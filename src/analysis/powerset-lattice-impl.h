#ifndef wasm_analysis_lattice_impl_h
#define wasm_analysis_lattice_impl_h

#include "lattice.h"

namespace wasm::analysis {

inline FinitePowersetLattice::FinitePowersetLattice(size_t size) : trues(0) {
  bitvector.reserve(size);
  for (size_t i = 0; i < size; ++i) {
    bitvector.push_back(false);
  }
}

inline FinitePowersetLattice FinitePowersetLattice::getBottom(size_t size) {
  // Return the empty set as the bottom lattice element.
  FinitePowersetLattice result(size);
  return result;
}

inline bool FinitePowersetLattice::isTop() {
  // Top lattice element is the set containing all possible elements.
  return trues == bitvector.size();
}

inline bool FinitePowersetLattice::isBottom() {
  // Bottom lattice element is the empty set.
  return trues == 0;
}

inline void FinitePowersetLattice::set(size_t index, bool value) {
  // The set function updates the count of true bits in the bitvector.
  if (value != bitvector.at(index)) {
    if (value) {
      trues += 1;
    } else {
      trues -= 1;
    }
  }
  bitvector.at(index) = value;
}

inline bool FinitePowersetLattice::get(size_t index) {
  return bitvector.at(index);
}

inline LatticeComparison
FinitePowersetLattice::compare(const FinitePowersetLattice& left,
                               const FinitePowersetLattice& right) {
  // Both must be from the powerset lattice of the same set.
  assert(left.bitvector.size() == right.bitvector.size());

  // True in left, false in right.
  bool leftNotRight = false;

  // True in right, false in left.
  bool rightNotLeft = false;

  if (left.trues > right.trues) {
    // If there are more elements in the left, some must not be in the right.
    leftNotRight = true;
  } else if (right.trues > left.trues) {
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

// Least upper bound is implemented as a logical OR between the bitvectors on
// both sides.
inline bool
FinitePowersetLattice::getLeastUpperBound(const FinitePowersetLattice& right) {
  // Both must be from powerset lattice of the same set.
  assert(right.bitvector.size() == bitvector.size());

  bool modified = false;
  for (size_t i = 0; i < bitvector.size(); ++i) {
    if (!bitvector.at(i) && right.bitvector.at(i)) {
      bitvector.at(i) = true;
      trues++;
      modified = true;
    }
  }

  return modified;
}

inline void FinitePowersetLattice::print(std::ostream& os) {
  for (auto it = bitvector.rbegin(); it != bitvector.rend(); ++it) {
    os << *it;
  }
}

}; // namespace wasm::analysis

#endif // wasm_analysis_lattice_impl_h
