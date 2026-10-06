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

#include <memory>
#include <sstream>
#include <unordered_map>
#include <unordered_set>
#include <variant>
#include <vector>

#include "cfg/wto.h"
#include "gtest/gtest.h"

using namespace wasm;

namespace {

struct TestCFG {
  struct Contents {
    bool inQueue = false;
    Index index = 0;
  };

  struct BasicBlock {
    Contents contents;
    std::vector<BasicBlock*> out;
    std::vector<BasicBlock*> in;
  };

  std::vector<std::unique_ptr<BasicBlock>> basicBlocks;
  BasicBlock* entry = nullptr;

  explicit TestCFG(Index numBlocks) {
    basicBlocks.reserve(numBlocks);
    for (Index i = 0; i < numBlocks; ++i) {
      auto block = std::make_unique<BasicBlock>();
      block->contents.index = i;
      basicBlocks.push_back(std::move(block));
    }
    if (numBlocks > 0) {
      entry = basicBlocks[0].get();
    }
  }

  void addEdge(Index u, Index v) {
    assert(u < basicBlocks.size());
    assert(v < basicBlocks.size());
    basicBlocks[u]->out.push_back(basicBlocks[v].get());
    basicBlocks[v]->in.push_back(basicBlocks[u].get());
  }
};

// Index-based mirror of a Weak Topological Ordering used in tests so that:
//   1. Expected orderings can be written concisely with block indices (e.g.
//      `WTOList{0, C({1, 2}), 3}`) and pretty-printed on failure.
//   2. Test assertions remain independent of the internal representation of
//      `WeakTopologicalOrdering` (which will be flattened into a contiguous
//      entry array in a follow-on commit).
struct WTOCycle;
struct WTOElem;
using WTOList = std::vector<WTOElem>;

struct WTOCycle {
  WTOList elems;

  WTOCycle(std::initializer_list<WTOElem> list);
  explicit WTOCycle(WTOList elems);

