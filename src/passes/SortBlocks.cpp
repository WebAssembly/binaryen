/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Reorder blocks so there is a canonical ordering, which can help
// passes that look for identical code on multiple blocks.
//

#include <tuple>
#include <utility>

#include "ir/effects.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/hash.h"
#include "wasm.h"

namespace wasm {


// Main pass class
struct SortBlocks : public WalkerPass<PostWalker<SortBlocks>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SortBlocks; }

  void visitBlock(Block* curr) {
    auto& list = curr->list;
    if (list.empty()) return;
    Index numSortable = list.size();
    if (list.back()->type != none) {
      numSortable--;
    }
    if (numSortable < 2) return;

    // Compute all the effects (which may block some reordering) and
    // all the hashes.
    std::map<Expression*, EffectAnalyzer> effects;
    std::map<Expression*, HashType> hashes;

    for (Index i = 0; i < numSortable; i++) {
      auto* curr = list[i];
      effects.emplace(std::piecewise_construct,
                      std::forward_as_tuple(curr),
                      std::forward_as_tuple(getPassOptions(), curr));
      hashes.emplace(curr, ExpressionAnalyzer::hash(curr));
    }

    // Do the sorting, by bubbling to the front and back (which is
    // where optimizations typically look). We pick the order of
    // lower hashes earlier.
    bool more = true;
    while (more) {
      more = false;
      for (Index i = 0; i < numSortable; i++) {
        // Bubble forward.
        Index j = i;
        while (j < numSortable - 1 &&
               hashes[list[j]] > hashes[list[j + 1]] &&
               !effects.at(list[j]).invalidates(effects.at(list[j + 1]))) {
          std::swap(list[j], list[j + 1]);
          j++;
          more = true;
        }
        // Bubble backward, if we didn't move forward (if we did, there
        // is no possibility to reverse).
        if (j == i) {
          while (j > 0 &&
                 hashes[list[j]] < hashes[list[j - 1]] &&
                 !effects.at(list[j]).invalidates(effects.at(list[j - 1]))) {
            std::swap(list[j], list[j - 1]);
            j--;
            more = true;
          }
        }
      }
    }
  }
};

Pass* createSortBlocksPass() { return new SortBlocks(); }

} // namespace wasm
