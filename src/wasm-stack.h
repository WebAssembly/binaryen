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
                   Function* func)
    : parent(parent), o(o), func(func) {}

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
  void visitHost(Host* curr);
  void visitTry(Try* curr);
  void visitThrow(Throw* curr);
  void visitRethrow(Rethrow* curr);
  void visitBrOnExn(BrOnExn* curr);
  void visitNop(Nop* curr);
  void visitUnreachable(Unreachable* curr);
  void visitDrop(Drop* curr);
  void visitPush(Push* curr);
  void visitPop(Pop* curr);

  void emitIfElse();
  void emitCatch();
  void emitScopeEnd();    // emit an end at the end of a block/loop/if/try
  void emitFunctionEnd(); // emit an end at the end of a function
  void emitUnreachable();
  void mapLocalsAndEmitHeader();

private:
  void emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset);
  int32_t getBreakIndex(Name name);

  WasmBinaryWriter& parent;
  BufferWithRandomAccess& o;
  Function* func = nullptr;
  std::vector<Name> breakStack;

  // type => number of locals of that type in the compact form
  std::map<Type, size_t> numLocalsByType;
  // local index => index in compact form of [all int32s][all int64s]etc
  std::map<Index, size_t> mappedLocals;
};

// Takes binaryen IR and converts it to something else (binary or stack IR)
template<typename SubType>
class BinaryenIRWriter : public OverriddenVisitor<BinaryenIRWriter<SubType>> {
public:
  BinaryenIRWriter(Function* func) : func(func) {}

  void write();

