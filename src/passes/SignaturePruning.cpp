/*
 * Copyright 2022 WebAssembly Community Group participants
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
// Remove params from signature/function types where possible.
//
// This differs from DeadArgumentElimination in that DAE will look at each
// function by itself, and cannot handle indirectly-called functions. This pass
// looks at each heap type at a time, and if all functions with a heap type do
// not use a particular param, will remove the param.
//

#include "ir/find_all.h"
#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "param-utils.h"
#include "pass.h"
#include "support/sorted_vector.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

struct SignaturePruning : public Pass {
  // Maps each heap type to the possible pruned heap type. We will fill this
  // during analysis and then use it while doing an update of the types. If a
  // type has no improvement that we can find, it will not appear in this map.
  std::unordered_map<HeapType, Signature> newSignatures;

  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "SignaturePruning requires nominal typing";
    }

    if (!module->tables.empty()) {
      // When there are tables we must also take their types into account, which
      // would require us to take call_indirect, element segments, etc. into
      // account. For now, do nothing if there are tables.
      // TODO
      return;
    }

    // First, find all the information we need. Start by collecting inside each
    // function in parallel.

    struct Info {
      std::vector<Call*> calls;
      std::vector<CallRef*> callRefs;

      std::unordered_set<Index> usedParams;
    };

    ModuleUtils::ParallelFunctionAnalysis<Info> analysis(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          // Imports cannot be modified, so this blocks us, as if all the params
          // were used.
          for (Index i = 0; i < func->getNumParams(); i++) {
            info.usedParams.insert(i);
          }
          return;
        }

        info.calls = std::move(FindAll<Call>(func->body).list);
        info.callRefs = std::move(FindAll<CallRef>(func->body).list);
        info.usedParams = ParamUtils::getUsedParams(func);
      });

    // A map of types to all the information combined over all the functions
    // with that type.
    std::unordered_map<HeapType, Info> allInfo;

    // Map heap types to all functions with that type.
    std::unordered_map<HeapType, std::vector<Function*>> sigFuncs;

    // Combine all the information we gathered into that map.
    for (auto& [func, info] : analysis.map) {
      // For direct calls, add each call to the type of the function being
      // called.
      for (auto* call : info.calls) {
        allInfo[module->getFunction(call->target)->type].calls.push_back(call);
      }

      // For indirect calls, add each call_ref to the type the call_ref uses.
      for (auto* callRef : info.callRefs) {
        auto calledType = callRef->target->type;
        if (calledType != Type::unreachable) {
          allInfo[calledType.getHeapType()].callRefs.push_back(callRef);
        }
      }

      // A parameter used in this function is used in the heap type - just one
      // function is enough to prevent the parameter from being removed.
      auto& allUsedParams = allInfo[func->type].usedParams;
      for (auto index : info.usedParams) {
        allUsedParams.insert(index);
      }
      sigFuncs[func->type].push_back(func);
    }

    // Find parameters to prune.
    for (auto& [type, funcs] : sigFuncs) {
      auto sig = type.getSignature();
      auto& info = allInfo[type];
      auto numParams = sig.params.size();
      if (info.usedParams.size() == numParams) {
        // All parameters are used, give up on this one.
        continue;
      }

      // We found possible work! Find the specific params that are unused try to
      // prune them.
      SortedVector unusedParams;
      for (Index i = 0; i < numParams; i++) {
        if (info.usedParams.count(i) == 0) {
          unusedParams.insert(i);
        }
      }

      auto oldParams = sig.params;
      auto removedIndexes = ParamUtils::removeParameters(
        funcs, unusedParams, info.calls, info.callRefs, module, runner);
      if (removedIndexes.empty()) {
        continue;
      }

      // Success! Update the types.
      std::vector<Type> newParams;
      for (Index i = 0; i < numParams; i++) {
        if (!removedIndexes.has(i)) {
          newParams.push_back(oldParams[i]);
        }
      }
      auto newType = Signature(Type(newParams), sig.results);
      newSignatures[type] = newType;

      // removeParameters() updates the type as it goes, but in this pass we
      // need the type to match the other locations, nominally. That is, we need
      // all the functions of a particular type to still have the same type
      // after this operation, and that must be the exact same type at the
      // relevant call_refs and so forth. The TypeRewriter below will do the
      // right thing as it rewrites everything all at once, so we do not want
      // the type to be modified by removeParameters(), and so we undo the type
      // it made.
      //
      // Note that we cannot just ask removeParameters() to not update the type,
      // as it adds a new local there, whose index depends on the type (which
      // contains the # of parameters, and that determine where non-parameter
      // local indexes begin). Rather than have it update the type and then undo
      // that, which would add more complexity in that method, undo the change
      // here.
      for (auto* func : funcs) {
        func->type = type;
      }
    }

    if (newSignatures.empty()) {
      // We found nothing to optimize.
      return;
    }

    // Rewrite the types.
    GlobalTypeRewriter::updateSignatures(newSignatures, *module);
  }
};

} // anonymous namespace

Pass* createSignaturePruningPass() { return new SignaturePruning(); }

} // namespace wasm
