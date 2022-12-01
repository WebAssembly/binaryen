/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Optimizes call arguments in a whole-program manner. In particular, this
// removes ones that are not used (dead), but it also does more things:
//
//  * Find functions for whom an argument is always passed the same
//    constant. If so, we can just set that local to that constant
//    in the function.
//  * Find functions that don't use the value passed to an argument.
//    If so, we can avoid even sending and receiving it. (Note how if
//    the previous point was true for an argument, then the second
//    must as well.)
//  * Find return values ("return arguments" ;) that are never used.
//  * Refine the types of arguments, that is make the argument type more
//    specific if all the passed values allow that.
//
// This pass does not depend on flattening, but it may be more effective,
// as then call arguments never have side effects (which we need to
// watch for here).
//

#include <unordered_map>
#include <unordered_set>

#include "ir/effects.h"
#include "ir/element-utils.h"
#include "ir/find_all.h"
#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "param-utils.h"
#include "pass.h"
#include "passes/opt-utils.h"
#include "support/sorted_vector.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

// Information for a function
struct DAEFunctionInfo {
  // The unused parameters, if any.
  SortedVector unusedParams;
  // Maps a function name to the calls going to it.
  std::unordered_map<Name, std::vector<Call*>> calls;
  // Map of all calls that are dropped, to their drops' locations (so that
  // if we can optimize out the drop, we can replace the drop there).
  std::unordered_map<Call*, Expression**> droppedCalls;
  // Whether this function contains any tail calls (including indirect tail
  // calls) and the set of functions this function tail calls. Tail-callers and
  // tail-callees cannot have their dropped returns removed because of the
  // constraint that tail-callees must have the same return type as
  // tail-callers. Indirectly tail called functions are already not optimized
  // because being in a table inhibits DAE. TODO: Allow the removal of dropped
  // returns from tail-callers if their tail-callees can have their returns
  // removed as well.
  bool hasTailCalls = false;
  std::unordered_set<Name> tailCallees;
  // Whether the function can be called from places that
  // affect what we can do. For now, any call we don't
  // see inhibits our optimizations, but TODO: an export
  // could be worked around by exporting a thunk that
  // adds the parameter.
  // This is atomic so that we can write to it from any function at any time
  // during the parallel analysis phase which is run in DAEScanner.
  std::atomic<bool> hasUnseenCalls;

  DAEFunctionInfo() { hasUnseenCalls = false; }
};

using DAEFunctionInfoMap = std::unordered_map<Name, DAEFunctionInfo>;

struct DAEScanner
  : public WalkerPass<PostWalker<DAEScanner, Visitor<DAEScanner>>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<DAEScanner>(infoMap);
  }

  DAEScanner(DAEFunctionInfoMap* infoMap) : infoMap(infoMap) {}

  DAEFunctionInfoMap* infoMap;
  DAEFunctionInfo* info;

  Index numParams;

  void visitCall(Call* curr) {
    if (!getModule()->getFunction(curr->target)->imported()) {
      info->calls[curr->target].push_back(curr);
    }
    if (curr->isReturn) {
      info->hasTailCalls = true;
      info->tailCallees.insert(curr->target);
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (curr->isReturn) {
      info->hasTailCalls = true;
    }
  }

  void visitCallRef(CallRef* curr) {
    if (curr->isReturn) {
      info->hasTailCalls = true;
    }
  }

  void visitDrop(Drop* curr) {
    if (auto* call = curr->value->dynCast<Call>()) {
      info->droppedCalls[call] = getCurrentPointer();
    }
  }

  void visitRefFunc(RefFunc* curr) {
    // We can't modify another function in parallel.
    assert((*infoMap).count(curr->func));
    // Treat a ref.func as an unseen call, preventing us from changing the
    // function's type. If we did change it, it could be an observable
    // difference from the outside, if the reference escapes, for example.
    // TODO: look for actual escaping?
    // TODO: create a thunk for external uses that allow internal optimizations
    (*infoMap)[curr->func].hasUnseenCalls = true;
  }

  // main entry point

  void doWalkFunction(Function* func) {
    numParams = func->getNumParams();
    info = &((*infoMap)[func->name]);
    PostWalker<DAEScanner, Visitor<DAEScanner>>::doWalkFunction(func);
    // If there are relevant params, check if they are used. If we can't
    // optimize the function anyhow, there's no point (note that our check here
    // is technically racy - another thread could update hasUnseenCalls to true
    // around when we check it - but that just means that we might or might not
    // do some extra work, as we'll ignore the results later if we have unseen
    // calls. That is, the check for hasUnseenCalls here is just a minor
    // optimization to avoid pointless work. We can avoid that work if either
    // we know there is an unseen call before the parallel analysis that we are
    // part of, say if we are exported, or if another parallel function finds a
    // RefFunc to us and updates it before we check it).
    if (numParams > 0 && !info->hasUnseenCalls) {
      auto usedParams = ParamUtils::getUsedParams(func);
      for (Index i = 0; i < numParams; i++) {
        if (usedParams.count(i) == 0) {
          info->unusedParams.insert(i);
        }
      }
    }
  }
};

