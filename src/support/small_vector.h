#include <iostream>
/*
 * Copyright 2019 WebAssembly Community Group participants
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

//
// A vector of elements, which may be small, and uses a fixed space
// for those small elements.
//

#ifndef wasm_support_small_vector_h
#define wasm_support_small_vector_h

#include <array>
#include <vector>

namespace wasm {

template<typename T, size_t N>
struct SmallVector {
  size_t usedFixed = 0;
  std::array<T, N> fixed;

  std::vector<T> flexible;

  SmallVector() = default;

  T& operator[](size_t i) {
    if (i < N) {
      return fixed[i];
    } else {
      return flexible[i - N];
    }
  }

  T operator[](size_t i) const {
    if (i < N) {
      return fixed[i];
    } else {
      return flexible[i - N];
    }
  }

  void push_back(const T& x) {
    if (usedFixed < N) {
      fixed[usedFixed++] = x;
    } else {
      flexible.push_back(x);
    }
  }

  size_t size() const {
    return usedFixed + flexible.size();
  }

  void clear() {
    usedFixed = 0;
    flexible.clear();
  }

  bool operator==(const SmallVector<T, N>& other) const {
    if (usedFixed != other.usedFixed) return false;
    for (size_t i = 0; i < usedFixed; i++) {
      if (fixed[i] != other.fixed[i]) return false;
    }
    return flexible == other.flexible;
  }

  bool operator!=(const SmallVector<T, N>& other) const {
    return !(*this == other);
  }
};

} // namespace wasm

#endif // wasm_support_small_vector_h
