/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_analysis_lattices_bound_h
#define wasm_analysis_lattices_bound_h

#include <iostream>
#include <optional>
#include <utility>
#include <variant>

#include "analysis/lattice.h"

namespace wasm::analysis {

enum class BoundRelation { LT, LE, GE, GT };

inline std::ostream& operator<<(std::ostream& os, BoundRelation rel) {
  switch (rel) {
    case BoundRelation::LT:
      os << "<";
      break;
    case BoundRelation::LE:
      os << "<=";
      break;
    case BoundRelation::GE:
      os << ">=";
      break;
    case BoundRelation::GT:
      os << ">";
      break;
  }
  return os;
}

template<FullLattice L> struct Bound {
  struct Bot {
    bool operator==(const Bot&) const { return true; }
    bool operator!=(const Bot&) const { return false; }
  };
  struct Top {
    bool operator==(const Top&) const { return true; }
    bool operator!=(const Top&) const { return false; }
  };

  struct Constraint {
    BoundRelation rel;
    typename L::Element val;

    bool operator==(const Constraint& other) const {
      return rel == other.rel && val == other.val;
    }
    bool operator!=(const Constraint& other) const { return !(*this == other); }
  };

  using Element = std::variant<Constraint, Bot, Top>;

  L lattice;

  Bound(L&& lattice) : lattice(std::move(lattice)) {}

  Element getBottom() const noexcept { return Bot{}; }
  Element getTop() const noexcept { return Top{}; }

  Element makeBound(BoundRelation rel, typename L::Element val) const {
    auto bot_L = lattice.getBottom();
    std::optional<typename L::Element> top_L = std::nullopt;
    if constexpr (requires {
                    { lattice.getTop() } -> std::same_as<typename L::Element>;
                  }) {
      top_L = lattice.getTop();
    }

    if (rel == BoundRelation::LT && lattice.compare(val, bot_L) == EQUAL) {
      return Bot{};
    }
    if (top_L && rel == BoundRelation::GT &&
        lattice.compare(val, *top_L) == EQUAL) {
      return Bot{};
    }
    if (top_L && rel == BoundRelation::LE &&
        lattice.compare(val, *top_L) == EQUAL) {
      return Top{};
    }
    if (rel == BoundRelation::GE && lattice.compare(val, bot_L) == EQUAL) {
      return Top{};
    }

    return Constraint{rel, val};
  }

  bool implies(const Constraint& c1, const Constraint& c2) const noexcept {
    auto comp = lattice.compare(c1.val, c2.val);
    switch (c1.rel) {
      case BoundRelation::LT:
        switch (c2.rel) {
          case BoundRelation::LT:
            return comp == LESS || comp == EQUAL;
          case BoundRelation::LE:
            return comp == LESS || comp == EQUAL;
          default:
            return false;
        }
        break;
      case BoundRelation::LE:
        switch (c2.rel) {
          case BoundRelation::LE:
            return comp == LESS || comp == EQUAL;
          case BoundRelation::LT:
            return comp == LESS;
          default:
            return false;
        }
        break;
      case BoundRelation::GE:
        switch (c2.rel) {
          case BoundRelation::GE:
            return comp == GREATER || comp == EQUAL;
          case BoundRelation::GT:
            return comp == GREATER;
          default:
            return false;
        }
        break;
      case BoundRelation::GT:
        switch (c2.rel) {
          case BoundRelation::GT:
            return comp == GREATER || comp == EQUAL;
          case BoundRelation::GE:
            return comp == GREATER || comp == EQUAL;
          default:
            return false;
        }
        break;
    }
    return false;
  }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    if (std::holds_alternative<Bot>(a) && std::holds_alternative<Bot>(b))
      return EQUAL;
    if (std::holds_alternative<Bot>(a))
      return LESS;
    if (std::holds_alternative<Bot>(b))
      return GREATER;

    if (std::holds_alternative<Top>(a) && std::holds_alternative<Top>(b))
      return EQUAL;
    if (std::holds_alternative<Top>(a))
      return GREATER;
    if (std::holds_alternative<Top>(b))
      return LESS;

    const auto& c1 = std::get<Constraint>(a);
    const auto& c2 = std::get<Constraint>(b);

    bool a_implies_b = implies(c1, c2);
    bool b_implies_a = implies(c2, c1);

    if (a_implies_b && b_implies_a)
      return EQUAL;
    if (a_implies_b)
      return LESS;
    if (b_implies_a)
      return GREATER;
    return NO_RELATION;
  }

