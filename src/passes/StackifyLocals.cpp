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

#include "ir/local-graph.h"
#include "ir/stack-utils.h"
#include "pass.h"

namespace wasm {

struct StackifyLocalsPass : public WalkerPass<PostWalker<StackifyLocalsPass>> {
  bool isFunctionParallel() override { return true; }
  Pass* create() override { return new StackifyLocalsPass; }

  std::unique_ptr<LocalGraph> localGraph;

  void doWalkFunction(Function* curr) {
    localGraph = std::make_unique<LocalGraph>(curr);
    localGraph->computeInfluences();
    super::doWalkFunction(curr);
  }

  void visitBlock(Block* curr) {
    // Maps sets in this block to their indexes in the block list
    std::unordered_map<LocalSet*, Index> localSets;
    for (Index i = 0; i < curr->list.size(); ++i) {
      if (auto* set = curr->list[i]->dynCast<LocalSet>()) {
        // Tees can't be stackified, so ignore them
        if (!set->isTee()) {
          localSets.emplace(set, i);
        }
      } else if (auto* get = curr->list[i]->dynCast<LocalGet>()) {
        // Check that there is a single set providing this value
        auto& sets = localGraph->getSetses[get];
        if (sets.size() != 1) {
          continue;
        }
        auto* set = *sets.begin();
        // Check that the set is in this block.
        auto it = localSets.find(set);
        if (it == localSets.end()) {
          continue;
        }
        auto setIndex = it->second;
        // Check that the intervening instructions are stack neutral
        StackSignature sig(curr->list.begin() + setIndex + 1,
                           curr->list.begin() + i);
        if (sig.params != Type::none || sig.results != Type::none) {
          continue;
        }
        // Check how many uses there are to determine how to optimize
        auto& gets = localGraph->setInfluences[set];
        if (gets.size() == 1) {
          assert(*gets.begin() == get);
          ExpressionManipulator::nop(set);
          ExpressionManipulator::nop(get);
        } else {
          // TODO: still remove the get, but make the `set` a `tee`
        }
      }
    }
    StackUtils::compact(curr);
  }
};

Pass* createStackifyLocalsPass() { return new StackifyLocalsPass(); }

} // namespace wasm
