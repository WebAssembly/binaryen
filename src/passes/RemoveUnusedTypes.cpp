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
// Remove unused types from private rec groups. This is done implicitly by other
// type optimizations as well, but only if they find anything else they want to
// optimize.
//

#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "pass.h"

namespace wasm {

namespace {

struct RemoveUnusedTypes : Pass {
  void run(Module* module) override {
    if (!module->features.hasGC()) {
      // This pass only does anything with GC types.
      return;
    }

    // Consider (rec $A $unused), where anyrefs received from the outside are
    // cast to `$A`. In an open world we cannot remove $unused because that
    // would change the identity of $A. Currently we would incorrectly remove
    // $unused. To fix that, we need to fix our collection of public types to
    // consider $A (and $unused) public in an open world.
    if (!getPassOptions().closedWorld) {
      Fatal() << "RemoveUnusedTypes requires --closed-world";
    }

    // We're not changing the contents of any of the types, so we just round
    // trip them through GlobalTypeRewriter which will put all the private types
    // in a single new rec group and leave out all the unused types.
    GlobalTypeRewriter(*module).update();
  }
};

} // anonymous namespace

Pass* createRemoveUnusedTypesPass() { return new RemoveUnusedTypes(); }

} // namespace wasm
