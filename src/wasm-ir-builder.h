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
  [[nodiscard]] Result<Expression*> build();

  // Call visit() on an existing Expression with its non-child fields
  // initialized to initialize the child fields and refinalize it.
  [[nodiscard]] Result<> visit(Expression*);

  // Handle the boundaries of control flow structures. Users may choose to use
  // the corresponding `makeXYZ` function below instead of `visitXYZStart`, but
  // either way must call `visitEnd` and friends at the appropriate times.
  [[nodiscard]] Result<> visitBlockStart(Block* block);
  [[nodiscard]] Result<> visitIfStart(If* iff, Name label = {});
  [[nodiscard]] Result<> visitElse();
  [[nodiscard]] Result<> visitLoopStart(Loop* iff);
  [[nodiscard]] Result<> visitEnd();

  // Alternatively, call makeXYZ to have the IRBuilder allocate the nodes. This
  // is generally safer than calling `visit` because the function signatures
  // ensure that there are no missing fields.
  [[nodiscard]] Result<> makeNop();
  [[nodiscard]] Result<> makeBlock(Name label, Type type);
  [[nodiscard]] Result<> makeIf(Name label, Type type);
  [[nodiscard]] Result<> makeLoop(Name label, Type type);
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
  // [[nodiscard]] Result<> makeTableFill();
  // [[nodiscard]] Result<> makeTry();
  // [[nodiscard]] Result<> makeThrow();
  // [[nodiscard]] Result<> makeRethrow();
  // [[nodiscard]] Result<> makeTupleMake();
  // [[nodiscard]] Result<> makeTupleExtract();
  [[nodiscard]] Result<> makeRefI31();
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

  void setFunction(Function* func) { this->func = func; }

  // Private functions that must be public for technical reasons.
  [[nodiscard]] Result<> visitExpression(Expression*);
  [[nodiscard]] Result<> visitBlock(Block*);
  [[nodiscard]] Result<> visitReturn(Return*);
  [[nodiscard]] Result<> visitStructNew(StructNew*);
  [[nodiscard]] Result<> visitArrayNew(ArrayNew*);

private:
  Module& wasm;
  Function* func;
  Builder builder;

  // The context for a single block scope, including the instructions parsed
  // inside that scope so far and the ultimate result type we expect this block
  // to have.
  struct ScopeCtx {
    struct NoScope {};
    struct BlockScope {
      Block* block;
    };
    struct IfScope {
      If* iff;
      Name label;
    };
    struct ElseScope {
      If* iff;
      Name label;
    };
    struct LoopScope {
      Loop* loop;
    };
    using Scope =
      std::variant<NoScope, BlockScope, IfScope, ElseScope, LoopScope>;

    // The control flow structure we are building expressions for.
    Scope scope;

    std::vector<Expression*> exprStack;
    // Whether we have seen an unreachable instruction and are in
    // stack-polymorphic unreachable mode.
    bool unreachable = false;

    ScopeCtx() : scope(NoScope{}) {}
    ScopeCtx(Scope scope) : scope(scope) {}

    static ScopeCtx makeBlock(Block* block) {
      return ScopeCtx(BlockScope{block});
    }
    static ScopeCtx makeIf(If* iff, Name label = {}) {
      return ScopeCtx(IfScope{iff, label});
    }
    static ScopeCtx makeElse(If* iff, Name label = {}) {
      return ScopeCtx(ElseScope{iff, label});
    }
    static ScopeCtx makeLoop(Loop* loop) { return ScopeCtx(LoopScope{loop}); }

    bool isNone() { return std::get_if<NoScope>(&scope); }
    Block* getBlock() {
      if (auto* blockScope = std::get_if<BlockScope>(&scope)) {
        return blockScope->block;
      }
      return nullptr;
    }
    If* getIf() {
      if (auto* ifScope = std::get_if<IfScope>(&scope)) {
        return ifScope->iff;
      }
      return nullptr;
    }
    If* getElse() {
      if (auto* elseScope = std::get_if<ElseScope>(&scope)) {
        return elseScope->iff;
      }
      return nullptr;
    }
    Loop* getLoop() {
      if (auto* loopScope = std::get_if<LoopScope>(&scope)) {
        return loopScope->loop;
      }
      return nullptr;
    }
    Type getResultType() {
      if (auto* block = getBlock()) {
        return block->type;
      }
      if (auto* iff = getIf()) {
        return iff->type;
      }
      if (auto* iff = getElse()) {
        return iff->type;
      }
      if (auto* loop = getLoop()) {
        return loop->type;
      }
      WASM_UNREACHABLE("unexpected scope kind");
    }
    Name getLabel() {
      if (auto* block = getBlock()) {
        return block->name;
      }
      if (auto* ifScope = std::get_if<IfScope>(&scope)) {
        return ifScope->label;
      }
      if (auto* elseScope = std::get_if<ElseScope>(&scope)) {
        return elseScope->label;
      }
      if (auto* loop = getLoop()) {
        return loop->name;
      }
      WASM_UNREACHABLE("unexpected scope kind");
    }
  };

  // The stack of block contexts currently being parsed.
  std::vector<ScopeCtx> scopeStack;

  ScopeCtx& getScope() {
    if (scopeStack.empty()) {
      // We are not in a block context, so push a dummy scope.
      scopeStack.push_back({});
    }
    return scopeStack.back();
  }

  // Collect the current scope into a single expression. If it has multiple
  // top-level expressions, this requires collecting them into a block. If we
  // are in a block context, we can collect them directly into the destination
  // `block`, but otherwise we will have to allocate a new block.
  Result<Expression*> finishScope(Block* block = nullptr);

  [[nodiscard]] Result<Index> addScratchLocal(Type);
  [[nodiscard]] Result<Expression*> pop();
  void push(Expression*);

  struct HoistedVal {
    // The index in the stack of the original value-producing expression.
    Index valIndex;
    // The local.get placed on the stack, if any.
    LocalGet* get;
  };

  // Find the last value-producing expression, if any, and hoist its value to
  // the top of the stack using a scratch local if necessary.
  [[nodiscard]] MaybeResult<HoistedVal> hoistLastValue();
  // Transform the stack as necessary such that the original producer of the
  // hoisted value will be popped along with the final expression that produces
  // the value, if they are different. May only be called directly after
  // hoistLastValue().
  [[nodiscard]] Result<> packageHoistedValue(const HoistedVal&);
};

} // namespace wasm

#endif // wasm_wasm_ir_builder_h
