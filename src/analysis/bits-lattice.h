#ifndef wasm_analysis_bits_lattice_h
#define wasm_analysis_bits_lattice_h

#include "lattice.h"

namespace wasm::analysis {

struct BitsLattice {
  enum Status { BOTTOM, NUMBER, TOP };

  class Element {
    Status status = Status::BOTTOM;
    uint32_t value = 0;

  public:
    bool isTop() { return status == Status::TOP; }
    bool isBottom() { return status == Status::BOTTOM; }

    uint32_t getValue() { return value; }
    void setValue(uint32_t val) {
      if (status != Status::TOP) {
        value = val;
        status = Status::NUMBER;
      }
    }

    bool makeLeastUpperBound(const Element& other) {
      if (other.status > status) {
        if (other.status == Status::NUMBER) {
          status = Status::NUMBER;
          value = other.value;
          return true;
        } else if (other.status == Status::TOP) {
          status = Status::TOP;
          return true;
        }
      } else if (other.status == status && status == Status::NUMBER &&
                 other.value != value) {
        status = Status::TOP;
        return true;
      }

      return false;
    }

    void print(std::ostream& os) {
      switch (status) {
        case Status::BOTTOM:
          os << "BOTTOM";
          break;
        case Status::TOP:
          os << "TOP";
          break;
        default:
          os << value;
      }
    }

    friend BitsLattice;
  };

  LatticeComparison compare(const Element& left, const Element& right) {
    if (left.status < right.status) {
      return LatticeComparison::LESS;
    } else if (left.status > right.status) {
      return LatticeComparison::GREATER;
    } else {
      return LatticeComparison::EQUAL;
    }
  }

  Element getBottom() {
    Element result;
    return result;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis__bitslattice_h