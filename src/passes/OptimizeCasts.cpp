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
// Refine uses of locals where possible. For example, consider this:
//
//  (some.operation
//    (ref.cast .. (local.get $ref))
//    (local.get $ref)
//  )
//
// The second use might as well use the refined/cast value as well:
//
//  (some.operation
//    (local.tee $temp
//      (ref.cast .. (local.get $ref))
//    )
//    (local.get $temp)
//  )
//
// This change adds a local but it switches some local.gets to use a local of a
// more refined type. That can help other optimizations later.
//
// An example of an important pattern this handles are itable calls:
//
//  (call_ref
//    (ref.cast $actual.type
//      (local.get $object)
//    )
//    (struct.get $vtable ..
//      (ref.cast $vtable
//        (struct.get $itable ..
//          (local.get $object)
//        )
//      )
//    )
//  )
//
// We cast to the actual type for the |this| parameter, but we technically do
// not need to do so for reading its itable - since the itable may be of a
// generic type, and we cast the vtable afterwards anyhow. But since we cast
// |this|, we can use the cast value for the itable get, which may then lead to
// removing the vtable cast after we refine the itable type. And that can lead
// to devirtualization later.
//
// Closely related things appear in other passes:
//
//  * SimplifyLocals will find locals already containing a more refined type and
//    switch to them. RedundantSetElimination does the same across basic blocks.
//    In theory one of them could be extended to also add new locals, and then
//    they would be doing something similar to this pass.
//  * LocalCSE finds repeated expressions and stores them in locals for use
//    later. In theory that pass could be extended to look not for exact copies
//    but for equivalent things through a cast, and then it would be doing
//    something similar to this pass.
//
// However, while those other passes could be extended to cover what this pass
// does, we will have further cast-specific optimizations to add, which make
// sense in new pass anyhow, and things should be simpler overall to keep such
// casts all in one pass, here.
//
// Also, we can move more refined casts earlier in a basic block before applying
// the above optimization. This may allow more refined casts to be used by the
// optimization earlier and allow trapping casts to trap earlier. For instance,
// the below example:
//
//  (some.operation
//    (local.get $ref)
//    (ref.cast .. (local.get $ref))
//  )
//
// could be converted to:
//
//  (some.operation
//    (ref.cast (local.get $ref))
//    (ref.cast .. (local.get $ref))
//  )
//
// TODO: 1. Move casts earlier in a basic block as well, at least in
//          traps-never-happen mode where we can assume they never fail, and
//          perhaps in other situations too.
// TODO: 2. Look past individual basic blocks? This may be worth considering
//          given the pattern of a cast appearing in an if condition that is
//          then used in an if arm, for example, where simple dominance shows
//          the cast can be reused.
// TODO: 3. Look at LocalSet as well and not just Get. That would add some
//          overlap with the other passes mentioned above (SimplifyLocals and
//          RedundantSetElimination also track sets and can switch a get to use
//          a better set's index when that refines the type). But once we do the
//          first two TODOs above then we'd be adding some novel things here,
//          as we could optimize "backwards" as well (TODO 1) and past basic
//          blocks (TODO 2, though RedundantSetElimination does that as well).
//          However, we should consider whether improving those other passes
//          might make more sense (as it would help more than casts, if we could
//          make them operate "backwards" and/or past basic blocks).
//

#include "ir/effects.h"
#include "ir/linear-execution.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// For a local index, checks the earliest local get to which a cast can be
// moved. The IndexEarlyCastSearcher will attempt to move the most refined cast
// which is possible to be moved. EffectAnalyzers are used to check if the move
// can be done without unwanted side-effects.
struct IndexEarlyCastSearcher {
  PassOptions& options;
  Module& module;

  // The list of expressions to which a cast immediately after the currently
  // visited expression can be moved to. Currently we only track LocalGets.
  std::vector<Expression*> moveableExpressions;

  // EffectAnalyzers for expressions in moveableExpressions.
  std::unordered_map<Expression*, EffectAnalyzer> effectAnalyzers;

  // The earliest expression in moveableExpressions which a RefAs can be moved
  // to.
  size_t earliestRefAsEligible;

  // The earliest expression in moveableExpressions which a RefCast can be moved
  // to.
  size_t earliestRefCastEligible;

  // "Dummy" casts which are used to test for side effects.
  RefAs sampleRefAs;
  RefCast sampleRefCast;
  EffectAnalyzer testRefAs;
  EffectAnalyzer testRefCast;

