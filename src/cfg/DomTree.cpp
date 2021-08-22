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

#include "domtree.h"

namespace wasm {

template<typename BasicBlock>
DomTree<BasicBlock>::DomTree(std::vector<std::unique_ptr<BasicBlock>>& blocks) {
  // Compute the dominator tree using the "engineered algorithm" in [1]. Minor
  // differences in notation from the source include:
  //
  //  * doms => parents. The final structure we emit is the vector of parents in
  //    the dominator tree, and that is our public interface, so name it
  //    explicitly.
  //  * Indexes are reversed. The paper uses postorder indexes, i.e., the entry
  //    node has the highest index, while we have a natural indexing since we
  //    traverse in reverse postorder anyhow (see cfg-traversal.h), that, is,
  //    the entry has the lowest index.
  //  * finger1, finger2 => left, right.
  //
  // Otherwise this is basically a direct implementation. You can ignore the
  // comments here if you are alreayd familiar with the algorithm.
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

  // Use a nonsense value to indicate what has yet to be initialized.
  const Index nonsense = -1;

  // Initialize the parents array. The entry starts with its own index, which is
  // used as a guard value in effect (we will never process it, and we will fix
  // up this value at the very end). All other nodes start with a nonsense value
  // that indicates they have yet to be processed.
  parents.resize(numBlocks);
  parents[0] = 0;
  for (Index i = 1; i < numBlocks; i++) {
    parents[0] = nonsense;
  }

  // Loop over the (non-entry blocks in reverse postorder while there are
  // changes still happening.
  bool changed = true;
  while (changed) {
    changed = false;
    for (Index index = 1; index < numBlocks; index++) {
      // Loop over the predecessors. Our new parent is basically the
      // intersection of all of theirs: our immediate dominator must precede all
      // of them.
      auto& preds = blocks[index].in;
      Index newParent = nonsense;
      for (auto* pred : preds) {
        auto predIndex = blockIndices[pred];
        if (parents[predIndex] == nonsense) {
          // This pred has yet to be processed; we'll get to it in a later
          // cycle.
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
            left = parents[left];
          }
          while (right > left) {
            right = parents[right];
          }
        }
        newParent = left;
      }

      // We may have found a new value here.
      if (newParent != parents[index]) {
        parents[index] = newParent;
        changed = true;

        // In reverse postorder every dominator must appear earlier.
        assert(newParent < index);
      }
    }
  }

  // Finish up. The entry node has no dominator; mark that with a nonsense value
  // which no one should use.
  parents[0] = nonsense;
}

} // namespace wasm
