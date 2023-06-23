#include "lattice.h"
#include <type_traits>

namespace wasm::analysis {

struct SignLattice {
public:
  enum Sign { BOTTOM, NEGATIVE, ZERO, POSITIVE, TOP };

private:
  Sign value;

public:
  static bool isTop(const SignLattice& element) { return element.value == TOP; }

  static bool isBottom(const SignLattice& element) {
    return element.value == BOTTOM;
  }

  static LatticeComparison compare(const SignLattice& left,
                                   const SignLattice& right) {
    if (left.value == right.value) {
      return EQUAL;
    } else if (left.value == BOTTOM || right.value == TOP) {
      return LESS;
    } else if (left.value == TOP || right.value == BOTTOM) {
      return GREATER;
    } else {
      return NO_RELATION;
    }
  }

  // Modifies the left lattice element to the least upper bound between
  // it and the right hand lattice element in-place. Returns true
  // if the left lattice element has been changed.
  void getLeastUpperBound(const SignLattice& right) {
    if (value == right.value || value == TOP || right.value == BOTTOM) {
      return;
    } else if (value == BOTTOM || right.value == TOP) {
      value = right.value;
    } else {
      value = TOP;
    }
  }
};

static_assert(is_lattice<SignLattice>);

} // namespace wasm::analysis
