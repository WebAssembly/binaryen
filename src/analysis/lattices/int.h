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

#ifndef wasm_analysis_lattices_int_h
#define wasm_analysis_lattices_int_h

#include <cstdint>
#include <limits>

#include "../lattice.h"

namespace wasm::analysis {

// The lattice of integers of the given type `T`, ordered by <. The min integer
// is the bottom element and the max integer is the top element.
#if __cplusplus >= 202002L
template<std::integral T>
#else
template<typename T>
#endif
struct Integer {
  using Element = T;
  Element getBottom() const noexcept { return std::numeric_limits<T>::min(); }
  Element getTop() const noexcept { return std::numeric_limits<T>::max(); }
  LatticeComparison compare(Element a, Element b) const noexcept {
    return a > b ? GREATER : a == b ? EQUAL : LESS;
  }
  bool join(Element& joinee, Element joiner) const noexcept {
    if (joinee < joiner) {
      joinee = joiner;
      return true;
    }
    return false;
  }
  bool meet(Element& meetee, Element meeter) const noexcept {
    if (meetee > meeter) {
      meetee = meeter;
      return true;
    }
    return false;
  }
};

using Int32 = Integer<int32_t>;
using UInt32 = Integer<uint32_t>;
using Int64 = Integer<int64_t>;
using UInt64 = Integer<uint64_t>;

#if __cplusplus >= 202002L
static_assert(FullLattice<Int32>);
static_assert(FullLattice<Int64>);
static_assert(FullLattice<UInt32>);
static_assert(FullLattice<UInt64>);
#endif // __cplusplus >= 202002L

} // namespace wasm::analysis

#endif // wasm_analysis_lattices_int_h
