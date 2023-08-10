#ifndef wasm_analysis_bits_bounds_lattice_h
#define wasm_analysis_bits_bounds_lattice_h

#include <optional>

#include "lattice.h"
#include "wasm.h"

namespace wasm::analysis {

struct MaxBitsLattice {
  enum LatticeState { BOTTOM, REGULAR_VALUE, TOP };

  struct Element {
    Index upperBound = 0;
    std::optional<Literal> constVal;
    LatticeState state = BOTTOM;

    bool isTop() const { return state == TOP; }

    bool isBottom() const { return state == BOTTOM; }

    void setUpperBound(Index upperBound) {
      if (state != TOP) {
        state = REGULAR_VALUE;
        this->upperBound = upperBound;
        constVal.reset();
      }
    }

    void setUpperBound(Index upperBound, Literal constVal) {
      if (state != TOP) {
        state = REGULAR_VALUE;
        this->upperBound = upperBound;
        this->constVal = constVal;
      }
    }

    void setTop() {
      state = TOP;
      upperBound = UINT32_MAX;
      constVal.reset();
    }

    bool makeLeastUpperBound(const Element& other) {
      if (other.isBottom() || isTop()) {
        return false;
      } else if (other.isTop()) {
        setTop();
        return true;
      } else if (isBottom()) {
        if (other.constVal.has_value()) {
          setUpperBound(other.upperBound, other.constVal.value());
        } else {
          setUpperBound(other.upperBound);
        }
        return true;
      }

      if (upperBound < other.upperBound) {
        if (other.constVal.has_value()) {
          setUpperBound(other.upperBound, other.constVal.value());
        } else {
          setUpperBound(other.upperBound);
        }
        return true;
      } else if (upperBound == other.upperBound && other.constVal.has_value()) {
        if (constVal.has_value()) {
          constVal.reset();
        } else {
          constVal = other.constVal.value();
        }
        return true;
      }

      return false;
    }

    void print(std::ostream& os) {
      if (state == TOP) {
        os << "TOP";
      } else if (state == BOTTOM) {
        os << "BOTTOM";
      } else {
        os << upperBound;
        if (constVal.has_value()) {
          os << " " << constVal.value();
        }
      }
    }

    friend MaxBitsLattice;
  };

  LatticeComparison compare(const Element& left, const Element& right) {
    if (left.isTop()) {
      if (right.isTop()) {
        return LatticeComparison::EQUAL;
      } else {
        return LatticeComparison::GREATER;
      }
    } else if (right.isTop()) {
      return LatticeComparison::LESS;
    } else if (left.isBottom()) {
      if (right.isBottom()) {
        return LatticeComparison::EQUAL;
      } else {
        return LatticeComparison::LESS;
      }
    } else if (right.isBottom()) {
      return LatticeComparison::GREATER;
    }

    if (left.upperBound > right.upperBound) {
      return LatticeComparison::GREATER;
    } else if (left.upperBound < right.upperBound) {
      return LatticeComparison::LESS;
    } else {
      if (left.constVal.has_value()) {
        if (right.constVal.has_value()) {
          if (left.constVal.value() == right.constVal.value()) {
            return LatticeComparison::EQUAL;
          } else {
            return LatticeComparison::NO_RELATION;
          }
        } else {
          return LatticeComparison::LESS;
        }
      } else {
        if (right.constVal.has_value()) {
          return LatticeComparison::GREATER;
        } else {
          return LatticeComparison::EQUAL;
        }
      }
    }
  }

  Element getBottom() { return Element{}; }
};

} // namespace wasm::analysis

#endif // wasm_analysis_bits_bounds_lattice_h