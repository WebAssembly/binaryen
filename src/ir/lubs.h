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

//
// Helper to find a LUB of a series of expressions. This works incrementally so
// that if we see we are not improving on an existing type then we can stop
// early. It also notes null expressions that can be updated later, and if
// updating them would allow a better LUB it can do so. That is, given this:
//
//   (ref.null any)  ;; an expression that we can update
//   (.. something of type data ..)
//
// We can update that null to type (ref null data) which would allow setting
// that as the LUB. This is important in cases where there is a null initial
// value in a field, for example: we should not let the type there prevent us
// from optimizing - after all, all nulls compare equally anyhow.
//
struct LUBFinder {
  LUBFinder() {}

  LUBFinder(Type initialType) { note(initialType); }

  // Note another type to take into account in the lub.
  void note(Type type) { lub = Type::getLeastUpperBound(lub, type); }

  // Note an expression that can be updated, that is, that we can modify in
  // safe ways if doing so would allow us to get a better lub. The specific
  // optimization possible here involves nulls, see the top comment.
  void noteUpdatableExpression(Expression* curr) {
    if (curr->is<RefNull>()) {
      hasNull = true;
    } else {
      note(curr->type);
    }
  }

  // Returns whether we noted any (reachable) value. This ignores nulls, as they
  // do not contribute type information - we do not try to find a lub based on
  // them (rather we update them to the LUB).
  bool noted() { return lub != Type::unreachable; }

  // Returns the best possible lub. This ignores updatable nulls for the reasons
  // mentioned above, since they will not limit us, aside from making the type
  // nullable if nulls exist. This does not update the nulls.
  Type getBestPossible() {
    if (lub.isNonNullable() && hasNull) {
      return Type(lub.getHeapType(), Nullable);
    }
    return lub;
  }

  // Combines the information in another LUBFinder into this one, and returns
  // whether we changed anything.
  bool combine(const LUBFinder& other) {
    // Check if the lub was changed.
    auto old = lub;
    note(other.lub);
    hasNull = hasNull || other.hasNull;
    return old != lub;
  }

private:
  // The least upper bound. As we go this always contains the latest value based
  // on everything we've seen so far, except for nulls.
  bool hasNull = false;
  Type lub = Type::unreachable;
};

namespace LUB {

// Given a function, computes a LUB for its results. The caller can then decide
// to apply a refined type if we found one.
//
// This modifies the called function even if it fails to find a refined type as
// it does a refinalize in order to be able to compute the new types. We could
// roll back that change, but it's not harmful and can help, so we keep it
// regardless.
LUBFinder getResultsLUB(Function* func, Module& wasm);

} // namespace LUB

} // namespace wasm

#endif // wasm_ir_lubs_h
