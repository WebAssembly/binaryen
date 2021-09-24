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
// A set of elements, which is often small. While the number of items is small,
// the implementation simply stores them in an array that is linearly looked
// through. Once the size is large enough, we switch to using a std::set.
//

#ifndef wasm_support_small_set_h
#define wasm_support_small_set_h

#include <array>
#include <cassert>
#include <iterator>
#include <set>

namespace wasm {

template<typename T, size_t N> class SmallSet {
  // fixed-space storage
  size_t usedFixed = 0;
  std::array<T, N> fixed;

  // flexible additional storage
  std::set<T> flexible;

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
  using set_type = typename std::set<T>;
  using size_type = size_t;

  SmallSet() {}
  SmallSet(std::initializer_list<T> init) {
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
        for (size_t i = 0; i < usedFixed; i++) {
          flexible.insert(fixed[i]);
        }
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

  bool operator==(const SmallSet<T, N>& other) const {
    if (usingFixed()) {
      if (usedFixed != other.usedFixed) {
        return false;
      }
      for (size_t i = 0; i < usedFixed; i++) {
        if (fixed[i] != other.fixed[i]) {
          return false;
        }
      }
    }
    return flexible == other.flexible;
  }

  bool operator!=(const SmallSet<T, N>& other) const {
    return !(*this == other);
  }

  // iteration

  template<typename Parent, typename Iterator, typename FlexibleIterator>
  struct IteratorBase : public std::iterator<std::forward_iterator_tag, T> {
    typedef T value_type;
    typedef long difference_type;
    typedef T& reference;

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
      assert(usingFixed == other.usingFixed);
      if (usingFixed) {
        return fixedIndex == other.fixedIndex;
      } else {
        return flexibleIterator == other.flexibleIterator;
      }
    }

    bool operator!=(const Iterator& other) const { return !(*this == other); }

    void operator++() {
      if (usingFixed) {
        fixedIndex++;
      } else {
        flexibleIterator++;
      }
    }
  };

  struct Iterator
    : IteratorBase<SmallSet<T, N>, Iterator, typename std::set<T>::iterator> {
    typedef std::forward_iterator_tag iterator_category;

    Iterator(SmallSet<T, N>* parent)
      : IteratorBase<SmallSet<T, N>, Iterator, typename std::set<T>::iterator>(
          parent) {}

    value_type operator*() const {
      if (this->usingFixed) {
        return (this->parent->fixed)[this->fixedIndex];
      } else {
        return *this->flexibleIterator;
      }
    }
  };

  struct ConstIterator : IteratorBase<const SmallSet<T, N>,
                                      ConstIterator,
                                      typename std::set<T>::const_iterator> {
    typedef std::forward_iterator_tag iterator_category;

    ConstIterator(const SmallSet<T, N>* parent)
      : IteratorBase<const SmallSet<T, N>,
                     ConstIterator,
                     typename std::set<T>::const_iterator>(parent) {}

    const value_type operator*() const {
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
  // using reverse_iterator = typename vector_type::const_reverse_iterator;
  // using const_reverse_iterator = typename
  // vector_type::const_reverse_iterator;

  // Test-only method to allow unit tests to verify the right internal
  // behavior.
  bool TEST_ONLY_NEVER_USE_usingFixed() { return usingFixed(); }
};

} // namespace wasm

#if 0

namespace std {

template<typename T, size_t N>
struct iterator_traits<typename wasm::SmallSet<T, N>::Iterator> {
  typedef forward_iterator_tag iterator_category;
};

template<typename T, size_t N>
struct iterator_traits<typename wasm::SmallSet<T, N>::ConstIterator> {
  typedef forward_iterator_tag iterator_category;
};

}

#endif

#endif // wasm_support_small_set_h
