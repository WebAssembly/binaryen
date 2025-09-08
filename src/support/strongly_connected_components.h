/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_support_strongly_connected_components_h
#define wasm_support_strongly_connected_components_h

#include <cassert>
#include <optional>
#include <unordered_map>
#include <unordered_set>
#include <vector>

#include <iostream>

namespace wasm {

// A CRTP utility implementing Tarjan's Strongly Connected Component algorithm
// (https://en.wikipedia.org/wiki/Tarjan%27s_strongly_connected_components_algorithm)
// in terms of iterators. Given the beginning and end iterators over the
// elements in a graph an implementation of `pushChildren` in the CRTP subclass
// that pushes an element's children, provides an iterable over the SCCs, each
// of which is an iterable over the elements in the SCC. All implemented
// iterators are input iterators that mutate the underlying state, so this
// utility can only be used for single-pass algorithms.
template<typename It, typename Class> struct SCCs {
  SCCs(It inputIt, It inputEnd) : inputIt(inputIt), inputEnd(inputEnd) {}

private:
  using T = typename It::value_type;

  // The iterators over the graph we are calculating the SCCs for.
  It inputIt;
  It inputEnd;

  // Stack of pending elements to visit, used instead of a recursive visitor.
  struct WorkItem {
    T item;
    std::optional<T> parent = std::nullopt;
    bool processedChildren = false;
  };
  std::vector<WorkItem> workStack;

  // The Tarjan's algorithm stack. Similar to a DFS stack, but elements are only
  // popped off once they are committed to a strongly connected component.
  // Elements stay on the stack after they are visited iff they have a back edge
  // to an element earlier in the stack.
  std::vector<T> stack;

  struct ElementInfo {
    // Index assigned based on element visitation order.
    size_t index;
    // The smallest index of the elements reachable from this element.
    size_t lowlink;
    // Whether this element is still on `stack`.
    bool onStack;
  };
  std::unordered_map<T, ElementInfo> elementInfo;

  // The parent to record when calling into the subclass to push children.
  std::optional<T> currParent;

  // The root (i.e. deepest element in the stack) for the current SCC. Empty
  // whenever we have yet to find the next SCC.
  std::optional<T> currRoot;

  bool stepToNextGroup() {
    while (inputIt != inputEnd || !workStack.empty()) {
      if (workStack.empty()) {
        workStack.push_back({*inputIt++});
      }
      while (!workStack.empty()) {
        auto& work = workStack.back();
        auto& item = work.item;

        if (!work.processedChildren) {
          auto newIndex = elementInfo.size();
          auto [it, inserted] =
            elementInfo.insert({item, {newIndex, newIndex, true}});
          if (inserted) {
            // This is a new item we have never seen before. We have already
            // initialized its associated data.
            stack.push_back(item);

            // Leave the element on the work stack because we will have to do
            // more work after we have finished processing its children.
            work.processedChildren = true;
            currParent = item;
            static_cast<Class*>(this)->pushChildren(item);
            currParent = std::nullopt;
            // Process the pushed children first; we will come back to this item
            // later.
            continue;
          }

          auto& info = it->second;
          if (info.onStack) {
            assert(work.parent);
            // Item is already in the current SCC. Update the parent's lowlink
            // if this child has a smaller index than we have seen so far.
            auto& parentLowlink = elementInfo[*work.parent].lowlink;
            parentLowlink = std::min(parentLowlink, info.index);
          } else {
            // Item is in an SCC we have already processed, so ignore it
            // entirely.
          }
          // Do not recurse for this item we have seen before. We are done with
          // it.
          workStack.pop_back();
          continue;
        }

        // We have finished processing the children for the current element, so
        // we know its final lowlink value. Use it to potentially update the
        // parent's lowlink value.
        auto& info = elementInfo[item];
        if (work.parent) {
          auto& parentLowlink = elementInfo[*work.parent].lowlink;
          parentLowlink = std::min(parentLowlink, info.lowlink);
        }

        if (info.index == info.lowlink) {
          // This element reaches and is reachable by all shallower elements in
          // the stack (otherwise they would have already been popped) and does
          // not itself reach any deeper elements, so we have found an SCC and
          // the current item is its root.
          currRoot = item;
          workStack.pop_back();
          return true;
        }
        workStack.pop_back();
      }
    }
    // We are at the end.
    return false;
  }

  void stepToNextElem() {
    assert(currRoot);
    if (stack.back() == *currRoot) {
      // This was the last element in the current SCC. We have to find the next
      // SCC now.
      currRoot = std::nullopt;
    }
    elementInfo[stack.back()].onStack = false;
    stack.pop_back();
  }

  void pushChildren(const T& parent) {
    static_assert(&SCCs<It, Class>::pushChildren != &Class::pushChildren,
                  "SCCs subclass must implement `pushChildren`");
  }

protected:
  // Call this from `Class::pushChildren` to add a child.
  void push(const T& item) {
    assert(currParent);
    workStack.push_back({item, currParent});
  }

public:
  struct SCC {
    SCCs<It, Class>* parent;

    // Iterate over the elements in a strongly connected component.
    struct Iterator {
      using value_type = T;
      using difference_type = std::ptrdiff_t;
      using reference = T&;
      using pointer = T*;
      using iterator_category = std::input_iterator_tag;

      SCCs<It, Class>* parent;
      std::optional<T> val = std::nullopt;

      bool isEnd() const { return !parent || !parent->currRoot; }
      bool operator==(const Iterator& other) const {
        return isEnd() == other.isEnd();
      }
      bool operator!=(const Iterator& other) const { return !(*this == other); }
      T operator*() { return *val; }
      T* operator->() { return &*val; }
      void setVal() {
        if (isEnd()) {
          val = std::nullopt;
        } else {
          val = parent->stack.back();
        }
      }

      Iterator& operator++() {
        parent->stepToNextElem();
        setVal();
        return *this;
      }
      Iterator operator++(int) {
        auto it = *this;
        ++(*this);
        return it;
      }
    };

    Iterator begin() {
      Iterator it = {parent};
      it.setVal();
      return it;
    }
    Iterator end() { return {nullptr}; }
  };

  // Iterate over the strongly connected components of the graph.
  struct Iterator {
    using value_type = SCC;
    using difference_type = std::ptrdiff_t;
    using reference = SCC&;
    using pointer = SCC*;
    using iterator_category = std::input_iterator_tag;

    // scc.parent is null iff we are at the end.
    SCC scc;

    bool isEnd() const { return !scc.parent; }
    bool operator==(const Iterator& other) const {
      return isEnd() == other.isEnd();
    }
    bool operator!=(const Iterator& other) const { return !(*this == other); }
    SCC operator*() { return scc; }
    SCC* operator->() { return &scc; }
    Iterator& operator++() {
      // Skip the rest of the current SCC, if for some reason it was not
      // consumed.
      for (auto elem : *(*this)) {
        (void)elem;
      }
      if (!scc.parent->stepToNextGroup()) {
        // We are at the end, so mark ourselves as such.
        scc.parent = nullptr;
      }
      return *this;
    }
    void operator++(int) { ++(*this); }
  };

  Iterator begin() { return ++Iterator{this}; }
  Iterator end() { return {nullptr}; }
};

} // namespace wasm

#endif // wasm_support_strongly_connected_components_h
