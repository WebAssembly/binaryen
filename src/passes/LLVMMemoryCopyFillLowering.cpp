/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "ir/names.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

// Replace memory.copy and memory.fill with a call to a function that
// implements the same semantics. This is intended to be used with LLVM output,
// so anything considered undefined behavior in LLVM is ignored. (In
// particular, pointer overflow is UB and not handled here).

namespace wasm {
struct LLVMMemoryCopyFillLowering
  : public WalkerPass<PostWalker<LLVMMemoryCopyFillLowering>> {
  bool needsMemoryCopy = false;
  bool needsMemoryFill = false;
  Name memCopyFuncName;
  Name memFillFuncName;

  void visitMemoryCopy(MemoryCopy* curr) {
    assert(curr->destMemory ==
           curr->sourceMemory); // multi-memory not supported.
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(
      "__memory_copy", {curr->dest, curr->source, curr->size}, Type::none));
    needsMemoryCopy = true;
  }

  void visitMemoryFill(MemoryFill* curr) {
    Builder builder(*getModule());
    replaceCurrent(builder.makeCall(
      "__memory_fill", {curr->dest, curr->value, curr->size}, Type::none));
    needsMemoryFill = true;
  }

  void run(Module* module) override {
    if (!module->features.hasBulkMemoryOpt()) {
      return;
    }
    if (module->features.hasMemory64() || module->features.hasMultiMemory()) {
      Fatal()
        << "Memory64 and multi-memory not supported by memory.copy lowering";
    }

    // Check for the presence of any passive data or table segments.
    for (auto& segment : module->dataSegments) {
      if (segment->isPassive) {
        Fatal() << "memory.copy lowering should only be run on modules with "
                   "no passive segments";
      }
    }
    for (auto& segment : module->elementSegments) {
      if (!segment->table.is()) {
        Fatal() << "memory.copy lowering should only be run on modules with"
                   " no passive segments";
      }
    }
    // Since there are no passive segments, we can remove the feature. This also
    // causes Binaryen to not encode a DataCount section.
    module->features.setBulkMemory(false);

    // In order to introduce a call to a function, it must first exist, so
    // create an empty stub.
    Builder b(*module);

    memCopyFuncName = Names::getValidFunctionName(*module, "__memory_copy");
    memFillFuncName = Names::getValidFunctionName(*module, "__memory_fill");
    auto memCopyFunc = b.makeFunction(
      memCopyFuncName,
      {{"dst", Type::i32}, {"src", Type::i32}, {"size", Type::i32}},
      Signature({Type::i32, Type::i32, Type::i32}, {Type::none}),
      {{"start", Type::i32},
       {"end", Type::i32},
       {"step", Type::i32},
       {"i", Type::i32}});
    memCopyFunc->body = b.makeBlock();
    module->addFunction(memCopyFunc.release());
    auto memFillFunc = b.makeFunction(
      memFillFuncName,
      {{"dst", Type::i32}, {"val", Type::i32}, {"size", Type::i32}},
      Signature({Type::i32, Type::i32, Type::i32}, {Type::none}),
      {});
    memFillFunc->body = b.makeBlock();
    module->addFunction(memFillFunc.release());

    Super::run(module);

    if (needsMemoryCopy) {
      createMemoryCopyFunc(module);
    } else {
      module->removeFunction(memCopyFuncName);
    }

    if (needsMemoryFill) {
      createMemoryFillFunc(module);
    } else {
      module->removeFunction(memFillFuncName);
    }
    module->features.setBulkMemoryOpt(false);
  }

