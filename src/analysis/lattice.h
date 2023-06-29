#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#include <iostream>
#include <vector>

#include "wasm.h"

namespace wasm::analysis {

enum LatticeComparison { NO_RELATION, EQUAL, LESS, GREATER };

template<typename Lattice>
constexpr bool has_getBottom =
  std::is_invocable_r<typename Lattice::Element,
                      decltype(&Lattice::getBottom),
                      Lattice>::value;
template<typename Lattice>
constexpr bool has_compare =
  std::is_invocable_r<LatticeComparison,
                      decltype(Lattice::compare),
                      const typename Lattice::Element&,
                      const typename Lattice::Element&>::value;
template<typename Element>
constexpr bool has_makeLeastUpperBound =
  std::is_invocable_r<void,
                      decltype(&Element::makeLeastUpperBound),
                      Element,
                      const Element&>::value;
template<typename Element>
constexpr bool has_isTop =
  std::is_invocable_r<bool, decltype(&Element::isTop), Element>::value;
template<typename Element>
constexpr bool has_isBottom =
  std::is_invocable_r<bool, decltype(&Element::isBottom), Element>::value;

template<typename Lattice>
constexpr bool is_lattice = has_getBottom<Lattice>&& has_compare<Lattice>&&
  has_makeLeastUpperBound<typename Lattice::Element>&& has_isTop<
    typename Lattice::Element>&& has_isBottom<typename Lattice::Element>;

// Represents a powerset lattice which is constructed from a finite set which
// can be represented by a bitvector. Set elements are represented by
// FinitePowersetLattice::Element, which represents members present in each
// element by bits in the bitvector.
class FinitePowersetLattice {

  // The size of the set that the powerset lattice was created from. This is
  // equivalent to the size of the Top lattice element.
  size_t setSize;

public:
  FinitePowersetLattice(size_t setSize) : setSize(setSize) {}

  // This represents an element of a powerset lattice. The element is itself a
  // set which has set members. The bitvector tracks which possible members of
  // the element are actually present.
  class Element {
    // If bitvector[i] is true, then member i is present in the lattice element,
    // otherwise it isn't.
    std::vector<bool> bitvector;

    // This constructs a bottom element, given the lattice set size. Used by the
    // lattice's getBottom function.
    Element(size_t latticeSetSize) : bitvector(latticeSetSize) {}

  public:
    Element(Element&& source) = default;
    Element(Element& source) = default;

    Element& operator=(Element&& source) = default;
    Element& operator=(const Element& source) = default;

    // Counts the number of members present the element itself. For instance, if
    // we had {true, false, true}, the count would be 2. O(N) operation which
    // iterates through the bitvector.
    size_t count();

    bool get(size_t index) { return bitvector[index]; }
    void set(size_t index, bool value) { bitvector[index] = value; }

    bool isTop() { return count() == bitvector.size(); }
    bool isBottom() { return count() == 0; }

    // Calculates the LUB of this element with some other element and sets
    // this element to the LUB in place. Returns true if this element before
    // this method call was different than the LUB.
    bool makeLeastUpperBound(const Element& other);

    // Prints out the bits in the bitvector for a lattice element.
    void print(std::ostream& os);

    friend FinitePowersetLattice;
  };

  // Compares two lattice elements and returns a result indicating the
  // left element's relation to the right element.
  static LatticeComparison compare(const Element& left, const Element& right);

  // Returns an instance of the bottom lattice element.
  Element getBottom();
};

static_assert(is_lattice<FinitePowersetLattice>);

} // namespace wasm::analysis

#include "powerset-lattice-impl.h"

#endif // wasm_analysis_lattice_h
