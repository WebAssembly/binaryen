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

// Perform dead argument elimination based on a smallest fixed point analysis of
// used parameters. Traverse the module once to collect call graph information,
// used parameters, and "forwarded" parameters that are only used by being
// forwarded on to other function calls. Parameters are forwarded if their
// local.gets are consumed as parameters to function calls or if they are
// consumed by other side-effect-free instructions that are transitively
// forwarded to function calls. These forwarded parameters (and their
// intermediate users) can still be optimized out as long as they are unused in
// the callees they are forwarded to. Since we perform a fixed point analysis,
// cycles of forwarded parameters can still be removed.
//
// After finding used parameters, traverse the module once more to remove
// unused parameters and arguments. Finally, if we are able to optimize indirect
// calls and referenced functions, traverse the module one last time to globally
// update referenced function types. This may require first giving unreferenced
// functions replacement types to make sure they are not incorrectly updated by
// the global type rewriting.
//
// As a POC, only do the backward analysis to find unused parameters. To match
// and exceed the power of DAE, we will need to extend this backward analysis to
// find unused results as well, and also add a forward analysis that propagates
// constants and types through parameters and results.

#include <algorithm>
#include <memory>
#include <unordered_map>
#include <vector>

#include "analysis/lattices/bool.h"
#include "ir/effects.h"
#include "ir/eh-utils.h"
#include "ir/intrinsics.h"
#include "ir/label-utils.h"
#include "ir/local-graph.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "support/index.h"
#include "support/mixed_arena.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm-type-shape.h"
#include "wasm-type.h"
#include "wasm.h"

#ifndef TIME_DAE
#define TIME_DAE 0
#endif

#ifndef DAE_STATS
#define DAE_STATS 0
#endif

#if TIME_DAE || DAE_STATS

#include <iostream>

#include "support/insert_ordered.h"
#include "support/strongly_connected_components.h"
#include "support/timing.h"

#endif // TIME_DAE || DAE_STATS

// TODO: Treat call_indirects more precisely than call_refs by taking the target
// table into account.

// TODO: Analyze stack switching instructions to remove their unused parameters.

namespace wasm {

namespace {

#if TIME_DAE
#define TIME(...) __VA_ARGS__
#else
#define TIME(...)
#endif // TIME_DAE

// Find the non-basic root of the subtyping hierarchy for a given HeapType.
HeapType getRootType(HeapType type) {
  while (true) {
    if (auto super = type.getDeclaredSuperType()) {
      type = *super;
      continue;
    }
    break;
  }
  return type;
}

// Analysis lattice: top/true = used, bot/false = unused.
using Used = analysis::Bool;

// Analysis results for each parameter of a function.
using Params = std::vector<Used::Element>;

// Function index and parameter index.
using FuncParamLoc = std::pair<Index, Index>;

// Function index identifying the function' result (we treat result tuples as a
// single value).
using FuncResultLoc = Index;

// Function type and parameter index.
using TypeParamLoc = std::pair<HeapType, Index>;

// Function type identifying the function type's result (we treat result tuples
// as a single value).
using TypeResultLoc = HeapType;

using Location =
  std::variant<FuncParamLoc, FuncResultLoc, TypeParamLoc, TypeResultLoc>;

// A set of (source, destination) index pairs for parameters of a caller
// function being forwarded as arguments to a callee function.
using ForwardedParamSet = std::unordered_set<std::pair<Index, Index>>;

// Map param indices (in the outer vector) to lists of locations.
// TODO: Experiment with using a set in place of the inner vector.
using ParamLocations = std::vector<std::vector<Location>>;

using TypeMap = GlobalTypeRewriter::TypeMap;

// Analysis results and call graph information for a single function.
// This tracks how parameters are used within the function and how they
// are forwarded to other functions via direct and indirect calls.
struct FunctionInfo {
  // Analysis results. For each parameter, whether it is used.
  Params paramUsages;

  // Analysis result for the function result. It will remain bot if there is no
  // result.
  Used::Element resultUsage;

  // Map direct callee function names to the source locations forwarded to their
  // parameters.
  std::unordered_map<Name, ParamLocations> forwardedToDirectParams;

  // Map the root supertypes of indirect callee types to the source locations
  // forwarded to their parameters.
  std::unordered_map<HeapType, ParamLocations> forwardedToIndirectParams;

  // Locations forwarded to this function's result. These locations will become
  // used if the result turns out ot be used.
  std::vector<Location> resultSources;

  // For each parameter of this function, the list of locations that will become
  // used if the parameter turns out to be used. Computed by reversing the
  // forwardedToDirectParams graph.
  ParamLocations paramSources;

  // Locations used in an observable way by the code in this function.
  // Propagation of usage will begin at these locations.
  // TODO: Experiment with making this a set.
  std::vector<Location> usedLocations;

  // The gets that may read from parameters. These are the gets that might be
  // optimized out if their results are unused or forwarded to another function
  // where they will be unused.
  std::unordered_set<LocalGet*> paramGets;

  // We do not yet analyze parameter or result usage in stack switching
  // instructions. Collect the used continuation types so we can be sure not to
  // modify their associated function types.
  // TODO: Analyze stack switching.
  std::unordered_set<HeapType> contTypes;

  // Whether we need to additionally propagate param usage to and result usage
  // from indirect callers of this function's type. Atomic because it can be set
  // when visiting other functions in parallel.
  std::atomic<bool> referenced = false;

  // We cannot yet fully analyze and optimize call.without.effects, which would
  // require creating new imports for new signatures, etc. Functions that are
  // called via these intrinsics will not be optimized.
  // TODO: Fix this.
  std::atomic<bool> usedInIntrinsic = false;

  // Unreferenced functions can be optimized separately from referenced
  // functions with the same type. For unreferenced functions in that situation,
  // this is the new type that should be applied before global type rewriting to
  // prevent the function from getting the wrong optimizations.
  std::optional<HeapType> replacementType;

  // Functions that this function directly tail-calls.
  std::vector<Index> tailCallees;

  // Root function types that this function indirectly tail-calls.
  std::vector<HeapType> tailCalleeTypes;
};

// Analysis results and call graph information for a tree of related function
// types. Every type in the tree must have matching used and unused parameters,
// so we can track information per-tree instead of per-type.
struct RootFuncTypeInfo {
  // For each parameter in the type, whether it is used.
  Params paramUsages;

  // Analysis result for the function result.
  Used::Element resultUsage;

  // The list of referenced functions with types in this tree. When a parameter
  // in this type tree is used, the parameter becomes used in these functions
  // and vice versa.
  std::vector<Index> referencedFuncs;

  // For each parameter in this root function type, the list of locations that
  // become used when the parameter in this root function type becomes used.
  // Computed by reversing indirectForwardedParams from the function infos for
  // functions with this root type.
  ParamLocations paramSources;

  // Tail-callers of this type tree. If this type tree's result is used,
  // these callers' results must also be used. Normally, result usage only
  // flows from types to their referenced functions, but tail calls require
  // this reverse constraint.
  std::vector<Location> resultSources;

  RootFuncTypeInfo(Used& used, HeapType type)
    : paramUsages(type.getSignature().params.size(), used.getBottom()),
      resultUsage(used.getBottom()),
      paramSources(type.getSignature().params.size()) {}
};

struct DAE2 : public Pass {
  // Analysis lattice.
  Used used;

  Module* wasm = nullptr;

  // Map function name to index.
  std::unordered_map<Name, Index> funcIndices;

  // Intermediate and final analysis results by function index.
  std::vector<FunctionInfo> funcInfos;

  // Intermediate and final analysis results for each function type tree, keyed
  // by root type in the tree.
  std::unordered_map<HeapType, RootFuncTypeInfo> typeTreeInfos;

  RootFuncTypeInfo& getTypeTreeInfo(HeapType rootType) {
    return typeTreeInfos.try_emplace(rootType, used, rootType).first->second;
  }

  // In general referenced functions may escape and be called externally in an
  // open world, so we require a closed world to optimize referenced functions.
  // Further, without GC we cannot differentiate the types of unreferenced and
  // referenced functions before global type rewriting, so we cannot optimize
  // them separately. Do not constrain the optimization of unreferenced
  // functions by optimizing referenced functions in that case.
  // TODO: Find a way to optimize referenced functions without GC enabled as
  // long as traps never happen so call_indirect cannot distinguish separate
  // types.
  bool optimizeReferencedFuncs = false;

