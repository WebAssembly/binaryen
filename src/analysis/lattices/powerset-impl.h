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

#ifndef wasm_analysis_lattices_powerset_impl_h
#define wasm_analysis_lattices_powerset_impl_h

#include <iostream>

#include "powerset.h"

namespace wasm::analysis {

inline LatticeComparison FiniteIntPowersetLattice::compare(
  const FiniteIntPowersetLattice::Element& left,
  const FiniteIntPowersetLattice::Element& right) const noexcept {
  // Both must be from the powerset lattice of the same set.
  assert(left.bitvector.size() == right.bitvector.size());

  // True in left, false in right.
  bool leftNotRight = false;

  // True in right, false in left.
  bool rightNotLeft = false;

  size_t size = left.bitvector.size();

  for (size_t i = 0; i < size; ++i) {
    leftNotRight |= (left.bitvector[i] && !right.bitvector[i]);
    rightNotLeft |= (right.bitvector[i] && !left.bitvector[i]);

    // We can end early if we know neither is a subset of the other.
    if (leftNotRight && rightNotLeft) {
      return NO_RELATION;
    }
  }

  if (!leftNotRight) {
    if (!rightNotLeft) {
      return EQUAL;
    }
    return LESS;
  } else if (!rightNotLeft) {
    return GREATER;
  }

  return NO_RELATION;
}

inline FiniteIntPowersetLattice::Element
FiniteIntPowersetLattice::getBottom() const noexcept {
  FiniteIntPowersetLattice::Element result(setSize);
  return result;
}

// We count the number of element members present in the element by counting the
// trues in the bitvector.
inline size_t FiniteIntPowersetLattice::Element::count() const {
  size_t count = 0;
  for (auto it : bitvector) {
    count += it;
  }
  return count;
}

// Least upper bound is implemented as a logical OR between the bitvectors on
// both sides. We return true if a bit is flipped in-place on the left so the
// worklist algorithm will know if when to enqueue more work.
inline bool
FiniteIntPowersetLattice::join(Element& joinee,
                               const Element& joiner) const noexcept {
  // Both must be from powerset lattice of the same set.
  assert(joiner.bitvector.size() == joinee.bitvector.size());

  bool modified = false;
  for (size_t i = 0; i < joinee.bitvector.size(); ++i) {
    // Bit is flipped on joinee only if joinee is false and joiner is true when
    // joinee and joiner are OR'ed together.
    modified |= (!joinee.bitvector[i] && joiner.bitvector[i]);
    joinee.bitvector[i] = joinee.bitvector[i] || joiner.bitvector[i];
  }

  return modified;
}

inline void FiniteIntPowersetLattice::Element::print(std::ostream& os) {
  // Element member 0 is on the left, element member N is on the right.
  for (auto it : bitvector) {
    os << it;
  }
}

}; // namespace wasm::analysis

#endif // wasm_analysis_lattices_powerset_impl_h
