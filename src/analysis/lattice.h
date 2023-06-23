#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#include "wasm.h"
#include <bitset>
#include <iostream>

namespace wasm::analysis {

enum LatticeComparison { NO_RELATION, EQUAL, LESS, GREATER };

template<typename T>
constexpr bool has_compare = std::is_invocable_r<LatticeComparison,
                                                 decltype(T::compare),
                                                 const T&,
                                                 const T&>::value;
template<typename T>
constexpr bool has_getLeastUpperBound = std::
  is_invocable_r<void, decltype(&T::getLeastUpperBound), T, const T&>::value;
template<typename T>
constexpr bool has_isTop =
  std::is_invocable_r<bool, decltype(T::isTop), const T&>::value;
template<typename T>
constexpr bool has_isBottom =
  std::is_invocable_r<bool, decltype(T::isBottom), const T&>::value;

template<typename T>
constexpr bool is_lattice =
  has_compare<T>&& has_getLeastUpperBound<T>&& has_isTop<T>&& has_isBottom<T>;

// Represents a powerset lattice element (i.e. a set) as a bitvector. A true
// means that an element is present in the set.
template<size_t N> struct BitsetPowersetLattice {
  std::bitset<N> value;

  static BitsetPowersetLattice<N> getBottom();
  static bool isTop(const BitsetPowersetLattice<N>& element);
  static bool isBottom(const BitsetPowersetLattice<N>& element);

  // Compares two lattice elements and returns a result indicating the
  // left element's relation to the right element.
  static LatticeComparison compare(const BitsetPowersetLattice<N>& left,
                                   const BitsetPowersetLattice<N>& right);

  // Calculates the LUB of this current (left) lattice element with some right
  // element. It then updates this current lattice element to the LUB in place.
  void getLeastUpperBound(const BitsetPowersetLattice<N>& right);

  // Prints out the bits in the bitvector for a lattice element.
  void print(std::ostream& os);
};

} // namespace wasm::analysis

#include "powerset-lattice-impl.h"

#endif // wasm_analysis_lattice_h