  // Cache the public heap types to avoid gathering them more than once.
  std::vector<HeapType> publicHeapTypes;

  void run(Module* wasm) override {
    this->wasm = wasm;
    for (auto& func : wasm->functions) {
      funcIndices.insert({func->name, funcIndices.size()});
    }

    optimizeReferencedFuncs =
      getPassOptions().worldMode == WorldMode::Closed && wasm->features.hasGC();

    TIME(Timer timer);

    analyzeModule();

    TIME(std::cerr << "analysis: " << timer.lastElapsed() << "\n");

    prepareReverseGraph();

    TIME(std::cerr << "prepare: " << timer.lastElapsed() << "\n");

    computeFixedPoint();

    TIME(std::cerr << "fixed point: " << timer.lastElapsed() << "\n");

#if DAE_STATS
    collectStats();

    TIME(std::cerr << "stats: " << timer.lastElapsed() << "\n");
#endif // DAE_STATS

    optimize();

    TIME(auto [last, total] = timer.elapsed());
    TIME(std::cerr << "optimize: " << last << "\n");
    TIME(std::cerr << "total: " << total << "\n");
  }

  void analyzeModule();
  void prepareReverseGraph();
  void computeFixedPoint();
  void optimize();

#if DAE_STATS
  void collectStats();
#endif // DAE_STATS

  void makeUnreferencedFunctionTypes(const std::vector<HeapType>& oldTypes,
                                     const TypeMap& newTypes);

  void markParamsUsed(Index funcIndex) {
    auto& usages = funcInfos[funcIndex].paramUsages;
    std::fill(usages.begin(), usages.end(), used.getTop());
  }

  void markParamsUsed(Name func) { markParamsUsed(funcIndices.at(func)); }

  void markParamsUsed(HeapType rootType) {
    auto& usages = getTypeTreeInfo(rootType).paramUsages;
    std::fill(usages.begin(), usages.end(), used.getTop());
  }

  void markResultsUsed(Index funcIndex) {
    funcInfos[funcIndex].resultUsage = used.getTop();
  }

  void markResultsUsed(Name func) { markResultsUsed(funcIndices.at(func)); }

  void markResultsUsed(HeapType rootType) {
    getTypeTreeInfo(rootType).resultUsage = used.getTop();
  }

  bool join(FuncParamLoc loc, const Used::Element& other) {
    auto& elem = funcInfos[loc.first].paramUsages[loc.second];
    return used.join(elem, other);
  }

  bool join(FuncResultLoc loc, const Used::Element& other) {
    auto& elem = funcInfos[loc].resultUsage;
    return used.join(elem, other);
  }

  bool join(TypeParamLoc loc, const Used::Element& other) {
    assert(loc.first == getRootType(loc.first));
    auto& elem = getTypeTreeInfo(loc.first).paramUsages[loc.second];
    return used.join(elem, other);
  }

  bool join(TypeResultLoc loc, const Used::Element& other) {
    assert(loc == getRootType(loc));
    auto& elem = getTypeTreeInfo(loc).resultUsage;
    return used.join(elem, other);
  }

  bool join(Location loc, const Used::Element& other) {
    if (auto* l = std::get_if<FuncParamLoc>(&loc)) {
      return join(*l, other);
    }
    if (std::get_if<FuncResultLoc>(&loc)) {
      return join(std::get<FuncResultLoc>(loc), other);
    }
    if (auto* l = std::get_if<TypeParamLoc>(&loc)) {
      return join(*l, other);
    }
    if (std::get_if<TypeResultLoc>(&loc)) {
      return join(std::get<TypeResultLoc>(loc), other);
    }
    WASM_UNREACHABLE("unexpected loc");
  }
};

struct GraphBuilder : public WalkerPass<ExpressionStackWalker<GraphBuilder>> {
  bool isFunctionParallel() override { return true; }
  bool modifiesBinaryenIR() override { return false; }

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

  bool optimizeReferencedFuncs;

  GraphBuilder(const Used& used,
               const std::unordered_map<Name, Index>& funcIndices,
               std::vector<FunctionInfo>& funcInfos,
               bool optimizeReferencedFuncs)
    : used(used), funcIndices(funcIndices), funcInfos(funcInfos),
      optimizeReferencedFuncs(optimizeReferencedFuncs) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<GraphBuilder>(
      used, funcIndices, funcInfos, optimizeReferencedFuncs);
  }

  void runOnFunction(Module* wasm, Function* func) override {
    assert(index == Index(-1));
    index = funcIndices.at(func->name);
    localGraph.emplace(func);
    WalkerPass<ExpressionStackWalker<GraphBuilder>>::runOnFunction(wasm, func);
  }

  void visitRefFunc(RefFunc* curr) {
    funcInfos[funcIndices.at(curr->func)].referenced = true;
  }

  void noteContinuation(Type type) {
    if (type.isContinuation()) {
      funcInfos[index].contTypes.insert(type.getHeapType());
    }
  }

  void visitResumeHandlers(const ArenaVector<Name>& labels) {
    for (Index i = 0; i < labels.size(); ++i) {
      if (labels[i]) {
        auto* target = findBreakTarget(labels[i]);
        assert(target->type.size() >= 1);
        auto newContType = target->type[target->type.size() - 1];
        assert(newContType.isContinuation());
        noteContinuation(newContType);
      }
    }
  }

  void visitResume(Resume* curr) {
    noteContinuation(curr->cont->type);
    visitResumeHandlers(curr->handlerBlocks);
  }
  void visitResumeThrow(ResumeThrow* curr) {
    noteContinuation(curr->cont->type);
    visitResumeHandlers(curr->handlerBlocks);
  }
  void visitStackSwitch(StackSwitch* curr) {
    noteContinuation(curr->cont->type);
    // Do not optimize the return continuation either because that would
    // require us to update the type of the switch expression.
    if (curr->cont->type.isContinuation()) {
      auto retParams = curr->cont->type.getHeapType()
                         .getContinuation()
                         .type.getSignature()
                         .params;
      noteContinuation(retParams[retParams.size() - 1]);
    }
  }
  void visitContBind(ContBind* curr) {
    noteContinuation(curr->cont->type);
    noteContinuation(curr->type);
  }

  Index getArgIndex(const ExpressionList& operands, Expression* arg) {
    for (Index i = 0; i < operands.size(); ++i) {
      if (operands[i] == arg) {
        return i;
      }
    }
    WASM_UNREACHABLE("expected arg");
  }

  void forwardToDirectParam(Location source,
                            const ExpressionList& operands,
                            Expression* arg,
                            Name target) {
    auto argIndex = getArgIndex(operands, arg);
    auto& forwarded = funcInfos[index].forwardedToDirectParams[target];
    if (forwarded.empty()) {
      forwarded.resize(operands.size());
    }
    forwarded[argIndex].push_back(source);
  }

  void forwardToIndirectParam(Location source,
                              const ExpressionList& operands,
                              Expression* arg,
                              HeapType type) {
    auto rootType = getRootType(type);
    auto argIndex = getArgIndex(operands, arg);
    auto& forwarded = funcInfos[index].forwardedToIndirectParams[rootType];
    if (forwarded.empty()) {
      forwarded.resize(operands.size());
    }
    forwarded[argIndex].push_back(source);
  }

  void forwardToResult(Location source) {
    funcInfos[index].resultSources.push_back(source);
  }

