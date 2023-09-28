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
// Handle the computation of global effects. The effects are stored on the
// PassOptions structure; see more details there.
//

#include "ir/effects.h"
#include "ir/module-utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm {

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    // First, we do a scan of each function to see what effects they have,
    // including which functions they call directly (so that we can compute
    // transitive effects later.

    struct FuncInfo {
      // Effects in this function.
      std::unique_ptr<EffectAnalyzer> effects;

      // Directly-called function from this function.
      std::unordered_set<Name> calledFunctions;
    };

    ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
      *module, [&](Function* func, FuncInfo& funcInfo) {
        if (func->imported()) {
          // Imports can do anything, so we need to assume the worst anyhow,
          // which is the same as not specifying any effects for them in the
          // map.
          return;
        }

        // Gather the effects.
        funcInfo.effects =
          std::make_unique<EffectAnalyzer>(getPassOptions(), *module, func);

        if (funcInfo.effects->calls) {
          // There are calls in this function, which we will analyze in detail.
          // Clear the |calls| field regardless, as we'll handle calls of all
          // sorts below.
          funcInfo.effects->calls = false;

          // Clear throws as well, as we are "forgetting" calls right now, and
          // want to forget their throwing effect as well. If we see something
          // else that throws, below, then we'll note that.
          funcInfo.effects->throws_ = false;

          struct CallScanner
            : public PostWalker<CallScanner,
                                UnifiedExpressionVisitor<CallScanner>> {
            Module& wasm;
            PassOptions& options;
            FuncInfo& funcInfo;

            CallScanner(Module& wasm, PassOptions& options, FuncInfo& funcInfo)
              : wasm(wasm), options(options), funcInfo(funcInfo) {}

            void visitExpression(Expression* curr) {
              ShallowEffectAnalyzer effects(options, wasm, curr);
              if (!effects.calls) {
                // No call here, but update throwing if we see it. (Only do so,
                // however, if we have effects; if we cleared it - see below -
                // then we assume the worst anyhow, and have nothing to update.)
                if (effects.throws_ && funcInfo.effects) {
                  funcInfo.effects->throws_ = true;
                }
                return;
              }

              if (auto* call = curr->dynCast<Call>()) {
                funcInfo.calledFunctions.insert(call->target);
              } else {
                // This is an indirect call of some sort, so we must assume the
                // worst. To do so, clear the effects, which indicates nothing
                // is known (so anything is possible).
                // TODO: We could group effects by function type etc.
                funcInfo.effects.reset();
              }
            }
          };
          CallScanner scanner(*module, getPassOptions(), funcInfo);
          scanner.walkFunction(func);
        }
      });

    // Compute the transitive closure of effects. To do so, first construct for
    // each function a list of the functions that it is called by (so we need to
    // propogate its effects to them).
    std::unordered_map<Name, std::unordered_set<Name>> callers;
    UniqueDeferredQueue<Name> work;
    for (auto& [func, info] : analysis.map) {
      for (auto& called : info.calledFunctions) {
        callers[called].insert(func->name);
      }
      work.push(func->name);
    }

    // Compute the transitive closure of the call graph, that is, fill out
    // |callers| so that it contains the list of all callers - even through a
    // chain - of each function.
    while (!work.empty()) {
      auto func = work.pop();

      // Iterate over a copy to avoid iterator invalidation.
      auto callersOfFunc = callers[func];
      for (auto& caller : callersOfFunc) {
        // We know |caller| calls |func|, and therefore each call of |caller|
        // also calls func:
        //
        //   |caller of caller| => |caller| => |func|
        //

        auto callersOfCaller = callers[caller];
        for (auto& callerOfCaller : callersOfCaller) {
          if (callers[func].insert(callerOfCaller).second) {
            // We found a new caller, which means more work: everything that
            // |func| calls must be recomputed, as more things might call them.
            for (auto& called : analysis.map[module->getFunction(func)].calledFunctions) {
              work.push(called);
            }
          }
        }
      }
    }

    // Now that we have transitively propagated all static calls, apply that
    // information.
    for (auto& [func, info] : analysis.map) {
      auto& funcEffects = analysis.map[func].effects;

      for (auto& caller : callers[func->name]) {
        auto& callerEffects = analysis.map[module->getFunction(caller)].effects;
        if (!callerEffects) {
          // Nothing is known for the caller, which is already the worst case.
          continue;
        }

        if (!funcEffects) {
          // Nothing is known for the called function, which means nothing is
          // known for the caller either.
          callerEffects.reset();
          continue;
        }

        // Add func's effects to the caller.
        callerEffects->mergeIn(*funcEffects); // TODO: remove ==
      }
    }

    // TODO: cycles are effects too

    // Generate the final data structure, starting from a blank slate where
    // nothing is known.
    auto& funcEffectsMap = getPassOptions().funcEffectsMap;
    funcEffectsMap.reset();

    for (auto& [func, info] : analysis.map) {
      if (!info.effects) {
        // Add no entry to funcEffectsMap, since nothing is known.
        continue;
      }

      // Only allocate a new funcEffectsMap here when we actually have data for
      // it (which might make later effect computation slightly faster, to
      // quickly skip the funcEffectsMap code path).
      if (!funcEffectsMap) {
        funcEffectsMap = std::make_shared<FuncEffectsMap>();
      }
      funcEffectsMap->emplace(func->name, *info.effects);
    }
  }
};

struct DiscardGlobalEffects : public Pass {
  void run(Module* module) override { getPassOptions().funcEffectsMap.reset(); }
};

Pass* createGenerateGlobalEffectsPass() { return new GenerateGlobalEffects(); }

Pass* createDiscardGlobalEffectsPass() { return new DiscardGlobalEffects(); }

} // namespace wasm
