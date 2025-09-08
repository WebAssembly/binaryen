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

#include <cstddef>
#include <optional>
#include <vector>

#include "support/topological_sort.h"
#include "gtest/gtest.h"

using namespace wasm;

using Graph = TopologicalSort::Graph;

TEST(TopologicalSortTest, Empty) {
  Graph graph;
  TopologicalOrders orders(graph);
  EXPECT_EQ(orders.begin(), orders.end());
}

TEST(TopologicalSortTest, Singleton) {
  Graph graph(1);
  TopologicalOrders orders(graph);
  auto it = orders.begin();
  ASSERT_NE(it, orders.end());
  EXPECT_EQ(*it, std::vector<Index>{0});
  ++it;
  EXPECT_EQ(it, orders.end());
}

TEST(TopologicalSortTest, Permutations) {
  Graph graph(3);
  TopologicalOrders orders(graph);
  std::set<std::vector<Index>> results(orders.begin(), orders.end());
  std::set<std::vector<Index>> expected{
    {0, 1, 2},
    {0, 2, 1},
    {1, 0, 2},
    {1, 2, 0},
    {2, 0, 1},
    {2, 1, 0},
  };
  EXPECT_EQ(results, expected);
}

TEST(TopologicalSortTest, Chain) {
  constexpr Index n = 10;
  Graph graph(n);
  for (Index i = 1; i < n; ++i) {
    graph[i].push_back(i - 1);
  }
  TopologicalOrders orders(graph);
  std::set<std::vector<Index>> results(orders.begin(), orders.end());
  std::set<std::vector<Index>> expected{{9, 8, 7, 6, 5, 4, 3, 2, 1, 0}};
  EXPECT_EQ(results, expected);
}

TEST(TopologicalSortTest, TwoChains) {
  Graph graph(4);
  graph[0].push_back(2);
  graph[1].push_back(3);
  TopologicalOrders orders(graph);
  std::set<std::vector<Index>> results(orders.begin(), orders.end());
  std::set<std::vector<Index>> expected{
    {0, 1, 2, 3},
    {0, 1, 3, 2},
    {0, 2, 1, 3},
    {1, 0, 2, 3},
    {1, 0, 3, 2},
    {1, 3, 0, 2},
  };
  EXPECT_EQ(results, expected);
}

TEST(TopologicalSortTest, Diamond) {
  Graph graph(4);
  graph[0].push_back(1);
  graph[0].push_back(2);
  graph[1].push_back(3);
  graph[2].push_back(3);
  TopologicalOrders orders(graph);
  std::set<std::vector<Index>> results(orders.begin(), orders.end());
  std::set<std::vector<Index>> expected{
    {0, 1, 2, 3},
    {0, 2, 1, 3},
  };
  EXPECT_EQ(results, expected);
}

TEST(MinTopologicalSortTest, SortStrings) {
  std::map<std::string, std::vector<std::string>> graph{
    {"animal", {"mammal"}},
    {"cat", {}},
    {"dog", {}},
    {"mammal", {"cat", "dog"}}};
  std::vector<std::string> expected{"animal", "mammal", "cat", "dog"};
  EXPECT_EQ(TopologicalSort::sortOf(graph.begin(), graph.end()), expected);
}

TEST(MinTopologicalSortTest, EmptyMinSort) {
  Graph graph(0);
  EXPECT_EQ(TopologicalSort::minSort<>(graph), std::vector<Index>{});
}

TEST(MinTopologicalSortTest, UnconstrainedMinSort) {
  Graph graph(3);
  std::vector<Index> expected{0, 1, 2};
  EXPECT_EQ(TopologicalSort::minSort(graph), expected);
}

TEST(MinTopologicalSortTest, ReversedMinSort) {
  Graph graph(3);
  graph[2].push_back(1);
  graph[1].push_back(0);
  std::vector<Index> expected{2, 1, 0};
  EXPECT_EQ(TopologicalSort::minSort(graph), expected);
}

TEST(MinTopologicalSortTest, OneBeforeZeroMinSort) {
  Graph graph(3);
  graph[1].push_back(0);
  // 2 last because it is greater than 1 and 0
  std::vector<Index> expected{1, 0, 2};
  EXPECT_EQ(TopologicalSort::minSort(graph), expected);
}

TEST(MinTopologicalSortTest, TwoBeforeOneMinSort) {
  Graph graph(3);
  graph[2].push_back(1);
  // 0 first because it is less than 2 and 1
  std::vector<Index> expected{0, 2, 1};
  EXPECT_EQ(TopologicalSort::minSort(graph), expected);
}

TEST(MinTopologicalSortTest, TwoBeforeZeroMinSort) {
  Graph graph(3);
  graph[2].push_back(0);
  // 1 first because it is less than 2 and zero is not eligible.
  std::vector<Index> expected{1, 2, 0};
  EXPECT_EQ(TopologicalSort::minSort(graph), expected);
}
