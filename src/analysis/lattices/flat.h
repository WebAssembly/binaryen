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

#include <variant>

#if __cplusplus >= 202002L
#include <concepts>
#endif

#include "../lattice.h"
#include "support/utilities.h"

namespace wasm::analysis {

#if __cplusplus >= 202002L

template<typename T>
concept Flattenable = std::copyable<T> && std::equality_comparable<T>;

// Given a type T, Flat<T> is the lattice where none of the values of T are
// comparable except with themselves, but they are all greater than a common
// bottom element not in T and less than a common top element also not in T.
template<Flattenable T>
#else
template<typename T>
#endif
struct Flat {
private:
  struct Bot {};
  struct Top {};

public:
  struct Element : std::variant<Bot, T, Top> {
    bool isBottom() const noexcept { return std::get_if<Bot>(this); }
    bool isTop() const noexcept { return std::get_if<Top>(this); }
    const T* getVal() const noexcept { return std::get_if<T>(this); }
    T* getVal() noexcept { return std::get_if<T>(this); }
    bool operator==(const Element& other) const noexcept {
      return ((isBottom() && other.isBottom()) || (isTop() && other.isTop()) ||
              (getVal() && other.getVal() && *getVal() == *other.getVal()));
    }
    bool operator!=(const Element& other) const noexcept {
      return !(*this == other);
    }
  };

  Element getBottom() const noexcept { return Element{Bot{}}; }
  Element getTop() const noexcept { return Element{Top{}}; }
  Element get(T&& val) const noexcept { return Element{std::move(val)}; }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    if (a.index() < b.index()) {
      return LESS;
    } else if (a.index() > b.index()) {
      return GREATER;
    } else if (auto pA = a.getVal(); pA && *pA != *b.getVal()) {
      return NO_RELATION;
    } else {
      return EQUAL;
    }
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
