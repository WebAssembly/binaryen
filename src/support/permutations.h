/*
 * Copyright 2016 WebAssembly Community Group participants
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

// Utilities for operating on permutation vectors

#ifndef wasm_support_permutations_h
#define wasm_support_permutations_h

#include "wasm.h"

namespace wasm {

inline std::vector<Index> makeIdentity(Index num) {
  std::vector<Index> ret;
  ret.resize(num);
  for (Index i = 0; i < num; i++) {
    ret[i] = i;
  }
  return ret;
}

inline void setIdentity(std::vector<Index>& ret) {
  auto num = ret.size();
  assert(num > 0); // must already be of the right size
  for (Index i = 0; i < num; i++) {
    ret[i] = i;
  }
}

inline std::vector<Index> makeReversed(std::vector<Index>& original) {
  std::vector<Index> ret;
  auto num = original.size();
  ret.resize(num);
  for (Index i = 0; i < num; i++) {
    ret[original[i]] = i;
  }
  return ret;
}

// Return a list of all permutations.
inline std::vector<std::vector<Index>> makeAllPermutations(Index size) {
  std::vector<std::vector<Index>> ret;
  std::vector<Index> curr;
  curr.resize(size);
  for (auto& x : curr) x = 0;
  while (1) {
    std::set<Index> set;
    for (auto x : curr) set.insert(x);
    if (set.size() == size) {
      ret.push_back(curr); // this is indeed a permutation
    }
    // advance to the next permutation in order
    Index toBump = size - 1;
    while (1) {
      curr[toBump]++;
      if (curr[toBump] < size) break;
      // an overflow
      if (toBump == 0) return ret; // all done
      curr[toBump] = 0;
      toBump--;
    }
  }
}

} // namespace wasm

#endif // permutations
