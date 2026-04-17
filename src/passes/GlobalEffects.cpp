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

#include <ranges>

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

  // Types that are targets of indirect calls.
  std::unordered_set<HeapType> indirectCalledTypes;
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
            } else if (effects.calls && options.closedWorld) {
              HeapType type;
              if (auto* callRef = curr->dynCast<CallRef>()) {
                // call_ref on unreachable does not have a call effect,
                // so this must be a HeapType.
                type = callRef->target->type.getHeapType();
              } else if (auto* callIndirect = curr->dynCast<CallIndirect>()) {
                type = callIndirect->heapType;
              } else {
                WASM_UNREACHABLE("Unexpected call type");
              }

              funcInfo.indirectCalledTypes.insert(type);
            } else if (effects.calls) {
              assert(!options.closedWorld);
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

using CallGraphNode = std::variant<Function*, HeapType>;

/*
 Call graph for indirect and direct calls.

 key (caller) -> value (callee)
 Function  -> Function : direct call
 Function  -> HeapType : indirect call to the given HeapType
 HeapType  -> Function : The function `callee` has the type `caller`. The
                         HeapType may essentially 'call' any of its
                         potential implementations.
 HeapType  -> HeapType : `callee` is a subtype of `caller`. A call_ref
                         could target any subtype of the ref, so we need to
                         aggregate effects of subtypes of the target type.

 If we're running in an open world, we only include Function -> Function edges,
 and don't compute effects for indirect calls, conservatively assuming the
 worst.
*/
using CallGraph =
  std::unordered_map<CallGraphNode, std::unordered_set<CallGraphNode>>;

CallGraph buildCallGraph(const Module& module,
                         const std::map<Function*, FuncInfo>& funcInfos,
                         bool closedWorld) {
  CallGraph callGraph;

  std::unordered_set<HeapType> allFunctionTypes;
  for (const auto& [caller, callerInfo] : funcInfos) {
    auto& callees = callGraph[caller];

    // Function -> Function
    for (Name calleeFunction : callerInfo.calledFunctions) {
      callees.insert(module.getFunction(calleeFunction));
    }

    if (!closedWorld) {
      continue;
    }

    // Function -> Type
    allFunctionTypes.insert(caller->type.getHeapType());
    for (HeapType calleeType : callerInfo.indirectCalledTypes) {
      callees.insert(calleeType);
      allFunctionTypes.insert(calleeType);
    }

    // Type -> Function
    callGraph[caller->type.getHeapType()].insert(caller);
  }

  // Type -> Type
  for (HeapType type : allFunctionTypes) {
    // Not needed except that during lookup we expect the key to exist.
    callGraph[type];

    for (auto super = type.getDeclaredSuperType(); super;
         super = super->getDeclaredSuperType()) {
      // Don't bother noting supertypes with no functions in it. There are no
      // effects to aggregate anyway.
      if (allFunctionTypes.contains(*super)) {
        callGraph[*super].insert(type);
      }
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

template<std::ranges::common_range Range>
  requires std::same_as<std::ranges::range_value_t<Range>, CallGraphNode>
struct CallGraphSCCs
  : SCCs<std::ranges::iterator_t<Range>, CallGraphSCCs<Range>> {
  const std::map<Function*, FuncInfo>& funcInfos;
  const CallGraph& callGraph;
  const Module& module;

  CallGraphSCCs(
    Range&& nodes,
    const std::map<Function*, FuncInfo>& funcInfos,
    const std::unordered_map<CallGraphNode, std::unordered_set<CallGraphNode>>&
      callGraph,
    const Module& module)
    : SCCs<std::ranges::iterator_t<Range>, CallGraphSCCs<Range>>(
        std::ranges::begin(nodes), std::ranges::end(nodes)),
      funcInfos(funcInfos), callGraph(callGraph), module(module) {}

  void pushChildren(CallGraphNode node) {
    for (CallGraphNode callee : callGraph.at(node)) {
      this->push(callee);
    }
  }
};

// Explicit deduction guide to resolve -Wctad-maybe-unsupported
template<std::ranges::common_range Range>
CallGraphSCCs(
  Range&&,
  const std::map<Function*, FuncInfo>&,
  const std::unordered_map<CallGraphNode, std::unordered_set<CallGraphNode>>&,
  const Module&) -> CallGraphSCCs<Range>;

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
  // We only care about Functions that are roots, not types.
  // A type would be a root if a function exists with that type, but no-one
  // indirect calls the type.
  auto funcNodes = std::views::keys(callGraph) |
                   std::views::filter([](auto node) {
                     return std::holds_alternative<Function*>(node);
                   }) |
                   std::views::common;
  CallGraphSCCs sccs(std::move(funcNodes), funcInfos, callGraph, module);

  std::vector<std::optional<EffectAnalyzer>> componentEffects;
  // Points to an index in componentEffects
  std::unordered_map<CallGraphNode, Index> nodeComponents;

  for (auto ccIterator : sccs) {
    std::optional<EffectAnalyzer>& ccEffects =
      componentEffects.emplace_back(std::in_place, passOptions, module);
    std::vector<CallGraphNode> cc(ccIterator.begin(), ccIterator.end());

    std::vector<Function*> ccFuncs;
    for (CallGraphNode node : cc) {
      nodeComponents.emplace(node, componentEffects.size() - 1);
      if (auto** func = std::get_if<Function*>(&node)) {
        ccFuncs.push_back(*func);
      }
    }

    std::unordered_set<int> calleeSccs;
    for (CallGraphNode caller : cc) {
      for (CallGraphNode callee : callGraph.at(caller)) {
        calleeSccs.insert(nodeComponents.at(callee));
      }
    }

    // Merge in effects from callees
    for (int calleeScc : calleeSccs) {
      const auto& calleeComponentEffects = componentEffects.at(calleeScc);
      mergeMaybeEffects(ccEffects, calleeComponentEffects);
    }

    // Add trap effects for potential cycles.
    if (cc.size() > 1) {
      if (ccEffects != UnknownEffects) {
        ccEffects->trap = true;
      }
    } else if (ccFuncs.size() == 1) {
      // It's possible for a CC to only contain 1 type, but that is not a
      // cycle in the call graph.
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

    auto callGraph =
      buildCallGraph(*module, funcInfos, getPassOptions().closedWorld);

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
