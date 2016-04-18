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
// Lowers if (x) y else z into
//
// L: {
//   if (x) break (y) L
//   z
// }
//
// This is useful for investigating how beneficial if_else is.
//

#include <memory>

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct LowerIfElse : public WalkerPass<PostWalker<LowerIfElse, Visitor<LowerIfElse>>> {
  MixedArena* allocator;
  std::unique_ptr<NameManager> namer;

  void prepare(PassRunner* runner, Module *module) override {
    allocator = runner->allocator;
    namer = std::unique_ptr<NameManager>(new NameManager());
    namer->run(runner, module);
  }

  void visitIf(If *curr) {
    if (curr->ifFalse) {
      auto block = allocator->alloc<Block>();
      auto name = namer->getUnique("L"); // TODO: getUniqueInFunction
      block->name = name;
      block->list.push_back(curr);
      block->list.push_back(curr->ifFalse);
      block->finalize();
      curr->ifFalse = nullptr;
      auto break_ = allocator->alloc<Break>();
      break_->name = name;
      break_->value = curr->ifTrue;
      curr->ifTrue = break_;
      replaceCurrent(block);
    }
  }
};

static RegisterPass<LowerIfElse> registerPass("lower-if-else", "lowers if-elses into ifs, blocks and branches");

} // namespace wasm
