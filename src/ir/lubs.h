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
  // The least upper bound we found so far.
  Type lub = Type::unreachable;

  // Note another type to take into account in the lub. Returns the new lub.
  Type note(Type type) { return lub = Type::getLeastUpperBound(lub, type); }

  Type note(Expression* curr) { return note(curr->type); }

  // Returns whether we noted any (reachable) value.
  bool noted() { return lub != Type::unreachable; }

  // Returns the lub that we found.
  Type get() { return lub; }

  // Combines the information into another LUBFinder, and returns whether we
  // changed anything.
  bool combineInfo(LUBFinder& other) const {
    auto old = other.lub;
    other.note(lub);
    return other.lub != old;
  }
};

} // namespace wasm

#endif // wasm_ir_lubs_h
