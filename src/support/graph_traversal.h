/*
 * Copyright 2026 WebAssembly Community Group participants
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

#include <concepts>
#include <functional>
#include <iterator>
#include <unordered_set>

namespace wasm {

template<typename T, typename SuccessorFunction>
  requires std::
    invocable<SuccessorFunction, std::function<void(const T&)>&, const T&>
  class Graph {
public:
  template<std::input_iterator It, std::sentinel_for<It> Sen>
    requires std::convertible_to<std::iter_reference_t<It>, T>
  Graph(It rootsBegin, Sen rootsEnd, auto&& successors)
    : roots(rootsBegin, rootsEnd),
      successors(std::forward<decltype(successors)>(successors)) {}

  // Traverse the graph depth-first, calling `successors` exactly once for each
  // node (unless the node appears multiple times in `roots`). Return the set of
  // nodes visited.
  std::unordered_set<T> traverseDepthFirst() const {
    std::vector<T> stack(roots.begin(), roots.end());
    std::unordered_set<T> visited(roots.begin(), roots.end());

    auto maybePush = [&](const T& t) {
      if (visited.contains(t)) {
        return;
      }

      visited.insert(t);
      stack.push_back(t);
    };

    while (!stack.empty()) {
      auto curr = std::move(stack.back());
      stack.pop_back();

      successors(maybePush, curr);
    }

    return visited;
  }

private:
  std::vector<T> roots;
  SuccessorFunction successors;
};

template<std::input_iterator It,
         std::sentinel_for<It> Sen,
         typename SuccessorFunction>
Graph(It, Sen, SuccessorFunction)
  -> Graph<std::iter_value_t<It>, std::decay_t<SuccessorFunction>>;

} // namespace wasm
