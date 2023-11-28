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
// Apply more specific subtypes to signature/function types where possible.
//
// This differs from DeadArgumentElimination's refineArgumentTypes() etc. in
// that DAE will modify the type of a function. It can only do that if the
// function's type is not observable, which means it is not taken by reference.
// On the other hand, this pass will modify the signature types themselves,
// which means it can optimize functions whose reference is taken, and it does
// so while considering all users of the type (across all functions sharing that
// type, and all call_refs using it).
//

#include "ir/export-utils.h"
#include "ir/find_all.h"
#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

struct SignatureRefining : public Pass {
  // Only changes heap types and parameter types (but not locals).
  bool requiresNonNullableLocalFixups() override { return false; }

  // Maps each heap type to the possible refinement of the types in their
  // signatures. We will fill this during analysis and then use it while doing
  // an update of the types. If a type has no improvement that we can find, it
  // will not appear in this map.
  std::unordered_map<HeapType, Signature> newSignatures;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
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
      // The calls and call_refs.
      std::vector<Call*> calls;
      std::vector<CallRef*> callRefs;

      // Additional calls to take into account. We store intrinsic calls here,
      // as they must appear twice: call.without.effects is both a normal call
      // and also takes a final parameter that is a function reference that is
      // called, and so two signatures are relevant for it. For the latter, we
      // add the call as an "extra call" (which is an unusual call, as it has an
      // extra parameter at the end, the function reference, compared to what we
      // expect for the signature being called).
      std::vector<Call*> extraCalls;

      // A possibly improved LUB for the results.
      LUBFinder resultsLUB;

