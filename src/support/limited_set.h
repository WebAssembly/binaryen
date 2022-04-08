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

//
// A set of elements, which is often small, and has a *limit*. When the limit is
// reached, the set is "full". When the set is full, we consider it to be in an
// "infinitely full" state:
//
//  * Checking for the presence of an item always returns true, as if the set
//    contains everything.
//  * We cannot iterate on the
// items, as the point of the "full" state is to avoid increasing the size any
// more. We can add more items to a full set, but doing so does nothing as it is
// not observable (aside from the size() not increasing any more). We also
// cannot remove items from a full set (since we do not track them) so that is a
// no-op as well.
//
// A limit (N) of 3 means that at size 3 the set becomes full and no longer
// iterable, so it is a set that works on sizes 0, 1, and 2 normally.
//

#ifndef wasm_support_limited_set_h
#define wasm_support_limited_set_h

#include <algorithm>
#include <array>
#include <cassert>
#include <set>
#include <unordered_set>

#include "small_set.h"
#include "utilities.h"

namespace wasm {

template<typename T, size_t N> class LimitedSet {
  // Fixed-space storage. |used| is the amount of space used; when it is
  // equal to N then the set is in full mode.
  size_t used = 0;
  std::array<T, N - 1> storage;

public:
  bool isFull() const {
    assert(used <= N);
    return used == N;
  }

public:
  using value_type = T;
  using key_type = T;
  using reference = T&;
  using const_reference = const T&;
  //using set_type = FlexibleSet;
  using size_type = size_t;

  LimitedSet() {}
  LimitedSet(std::initializer_list<T> init) {
    for (T item : init) {
      insert(item);
    }
  }

  void insert(const T& x) {
    if (isFull()) {
      // The set is already full; nothing more can be added.
      return;
    }
    if (count(x)) {
      // The item already exists, so there is nothing to do.
      return;
    }
    // We must add a new item.
    if (used == N - 1) {
      // The set is now full.
      used = N;
      assert(isFull());
      return;
    }
    // Append the new item.
    storage[used++] = x;
  }

  void erase(const T& x) {
    if (isFull()) {
      // The set is already full; nothing can be removed, as if it were
      // infinitely large.
      return;
    }
    for (size_t i = 0; i < used; i++) {
      if (storage[i] == x) {
        // We found the item; erase it by moving the final item to replace it
        // and truncating the size.
        used--;
        storage[i] = storage[used];
        return;
      }
    }
  }

  size_t count(const T& x) const {
    if (isFull()) {
      // A full set is "infinitely full" and contains everything.
      return true;
    }
    // Do a linear search.
    for (size_t i = 0; i < used; i++) {
      if (storage[i] == x) {
        return 1;
      }
    }
    return 0;
  }

  size_t size() const {
    return used;
  }

  bool empty() const { return size() == 0; }

  void clear() {
    used = 0;
  }

  bool operator==(const LimitedSet<T, N>& other) const {
    if (size() != other.size()) {
      return false;
    }
    if (isFull() && other.isFull()) {
      return true;
    }
    // The sets are of equal size and they are not full, so compare the items.
    return std::all_of(storage.begin(),
                       storage.begin() + used,
                       [&other](const T& x) { return other.count(x); });
  }

  bool operator!=(const LimitedSet<T, N>& other) const {
    return !(*this == other);
  }

  // iteration

  template<typename Parent> struct IteratorBase {
    using iterator_category = std::forward_iterator_tag;
    using difference_type = long;
    using value_type = T;
    using pointer = const value_type*;
    using reference = const value_type&;

    Parent* parent;

    using Iterator = IteratorBase<Parent>;

    size_t index;

    IteratorBase(Parent* parent)
      : parent(parent) {}

    void setBegin() {
      assert(!parent.isFull());
      index = 0;
    }

    void setEnd() {
      assert(!parent.isFull());
      index = parent->size();
    }

    bool operator==(const Iterator& other) const {
      if (parent != other.parent) {
        return false;
      }
      return index == other.index;
    }

    bool operator!=(const Iterator& other) const { return !(*this == other); }

    Iterator& operator++() {
      index++;
      return *this;
    }

    const value_type& operator*() const {
      return (this->parent->storage)[this->index];
    }
  };

  using Iterator = IteratorBase<LimitedSet<T, N>>;

  Iterator begin() {
    auto ret = Iterator(this);
    ret.setBegin();
    return ret;
  }
  Iterator end() {
    auto ret = Iterator(this);
    ret.setEnd();
    return ret;
  }
  Iterator begin() const {
    auto ret = Iterator(this);
    ret.setBegin();
    return ret;
  }
  Iterator end() const {
    auto ret = Iterator(this);
    ret.setEnd();
    return ret;
  }

  using iterator = Iterator;
  using const_iterator = Iterator;
};

} // namespace wasm

#endif // wasm_support_limited_set_h
