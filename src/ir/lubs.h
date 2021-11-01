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

#ifndef wasm_ir_lubs_h
#define wasm_ir_lubs_h

#include "ir/module-utils.h"
#include "wasm.h"

namespace wasm {

// Helper to find a LUB of a series of expressions. This works incrementally so
// that if we see we are not improving on an existing type then we can stop
// early.
struct LUBFinder {
  // Note another type to take into account in the lub. Returns the new lub.
  Type note(Type type) {
    assert(!finalized);
    lub = Type::getLeastUpperBound(lub, type);
    updateLUBNullability();
    return lub;
  }

  // Note an expression that can be updated, that is, that we can modify in
  // safe ways if doing so would allow us to get a better lub. The specific
  // optimization possible here involves nulls: the lub of
  //
  //   (ref.null any)  ;; an expression that we can update
  //   (ref data)      ;; a type
  //
  // can be (ref null data), if we update that null to be
  //
  //   (ref.null data)
  //
  // It is safe to change the type of nulls, since all nulls are the same. This
  // is a common case, as e.g. if a field has a nullable type, and it has a
  // null assigned during creation, then that null would prevent us from using a
  // more specific type if we do not update the null.
  Type noteUpdatableExpression(Expression* curr) {
    assert(!finalized);
    if (auto* null = curr->dynCast<RefNull>()) {
      updatableNulls.push_back(null);
      updateLUBNullability();
      return lub;
    } else {
      return note(curr->type);
    }
  }

  // Returns whether we noted any (reachable) value.
  bool noted() { return lub != Type::unreachable; }

  // Finalizes and returns the lub that we found.
  Type get() {
    if (!finalized) {
      finalized = true;

      // Update any nulls with the final lub's type. Note that we can only do
      // that if we've noted a reachable type for the lub, or else we have no
      // type to give the nulls (in that case, all we've every seen are nulls,
      // and we have no idea of what type to change to).
      if (noted()) {
        for (auto* null : updatableNulls) {
          assert(lub.isNullable());
          null->finalize(lub);
        }
      }
    }
    return lub;
  }

private:
  // The least upper bound. As we go this always contains the latest value based
  // on everything we've seen so far.
  Type lub = Type::unreachable;

  // Whether we computed the final value.
  bool finalized = false;

  // Nulls that we can update.
  std::vector<RefNull*> updatableNulls;

  // Update the nullability of the LUB based on all we've seen. In particular,
  // if we've noted an updatable null then we must make the LUB nullable.
  void updateLUBNullability() {
    // The existence of a null means the lub must be nullable. (Note that we can
    // only do that if the lub is not Type::unreachable, hence the last check.)
    if (!lub.isNullable() && !updatableNulls.empty() && lub.isRef()) {
      lub = Type(lub.getHeapType(), Nullable);
    }
  }
};

} // namespace wasm

#endif // wasm_ir_lubs_h
