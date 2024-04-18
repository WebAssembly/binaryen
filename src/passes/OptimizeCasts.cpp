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
// Note that right now, we only consider RefAs with op RefAsNonNull as a cast.
// RefAs with ExternInternalize and ExternExternalize are not considered casts
// when obtaining fallthroughs, and so are ignored.
//
// TODO: Look past individual basic blocks? This may be worth considering
//       given the pattern of a cast appearing in an if condition that is
//       then used in an if arm, for example, where simple dominance shows
//       the cast can be reused.

#include "ir/effects.h"
#include "ir/linear-execution.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// Contains information about a RefCast we want to move to a target LocalGet.
struct RefCastInfo {
  LocalGet* target = nullptr;
  RefCast* bestCast = nullptr;
};

// Contains information about a RefAs we want to move to a target LocalGet.
// Currently only RefAsNonNull will be moved.
struct RefAsInfo {
  LocalGet* target = nullptr;
  RefAs* bestCast = nullptr;
};

// Find a cast to move earlier to another local.get. More refined subtypes are
// chosen over less refined ones.
struct EarlyCastFinder
  : public LinearExecutionWalker<EarlyCastFinder,
                                 UnifiedExpressionVisitor<EarlyCastFinder>> {
  PassOptions options;
  size_t numLocals;

  // For each local index, tracks the current earliest local.get that we can
  // move a cast to without side-effects, and the most refined cast that we can
  // move to it (could be already at the earliest local.get).
  //
  // Note that we track a cast already on the get since we only want to move
  // better casts to it: if the best cast is already on the get, there is no
  // work to do.
  std::vector<RefCastInfo> currRefCastMove;
  std::vector<RefAsInfo> currRefAsMove;

  // Used to analyze expressions to see if casts can be moved past them.
  EffectAnalyzer testRefCast;
  EffectAnalyzer testRefAs;

  // Maps LocalGets to the most refined RefCast to move to it, to be used by the
  // EarlyCastApplier. If the most refined RefCast is already at the desired
  // LocalGet, it does not appear here. In the normal case, only one RefCast
  // needs to be moved to a LocalGet; if a LocalGet is cast to multiple types
  // which are not subtypes of each other then a trap is inevitable, and we
  // assume this would already be optimized away beforehand, so we don't care
  // about this special case.
  std::unordered_map<LocalGet*, RefCast*> refCastToApply;

  // Maps LocalGets to a RefAs to move to it, to be used by the
  // EarlyCastApplier. As of right now RefAsNonNull is the only non-extern cast,
  // so we only have one type of RefAs cast to move.
  std::unordered_map<LocalGet*, RefAs*> refAsToApply;

  EarlyCastFinder(PassOptions options, Module* module, Function* func)
    : options(options), numLocals(func->getNumLocals()),
      currRefCastMove(func->getNumLocals()),
      currRefAsMove(func->getNumLocals()), testRefCast(options, *module),
      testRefAs(options, *module) {

    // TODO: generalize this when we handle more than RefAsNonNull.
    RefCast dummyRefCast(module->allocator);
    RefAs dummyRefAs(module->allocator);
    dummyRefAs.op = RefAsNonNull;

    testRefCast.visit(&dummyRefCast);
    testRefAs.visit(&dummyRefAs);
  }

  // We track information as we go, looking for the best cast to move backwards,
  // and when we hit a barrier - a position we can't optimize past - then we
  // flush/finalize the work we've done so far, since nothing better can appear
  // later. We ignore the best cast if it is already at the desired location.
  void flushRefCastResult(size_t index, Module& module) {
    auto& target = currRefCastMove[index].target;
    if (target) {
      auto& bestCast = currRefCastMove[index].bestCast;
      if (bestCast) {
        // If the fallthrough is equal to the target, this means the cast is
        // already at the target local.get and doesn't need to be duplicated
        // again.
        auto* fallthrough =
          Properties::getFallthrough(bestCast, options, module);
        if (fallthrough != target) {
          refCastToApply[target] = bestCast;
        }
        bestCast = nullptr;
      }
      target = nullptr;
    }
  }

  // Does the same as above function, but for RefAs instead of RefCast.
  void flushRefAsResult(size_t index, Module& module) {
    auto& target = currRefAsMove[index].target;
    if (target) {
      auto& bestCast = currRefAsMove[index].bestCast;
      if (bestCast) {
        // As in flushRefCastResult, we need to check if the cast is already at
        // the target and thus does not need to be moved.
        auto* fallthrough =
          Properties::getFallthrough(bestCast, options, module);
        if (fallthrough != target) {
          refAsToApply[target] = bestCast;
        }
        bestCast = nullptr;
      }
      target = nullptr;
    }
  }

  inline void flushAll() {
    for (size_t i = 0; i < numLocals; i++) {
      flushRefCastResult(i, *getModule());
      flushRefAsResult(i, *getModule());
    }
  }

  static void doNoteNonLinear(EarlyCastFinder* self, Expression** currp) {
    self->flushAll();
  }

  void visitFunction(Function* curr) { flushAll(); }

  void visitExpression(Expression* curr) {
    // A new one is instantiated for each expression to determine
    // if a cast can be moved past it.
    ShallowEffectAnalyzer currAnalyzer(options, *getModule(), curr);

    if (testRefCast.invalidates(currAnalyzer)) {
      for (size_t i = 0; i < numLocals; i++) {
        flushRefCastResult(i, *getModule());
      }
    }

    if (testRefAs.invalidates(currAnalyzer)) {
      for (size_t i = 0; i < numLocals; i++) {
        flushRefAsResult(i, *getModule());
      }
    }
  }

  void visitLocalSet(LocalSet* curr) {
    visitExpression(curr);

    flushRefCastResult(curr->index, *getModule());
    flushRefAsResult(curr->index, *getModule());
  }

  void visitLocalGet(LocalGet* curr) {
    visitExpression(curr);

    if (!currRefCastMove[curr->index].target) {
      currRefCastMove[curr->index].target = curr;
    }

    // As we only move RefAsNonNull RefAs casts right now, we should
    // ignore a LocalGet if the type is already non-nullable, as
    // adding an extra ref.as_non_null has no effect.
    if (!currRefAsMove[curr->index].target && curr->type.isNullable()) {
      currRefAsMove[curr->index].target = curr;
    }
  }

  void visitRefAs(RefAs* curr) {
    visitExpression(curr);

    // TODO: support more than RefAsNonNull.
    if (curr->op != RefAsNonNull) {
      return;
    }

    auto* fallthrough = Properties::getFallthrough(curr, options, *getModule());
    if (auto* get = fallthrough->dynCast<LocalGet>()) {
      auto& bestMove = currRefAsMove[get->index];
      if (bestMove.target && !bestMove.bestCast) {
        bestMove.bestCast = curr;
      }
    }
  }

  void visitRefCast(RefCast* curr) {
    visitExpression(curr);

    // Using fallthroughs here is fine due to the following cases.
    // Suppose we have types $A->$B->$C (where $C is the most refined)
    // and $D, which is an unrelated type.
    // Case 1:
    // (ref.cast $A (ref.cast $C (local.get $x)))
    //
    // ref.cast $C is initially chosen for $x. Then we consider ref.cast $A.
    // Since $A is less refined than $C, we ignore it.
    //
    // Case 2:
    // (ref.cast $C (ref.cast $A (local.get $x)))
    //
    // ref.cast $A is initially chosen for $x. Then we consider ref.cast $C,
    // which is more refined than ref.cast $A, so we replace it with ref.cast
    // $C.
    //
    // Case 3:
    // (ref.cast $B (ref.cast $B (local.get $x)))
    //
    // We initially choose to move the inner ref.cast $B. When we consider the
    // outer ref.cast $B, we can see that it has the same type as tge existing
    // ref.cast $B, so we ignore it.
    //
    // Case 4:
    // (ref.cast $D (ref.cast $C (local.get $x)))
    //
    // This would produce a trap and should already be optimized away
    // beforehand.
    //
    // If the best cast is already at the target location, we will still track
    // it in currRefCastMove to see if we can obtain a better cast. However, we
    // won't flush it.

    auto* fallthrough = Properties::getFallthrough(curr, options, *getModule());
    if (auto* get = fallthrough->dynCast<LocalGet>()) {
      auto& bestMove = currRefCastMove[get->index];
      // Do not move a cast if its type is not related to the target
      // local.get's type (i.e. not in a subtyping relationship). Otherwise
      // a type error will occur. Also, if the target local.get's type is
      // already more refined than this current cast, there is no point in
      // moving it.
      if (bestMove.target && bestMove.target->type != curr->type &&
          Type::isSubType(curr->type, bestMove.target->type)) {
        if (!bestMove.bestCast) {
          // If there isn't any other cast to move, the current cast is the
          // best.
          bestMove.bestCast = curr;
        } else if (bestMove.bestCast->type != curr->type &&
                   Type::isSubType(curr->type, bestMove.bestCast->type)) {
          // If the current cast is more refined than the best cast to move,
          // change the best cast to move.
          bestMove.bestCast = curr;
        }
        // We don't care about the safety of the cast at present. If there are
        // two casts with the same type one being safe and one being unsafe, the
        // first cast that we visit will be chosen to be moved. Perhaps in the
        // future we can consider prioritizing unsafe casts over safe ones since
        // users may be more interested in that.
      }
    }
  }

  bool hasCastsToMove() {
    return refCastToApply.size() > 0 || refAsToApply.size() > 0;
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

  // RefCast casts are applied before RefAs casts. If there are multiple
  // casts to apply to a location, they are nested within one another. Only
  // at most one RefCast and at most one RefAs can be applied.
  void visitLocalGet(LocalGet* curr) {
    Expression* currPtr = curr;

    auto refCastIter = finder.refCastToApply.find(curr);
    if (refCastIter != finder.refCastToApply.end()) {
      currPtr = replaceCurrent(
        Builder(*getModule()).makeRefCast(currPtr, refCastIter->second->type));
    }

    auto refAsIter = finder.refAsToApply.find(curr);
    if (refAsIter != finder.refAsToApply.end()) {
      replaceCurrent(
        Builder(*getModule()).makeRefAs(refAsIter->second->op, currPtr));
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

  // It is ok to look at adjacent blocks together, as if a later part of a block
  // is not reached that is fine - changes we make there would not be reached in
  // that case.
  //
  // Note that we *cannot* do the same in EarlyCastFinder, as it modifies the
  // earlier code in a dangerous way: it may move a trap to an earlier position.
  // We cannot move a trap before a branch, as perhaps the branch is all that
  // prevented us from trapping.
  bool connectAdjacentBlocks = true;

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
    auto* teeFallthrough = Properties::getFallthrough(
      curr, options, *getModule(), Properties::FallthroughBehavior::NoTeeBrIf);
    if (auto* tee = teeFallthrough->dynCast<LocalSet>()) {
      updateBestCast(curr, tee->index);
    }
    auto* fallthrough =
      Properties::getFallthrough(teeFallthrough, options, *getModule());
    if (auto* get = fallthrough->dynCast<LocalGet>()) {
      updateBestCast(curr, get->index);
    }
  }

  void updateBestCast(Expression* curr, Index index) {
    auto*& bestCast = mostCastedGets[index];
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

    // Look for casts which can be moved earlier.
    EarlyCastFinder earlyCastFinder(getPassOptions(), getModule(), func);
    earlyCastFinder.walkFunctionInModule(func, getModule());

    if (earlyCastFinder.hasCastsToMove()) {
      // Duplicate casts to earlier locations if possible.
      EarlyCastApplier earlyCastApplier(earlyCastFinder);
      earlyCastApplier.walkFunctionInModule(func, getModule());

      // Adding more casts causes types to be refined, that should be
      // propagated.
      ReFinalize().walkFunctionInModule(func, getModule());
    }

    // Find the best casts that we want to use.
    BestCastFinder finder;
    finder.options = getPassOptions();
    finder.walkFunctionInModule(func, getModule());

    if (!finder.lessCastedGets.empty()) {
      // Apply the requests: use the best casts.
      FindingApplier applier(finder);
      applier.walkFunctionInModule(func, getModule());

      // LocalGet type changes must be propagated.
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }
};

Pass* createOptimizeCastsPass() { return new OptimizeCasts(); }

} // namespace wasm
