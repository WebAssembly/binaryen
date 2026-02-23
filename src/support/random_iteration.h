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

#ifndef wasm_support_random_iteration_h
#define wasm_support_random_iteration_h

#include <algorithm>
#include <cstddef>
#include <random>
#include <vector>

namespace wasm {

// Provide RandomIteration and RandomConstIteration templates, which wrap an
// arbitrary collection with an associated `iterator` or `const_iterator` type,
// respectively, and provide a randomized iteration order over it.
//
// Useful for finding and debugging determinism bugs where iteration order
// affects output. These bugs usually manifest as different output on different
// operating systems; these utilities can help them manifest between different
// executions on the same system.
template<typename T> struct RandomIteration;
template<typename T> struct RandomConstIteration;

// Implementation details.
template<typename It> struct RandomIterationBase {
  std::vector<It> iterators;

  RandomIterationBase(std::vector<It> iterators)
    : iterators(std::move(iterators)) {
    std::random_device rd;
    std::mt19937 rng(rd());
    std::shuffle(this->iterators.begin(), this->iterators.end(), rng);
  }

  struct Iterator {
    using iterator_category = std::random_access_iterator_tag;
    using difference_type = std::ptrdiff_t;
    using value_type = typename It::value_type;
    using pointer = typename It::pointer;
    using reference = typename It::reference;

    typename std::vector<It>::iterator it;

    bool operator==(const Iterator& other) const { return it == other.it; }
    bool operator!=(const Iterator& other) const { return !(*this == other); }
    reference operator*() { return **it; }
    pointer operator->() { return &**it; }
    Iterator& operator++() {
      ++it;
      return *this;
    }
    Iterator operator++(int) {
      auto it = *this;
      ++(*this);
      return it;
    }
    Iterator& operator--() {
      --it;
      return *this;
    }
    Iterator operator--(int) {
      auto it = *this;
      --(*this);
      return it;
    }
    Iterator& operator+=(difference_type n) {
      it += n;
      return *this;
    }
    Iterator operator+(difference_type n) const {
      auto it = *this;
      it += n;
      return it;
    }
    Iterator& operator-=(difference_type n) {
      it -= n;
      return *this;
    }
    Iterator operator-(difference_type n) const {
      auto it = *this;
      it -= n;
      return it;
    }
    difference_type operator-(const Iterator& other) const {
      return it - other.it;
    }
    reference operator[](difference_type n) const { return *(*this + n); }
  };

  Iterator begin() { return {iterators.begin()}; }
  Iterator end() { return {iterators.end()}; }
};

template<typename T>
struct RandomIteration : RandomIterationBase<typename T::iterator> {
  RandomIteration(T& iterable)
    : RandomIterationBase<typename T::iterator>([&]() {
        std::vector<typename T::iterator> iterators;
        for (auto it = iterable.begin(); it != iterable.end(); ++it) {
          iterators.push_back(it);
        }
        return iterators;
      }()) {}
};

template<typename T> RandomIteration(T&) -> RandomIteration<T>;

template<typename T>
struct RandomConstIteration : RandomIterationBase<typename T::const_iterator> {
  RandomConstIteration(const T& iterable)
    : RandomIterationBase<typename T::const_iterator>([&]() {
        std::vector<typename T::const_iterator> iterators;
        for (auto it = iterable.begin(); it != iterable.end(); ++it) {
          iterators.push_back(it);
        }
        return iterators;
      }()) {}
};

template<typename T> RandomConstIteration(const T&) -> RandomConstIteration<T>;

} // namespace wasm

#endif // wasm_support_random_iteration_h
