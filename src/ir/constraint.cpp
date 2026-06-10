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

#include "ir/constraint.h"

namespace wasm {

using namespace analysis;

// Defines a total order on Flat<Index>::Element that linearly extends the
// flat lattice partial order (where Bot < Index < Top, and different indices
// are unrelated).
// We order Bot < Index (ordered by index value) < Top.
std::strong_ordering orderFlatElements(const typename Flat<Index>::Element& a,
                                       const typename Flat<Index>::Element& b) {
  auto get_key = [](const typename Flat<Index>::Element& x) {
    if (x.isBottom())
      return 0u;
    if (x.isTop())
      return 2u;
    return 1u;
  };
  auto k1 = get_key(a);
  auto k2 = get_key(b);
  if (k1 != k2)
    return k1 <=> k2;
  // If both are Index, compare their uint32_t values.
  if (k1 == 1) {
    return *a.getVal() <=> *b.getVal();
  }
  return std::strong_ordering::equal;
}

// BoundedConstraintsBase::orderElements implements the total order for the
// OneOf elements.
//
// It satisfies the requirement to be a linear extension of the OneOf lattice
// partial order, and additionally orders constant bounds (index 0) before
// variable bounds (index 1) so that variable bounds are dropped first when
// the size limit N is exceeded in BoundedConjunction.
std::strong_ordering
BoundedConstraintsBase::orderElements(const typename L::Element& a,
                                      const typename L::Element& b) const {
  // If they belong to different component lattices, order constants (index 0)
  // before variables (index 1).
  if (a.index() != b.index()) {
    return a.index() <=> b.index();
  }

  // If they belong to the same component lattice, we define a total order
  // within that component that extends the component's lattice order.

  if (a.index() == 0) {
    // Bound<Int64> component.
    Bound<Int64> bound_int(Int64{});
    const auto& va = std::get<0>(a);
    const auto& vb = std::get<0>(b);

    // If they are related in the lattice, use that order.
    auto comp = bound_int.compare(va, vb);
    if (comp == LESS)
      return std::strong_ordering::less;
    if (comp == GREATER)
      return std::strong_ordering::greater;
    if (comp == EQUAL)
      return std::strong_ordering::equal;

    // If they are unrelated (e.g. x < 5 and x >= 3), we use an arbitrary
    // total order on their representation: first by relation, then by value.
    const auto& c1 = std::get<typename Bound<Int64>::Constraint>(va);
    const auto& c2 = std::get<typename Bound<Int64>::Constraint>(vb);
    if (c1.rel != c2.rel) {
      return c1.rel <=> c2.rel;
    }
    return c1.val <=> c2.val;
  }

  if (a.index() == 1) {
    // Bound<Flat<Index>> component.
    Bound<Flat<Index>> bound_flat(Flat<Index>{});
    const auto& va = std::get<1>(a);
    const auto& vb = std::get<1>(b);

    // If they are related in the lattice, use that order.
    auto comp = bound_flat.compare(va, vb);
    if (comp == LESS)
      return std::strong_ordering::less;
    if (comp == GREATER)
      return std::strong_ordering::greater;
    if (comp == EQUAL)
      return std::strong_ordering::equal;

    // If they are unrelated, compare by relation, then by the total order
    // on Flat<Index> elements.
    const auto& c1 = std::get<typename Bound<Flat<Index>>::Constraint>(va);
    const auto& c2 = std::get<typename Bound<Flat<Index>>::Constraint>(vb);
    if (c1.rel != c2.rel) {
      return c1.rel <=> c2.rel;
    }
    return orderFlatElements(c1.val, c2.val);
  }

  return std::strong_ordering::equal;
}

} // namespace wasm
