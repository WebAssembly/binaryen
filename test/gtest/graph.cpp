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

#include <vector>

#include "support/graph_traversal.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(GraphTest, Linear) {
  // 0 -> 1 -> 2
  std::vector<int> roots = {0};
  std::vector<int> order;
  auto successors = [&](const auto& push, int n) {
    order.push_back(n);
    if (n < 2) {
      push(n + 1);
    }
  };

  Graph g(roots.begin(), roots.end(), successors);
  auto visited = g.traverseDepthFirst();

  std::vector<int> expectedOrder = {0, 1, 2};
  EXPECT_EQ(order, expectedOrder);

  std::unordered_set<int> expectedVisited = {0, 1, 2};
  EXPECT_EQ(visited, expectedVisited);
}

TEST(GraphTest, Cycle) {
  // 0 -> 1 -> 0
  std::vector<int> roots = {0};
  std::vector<int> order;
  auto successors = [&](const auto& push, int n) {
    order.push_back(n);
    if (n == 0) {
      push(1);
    } else if (n == 1) {
      push(0);
    }
  };

  Graph g(roots.begin(), roots.end(), successors);
  auto visited = g.traverseDepthFirst();

  std::vector<int> expectedOrder = {0, 1};
  EXPECT_EQ(order, expectedOrder);

  std::unordered_set<int> expectedVisited = {0, 1};
  EXPECT_EQ(visited, expectedVisited);
}

TEST(GraphTest, Diamond) {
  // 0 -> 1, 2
  // 1 -> 3
  // 2 -> 3

  std::vector<int> roots = {0};
  std::vector<int> order;
  auto successors = [&](const auto& push, int n) {
    order.push_back(n);
    if (n == 0) {
      push(2);
      push(1);
    } else if (n == 1 || n == 2) {
      push(3);
    }
  };

  Graph g(roots.begin(), roots.end(), successors);
  auto visited = g.traverseDepthFirst();

  std::vector<int> expectedOrder = {0, 1, 3, 2};
  EXPECT_EQ(order, expectedOrder);

  std::unordered_set<int> expectedVisited = {0, 1, 2, 3};
  EXPECT_EQ(visited, expectedVisited);
}

TEST(GraphTest, DuplicateRoots) {
  // 0 -> 1, 2
  // 1 -> 0
  // 2 -> 0
  // 0 is added as a root 3 times

  std::vector<int> roots = {0, 0, 0};
  std::vector<int> order;
  auto successors = [&](const auto& push, int n) {
    order.push_back(n);
    if (n == 0) {
      push(2);
      push(1);
    } else if (n == 1 || n == 2) {
      push(0);
    }
  };

  Graph g(roots.begin(), roots.end(), successors);
  auto visited = g.traverseDepthFirst();

  std::vector<int> expectedOrder = {0, 1, 2, 0, 0};
  EXPECT_EQ(order, expectedOrder);

  std::unordered_set<int> expectedVisited = {0, 1, 2};
  EXPECT_EQ(visited, expectedVisited);
}

TEST(GraphTest, Disjoint) {
  // 0 -> 1
  // 2 -> 3

  std::vector<int> roots = {2, 0};
  std::vector<int> order;
  auto successors = [&](const auto& push, int n) {
    order.push_back(n);
    if (n == 0) {
      push(1);
    } else if (n == 2) {
      push(3);
    }
  };

  Graph g(roots.begin(), roots.end(), successors);
  auto visited = g.traverseDepthFirst();

  std::vector<int> expectedOrder = {0, 1, 2, 3};
  EXPECT_EQ(order, expectedOrder);

  std::unordered_set<int> expectedVisited = {0, 1, 2, 3};
  EXPECT_EQ(visited, expectedVisited);
}
