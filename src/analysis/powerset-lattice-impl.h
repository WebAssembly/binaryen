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

  if (left.elementSize > right.elementSize) {
    // If there are more elements in the left, some must not be in the right.
    leftNotRight = true;
  } else if (right.elementSize > left.elementSize) {
    // If there are more elements in the right, some must not be in the left.
    rightNotLeft = true;
  }

  size_t size = left.bitvector.size();

  for (size_t i = 0; i < size; ++i) {
    if (left.bitvector[i] && !right.bitvector[i]) {
      leftNotRight = true;
    } else if (right.bitvector[i] && !left.bitvector[i]) {
      rightNotLeft = true;
    }

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

inline void FinitePowersetLattice::Element::set(size_t index, bool value) {
  // The set function updates the count of true bits in the bitvector.
  if (value != bitvector.at(index)) {
    if (value) {
      elementSize += 1;
    } else {
      elementSize -= 1;
    }
  }
  bitvector.at(index) = value;
}

// Least upper bound is implemented as a logical OR between the bitvectors on
// both sides.
inline bool FinitePowersetLattice::Element::getLeastUpperBound(
  const FinitePowersetLattice::Element& right) {
  // Both must be from powerset lattice of the same set.
  assert(right.bitvector.size() == bitvector.size());

  bool modified = false;
  for (size_t i = 0; i < bitvector.size(); ++i) {
    if (!bitvector.at(i) && right.bitvector.at(i)) {
      bitvector.at(i) = true;
      elementSize++;
      modified = true;
    }
  }

  return modified;
}

inline void FinitePowersetLattice::Element::print(std::ostream& os) {
  for (auto it : bitvector) {
    os << it;
  }
}

}; // namespace wasm::analysis

#endif // wasm_analysis_lattice_impl_h