  // visits a node, emitting the proper code for it
  void visit(Expression* curr);

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
  void visitHost(Host* curr);
  void visitTry(Try* curr);
  void visitThrow(Throw* curr);
  void visitRethrow(Rethrow* curr);
  void visitBrOnExn(BrOnExn* curr);
  void visitNop(Nop* curr);
  void visitUnreachable(Unreachable* curr);
  void visitDrop(Drop* curr);
  void visitPush(Push* curr);
  void visitPop(Pop* curr);

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
  }
  if (block->type == unreachable && block->list.back()->type != unreachable) {
    // similar to in visitBlock, here we could skip emitting the block itself,
    // but must still end the 'block' (the contents, really) with an unreachable
    emitUnreachable();
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visit(Expression* curr) {
  emitDebugLocation(curr);
  OverriddenVisitor<BinaryenIRWriter>::visit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitBlock(Block* curr) {
  auto visitChildren = [this](Block* curr, Index from) {
    auto& list = curr->list;
    while (from < list.size()) {
      visit(list[from++]);
    }
  };

  auto afterChildren = [this](Block* curr) {
    if (curr->type == unreachable) {
      // an unreachable block is one that cannot be exited. We cannot encode
      // this directly in wasm, where blocks must be none,i32,i64,f32,f64. Since
      // the block cannot be exited, we can emit an unreachable at the end, and
      // that will always be valid, and then the block is ok as a none
      emitUnreachable();
    }
    emitScopeEnd(curr);
    if (curr->type == unreachable) {
      // and emit an unreachable *outside* the block too, so later things can
      // pop anything
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
    // Finish the later parts of all the parent blocks.
    while (!parents.empty()) {
      auto* parent = parents.back();
      parents.pop_back();
      visitChildren(parent, 1);
      afterChildren(parent);
    }
    return;
  }
  // Simple case of not having a nested block in the first position.
  emit(curr);
  visitChildren(curr, 0);
  afterChildren(curr);
}

template<typename SubType> void BinaryenIRWriter<SubType>::visitIf(If* curr) {
  visit(curr->condition);
  if (curr->condition->type == unreachable) {
    // this if-else is unreachable because of the condition, i.e., the condition
    // does not exit. So don't emit the if (but do consume the condition)
    emitUnreachable();
    return;
  }
  emit(curr);
  visitPossibleBlockContents(curr->ifTrue);

  if (curr->ifFalse) {
    emitIfElse(curr);
    visitPossibleBlockContents(curr->ifFalse);
  }

  emitScopeEnd(curr);
  if (curr->type == unreachable) {
    // we already handled the case of the condition being unreachable.
    // otherwise, we may still be unreachable, if we are an if-else with both
    // sides unreachable. wasm does not allow this to be emitted directly, so we
    // must do something more. we could do better, but for now we emit an extra
    // unreachable instruction after the if, so it is not consumed itself,
    assert(curr->ifFalse);
    emitUnreachable();
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitLoop(Loop* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->body);
  if (curr->type == unreachable) {
    // we emitted a loop without a return type, and the body might be block
    // contents, so ensure it is not consumed
    emitUnreachable();
  }
  emitScopeEnd(curr);
  if (curr->type == unreachable) {
    // we emitted a loop without a return type, so it must not be consumed
    emitUnreachable();
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitBreak(Break* curr) {
  if (curr->value) {
    visit(curr->value);
  }
  if (curr->condition) {
    visit(curr->condition);
  }
  emit(curr);
  if (curr->condition && curr->type == unreachable) {
    // a br_if is normally none or emits a value. if it is unreachable, then
    // either the condition or the value is unreachable, which is extremely
    // rare, and may require us to make the stack polymorphic (if the block we
    // branch to has a value, we may lack one as we are not a reachable branch;
    // the wasm spec on the other hand does presume the br_if emits a value of
    // the right type, even if it popped unreachable)
    emitUnreachable();
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitSwitch(Switch* curr) {
  if (curr->value) {
    visit(curr->value);
  }
  visit(curr->condition);
  if (!BranchUtils::isBranchReachable(curr)) {
    // if the branch is not reachable, then it's dangerous to emit it, as wasm
    // type checking rules are different, especially in unreachable code. so
    // just don't emit that unreachable code.
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitCall(Call* curr) {
  for (auto* operand : curr->operands) {
    visit(operand);
  }

  // For non-control-flow value-returning instructions, if the type of an
  // expression is unreachable, we emit an unreachable and don't emit the
  // instruction itself. If we don't emit an unreachable, instructions that
  // follow can have a validation failure in wasm binary format. For example:
  // [unreachable] (f32.add
  // [unreachable]   (i32.eqz
  // [unreachable]     (unreachable)
  //                 )
  //                 ...
  //               )
  // This is a valid prgram in binaryen IR, because the unreachable type
  // propagates out of an expression, making both i32.eqz and f32.add
  // unreachable. But in binary format, this becomes:
  // unreachable
  // i32.eqz
  // f32.add       ;; validation failure; it takes an i32!
  // And here f32.add causes validation failure in wasm validation. So in this
  // case we add an unreachable to prevent following instructions to consume
  // the current value (here i32.eqz).
  //
  // The same applies for other expressions.
  if (curr->type == unreachable && !curr->isReturn) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitCallIndirect(CallIndirect* curr) {
  for (auto* operand : curr->operands) {
    visit(operand);
  }
  visit(curr->target);
  if (curr->type == unreachable && !curr->isReturn) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitLocalGet(LocalGet* curr) {
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitLocalSet(LocalSet* curr) {
  visit(curr->value);
  if (curr->isTee() && curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitGlobalGet(GlobalGet* curr) {
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitGlobalSet(GlobalSet* curr) {
  visit(curr->value);
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitLoad(Load* curr) {
  visit(curr->ptr);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitStore(Store* curr) {
  visit(curr->ptr);
  visit(curr->value);
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitAtomicRMW(AtomicRMW* curr) {
  visit(curr->ptr);
  visit(curr->value);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  visit(curr->ptr);
  visit(curr->expected);
  visit(curr->replacement);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitAtomicWait(AtomicWait* curr) {
  visit(curr->ptr);
  visit(curr->expected);
  visit(curr->timeout);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitAtomicNotify(AtomicNotify* curr) {
  visit(curr->ptr);
  visit(curr->notifyCount);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitAtomicFence(AtomicFence* curr) {
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitSIMDExtract(SIMDExtract* curr) {
  visit(curr->vec);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitSIMDReplace(SIMDReplace* curr) {
  visit(curr->vec);
  visit(curr->value);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitSIMDShuffle(SIMDShuffle* curr) {
  visit(curr->left);
  visit(curr->right);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitSIMDTernary(SIMDTernary* curr) {
  visit(curr->a);
  visit(curr->b);
  visit(curr->c);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitSIMDShift(SIMDShift* curr) {
  visit(curr->vec);
  visit(curr->shift);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitSIMDLoad(SIMDLoad* curr) {
  visit(curr->ptr);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitMemoryInit(MemoryInit* curr) {
  visit(curr->dest);
  visit(curr->offset);
  visit(curr->size);
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitDataDrop(DataDrop* curr) {
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitMemoryCopy(MemoryCopy* curr) {
  visit(curr->dest);
  visit(curr->source);
  visit(curr->size);
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitMemoryFill(MemoryFill* curr) {
  visit(curr->dest);
  visit(curr->value);
  visit(curr->size);
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitConst(Const* curr) {
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitUnary(Unary* curr) {
  visit(curr->value);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitBinary(Binary* curr) {
  visit(curr->left);
  visit(curr->right);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitSelect(Select* curr) {
  visit(curr->ifTrue);
  visit(curr->ifFalse);
  visit(curr->condition);
  if (curr->type == unreachable) {
    emitUnreachable();
    return;
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitReturn(Return* curr) {
  if (curr->value) {
    visit(curr->value);
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitHost(Host* curr) {
  switch (curr->op) {
    case MemorySize: {
      break;
    }
    case MemoryGrow: {
      visit(curr->operands[0]);
      break;
    }
  }
  emit(curr);
}

template<typename SubType> void BinaryenIRWriter<SubType>::visitTry(Try* curr) {
  emit(curr);
  visitPossibleBlockContents(curr->body);
  emitCatch(curr);
  visitPossibleBlockContents(curr->catchBody);
  emitScopeEnd(curr);
  if (curr->type == unreachable) {
    emitUnreachable();
  }
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitThrow(Throw* curr) {
  for (auto* operand : curr->operands) {
    visit(operand);
  }
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitRethrow(Rethrow* curr) {
  visit(curr->exnref);
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitBrOnExn(BrOnExn* curr) {
  visit(curr->exnref);
  emit(curr);
  if (curr->type == unreachable) {
    emitUnreachable();
  }
}

template<typename SubType> void BinaryenIRWriter<SubType>::visitNop(Nop* curr) {
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitUnreachable(Unreachable* curr) {
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitDrop(Drop* curr) {
  visit(curr->value);
  emit(curr);
}

template<typename SubType>
void BinaryenIRWriter<SubType>::visitPush(Push* curr) {
  // Turns into nothing in the binary format: leave the child on the stack for
  // others to use.
  visit(curr->value);
}

template<typename SubType> void BinaryenIRWriter<SubType>::visitPop(Pop* curr) {
  // Turns into nothing in the binary format: just get a value that is already
  // on the stack.
}

// Binaryen IR to binary writer
class BinaryenIRToBinaryWriter
  : public BinaryenIRWriter<BinaryenIRToBinaryWriter> {
public:
  BinaryenIRToBinaryWriter(WasmBinaryWriter& parent,
                           BufferWithRandomAccess& o,
                           Function* func = nullptr,
                           bool sourceMap = false)
    : BinaryenIRWriter<BinaryenIRToBinaryWriter>(func), parent(parent),
      writer(parent, o, func), sourceMap(sourceMap) {}

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
  void emitIfElse(If* curr) { writer.emitIfElse(); }
  void emitCatch(Try* curr) { writer.emitCatch(); }
  void emitScopeEnd(Expression* curr) { writer.emitScopeEnd(); }
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
  bool sourceMap = false;
};

// Binaryen IR to stack IR converter
// Queues the expressions linearly in Stack IR (SIR)
class StackIRGenerator : public BinaryenIRWriter<StackIRGenerator> {
public:
  StackIRGenerator(MixedArena& allocator, Function* func)
    : BinaryenIRWriter<StackIRGenerator>(func), allocator(allocator) {}

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
    stackIR.push_back(makeStackInst(Builder(allocator).makeUnreachable()));
  }
  void emitDebugLocation(Expression* curr) {}

  StackIR& getStackIR() { return stackIR; }

private:
  StackInst* makeStackInst(StackInst::Op op, Expression* origin);
  StackInst* makeStackInst(Expression* origin) {
    return makeStackInst(StackInst::Basic, origin);
  }

  MixedArena& allocator;
  StackIR stackIR; // filled in write()
};

// Stack IR to binary writer
class StackIRToBinaryWriter {
public:
  StackIRToBinaryWriter(WasmBinaryWriter& parent,
                        BufferWithRandomAccess& o,
                        Function* func)
    : writer(parent, o, func), func(func) {}

  void write();

private:
  BinaryInstWriter writer;
  Function* func;
};

} // namespace wasm

#endif // wasm_stack_h
