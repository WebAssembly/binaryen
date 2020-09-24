/*
 * Copyright 2018 WebAssembly Community Group participants
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

#ifndef wasm_stack_h
#define wasm_stack_h

#include "ir/branch-utils.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-binary.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

// Stack IR: an IR that represents code at the wasm binary format level,
// that is, a stack machine. Binaryen IR is *almost* identical to this,
// but as documented in README.md, there are a few differences, intended
// to make Binaryen IR fast and flexible for maximal optimization. Stack
// IR, on the other hand, is designed to optimize a few final things that
// can only really be done when modeling the stack machine format precisely.

// Currently the benefits of Stack IR are minor, less than 1% reduction in
// code size. For that reason it is just a secondary IR, run optionally
// after the main IR has been optimized. However, if we improve Stack IR
// optimizations to a point where they have a significant impact, it's
// possible that could motivate investigating replacing the main IR with Stack
// IR (so that we have just a single IR).

// A StackIR instance (see wasm.h) contains a linear sequence of
// stack instructions. This representation is very simple: just a single vector
// of all instructions, in order.
//  * nullptr is allowed in the vector, representing something to skip.
//    This is useful as a common thing optimizations do is remove instructions,
//    so this way we can do so without compacting the vector all the time.

// Direct writing binaryen IR to binary is fast. Otherwise, StackIRGenerator
// lets you optimize the Stack IR before emitting stack IR to binary (but the
// cost is that the extra IR in the middle makes things 20% slower than emitting
// binaryen IR to binary directly).

// A Stack IR instruction. Most just directly reflect a Binaryen IR node,
// but we need extra ones for certain things.
class StackInst {
public:
  StackInst(MixedArena&) {}

  enum Op {
    Basic,      // an instruction directly corresponding to a non-control-flow
                // Binaryen IR node
    BlockBegin, // the beginning of a block
    BlockEnd,   // the ending of a block
    IfBegin,    // the beginning of a if
    IfElse,     // the else of a if
    IfEnd,      // the ending of a if
    LoopBegin,  // the beginning of a loop
    LoopEnd,    // the ending of a loop
    TryBegin,   // the beginning of a try
    Catch,      // the catch within a try
    TryEnd      // the ending of a try
  } op;

  Expression* origin; // the expression this originates from

  // the type - usually identical to the origin type, but e.g. wasm has no
  // unreachable blocks, they must be none
  Type type;
};

class BinaryInstWriter : public OverriddenVisitor<BinaryInstWriter> {
public:
  BinaryInstWriter(WasmBinaryWriter& parent,
                   BufferWithRandomAccess& o,
                   Function* func,
                   bool sourceMap,
                   bool DWARF)
    : parent(parent), o(o), func(func), sourceMap(sourceMap), DWARF(DWARF) {}

  void visit(Expression* curr) {
    if (func && !sourceMap) {
      parent.writeDebugLocation(curr, func);
    }
    OverriddenVisitor<BinaryInstWriter>::visit(curr);
    if (func && !sourceMap) {
      parent.writeDebugLocationEnd(curr, func);
    }
  }

  void visitBlock(Block* curr);
  void visitIf(If* curr);
  void visitLoop(Loop* curr);
  void visitBreak(Break* curr);
  void visitSwitch(Switch* curr);
  void visitCall(Call* curr);
  void visitCallIndirect(CallIndirect* curr);
  void visitLocalGet(LocalGet* curr);
  void visitLocalSet(LocalSet* curr);
  void visitGlobalGet(GlobalGet* curr);
  void visitGlobalSet(GlobalSet* curr);
  void visitLoad(Load* curr);
  void visitStore(Store* curr);
  void visitAtomicRMW(AtomicRMW* curr);
  void visitAtomicCmpxchg(AtomicCmpxchg* curr);
  void visitAtomicWait(AtomicWait* curr);
  void visitAtomicNotify(AtomicNotify* curr);
  void visitAtomicFence(AtomicFence* curr);
  void visitSIMDExtract(SIMDExtract* curr);
  void visitSIMDReplace(SIMDReplace* curr);
  void visitSIMDShuffle(SIMDShuffle* curr);
  void visitSIMDTernary(SIMDTernary* curr);
  void visitSIMDShift(SIMDShift* curr);
  void visitSIMDLoad(SIMDLoad* curr);
  void visitMemoryInit(MemoryInit* curr);
  void visitDataDrop(DataDrop* curr);
  void visitMemoryCopy(MemoryCopy* curr);
  void visitMemoryFill(MemoryFill* curr);
  void visitConst(Const* curr);
  void visitUnary(Unary* curr);
  void visitBinary(Binary* curr);
  void visitSelect(Select* curr);
  void visitReturn(Return* curr);
  void visitMemorySize(MemorySize* curr);
  void visitMemoryGrow(MemoryGrow* curr);
  void visitRefNull(RefNull* curr);
  void visitRefIsNull(RefIsNull* curr);
  void visitRefFunc(RefFunc* curr);
  void visitRefEq(RefEq* curr);
  void visitTry(Try* curr);
  void visitThrow(Throw* curr);
  void visitRethrow(Rethrow* curr);
  void visitBrOnExn(BrOnExn* curr);
  void visitNop(Nop* curr);
  void visitUnreachable(Unreachable* curr);
  void visitDrop(Drop* curr);
  void visitPop(Pop* curr);
  void visitTupleMake(TupleMake* curr);
  void visitTupleExtract(TupleExtract* curr);
  void visitI31New(I31New* curr);
  void visitI31Get(I31Get* curr);

  void emitResultType(Type type);
  void emitIfElse(If* curr);
  void emitCatch(Try* curr);
  // emit an end at the end of a block/loop/if/try
  void emitScopeEnd(Expression* curr);
  // emit an end at the end of a function
  void emitFunctionEnd();
  void emitUnreachable();
  void mapLocalsAndEmitHeader();

private:
  void emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset);
  int32_t getBreakIndex(Name name);

  WasmBinaryWriter& parent;
  BufferWithRandomAccess& o;
  Function* func = nullptr;
  bool sourceMap;
  bool DWARF;

  std::vector<Name> breakStack;

  // type => number of locals of that type in the compact form
  std::map<Type, size_t> numLocalsByType;
  // (local index, tuple index) => binary local index
  std::map<std::pair<Index, Index>, size_t> mappedLocals;

  // Keeps track of the binary index of the scratch locals used to lower
  // tuple.extract.
  std::map<Type, Index> scratchLocals;
  void countScratchLocals();
  void setScratchLocals();
};

// Takes binaryen IR and converts it to something else (binary or stack IR)
template<typename SubType>
class BinaryenIRWriter : public Visitor<BinaryenIRWriter<SubType>> {
public:
  BinaryenIRWriter(Function* func) : func(func) {}

  void write();

  // visits a node, emitting the proper code for it
  void visit(Expression* curr);

  void visitBlock(Block* curr);
  void visitIf(If* curr);
  void visitLoop(Loop* curr);
  void visitTry(Try* curr);

protected:
  Function* func = nullptr;

private:
  void emit(Expression* curr) { static_cast<SubType*>(this)->emit(curr); }
  void emitHeader() { static_cast<SubType*>(this)->emitHeader(); }
  void emitIfElse(If* curr) { static_cast<SubType*>(this)->emitIfElse(curr); }
  void emitCatch(Try* curr) { static_cast<SubType*>(this)->emitCatch(curr); }
  void emitScopeEnd(Expression* curr) {
    static_cast<SubType*>(this)->emitScopeEnd(curr);
  }
  void emitFunctionEnd() { static_cast<SubType*>(this)->emitFunctionEnd(); }
  void emitUnreachable() { static_cast<SubType*>(this)->emitUnreachable(); }
  void emitDebugLocation(Expression* curr) {
    static_cast<SubType*>(this)->emitDebugLocation(curr);
  }
  void visitPossibleBlockContents(Expression* curr);
};

template<typename SubType> void BinaryenIRWriter<SubType>::write() {
  assert(func && "BinaryenIRWriter: function is not set");
  emitHeader();
  visitPossibleBlockContents(func->body);
  emitFunctionEnd();
}

// emits a node, but if it is a block with no name, emit a list of its contents
template<typename SubType>
void BinaryenIRWriter<SubType>::visitPossibleBlockContents(Expression* curr) {
  auto* block = curr->dynCast<Block>();
  if (!block || BranchUtils::BranchSeeker::has(block, block->name)) {
    visit(curr);
    return;
  }
  for (auto* child : block->list) {
    visit(child);
    // Since this child was unreachable, either this child or one of its
    // descendants was a source of unreachability that was actually
    // emitted. Subsequent children won't be reachable, so skip them.
    if (child->type == Type::unreachable) {
      break;
    }
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visit(Expression* curr) {
  emitDebugLocation(curr);
  // We emit unreachable instructions that create unreachability, but not
  // unreachable instructions that just inherit unreachability from their
  // children, since the latter won't be reached. This (together with logic in
  // the control flow visitors) also ensures that the final instruction in each
  // unreachable block is a source of unreachability, which means we don't need
  // to emit an extra `unreachable` before the end of the block to prevent type
  // errors.
  bool hasUnreachableChild = false;
  for (auto* child : ValueChildIterator(curr)) {
    visit(child);
    if (child->type == Type::unreachable) {
      hasUnreachableChild = true;
      break;
    }
  }
  if (hasUnreachableChild) {
    // `curr` is not reachable, so don't emit it.
    return;
  }
  // Control flow requires special handling, but most instructions can be
  // emitted directly after their children.
  if (Properties::isControlFlowStructure(curr)) {
    Visitor<BinaryenIRWriter>::visit(curr);
  } else {
    emit(curr);
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitBlock(Block* curr) {
  auto visitChildren = [this](Block* curr, Index from) {
    auto& list = curr->list;
    while (from < list.size()) {
      auto* child = list[from];
      visit(child);
      if (child->type == Type::unreachable) {
        break;
      }
      ++from;
    }
  };

  auto afterChildren = [this](Block* curr) {
    emitScopeEnd(curr);
    if (curr->type == Type::unreachable) {
      // Since this block is unreachable, no instructions will be emitted after
      // it in its enclosing scope. That means that this block will be the last
      // instruction before the end of its parent scope, so its type must match
      // the type of its parent. But we don't have a concrete type for this
      // block and we don't know what type its parent expects, so we can't
      // ensure the types match. To work around this, we insert an `unreachable`
      // instruction after every unreachable control flow structure and depend
      // on its polymorphic behavior to paper over any type mismatches.
      emitUnreachable();
    }
  };

  // Handle very deeply nested blocks in the first position efficiently,
  // avoiding heavy recursion. We only start to do this if we see it will help
  // us (to avoid allocation of the vector).
  if (!curr->list.empty() && curr->list[0]->is<Block>()) {
    std::vector<Block*> parents;
    Block* child;
    while (!curr->list.empty() && (child = curr->list[0]->dynCast<Block>())) {
      parents.push_back(curr);
      emit(curr);
      curr = child;
    }
    // Emit the current block, which does not have a block as a child in the
    // first position.
    emit(curr);
    visitChildren(curr, 0);
    afterChildren(curr);
    bool childUnreachable = curr->type == Type::unreachable;
    // Finish the later parts of all the parent blocks.
    while (!parents.empty()) {
      auto* parent = parents.back();
      parents.pop_back();
      if (!childUnreachable) {
        visitChildren(parent, 1);
      }
      afterChildren(parent);
      childUnreachable = parent->type == Type::unreachable;
    }
    return;
  }
  // Simple case of not having a nested block in the first position.
  emit(curr);
  visitChildren(curr, 0);
  afterChildren(curr);
}

template<typename SubType> void BinaryenIRWriter<SubType>::visitIf(If* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->ifTrue);

  if (curr->ifFalse) {
    emitIfElse(curr);
    visitPossibleBlockContents(curr->ifFalse);
  }

  emitScopeEnd(curr);
  if (curr->type == Type::unreachable) {
    // We already handled the case of the condition being unreachable in
    // `visit`.  Otherwise, we may still be unreachable, if we are an if-else
    // with both sides unreachable. Just like with blocks, we emit an extra
    // `unreachable` to work around potential type mismatches.
    assert(curr->ifFalse);
    emitUnreachable();
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitLoop(Loop* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->body);
  emitScopeEnd(curr);
  if (curr->type == Type::unreachable) {
    // we emitted a loop without a return type, so it must not be consumed
    emitUnreachable();
  }
}

template<typename SubType> void BinaryenIRWriter<SubType>::visitTry(Try* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->body);
  emitCatch(curr);
  visitPossibleBlockContents(curr->catchBody);
  emitScopeEnd(curr);
  if (curr->type == Type::unreachable) {
    emitUnreachable();
  }
}

// Binaryen IR to binary writer
class BinaryenIRToBinaryWriter
  : public BinaryenIRWriter<BinaryenIRToBinaryWriter> {
public:
  BinaryenIRToBinaryWriter(WasmBinaryWriter& parent,
                           BufferWithRandomAccess& o,
                           Function* func = nullptr,
                           bool sourceMap = false,
                           bool DWARF = false)
    : BinaryenIRWriter<BinaryenIRToBinaryWriter>(func), parent(parent),
      writer(parent, o, func, sourceMap, DWARF), sourceMap(sourceMap) {}

  void visit(Expression* curr) {
    BinaryenIRWriter<BinaryenIRToBinaryWriter>::visit(curr);
  }

  void emit(Expression* curr) { writer.visit(curr); }
  void emitHeader() {
    if (func->prologLocation.size()) {
      parent.writeDebugLocation(*func->prologLocation.begin());
    }
    writer.mapLocalsAndEmitHeader();
  }
  void emitIfElse(If* curr) { writer.emitIfElse(curr); }
  void emitCatch(Try* curr) { writer.emitCatch(curr); }
  void emitScopeEnd(Expression* curr) { writer.emitScopeEnd(curr); }
  void emitFunctionEnd() {
    if (func->epilogLocation.size()) {
      parent.writeDebugLocation(*func->epilogLocation.begin());
    }
    writer.emitFunctionEnd();
  }
  void emitUnreachable() { writer.emitUnreachable(); }
  void emitDebugLocation(Expression* curr) {
    if (sourceMap) {
      parent.writeDebugLocation(curr, func);
    }
  }

private:
  WasmBinaryWriter& parent;
  BinaryInstWriter writer;
  bool sourceMap;
};

// Binaryen IR to stack IR converter
// Queues the expressions linearly in Stack IR (SIR)
class StackIRGenerator : public BinaryenIRWriter<StackIRGenerator> {
public:
  StackIRGenerator(Module& module, Function* func)
    : BinaryenIRWriter<StackIRGenerator>(func), module(module) {}

  void emit(Expression* curr);
  void emitScopeEnd(Expression* curr);
  void emitHeader() {}
  void emitIfElse(If* curr) {
    stackIR.push_back(makeStackInst(StackInst::IfElse, curr));
  }
  void emitCatch(Try* curr) {
    stackIR.push_back(makeStackInst(StackInst::Catch, curr));
  }
  void emitFunctionEnd() {}
  void emitUnreachable() {
    stackIR.push_back(makeStackInst(Builder(module).makeUnreachable()));
  }
  void emitDebugLocation(Expression* curr) {}

  StackIR& getStackIR() { return stackIR; }

private:
  StackInst* makeStackInst(StackInst::Op op, Expression* origin);
  StackInst* makeStackInst(Expression* origin) {
    return makeStackInst(StackInst::Basic, origin);
  }

  Module& module;
  StackIR stackIR; // filled in write()
};

// Stack IR to binary writer
class StackIRToBinaryWriter {
public:
  StackIRToBinaryWriter(WasmBinaryWriter& parent,
                        BufferWithRandomAccess& o,
                        Function* func)
    : writer(parent, o, func, false /* sourceMap */, false /* DWARF */),
      func(func) {}

  void write();

private:
  BinaryInstWriter writer;
  Function* func;
};

} // namespace wasm

#endif // wasm_stack_h
