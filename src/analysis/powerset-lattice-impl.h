#ifndef wasm_analysis_lattice_impl_h
#define wasm_analysis_lattice_impl_h

#include "lattice.h"

namespace wasm::analysis {

template<size_t N>
inline BitsetPowersetLattice<N> BitsetPowersetLattice<N>::getBottom() {
  // Return the empty set as the bottom lattice element.
  BitsetPowersetLattice<N> result{0};
  return result;
}

template<size_t N>
inline bool
BitsetPowersetLattice<N>::isTop(const BitsetPowersetLattice<N>& element) {
  // Top lattice element is the set containing all possible elements.
  return element.value.all();
}

template<size_t N>
inline bool
BitsetPowersetLattice<N>::isBottom(const BitsetPowersetLattice<N>& element) {
  // Bottom lattice element is the empty set.
  return element.value.none();
}

template<size_t N>
inline LatticeComparison
BitsetPowersetLattice<N>::compare(const BitsetPowersetLattice<N>& left,
                                  const BitsetPowersetLattice<N>& right) {
  size_t leftCount = left.value.count();
  size_t rightCount = right.value.count();

  // If left has more elements, left might be a superset of right.
  if (leftCount > rightCount) {
    if ((left.value | right.value) == left.value) {
      return GREATER;
    }
    // If right has more elements, right might be a superset of left.
  } else if (leftCount < rightCount) {
    if ((left.value | right.value) == right.value) {
      return LESS;
    }
  } else if (left.value == right.value) {
    return EQUAL;
  }

  return NO_RELATION;
}

// Implement LUB as an OR of the two bitsets.
template<size_t N>
inline void BitsetPowersetLattice<N>::getLeastUpperBound(
  const BitsetPowersetLattice<N>& right) {
  value |= right.value;
}

template<size_t N>
inline void BitsetPowersetLattice<N>::print(std::ostream& os) {
  os << value;
}

}; // namespace wasm::analysis

#endif // wasm_analysis_lattice_impl_h
