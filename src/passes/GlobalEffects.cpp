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
#include "support/graph_traversal.h"
#include "support/strongly_connected_components.h"
#include "support/utilities.h"
#include "wasm.h"

#include <iostream>
#include <sstream>

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
            } else if (effects.calls &&
                       options.worldMode == WorldMode::Closed) {
              HeapType type;
              if (auto* callRef = curr->dynCast<CallRef>()) {
                // call_ref on unreachable does not have a call effect,
                // so this must be a HeapType.
                type = callRef->target->type.getHeapType();
              } else if (auto* callIndirect = curr->dynCast<CallIndirect>()) {
                type = callIndirect->heapType;
              } else {
                funcInfo.effects = std::nullopt;
                return;
              }

              funcInfo.indirectCalledTypes.insert(type);
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

using CallGraphNode = std::variant<Function*, HeapType>;

// Call graph for indirect and direct calls.
//
// key (caller) -> value (callee)
// Function  -> Function : direct call
// Function  -> HeapType : indirect call to the given HeapType
// HeapType  -> Function : The function `callee` has the type `caller`. The
//                         HeapType may essentially 'call' any of its
//                         potential implementations.
// HeapType  -> HeapType : `callee` is a subtype of `caller`. A call_ref
//                         could target any subtype of the ref, so we need to
//                         aggregate effects of subtypes of the target type.
//
// If we're running in an open world, we only include Function -> Function
// edges, and don't compute effects for indirect calls, conservatively assuming
// the worst.
using CallGraph =
  std::unordered_map<CallGraphNode, std::unordered_set<CallGraphNode>>;

CallGraph buildCallGraph(const Module& module,
                         const std::map<Function*, FuncInfo>& funcInfos,
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

  std::unordered_set<HeapType> allFunctionTypes;
  for (const auto& [caller, callerInfo] : funcInfos) {
    auto& callees = callGraph[caller];

    // Function -> Function
    for (Name calleeFunction : callerInfo.calledFunctions) {
      callees.insert(module.getFunction(calleeFunction));
    }

    // Function -> Type
    allFunctionTypes.insert(caller->type.getHeapType());
    for (HeapType calleeType : callerInfo.indirectCalledTypes) {
      callees.insert(calleeType);

      // Add the key to ensure the lookup doesn't fail for indirect calls to
      // uninhabited types.
      callGraph[calleeType];
    }

    // Type -> Function
    callGraph[caller->type.getHeapType()].insert(caller);
  }

  // Type -> Type
  // Do a DFS up the type heirarchy for all function implementations.
  // We are essentially walking up each supertype chain and adding edges from
  // super -> subtype, but doing it via DFS to avoid repeated work.
  Graph superTypeGraph(allFunctionTypes.begin(),
                       allFunctionTypes.end(),
                       [&callGraph](auto&& push, HeapType t) {
                         // Not needed except that during lookup we expect the
                         // key to exist.
                         callGraph[t];

                         if (auto super = t.getDeclaredSuperType()) {
                           callGraph[*super].insert(t);
                           push(*super);
                         }
                       });
  (void)superTypeGraph.traverseDepthFirst();

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
  std::unordered_map<HeapType, std::shared_ptr<const EffectAnalyzer>>&
    typeEffects,
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
      std::visit(overloaded{[&](HeapType type) {
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

    auto callGraph =
      buildCallGraph(*module, funcInfos, getPassOptions().worldMode);

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

struct GenerateCallGraph : public Pass {
  bool modifiesBinaryenIR() override { return false; }

  void run(Module* module) override {
    std::map<Function*, FuncInfo> funcInfos =
      analyzeFuncs(*module, getPassOptions());

    auto callGraph =
      buildCallGraph(*module, funcInfos, getPassOptions().worldMode);

    printCallGraph(callGraph, std::cout);
  }

  private:
  std::string nodeToString(const CallGraphNode& node) {
    return std::visit(
      overloaded{[](Function* func) { return func->name.toString(); },
                 [](HeapType type) {
                   std::stringstream ss;
                   ss << type;
                   return ss.str();
                 }},
      node);
  }

  void printCallGraph(const CallGraph& callGraph, std::ostream& o) {
    std::map<std::string, std::string> nodeTypes;
    std::map<std::string, std::map<std::string, std::string>> sortedGraph;

    auto getNodeType = [](const CallGraphNode& node) {
      return std::visit(overloaded{[](Function*) { return "function"; },
                                   [](HeapType) { return "type"; }},
                        node);
    };

    for (const auto& [caller, callees] : callGraph) {
      std::string callerName = nodeToString(caller);
      nodeTypes[callerName] = getNodeType(caller);

      for (const auto& callee : callees) {
        std::string calleeName = nodeToString(callee);
        nodeTypes[calleeName] = getNodeType(callee);

        std::string style = std::visit(
          overloaded{
            [](Function*, Function*) {
              return " [style=\"solid\", color=\"black\", kind=\"direct\"]";
            },
            [](Function*, HeapType) {
              return " [style=\"dotted\", color=\"black\", kind=\"indirect\"]";
            },
            [](HeapType, HeapType) {
              return " [style=\"solid\", color=\"blue\", kind=\"subtyping\"]";
            },
            [](HeapType, Function*) {
              return " [style=\"dashed\", color=\"green\", "
                     "kind=\"implementation\"]";
            }},
          caller,
          callee);

        sortedGraph[callerName][calleeName] = style;
      }
    }

    o << "digraph CallGraph {\n";
    for (const auto& [nodeName, nodeType] : nodeTypes) {
      o << "  \"" << nodeName << "\" [kind=\"" << nodeType << "\"];\n";
    }
    for (const auto& [callerName, callees] : sortedGraph) {
      for (const auto& [calleeName, style] : callees) {
        o << "  \"" << callerName << "\" -> \"" << calleeName << "\""
                  << style << ";\n";
      }
    }
    o << "}\n";
  }

};

} // namespace

Pass* createGenerateGlobalEffectsPass() { return new GenerateGlobalEffects(); }

Pass* createDiscardGlobalEffectsPass() { return new DiscardGlobalEffects(); }

Pass* createGenerateCallGraphPass() { return new GenerateCallGraph(); }

Pass* createPrintCallGraphPass() { return new GenerateCallGraph(); }

} // namespace wasm
