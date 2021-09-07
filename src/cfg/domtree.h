/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Computes a dominator tree for a CFG graph, that is, for each block x we find
// the blocks y_i that must be reached before x on any path from the entry. Each
// block x has a single immediate dominator, the one closest to it, which forms
// a tree structure.
//
// This assumes the input is reducible.
//

#ifndef domtree_h
#define domtree_h

#include "cfg-traversal.h"
#include "wasm.h"

namespace wasm {

//
// DomTree receives an input CFG which has a list of basic blocks in reverse
// postorder. It generates the dominator tree by representing it as a vector of
// indexes, for each block giving the index of its parent (the immediate
// dominator) in the tree, that is,
//
//  iDoms[0] = a nonsense value, as the entry node has no immediate dominator
//  iDoms[1] = the index of the immediate dominator of CFG.blocks[1]
//  iDoms[2] = the index of the immediate dominator of CFG.blocks[2]
//  etc.
//
// The BasicBlock type is assumed to have a ".in" property which declares a
// vector of pointers to the incoming blocks, that is, the predecessors.
template<typename BasicBlock> struct DomTree {
  std::vector<Index> iDoms;

  // Use a nonsense value to indicate what has yet to be initialized or what is
  // irrelevant.
  enum { nonsense = Index(-1) };

  DomTree(std::vector<std::unique_ptr<BasicBlock>>& blocks);
};

template<typename BasicBlock>
DomTree<BasicBlock>::DomTree(std::vector<std::unique_ptr<BasicBlock>>& blocks) {
  // Compute the dominator tree using the "engineered algorithm" in [1]. Minor
  // differences in notation from the source include:
  //
  //  * doms => iDoms. The final structure we emit is the vector of parents in
  //    the dominator tree, and that is our public interface, so name it
  //    explicitly as the immediate dominators.
  //  * Indexes are reversed. The paper uses postorder indexes, i.e., the entry
  //    node has the highest index, while we have a natural indexing since we
  //    traverse in reverse postorder anyhow (see cfg-traversal.h), that, is,
  //    the entry has the lowest index.
  //  * finger1, finger2 => left, right.
  //  * We assume the input is reducible, since wasm and Binaryen IR have that
  //    property. This simplifies some things, see below.
  //
  // Otherwise this is basically a direct implementation.
  //
  // [1] Cooper, Keith D.; Harvey, Timothy J; Kennedy, Ken (2001). "A Simple,
  //       Fast Dominance Algorithm" (PDF).
  //       http://www.hipersoft.rice.edu/grads/publications/dom14.pdf

  // If there are no blocks, we have nothing to do.
  Index numBlocks = blocks.size();
  if (numBlocks == 0) {
    return;
  }

  // Map basic blocks to their indices.
  std::unordered_map<BasicBlock*, Index> blockIndices;
  for (Index i = 0; i < numBlocks; i++) {
    blockIndices[blocks[i].get()] = i;
  }

  // Initialize the iDoms array. The entry starts with its own index, which is
  // used as a guard value in effect (we will never process it, and we will fix
  // up this value at the very end). All other nodes start with a nonsense value
  // that indicates they have yet to be processed.
  iDoms.resize(numBlocks, nonsense);
  iDoms[0] = 0;

  // Process the (non-entry) blocks in reverse postorder, computing the
  // immediate dominators as we go. This returns whether we made any changes,
  // which is used in an assertion later down.
  auto processBlocks = [&]() {
    bool changed = false;
    for (Index index = 1; index < numBlocks; index++) {
      // Loop over the predecessors. Our new parent is basically the
      // intersection of all of theirs: our immediate dominator must precede all
      // of them.
      auto& preds = blocks[index]->in;
      Index newParent = nonsense;
      for (auto* pred : preds) {
        auto predIndex = blockIndices[pred];

        // In a reducible graph, we only need to care about the predecessors
        // that appear before us in the reverse postorder numbering. The only
        // predecessor that can appear *after* us is a loop backedge, but that
        // will never dominate the loop - the loop is dominated by its single
        // entry (since it is reducible, it has just one entry).
        if (predIndex > index) {
          continue;
        }

        // All of our predecessors will have been processed before us, except
        // if they are unreachable from the entry, in which case, we can ignore
        // them.
        if (iDoms[predIndex] == nonsense) {
          continue;
        }

        if (newParent == nonsense) {
          // This is the first processed predecessor.
          newParent = predIndex;
          continue;
        }

        // This is an additional predecessor. Intersect it, by going back to a
        // node that definitely dominates both possibilities. Effectively, we
        // keep decreasing the index backwards in the reverse postorder
        // indexing until we stop (at the latest, in the entry).
        auto left = newParent;
        auto right = predIndex;
        while (left != right) {
          while (left > right) {
            left = iDoms[left];
          }
          while (right > left) {
            right = iDoms[right];
          }
        }
        newParent = left;
      }

      // Check if we found a new value here, and apply it. (We will normally
      // always find a new value in the single pass that we run, but we also
      // assert lower down that running another pass causes no further changes.)
      if (newParent != iDoms[index]) {
        iDoms[index] = newParent;
        changed = true;

        // In reverse postorder the dominator cannot appear later.
        assert(newParent <= index);
      }
    }

    return changed;
  };

  processBlocks();

  // We must have finished all the work in a single traversal, since our input
  // is reducible.
  assert(!processBlocks());

  // Finish up. The entry node has no dominator; mark that with a nonsense value
  // which no one should use.
  iDoms[0] = nonsense;
}

} // namespace wasm

#endif // domtree_h
