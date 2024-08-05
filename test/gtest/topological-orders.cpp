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

#include "support/topological_orders.h"
#include "gtest/gtest.h"

using namespace wasm;

using Graph = std::vector<std::vector<size_t>>;

TEST(TopologicalOrdersTest, Empty) {
  Graph graph;
  TopologicalOrders orders(graph);
  EXPECT_EQ(orders.begin(), orders.end());
}

TEST(TopologicalOrdersTest, Singleton) {
  Graph graph(1);
  TopologicalOrders orders(graph);
  auto it = orders.begin();
  ASSERT_NE(it, orders.end());
  EXPECT_EQ(*it, std::vector<size_t>{0});
  ++it;
  EXPECT_EQ(it, orders.end());
}

TEST(TopologicalOrdersTest, Permutations) {
  Graph graph(3);
  TopologicalOrders orders(graph);
  std::set<std::vector<size_t>> results(orders.begin(), orders.end());
  std::set<std::vector<size_t>> expected{
    {0, 1, 2},
    {0, 2, 1},
    {1, 0, 2},
    {1, 2, 0},
    {2, 0, 1},
    {2, 1, 0},
  };
  EXPECT_EQ(results, expected);
}

TEST(TopologicalOrdersTest, Chain) {
  constexpr size_t n = 10;
  Graph graph(n);
  for (size_t i = 1; i < n; ++i) {
    graph[i].push_back(i - 1);
  }
  TopologicalOrders orders(graph);
  std::set<std::vector<size_t>> results(orders.begin(), orders.end());
  std::set<std::vector<size_t>> expected{{9, 8, 7, 6, 5, 4, 3, 2, 1, 0}};
  EXPECT_EQ(results, expected);
}

TEST(TopologicalOrdersTest, TwoChains) {
  Graph graph(4);
  graph[0].push_back(2);
  graph[1].push_back(3);
  TopologicalOrders orders(graph);
  std::set<std::vector<size_t>> results(orders.begin(), orders.end());
  std::set<std::vector<size_t>> expected{
    {0, 1, 2, 3},
    {0, 1, 3, 2},
    {0, 2, 1, 3},
    {1, 0, 2, 3},
    {1, 0, 3, 2},
    {1, 3, 0, 2},
  };
  EXPECT_EQ(results, expected);
}

TEST(TopologicalOrdersTest, Diamond) {
  Graph graph(4);
  graph[0].push_back(1);
  graph[0].push_back(2);
  graph[1].push_back(3);
  graph[2].push_back(3);
  TopologicalOrders orders(graph);
  std::set<std::vector<size_t>> results(orders.begin(), orders.end());
  std::set<std::vector<size_t>> expected{
    {0, 1, 2, 3},
    {0, 2, 1, 3},
  };
  EXPECT_EQ(results, expected);
}
