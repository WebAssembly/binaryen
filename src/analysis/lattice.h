#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#include <iostream>
#include <unordered_map>
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

// Represents a powerset lattice constructed from a finite set of consecutive
// integers from 0 to n which can be represented by a bitvector. Set elements
// are represented by FiniteIntPowersetLattice::Element, which represents
// members present in each element by bits in the bitvector.
class FiniteIntPowersetLattice {
  // The size of the set that the powerset lattice was created from. This is
  // equivalent to the size of the Top lattice element.
  size_t setSize;

public:
  FiniteIntPowersetLattice(size_t setSize) : setSize(setSize) {}

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

    friend FiniteIntPowersetLattice;
  };

  // Compares two lattice elements and returns a result indicating the
  // left element's relation to the right element.
  static LatticeComparison compare(const Element& left, const Element& right);

  // Returns an instance of the bottom lattice element.
  Element getBottom();
};

// A layer of abstraction over FiniteIntPowersetLattice which maps
// set members of some type T to indices in the bitvector. Allows
// the finite powerset lattice to be generalized to arbitrary types.
template<typename T> class FinitePowersetLattice {
  FiniteIntPowersetLattice intLattice;

  // Maps a bitvector index to some element member of type T.
  // Used to produce initial ordering of element members.
  std::vector<T> members;

  // Maps an element member of type T to a bitvector index.
  std::unordered_map<T, size_t> memberIndices;

public:
  using Element = FiniteIntPowersetLattice::Element;

  // Takes in an ordered list of all elements of the set to create
  // the powerset lattice from (i.e. the powerset lattice top element). This
  // is used for mapping the elements to bitvector indices.
  FinitePowersetLattice(std::vector<T>&& setMembers)
    : intLattice(setMembers.size()), members(std::move(setMembers)) {
    for (size_t i = 0; i < members.size(); ++i) {
      memberIndices[members[i]] = i;
    }
  }

  T indexToMember(size_t index) { return members[index]; }

  size_t memberToIndex(T member) { return memberIndices[member]; }

  // Adds member to a powerset lattice element.
  void add(Element* element, T member) {
    element->set(memberIndices[member], true);
  }

  // Removes member from a powerset lattice element.
  void remove(Element* element, T member) {
    element->set(memberIndices[member], false);
  }

  // Checks if member is included in the element set.
  bool exists(Element* element, T member) {
    return element->get(memberIndices[member]);
  }

  // We use implementations from FiniteIntPowersetLattice here.
  static LatticeComparison compare(const Element& left, const Element& right) {
    return FiniteIntPowersetLattice::compare(left, right);
  }

  Element getBottom() { return intLattice.getBottom(); }
};

} // namespace wasm::analysis

#include "powerset-lattice-impl.h"

#endif // wasm_analysis_lattice_h