  void createMemoryCopyFunc(Module* module) {
    Builder b(*module);
    Index dst = 0, src = 1, size = 2, start = 3, end = 4, step = 5, i = 6;
    Name memory = module->memories.front()->name;
    Block* body = b.makeBlock();
    // end = memory size in bytes
    body->list.push_back(
      b.makeLocalSet(end,
                     b.makeBinary(BinaryOp::MulInt32,
                                  b.makeMemorySize(memory),
                                  b.makeConst(Memory::kPageSize))));
    // if dst + size > memsize or src + size > memsize, then trap.
    body->list.push_back(b.makeIf(
      b.makeBinary(BinaryOp::OrInt32,
                   b.makeBinary(BinaryOp::GtUInt32,
                                b.makeBinary(BinaryOp::AddInt32,
                                             b.makeLocalGet(dst, Type::i32),
                                             b.makeLocalGet(size, Type::i32)),
                                b.makeLocalGet(end, Type::i32)),
                   b.makeBinary(BinaryOp::GtUInt32,
                                b.makeBinary(BinaryOp::AddInt32,
                                             b.makeLocalGet(src, Type::i32),
                                             b.makeLocalGet(size, Type::i32)),
                                b.makeLocalGet(end, Type::i32))),
      b.makeUnreachable()));
    // start and end are the starting and past-the-end indexes
    // if src < dest: start = size - 1, end = -1, step = -1
    // else: start = 0, end = size, step = 1
    body->list.push_back(
      b.makeIf(b.makeBinary(BinaryOp::LtUInt32,
                            b.makeLocalGet(src, Type::i32),
                            b.makeLocalGet(dst, Type::i32)),
               b.makeBlock({
                 b.makeLocalSet(start,
                                b.makeBinary(BinaryOp::SubInt32,
                                             b.makeLocalGet(size, Type::i32),
                                             b.makeConst(1))),
                 b.makeLocalSet(end, b.makeConst(-1U)),
                 b.makeLocalSet(step, b.makeConst(-1U)),
               }),
               b.makeBlock({
                 b.makeLocalSet(start, b.makeConst(0)),
                 b.makeLocalSet(end, b.makeLocalGet(size, Type::i32)),
                 b.makeLocalSet(step, b.makeConst(1)),
               })));
    // i = start
    body->list.push_back(b.makeLocalSet(i, b.makeLocalGet(start, Type::i32)));
    body->list.push_back(b.makeBlock(
      "out",
      b.makeLoop(
        "copy",
        b.makeBlock(
          {// break if i == end
           b.makeBreak("out",
                       nullptr,
                       b.makeBinary(BinaryOp::EqInt32,
                                    b.makeLocalGet(i, Type::i32),
                                    b.makeLocalGet(end, Type::i32))),
           // dst[i] = src[i]
           b.makeStore(1,
                       0,
                       1,
                       b.makeBinary(BinaryOp::AddInt32,
                                    b.makeLocalGet(dst, Type::i32),
                                    b.makeLocalGet(i, Type::i32)),
                       b.makeLoad(1,
                                  false,
                                  0,
                                  1,
                                  b.makeBinary(BinaryOp::AddInt32,
                                               b.makeLocalGet(src, Type::i32),
                                               b.makeLocalGet(i, Type::i32)),
                                  Type::i32,
                                  memory),
                       Type::i32,
                       memory),
           // i += step
           b.makeLocalSet(i,
                          b.makeBinary(BinaryOp::AddInt32,
                                       b.makeLocalGet(i, Type::i32),
                                       b.makeLocalGet(step, Type::i32))),
           // loop
           b.makeBreak("copy", nullptr)}))));
    module->getFunction(memCopyFuncName)->body = body;
  }

  void createMemoryFillFunc(Module* module) {
    Builder b(*module);
    Index dst = 0, val = 1, size = 2;
    Name memory = module->memories.front()->name;
    Block* body = b.makeBlock();

    // if dst + size > memsize in bytes, then trap.
    body->list.push_back(
      b.makeIf(b.makeBinary(BinaryOp::GtUInt32,
                            b.makeBinary(BinaryOp::AddInt32,
                                         b.makeLocalGet(dst, Type::i32),
                                         b.makeLocalGet(size, Type::i32)),
                            b.makeBinary(BinaryOp::MulInt32,
                                         b.makeMemorySize(memory),
                                         b.makeConst(Memory::kPageSize))),
               b.makeUnreachable()));

    body->list.push_back(b.makeBlock(
      "out",
      b.makeLoop(
        "copy",
        b.makeBlock(
          {// break if size == 0
           b.makeBreak(
             "out",
             nullptr,
             b.makeUnary(UnaryOp::EqZInt32, b.makeLocalGet(size, Type::i32))),
           // size--
           b.makeLocalSet(size,
                          b.makeBinary(BinaryOp::SubInt32,
                                       b.makeLocalGet(size, Type::i32),
                                       b.makeConst(1))),
           // *(dst+size) = val
           b.makeStore(1,
                       0,
                       1,
                       b.makeBinary(BinaryOp::AddInt32,
                                    b.makeLocalGet(dst, Type::i32),
                                    b.makeLocalGet(size, Type::i32)),
                       b.makeLocalGet(val, Type::i32),
                       Type::i32,
                       memory),
           b.makeBreak("copy", nullptr)}))));
    module->getFunction(memFillFuncName)->body = body;
  }

  void VisitTableCopy(TableCopy* curr) {
    Fatal() << "table.copy instruction found. Memory copy lowering is not "
               "designed to work on modules with bulk table operations";
  }
  void VisitTableFill(TableCopy* curr) {
    Fatal() << "table.fill instruction found. Memory copy lowering is not "
               "designed to work on modules with bulk table operations";
  }
};

Pass* createLLVMMemoryCopyFillLoweringPass() {
  return new LLVMMemoryCopyFillLowering();
}

} // namespace wasm
