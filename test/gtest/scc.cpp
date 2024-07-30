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

#include <vector>

#include "support/strongly_connected_components.h"
#include "gtest/gtest.h"

using namespace wasm;

struct IntIt {
  using value_type = unsigned;
  using difference_type = std::ptrdiff_t;
  using reference = unsigned&;
  using pointer = unsigned*;
  using iterator_category = std::input_iterator_tag;

  unsigned i = 0;

  bool operator==(const IntIt& other) const { return i == other.i; }
  bool operator!=(const IntIt& other) const { return !(*this == other); }
  unsigned operator*() { return i; }
  IntIt& operator++() {
    ++i;
    return *this;
  }
  IntIt operator++(int) {
    IntIt it = *this;
    ++(*this);
    return it;
  }
};

struct Graph {
  std::vector<std::set<unsigned>> graph;

  explicit Graph(unsigned size) : graph(size) {}

  void addEdge(unsigned from, unsigned to) {
    assert(from < graph.size());
    assert(to < graph.size());
    graph[from].insert(to);
  }

  const std::set<unsigned>& children(unsigned parent) const {
    return graph[parent];
  }

  IntIt begin() const { return {}; }
  IntIt end() const { return {unsigned(graph.size())}; }
};

struct GraphSCCs : SCCs<IntIt, GraphSCCs> {
  const Graph& graph;
  GraphSCCs(const Graph& graph)
    : SCCs<IntIt, GraphSCCs>(graph.begin(), graph.end()), graph(graph) {}

  void pushChildren(unsigned parent) {
    for (auto child : graph.children(parent)) {
      push(child);
    }
  }
};

using SCCSet = std::set<std::set<unsigned>>;

SCCSet getSCCs(const Graph& graph) {
  SCCSet set;
  for (auto scc : GraphSCCs(graph)) {
    set.emplace(scc.begin(), scc.end());
  }
  return set;
}

TEST(SCCTest, Empty) {
  Graph graph(0);
  GraphSCCs sccs(graph);
  auto it = sccs.begin();
  EXPECT_EQ(it, sccs.end());

  EXPECT_EQ(getSCCs(graph), SCCSet{});
}

TEST(SCCTest, Singleton) {
  Graph graph(1);
  GraphSCCs sccs(graph);

  auto it = sccs.begin();
  ASSERT_NE(it, sccs.end());

  auto scc = *it;
  auto sccIt = scc.begin();
  ASSERT_NE(sccIt, scc.end());
  EXPECT_EQ(*sccIt, 0u);

  ++sccIt;
  EXPECT_EQ(sccIt, scc.end());
  ASSERT_NE(it, sccs.end());

  ++it;
  EXPECT_EQ(it, sccs.end());

  EXPECT_EQ(getSCCs(graph), SCCSet{{0}});
}

TEST(SCCTest, SingletonLoop) {
  // Same as above, but now there is an edge. The results are the same.
  Graph graph(1);
  graph.addEdge(0, 0);
  GraphSCCs sccs(graph);

  auto it = sccs.begin();
  ASSERT_NE(it, sccs.end());

  auto scc = *it;
  auto sccIt = scc.begin();
  ASSERT_NE(sccIt, scc.end());
  EXPECT_EQ(*sccIt, 0u);

  ++sccIt;
  EXPECT_EQ(sccIt, scc.end());
  ASSERT_NE(it, sccs.end());

  ++it;
  EXPECT_EQ(it, sccs.end());

  EXPECT_EQ(getSCCs(graph), SCCSet{{0}});
}

TEST(SCCTest, DerefPostIncrement) {
  // Valid input iterators must have *it++ yield the value from before the
  // increment.
  Graph graph(1);
  GraphSCCs sccs(graph);
  auto it = sccs.begin()->begin();
  EXPECT_EQ(*it++, 0u);
}

TEST(SCCTest, Disconnected) {
  // There are no edges between the vertices.
  Graph graph(3);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0}, {1}, {2}}));
}

TEST(SCCTest, Chain) {
  // 0 -> 1 -> 2
  Graph graph(3);
  graph.addEdge(0, 1);
  graph.addEdge(1, 2);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0}, {1}, {2}}));
}

TEST(SCCTest, ChainReverse) {
  // 0 <- 1 <- 2
  Graph graph(3);
  graph.addEdge(2, 1);
  graph.addEdge(1, 0);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0}, {1}, {2}}));
}

