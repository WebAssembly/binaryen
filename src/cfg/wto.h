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

//
// Weak Topological Ordering (WTO) and worklist runner for forward data flow
// analysis over reducible CFGs.
//
// A Weak Topological Ordering (Bourdoncle, "Efficient chaotic iteration
// strategies with widenings", 1993) is a hierarchical ordering of the reachable
// blocks of a directed graph in which strongly connected components (loops) are
// parenthesized into nested cycles. The first element of each cycle is its
// "head" (loop header), and the ordering satisfies two properties:
//
//   1. Every non-cycle edge u -> v goes forward in the flattened ordering
//      (u appears before v).
//   2. Every backedge u -> v targets the head v of a cycle that encloses both
//      u and v.
//
// Examples (writing `(h ...)` for a cycle with head `h`):
//
//   - Diamond (0 -> 1, 0 -> 2, 1 -> 3, 2 -> 3):
//       0 1 2 3
//
//   - Simple loop (0 -> 1 -> 2 -> 1, 2 -> 3):
//       0 (1 2) 3
//     Here 1 is the cycle head, 1 and 2 form the cycle body, and the exit
//     block 3 is outside the cycle.
//
//   - Nested loops (0 -> 1 -> 2 -> 3 -> 2, 3 -> 4 -> 1, 4 -> 5):
//       0 (1 (2 3) 4) 5
//     Here outer cycle (1 (2 3) 4) with head 1 encloses inner cycle (2 3) with
//     head 2.
//
// During forward dataflow analysis, elements of the WTO are evaluated
// left-to-right. When a cycle `(h ...)` is reached, its elements are evaluated
// repeatedly in order until the head `h` is no longer re-queued by a backedge.
// Inner cycles therefore stabilize completely on each iteration of an enclosing
// outer cycle before flow values propagate past the cycle.
//
// Algorithm sketch:
//
//   In a reducible CFG whose blocks are ordered in reverse postorder (RPO, as
//   produced by cfg-traversal.h), every cycle is a natural loop headed by a
//   single entry block that dominates all blocks in the cycle, and every
//   backedge `p -> h` satisfies `h` dominates `p` (with `h <= p` in RPO). We
//   construct the WTO directly from the dominator tree in three steps:
//
//   1. Compute the dominator tree (`DomTree`) over the RPO-indexed blocks.
//   2. Discover natural loops from innermost to outermost by scanning candidate
//      headers `h` in reverse RPO order (N - 1 down to 0). For each `h` that
//      has at least one backedge `p -> h` (where `h` dominates `p`), run a
//      backward DFS over predecessors starting from `p` and stopping at `h` to
//      visit every block in `h`'s natural loop. Because inner loop headers have
//      larger RPO indices than outer loop headers and are processed first, the
//      first loop that visits a block `b != h` is its immediately enclosing
//      loop (`loopParent[b] = h`). As each loop body is discovered, we collapse
//      its blocks into `h` using union-find so that outer loops skip over
//      already-collapsed inner loop bodies instead of re-traversing them (both
//      during the backward DFS and when walking the dominator tree).
//   3. Link each reachable block into the child list of its `loopParent` in
//      increasing RPO order, then walk the resulting loop nesting forest to
//      emit each loop header `h` and its children as a nested `Cycle`.
//

#ifndef cfg_wto_h
#define cfg_wto_h

#include <cassert>
#include <memory>
#include <vector>

#include "cfg/domtree.h"
#include "wasm.h"

