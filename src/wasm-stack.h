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

namespace wasm {

// Stack IR: an IR that represents code at the wasm binary format level,
// that is, a stack machine. Binaryen IR is *almost* identical to this,
// but as documented in README.md, there are a few differences, intended
// to make Binaryen IR fast and flexible for maximal optimization. Stack
// IR, on the other hand, is designed to optimize a few final things that
// can only really be done when modeling the stack machine format precisely.

// A Stack IR instruction. Most just directly reflect a Binaryen IR node,
// but we need extra ones for certain things.
struct StackInst {
  StackInst(MixedArena&) {}

  enum Op {
    Basic,    // an instruction directly corresponding to a Binaryen IR node
    BlockEnd, // a block's end
    IfElse,   // an if's else
    IfEnd,    // an if's end
    LoopEnd   // a loop's end
  } op;

  Expression* origin; // the expression this originates from

  Type type; // the type - usually identical to the origin type, but
                 // e.g. wasm has no unreachable blocks, they must be none
};

// A representation of Stack IR, containing a linear sequence of
// stack instructions, and code to optimize.
// This representation is very simple: just a single vector of
// all instructions, in order.
//  * nullptr is allowed in the vector, representing something to skip.
//    This is useful as a common thing optimizations do is remove instructions,
//    so this way we can do so without compacting the vector all the time.
class StackIR : public std::vector<StackInst*> {
  // Optimize the IR. If func is provided, the IR is the entirety of a
  // function body; otherwise it is just a fragment from a function or
  // a global segment offset etc.
  void optimize(Function* func=nullptr);
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

template<StackWriterMode Mode>
class StackWriter : public Visitor<StackWriter<Mode>> {
public:
  StackWriter(WasmBinaryWriter& parent, BufferWithRandomAccess& o, bool sourceMap=false, bool debug=false)
    : parent(parent), o(o), sourceMap(sourceMap), debug(debug) {}

  StackIR stackInsts; // filled in Binaryen2Stack, read in Stack2Binary

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
  void visitCallImport(CallImport* curr);
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
  void visitAtomicWake(AtomicWake* curr);
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
  WasmBinaryWriter& parent;
  BufferWithRandomAccess& o;
  bool sourceMap;
  bool debug;

  Function* func;

  std::map<Index, size_t> mappedLocals; // local index => index in compact form of [all int32s][all int64s]etc

  MixedArena temps; // Stack IR needs some temporary allocations

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
class ExpressionStackWriter : StackWriter<StackWriterMode::Binaryen2Binary> {
public:
  ExpressionStackWriter(Expression* curr, WasmBinaryWriter& parent, BufferWithRandomAccess& o, bool debug=false) :
    StackWriter<StackWriterMode::Binaryen2Binary>(parent, o, /* sourceMap= */ false, debug) {
    visit(curr);
  }
};

// Write out a function body, including the local header info.
class FunctionStackWriter : StackWriter<StackWriterMode::Binaryen2Binary> {
public:
  FunctionStackWriter(Function* funcInit, WasmBinaryWriter& parent, BufferWithRandomAccess& o, bool sourceMap=false, bool debug=false) :
    StackWriter<StackWriterMode::Binaryen2Binary>(parent, o, sourceMap, debug) {
    setFunction(funcInit);
    mapLocalsAndEmitHeader();
    visitPossibleBlockContents(func->body);
    finishFunctionBody();
  }
};

// An optimizing function body writer: emits Binaryen IR to Stack IR, runs opts,
// then converts the optimized Stack IR to wasm binary.
// Note that source maps are not supported here: use a simpler stack writer
// for that.
class OptimizingFunctionStackWriter : public StackWriter<StackWriterMode::Binaryen2Stack> {
public:
  OptimizingFunctionStackWriter(Function* funcInit, WasmBinaryWriter& parent, BufferWithRandomAccess& o, bool debug=false) :
    StackWriter<StackWriterMode::Binaryen2Stack>(parent, o, /* sourceMap= */ false, debug) {
    // Write out Stack IR.
    setFunction(funcInit);
    visitPossibleBlockContents(func->body);
    // Optimize it.
    stackIR.optimize(func);
    // Emit the binary.
    // FIXME XXX this recomputes the localMap, avoid the duplication
    StackWriter<StackWriterMode::Stack2Binary> finalWriter(parent, o, /* sourceMap= */ false, debug);
    finalWriter.setFunction(func);
    // Locals may have changed during optimization, let the finalWriter emit the header.
    finalWriter.mapLocalsAndEmitHeader();
    for (auto* inst : stackInsts) {
      if (!inst) continue; // a nullptr is just something we can skip
      switch (inst->op) {
        case StackInst::Basic: {
          finalWriter.visit(inst->origin);
          break;
        }
        case StackInst::BlockEnd: {
          finalWriter.visitBlockEnd(inst->origin->cast<Block>());
          break;
        }
        case StackInst::IfElse: {
          finalWriter.visitIfElse(inst->origin->cast<If>());
          break;
        }
        case StackInst::IfEnd: {
          finalWriter.visitIfEnd(inst->origin->cast<If>());
          break;
        }
        case StackInst::LoopEnd: {
          finalWriter.visitLoopEnd(inst->origin->cast<Loop>());
          break;
        }
        default: WASM_UNREACHABLE();
      }
    }
    finishFunctionBody();
  }
};

} // namespace wasm

#endif // wasm_stack_h

