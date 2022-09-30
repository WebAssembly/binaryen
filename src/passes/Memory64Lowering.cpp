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

  void wrapAddress64(Expression*& ptr, Name memoryName) {
    if (ptr->type == Type::unreachable) {
      return;
    }
    auto& module = *getModule();
    auto memory = module.getMemory(memoryName);
    if (memory->is64()) {
      assert(ptr->type == Type::i64);
      Builder builder(module);
      ptr = builder.makeUnary(UnaryOp::WrapInt64, ptr);
    }
  }

  void extendAddress64(Expression*& ptr, Name memoryName) {
    if (ptr->type == Type::unreachable) {
      return;
    }
    auto& module = *getModule();
    auto memory = module.getMemory(memoryName);
    if (memory->is64()) {
      assert(ptr->type == Type::i64);
      ptr->type = Type::i32;
      Builder builder(module);
      ptr = builder.makeUnary(UnaryOp::ExtendUInt32, ptr);
    }
  }

  void visitLoad(Load* curr) { wrapAddress64(curr->ptr, curr->memory); }

  void visitStore(Store* curr) { wrapAddress64(curr->ptr, curr->memory); }

  void visitMemorySize(MemorySize* curr) {
    auto& module = *getModule();
    auto memory = module.getMemory(curr->memory);
    if (memory->is64()) {
      auto size = static_cast<Expression*>(curr);
      extendAddress64(size, curr->memory);
      curr->ptrType = Type::i32;
      replaceCurrent(size);
    }
  }

  void visitMemoryGrow(MemoryGrow* curr) {
    auto& module = *getModule();
    auto memory = module.getMemory(curr->memory);
    if (memory->is64()) {
      wrapAddress64(curr->delta, curr->memory);
      auto size = static_cast<Expression*>(curr);
      extendAddress64(size, curr->memory);
      curr->ptrType = Type::i32;
      replaceCurrent(size);
    }
  }

  void visitMemoryInit(MemoryInit* curr) {
    wrapAddress64(curr->dest, curr->memory);
  }

  void visitMemoryFill(MemoryFill* curr) {
    wrapAddress64(curr->dest, curr->memory);
    wrapAddress64(curr->size, curr->memory);
  }

  void visitMemoryCopy(MemoryCopy* curr) {
    wrapAddress64(curr->dest, curr->destMemory);
    wrapAddress64(curr->source, curr->sourceMemory);
    wrapAddress64(curr->size, curr->destMemory);
  }

  void visitAtomicRMW(AtomicRMW* curr) {
    wrapAddress64(curr->ptr, curr->memory);
  }

  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    wrapAddress64(curr->ptr, curr->memory);
  }

  void visitAtomicWait(AtomicWait* curr) {
    wrapAddress64(curr->ptr, curr->memory);
  }

  void visitAtomicNotify(AtomicNotify* curr) {
    wrapAddress64(curr->ptr, curr->memory);
  }

  void visitMemory(Memory* memory) {
    // This is visited last.
    if (memory->is64()) {
      memory->indexType = Type::i32;
      if (memory->hasMax() && memory->max > Memory::kMaxSize32) {
        memory->max = Memory::kMaxSize32;
      }
    }
  }

  void visitDataSegment(DataSegment* segment) {
    if (!segment->isPassive) {
      auto* c = segment->offset->cast<Const>();
      c->value = Literal(static_cast<uint32_t>(c->value.geti64()));
      c->type = Type::i32;
    }
  }
};

Pass* createMemory64LoweringPass() { return new Memory64Lowering(); }

} // namespace wasm
