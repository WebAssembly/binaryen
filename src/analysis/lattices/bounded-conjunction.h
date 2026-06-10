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

#ifndef wasm_analysis_lattices_bounded_conjunction_h
#define wasm_analysis_lattices_bounded_conjunction_h

#include <algorithm>
#include <cassert>
#include <compare>
#include <variant>
#include <vector>

#include "analysis/lattice.h"
#include "support/inplace_vector.h"

namespace wasm::analysis {

// BoundedConjunction<Subclass, L, N> represents a conjunction of up to N
// pairwise unrelated elements of the underlying lattice L.
//
// This is a semilattice (implements Lattice but not FullLattice).
//
// The elements are represented as a std::variant of wasm::inplace_vector and
// Bot. The top element (no constraints) is represented as an empty vector.
//
// Subclasses must implement:
//   std::strong_ordering orderElements(const typename L::Element&, const
//   typename L::Element&) const
//
// To maximize monotonicity of boundedMeet, the total order defined by
// orderElements must be a linear extension of the lattice partial order (i.e. x
// <_L y => x < y in total order).
//
// To enforce this and simplify subclass implementation, boundedMeet will ONLY
// call subclass.orderElements for elements that are unrelated in L. For related
// elements, the lattice order is used.
template<typename Subclass, Lattice L, std::size_t N>
struct BoundedConjunction {
  struct Bot {
    bool operator==(const Bot&) const { return true; }
    bool operator!=(const Bot&) const { return false; }
  };

  using Element = std::variant<inplace_vector<typename L::Element, N>, Bot>;

  L lattice;

  BoundedConjunction(L&& lattice) : lattice(std::move(lattice)) {
    static_assert(
      requires(const Subclass& sub,
               const typename L::Element& a,
               const typename L::Element& b) {
        { sub.orderElements(a, b) } -> std::same_as<std::strong_ordering>;
      },
      "Subclass must implement orderElements(const L::Element&, const "
      "L::Element&) -> std::strong_ordering");
  }

  Element getBottom() const noexcept {
    return Element{std::in_place_type<Bot>};
  }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    if (std::holds_alternative<Bot>(a) && std::holds_alternative<Bot>(b))
      return EQUAL;
    if (std::holds_alternative<Bot>(a))
      return LESS;
    if (std::holds_alternative<Bot>(b))
      return GREATER;

    const auto& va = std::get<inplace_vector<typename L::Element, N>>(a);
    const auto& vb = std::get<inplace_vector<typename L::Element, N>>(b);

    if (va.empty() && vb.empty())
      return EQUAL;
    if (va.empty())
      return GREATER;
    if (vb.empty())
      return LESS;

    // a <= b iff for all eb in b, there exists ea in a s.t. ea <= eb
    bool a_le_b = std::all_of(vb.begin(), vb.end(), [&](const auto& eb) {
      return std::any_of(va.begin(), va.end(), [&](const auto& ea) {
        auto comp = lattice.compare(ea, eb);
        return comp == LESS || comp == EQUAL;
      });
    });

    // b <= a iff for all ea in a, there exists eb in b s.t. eb <= ea
    bool b_le_a = std::all_of(va.begin(), va.end(), [&](const auto& ea) {
      return std::any_of(vb.begin(), vb.end(), [&](const auto& eb) {
        auto comp = lattice.compare(eb, ea);
        return comp == LESS || comp == EQUAL;
      });
    });

    if (a_le_b && b_le_a)
      return EQUAL;
    if (a_le_b)
      return LESS;
    if (b_le_a)
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

    auto& v_joinee = std::get<inplace_vector<typename L::Element, N>>(joinee);
    const auto& v_joiner =
      std::get<inplace_vector<typename L::Element, N>>(joiner);

    if (v_joinee.empty())
      return false;
    if (v_joiner.empty()) {
      v_joinee.clear();
      return true;
    }

    std::vector<typename L::Element> temp_result;
    for (const auto& ea : v_joinee) {
      for (const auto& eb : v_joiner) {
        auto joined = ea;
        lattice.join(joined, eb);
        addConstraint(temp_result, joined);
      }
    }

    if (temp_result.size() > N) {
      const auto& subclass = *static_cast<const Subclass*>(this);
      std::sort(temp_result.begin(),
                temp_result.end(),
                [&](const auto& a, const auto& b) {
                  auto comp = lattice.compare(a, b);
                  if (comp == LESS)
                    return true;
                  if (comp == GREATER)
                    return false;
                  if (comp == EQUAL)
                    return false;
                  return subclass.orderElements(a, b) ==
                         std::strong_ordering::less;
                });
      temp_result.erase(temp_result.begin() + N, temp_result.end());
    }

    inplace_vector<typename L::Element, N> result;
    for (auto& e : temp_result) {
      result.push_back(std::move(e));
    }

    if (v_joinee == result)
      return false;
    v_joinee = std::move(result);
    return true;
  }

  bool boundedMeet(Element& meetee, const Element& meeter) const noexcept {
    if (std::holds_alternative<Bot>(meetee))
      return false;
    if (std::holds_alternative<Bot>(meeter)) {
      meetee = getBottom();
      return true;
    }

    auto& v_meetee = std::get<inplace_vector<typename L::Element, N>>(meetee);
    const auto& v_meeter =
      std::get<inplace_vector<typename L::Element, N>>(meeter);

    if (v_meeter.empty())
      return false;
    if (v_meetee.empty()) {
      v_meetee = v_meeter;
      return true;
    }

    std::vector<typename L::Element> temp_result(v_meetee.begin(),
                                                 v_meetee.end());
    for (const auto& em : v_meeter) {
      if (!addConstraint(temp_result, em)) {
        meetee = getBottom();
        return true;
      }
    }

    if (temp_result.size() > N) {
      const auto& subclass = *static_cast<const Subclass*>(this);
      std::sort(temp_result.begin(),
                temp_result.end(),
                [&](const auto& a, const auto& b) {
                  auto comp = lattice.compare(a, b);
                  if (comp == LESS)
                    return true;
                  if (comp == GREATER)
                    return false;
                  if (comp == EQUAL)
                    return false;
                  return subclass.orderElements(a, b) ==
                         std::strong_ordering::less;
                });
      temp_result.erase(temp_result.begin() + N, temp_result.end());
    }

    inplace_vector<typename L::Element, N> result;
    for (auto& e : temp_result) {
      result.push_back(std::move(e));
    }

    if (v_meetee == result)
      return false;
    v_meetee = std::move(result);
    return true;
  }

private:
  // Helper to add constraint and simplify.
  // Returns false if meet results in Bottom.
  bool addConstraint(std::vector<typename L::Element>& vec,
                     const typename L::Element& e) const noexcept {
    if (lattice.compare(e, lattice.getBottom()) == EQUAL) {
      return false;
    }
    if constexpr (requires {
                    { lattice.getTop() } -> std::same_as<typename L::Element>;
                  }) {
      if (lattice.compare(e, lattice.getTop()) == EQUAL) {
        return true;
      }
    }

    bool add = true;
    for (auto it = vec.begin(); it != vec.end();) {
      auto comp = lattice.compare(e, *it);
      if (comp == EQUAL || comp == LESS) {
        it = vec.erase(it);
      } else if (comp == GREATER) {
        add = false;
        ++it;
      } else {
        ++it;
      }
    }
    if (add) {
      vec.push_back(e);
    }
    return true;
  }
};

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_bounded_conjunction_h
