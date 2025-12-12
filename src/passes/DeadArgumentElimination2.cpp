/*
 * Copyright 2025 WebAssembly Community Group participants
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

// As a POC, only do the backward analyis to find unused parameters, including
// those that appear to be used because they are forwarded on to another call
// but are then unused by that call.
//
// To match and exceed the power of DAE, we will need to extend this backward
// analysis to find unused results as well, and also add a forward analysis that
// propagates constants and types through parameters and results.

#include <memory>
#include <unordered_map>
#include <vector>

#include "analysis/lattices/bool.h"
#include "ir/local-graph.h"
#include "pass.h"
#include "support/index.h"
#include "support/utilities.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// Analysis lattice: top/true = used, bot/false = unused.
using Used = analysis::Bool;

// Function index and parameter index.
using ParamLoc = std::pair<Index, Index>;

// A set of (source, destination) index pairs for parameters of a caller
// function being forwarded as arguments to a called function.
using ForwardedParamSet = std::unordered_set<std::pair<Index, Index>>;

struct FunctionInfo {
  // Analysis results.
  // TODO: Fix Bool to wrap its element in a struct so we can store it directly
  // in a vector without getting the bool overload.
  std::vector<std::tuple<Used::Element>> paramUsages;

  // Map callee function names to their forwarded params for direct calls.
  std::unordered_map<Name, ForwardedParamSet> directForwardedParams;

  // Map callee types to their forwarded params for indirect calls.
  std::unordered_map<HeapType, ForwardedParamSet> indirectForwardedParams;

  // For each parameter of this function, the list of parameters in direct
  // callers that will become used if the parameter in this function turns out
  // to be used. Computed by reversing the directForwardedParams graph.
  std::vector<std::vector<ParamLoc>> callerParams;

  // Whether we need to additionally propagate param usage to indirect callers
  // of this function's type. Atomic because it can be set when visiting other
  // functions in parallel.
  std::atomic<bool> referenced = false;
};

struct GraphBuilder : public WalkerPass<ExpressionStackWalker<GraphBuilder>> {
  // Analysis lattice.
  const Used& used;

  // The function info graph is stored as vectors accessed by function index.
  // Map function names to their indices.
  const std::unordered_map<Name, Index>& funcIndices;

  // Vector of analysis info representing the analysis graph we are building.
  // This is populated safely in parallel because the visitor for each function
  // only modifies the entry for that function.
  std::vector<FunctionInfo>& funcInfos;

  // The index of the function we are currently walking.
  Index index = -1;

  // A use of a parameter local does not necessarily imply the use of the
  // parameter value. We use a local graph to check where parameter values may
  // be used.
  std::optional<LazyLocalGraph> localGraph;

  GraphBuilder(const Used& used,
               const std::unordered_map<Name, Index>& funcIndices,
               std::vector<FunctionInfo>& funcInfos)
    : used(used), funcIndices(funcIndices), funcInfos(funcInfos) {}

  bool isFunctionParallel() override { return true; }
  bool modifiesBinaryenIR() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<GraphBuilder>(used, funcIndices, funcInfos);
  }

  void runOnFunction(Module* wasm, Function* func) override {
    assert(index == Index(-1));
    index = funcIndices.at(func->name);
    assert(index < funcInfos.size());
    if (func->imported()) {
      // We must assume imported functions use all their parameters.
      auto& usages = funcInfos[index].paramUsages;
      assert(usages.empty());
      usages.insert(usages.end(), func->getNumParams(), used.getTop());
    } else {
      localGraph.emplace(func);
      using Super = WalkerPass<ExpressionStackWalker<GraphBuilder>>;
      Super::runOnFunction(wasm, func);
    }
  }

  void visitRefFunc(RefFunc* curr) {
    funcInfos[funcIndices.at(curr->func)].referenced = true;
  }

  Index getArgIndex(const ExpressionList& operands, Expression* arg) {
    for (Index i = 0; i < operands.size(); ++i) {
      if (operands[i] == arg) {
        return i;
      }
    }
    WASM_UNREACHABLE("expected arg");
  }

  void handleDirectForwardedParam(LocalGet* curr, Call* call) {
    auto argIndex = getArgIndex(call->operands, curr);
    auto& forwarded = funcInfos[index].directForwardedParams[call->target];
    forwarded.insert({curr->index, argIndex});
  }

  void handleIndirectForwardedParam(LocalGet* curr,
                                    const ExpressionList& operands,
                                    HeapType type) {
    auto argIndex = getArgIndex(operands, curr);
    auto& forwarded = funcInfos[index].indirectForwardedParams[type];
    forwarded.insert({curr->index, argIndex});
  }

  void visitLocalGet(LocalGet* curr) {
    if (curr->index >= getFunction()->getNumParams()) {
      // Not a parameter.
      return;
    }

    const auto& sets = localGraph->getSets(curr);
    bool usesParam = std::any_of(
      sets.begin(), sets.end(), [](LocalSet* set) { return set == nullptr; });

    if (!usesParam) {
      // The original parameter value does not reach here.
      return;
    }

    auto* parent = getParent();
    if (auto* call = parent->dynCast<Call>()) {
      handleDirectForwardedParam(curr, call);
    } else if (auto* call = parent->dynCast<CallIndirect>()) {
      handleIndirectForwardedParam(curr, call->operands, call->heapType);
    } else if (auto* call = parent->dynCast<CallRef>()) {
      if (!call->target->type.isSignature()) {
        // The call will never happen, so we don't need to consider it.
        return;
      }
      auto heapType = call->target->type.getHeapType();
      handleIndirectForwardedParam(curr, call->operands, heapType);
    } else {
      // The parameter value is used by something other than a call. We could
      // check whether the user is a drop, but for simplicity we assume that
      // Vacuum would have already removed such patterns.
      funcInfos[index].paramUsages[curr->index] = used.getTop();
    }
  }
};

struct DAE2 : public Pass {
  // Analysis lattice.
  Used used;

  // Map function name to index.
  std::unordered_map<Name, Index> funcIndices;

  // The intermediate and final analysis results by function index.
  std::vector<FunctionInfo> funcInfos;

  // For each parameter in each indirectly called type, the set of forwarded
  // params in the callers that need to be marked used if a param of a callee of
  // that type is used.
  std::unordered_map<HeapType, std::vector<std::vector<ParamLoc>>>
    indirectCallerParams;

  Module* wasm = nullptr;

  void run(Module* wasm) override {
    this->wasm = wasm;
    for (auto& func : wasm->functions) {
      funcIndices.insert({func->name, funcIndices.size()});
    }
    analyzeModule(wasm);
    prepareAnalysis();
    computeFixedPoint();
    optimize();
  }

  void analyzeModule(Module* wasm) {
    funcInfos.resize(wasm->functions.size());

    // Analyze functions to find forwarded and used parameters as well as
    // function references.
    GraphBuilder builder(used, funcIndices, funcInfos);
    builder.run(getPassRunner(), wasm);

    // Find additional function references at the module level.
    builder.walkModuleCode(wasm);

    // Mark parameters of exported functions as used.
    for (auto& export_ : wasm->exports) {
      if (export_->kind == ExternalKind::Function) {
        auto name = *export_->getInternalName();
        auto& usages = funcInfos[funcIndices.at(name)].paramUsages;
        std::fill(usages.begin(), usages.end(), used.getTop());
      }
    }

    // TODO: Find function types that escape the module beyond exported
    // functions (or just use all public function types as a conservative
    // approximation) and mark parameters of referenced funtions of those types
    // as used.
  }

  void prepareAnalysis() {
    // Compute the reverse graph used by the fixed point analysis from the
    // forward graph we have built.
    for (Index i = 0; i < funcInfos.size(); ++i) {
      funcInfos[i].callerParams.resize(funcInfos[i].paramUsages.size());
    }
    for (Index callerIndex = 0; callerIndex < funcInfos.size(); ++callerIndex) {
      for (auto& [callee, forwarded] :
           funcInfos[callerIndex].directForwardedParams) {
        auto& callerParams = funcInfos[funcIndices.at(callee)].callerParams;
        for (auto& [srcParam, destParam] : forwarded) {
          callerParams[destParam].push_back({callerIndex, srcParam});
        }
      }
      for (auto& [calleeType, forwarded] :
           funcInfos[callerIndex].indirectForwardedParams) {
        auto& callerParams = indirectCallerParams[calleeType];
        callerParams.resize(funcInfos[callerIndex].paramUsages.size());
        for (auto& [srcParam, destParam] : forwarded) {
          callerParams[destParam].push_back({callerIndex, srcParam});
        }
      }
    }
  }

  bool join(ParamLoc loc, const Used::Element& other) {
    auto& elem = std::get<0>(funcInfos[loc.first].paramUsages[loc.second]);
    return used.join(elem, other);
  }

  void computeFixedPoint() {
    // List of params from which we may need to propagate usage information.
    // Initialized with all params we have observed to be used in the IR.
    std::vector<ParamLoc> work;
    for (Index i = 0; i < funcInfos.size(); ++i) {
      for (Index j = 0; j < funcInfos[i].paramUsages.size(); ++j) {
        work.push_back({i, j});
      }
    }
    while (!work.empty()) {
      auto [calleeIndex, calleeParamIndex] = work.back();
      work.pop_back();

      const auto& elem =
        std::get<0>(funcInfos[calleeIndex].paramUsages[calleeParamIndex]);
      assert(elem && "unexpected unused param");

      // Propagate back to forwarded params of direct callers.
      auto& callerParams =
        funcInfos[calleeIndex].callerParams[calleeParamIndex];
      for (auto param : callerParams) {
        if (join(param, elem)) {
          work.push_back(param);
        }
      }

      if (!funcInfos[calleeIndex].referenced) {
        // Non-referenced functions can only be called directly.
        continue;
      }

      // Propagate usage back to forwarded params of the indirect callers of all
      // supertypes of this function's type.
      for (std::optional<HeapType> type =
             wasm->functions[calleeIndex]->type.getHeapType();
           type;
           type = type->getDeclaredSuperType()) {
        auto it = indirectCallerParams.find(*type);
        if (it == indirectCallerParams.end()) {
          continue;
        }
        auto& callerParams = it->second[calleeParamIndex];
        for (auto param : callerParams) {
          if (join(param, elem)) {
            work.push_back(param);
          }
        }
      }

      // TODO: Propagate usage to all functions of any type in the type tree of
      // this function's type to keep subtyping valid.
    }
  }

  void optimize() {
    struct Optimizer : public WalkerPass<PostWalker<Optimizer>> {
      // TODO: Visit functions in parallel, replacing unused parameters with
      // locals. Direct calls should look at their target to determine which
      // operands to remove (being sure to preserve side effects using
      // ChildLocalizer). Indirect calls need to look at the analysis results
      // for the target type (TODO: materialize this, possibly just for the root
      // type for each type tree) to determine what operands to remove.
    };
    Optimizer{}.run(getPassRunner(), wasm);
  }
};

} // anonymous namespace

Pass* createDAE2Pass() { return new DAE2(); }

} // namespace wasm
