#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

// Replace memory.copy and memory.fill with a call to a function that
// implements the same semantics.

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
    // In order to introduce a call to a function, it must first exist, so create an empty stub.
    Builder b(*module);
    auto memCpyFunc = b.makeFunction("__memory_copy",
      Signature({Type::i32, Type::i32, Type::i32}, {Type::none}), {Type::i32});
    memCpyFunc->body = b.makeBlock();
    module->addFunction(memCpyFunc.release());
    auto memFillFunc = b.makeFunction("__memory_fill",
      Signature({Type::i32, Type::i32, Type::i32}, {Type::none}), {});
    memFillFunc->body = b.makeBlock();
    module->addFunction(memFillFunc.release());

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
      body->list.push_back(b.makeBlock("out",
        b.makeLoop("copy", b.makeBlock({
          // break if dst == temp
          b.makeBreak("out", nullptr,
            b.makeBinary(BinaryOp::EqInt32,
              b.makeLocalGet(dst, Type::i32),
              b.makeLocalGet(temp, Type::i32))),
          // --dst; --src;
          b.makeLocalSet(dst, 
            b.makeBinary(BinaryOp::SubInt32, b.makeLocalGet(dst, Type::i32), b.makeConst(1))),
          b.makeLocalSet(src,
            b.makeBinary(BinaryOp::SubInt32, b.makeLocalGet(src, Type::i32), b.makeConst(1))),
          // *dst = *src
          b.makeStore(1, 0, 1, b.makeLocalGet(dst, Type::i32),
            b.makeLoad(1, false, 0, 1,
              b.makeLocalGet(src, Type::i32), Type::i32, memory), Type::i32, memory)
        }))
      ));
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
       br_if (i32.eq(local.get $dst, local.get $temp)
       i32.store8(local.get $dst, i32.load8_u(get_local $src))
       local.set($dst, i32.sub(local.get($dst), i32.const 1))
       local.set($src, i32.sub(local.get($src), i32.const 1))
      )
      */
    } else {
      module->removeFunction("__memory_copy");
    }

    if (needsMemoryFill) {
      Index dst = 0, val = 1, size = 2;
      Name memory = module->memories.front()->name;
      Block* body = b.makeBlock();

      // if dst + size > memsize in bytes, then trap.
      body->list.push_back(
        b.makeIf(
          b.makeBinary(BinaryOp::GtUInt32,
            b.makeBinary(BinaryOp::AddInt32,
              b.makeLocalGet(dst, Type::i32), b.makeLocalGet(size, Type::i32)),
            b.makeBinary(BinaryOp::MulInt32,
              b.makeMemorySize(memory),
              b.makeConst(Memory::kPageSize))),
          b.makeUnreachable()));

      body->list.push_back(b.makeBlock("out", b.makeLoop("copy", b.makeBlock({
        // break if size == 0
        b.makeBreak("out", nullptr, b.makeLocalGet(size, Type::i32)),
        // size--
        b.makeLocalSet(size,
          b.makeBinary(BinaryOp::SubInt32,
            b.makeLocalGet(size, Type::i32), b.makeConst(1))),
        // *(dst+size) = val
        b.makeStore(1, 0, 1,
          b.makeBinary(BinaryOp::AddInt32,
            b.makeLocalGet(dst, Type::i32), b.makeLocalGet(size, Type::i32)),
          b.makeLocalGet(val, Type::i32),
          Type::i32, memory)
        })))
      );
      module->getFunction("__memory_fill")->body = body;
     /*
     if (
      i32.ugt(i32.add(local.get $dst, local.get $size))), i32.mul(memory.size 0, i32.const 65536))
     ) then unreachable
     loop (
      local.set($size, i32.sub((local.get $size), (i32.const 1))
      br_if (local.get $size))
      i32.store8((i32.add((local.get $dst), (local.get $size), (local.get $val))     )
     */
    } else {
      module->removeFunction("__memory_fill");
    }
    module->features.disable(FeatureSet::BulkMemory);
  }
};

Pass* createMemoryCopyFillLoweringPass() {
  return new MemoryCopyFillLowering();
}

} // namespace wasm