  // The two maps map an expression to the "best" cast which will be moved to
  // it. This is used as the final result in the end.
  std::unordered_map<Expression*, RefAs*> refAsReplacement;
  std::unordered_map<Expression*, RefCast*> refCastReplacement;

  // A cast should not be moved to its fallthrough local get, as this would be
  // redundant. However, we may initially mark the cast as the best for its
  // local get so it can be compared against later casts. These sets store these
  // "redundant" casts which have not been replaced and need to be removed.
  std::unordered_set<Expression*> redundantRefAsReplacement;
  std::unordered_set<Expression*> redundantRefCastReplacement;

  IndexEarlyCastSearcher(PassOptions& options, Module& module)
    : options(options), module(module), earliestRefAsEligible(0),
      earliestRefCastEligible(0), sampleRefAs(module.allocator),
      sampleRefCast(module.allocator), testRefAs(options, module),
      testRefCast(options, module) {
    testRefAs.visit(&sampleRefAs);
    testRefCast.visit(&sampleRefCast);
  }

  // For each expression, check whether a cast can be moved past it.
  void visitExpression(Expression* curr) {
    for (size_t i = 0; i < moveableExpressions.size(); i++) {
      // Each expression's EffectAnalyzer visits the new expression
      EffectAnalyzer& currEffectAnalyzer =
        effectAnalyzers.at(moveableExpressions.at(i));
      currEffectAnalyzer.visit(curr);

      // Check for side-effects when moving RefAs and RefCast expressions past
      // the new expression.
      if (currEffectAnalyzer.invalidates(testRefAs)) {
        earliestRefAsEligible = i + 1;
      }

      if (currEffectAnalyzer.invalidates(testRefCast)) {
        earliestRefCastEligible = i + 1;
      }
    }

    // If both RefAs and RefCast can no longer be moved up to an expression
    // then we need to delete it.
    if (earliestRefAsEligible > 0 && earliestRefCastEligible > 0) {
      size_t minIndex =
        std::min(earliestRefAsEligible, earliestRefCastEligible);
      for (size_t i = 0; i < minIndex; i++) {
        effectAnalyzers.erase(moveableExpressions.at(i));
      }
      moveableExpressions.erase(moveableExpressions.begin(),
                                moveableExpressions.begin() + minIndex);
      earliestRefAsEligible -= minIndex;
      earliestRefCastEligible -= minIndex;
    }
  }

  void visitLocalGet(LocalGet* curr, Module& module) {
    moveableExpressions.push_back(curr);
    EffectAnalyzer currEffectAnalyzer(options, module);
    currEffectAnalyzer.visit(curr);
    effectAnalyzers.emplace(curr, currEffectAnalyzer);
  }

  void visitLocalSet(LocalSet* curr) {
    moveableExpressions.clear();
    effectAnalyzers.clear();
    earliestRefAsEligible = 0;
    earliestRefCastEligible = 0;
  }

  void visitRefAs(RefAs* curr, LocalGet* fallthrough) {
    auto iter = refAsReplacement.find(moveableExpressions.front());
    if (iter == refAsReplacement.end()) {
      // Since RefAs ops are orthogonal to each other, we currently just
      // select the first RefAs we come accross which is moveable.
      refAsReplacement.emplace(moveableExpressions.front(), curr);
      if (fallthrough == moveableExpressions.front()) {
        redundantRefAsReplacement.insert(fallthrough);
      }
    }
  }

  void visitRefCast(RefCast* curr, LocalGet* fallthrough) {
    auto iter = refCastReplacement.find(moveableExpressions.front());
    if (iter == refCastReplacement.end()) {
      refCastReplacement.emplace(moveableExpressions.front(), curr);
      if (fallthrough == moveableExpressions.front()) {
        redundantRefCastReplacement.insert(fallthrough);
      }
    } else if (curr->type != iter->second->type &&
               Type::isSubType(curr->type, iter->second->type)) {
      iter->second = curr;
      if (fallthrough != iter->first) {
        redundantRefCastReplacement.erase(iter->first);
      }
    }
  }

  void removeRedundantReplacements() {
    for (auto& redundantRefAs : redundantRefAsReplacement) {
      refAsReplacement.erase(redundantRefAs);
    }
    for (auto& redundantRefCast : redundantRefCastReplacement) {
      refCastReplacement.erase(redundantRefCast);
    }
  }
};

