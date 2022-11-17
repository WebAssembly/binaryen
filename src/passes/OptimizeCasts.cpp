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
// TODO: Move casts earlier in a basic block as well, at least in traps-never-
//       happen mode where we can assume they never fail.
// TODO: Look past individual basic blocks?
//

#include "ir/linear-execution.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// Find the best sources for local.gets: other locals with the same value, but
// cast to a more refined type.
struct BestSourceFinder : public LinearExecutionWalker<BestSourceFinder> {

  PassOptions options;

  // Map local indices to the most refined downcastings of local.gets from those indices.
  std::unordered_map<Index, Expression*> bestSourceForIndexMap;

  // For each most-downcasted local.get, a vector of other local.gets that could be replaced with gets of the downcasted value.
  std::unordered_map<Expression*, std::vector<LocalGet*>> requestMap;

  static void doNoteNonLinear(BestSourceFinder* self, Expression** currp) {
    self->bestSourceForIndexMap.clear();
  }

  void visitLocalSet(LocalSet* curr) {
    // Clear any information about this local; it has a new value here.
    bestSourceForIndexMap.erase(curr->index);
  }

  void visitLocalGet(LocalGet* curr) {
    auto iter = bestSourceForIndexMap.find(curr->index);
    if (iter != bestSourceForIndexMap.end()) {
      auto* bestSource = iter->second;
      if (curr->type != bestSource->type &&
          Type::isSubType(bestSource->type, curr->type)) {
        // The best source has a more refined type, note that we want to use it.
        requestMap[bestSource].push_back(curr);
      }
    }
  }

  void visitRefAs(RefAs* curr) { handleRefinement(curr); }

  void visitRefCast(RefCast* curr) { handleRefinement(curr); }

  void handleRefinement(Expression* curr) {
    auto* fallthrough = Properties::getFallthrough(curr, options, *getModule());
    if (auto* get = fallthrough->dynCast<LocalGet>()) {
      auto*& bestSource = bestSourceForIndexMap[get->index];
      if (!bestSource) {
        // This is the first.
        bestSource = curr;
        return;
      }

      // See if we are better than the current source.
      if (curr->type != bestSource->type &&
          Type::isSubType(curr->type, bestSource->type)) {
        bestSource = curr;
      }
    }
  }
};

// Given a set of best sources, apply them: save each best source in a local and
// use it in the places that want to.
//
// It is simpler to do this in another pass after BestSourceFinder so that we do
// not need to worry about corner cases with invalidation of pointers in things
// we've already walked past.
struct FindingApplier : public PostWalker<FindingApplier> {
  BestSourceFinder& finder;

  FindingApplier(BestSourceFinder& finder) : finder(finder) {}

  void visitRefAs(RefAs* curr) { handleRefinement(curr); }

  void visitRefCast(RefCast* curr) { handleRefinement(curr); }

  void handleRefinement(Expression* curr) {
    auto iter = finder.requestMap.find(curr);
    if (iter == finder.requestMap.end()) {
      return;
    }

    // This expression was the best source for some gets. Add a new local to
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

    // First, find the best sources that we want to use.
    BestSourceFinder finder;
    finder.options = getPassOptions();
    finder.walkFunctionInModule(func, getModule());

    if (finder.requestMap.empty()) {
      // Nothing to do.
      return;
    }

    // Apply the requests: use the best sources.
    FindingApplier applier(finder);
    applier.walkFunctionInModule(func, getModule());

    // LocalGet type changes must be propagated.
    ReFinalize().walkFunctionInModule(func, getModule());
  }
};

Pass* createOptimizeCastsPass() { return new OptimizeCasts(); }

} // namespace wasm
