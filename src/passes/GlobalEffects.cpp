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
#include "ir/subtypes.h"
#include "pass.h"
#include "support/graph_traversal.h"
#include "support/strongly_connected_components.h"
#include "support/utilities.h"
#include "wasm.h"

namespace wasm {

namespace {

struct FuncInfo {
  // Effects in this function. nullopt means that we don't know what effects
  // this function has, so we conservatively assume all effects.
  // Nullopt cases won't be copied to Function::effects.
  std::optional<EffectAnalyzer> effects;

  // Directly-called functions from this function.
  std::unordered_set<Name> calledFunctions;

  // Types that are targets of indirect calls.
  std::unordered_set<std::pair<HeapType, Exactness>> indirectCalledTypes;
};

// Only funcs that are referenced may be the target of an indirect call. A
// function is referenced if:
// - It appears in a ref.func expression (this includes `elem` statements
// because of how our IR is represented).
// - It's exported, because it may flow back to us as a reference.
//
// If a function doesn't meet any of these criteria, it can't be the target of
// an indirect call and we don't need to include its effects in indirect calls.
std::unordered_set<Function*> getReferencedFuncs(Module& module,
                                                 PassRunner& passRunner) {
  struct AddressedFuncsWalker : WalkerPass<PostWalker<AddressedFuncsWalker>> {
    // For each function, which functions are referenced in its body.
    // The key for `nullptr` contains references that are not in a function
    // (e.g. `elem` segments).
    std::unordered_map<Function*, std::unordered_set<Function*>>&
      allReferencedFuncs;
    // Points to `allReferencedFuncs`.
    std::unordered_set<Function*>* referencedFuncs = nullptr;

    AddressedFuncsWalker(
      std::unordered_map<Function*, std::unordered_set<Function*>>&
        allReferencedFuncs)
      : allReferencedFuncs(allReferencedFuncs),
        referencedFuncs(&allReferencedFuncs[nullptr]) {}

    std::unique_ptr<Pass> create() override {
      return std::make_unique<AddressedFuncsWalker>(allReferencedFuncs);
    }

    bool isFunctionParallel() override { return true; }

    bool modifiesBinaryenIR() override { return false; }

    void doWalkFunction(Function* func) {
      referencedFuncs = &allReferencedFuncs.at(func);
      walk(func->body);
    }

    void visitRefFunc(RefFunc* refFunc) {
      referencedFuncs->insert(getModule()->getFunction(refFunc->func));
    }
  };

  std::unordered_map<Function*, std::unordered_set<Function*>>
    allReferencedFuncs;
  for (auto& func : module.functions) {
    allReferencedFuncs[func.get()];
  }

  AddressedFuncsWalker walker(allReferencedFuncs);
  walker.run(&passRunner, &module);
  walker.runOnModuleCode(&passRunner, &module);

  std::unordered_set<Function*> mergedReferencedFuncs;
  for (auto& [_, referencedFuncs] : allReferencedFuncs) {
    mergedReferencedFuncs.merge(referencedFuncs);
  }

  for (const auto& export_ : module.exports) {
    if (export_->kind != ExternalKind::Function) {
      continue;
    }

    mergedReferencedFuncs.insert(
      module.getFunction(*export_->getInternalName()));
  }

  return mergedReferencedFuncs;
}

std::map<Function*, FuncInfo> analyzeFuncs(Module& module,
                                           const PassOptions& passOptions) {
  ModuleUtils::ParallelFunctionAnalysis<FuncInfo> analysis(
    module, [&](Function* func, FuncInfo& funcInfo) {
      if (func->imported()) {
        // Imports can do almost anything, so we need to assume the worst
        // anyhow, which is the same as not specifying any effects for them in
        // the map (which we do by not setting funcInfo.effects).
        //
        // TODO: We can be more precise here since imports can't mutate
        // globals/tables/memories that aren't imported or exported.
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
            } else if (effects.calls &&
                       options.worldMode == WorldMode::Closed) {
              std::pair<HeapType, Exactness> typeExact;
              if (auto* callRef = curr->dynCast<CallRef>()) {
                // call_ref on unreachable does not have a call effect,
                // so this must be a HeapType.
                typeExact = {callRef->target->type.getHeapType(),
                             callRef->target->type.getExactness()};
              } else if (auto* callIndirect = curr->dynCast<CallIndirect>()) {
                typeExact = {callIndirect->heapType, Inexact};
              } else {
                funcInfo.effects = std::nullopt;
                return;
              }

              funcInfo.indirectCalledTypes.insert(typeExact);
            } else if (effects.calls) {
              assert(options.worldMode == WorldMode::Open);
              funcInfo.effects = std::nullopt;
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

using CallGraphNode = std::variant<Function*, std::pair<HeapType, Exactness>>;

// Call graph for indirect and direct calls.
//
// key (caller) -> value (callee)
// Function  -> Function :
//   direct call
// Function  -> HeapType :
//   indirect call to the given HeapType (exact or inexact).
// HeapType  -> Function :
//   The function `callee` has the type `caller`. The HeapType may essentially
//   'call' any of its potential implementations. The HeapType is always Exact
//   for these edges.
// HeapType  -> HeapType :
//   `callee` is a subtype of `caller`. An indirect call with an Inexact type
//   could target any subtype of the ref, so we aggregate effects of subtypes of
//   the target type. If B is a subtype of A, then we have edges:
//     A (inexact) -> B (inexact)
//     A (inexact) -> A (exact)
//     B (inexact) -> B (exact)
//   As a result, calls to (inexact A) include B's effects, and calls to
//   (exact A) only include A's effects.
//
// If we're running in an open world, we only include Function -> Function
// edges, and don't compute effects for indirect calls, conservatively assuming
// the worst.
using CallGraph =
  std::unordered_map<CallGraphNode, std::unordered_set<CallGraphNode>>;

CallGraph buildCallGraph(const Module& module,
                         const std::map<Function*, FuncInfo>& funcInfos,
                         const std::unordered_set<Function*>& referencedFuncs,
                         WorldMode worldMode) {
  CallGraph callGraph;
  if (worldMode == WorldMode::Open) {
    for (const auto& [caller, callerInfo] : funcInfos) {
      auto& callees = callGraph[caller];

      // Function -> Function
      for (Name calleeFunction : callerInfo.calledFunctions) {
        callees.insert(module.getFunction(calleeFunction));
      }
    }

    return callGraph;
  }

  std::unordered_set<std::pair<HeapType, Exactness>> allFunctionTypes;
  for (const auto& [caller, callerInfo] : funcInfos) {
    auto& callees = callGraph[caller];

    // Function -> Function
    for (Name calleeFunction : callerInfo.calledFunctions) {
      callees.insert(module.getFunction(calleeFunction));
    }

    // Function -> Type
    allFunctionTypes.insert({caller->type.getHeapType(), Exact});
    for (auto calleeTypeExact : callerInfo.indirectCalledTypes) {
      callees.insert(calleeTypeExact);

      // Add the key to ensure the lookup doesn't fail for indirect calls to
      // uninhabited types.
      callGraph[calleeTypeExact];
      allFunctionTypes.insert(calleeTypeExact);
    }

    // Type -> Function
    if (referencedFuncs.contains(caller)) {
      callGraph[std::pair(caller->type.getHeapType(), Exact)].insert(caller);
    }
  }

  // Type -> Type
  // Do a DFS up the type hierarchy for all function implementations.
  // We are essentially walking up each supertype chain and adding edges from
  // super -> subtype, but doing it via DFS to avoid repeated work.
  Graph superTypeGraph(
    allFunctionTypes.begin(),
    allFunctionTypes.end(),
    [&callGraph](const auto& push,
                 std::pair<HeapType, Exactness> typeAndExactness) {
      // Not needed except that during lookup we expect the
      // key to exist.
      callGraph[typeAndExactness];

      auto [type, exactness] = typeAndExactness;

      // The supertype of an exact type is its inexact type.
      // The supertype of an inexact type is its normal inexact supertype.
      switch (exactness) {
        case Exact: {
          callGraph[std::pair(type, Inexact)].insert(typeAndExactness);
          push({type, Inexact});
          break;
        }
        case Inexact: {
          if (auto super = type.getDeclaredSuperType()) {
            callGraph[std::pair(*super, Inexact)].insert(typeAndExactness);
            push({*super, Inexact});
          }
          break;
        }
      }
    });
  (void)superTypeGraph.traverseDepthFirst();

  // Add Type -> Function edges to account for inexact imports. For (ref.func)
  // on a *defined* function, we know its exact type and can add a single
  // Type -> Function edge in the graph (done above). We know that indirect
  // calls to strict subtypes of the function can't reach the function.
  //
  // OTOH for inexactly imported functions, they may be downcasted to a subtype.
  // To account for this, add Type -> Function edges to all subtypes for
  // inexactly imported functions.
  SubTypes subtypes(module);
  ModuleUtils::iterImportedFunctions(module, [&](Function* func) {
    if (func->type.isExact()) {
      return;
    }
    if (!referencedFuncs.contains(func)) {
      return;
    }

    subtypes.iterSubTypes(func->type.getHeapType(), [&](auto subtype, int _) {
      // The import's effects must be included in both calls to its exact and
      // inexact subtypes. Adding an edge from the exact subtype is enough
      // because we propagate effects up the subtype chain and exact types are a
      // subtype of their inexact type.
      callGraph[std::pair(subtype, Exact)].insert(func);
      return true;
    });
  });

  return callGraph;
}

constexpr auto UnknownEffects = nullptr;

// Merges effects from another connected component (const EffectAnalyzer*) or a
// function (std::optional<EffectAnalyzer>&).
template<typename EffectAnalyzerPtr>
void mergeMaybeEffects(std::shared_ptr<EffectAnalyzer>& dest,
                       const EffectAnalyzerPtr& src) {
  if (dest == UnknownEffects) {
    return;
  }
  if (!src) {
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
void propagateEffects(
  const Module& module,
  const PassOptions& passOptions,
  std::map<Function*, FuncInfo>& funcInfos,
  std::unordered_map<std::pair<HeapType, Exactness>,
                     std::shared_ptr<const EffectAnalyzer>>& typeEffects,
  const CallGraph& callGraph) {
  // We only care about Functions that are roots, not types.
  // A type would be a root if a function exists with that type, but no-one
  // indirect calls the type.
  std::vector<CallGraphNode> funcNodes;
  for (const auto& [node, _] : callGraph) {
    if (std::holds_alternative<Function*>(node)) {
      funcNodes.push_back(node);
    }
  }

  struct CallGraphSCCs
    : SCCs<std::vector<CallGraphNode>::iterator, CallGraphSCCs> {

    const std::map<Function*, FuncInfo>& funcInfos;
    const CallGraph& callGraph;
    const Module& module;

    CallGraphSCCs(std::vector<CallGraphNode>& nodes,
                  const std::map<Function*, FuncInfo>& funcInfos,
                  const CallGraph& callGraph,
                  const Module& module)
      : SCCs<std::vector<CallGraphNode>::iterator, CallGraphSCCs>(nodes.begin(),
                                                                  nodes.end()),
        funcInfos(funcInfos), callGraph(callGraph), module(module) {}

    void pushChildren(CallGraphNode node) {
      for (CallGraphNode callee : callGraph.at(node)) {
        push(callee);
      }
    }
  };
  CallGraphSCCs sccs(funcNodes, funcInfos, callGraph, module);

  std::vector<std::shared_ptr<EffectAnalyzer>> componentEffects;
  // Points to an index in componentEffects
  std::unordered_map<CallGraphNode, Index> nodeComponents;

  for (auto ccIterator : sccs) {
    auto& ccEffects = componentEffects.emplace_back(
      std::make_shared<EffectAnalyzer>(passOptions, module));
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
      mergeMaybeEffects(ccEffects, calleeComponentEffects.get());
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
    } else if (ccFuncs.empty() && calleeSccs.empty()) {
      // This node came from an indirect call to an uninhabited type.
      // This CC must consist of exactly one type, because an uninhabited type
      // can't make any indirect calls to other types.
      //
      // Since the type is uninhabited, this call must trap.
      assert(cc.size() == 1);
      ccEffects->trap = true;
    }

    // Aggregate effects within this CC
    if (ccEffects) {
      for (Function* f : ccFuncs) {
        const auto& effects = funcInfos.at(f).effects;
        mergeMaybeEffects(ccEffects, effects);
      }
    }

    // Assign each function's effects to its CC effects.
    for (auto node : cc) {
      std::visit(overloaded{[&](std::pair<HeapType, Exactness> type) {
                              if (ccEffects != UnknownEffects) {
                                typeEffects[type] = ccEffects;
                              }
                            },
                            [&](Function* f) { f->effects = ccEffects; }},
                 node);
    }
  }
}

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    std::map<Function*, FuncInfo> funcInfos =
      analyzeFuncs(*module, getPassOptions());

    auto referencedFuncs = getReferencedFuncs(*module, *getPassRunner());

    auto callGraph = buildCallGraph(
      *module, funcInfos, referencedFuncs, getPassOptions().worldMode);

    propagateEffects(*module,
                     getPassOptions(),
                     funcInfos,
                     module->indirectCallEffects,
                     callGraph);
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
