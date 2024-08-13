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

#include <cstddef>
#include <optional>
#include <vector>

namespace wasm {

// A utility for iterating through all possible topological orders in a graph
// using an extension of Kahn's algorithm (see
// https://en.wikipedia.org/wiki/Topological_sorting) that iteratively makes all
// possible choices for each position of the output order.
struct TopologicalOrders {
  using value_type = const std::vector<size_t>;
  using difference_type = std::ptrdiff_t;
  using reference = const std::vector<size_t>&;
  using pointer = const std::vector<size_t>*;
  using iterator_category = std::input_iterator_tag;

  // Takes an adjacency list, where the list for each vertex is a sorted list of
  // the indices of its children, which will appear after it in the order.
  TopologicalOrders(const std::vector<std::vector<size_t>>& graph);

  TopologicalOrders begin() { return TopologicalOrders(graph); }
  TopologicalOrders end() { return TopologicalOrders({}); }

  bool operator==(const TopologicalOrders& other) const {
    return selectors.empty() == other.selectors.empty();
  }
  bool operator!=(const TopologicalOrders& other) const {
    return !(*this == other);
  }
  const std::vector<size_t>& operator*() { return buf; }
  const std::vector<size_t>* operator->() { return &buf; }
  TopologicalOrders& operator++();
  TopologicalOrders operator++(int) { return ++(*this); }

private:
  // The input graph given as an adjacency list with edges from vertices to
  // their dependent children.
  const std::vector<std::vector<size_t>>& graph;
  // The current in-degrees for each vertex. When a vertex is appended to our
  // permutation, the in-degrees of its children are decremented and those that
  // go to zero become available for the next selection.
  std::vector<size_t> indegrees;
  // The buffer in which we are constructing a permutation. It contains a
  // sequence of selected vertices followed by a sequence of possible choices
  // for the next vertex.
  std::vector<size_t> buf;

  // The state for tracking the possible choices for a single vertex in the
  // output order.
  struct Selector {
    // The start index of the sequence of available choices. Also the index
    // where we place the current choice.
    size_t start;
    // The number of choices we have.
    size_t count;
    // The index of the current choice in the original order.
    size_t index;

    // Select the next available vertex, decrement in-degrees, and update the
    // sequence of available vertices. Return the Selector for the next vertex.
    Selector select(TopologicalOrders& ctx);

    // Undo the current selection, move the next selection into the first
    // position and return the new selector for the next position. Returns
    // nullopt if advancing wraps back around to the original configuration.
    std::optional<Selector> advance(TopologicalOrders& ctx);
  };

  // A stack of selectors, one for each vertex in a complete topological order.
  // Empty if we've already seen every possible ordering.
  std::vector<Selector> selectors;
};

} // namespace wasm

#endif // wasm_support_topological_orders_h
