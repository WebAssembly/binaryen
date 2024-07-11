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
#include "ir/import-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

static Name MEMORY_BASE("__memory_base");
static Name MEMORY_BASE32("__memory_base32");

struct Memory64Lowering : public WalkerPass<PostWalker<Memory64Lowering>> {

  void wrapAddress64(Expression*& ptr, Name memoryName) {
    if (ptr->type == Type::unreachable) {
      return;
    }
    auto& module = *getModule();
    auto* memory = module.getMemory(memoryName);
    if (memory->is64()) {
      assert(ptr->type == Type::i64);
      ptr = Builder(module).makeUnary(UnaryOp::WrapInt64, ptr);
    }
  }

  void extendAddress64(Expression*& ptr, Name memoryName) {
    if (ptr->type == Type::unreachable) {
      return;
    }
    auto& module = *getModule();
    auto* memory = module.getMemory(memoryName);
    if (memory->is64()) {
      assert(ptr->type == Type::i64);
      ptr->type = Type::i32;
      ptr = Builder(module).makeUnary(UnaryOp::ExtendUInt32, ptr);
    }
  }

  void visitLoad(Load* curr) { wrapAddress64(curr->ptr, curr->memory); }

  void visitStore(Store* curr) { wrapAddress64(curr->ptr, curr->memory); }

  void visitMemorySize(MemorySize* curr) {
    auto& module = *getModule();
    auto* memory = module.getMemory(curr->memory);
    if (memory->is64()) {
      auto* size = static_cast<Expression*>(curr);
      extendAddress64(size, curr->memory);
      curr->type = Type::i32;
      replaceCurrent(size);
    }
  }

  void visitMemoryGrow(MemoryGrow* curr) {
    auto& module = *getModule();
    auto* memory = module.getMemory(curr->memory);
    if (memory->is64()) {
      wrapAddress64(curr->delta, curr->memory);
      auto* size = static_cast<Expression*>(curr);
      // MemoryGrow returns -1 in case of failure.  We cannot just use
      // extend_32_u in this case so we handle it as follows:
      //
      // (if (result i64)
      //  (i32.eq (i32.const -1) (local.tee $tmp (memory.grow X)))
      //  (then
      //   (i64.const -1)
      //  )
      //  (else
      //   (i32.extend_32_u (local.get $tmp))
      //  )
      // )
      Builder builder(module);
      auto tmp = builder.addVar(getFunction(), Type::i32);
      Expression* isMinusOne =
        builder.makeBinary(EqInt32,
                           builder.makeConst(int32_t(-1)),
                           builder.makeLocalTee(tmp, size, Type::i32));
      auto* newSize = builder.makeLocalGet(tmp, Type::i32);
      builder.makeUnary(UnaryOp::ExtendUInt32, newSize);
      Expression* ifExp =
        builder.makeIf(isMinusOne,
                       builder.makeConst(int64_t(-1)),
                       builder.makeUnary(UnaryOp::ExtendUInt32, newSize));
      curr->type = Type::i32;
      replaceCurrent(ifExp);
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

  void visitDataSegment(DataSegment* segment) {
    auto& module = *getModule();

    // passive segments don't have any offset to adjust
    if (segment->isPassive || !module.getMemory(segment->memory)->is64()) {
      return;
    }

    if (auto* c = segment->offset->dynCast<Const>()) {
      c->value = Literal(static_cast<uint32_t>(c->value.geti64()));
      c->type = Type::i32;
    } else if (auto* get = segment->offset->dynCast<GlobalGet>()) {
      auto* g = module.getGlobal(get->name);
      if (g->imported() && g->base == MEMORY_BASE) {
        ImportInfo info(module);
        auto* memoryBase32 = info.getImportedGlobal(g->module, MEMORY_BASE32);
        if (!memoryBase32) {
          Builder builder(module);
          memoryBase32 = builder
                           .makeGlobal(MEMORY_BASE32,
                                       Type::i32,
                                       builder.makeConst(int32_t(0)),
                                       Builder::Immutable)
                           .release();
          memoryBase32->module = g->module;
          memoryBase32->base = MEMORY_BASE32;
          module.addGlobal(memoryBase32);
        }
        // Use this alternative import when initializing the segment.
        assert(memoryBase32);
        get->type = Type::i32;
        get->name = memoryBase32->name;
      }
    } else {
      WASM_UNREACHABLE("unexpected elem offset");
    }
  }

  void run(Module* module) override {
    if (!module->features.has(FeatureSet::Memory64)) {
      return;
    }
    super::run(module);
    // Don't modify the memories themselves until after the traversal since we
    // that would require memories to be the last thing that get visited, and
    // we don't want to depend on that specific ordering.
    for (auto& memory : module->memories) {
      if (memory->is64()) {
        memory->indexType = Type::i32;
        if (memory->hasMax() && memory->max > Memory::kMaxSize32) {
          memory->max = Memory::kMaxSize32;
        }
      }
    }
    module->features.disable(FeatureSet::Memory64);
  }
};

Pass* createMemory64LoweringPass() { return new Memory64Lowering(); }

} // namespace wasm
