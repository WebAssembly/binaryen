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

#ifndef wasm_analysis_lattices_shared_h
#define wasm_analysis_lattices_shared_h

#include <cstdint>

#include "../lattice.h"
#include "bool.h"

namespace wasm::analysis {

// A lattice whose elements are a single ascending chain in lattice `L`.
// Internally, there is only ever a single monotonically increasing element of L
// materialized. Dereferencing any element of the Shared lattice will produce
// the current value of that single element of L, which is generally safe
// because the current value always overapproximates the value at the time of
// the Shared element's construction.
template<Lattice L> struct Shared {
  class Element {
    const typename L::Element* val;
    uint32_t seq = 0;

    Element(const typename L::Element* val) : val(val) {}

  public:
    Element() = default;
    Element(const Element&) = default;
    Element(Element&&) = default;
    Element& operator=(const Element&) = default;
    Element& operator=(Element&&) = default;

    // Only provide const references to the value to force all updates to go
    // through our API.
    const typename L::Element& operator*() const noexcept { return *val; }
    const typename L::Element* operator->() const noexcept { return val; }

    bool operator==(const Element& other) const noexcept {
      assert(val == other.val);
      return seq == other.seq;
    }

    bool operator!=(const Element& other) const noexcept {
      return !(*this == other);
    }

    friend Shared;
  };

  L lattice;

  // The current value that all elements point to and the current maximum
  // sequence number. The sequence numbers monotonically increase along with
  // `val` and serve to provide ordering between elements of this lattice.
  mutable typename L::Element val;
  mutable uint32_t seq = 0;

  Shared(L&& l) : lattice(std::move(l)), val(lattice.getBottom()) {}

  Element getBottom() const noexcept { return Element{&val}; }

  LatticeComparison compare(const Element& a, const Element& b) const noexcept {
    assert(a.val == b.val);
    return a.seq < b.seq ? LESS : a.seq == b.seq ? EQUAL : GREATER;
  }

  bool join(Element& joinee, const Element& joiner) const noexcept {
    assert(joinee.val == joiner.val);
    if (joinee.seq < joiner.seq) {
      joinee.seq = joiner.seq;
      return true;
    }
    return false;
  }

  bool join(Element& joinee, const typename L::Element& joiner) const noexcept {
    if (lattice.join(val, joiner)) {
      // We have moved to the next value in our ascending chain. Assign it a new
      // sequence number and update joinee with that sequence number.
      joinee.seq = ++seq;
      return true;
    }
    return false;
  }
};

#if __cplusplus >= 202002L
static_assert(Lattice<Shared<Bool>>);
#endif // __cplusplus >= 202002L

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_shared_h