      // Normally we can optimize, but some cases prevent a particular signature
      // type from being changed at all, see below.
      bool canModify = true;
    };

    // This analysis also modifies the wasm as it goes, as the getResultsLUB()
    // operation has side effects (see comment on header declaration).
    ModuleUtils::ParallelFunctionAnalysis<Info, Mutable> analysis(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          // Avoid changing the types of imported functions. Spec and VM support
          // for that is not yet stable.
          // TODO: optimize this when possible in the future
          info.canModify = false;
          return;
        }
        info.calls = std::move(FindAll<Call>(func->body).list);
        info.callRefs = std::move(FindAll<CallRef>(func->body).list);
        info.resultsLUB = LUB::getResultsLUB(func, *module);
      });

    // A map of types to all the information combined over all the functions
    // with that type.
    std::unordered_map<HeapType, Info> allInfo;

    // Combine all the information we gathered into that map.
    for (auto& [func, info] : analysis.map) {
      // For direct calls, add each call to the type of the function being
      // called.
      for (auto* call : info.calls) {
        allInfo[module->getFunction(call->target)->type].calls.push_back(call);

        // For call.without.effects, we also add the effective function being
        // called as well. The final operand is the function reference being
        // called, which defines that type.
        if (Intrinsics(*module).isCallWithoutEffects(call)) {
          auto targetType = call->operands.back()->type;
          if (!targetType.isRef()) {
            continue;
          }
          allInfo[targetType.getHeapType()].extraCalls.push_back(call);
        }
      }

      // For indirect calls, add each call_ref to the type the call_ref uses.
      for (auto* callRef : info.callRefs) {
        auto calledType = callRef->target->type;
        if (calledType != Type::unreachable) {
          allInfo[calledType.getHeapType()].callRefs.push_back(callRef);
        }
      }

      // Add the function's return LUB to the one for the heap type of that
      // function.
      allInfo[func->type].resultsLUB.combine(info.resultsLUB);

      // If one function cannot be modified, that entire type cannot be.
      if (!info.canModify) {
        allInfo[func->type].canModify = false;
      }
    }

    // We cannot alter the signature of an exported function, as the outside may
    // notice us doing so. For example, if we turn a parameter from nullable
    // into non-nullable then callers sending a null will break. Put another
    // way, we need to see all callers to refine types, and for exports we
    // cannot do so.
    // TODO If a function type is passed we should also mark the types used
    //      there, etc., recursively. For now this code just handles the top-
    //      level type, which is enough to keep the fuzzer from erroring. More
    //      generally, we need to decide about adding a "closed-world" flag of
    //      some kind.
    for (auto* exportedFunc : ExportUtils::getExportedFunctions(*module)) {
      allInfo[exportedFunc->type].canModify = false;
    }

    // For now, do not optimize types that have subtypes. When we modify such a
    // type we need to modify subtypes as well, similar to the analysis in
    // TypeRefining, and perhaps we can unify this pass with that. TODO
    SubTypes subTypes(*module);
    for (auto& [type, info] : allInfo) {
      if (!subTypes.getImmediateSubTypes(type).empty()) {
        info.canModify = false;
      } else if (type.getDeclaredSuperType()) {
        // Also avoid modifying types with supertypes, as we do not handle
        // contravariance here. That is, when we refine parameters we look for
        // a more refined type, but the type must be *less* refined than the
        // param type for the parent (or equal) TODO
        info.canModify = false;
      }
    }

    // Compute optimal LUBs.
    std::unordered_set<HeapType> seen;
    for (auto& func : module->functions) {
      auto type = func->type;
      if (!seen.insert(type).second) {
        continue;
      }

      auto& info = allInfo[type];
      if (!info.canModify) {
        continue;
      }

      auto sig = type.getSignature();

      auto numParams = sig.params.size();
      std::vector<LUBFinder> paramLUBs(numParams);

      auto updateLUBs = [&](const ExpressionList& operands) {
        for (Index i = 0; i < numParams; i++) {
          paramLUBs[i].note(operands[i]->type);
        }
      };

      for (auto* call : info.calls) {
        updateLUBs(call->operands);
      }
      for (auto* callRef : info.callRefs) {
        updateLUBs(callRef->operands);
      }
      for (auto* call : info.extraCalls) {
        // Note that these intrinsic calls have an extra function reference
        // param at the end, but updateLUBs looks at |numParams| only, so it
        // considers just the relevant parameters.
        updateLUBs(call->operands);
      }

      // Find the final LUBs, and see if we found an improvement.
      std::vector<Type> newParamsTypes;
      for (auto& lub : paramLUBs) {
        if (!lub.noted()) {
          break;
        }
        newParamsTypes.push_back(lub.getLUB());
      }
      Type newParams;
      if (newParamsTypes.size() < numParams) {
        // We did not have type information to calculate a LUB (no calls, or
        // some param is always unreachable), so there is nothing we can improve
        // here. Other passes might remove the type entirely.
        newParams = func->getParams();
      } else {
        newParams = Type(newParamsTypes);
      }

      auto& resultsLUB = info.resultsLUB;
      Type newResults;
      if (!resultsLUB.noted()) {
        // We did not have type information to calculate a LUB (no returned
        // value, or it can return a value but traps instead etc.).
        newResults = func->getResults();
      } else {
        newResults = resultsLUB.getLUB();
      }

      if (newParams == func->getParams() && newResults == func->getResults()) {
        continue;
      }

      // We found an improvement!
      newSignatures[type] = Signature(newParams, newResults);

      if (newResults != func->getResults()) {
        // Update the types of calls using the signature.
        for (auto* call : info.calls) {
          if (call->type != Type::unreachable) {
            call->type = newResults;
          }
        }
        for (auto* callRef : info.callRefs) {
          if (callRef->type != Type::unreachable) {
            callRef->type = newResults;
          }
        }
      }
    }

    if (newSignatures.empty()) {
      // We found nothing to optimize.
      return;
    }

    // Update function contents for their new parameter types.
    struct CodeUpdater : public WalkerPass<PostWalker<CodeUpdater>> {
      bool isFunctionParallel() override { return true; }

      // Updating parameter types cannot affect validation (only updating var
      // types types might).
      bool requiresNonNullableLocalFixups() override { return false; }

      SignatureRefining& parent;
      Module& wasm;

      CodeUpdater(SignatureRefining& parent, Module& wasm)
        : parent(parent), wasm(wasm) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<CodeUpdater>(parent, wasm);
      }

      void doWalkFunction(Function* func) {
        auto iter = parent.newSignatures.find(func->type);
        if (iter != parent.newSignatures.end()) {
          std::vector<Type> newParamsTypes;
          for (auto param : iter->second.params) {
            newParamsTypes.push_back(param);
          }
          // Do not update local.get/local.tee here, as we will do so in
          // GlobalTypeRewriter::updateSignatures, below. (Doing an update here
          // would leave the IR in an inconsistent state of a partial update;
          // instead, do the full update at the end.)
          TypeUpdating::updateParamTypes(
            func,
            newParamsTypes,
            wasm,
            TypeUpdating::LocalUpdatingMode::DoNotUpdate);
        }
      }
    };
    CodeUpdater(*this, *module).run(getPassRunner(), module);

    // Rewrite the types.
    GlobalTypeRewriter::updateSignatures(newSignatures, *module);

    // Update intrinsics.
    updateIntrinsics(module, allInfo);

    // TODO: we could do this only in relevant functions perhaps
    ReFinalize().run(getPassRunner(), module);
  }

  template<typename HeapInfoMap>
  void updateIntrinsics(Module* module, HeapInfoMap& map) {
    // The call.without.effects intrinsic needs to be updated if we refine the
    // function reference it receives. Imagine that we have this:
    //
    //  (call $call.without.effects
    //    (ref.func $returns.A)
    //  )
    //
    // If we refined that $returns.A function to actually return a subtype $B,
    // then now the call.without.effects should return $B, because logically it
    // is still a direct call to that function. (We could also defer this to
    // later, if we relaxed validation here, but updating right now is better
    // for followup optimizations.)

    // Each time we update we create a new import with the proper type. Keep a
    // map of them to avoid creating more than one for each type.
    std::unordered_map<HeapType, Function*> newImports;

    auto getImportWithNewResults = [&](Function* import, Type newResults) {
      auto newType = Signature(import->getParams(), newResults);
      if (auto iter = newImports.find(newType); iter != newImports.end()) {
        return iter->second;
      }

      auto name = Names::getValidFunctionName(*module, import->name);
      auto newImport =
        module->addFunction(Builder(*module).makeFunction(name, newType, {}));

      // Copy the binaryen intrinsic module.base import names.
      newImport->module = import->module;
      newImport->base = import->base;

      newImports[newType] = newImport;
      return newImport;
    };

    for (auto& [_, info] : map) {
      for (auto* call : info.calls) {
        if (Intrinsics(*module).isCallWithoutEffects(call)) {
          auto targetType = call->operands.back()->type;
          if (!targetType.isRef()) {
            continue;
          }
          auto heapType = targetType.getHeapType();
          if (!heapType.isSignature()) {
            continue;
          }
          auto newResults = heapType.getSignature().results;
          if (call->type == newResults) {
            continue;
          }

          // The target was refined, so we need to update here. Create a new
          // import of the refined type, and call that instead.
          call->target = getImportWithNewResults(
                           module->getFunction(call->target), newResults)
                           ->name;
          call->type = newResults;
        }
      }
    }
  }
};

} // anonymous namespace

Pass* createSignatureRefiningPass() { return new SignatureRefining(); }

} // namespace wasm
