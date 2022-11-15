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
// more refined type. That can help other optimizations later, and can also help
// refine types of other locals in the rest of this pass.
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
// TODO: Move casts earlier in a basic block as well, at least in traps-never-
//       happen mode where we can assume they don't happen.
// TODO: Look past individual basic blocks?
//

#include "ir/linear-execution.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct OptimizeCasts : public WalkerPass<PostWalker<OptimizeCasts>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<OptimizeCasts>();
  }

  void doWalkFunction(Function* func) {
    if (!getModule()->features.hasGC()) {
      return;
    }

    struct BestSourceFinder : public LinearExecutionWalker<BestSourceFinder> {

      PassOptions options;

      // A map of the best local.get for a particular index: the local.get that
      // has the most refined type.
      std::unordered_map<Index, Expression*> bestSourceForIndexMap;

      // For each expression, a vector of local.gets that would like to use its
      // value instead of themselves (as it is more refined).
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
            // The best source has a more refined type, note that we want to use
            // it.
            requestMap[bestSource].push_back(curr);
          }
        }
      }

      void visitRefAs(RefAs* curr) { handleRefinement(curr); }

      void visitRefCast(RefCast* curr) { handleRefinement(curr); }

      void handleRefinement(Expression* curr) {
        auto* fallthrough =
          Properties::getFallthrough(curr, options, *getModule());
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

    BestSourceFinder finder;
    finder.setModule(getModule());
    finder.options = getPassOptions();
    finder.walkFunctionInModule(func, getModule());

    if (finder.requestMap.empty()) {
      return;
    }

    // Apply the requests. We need to do this in a subsequent pass as altering
    // pointers to things we've already walked past can have interesting corner
    // cases with removing a pointer to something inside something that is also
    // going away.
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

        // This expression was the best source for some gets. Add a new local
        // to store this value, then use it for the gets.
        auto var = Builder::addVar(getFunction(), curr->type);
        auto& gets = iter->second;
        for (auto* get : gets) {
          get->index = var;
          get->type = curr->type;
        }

        // Replace ourselves with a tee.
        replaceCurrent(
          Builder(*getModule()).makeLocalTee(var, curr, curr->type));
      }
    };

    FindingApplier applier(finder);
    applier.walkFunctionInModule(func, getModule());

    // LocalGet type changes must be propagated.
    ReFinalize().walkFunctionInModule(func, getModule());
  }
};

Pass* createOptimizeCastsPass() { return new OptimizeCasts(); }

} // namespace wasm
