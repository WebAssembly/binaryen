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
#include "ir/manipulation.h"
#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "support/index.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm-type-shape.h"
#include "wasm-type.h"
#include "wasm.h"

#define TIME_DAE 0

#if TIME_DAE

#include <iostream>

#include "support/timing.h"

#endif // TIME_DAE

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

// Function type and parameter index.
using TypeParamLoc = std::pair<HeapType, Index>;

// A set of (source, destination) index pairs for parameters of a caller
// function being forwarded as arguments to a callee function.
using ForwardedParamSet = std::unordered_set<std::pair<Index, Index>>;

using TypeMap = GlobalTypeRewriter::TypeMap;

// Analysis results and call graph information for a single function.
// This tracks how parameters are used within the function and how they
// are forwarded to other functions via direct and indirect calls.
struct FunctionInfo {
  // Analysis results. For each parameter, whether it is used.
  Params paramUsages;

  // Map callee function names to their forwarded params for direct calls.
  std::unordered_map<Name, ForwardedParamSet> directForwardedParams;

  // Map the root supertypes of callee types to their forwarded params for
  // indirect calls.
  std::unordered_map<HeapType, ForwardedParamSet> indirectForwardedParams;

  // For each parameter of this function, the list of parameters in direct
  // callers that will become used if the parameter in this function turns out
  // to be used. Computed by reversing the directForwardedParams graph.
  std::vector<std::vector<FuncParamLoc>> callerParams;

  // The gets that may read from parameters. These are the gets that might be
  // optimized out if their results are unused or forwarded to another function
  // where they will be unused.
  std::unordered_set<LocalGet*> paramGets;

  // We do not yet analyze parameter usage in stack switching instructions.
  // Collect the used continuation types so we can be sure not to modify their
  // associated function types.
  // TODO: Analyze stack switching.
  std::unordered_set<HeapType> contTypes;

  // Whether we need to additionally propagate param usage to indirect callers
  // of this function's type. Atomic because it can be set when visiting other
  // functions in parallel.
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
};

// Analysis results and call graph information for a tree of related function
// types. Every type in the tree must have matching used and unused parameters,
// so we can track information per-tree instead of per-type.
struct RootFuncTypeInfo {
  // For each parameter in the type, whether it is used.
  Params paramUsages;

  // The list of referenced functions with types in this tree. When a parameter
  // in this type tree is used, the parameter becomes used in these functions
  // and vice versa.
  std::vector<Index> referencedFuncs;

  // For each parameter in this root function type, the list of parameters of
  // indirect callers (of any function type in this tree) that become used when
  // the parameter in this root function type becomes used. Computed by
  // reversing indirectForwardedParams from the function infos.
  std::vector<std::vector<FuncParamLoc>> callerParams;

  RootFuncTypeInfo(Used& used, HeapType type)
    : paramUsages(type.getSignature().params.size(), used.getBottom()),
      callerParams(type.getSignature().params.size()) {}
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
      getPassOptions().closedWorld && wasm->features.hasGC();

    TIME(Timer timer);

    analyzeModule();

    TIME(std::cerr << "analysis: " << timer.lastElapsed() << "\n");

    prepareReverseGraph();

    TIME(std::cerr << "prepare: " << timer.lastElapsed() << "\n");

    computeFixedPoint();

    TIME(std::cerr << "fixed point: " << timer.lastElapsed() << "\n");

    optimize();

