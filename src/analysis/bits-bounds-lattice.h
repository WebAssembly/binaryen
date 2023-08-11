/*
 * Copyright 2023 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#ifndef wasm_analysis_bits_bounds_lattice_h
#define wasm_analysis_bits_bounds_lattice_h

#include <optional>
#include <variant>

#include "lattice.h"
#include "wasm.h"

namespace wasm::analysis {

struct MaxBitsLattice {
  enum LatticeState { BOTTOM, TOP };

  class Element {
    // If this holds a LatticeState, it indicates if the element is a top or
    // bottom element. An Index will represent the maximum number of bits a
    // value has. A Literal contains the actual value if we know what it is.
    std::variant<Index, Literal, LatticeState> value;

  public:
    bool isTop() const {
      if (std::holds_alternative<LatticeState>(value)) {
        return std::get<LatticeState>(value) == LatticeState::TOP;
      }
      return false;
    }

    void setTop() { value = LatticeState::TOP; }

    bool isBottom() const {
      if (std::holds_alternative<LatticeState>(value)) {
        return std::get<LatticeState>(value) == LatticeState::BOTTOM;
      }
      return false;
    }

    void setBottom() { value = LatticeState::BOTTOM; }

    // Returns an optional which contains a literal (i.e. constant)
    // value if it exists.
    std::optional<Literal> getLiteral() const {
      std::optional<Literal> result;
      if (std::holds_alternative<Literal>(value)) {
        result = std::get<Literal>(value);
      }
      return result;
    }

    // Returns the maximum number of bits. The optional is empty
    // for the top and bottom elements, or if the literal happens
    // not to be i32 or i64.
    std::optional<Index> getUpperBound() const {
      std::optional<Index> result;
      if (std::holds_alternative<Index>(value)) {
        result = std::get<Index>(value);
      } else if (std::holds_alternative<Literal>(value)) {
        Literal val = std::get<Literal>(value);
        if (val.type == Type::i32) {
          result = 32 - val.countLeadingZeroes().geti32();
        } else if (val.type == Type::i64) {
          result = 64 - val.countLeadingZeroes().geti64();
        }
      }
      return result;
    }

    // Returns an upper bound approximated for i32s. If Top, returns 32. If
    // bottom, or has no upper bound, returns 0.
    Index geti32ApproxUpperBound() const {
      std::optional<Index> result = getUpperBound();
      if (result.has_value()) {
        return result.value();
      } else if (isTop()) {
        return Index(32);
      } else {
        return Index(0);
      }
    }

    // Returns an upper bound approximated of i64s. If Top, returns 32. If
    // bottom, or has no upper bound, returns 0.
    Index geti64ApproxUpperBound() const {
      std::optional<Index> result = getUpperBound();
      if (result.has_value()) {
        return result.value();
      } else if (isTop()) {
        return Index(64);
      } else {
        return Index(0);
      }
    }

    void setUpperBound(Index upperBound) { value = upperBound; }

    // If we don't have a desired literal type, we switch to
    // bottom (i.e. the literal isn't supposed to have a max bits value).
    void setLiteralValue(Literal val) {
      if (val.type == Type::i32 || val.type == Type::i64) {
        value = val;
      } else {
        value = LatticeState::BOTTOM;
      }
    }

    bool makeLeastUpperBound(const Element& other) {
      if (other.isBottom() || isTop()) {
        return false;
      } else if (other.isTop()) {
        value = LatticeState::TOP;
        return true;
      } else if (isBottom()) {
        if (std::holds_alternative<Literal>(other.value)) {
          value = std::get<Literal>(other.value);
        } else {
          value = std::get<Index>(other.value);
        }
        return true;
      }

      Index currMaxBits = getUpperBound().value();
      Index otherMaxBits = other.getUpperBound().value();

      if (currMaxBits < otherMaxBits) {
        if (std::holds_alternative<Literal>(other.value)) {
          value = std::get<Literal>(other.value);
        } else {
          value = otherMaxBits;
        }
        return true;
      } else if (currMaxBits == otherMaxBits &&
                 std::holds_alternative<Literal>(value) &&
                 (!std::holds_alternative<Literal>(other.value) ||
                  std::get<Literal>(value) != std::get<Literal>(other.value))) {
        value = currMaxBits;
        return true;
      }

      return false;
    }

    void print(std::ostream& os) {
      if (LatticeState* val = std::get_if<LatticeState>(&value)) {
        if (*val == LatticeState::BOTTOM) {
          os << "BOTTOM";
        } else {
          os << "TOP";
        }
      } else if (Index* val = std::get_if<Index>(&value)) {
        os << *val;
      } else {
        os << "Literal " << std::get<Literal>(value);
      }
    }

    friend MaxBitsLattice;
  };

  LatticeComparison compare(const Element& left, const Element& right) {
    if (std::holds_alternative<LatticeState>(left.value)) {
      LatticeState leftVal = std::get<LatticeState>(left.value);
      if (std::holds_alternative<LatticeState>(right.value)) {
        LatticeState rightVal = std::get<LatticeState>(right.value);
        if (leftVal < rightVal) {
          return LatticeComparison::LESS;
        } else if (leftVal > rightVal) {
          return LatticeComparison::GREATER;
        } else {
          return LatticeComparison::EQUAL;
        }
      } else {
        return leftVal == LatticeState::TOP ? LatticeComparison::GREATER
                                            : LatticeComparison::LESS;
      }
    } else if (std::holds_alternative<LatticeState>(right.value)) {
      return std::get<LatticeState>(right.value) == LatticeState::TOP
               ? LatticeComparison::LESS
               : LatticeComparison::GREATER;
    }

    Index leftMaxBits = left.getUpperBound().value();
    Index rightMaxBits = right.getUpperBound().value();

    if (leftMaxBits < rightMaxBits) {
      return LatticeComparison::LESS;
    } else if (leftMaxBits > rightMaxBits) {
      return LatticeComparison::GREATER;
    } else {
      if (std::holds_alternative<Literal>(left.value)) {
        if (std::holds_alternative<Literal>(right.value)) {
          if (std::get<Literal>(left.value) == std::get<Literal>(right.value)) {
            return LatticeComparison::EQUAL;
          } else {
            return LatticeComparison::NO_RELATION;
          }
        } else {
          return LatticeComparison::LESS;
        }
      } else {
        if (std::holds_alternative<Literal>(right.value)) {
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
