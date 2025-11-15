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

#ifndef wasm_analysis_lattices_flat_h
#define wasm_analysis_lattices_flat_h

#include <tuple>
#include <type_traits>
#include <variant>

#if __cplusplus >= 202002L
#include <concepts>
#endif

#include "analysis/lattice.h"
#include "support/utilities.h"

namespace wasm::analysis {

#if __cplusplus >= 202002L

template<typename T>
concept Flattenable = std::copyable<T> && std::equality_comparable<T>;

// Given types Ts..., Flat<T...> is the lattice where none of the values of any
// T are comparable except with themselves, but they are all greater than a
// common bottom element and less than a common top element.
template<Flattenable T, Flattenable... Ts>
#else
template<typename T, typename... Ts>
#endif
struct Flat {
private:
  struct Bot : std::monostate {};
  struct Top : std::monostate {};

  template<std::size_t I>
  using TI = std::tuple_element_t<I, std::tuple<T, Ts...>>;

public:
  struct Element : std::variant<T, Ts..., Bot, Top> {
    bool isBottom() const noexcept { return std::get_if<Bot>(this); }
    bool isTop() const noexcept { return std::get_if<Top>(this); }
    template<typename U = T> const U* getVal() const noexcept {
      return std::get_if<U>(this);
    }
    template<typename U = T> U* getVal() noexcept {
      return std::get_if<U>(this);
    }
    template<std::size_t I> const TI<I>* getVal() const noexcept {
      return std::get_if<I>(this);
    }
    template<std::size_t I> TI<I>* getVal() noexcept {
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

  Element getBottom() const noexcept { return Element{Bot{}}; }
  Element getTop() const noexcept { return Element{Top{}}; }
  template<typename U> Element get(U&& val) const noexcept {
    return Element{std::move(val)};
  }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    if (a == b) {
      return EQUAL;
    }
    if (a.isTop() || b.isBottom()) {
      return GREATER;
    }
    if (a.isBottom() || b.isTop()) {
      return LESS;
    }
    return NO_RELATION;
  }

  bool join(Element& joinee, const Element& joiner) const noexcept {
    switch (compare(joinee, joiner)) {
      case LESS:
        joinee = joiner;
        return true;
      case NO_RELATION:
        joinee = Element{Top{}};
        return true;
      case GREATER:
      case EQUAL:
        return false;
    }
    WASM_UNREACHABLE("unexpected comparison result");
  }
};

#if __cplusplus >= 202002L
static_assert(Lattice<Flat<int>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_flat_h