  Index head() const;
  bool operator==(const WTOCycle& other) const;
};

struct WTOElem : std::variant<Index, WTOCycle> {
  using Base = std::variant<Index, WTOCycle>;
  using Base::Base;
  WTOElem(Index v) : Base(v) {}
  WTOElem(int v) : Base(Index(v)) {}
  WTOElem(WTOCycle c) : Base(std::move(c)) {}
};

WTOCycle::WTOCycle(std::initializer_list<WTOElem> list) : elems(list) {}
WTOCycle::WTOCycle(WTOList elems) : elems(std::move(elems)) {}
Index WTOCycle::head() const { return std::get<Index>(elems.front()); }
bool WTOCycle::operator==(const WTOCycle& other) const {
  return elems == other.elems;
}

WTOCycle C(std::initializer_list<WTOElem> list) { return WTOCycle(list); }

std::ostream& operator<<(std::ostream& os, const WTOElem& elem);
std::ostream& operator<<(std::ostream& os, const WTOList& list);

std::ostream& operator<<(std::ostream& os, const WTOCycle& cycle) {
  return os << "(" << cycle.elems << ")";
}

std::ostream& operator<<(std::ostream& os, const WTOElem& elem) {
  if (auto* v = std::get_if<Index>(&elem)) {
    return os << *v;
  }
  return os << std::get<WTOCycle>(elem);
}

std::ostream& operator<<(std::ostream& os, const WTOList& list) {
  for (size_t i = 0; i < list.size(); ++i) {
    if (i > 0) {
      os << " ";
    }
    os << list[i];
  }
  return os;
}

using BasicBlock = TestCFG::BasicBlock;

WTOList toIndexWTO(const WeakTopologicalOrdering<BasicBlock>::List& src) {
  WTOList dst;
  for (const auto& elem : src) {
    if (auto* b = std::get_if<BasicBlock*>(&elem)) {
      dst.emplace_back((*b)->contents.index);
    } else {
      const auto& cycle =
        std::get<WeakTopologicalOrdering<BasicBlock>::Cycle>(elem);
      EXPECT_EQ(cycle.head(), std::get<BasicBlock*>(cycle.elems.front()));
      dst.emplace_back(WTOCycle(toIndexWTO(cycle.elems)));
    }
  }
  return dst;
}

// Check the formal properties of a Weak Topological Ordering (Bourdoncle 1993,
// Definition 1) over the reachable subgraph of `cfg`:
// 1. Every vertex appears at most once in the flattened ordering.
// 2. Every cycle is non-empty and its head (first element) is a single vertex,
//    not a nested cycle.
// 3. For every edge u -> v between reachable vertices:
//    - Either u appears strictly before v in the flattened order, OR
//    - v appears at or before u AND v is the head of a cycle containing both v
//      and u.
void verifyWTOInvariants(const TestCFG& cfg, const WTOList& wto) {
  std::vector<Index> flatOrder;
  std::unordered_map<Index, size_t> pos;
  std::unordered_map<Index, std::unordered_set<Index>> cycleMembers;

  auto walk = [&](auto& self,
                  const WTOList& list,
                  std::vector<Index>& activeHeads) -> void {
    for (const auto& elem : list) {
      if (auto* v = std::get_if<Index>(&elem)) {
        EXPECT_FALSE(pos.contains(*v)) << "Duplicate vertex " << *v;
        pos[*v] = flatOrder.size();
        flatOrder.push_back(*v);
        for (Index head : activeHeads) {
          cycleMembers[head].insert(*v);
        }
      } else {
        const auto& cycle = std::get<WTOCycle>(elem);
        ASSERT_FALSE(cycle.elems.empty()) << "Empty cycle in WTO";
        ASSERT_TRUE(std::holds_alternative<Index>(cycle.elems.front()))
          << "Cycle head must be a single vertex, not a nested cycle";
        Index head = cycle.head();
        activeHeads.push_back(head);
        self(self, cycle.elems, activeHeads);
        activeHeads.pop_back();
      }
    }
  };

  std::vector<Index> activeHeads;
  walk(walk, wto, activeHeads);

  for (Index u : flatOrder) {
    for (auto* succ : cfg.basicBlocks[u]->out) {
      Index v = succ->contents.index;
      ASSERT_TRUE(pos.contains(v))
        << "Reachable vertex " << v << " missing from WTO";
      if (pos[u] >= pos[v]) {
        ASSERT_TRUE(cycleMembers.contains(v))
          << "Back-edge " << u << " -> " << v << " targets non-head vertex "
          << v;
        EXPECT_TRUE(cycleMembers[v].contains(u))
          << "Back-edge " << u << " -> " << v
          << " is not enclosed in the cycle headed by " << v;
      }
    }
  }
}

WTOList getWTO(TestCFG& cfg) {
  WeakTopologicalOrdering<BasicBlock> wto(cfg.basicBlocks);
  EXPECT_EQ(wto.elems, wto.elems);
  auto list = toIndexWTO(wto.elems);
  verifyWTOInvariants(cfg, list);
  return list;
}

} // namespace

TEST(WTOTest, Empty) {
  TestCFG cfg(0);
  EXPECT_EQ(getWTO(cfg), WTOList{});
}

TEST(WTOTest, Singleton) {
  TestCFG cfg(1);
  EXPECT_EQ(getWTO(cfg), WTOList{0});
}

TEST(WTOTest, LinearChain) {
  TestCFG cfg(3);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 2);
  EXPECT_EQ(getWTO(cfg), (WTOList{0, 1, 2}));
}

TEST(WTOTest, Diamond) {
  {
    TestCFG cfg(4);
    cfg.addEdge(0, 1);
    cfg.addEdge(0, 2);
    cfg.addEdge(1, 3);
    cfg.addEdge(2, 3);
    EXPECT_EQ(getWTO(cfg), (WTOList{0, 1, 2, 3}));
  }
  {
    // Reversed edge insertion order at the split and join.
    TestCFG cfg(4);
    cfg.addEdge(0, 2);
    cfg.addEdge(0, 1);
    cfg.addEdge(2, 3);
    cfg.addEdge(1, 3);
    EXPECT_EQ(getWTO(cfg), (WTOList{0, 1, 2, 3}));
  }
  {
    // Asymmetric diamond (one arm has two blocks, the other has one) under both
    // valid RPO block orderings.
    TestCFG leftFirst(5);
    leftFirst.addEdge(0, 1);
    leftFirst.addEdge(1, 2);
    leftFirst.addEdge(0, 3);
    leftFirst.addEdge(2, 4);
    leftFirst.addEdge(3, 4);
    EXPECT_EQ(getWTO(leftFirst), (WTOList{0, 1, 2, 3, 4}));

    TestCFG rightFirst(5);
    rightFirst.addEdge(0, 2);
    rightFirst.addEdge(2, 3);
    rightFirst.addEdge(0, 1);
    rightFirst.addEdge(3, 4);
    rightFirst.addEdge(1, 4);
    EXPECT_EQ(getWTO(rightFirst), (WTOList{0, 1, 2, 3, 4}));
  }
}