TEST(SCCTest, Loop) {
  // 0 -> 1 -> 2 -> 0
  // There is only one SCC here.
  Graph graph(3);
  graph.addEdge(0, 1);
  graph.addEdge(1, 2);
  graph.addEdge(2, 0);
  EXPECT_EQ(getSCCs(graph), (SCCSet({{0, 1, 2}})));
}

TEST(SCCTest, LoopReverse) {
  // 0 <- 1 <- 2 <- 0
  // There is only one SCC here.
  Graph graph(3);
  graph.addEdge(0, 2);
  graph.addEdge(2, 1);
  graph.addEdge(1, 0);
  EXPECT_EQ(getSCCs(graph), (SCCSet({{0, 1, 2}})));
}

TEST(SCCTest, Full) {
  // Fully connected graph has one SCC.
  Graph graph(3);
  for (unsigned i = 0; i < 3; ++i) {
    for (unsigned j = 0; j < 3; ++j) {
      graph.addEdge(i, j);
    }
  }
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0, 1, 2}}));
}

TEST(SCCTest, TwoAndOne) {
  // 0 <-> 1 -> 2
  Graph graph(3);
  graph.addEdge(0, 1);
  graph.addEdge(1, 0);
  graph.addEdge(1, 2);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0, 1}, {2}}));
}

TEST(SCCTest, TwoAndOneRedundant) {
  // 2 <- 0 <-> 1 -> 2
  Graph graph(3);
  graph.addEdge(0, 1);
  graph.addEdge(1, 0);
  graph.addEdge(1, 2);
  // New from previous, doesn't affect result.
  graph.addEdge(0, 2);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0, 1}, {2}}));
}

TEST(SCCTest, OneAndTwo) {
  // 0 -> 1 <-> 2
  Graph graph(3);
  graph.addEdge(0, 1);
  graph.addEdge(1, 2);
  graph.addEdge(2, 1);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0}, {1, 2}}));
}

TEST(SCCTest, TwoAndTwoDisconnected) {
  // 0 <-> 1  2 <-> 3
  Graph graph(4);
  graph.addEdge(0, 1);
  graph.addEdge(1, 0);
  graph.addEdge(2, 3);
  graph.addEdge(3, 2);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0, 1}, {2, 3}}));
}

TEST(SCCTest, TwoAndTwo) {
  // 0 <-> 1 -> 2 <-> 3
  Graph graph(4);
  graph.addEdge(0, 1);
  graph.addEdge(1, 0);
  graph.addEdge(2, 3);
  graph.addEdge(3, 2);
  // New from previous, doesn't affect result
  graph.addEdge(1, 2);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0, 1}, {2, 3}}));
}

TEST(SCCTest, DoublyLinkedList) {
  // 0 <-> 1 <-> 2 <-> 3
  Graph graph(4);
  graph.addEdge(0, 1);
  graph.addEdge(1, 0);
  graph.addEdge(2, 3);
  graph.addEdge(3, 2);
  graph.addEdge(1, 2);
  // New from previous, combines SCCs.
  graph.addEdge(2, 1);
  EXPECT_EQ(getSCCs(graph), (SCCSet{{0, 1, 2, 3}}));
}

TEST(SCCTest, BigTree) {
  // 012 <- 345 -> 678
  Graph graph(9);
  graph.addEdge(0, 1);
  graph.addEdge(1, 2);
  graph.addEdge(2, 0);

  graph.addEdge(3, 4);
  graph.addEdge(4, 5);
  graph.addEdge(5, 3);

  graph.addEdge(6, 7);
  graph.addEdge(7, 8);
  graph.addEdge(8, 6);

  graph.addEdge(3, 2);
  graph.addEdge(5, 6);

  EXPECT_EQ(getSCCs(graph), (SCCSet{{0, 1, 2}, {3, 4, 5}, {6, 7, 8}}));
}

TEST(SCCTest, BigDiamond) {
  // 67 <- 01 <- 23 -> 45 -> 67
  Graph graph(8);
  graph.addEdge(0, 1);
  graph.addEdge(1, 0);

  graph.addEdge(2, 3);
  graph.addEdge(3, 2);

  graph.addEdge(4, 5);
  graph.addEdge(5, 4);

  graph.addEdge(6, 7);
  graph.addEdge(7, 6);

  graph.addEdge(2, 0);
  graph.addEdge(2, 4);
  graph.addEdge(0, 6);
  graph.addEdge(4, 6);

  EXPECT_EQ(getSCCs(graph), (SCCSet{{0, 1}, {2, 3}, {4, 5}, {6, 7}}));
}