    TIME(auto [last, total] = timer.elapsed());
    TIME(std::cerr << "optimize: " << last << "\n");
    TIME(std::cerr << "total: " << total << "\n");
  }

  void analyzeModule();
  void prepareReverseGraph();
  void computeFixedPoint();
  void optimize();

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

  bool join(FuncParamLoc loc, const Used::Element& other) {
    auto& elem = funcInfos[loc.first].paramUsages[loc.second];
    return used.join(elem, other);
  }

  bool join(TypeParamLoc loc, const Used::Element& other) {
    assert(loc.first == getRootType(loc.first));
    auto& elem = getTypeTreeInfo(loc.first).paramUsages[loc.second];
    return used.join(elem, other);
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

  void visitResume(Resume* curr) { noteContinuation(curr->cont->type); }
  void visitResumeThrow(ResumeThrow* curr) {
    noteContinuation(curr->cont->type);
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

  void visitCall(Call* curr) {
    if (Intrinsics(*getModule()).isCallWithoutEffects(curr)) {
      auto target = curr->operands.back()->cast<RefFunc>()->func;
      funcInfos[funcIndices.at(target)].usedInIntrinsic = true;
    }
  }

  Index getArgIndex(const ExpressionList& operands, Expression* arg) {
    for (Index i = 0; i < operands.size(); ++i) {
      if (operands[i] == arg) {
        return i;
      }
    }
    WASM_UNREACHABLE("expected arg");
  }

  void handleDirectForwardedParam(LocalGet* get, Expression* arg, Call* call) {
    auto argIndex = getArgIndex(call->operands, arg);
    auto& forwarded = funcInfos[index].directForwardedParams[call->target];
    forwarded.insert({get->index, argIndex});
  }

  void handleIndirectForwardedParam(LocalGet* get,
                                    Expression* arg,
                                    const ExpressionList& operands,
                                    HeapType type) {
    auto rootType = getRootType(type);
    auto argIndex = getArgIndex(operands, arg);
    auto& forwarded = funcInfos[index].indirectForwardedParams[rootType];
    forwarded.insert({get->index, argIndex});
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

    // Look at the transitive users of this value (i.e. its parent and further
    // ancestors) to see if it is used by a call. If it is, we say that the
    // caller parameter is "forwarded" to the callee. We will create an edge in
    // the analysis graph so that if the callee uses its parameter, we will mark
    // the forwarded parameter used in the current function as well. We must
    // make sure the current function doesn't first use the parameter via this
    // local.get in other ways, though, for example by teeing it to another
    // local or by performing a branching or trapping cast on it. As a
    // conservative approximation, consider the parameter used if any of the
    // expressions between the local.get and a function call have non-removable
    // side effects (even if those side effects do not depend on the value
    // flowing from the get).
    for (Index i = expressionStack.size() - 1; i > 0; --i) {
      auto* expr = expressionStack[i];
      auto* parent = expressionStack[i - 1];

      if (auto* call = parent->dynCast<Call>()) {
        handleDirectForwardedParam(curr, expr, call);
        return;
      }
      if (auto* call = parent->dynCast<CallIndirect>();
          call && expr != call->target && optimizeReferencedFuncs) {
        handleIndirectForwardedParam(
          curr, expr, call->operands, call->heapType);
        return;
      }
      if (auto* call = parent->dynCast<CallRef>();
          call && expr != call->target && optimizeReferencedFuncs) {
        if (!call->target->type.isSignature()) {
          // The call will never happen, so we don't need to consider it.
          return;
        }
        auto heapType = call->target->type.getHeapType();
        handleIndirectForwardedParam(curr, expr, call->operands, heapType);
        return;
      }

      // If the parameter flows into an If condition, we must consider it used
      // because removing it may visibly change which arm of the If gets
      // executed. This is not captured by the effects analysis below.
      if (auto* iff = parent->dynCast<If>(); iff && expr == iff->condition) {
        break;
      }

      // If the current parent expression has unremovable side effects, we
      // conservatively treat the parameter as used.
      EffectAnalyzer effects(getPassOptions(), *getModule());
      effects.visit(parent);
      if (effects.hasUnremovableSideEffects()) {
        // Conservatively assume this expression uses the parameter value
        // in some way that prevents us from removing it.
        break;
      }

      if (!parent->type.isConcrete()) {
        // The value flows no further, so it is not used in an observable way.
        return;
      }
      // TODO: Once we analyze return values, consider the case where this
      // parameter is used only if the return value of this function is used.
    }
    // The parameter value is used by something other than a call.
    funcInfos[index].paramUsages[curr->index] = used.getTop();
  }
};

void DAE2::analyzeModule() {
  // Initialize the function infos. (The type infos are initialized
  // on-demand instead.)
  funcInfos = std::vector<FunctionInfo>(wasm->functions.size());
  for (Index i = 0; i < funcInfos.size(); ++i) {
    auto numParams = wasm->functions[i]->getNumParams();
    funcInfos[i].paramUsages.resize(numParams, used.getBottom());
    funcInfos[i].callerParams.resize(numParams);
  }

  // Analyze functions to find forwarded and used parameters as well as
  // function references and other relevant information.
  GraphBuilder builder(used, funcIndices, funcInfos, optimizeReferencedFuncs);
  builder.run(getPassRunner(), wasm);

  // Find additional function references at the module level.
  builder.walkModuleCode(wasm);

  // Model imported and exported functions as referenced so that marking the
  // parameters of their types as used will prevent optimizations of the
  // functions themselves.
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
  // their parameters as used.
  for (Index i = 0; i < wasm->functions.size(); ++i) {
    if (funcInfos[i].usedInIntrinsic) {
      markParamsUsed(i);
    }
  }

  // Functions passed to configureAll will be called externally. Mark their
  // parameters as used. configureAll is only available when custom
  // descriptors is enabled.
  if (wasm->features.hasCustomDescriptors()) {
    for (auto name : Intrinsics(*wasm).getConfigureAllFunctions()) {
      markParamsUsed(name);
    }
  }

  // If we're not optimizing referenced functions, mark all their parameters as
  // used.
  if (!optimizeReferencedFuncs) {
    for (Index i = 0; i < wasm->functions.size(); ++i) {
      if (funcInfos[i].referenced) {
        markParamsUsed(i);
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
  publicHeapTypes = ModuleUtils::getPublicHeapTypes(*wasm);
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
  }
}

void DAE2::prepareReverseGraph() {
  // Compute the reverse graph used by the fixed point analysis from the
  // forward graph we have built.
  for (Index i = 0; i < funcInfos.size(); ++i) {
    funcInfos[i].callerParams.resize(funcInfos[i].paramUsages.size());
    if (funcInfos[i].referenced) {
      auto root = getRootType(wasm->functions[i]->type.getHeapType());
      getTypeTreeInfo(root).referencedFuncs.push_back(i);
    }
  }
  for (Index callerIndex = 0; callerIndex < funcInfos.size(); ++callerIndex) {
    for (auto& [callee, forwarded] :
         funcInfos[callerIndex].directForwardedParams) {
      auto& callerParams = funcInfos[funcIndices.at(callee)].callerParams;
      for (auto& [srcParam, destParam] : forwarded) {
        assert(destParam < callerParams.size());
        callerParams[destParam].push_back({callerIndex, srcParam});
      }
    }
    for (auto& [calleeRootType, forwarded] :
         funcInfos[callerIndex].indirectForwardedParams) {
      assert(getRootType(calleeRootType) == calleeRootType);
      auto& callerParams = getTypeTreeInfo(calleeRootType).callerParams;
      for (auto& [srcParam, destParam] : forwarded) {
        assert(destParam < callerParams.size());
        callerParams[destParam].push_back({callerIndex, srcParam});
      }
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
  using Item = std::variant<FuncParamLoc, TypeParamLoc>;

  // List of params, either of functions or root function types, from which we
  // may need to propagate usage information. Initialized with all params we
  // have observed to be used in the IR.
  std::vector<Item> work;
  for (Index i = 0; i < funcInfos.size(); ++i) {
    for (Index j = 0; j < funcInfos[i].paramUsages.size(); ++j) {
      if (funcInfos[i].paramUsages[j]) {
        work.push_back(FuncParamLoc{i, j});
      }
    }
  }
  for (auto& [rootType, info] : typeTreeInfos) {
    for (Index i = 0; i < info.paramUsages.size(); ++i) {
      if (info.paramUsages[i]) {
        work.push_back(TypeParamLoc{rootType, i});
      }
    }
  }
  while (!work.empty()) {
    auto item = work.back();
    work.pop_back();

    if (auto* loc = std::get_if<TypeParamLoc>(&item)) {
      auto [rootType, calleeParamIndex] = *loc;
      auto& typeTreeInfo = getTypeTreeInfo(rootType);
      const auto& elem = typeTreeInfo.paramUsages[calleeParamIndex];
      assert(elem && "unexpected unused param");

      // Propagate usage back to forwarded parameters of indirect callers.
      for (auto param : typeTreeInfo.callerParams[calleeParamIndex]) {
        if (join(param, elem)) {
          work.push_back(param);
        }
      }
      // Propagate usage to referenced functions with types in the same type
      // tree to ensure their types can all be updated uniformly.
      for (auto funcIndex : typeTreeInfo.referencedFuncs) {
        FuncParamLoc param = {funcIndex, calleeParamIndex};
        if (join(param, elem)) {
          work.push_back(param);
        }
      }
      continue;
    }

    if (auto* loc = std::get_if<FuncParamLoc>(&item)) {
      auto [calleeIndex, calleeParamIndex] = *loc;
      auto& calleeInfo = funcInfos[calleeIndex];
      const auto& elem = calleeInfo.paramUsages[calleeParamIndex];
      assert(elem && "unexpected unused param");

      // Propagate usage back to forwarded params of direct callers.
      for (auto param : calleeInfo.callerParams[calleeParamIndex]) {
        if (join(param, elem)) {
          work.push_back(param);
        }
      }

      if (calleeInfo.referenced) {
        // Propagate the use to the function type. It will be propagated from
        // there to indirect callers of this type.
        auto calleeType = wasm->functions[calleeIndex]->type.getHeapType();
        TypeParamLoc param = {getRootType(calleeType), calleeParamIndex};
        if (join(param, elem)) {
          work.push_back(param);
        }
      }
      continue;
    }
    WASM_UNREACHABLE("unexpected item");
  }
}

// Updates function signatures throughout the module. Ensures that all functions
// within the same subtyping tree have the same parameters removed, maintaining
// the validity of the subtyping hierarchy.
struct DAETypeUpdater : GlobalTypeRewriter {
  DAE2& parent;
  DAETypeUpdater(DAE2& parent)
    : GlobalTypeRewriter(*parent.wasm), parent(parent) {}

  void modifySignature(HeapType oldType, Signature& sig) override {
    // All signature types in a type tree will have the same parameters removed
    // to keep subtyping valid. Look up which parameters to keep by the root
    // type in the tree.
    auto& usages = parent.getTypeTreeInfo(getRootType(oldType)).paramUsages;
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
    bool hasRemoved = std::any_of(
      paramUsages.begin(), paramUsages.end(), [&](auto& use) { return !use; });

    bool hasNewNonNullableLocal = false;
    if (hasRemoved) {
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
      // parameters. This ensures that newly added locals get the right indices.
      // Preserve sharedness in case this becomes the permanent new type (when
      // GC is disabled, see below).
      Signature sig(Type(keptParams), func->getResults());
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

  void visitLocalSet(LocalSet* curr) { curr->index = newIndices[curr->index]; }

  void visitLocalGet(LocalGet* curr) {
    // If this is a get of a removed parameter, we need to make it disappear
    // along with all of its parents until we reach a call or the value is no
    // longer propagated. We know removing these expressions is ok because if
    // any of them had non-removable side effects, we would not be optimizing
    // out the parameter.
    if (curr->index < funcInfo->paramUsages.size() &&
        !funcInfo->paramUsages[curr->index] &&
        funcInfo->paramGets.count(curr)) {
      for (Index i = expressionStack.size(); i > 0; --i) {
        auto* expr = expressionStack[i - 1];
        if (expr->is<Call>() || expr->is<CallIndirect>() ||
            expr->is<CallRef>()) {
          break;
        }
        if (!removedExpressions.insert(expr).second) {
          // This expression, and therefore its relevant parents, have already
          // been marked, so we do not need to continue.
          break;
        }
        if (!expr->type.isConcrete()) {
          // The value does not flow further, so stop removing.
          break;
        }
      }
    }
    curr->index = newIndices[curr->index];
  }

  // Given an expression, return a new expression containing all its non-removed
  // parts, if any, or otherwise nullptr. The returned expression will have
  // non-concrete type because its value will have been removed.
  Expression* getReplacement(Expression* curr);

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
    removeOperands(
      curr,
      curr->operands,
      parent.funcInfos[parent.funcIndices.at(curr->target)].paramUsages);
  }

  void handleIndirectCall(Expression* curr,
                          ExpressionList& operands,
                          HeapType type) {
    if (!parent.optimizeReferencedFuncs) {
      return;
    }
    auto it = parent.typeTreeInfos.find(getRootType(type));
    if (it == parent.typeTreeInfos.end()) {
      // No analysis results for this type, so none of its parameters are used.
      removeOperands(curr, operands, {});
    } else {
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

  void visitExpression(Expression* curr) {
    if (curr->type.isConcrete()) {
      // If this expression should be removed, that will be handled by the call
      // or non-concrete expression it ultimately flows into.
      return;
    }
    if (!removedExpressions.count(curr)) {
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
};

Expression* Optimizer::getReplacement(Expression* curr) {
  Builder builder(*getModule());
  if (!removedExpressions.count(curr)) {
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

      if (!self->removedExpressions.count(curr)) {
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

    auto newSig =
      updateSignature({Type(std::move(keptParams)), func->getResults()});

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

} // anonymous namespace

Pass* createDAE2Pass() { return new DAE2(); }

} // namespace wasm
