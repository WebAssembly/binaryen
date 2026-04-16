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

struct FuncInfo {
  // Directly-called functions from this function.
  std::unordered_set<Name> calledFunctions;
};

std::map<Function*, FuncInfo> analyzeFuncs(Module& module,
                                           const PassOptions& passOptions) {
  ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
    module, [&](Function* func, FuncInfo& funcInfo) {
      if (func->imported()) {
        // Imports can do anything, so we need to assume the worst anyhow.
        func->effects = nullptr;
        return;
      }

      // Gather the effects.
      func->effects =
        std::make_shared<EffectAnalyzer>(passOptions, module, func);

      if (func->effects->calls) {
        // There are calls in this function, which we will analyze in detail.
        // Clear the |calls| field first, and we'll handle calls of all sorts
        // below.
        func->effects->calls = false;

        // Clear throws as well, as we are "forgetting" calls right now, and
        // want to forget their throwing effect as well. If we see something
        // else that throws, below, then we'll note that there.
        func->effects->throws_ = false;

        struct CallScanner
          : public PostWalker<CallScanner,
                              UnifiedExpressionVisitor<CallScanner>> {
          Module& wasm;
          const PassOptions& options;
          FuncInfo& funcInfo;
          Function* func;

          CallScanner(Module& wasm,
                      const PassOptions& options,
                      FuncInfo& funcInfo,
                      Function* func)
            : wasm(wasm), options(options), funcInfo(funcInfo), func(func) {}

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
              func->effects = nullptr;
            } else {
              // No call here, but update throwing if we see it. (Only do so,
              // however, if we have effects; if we cleared it - see before -
              // then we assume the worst anyhow, and have nothing to update.)
              if (effects.throws_ && func->effects) {
                func->effects->throws_ = true;
              }
            }
          }
        };
        CallScanner scanner(module, passOptions, funcInfo, func);
        scanner.walkFunction(func);
      }
    });

  return std::move(analysis.map);
}

std::unordered_map<Function*, std::unordered_set<Function*>>
buildCallGraph(const Module& module,
               const std::map<Function*, FuncInfo>& funcInfos) {
  std::unordered_map<Function*, std::unordered_set<Function*>> callGraph;
  for (const auto& [func, info] : funcInfos) {
    for (Name callee : info.calledFunctions) {
      callGraph[func].insert(module.getFunction(callee));
    }
  }

  return callGraph;
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
void propagateEffects(
  const Module& module,
  const PassOptions& passOptions,
  std::map<Function*, FuncInfo>& funcInfos,
  const std::unordered_map<Function*, std::unordered_set<Function*>>
    callGraph) {
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

  std::unordered_map<Function*, int> sccMembers;
  std::unordered_map<int, std::shared_ptr<EffectAnalyzer>> componentEffects;

  int ccIndex = 0;
  for (auto ccIterator : sccs) {
    ccIndex++;
    std::shared_ptr<EffectAnalyzer>& ccEffects = componentEffects[ccIndex];
    std::vector<Function*> ccFuncs(ccIterator.begin(), ccIterator.end());

    ccEffects = std::make_shared<EffectAnalyzer>(passOptions, module);

    for (Function* f : ccFuncs) {
      sccMembers.emplace(f, ccIndex);
    }

    std::unordered_set<int> calleeSccs;
    for (Function* caller : ccFuncs) {
      auto callees = callGraph.find(caller);
      if (callees == callGraph.end()) {
        continue;
      }
      for (auto* callee : callees->second) {
        calleeSccs.insert(sccMembers.at(callee));
      }
    }

    // Merge in effects from callees
    for (int calleeScc : calleeSccs) {
      const auto& calleeComponentEffects = componentEffects.at(calleeScc);
      if (calleeComponentEffects == nullptr) {
        ccEffects.reset();
        break;
      }

      else if (ccEffects != nullptr) {
        ccEffects->mergeIn(*calleeComponentEffects);
      }
    }

    // Add trap effects for potential cycles.
    if (ccFuncs.size() > 1) {
      if (ccEffects != nullptr) {
        ccEffects->trap = true;
      }
    } else {
      auto* func = ccFuncs[0];
      if (funcInfos.at(func).calledFunctions.contains(func->name)) {
        if (ccEffects != nullptr) {
          ccEffects->trap = true;
        }
      }
    }

    // Aggregate effects within this CC
    if (ccEffects) {
      for (Function* f : ccFuncs) {
        const auto& effects = f->effects;
        if (effects == nullptr) {
          ccEffects.reset();
          break;
        }

        ccEffects->mergeIn(*effects);
      }
    }

    // Assign each function's effects to its CC effects.
    for (Function* f : ccFuncs) {
      f->effects = ccEffects;
    }
  }
}

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    std::map<Function*, FuncInfo> funcInfos =
      analyzeFuncs(*module, getPassOptions());

    auto callGraph = buildCallGraph(*module, funcInfos);

    propagateEffects(*module, getPassOptions(), funcInfos, callGraph);
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
