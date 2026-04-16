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
#include "support/strongly_connected_components.h"
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

using CallGraph = std::unordered_map<Function*, std::unordered_set<Function*>>;

CallGraph buildCallGraph(const Module& module,
                         const std::map<Function*, FuncInfo>& funcInfos) {
  CallGraph callGraph;
  for (const auto& [func, info] : funcInfos) {
    if (info.calledFunctions.empty()) {
      continue;
    }

    auto& callees = callGraph[func];
    for (Name callee : info.calledFunctions) {
      callees.insert(module.getFunction(callee));
    }
  }

  return callGraph;
}

void mergeMaybeEffects(std::optional<EffectAnalyzer>& dest,
                       const std::optional<EffectAnalyzer>& src) {
  if (dest == UnknownEffects) {
    return;
  }
  if (src == UnknownEffects) {
    dest = UnknownEffects;
    return;
  }

  dest->mergeIn(*src);
}

// Propagate effects from callees to callers transitively
// e.g. if A -> B -> C (A calls B which calls C)
// Then B inherits effects from C and A inherits effects from both B and C.
//
// Generate SCC for the call graph, then traverse it in reverse topological
// order processing each callee before its callers. When traversing:
// - Merge all of the effects of functions within the CC
// - Also merge the (already computed) effects of each callee CC
// - Add trap effects for potentially recursive call chains
void propagateEffects(const Module& module,
                      const PassOptions& passOptions,
                      std::map<Function*, FuncInfo>& funcInfos,
                      const CallGraph& callGraph) {
  struct CallGraphSCCs
    : SCCs<std::vector<Function*>::const_iterator, CallGraphSCCs> {
    const std::map<Function*, FuncInfo>& funcInfos;
    const std::unordered_map<Function*, std::unordered_set<Function*>>&
      callGraph;
    const Module& module;

    CallGraphSCCs(
      const std::vector<Function*>& funcs,
      const std::map<Function*, FuncInfo>& funcInfos,
      const std::unordered_map<Function*, std::unordered_set<Function*>>&
        callGraph,
      const Module& module)
      : SCCs<std::vector<Function*>::const_iterator, CallGraphSCCs>(
          funcs.begin(), funcs.end()),
        funcInfos(funcInfos), callGraph(callGraph), module(module) {}

    void pushChildren(Function* f) {
      auto callees = callGraph.find(f);
      if (callees == callGraph.end()) {
        return;
      }

      for (auto* callee : callees->second) {
        push(callee);
      }
    }
  };

  std::vector<Function*> allFuncs;
  for (auto& [func, info] : funcInfos) {
    allFuncs.push_back(func);
  }
  CallGraphSCCs sccs(allFuncs, funcInfos, callGraph, module);

  std::vector<std::optional<EffectAnalyzer>> componentEffects;
  // Points to an index in componentEffects
  std::unordered_map<Function*, Index> funcComponents;

  for (auto ccIterator : sccs) {
    std::optional<EffectAnalyzer>& ccEffects =
      componentEffects.emplace_back(std::in_place, passOptions, module);

    std::vector<Function*> ccFuncs(ccIterator.begin(), ccIterator.end());

    for (Function* f : ccFuncs) {
      funcComponents.emplace(f, componentEffects.size() - 1);
    }

    std::unordered_set<int> calleeSccs;
    for (Function* caller : ccFuncs) {
      auto callees = callGraph.find(caller);
      if (callees == callGraph.end()) {
        continue;
      }
      for (auto* callee : callees->second) {
        calleeSccs.insert(funcComponents.at(callee));
      }
    }

    // Merge in effects from callees
    for (int calleeScc : calleeSccs) {
      const auto& calleeComponentEffects = componentEffects.at(calleeScc);
      mergeMaybeEffects(ccEffects, calleeComponentEffects);
    }

    // Add trap effects for potential cycles.
    if (ccFuncs.size() > 1) {
      if (ccEffects != UnknownEffects) {
        ccEffects->trap = true;
      }
    } else {
      auto* func = ccFuncs[0];
      if (funcInfos.at(func).calledFunctions.contains(func->name)) {
        if (ccEffects != UnknownEffects) {
          ccEffects->trap = true;
        }
      }
    }

    // Aggregate effects within this CC
    if (ccEffects) {
      for (Function* f : ccFuncs) {
        const auto& effects = funcInfos.at(f).effects;
        mergeMaybeEffects(ccEffects, effects);
      }
    }

    // Assign each function's effects to its CC effects.
    for (Function* f : ccFuncs) {
      if (!ccEffects) {
        funcInfos.at(f).effects = UnknownEffects;
      } else {
        funcInfos.at(f).effects.emplace(*ccEffects);
      }
    }
  }
}

void copyEffectsToFunctions(const std::map<Function*, FuncInfo>& funcInfos) {
  for (auto& [func, info] : funcInfos) {
    func->effects.reset();
    if (!info.effects) {
      continue;
    }

    func->effects = std::make_shared<EffectAnalyzer>(*info.effects);
  }
}

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    std::map<Function*, FuncInfo> funcInfos =
      analyzeFuncs(*module, getPassOptions());

    auto callGraph = buildCallGraph(*module, funcInfos);

    propagateEffects(*module, getPassOptions(), funcInfos, callGraph);

    copyEffectsToFunctions(funcInfos);
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
