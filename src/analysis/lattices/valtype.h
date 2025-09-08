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

#ifndef wasm_analysis_lattices_valtype_h
#define wasm_analysis_lattices_valtype_h

#include "../lattice.h"
#include "wasm-type.h"

namespace wasm::analysis {

// Thin wrapper around `wasm::Type` giving it the interface of a lattice. As
// usual, `Type::unreachable` is the bottom element, but unlike in the
// underlying API, we uniformly treat `Type::none` as the top type so that we
// have a proper lattice.
struct ValType {
  using Element = Type;

  Element getBottom() const noexcept { return Type::unreachable; }

  Element getTop() const noexcept { return Type::none; }

  LatticeComparison compare(Element a, Element b) const noexcept {
    if (a == b) {
      return EQUAL;
    }
    if (b == Type::none || Type::isSubType(a, b)) {
      return LESS;
    }
    if (a == Type::none || Type::isSubType(b, a)) {
      return GREATER;
    }
    return NO_RELATION;
  }

  bool join(Element& joinee, Element joiner) const noexcept {
    // `getLeastUpperBound` already treats `Type::none` as top.
    auto lub = Type::getLeastUpperBound(joinee, joiner);
    if (lub != joinee) {
      joinee = lub;
      return true;
    }
    return false;
  }

  bool meet(Element& meetee, Element meeter) const noexcept {
    if (meetee == meeter || meeter == Type::none) {
      return false;
    }
    if (meetee == Type::none) {
      meetee = meeter;
      return true;
    }
    auto glb = Type::getGreatestLowerBound(meetee, meeter);
    if (glb != meetee) {
      meetee = glb;
      return true;
    }
    return false;
  }
};

#if __cplusplus >= 202002L
static_assert(FullLattice<ValType>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_valtype_h