struct DAE : public Pass {
  // This pass changes locals and parameters.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  bool optimize = false;

  void run(Module* module) override {
    // Iterate to convergence.
    while (1) {
      if (!iteration(module)) {
        break;
      }
    }
  }

  bool iteration(Module* module) {
    allDroppedCalls.clear();

    DAEFunctionInfoMap infoMap;
    // Ensure they all exist so the parallel threads don't modify the data
    // structure.
    for (auto& func : module->functions) {
      infoMap[func->name];
    }
    DAEScanner scanner(&infoMap);
    scanner.walkModuleCode(module);
    for (auto& curr : module->exports) {
      if (curr->kind == ExternalKind::Function) {
        infoMap[curr->value].hasUnseenCalls = true;
      }
    }
    // Scan all the functions.
    scanner.run(getPassRunner(), module);
    // Combine all the info.
    std::map<Name, std::vector<Call*>> allCalls;
    std::unordered_set<Name> tailCallees;
    for (auto& [_, info] : infoMap) {
      for (auto& [name, calls] : info.calls) {
        auto& allCallsToName = allCalls[name];
        allCallsToName.insert(allCallsToName.end(), calls.begin(), calls.end());
      }
      for (auto& callee : info.tailCallees) {
        tailCallees.insert(callee);
      }
      for (auto& [name, calls] : info.droppedCalls) {
        allDroppedCalls[name] = calls;
      }
    }
    // If we refine return types then we will need to do more type updating
    // at the end.
    bool refinedReturnTypes = false;
    // We now have a mapping of all call sites for each function, and can look
    // for optimization opportunities.
    for (auto& [name, calls] : allCalls) {
      // We can only optimize if we see all the calls and can modify them.
      if (infoMap[name].hasUnseenCalls) {
        continue;
      }
      auto* func = module->getFunction(name);
      // Refine argument types before doing anything else. This does not
      // affect whether an argument is used or not, it just refines the type
      // where possible.
      refineArgumentTypes(func, calls, module, infoMap[name]);
      // Refine return types as well.
      if (refineReturnTypes(func, calls, module)) {
        refinedReturnTypes = true;
      }
      auto optimizedIndexes =
        ParamUtils::applyConstantValues({func}, calls, {}, module);
      for (auto i : optimizedIndexes) {
        // Mark it as unused, which we know it now is (no point to re-scan just
        // for that).
        infoMap[name].unusedParams.insert(i);
      }
    }
    if (refinedReturnTypes) {
      // Changing a call expression's return type can propagate out to its
      // parents, and so we must refinalize.
      // TODO: We could track in which functions we actually make changes.
      ReFinalize().run(getPassRunner(), module);
    }
    // Track which functions we changed, and optimize them later if necessary.
    std::unordered_set<Function*> changed;
    // We now know which parameters are unused, and can potentially remove them.
    for (auto& [name, calls] : allCalls) {
      if (infoMap[name].hasUnseenCalls) {
        continue;
      }
      auto* func = module->getFunction(name);
      auto numParams = func->getNumParams();
      if (numParams == 0) {
        continue;
      }
      auto removedIndexes = ParamUtils::removeParameters(
        {func}, infoMap[name].unusedParams, calls, {}, module, getPassRunner());
      if (!removedIndexes.empty()) {
        // Success!
        changed.insert(func);
      }
    }
    // We can also tell which calls have all their return values dropped. Note
    // that we can't do this if we changed anything so far, as we may have
    // modified allCalls (we can't modify a call site twice in one iteration,
    // once to remove a param, once to drop the return value).
    if (changed.empty()) {
      for (auto& func : module->functions) {
        if (func->getResults() == Type::none) {
          continue;
        }
        auto name = func->name;
        if (infoMap[name].hasUnseenCalls) {
          continue;
        }
        if (infoMap[name].hasTailCalls) {
          continue;
        }
        if (tailCallees.count(name)) {
          continue;
        }
        auto iter = allCalls.find(name);
        if (iter == allCalls.end()) {
          continue;
        }
        auto& calls = iter->second;
        bool allDropped =
          std::all_of(calls.begin(), calls.end(), [&](Call* call) {
            return allDroppedCalls.count(call);
          });
        if (!allDropped) {
          continue;
        }
        removeReturnValue(func.get(), calls, module);
        // TODO Removing a drop may also open optimization opportunities in the
        // callers.
        changed.insert(func.get());
      }
    }
    if (optimize && !changed.empty()) {
      OptUtils::optimizeAfterInlining(changed, module, getPassRunner());
    }
    return !changed.empty() || refinedReturnTypes;
  }

private:
  std::unordered_map<Call*, Expression**> allDroppedCalls;

