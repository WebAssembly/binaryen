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

inline bool FinitePowersetLattice::isTop(const FinitePowersetLattice& element) {
  // Top lattice element is the set containing all possible elements.
  return element.trues == element.bitvector.size();
}

inline bool
FinitePowersetLattice::isBottom(const FinitePowersetLattice& element) {
  // Bottom lattice element is the empty set.
  return element.trues == 0;
}

inline void FinitePowersetLattice::set(size_t index, bool value) {
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
  assert(left.bitvector.size() == right.bitvector.size());

  // True in left, false in right.
  bool leftNotRight = false;

  // True in right, false in left.
  bool rightNotLeft = false;

  if (left.trues > right.trues) {
    leftNotRight = true;
  } else if (right.trues > left.trues) {
    rightNotLeft = true;
  }

  size_t size = left.bitvector.size();

  for (size_t i = 0; i < size; ++i) {
    if (left.bitvector[i] && !right.bitvector[i]) {
      leftNotRight = true;
    } else if (right.bitvector[i] && !left.bitvector[i]) {
      rightNotLeft = true;
    }

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

inline bool
FinitePowersetLattice::getLeastUpperBound(const FinitePowersetLattice& right) {
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
