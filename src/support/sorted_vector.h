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

template<typename T = Index> struct SortedVector : public std::vector<T> {
  using Base = std::vector<T>;
  using Base::back;
  using Base::begin;
  using Base::clear;
  using Base::empty;
  using Base::end;
  using Base::erase;
  using Base::push_back;
  using Base::resize;
  using Base::size;

  SortedVector() = default;

  SortedVector merge(const SortedVector& other) const {
    SortedVector ret;
    ret.resize(size() + other.size());
    Index i = 0, j = 0, t = 0;
    while (i < size() && j < other.size()) {
      const auto& left = (*this)[i];
      const auto& right = other[j];
      if (left < right) {
        ret[t++] = left;
        i++;
      } else if (right < left) {
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

  T& insert(T x) {
    if (empty() || back() < x) {
      push_back(std::move(x));
      return back();
    }
    auto it = std::lower_bound(begin(), end(), x);
    if (x < *it) {
      Index i = it - begin();
      resize(size() + 1);
      std::move_backward(begin() + i, begin() + size() - 1, end());
      (*this)[i] = std::move(x);
      return (*this)[i];
    }
    return *it;
  }

  template<typename K = T> T* find(const K& x) {
    auto it = std::lower_bound(begin(), end(), x);
    if (it != end() && !(x < *it)) {
      return &*it;
    }
    return nullptr;
  }

  template<typename K = T> const T* find(const K& x) const {
    auto it = std::lower_bound(begin(), end(), x);
    if (it != end() && !(x < *it)) {
      return &*it;
    }
    return nullptr;
  }

  template<typename K = T> bool erase(const K& x) {
    auto it = std::lower_bound(begin(), end(), x);
    if (it != end() && !(x < *it)) {
      std::move(it + 1, end(), it);
      resize(size() - 1);
      return true;
    }
    return false;
  }

  template<typename K = T> bool has(const K& x) const {
    return find(x) != nullptr;
  }

  template<typename F> SortedVector& filter(F keep) {
    size_t skip = 0;
    for (size_t i = 0; i < size(); i++) {
      if (keep((*this)[i])) {
        if (skip > 0) {
          (*this)[i - skip] = std::move((*this)[i]);
        }
      } else {
        skip++;
      }
    }
    resize(size() - skip);
    return *this;
  }

  // Intersect this vector in place with |other|, keeping only elements present
  // in both for which |keep(selfElem, otherElem)| returns true.
  template<typename F> void intersect(const SortedVector& other, F keep) {
    size_t write = 0;
    size_t i = 0, j = 0;
    while (i < size() && j < other.size()) {
      if ((*this)[i] < other[j]) {
        i++;
      } else if (other[j] < (*this)[i]) {
        j++;
      } else {
        if (keep((*this)[i], other[j])) {
          if (write != i) {
            (*this)[write] = std::move((*this)[i]);
          }
          write++;
        }
        i++;
        j++;
      }
    }
    resize(write);
  }

  void verify() const {
    for (Index i = 1; i < size(); i++) {
      assert((*this)[i - 1] < (*this)[i]);
    }
  }

  void dump(const char* str = nullptr) const {
    std::cout << "SortedVector " << (str ? str : "") << ": ";
    for (const auto& x : *this) {
      std::cout << x << " ";
    }
    std::cout << '\n';
  }
};

} // namespace wasm

#endif // wasm_support_sorted_vector_h