  // Record the fact that `curr`'s result comes from `source`.
  void getValueFromLocation(Expression* curr, Location source) {
    // Look at the transitive users of this value (i.e. its parent and further
    // ancestors) to see if it flows (possibly with transformations) into
    // another location, `dest`. If it is, we say that `src` is "forwarded" to
    // `dest`. We will create an edge in the analysis graph so that if `dest` is
    // used, then `src` will be marked as used as well. We must make sure the
    // current function doesn't first use `src` in other ways, though, for
    // example by teeing it to a local or by performing a branching or trapping
    // cast on it. As a conservative approximation, consider the `src` used if
    // any of the expressions between `curr` and `dest` have non-removable side
    // effects (even if those side effects do not depend on the value flowing
    // from `curr`).
    if (curr == getFunction()->body) {
      // No parents to look at, but the result is forwarded to the function
      // result.
      forwardToResult(source);
      return;
    }
    for (Index i = expressionStack.size() - 1; i > 0; --i) {
      auto* expr = expressionStack[i];
      auto* parent = expressionStack[i - 1];

      // TODO: Experiment with caching the location (or lack of location, or
      // use) reached from parent expressions so we can avoid traversing the
      // same parents more than once.

      if (auto* call = parent->dynCast<Call>()) {
        forwardToDirectParam(source, call->operands, expr, call->target);
        return;
      }
      if (auto* call = parent->dynCast<CallIndirect>();
          call && expr != call->target && optimizeReferencedFuncs) {
        forwardToIndirectParam(source, call->operands, expr, call->heapType);
        return;
      }
      if (auto* call = parent->dynCast<CallRef>();
          call && expr != call->target && optimizeReferencedFuncs) {
        if (!call->target->type.isSignature()) {
          // The call will never happen, so we don't need to consider it.
          return;
        }
        auto heapType = call->target->type.getHeapType();
        forwardToIndirectParam(source, call->operands, expr, heapType);
        return;
      }

      if (parent->is<Return>()) {
        forwardToResult(source);
        return;
      }

      // TODO: Handle unconditional branches to blocks that fall through to the
      // end of the function as well? Handle all unconditional branches to
      // blocks in general?

      // If the value flows into an If condition, we must consider it used
      // because removing it may visibly change which arm of the If gets
      // executed. This is not captured by the effects analysis below.
      if (auto* iff = parent->dynCast<If>(); iff && expr == iff->condition) {
        break;
      }

      // TODO: Skip the effects analysis below when we are flowing out of a
      // block. Side effects earlier in the block don't matter.

      // If the current parent expression has unremovable side effects, we
      // conservatively treat the value as used.
      EffectAnalyzer effects(getPassOptions(), *getModule());
      effects.visit(parent);
      if (effects.hasUnremovableSideEffects()) {
        // Conservatively assume this expression uses the value in some way that
        // prevents us from removing it.
        break;
      }

      if (!parent->type.isConcrete()) {
        // The value flows no further, so it is not used in an observable way.
        return;
      }

      // If the value flows out of the function body, it is forwarded to this
      // function's results.
      if (parent == getFunction()->body) {
        forwardToResult(source);
        return;
      }
    }

    // The value is used by something we aren't analyzing.
    if (auto* l = std::get_if<FuncParamLoc>(&source)) {
      // Parameter uses are local to the function and can be updated in
      // parallel.
      funcInfos[index].paramUsages[l->second] = used.getTop();
    } else {
      // Other locations will have to be handled later.
      funcInfos[index].usedLocations.push_back(source);
    }
  }

  void visitLocalGet(LocalGet* curr) {
    if (!getFunction()->isParam(curr->index)) {
      return;
    }

    // A use of a parameter local does not necessarily imply the use of the
    // parameter value. Check where the parameter value may be used.
    const auto& sets = localGraph->getSets(curr);
    bool usesParam = std::any_of(
      sets.begin(), sets.end(), [](LocalSet* set) { return set == nullptr; });

    if (!usesParam) {
      // The original parameter value does not reach here.
      return;
    }

    funcInfos[index].paramGets.insert(curr);

    getValueFromLocation(curr, FuncParamLoc{index, curr->index});
  }

