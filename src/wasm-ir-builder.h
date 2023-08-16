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
  // initialized to initialize the child fields and refinalize it. These
  // specific visitors are internal implementation details.
  Result<> visitExpression(Expression*);
  Result<> visitBlock(Block*);
  Result<> visitReturn(Return*);
  Result<> visitStructNew(StructNew*);
  Result<> visitArrayNew(ArrayNew*);

  // Alternatively, call makeXYZ to have the IRBuilder allocate the nodes. This
  // is generally safer than calling `visit` because the function signatures
  // ensure that there are no missing fields.
  Result<> makeNop();
  Result<> makeBlock();
  // Result<> makeIf();
  // Result<> makeLoop();
  // Result<> makeBreak();
  // Result<> makeSwitch();
  // Result<> makeCall();
  // Result<> makeCallIndirect();
  Result<> makeLocalGet(Index local);
  Result<> makeLocalSet(Index local);
  Result<> makeLocalTee(Index local);
  Result<> makeGlobalGet(Name global);
  Result<> makeGlobalSet(Name global);
  Result<> makeLoad(unsigned bytes,
                    bool signed_,
                    Address offset,
                    unsigned align,
                    Type type,
                    Name mem);
  Result<> makeStore(
    unsigned bytes, Address offset, unsigned align, Type type, Name mem);
  Result<> makeAtomicLoad(unsigned bytes, Address offset, Type type, Name mem);
  Result<> makeAtomicStore(unsigned bytes, Address offset, Type type, Name mem);
  Result<> makeAtomicRMW(
    AtomicRMWOp op, unsigned bytes, Address offset, Type type, Name mem);
  Result<>
  makeAtomicCmpxchg(unsigned bytes, Address offset, Type type, Name mem);
  Result<> makeAtomicWait(Type type, Address offset, Name mem);
  Result<> makeAtomicNotify(Address offset, Name mem);
  Result<> makeAtomicFence();
  Result<> makeSIMDExtract(SIMDExtractOp op, uint8_t lane);
  Result<> makeSIMDReplace(SIMDReplaceOp op, uint8_t lane);
  Result<> makeSIMDShuffle(const std::array<uint8_t, 16>& lanes);
  Result<> makeSIMDTernary(SIMDTernaryOp op);
  Result<> makeSIMDShift(SIMDShiftOp op);
  Result<>
  makeSIMDLoad(SIMDLoadOp op, Address offset, unsigned align, Name mem);
  Result<> makeSIMDLoadStoreLane(SIMDLoadStoreLaneOp op,
                                 Address offset,
                                 unsigned align,
                                 uint8_t lane,
                                 Name mem);
  Result<> makeMemoryInit(Name data, Name mem);
  Result<> makeDataDrop(Name data);
  Result<> makeMemoryCopy(Name destMem, Name srcMem);
  Result<> makeMemoryFill(Name mem);
  Result<> makeConst(Literal val);
  Result<> makeUnary(UnaryOp op);
  Result<> makeBinary(BinaryOp op);
  Result<> makeSelect(std::optional<Type> type = std::nullopt);
  Result<> makeDrop();
  Result<> makeReturn();
  Result<> makeMemorySize(Name mem);
  Result<> makeMemoryGrow(Name mem);
  Result<> makeUnreachable();
  // Result<> makePop();
  Result<> makeRefNull(HeapType type);
  Result<> makeRefIsNull();
  // Result<> makeRefFunc();
  Result<> makeRefEq();
  // Result<> makeTableGet();
  // Result<> makeTableSet();
  // Result<> makeTableSize();
  // Result<> makeTableGrow();
  // Result<> makeTry();
  // Result<> makeThrow();
  // Result<> makeRethrow();
  // Result<> makeTupleMake();
  // Result<> makeTupleExtract();
  Result<> makeI31New();
  Result<> makeI31Get(bool signed_);
  // Result<> makeCallRef();
  // Result<> makeRefTest();
  // Result<> makeRefCast();
  // Result<> makeBrOn();
  Result<> makeStructNew(HeapType type);
  Result<> makeStructNewDefault(HeapType type);
  Result<> makeStructGet(HeapType type, Index field, bool signed_);
  Result<> makeStructSet(HeapType type, Index field);
  Result<> makeArrayNew(HeapType type);
  Result<> makeArrayNewDefault(HeapType type);
  Result<> makeArrayNewData(HeapType type, Name data);
  Result<> makeArrayNewElem(HeapType type, Name elem);
  // Result<> makeArrayNewFixed();
  Result<> makeArrayGet(HeapType type, bool signed_);
  Result<> makeArraySet(HeapType type);
  Result<> makeArrayLen();
  Result<> makeArrayCopy(HeapType destType, HeapType srcType);
  Result<> makeArrayFill(HeapType type);
  // Result<> makeArrayInitData();
  // Result<> makeArrayInitElem();
  // Result<> makeRefAs();
  // Result<> makeStringNew();
  // Result<> makeStringConst();
  // Result<> makeStringMeasure();
  // Result<> makeStringEncode();
  // Result<> makeStringConcat();
  // Result<> makeStringEq();
  // Result<> makeStringAs();
  // Result<> makeStringWTF8Advance();
  // Result<> makeStringWTF16Get();
  // Result<> makeStringIterNext();
  // Result<> makeStringIterMove();
  // Result<> makeStringSliceWTF();
  // Result<> makeStringSliceIter();

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
  Result<> push(Expression*);
  Result<Expression*> pop();
};

} // namespace wasm

#endif // wasm_wasm_ir_builder_h
