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
#include <cassert>
#include <iterator>
#include <vector>

namespace wasm {

template<typename T, size_t N>
class SmallVector {
  // fixed-space storage
  size_t usedFixed = 0;
  std::array<T, N> fixed;

  // flexible additional storage
  std::vector<T> flexible;

public:
  SmallVector() {}

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

  template <typename... ArgTypes>
  void emplace_back(ArgTypes &&... Args) {
    if (usedFixed < N) {
      new(&fixed[usedFixed++]) T(std::forward<ArgTypes>(Args)...);
    } else {
      flexible.emplace_back(std::forward<ArgTypes>(Args)...);
    }
  }

  void pop_back() {
    if (flexible.empty()) {
      assert(usedFixed > 0);
      usedFixed--;
    } else {
      flexible.pop_back();
    }
  }

  T& back() {
    if (flexible.empty()) {
      assert(usedFixed > 0);
      return fixed[usedFixed - 1];
    } else {
      return flexible.back();
    }
  }

  const T& back() const {
    if (flexible.empty()) {
      assert(usedFixed > 0);
      return fixed[usedFixed - 1];
    } else {
      return flexible.back();
    }
  }

  size_t size() const {
    return usedFixed + flexible.size();
  }

  bool empty() const {
    return size() == 0;
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

  // iteration

  struct Iterator {
    typedef T value_type;
    typedef long difference_type;
    typedef T& reference;

    const SmallVector<T, N>* parent;
    size_t index;

    Iterator(const SmallVector<T, N>* parent, size_t index) : parent(parent), index(index) {}

    bool operator!=(const Iterator& other) const {
      return index != other.index || parent != other.parent;
    }

    void operator++() {
      index++;
    }

    Iterator& operator+=(difference_type off) {
      index += off;
      return *this;
    }

    const Iterator operator+(difference_type off) const {
      return Iterator(*this) += off;
    }

    const value_type operator*() const {
      return (*parent)[index];
    }
  };

  Iterator begin() const {
    return Iterator(static_cast<const SmallVector<T, N>*>(this), 0);
  }
  Iterator end() const {
    return Iterator(static_cast<const SmallVector<T, N>*>(this), size());
  }
};

} // namespace wasm

#endif // wasm_support_small_vector_h
