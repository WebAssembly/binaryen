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
// Like in DAE, as part of pruning parameters this will find parameters that are
// always sent the same constant value. We can then apply that value in the
// function, making the parameter's value unused, which means we can prune it.
//

#include "ir/find_all.h"
#include "ir/intrinsics.h"
#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "ir/subtypes.h"
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

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "SignaturePruning requires --closed-world";
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

      // If we set this to false, we may not attempt to perform any optimization
      // whatsoever on this data.
      bool optimizable = true;
    };

    ModuleUtils::ParallelFunctionAnalysis<Info> analysis(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          // Imports cannot be modified.
          info.optimizable = false;
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

        // Intrinsics limit our ability to optimize in some cases. We will avoid
        // modifying any type that is used by call.without.effects, to avoid
        // the complexity of handling that. After intrinsics are lowered,
        // this optimization will be able to run at full power anyhow.
        if (Intrinsics(*module).isCallWithoutEffects(call)) {
          // The last operand is the actual call target.
          auto* target = call->operands.back();
          if (target->type != Type::unreachable) {
            allInfo[target->type.getHeapType()].optimizable = false;
          }
        }
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

      if (!info.optimizable) {
        allInfo[func->type].optimizable = false;
      }

      sigFuncs[func->type].push_back(func);
    }

    // Exported functions cannot be modified.
    for (auto& exp : module->exports) {
      if (exp->kind == ExternalKind::Function) {
        auto* func = module->getFunction(exp->value);
        allInfo[func->type].optimizable = false;
      }
    }

    // A type must have the same number of parameters and results as its
    // supertypes and subtypes, so we only attempt to modify types without
    // supertypes or subtypes.
    // TODO We could handle "cycles" where we remove fields from a group of
    //      types with subtyping relations at once.
    SubTypes subTypes(*module);

    // Find parameters to prune.
    for (auto& [type, funcs] : sigFuncs) {
      auto sig = type.getSignature();
      auto& info = allInfo[type];
      auto& usedParams = info.usedParams;
      auto numParams = sig.params.size();

      if (!info.optimizable) {
        continue;
      }

      if (!subTypes.getStrictSubTypes(type).empty()) {
        continue;
      }
      if (auto super = type.getSuperType()) {
        if (super->isSignature()) {
          continue;
        }
      }

      // Apply constant indexes: find the parameters that are always sent a
      // constant value, and apply that value in the function. That then makes
      // the parameter unused (since the applied value makes us ignore the value
      // arriving in the parameter).
      auto optimizedIndexes = ParamUtils::applyConstantValues(
        funcs, info.calls, info.callRefs, module);
      for (auto i : optimizedIndexes) {
        usedParams.erase(i);
      }

      if (usedParams.size() == numParams) {
        // All parameters are used, give up on this one.
        continue;
      }

      // We found possible work! Find the specific params that are unused & try
      // to prune them.
      SortedVector unusedParams;
      for (Index i = 0; i < numParams; i++) {
        if (usedParams.count(i) == 0) {
          unusedParams.insert(i);
        }
      }

      auto oldParams = sig.params;
      auto removedIndexes = ParamUtils::removeParameters(funcs,
                                                         unusedParams,
                                                         info.calls,
                                                         info.callRefs,
                                                         module,
                                                         getPassRunner());
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

      // Create a new signature. When the TypeRewriter operates below it will
      // modify the existing heap type in place to change its signature to this
      // one (which preserves identity, that is, even if after pruning the new
      // signature is structurally identical to another one, it will remain
      // nominally different from those).
      newSignatures[type] = Signature(Type(newParams), sig.results);

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

    // Rewrite the types.
    GlobalTypeRewriter::updateSignatures(newSignatures, *module);
  }
};

} // anonymous namespace

Pass* createSignaturePruningPass() { return new SignaturePruning(); }

} // namespace wasm
