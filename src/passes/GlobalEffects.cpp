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
#include "ir/subtypes.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm {
namespace {

struct FuncInfo {
  // Effects in this function.
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

  return analysis.map;
}

template <typename T>
std::unordered_map<T, std::unordered_set<T>> transitiveClosure2(const std::unordered_map<T, std::unordered_set<T>>& in) {
  UniqueNonrepeatingDeferredQueue<std::pair<T, T>> work;

  for (const auto& [curr, neighbors] : in) {
    for (const auto& neighbor : neighbors) {
      work.push({curr, neighbor});
    }
  }

  std::unordered_map<T, std::unordered_set<T>> closure;
  while (!work.empty()) {
    auto [curr, neighbor] = work.pop();

    closure[curr].insert(neighbor);

    auto neighborNeighbors = in.find(neighbor);
    if (neighborNeighbors == in.end()) continue;
    for (const auto& neighborNeighbor : neighborNeighbors->second) {
      work.push({curr, neighborNeighbor});
    }
  }

  return closure;
}

std::unordered_map<Name, std::unordered_set<Name>>
transitiveClosure(const Module& module,
                  const std::map<Function*, FuncInfo>& funcInfos) {
  // Compute the transitive closure of effects. To do so, first construct for
  // each function a list of the functions that it is called by (so we need to
  // propogate its effects to them), and then we'll construct the closure of
  // that.
  //
  // callers[foo] = [func that calls foo, another func that calls foo, ..]
  //
  std::unordered_map<Name, std::unordered_set<Name>> callers;

  // Our work queue contains info about a new call pair: a call from a caller
  // to a called function, that is information we then apply and propagate.
  using CallPair = std::pair<Name, Name>; // { caller, called }
  UniqueDeferredQueue<CallPair> work;
  for (auto& [func, info] : funcInfos) {
    for (auto& called : info.calledFunctions) {
      work.push({func->name, called});
    }
  }

  // Compute the transitive closure of the call graph, that is, fill out
  // |callers| so that it contains the list of all callers - even through a
  // chain - of each function.
  while (!work.empty()) {
    auto [caller, called] = work.pop();

    // We must not already have an entry for this call (that would imply we
    // are doing wasted work).
    assert(!callers[called].contains(caller));

    // Apply the new call information.
    callers[called].insert(caller);

    // We just learned that |caller| calls |called|. It also calls
    // transitively, which we need to propagate to all places unaware of that
    // information yet.
    //
    //   caller => called => called by called
    //
    auto it = funcInfos.find(module.getFunction(called));
    auto& calledInfo = it->second;
    // auto& calledInfo = funcInfos.at(module.getFunction(called));
    for (auto calledByCalled : calledInfo.calledFunctions) {
      if (!callers[calledByCalled].contains(caller)) {
        work.push({caller, calledByCalled});
      }
    }
  }

  return callers;
}

// std::unordered_map<Name, std::unordered_set<Name>> transitiveClosure(
//   const Module& module,
//   const std::unordered_map<Name, std::unordered_set<Name>>& funcInfos) {
//   auto transformed =
//     funcInfos | std::views::transform(
//                   [&](const auto& pair) -> std::pair<Function*, FuncInfo> {
//                     auto& [k, v] = pair;

//                     auto* func = module.getFunction(k);
//                     FuncInfo info;
//                     info.calledFunctions = v;
//                     return {func, info};
//                   });
//   std::map<Function*, FuncInfo> other(transformed.begin(), transformed.end());
//   return transitiveClosure(module, other);
// }

template <typename K, typename V>
std::unordered_map<V, std::unordered_set<K>> flip(const std::unordered_map<K, std::unordered_set<V>>& in) {
  std::unordered_map<V, std::unordered_set<K>> flipped;
  for (const auto& [k, vs] : in) {
    for (const auto& v : vs) {
      flipped[v].insert(k);
    }
  }
  return flipped;
}

// std::unordered_map<HeapType, std::unordered_set<Name>> 

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    // First, we do a scan of each function to see what effects they have,
    // including which functions they call directly (so that we can compute
    // transitive effects later).
    auto funcInfos = analyzeFuncs(*module, getPassOptions());

