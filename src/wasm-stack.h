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

#include "wasm.h"
#include "wasm-binary.h"
#include "wasm-traversal.h"
#include "ir/branch-utils.h"
#include "pass.h"

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
// stack instructions. This representation is very simple: just a single vector of
// all instructions, in order.
//  * nullptr is allowed in the vector, representing something to skip.
//    This is useful as a common thing optimizations do is remove instructions,
//    so this way we can do so without compacting the vector all the time.

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
  } op;

  Expression* origin; // the expression this originates from

  Type type; // the type - usually identical to the origin type, but
                 // e.g. wasm has no unreachable blocks, they must be none
};

//
// StackWriter: Writes out binary format stack machine code for a Binaryen IR expression
//
// A stack writer has one of three modes:
//  * Binaryen2Binary: directly writes the expression to wasm binary
//  * Binaryen2Stack: queues the expressions linearly, in Stack IR (SIR)
//  * Stack2Binary: emits SIR to wasm binary
//
// Direct writing, in Binaryen2Binary, is fast. Otherwise, Binaryen2Stack
// lets you optimize the Stack IR before running Stack2Binary (but the cost
// is that the extra IR in the middle makes things 20% slower than direct
// Binaryen2Binary).
//
// To reduce the amount of boilerplate code here, we implement all 3 in
// a single class, templated on the mode. This allows compilers to trivially
// optimize out irrelevant code paths, and there should be no runtime
// downside.
//

enum class StackWriterMode {
  Binaryen2Binary, Binaryen2Stack, Stack2Binary
};

template<StackWriterMode Mode, typename Parent>
class StackWriter : public Visitor<StackWriter<Mode, Parent>> {
public:
  StackWriter(Parent& parent, BufferWithRandomAccess& o, bool sourceMap=false, bool debug=false)
    : parent(parent), o(o), sourceMap(sourceMap), debug(debug), allocator(parent.getModule()->allocator) {}

  StackIR stackIR; // filled in Binaryen2Stack, read in Stack2Binary

  std::map<Type, size_t> numLocalsByType; // type => number of locals of that type in the compact form

  // visits a node, emitting the proper code for it
  void visit(Expression* curr);
  // emits a node, but if it is a block with no name, emit a list of its contents
  void visitPossibleBlockContents(Expression* curr);
  // visits a child node. (in some modes we may not want to visit children,
  // that logic is handled here)
  void visitChild(Expression* curr);

  void visitBlock(Block* curr);
  void visitBlockEnd(Block* curr);

  void visitIf(If* curr);
  void visitIfElse(If* curr);
  void visitIfEnd(If* curr);

  void visitLoop(Loop* curr);
  void visitLoopEnd(Loop* curr);

  void visitBreak(Break* curr);
  void visitSwitch(Switch* curr);
  void visitCall(Call* curr);
  void visitCallIndirect(CallIndirect* curr);
  void visitGetLocal(GetLocal* curr);
  void visitSetLocal(SetLocal* curr);
  void visitGetGlobal(GetGlobal* curr);
  void visitSetGlobal(SetGlobal* curr);
  void visitLoad(Load* curr);
  void visitStore(Store* curr);
  void visitAtomicRMW(AtomicRMW* curr);
  void visitAtomicCmpxchg(AtomicCmpxchg* curr);
  void visitAtomicWait(AtomicWait* curr);
  void visitAtomicNotify(AtomicNotify* curr);
  void visitSIMDExtract(SIMDExtract* curr);
  void visitSIMDReplace(SIMDReplace* curr);
  void visitSIMDShuffle(SIMDShuffle* curr);
  void visitSIMDBitselect(SIMDBitselect* curr);
  void visitSIMDShift(SIMDShift* curr);
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
  void visitNop(Nop* curr);
  void visitUnreachable(Unreachable* curr);
  void visitDrop(Drop* curr);

  // We need to emit extra unreachable opcodes in some cases
  void emitExtraUnreachable();

  // If we are in Binaryen2Stack, then this adds the item to the
  // stack IR and returns true, which is all we need to do for
  // non-control flow expressions.
  bool justAddToStack(Expression* curr);

  void setFunction(Function* funcInit) {
    func = funcInit;
  }

  void mapLocalsAndEmitHeader();

protected:
  Parent& parent;
  BufferWithRandomAccess& o;
  bool sourceMap;
  bool debug;

  MixedArena& allocator;

  Function* func;

  std::map<Index, size_t> mappedLocals; // local index => index in compact form of [all int32s][all int64s]etc

  std::vector<Name> breakStack;

  int32_t getBreakIndex(Name name);
  void emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset);

  void finishFunctionBody();

  StackInst* makeStackInst(StackInst::Op op, Expression* origin);
  StackInst* makeStackInst(Expression* origin) {
    return makeStackInst(StackInst::Basic, origin);
  }
};

// Write out a single expression, such as an offset for a global segment.
template<typename Parent>
class ExpressionStackWriter : StackWriter<StackWriterMode::Binaryen2Binary, Parent> {
public:
  ExpressionStackWriter(Expression* curr, Parent& parent, BufferWithRandomAccess& o, bool debug=false) :
    StackWriter<StackWriterMode::Binaryen2Binary, Parent>(parent, o, /* sourceMap= */ false, debug) {
    this->visit(curr);
  }
};

// Write out a function body, including the local header info.
template<typename Parent>
class FunctionStackWriter : StackWriter<StackWriterMode::Binaryen2Binary, Parent> {
public:
  FunctionStackWriter(Function* funcInit, Parent& parent, BufferWithRandomAccess& o, bool sourceMap=false, bool debug=false) :
    StackWriter<StackWriterMode::Binaryen2Binary, Parent>(parent, o, sourceMap, debug) {
    this->setFunction(funcInit);
    this->mapLocalsAndEmitHeader();
    this->visitPossibleBlockContents(this->func->body);
    this->finishFunctionBody();
  }
};

// Use Stack IR to write the function body
template<typename Parent>
class StackIRFunctionStackWriter : StackWriter<StackWriterMode::Stack2Binary, Parent> {
public:
  StackIRFunctionStackWriter(Function* funcInit, Parent& parent, BufferWithRandomAccess& o, bool debug=false) :
    StackWriter<StackWriterMode::Stack2Binary, Parent>(parent, o, false, debug) {
    this->setFunction(funcInit);
    this->mapLocalsAndEmitHeader();
    for (auto* inst : *funcInit->stackIR) {
      if (!inst) continue; // a nullptr is just something we can skip
      switch (inst->op) {
        case StackInst::Basic:
        case StackInst::BlockBegin:
        case StackInst::IfBegin:
        case StackInst::LoopBegin: {
          this->visit(inst->origin);
          break;
        }
        case StackInst::BlockEnd: {
          this->visitBlockEnd(inst->origin->template cast<Block>());
          break;
        }
        case StackInst::IfElse: {
          this->visitIfElse(inst->origin->template cast<If>());
          break;
        }
        case StackInst::IfEnd: {
          this->visitIfEnd(inst->origin->template cast<If>());
          break;
        }
        case StackInst::LoopEnd: {
          this->visitLoopEnd(inst->origin->template cast<Loop>());
          break;
        }
        default: WASM_UNREACHABLE();
      }
    }
    this->finishFunctionBody();
  }
};