  void visitCall(Call* curr) {
    if (Intrinsics(*getModule()).isCallWithoutEffects(curr)) {
      auto target = curr->operands.back()->cast<RefFunc>()->func;
      funcInfos[funcIndices.at(target)].usedInIntrinsic = true;
    }
    auto* callee = getModule()->getFunction(curr->target);
    if (callee->getResults().isConcrete()) {
      Location source = FuncResultLoc{funcIndices.at(curr->target)};
      if (curr->isReturn) {
        forwardToResult(source);
        funcInfos[index].tailCallees.push_back(funcIndices.at(curr->target));
      } else {
        getValueFromLocation(curr, source);
      }
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    auto sig = curr->heapType.getSignature();
    if (sig.results.isConcrete()) {
      if (curr->isReturn) {
        Location source = TypeResultLoc{getRootType(curr->heapType)};
        forwardToResult(source);
        funcInfos[index].tailCalleeTypes.push_back(getRootType(curr->heapType));
      } else if (optimizeReferencedFuncs) {
        Location source = TypeResultLoc{getRootType(curr->heapType)};
        getValueFromLocation(curr, source);
      }
    }
  }

  void visitCallRef(CallRef* curr) {
    if (curr->target->type.isSignature()) {
      auto sig = curr->target->type.getHeapType().getSignature();
      if (sig.results.isConcrete()) {
        if (curr->isReturn) {
          Location source =
            TypeResultLoc{getRootType(curr->target->type.getHeapType())};
          forwardToResult(source);
          auto heapType = curr->target->type.getHeapType();
          funcInfos[index].tailCalleeTypes.push_back(getRootType(heapType));
        } else if (optimizeReferencedFuncs) {
          Location source =
            TypeResultLoc{getRootType(curr->target->type.getHeapType())};
          getValueFromLocation(curr, source);
        }
      }
    }
  }
};

void DAE2::analyzeModule() {
  // Initialize the function infos. (The type infos are initialized
  // on-demand instead.)
  funcInfos = std::vector<FunctionInfo>(wasm->functions.size());
  for (Index i = 0; i < funcInfos.size(); ++i) {
    auto numParams = wasm->functions[i]->getNumParams();
    funcInfos[i].paramUsages.resize(numParams, used.getBottom());
    funcInfos[i].resultUsage = used.getBottom();
    funcInfos[i].paramSources.resize(numParams);
  }

  // Analyze functions to find forwarded and used parameters as well as
  // function references and other relevant information.
  GraphBuilder builder(used, funcIndices, funcInfos, optimizeReferencedFuncs);
  builder.run(getPassRunner(), wasm);

  // Find additional function references at the module level.
  builder.walkModuleCode(wasm);

  // Update the locations for which we observed direct usage.
  for (Index i = 0; i < wasm->functions.size(); ++i) {
    auto& info = funcInfos[i];
    for (auto loc : info.usedLocations) {
      if (auto* l = std::get_if<FuncResultLoc>(&loc)) {
        markResultsUsed(*l);
      } else if (auto* l = std::get_if<TypeResultLoc>(&loc)) {
        markResultsUsed(*l);
      } else {
        // Function parameter uses were already handled in parallel. It is
        // impossible to directly use a type parameter since they are used only
        // transitively through function parameters.
        WASM_UNREACHABLE("unexpected location");
      }
    }
  }

  // Model imported and exported functions as referenced so that marking the
  // parameters or results of their types as used will prevent optimizations of
  // the functions themselves.
  for (Index i = 0; i < wasm->functions.size(); ++i) {
    if (wasm->functions[i]->imported()) {
      funcInfos[i].referenced = true;
    }
  }
  for (auto& export_ : wasm->exports) {
    if (export_->kind == ExternalKind::Function) {
      auto i = funcIndices.at(*export_->getInternalName());
      funcInfos[i].referenced = true;
    }
  }

  // Functions called with call.without.effects cannot yet be optimized. Mark
  // their parameters and results as used.
  for (Index i = 0; i < wasm->functions.size(); ++i) {
    if (funcInfos[i].usedInIntrinsic) {
      markParamsUsed(i);
      markResultsUsed(i);
    }
  }

  // JS-called functions will be called externally, so we cannot optimize out
  // their parameters or results.
  // TODO: Consider optimizing out a suffix of their parameters.
  for (auto name : Intrinsics(*wasm).getJSCalledFunctions()) {
    markParamsUsed(name);
    markResultsUsed(name);
  }

  // If we're not optimizing referenced functions, mark all their parameters
  // and results as used.
  if (!optimizeReferencedFuncs) {
    for (Index i = 0; i < wasm->functions.size(); ++i) {
      if (funcInfos[i].referenced) {
        markParamsUsed(i);
        markResultsUsed(i);
      }
    }
  }

  // Additionally mark parameters of referenced functions with public types (or
  // private subtypes of public types) as used because we cannot rewrite their
  // types. Similarly, we do not rewrite tag types or function types used in
  // continuations, so any referenced function whose type is in the same tree as
  // a tag type or continuation function type will have its parameters marked as
  // used.
  //
  // TODO: Consider analyzing whether we can rewrite the types of such
  // referenced functions to new private types first. This would require
  // analyzing whether they can escape the module.
  //
  // TODO: Analyze tags and remove their unused parameters.
  std::unordered_set<HeapType> unrewritableRoots;
  publicHeapTypes =
    ModuleUtils::getPublicHeapTypes(*wasm, getPassOptions().worldMode);
  for (auto type : publicHeapTypes) {
    if (type.isSignature()) {
      unrewritableRoots.insert(getRootType(type));
    }
  }
  for (auto& tag : wasm->tags) {
    unrewritableRoots.insert(getRootType(tag->type));
  }
  for (Index i = 0; i < wasm->functions.size(); ++i) {
    for (auto type : funcInfos[i].contTypes) {
      unrewritableRoots.insert(getRootType(type.getContinuation().type));
    }
  }

  // The types of the call.without.effects imports are excluded from the set of
  // public heap types, but until we can handle analyzing and updating them in
  // this pass, we must treat them the same as any other imported function
  // types.
  for (auto& func : wasm->functions) {
    if (Intrinsics(*wasm).isCallWithoutEffects(func.get())) {
      unrewritableRoots.insert(getRootType(func->type.getHeapType()));
    }
  }

  for (auto root : unrewritableRoots) {
    markParamsUsed(root);
    markResultsUsed(root);
  }
}

void DAE2::prepareReverseGraph() {
  // Compute the reverse graph used by the fixed point analysis from the
  // forward graph we have built.

  // Collect the referenced functions for each type tree.
  for (Index i = 0; i < funcInfos.size(); ++i) {
    funcInfos[i].paramSources.resize(funcInfos[i].paramUsages.size());
    if (funcInfos[i].referenced) {
      auto root = getRootType(wasm->functions[i]->type.getHeapType());
      getTypeTreeInfo(root).referencedFuncs.push_back(i);
    }
  }
  for (Index callerIndex = 0; callerIndex < funcInfos.size(); ++callerIndex) {
    auto& callerInfo = funcInfos[callerIndex];
    // Collect the source locations for direct callees.
    for (auto& [callee, forwardedParams] : callerInfo.forwardedToDirectParams) {
      auto& calleeInfo = funcInfos[funcIndices.at(callee)];
      for (Index destParam = 0; destParam < forwardedParams.size();
           ++destParam) {
        for (auto sourceLoc : forwardedParams[destParam]) {
          calleeInfo.paramSources[destParam].push_back(sourceLoc);
        }
      }
    }
    // Collect the source locations for indirect callees.
    for (auto& [calleeRootType, forwardedParams] :
         callerInfo.forwardedToIndirectParams) {
      assert(getRootType(calleeRootType) == calleeRootType);
      auto& typeTreeInfo = getTypeTreeInfo(calleeRootType);
      for (Index destParam = 0; destParam < forwardedParams.size();
           ++destParam) {
        for (auto sourceLoc : forwardedParams[destParam]) {
          typeTreeInfo.paramSources[destParam].push_back(sourceLoc);
        }
      }
    }
    // Collect the tail callers of each callee function and type tree.
    Location callerResult = FuncResultLoc{callerIndex};
    for (auto calleeIndex : callerInfo.tailCallees) {
      funcInfos[calleeIndex].resultSources.push_back(callerResult);
    }
    for (auto calleeRootType : callerInfo.tailCalleeTypes) {
      getTypeTreeInfo(calleeRootType).resultSources.push_back(callerResult);
    }
  }
}

// Performs a smallest fixed-point analysis to propagate parameter usage
// information through the reverse call graph. If a parameter is used in a
// function, then any caller parameters that were forwarded to the parameter are
// also used. Cycles of forwarded arguments will not be marked used unless
// one of the arguments starts out as used or there is some source of usage
// outside the cycle.
void DAE2::computeFixedPoint() {
  // List of destination locations (i.e. params and results, either of functions
  // or root function types) from which we may need to propagate usage
  // information. Initialized with all locations we have observed to be used in
  // the IR.
  // TODO: Consider propagating by connected components instead.
  std::vector<Location> work;
  for (Index i = 0; i < funcInfos.size(); ++i) {
    for (Index j = 0; j < funcInfos[i].paramUsages.size(); ++j) {
      if (funcInfos[i].paramUsages[j]) {
        work.push_back(FuncParamLoc{i, j});
      }
    }
    if (funcInfos[i].resultUsage) {
      work.push_back(FuncResultLoc{i});
    }
  }
  for (auto& [rootType, info] : typeTreeInfos) {
    for (Index i = 0; i < info.paramUsages.size(); ++i) {
      if (info.paramUsages[i]) {
        work.push_back(TypeParamLoc{rootType, i});
      }
    }
    if (info.resultUsage) {
      work.push_back(TypeResultLoc{rootType});
    }
  }

  while (!work.empty()) {
    auto loc = work.back();
    work.pop_back();

    if (auto* l = std::get_if<TypeParamLoc>(&loc)) {
      auto [rootType, paramIndex] = *l;
      auto& typeTreeInfo = getTypeTreeInfo(rootType);
      const auto& elem = typeTreeInfo.paramUsages[paramIndex];
      assert(elem && "unexpected unused param");

      // Propagate usage back to locations forwarded from indirect callers.
      for (auto source : typeTreeInfo.paramSources[paramIndex]) {
        if (join(source, elem)) {
          work.push_back(source);
        }
      }
      // Propagate usage to referenced functions with types in the same type
      // tree to ensure their types can all be updated uniformly.
      for (auto funcIndex : typeTreeInfo.referencedFuncs) {
        FuncParamLoc param = {funcIndex, paramIndex};
        if (join(param, elem)) {
          work.push_back(param);
        }
      }
    } else if (auto* l = std::get_if<TypeResultLoc>(&loc)) {
      auto& typeTreeInfo = getTypeTreeInfo(*l);
      const auto& elem = typeTreeInfo.resultUsage;
      assert(elem && "unexpected unused result");
      // Propagate usage to referenced functions with types in the same type
      // tree to ensure their types can all be updated uniformly.
      for (auto funcIndex : typeTreeInfo.referencedFuncs) {
        FuncResultLoc res = funcIndex;
        if (join(res, elem)) {
          work.push_back(res);
        }
      }
      // Propagate to tail callers.
      for (auto source : typeTreeInfo.resultSources) {
        if (join(source, elem)) {
          work.push_back(source);
        }
      }
    } else if (auto* l = std::get_if<FuncParamLoc>(&loc)) {
      auto [calleeIndex, calleeParamIndex] = *l;
      auto& calleeInfo = funcInfos[calleeIndex];
      const auto& elem = calleeInfo.paramUsages[calleeParamIndex];
      assert(elem && "unexpected unused param");
      // Propagate usage back to locations forwarded from direct callers.
      for (auto source : calleeInfo.paramSources[calleeParamIndex]) {
        if (join(source, elem)) {
          work.push_back(source);
        }
      }
      if (calleeInfo.referenced) {
        // Propagate the use to the function type. It will be propagated from
        // there to indirect callers and other functions of this type.
        auto calleeType = wasm->functions[calleeIndex]->type.getHeapType();
        TypeParamLoc param = {getRootType(calleeType), calleeParamIndex};
        if (join(param, elem)) {
          work.push_back(param);
        }
      }
    } else if (auto* l = std::get_if<FuncResultLoc>(&loc)) {
      auto calleeIndex = *l;
      auto& calleeInfo = funcInfos[calleeIndex];
      const auto& elem = calleeInfo.resultUsage;
      assert(elem && "unexpected unused result");
      // Propagate usage back to sources of this result, including tail callers.
      for (auto source : calleeInfo.resultSources) {
        if (join(source, elem)) {
          work.push_back(source);
        }
      }
      if (calleeInfo.referenced) {
        // Propagate the use to the function type. It will be propagated from
        // there to other functions of this type.
        auto calleeType = wasm->functions[calleeIndex]->type.getHeapType();
        TypeResultLoc res = getRootType(calleeType);
        if (join(res, elem)) {
          work.push_back(res);
        }
      }
    } else {
      WASM_UNREACHABLE("unexpected location");
    }
  }
}

// Updates function signatures throughout the module. Ensures that all functions
// within the same subtyping tree have the same parameters removed, maintaining
// the validity of the subtyping hierarchy.
struct DAETypeUpdater : GlobalTypeRewriter {
  DAE2& parent;
  DAETypeUpdater(DAE2& parent)
    : GlobalTypeRewriter(*parent.wasm, parent.getPassOptions().worldMode),
      parent(parent) {}

