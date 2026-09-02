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

#ifndef wasm_analysis_lattices_one_of_h
#define wasm_analysis_lattices_one_of_h

#include <array>
#include <tuple>
#include <type_traits>
#include <variant>

#if __has_include(<concepts>)
#include <concepts>
#endif

#include "analysis/lattice.h"
#include "support/utilities.h"

namespace wasm::analysis {

// Elements of this lattice are elements of "one of" an arbitrary number of
// component lattices, or top or bottom. The elements are represented with a
// std::variant. Join and meet operations between elements of different
// component lattices produce top and bottom values, respectively. Join and meet
// between elements of the same component lattice return the result of the join
// or meet operation of that component lattice.
#if defined(__cpp_lib_concepts)
template<Lattice... Ls>
#else
template<typename... Ls>
#endif
struct OneOf {
private:
  struct Bot : std::monostate {};
  struct Top : std::monostate {};

  template<std::size_t I> using L = std::tuple_element_t<I, std::tuple<Ls...>>;

public:
  template<std::size_t I> using EI = typename L<I>::Element;

  struct Element : std::variant<typename Ls::Element..., Bot, Top> {
    using std::variant<typename Ls::Element..., Bot, Top>::variant;
    bool isBottom() const noexcept {
      return std::holds_alternative<Bot>(*this);
    }
    bool isTop() const noexcept { return std::holds_alternative<Top>(*this); }

    template<typename U> const U* getVal() const noexcept {
      return std::get_if<U>(this);
    }
    template<typename U> U* getVal() noexcept { return std::get_if<U>(this); }
    template<std::size_t I> const EI<I>* getVal() const noexcept {
      return std::get_if<I>(this);
    }
    template<std::size_t I> EI<I>* getVal() noexcept {
      return std::get_if<I>(this);
    }

    bool operator==(const Element& other) const noexcept {
      return this->index() == other.index() &&
             std::visit(
               [](const auto& a, const auto& b) {
                 if constexpr (std::is_same_v<decltype(a), decltype(b)>) {
                   return a == b;
                 }
                 return false;
               },
               *this,
               other);
    }
    bool operator!=(const Element& other) const noexcept {
      return !(*this == other);
    }
  };

  std::tuple<Ls...> lattices;

  OneOf(Ls&&... lattices) : lattices({std::move(lattices)...}) {}
  OneOf() = default;

  Element getBottom() const noexcept {
    return Element{std::in_place_type<Bot>};
  }
  Element getTop() const noexcept { return Element{std::in_place_type<Top>}; }

  template<std::size_t I> Element get(EI<I>&& val) const noexcept {
    return Element(std::in_place_index<I>, std::move(val));
  }

  template<std::size_t I> Element get(const EI<I>& val) const noexcept {
    return Element(std::in_place_index<I>, val);
  }

private:
  static constexpr std::size_t BotIndex = sizeof...(Ls);
  static constexpr std::size_t TopIndex = sizeof...(Ls) + 1;

  template<std::size_t... I>
  static constexpr auto makeCompareFuncs(std::index_sequence<I...>) noexcept {
    using F = LatticeComparison (*)(
      const std::tuple<Ls...>&, const Element&, const Element&);
    return std::array<F, sizeof...(I)>{
      [](const std::tuple<Ls...>& lattices,
         const Element& a,
         const Element& b) -> LatticeComparison {
        return std::get<I>(lattices).compare(std::get<I>(a), std::get<I>(b));
      }...};
  }
  static constexpr auto compareFuncs() noexcept {
    return makeCompareFuncs(std::make_index_sequence<sizeof...(Ls)>{});
  }

  template<std::size_t... I>
  static constexpr auto makeJoinFuncs(std::index_sequence<I...>) noexcept {
    using F = bool (*)(const std::tuple<Ls...>&, Element&, const Element&);
    return std::array<F, sizeof...(I)>{[](const std::tuple<Ls...>& lattices,
                                          Element& joinee,
                                          const Element& joiner) -> bool {
      return std::get<I>(lattices).join(std::get<I>(joinee),
                                        std::get<I>(joiner));
    }...};
  }
  static constexpr auto joinFuncs() noexcept {
    return makeJoinFuncs(std::make_index_sequence<sizeof...(Ls)>{});
  }

  template<std::size_t... I>
  static constexpr auto makeMeetFuncs(std::index_sequence<I...>) noexcept {
    using F = bool (*)(const std::tuple<Ls...>&, Element&, const Element&);
    return std::array<F, sizeof...(I)>{[](const std::tuple<Ls...>& lattices,
                                          Element& meetee,
                                          const Element& meeter) -> bool {
      return std::get<I>(lattices).meet(std::get<I>(meetee),
                                        std::get<I>(meeter));
    }...};
  }
  static constexpr auto meetFuncs() noexcept {
    return makeMeetFuncs(std::make_index_sequence<sizeof...(Ls)>{});
  }

public:
  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    if (a.index() == BotIndex && b.index() == BotIndex) {
      return EQUAL;
    }
    if (a.index() == BotIndex) {
      return LESS;
    }
    if (b.index() == BotIndex) {
      return GREATER;
    }

    if (a.index() == TopIndex && b.index() == TopIndex) {
      return EQUAL;
    }
    if (a.index() == TopIndex) {
      return GREATER;
    }
    if (b.index() == TopIndex) {
      return LESS;
    }

    if (a.index() != b.index()) {
      return NO_RELATION;
    }

    return compareFuncs()[a.index()](lattices, a, b);
  }

  bool join(Element& joinee, const Element& joiner) const noexcept {
    if (joiner.index() == BotIndex) {
      return false;
    }
    if (joinee.index() == BotIndex) {
      joinee = joiner;
      return true;
    }
    if (joinee.index() == TopIndex) {
      return false;
    }
    if (joiner.index() == TopIndex) {
      joinee = Element(std::in_place_type<Top>);
      return true;
    }
    if (joinee.index() != joiner.index()) {
      joinee = Element(std::in_place_type<Top>);
      return true;
    }
    return joinFuncs()[joinee.index()](lattices, joinee, joiner);
  }

  bool meet(Element& meetee, const Element& meeter) const noexcept {
    if (meeter.index() == TopIndex) {
      return false;
    }
    if (meetee.index() == TopIndex) {
      meetee = meeter;
      return true;
    }
    if (meetee.index() == BotIndex) {
      return false;
    }
    if (meeter.index() == BotIndex) {
      meetee = Element(std::in_place_type<Bot>);
      return true;
    }
    if (meetee.index() != meeter.index()) {
      meetee = Element(std::in_place_type<Bot>);
      return true;
    }
    return meetFuncs()[meetee.index()](lattices, meetee, meeter);
  }
};

#if defined(__cpp_lib_concepts)
static_assert(FullLattice<OneOf<Bool, Bool>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_one_of_h
