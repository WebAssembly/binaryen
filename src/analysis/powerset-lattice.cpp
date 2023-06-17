#include "lattice.h"

namespace wasm::analysis {
/*
template<typename T, >

class PowersetLattice {
    unordered_set<T> value;

    public:

    static bool isBottom(const PowersetLattice<T> & element) {
        return element.value.empty();
    }

    static LatticeComparison compare(const PowersetLattice<T> & left, const PowersetLattice<T> & right) {
        if (left.value.size() <= right.value.size()) {
            for (auto const& leftElement : left.value) {
                if () {
                    return 
                }
            }
            
            if () {

            } else {

            }
        } else {

        }
    }

    static PowersetLattice<T> getLeastUpperBound() {

    }
}
*/

template<size_t N>
BitsetPowersetLattice<N> BitsetPowersetLattice<N>::getBottom() {
    BitsetPowersetLattice<N> result{0};
    return result;
}

template<size_t N>
bool BitsetPowersetLattice<N>::isTop(const BitsetPowersetLattice<N> & element) {
    return element.value.all();
}

template<size_t N>
bool BitsetPowersetLattice<N>::isBottom(const BitsetPowersetLattice<N> & element) {
    return element.value.none();
}

template<size_t N>
LatticeComparison BitsetPowersetLattice<N>::compare(const BitsetPowersetLattice<N> & left, const BitsetPowersetLattice<N> & right) {
    size_t leftCount = left.count();
    size_t rightCount = right.count();

    if (leftCount > rightCount) {
        if (left.value | right.value == left.value) {
            return GREATER;
        }
    } else if (leftCount < rightCount) {
        if (left.value | right.value == right.value) {
            return LESS;
        }
    } else if (left.value == right.value) {
        return EQUAL;
    }

    return NO_RELATION;
}

template<size_t N>
BitsetPowersetLattice<N> BitsetPowersetLattice<N>::getLeastUpperBound(const BitsetPowersetLattice<N> & left, const BitsetPowersetLattice<N> & right) {
    BitsetPowersetLattice<N> result;
    result.value = left.value | right.value;
    return result;
}

template<size_t N>
void BitsetPowersetLattice<N>::print(std::ostream& os) {
    os << value << std::endl;
}

}; // namespace wasm::analysis
