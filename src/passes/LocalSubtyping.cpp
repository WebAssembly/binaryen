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

#include <ir/find_all.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm.h>

namespace wasm {

struct LocalSubtyping : public WalkerPass<LinearExecutionWalker<LocalSubtyping>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() { return new LocalSubtyping(); }

  void doWalkFunction(Function* func) {
    auto varBase = func->getVarIndexBase();
    auto numLocals = func->getNumLocals();
    bool more;

    // Map local index to the sets for it.
    std::vector<std::vector<LocalSet*>> setsForLocal;
    setsForLocal.resize(numLocals);
    FindAll<LocalSet> sets(func->body);
    for (auto* set : sets.list) {
      setsForLocal[set->index].push_back(set);
    }

    // Keep iterating while we find things to change. There can be chains like
    // X -> Y -> Z where one change enables more. Note that we are O(N^2) on
    // that atm, but it is a rare pattern as general optimizations
    // (SimplifyLocals and CoalesceLocals) break up such things; also, even if
    // we tracked changes more carefully we'd have the case of nested tees
    // where we could still be O(N^2), so we'd need something more complex here
    // involving topological sorting. Leave that for it the need arises.

    do {
      more = false;

      // First, refinalize which will recompute least upper bounds on ifs and
      // blocks, etc., potentially finding a more specific type. Note that
      // the utility does not tell us if it changed anything, so we depend on
      // the next step for knowing if there is more work to do.
      ReFinalize().walkFunctionInModule(func, getModule());

      // Second, find vars whose actual applied values allow a more specific
      // type.

      for (Index i = varBase; i < numLocals; i++) {
        // Find all the types assigned to the var.
        std::unordered_set<Type> types;
        for (auto* set : setsForLocal[i]) {
          types.insert(set->value->type);
        }
        auto newType = Type::getLeastUpperBound(types);
        auto oldType = func->getLocalType(i);
        assert(newType != Type::none); // in valid wasm there must be a LUB

        // Remove non-nullability, which cant be stored in a local.
        if (newType.isRef() && !newType.isNullable()) {
          newType = Type(newType.getHeapType(), Nullable);
          // Note that the old type must have been nullable as well, as non-
          // nullable types cannot be locals, which means that we will not have
          // to do any extra work to handle non-nullability if we update the
          // type: we are just updating the heap type, and leaving the type
          // nullable.
          assert(oldType.isRef() && oldType.isNullable());
        }

        if (newType != oldType) {
          // We found a more specific type!
          assert(Type::isSubType(newType, oldType));
          func->vars[i - varBase] = newType;
          more = true;

          // Update tees.
          // NB: this code will not be needed if the type of tees becomes that
          //     of their value.
          for (auto* set : setsForLocal[i]) {
            if (set->isTee() && set->type != Type::unreachable) {
              set->type = newType;
            }
          }
        }
      }
    } while (more);
  }
};

Pass* createLocalSubtypingPass() { return new LocalSubtyping(); }

} // namespace wasm