  void modifySignature(HeapType oldType, Signature& sig) override {
    // All signature types in a type tree will have the same parameters removed
    // to keep subtyping valid. Look up which parameters to keep by the root
    // type in the tree.
    auto& info = parent.getTypeTreeInfo(getRootType(oldType));
    auto& usages = info.paramUsages;
    bool hasRemoved = std::any_of(
      usages.begin(), usages.end(), [&](auto& use) { return !use; });
    if (hasRemoved) {
      std::vector<Type> keptParams;
      keptParams.reserve(usages.size());
      for (Index i = 0; i < usages.size(); ++i) {
        if (usages[i]) {
          keptParams.push_back(sig.params[i]);
        }
      }
      sig.params = getTempTupleType(std::move(keptParams));
    }
    if (!info.resultUsage) {
      sig.results = Type::none;
    }
  }

  // Return the sorted list of old types (used for deterministic ordering) and
  // the unordered map from old to new types.
  std::pair<std::vector<HeapType>, TypeMap> rebuildTypes() {
    auto types = getSortedTypes(getPrivatePredecessors());
    auto map = GlobalTypeRewriter::rebuildTypes(types);
    return {std::move(types), std::move(map)};
  }
};

// Optimize functions in parallel using the DAE2 analysis results.
struct Optimizer
  : public WalkerPass<
      ExpressionStackWalker<Optimizer, UnifiedExpressionVisitor<Optimizer>>> {
  using Super = WalkerPass<
    ExpressionStackWalker<Optimizer, UnifiedExpressionVisitor<Optimizer>>>;

  bool isFunctionParallel() override { return true; }

  // We handle non-nullable local fixups in the pass itself. If we ran the
  // fixups after the pass, they could get confused and produce invalid code
  // because this pass updates local indices but does not always update function
  // types to match. Function types are updated after this pass runs.
  bool requiresNonNullableLocalFixups() override { return false; }

  const DAE2& parent;

  // The info for the function we are running on.
  const FunctionInfo* funcInfo = nullptr;

  // Map old local indices to new local indices for the function we are
  // currently optimizing. Kept parameters and locals may need to have their
  // indices shifted down to account for removed parameters, and removed
  // parameters will need to be mapped to their new replacement locals.
  std::vector<Index> newIndices;

  // It is not enough to simply replace removed parameters with locals. Removed
  // non-nullable parameters would become non-nullable locals, and those locals
  // might have gets that are dropped or forwarded to other optimized calls
  // before any set is executed. We cannot in general synthesize a value to
  // initialize such locals (nor would we want to), so instead we must make the
  // dropped or forwarded gets disappear, as well as their parents up to the
  // drop or forwarding call. These are the expressions we must remove.
  std::unordered_set<Expression*> removedExpressions;

  // We will need to generate fresh labels for trampoline blocks.
  std::optional<LabelUtils::LabelManager> labels;

  Optimizer(const DAE2& parent) : parent(parent) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Optimizer>(parent);
  }

  // Update the locals and local indices within the function. If the function is
  // not referenced, also update its type. (Referenced functions will have their
  // types updated later in a global type rewriting operation.)
  void runOnFunction(Module* wasm, Function* func) override {
    if (func->imported()) {
      return;
    }

    funcInfo = &parent.funcInfos[parent.funcIndices.at(func->name)];
    labels.emplace(func);

    auto originalType = func->type;
    auto originalParams = func->getParams();
    auto numParams = originalParams.size();
    Index numLocals = func->getNumLocals();

    assert(newIndices.empty());
    newIndices.reserve(numLocals);

    auto& paramUsages = funcInfo->paramUsages;
    assert(paramUsages.size() == numParams);
    bool hasRemovedParam = std::any_of(
      paramUsages.begin(), paramUsages.end(), [&](auto& use) { return !use; });
    bool hasRemovedResult =
      !funcInfo->resultUsage && func->getResults().isConcrete();

    bool hasNewNonNullableLocal = false;
    if (hasRemovedParam || hasRemovedResult) {
      // Remove the parameters and replace them with scratch locals. Map the
      // indices of removed params to their types and names so we can create
      // properly typed and named scratch locals later.
      std::vector<std::pair<Type, Name>> removedParams;
      std::vector<Type> keptParams;
      std::unordered_map<Index, Name> newLocalNames;
      std::unordered_map<Name, Index> newLocalIndices;
      Index next = 0;

      for (Index i = 0; i < numLocals; ++i) {
        if (i >= numParams || paramUsages[i]) {
          // Used param or local. Keep it.
          if (i < numParams) {
            keptParams.push_back(originalParams[i]);
          }
          newIndices.push_back(next);
          if (auto name = func->getLocalNameOrDefault(i)) {
            newLocalNames[next] = name;
            newLocalIndices[name] = next;
          }
          ++next;
        } else {
          // Skip this unused param and record it to be added as a new local
          // later.
          removedParams.emplace_back(originalParams[i],
                                     func->getLocalNameOrDefault(i));
          newIndices.push_back(numLocals - removedParams.size());
        }
      }

      func->localNames = std::move(newLocalNames);
      func->localIndices = std::move(newLocalIndices);

      // Replace the function's type with a new type using only the kept
      // parameters and result. This ensures that newly added locals get the
      // right indices. Preserve sharedness in case this becomes the permanent
      // new type (when GC is disabled, see below).
      Signature sig(Type(keptParams),
                    funcInfo->resultUsage ? func->getResults() : Type::none);
      TypeBuilder builder(1);
      builder[0] = sig;
      builder[0].setShared(originalType.getHeapType().getShared());
      auto newType = (*builder.build())[0];
      func->type = Type(newType, NonNullable, Exact);

      // Add new vars to replace the removed params.
      for (Index i = removedParams.size(); i > 0; --i) {
        auto& [type, name] = removedParams[i - 1];
        if (type.isNonNullable()) {
          hasNewNonNullableLocal = true;
        }
        Builder::addVar(func, name, type);
      }
    } else {
      // Not changing any indices.
      for (Index i = 0; i < numLocals; ++i) {
        newIndices.push_back(i);
      }
    }

    Super::runOnFunction(wasm, func);

    assert(!hasRemovedResult || !func->body->type.isConcrete());

    // We may have moved pops around. Fix them.
    EHUtils::handleBlockNestedPops(func, *wasm);

    // We may have introduced a new non-nullable local whose sets do not
    // structurally dominate its gets. Fix it.
    if (hasNewNonNullableLocal) {
      TypeUpdating::handleNonDefaultableLocals(func, *wasm);
    }

    // If there is a replacement type, install it now. Otherwise we know the
    // global type rewriting will do the right thing with the original type,
    // so restore it for now to let that rewriting happen. Only do this if we
    // are optimizing indirect calls because otherwise there will not be a
    // global type rewriting step.
    if (funcInfo->replacementType) {
      func->type = Type(*funcInfo->replacementType, NonNullable, Exact);
    } else if (parent.optimizeReferencedFuncs) {
      func->type = originalType;
    }
  }

  // Mark the parents of the current expression for removal until they either
  // stop propagating the unused value or reach a call parameter or function
  // result.
  void markParentsRemoved() {
    for (Index i = expressionStack.size() - 1; i > 0; --i) {
      auto* parent = expressionStack[i - 1];
      if (parent->is<Call>() || parent->is<CallIndirect>() ||
          parent->is<CallRef>() || parent->is<Return>()) {
        break;
      }
      if (!removedExpressions.insert(parent).second) {
        // This expression, and therefore its relevant parents, have already
        // been marked, so we do not need to continue.
        break;
      }
      if (!parent->type.isConcrete()) {
        // The value does not flow further, so stop removing.
        break;
      }
    }
  }

  void visitLocalSet(LocalSet* curr) { curr->index = newIndices[curr->index]; }

