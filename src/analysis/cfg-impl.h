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

#ifndef wasm_analysis_cfg_impl_h
#define wasm_analysis_cfg_impl_h

#include "cfg.h"

namespace wasm::analysis {

// An iterator over a sequence of contiguous pointers (represented as a pointer
// to a pointer in the sequence) that dereferences the pointed-to pointer.
// TODO: Move this to its own public header if there is ever another use for it.
template<typename T> struct _indirect_ptr_iterator {
  using iterator_category = std::random_access_iterator_tag;
  using value_type = T;
  using different_type = off_t;
  using reference = const T&;
  using pointer = const T*;

  const T* const* ptr;

  const T& operator*() const { return **ptr; }

  const T& operator[](int n) const { return **(ptr + n); }

  _indirect_ptr_iterator& operator+=(int n) {
    ptr += n;
    return *this;
  }

  _indirect_ptr_iterator& operator-=(int n) {
    ptr -= n;
    return *this;
  }

  _indirect_ptr_iterator& operator++() { return *this += 1; }

  _indirect_ptr_iterator operator++(int) {
    _indirect_ptr_iterator it = *this;
    ++(*this);
    return it;
  }

  _indirect_ptr_iterator& operator--() { return *this -= 1; }

  _indirect_ptr_iterator operator--(int) {
    _indirect_ptr_iterator it = *this;
    --(*this);
    return it;
  }

  _indirect_ptr_iterator operator+(int n) const {
    _indirect_ptr_iterator it = *this;
    it += n;
    return it;
  }

  _indirect_ptr_iterator operator-(int n) const {
    _indirect_ptr_iterator it = *this;
    it -= n;
    return it;
  }

  bool operator==(const _indirect_ptr_iterator& other) const {
    return ptr == other.ptr;
  }

  bool operator!=(const _indirect_ptr_iterator& other) const {
    return !(*this == other);
  }

  bool operator<(const _indirect_ptr_iterator& other) const {
    return ptr < other.ptr;
  }

  bool operator>(const _indirect_ptr_iterator& other) const {
    return ptr > other.ptr;
  }

  bool operator<=(const _indirect_ptr_iterator& other) const {
    return ptr <= other.ptr;
  }

  bool operator>=(const _indirect_ptr_iterator& other) const {
    return ptr >= other.ptr;
  }
};

template<typename T>
_indirect_ptr_iterator<T> operator+(int n,
                                    const _indirect_ptr_iterator<T>& it) {
  return it + n;
}

// Wraps a vector of pointers and provides dereferencing iterators for it.
template<typename T> struct _indirect_ptr_vec {
  using iterator = _indirect_ptr_iterator<T>;

  const std::vector<T*>& vec;

  _indirect_ptr_vec(const std::vector<T*>& vec) : vec(vec) {}

  iterator begin() const { return {&vec.data()[0]}; }
  iterator end() const { return {&vec.data()[vec.size()]}; }
};

struct BasicBlock::BasicBlockIterable : _indirect_ptr_vec<BasicBlock> {
  BasicBlockIterable(const std::vector<BasicBlock*>& blocks)
    : _indirect_ptr_vec(blocks) {}
};

inline BasicBlock::BasicBlockIterable BasicBlock::preds() const {
  return BasicBlockIterable(predecessors);
}

inline BasicBlock::BasicBlockIterable BasicBlock::succs() const {
  return BasicBlockIterable(successors);
}

} // namespace wasm::analysis

#endif // wasm_analysis_cfg_impl_h