    // Find the 'entry points' of indirect calls Name -> HeapType.
    // At the same time, start recording connections for the transitive closure of indirect calls
    // HeapType -> HeapType. This will be used to find the set of HeapTypes that are reachable via any sequence of indirect calls from a given function
    // (Name -> HeapType)
    std::unordered_map<Name, std::unordered_set<HeapType>>
      indirectCallersNonTransitive;
    std::unordered_map<HeapType, std::unordered_set<HeapType>> indirectCalls;
    for (auto& [func, info] : funcInfos) {
      auto& set = indirectCallersNonTransitive[func->name];
      auto& indirectCallsSet = indirectCalls[func->type.getHeapType()];
      for (auto& calledType : info.indirectCalledTypes) {
          set.insert(calledType);
          indirectCallsSet.insert(calledType);
      }
    }

    // indirectCallers[foo] = [func that indirect calls something with the same
    // type as foo, ..]
    // const std::unordered_map<HeapType, std::unordered_set<Name>> indirectCallers =
    //   transitiveClosure(*module, indirectCallersNonTransitive);

    // TODO: need to take subtypes into account here
    // we can pretend that each type 'indirect calls' its subtypes
    // This is good enough because when querying the particular function Name that 
    // indirect calls someone we want to take its indirect calls into account anyway
    // So just pretend that it indirect calls its subtypes.

    SubTypes subtypes(*module);
    std::unordered_map<HeapType, std::unordered_set<HeapType>> subTypesToAdd;

    for (const auto& [type, _] : indirectCalls) {
      subtypes.iterSubTypes(type, [&subTypesToAdd, type](HeapType sub, int _) { subTypesToAdd[type].insert(sub); return true; });
    }

    for (const auto& [k, v] : subTypesToAdd) {
      auto it = indirectCalls.find(k);

      // No need to add this. It wasn't in the map because no function has this 
      // type, so there are no effects to aggregate and we can forget about it.
      if (it == indirectCalls.end()) continue;

      it->second.insert(v.begin(), v.end());
    }

    auto a = transitiveClosure2<HeapType>(indirectCalls);

    // Pretend that each subtype is indirect called by its supertype.
    // This might not be the case but it's accurate enough since any caller that
    // may indirect call a given type may also indirect call its subtype.
    for (const auto& [k, v]: indirectCallersNonTransitive) {
      for (const auto& x : v) {
        auto y = a[x];

        // we're leaving what was already there but should be fine
        // since it's covered under transitive calls anyway
        indirectCallersNonTransitive[k].insert(y.begin(), y.end());
      }
    }

    std::unordered_map<HeapType, std::unordered_set<Name>> flipped = flip(indirectCallersNonTransitive);

    // Compute the transitive closure of effects. To do so, first construct for
    // each function a list of the functions that it is called by (so we need to
    // propagate its effects to them), and then we'll construct the closure of
    // that.
    //
    // callers[foo] = [func that calls foo, another func that calls foo, ..]
    //
    std::unordered_map<Name, std::unordered_set<Name>> callers =
      transitiveClosure(*module, funcInfos);


    // Now that we have transitively propagated all static calls, apply that
    // information. First, apply infinite recursion: if a function can call
    // itself then it might recurse infinitely, which we consider an effect (a
    // trap).
    for (auto& [func, info] : funcInfos) {
      if (callers[func->name].contains(func->name)) {
        if (info.effects) {
          info.effects->trap = true;
        }
      }
    }

    // Next, apply function effects to their callers.
    for (auto& [func, info] : funcInfos) {
      auto& funcEffects = info.effects;

      for (const auto& caller : callers[func->name]) {
        auto& callerEffects = funcInfos[module->getFunction(caller)].effects;
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
        callerEffects->mergeIn(*funcEffects);
      }

      auto indirectCallersOfThisFunction = flipped.find(func->type.getHeapType());
      if (indirectCallersOfThisFunction == flipped.end()) {
        continue;
      }
      for (Name caller : indirectCallersOfThisFunction->second) {
        auto& callerEffects = funcInfos[module->getFunction(caller)].effects;
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
        callerEffects->mergeIn(*funcEffects);
      }
    }

    // Generate the final data, starting from a blank slate where nothing is
    // known.
    for (auto& [func, info] : funcInfos) {
      func->effects.reset();
      if (!info.effects) {
        continue;
      }

      std::cout << func->name << " has effects " << *info.effects << "\n";
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
