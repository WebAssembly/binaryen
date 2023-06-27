#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#include <iostream>
#include <vector>

#include "wasm.h"

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
  std::is_invocable_r<bool, decltype(&T::isTop), T>::value;
template<typename T>
constexpr bool has_isBottom =
  std::is_invocable_r<bool, decltype(&T::isBottom), T>::value;

template<typename T>
constexpr bool is_lattice =
  has_compare<T>&& has_getLeastUpperBound<T>&& has_isTop<T>&& has_isBottom<T>;

// Represents a powerset lattice element (i.e. a set) as a bitvector. A true
// means that an element is present in the set.
class FinitePowersetLattice {
  // The size of the set that the powerset lattice was created from. This is
  // equivalent to the size of the Top lattice element.
  size_t setSize;

public:
  FinitePowersetLattice(size_t setSize) : setSize(setSize) {}

  struct Element {
    std::vector<bool> bitvector;

    size_t count();

    using iterator = std::vector<bool>::const_iterator;
    iterator begin() { return bitvector.cbegin(); }
    iterator end() { return bitvector.cend(); }
    bool get(size_t index) { return bitvector[index]; }
    void set(size_t index, bool value) { bitvector[index] = value; }

    bool isTop() { return count() == bitvector.size(); }
    bool isBottom() { return count() == 0; }

    // Calculates the LUB of this element with some right element and sets
    // this element to the LUB in place. Returns true if this element before
    // this method call was different than the LUB.
    bool getLeastUpperBound(const Element& right);

    // Prints out the bits in the bitvector for a lattice element.
    void print(std::ostream& os);

  private:
    Element(size_t latticeSetSize) : bitvector(latticeSetSize) {}

    friend FinitePowersetLattice;
  };

  // Compares two lattice elements and returns a result indicating the
  // left element's relation to the right element.
  static LatticeComparison compare(const Element& left, const Element& right);

  // Returns an instance of the bottom lattice element. The size of the the top
  // lattice element must be specified.
  Element getBottom();
};

} // namespace wasm::analysis

#include "powerset-lattice-impl.h"

#endif // wasm_analysis_lattice_h
