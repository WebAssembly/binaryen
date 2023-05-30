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
// TODO: 1. Look past individual basic blocks? This may be worth considering
//          given the pattern of a cast appearing in an if condition that is
//          then used in an if arm, for example, where simple dominance shows
//          the cast can be reused.
// TODO: 2. Look at LocalSet as well and not just Get. That would add some
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

// Contains information about a RefCast we want to move to some target.
struct RefCastInfo {
  Type type;
  RefCast::Safety safety;

  // Indicate whether the cast is already at the target. If it is, then
  // the information is just for determining if a potential cast is less
  // refined than the existing cast, and will be removed later.
  bool atTarget;

  RefCastInfo() {}

  RefCastInfo(Type type, RefCast::Safety safety, bool atTarget)
    : type(type), safety(safety), atTarget(atTarget) {}
};

// Contains information about a RefAs we want to move to some target.
struct RefAsInfo {
  RefAsOp op;
  bool atTarget;

  RefAsInfo() {}

  RefAsInfo(RefAsOp op, bool atTarget) : op(op), atTarget(atTarget) {}
};

// Find casts to move earlier to another local.get. More refined subtypes are
// chosen over less refined ones.
struct EarlyCastFinder
  : public LinearExecutionWalker<EarlyCastFinder,
                                 UnifiedExpressionVisitor<EarlyCastFinder>> {
  PassOptions options;
  size_t numLocals;

  // Tracks the current earliest local.get that we can move a cast to without
  // side-effects.
  std::vector<LocalGet*> earliestRefCastReachable;
  std::vector<LocalGet*> earliestRefAsReachable;

  // Used to analyze expressions to see if casts can be moved past them.
  RefCast dummyRefCast;
  RefAs dummyRefAs;
  EffectAnalyzer testRefCast;
  EffectAnalyzer testRefAs;

  // Maps local.gets to a list of RefCast to move to it. This is the final
  // result.
  std::unordered_map<LocalGet*, SmallVector<RefCastInfo, 5>> refCastToApply;

  // Maps local.gets to a list of RefAs to move to it. This is the final result.
  std::unordered_map<LocalGet*, SmallVector<RefAsInfo, 3>> refAsToApply;

  EarlyCastFinder(PassOptions options, Module* module, Function* func)
    : options(options), numLocals(func->getNumLocals()),
      earliestRefCastReachable(func->getNumLocals(), nullptr),
      earliestRefAsReachable(func->getNumLocals(), nullptr),
      dummyRefCast(module->allocator), dummyRefAs(module->allocator),
      testRefCast(options, *module), testRefAs(options, *module) {

    // Only RefAsNonNull produces implicit traps, so we use this when analyzing
    // RefAs. ExternInternalize and ExternExternalize ops can actually be moved
    // further since they are infallible, but we don't have special cases for
    // them currently.
    dummyRefAs.op = RefAsNonNull;

    testRefCast.visit(&dummyRefCast);
    testRefAs.visit(&dummyRefAs);
  }

  static void doNoteNonLinear(EarlyCastFinder* self, Expression**) {
    for (size_t i = 0; i < self->numLocals; i++) {
      self->earliestRefCastReachable[i] = nullptr;
      self->earliestRefAsReachable[i] = nullptr;
    }
  }

  void visitExpression(Expression* curr) {
    // A new one is instantiated for each expression to determine
    // if a cast can be moved past it.
    ShallowEffectAnalyzer currAnalyzer(options, *getModule(), curr);

    if (testRefCast.invalidates(currAnalyzer)) {
      for (size_t i = 0; i < numLocals; i++) {
        earliestRefCastReachable[i] = nullptr;
      }
    }

    if (testRefAs.invalidates(currAnalyzer)) {
      for (size_t i = 0; i < numLocals; i++) {
        earliestRefAsReachable[i] = nullptr;
      }
    }
  }

  void visitLocalSet(LocalSet* curr) {
    visitExpression(curr);
    earliestRefCastReachable[curr->index] = nullptr;
    earliestRefAsReachable[curr->index] = nullptr;
  }

  void visitLocalGet(LocalGet* curr) {
    visitExpression(curr);

    if (!earliestRefCastReachable[curr->index]) {
      earliestRefCastReachable[curr->index] = curr;
    }

    if (!earliestRefAsReachable[curr->index]) {
      earliestRefAsReachable[curr->index] = curr;
    }
  }

  void visitRefAs(RefAs* curr) {
    visitExpression(curr);

    auto* fallthrough = Properties::getFallthrough(curr, options, *getModule());

    if (auto* get = fallthrough->dynCast<LocalGet>()) {
      auto& castVector = refAsToApply[earliestRefAsReachable[get->index]];
      bool alreadyAdded = false;
      for (size_t i = 0; i < castVector.size(); i++) {
        if (castVector[i].op == curr->op) {
          alreadyAdded = true;
          break;
        }
      }

      if (!alreadyAdded) {
        castVector.emplace_back(
          curr->op, get == earliestRefAsReachable[get->index]);
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
    // which is more refined than ref.cast $A, so we replace it with ref.cast $C.
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
    // We first choose to move ref.cast $C. Since $D is neither a subtype nor
    // a supertype of $C (if $B->$D, this also applies), then we add ref.cast $D
    // as an additional cast to apply. ref.cast $C is nested in ref.cast $D.
    //
    // Note that if the best cast is already at the target location, we will
    // keep it for comparison purposes but remove it once the traversal is done.

    auto* fallthrough = Properties::getFallthrough(curr, options, *getModule());
    if (auto* get = fallthrough->dynCast<LocalGet>()) {
      auto& castVector = refCastToApply[earliestRefCastReachable[get->index]];

      // If the cast's type is a completely new type (i.e. it is not a subtype
      // or a supertype of the existing type), we must move it, since it cannot
      // replace an existing cast.
      bool isNewType = true;

      for (size_t i = 0; i < castVector.size(); i++) {
        RefCastInfo& currInfo = castVector[i];
        if (curr->type != currInfo.type) {
          if (Type::isSubType(curr->type, currInfo.type)) {
            isNewType = false;
            currInfo = RefCastInfo(curr->type, curr->safety, get == earliestRefCastReachable[get->index]);
            break;
          } else if (Type::isSubType(currInfo.type, curr->type)) {
            isNewType = false;
            break;
          }
        } else {
          isNewType = false;
          if (curr->safety == RefCast::Safety::Safe) {
            currInfo.safety = RefCast::Safety::Safe;
            currInfo.atTarget = get == earliestRefCastReachable[get->index];
          }

          break;
        }
      }

      if (isNewType) {
        castVector.emplace_back(
          curr->type,
          curr->safety,
          get == earliestRefCastReachable[get->index]);
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
  // casts to apply to a location, they are nested within one another.
  void visitLocalGet(LocalGet* curr) {
    Expression* currPtr = curr;

    auto refCastIter = finder.refCastToApply.find(curr);
    if (refCastIter != finder.refCastToApply.end()) {
      for (auto& currRefCast : refCastIter->second) {
        if (!currRefCast.atTarget) {
          currPtr = replaceCurrent(
            Builder(*getModule())
              .makeRefCast(currPtr, currRefCast.type, currRefCast.safety));
        }
      }
    }

    auto refAsIter = finder.refAsToApply.find(curr);
    if (refAsIter != finder.refAsToApply.end()) {
      for (auto& currRefAs : refAsIter->second) {
        if (!currRefAs.atTarget) {
          currPtr = replaceCurrent(
            Builder(*getModule()).makeRefAs(currRefAs.op, currPtr));
        }
      }
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
    EarlyCastFinder earlyCastFinder(getPassOptions(), getModule(), func);
    earlyCastFinder.walkFunctionInModule(func, getModule());

    bool castsToMove = earlyCastFinder.hasCastsToMove();
    if (castsToMove) {
      // Duplicate casts to earlier locations if possible
      EarlyCastApplier earlyCastApplier(earlyCastFinder);
      earlyCastApplier.walkFunctionInModule(func, getModule());

      // Adding more casts causes types to be refined, that should be propagated. Especially those of nested casts.
      ReFinalize().walkFunctionInModule(func, getModule());
    }

    // Find the best casts that we want to use.
    BestCastFinder finder;
    finder.options = getPassOptions();
    finder.walkFunctionInModule(func, getModule());

    bool castsToOptimize = !finder.lessCastedGets.empty();
    if (castsToOptimize) {
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