  void visitLocalGet(LocalGet* curr) {
    // If this is a get of a removed parameter, we need to make it disappear
    // along with all of its parents until we reach a call or the value is no
    // longer propagated. We know removing these expressions is ok because if
    // any of them had non-removable side effects, we would not be optimizing
    // out the parameter.
    if (curr->index < funcInfo->paramUsages.size() &&
        !funcInfo->paramUsages[curr->index] &&
        funcInfo->paramGets.contains(curr)) {
      removedExpressions.insert(curr);
      markParentsRemoved();
    }
    curr->index = newIndices[curr->index];
  }

  // Given an expression, return a new expression containing all its non-removed
  // parts, if any, or otherwise nullptr. The returned expression will have
  // non-concrete type because its value will have been removed.
  Expression* getReplacement(Expression* curr);

  // Given an expression, return its replacement or a nop if it is marked for
  // removal, or otherwise return it dropped.
  Expression* getReplacementOrDrop(Expression* curr) {
    Builder builder(*getModule());
    if (removedExpressions.contains(curr)) {
      if (auto* replacement = getReplacement(curr)) {
        return replacement;
      }
      return builder.makeNop();
    }
    if (curr->type.isConcrete()) {
      return builder.makeDrop(curr);
    }
    return curr;
  }

  // Remove operands from any kind of call (i.e. Call, CallIndirect, or
  // CallRef), given the call's list of operands and analysis results for those
  // operands.
  void removeOperands(Expression* call,
                      ExpressionList& operands,
                      const Params& usages) {
    if (operands.empty()) {
      return;
    }
    assert(usages.empty() || usages.size() == operands.size());
    bool hasRemoved = usages.empty() ||
                      std::any_of(usages.begin(), usages.end(), [](auto& elem) {
                        return !elem;
                      });
    if (!hasRemoved) {
      return;
    }

    // In general we cannot change the order of the operands, including the kept
    // parts of removed operands, because they may have side effects. Use
    // scratch locals to move the kept operand values past any subsequent kept
    // parts of removed operands. (N.B. We could use ChildLocalizer here, but
    // that would make it hard to find the expression to replace because it
    // might or might not end up in a new local.set.)
    Builder builder(*getModule());
    Expression* block = nullptr;
    Index next = 0;
    bool hasUnreachableRemovedOperand = false;
    for (Index i = 0; i < operands.size(); ++i) {
      auto type = operands[i]->type;
      if (!usages.empty() && usages[i]) {
        if (type == Type::unreachable) {
          // No scratch local necessary to propagate unreachable.
          block = builder.blockify(block, operands[i]);
          operands[next++] = builder.makeUnreachable();
          continue;
        }
        Index scratch = Builder::addVar(getFunction(), type);
        block =
          builder.blockify(block, builder.makeLocalSet(scratch, operands[i]));
        operands[next++] = builder.makeLocalGet(scratch, type);
        continue;
      }
      // This operand is removed, but it might have children we need to keep.
      if (type == Type::unreachable) {
        hasUnreachableRemovedOperand = true;
      }
      if (auto* replacement = getReplacement(operands[i])) {
        block = builder.blockify(block, replacement);
      }
    }
    operands.resize(next);
    // If we removed an unreachable operand, then the call is definitely
    // unreachable but may no longer have an unreachable child. This is not
    // valid, so replace it with an unreachable.
    if (hasUnreachableRemovedOperand) {
      block = builder.blockify(block, builder.makeUnreachable());
    } else {
      block = builder.blockify(block, call);
    }
    replaceCurrent(block);
  }

  void visitCall(Call* curr) {
    auto& calleeInfo = parent.funcInfos[parent.funcIndices.at(curr->target)];
    if (!calleeInfo.resultUsage && curr->type.isConcrete()) {
      curr->type = Type::none;
      markParentsRemoved();
    }
    removeOperands(curr, curr->operands, calleeInfo.paramUsages);
  }

  void handleIndirectCall(Expression* curr,
                          ExpressionList& operands,
                          HeapType type) {
    if (!parent.optimizeReferencedFuncs) {
      return;
    }
    auto it = parent.typeTreeInfos.find(getRootType(type));
    if (it == parent.typeTreeInfos.end()) {
      // No analysis results for this type, so none of its parameters or results
      // are used.
      if (curr->type.isConcrete()) {
        curr->type = Type::none;
        markParentsRemoved();
      }
      removeOperands(curr, operands, {});
    } else {
      if (!it->second.resultUsage && curr->type.isConcrete()) {
        curr->type = Type::none;
        markParentsRemoved();
      }
      removeOperands(curr, operands, it->second.paramUsages);
    }
  }

  void visitCallRef(CallRef* curr) {
    if (!curr->target->type.isSignature()) {
      return;
    }
    handleIndirectCall(curr, curr->operands, curr->target->type.getHeapType());
  }

  void visitCallIndirect(CallIndirect* curr) {
    handleIndirectCall(curr, curr->operands, curr->heapType);
  }

  void visitReturn(Return* curr) {
    if (curr->value && !funcInfo->resultUsage) {
      // We are removing this function's unused result. Remove or drop the
      // original value (depending on whether or not the value uses another
      // removed location) and then return.
      Builder builder(*getModule());
      replaceCurrent(
        builder.makeSequence(getReplacementOrDrop(curr->value), curr));
      curr->value = nullptr;
    }
  }

  void visitExpression(Expression* curr) {
    if (curr->type.isConcrete()) {
      // If this expression should be removed, that will be handled by the call
      // or non-concrete expression it ultimately flows into.
      return;
    }
    if (!removedExpressions.contains(curr)) {
      // We're keeping this one.
      return;
    }
    // This is a top-level removed expression. Replace it with its kept
    // children, if any, and make sure unreachable expressions remain
    // unreachable.
    Builder builder(*getModule());
    if (auto* replacement = getReplacement(curr)) {
      if (curr->type == Type::unreachable &&
          replacement->type != Type::unreachable) {
        replacement = builder.blockify(replacement, builder.makeUnreachable());
      }
      replaceCurrent(replacement);
      return;
    }
    // There are no kept children.
    builder.replaceWithIdenticalType(curr);
  }