TEST(WTOTest, SelfLoop) {
  TestCFG cfg(3);
  cfg.addEdge(0, 0);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 1);
  cfg.addEdge(1, 2);
  EXPECT_EQ(getWTO(cfg), (WTOList{C({0}), C({1}), 2}));
}

TEST(WTOTest, SimpleCycle) {
  TestCFG cfg(2);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 0);
  EXPECT_EQ(getWTO(cfg), (WTOList{C({0, 1})}));
}

TEST(WTOTest, ThreeNodeCycle) {
  TestCFG cfg(3);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 2);
  cfg.addEdge(2, 0);
  EXPECT_EQ(getWTO(cfg), (WTOList{C({0, 1, 2})}));
}

TEST(WTOTest, SharedLoopHeader) {
  // Two loops sharing header 0: 0 -> 1 -> 0 and 0 -> 2 -> 0.
  TestCFG cfg(3);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 0);
  cfg.addEdge(0, 2);
  cfg.addEdge(2, 0);
  EXPECT_EQ(getWTO(cfg), (WTOList{C({0, 1, 2})}));
}

TEST(WTOTest, BourdonclePaperExample) {
  // The example control-flow graph from Bourdoncle's 1993 paper "Efficient
  // chaotic iteration strategies with widenings", Figure 1 (0-indexed: vertices
  // 0..7 correspond to 1..8 in the paper):
  //   0 -> 1
  //   1 -> 2, 1 -> 7
  //   2 -> 3
  //   3 -> 4, 3 -> 6
  //   4 -> 5
  //   5 -> 4, 5 -> 6
  //   6 -> 2, 6 -> 7
  // Expected WTO from the paper: 0 1 (2 3 (4 5) 6) 7
  TestCFG cfg(8);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 2);
  cfg.addEdge(1, 7);
  cfg.addEdge(2, 3);
  cfg.addEdge(3, 4);
  cfg.addEdge(3, 6);
  cfg.addEdge(4, 5);
  cfg.addEdge(5, 4);
  cfg.addEdge(5, 6);
  cfg.addEdge(6, 2);
  cfg.addEdge(6, 7);
  auto wto = getWTO(cfg);
  EXPECT_EQ(wto, (WTOList{0, 1, C({2, 3, C({4, 5}), 6}), 7}));
  std::ostringstream ss;
  ss << wto;
  EXPECT_EQ(ss.str(), "0 1 (2 3 (4 5) 6) 7");
}

TEST(WTOTest, LoopHeaderDominatesExit) {
  // Same as Bourdoncle's paper graph, except block 7 is only reachable from
  // block 6 (no direct edge 1 -> 7). Block 2 dominates block 7 even though
  // block 7 is outside the natural loop of 2. Block 7 must remain outside the
  // cycle of 2.
  TestCFG cfg(8);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 2);
  cfg.addEdge(2, 3);
  cfg.addEdge(3, 4);
  cfg.addEdge(3, 6);
  cfg.addEdge(4, 5);
  cfg.addEdge(5, 4);
  cfg.addEdge(5, 6);
  cfg.addEdge(6, 2);
  cfg.addEdge(6, 7);
  EXPECT_EQ(getWTO(cfg), (WTOList{0, 1, C({2, 3, C({4, 5}), 6}), 7}));
}

TEST(WTOTest, DiamondOfLoops) {
  // 01 -> 23 -> 67 and 01 -> 45 -> 67, where each pair is a 2-block loop.
  TestCFG cfg(8);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 0);
  cfg.addEdge(1, 2);
  cfg.addEdge(1, 4);

  cfg.addEdge(2, 3);
  cfg.addEdge(3, 2);
  cfg.addEdge(3, 6);

  cfg.addEdge(4, 5);
  cfg.addEdge(5, 4);
  cfg.addEdge(5, 6);

  cfg.addEdge(6, 7);
  cfg.addEdge(7, 6);

  EXPECT_EQ(getWTO(cfg), (WTOList{C({0, 1}), C({2, 3}), C({4, 5}), C({6, 7})}));
}