// Find the "best" cast to move earlier to another local.gets
struct EarlyCastFinder
  : public LinearExecutionWalker<EarlyCastFinder,
                                 UnifiedExpressionVisitor<EarlyCastFinder>> {
  PassOptions options;

  // For each local index, we have an searcher to move casts for it.
  std::unordered_map<Index, IndexEarlyCastSearcher> castMoveSearchers;

  // Maps local.gets to the "best" RefAs to move to it.
  std::unordered_map<Expression*, RefAs*> refAsToApply;

  // Maps local.gets to the "best" RefCast to move to it.
  std::unordered_map<Expression*, RefCast*> refCastToApply;

  static void doNoteNonLinear(EarlyCastFinder* self, Expression**) {
    self->castMoveSearchers.clear();
  }

  void visitExpression(Expression* curr) {
    for (auto& indexSearcher : castMoveSearchers) {
      indexSearcher.second.visitExpression(curr);
    }
  }

  void visitLocalSet(LocalSet* curr) {
    for (auto& indexSearcher : castMoveSearchers) {
      indexSearcher.second.visitExpression(curr);
    }
    auto iter = castMoveSearchers.find(curr->index);
    if (iter != castMoveSearchers.end()) {
      iter->second.visitLocalSet(curr);
    }
  }

  void visitLocalGet(LocalGet* curr) {
    for (auto& indexSearcher : castMoveSearchers) {
      indexSearcher.second.visitExpression(curr);
    }
    auto iter = castMoveSearchers.find(curr->index);
    if (iter == castMoveSearchers.end()) {
      RefCast testRefCast(getModule()->allocator);
      EffectAnalyzer efa(options, *getModule());
      efa.visit(&testRefCast);
      IndexEarlyCastSearcher searcher(options, *getModule());
      searcher.visitLocalGet(curr, *getModule());
      castMoveSearchers.emplace(curr->index, searcher);
    } else {
      iter->second.visitLocalGet(curr, *getModule());
    }
  }

  void visitRefAs(RefAs* curr) {
    for (auto& indexSearcher : castMoveSearchers) {
      indexSearcher.second.visitExpression(curr);
    }
    // Currently we only consider casts whose immediate child is a local get.
    if (auto* get = curr->value->dynCast<LocalGet>()) {
      castMoveSearchers.at(get->index).visitRefAs(curr, get);
    }
  }

  void visitRefCast(RefCast* curr) {
    for (auto& indexSearcher : castMoveSearchers) {
      indexSearcher.second.visitExpression(curr);
    }
    // Currently we only consider casts whose immediate child is a local get.
    if (auto* get = curr->ref->dynCast<LocalGet>()) {
      castMoveSearchers.at(get->index).visitRefCast(curr, get);
    }
  }

  void collectCastMoves() {
    for (auto& indexSearcher : castMoveSearchers) {
      indexSearcher.second.removeRedundantReplacements();
      refAsToApply.merge(indexSearcher.second.refAsReplacement);
      refCastToApply.merge(indexSearcher.second.refCastReplacement);
    }
  }
};

// Given a set of RefAs and RefCast casts to move to specified
// earlier expressions, duplicate the cast at the specified
// earlier expression. The original cast that we are moving will
// be optimized out by a later pass once we have applied the same
// cast earlier.
struct EarlyCastApplier : public PostWalker<EarlyCastApplier> {
  EarlyCastFinder& finder;

  EarlyCastApplier(EarlyCastFinder& finder) : finder(finder) {}

  // At present, only one cast is applied to an expression, with preference
  // for a RefCast over a RefAs. This can easily be changed to apply both
  // casts if both exist. Furthermore, we could change this to potentially
  // move multiple casts to the same expression.
  void visitLocalGet(LocalGet* curr) {
    auto refCastIter = finder.refCastToApply.find(curr);
    if (refCastIter != finder.refCastToApply.end()) {
      replaceCurrent(Builder(*getModule())
                       .makeRefCast(curr,
                                    refCastIter->second->type,
                                    refCastIter->second->safety));
      return;
    }

    auto refAsIter = finder.refAsToApply.find(curr);
    if (refAsIter != finder.refAsToApply.end()) {
      replaceCurrent(
        Builder(*getModule()).makeRefAs(refAsIter->second->op, curr));
      return;
    }
  }
};

// Find the best casted verisons of local.gets: other local.gets with the same
// value, but cast to a more refined type.
struct BestCastFinder : public LinearExecutionWalker<BestCastFinder> {

  PassOptions options;

