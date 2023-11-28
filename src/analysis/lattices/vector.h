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

#ifndef wasm_analysis_lattices_vector_h
#define wasm_analysis_lattices_vector_h

#include <vector>

#include "../lattice.h"
#include "bool.h"
#include "flat.h"

namespace wasm::analysis {

// A lattice whose elements are N-tuples of elements of L. Also written as L^N.
// N is supplied at run time rather than compile time like it is for Array.
template<Lattice L> struct Vector {
  using Element = std::vector<typename L::Element>;

  // Represent a vector in which all but one of the elements are bottom without
  // materializing the full vector.
  struct SingletonElement : std::pair<size_t, typename L::Element> {
    SingletonElement(size_t i, typename L::Element&& elem)
      : std::pair<size_t, typename L::Element>{i, std::move(elem)} {}
  };

  L lattice;
  const size_t size;

  Vector(L&& lattice, size_t size) : lattice(std::move(lattice)), size(size) {}

  Element getBottom() const noexcept {
    return Element(size, lattice.getBottom());
  }

  Element getTop() const noexcept { return Element(size, lattice.getTop()); }

  // `a` <= `b` if their elements are pairwise <=, etc. Unless we determine
  // that there is no relation, we must check all the elements.
  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    assert(a.size() == size);
    assert(b.size() == size);
    auto result = EQUAL;
    for (size_t i = 0; i < size; ++i) {
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
    assert(joinee.size() == size);
    assert(joiner.size() == size);
    bool result = false;
    for (size_t i = 0; i < size; ++i) {
      result |= joinAtIndex(joinee, i, joiner[i]);
    }
    return result;
  }

  bool join(Element& joinee, const SingletonElement& joiner) const noexcept {
    const auto& [index, elem] = joiner;
    assert(index < joinee.size());
    return joinAtIndex(joinee, index, elem);
  }

  // Pairwise meet on the elements.
  bool meet(Element& meetee, const Element& meeter) const noexcept {
    assert(meetee.size() == size);
    assert(meeter.size() == size);
    bool result = false;
    for (size_t i = 0; i < size; ++i) {
      result |= meetAtIndex(meetee, i, meeter[i]);
    }
    return result;
  }

  bool meet(Element& meetee, const SingletonElement& meeter) const noexcept {
    const auto& [index, elem] = meeter;
    assert(index < meetee.size());
    return meetAtIndex(meetee, index, elem);
  }

private:
  bool joinAtIndex(Element& joinee,
                   size_t i,
                   const typename L::Element& elem) const noexcept {
    if constexpr (std::is_same_v<typename L::Element, bool>) {
      // The vector<bool> specialization does not expose references to the
      // individual bools because they might be in a bitmap, so we need a
      // workaround.
      bool e = joinee[i];
      if (lattice.join(e, elem)) {
        joinee[i] = e;
        return true;
      }
      return false;
    } else {
      return lattice.join(joinee[i], elem);
    }
  }

  bool meetAtIndex(Element& meetee,
                   size_t i,
                   const typename L::Element& elem) const noexcept {
    if constexpr (std::is_same_v<typename L::Element, bool>) {
      // The vector<bool> specialization does not expose references to the
      // individual bools because they might be in a bitmap, so we need a
      // workaround.
      bool e = meetee[i];
      if (lattice.meet(e, elem)) {
        meetee[i] = e;
        return true;
      }
      return false;
    } else {
      return lattice.meet(meetee[i], elem);
    }
  }
};

// Deduction guide.
template<typename L> Vector(L&&, size_t) -> Vector<L>;

#if __cplusplus >= 202002L
static_assert(FullLattice<Vector<Bool>>);
static_assert(Lattice<Vector<Flat<bool>>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_vector_h
