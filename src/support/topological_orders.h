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

#ifndef wasm_support_topological_orders_h
#define wasm_support_topological_orders_h

#include <algorithm>
#include <cassert>
#include <cstddef>
#include <functional>
#include <optional>
#include <type_traits>
#include <unordered_map>
#include <variant>
#include <vector>

#include "support/index.h"

namespace wasm {

namespace TopologicalSort {

// An adjacency list containing edges from vertices to their successors. Uses
// `Index` because we are primarily sorting elements of Wasm modules. If we ever
// need to sort signficantly larger objects, we might need to switch to
// `size_t` or make this a template parameter.
using Graph = std::vector<std::vector<Index>>;

// Return a topological sort of the vertices in the given adjacency graph.
inline std::vector<Index> sort(const Graph& graph);

// A utility that finds a topological sort of a graph with arbitrary element
// types. The provided iterators must be to pairs of elements and collections of
// their children.
template<typename It> decltype(auto) sortOf(It begin, It end) {
  using T = std::remove_cv_t<typename It::value_type::first_type>;
  std::unordered_map<T, Index> indices;
  std::vector<T> elements;
  // Assign indices to each element.
  for (auto it = begin; it != end; ++it) {
    auto inserted = indices.insert({it->first, elements.size()});
    assert(inserted.second && "unexpected repeat element");
    elements.push_back(inserted.first->first);
  }
  // Collect the graph in terms of indices.
  Graph indexGraph;
  indexGraph.reserve(elements.size());
  for (auto it = begin; it != end; ++it) {
    indexGraph.emplace_back();
    for (const auto& child : it->second) {
      indexGraph.back().push_back(indices.at(child));
    }
  }
  // Compute the topological order and convert back to original elements.
  std::vector<T> order;
  order.reserve(elements.size());
  for (auto i : sort(indexGraph)) {
    order.emplace_back(std::move(elements[i]));
  }
  return order;
}

// Return the topological sort of the vertices in the given adjacency graph that
// is lexicographically minimal with respect to the provided comparator on
// vertex indices. Implemented using a min-heap internally.
template<typename F = std::less<Index>>
std::vector<Index> minSort(const Graph& graph, F cmp = std::less<Index>{});

} // namespace TopologicalSort

template<typename F = std::monostate> struct TopologicalOrdersImpl;

// A utility for iterating through all possible topological orders in a graph
// using an extension of Kahn's algorithm (see
// https://en.wikipedia.org/wiki/Topological_sorting) that iteratively makes all
// possible choices for each position of the output order.
using TopologicalOrders = TopologicalOrdersImpl<std::monostate>;

// The template parameter `Cmp` is only used as in internal implementation
// detail of `minSort`.
template<typename Cmp> struct TopologicalOrdersImpl {
  using Graph = TopologicalSort::Graph;
  using value_type = const std::vector<Index>;
  using difference_type = std::ptrdiff_t;
  using reference = const std::vector<Index>&;
  using pointer = const std::vector<Index>*;
  using iterator_category = std::input_iterator_tag;

  // Takes an adjacency list, where the list for each vertex is a sorted list of
  // the indices of its children, which will appear after it in the order.
  TopologicalOrdersImpl(const Graph& graph)
    : TopologicalOrdersImpl(graph, {}) {}

  TopologicalOrdersImpl begin() { return TopologicalOrdersImpl(graph); }
  TopologicalOrdersImpl end() { return TopologicalOrdersImpl({}); }

  bool operator==(const TopologicalOrdersImpl& other) const {
    return selectors.empty() == other.selectors.empty();
  }
  bool operator!=(const TopologicalOrdersImpl& other) const {
    return !(*this == other);
  }
  const std::vector<Index>& operator*() const { return buf; }
  const std::vector<Index>* operator->() const { return &buf; }
  TopologicalOrdersImpl& operator++() {
    // Find the last selector that can be advanced, popping any that cannot.
    std::optional<Selector> next;
    while (!selectors.empty() && !(next = selectors.back().advance(*this))) {
      selectors.pop_back();
    }
    if (!next) {
      // No selector could be advanced, so we've seen every possible ordering.
      assert(selectors.empty());
      return *this;
    }
    // We've advanced the last selector on the stack, so initialize the
    // subsequent selectors.
    assert(selectors.size() < graph.size());
    selectors.push_back(*next);
    while (selectors.size() < graph.size()) {
      selectors.push_back(selectors.back().select(*this));
    }

    return *this;
  }
  TopologicalOrdersImpl operator++(int) { return ++(*this); }

private:
  TopologicalOrdersImpl(const Graph& graph, Cmp cmp)
    : graph(graph), indegrees(graph.size()), buf(graph.size()), cmp(cmp) {
    if (graph.size() == 0) {
      return;
    }
    // Find the in-degree of each vertex.
    for (const auto& vertex : graph) {
      for (auto child : vertex) {
        ++indegrees[child];
      }
    }
    // Set up the first selector with its possible selections.
    selectors.reserve(graph.size());
    selectors.push_back({0, 0, 0});
    auto& first = selectors.back();
    for (Index i = 0; i < graph.size(); ++i) {
      if (indegrees[i] == 0) {
        if constexpr (useMinHeap) {
          pushChoice(i);
        } else {
          buf[first.count] = i;
        }
        ++first.count;
      }
    }
    // Initialize the full stack of selectors.
    while (selectors.size() < graph.size()) {
      selectors.push_back(selectors.back().select(*this));
    }
    selectors.back().select(*this);
  }

  // The input graph given as an adjacency list with edges from vertices to
  // their dependent children.
  const Graph& graph;
  // The current in-degrees for each vertex. When a vertex is appended to our
  // permutation, the in-degrees of its children are decremented and those that
  // go to zero become available for the next selection.
  std::vector<Index> indegrees;
  // The buffer in which we are constructing a permutation. It contains a
  // sequence of selected vertices followed by a sequence of possible choices
  // for the next vertex.
  std::vector<Index> buf;
  // When we are finding a minimal topological order, store the possible
  // choices in this separate min-heap instead of directly in `buf`.
  std::vector<Index> choiceHeap;
  // When we are finding a minimal topological order, use this function to
  // compare possible choices. Empty iff we are not finding a minimal
  // topological order.
  Cmp cmp;

  static constexpr bool useMinHeap = !std::is_same_v<Cmp, std::monostate>;

  // The state for tracking the possible choices for a single vertex in the
  // output order.
  struct Selector {
    // The start index of the sequence of available choices. Also the index
    // where we place the current choice.
    Index start;
    // The number of choices we have.
    Index count;
    // The index of the current choice in the original order.
    Index index;

    // Select the next available vertex, decrement in-degrees, and update the
    // sequence of available vertices. Return the Selector for the next vertex.
    Selector select(TopologicalOrdersImpl& ctx) {
      assert(count >= 1);
      assert(start + count <= ctx.buf.size());
      if constexpr (TopologicalOrdersImpl::useMinHeap) {
        ctx.buf[start] = ctx.popChoice();
      }
      auto selection = ctx.buf[start];
      // The next selector will select the next index and will not be able to
      // choose the vertex we just selected.
      Selector next = {start + 1, count - 1, 0};
      // Append any child that this selection makes available to the choices for
      // the next selector.
      for (auto child : ctx.graph[selection]) {
        assert(ctx.indegrees[child] > 0);
        if (--ctx.indegrees[child] == 0) {
          if constexpr (TopologicalOrdersImpl::useMinHeap) {
            ctx.pushChoice(child);
          } else {
            ctx.buf[next.start + next.count] = child;
          }
          ++next.count;
        }
      }
      return next;
    }

    // Undo the current selection, move the next selection into the first
    // position and return the new selector for the next position. Returns
    // nullopt if advancing wraps back around to the original configuration.
    std::optional<Selector> advance(TopologicalOrdersImpl& ctx) {
      assert(count >= 1);
      // Undo the current selection. Backtrack by incrementing the in-degree for
      // each child of the vertex we are unselecting. No need to remove the
      // newly unavailable children from the buffer; they will be overwritten
      // with valid selections.
      auto unselected = ctx.buf[start];
      for (auto child : ctx.graph[unselected]) {
        ++ctx.indegrees[child];
      }
      if (index == count - 1) {
        // We are wrapping back to the original configuration. The current
        // selection element needs to go back on the end and everything else
        // needs to be shifted back to its original location. This ensures that
        // we leave everything how we found it so the previous selector can make
        // its next selection without observing anything having changed in the
        // meantime.
        for (Index i = 1; i < count; ++i) {
          ctx.buf[start + i - 1] = ctx.buf[start + i];
        }
        ctx.buf[start + count - 1] = unselected;
        return std::nullopt;
      }
      // Otherwise, just swap the next selection into the first position and
      // finalize the selection.
      std::swap(ctx.buf[start], ctx.buf[start + ++index]);
      return select(ctx);
    }
  };

  void pushChoice(Index choice) {
    choiceHeap.push_back(choice);
    std::push_heap(choiceHeap.begin(), choiceHeap.end(), [&](Index a, Index b) {
      return cmp(b, a);
    });
  }
  Index popChoice() {
    std::pop_heap(choiceHeap.begin(), choiceHeap.end(), [&](Index a, Index b) {
      return cmp(b, a);
    });
    auto choice = choiceHeap.back();
    choiceHeap.pop_back();
    return choice;
  }

  // A stack of selectors, one for each vertex in a complete topological order.
  // Empty if we've already seen every possible ordering.
  std::vector<Selector> selectors;

  friend std::vector<Index> TopologicalSort::minSort<Cmp>(const Graph&, Cmp);
};

namespace TopologicalSort {

std::vector<Index> sort(const Graph& graph) {
  return *TopologicalOrders(graph);
}

template<typename Cmp> std::vector<Index> minSort(const Graph& graph, Cmp cmp) {
  return *TopologicalOrdersImpl<Cmp>(graph, cmp);
}

} // namespace TopologicalSort

} // namespace wasm

#endif // wasm_support_topological_orders_h
