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
// that DAE will update the type of a function. It can only do that if the
// function is not taken by reference, in particular. This pass will modify the
// type of that function itself, in a coordinated way across all the things that
// use that type.
//
// TODO: optimize results too and not just params.
//

#include "ir/find_all.h"
#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

using namespace std;

namespace wasm {

namespace {

struct SignatureSubtyping : public Pass {
  // A list of the type relevant types of calls for us, calls and call_refs.
  struct CallInfo {
    std::vector<Call*> calls;
    std::vector<CallRef*> callRefs;
  };

  // Maps each heap type to the possible refinement of the types in their
  // signatures.
  std::unordered_map<HeapType, Signature> newSignatures;

  void run(PassRunner* runner, Module* module) override {
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "SignatureSubtyping requires nominal typing";
    }

    // First, find all the calls and call_refs.

    ModuleUtils::ParallelFunctionAnalysis<CallInfo> analysis(
      *module, [&](Function* func, CallInfo& info) {
        if (func->imported()) {
          return;
        }
        info.calls = std::move(FindAll<Call>(func->body).list);
        info.callRefs = std::move(FindAll<CallRef>(func->body).list);
      });

    // A map of function types to the calls and call_refs that involve that
    // type.
    std::unordered_map<HeapType, CallInfo> allCallsTo;

    // Combine all the information into the map of function types to the calls
    // and call_refs that involve that type.
    for (auto& [func, info] : analysis.map) {
      for (auto* call : info.calls) {
        allCallsTo[module->getFunction(call->target)->type].calls.push_back(
          call);
      }
      for (auto* callRef : info.callRefs) {
        auto calledType = callRef->target->type;
        if (calledType != Type::unreachable) {
          allCallsTo[calledType.getHeapType()].callRefs.push_back(callRef);
        }
      }
    }

    // Compute optimal LUBs.
    std::unordered_set<HeapType> seen;
    for (auto& func : module->functions) {
      auto type = func->type;
      if (seen.count(type)) {
        continue;
      }
      seen.insert(type);

      auto sig = type.getSignature();
      auto params = sig.params;
      auto numParams = params.size();

      // Compute LUBs for the params.
      std::vector<LUBFinder> paramLUBs(numParams);

      auto updateLUBs = [&](const ExpressionList& operands) {
        for (Index i = 0; i < numParams; i++) {
          paramLUBs[i].note(operands[i]->type);
        }
      };

      auto& callsTo = allCallsTo[type];
      for (auto* call : callsTo.calls) {
        updateLUBs(call->operands);
      }
      for (auto* callRef : callsTo.callRefs) {
        updateLUBs(callRef->operands);
      }

      // Apply the LUBs to the type.
      std::vector<Type> newParamsTypes;
      for (auto lub : paramLUBs) {
        if (!lub.noted()) {
          break;
        }
        newParamsTypes.push_back(lub.get());
      }
      if (newParamsTypes.size() < numParams) {
        // We did not have type information to calculate a LUB (no calls, or the
        // calls are unreachable), so there is nothing we can improve here.
        // Other passes might remove the type entirely.
        continue;
      }
      auto newParams = Type(newParamsTypes);
      if (newParams != func->getParams()) {
        // We found an improvement!
        newSignatures[type] = Signature(newParams, Type::none);
      }
    }

    // Update functions for their new parameter types.
    struct CodeUpdater : public WalkerPass<PostWalker<CodeUpdater>> {
      bool isFunctionParallel() override { return true; }

      SignatureSubtyping& parent;
      Module& wasm;

      CodeUpdater(SignatureSubtyping& parent, Module& wasm)
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

    // Rewrite the types, computing optimal LUBs for each one.
    class TypeRewriter : public GlobalTypeRewriter {
      SignatureSubtyping& parent;

    public:
      TypeRewriter(Module& wasm, SignatureSubtyping& parent)
        : GlobalTypeRewriter(wasm), parent(parent) {}

      virtual void modifySignature(HeapType oldSignatureType, Signature& sig) {
        auto iter = parent.newSignatures.find(oldSignatureType);
        if (iter != parent.newSignatures.end()) {
          sig.params = getTempType(iter->second.params);
        }
      }
    };

    TypeRewriter(*module, *this).update();
  }
};

} // anonymous namespace

Pass* createSignatureSubtypingPass() { return new SignatureSubtyping(); }

} // namespace wasm