  // Map local indices to the most refined downcastings of local.gets from those
  // indices.
  //
  // This is tracked in each basic block, and cleared between them.
  std::unordered_map<Index, Expression*> mostCastedGets;

  // For each most-downcasted local.get, a vector of other local.gets that could
  // be replaced with gets of the downcasted value.
  //
  // This is tracked until the end of the entire function, and contains the
  // information we need to optimize later. That is, entries here are things we
  // want to apply.
  std::unordered_map<Expression*, std::vector<LocalGet*>> lessCastedGets;

  static void doNoteNonLinear(BestCastFinder* self, Expression** currp) {
    self->mostCastedGets.clear();
  }

  void visitLocalSet(LocalSet* curr) {
    // Clear any information about this local; it has a new value here.
    mostCastedGets.erase(curr->index);
  }

  void visitLocalGet(LocalGet* curr) {
    auto iter = mostCastedGets.find(curr->index);
    if (iter != mostCastedGets.end()) {
      auto* bestCast = iter->second;
      if (curr->type != bestCast->type &&
          Type::isSubType(bestCast->type, curr->type)) {
        // The best cast has a more refined type, note that we want to use it.
        lessCastedGets[bestCast].push_back(curr);
      }
    }
  }

  void visitRefAs(RefAs* curr) { handleRefinement(curr); }

  void visitRefCast(RefCast* curr) { handleRefinement(curr); }

  void handleRefinement(Expression* curr) {
    auto* fallthrough = Properties::getFallthrough(curr, options, *getModule());
    if (auto* get = fallthrough->dynCast<LocalGet>()) {
      auto*& bestCast = mostCastedGets[get->index];
      if (!bestCast) {
        // This is the first.
        bestCast = curr;
        return;
      }

      // See if we are better than the current best.
      if (curr->type != bestCast->type &&
          Type::isSubType(curr->type, bestCast->type)) {
        bestCast = curr;
      }
    }
  }
};

// Given a set of best casts, apply them: save each best cast in a local and use
// it in the places that want to.
//
// It is simpler to do this in another pass after BestCastFinder so that we do
// not need to worry about corner cases with invalidation of pointers in things
// we've already walked past.
struct FindingApplier : public PostWalker<FindingApplier> {
  BestCastFinder& finder;

  FindingApplier(BestCastFinder& finder) : finder(finder) {}

  void visitRefAs(RefAs* curr) { handleRefinement(curr); }

  void visitRefCast(RefCast* curr) { handleRefinement(curr); }

  void handleRefinement(Expression* curr) {
    auto iter = finder.lessCastedGets.find(curr);
    if (iter == finder.lessCastedGets.end()) {
      return;
    }

    // This expression was the best cast for some gets. Add a new local to
    // store this value, then use it for the gets.
    auto var = Builder::addVar(getFunction(), curr->type);
    auto& gets = iter->second;
    for (auto* get : gets) {
      get->index = var;
      get->type = curr->type;
    }

    // Replace ourselves with a tee.
    replaceCurrent(Builder(*getModule()).makeLocalTee(var, curr, curr->type));
  }
};

} // anonymous namespace

struct OptimizeCasts : public WalkerPass<PostWalker<OptimizeCasts>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<OptimizeCasts>();
  }

  void doWalkFunction(Function* func) {
    if (!getModule()->features.hasGC()) {
      return;
    }

    // Look for casts which can be moved earlier
    EarlyCastFinder earlyCastFinder;
    earlyCastFinder.options = getPassOptions();
    earlyCastFinder.walkFunctionInModule(func, getModule());
    earlyCastFinder.collectCastMoves();

    // If there are casts which can be moved earlier, duplicate them to those
    // locations
    if (!earlyCastFinder.refAsToApply.empty() ||
        !earlyCastFinder.refCastToApply.empty()) {
      EarlyCastApplier earlyCastApplier(earlyCastFinder);
      earlyCastApplier.walkFunctionInModule(func, getModule());
    }

    // Find the best casts that we want to use.
    BestCastFinder finder;
    finder.options = getPassOptions();
    finder.walkFunctionInModule(func, getModule());

    if (finder.lessCastedGets.empty()) {
      // Nothing to do.
      return;
    }

    // Apply the requests: use the best casts.
    FindingApplier applier(finder);
    applier.walkFunctionInModule(func, getModule());

    // LocalGet type changes must be propagated.
    ReFinalize().walkFunctionInModule(func, getModule());
  }
};

Pass* createOptimizeCastsPass() { return new OptimizeCasts(); }

} // namespace wasm