  bool join(Element& joinee, const Element& joiner) const noexcept {
    if (std::holds_alternative<Bot>(joiner))
      return false;
    if (std::holds_alternative<Bot>(joinee)) {
      joinee = joiner;
      return true;
    }
    if (std::holds_alternative<Top>(joinee))
      return false;
    if (std::holds_alternative<Top>(joiner)) {
      joinee = Top{};
      return true;
    }

    const auto& c1 = std::get<Constraint>(joinee);
    const auto& c2 = std::get<Constraint>(joiner);

    auto result = joinConstraints(c1, c2);
    if (joinee == result)
      return false;
    joinee = std::move(result);
    return true;
  }

  bool meet(Element& meetee, const Element& meeter) const noexcept {
    if (std::holds_alternative<Top>(meeter))
      return false;
    if (std::holds_alternative<Top>(meetee)) {
      meetee = meeter;
      return true;
    }
    if (std::holds_alternative<Bot>(meetee))
      return false;
    if (std::holds_alternative<Bot>(meeter)) {
      meetee = Bot{};
      return true;
    }

    const auto& c1 = std::get<Constraint>(meetee);
    const auto& c2 = std::get<Constraint>(meeter);

    auto result = meetConstraints(c1, c2);
    if (meetee == result)
      return false;
    meetee = std::move(result);
    return true;
  }

private:
  typename L::Element meet_values(const typename L::Element& a,
                                  const typename L::Element& b) const {
    auto copy = a;
    lattice.meet(copy, b);
    return copy;
  }

  Element joinConstraints(const Constraint& c1, const Constraint& c2) const {
    if (implies(c1, c2))
      return c2;
    if (implies(c2, c1))
      return c1;

    auto is_upper = [](BoundRelation r) {
      return r == BoundRelation::LT || r == BoundRelation::LE;
    };
    auto is_lower = [](BoundRelation r) {
      return r == BoundRelation::GT || r == BoundRelation::GE;
    };

    if (is_upper(c1.rel) && is_upper(c2.rel)) {
      auto joined_val = c1.val;
      lattice.join(joined_val, c2.val);
      return makeBound(BoundRelation::LT, joined_val);
    }

    if (is_lower(c1.rel) && is_lower(c2.rel)) {
      auto met = meet_values(c1.val, c2.val);
      return makeBound(BoundRelation::GT, met);
    }

    return Top{};
  }

  Element meetConstraints(const Constraint& c1, const Constraint& c2) const {
    if (implies(c1, c2))
      return c1;
    if (implies(c2, c1))
      return c2;

    if (c1.rel == c2.rel) {
      if (c1.rel == BoundRelation::LE) {
        auto met_val = meet_values(c1.val, c2.val);
        return makeBound(c1.rel, met_val);
      }
      if (c1.rel == BoundRelation::GE) {
        auto joined_val = c1.val;
        lattice.join(joined_val, c2.val);
        return makeBound(c1.rel, joined_val);
      }
    }

    return Bot{};
  }
};

template<FullLattice L>
std::ostream& operator<<(std::ostream& os,
                         const typename Bound<L>::Element& elem) {
  if (std::holds_alternative<typename Bound<L>::Bot>(elem)) {
    os << "bound bot";
  } else if (std::holds_alternative<typename Bound<L>::Top>(elem)) {
    os << "bound top";
  } else {
    const auto& c = std::get<typename Bound<L>::Constraint>(elem);
    os << "Bound(" << c.rel << " " << c.val << ")";
  }
  return os;
}

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_bound_h
