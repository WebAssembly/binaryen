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
#include "support/hash.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm {

namespace {

template<typename T>
std::unordered_map<T, std::unordered_set<T>>
transitiveClosure(const std::unordered_map<T, std::unordered_set<T>>& in) {
  std::unordered_map<T, std::unordered_set<T>> transitive;

  std::unordered_set<std::pair<T, T>> processed;
  std::deque<std::pair<T, T>> work;

  for (const auto& [k, neighbors] : in) {
    for (const auto& neighbor : neighbors) {
      work.emplace_back(k, neighbor);
      processed.emplace(k, neighbor);
    }
  }

  while (!work.empty()) {
    auto [curr, next] = work.back();
    work.pop_back();

    transitive[curr].insert(next);

    const auto& neighborNeighbors = in.find(next);
    if (neighborNeighbors == in.end()) {
      continue;
    }

    for (const T& neighborNeighbor : neighborNeighbors->second) {
      if (processed.count({curr, neighborNeighbor})) {
        continue;
      }

      processed.emplace(curr, neighborNeighbor);
      work.emplace_back(curr, neighborNeighbor);
    }
  }

  return transitive;
}

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    // First, we do a scan of each function to see what effects they have,
    // including which functions they call directly (so that we can compute
    // transitive effects later).

    struct FuncInfo {
      // Effects in this function.
      std::optional<EffectAnalyzer> effects;

      // Directly-called functions from this function.
      std::unordered_set<Name> calledFunctions;
    };

    ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
      *module, [&](Function* func, FuncInfo& funcInfo) {
        if (func->imported()) {
          // Imports can do anything, so we need to assume the worst anyhow,
          // which is the same as not specifying any effects for them in the
          // map (which we do by not setting funcInfo.effects).
          return;
        }

        // Gather the effects.
        funcInfo.effects.emplace(getPassOptions(), *module, func);

        if (funcInfo.effects->calls) {
          // There are calls in this function, which we will analyze in detail.
          // Clear the |calls| field first, and we'll handle calls of all sorts
          // below.
          funcInfo.effects->calls = false;

          // Clear throws as well, as we are "forgetting" calls right now, and
          // want to forget their throwing effect as well. If we see something
          // else that throws, below, then we'll note that there.
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
              if (auto* call = curr->dynCast<Call>()) {
                // Note the direct call.
                funcInfo.calledFunctions.insert(call->target);
              } else if (effects.calls) {
                // This is an indirect call of some sort, so we must assume the
                // worst. To do so, clear the effects, which indicates nothing
                // is known (so anything is possible).
                // TODO: We could group effects by function type etc.
                funcInfo.effects.reset();
              } else {
                // No call here, but update throwing if we see it. (Only do so,
                // however, if we have effects; if we cleared it - see before -
                // then we assume the worst anyhow, and have nothing to update.)
                if (effects.throws_ && funcInfo.effects) {
                  funcInfo.effects->throws_ = true;
                }
              }
            }
          };
          CallScanner scanner(*module, getPassOptions(), funcInfo);
          scanner.walkFunction(func);
        }
      });

    // Compute the transitive closure of effects. To do so, first construct for
    // each function a list of the functions that it is called by (so we need to
    // propagate its effects to them), and then we'll construct the closure of
    // that.
    //
    // callers[foo] = [func that calls foo, another func that calls foo, ..]
    //
    std::unordered_map<Name, std::unordered_set<Name>> callers;
    for (const auto& [func, info] : analysis.map) {
      callers[func->name].insert(info.calledFunctions.begin(),
                                 info.calledFunctions.end());
    }

    auto callersTransitive = transitiveClosure(callers);

    // Check for functions that may have infinite recursion
    for (auto& [func, info] : analysis.map) {
      if (auto it = callersTransitive.find(func->name);
          it != callersTransitive.end() && it->second.contains(func->name)) {
        if (info.effects) {
          info.effects->trap = true;
        }
      }
    }

    for (const auto& [caller, callees] : callersTransitive) {
      auto& callerEffects = analysis.map[module->getFunction(caller)].effects;
      for (const auto& callee : callees) {
        const auto& calleeEffects =
          analysis.map[module->getFunction(callee)].effects;
        if (!callerEffects) {
          continue;
        }

        if (!calleeEffects) {
          callerEffects.reset();
          continue;
        }

        callerEffects->mergeIn(*calleeEffects);
      }
    }

    // Generate the final data, starting from a blank slate where nothing is
    // known.
    for (auto& [func, info] : analysis.map) {
      func->effects.reset();
      if (!info.effects) {
        continue;
      }

      func->effects = std::make_shared<EffectAnalyzer>(*info.effects);
    }
  }
};

struct DiscardGlobalEffects : public Pass {
  void run(Module* module) override {
    for (auto& func : module->functions) {
      func->effects.reset();
    }
  }
};

} // namespace

Pass* createGenerateGlobalEffectsPass() { return new GenerateGlobalEffects(); }

Pass* createDiscardGlobalEffectsPass() { return new DiscardGlobalEffects(); }

} // namespace wasm
