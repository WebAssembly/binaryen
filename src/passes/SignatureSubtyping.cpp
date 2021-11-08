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

  // A map of function types to the calls and call_refs that involve that type.
  std::unordered_map<HeapType, CallInfo> allCallsTo;

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

    // Rewrite the types, computing optimal LUBs for each one.
    class TypeRewriter : public GlobalTypeRewriter {
      SignatureSubtyping& parent;

    public:
      TypeRewriter(Module& wasm, SignatureSubtyping& parent)
        : GlobalTypeRewriter(wasm), parent(parent) {}

      virtual void modifySignature(HeapType oldSignatureType, Signature& sig) {
        auto oldSig = oldSignatureType.getSignature();
        auto oldParams = oldSig.params;
        auto numParams = oldParams.size();

        // Compute LUBs for the params.
        std::vector<LUBFinder> paramLUBs(numParams);

        auto updateLUBs = [&](const ExpressionList& operands) {
          for (Index i = 0; i < numParams; i++) {
            paramLUBs[i].note(operands[i]->type);
          }
        };

        auto& callsTo = parent.allCallsTo[oldSignatureType];
        for (auto* call : callsTo.calls) {
          updateLUBs(call->operands);
        }
        for (auto* callRef : callsTo.callRefs) {
          updateLUBs(callRef->operands);
        }

        // Apply the LUBs to the type.
        std::vector<Type> newParams;
        for (auto lub : paramLUBs) {
          newParams.push_back(lub.get());
        }
        sig.params = getTempType(Type(newParams));
      }
    };

    TypeRewriter(*module, *this).update();

    // Update local types everywhere, as parameters may have changed.
    TypeUpdating::updateLocalTypes(*module);
  }
};

} // anonymous namespace

Pass* createSignatureSubtypingPass() { return new SignatureSubtyping(); }

} // namespace wasm
