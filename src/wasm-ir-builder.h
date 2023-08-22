/*
 * Copyright 2023 WebAssembly Community Group participants
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

#ifndef wasm_wasm_ir_builder_h
#define wasm_wasm_ir_builder_h

#include <vector>

#include "support/result.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

// A utility for constructing valid Binaryen IR from arbitrary valid sequences
// of WebAssembly instructions. The user is responsible for providing Expression
// nodes with all of their non-child fields already filled out, and IRBuilder is
// responsible for setting child fields and finalizing nodes.
//
// To use, call CHECK_ERR(visit(...)) or CHECK_ERR(makeXYZ(...)) on each
// expression in the sequence, then call build().
class IRBuilder : public UnifiedExpressionVisitor<IRBuilder, Result<>> {
public:
  IRBuilder(Module& wasm, Function* func = nullptr)
    : wasm(wasm), func(func), builder(wasm) {}

  // Get the valid Binaryen IR expression representing the sequence of visited
  // instructions. The IRBuilder is reset and can be used with a fresh sequence
  // of instructions after this is called.
  Expression* build();

  [[nodiscard]] Result<std::vector<Expression*>> finishInstrs();

  // Call visit() on an existing Expression with its non-child fields
  // initialized to initialize the child fields and refinalize it. The specific
  // visitors are internal implementation details.
  [[nodiscard]] Result<> visit(Expression*);
  [[nodiscard]] Result<> visitExpression(Expression*);
  [[nodiscard]] Result<> visitBlock(Block*);
  [[nodiscard]] Result<> visitReturn(Return*);
  [[nodiscard]] Result<> visitStructNew(StructNew*);
  [[nodiscard]] Result<> visitArrayNew(ArrayNew*);

  // Alternatively, call makeXYZ to have the IRBuilder allocate the nodes. This
  // is generally safer than calling `visit` because the function signatures
  // ensure that there are no missing fields.
  [[nodiscard]] Result<> makeNop();
  [[nodiscard]] Result<> makeBlock();
  // [[nodiscard]] Result<> makeIf();
  // [[nodiscard]] Result<> makeLoop();
  // [[nodiscard]] Result<> makeBreak();
  // [[nodiscard]] Result<> makeSwitch();
  // [[nodiscard]] Result<> makeCall();
  // [[nodiscard]] Result<> makeCallIndirect();
  [[nodiscard]] Result<> makeLocalGet(Index local);
  [[nodiscard]] Result<> makeLocalSet(Index local);
  [[nodiscard]] Result<> makeLocalTee(Index local);
  [[nodiscard]] Result<> makeGlobalGet(Name global);
  [[nodiscard]] Result<> makeGlobalSet(Name global);
  [[nodiscard]] Result<> makeLoad(unsigned bytes,
                                  bool signed_,
                                  Address offset,
                                  unsigned align,
                                  Type type,
                                  Name mem);
  [[nodiscard]] Result<> makeStore(
    unsigned bytes, Address offset, unsigned align, Type type, Name mem);
  [[nodiscard]] Result<>
  makeAtomicLoad(unsigned bytes, Address offset, Type type, Name mem);
  [[nodiscard]] Result<>
  makeAtomicStore(unsigned bytes, Address offset, Type type, Name mem);
  [[nodiscard]] Result<> makeAtomicRMW(
    AtomicRMWOp op, unsigned bytes, Address offset, Type type, Name mem);
  [[nodiscard]] Result<>
  makeAtomicCmpxchg(unsigned bytes, Address offset, Type type, Name mem);
  [[nodiscard]] Result<> makeAtomicWait(Type type, Address offset, Name mem);
  [[nodiscard]] Result<> makeAtomicNotify(Address offset, Name mem);
  [[nodiscard]] Result<> makeAtomicFence();
  [[nodiscard]] Result<> makeSIMDExtract(SIMDExtractOp op, uint8_t lane);
  [[nodiscard]] Result<> makeSIMDReplace(SIMDReplaceOp op, uint8_t lane);
  [[nodiscard]] Result<> makeSIMDShuffle(const std::array<uint8_t, 16>& lanes);
  [[nodiscard]] Result<> makeSIMDTernary(SIMDTernaryOp op);
  [[nodiscard]] Result<> makeSIMDShift(SIMDShiftOp op);
  [[nodiscard]] Result<>
  makeSIMDLoad(SIMDLoadOp op, Address offset, unsigned align, Name mem);
  [[nodiscard]] Result<> makeSIMDLoadStoreLane(SIMDLoadStoreLaneOp op,
                                               Address offset,
                                               unsigned align,
                                               uint8_t lane,
                                               Name mem);
  [[nodiscard]] Result<> makeMemoryInit(Name data, Name mem);
  [[nodiscard]] Result<> makeDataDrop(Name data);
  [[nodiscard]] Result<> makeMemoryCopy(Name destMem, Name srcMem);
  [[nodiscard]] Result<> makeMemoryFill(Name mem);
  [[nodiscard]] Result<> makeConst(Literal val);
  [[nodiscard]] Result<> makeUnary(UnaryOp op);
  [[nodiscard]] Result<> makeBinary(BinaryOp op);
  [[nodiscard]] Result<> makeSelect(std::optional<Type> type = std::nullopt);
  [[nodiscard]] Result<> makeDrop();
  [[nodiscard]] Result<> makeReturn();
  [[nodiscard]] Result<> makeMemorySize(Name mem);
  [[nodiscard]] Result<> makeMemoryGrow(Name mem);
  [[nodiscard]] Result<> makeUnreachable();
  // [[nodiscard]] Result<> makePop();
  [[nodiscard]] Result<> makeRefNull(HeapType type);
  [[nodiscard]] Result<> makeRefIsNull();
  // [[nodiscard]] Result<> makeRefFunc();
  [[nodiscard]] Result<> makeRefEq();
  // [[nodiscard]] Result<> makeTableGet();
  // [[nodiscard]] Result<> makeTableSet();
  // [[nodiscard]] Result<> makeTableSize();
  // [[nodiscard]] Result<> makeTableGrow();
  // [[nodiscard]] Result<> makeTry();
  // [[nodiscard]] Result<> makeThrow();
  // [[nodiscard]] Result<> makeRethrow();
  // [[nodiscard]] Result<> makeTupleMake();
  // [[nodiscard]] Result<> makeTupleExtract();
  [[nodiscard]] Result<> makeI31New();
  [[nodiscard]] Result<> makeI31Get(bool signed_);
  // [[nodiscard]] Result<> makeCallRef();
  // [[nodiscard]] Result<> makeRefTest();
  // [[nodiscard]] Result<> makeRefCast();
  // [[nodiscard]] Result<> makeBrOn();
  [[nodiscard]] Result<> makeStructNew(HeapType type);
  [[nodiscard]] Result<> makeStructNewDefault(HeapType type);
  [[nodiscard]] Result<>
  makeStructGet(HeapType type, Index field, bool signed_);
  [[nodiscard]] Result<> makeStructSet(HeapType type, Index field);
  [[nodiscard]] Result<> makeArrayNew(HeapType type);
  [[nodiscard]] Result<> makeArrayNewDefault(HeapType type);
  [[nodiscard]] Result<> makeArrayNewData(HeapType type, Name data);
  [[nodiscard]] Result<> makeArrayNewElem(HeapType type, Name elem);
  // [[nodiscard]] Result<> makeArrayNewFixed();
  [[nodiscard]] Result<> makeArrayGet(HeapType type, bool signed_);
  [[nodiscard]] Result<> makeArraySet(HeapType type);
  [[nodiscard]] Result<> makeArrayLen();
  [[nodiscard]] Result<> makeArrayCopy(HeapType destType, HeapType srcType);
  [[nodiscard]] Result<> makeArrayFill(HeapType type);
  // [[nodiscard]] Result<> makeArrayInitData();
  // [[nodiscard]] Result<> makeArrayInitElem();
  // [[nodiscard]] Result<> makeRefAs();
  // [[nodiscard]] Result<> makeStringNew();
  // [[nodiscard]] Result<> makeStringConst();
  // [[nodiscard]] Result<> makeStringMeasure();
  // [[nodiscard]] Result<> makeStringEncode();
  // [[nodiscard]] Result<> makeStringConcat();
  // [[nodiscard]] Result<> makeStringEq();
  // [[nodiscard]] Result<> makeStringAs();
  // [[nodiscard]] Result<> makeStringWTF8Advance();
  // [[nodiscard]] Result<> makeStringWTF16Get();
  // [[nodiscard]] Result<> makeStringIterNext();
  // [[nodiscard]] Result<> makeStringIterMove();
  // [[nodiscard]] Result<> makeStringSliceWTF();
  // [[nodiscard]] Result<> makeStringSliceIter();

  // TODO: make this private.
  void pushScope(Type type) { scopeStack.push_back({{}, type}); }

  void setFunction(Function* func) { this->func = func; }

private:
  Module& wasm;
  Function* func;
  Builder builder;

  // The context for a single block scope, including the instructions parsed
  // inside that scope so far and the ultimate result type we expect this block
  // to have.
  struct BlockCtx {
    std::vector<Expression*> exprStack;
    Type type;
  };

  // The stack of block contexts currently being parsed.
  std::vector<BlockCtx> scopeStack;
  std::vector<Expression*>& getExprStack();
  Type getResultType() {
    assert(!scopeStack.empty());
    return scopeStack.back().type;
  }

  // Whether we have seen an unreachable instruction and are in
  // stack-polymorphic unreachable mode.
  bool unreachable = false;

  Result<Index> addScratchLocal(Type);
  [[nodiscard]] Result<> push(Expression*);
  Result<Expression*> pop();
};

} // namespace wasm

#endif // wasm_wasm_ir_builder_h
