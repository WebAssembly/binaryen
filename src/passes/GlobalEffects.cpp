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
              // funcInfo.effects.reset();
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

std::unordered_map<HeapType, std::unordered_set<Name>>
typeToFunctionNames(const Module& module) {
  std::unordered_map<HeapType, std::unordered_set<Name>> ret;

  for (const auto& func : module.functions) {
    ret[func->type.getHeapType()].insert(func->name);
  }

  return ret;
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
    auto& calledInfo = funcInfos.at(module.getFunction(called));
    for (auto calledByCalled : calledInfo.calledFunctions) {
      if (!callers[calledByCalled].contains(caller)) {
        work.push({caller, calledByCalled});
      }
    }
  }

  return callers;
}

std::unordered_map<Name, std::unordered_set<Name>> transitiveClosure(
  const Module& module,
  const std::unordered_map<Name, std::unordered_set<Name>>& funcInfos) {
  std::map<Function*, FuncInfo> other;
  auto _ =
    funcInfos | std::views::transform(
                  [&](const auto& pair) -> std::pair<Function*, FuncInfo> {
                    auto& [k, v] = pair;

                    auto& func = module.getFunction(k);
                    FuncInfo info;
                    info.calledFunctions = v;
                    return {func->name, info};
                  });

  return transitiveClosure(module, other);
}

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    // First, we do a scan of each function to see what effects they have,
    // including which functions they call directly (so that we can compute
    // transitive effects later).
    auto funcInfos = analyzeFuncs(*module, getPassOptions());

    // Compute the transitive closure of effects. To do so, first construct for
    // each function a list of the functions that it is called by (so we need to
    // propagate its effects to them), and then we'll construct the closure of
    // that.
    //
    // callers[foo] = [func that calls foo, another func that calls foo, ..]
    //
    std::unordered_map<Name, std::unordered_set<Name>> callers =
      transitiveClosure(*module, funcInfos);

    const auto functionsWithType = typeToFunctionNames(*module);
    std::unordered_map<Name, std::unordered_set<Name>>
      indirectCallersNonTransitive;
    for (auto& [func, info] : funcInfos) {
      for (auto& calledType : info.indirectCalledTypes) {
        // auto asdf = functionsWithType.at(calledType);
        // auto foo = indirectCallersNonTransitive[func->name];
        // asdf.merge(foo);
        // foo.merge(asdf);

        if (auto it = functionsWithType.find(calledType);
            it != functionsWithType.end()) {
          indirectCallersNonTransitive[func->name].insert(it->second.begin(),
                                                          it->second.end());
        }
        // indirectCallersNonTransitive[func->name].merge(functionsWithType.at(calledType));
      }
      // for (const auto& name : functionsWitType[])
      // for ()
      // info.indirectCalledTypes[func->name]
    }

    // indirectCallers[foo] = [func that indirect calls something with the same
    // type as foo, ..]
    const std::unordered_map<Name, std::unordered_set<Name>> indirectCallers =
      transitiveClosure(*module, indirectCallersNonTransitive);

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

      auto indirectCallersOfThisFunction = indirectCallers.find(func->name);
      if (indirectCallersOfThisFunction == indirectCallers.end()) {
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
