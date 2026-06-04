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

//
// A vector of elements with a maximum size, storing them all in-place. This is
// similar to C++26's inplace_vector, and is basically a small_vector, except
// there is never any dynamic storage.
//

#ifndef wasm_support_inplace_vector_h
#define wasm_support_inplace_vector_h

#include <array>
#include <cassert>
#include <vector>

#include "support/parent_index_iterator.h"

namespace wasm {

template<typename T, size_t N> class inplace_vector {
  // fixed-space storage
  size_t usedFixed = 0;
  std::array<T, N> fixed{};

public:
  using value_type = T;

  inplace_vector() {}
  inplace_vector(const inplace_vector<T, N>& other)
    : usedFixed(other.usedFixed), fixed(other.fixed) {
  }
  inplace_vector(inplace_vector<T, N>&& other)
    : usedFixed(other.usedFixed), fixed(std::move(other.fixed)),
      {}
  inplace_vector(std::initializer_list<T> init) {
    for (T item : init) {
      push_back(item);
    }
  }
  inplace_vector(size_t initialSize) { resize(initialSize); }

  inplace_vector<T, N>& operator=(const inplace_vector<T, N>& other) {
    usedFixed = other.usedFixed;
    fixed = other.fixed;
    return *this;
  }

  inplace_vector<T, N>& operator=(inplace_vector<T, N>&& other) {
    usedFixed = other.usedFixed;
    fixed = std::move(other.fixed);
    return *this;
  }

  T& operator[](size_t i) {
    return fixed[i];
  }

  const T& operator[](size_t i) const {
    return const_cast<inplace_vector<T, N>&>(*this)[i];
  }

  void push_back(const T& x) {
    assert(usedFixed < N);
    fixed[usedFixed++] = x;
  }

  template<typename... ArgTypes> void emplace_back(ArgTypes&&... Args) {
    assert(usedFixed < N);
    new (&fixed[usedFixed++]) T(std::forward<ArgTypes>(Args)...);
  }

  void pop_back() {
    assert(usedFixed > 0);
    usedFixed--;
  }

  T& back() {
    assert(usedFixed > 0);
    return fixed[usedFixed - 1];
  }

  const T& back() const {
    assert(usedFixed > 0);
    return fixed[usedFixed - 1];
  }

  size_t size() const { return usedFixed; }

  bool empty() const { return size() == 0; }

  void clear() {
    usedFixed = 0;
  }

  void resize(size_t newSize) {
    assert(newSize <= N);
    usedFixed = newSize;
  }

  size_t capacity() const { return N; }

  bool operator==(const inplace_vector<T, N>& other) const {
    if (usedFixed != other.usedFixed) {
      return false;
    }
    for (size_t i = 0; i < usedFixed; i++) {
      if (fixed[i] != other.fixed[i]) {
        return false;
      }
    }
    return true;
  }

  bool operator!=(const inplace_vector<T, N>& other) const {
    return !(*this == other);
  }

  // iteration

  struct Iterator : ParentIndexIterator<inplace_vector<T, N>*, Iterator> {
    using value_type = T;
    using pointer = T*;
    using reference = T&;

    Iterator(inplace_vector<T, N>* parent, size_t index)
      : ParentIndexIterator<inplace_vector<T, N>*, Iterator>{parent, index} {}
    Iterator(const Iterator& other) = default;

    T& operator*() { return (*this->parent)[this->index]; }
  };

  struct ConstIterator
    : ParentIndexIterator<const inplace_vector<T, N>*, ConstIterator> {
    using value_type = const T;
    using pointer = const T*;
    using reference = const T&;

    ConstIterator(const inplace_vector<T, N>* parent, size_t index)
      : ParentIndexIterator<const inplace_vector<T, N>*, ConstIterator>{parent,
                                                                     index} {}
    ConstIterator(const ConstIterator& other) = default;

    const T& operator*() const { return (*this->parent)[this->index]; }
  };

  Iterator begin() { return Iterator(this, 0); }
  Iterator end() { return Iterator(this, size()); }
  ConstIterator begin() const { return ConstIterator(this, 0); }
  ConstIterator end() const { return ConstIterator(this, size()); }

  void erase(Iterator a, Iterator b) {
    // Atm we only support erasing at the end, which is very efficient.
    assert(b == end());
    resize(a.index);
  }
};

// A inplace_vector for which some values may be read before they are written, and
// in that case they have the value zero.
template<typename T, size_t N>
struct ZeroInitinplace_vector : public inplace_vector<T, N> {
  T& operator[](size_t i) {
    if (i >= this->size()) {
      resize(i + 1);
    }
    return inplace_vector<T, N>::operator[](i);
  }

  const T& operator[](size_t i) const {
    return const_cast<ZeroInitinplace_vector<T, N>&>(*this)[i];
  }

  void resize(size_t newSize) {
    auto oldSize = this->size();
    inplace_vector<T, N>::resize(newSize);
    for (size_t i = oldSize; i < this->size(); i++) {
      (*this)[i] = 0;
    }
  }
};

} // namespace wasm

#endif // wasm_support_inplace_vector_h
