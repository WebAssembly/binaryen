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

    // Compute the list of gets and sets for each local.
    struct Scanner : public PostWalker<Scanner> {
      // Which locals are relevant for us (we can ignore non-references).
      std::vector<bool> relevant;

      // The lists of gets and sets.
      std::vector<std::vector<LocalSet*>> setsForLocal;
      std::vector<std::vector<LocalGet*>> getsForLocal;

      Scanner(Function* func) {
        auto numLocals = func->getNumLocals();
        relevant.resize(numLocals);
        setsForLocal.resize(numLocals);
        getsForLocal.resize(numLocals);

        for (Index i = 0; i < numLocals; i++) {
          // TODO: Ignore params here? That may require changes below.
          if (func->getLocalType(i).isRef()) {
            relevant[i] = true;
          }
        }

        walk(func->body);
      }

      void visitLocalGet(LocalGet* curr) {
        if (relevant[curr->index]) {
          getsForLocal[curr->index].push_back(curr);
        }
      }

      void visitLocalSet(LocalSet* curr) {
        if (relevant[curr->index]) {
          setsForLocal[curr->index].push_back(curr);
        }
      }
    } scanner(func);

    auto& setsForLocal = scanner.setsForLocal;
    auto& getsForLocal = scanner.getsForLocal;

    // Find which vars can be non-nullable (if a null is written, or the default
    // null is used, then a local cannot become non-nullable).
    std::unordered_set<Index> cannotBeNonNullable;

    // All gets must be dominated structurally by sets for the local to be non-
    // nullable.
    LocalStructuralDominance info(func, *getModule());
    for (auto index : info.nonDominatingIndices) {
      cannotBeNonNullable.insert(index);
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

    auto numLocals = func->getNumLocals();

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
          lub.note(set->value->type);
          if (lub.getLUB() == oldType) {
            break;
          }
        }
        if (!lub.noted()) {
          // Nothing is assigned to this local (other opts will remove it).
          continue;
        }

        auto newType = lub.getLUB();
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
  }
};

Pass* createLocalSubtypingPass() { return new LocalSubtyping(); }

} // namespace wasm
