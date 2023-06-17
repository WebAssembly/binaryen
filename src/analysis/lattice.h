#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#include <bitset>
#include <iostream>
#include "wasm.h"

namespace wasm::analysis {

enum LatticeComparison {
    NO_RELATION,
    EQUAL,
    LESS,
    GREATER
};

template<size_t N>
struct BitsetPowersetLattice {
    std::bitset<N> value;
    static BitsetPowersetLattice<N> getBottom();
    static bool isTop(const BitsetPowersetLattice<N> & element);
    static bool isBottom(const BitsetPowersetLattice<N> & element);
    static LatticeComparison compare(const BitsetPowersetLattice<N> & left, const BitsetPowersetLattice<N> & right);
    static BitsetPowersetLattice<N> getLeastUpperBound(const BitsetPowersetLattice<N> & left, const BitsetPowersetLattice<N> & right);
    void print(std::ostream& os);
};

}

#endif // wasm_analysis_lattice_h