/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Refines the types of locals where possible. That is, if a local is assigned
// types that are more specific than the local's declared type, refine the
// declared type. This can then potentially unlock optimizations later when the
// local is used, as we have more type info. (However, it may also increase code
// size in theory, if we end up declaring more types - TODO investigate.)
//

#include <ir/find_all.h>
#include <ir/linear-execution.h>
#include <ir/local-graph.h>
#include <ir/local-structural-dominance.h>
#include <ir/lubs.h>
#include <ir/properties.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

struct LocalSubtyping : public WalkerPass<PostWalker<LocalSubtyping>> {
  bool isFunctionParallel() override { return true; }

  // This pass carefully avoids breaking validation by only refining a local's
  // type to be non-nullable if it would validate.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<LocalSubtyping>();
  }

  void doWalkFunction(Function* func) {
    if (!getModule()->features.hasGC()) {
      return;
    }

    // First, refine local uses as much as possible, before we refine types.
    refineLocalUses(func);

    auto numLocals = func->getNumLocals();

    // Compute the local graph. We need to get the list of gets and sets for
    // each local, so that we can do the analysis. For non-nullable locals, we
    // also need to know when the default value of a local is used: if so then
    // we cannot change that type, as if we change the local type to
    // non-nullable then we'd be accessing the default, which is not allowed.
    //
    // TODO: Optimize this, as LocalGraph computes more than we need, and on
    //       more locals than we need.
    LocalGraph localGraph(func);

    // For each local index, compute all the the sets and gets.
    std::vector<std::vector<LocalSet*>> setsForLocal(numLocals);
    std::vector<std::vector<LocalGet*>> getsForLocal(numLocals);

    for (auto& [curr, _] : localGraph.locations) {
      if (auto* set = curr->dynCast<LocalSet>()) {
        setsForLocal[set->index].push_back(set);
      } else {
        auto* get = curr->cast<LocalGet>();
        getsForLocal[get->index].push_back(get);
      }
    }

    // Find which vars can be non-nullable.
    std::unordered_set<Index> cannotBeNonNullable;

    if (getModule()->features.hasGCNNLocals()) {
      // If the feature is enabled then the only constraint is being able to
      // read the default value - if it is readable, the local cannot become
      // non-nullable.
      for (auto& [get, sets] : localGraph.getSetses) {
        auto index = get->index;
        if (func->isVar(index) &&
            std::any_of(sets.begin(), sets.end(), [&](LocalSet* set) {
              return set == nullptr;
            })) {
          cannotBeNonNullable.insert(index);
        }
      }
    } else {
      // Without GCNNLocals, validation rules follow the spec rules: all gets
      // must be dominated structurally by sets, for the local to be non-
      // nullable.
      LocalStructuralDominance info(func, *getModule());
      for (auto index : info.nonDominatingIndices) {
        cannotBeNonNullable.insert(index);
      }
    }

    auto varBase = func->getVarIndexBase();

    // Keep iterating while we find things to change. There can be chains like
    // X -> Y -> Z where one change enables more. Note that we are O(N^2) on
    // that atm, but it is a rare pattern as general optimizations
    // (SimplifyLocals and CoalesceLocals) break up such things; also, even if
    // we tracked changes more carefully we'd have the case of nested tees
    // where we could still be O(N^2), so we'd need something more complex here
    // involving topological sorting. Leave that for if the need arises.

    // TODO: handle cycles of X -> Y -> X etc.

    bool more;
    bool optimized = false;

    do {
      more = false;

      // First, refinalize which will recompute least upper bounds on ifs and
      // blocks, etc., potentially finding a more specific type. Note that
      // that utility does not tell us if it changed anything, so we depend on
      // the next step for knowing if there is more work to do.
      ReFinalize().walkFunctionInModule(func, getModule());

      // Second, find vars whose actual applied values allow a more specific
      // type.

      for (Index i = varBase; i < numLocals; i++) {
        auto oldType = func->getLocalType(i);

        // Find all the types assigned to the var, and compute the optimal LUB.
        LUBFinder lub;
        for (auto* set : setsForLocal[i]) {
          lub.noteUpdatableExpression(set->value);
          if (lub.getBestPossible() == oldType) {
            break;
          }
        }
        if (!lub.noted()) {
          // Nothing is assigned to this local (other opts will remove it).
          continue;
        }

        auto newType = lub.getBestPossible();
        assert(newType != Type::none); // in valid wasm there must be a LUB

        // Remove non-nullability if we disallow that in locals.
        if (newType.isNonNullable()) {
          if (cannotBeNonNullable.count(i)) {
            newType = Type(newType.getHeapType(), Nullable);
          }
        } else if (!newType.isDefaultable()) {
          // Aside from the case we just handled of allowed non-nullability, we
          // cannot put anything else in a local that does not have a default
          // value.
          continue;
        }

        if (newType != oldType) {
          // We found a more specific type!
          assert(Type::isSubType(newType, oldType));
          func->vars[i - varBase] = newType;
          more = true;
          optimized = true;
          lub.updateNulls();

          // Update gets and tees.
          for (auto* get : getsForLocal[i]) {
            get->type = newType;
          }

          // NB: These tee updates will not be needed if the type of tees
          //     becomes that of their value, in the spec.
          for (auto* set : setsForLocal[i]) {
            if (set->isTee()) {
              set->type = newType;
              set->finalize();
            }
          }
        }
      }
    } while (more);

    // If we ever optimized, then we also need to do a final pass to update any
    // unreachable gets and tees. They are not seen or updated in the above
    // analysis, but must be fixed up for validation to work.
    if (optimized) {
      for (auto* get : FindAll<LocalGet>(func->body).list) {
        get->type = func->getLocalType(get->index);
      }
      for (auto* set : FindAll<LocalSet>(func->body).list) {
        auto newType = func->getLocalType(set->index);
        if (set->isTee()) {
          set->type = newType;
          set->finalize();
        }

        // If this set was not processed earlier - that is, if it is in
        // unreachable code - then it may have an incompatible type. That is,
        // If we saw a reachable set that writes type A, and this set writes
        // type B, we may have specialized the local type to A, but the value
        // of type B in this unreachable set is no longer valid to write to
        // that local. In such a case we must do additional work.
        if (!Type::isSubType(set->value->type, newType)) {
          // The type is incompatible. To fix this, replace
          //
          //  (set (bad-value))
          //
          // with
          //
          //  (set (block
          //   (drop (bad-value))
          //   (unreachable)
          //  ))
          //
          // (We cannot just ignore the bad value, as it may contain a break to
          // a target that is necessary for validation.)
          Builder builder(*getModule());
          set->value = builder.makeSequence(builder.makeDrop(set->value),
                                            builder.makeUnreachable());
        }
      }

      // Also update their parents.
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

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
  // This change adds a local but it switches some local.gets to use a local of
  // a more refined type. That can help other optimizations later, and can also
  // help refine types of other locals in the rest of this pass.
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
  // |this|, we can use the cast value for the itable get, which may then lead
  // to removing the vtable cast after we refine the itable type. And that can
  // lead to devirtualization later.
  void refineLocalUses(Function* func) {
    // TODO: Look past individual basic blocks?
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
    finder.walkFunction(func);

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
        }
      }
    };

    FindingApplier applier(finder);
    applier.walkFunction(func);
  }
};

Pass* createLocalSubtypingPass() { return new LocalSubtyping(); }

} // namespace wasm
