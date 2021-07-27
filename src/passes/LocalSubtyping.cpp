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
#include <ir/utils.h>
#include <pass.h>
#include <wasm.h>

namespace wasm {

struct LocalSubtyping : public WalkerPass<PostWalker<LocalSubtyping>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new LocalSubtyping(); }

  // Shared code to find all sets or gets for each local index. Returns a vector
  // that maps local indexes => vector of LocalGet*|LocalSet* expressions.
  template<typename T>
  std::vector<std::vector<T*>> getLocalOperations(Function* func) {
    std::vector<std::vector<T*>> ret;
    ret.resize(func->getNumLocals());
    FindAll<T> operations(func->body);
    for (auto* operation : operations.list) {
      ret[operation->index].push_back(operation);
    }
    return ret;
  }

  void doWalkFunction(Function* func) {
    if (!getModule()->features.hasGC()) {
      return;
    }

    auto varBase = func->getVarIndexBase();
    auto numLocals = func->getNumLocals();

    auto setsForLocal = getLocalOperations<LocalSet>(func);
    auto getsForLocal = getLocalOperations<LocalGet>(func);

    // Keep iterating while we find things to change. There can be chains like
    // X -> Y -> Z where one change enables more. Note that we are O(N^2) on
    // that atm, but it is a rare pattern as general optimizations
    // (SimplifyLocals and CoalesceLocals) break up such things; also, even if
    // we tracked changes more carefully we'd have the case of nested tees
    // where we could still be O(N^2), so we'd need something more complex here
    // involving topological sorting. Leave that for if the need arises.

    // TODO: handle cycles of X -> Y -> X etc.

    bool more;

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
        // Find all the types assigned to the var, and compute the optimal LUB.
        // Note that we do not need to take into account the initial value of
        // zero or null that locals have: that value has the type of the local,
        // which is a supertype of all the assigned values anyhow. It will never
        // be able to tell us of a more specific subtype that is possible.
        std::unordered_set<Type> types;
        for (auto* set : setsForLocal[i]) {
          types.insert(set->value->type);
        }
        if (types.empty()) {
          // Nothing is assigned to this local (other opts will remove it).
          continue;
        }

        auto oldType = func->getLocalType(i);
        auto newType = Type::getLeastUpperBound(types);
        assert(newType != Type::none); // in valid wasm there must be a LUB

        // Remove non-nullability if we disallow that in locals.
        if (newType.isNonNullable()) {
          if (!getModule()->features.hasGCNNLocals()) {
            newType = Type(newType.getHeapType(), Nullable);
            // Note that the old type must have been nullable as well, as non-
            // nullable types cannot be locals without that feature being
            // enabled, which means that we will not have to do any extra work
            // to handle non-nullability if we update the type: we are just
            // updating the heap type, and leaving the type nullable as it was.
            assert(oldType.isNullable());
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