  void
  removeReturnValue(Function* func, std::vector<Call*>& calls, Module* module) {
    func->setResults(Type::none);
    Builder builder(*module);
    // Remove any return values.
    struct ReturnUpdater : public PostWalker<ReturnUpdater> {
      Module* module;
      ReturnUpdater(Function* func, Module* module) : module(module) {
        walk(func->body);
      }
      void visitReturn(Return* curr) {
        auto* value = curr->value;
        assert(value);
        curr->value = nullptr;
        Builder builder(*module);
        replaceCurrent(builder.makeSequence(builder.makeDrop(value), curr));
      }
    } returnUpdater(func, module);
    // Remove any value flowing out.
    if (func->body->type.isConcrete()) {
      func->body = builder.makeDrop(func->body);
    }
    // Remove the drops on the calls.
    for (auto* call : calls) {
      auto iter = allDroppedCalls.find(call);
      assert(iter != allDroppedCalls.end());
      Expression** location = iter->second;
      *location = call;
      // Update the call's type.
      if (call->type != Type::unreachable) {
        call->type = Type::none;
      }
    }
  }

  // Given a function and all the calls to it, see if we can refine the type of
  // its arguments. If we only pass in a subtype, we may as well refine the type
  // to that.
  //
  // This assumes that the function has no calls aside from |calls|, that is, it
  // is not exported or called from the table or by reference.
  void refineArgumentTypes(Function* func,
                           const std::vector<Call*>& calls,
                           Module* module,
                           const DAEFunctionInfo& info) {
    if (!module->features.hasGC()) {
      return;
    }
    auto numParams = func->getNumParams();
    std::vector<Type> newParamTypes;
    newParamTypes.reserve(numParams);
    std::vector<LUBFinder> lubs(numParams);
    for (Index i = 0; i < numParams; i++) {
      auto originalType = func->getLocalType(i);
      // If the parameter type is not a reference, there is nothing to refine.
      // And if it is unused, also do nothing, as we can leave it to the other
      // parts of this pass to optimize it properly, which avoids having to
      // think about corner cases involving refining the type of an unused
      // param (in particular, unused params are turned into locals, which means
      // we'd need to think about defaultability etc.).
      if (!originalType.isRef() || info.unusedParams.has(i)) {
        newParamTypes.push_back(originalType);
        continue;
      }
      auto& lub = lubs[i];
      for (auto* call : calls) {
        auto* operand = call->operands[i];
        lub.note(operand->type);
        if (lub.getLUB() == originalType) {
          // We failed to refine this parameter to anything more specific.
          break;
        }
      }

      // Nothing is sent here at all; leave such optimizations to DCE.
      if (!lub.noted()) {
        return;
      }
      newParamTypes.push_back(lub.getLUB());
    }

    // Check if we are able to optimize here before we do the work to scan the
    // function body.
    auto newParams = Type(newParamTypes);
    if (newParams == func->getParams()) {
      return;
    }

    // We can do this!
    TypeUpdating::updateParamTypes(func, newParamTypes, *module);

    // Update the function's type.
    func->setParams(newParams);
  }

  // See if the types returned from a function allow us to define a more refined
  // return type for it. If so, we can update it and all calls going to it.
  //
  // This assumes that the function has no calls aside from |calls|, that is, it
  // is not exported or called from the table or by reference. Exports should be
  // fine, as should indirect calls in principle, but VMs will need to support
  // function subtyping in indirect calls. TODO: relax this when possible
  //
  // Returns whether we optimized.
  //
  // TODO: We may be missing a global optimum here, as e.g. if a function calls
  //       itself and returns that value, then we would not do any change here,
  //       as one of the return values is exactly what it already is. Similar
  //       unoptimality can happen with multiple functions, more local code in
  //       the middle, etc.
  bool refineReturnTypes(Function* func,
                         const std::vector<Call*>& calls,
                         Module* module) {
    auto lub = LUB::getResultsLUB(func, *module);
    if (!lub.noted()) {
      return false;
    }
    auto newType = lub.getLUB();
    if (newType != func->getResults()) {
      func->setResults(newType);
      for (auto* call : calls) {
        if (call->type != Type::unreachable) {
          call->type = newType;
        }
      }
      return true;
    }
    return false;
  }
};

Pass* createDAEPass() { return new DAE(); }

Pass* createDAEOptimizingPass() {
  auto* ret = new DAE();
  ret->optimize = true;
  return ret;
}

} // namespace wasm
