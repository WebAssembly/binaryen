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

    // Walk the code to collect information.
    auto numLocals = func->getNumLocals();
    uses.resize(numLocals);
    validUses.resize(numLocals);

    super::doWalkFunction(func);
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
      if (value->is<LocalSet>() || value->is<LocalGet>() ||
          value->is<TupleMake>()) {
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
};

Pass* createTupleOptimizationPass() { return new TupleOptimization(); }

} // namespace wasm
