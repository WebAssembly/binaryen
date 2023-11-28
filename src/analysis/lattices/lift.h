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

#ifndef wasm_analysis_lattices_lift_h
#define wasm_analysis_lattices_lift_h

#include <optional>
#include <utility>

#include "../lattice.h"
#include "bool.h"

namespace wasm::analysis {

// A lattice created by "lifting" another lattice by inserting a new bottom
// element that is less than all elements in the lifted lattice.
template<Lattice L> struct Lift {
  // Represent the bottom element as an empty optional and any element of the
  // lifted lattice as a non-empty optional. This representation is
  // intentionally part of the public API.
  struct Element : std::optional<typename L::Element> {
    bool isBottom() const noexcept { return !this->has_value(); }
    bool operator==(const Element& other) const noexcept {
      return (isBottom() && other.isBottom()) ||
             (!isBottom() && !other.isBottom() && **this == *other);
    }
  };

  L lattice;

  Lift(L&& lattice) : lattice(std::move(lattice)) {}

  Element getBottom() const noexcept { return {std::nullopt}; }
  Element get(typename L::Element&& val) const noexcept {
    return Element{std::move(val)};
  }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    if (a.isBottom() && b.isBottom()) {
      return EQUAL;
    } else if (a.isBottom()) {
      return LESS;
    } else if (b.isBottom()) {
      return GREATER;
    } else {
      return lattice.compare(*a, *b);
    }
  }

  bool join(Element& joinee, const Element& joiner) const noexcept {
    if (joinee.isBottom() && joiner.isBottom()) {
      return false;
    } else if (joinee.isBottom()) {
      joinee = joiner;
      return true;
    } else if (joiner.isBottom()) {
      return false;
    } else {
      return lattice.join(*joinee, *joiner);
    }
  }
};

// Deduction guide.
template<typename L> Lift(L&&) -> Lift<L>;

#if __cplusplus >= 202002L
static_assert(Lattice<Lift<Bool>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_lift_h
