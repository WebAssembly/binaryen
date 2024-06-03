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

// We don't understand this warning, only here and only on aarch64 and riscv64,
// we suspect it's spurious so disabling for now.
//
// For context: https://github.com/WebAssembly/binaryen/issues/6311

#if defined(__aarch64__)
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"
#endif

// https://github.com/WebAssembly/binaryen/issues/6410
#if defined(__riscv) && __riscv_xlen == 64
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wuninitialized"
#endif

template<typename T, size_t N> class SmallVector {
  // fixed-space storage
  size_t usedFixed = 0;
  std::array<T, N> fixed;

  // flexible additional storage
  std::vector<T> flexible;

#if defined(__aarch64__)
#pragma GCC diagnostic pop
#endif

#if defined(__riscv) && __riscv_xlen == 64
#pragma GCC diagnostic pop
#endif

public:
  using value_type = T;

  SmallVector() {}
  SmallVector(std::initializer_list<T> init) {
    for (T item : init) {
      push_back(item);
    }
  }
  SmallVector(size_t initialSize) { resize(initialSize); }

  T& operator[](size_t i) {
    if (i < N) {
      return fixed[i];
    } else {
      return flexible[i - N];
    }
  }

  const T& operator[](size_t i) const {
    return const_cast<SmallVector<T, N>&>(*this)[i];
  }

  void push_back(const T& x) {
    if (usedFixed < N) {
      fixed[usedFixed++] = x;
    } else {
      flexible.push_back(x);
    }
  }

  template<typename... ArgTypes> void emplace_back(ArgTypes&&... Args) {
    if (usedFixed < N) {
      new (&fixed[usedFixed++]) T(std::forward<ArgTypes>(Args)...);
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

  size_t size() const { return usedFixed + flexible.size(); }

  bool empty() const { return size() == 0; }

  void clear() {
    usedFixed = 0;
    flexible.clear();
  }

  void resize(size_t newSize) {
    usedFixed = std::min(N, newSize);
    if (newSize > N) {
      flexible.resize(newSize - N);
    } else {
      flexible.clear();
    }
  }

  void reserve(size_t reservedSize) {
    if (reservedSize > N) {
      flexible.reserve(reservedSize - N);
    }
  }

  size_t capacity() const { return N + flexible.capacity(); }

  bool operator==(const SmallVector<T, N>& other) const {
    if (usedFixed != other.usedFixed) {
      return false;
    }
    for (size_t i = 0; i < usedFixed; i++) {
      if (fixed[i] != other.fixed[i]) {
        return false;
      }
    }
    return flexible == other.flexible;
  }

  bool operator!=(const SmallVector<T, N>& other) const {
    return !(*this == other);
  }

  // iteration

  template<typename Parent, typename Iterator> struct IteratorBase {
    // TODO: Add remaining things from
    //       https://en.cppreference.com/w/cpp/named_req/RandomAccessIterator
    using iterator_category = std::random_access_iterator_tag;
    using value_type = T;
    using difference_type = long;
    using reference = T&;
    using pointer = T*;

    Parent* parent;
    size_t index;

    IteratorBase(Parent* parent, size_t index) : parent(parent), index(index) {}

    bool operator!=(const Iterator& other) const {
      return index != other.index || parent != other.parent;
    }

    Iterator& operator++() {
      Iterator& self = *static_cast<Iterator*>(this);
      index++;
      return self;
    }
    Iterator operator++(int) {
      Iterator self = *static_cast<Iterator*>(this);
      index++;
      return self;
    }

    Iterator& operator+=(difference_type off) {
      index += off;
      return *this;
    }

    const Iterator operator+(difference_type off) const {
      return Iterator(*this) += off;
    }

    difference_type operator-(const Iterator& other) const {
      return index - other.index;
    }

    bool operator==(const Iterator& other) const {
      return parent == other.parent && index == other.index;
    }
  };

  struct Iterator : IteratorBase<SmallVector<T, N>, Iterator> {
    Iterator(SmallVector<T, N>* parent, size_t index)
      : IteratorBase<SmallVector<T, N>, Iterator>(parent, index) {}
    value_type& operator*() { return (*this->parent)[this->index]; }
  };

  struct ConstIterator : IteratorBase<const SmallVector<T, N>, ConstIterator> {
    ConstIterator(const SmallVector<T, N>* parent, size_t index)
      : IteratorBase<const SmallVector<T, N>, ConstIterator>(parent, index) {}
    const value_type& operator*() const { return (*this->parent)[this->index]; }
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

// A SmallVector for which some values may be read before they are written, and
// in that case they have the value zero.
template<typename T, size_t N>
struct ZeroInitSmallVector : public SmallVector<T, N> {
  T& operator[](size_t i) {
    if (i >= this->size()) {
      resize(i + 1);
    }
    return SmallVector<T, N>::operator[](i);
  }

  const T& operator[](size_t i) const {
    return const_cast<ZeroInitSmallVector<T, N>&>(*this)[i];
  }

  void resize(size_t newSize) {
    auto oldSize = this->size();
    SmallVector<T, N>::resize(newSize);
    for (size_t i = oldSize; i < this->size(); i++) {
      (*this)[i] = 0;
    }
  }
};

} // namespace wasm

#endif // wasm_support_small_vector_h
