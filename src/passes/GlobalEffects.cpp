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
// Handle the computation of global effects. The effects are stored on
// Function::effects; see more details there.
//

#include "ir/subtypes.h"
#include "ir/effects.h"
#include "ir/module-utils.h"
#include "pass.h"
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
            } else if (effects.calls) {
              HeapType type;
              if (auto* callRef = curr->dynCast<CallRef>()) {
                type = callRef->target->type.getHeapType();
              } else if (auto* callIndirect = curr->dynCast<CallIndirect>()) {
                type = callIndirect->heapType;
              } else {
                assert(false && "Unexpected type of call");
              }

              funcInfo.indirectCalledTypes.insert(type);
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

using CallGraphNode = std::variant<Name, HeapType>;

// Propagate effects from callees to callers transitively
// e.g. if A -> B -> C (A calls B which calls C)
// Then B inherits effects from C and A inherits effects from both B and C.
void propagateEffects(
  const Module& module,
  const std::unordered_map<CallGraphNode, std::unordered_set<CallGraphNode>>& reverseCallGraph,
  std::map<Function*, FuncInfo>& funcInfos) {

  using CallGraphEdge = std::pair<CallGraphNode, CallGraphNode>;
  UniqueNonrepeatingDeferredQueue<CallGraphEdge> work;

  for (const auto& [callee, callers] : reverseCallGraph) {
    for (const auto& caller : callers) {
      work.push(std::pair(callee, caller));
    }
  }

  auto propagate = [&](Name* callee, Name* caller) {
    if (callee == nullptr || caller == nullptr) {
      return;
    }

    auto& callerEffects = funcInfos.at(module.getFunction(*caller)).effects;
    const auto& calleeEffects =
      funcInfos.at(module.getFunction(*callee)).effects;
    if (callerEffects == UnknownEffects) {
      return;
    }

    if (calleeEffects == UnknownEffects) {
      callerEffects = UnknownEffects;
      return;
    }

    if (*callee == *caller) {
      callerEffects->trap = true;
    } else {
      callerEffects->mergeIn(*calleeEffects);
    }
  };

  while (!work.empty()) {
    auto [callee, caller] = work.pop();

    if (std::get_if<Name>(&callee) == std::get_if<Name>(&caller) && std::holds_alternative<Name>(callee)) {
      auto& callerEffects = funcInfos.at(module.getFunction(std::get<Name>(caller))).effects;
      if (callerEffects) {
        callerEffects->trap = true;
      }
    }

    // Even if nothing changed, we still need to keep traversing the callers
    // to look for a potential cycle which adds a trap affect on the above
    // lines.
    propagate(std::get_if<Name>(&callee), std::get_if<Name>(&caller));

    const auto& callerCallers = reverseCallGraph.find(caller);
    if (callerCallers == reverseCallGraph.end()) {
      continue;
    }

    for (const CallGraphNode& callerCaller : callerCallers->second) {
      work.push(std::pair(callee, callerCaller));
    }
  }
}

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    std::map<Function*, FuncInfo> funcInfos =
      analyzeFuncs(*module, getPassOptions());

    // callee : caller
    std::unordered_map<CallGraphNode, std::unordered_set<CallGraphNode>> callers;

    std::unordered_set<HeapType> allIndirectCalledTypes;
    for (const auto& [func, info] : funcInfos) {
      // Name -> Name for direct calls
      for (const auto& callee : info.calledFunctions) {
        callers[callee].insert(func->name);
      }

      // HeapType -> Name for indirect calls
      for (const auto& calleeType : info.indirectCalledTypes) {
        callers[calleeType].insert(func->name);
      }

      // Name -> HeapType for function types
      callers[func->name].insert(func->type.getHeapType());

      allIndirectCalledTypes.insert(func->type.getHeapType());
    }

    SubTypes subtypes(*module);
    for (auto type : allIndirectCalledTypes) {
      subtypes.iterSubTypes(type, [&callers, type](HeapType sub, int _) {
        // HeapType -> HeapType
        // A subtype is a 'callee' of its supertype. Supertypes need to inherit effects from their subtypes
        // See the example in (TODO)
        callers[sub].insert(type);
        return true;
      });
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
