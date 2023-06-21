#ifndef wasm_analysis_lattice_impl_h
#define wasm_analysis_lattice_impl_h

#include "lattice.h"

namespace wasm::analysis {

template<size_t N>
BitsetPowersetLattice<N> BitsetPowersetLattice<N>::getBottom() {
  BitsetPowersetLattice<N> result{0};
  return result;
}

template<size_t N>
bool BitsetPowersetLattice<N>::isTop(const BitsetPowersetLattice<N>& element) {
  return element.value.all();
}

template<size_t N>
bool BitsetPowersetLattice<N>::isBottom(
  const BitsetPowersetLattice<N>& element) {
  return element.value.none();
}

template<size_t N>
LatticeComparison
BitsetPowersetLattice<N>::compare(const BitsetPowersetLattice<N>& left,
                                  const BitsetPowersetLattice<N>& right) {
  size_t leftCount = left.value.count();
  size_t rightCount = right.value.count();

  // if left has more elements, left might be a superset of right
  if (leftCount > rightCount) {
    if ((left.value | right.value) == left.value) {
      return GREATER;
    }
    // if right has more elements, right might be a superset of left
  } else if (leftCount < rightCount) {
    if ((left.value | right.value) == right.value) {
      return LESS;
    }
  } else if (left.value == right.value) {
    return EQUAL;
  }

  return NO_RELATION;
}

// Implement LUB as an OR of the two sets.
template<size_t N>
BitsetPowersetLattice<N> BitsetPowersetLattice<N>::getLeastUpperBound(
  const BitsetPowersetLattice<N>& left, const BitsetPowersetLattice<N>& right) {
  BitsetPowersetLattice<N> result;
  result.value = left.value | right.value;
  return result;
}

template<size_t N> void BitsetPowersetLattice<N>::print(std::ostream& os) {
  os << value << std::endl;
}

}; // namespace wasm::analysis

#endif // wasm_analysis_lattice_impl_h
