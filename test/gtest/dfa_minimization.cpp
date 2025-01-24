/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include <set>
#include <string>
#include <vector>

#include "support/dfa_minimization.h"
#include "gtest/gtest.h"

using namespace wasm;

using State = DFA::State<std::string>;
using Graph = std::vector<std::vector<State>>;
using Results = std::vector<std::vector<std::string>>;
using SetResults = std::set<std::set<std::string>>;

// We don't care about order between or within the output partitions.
SetResults settify(const Results& vecs) {
  SetResults sets;
  for (const auto& vec : vecs) {
    sets.emplace(vec.begin(), vec.end());
  }
  return sets;
}

// Check that the same values appear in the input and output and that each value
// appears once.
void validate(const Graph& graph, const Results& results) {
  std::set<std::string> inputVals;
  for (const auto& partition : graph) {
    for (const auto& state : partition) {
      bool inserted = inputVals.insert(state.val).second;
      ASSERT_TRUE(inserted);
    }
  }

  std::set<std::string> outputVals;
  for (const auto& partition : results) {
    for (const auto& val : partition) {
      ASSERT_NE(inputVals.find(val), inputVals.end());
      ASSERT_TRUE(outputVals.insert(val).second);
    }
  }

  ASSERT_EQ(outputVals.size(), inputVals.size());
}

TEST(DFATest, Empty) {
  Graph graph = {};
  auto results = DFA::refinePartitions(graph);
  validate(graph, results);
  EXPECT_EQ(settify(results), SetResults{});
}

TEST(DFATest, Singleton) {
  Graph graph = {{{"A", {}}}};
  auto results = DFA::refinePartitions(graph);
  validate(graph, results);
  EXPECT_EQ(settify(results), SetResults{{"A"}});
}

TEST(DFATest, CyclePartitioned) {
  // The partitions are already maximally refined, so shouldn't change.
  State a{"A", {"B"}};
  State b{"B", {"C"}};
  State c{"C", {"A"}};
  Graph graph = {{a}, {b}, {c}};
  auto results = DFA::refinePartitions(graph);
  validate(graph, results);
  EXPECT_EQ(settify(results), (SetResults{{"A"}, {"B"}, {"C"}}));
}

TEST(DFATest, CycleGrouped) {
  // All the states are identical, so the the partition shouldn't change.
  State a{"A", {"B"}};
  State b{"B", {"C"}};
  State c{"C", {"A"}};
  Graph graph = {{a, b, c}};
  auto results = DFA::refinePartitions(graph);
  validate(graph, results);
  EXPECT_EQ(settify(results), (SetResults{{"A", "B", "C"}}));
}

TEST(DFATest, CycleRefined) {
  // A and B are distinguishable, so the partitions should be refined.
  State a{"A", {"B"}};
  State b{"B", {"C"}};
  State c{"C", {"A"}};
  Graph graph = {{a, b}, {c}};
  auto results = DFA::refinePartitions(graph);
  validate(graph, results);
  EXPECT_EQ(settify(results), (SetResults{{"A"}, {"B"}, {"C"}}));
}

TEST(DFATest, ChainZip) {
  // Chain A->B->C->D is identical to chain W->X->Y->Z.
  State a{"A", {"B"}}, w{"W", {"X"}};
  State b{"B", {"C"}}, x{"X", {"Y"}};
  State c{"C", {"D"}}, y{"Y", {"Z"}};
  State d{"D", {}}, z{"Z", {}};
  Graph graph = {{a, b, c, d, w, x, y, z}};
  auto results = DFA::refinePartitions(graph);
  validate(graph, results);
  EXPECT_EQ(settify(results),
            (SetResults{{"A", "W"}, {"B", "X"}, {"C", "Y"}, {"D", "Z"}}));
}

TEST(DFATest, ChainUnzip) {
  // Chain A->B->C->D looks a lot like chain W->X->Y->Z, but since Z is
  // distinguishable, the full chains end up being separated.
  State a{"A", {"B"}}, w{"W", {"X"}};
  State b{"B", {"C"}}, x{"X", {"Y"}};
  State c{"C", {"D"}}, y{"Y", {"Z"}};
  State d{"D", {}}, z{"Z", {}};
  Graph graph = {{a, b, c, d, w, x, y}, {z}};
  auto results = DFA::refinePartitions(graph);
  validate(graph, results);
  EXPECT_EQ(
    settify(results),
    (SetResults{{"A"}, {"W"}, {"B"}, {"X"}, {"C"}, {"Y"}, {"D"}, {"Z"}}));
}
