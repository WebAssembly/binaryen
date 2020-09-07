/*
 * Copyright 2020 WebAssembly Community Group participants
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

// TODO: documentation

#include "ir/branch-utils.h"
#include "ir/utils.h"
#include "pass.h"

namespace wasm {

struct StackRemoveBlocksPass
  : public WalkerPass<PostWalker<StackRemoveBlocksPass>> {
  bool isFunctionParallel() override { return true; }
  Pass* create() override { return new StackRemoveBlocksPass; }

  void visitBlock(Block* curr) {
    for (size_t i = 0; i < curr->list.size();) {
      if (auto* block = curr->list[i]->dynCast<Block>()) {
        if (!BranchUtils::BranchSeeker::has(block, block->name)) {
          // TODO: implement `insert` on arena vectors directly
          std::vector<Expression*> insts(curr->list.begin(), curr->list.end());
          insts.erase(insts.begin() + i);
          insts.insert(
            insts.begin() + i, block->list.begin(), block->list.end());
          curr->list.set(insts);
          continue;
        }
      }
      ++i;
    }
  }
};

Pass* createStackRemoveBlocksPass() { return new StackRemoveBlocksPass; }

} // namespace wasm
