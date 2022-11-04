/*
 * Copyright 2021 WebAssembly Community Group participants
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
// A set of elements, which is often small. While the number of items is small,
// the implementation simply stores them in an array that is linearly looked
// through. Once the size is large enough, we switch to using a std::set or
// std::unordered_set.
//

#ifndef wasm_support_small_set_h
#define wasm_support_small_set_h

#include <algorithm>
#include <array>
#include <cassert>
#include <set>
#include <unordered_set>

#include "utilities.h"

namespace wasm {

template<typename T, size_t N> struct FixedStorageBase {
  size_t used = 0;
  std::array<T, N> storage;
};

template<typename T, size_t N>
struct UnorderedFixedStorage : public FixedStorageBase<T, N> {
  void insert(const T& x) {
    assert(this->used < N);
    this->storage[this->used++] = x;
  }

  void erase(const T& x) {
    for (size_t i = 0; i < this->used; i++) {
      if (this->storage[i] == x) {
        // We found the item; erase it by moving the final item to replace it
        // and truncating the size.
        this->used--;
        this->storage[i] = this->storage[this->used];
        return;
      }
    }
  }
};

template<typename T, size_t N>
struct OrderedFixedStorage : public FixedStorageBase<T, N> {
  void insert(const T& x) {
    assert(this->used < N);

    // Find the insertion point |i| where x should be placed.
    size_t i = 0;
    while (i < this->used && this->storage[i] <= x) {
      i++;
    }
    // |i| is now the location where x should be placed.

    if (i != this->used) {
      // Push things forward to make room for x.
      for (size_t j = this->used; j >= i + 1; j--) {
        this->storage[j] = this->storage[j - 1];
      }
    }

    this->storage[i] = x;
    this->used++;
  }

  void erase(const T& x) {
    for (size_t i = 0; i < this->used; i++) {
      if (this->storage[i] == x) {
        // We found the item; move things backwards and shrink.
        for (size_t j = i + 1; j < this->used; j++) {
          this->storage[j - 1] = this->storage[j];
        }
        this->used--;
        return;
      }
    }
  }
};

template<typename T, size_t N, typename FixedStorage, typename FlexibleSet>
class SmallSetBase {
  // fixed-space storage
  FixedStorage fixed;

  // flexible additional storage
  FlexibleSet flexible;

  bool usingFixed() const {
    // If the flexible storage contains something, then we are using it.
    // Otherwise we use the fixed storage. Note that if we grow and shrink then
    // we will stay in flexible mode until we reach a size of zero, at which
    // point we return to fixed mode. This is intentional, to avoid a lot of
    // movement in switching between fixed and flexible mode.
    return flexible.empty();
  }

public:
  using value_type = T;
  using key_type = T;
  using reference = T&;
  using const_reference = const T&;
  using set_type = FlexibleSet;
  using size_type = size_t;

  SmallSetBase() {}
  SmallSetBase(std::initializer_list<T> init) {
    for (T item : init) {
      insert(item);
    }
  }

  void insert(const T& x) {
    if (usingFixed()) {
      if (count(x)) {
        // The item already exists, so there is nothing to do.
        return;
      }
      // We must add a new item.
      if (fixed.used < N) {
        // Room remains in the fixed storage.
        fixed.insert(x);
      } else {
        // No fixed storage remains. Switch to flexible.
        assert(fixed.used == N);
        assert(flexible.empty());
        flexible.insert(fixed.storage.begin(),
                        fixed.storage.begin() + fixed.used);
        flexible.insert(x);
        assert(!usingFixed());
        fixed.used = 0;
      }
    } else {
      flexible.insert(x);
    }
  }

  void erase(const T& x) {
    if (usingFixed()) {
      fixed.erase(x);
    } else {
      flexible.erase(x);
    }
  }

  size_t count(const T& x) const {
    if (usingFixed()) {
      // Do a linear search.
      for (size_t i = 0; i < fixed.used; i++) {
        if (fixed.storage[i] == x) {
          return 1;
        }
      }
      return 0;
    } else {
      return flexible.count(x);
    }
  }

  size_t size() const {
    if (usingFixed()) {
      return fixed.used;
    } else {
      return flexible.size();
    }
  }

  bool empty() const { return size() == 0; }

  void clear() {
    fixed.used = 0;
    flexible.clear();
  }

  bool
  operator==(const SmallSetBase<T, N, FixedStorage, FlexibleSet>& other) const {
    if (size() != other.size()) {
      return false;
    }
    if (usingFixed()) {
      return std::all_of(fixed.storage.begin(),
                         fixed.storage.begin() + fixed.used,
                         [&other](const T& x) { return other.count(x); });
    } else if (other.usingFixed()) {
      return std::all_of(other.fixed.storage.begin(),
                         other.fixed.storage.begin() + other.fixed.used,
                         [this](const T& x) { return count(x); });
    } else {
      return flexible == other.flexible;
    }
  }

  bool
  operator!=(const SmallSetBase<T, N, FixedStorage, FlexibleSet>& other) const {
    return !(*this == other);
  }

  // iteration

  template<typename Parent, typename FlexibleIterator> struct IteratorBase {
    using iterator_category = std::forward_iterator_tag;
    using difference_type = long;
    using value_type = T;
    using pointer = const value_type*;
    using reference = const value_type&;

    const Parent* parent;

    using Iterator = IteratorBase<Parent, FlexibleIterator>;

    // Whether we are using fixed storage in the parent. When doing so we have
    // the index in fixedIndex. Otherwise, we are using flexible storage, and we
    // will use flexibleIterator.
    bool usingFixed;
    size_t fixedIndex;
    FlexibleIterator flexibleIterator;

    IteratorBase(const Parent* parent)
      : parent(parent), usingFixed(parent->usingFixed()) {}

    void setBegin() {
      if (usingFixed) {
        fixedIndex = 0;
      } else {
        flexibleIterator = parent->flexible.begin();
      }
    }

    void setEnd() {
      if (usingFixed) {
        fixedIndex = parent->size();
      } else {
        flexibleIterator = parent->flexible.end();
      }
    }

    bool operator==(const Iterator& other) const {
      if (parent != other.parent) {
        return false;
      }
      // std::set allows changes while iterating. For us here, though, it would
      // be nontrivial to support that given we have two iterators that we
      // generalize over (switching "in the middle" would not be easy or fast),
      // so error on that.
      if (usingFixed != other.usingFixed) {
        Fatal() << "SmallSet does not support changes while iterating";
      }
      if (usingFixed) {
        return fixedIndex == other.fixedIndex;
      } else {
        return flexibleIterator == other.flexibleIterator;
      }
    }

    bool operator!=(const Iterator& other) const { return !(*this == other); }

    Iterator& operator++() {
      if (usingFixed) {
        fixedIndex++;
      } else {
        flexibleIterator++;
      }
      return *this;
    }

    const value_type& operator*() const {
      if (this->usingFixed) {
        return this->parent->fixed.storage[this->fixedIndex];
      } else {
        return *this->flexibleIterator;
      }
    }
  };

  using Iterator = IteratorBase<SmallSetBase<T, N, FixedStorage, FlexibleSet>,
                                typename FlexibleSet::const_iterator>;

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

  // Test-only method to allow unit tests to verify the right internal
  // behavior.
  bool TEST_ONLY_NEVER_USE_usingFixed() { return usingFixed(); }
};

template<typename T, size_t N>
class SmallSet
  : public SmallSetBase<T, N, OrderedFixedStorage<T, N>, std::set<T>> {};

template<typename T, size_t N>
class SmallUnorderedSet : public SmallSetBase<T,
                                              N,
                                              UnorderedFixedStorage<T, N>,
                                              std::unordered_set<T>> {};

} // namespace wasm

#endif // wasm_support_small_set_h
