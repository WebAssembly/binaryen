/*

 * Copyright 2021 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//
// Merge similar functions that only differs constant values (like immediate
// operand of const and call insts) by parameterization.
// Performing this pass at post-link time can merge more functions across
// objects. Inspired by Swift compiler's optimization which is derived from
// LLVM's one:
// https://github.com/apple/swift/blob/main/lib/LLVMPasses/LLVMMergeFunctions.cpp
// https://github.com/llvm/llvm-project/blob/main/llvm/docs/MergeFunctions.rst
//
// e.g.
//
//  Before:
//    (func $big-const-42 (result i32)
//      [[many instr 1]]
//      (i32.const 44)
//      [[many instr 2]]
//    )
//    (func $big-const-43 (result i32)
//      [[many instr 1]]
//      (i32.const 45)
//      [[many instr 2]]
//    )
//  After:
//    (func $byn$mgfn-shared$big-const-42 (result i32)
//      [[many instr 1]]
//      (local.get $0)
//      [[many instr 2]]
//    )
//    (func $big-const-42 (result i32)
//      (call $byn$mgfn-shared$big-const-42
//       (i32.const 42)
//      )
//    )
//    (func $big-const-43 (result i32)
//      (call $byn$mgfn-shared$big-const-42
//       (i32.const 43)
//      )
//    )

#include "ir/hashed.h"
#include "ir/manipulation.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/utils.h"
#include "opt-utils.h"
#include "pass.h"
#include "support/hash.h"
#include "support/utilities.h"
#include "wasm.h"
#include <algorithm>
#include <cassert>
#include <cstddef>
#include <iostream>
#include <map>
#include <memory>
#include <ostream>
#include <variant>
#include <vector>

#if 0
#define MERGEFUNC_DEBUG(X)                                                     \
  do {                                                                         \
    X;                                                                         \
  } while (0)
#else
#define MERGEFUNC_DEBUG(X)                                                     \
  do {                                                                         \
  } while (0)
#endif

namespace wasm {

struct ConstValueDiff : public std::monostate {};
struct ConstCalleeDiff : public std::monostate {};

using ConstDiff =
  std::variant<ConstValueDiff, Literals, ConstCalleeDiff, std::vector<Name>>;

// Describes a parameter which we create to parameterize the merged function.
struct ParamInfo {
  // Actual values of the parameter ordered by the EquivalentClass's
  // `functions`.
  ConstDiff values;
  // All uses of the parameter in the primary function.
  std::vector<Expression**> uses;

  ParamInfo(ConstDiff values, std::vector<Expression**> uses)
    : values(std::move(values)), uses(uses) {}

  // Returns the type of the parameter value.
  Type getValueType(Module* module) const {
    if (const auto literals = std::get_if<Literals>(&values)) {
      return (*literals)[0].type;
      return Type::i32;
    } else if (auto callees = std::get_if<std::vector<Name>>(&values)) {
      auto* callee = module->getFunction((*callees)[0]);
      return Type(callee->getSig(), NonNullable);
    } else {
      WASM_UNREACHABLE("unexpected const value type");
    }
  }

  // Lower the constant value at a given index to an expression
  Expression*
  lowerToExpression(Builder& builder, Module* module, size_t index) const {
    if (const auto literals = std::get_if<Literals>(&values)) {
      return builder.makeConst((*literals)[index]);
    } else if (auto callees = std::get_if<std::vector<Name>>(&values)) {
      auto fnName = (*callees)[index];
      auto heapType = module->getFunction(fnName)->type;
      return builder.makeRefFunc(fnName, heapType);
    } else {
      WASM_UNREACHABLE("unexpected const value type");
    }
  }

  friend std::ostream& operator<<(std::ostream& o, const ParamInfo& info) {
    o << "ParamInfo(";
    if (auto literals = std::get_if<Literals>(&info.values)) {
      o << "literals = " << *literals;
    } else if (auto callees = std::get_if<std::vector<Name>>(&info.values)) {
      o << "callees = ";
      for (auto& callee : *callees) {
        o << callee << " ";
      }
    }
    o << ")";
    return o;
  }
};

// Describes the set of functions which are considered as "equivalent" (i.e.
// only differing by some constants).
struct EquivalentClass {
  // Primary function in the `functions`, which will be the base for the merged
  // function.
  Function* primaryFunction;
  // List of functions belonging to a same class.
  std::vector<Function*> functions;

  EquivalentClass(Function* primaryFunction, std::vector<Function*> functions)
    : primaryFunction(primaryFunction), functions(functions) {}

  bool isEligibleToMerge() { return this->functions.size() >= 2; }

  // Merge the functions in this class.
  void merge(Module* module, const std::vector<ParamInfo>& params);

  bool hasMergeBenefit(Module* module, const std::vector<ParamInfo>& params);

  Function* createShared(Module* module, const std::vector<ParamInfo>& params);

  Function* replaceWithThunk(Builder& builder,
                             Function* target,
                             Function* shared,
                             const std::vector<ParamInfo>& params,
                             const std::vector<Expression*>& extraArgs);

  bool deriveParams(Module* module,
                    std::vector<ParamInfo>& params,
                    bool isIndirectionEnabled);

  friend std::ostream& operator<<(std::ostream& o, EquivalentClass& self) {
    o << "EquivalentClass [";
    o << "primary=" << self.primaryFunction->name << ", ";
    o << "functions=" << self.functions.size() << ", ";
    for (auto* func : self.functions) {
      o << " - " << func->name << "\n";
    }
    return o;
  }
  void dump() { std::cout << *this << std::endl; }
};

struct Stats {
  size_t allFunctions = 0;
  size_t mergedFunctions = 0;
  size_t skip = 0;
  size_t duplicates = 0;
  size_t equivalentClasses = 0;
  void dump() {
    std::cout << "allFunctions: " << allFunctions << "\n";
    std::cout << "mergedCounter: " << mergedFunctions << "\n";
    std::cout << "skip: " << skip << "\n";
    std::cout << "duplicates: " << duplicates << "\n";
    std::cout << "equivalentClasses: " << equivalentClasses << "\n";
  }
};

struct MergeFunctions : public Pass {
  bool invalidatesDWARF() override { return true; }

  void run(PassRunner* runner, Module* module) override {
    {
      // Canonicalize locals indices to make comparison easier.
      PassRunner runner(module);
      runner.setIsNested(true);
      runner.add("reorder-locals");
      runner.run();
    }

    Stats stats;
    std::vector<EquivalentClass> classes;
    collectEquivalentClasses(classes, module);
    std::sort(
      classes.begin(), classes.end(), [](const auto& left, const auto& right) {
        return left.primaryFunction->name < right.primaryFunction->name;
      });
    for (auto& clazz : classes) {
      if (!clazz.isEligibleToMerge()) {
        continue;
      }

      stats.equivalentClasses += 1;
      MERGEFUNC_DEBUG(std::cout << "[merge-funcs] trying to merge: " << clazz
                                << std::endl);

      std::vector<ParamInfo> params;
      if (!clazz.deriveParams(
            module, params, isCallIndirectionEnabled(module))) {
        MERGEFUNC_DEBUG(std::cerr
                        << "[merge-funcs] Failed to derive params for "
                        << clazz.primaryFunction->name << std::endl);
        continue;
      }

      MERGEFUNC_DEBUG(for (Index i = 0; i < params.size(); i++) {
        std::cerr << "[merge-funcs] param[" << i << "] " << params[i]
                  << std::endl;
      });

      if (!clazz.hasMergeBenefit(module, params)) {
        stats.skip += clazz.functions.size();
        continue;
      }

      clazz.merge(module, params);
      MERGEFUNC_DEBUG(std::cout << "[merge-funcs] succeed to merge"
                                << std::endl);
      stats.mergedFunctions += clazz.functions.size();
    }
    stats.allFunctions = module->functions.size();
    MERGEFUNC_DEBUG(stats.dump());
  }

  // Parameterize direct calls if the module support func ref values.
  bool isCallIndirectionEnabled(Module* module) const {
    return module->features.hasTypedFunctionReferences() &&
           module->features.hasReferenceTypes();
  }
  bool areInEquvalentClass(Function* lhs, Function* rhs, Module* module);
  void collectEquivalentClasses(std::vector<EquivalentClass>& classes,
                                Module* module);
};

// Determine if two functions are equivalent ignoring constants.
bool MergeFunctions::areInEquvalentClass(Function* lhs,
                                         Function* rhs,
                                         Module* module) {
  if (lhs->imported() || rhs->imported()) {
    return false;
  }
  if (lhs->type != rhs->type) {
    return false;
  }
  if (lhs->getNumVars() != rhs->getNumVars()) {
    return false;
  }

  ExpressionAnalyzer::ExprComparer comparer = [&](Expression* lhsExpr,
                                                  Expression* rhsExpr) {
    if (lhsExpr->_id != rhsExpr->_id) {
      return false;
    }
    if (lhsExpr->type != rhsExpr->type) {
      return false;
    }
    if (lhsExpr->is<Call>()) {
      if (!this->isCallIndirectionEnabled(module)) {
        return false;
      }
      auto lhsCast = lhsExpr->dynCast<Call>();
      auto rhsCast = rhsExpr->dynCast<Call>();
      if (lhsCast->operands.size() != rhsCast->operands.size()) {
        return false;
      }
      if (lhsCast->type != rhsCast->type) {
        return false;
      }
      auto* lhsCallee = module->getFunction(lhsCast->target);
      auto* rhsCallee = module->getFunction(rhsCast->target);
      if (lhsCallee->getSig() != rhsCallee->getSig()) {
        return false;
      }

      // Arguments operands should be also equivalent ignoring constants.
      for (Index i = 0; i < lhsCast->operands.size(); i++) {
        if (!ExpressionAnalyzer::flexibleEqual(
              lhsCast->operands[i], rhsCast->operands[i], comparer)) {
          return false;
        }
      }
      return true;
    }

    if (lhsExpr->is<Const>()) {
      auto lhsCast = lhsExpr->dynCast<Const>();
      auto rhsCast = rhsExpr->dynCast<Const>();
      // Types should be the same at least.
      if (lhsCast->value.type != rhsCast->value.type) {
        return false;
      }
      return true;
    }

    return false;
  };
  if (!ExpressionAnalyzer::flexibleEqual(lhs->body, rhs->body, comparer)) {
    return false;
  }

  return true;
}

// Collect all equivalent classes to be merged.
void MergeFunctions::collectEquivalentClasses(
  std::vector<EquivalentClass>& classes, Module* module) {
  auto hashes = FunctionHasher::createMap(module);
  PassRunner runner(module);

  std::function<bool(Expression*, size_t&)> ignoringConsts =
    [&](Expression* expr, size_t& digest) {
      // Ignore const's immediate operands.
      if (expr->is<Const>()) {
        return true;
      }
      // Ignore callee operands.
      if (auto* call = expr->dynCast<Call>()) {
        for (auto operand : call->operands) {
          rehash(digest,
                 ExpressionAnalyzer::flexibleHash(operand, ignoringConsts));
        }
        rehash(digest, call->isReturn);
        return true;
      }
      return false;
    };
  FunctionHasher(&hashes, ignoringConsts).run(&runner, module);

  // Find hash-equal groups.
  std::map<size_t, std::vector<Function*>> hashGroups;
  ModuleUtils::iterDefinedFunctions(
    *module, [&](Function* func) { hashGroups[hashes[func]].push_back(func); });

  for (auto& [_, hashGroup] : hashGroups) {
    if (hashGroup.size() < 2) {
      continue;
    }

    // Collect exactly equivalent functions ignoring constants.
    std::vector<EquivalentClass> classesInGroup = {
      EquivalentClass(hashGroup[0], {hashGroup[0]})};

    for (Index i = 1; i < hashGroup.size(); i++) {
      auto* func = hashGroup[i];
      bool found = false;
      for (auto& newClass : classesInGroup) {
        if (areInEquvalentClass(newClass.primaryFunction, func, module)) {
          newClass.functions.push_back(func);
          found = true;
          break;
        }
      }

      if (!found) {
        // Same hash but different instruction pattern.
        // Functions having the same pattern may be in the same hash group.
        classesInGroup.push_back(EquivalentClass(func, {func}));
      }
    }
    std::copy(classesInGroup.begin(),
              classesInGroup.end(),
              std::back_inserter(classes));
  }
}

// Find the set of parameters which are required to merge the functions in the
// class Returns false if unable to derive parameters.
bool EquivalentClass::deriveParams(Module* module,
                                   std::vector<ParamInfo>& params,
                                   bool isCallIndirectionEnabled) {
  struct DeepValueIterator {
    SmallVector<Expression**, 10> tasks;

    DeepValueIterator(Expression** root) : tasks() { tasks.push_back(root); }

    void operator++() {
      ChildIterator it(*tasks.back());
      tasks.pop_back();
      for (Expression*& child : it) {
        tasks.push_back(&child);
      }
    }

    Expression*& operator*() { return *tasks.back(); }
    bool empty() { return tasks.empty(); }
  };

  if (primaryFunction->imported()) {
    return false;
  }
  DeepValueIterator primaryIt(&primaryFunction->body);
  std::vector<DeepValueIterator> siblingIterators;
  // Skip the first function, as it is the primary function.
  for (auto func = functions.begin() + 1; func != functions.end(); ++func) {
    siblingIterators.emplace_back(&(*func)->body);
  }

  for (; !primaryIt.empty(); ++primaryIt) {
    Expression*& primary = *primaryIt;
    ConstDiff diff;
    Literals values;
    std::vector<Name> names;

    bool isAllSame = true;
    if (auto* primaryConst = primary->dynCast<Const>()) {
      values.push_back(primaryConst->value);
      for (auto& it : siblingIterators) {
        Expression*& sibling = *it;
        ++it;
        if (auto* siblingConst = sibling->dynCast<Const>()) {
          isAllSame &= primaryConst->value == siblingConst->value;
          values.push_back(siblingConst->value);
        } else {
          WASM_UNREACHABLE(
            "all sibling functions should have the same instruction type");
        }
      }
      diff = values;
    } else if (isCallIndirectionEnabled && primary->is<Call>()) {
      auto* primaryCall = primary->dynCast<Call>();
      names.push_back(primaryCall->target);
      for (auto& it : siblingIterators) {
        Expression*& sibling = *it;
        ++it;
        if (auto* siblingCall = sibling->dynCast<Call>()) {
          isAllSame &= primaryCall->target == siblingCall->target;
          names.push_back(siblingCall->target);
        } else {
          WASM_UNREACHABLE(
            "all sibling functions should have the same instruction type");
        }
      }
      diff = names;
    } else {
      // Skip non-constant expressions, which are ensured to be the exactly
      // same.
      for (auto& it : siblingIterators) {
        // Sibling functions in a class should have the same instruction type.
        assert((*it)->_id == primary->_id);
        ++it;
      }
      continue;
    }
    // If all values are the same, skip to parameterize it.
    if (isAllSame) {
      continue;
    }
    // If the derived param is already in the params, reuse it.
    bool paramReused = false;
    for (auto& param : params) {
      if (param.values == diff) {
        param.uses.push_back(&primary);
        paramReused = true;
        break;
      }
    }
    if (!paramReused) {
      params.push_back(ParamInfo(diff, {&primary}));
    }
  }
  return true;
}

void EquivalentClass::merge(Module* module,
                            const std::vector<ParamInfo>& params) {
  Function* sharedFn = createShared(module, params);
  for (size_t i = 0; i < functions.size(); ++i) {
    Builder builder(*module);
    auto* func = functions[i];
    std::vector<Expression*> extraArgs;
    for (auto& param : params) {
      extraArgs.push_back(param.lowerToExpression(builder, module, i));
    }
    replaceWithThunk(builder, func, sharedFn, params, extraArgs);
  }
  return;
}

// Determine if it's beneficial to merge the functions in the class
// Merging functions by creating a shared function and thunks is not always
// beneficial. If the functions are very small, added glue code may be larger
// than the reduced size.
bool EquivalentClass::hasMergeBenefit(Module* module,
                                      const std::vector<ParamInfo>& params) {
  size_t funcCount = functions.size();
  Index exprSize = Measurer::measure(primaryFunction->body);
  size_t thunkCount = funcCount;
  // -1 for cloned primary func
  size_t removedInstrs = (funcCount - 1) * exprSize;
  // Each thunks will add local.get and call instructions to forward the params
  // and pass extra parameterized values.
  size_t addedInstrsPerThunk =
    thunkCount * (
                   // call
                   1 +
                   // local.get
                   primaryFunction->getParams().size() + params.size());

  constexpr size_t INSTR_WEIGHT = 1;
  constexpr size_t CODE_SEC_LOCALS_WEIGHT = 1;
  constexpr size_t CODE_SEC_ENTRY_WEIGHT = 2;
  constexpr size_t FUNC_SEC_ENTRY_WEIGHT = 2;

  // Glue instrs for thunks and a merged function entry will be added by the
  // merge.
  size_t negativeScore =
    addedInstrsPerThunk * INSTR_WEIGHT +
    thunkCount * (
                   // Locals entries in merged function in code section.
                   (params.size() * CODE_SEC_LOCALS_WEIGHT) +
                   // Code size field in merged function entry.
                   CODE_SEC_ENTRY_WEIGHT) +
    // Thunk function entries in function section.
    (thunkCount * FUNC_SEC_ENTRY_WEIGHT);
  size_t positiveScore = INSTR_WEIGHT * removedInstrs;
  if (negativeScore >= positiveScore) {
    MERGEFUNC_DEBUG(std::cerr
                    << "[merge-funcs] negative score: " << negativeScore
                    << " is greater than positive score: " << positiveScore
                    << " exprSize: " << exprSize << std::endl);
    MERGEFUNC_DEBUG(std::cerr << *primaryFunction->body << std::endl);
  }
  return negativeScore < positiveScore;
}

Function* EquivalentClass::createShared(Module* module,
                                        const std::vector<ParamInfo>& params) {
  Name fnName = Names::getValidFunctionName(
    *module, std::string("byn$mgfn-shared$") + primaryFunction->name.str);
  Builder builder(*module);
  std::vector<Type> sigParams;
  Index extraParamBase = primaryFunction->getNumParams();
  Index newVarBase = primaryFunction->getNumParams() + params.size();

  for (const auto& param : primaryFunction->getParams()) {
    sigParams.push_back(param);
  }
  for (const auto& param : params) {
    sigParams.push_back(param.getValueType(module));
  }

  Signature sig(Type(sigParams), primaryFunction->getResults());
  // Cloning the primary function while replacing the parameterized values
  ExpressionManipulator::CustomCopier copier =
    [&](Expression* expr) -> Expression* {
    if (!expr) {
      return nullptr;
    }
    // Replace the use of the parameter with extra locals
    for (Index paramIdx = 0; paramIdx < params.size(); paramIdx++) {
      for (auto& use : params[paramIdx].uses) {
        if (*use != expr) {
          continue;
        }
        auto* paramExpr = builder.makeLocalGet(
          extraParamBase + paramIdx, params[paramIdx].getValueType(module));
        if (expr->is<Const>()) {
          return paramExpr;
        } else if (auto* call = expr->cast<Call>()) {
          ExpressionList operands(module->allocator);
          // Clone the children of the call
          for (auto* operand : call->operands) {
            operands.push_back(
              ExpressionManipulator::flexibleCopy(operand, *module, copier));
          }
          return builder.makeCallRef(paramExpr, operands, call->type);
        }
      }
    }
    // Re-number local indices of variables (not params) to offset for the extra
    // params
    if (auto localGet = expr->dynCast<LocalGet>()) {
      if (primaryFunction->isVar(localGet->index)) {
        return builder.makeLocalGet(
          newVarBase + (localGet->index - primaryFunction->getNumParams()),
          localGet->type);
      }
    }
    if (auto localSet = expr->dynCast<LocalSet>()) {
      if (primaryFunction->isVar(localSet->index)) {
        auto operand =
          ExpressionManipulator::flexibleCopy(localSet->value, *module, copier);
        if (localSet->isTee()) {
          return builder.makeLocalTee(
            newVarBase + (localSet->index - primaryFunction->getNumParams()),
            operand,
            localSet->type);
        } else {
          return builder.makeLocalSet(
            newVarBase + (localSet->index - primaryFunction->getNumParams()),
            operand);
        }
      }
    }
    return nullptr;
  };
  Expression* body =
    ExpressionManipulator::flexibleCopy(primaryFunction->body, *module, copier);
  auto vars = primaryFunction->vars;
  std::unique_ptr<Function> f =
    builder.makeFunction(fnName, sig, std::move(vars), body);
  return module->addFunction(std::move(f));
}

Function*
EquivalentClass::replaceWithThunk(Builder& builder,
                                  Function* target,
                                  Function* shared,
                                  const std::vector<ParamInfo>& params,
                                  const std::vector<Expression*>& extraArgs) {
  std::vector<Expression*> callOperands;
  Type targetParams = target->getParams();
  for (Index i = 0; i < targetParams.size(); i++) {
    callOperands.push_back(builder.makeLocalGet(i, targetParams[i]));
  }

  for (const auto& value : extraArgs) {
    callOperands.push_back(value);
  }

  auto ret = builder.makeCall(shared->name, callOperands, target->getResults());
  target->vars.clear();
  target->body = ret;
  return target;
}

Pass* createMergeFunctionsPass() { return new MergeFunctions(); }

} // namespace wasm
