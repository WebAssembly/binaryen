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

#ifndef wasm_support_topological_sort_h
#define wasm_support_topological_sort_h

#include <cstddef>
#include <iterator>
#include <unordered_set>
#include <vector>

namespace wasm {

// CRTP utility that provides an iterator through arbitrary directed acyclic
// graphs of data that will visit the data in a topologically sorted order
// (https://en.wikipedia.org/wiki/Topological_sorting). In other words, the
// iterator will produce each item only after all that item's predecessors have
// been produced.
//
// Subclasses should call `push` on all the root items in their constructors and
// implement a `void pushPredecessors(T item)` method that calls `push` on all
// the immediate predecessors of `item`.
//
// Cycles in the graph are not detected and will result in an infinite loop.
template<typename T, typename Subtype> struct TopologicalSort {
private:
  // The DFS work list.
  std::vector<T> workStack;

  // Remember which items we have finished so we don't visit them again.
  std::unordered_set<T> finished;

  // Should be overridden by `Subtype`.
  void pushPredecessors(T item) {
    static_assert(&TopologicalSort<T, Subtype>::pushPredecessors !=
                    &Subtype::pushPredecessors,
                  "TopologicalSort subclass must implement `pushPredecessors`");
  }

  // Pop until the stack is empty or it has an unfinished item on top.
  void finishCurr() {
    finished.insert(workStack.back());
    workStack.pop_back();
    while (!workStack.empty() && finished.count(workStack.back())) {
      workStack.pop_back();
    }
  }

  // Advance until the next item to be finished is on top of the stack or the
  // stack is empty.
  void stepToNext() {
    while (!workStack.empty()) {
      T item = workStack.back();
      static_cast<Subtype*>(this)->pushPredecessors(item);
      if (workStack.back() == item) {
        // No unfinished predecessors, so this is the next item in the sort.
        break;
      }
    }
  }

protected:
  // Call this from the `Subtype` constructor to add the root items and from
  // `Subtype::pushPredecessors` to add predecessors.
  void push(T item) {
    if (finished.count(item)) {
      return;
    }
    workStack.push_back(item);
  }

public:
  struct Iterator {
    using value_type = T;
    using difference_type = std::ptrdiff_t;
    using reference = T&;
    using pointer = T*;
    using iterator_category = std::input_iterator_tag;

    TopologicalSort<T, Subtype>* parent;

    bool isEnd() const { return !parent || parent->workStack.empty(); }
    bool operator==(Iterator& other) const { return isEnd() == other.isEnd(); }
    bool operator!=(Iterator& other) const { return !(*this == other); }
    T operator*() { return parent->workStack.back(); }
    void operator++(int) {
      parent->finishCurr();
      parent->stepToNext();
    }
    Iterator& operator++() {
      (*this)++;
      return *this;
    }
  };

  Iterator begin() {
    stepToNext();
    return {this};
  }
  Iterator end() { return {nullptr}; }
};

} // namespace wasm

#endif // wasm_support_topological_sort_h
