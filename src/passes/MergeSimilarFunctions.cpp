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
// The basic idea is:
//
// 1. Group possible mergeable functions by hashing instruction kind
// 2. Create a group of mergeable functions (EquivalentClass) that can be merged
//    by parameterization. The classes are collected by comparing functions on
//    a pairwise basis.
// 3. Derive the parameters to be parameterized (ParamInfo) from each
//    EquivalentClass. A ParamInfo contains positions of parameter use and a
//    set of constant values (ConstDiff) for each functions in an
//    EquivalentClass. (A parameter can be used in multiple times in a function,
//    so ParamInfo contains an array of use position)
// 4. Create a shared function from a function picked from EquivalentClass and
//    an array of ParamInfo.
// 5. Create thunks for each functions in an EquivalentClass.
//
// e.g.
//
//  Before:
//    (func $big-const-42 (result i32)
//      [[many instr 1]]
//      (i32.const 42)
//      [[many instr 2]]
//    )
//    (func $big-const-43 (result i32)
//      [[many instr 1]]
//      (i32.const 43)
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
//
// In the above example, there is an EquivalentClass `[$big-const-42,
// $big-const-43]`, and a ParamInfo `{ values: [i32(42), i32(43)], uses:
// [location of (i32.const 42)] }` is derived. Then, clone `$big-const-42`
// replacing uses of params with local.get, and create thunks for $big-const-42
// and $big-const-43.

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

namespace wasm {

// A set of constant values of an instruction different between each functions
// in an EquivalentClass
using ConstDiff = std::variant<Literals, std::vector<Name>>;

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
    } else if (auto callees = std::get_if<std::vector<Name>>(&values)) {
      auto* callee = module->getFunction((*callees)[0]);
      return Type(callee->type, NonNullable);
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
};

// Describes the set of functions which are considered as "equivalent" (i.e.
// only differing by some constants).
struct EquivalentClass {
  // Primary function in the `functions`, which will be the base for the merged
  // function.
  Function* primaryFunction;
  // List of functions belonging to this equivalence class.
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
};

struct MergeSimilarFunctions : public Pass {
  bool invalidatesDWARF() override { return true; }

  void run(Module* module) override {
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

      std::vector<ParamInfo> params;
      if (!clazz.deriveParams(
            module, params, isCallIndirectionEnabled(module))) {
        continue;
      }

      if (!clazz.hasMergeBenefit(module, params)) {
        continue;
      }

      clazz.merge(module, params);
    }
  }

  // Parameterize direct calls if the module supports func ref values.
  bool isCallIndirectionEnabled(Module* module) const {
    return module->features.hasReferenceTypes() && module->features.hasGC();
  }
  bool areInEquvalentClass(Function* lhs, Function* rhs, Module* module);
  void collectEquivalentClasses(std::vector<EquivalentClass>& classes,
                                Module* module);
};

// Determine if two functions are equivalent ignoring constants.
bool MergeSimilarFunctions::areInEquvalentClass(Function* lhs,
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
      if (lhsCallee->type != rhsCallee->type) {
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
void MergeSimilarFunctions::collectEquivalentClasses(
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
  // Allows iteration over children of the root expression recursively.
  struct DeepValueIterator {
    // The DFS work list.
    SmallVector<Expression**, 10> tasks;

    DeepValueIterator(Expression** root) { tasks.push_back(root); }

    void operator++() {
      ChildIterator it(*tasks.back());
      tasks.pop_back();
      for (Expression*& child : it) {
        tasks.push_back(&child);
      }
    }

    Expression*& operator*() {
      assert(!empty());
      return *tasks.back();
    }
    bool empty() { return tasks.empty(); }
  };

  if (primaryFunction->imported()) {
    return false;
  }
  DeepValueIterator primaryIt(&primaryFunction->body);
  std::vector<DeepValueIterator> siblingIterators;
  // Skip the first function, as it is the primary function to compare the
  // primary function with the other functions based on the primary instr type.
  assert(functions.size() >= 2);
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
    // e.g.
    //
    // ```
    // (func $use-42-twice (result i32)
    //   (i32.add (i32.const 42) (i32.const 42))
    // )
    // (func $use-43-twice (result i32)
    //   (i32.add (i32.const 43) (i32.const 43))
    // )
    // ```
    //
    // will be merged reusing the parameter [42, 43]
    //
    // ```
    // (func $use-42-twice (result i32)
    //  (call $byn$mgfn-shared$use-42-twice (i32.const 42))
    // )
    // (func $use-43-twice (result i32)
    //  (call $byn$mgfn-shared$use-42-twice (i32.const 43))
    // )
    // (func $byn$mgfn-shared$use-42-twice (param $0 i32) (result i32)
    //  (i32.add (local.get $0) (local.get $0))
    // )
    // ```
    //
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
  return negativeScore < positiveScore;
}

Function* EquivalentClass::createShared(Module* module,
                                        const std::vector<ParamInfo>& params) {
  Name fnName = Names::getValidFunctionName(*module,
                                            std::string("byn$mgfn-shared$") +
                                              primaryFunction->name.toString());
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
          auto returnType = module->getFunction(call->target)->getResults();
          return builder.makeCallRef(
            paramExpr, operands, returnType, call->isReturn);
        }
      }
    }
    // Re-number local indices of variables (not params) to offset for the extra
    // params
    if (auto* localGet = expr->dynCast<LocalGet>()) {
      if (primaryFunction->isVar(localGet->index)) {
        localGet->index =
          newVarBase + (localGet->index - primaryFunction->getNumParams());
        localGet->finalize();
        return localGet;
      }
    }
    if (auto* localSet = expr->dynCast<LocalSet>()) {
      if (primaryFunction->isVar(localSet->index)) {
        auto operand =
          ExpressionManipulator::flexibleCopy(localSet->value, *module, copier);
        localSet->index =
          newVarBase + (localSet->index - primaryFunction->getNumParams());
        localSet->value = operand;
        localSet->finalize();
        return localSet;
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

  // TODO: make a return_call when possible?
  auto ret = builder.makeCall(shared->name, callOperands, target->getResults());
  target->vars.clear();
  target->body = ret;
  return target;
}

Pass* createMergeSimilarFunctionsPass() { return new MergeSimilarFunctions(); }

} // namespace wasm
