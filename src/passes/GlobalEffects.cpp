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
#include "support/unique_deferring_queue.h"
#include "wasm.h"

namespace wasm {

namespace {

// template <std::derived_from<Named> T>
struct HashNamed {
  std::size_t operator()(const Named& named) const {
    return std::hash<Name>{}(named.name);
  }
};

struct EqNamed {
  bool operator()(const Named& a, const Named& b) const {
    return a.name == b.name;
  }
};

template<std::derived_from<Named> T>
using NamedSet = std::unordered_set<T, HashNamed, EqNamed>;

struct FuncInfo {
  // Effects in this function.
  std::optional<EffectAnalyzer> effects;

  // Directly-called functions from this function.
  std::unordered_set<Name> calledFunctions;

  // std::unordered_set<HeapType> indirectCalledTypes;
};

// struct FuncTypeInfo {
//   // not sure if we want this. It won't include indirect calls at first
//   std::optional<EffectAnalyzer> effects;

//   std::unordered_set<>
// };

// TODO: private method to avoid module param?
// Or store Functions in funcInfos instead of Names
std::unordered_map<Name, std::unordered_set<Name>>
transitiveCallers(Module& module, std::map<Function*, FuncInfo> funcInfos) {
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
    auto& calledInfo = funcInfos[module.getFunction(called)];
    for (auto calledByCalled : calledInfo.calledFunctions) {
      if (!callers[calledByCalled].contains(caller)) {
        work.push({caller, calledByCalled});
      }
    }
  }

  return callers;
}

struct GenerateGlobalEffects : public Pass {
  void run(Module* module) override {
    // First, we do a scan of each function to see what effects they have,
    // including which functions they call directly (so that we can compute
    // transitive effects later).

    // indirect calls that directly appear in the given type.
    // Later we will compute a transitive closure of this.

    std::unordered_map<Name, std::unordered_set<HeapType>> indirectCallTypes;

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
            std::unordered_map<Name, std::unordered_set<HeapType>>&
              indirectCallTypes;

            CallScanner(Module& wasm,
                        PassOptions& options,
                        FuncInfo& funcInfo,
                        std::unordered_map<Name, std::unordered_set<HeapType>>&
                          indirectCallTypes)
              : wasm(wasm), options(options), funcInfo(funcInfo),
                indirectCallTypes(indirectCallTypes) {}

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

                indirectCallTypes[getFunction()->name].insert(type);
                // TODO
                // callersForIndirectType[getFunction()->type.getHeapType()].insert(
                //   *function);
                // callersForIndirectType[getFunction()->type.getHeapType()].insert(
                //   *function);
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
          CallScanner scanner(
            *module, getPassOptions(), funcInfo, indirectCallTypes);
          scanner.walkFunction(func);
        }
      });

    // Compute the transitive closure of effects. To do so, first construct for
    // each function a list of the functions that it is called by (so we need to
    // propogate its effects to them), and then we'll construct the closure of
    // that.
    //
    // callers[foo] = [func that calls foo, another func that calls foo, ..]
    //
    auto callers = transitiveCallers(*module, analysis.map);

    std::unordered_map<HeapType, std::unordered_set<Name>> functionsWithType;
    for (auto& func : module->functions) {
      functionsWithType[func->type.getHeapType()].insert(func->name);
    }

    // Like above, for a function of a given type, what are the functions that
    // may end up (transitively) calling it?
    // TODO

    // auto indirectCallers = transitiveCallers(*module)
    std::unordered_map<Name, std::unordered_set<Name>> transitiveIndirectCalls;
    for (auto& [caller, calleeTypes] : indirectCallTypes) {
      for (auto calleeType : calleeTypes) {
        for (auto function : functionsWithType[calleeType]) {
          transitiveIndirectCalls[caller].insert(function);
        }
        // transitiveIndirectCallTypes[callee.type.getHeapType()].insert(caller);
      }
    }

    std::unordered_map<Name, std::unordered_set<Name>>
      transitiveIndirectCallees;
    for (auto& [caller, callees] : transitiveIndirectCalls) {
      for (auto callee : callees) {
        transitiveIndirectCallees[callee].insert(caller);
      }
    }

    // Now that we have transitively propagated all static calls, apply that
    // information. First, apply infinite recursion: if a function can call
    // itself then it might recurse infinitely, which we consider an effect (a
    // trap).
    for (auto& [func, info] : analysis.map) {
      if (callers[func->name].contains(func->name)) {
        if (info.effects) {
          info.effects->trap = true;
        }
      }
    }

    // Next, apply function effects to their callers.
    for (auto& [func, info] : analysis.map) {
      auto& funcEffects = info.effects;

      for (auto& caller : callers[func->name]) {
        auto& callerEffects = analysis.map[module->getFunction(caller)].effects;
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

      // const auto& calleeTypes =
      //   transitiveIndirectCallTypes[module->getFunction(func->name)
      //                                 ->type.getHeapType()];
      // We don't know effects for imports?
      // TODO: double-check on how this should be handled

      // Also, this is maybe too conservative. We might add effects to functions
      // that don't indirect call at all! They might just happen to share a type
      // with another function that does indirect call. I think we can just
      // change some of the usages of HeapType to Name and it will work out.

      // std::cout << "func type " << func->type << "\n";
      // for (const HeapType calleeType : calleeTypes) {
      //   std::cout << "calleeType " << calleeType << "\n";
      //   ModuleUtils::iterDefinedFunctions(*module, [&](Function*
      //   indirectCallee) {
      //     if (HeapType::isSubType(indirectCallee->type.getHeapType(),
      //     calleeType)) {
      //       if (!funcEffects) analysis.map[func].effects.reset();
      //       if (!analysis.map[func].effects || !funcEffects) return;
      //       // if (!indirectCallee->effects) return;

      //       // analysis.map[func].effects->mergeIn(*funcEffects);
      //       if (!indirectCallee->effects) return;
      //       analysis.map[func].effects->mergeIn(*indirectCallee->effects);
      //     }
      //   });
      // }

      for (auto caller : transitiveIndirectCallees[func->name]) {
        auto& callerEffects = analysis.map[module->getFunction(caller)].effects;
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
    for (auto& [func, info] : analysis.map) {
      func->effects.reset();
      if (!info.effects) {
        continue;
      }

      func->effects = std::make_shared<EffectAnalyzer>(*info.effects);
      std::cout << "Effects " << func->name << " " << *func->effects << "\n";
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
