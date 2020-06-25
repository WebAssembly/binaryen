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

#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"

namespace wasm {

struct StackDCEPass : public WalkerPass<PostWalker<StackDCEPass>> {
  bool isFunctionParallel() override { return true; }
  Pass* create() override { return new StackDCEPass; }
  bool changed = false;

  void visitBlock(Block* curr) {
    for (size_t i = 0, size = curr->list.size(); i < size; ++i) {
      if (curr->list[i]->type == Type::unreachable) {
        // Conservatively keep any `unreachable` following block structures to
        // guarantee proper typing. TODO: Add a pass to re-type blocks and
        // remove these unreachables
        if (Properties::isControlFlowStructure(curr->list[i]) && i < size - 1 &&
            curr->list[i + 1]->is<Unreachable>()) {
          curr->list.resize(i + 2);
        } else {
          curr->list.resize(i + 1);
        }
        changed = true;
        return;
      }
    }
  }

  void doWalkFunction(Function* func) {
    super::doWalkFunction(func);
    if (changed) {
      ReFinalize(IRProfile::Stacky).walkFunctionInModule(func, getModule());
    }
  }
};

Pass* createStackDCEPass() { return new StackDCEPass; }

} // namespace wasm
