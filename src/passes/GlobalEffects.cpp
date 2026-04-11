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

constexpr auto UnknownEffects = std::nullopt;

struct FuncInfo {
  // Effects in this function. nullopt / UnknownEffects means that we don't know
  // what effects this function has, so we conservatively assume all effects.
  // Nullopt cases won't be copied to Function::effects.
  std::optional<EffectAnalyzer> effects;

  // Directly-called functions from this function.
  std::unordered_set<Name> calledFunctions;
};

std::map<Function*, FuncInfo> analyzeFuncs(Module& module,
                                           const PassOptions& passOptions) {
  ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
    module, [&](Function* func, FuncInfo& funcInfo) {
      if (func->imported()) {
        // Imports can do anything, so we need to assume the worst anyhow,
        // which is the same as not specifying any effects for them in the
        // map (which we do by not setting funcInfo.effects).
        return;
      }

      // Gather the effects.
      funcInfo.effects.emplace(passOptions, module, func);

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
          const PassOptions& options;
          FuncInfo& funcInfo;

          CallScanner(Module& wasm,
                      const PassOptions& options,
                      FuncInfo& funcInfo)
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
              funcInfo.effects = UnknownEffects;
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
        CallScanner scanner(module, passOptions, funcInfo);
        scanner.walkFunction(func);
      }
    });

  return std::move(analysis.map);
}

// Propagate effects from callees to callers transitively
// e.g. if A -> B -> C (A calls B which calls C)
// Then B inherits effects from C and A inherits effects from both B and C.
void propagateEffects(
  const Module& module,
  const std::unordered_map<Name, std::unordered_set<Name>>& reverseCallGraph,
  std::map<Function*, FuncInfo>& funcInfos) {

  UniqueNonrepeatingDeferredQueue<std::pair<Name, Name>> work;

  for (const auto& [callee, callers] : reverseCallGraph) {
    for (const auto& caller : callers) {
      work.push(std::pair(callee, caller));
    }
  }

  auto propagate = [&](Name callee, Name caller) {
    auto& callerEffects = funcInfos.at(module.getFunction(caller)).effects;
    const auto& calleeEffects =
      funcInfos.at(module.getFunction(callee)).effects;
    if (!callerEffects) {
      return;
    }

    if (!calleeEffects) {
      callerEffects = UnknownEffects;
      return;
    }

    callerEffects->mergeIn(*calleeEffects);
  };

  while (!work.empty()) {
    auto [callee, caller] = work.pop();

    if (callee == caller) {
      auto& callerEffects = funcInfos.at(module.getFunction(caller)).effects;
      if (callerEffects) {
        callerEffects->trap = true;
      }
    }

    // Even if nothing changed, we still need to keep traversing the callers
    // to look for a potential cycle which adds a trap affect on the above
    // lines.
    propagate(callee, caller);

    const auto& callerCallers = reverseCallGraph.find(caller);
    if (callerCallers == reverseCallGraph.end()) {
      continue;
    }

    for (const Name& callerCaller : callerCallers->second) {
      work.push(std::pair(callee, callerCaller));
    }
  }
}

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    std::map<Function*, FuncInfo> funcInfos =
      analyzeFuncs(*module, getPassOptions());

    // callee : caller
    std::unordered_map<Name, std::unordered_set<Name>> callers;
    for (const auto& [func, info] : funcInfos) {
      for (const auto& callee : info.calledFunctions) {
        callers[callee].insert(func->name);
      }
    }

    propagateEffects(*module, callers, funcInfos);

    // Generate the final data, starting from a blank slate where nothing is
    // known.
    for (auto& [func, info] : funcInfos) {
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
