/*
 * Copyright 2017 WebAssembly Community Group participants
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
// A vector of sorted elements.
//

#ifndef wasm_support_sorted_vector_h
#define wasm_support_sorted_vector_h

#include "wasm.h"
#include <vector>

namespace wasm {

struct SortedVector : public std::vector<Index> {
  SortedVector() = default;

  SortedVector merge(const SortedVector& other) const {
    SortedVector ret;
    ret.resize(size() + other.size());
    Index i = 0, j = 0, t = 0;
    while (i < size() && j < other.size()) {
      auto left = (*this)[i];
      auto right = other[j];
      if (left < right) {
        ret[t++] = left;
        i++;
      } else if (left > right) {
        ret[t++] = right;
        j++;
      } else {
        ret[t++] = left;
        i++;
        j++;
      }
    }
    while (i < size()) {
      ret[t++] = (*this)[i];
      i++;
    }
    while (j < other.size()) {
      ret[t++] = other[j];
      j++;
    }
    ret.resize(t);
    return ret;
  }

  void insert(Index x) {
    auto it = std::lower_bound(begin(), end(), x);
    if (it == end()) {
      push_back(x);
    } else if (*it > x) {
      Index i = it - begin();
      resize(size() + 1);
      std::move_backward(begin() + i, begin() + size() - 1, end());
      (*this)[i] = x;
    }
  }

  bool erase(Index x) {
    auto it = std::lower_bound(begin(), end(), x);
    if (it != end() && *it == x) {
      std::move(it + 1, end(), it);
      resize(size() - 1);
      return true;
    }
    return false;
  }

  bool has(Index x) const {
    auto it = std::lower_bound(begin(), end(), x);
    return it != end() && *it == x;
  }

  template<typename T> SortedVector& filter(T keep) {
    size_t skip = 0;
    for (size_t i = 0; i < size(); i++) {
      if (keep((*this)[i])) {
        (*this)[i - skip] = (*this)[i];
      } else {
        skip++;
      }
    }
    resize(size() - skip);
    return *this;
  }

  void verify() const {
    for (Index i = 1; i < size(); i++) {
      assert((*this)[i - 1] < (*this)[i]);
    }
  }

  void dump(const char* str = nullptr) const {
    std::cout << "SortedVector " << (str ? str : "") << ": ";
    for (auto x : *this) {
      std::cout << x << " ";
    }
    std::cout << '\n';
  }
};

} // namespace wasm

#endif // wasm_support_sorted_vector_h
