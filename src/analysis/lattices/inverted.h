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

#ifndef wasm_analysis_lattices_inverted_h
#define wasm_analysis_lattices_inverted_h

#include <utility>

#include "../lattice.h"
#include "bool.h"

namespace wasm::analysis {

// Reverses the order of an arbitrary full lattice. For example,
// `Inverted<UInt32>` would order uint32_t values by > rather than by <.
template<FullLattice L> struct Inverted {
  using Element = typename L::Element;

  L lattice;
  Inverted(L&& lattice) : lattice(std::move(lattice)) {}

  Element getBottom() const noexcept { return lattice.getTop(); }
  Element getTop() const noexcept { return lattice.getBottom(); }
  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    return lattice.compare(b, a);
  }

  template<typename Elem>
  bool join(Element& joinee, const Elem& joiner) const noexcept {
    return lattice.meet(joinee, joiner);
  }

  template<typename Elem>
  bool meet(Element& meetee, const Elem& meeter) const noexcept {
    return lattice.join(meetee, meeter);
  }
};

// Deduction guide.
template<typename L> Inverted(L&&) -> Inverted<L>;

#if __cplusplus >= 202002L
static_assert(Lattice<Inverted<Bool>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_inverted_h
