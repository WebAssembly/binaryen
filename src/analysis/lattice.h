#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#include "wasm.h"
#include <bitset>
#include <iostream>

namespace wasm::analysis {

enum LatticeComparison { NO_RELATION, EQUAL, LESS, GREATER };

// represents a powerset lattice element (i.e. set) as a bitvector. A true
// means that an element is present in the set.
template<size_t N> struct BitsetPowersetLattice {
  std::bitset<N> value;
  // Returns a bottom element to use.
  static BitsetPowersetLattice<N> getBottom();

  // indicates whether a lattice is the top element.
  static bool isTop(const BitsetPowersetLattice<N>& element);

  // indicates whether a lattice is the bottom element.
  static bool isBottom(const BitsetPowersetLattice<N>& element);
  static LatticeComparison compare(const BitsetPowersetLattice<N>& left,
                                   const BitsetPowersetLattice<N>& right);
  static BitsetPowersetLattice<N>
  getLeastUpperBound(const BitsetPowersetLattice<N>& left,
                     const BitsetPowersetLattice<N>& right);

  // prints out the bits in the bitvector.
  void print(std::ostream& os);
};

} // namespace wasm::analysis

#include "powerset-lattice-impl.h"

#endif // wasm_analysis_lattice_h