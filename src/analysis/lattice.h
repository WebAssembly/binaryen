#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#include "wasm.h"
#include <bitset>
#include <iostream>

namespace wasm::analysis {

enum LatticeComparison { NO_RELATION, EQUAL, LESS, GREATER };

// Represents a powerset lattice element (i.e. a set) as a bitvector. A true
// means that an element is present in the set.
template<size_t N> struct BitsetPowersetLattice {
  std::bitset<N> value;

  // Copies sets the bitvector to be identical to that of a source lattice
  // element.
  inline void copy(BitsetPowersetLattice<N>& src);

  // Returns a bottom lattice element to use.
  static inline BitsetPowersetLattice<N> getBottom();

  // Indicates whether a lattice element is the top element.
  static inline bool isTop(const BitsetPowersetLattice<N>& element);

  // Indicates whether a lattice element is the bottom element.
  static inline bool isBottom(const BitsetPowersetLattice<N>& element);

  // Compares two lattice elements and returns a result indicating the
  // left element's relation to the right element.
  static inline LatticeComparison
  compare(const BitsetPowersetLattice<N>& left,
          const BitsetPowersetLattice<N>& right);

  // Returns a lattice element which is the least upper bound of the left and
  // right elements.
  static inline BitsetPowersetLattice<N>
  getLeastUpperBound(const BitsetPowersetLattice<N>& left,
                     const BitsetPowersetLattice<N>& right);

  // Same as above function, but does this in place.
  inline void getLeastUpperBound(const BitsetPowersetLattice<N>& right);

  // Prints out the bits in the bitvector for a lattice element.
  inline void print(std::ostream& os);
};

} // namespace wasm::analysis

#include "powerset-lattice-impl.h"

#endif // wasm_analysis_lattice_h
