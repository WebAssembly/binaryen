/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include <array>
#include <tuple>
#include <utility>
#include <variant>

#include "../lattice.h"
#include "support/utilities.h"

#if __cplusplus >= 202002L
#include "analysis/lattices/bool.h"
#endif

#ifndef wasm_analysis_lattices_abstraction_h
#define wasm_analysis_lattices_abstraction_h

namespace wasm::analysis {

// CRTP lattice composed of increasingly abstract sub-lattices. The subclass is
// responsible for providing two method templates. The first abstracts an
// element of one sub-lattice into an element of the next sub-lattice:
//
//   template<size_t I, typename E1, typename E2>
//   E2 abstract(const E1&) const
//
// The template method should be specialized for each sub-lattice index I, its
// element type E1, and the next element type E2.
//
// The `abstract` method is used to abstract elements of the more specific
// lattice whenever elements from different lattices are compared or joined. It
// may also be used to abstract two joined elements from the same lattice when
// those elements are unrelated and the second method returns true:
//
//   template<size_t I, typename E>
//   bool shouldAbstract(const E&. const E&) const
//
// shouldAbstract is only queried for unrelated elements. Related elements of
// the same sub-lattice are always joined as normal.
//
// `abstract` should be monotonic. Making its input more general should either
// not change its output or make its output more general.
//
// `shouldAbstract` should return true only when no upper bound of its arguments
// in their original sub-lattice is used. If such an upper bound is used in a
// comparison or join, the operation may fail to uphold the properties of a
// lattice.
template<typename Self, typename... Ls> struct Abstraction {
  using Element = std::variant<typename Ls::Element...>;

  std::tuple<Ls...> lattices;

  Abstraction(Ls&&... lattices) : lattices({std::move(lattices)...}) {}

  Element getBottom() const noexcept {
    return std::get<0>(lattices).getBottom();
  }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    if (a.index() < b.index()) {
      auto abstractedA = a;
      abstractToIndex(abstractedA, b.index());
      switch (compares()[b.index()](lattices, abstractedA, b)) {
        case EQUAL:
        case LESS:
          return LESS;
        case NO_RELATION:
        case GREATER:
          return NO_RELATION;
      }
      WASM_UNREACHABLE("unexpected comparison");
    }
    if (a.index() > b.index()) {
      auto abstractedB = b;
      abstractToIndex(abstractedB, a.index());
      switch (compares()[a.index()](lattices, a, abstractedB)) {
        case EQUAL:
        case GREATER:
          return GREATER;
        case NO_RELATION:
        case LESS:
          return NO_RELATION;
      }
      WASM_UNREACHABLE("unexpected comparison");
    }
    return compares()[a.index()](lattices, a, b);
  }

  bool join(Element& joinee, const Element& _joiner) const noexcept {
    Element joiner = _joiner;
    bool changed = false;
    if (joinee.index() < joiner.index()) {
      abstractToIndex(joinee, joiner.index());
      changed = true;
    } else if (joinee.index() > joiner.index()) {
      abstractToIndex(joiner, joinee.index());
    }
    while (true) {
      assert(joinee.index() == joiner.index());
      if (joiner.index() == sizeof...(Ls) - 1) {
        // Cannot abstract further, so we must join no matter what.
        break;
      }
      switch (compares()[joiner.index()](lattices, joinee, joiner)) {
        case NO_RELATION:
          if (shouldAbstracts()[joiner.index()](self(), joinee, joiner)) {
            // Try abstracting further.
            joinee = abstracts()[joinee.index()](self(), joinee);
            joiner = abstracts()[joiner.index()](self(), joiner);
            changed = true;
            continue;
          }
          break;
        case EQUAL:
        case LESS:
        case GREATER:
          break;
      }
      break;
    }
    return joins()[joiner.index()](lattices, joinee, joiner) || changed;
  }

private:
  const Self& self() const noexcept { return *static_cast<const Self*>(this); }

  // TODO: Use C++26 pack indexing.
  template<std::size_t I> using L = std::tuple_element_t<I, std::tuple<Ls...>>;

  // Compute tables of functions that forward operations to the CRTP subtype or
  // the lattices. These tables map the dynamic variant indices to compile-time
  // lattice indices.

  template<std::size_t... I>
  static constexpr auto makeAbstracts(std::index_sequence<I...>) noexcept {
    using F = Element (*)(const Self&, const Element& elem);
    return std::array<F, sizeof...(I)>{
      [](const Self& self, const Element& elem) -> Element {
        if constexpr (I < sizeof...(Ls) - 1) {
          using E1 = typename L<I>::Element;
          using E2 = typename L<I + 1>::Element;
          return Element(std::in_place_index_t<I + 1>{},
                         self.template abstract<I, E1, E2>(std::get<I>(elem)));
        } else {
          WASM_UNREACHABLE("unexpected abstraction");
        }
      }...};
  }
  static constexpr auto abstracts() noexcept {
    return makeAbstracts(std::make_index_sequence<sizeof...(Ls)>{});
  }

  void abstractToIndex(Element& elem, std::size_t index) const noexcept {
    while (elem.index() < index) {
      elem = abstracts()[elem.index()](self(), elem);
    }
  }

  template<std::size_t... I>
  static constexpr auto
  makeShouldAbstracts(std::index_sequence<I...>) noexcept {
    using F = bool (*)(const Self&, const Element&, const Element&);
    return std::array<F, sizeof...(I)>{
      [](const Self& self, const Element& a, const Element& b) -> bool {
        if constexpr (I < sizeof...(Ls) - 1) {
          return self.template shouldAbstract<I>(std::get<I>(a),
                                                 std::get<I>(b));
        } else {
          WASM_UNREACHABLE("unexpected abstraction check");
        }
      }...};
  }
  static constexpr auto shouldAbstracts() noexcept {
    return makeShouldAbstracts(std::make_index_sequence<sizeof...(Ls)>{});
  }

  template<std::size_t... I>
  static constexpr auto makeCompares(std::index_sequence<I...>) noexcept {
    using F = LatticeComparison (*)(
      const std::tuple<Ls...>&, const Element&, const Element&);
    return std::array<F, sizeof...(I)>{
      [](const std::tuple<Ls...>& lattices,
         const Element& a,
         const Element& b) -> LatticeComparison {
        return std::get<I>(lattices).compare(std::get<I>(a), std::get<I>(b));
      }...};
  }
  static constexpr auto compares() noexcept {
    return makeCompares(std::make_index_sequence<sizeof...(Ls)>{});
  }

  template<std::size_t... I>
  static constexpr auto makeJoins(std::index_sequence<I...>) noexcept {
    using F = bool (*)(const std::tuple<Ls...>&, Element&, const Element&);
    return std::array<F, sizeof...(I)>{[](const std::tuple<Ls...>& lattices,
                                          Element& joinee,
                                          const Element& joiner) {
      return std::get<I>(lattices).join(std::get<I>(joinee),
                                        std::get<I>(joiner));
    }...};
  }
  static constexpr auto joins() noexcept {
    return makeJoins(std::make_index_sequence<sizeof...(Ls)>{});
  }
};

#if __cplusplus >= 202002L
static_assert(Lattice<Abstraction<Bool, Bool, Bool>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_abstraction_h