TEST(WTOTest, UnreachableBlocks) {
  // Blocks 0, 1, 2 form a reachable loop 0 -> 1 -> 2 -> 1.
  // Blocks 3, 4 form an unreachable cycle 3 -> 4 -> 3 with edges into 1 and 2.
  TestCFG cfg(5);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 2);
  cfg.addEdge(2, 1);
  cfg.addEdge(3, 4);
  cfg.addEdge(4, 3);
  cfg.addEdge(3, 1);
  cfg.addEdge(4, 2);
  EXPECT_EQ(getWTO(cfg), (WTOList{0, C({1, 2})}));
}

TEST(WTOTest, WorklistEvaluation) {
  // Evaluate a chaotic iteration sequence on Bourdoncle's paper graph where the
  // inner cycle (4 5) stabilizes in 2 iterations and the outer cycle
  // (2 3 (4 5) 6) stabilizes in 2 iterations.
  TestCFG cfg(8);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 2);
  cfg.addEdge(1, 7);
  cfg.addEdge(2, 3);
  cfg.addEdge(3, 4);
  cfg.addEdge(3, 6);
  cfg.addEdge(4, 5);
  cfg.addEdge(5, 4);
  cfg.addEdge(5, 6);
  cfg.addEdge(6, 2);
  cfg.addEdge(6, 7);

  WTOWorklist<TestCFG> work(cfg);
  work.push(cfg.entry);

  std::vector<Index> visits;
  unsigned count4 = 0;
  unsigned count2 = 0;
  work.run([&](BasicBlock* block) {
    Index id = block->contents.index;
    visits.push_back(id);
    for (auto* out : block->out) {
      Index outId = out->contents.index;
      if (id == 5 && outId == 4) {
        if (++count4 < 2) {
          work.push(out);
        }
      } else if (id == 6 && outId == 2) {
        if (++count2 < 2) {
          count4 = 0;
          work.push(out);
        }
      } else {
        work.push(out);
      }
    }
  });

  // Expected recursive evaluation order:
  // 0, 1,
  // first iteration of (2 3 (4 5) 6): 2, 3, 4, 5, 4, 5, 6,
  // second iteration of (2 3 (4 5) 6): 2, 3, 4, 5, 4, 5, 6,
  // 7
  EXPECT_EQ(
    visits,
    (std::vector<Index>{0, 1, 2, 3, 4, 5, 4, 5, 6, 2, 3, 4, 5, 4, 5, 6, 7}));
}

TEST(WTOTest, WorklistSelectivePropagation) {
  // In Bourdoncle's graph, test when block 3 only queues block 6 (skipping the
  // inner cycle (4 5) completely) and block 6 does not re-queue block 2.
  TestCFG cfg(8);
  cfg.addEdge(0, 1);
  cfg.addEdge(1, 2);
  cfg.addEdge(1, 7);
  cfg.addEdge(2, 3);
  cfg.addEdge(3, 4);
  cfg.addEdge(3, 6);
  cfg.addEdge(4, 5);
  cfg.addEdge(5, 4);
  cfg.addEdge(5, 6);
  cfg.addEdge(6, 2);
  cfg.addEdge(6, 7);

  WTOWorklist<TestCFG> work(cfg);
  work.push(cfg.entry);

  std::vector<Index> visits;
  work.run([&](BasicBlock* block) {
    Index id = block->contents.index;
    visits.push_back(id);
    if (id == 0) {
      work.push(cfg.basicBlocks[1].get());
    } else if (id == 1) {
      work.push(cfg.basicBlocks[2].get());
    } else if (id == 2) {
      work.push(cfg.basicBlocks[3].get());
    } else if (id == 3) {
      work.push(cfg.basicBlocks[6].get());
    } else if (id == 6) {
      work.push(cfg.basicBlocks[7].get());
    }
  });

  EXPECT_EQ(visits, (std::vector<Index>{0, 1, 2, 3, 6, 7}));
}