namespace wasm {

// The BasicBlock type is assumed to have an `in` vector of predecessor block
// pointers and a `contents.index` field of type `Index`.
template<typename BasicBlock> struct WeakTopologicalOrdering {
  static constexpr Index NoTarget = Index(-1);

  // Each entry either visits `block` (`cycleTarget == NoTarget`) or marks the
  // end of the cycle headed by `block` (`cycleTarget` is the entry index of the
  // cycle header).
  struct Entry {
    BasicBlock* block = nullptr;
    Index cycleTarget = NoTarget;
  };

  std::vector<Entry> entries;

  WeakTopologicalOrdering(std::vector<std::unique_ptr<BasicBlock>>& blocks);
};

template<typename BasicBlock>
WeakTopologicalOrdering<BasicBlock>::WeakTopologicalOrdering(
  std::vector<std::unique_ptr<BasicBlock>>& blocks) {
  Index numBlocks = blocks.size();
  if (numBlocks == 0) {
    return;
  }

  DomTree<BasicBlock> domTree(blocks);

  auto isReachable = [&](Index i) {
    return i == 0 || domTree.iDoms[i] != domTree.nonsense;
  };

  static constexpr Index NoIndex = Index(-1);
  struct Node {
    Index loopParent = NoIndex;
    Index firstChild = NoIndex;
    Index nextSibling = NoIndex;
    Index ufParent = NoIndex;
    bool isLoopHeader = false;
  };
  std::vector<Node> nodes(numBlocks);

  auto find = [&](Index x) {
    Index root = x;
    while (nodes[root].ufParent != NoIndex) {
      root = nodes[root].ufParent;
    }
    // Path compression.
    while (x != root) {
      Index next = nodes[x].ufParent;
      nodes[x].ufParent = root;
      x = next;
    }
    return root;
  };

  auto dominates = [&](Index dom, Index node) {
    assert(isReachable(dom));
    // Since blocks are indexed in RPO, dominators always precede the blocks
    // they dominate.
    if (node < dom || !isReachable(node)) {
      return false;
    }
    // Walk up the dominator tree, using `find` to skip over already-collapsed
    // inner loops.
    Index curr = node;
    while (curr > dom) {
      curr = find(domTree.iDoms[curr]);
    }
    return curr == dom;
  };

  // Discover natural loops from innermost to outermost (reverse RPO order).
  // Because inner loops are processed before outer loops, collapsing each loop
  // body into its header with union-find records each block's immediately
  // enclosing loop while avoiding re-traversing inner loop bodies.
  std::vector<Index> worklist;
  for (Index i = numBlocks; i > 0; --i) {
    Index h = i - 1;
    if (!isReachable(h)) {
      continue;
    }
    for (auto* pred : blocks[h]->in) {
      Index p = pred->contents.index;
      if (dominates(h, p)) {
        nodes[h].isLoopHeader = true;
        Index rep = find(p);
        if (rep != h) {
          nodes[rep].loopParent = h;
          nodes[rep].ufParent = h;
          worklist.push_back(rep);
        }
      }
    }
    while (!worklist.empty()) {
      Index curr = worklist.back();
      worklist.pop_back();
      for (auto* pred : blocks[curr]->in) {
        Index p = pred->contents.index;
        if (isReachable(p)) {
          Index rep = find(p);
          if (rep != h) {
            assert(dominates(h, rep) && "Expected reducible CFG");
            nodes[rep].loopParent = h;
            nodes[rep].ufParent = h;
            worklist.push_back(rep);
          }
        }
      }
    }
  }

  // Link each reachable block into its parent loop's intrusive child list.
  // Prepending in reverse RPO order yields increasing RPO order.
  Index topFirstChild = NoIndex;
  for (Index i = numBlocks; i > 0; --i) {
    Index idx = i - 1;
    if (!isReachable(idx)) {
      continue;
    }
    Index parent = nodes[idx].loopParent;
    if (parent == NoIndex) {
      nodes[idx].nextSibling = topFirstChild;
      topFirstChild = idx;
    } else {
      nodes[idx].nextSibling = nodes[parent].firstChild;
      nodes[parent].firstChild = idx;
    }
  }

  entries.reserve(numBlocks * 2);
  auto emitList = [&](auto& self, Index firstChild) -> void {
    for (Index curr = firstChild; curr != NoIndex;
         curr = nodes[curr].nextSibling) {
      auto* block = blocks[curr].get();
      if (nodes[curr].isLoopHeader) {
        Index startPc = entries.size();
        entries.push_back({block, NoTarget});
        self(self, nodes[curr].firstChild);
        entries.push_back({block, startPc});
      } else {
        entries.push_back({block, NoTarget});
      }
    }
  };

  emitList(emitList, topFirstChild);
}

// Given a CFG in reverse postorder (e.g. from cfg-traversal), run a forward
// fixed-point analysis over its basic blocks using a Weak Topological Ordering.
//
// Usage:
//   1. Construct `WTOWorklist work(cfg);` (which initializes `inQueue` and
//      `index` on each block's `contents`).
//   2. Seed the initial block(s) to evaluate via `work.push(cfg.entry);`.
//   3. Call `work.run([&](BasicBlock* block) { ... });`. Inside the visitor
//      callback, evaluate the transfer function for `block` and call
//      `work.push(next)` for any successor whose input state changed and needs
//      to be (re-)evaluated.
//
// The BasicBlock `contents` of the CFG must contain two fields:
//
//   bool inQueue; // whether scheduled for visitation
//   Index index;  // basic block index in RPO
//
template<typename CFG> struct WTOWorklist {
  using BasicBlock = typename CFG::BasicBlock;

  CFG& cfg;

  WTOWorklist(CFG& cfg) : cfg(cfg) {
    auto& basicBlocks = cfg.basicBlocks;
    for (Index i = 0; i < basicBlocks.size(); ++i) {
      auto& contents = basicBlocks[i]->contents;
      contents.inQueue = false;
      contents.index = i;
    }
  }

  void push(BasicBlock* block) { block->contents.inQueue = true; }

  bool hasBackEdge() const {
    for (auto* loopTop : cfg.loopTops) {
      Index h = loopTop->contents.index;
      for (auto* pred : loopTop->in) {
        if (pred->contents.index >= h) {
          return true;
        }
      }
    }
    return false;
  }

  template<typename VisitFn> void run(VisitFn&& visit) {
    // If the CFG has no backedges, a single reverse-postorder pass visits every
    // reachable block in topological order without constructing DomTree or WTO.
    if (!hasBackEdge()) {
      for (auto& block : cfg.basicBlocks) {
        if (block->contents.inQueue) {
          block->contents.inQueue = false;
          visit(block.get());
        }
      }
      return;
    }
    WeakTopologicalOrdering<BasicBlock> wto(cfg.basicBlocks);
    const auto& entries = wto.entries;
    Index pc = 0;
    Index end = entries.size();
    while (pc < end) {
      const auto& entry = entries[pc];
      if (entry.cycleTarget == WeakTopologicalOrdering<BasicBlock>::NoTarget) {
        if (entry.block->contents.inQueue) {
          entry.block->contents.inQueue = false;
          visit(entry.block);
        }
        ++pc;
      } else if (entry.block->contents.inQueue) {
        pc = entry.cycleTarget;
      } else {
        ++pc;
      }
    }
  }
};

} // namespace wasm

#endif // cfg_wto_h
