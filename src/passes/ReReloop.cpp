/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Convert the AST to a CFG, and optimize+convert it back to the AST
// using the relooper.
//
// This pass depends on flatten-control-flow being run before it.
//

#include "wasm.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "cfg/Relooper.h"

namespace wasm {

struct ReReloop : public Pass {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new ReReloop; }

  void runFunction(PassRunner* runner, Module* module, Function* function) override {
    // since control flow is flattened, this is pretty simple
    // first, traverse the function body. note how we don't need to traverse
    // into expressions, as we know they contain no control flow
    std::vector<Expression*> stack;
    Relooper relooper;
    stack.push_back(function->body);
    Builder builder(*module);
    std::map<Name, CFG::Block*> breakTargets;
    // make a cfg block, containing an ast block for us to append to
    auto makeCFGBlock = [&]() {
      return new CFG::Block(builder->makeBlock());
    };
    CFG::Block* currCFGBlock = makeCFGBlock();
    auto getCurrBlock = [&]() {
      return currCFGBlock->Code->cast<Block>();
    };
    while (stack.size() > 0) {
      auto* curr = stack.back();
      stack.pop_back();
      if (auto* block = curr->dynCast<Block>()) {
        if (block->name.is()) {
          .. but taret is in the future ..
          .. can create it now, but need to use it later
        }
        auto& list = block->list;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          stack.push_back(list[i]);
        }
      } else if (auto* loop = curr->dynCast<Loop>()) {
      }
    }
    // finish the current block
    ..
    // run the relooper to recreate control flow
    ..
  }
};

Pass *createReReloopPass() {
  return new ReReloop();
}

} // namespace wasm

