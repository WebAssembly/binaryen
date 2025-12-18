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

#ifndef wasm_analysis_lattices_bool_h
#define wasm_analysis_lattices_bool_h

#include "../lattice.h"

namespace wasm::analysis {

// A lattice with two elements: the top element is `true` and the bottom element
// is `false`.
struct Bool {
  // Use a wrapper around bool to avoid triggering bool specializations of e.g.
  // std::vector.
  struct Element {
    bool val = false;
    Element(bool val) : val(val) {}
    Element() = default;
    Element(const Element& other) = default;
    Element(Element&& other) = default;
    operator bool() const noexcept { return val; }
    bool operator==(const Element& other) const noexcept {
      return val == other.val;
    }
    bool operator==(bool other) const noexcept { return val == other; }
    bool operator!=(const Element& other) const noexcept {
      return !(*this == other);
    }
    bool operator!=(bool other) const noexcept { return !(*this == other); }
    Element& operator=(const Element& other) = default;
    Element& operator=(Element&& other) = default;
    Element& operator=(bool other) {
      val = other;
      return *this;
    }
  };
  Element getBottom() const noexcept { return false; }
  Element getTop() const noexcept { return true; }
  LatticeComparison compare(Element a, Element b) const noexcept {
    return a > b ? GREATER : a == b ? EQUAL : LESS;
  }
  bool join(Element& joinee, Element joiner) const noexcept {
    if (!joinee && joiner) {
      joinee = joiner;
      return true;
    }
    return false;
  }
  bool join(Element& joinee, bool joiner) const noexcept {
    return join(joinee, Element(joiner));
  }
  bool meet(Element& meetee, Element meeter) const noexcept {
    if (meetee && !meeter) {
      meetee = meeter;
      return true;
    }
    return false;
  }
  bool meet(Element& meetee, bool meeter) const noexcept {
    return meet(meetee, Element(meeter));
  }
};

#if __cplusplus >= 202002L
static_assert(Lattice<Bool>);
#endif // __cplusplus >= 202002L

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_bool_h
