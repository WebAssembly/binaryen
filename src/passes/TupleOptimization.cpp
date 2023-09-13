/*
 * Copyright 2023 WebAssembly Community Group participants
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
// Optimize away trivial tuples. When values are bundled together in a tuple, we
// are limited in how we can optimize then in the various local-related passes,
// like this:
//
//  (local.set $tuple
//    (tuple.make (A) (B) (C)))
//  (use
//    (tuple.extract 0
//      (local.get $tuple)))
//
// If there are no other uses, then we just need one of the three lanes. By
// lowing them to three separate locals, other passes can remove the other two.
//
// Specifically, this pass seeks out tuple locals that have these properties:
//
//  * They are always written either a tuple.make or another tuple local with
//    these properties.
//  * They are always used either in tuple.extract or to be copied to another
//    tuple local with these properties.
//
// The set of those tuple locals can be easily optimized into individual locals,
// as the tuple does not "escape" into say a return value.
//

#include <pass.h>
#include <support/unique_deferring_queue.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

struct TupleOptimization
  : public WalkerPass<
      PostWalker<TupleOptimization>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TupleOptimization>(propagate);
  }

  // TupleOptimization() {}

  // Track the number of uses for each tuple local.
  std::vector<Index> uses;

  // Tracks which tuple local uses are valid, that is, follow the properties
  // above. If we have more uses than valid uses then we must have an invalid
  // one, and the local cannot be optimized.
  std::vector<bool> validUses;

  // When one tuple local copies the value of another, we need to track the
  // index that was copied, as if the source ends up bad then the target is bad
  // as well.
  //
  // This is a map of the source to the indexes it is copied into (so that we
  // can easily flow badness forward).
  std::vector<std::unordered_set<Index>> copiedIndexes;

  void doWalkFunction(Function* func) {
    // If tuples are not enabled, or there are no tuple locals, then there is no
    // work to do.
    if (!getModule()->features.hasMultivalue()) {
      return;
    }
    bool hasTuple = false;
    for (auto var : func->vars) {
      if (var->type.isTuple()) {
        hasTuple = true;
        break;
      }
    }
    if (!hasTuple) {
      return;
    }

    // Prepare global data structures before we collect info.
    auto numLocals = func->getNumLocals();
    uses.resize(numLocals);
    validUses.resize(numLocals);
    copiedIndexes.resize(numLocals);

    // Walk the code to collect info.
    super::doWalkFunction(func);

    // Analyze and optimize.
    optimize(func);
  }

  void visitLocalGet(LocalGet* curr) {
    if (curr->type.isTuple()) {
      validUses[curr->index]++;
    }
  }

  void visitLocalSet(LocalSet* curr) {
    if (getFunction()->getLocalType(curr->index).isTuple()) {
      auto* value = curr->value;
      // We need the input to the local to be another such local (from a tee, or
      // a get), or a tuple.make.
      if (auto* set = value->dynCast<LocalSet>()) {
        validUses[set->index]++;
        copiedIndexes[set->index].insert(curr->index);
      } else if (auto* get = value->dynCast<LocalGet>()) {
        validUses[get->index]++;
        copiedIndexes[set->index].insert(curr->index);
      } else if (value->is<TupleMake>()) {
        validUses[curr->index]++;
      }
    }
  }

  void visitTupleExtract(TupleExtract* curr) {
    // We need the input to be a local, either from a tee or a get.
    if (auto* set = curr->tuple->dynCast<LocalSet>()) {
      validUses[set->index]++;
    } else if (auto* get = curr->tuple->dynCast<LocalGet>()) {
      validUses[get->index]++;
    }
  }

  void optimize(Function* func) {
    auto numLocals = func->getNumLocals();

    std::vector<bool> bad(numLocals);
    UniqueDeferredQueue<Index> work;

    for (Index i = 0; i < uses.size(); i++) {
      if (uses[i] > 0 && validUses[i] < uses[i]) {
        // This is a bad tuple. Note that, and also set it up for the flow to
        // corrupt those it is written into.
        bad[i] = true;
        work.push(i);
      }
    }

    // Flow badness forward.
    while (!work.empty()) {
      auto i = work.pop();
      if (bad[i]) {
        continue;
      }
      bad[i] = true;
      for (auto target : copiedIndexes[i]) {
        work.push(target);
      }
    }

    // Good indexes we can optimize are tuple locals with uses that are not bad.
    std::vector<bool> good(numLocals);
    bool hasGood = false;
    for (Index i = 0; i < uses.size(); i++) {
      if (uses[i] > 0 && !bad[i]) {
        good[i] = true;
        hasGood = true;
      }
    }

    if (!hasGood) {
      return;
    }

    // We found things to optimize! Create new non-tuple locals for their
    // contents, and then rewrite the code to use those according to the
    // mapping from tuple locals to normal ones. The mapping maps a tuple local
    // to the first index used for its contents (subsequent indexes are used
    // contiguously).
    std::unordered_map<Index, Index> tupleToNormalMap;
    for (Index i = 0; i < good.size(); i++) {
      if (good[i]) {
        auto normal = func->getNumLocals();
        tupleToNormalMap[i] = normal;
        auto lastNewIndex = 0;
        for (auto t : func->getLocalType(i)) {
          auto newIndex = Builder::addVar(func, t);
          if (lastNewIndex == 0) {
            // This is the first new local we added (0 is an impossible value,
            // since tuple locals exist, hence index 0 was already taken).
            assert(newIndex == normal);
          } else {
            // This must be right after the former.
            assert(newIndex == lastNewIndex + 1);
          }
          lastNewIndex = newIndex;
        }
      }
    }
  }
};

Pass* createTupleOptimizationPass() { return new TupleOptimization(); }

} // namespace wasm
