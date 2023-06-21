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

  static SignLattice getLeastUpperBound(const SignLattice& left,
                                        const SignLattice& right) {
    SignLattice lub;
    LatticeComparison cmp = compare(left, right);
    if (cmp == EQUAL || cmp == GREATER) {
      lub.value = left.value;
    } else if (cmp == LESS) {
      lub.value = right.value;
    } else {
      lub.value = TOP;
    }

    return lub;
  }
};

template<typename T>
inline constexpr bool is_lattice =
  std::is_invocable_r<LatticeComparison,
                      decltype(SignLattice::compare),
                      const SignLattice&,
                      const SignLattice&>::value &&
  std::is_invocable_r<SignLattice,
                      decltype(SignLattice::getLeastUpperBound),
                      const SignLattice&,
                      const SignLattice&>::value &&
  std::is_invocable_r<bool, decltype(SignLattice::isTop), const SignLattice&>::
    value &&
  std::is_invocable_r<bool,
                      decltype(SignLattice::isBottom),
                      const SignLattice&>::value;

static_assert(is_lattice<SignLattice>);

} // namespace wasm::analysis
