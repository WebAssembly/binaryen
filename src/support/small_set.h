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

#include <array>
#include <cassert>
#include <set>
#include <unordered_set>

#include "utilities.h"

namespace wasm {

template<typename T, size_t N, typename FlexibleSet> class SmallSetBase {
  // fixed-space storage
  size_t usedFixed = 0;
  std::array<T, N> fixed;

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
      if (usedFixed < N) {
        // Room remains in the fixed storage.
        fixed[usedFixed++] = x;
      } else {
        // No fixed storage remains. Switch to flexible.
        assert(usedFixed == N);
        assert(flexible.empty());
        flexible.insert(fixed.begin(), fixed.begin() + usedFixed);
        flexible.insert(x);
        assert(!usingFixed());
        usedFixed = 0;
      }
    } else {
      flexible.insert(x);
    }
  }

  void erase(const T& x) {
    if (usingFixed()) {
      for (size_t i = 0; i < usedFixed; i++) {
        if (fixed[i] == x) {
          // We found the item; erase it by moving the final item to replace it
          // and truncating the size.
          usedFixed--;
          fixed[i] = fixed[usedFixed];
          return;
        }
      }
    } else {
      flexible.erase(x);
    }
  }

  size_t count(const T& x) {
    if (usingFixed()) {
      // Do a linear search.
      for (size_t i = 0; i < usedFixed; i++) {
        if (fixed[i] == x) {
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
      return usedFixed;
    } else {
      return flexible.size();
    }
  }

  bool empty() const { return size() == 0; }

  void clear() {
    usedFixed = 0;
    flexible.clear();
  }

  bool operator==(const SmallSetBase<T, N, FlexibleSet>& other) const {
    if (usingFixed()) {
      if (usedFixed != other.usedFixed) {
        return false;
      }
      for (size_t i = 0; i < usedFixed; i++) {
        bool found = false;
        for (size_t j = 0; j < usedFixed; j++) {
          if (fixed[i] == other.fixed[j]) {
            found = true;
            break;
          }
        }
        if (!found) {
          return false;
        }
      }
      return true;
    }
    return flexible == other.flexible;
  }

  bool operator!=(const SmallSetBase<T, N, FlexibleSet>& other) const {
    return !(*this == other);
  }

  // iteration

  template<typename Parent, typename Iterator, typename FlexibleIterator>
  struct IteratorBase {
    using iterator_category = std::forward_iterator_tag;
    using value_type = T;
    using difference_type = long;
    using pointer = T*;
    using reference = T&;

    Parent* parent;

    // Whether we are using fixed storage in the parent. When doing so we have
    // the index in fixedIndex. Otherwise, we are using flexible storage, and we
    // will use flexibleIterator.
    bool usingFixed;
    size_t fixedIndex;
    FlexibleIterator flexibleIterator;

    IteratorBase(Parent* parent)
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

    IteratorBase<Parent, Iterator, FlexibleIterator>& operator++() {
      if (usingFixed) {
        fixedIndex++;
      } else {
        flexibleIterator++;
      }
      return *this;
    }
  };

  struct Iterator : IteratorBase<SmallSetBase<T, N, FlexibleSet>,
                                 Iterator,
                                 typename FlexibleSet::iterator> {
    Iterator(SmallSetBase<T, N, FlexibleSet>* parent)
      : IteratorBase<SmallSetBase<T, N, FlexibleSet>,
                     Iterator,
                     typename FlexibleSet::iterator>(parent) {}

    value_type operator*() const {
      if (this->usingFixed) {
        return (this->parent->fixed)[this->fixedIndex];
      } else {
        return *this->flexibleIterator;
      }
    }
  };

  struct ConstIterator : IteratorBase<const SmallSetBase<T, N, FlexibleSet>,
                                      ConstIterator,
                                      typename FlexibleSet::const_iterator> {
    ConstIterator(const SmallSetBase<T, N, FlexibleSet>* parent)
      : IteratorBase<const SmallSetBase<T, N, FlexibleSet>,
                     ConstIterator,
                     typename FlexibleSet::const_iterator>(parent) {}

    const value_type& operator*() const {
      if (this->usingFixed) {
        return (this->parent->fixed)[this->fixedIndex];
      } else {
        return *this->flexibleIterator;
      }
    }
  };

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
  ConstIterator begin() const {
    auto ret = ConstIterator(this);
    ret.setBegin();
    return ret;
  }
  ConstIterator end() const {
    auto ret = ConstIterator(this);
    ret.setEnd();
    return ret;
  }

  using iterator = Iterator;
  using const_iterator = ConstIterator;

  // Test-only method to allow unit tests to verify the right internal
  // behavior.
  bool TEST_ONLY_NEVER_USE_usingFixed() { return usingFixed(); }
};

template<typename T, size_t N>
class SmallSet : public SmallSetBase<T, N, std::set<T>> {};

template<typename T, size_t N>
class SmallUnorderedSet : public SmallSetBase<T, N, std::unordered_set<T>> {};

} // namespace wasm

#endif // wasm_support_small_set_h
