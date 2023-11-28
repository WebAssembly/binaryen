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

#ifndef wasm_analysis_lattices_array_h
#define wasm_analysis_lattices_array_h

#include <array>
#include <utility>

#include "../lattice.h"
#include "bool.h"
#include "flat.h"

namespace wasm::analysis {

// A lattice whose elements are N-tuples of elements of L. Also written as L^N.
// N is supplied at compile time rather than run time like it is for Vector.
template<Lattice L, size_t N> struct Array {
  using Element = std::array<typename L::Element, N>;

  L lattice;

  Array(L&& lattice) : lattice(std::move(lattice)) {}

private:
  // Use a template parameter pack to generate N copies of
  // `lattice.getBottom()`. TODO: Use C++20 lambda template parameters instead
  // of a separate helper function.
  template<size_t... I>
  Element getBottomImpl(std::index_sequence<I...>) const noexcept {
    return {((void)I, lattice.getBottom())...};
  }
  template<size_t... I>
  Element getTopImpl(std::index_sequence<I...>) const noexcept {
    return {((void)I, lattice.getTop())...};
  }

public:
  Element getBottom() const noexcept {
    return getBottomImpl(std::make_index_sequence<N>());
  }

  Element getTop() const noexcept
#if __cplusplus >= 202002L
    requires FullLattice<L>
#endif
  {
    return getTopImpl(std::make_index_sequence<N>());
  }

  // `a` <= `b` if all their elements are pairwise <=, etc. Unless we determine
  // that there is no relation, we must check all the elements.
  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    auto result = EQUAL;
    for (size_t i = 0; i < N; ++i) {
      switch (lattice.compare(a[i], b[i])) {
        case NO_RELATION:
          return NO_RELATION;
        case EQUAL:
          continue;
        case LESS:
          if (result == GREATER) {
            // Cannot be both less and greater.
            return NO_RELATION;
          }
          result = LESS;
          continue;
        case GREATER:
          if (result == LESS) {
            // Cannot be both greater and less.
            return NO_RELATION;
          }
          result = GREATER;
          continue;
      }
    }
    return result;
  }

  // Pairwise join on the elements.
  bool join(Element& joinee, const Element& joiner) const noexcept {
    bool result = false;
    for (size_t i = 0; i < N; ++i) {
      result |= lattice.join(joinee[i], joiner[i]);
    }
    return result;
  }

  // Pairwise meet on the elements.
  bool meet(Element& meetee, const Element& meeter) const noexcept
#if __cplusplus >= 202002L
    requires FullLattice<L>
#endif
  {
    bool result = false;
    for (size_t i = 0; i < N; ++i) {
      result |= lattice.meet(meetee[i], meeter[i]);
    }
    return result;
  }
};

#if __cplusplus >= 202002L
static_assert(FullLattice<Array<Bool, 1>>);
static_assert(Lattice<Array<Flat<bool>, 1>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_array_h