  void visitFunction(Function* func) {
    // Remove the function result if necessary.
    if (func->body->type.isConcrete() && !funcInfo->resultUsage) {
      func->body = getReplacementOrDrop(func->body);
    }
  }
};

Expression* Optimizer::getReplacement(Expression* curr) {
  Builder builder(*getModule());
  if (!removedExpressions.contains(curr)) {
    // This expression is not removed, so none of its children are either. (If
    // they were, they would already have been removed.)
    if (!curr->type.isConcrete()) {
      return curr;
    }
    return builder.makeDrop(curr);
  }

  // Traverse an expression that is being removed and collect any of its
  // sub-expressions that are not being removed into a new expression.
  struct Collector
    : ExpressionStackWalker<Collector, UnifiedExpressionVisitor<Collector>> {
    using Super =
      ExpressionStackWalker<Collector, UnifiedExpressionVisitor<Collector>>;

    std::unordered_set<Expression*>& removedExpressions;
    LabelUtils::LabelManager& labels;
    Builder& builder;

    // A stack of lists of expressions we are building, one list for each level
    // of control flow structures we are inserting them into.
    std::vector<std::vector<Expression*>> collectedStack = {{}};

    // Indices indicating which part of a Try we are currently constructing,
    // for every Try in the current expression stack. Index 0 is the body and
    // index N > 0 is catch body N - 1.
    std::vector<Index> tryIndexStack;

    Collector(std::unordered_set<Expression*>& removedExpressions,
              LabelUtils::LabelManager& labels,
              Builder& builder)
      : removedExpressions(removedExpressions), labels(labels),
        builder(builder) {}

    void appendExpr(Expression* curr) {
      if (curr->type.isConcrete()) {
        curr = builder.makeDrop(curr);
      }
      collectedStack.back().push_back(curr);
    }

    Expression* collectExprsOrNull() {
      auto& exprs = collectedStack.back();
      Expression* result;
      switch (exprs.size()) {
        case 0:
          return nullptr;
        case 1:
          result = exprs[0];
          break;
        default:
          result = builder.makeBlock(exprs, Type::none);
          break;
      }
      exprs.clear();
      return result;
    }

    Expression* collectExprsOrNop() {
      if (auto* expr = collectExprsOrNull()) {
        return expr;
      }
      return builder.makeNop();
    }

    void finishControlFlow(Expression* curr) {
      collectedStack.pop_back();
      appendExpr(curr);
      // Do not traverse this expression again, since it need not change after
      // having been processed once.
      removedExpressions.erase(curr);
    }

    // Ifs, Loops, Trys, and labeled Blocks can all produce values and may
    // shallowly have only removable side effects, so it is possible that they
    // will need to be removed. However, they may contain expressions that
    // have non-removable side effects. The execution of these side effects
    // must remain under the control of the original control flow structures.
    // This custom scan calls hooks that will incorporate the control flow
    // structures into the collected expression. Once a control flow structure
    // has been fully processed once, remove it from the set of removed
    // expressions because its remaining contents are not removed and would
    // not change if processed again.
    static void scan(Collector* self, Expression** currp) {
      Expression* curr = *currp;

      if (!self->removedExpressions.contains(curr)) {
        // The expressions we are removing form a sub-tree starting at the
        // root expression. There is therefore never a removed expression
        // inside a non-removed expression. We can just collect this
        // non-removed expression without scanning it.
        self->appendExpr(curr);
        return;
      }

      if (auto* iff = curr->dynCast<If>()) {
        assert(iff->ifFalse && "unexpected one-arm if");
        self->pushTask(doPostVisit, currp);
        self->pushTask(doEndIfFalse, currp);
        self->pushTask(scan, &iff->ifFalse);
        self->pushTask(doEndIfTrue, currp);
        self->pushTask(scan, &iff->ifTrue);
        // If conditions are always kept, so we do not need to scan them.
        self->pushTask(doPreVisit, currp);
        self->collectedStack.emplace_back();
      } else if (auto* loop = curr->dynCast<Loop>()) {
        self->pushTask(doPostVisit, currp);
        self->pushTask(doEndLoop, currp);
        self->pushTask(scan, &loop->body);
        self->pushTask(doPreVisit, currp);
        self->collectedStack.emplace_back();
      } else if (auto* try_ = curr->dynCast<Try>()) {
        self->pushTask(doPostVisit, currp);
        for (Index i = try_->catchBodies.size(); i > 0; --i) {
          self->pushTask(doEndTryBody, currp);
          self->pushTask(scan, &try_->catchBodies[i - 1]);
        }
        self->pushTask(doEndTryBody, currp);
        self->pushTask(scan, &try_->body);
        self->pushTask(doPreVisit, currp);
        self->tryIndexStack.push_back(0);
        self->collectedStack.emplace_back();
      } else if (auto* block = curr->dynCast<Block>(); block && block->name) {
        self->pushTask(doPostVisit, currp);
        self->pushTask(doEndLabeledBlock, currp);
        for (Index i = block->list.size(); i > 0; --i) {
          self->pushTask(scan, &block->list[i - 1]);
        }
        self->pushTask(doPreVisit, currp);
        self->collectedStack.emplace_back();
      } else {
        Super::scan(self, currp);
      }
      // N.B. No need to handle TryTable because it either has no handlers and
      // can be removed or has the branchesOut effect and would not be removed
      // in the first place.
    }

    static void doEndIfFalse(Collector* self, Expression** currp) {
      If* curr = (*currp)->cast<If>();
      // If this is null, we will just have erased the empty ifFalse arm,
      // which is fine.
      curr->ifFalse = self->collectExprsOrNull();
      curr->finalize();
      self->finishControlFlow(curr);
    }

    static void doEndIfTrue(Collector* self, Expression** currp) {
      If* curr = (*currp)->cast<If>();
      // There must be an ifFalse arm because the if must have concrete type
      // and we only process each removed control flow structure once.
      assert(curr->ifFalse);
      curr->ifTrue = self->collectExprsOrNop();
    }

    static void doEndLoop(Collector* self, Expression** currp) {
      Loop* curr = (*currp)->cast<Loop>();
      curr->body = self->collectExprsOrNop();
      curr->finalize();
      self->finishControlFlow(curr);
    }

    static void doEndTryBody(Collector* self, Expression** currp) {
      Try* curr = (*currp)->cast<Try>();
      Index index = self->tryIndexStack.back()++;
      auto* collected = self->collectExprsOrNop();
      if (index == 0) {
        curr->body = collected;
      } else {
        curr->catchBodies[index - 1] = collected;
      }
      if (index == curr->catchBodies.size()) {
        self->tryIndexStack.pop_back();
        curr->finalize();
        self->finishControlFlow(curr);
      }
    }

    static void doEndLabeledBlock(Collector* self, Expression** currp) {
      Block* curr = (*currp)->cast<Block>();
      assert(curr->name);
      assert(curr->type.isConcrete());

      if (self->collectedStack.back().empty()) {
        // This is the happy case where there cannot possibly be branches to
        // the block because we have not collected any expressions at all.
        // Since an empty block isn't useful, we don't need to collect
        // anything new.
        self->collectedStack.pop_back();
        return;
      }

      // The kept expressions might have arbitrary value-carrying branches to
      // this block, but we are trying to remove the block's value. In general
      // we cannot remove the values from the branches, so we must instead add
      // a trampoline that will let us drop the branch values:
      //
      // (block $fresh          ;; A new outer block that returns nothing.
      //  (drop                 ;; Drop the branch values.
      //   (block $l (result t) ;; An inner block for the branches to target.
      //     ...                ;; The kept expressions, if any.
      //     (br $fresh)        ;; If no branches are taken, skip the drop.
      //   )
      //  )
      // )
      Name fresh = self->labels.getUnique("trampoline");
      auto* collected = self->collectExprsOrNull();
      assert(collected);
      auto* inner =
        self->builder.makeSequence(collected, self->builder.makeBreak(fresh));
      inner->name = curr->name;
      inner->type = curr->type;
      auto* drop = self->builder.makeDrop(inner);
      self->finishControlFlow(self->builder.makeBlock(fresh, drop));
    }
  };

  Collector collector(removedExpressions, *labels, builder);
  collector.walk(curr);
  assert(collector.collectedStack.size() == 1);
  return collector.collectExprsOrNull();
}

void DAE2::optimize() {
  Optimizer optimizer(*this);
  if (!optimizeReferencedFuncs) {
    // Cannot globally rewrite types or optimize referenced functions, so just
    // run the optimizer to optimize unreferenced functions.
    optimizer.run(getPassRunner(), wasm);
    return;
  }

  TIME(Timer timer);

  // Global type rewriting
  DAETypeUpdater typeUpdater(*this);
  auto [oldTypes, newTypes] = typeUpdater.rebuildTypes();

  TIME(std::cerr << "  rebuild types: " << timer.lastElapsed() << "\n");

  makeUnreferencedFunctionTypes(oldTypes, newTypes);

  TIME(std::cerr << "  make replacements: " << timer.lastElapsed() << "\n");

  optimizer.run(getPassRunner(), wasm);

  TIME(std::cerr << "  optimize: " << timer.lastElapsed() << "\n");

  // Update the types for referenced functions and all the locations that might
  // hold them. The types of non-referenced functions have already been updated
  // separately.
  typeUpdater.mapTypes(newTypes);

  TIME(std::cerr << "  update types: " << timer.lastElapsed() << "\n");
}

// Generate new (possibly optimized) types for each unreferenced function so
// the later global type update will leave them with the desired optimized
// signature. This may involve giving them a different function type that will
// be rewritten to the desired signature, or alternatively we might give the
// function the optimized signature directly and ensure the global type update
// will not change it further.
void DAE2::makeUnreferencedFunctionTypes(const std::vector<HeapType>& oldTypes,
                                         const TypeMap& newTypes) {

  auto updateSingleType = [&](Type type) -> Type {
    if (!type.isRef()) {
      return type;
    }
    if (auto it = newTypes.find(type.getHeapType()); it != newTypes.end()) {
      return type.with(it->second);
    }
    return type;
  };

  auto updateType = [&](Type type) -> Type {
    if (type.isTuple()) {
      std::vector<Type> elems;
      elems.reserve(type.getTuple().size());
      for (auto t : type.getTuple()) {
        elems.push_back(updateSingleType(t));
      }
      return Type(std::move(elems));
    }
    return updateSingleType(type);
  };

  auto updateSignature = [&](Signature sig) -> Signature {
    sig.params = updateType(sig.params);
    sig.results = updateType(sig.results);
    return sig;
  };

  // Map possibly-optimized signatures with updated types to the pre-rewrite
  // heap type that will be rewritten to have those signatures. These are the
  // types we will give the unreferenced functions to make sure they end up with
  // the correct types after type rewriting.
  std::unordered_map<Signature, HeapType> replacementTypes;

  // Public types will never be rewritten, so we can use them as replacement
  // types when they already have the desired signatures.
  for (auto type : publicHeapTypes) {
    if (type.isSignature()) {
      replacementTypes.insert({type.getSignature(), type});
    }
  }

  // Other types may be rewritten. We can use them as our replacement types if
  // they will be rewritten to have the desired signatures. Do not iterate on
  // newTypes directly because it is unordered and we need determinism.
  for (auto& oldType : oldTypes) {
    if (oldType.isSignature()) {
      if (auto it = newTypes.find(oldType); it != newTypes.end()) {
        replacementTypes.insert({it->second.getSignature(), oldType});
      }
    }
  }

  // If we can't reuse a type that will be rewritten to the desired signature,
  // we need to create a new type that already has the desired signature and
  // will not be rewritten. Make sure these new types are distinct from any
  // types that will be globally rewritten.
  UniqueRecGroups unique(wasm->features);
  for (auto& [oldType, newType] : newTypes) {
    if (!oldType.isSignature()) {
      continue;
    }
    // New types we generate will always be the first types in their rec groups,
    // so we only need to go out of our way to ensure that the new types are
    // separate from other function types that are also the first in their rec
    // groups.
    if (oldType.getRecGroupIndex() != 0) {
      continue;
    }
    if (oldType.getSignature() != newType.getSignature()) {
      unique.insertOrGet(oldType.getRecGroup());
    }
  }

  // Assign replacement types to unreferenced functions that need them.
  for (Index i = 0; i < wasm->functions.size(); ++i) {
    auto& func = wasm->functions[i];
    if (funcInfos[i].referenced) {
      continue;
    }

    auto params = func->getParams();
    std::vector<Type> keptParams;
    keptParams.reserve(params.size());
    for (Index j = 0; j < params.size(); ++j) {
      if (funcInfos[i].paramUsages[j]) {
        keptParams.push_back(params[j]);
      }
    }

    Type keptResults = func->getResults();
    if (!funcInfos[i].resultUsage) {
      keptResults = Type::none;
    }

    auto newSig = updateSignature({Type(std::move(keptParams)), keptResults});

    // Look up or create a replacement type that will be rewritten to the
    // desired signature.
    auto [it, inserted] = replacementTypes.insert({newSig, HeapType(0)});
    if (inserted) {
      // Create a new type with the desired signature that will not be rewritten
      // to some other signature.
      // TODO: We need to match sharedness here.
      it->second = unique.insert(HeapType(newSig).getRecGroup())[0];
    }

    // The global type rewriting will not make the desired update, so we need a
    // replacement type.
    funcInfos[i].replacementType = it->second;
  }
}

#if DAE_STATS
void DAE2::collectStats() {
  // Count the number of removed parameters of unreferenced functions and
  // function types as well as the number of removed parameters that are part of
  // a parameter forwarding cycle.
  Index removedUnreferenced = 0, removedType = 0, removedTotal = 0;
  Index removedCycle = 0, largestCycle = 0, deepestChain = 0;

  // Collect a graph of optimized parameters and forwarding edges so we can find
  // optimized cycles.
  using Node = std::variant<FuncParamLoc, TypeParamLoc>;
  using Nodes = InsertOrderedSet<Node>;
  Nodes optimizedNodes;

  // Collect unreferenced function parameters and the total removed parameters.
  for (Index i = 0; i < funcInfos.size(); ++i) {
    for (Index j = 0; j < funcInfos[i].paramUsages.size(); ++j) {
      if (!funcInfos[i].paramUsages[j]) {
        ++removedTotal;
        if (!funcInfos[i].referenced) {
          ++removedUnreferenced;
          optimizedNodes.insert(FuncParamLoc{i, j});
        }
      }
    }
  }

  // Collect function type parameters.
  for (auto& [type, info] : typeTreeInfos) {
    for (Index i = 0; i < info.paramUsages.size(); ++i) {
      assert(getRootType(type) == type);
      if (!info.paramUsages[i]) {
        optimizedNodes.insert(TypeParamLoc{type, i});
        ++removedType;
      }
    }
  }

  // Find the strongly-connected components to find cycles. Consider only nodes
  // that have been optimized out when computing the graph.
  struct ParamSCCs : SCCs<typename Nodes::iterator, ParamSCCs> {
    DAE2& parent;
    Nodes& optimizedNodes;
    ParamSCCs(DAE2& parent, Nodes& optimizedNodes)
      : SCCs(optimizedNodes.begin(), optimizedNodes.end()), parent(parent),
        optimizedNodes(optimizedNodes) {}
    void pushChildren(Node& node) {
      if (auto* loc = std::get_if<FuncParamLoc>(&node)) {
        auto [funcIndex, paramIndex] = *loc;
        for (auto loc : parent.funcInfos[funcIndex].callerParams[paramIndex]) {
          if (optimizedNodes.contains(loc)) {
            push(loc);
          }
        }
      } else if (auto* loc = std::get_if<TypeParamLoc>(&node)) {
        auto [funcType, paramIndex] = *loc;
        if (auto it = parent.typeTreeInfos.find(funcType);
            it != parent.typeTreeInfos.end()) {
          for (auto loc : it->second.callerParams[paramIndex]) {
            if (optimizedNodes.contains(loc)) {
              push(loc);
            }
          }
        }
      } else {
        WASM_UNREACHABLE("unexpected node");
      }
    }
  };

  // Track depths for each parameter to find the longest chain.
  std::unordered_map<Node, Index> depths;
  auto getDepth = [&](Node node) -> Index {
    if (auto it = depths.find(node); it != depths.end()) {
      return it->second;
    }
    return 0;
  };
  for (auto scc : ParamSCCs(*this, optimizedNodes)) {
    std::vector<Node> sccNodes(scc.begin(), scc.end());
    if (sccNodes.size() > 1) {
      removedCycle += sccNodes.size();
    }
    // Normally we can just take the SCC size as the cycle size, but SCCs of
    // size one are not necessarily cycles at all. Look for self-references to
    // determine whether we have a size-1 cycle.
    bool isCycle = sccNodes.size() > 1;
    // Find the depth of this SCC, which one more than the max depth of its
    // children.
    Index maxChildDepth = 0;
    for (auto& node : sccNodes) {
      if (auto* loc = std::get_if<FuncParamLoc>(&node)) {
        auto [funcIndex, paramIndex] = *loc;
        for (auto loc : funcInfos[funcIndex].callerParams[paramIndex]) {
          maxChildDepth = std::max(maxChildDepth, getDepth(loc));
          if (Node(loc) == node) {
            isCycle = true;
          }
        }
      } else if (auto* loc = std::get_if<TypeParamLoc>(&node)) {
        auto [funcType, paramIndex] = *loc;
        if (auto it = typeTreeInfos.find(funcType); it != typeTreeInfos.end()) {
          for (auto loc : it->second.callerParams[paramIndex]) {
            maxChildDepth = std::max(maxChildDepth, getDepth(loc));
            if (Node(loc) == node) {
              isCycle = true;
            }
          }
        }
      } else {
        WASM_UNREACHABLE("unexpected node");
      }
    }
    Index depth = maxChildDepth + 1;
    for (auto& node : sccNodes) {
      depths[node] = depth;
    }
    deepestChain = std::max(deepestChain, depth);
    if (isCycle) {
      largestCycle = std::max(largestCycle, Index(sccNodes.size()));
    }
  }

  std::cout << "Total removed parameters: " << removedTotal << "\n";
  std::cout << "Parameters removed from unreferenced functions: "
            << removedUnreferenced << "\n";
  std::cout << "Parameters removed from inhabited function types: "
            << removedType << "\n";
  std::cout << "Parameters in forwarding cycles: " << removedCycle << "\n";
  std::cout << "Largest forwarding cycle: " << largestCycle << "\n";
  std::cout << "Deepest forwarding chain: " << deepestChain << "\n";
}
#endif // DAE_STATS

} // anonymous namespace

Pass* createDAE2Pass() { return new DAE2(); }

} // namespace wasm
