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

#ifndef wasm_analysis_lattices_tuple_h
#define wasm_analysis_lattices_tuple_h

#include <tuple>
#include <utility>

#include "bool.h"
#include "support/utilities.h"

namespace wasm::analysis {

template<Lattice... Ls> struct Tuple {
  using Element = std::tuple<typename Ls::Element...>;

  std::tuple<Ls...> lattices;

  Tuple(Ls&&... lattices) : lattices({std::move(lattices)...}) {}

private:
  template<size_t... I>
  Element getBottomImpl(std::index_sequence<I...>) const noexcept {
    return {std::get<I>(lattices).getBottom()...};
  }

  template<size_t... I>
  Element getTopImpl(std::index_sequence<I...>) const noexcept {
    return {std::get<I>(lattices).getTop()...};
  }

  LatticeComparison compareImpl(const Element& a,
                                const Element& b,
                                LatticeComparison result,
                                std::index_sequence<>) const noexcept {
    // Base case: there is nothing left to compare.
    return result;
  }

  template<size_t I, size_t... Is>
  LatticeComparison compareImpl(const Element& a,
                                const Element& b,
                                LatticeComparison result,
                                std::index_sequence<I, Is...>) const noexcept {
    // Recursive case: compare the current elements, update `result`, and
    // recurse to the next elements if necessary.
    switch (std::get<I>(lattices).compare(std::get<I>(a), std::get<I>(b))) {
      case EQUAL:
        return compareImpl(a, b, result, std::index_sequence<Is...>{});
      case LESS:
        if (result == GREATER) {
          // Cannot be both less and greater.
          return NO_RELATION;
        }
        return compareImpl(a, b, LESS, std::index_sequence<Is...>{});
      case GREATER:
        if (result == LESS) {
          // Cannot be both greater and less.
          return NO_RELATION;
        }
        return compareImpl(a, b, GREATER, std::index_sequence<Is...>{});
      case NO_RELATION:
        return NO_RELATION;
    }
    WASM_UNREACHABLE("unexpected comparison");
  }

  int joinImpl(Element& joinee,
               const Element& joiner,
               std::index_sequence<>) const noexcept {
    // Base case: there is nothing left to join.
    return false;
  }

  template<size_t I, size_t... Is>
  int joinImpl(Element& joinee,
               const Element& joiner,
               std::index_sequence<I, Is...>) const noexcept {
    // Recursive case: join the current element and recurse to the next
    // elements.
    return std::get<I>(lattices).join(std::get<I>(joinee),
                                      std::get<I>(joiner)) |
           joinImpl(joinee, joiner, std::index_sequence<Is...>{});
  }

  int meetImpl(Element& meetee,
               const Element& meeter,
               std::index_sequence<>) const noexcept {
    // Base case: there is nothing left to mee.
    return false;
  }

  template<size_t I, size_t... Is>
  int meetImpl(Element& meetee,
               const Element& meeter,
               std::index_sequence<I, Is...>) const noexcept {
    // Recursive case: meet the current element and recurse to the next
    // elements.
    return (std::get<I>(lattices).meet(std::get<I>(meetee),
                                       std::get<I>(meeter))) |
           meetImpl(meetee, meeter, std::index_sequence<Is...>{});
  }

public:
  Element getBottom() const noexcept {
    return getBottomImpl(std::index_sequence_for<Ls...>());
  }

  Element getTop() const noexcept {
    return getTopImpl(std::index_sequence_for<Ls...>());
  }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    return compareImpl(a, b, EQUAL, std::index_sequence_for<Ls...>());
  }

  bool join(Element& joinee, const Element& joiner) const noexcept {
    return joinImpl(joinee, joiner, std::index_sequence_for<Ls...>());
  }

  bool meet(Element& meetee, const Element& meeter) const noexcept {
    return meetImpl(meetee, meeter, std::index_sequence_for<Ls...>());
  }
};

#if __cplusplus >= 202002L
static_assert(FullLattice<Tuple<>>);
static_assert(FullLattice<Tuple<Bool>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_tuple_h
