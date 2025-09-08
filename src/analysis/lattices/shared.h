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
#include <utility>

#include "../lattice.h"
#include "bool.h"

namespace wasm::analysis {

// A lattice whose elements are a single ascending chain in lattice `L`.
// Internally, there is only ever a single monotonically increasing element of L
// materialized. Dereferencing any element of the SharedPath lattice will
// produce the current value of that single element of L, which is generally
// safe because the current value always overapproximates (i.e. is higher in the
// lattice than) the value at the time of the SharedPath element's construction.
//
// Each element of this lattice maintains a sequence number that corresponds to
// a value the shared underlying element has had at some point in time. Higher
// sequence numbers correspond to greater values of the underlying element.
// Elements of this lattice are compared and joined using these sequence
// numbers, so blocks will correctly be re-analyzed if the value has increased
// since the last time they were analyzed.
template<Lattice L> struct SharedPath {
  // If we ever have extremely long-running analyses, this may need to be
  // changed to uint64_t.
  using Seq = uint32_t;

  class Element {
    const typename L::Element* val;
    Seq seq = 0;

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

    friend SharedPath;
  };

  L lattice;

  // The current value that all elements point to and the current maximum
  // sequence number. The sequence numbers monotonically increase along with
  // `val` and serve to provide ordering between elements of this lattice. These
  // are mutable because they are logically not part of the lattice itself, but
  // rather of its elements. They are only stored inside the lattice because it
  // is simpler and more efficient than using shared pointers.
  mutable typename L::Element val;
  mutable Seq seq = 0;

  SharedPath(L&& l) : lattice(std::move(l)), val(lattice.getBottom()) {}

  // TODO: Delete the move constructor and the move assignment operator. This
  // requires fixing the lattice fuzzer first, since it depends on lattices
  // being moveable.

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

  template<typename Elem>
  bool join(Element& joinee, const Elem& joiner) const noexcept {
    if (lattice.join(val, joiner)) {
      // We have moved to the next value in our ascending chain. Assign it a new
      // sequence number and update joinee with that sequence number.
      joinee.seq = ++seq;
      return true;
    }
    return false;
  }
};

// Deduction guide.
template<typename L> SharedPath(L&&) -> SharedPath<L>;

#if __cplusplus >= 202002L
static_assert(Lattice<SharedPath<Bool>>);
#endif // __cplusplus >= 202002L

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_shared_h
