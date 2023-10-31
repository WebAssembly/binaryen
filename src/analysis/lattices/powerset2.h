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

#include <unordered_set>

#include "../lattice.h"
#include "support/bitset.h"

#ifndef wasm_analysis_lattices_powerset2_h
#define wasm_analysis_lattices_powerset2_h

namespace wasm::analysis {

// A powerset lattice whose elements are sets (represented concretely with type
// `Set`) ordered by subset.
template<typename Set> struct Powerset2 {
  using Element = Set;

  Element getBottom() const noexcept { return Set{}; }

  LatticeComparison compare(const Set& a, const Set& b) const noexcept {
    auto sizeA = a.size();
    auto sizeB = b.size();
    if (sizeA <= sizeB) {
      for (const auto& val : a) {
        if (!b.count(val)) {
          // At least one member differs between A and B.
          return NO_RELATION;
        }
      }
      // All elements in A were also in B.
      return sizeA == sizeB ? EQUAL : LESS;
    }
    for (const auto& val : b) {
      if (!a.count(val)) {
        // At least one member differs between A and B.
        return NO_RELATION;
      }
    }
    // A was larger and contained all the elements of B.
    return GREATER;
  }

  bool join(Set& joinee, const Set& joiner) const noexcept {
    bool result = false;
    for (const auto& val : joiner) {
      result |= joinee.insert(val).second;
    }
    return result;
  }
};

// A powerset lattice initialized with a list of all elements in the universe,
// making it possible to produce a top elements that contains all of them.
template<typename Set> struct FinitePowerset2 : Powerset2<Set> {
private:
  const Set top;

public:
  using Element = Set;

  FinitePowerset2(std::initializer_list<typename Set::value_type>&& vals)
    : top(std::move(vals)) {}

  template<typename Vals>
  FinitePowerset2(const Vals& vals) : top(vals.begin(), vals.end()) {}

  Element getTop() const noexcept { return top; }

  bool meet(Set& meetee, const Set& meeter) const noexcept {
    bool result = false;
    for (auto it = meetee.begin(); it != meetee.end();) {
      if (!meeter.count(*it)) {
        it = meetee.erase(it);
        result = true;
      } else {
        ++it;
      }
    }
    return result;
  }
};

#if __cplusplus >= 202002L
static_assert(Lattice<Powerset2<BitSet>>);
static_assert(Lattice<Powerset2<std::unordered_set<int>>>);
static_assert(FullLattice<FinitePowerset2<BitSet>>);
static_assert(FullLattice<FinitePowerset2<std::unordered_set<int>>>);
#endif

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_powerset2_h
