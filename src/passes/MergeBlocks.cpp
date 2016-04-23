/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Merges blocks to their parents.
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct MergeBlocks : public WalkerPass<PostWalker<MergeBlocks, Visitor<MergeBlocks>>> {
  bool isFunctionParallel() { return true; }

  void visitBlock(Block *curr) {
    bool more = true;
    while (more) {
      more = false;
      for (size_t i = 0; i < curr->list.size(); i++) {
        Block* child = curr->list[i]->dynCast<Block>();
        if (!child) continue;
        if (child->name.is()) continue; // named blocks can have breaks to them (and certainly do, if we ran RemoveUnusedNames and RemoveUnusedBrs)
        ExpressionList merged(getModule()->allocator);
        for (size_t j = 0; j < i; j++) {
          merged.push_back(curr->list[j]);
        }
        for (auto item : child->list) {
          merged.push_back(item);
        }
        for (size_t j = i + 1; j < curr->list.size(); j++) {
          merged.push_back(curr->list[j]);
        }
        curr->list = merged;
        more = true;
        break;
      }
    }
  }
};

static RegisterPass<MergeBlocks> registerPass("merge-blocks", "merges blocks to their parents");

} // namespace wasm

