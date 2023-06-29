#ifndef wasm_analysis_lattice_impl_h
#define wasm_analysis_lattice_impl_h

#include "lattice.h"

namespace wasm::analysis {

inline LatticeComparison
FinitePowersetLattice::compare(const FinitePowersetLattice::Element& left,
                               const FinitePowersetLattice::Element& right) {
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

inline FinitePowersetLattice::Element FinitePowersetLattice::getBottom() {
  FinitePowersetLattice::Element result(setSize);
  return result;
}

// We count the number of element members present in the element by counting the
// trues in the bitvector.
inline size_t FinitePowersetLattice::Element::count() {
  size_t count = 0;
  for (auto it : bitvector) {
    count += it;
  }
  return count;
}

// Least upper bound is implemented as a logical OR between the bitvectors on
// both sides. We return true if a bit is flipped in-place on the left so the
// worklist algorithm will know if when to enqueue more work.
inline bool FinitePowersetLattice::Element::makeLeastUpperBound(
  const FinitePowersetLattice::Element& other) {
  // Both must be from powerset lattice of the same set.
  assert(other.bitvector.size() == bitvector.size());

  bool modified = false;
  for (size_t i = 0; i < bitvector.size(); ++i) {
    // Bit is flipped on self only if self is false and other is true when self
    // and other are OR'ed together.
    modified |= (!bitvector[i] && other.bitvector[i]);
    bitvector[i] = bitvector[i] || other.bitvector[i];
  }

  return modified;
}

inline void FinitePowersetLattice::Element::print(std::ostream& os) {
  // Element member 0 is on the left, element member N is on the right.
  for (auto it : bitvector) {
    os << it;
  }
}

}; // namespace wasm::analysis

#endif // wasm_analysis_lattice_impl_h
