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

#include <cassert>

#include "topological_orders.h"

namespace wasm {

TopologicalOrders::Selector
TopologicalOrders::Selector::select(TopologicalOrders& ctx) {
  assert(count >= 1);
  assert(start + count <= ctx.buf.size());
  auto selection = ctx.buf[start];
  // The next selector will select the next index and will not be able to choose
  // the vertex we just selected.
  Selector next = {start + 1, count - 1, 0};
  // Append any child that this selection makes available to the choices for the
  // next selector.
  for (auto child : ctx.graph[selection]) {
    assert(ctx.indegrees[child] > 0);
    if (--ctx.indegrees[child] == 0) {
      ctx.buf[next.start + next.count++] = child;
    }
  }
  return next;
}

std::optional<TopologicalOrders::Selector>
TopologicalOrders::Selector::advance(TopologicalOrders& ctx) {
  assert(count >= 1);
  // Undo the current selection. Backtrack by incrementing the in-degree for
  // each child of the vertex we are unselecting. No need to remove the newly
  // unavailable children from the buffer; they will be overwritten with valid
  // selections.
  auto unselected = ctx.buf[start];
  for (auto child : ctx.graph[unselected]) {
    ++ctx.indegrees[child];
  }
  if (index == count - 1) {
    // We are wrapping back to the original configuration. The current selection
    // element needs to go back on the end and everything else needs to be
    // shifted back to its original location. This ensures that we leave
    // everything how we found it so the previous selector can make its next
    // selection without observing anything having changed in the meantime.
    for (size_t i = 1; i < count; ++i) {
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

TopologicalOrders::TopologicalOrders(
  const std::vector<std::vector<size_t>>& graph)
  : graph(graph), indegrees(graph.size()), buf(graph.size()) {
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
  for (size_t i = 0; i < graph.size(); ++i) {
    if (indegrees[i] == 0) {
      buf[first.count++] = i;
    }
  }
  // Initialize the full stack of selectors.
  while (selectors.size() < graph.size()) {
    selectors.push_back(selectors.back().select(*this));
  }
}

TopologicalOrders& TopologicalOrders::operator++() {
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

} // namespace wasm
