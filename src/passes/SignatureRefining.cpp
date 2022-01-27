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

#include "ir/find_all.h"
#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

using namespace std;

namespace wasm {

namespace {

struct SignatureRefining : public Pass {
  // Maps each heap type to the possible refinement of the types in their
  // signatures. We will fill this during analysis and then use it while doing
  // an update of the types. If a type has no improvement that we can find, it
  // will not appear in this map.
  std::unordered_map<HeapType, Signature> newSignatures;

  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "SignatureRefining requires nominal typing";
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

      // A possibly improved LUB for the results.
      LUBFinder resultsLUB;
    };

    ModuleUtils::ParallelFunctionAnalysis<Info> analysis(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
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
    }

    bool refinedResults = false;

    // Compute optimal LUBs.
    std::unordered_set<HeapType> seen;
    for (auto& func : module->functions) {
      auto type = func->type;
      if (!seen.insert(type).second) {
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

      auto& info = allInfo[type];
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
      Type newResults;
      if (!resultsLUB.noted()) {
        // We did not have type information to calculate a LUB (no returned
        // value, or it can return a value but traps instead etc.).
        newResults = func->getResults();
      } else {
        newResults = resultsLUB.getBestPossible();
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

      SignatureRefining& parent;
      Module& wasm;

      CodeUpdater(SignatureRefining& parent, Module& wasm)
        : parent(parent), wasm(wasm) {}

      CodeUpdater* create() override { return new CodeUpdater(parent, wasm); }

      void doWalkFunction(Function* func) {
        auto iter = parent.newSignatures.find(func->type);
        if (iter != parent.newSignatures.end()) {
          std::vector<Type> newParamsTypes;
          for (auto param : iter->second.params) {
            newParamsTypes.push_back(param);
          }
          TypeUpdating::updateParamTypes(func, newParamsTypes, wasm);
        }
      }
    };
    CodeUpdater(*this, *module).run(runner, module);

    // Rewrite the types.
    class TypeRewriter : public GlobalTypeRewriter {
      SignatureRefining& parent;

    public:
      TypeRewriter(Module& wasm, SignatureRefining& parent)
        : GlobalTypeRewriter(wasm), parent(parent) {}

      void modifySignature(HeapType oldSignatureType, Signature& sig) override {
        auto iter = parent.newSignatures.find(oldSignatureType);
        if (iter != parent.newSignatures.end()) {
          sig.params = getTempType(iter->second.params);
          sig.results = getTempType(iter->second.results);
        }
      }
    };

    TypeRewriter(*module, *this).update();

    if (refinedResults) {
      // After return types change we need to propagate.
      // TODO: we could do this only in relevant functions perhaps
      ReFinalize().run(runner, module);
    }
  }
};

} // anonymous namespace

Pass* createSignatureRefiningPass() { return new SignatureRefining(); }

} // namespace wasm
