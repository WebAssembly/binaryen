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

#ifndef wasm_support_bitset_h
#define wasm_support_bitset_h

#include <cassert>
#include <cstddef>
#include <iterator>
#include <vector>

namespace wasm {

// Represent a set of integers in [0, N) with a bitvector of size N, where a 1
// bit signifies set membership. This interface is intended to match that of
// std::set or std::unordered_set as closely as possible.
class BitSet : std::vector<bool> {
  std::vector<bool>& vec() noexcept { return *this; }
  const std::vector<bool>& vec() const noexcept { return *this; }

  void ensure(size_t value) noexcept {
    if (vec().size() <= value) {
      vec().resize(value + 1);
    }
  }

public:
  using key_type = size_t;
  using value_type = size_t;

  class iterator {
    const std::vector<bool>* parent = nullptr;
    size_t index = 0;

    iterator(const std::vector<bool>* parent) : parent(parent) {
      const auto size = parent->size();
      while (index < size && !(*parent)[index]) {
        ++index;
      }
    }

    iterator(const std::vector<bool>* parent, size_t index)
      : parent(parent), index(index) {}

    friend BitSet;

  public:
    using difference_type = ptrdiff_t;
    using value_type = size_t;
    using pointer = size_t*;
    using reference = size_t&;
    using iterator_category = std::bidirectional_iterator_tag;

    iterator() = default;
    iterator(const iterator&) = default;
    iterator(iterator&&) = default;
    iterator& operator=(const iterator&) = default;
    iterator& operator=(iterator&&) = default;

    size_t operator*() const noexcept { return index; }

    iterator& operator++() noexcept {
      const auto size = parent->size();
      do {
        ++index;
      } while (index < size && !(*parent)[index]);
      return *this;
    }

    iterator operator++(int) noexcept {
      iterator it = *this;
      ++(*this);
      return it;
    }

    iterator& operator--() noexcept {
      do {
        --index;
        assert(index != -1ull);
      } while (!(*parent)[index]);
      return *this;
    }

    iterator operator--(int) noexcept {
      iterator it = *this;
      --(*this);
      return it;
    }

    bool operator==(const iterator& other) const noexcept {
      assert(parent == other.parent);
      return index == other.index;
    }
    bool operator!=(const iterator& other) const noexcept {
      return !(*this == other);
      assert(parent == other.parent);
      return index == other.index;
    }
  };

  BitSet() = default;
  BitSet(const BitSet&) = default;
  BitSet(BitSet&&) = default;

  template<typename It> BitSet(It begin, It end) {
    for (auto it = begin; it != end; ++it) {
      insert(*it);
    }
  }
  BitSet(const std::initializer_list<size_t>& vals)
    : BitSet(vals.begin(), vals.end()) {}

  BitSet& operator=(const BitSet&) = default;
  BitSet& operator=(BitSet&&) = default;

  iterator begin() const noexcept { return iterator({this}); }
  iterator end() const noexcept { return iterator({this, vec().size()}); }

  bool empty() const noexcept { return begin() == end(); }

  size_t size() const noexcept {
    size_t result = 0;
    for (auto it = begin(); it != end(); ++it, ++result) {
    }
    return result;
  }

  void clear() noexcept { vec().clear(); }

  std::pair<iterator, bool> insert(size_t value) noexcept {
    ensure(value);
    bool didInsert = false;
    if (!(*this)[value]) {
      didInsert = true;
      (*this)[value] = true;
    }
    return {iterator({this, value}), didInsert};
  }

  size_t erase(size_t key) noexcept {
    if (key < vec().size()) {
      return false;
    }
    bool didErase = false;
    if ((*this)[key]) {
      didErase = true;
      (*this)[key] = false;
    }
    return didErase;
  }

  iterator erase(iterator it) noexcept {
    auto next = it;
    ++next;
    (*this)[it.index] = false;
    return next;
  }

  size_t count(size_t key) const noexcept {
    if (key >= vec().size()) {
      return 0;
    }
    return (*this)[key];
  }

  bool operator==(const BitSet& other) const {
    auto thisSize = vec().size();
    auto otherSize = other.vec().size();
    const std::vector<bool>* shorter;
    const std::vector<bool>* longer;
    if (thisSize <= otherSize) {
      shorter = this;
      longer = &other;
    } else {
      shorter = &other;
      longer = this;
    }
    size_t i = 0;
    size_t shortSize = shorter->size();
    size_t longSize = longer->size();
    // All elements should match.
    for (; i < shortSize; ++i) {
      if ((*shorter)[i] != (*longer)[i]) {
        return false;
      }
    }
    // The rest of the longer vector should be zeroes.
    for (; i < longSize; ++i) {
      if ((*longer)[i]) {
        return false;
      }
    }
    return true;
  }
};

#if __cplusplus >= 202002L
static_assert(std::bidirectional_iterator<typename BitSet::iterator>);
#endif

} // namespace wasm

#endif // wasm_support_bitset_h
