/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_support_parent_index_iterator_h
#define wasm_support_parent_index_iterator_h

#include <cstddef>
#include <iterator>

namespace wasm {

// A helper for defining iterators that contain references to some parent object
// and indices into that parent object. Provides operator implementations for
// equality, inequality, index updates, and index differences, but not for
// dereferencing.
//
// Users of this utility should subclass ParentIndexIterator<...> and define the
// following members in the subclass:
//
//   - using value_type = ...
//   - using pointer = ...
//   - using reference = ...
//   - reference operator*() const
//
// `Parent` is the parent type that the iterator contains and is being indexed
// into and `Iterator` is the subclass of ParentIndexIterator<...> that is being
// defined.
template<typename Parent, typename Iterator> struct ParentIndexIterator {
  using iterator_category = std::random_access_iterator_tag;
  using difference_type = std::ptrdiff_t;

  Parent parent;
  size_t index;

  const Iterator& self() const { return *static_cast<const Iterator*>(this); }

  Iterator& self() { return *static_cast<Iterator*>(this); }

  bool operator==(const ParentIndexIterator& other) const {
    return index == other.index && parent == other.parent;
  }
  bool operator!=(const ParentIndexIterator& other) const {
    return !(*this == other);
  }
  Iterator& operator++() {
    ++index;
    return self();
  }
  Iterator& operator--() {
    --index;
    return self();
  }
  Iterator operator++(int) {
    auto it = self();
    index++;
    return it;
  }
  Iterator operator--(int) {
    auto it = self();
    index--;
    return it;
  }
  Iterator& operator+=(difference_type off) {
    index += off;
    return self();
  }
  Iterator operator+(difference_type off) const {
    return Iterator(self()) += off;
  }
  Iterator& operator-=(difference_type off) {
    index -= off;
    return self();
  }
  Iterator operator-(difference_type off) const {
    return Iterator(self()) -= off;
  }
  difference_type operator-(const Iterator& other) const {
    assert(parent == other.parent);
    return index - other.index;
  }
};

} // namespace wasm

#endif // wasm_support_parent_index_iterator_h
