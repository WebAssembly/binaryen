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
  LUBFinder(const PassOptions& passOptions, Module& module)
    : passOptions(passOptions), module(module) {}

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
    // Look at the fallthrough value if there is one, but only if it has the
    // identical type. If it has a more specific type, we may not be able to
    // emit a LUB for it (the code still receives the original expression as an
    // input, not the fallthrough), and if it has a less specific type then that
    // is not helpful anyhow.
    curr = Properties::getIdenticallyTypedFallthrough(curr, passOptions, module);
    if (auto* block = curr->dynCast<Block>()) {
      if (!block->name.is()) {
        // TODO: use fallthrough
        curr = block->list.back();
      }
    }
    if (auto* null = curr->dynCast<RefNull>()) {
      updatableNulls.push_back(null);
      updateLUBNullability();
      return lub;
    } else {
      return note(curr->type);
    }
  }

  // Returns whether we noted any (reachable) value.
  bool noted() { return lub != Type::unreachable || updatableNulls.size(); }

  // Finalizes and returns the lub that we found. While doing so this will
  // update the types of updatable nulls, if there were any, and if there is a
  // useful lub to update them to.
  Type get() {
    if (!finalized) {
      finalized = true;

      // There are four possibilities for the lub of types and the presence of
      // nulls:
      //
      //  1. We have no lub (it is unreachable) and we've seen no nulls. In this
      //     case we've seen literally nothing, and the lub can stay as
      //     the unreachable type.
      //  2. We have a lub and no nulls. There is nothing more to do here: we
      //     already know the lub.
      //  3. We have both a lub and nulls. In this case we can update the nulls
      //     to be whatever type we want, and we do so in order to make the most
      //     specific type we can - which is that of the lub.
      //  4. We have no lub, but we *do* have nulls. Set the LUB based on their
      //     types, as we need a lub to report here, and that is a valid value.
      //     (In theory, it could be an even more specific type, if we updated
      //     all the nulls to the "most specific" of them, for example, but this
      //     case does not matter much as other optimizations can handle it.)

      if (lub == Type::unreachable && updatableNulls.size()) {
        // This is case 4 from above: calculate the LUB from the nulls.
        std::vector<Type> types;
        for (auto* null : updatableNulls) {
          types.push_back(null->type);
        }
        lub = Type::getLeastUpperBound(types);
      } else if (lub != Type::unreachable && updatableNulls.size()) {
        // This is case 3 from above: update the nulls based on the lub.
        for (auto* null : updatableNulls) {
          assert(lub.isNullable());
          null->finalize(lub);
        }
      }
    }

    return lub;
  }

private:
  const PassOptions& passOptions;
  Module& module;

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
    if (!lub.isNullable() && updatableNulls.size() &&
        lub != Type::unreachable) {
      lub = Type(lub.getHeapType(), Nullable);
    }
  }
};

} // namespace wasm

#endif // wasm_ir_lubs_h
