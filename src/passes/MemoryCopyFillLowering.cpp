#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"
#include <limits>

// By default LLVM emits nontrapping float-to-int instructions to implement its
// fptoui/fptosi conversion instructions. This pass replaces these instructions
// with code sequences which also implement LLVM's fptoui/fptosi, but which are
// not semantically equivalent in wasm. This is because out-of-range inputs to
// these instructions produce poison values. So we need only ensure that there
// is no trap, but need not ensure any particular result.

namespace wasm {
struct MemoryCopyFillLowering
  : public WalkerPass<PostWalker<MemoryCopyFillLowering>> {
  bool needsMemoryCopy = false;
  bool needsMemoryFill = false;

  void visitMemoryCopy(MemoryCopy* curr) {
    if (curr->destMemory != curr->sourceMemory) {
      return; // Throw an error here instead of silently ignoring?
    }
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(
        "__memory_copy", {curr->dest, curr->source, curr->size},
        Type::none));
    needsMemoryCopy = true;
  }

  void visitMemoryFill(MemoryFill* curr) {
    if (curr->memory != "what's the default name of the memory?") {
        return;
    }
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(
        "__memory_fill", {curr->dest, curr->value, curr->size}, Type::none)
    );
    needsMemoryFill = true;
  }

  void run(Module* module) override {
    if (!module->features.hasBulkMemory()) {
      return;
    }
    if (module->features.hasMemory64() || module->features.hasMultiMemory()) {
      throw "Memory64 and multi-memory not supported";// TODO: best way to return an error?
    }
    Builder b(*module);
    auto memCpyFunc = b.makeFunction("__memory_copy", 
      Signature({Type::i32, Type::i32, Type::i32}, {Type::none}), {Type::i32});
    memCpyFunc->body = b.makeBlock();
    module->addFunction(memCpyFunc.release());
    
    Super::run(module);
    if (needsMemoryCopy) {
      Index dst = 0, src = 1, size = 2, temp = 3;
      Name memory = module->memories.front()->name;
      Block* body = b.makeBlock();
      // temp = memory size in bytes
      body->list.push_back(b.makeLocalSet(temp,
        b.makeBinary(BinaryOp::MulInt32,
          b.makeMemorySize(memory), 
          b.makeConst(Memory::kPageSize))));
      // if dst + size > memsize or src + size > memsize, then trap.
      body->list.push_back(
        b.makeIf(
          b.makeBinary(BinaryOp::OrInt32,
            b.makeBinary(BinaryOp::GtUInt32, 
              b.makeBinary(BinaryOp::AddInt32,                    
                b.makeLocalGet(dst, Type::i32), b.makeLocalGet(size, Type::i32)),
              b.makeLocalGet(temp, Type::i32)),
            b.makeBinary(BinaryOp::GtUInt32, 
              b.makeBinary(BinaryOp::AddInt32,                    
                b.makeLocalGet(src, Type::i32), b.makeLocalGet(size, Type::i32)),
              b.makeLocalGet(temp, Type::i32))),
        b.makeUnreachable())
      );
      // temp = dst
      body->list.push_back(b.makeLocalSet(temp, b.makeLocalGet(dst, Type::i32)));
      // dst = dst + size
      body->list.push_back(
        b.makeLocalSet(dst,
          b.makeBinary(BinaryOp::AddInt32,
            b.makeLocalGet(dst, Type::i32),
            b.makeLocalGet(size, Type::i32))));
      // src = src + size
      body->list.push_back(
        b.makeLocalSet(src,
          b.makeBinary(BinaryOp::AddInt32,
            b.makeLocalGet(src, Type::i32),
            b.makeLocalGet(size, Type::i32))));
      // loop (
      body->list.push_back(
        b.makeLoop("copy", b.makeBlock({
          // if dst > temp, then break
          b.makeBreak("copy", nullptr,
            b.makeBinary(BinaryOp::GeUInt32,
              b.makeLocalGet(dst, Type::i32),
              b.makeLocalGet(temp, Type::i32))),
          b.makeStore(1, 0, 1, b.makeLocalGet(dst, Type::i32),
            b.makeLoad(1, false, 0, 1,
              b.makeLocalGet(src, Type::i32), Type::i32, memory), Type::i32, memory),
          b.makeLocalSet(dst, 
            b.makeBinary(BinaryOp::SubInt32, b.makeLocalGet(dst, Type::i32), b.makeConst(1))),
          b.makeLocalSet(src,
            b.makeBinary(BinaryOp::SubInt32, b.makeLocalGet(src, Type::i32), b.makeConst(1)))
        }))
      );
      module->getFunction("__memory_copy")->body = body;
  
      /*
      local.set($temp, i32.mul(memory.size 0, i32.const 65536))
      if (
        i32.or(
          i32.ugt(i32.add(local.get $src, local.get $size), local.get $temp),
          i32.ugt(i32.add(local.get $dst, local.get $size), local.get $temp),
        )
      ) then unreachable
      local.set($temp, local.get $dst)
      local.set($dst, i32.add(local.get $dst, local.get $size))
      local.set($src, i32.add(local.get $src, local.get $size))
      loop (
       br_if (i32.uge(local.get $dst, local.get $temp)
       i32.store(local.get $dst, i32.load(get_local $src))
       local.set($dst, i32.sub(local.get($dst), i32.const 1))
       local.set($src, i32.sub(local.get($src), i32.const 1))
      )
      */
    } else {
      module->removeFunction("__memory_copy");
    }
    module->features.disable(FeatureSet::BulkMemory);
  }
};

Pass* createMemoryCopyFillLoweringPass() {
  return new MemoryCopyFillLowering();
}

} // namespace wasm
