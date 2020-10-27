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

//
// Lowers a module with loads and stores that access a 64-bit memory with
// one that works as-is on wasm32.
//
// TODO(wvo): make this run in parallel if needed.

#include "ir/bits.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct Memory64Lowering : public WalkerPass<PostWalker<Memory64Lowering>> {

  void run(PassRunner* runner, Module* module) override {
    if (module->memory.is64()) {
      super::run(runner, module);
    }
  }

  void WrapAddress64(Expression*& ptr) {
    if (ptr->type == Type::unreachable) {
      return;
    }
    auto& module = *getModule();
    assert(module.memory.is64());
    assert(ptr->type == Type::i64);
    Builder builder(module);
    ptr = builder.makeUnary(UnaryOp::WrapInt64, ptr);
  }

  void visitLoad(Load* curr) { WrapAddress64(curr->ptr); }

  void visitStore(Store* curr) { WrapAddress64(curr->ptr); }

  void visitMemorySize(MemorySize* curr) {
    auto size = static_cast<Expression*>(curr);
    WrapAddress64(size);
    replaceCurrent(size);
  }

  void visitMemoryGrow(MemoryGrow* curr) {
    WrapAddress64(curr->delta);
    auto size = static_cast<Expression*>(curr);
    WrapAddress64(size);
    replaceCurrent(size);
  }

  void visitMemoryInit(MemoryInit* curr) { WrapAddress64(curr->dest); }

  void visitMemoryFill(MemoryFill* curr) {
    WrapAddress64(curr->dest);
    WrapAddress64(curr->size);
  }

  void visitMemoryCopy(MemoryCopy* curr) {
    WrapAddress64(curr->dest);
    WrapAddress64(curr->source);
    WrapAddress64(curr->size);
  }

  void visitMemory(Memory* memory) {
    // This is visited last.
    memory->indexType = Type::i32;
  }
};

Pass* createMemory64LoweringPass() { return new Memory64Lowering(); }

} // namespace wasm
