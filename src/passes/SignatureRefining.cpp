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
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "param-utils.h"
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

  struct Info {
    // The calls and call_refs.
    std::vector<Call*> calls;
    std::vector<CallRef*> callRefs;

    // The relevant drops. In the initial scan we collect all drops, and then
    // when we merge the information we'll note the drops for each call. We
    // list pointers to the drops so that we can replace them (we won't need
    // the drop if we remove all returned values).
    std::vector<Expression**> drops;

    // A possibly improved LUB for the results.
    LUBFinder resultsLUB;

    // Normally we can optimize, but some cases prevent a particular signature
    // type from being changed at all, see below.
    bool canModify = true;

    // Sometimes we can modify the signature as a whole, but not the results.
    bool canModifyResults = true;
  };

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }
    if (getTypeSystem() != TypeSystem::Nominal &&
        getTypeSystem() != TypeSystem::Isorecursive) {
      Fatal() << "SignatureRefining requires nominal/hybrid typing";
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
    //
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
        info.drops = std::move(FindAllPointers<Drop>(func->body).list);
        info.resultsLUB = LUB::getResultsLUB(func, *module);

        // If this function contains a return_call then we can't modify the
        // results, as the results must continue to match the return_call.
        for (auto* call : info.calls) {
          if (call->isReturn) {
            info.canModifyResults = false;
            break;
          }
        }
        for (auto* call : info.callRefs) {
          if (call->isReturn) {
            info.canModifyResults = false;
            break;
          }
        }
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
        // If a function is return_call'd then we can't modify the results, as
        // the results must continue to match the function the return_call is
        // inside.
        if (call->isReturn) {
          allInfo[module->getFunction(call->target)->type].canModifyResults = false;
        }
      }

      // For indirect calls, add each call_ref to the type the call_ref uses.
      for (auto* callRef : info.callRefs) {
        auto calledType = callRef->target->type;
        if (calledType != Type::unreachable) {
          allInfo[calledType.getHeapType()].callRefs.push_back(callRef);
        }
        // See comment above on return_call.
        if (callRef->isReturn) {
          allInfo[calledType.getHeapType()].canModifyResults = false;
        }
      }

      // Find drops of calls and place them in the relevant location.
      for (auto** dropp : info.drops) {
        auto* drop = (*dropp)->cast<Drop>();
        if (auto* call = drop->value->dynCast<Call>()) {
          allInfo[module->getFunction(call->target)->type].drops.push_back(
            dropp);
        } else if (auto* callRef = drop->value->dynCast<CallRef>()) {
          auto calledType = callRef->target->type;
          if (calledType != Type::unreachable) {
            allInfo[calledType.getHeapType()].drops.push_back(dropp);
          }
        }
      }

      // Add the function's return LUB to the one for the heap type of that
      // function.
      allInfo[func->type].resultsLUB.combine(info.resultsLUB);

      // If one function cannot be modified, that entire type cannot be.
      if (!info.canModify) {
        allInfo[func->type].canModify = false;
      }
      if (!info.canModifyResults) {
        allInfo[func->type].canModifyResults = false;
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

    bool refinedResults = false;

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
          paramLUBs[i].noteUpdatableExpression(operands[i]);
        }
      };

      for (auto* call : info.calls) {
        updateLUBs(call->operands);
      }
      for (auto* callRef : info.callRefs) {
        updateLUBs(callRef->operands);
      }

      // Find the final LUBs, and see if we found an improvement.
      std::vector<Type> newParamsTypes;
      for (auto& lub : paramLUBs) {
        if (!lub.noted()) {
          break;
        }
        newParamsTypes.push_back(lub.getBestPossible());
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
      Type newResults = func->getResults();
      if (info.canModifyResults) {
         // If we had enough information to infer a LUB for the results, we can
         // use that. (We couldn't if there was no returned value or it can
         // return a value but traps instead etc.)
         if (resultsLUB.noted()) {
          newResults = resultsLUB.getBestPossible();
        }

        // If calls to this type are always dropped, we do not need the results.
        if (func->getResults() != Type::none) {
          auto numCalls = info.calls.size() + info.callRefs.size();
          auto numDroppedCalls = info.drops.size();
          assert(numDroppedCalls <= numCalls);
          // Check that all calls are dropped, but also that there are calls at
          // all - it would be wasted work to do anything to a type that is
          // effectively unreachable. Leave that for other passes.
          if (numDroppedCalls == numCalls && numCalls > 0) {
            removeResults(type, info, module);
            newResults = Type::none;
          }
        }
      }

      if (newParams == func->getParams() && newResults == func->getResults()) {
        continue;
      }

      // We found an improvement!
      newSignatures[type] = Signature(newParams, newResults);

      // Update nulls as necessary, now that we are changing things.
      if (newParams != func->getParams()) {
        for (auto& lub : paramLUBs) {
          lub.updateNulls();
        }
      }
      if (newResults != func->getResults()) {
        resultsLUB.updateNulls();
        refinedResults = true;

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

    if (refinedResults) {
      // After return types change we need to propagate.
      // TODO: we could do this only in relevant functions perhaps
      ReFinalize().run(getPassRunner(), module);
    }
  }

  void removeResults(HeapType type, const Info& info, Module* module) {
    // Replace all drops of calls with the call itself.
    for (auto** dropp : info.drops) {
      auto* drop = (*dropp)->cast<Drop>();
      (*dropp) = drop->value;
    }

    // Remove returns inside the functions.
    ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
      if (func->type == type) {
        ParamUtils::removeReturns(func, module);
      }
    });
  }
};

} // anonymous namespace

Pass* createSignatureRefiningPass() { return new SignatureRefining(); }

} // namespace wasm
