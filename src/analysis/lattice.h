#ifndef wasm_analysis_lattice_h
#define wasm_analysis_lattice_h

#include <iostream>
#include <unordered_map>
#include <vector>

#include "wasm.h"

namespace wasm::analysis {

enum LatticeComparison { NO_RELATION, EQUAL, LESS, GREATER };

// If parameter "comparison" compares x and y, the function returns the opposite
// direction comparison between y and x.
inline LatticeComparison reverseComparison(LatticeComparison comparison) {
  if (comparison == LatticeComparison::LESS) {
    return LatticeComparison::GREATER;
  } else if (comparison == LatticeComparison::GREATER) {
    return LatticeComparison::LESS;
  } else {
    return comparison;
  }
}

#if __cplusplus >= 202002L

#include <concepts>

template<typename L>
concept Lattice = requires(const L& lattice,
                           const typename L::Element& constElem,
                           typename L::Element& elem) {
  // Lattices must have elements.
  typename L::Element;
  // We need to be able to get the bottom element.
  { lattice.getBottom() } noexcept -> std::same_as<typename L::Element>;
  // Elements should be comparable. TODO: use <=> and std::three_way_comparable
  // once we support C++20 everywhere.
  {
    lattice.compare(constElem, constElem)
  } noexcept -> std::same_as<LatticeComparison>;
  // We need to be able to get the least upper bound of two elements and know
  // whether any change was made.
  { elem.makeLeastUpperBound(constElem) } noexcept -> std::same_as<bool>;
};

#else

#define Lattice typename

#endif // __cplusplus >= 202002L

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

  // Returns the size of the set that the powerset lattices was created from.
  size_t getSetSize() { return setSize; }

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
    Element(const Element& source) = default;

    Element& operator=(Element&& source) = default;
    Element& operator=(const Element& source) = default;

    // Counts the number of members present the element itself. For instance, if
    // we had {true, false, true}, the count would be 2. O(N) operation which
    // iterates through the bitvector.
    size_t count() const;

    bool get(size_t index) { return bitvector[index]; }
    void set(size_t index, bool value) { bitvector[index] = value; }

    bool isTop() const { return count() == bitvector.size(); }
    bool isBottom() const { return count() == 0; }

    // Calculates the LUB of this element with some other element and sets
    // this element to the LUB in place. Returns true if this element before
    // this method call was different than the LUB.
    bool makeLeastUpperBound(const Element& other) noexcept;

    // Prints out the bits in the bitvector for a lattice element.
    void print(std::ostream& os);

    friend FiniteIntPowersetLattice;
  };

  // Compares two lattice elements and returns a result indicating the
  // left element's relation to the right element.
  LatticeComparison compare(const Element& left,
                            const Element& right) const noexcept;

  // Returns an instance of the bottom lattice element.
  Element getBottom() const noexcept;
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

  // Iterator to access the list of element members.
  using membersIterator = typename std::vector<T>::const_iterator;
  membersIterator membersBegin() { return members.cbegin(); }
  membersIterator membersEnd() { return members.cend(); }
  size_t getSetSize() { return intLattice.getSetSize(); }

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
  LatticeComparison compare(const Element& left,
                            const Element& right) const noexcept {
    return intLattice.compare(left, right);
  }

  Element getBottom() const noexcept { return intLattice.getBottom(); }
};

} // namespace wasm::analysis

#include "powerset-lattice-impl.h"

#endif // wasm_analysis_lattice_h
