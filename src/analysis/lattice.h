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
  std::vector<bool> bitvector;

  // Counts the number of elements in the set (i. e. number of trues in the
  // bitvector).
  size_t trues;

  // Size of the top lattice element must be specified, as it determines the set
  // of the bitvector.
  FinitePowersetLattice(size_t size);

public:
  void set(size_t index, bool value);
  bool get(size_t index);
  size_t size() { return bitvector.size(); }
  size_t countElements() { return trues; }

  using iterator = std::vector<bool>::const_iterator;
  iterator begin() { return bitvector.cbegin(); }
  iterator end() { return bitvector.cend(); }

  // Returns an instance of the bottom lattice element. The size of the the top
  // lattice element must be specified.
  static FinitePowersetLattice getBottom(size_t size);
  bool isTop();
  bool isBottom();

  // Compares two lattice elements and returns a result indicating the
  // left element's relation to the right element.
  static LatticeComparison compare(const FinitePowersetLattice& left,
                                   const FinitePowersetLattice& right);

  // Calculates the LUB of this current (left) lattice element with some right
  // element. It then updates this current lattice element to the LUB in place.
  // Returns true if the current lattice element was changed, false otherwise.
  bool getLeastUpperBound(const FinitePowersetLattice& right);

  // Prints out the bits in the bitvector for a lattice element.
  void print(std::ostream& os);
};

} // namespace wasm::analysis

#include "powerset-lattice-impl.h"

#endif // wasm_analysis_lattice_h
