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

//
// StackWriter: Writes out binary format stack machine code for a Binaryen IR expression
//
// A stack writer has one of three modes:
//  * Binaryen2Binary: directly writes the expression to wasm binary
//  * Binaryen2Stack: queues the expressions linearly, in Stack IR (SIR)
//  * Stack2Binary: emits SIR to wasm binary
//
// Direct writing, in Binaryen2Binary, is fast. Otherwise, Binaryen2Stack
// lets you optimzie the Stack IR before running Stack2Binary.
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

  std::vector<Expression*> stackIR; // filled in Binaryen2Stack, read in Stack2Binary

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
  void visitStackItem(StackItem* curr);

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
    // TODO optimize(stackIR, func);
    // Emit the binary.
    // FIXME XXX this recomputes the localMap, avoid the duplication
    StackWriter<StackWriterMode::Stack2Binary> finalWriter(parent, o, /* sourceMap= */ false, debug);
    finalWriter.setFunction(func);
    // Locals may have changed during optimization, let the finalWriter emit the header.
    finalWriter.mapLocalsAndEmitHeader();
    for (auto* item : stackIR) {
      if (!item) continue; // a nullptr is just something we can skip
      finalWriter.visit(item);
    }
  }
};

} // namespace wasm

#endif // wasm_stack_h

