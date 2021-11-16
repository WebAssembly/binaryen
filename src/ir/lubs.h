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
  void note(Type type) { lub = Type::getLeastUpperBound(lub, type); }

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
  void noteUpdatableExpression(Expression* curr) {
    if (auto* null = curr->dynCast<RefNull>()) {
      nulls.insert(null);
    } else {
      note(curr->type);
    }
  }

  void noteNullDefault() {
    // A default value is indicated by a null pointer.
    nulls.insert(nullptr);
  }

  // Returns whether we noted any (reachable) value. This ignores nulls, as they
  // do not contribute type information - we do not try to find a lub based on
  // them.
  bool noted() { return lub != Type::unreachable; }

  // Returns the best possible lub. This ignores updatable nulls for the reasons
  // mentioned above, since they will not limit us, aside from making the type
  // nullable if nulls exist. This does not update the nulls.
  Type getBestPossible() {
    if (lub == Type::unreachable) {
      // Perhaps if we have seen nulls we could compute a lub on them, but it's
      // not clear that is helpful.
      return lub;
    }

    // We have a lub. Make it nullable if we need to.
    if (!lub.isNullable() && !nulls.empty()) {
      return Type(lub.getHeapType(), Nullable);
    } else {
      return lub;
    }
  }

  // Update the nulls for the best possible LUB, if we found one.
  void updateNulls() {
    auto newType = getBestPossible();
    if (newType != Type::unreachable) {
      for (auto* null : nulls) {
        // Default null values (represented as nullptr here) do not need to be
        // updated. Aside from that, if this null is already of a more specific
        // type, also do not update it - it's never worth making a type less
        // specific. What we care about here is making sure the nulls are all
        // specific enough given the LUB that is being applied.
        if (null && !Type::isSubType(null->type, newType)) {
          null->finalize(newType);
        }
      }
    }
  }

  // Combines the information in another LUBFinder into this one, and returns
  // whether we changed anything.
  bool combine(const LUBFinder& other) {
    // Check if the lub was changed.
    auto old = lub;
    note(other.lub);
    bool changed = old != lub;

    // Check if we added new updatable nulls.
    for (auto* null : other.nulls) {
      if (nulls.insert(null).second) {
        changed = true;
      }
    }

    return changed;
  }

  // Force the lub to a particular type. This resets the entire state of the
  // LUBFinder to just contain that type.
  void set(Type type) {
    lub = type;
    nulls.clear();
  }

private:
  // The least upper bound. As we go this always contains the latest value based
  // on everything we've seen so far.
  Type lub = Type::unreachable;

  // Nulls that we can update. A nullptr here indicates an "implicit" null, that
  // is, a null default value.
  std::unordered_set<RefNull*> nulls;
};

} // namespace wasm

#endif // wasm_ir_lubs_h