//
// Implementations
//

// StackWriter

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::mapLocalsAndEmitHeader() {
  if (func->prologLocation.size()) {
    parent.writeDebugLocation(*func->prologLocation.begin());
  }
  // Map them
  for (Index i = 0; i < func->getNumParams(); i++) {
    size_t curr = mappedLocals.size();
    mappedLocals[i] = curr;
  }
  for (auto type : func->vars) {
    numLocalsByType[type]++;
  }
  std::map<Type, size_t> currLocalsByType;
  for (Index i = func->getVarIndexBase(); i < func->getNumLocals(); i++) {
    size_t index = func->getVarIndexBase();
    Type type = func->getLocalType(i);
    currLocalsByType[type]++; // increment now for simplicity, must decrement it in returns
    if (type == i32) {
      mappedLocals[i] = index + currLocalsByType[i32] - 1;
      continue;
    }
    index += numLocalsByType[i32];
    if (type == i64) {
      mappedLocals[i] = index + currLocalsByType[i64] - 1;
      continue;
    }
    index += numLocalsByType[i64];
    if (type == f32) {
      mappedLocals[i] = index + currLocalsByType[f32] - 1;
      continue;
    }
    index += numLocalsByType[f32];
    if (type == f64) {
      mappedLocals[i] = index + currLocalsByType[f64] - 1;
      continue;
    }
    index += numLocalsByType[f64];
    if (type == v128) {
      mappedLocals[i] = index + currLocalsByType[v128] - 1;
      continue;
    }
    WASM_UNREACHABLE();
  }
  // Emit them.
  o << U32LEB(
      (numLocalsByType[i32] ? 1 : 0) +
      (numLocalsByType[i64] ? 1 : 0) +
      (numLocalsByType[f32] ? 1 : 0) +
      (numLocalsByType[f64] ? 1 : 0) +
      (numLocalsByType[v128] ? 1 : 0)
              );
  if (numLocalsByType[i32]) o << U32LEB(numLocalsByType[i32]) << binaryType(i32);
  if (numLocalsByType[i64]) o << U32LEB(numLocalsByType[i64]) << binaryType(i64);
  if (numLocalsByType[f32]) o << U32LEB(numLocalsByType[f32]) << binaryType(f32);
  if (numLocalsByType[f64]) o << U32LEB(numLocalsByType[f64]) << binaryType(f64);
  if (numLocalsByType[v128]) o << U32LEB(numLocalsByType[v128]) << binaryType(v128);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visit(Expression* curr) {
  if (Mode == StackWriterMode::Binaryen2Binary && sourceMap) {
    parent.writeDebugLocation(curr, func);
  }
  Visitor<StackWriter>::visit(curr);
}

// emits a node, but if it is a block with no name, emit a list of its contents
template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitPossibleBlockContents(Expression* curr) {
  auto* block = curr->dynCast<Block>();
  if (!block || BranchUtils::BranchSeeker::hasNamed(block, block->name)) {
    visitChild(curr);
    return;
  }
  for (auto* child : block->list) {
    visitChild(child);
  }
  if (block->type == unreachable && block->list.back()->type != unreachable) {
    // similar to in visitBlock, here we could skip emitting the block itself,
    // but must still end the 'block' (the contents, really) with an unreachable
    emitExtraUnreachable();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitChild(Expression* curr) {
  // In stack => binary, we don't need to visit child nodes, everything
  // is already in the linear stream.
  if (Mode != StackWriterMode::Stack2Binary) {
    visit(curr);
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitBlock(Block* curr) {
  auto tilChildren = [this](Block* curr) {
    if (Mode == StackWriterMode::Binaryen2Stack) {
      stackIR.push_back(makeStackInst(StackInst::BlockBegin, curr));
    } else {
      o << int8_t(BinaryConsts::Block);
      o << binaryType(curr->type != unreachable ? curr->type : none);
    }
    breakStack.push_back(curr->name); // TODO: we don't need to do this in Binaryen2Stack
  };
  auto visitChildren = [this](Block* curr, Index from) {
    auto& list = curr->list;
    while (from < list.size()) {
      visitChild(list[from++]);
    }
  };
  auto afterChildren = [this](Block* curr) {
    // in Stack2Binary the block ending is in the stream later on
    if (Mode != StackWriterMode::Stack2Binary) {
      visitBlockEnd(curr);
    }
  };
  // Handle very deeply nested blocks in the first position efficiently,
  // avoiding heavy recursion.
  // We only start to do this if we see it will help us (to avoid allocation
  // of the vector).
  // Note that Stack2Binary mode we don't need to visit children anyhow, so
  // we don't need this optimization.
  if (Mode != StackWriterMode::Stack2Binary) {
    if (!curr->list.empty() && curr->list[0]->is<Block>()) {
      std::vector<Block*> parents;
      Block* child;
      while (!curr->list.empty() &&
             (child = curr->list[0]->dynCast<Block>())) {
        parents.push_back(curr);
        tilChildren(curr);
        curr = child;
      }
      // Emit the current block, which does not have a block as
      // a child in the first position.
      tilChildren(curr);
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
  }
  // Simple case of not having a nested block in the first position.
  tilChildren(curr);
  visitChildren(curr, 0);
  afterChildren(curr);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitBlockEnd(Block* curr) {
  if (curr->type == unreachable) {
    // an unreachable block is one that cannot be exited. We cannot encode this directly
    // in wasm, where blocks must be none,i32,i64,f32,f64. Since the block cannot be
    // exited, we can emit an unreachable at the end, and that will always be valid,
    // and then the block is ok as a none
    emitExtraUnreachable();
  }
  if (Mode == StackWriterMode::Binaryen2Stack) {
    stackIR.push_back(makeStackInst(StackInst::BlockEnd, curr));
  } else {
    o << int8_t(BinaryConsts::End);
  }
  assert(!breakStack.empty());
  breakStack.pop_back();
  if (curr->type == unreachable) {
    // and emit an unreachable *outside* the block too, so later things can pop anything
    emitExtraUnreachable();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitIf(If* curr) {
  if (curr->condition->type == unreachable) {
    // this if-else is unreachable because of the condition, i.e., the condition
    // does not exit. So don't emit the if, but do consume the condition
    visitChild(curr->condition);
    emitExtraUnreachable();
    return;
  }
  visitChild(curr->condition);
  if (Mode == StackWriterMode::Binaryen2Stack) {
    stackIR.push_back(makeStackInst(StackInst::IfBegin, curr));
  } else {
    o << int8_t(BinaryConsts::If);
    o << binaryType(curr->type != unreachable ? curr->type : none);
  }
  breakStack.push_back(IMPOSSIBLE_CONTINUE); // the binary format requires this; we have a block if we need one
                                             // TODO: optimize this in Stack IR (if child is a block, we
                                             //       may break to this instead)
  visitPossibleBlockContents(curr->ifTrue); // TODO: emit block contents directly, if possible
  if (Mode == StackWriterMode::Stack2Binary) {
    return;
  }
  if (curr->ifFalse) {
    visitIfElse(curr);
  }
  visitIfEnd(curr);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitIfElse(If* curr) {
  assert(!breakStack.empty());
  breakStack.pop_back();
  if (Mode == StackWriterMode::Binaryen2Stack) {
    stackIR.push_back(makeStackInst(StackInst::IfElse, curr));
  } else {
    o << int8_t(BinaryConsts::Else);
  }
  breakStack.push_back(IMPOSSIBLE_CONTINUE); // TODO ditto
  visitPossibleBlockContents(curr->ifFalse);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitIfEnd(If* curr) {
  assert(!breakStack.empty());
  breakStack.pop_back();
  if (Mode == StackWriterMode::Binaryen2Stack) {
    stackIR.push_back(makeStackInst(StackInst::IfEnd, curr));
  } else {
    o << int8_t(BinaryConsts::End);
  }
  if (curr->type == unreachable) {
    // we already handled the case of the condition being unreachable. otherwise,
    // we may still be unreachable, if we are an if-else with both sides unreachable.
    // wasm does not allow this to be emitted directly, so we must do something more. we could do
    // better, but for now we emit an extra unreachable instruction after the if, so it is not consumed itself,
    assert(curr->ifFalse);
    emitExtraUnreachable();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitLoop(Loop* curr) {
  if (Mode == StackWriterMode::Binaryen2Stack) {
    stackIR.push_back(makeStackInst(StackInst::LoopBegin, curr));
  } else {
    o << int8_t(BinaryConsts::Loop);
    o << binaryType(curr->type != unreachable ? curr->type : none);
  }
  breakStack.push_back(curr->name);
  visitPossibleBlockContents(curr->body);
  if (Mode == StackWriterMode::Stack2Binary) {
    return;
  }
  visitLoopEnd(curr);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitLoopEnd(Loop* curr) {
  assert(!breakStack.empty());
  breakStack.pop_back();
  if (curr->type == unreachable) {
    // we emitted a loop without a return type, and the body might be
    // block contents, so ensure it is not consumed
    emitExtraUnreachable();
  }
  if (Mode == StackWriterMode::Binaryen2Stack) {
    stackIR.push_back(makeStackInst(StackInst::LoopEnd, curr));
  } else {
    o << int8_t(BinaryConsts::End);
  }
  if (curr->type == unreachable) {
    // we emitted a loop without a return type, so it must not be consumed
    emitExtraUnreachable();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitBreak(Break* curr) {
  if (curr->value) {
    visitChild(curr->value);
  }
  if (curr->condition) visitChild(curr->condition);
  if (!justAddToStack(curr)) {
    o << int8_t(curr->condition ? BinaryConsts::BrIf : BinaryConsts::Br)
      << U32LEB(getBreakIndex(curr->name));
  }
  if (curr->condition && curr->type == unreachable) {
    // a br_if is normally none or emits a value. if it is unreachable,
    // then either the condition or the value is unreachable, which is
    // extremely rare, and may require us to make the stack polymorphic
    // (if the block we branch to has a value, we may lack one as we
    // are not a reachable branch; the wasm spec on the other hand does
    // presume the br_if emits a value of the right type, even if it
    // popped unreachable)
    emitExtraUnreachable();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSwitch(Switch* curr) {
  if (curr->value) {
    visitChild(curr->value);
  }
  visitChild(curr->condition);
  if (!BranchUtils::isBranchReachable(curr)) {
    // if the branch is not reachable, then it's dangerous to emit it, as
    // wasm type checking rules are different, especially in unreachable
    // code. so just don't emit that unreachable code.
    emitExtraUnreachable();
    return;
  }
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::TableSwitch) << U32LEB(curr->targets.size());
  for (auto target : curr->targets) {
    o << U32LEB(getBreakIndex(target));
  }
  o << U32LEB(getBreakIndex(curr->default_));
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitCall(Call* curr) {
  for (auto* operand : curr->operands) {
    visitChild(operand);
  }
  if (!justAddToStack(curr)) {
    o << int8_t(BinaryConsts::CallFunction) << U32LEB(parent.getFunctionIndex(curr->target));
  }
  if (curr->type == unreachable) { // TODO FIXME: this and similar can be removed
    emitExtraUnreachable();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitCallIndirect(CallIndirect* curr) {
  for (auto* operand : curr->operands) {
    visitChild(operand);
  }
  visitChild(curr->target);
  if (!justAddToStack(curr)) {
    o << int8_t(BinaryConsts::CallIndirect)
      << U32LEB(parent.getFunctionTypeIndex(curr->fullType))
      << U32LEB(0); // Reserved flags field
  }
  if (curr->type == unreachable) {
    emitExtraUnreachable();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitGetLocal(GetLocal* curr) {
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::GetLocal) << U32LEB(mappedLocals[curr->index]);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSetLocal(SetLocal* curr) {
  visitChild(curr->value);
  if (!justAddToStack(curr)) {
    o << int8_t(curr->isTee() ? BinaryConsts::TeeLocal : BinaryConsts::SetLocal) << U32LEB(mappedLocals[curr->index]);
  }
  if (curr->type == unreachable) {
    emitExtraUnreachable();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitGetGlobal(GetGlobal* curr) {
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::GetGlobal) << U32LEB(parent.getGlobalIndex(curr->name));
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSetGlobal(SetGlobal* curr) {
  visitChild(curr->value);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::SetGlobal) << U32LEB(parent.getGlobalIndex(curr->name));
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitLoad(Load* curr) {
  visitChild(curr->ptr);
  if (curr->type == unreachable) {
    // don't even emit it; we don't know the right type
    emitExtraUnreachable();
    return;
  }
  if (justAddToStack(curr)) return;
  if (!curr->isAtomic) {
    switch (curr->type) {
      case i32: {
        switch (curr->bytes) {
          case 1: o << int8_t(curr->signed_ ? BinaryConsts::I32LoadMem8S : BinaryConsts::I32LoadMem8U); break;
          case 2: o << int8_t(curr->signed_ ? BinaryConsts::I32LoadMem16S : BinaryConsts::I32LoadMem16U); break;
          case 4: o << int8_t(BinaryConsts::I32LoadMem); break;
          default: abort();
        }
        break;
      }
      case i64: {
        switch (curr->bytes) {
          case 1: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem8S : BinaryConsts::I64LoadMem8U); break;
          case 2: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem16S : BinaryConsts::I64LoadMem16U); break;
          case 4: o << int8_t(curr->signed_ ? BinaryConsts::I64LoadMem32S : BinaryConsts::I64LoadMem32U); break;
          case 8: o << int8_t(BinaryConsts::I64LoadMem); break;
          default: abort();
        }
        break;
      }
      case f32: o << int8_t(BinaryConsts::F32LoadMem); break;
      case f64: o << int8_t(BinaryConsts::F64LoadMem); break;
      case v128: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Load); break;
      case unreachable: return; // the pointer is unreachable, so we are never reached; just don't emit a load
      case none: WASM_UNREACHABLE();
    }
  } else {
    o << int8_t(BinaryConsts::AtomicPrefix);
    switch (curr->type) {
      case i32: {
        switch (curr->bytes) {
          case 1: o << int8_t(BinaryConsts::I32AtomicLoad8U); break;
          case 2: o << int8_t(BinaryConsts::I32AtomicLoad16U); break;
          case 4: o << int8_t(BinaryConsts::I32AtomicLoad); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case i64: {
        switch (curr->bytes) {
          case 1: o << int8_t(BinaryConsts::I64AtomicLoad8U); break;
          case 2: o << int8_t(BinaryConsts::I64AtomicLoad16U); break;
          case 4: o << int8_t(BinaryConsts::I64AtomicLoad32U); break;
          case 8: o << int8_t(BinaryConsts::I64AtomicLoad); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case unreachable: return;
      default: WASM_UNREACHABLE();
    }
  }
  emitMemoryAccess(curr->align, curr->bytes, curr->offset);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitStore(Store* curr) {
  visitChild(curr->ptr);
  visitChild(curr->value);
  if (curr->type == unreachable) {
    // don't even emit it; we don't know the right type
    emitExtraUnreachable();
    return;
  }
  if (justAddToStack(curr)) return;
  if (!curr->isAtomic) {
    switch (curr->valueType) {
      case i32: {
        switch (curr->bytes) {
          case 1: o << int8_t(BinaryConsts::I32StoreMem8); break;
          case 2: o << int8_t(BinaryConsts::I32StoreMem16); break;
          case 4: o << int8_t(BinaryConsts::I32StoreMem); break;
          default: abort();
        }
        break;
      }
      case i64: {
        switch (curr->bytes) {
          case 1: o << int8_t(BinaryConsts::I64StoreMem8); break;
          case 2: o << int8_t(BinaryConsts::I64StoreMem16); break;
          case 4: o << int8_t(BinaryConsts::I64StoreMem32); break;
          case 8: o << int8_t(BinaryConsts::I64StoreMem); break;
          default: abort();
        }
        break;
      }
      case f32: o << int8_t(BinaryConsts::F32StoreMem); break;
      case f64: o << int8_t(BinaryConsts::F64StoreMem); break;
      case v128: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Store); break;
      case none:
      case unreachable: WASM_UNREACHABLE();
    }
  } else {
    o << int8_t(BinaryConsts::AtomicPrefix);
    switch (curr->valueType) {
      case i32: {
        switch (curr->bytes) {
          case 1: o << int8_t(BinaryConsts::I32AtomicStore8); break;
          case 2: o << int8_t(BinaryConsts::I32AtomicStore16); break;
          case 4: o << int8_t(BinaryConsts::I32AtomicStore); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      case i64: {
        switch (curr->bytes) {
          case 1: o << int8_t(BinaryConsts::I64AtomicStore8); break;
          case 2: o << int8_t(BinaryConsts::I64AtomicStore16); break;
          case 4: o << int8_t(BinaryConsts::I64AtomicStore32); break;
          case 8: o << int8_t(BinaryConsts::I64AtomicStore); break;
          default: WASM_UNREACHABLE();
        }
        break;
      }
      default: WASM_UNREACHABLE();
    }
  }
  emitMemoryAccess(curr->align, curr->bytes, curr->offset);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitAtomicRMW(AtomicRMW* curr) {
  visitChild(curr->ptr);
  // stop if the rest isn't reachable anyhow
  if (curr->ptr->type == unreachable) return;
  visitChild(curr->value);
  if (curr->value->type == unreachable) return;
  if (curr->type == unreachable) {
    // don't even emit it; we don't know the right type
    emitExtraUnreachable();
    return;
  }
  if (justAddToStack(curr)) return;

  o << int8_t(BinaryConsts::AtomicPrefix);

#define CASE_FOR_OP(Op) \
  case Op: \
    switch (curr->type) {                                               \
      case i32:                                                         \
        switch (curr->bytes) {                                          \
          case 1: o << int8_t(BinaryConsts::I32AtomicRMW##Op##8U); break; \
          case 2: o << int8_t(BinaryConsts::I32AtomicRMW##Op##16U); break; \
          case 4: o << int8_t(BinaryConsts::I32AtomicRMW##Op); break;   \
          default: WASM_UNREACHABLE();                                  \
        }                                                               \
        break;                                                          \
      case i64:                                                         \
        switch (curr->bytes) {                                          \
          case 1: o << int8_t(BinaryConsts::I64AtomicRMW##Op##8U); break; \
          case 2: o << int8_t(BinaryConsts::I64AtomicRMW##Op##16U); break; \
          case 4: o << int8_t(BinaryConsts::I64AtomicRMW##Op##32U); break; \
          case 8: o << int8_t(BinaryConsts::I64AtomicRMW##Op); break;   \
          default: WASM_UNREACHABLE();                                  \
        }                                                               \
        break;                                                          \
      default: WASM_UNREACHABLE();                                      \
    }                                                                   \
    break

  switch(curr->op) {
    CASE_FOR_OP(Add);
    CASE_FOR_OP(Sub);
    CASE_FOR_OP(And);
    CASE_FOR_OP(Or);
    CASE_FOR_OP(Xor);
    CASE_FOR_OP(Xchg);
    default: WASM_UNREACHABLE();
  }
#undef CASE_FOR_OP

  emitMemoryAccess(curr->bytes, curr->bytes, curr->offset);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitAtomicCmpxchg(AtomicCmpxchg* curr) {
  visitChild(curr->ptr);
  // stop if the rest isn't reachable anyhow
  if (curr->ptr->type == unreachable) return;
  visitChild(curr->expected);
  if (curr->expected->type == unreachable) return;
  visitChild(curr->replacement);
  if (curr->replacement->type == unreachable) return;
  if (curr->type == unreachable) {
    // don't even emit it; we don't know the right type
    emitExtraUnreachable();
    return;
  }
  if (justAddToStack(curr)) return;

  o << int8_t(BinaryConsts::AtomicPrefix);
  switch (curr->type) {
    case i32:
      switch (curr->bytes) {
        case 1: o << int8_t(BinaryConsts::I32AtomicCmpxchg8U); break;
        case 2: o << int8_t(BinaryConsts::I32AtomicCmpxchg16U); break;
        case 4: o << int8_t(BinaryConsts::I32AtomicCmpxchg); break;
        default: WASM_UNREACHABLE();
      }
      break;
    case i64:
      switch (curr->bytes) {
        case 1: o << int8_t(BinaryConsts::I64AtomicCmpxchg8U); break;
        case 2: o << int8_t(BinaryConsts::I64AtomicCmpxchg16U); break;
        case 4: o << int8_t(BinaryConsts::I64AtomicCmpxchg32U); break;
        case 8: o << int8_t(BinaryConsts::I64AtomicCmpxchg); break;
        default: WASM_UNREACHABLE();
      }
      break;
    default: WASM_UNREACHABLE();
  }
  emitMemoryAccess(curr->bytes, curr->bytes, curr->offset);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitAtomicWait(AtomicWait* curr) {
  visitChild(curr->ptr);
  // stop if the rest isn't reachable anyhow
  if (curr->ptr->type == unreachable) return;
  visitChild(curr->expected);
  if (curr->expected->type == unreachable) return;
  visitChild(curr->timeout);
  if (curr->timeout->type == unreachable) return;
  if (justAddToStack(curr)) return;

  o << int8_t(BinaryConsts::AtomicPrefix);
  switch (curr->expectedType) {
    case i32: {
      o << int8_t(BinaryConsts::I32AtomicWait);
      emitMemoryAccess(4, 4, 0);
      break;
    }
    case i64: {
      o << int8_t(BinaryConsts::I64AtomicWait);
      emitMemoryAccess(8, 8, 0);
      break;
    }
    default: WASM_UNREACHABLE();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitAtomicNotify(AtomicNotify* curr) {
  visitChild(curr->ptr);
  // stop if the rest isn't reachable anyhow
  if (curr->ptr->type == unreachable) return;
  visitChild(curr->notifyCount);
  if (curr->notifyCount->type == unreachable) return;
  if (justAddToStack(curr)) return;

  o << int8_t(BinaryConsts::AtomicPrefix) << int8_t(BinaryConsts::AtomicNotify);
  emitMemoryAccess(4, 4, 0);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSIMDExtract(SIMDExtract* curr) {
  visitChild(curr->vec);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::SIMDPrefix);
  switch (curr->op) {
    case ExtractLaneSVecI8x16: o << U32LEB(BinaryConsts::I8x16ExtractLaneS); break;
    case ExtractLaneUVecI8x16: o << U32LEB(BinaryConsts::I8x16ExtractLaneU); break;
    case ExtractLaneSVecI16x8: o << U32LEB(BinaryConsts::I16x8ExtractLaneS); break;
    case ExtractLaneUVecI16x8: o << U32LEB(BinaryConsts::I16x8ExtractLaneU); break;
    case ExtractLaneVecI32x4: o << U32LEB(BinaryConsts::I32x4ExtractLane); break;
    case ExtractLaneVecI64x2: o << U32LEB(BinaryConsts::I64x2ExtractLane); break;
    case ExtractLaneVecF32x4: o << U32LEB(BinaryConsts::F32x4ExtractLane); break;
    case ExtractLaneVecF64x2: o << U32LEB(BinaryConsts::F64x2ExtractLane); break;
  }
  o << uint8_t(curr->index);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSIMDReplace(SIMDReplace* curr) {
  visitChild(curr->vec);
  visitChild(curr->value);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::SIMDPrefix);
  switch (curr->op) {
    case ReplaceLaneVecI8x16: o << U32LEB(BinaryConsts::I8x16ReplaceLane); break;
    case ReplaceLaneVecI16x8: o << U32LEB(BinaryConsts::I16x8ReplaceLane); break;
    case ReplaceLaneVecI32x4: o << U32LEB(BinaryConsts::I32x4ReplaceLane); break;
    case ReplaceLaneVecI64x2: o << U32LEB(BinaryConsts::I64x2ReplaceLane); break;
    case ReplaceLaneVecF32x4: o << U32LEB(BinaryConsts::F32x4ReplaceLane); break;
    case ReplaceLaneVecF64x2: o << U32LEB(BinaryConsts::F64x2ReplaceLane); break;
  }
  assert(curr->index < 16);
  o << uint8_t(curr->index);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSIMDShuffle(SIMDShuffle* curr) {
  visitChild(curr->left);
  visitChild(curr->right);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V8x16Shuffle);
  for (uint8_t m : curr->mask) {
    o << m;
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSIMDBitselect(SIMDBitselect* curr) {
  visitChild(curr->left);
  visitChild(curr->right);
  visitChild(curr->cond);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Bitselect);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSIMDShift(SIMDShift* curr) {
  visitChild(curr->vec);
  visitChild(curr->shift);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::SIMDPrefix);
  switch (curr->op) {
    case ShlVecI8x16:  o << U32LEB(BinaryConsts::I8x16Shl); break;
    case ShrSVecI8x16: o << U32LEB(BinaryConsts::I8x16ShrS); break;
    case ShrUVecI8x16: o << U32LEB(BinaryConsts::I8x16ShrU); break;
    case ShlVecI16x8:  o << U32LEB(BinaryConsts::I16x8Shl); break;
    case ShrSVecI16x8: o << U32LEB(BinaryConsts::I16x8ShrS); break;
    case ShrUVecI16x8: o << U32LEB(BinaryConsts::I16x8ShrU); break;
    case ShlVecI32x4:  o << U32LEB(BinaryConsts::I32x4Shl); break;
    case ShrSVecI32x4: o << U32LEB(BinaryConsts::I32x4ShrS); break;
    case ShrUVecI32x4: o << U32LEB(BinaryConsts::I32x4ShrU); break;
    case ShlVecI64x2:  o << U32LEB(BinaryConsts::I64x2Shl); break;
    case ShrSVecI64x2: o << U32LEB(BinaryConsts::I64x2ShrS); break;
    case ShrUVecI64x2: o << U32LEB(BinaryConsts::I64x2ShrU); break;
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitMemoryInit(MemoryInit* curr) {
  visitChild(curr->dest);
  visitChild(curr->offset);
  visitChild(curr->size);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::MiscPrefix);
  o << U32LEB(BinaryConsts::MemoryInit);
  o << U32LEB(curr->segment) << int8_t(0);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitDataDrop(DataDrop* curr) {
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::MiscPrefix);
  o << U32LEB(BinaryConsts::DataDrop);
  o << U32LEB(curr->segment);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitMemoryCopy(MemoryCopy* curr) {
  visitChild(curr->dest);
  visitChild(curr->source);
  visitChild(curr->size);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::MiscPrefix);
  o << U32LEB(BinaryConsts::MemoryCopy);
  o << int8_t(0) << int8_t(0);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitMemoryFill(MemoryFill* curr) {
  visitChild(curr->dest);
  visitChild(curr->value);
  visitChild(curr->size);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::MiscPrefix);
  o << U32LEB(BinaryConsts::MemoryFill);
  o << int8_t(0);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitConst(Const* curr) {
  if (justAddToStack(curr)) return;
  switch (curr->type) {
    case i32: {
      o << int8_t(BinaryConsts::I32Const) << S32LEB(curr->value.geti32());
      break;
    }
    case i64: {
      o << int8_t(BinaryConsts::I64Const) << S64LEB(curr->value.geti64());
      break;
    }
    case f32: {
      o << int8_t(BinaryConsts::F32Const) << curr->value.reinterpreti32();
      break;
    }
    case f64: {
      o << int8_t(BinaryConsts::F64Const) << curr->value.reinterpreti64();
      break;
    }
    case v128: {
      o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Const);
      std::array<uint8_t, 16> v = curr->value.getv128();
      for (size_t i = 0; i < 16; ++i) {
        o << uint8_t(v[i]);
      }
      break;
    }
    case none:
    case unreachable:
      WASM_UNREACHABLE();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitUnary(Unary* curr) {
  visitChild(curr->value);
  if (curr->type == unreachable) {
    emitExtraUnreachable();
    return;
  }
  if (justAddToStack(curr)) return;
  switch (curr->op) {
    case ClzInt32:               o << int8_t(BinaryConsts::I32Clz); break;
    case CtzInt32:               o << int8_t(BinaryConsts::I32Ctz); break;
    case PopcntInt32:            o << int8_t(BinaryConsts::I32Popcnt); break;
    case EqZInt32:               o << int8_t(BinaryConsts::I32EqZ); break;
    case ClzInt64:               o << int8_t(BinaryConsts::I64Clz); break;
    case CtzInt64:               o << int8_t(BinaryConsts::I64Ctz); break;
    case PopcntInt64:            o << int8_t(BinaryConsts::I64Popcnt); break;
    case EqZInt64:               o << int8_t(BinaryConsts::I64EqZ); break;
    case NegFloat32:             o << int8_t(BinaryConsts::F32Neg); break;
    case AbsFloat32:             o << int8_t(BinaryConsts::F32Abs); break;
    case CeilFloat32:            o << int8_t(BinaryConsts::F32Ceil); break;
    case FloorFloat32:           o << int8_t(BinaryConsts::F32Floor); break;
    case TruncFloat32:           o << int8_t(BinaryConsts::F32Trunc); break;
    case NearestFloat32:         o << int8_t(BinaryConsts::F32NearestInt); break;
    case SqrtFloat32:            o << int8_t(BinaryConsts::F32Sqrt); break;
    case NegFloat64:             o << int8_t(BinaryConsts::F64Neg); break;
    case AbsFloat64:             o << int8_t(BinaryConsts::F64Abs); break;
    case CeilFloat64:            o << int8_t(BinaryConsts::F64Ceil); break;
    case FloorFloat64:           o << int8_t(BinaryConsts::F64Floor); break;
    case TruncFloat64:           o << int8_t(BinaryConsts::F64Trunc); break;
    case NearestFloat64:         o << int8_t(BinaryConsts::F64NearestInt); break;
    case SqrtFloat64:            o << int8_t(BinaryConsts::F64Sqrt); break;
    case ExtendSInt32:           o << int8_t(BinaryConsts::I64STruncI32); break;
    case ExtendUInt32:           o << int8_t(BinaryConsts::I64UTruncI32); break;
    case WrapInt64:              o << int8_t(BinaryConsts::I32ConvertI64); break;
    case TruncUFloat32ToInt32:   o << int8_t(BinaryConsts::I32UTruncF32); break;
    case TruncUFloat32ToInt64:   o << int8_t(BinaryConsts::I64UTruncF32); break;
    case TruncSFloat32ToInt32:   o << int8_t(BinaryConsts::I32STruncF32); break;
    case TruncSFloat32ToInt64:   o << int8_t(BinaryConsts::I64STruncF32); break;
    case TruncUFloat64ToInt32:   o << int8_t(BinaryConsts::I32UTruncF64); break;
    case TruncUFloat64ToInt64:   o << int8_t(BinaryConsts::I64UTruncF64); break;
    case TruncSFloat64ToInt32:   o << int8_t(BinaryConsts::I32STruncF64); break;
    case TruncSFloat64ToInt64:   o << int8_t(BinaryConsts::I64STruncF64); break;
    case ConvertUInt32ToFloat32: o << int8_t(BinaryConsts::F32UConvertI32); break;
    case ConvertUInt32ToFloat64: o << int8_t(BinaryConsts::F64UConvertI32); break;
    case ConvertSInt32ToFloat32: o << int8_t(BinaryConsts::F32SConvertI32); break;
    case ConvertSInt32ToFloat64: o << int8_t(BinaryConsts::F64SConvertI32); break;
    case ConvertUInt64ToFloat32: o << int8_t(BinaryConsts::F32UConvertI64); break;
    case ConvertUInt64ToFloat64: o << int8_t(BinaryConsts::F64UConvertI64); break;
    case ConvertSInt64ToFloat32: o << int8_t(BinaryConsts::F32SConvertI64); break;
    case ConvertSInt64ToFloat64: o << int8_t(BinaryConsts::F64SConvertI64); break;
    case DemoteFloat64:          o << int8_t(BinaryConsts::F32ConvertF64); break;
    case PromoteFloat32:         o << int8_t(BinaryConsts::F64ConvertF32); break;
    case ReinterpretFloat32:     o << int8_t(BinaryConsts::I32ReinterpretF32); break;
    case ReinterpretFloat64:     o << int8_t(BinaryConsts::I64ReinterpretF64); break;
    case ReinterpretInt32:       o << int8_t(BinaryConsts::F32ReinterpretI32); break;
    case ReinterpretInt64:       o << int8_t(BinaryConsts::F64ReinterpretI64); break;
    case ExtendS8Int32:          o << int8_t(BinaryConsts::I32ExtendS8); break;
    case ExtendS16Int32:         o << int8_t(BinaryConsts::I32ExtendS16); break;
    case ExtendS8Int64:          o << int8_t(BinaryConsts::I64ExtendS8); break;
    case ExtendS16Int64:         o << int8_t(BinaryConsts::I64ExtendS16); break;
    case ExtendS32Int64:         o << int8_t(BinaryConsts::I64ExtendS32); break;
    case TruncSatSFloat32ToInt32: o << int8_t(BinaryConsts::MiscPrefix) << U32LEB(BinaryConsts::I32STruncSatF32); break;
    case TruncSatUFloat32ToInt32: o << int8_t(BinaryConsts::MiscPrefix) << U32LEB(BinaryConsts::I32UTruncSatF32); break;
    case TruncSatSFloat64ToInt32: o << int8_t(BinaryConsts::MiscPrefix) << U32LEB(BinaryConsts::I32STruncSatF64); break;
    case TruncSatUFloat64ToInt32: o << int8_t(BinaryConsts::MiscPrefix) << U32LEB(BinaryConsts::I32UTruncSatF64); break;
    case TruncSatSFloat32ToInt64: o << int8_t(BinaryConsts::MiscPrefix) << U32LEB(BinaryConsts::I64STruncSatF32); break;
    case TruncSatUFloat32ToInt64: o << int8_t(BinaryConsts::MiscPrefix) << U32LEB(BinaryConsts::I64UTruncSatF32); break;
    case TruncSatSFloat64ToInt64: o << int8_t(BinaryConsts::MiscPrefix) << U32LEB(BinaryConsts::I64STruncSatF64); break;
    case TruncSatUFloat64ToInt64: o << int8_t(BinaryConsts::MiscPrefix) << U32LEB(BinaryConsts::I64UTruncSatF64); break;
    case SplatVecI8x16:   o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Splat); break;
    case SplatVecI16x8:   o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Splat); break;
    case SplatVecI32x4:   o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Splat); break;
    case SplatVecI64x2:   o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Splat); break;
    case SplatVecF32x4:   o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Splat); break;
    case SplatVecF64x2:   o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Splat); break;
    case NotVec128:       o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Not); break;
    case NegVecI8x16:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Neg); break;
    case AnyTrueVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16AnyTrue); break;
    case AllTrueVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16AllTrue); break;
    case NegVecI16x8:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Neg); break;
    case AnyTrueVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8AnyTrue); break;
    case AllTrueVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8AllTrue); break;
    case NegVecI32x4:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Neg); break;
    case AnyTrueVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4AnyTrue); break;
    case AllTrueVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4AllTrue); break;
    case NegVecI64x2:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Neg); break;
    case AnyTrueVecI64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2AnyTrue); break;
    case AllTrueVecI64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2AllTrue); break;
    case AbsVecF32x4:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Abs); break;
    case NegVecF32x4:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Neg); break;
    case SqrtVecF32x4:    o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Sqrt); break;
    case AbsVecF64x2:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Abs); break;
    case NegVecF64x2:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Neg); break;
    case SqrtVecF64x2:    o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Sqrt); break;
    case TruncSatSVecF32x4ToVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4TruncSatSF32x4); break;
    case TruncSatUVecF32x4ToVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4TruncSatUF32x4); break;
    case TruncSatSVecF64x2ToVecI64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2TruncSatSF64x2); break;
    case TruncSatUVecF64x2ToVecI64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2TruncSatUF64x2); break;
    case ConvertSVecI32x4ToVecF32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4ConvertSI32x4); break;
    case ConvertUVecI32x4ToVecF32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4ConvertUI32x4); break;
    case ConvertSVecI64x2ToVecF64x2:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2ConvertSI64x2); break;
    case ConvertUVecI64x2ToVecF64x2:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2ConvertUI64x2); break;
    case InvalidUnary: WASM_UNREACHABLE();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitBinary(Binary* curr) {
  visitChild(curr->left);
  visitChild(curr->right);
  if (curr->type == unreachable) {
    emitExtraUnreachable();
    return;
  }
  if (justAddToStack(curr)) return;
  switch (curr->op) {
    case AddInt32:      o << int8_t(BinaryConsts::I32Add); break;
    case SubInt32:      o << int8_t(BinaryConsts::I32Sub); break;
    case MulInt32:      o << int8_t(BinaryConsts::I32Mul); break;
    case DivSInt32:     o << int8_t(BinaryConsts::I32DivS); break;
    case DivUInt32:     o << int8_t(BinaryConsts::I32DivU); break;
    case RemSInt32:     o << int8_t(BinaryConsts::I32RemS); break;
    case RemUInt32:     o << int8_t(BinaryConsts::I32RemU); break;
    case AndInt32:      o << int8_t(BinaryConsts::I32And); break;
    case OrInt32:       o << int8_t(BinaryConsts::I32Or); break;
    case XorInt32:      o << int8_t(BinaryConsts::I32Xor); break;
    case ShlInt32:      o << int8_t(BinaryConsts::I32Shl); break;
    case ShrUInt32:     o << int8_t(BinaryConsts::I32ShrU); break;
    case ShrSInt32:     o << int8_t(BinaryConsts::I32ShrS); break;
    case RotLInt32:     o << int8_t(BinaryConsts::I32RotL); break;
    case RotRInt32:     o << int8_t(BinaryConsts::I32RotR); break;
    case EqInt32:       o << int8_t(BinaryConsts::I32Eq); break;
    case NeInt32:       o << int8_t(BinaryConsts::I32Ne); break;
    case LtSInt32:      o << int8_t(BinaryConsts::I32LtS); break;
    case LtUInt32:      o << int8_t(BinaryConsts::I32LtU); break;
    case LeSInt32:      o << int8_t(BinaryConsts::I32LeS); break;
    case LeUInt32:      o << int8_t(BinaryConsts::I32LeU); break;
    case GtSInt32:      o << int8_t(BinaryConsts::I32GtS); break;
    case GtUInt32:      o << int8_t(BinaryConsts::I32GtU); break;
    case GeSInt32:      o << int8_t(BinaryConsts::I32GeS); break;
    case GeUInt32:      o << int8_t(BinaryConsts::I32GeU); break;

    case AddInt64:      o << int8_t(BinaryConsts::I64Add); break;
    case SubInt64:      o << int8_t(BinaryConsts::I64Sub); break;
    case MulInt64:      o << int8_t(BinaryConsts::I64Mul); break;
    case DivSInt64:     o << int8_t(BinaryConsts::I64DivS); break;
    case DivUInt64:     o << int8_t(BinaryConsts::I64DivU); break;
    case RemSInt64:     o << int8_t(BinaryConsts::I64RemS); break;
    case RemUInt64:     o << int8_t(BinaryConsts::I64RemU); break;
    case AndInt64:      o << int8_t(BinaryConsts::I64And); break;
    case OrInt64:       o << int8_t(BinaryConsts::I64Or); break;
    case XorInt64:      o << int8_t(BinaryConsts::I64Xor); break;
    case ShlInt64:      o << int8_t(BinaryConsts::I64Shl); break;
    case ShrUInt64:     o << int8_t(BinaryConsts::I64ShrU); break;
    case ShrSInt64:     o << int8_t(BinaryConsts::I64ShrS); break;
    case RotLInt64:     o << int8_t(BinaryConsts::I64RotL); break;
    case RotRInt64:     o << int8_t(BinaryConsts::I64RotR); break;
    case EqInt64:       o << int8_t(BinaryConsts::I64Eq); break;
    case NeInt64:       o << int8_t(BinaryConsts::I64Ne); break;
    case LtSInt64:      o << int8_t(BinaryConsts::I64LtS); break;
    case LtUInt64:      o << int8_t(BinaryConsts::I64LtU); break;
    case LeSInt64:      o << int8_t(BinaryConsts::I64LeS); break;
    case LeUInt64:      o << int8_t(BinaryConsts::I64LeU); break;
    case GtSInt64:      o << int8_t(BinaryConsts::I64GtS); break;
    case GtUInt64:      o << int8_t(BinaryConsts::I64GtU); break;
    case GeSInt64:      o << int8_t(BinaryConsts::I64GeS); break;
    case GeUInt64:      o << int8_t(BinaryConsts::I64GeU); break;

    case AddFloat32:      o << int8_t(BinaryConsts::F32Add); break;
    case SubFloat32:      o << int8_t(BinaryConsts::F32Sub); break;
    case MulFloat32:      o << int8_t(BinaryConsts::F32Mul); break;
    case DivFloat32:      o << int8_t(BinaryConsts::F32Div); break;
    case CopySignFloat32: o << int8_t(BinaryConsts::F32CopySign);break;
    case MinFloat32:      o << int8_t(BinaryConsts::F32Min); break;
    case MaxFloat32:      o << int8_t(BinaryConsts::F32Max); break;
    case EqFloat32:       o << int8_t(BinaryConsts::F32Eq); break;
    case NeFloat32:       o << int8_t(BinaryConsts::F32Ne); break;
    case LtFloat32:       o << int8_t(BinaryConsts::F32Lt); break;
    case LeFloat32:       o << int8_t(BinaryConsts::F32Le); break;
    case GtFloat32:       o << int8_t(BinaryConsts::F32Gt); break;
    case GeFloat32:       o << int8_t(BinaryConsts::F32Ge); break;

    case AddFloat64:      o << int8_t(BinaryConsts::F64Add); break;
    case SubFloat64:      o << int8_t(BinaryConsts::F64Sub); break;
    case MulFloat64:      o << int8_t(BinaryConsts::F64Mul); break;
    case DivFloat64:      o << int8_t(BinaryConsts::F64Div); break;
    case CopySignFloat64: o << int8_t(BinaryConsts::F64CopySign);break;
    case MinFloat64:      o << int8_t(BinaryConsts::F64Min); break;
    case MaxFloat64:      o << int8_t(BinaryConsts::F64Max); break;
    case EqFloat64:       o << int8_t(BinaryConsts::F64Eq); break;
    case NeFloat64:       o << int8_t(BinaryConsts::F64Ne); break;
    case LtFloat64:       o << int8_t(BinaryConsts::F64Lt); break;
    case LeFloat64:       o << int8_t(BinaryConsts::F64Le); break;
    case GtFloat64:       o << int8_t(BinaryConsts::F64Gt); break;
    case GeFloat64:       o << int8_t(BinaryConsts::F64Ge); break;

    case EqVecI8x16:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Eq); break;
    case NeVecI8x16:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Ne); break;
    case LtSVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16LtS); break;
    case LtUVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16LtU); break;
    case GtSVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16GtS); break;
    case GtUVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16GtU); break;
    case LeSVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16LeS); break;
    case LeUVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16LeU); break;
    case GeSVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16GeS); break;
    case GeUVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16GeU); break;
    case EqVecI16x8:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Eq); break;
    case NeVecI16x8:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Ne); break;
    case LtSVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8LtS); break;
    case LtUVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8LtU); break;
    case GtSVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8GtS); break;
    case GtUVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8GtU); break;
    case LeSVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8LeS); break;
    case LeUVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8LeU); break;
    case GeSVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8GeS); break;
    case GeUVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8GeU); break;
    case EqVecI32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Eq); break;
    case NeVecI32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Ne); break;
    case LtSVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4LtS); break;
    case LtUVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4LtU); break;
    case GtSVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4GtS); break;
    case GtUVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4GtU); break;
    case LeSVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4LeS); break;
    case LeUVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4LeU); break;
    case GeSVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4GeS); break;
    case GeUVecI32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4GeU); break;
    case EqVecF32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Eq); break;
    case NeVecF32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Ne); break;
    case LtVecF32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Lt); break;
    case GtVecF32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Gt); break;
    case LeVecF32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Le); break;
    case GeVecF32x4:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Ge); break;
    case EqVecF64x2:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Eq); break;
    case NeVecF64x2:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Ne); break;
    case LtVecF64x2:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Lt); break;
    case GtVecF64x2:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Gt); break;
    case LeVecF64x2:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Le); break;
    case GeVecF64x2:  o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Ge); break;
    case AndVec128:   o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128And); break;
    case OrVec128:    o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Or); break;
    case XorVec128:   o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::V128Xor); break;

    case AddVecI8x16:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Add); break;
    case AddSatSVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16AddSatS); break;
    case AddSatUVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16AddSatU); break;
    case SubVecI8x16:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Sub); break;
    case SubSatSVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16SubSatS); break;
    case SubSatUVecI8x16: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16SubSatU); break;
    case MulVecI8x16:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I8x16Mul); break;
    case AddVecI16x8:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Add); break;
    case AddSatSVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8AddSatS); break;
    case AddSatUVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8AddSatU); break;
    case SubVecI16x8:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Sub); break;
    case SubSatSVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8SubSatS); break;
    case SubSatUVecI16x8: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8SubSatU); break;
    case MulVecI16x8:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I16x8Mul); break;
    case AddVecI32x4:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Add); break;
    case SubVecI32x4:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Sub); break;
    case MulVecI32x4:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I32x4Mul); break;
    case AddVecI64x2:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Add); break;
    case SubVecI64x2:     o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::I64x2Sub); break;

    case AddVecF32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Add); break;
    case SubVecF32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Sub); break;
    case MulVecF32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Mul); break;
    case DivVecF32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Div); break;
    case MinVecF32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Min); break;
    case MaxVecF32x4: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F32x4Max); break;
    case AddVecF64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Add); break;
    case SubVecF64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Sub); break;
    case MulVecF64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Mul); break;
    case DivVecF64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Div); break;
    case MinVecF64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Min); break;
    case MaxVecF64x2: o << int8_t(BinaryConsts::SIMDPrefix) << U32LEB(BinaryConsts::F64x2Max); break;
    case InvalidBinary: WASM_UNREACHABLE();
  }
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitSelect(Select* curr) {
  visitChild(curr->ifTrue);
  visitChild(curr->ifFalse);
  visitChild(curr->condition);
  if (curr->type == unreachable) {
    emitExtraUnreachable();
    return;
  }
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::Select);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitReturn(Return* curr) {
  if (curr->value) {
    visitChild(curr->value);
  }
  if (justAddToStack(curr)) return;

  o << int8_t(BinaryConsts::Return);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitHost(Host* curr) {
  switch (curr->op) {
    case CurrentMemory: {
      break;
    }
    case GrowMemory: {
      visitChild(curr->operands[0]);
      break;
    }
  }
  if (justAddToStack(curr)) return;
  switch (curr->op) {
    case CurrentMemory: {
      o << int8_t(BinaryConsts::CurrentMemory);
      break;
    }
    case GrowMemory: {
      o << int8_t(BinaryConsts::GrowMemory);
      break;
    }
  }
  o << U32LEB(0); // Reserved flags field
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitNop(Nop* curr) {
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::Nop);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitUnreachable(Unreachable* curr) {
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::Unreachable);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::visitDrop(Drop* curr) {
  visitChild(curr->value);
  if (justAddToStack(curr)) return;
  o << int8_t(BinaryConsts::Drop);
}

template<StackWriterMode Mode, typename Parent>
int32_t StackWriter<Mode, Parent>::getBreakIndex(Name name) { // -1 if not found
  for (int i = breakStack.size() - 1; i >= 0; i--) {
    if (breakStack[i] == name) {
      return breakStack.size() - 1 - i;
    }
  }
  WASM_UNREACHABLE();
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::emitMemoryAccess(size_t alignment, size_t bytes, uint32_t offset) {
  o << U32LEB(Log2(alignment ? alignment : bytes));
  o << U32LEB(offset);
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::emitExtraUnreachable() {
  if (Mode == StackWriterMode::Binaryen2Stack) {
    stackIR.push_back(makeStackInst(Builder(allocator).makeUnreachable()));
  } else if (Mode == StackWriterMode::Binaryen2Binary) {
    o << int8_t(BinaryConsts::Unreachable);
  }
}

template<StackWriterMode Mode, typename Parent>
bool StackWriter<Mode, Parent>::justAddToStack(Expression* curr) {
  if (Mode == StackWriterMode::Binaryen2Stack) {
    stackIR.push_back(makeStackInst(curr));
    return true;
  }
  return false;
}

template<StackWriterMode Mode, typename Parent>
void StackWriter<Mode, Parent>::finishFunctionBody() {
  if (func->epilogLocation.size()) {
    parent.writeDebugLocation(*func->epilogLocation.begin());
  }
  o << int8_t(BinaryConsts::End);
}

template<StackWriterMode Mode, typename Parent>
StackInst* StackWriter<Mode, Parent>::makeStackInst(StackInst::Op op, Expression* origin) {
  auto* ret = allocator.alloc<StackInst>();
  ret->op = op;
  ret->origin = origin;
  auto stackType = origin->type;
  if (origin->is<Block>() || origin->is<Loop>() || origin->is<If>()) {
    if (stackType == unreachable) {
      // There are no unreachable blocks, loops, or ifs. we emit extra unreachables
      // to fix that up, so that they are valid as having none type.
      stackType = none;
    } else if (op != StackInst::BlockEnd &&
               op != StackInst::IfEnd &&
               op != StackInst::LoopEnd) {
      // If a concrete type is returned, we mark the end of the construct has
      // having that type (as it is pushed to the value stack at that point),
      // other parts are marked as none).
      stackType = none;
    }
  }
  ret->type = stackType;
  return ret;
}

} // namespace wasm

#endif // wasm_stack_h
