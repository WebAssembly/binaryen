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
// Given a function and all the calls to it, see if there are arguments that
// are always immediately cast to a subtype. If so, then we can move the cast
// to the callers, like this:
//
//   foo(x1);
//   foo(x2);
//   function foo(x : X) {
//     cast<Y>(x); // immediately cast the input X to a subtype Y
//
// This pattern is common in object-oriented code from Java and Kotlin etc.,
// where an itable method implementation will cast the input type to the
// proper type for the class.
//
// This may increase code size (but it does not add more work at runtime) so
// whether we do this depends on the opt/shrink levels.
//
// Returns whether we optimized.
//
// TODO: Add similar code in OptimizeCallCasts as well, for entire type sets.
//

#include "ir/module-utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

struct OptimizeCallCasts : public Pass {
  // Only changes heap types and parameter types (but not locals).
  // XXX
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

    // First, find all the information we need. Start by collecting inside each
    // function in parallel.

    struct Info {
      // The calls.
      std::vector<Call*> calls;

      // A map of param indexes to the types they are definitely cast to if the
      // function is entered.
      std::unordered_map<Index, Type> castParams;
    };

    ModuleUtils::ParallelFunctionAnalysis<Info> analysis(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          return;
        }

        struct Scanner : public LinearExecutionWalker<Scanner> {
          Info& info;

          Scanner(Info& info) : info(info) {}

          // We start in the entry block. TODO: Scan further, noting dominance
          // etc.
          bool inEntry = true;

          static void doNoteNonLinear(SubType* self, Expression** currp) {
            // This is the end of the first basic block.
            inEntry = false;
          }

          void visitCall(Call* curr) {
            info.calls.push_back(curr);
          }

          void visitRefCast(RefCast* curr) {
            if (!inEntry) {
              return;
            }
            if (auto* get = curr->value->dynCast<LocalGet>()) {
              if (curr->type != get->type &&
                  Type::isSubType(curr->type, get->type)) {
                info.castParams[get->index] = curr->type;
                // Note that if we see more than one cast we keep the last one. This
                // is not important in optimized code, as the most refined cast
                // would be the only one to exist there.
              }
            }
          }
        };

        Scanner scanner(info);
        scanner.walk(func);
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
      } else if (type.getSuperType()) {
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

      OptimizeCallCasts& parent;
      Module& wasm;

      CodeUpdater(OptimizeCallCasts& parent, Module& wasm)
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

    // TODO: we could do this only in relevant functions perhaps
    ReFinalize().run(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createOptimizeCallCastsPass() { return new OptimizeCallCasts(); }

} // namespace wasm
