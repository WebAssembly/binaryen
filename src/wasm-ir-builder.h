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

#include "ir/names.h"
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
//
// Unlike `Builder`, `IRBuilder` requires referenced module-level items (e.g.
// globals, tables, functions, etc.) to already exist in the module.
class IRBuilder : public UnifiedExpressionVisitor<IRBuilder, Result<>> {
public:
  IRBuilder(Module& wasm) : wasm(wasm), builder(wasm) {}

  // Get the valid Binaryen IR expression representing the sequence of visited
  // instructions. The IRBuilder is reset and can be used with a fresh sequence
  // of instructions after this is called.
  Result<Expression*> build();

  // If the IRBuilder is empty, then it's ready to parse a new self-contained
  // sequence of instructions.
  [[nodiscard]] bool empty() { return scopeStack.empty(); }

  // Call visit() on an existing Expression with its non-child fields
  // initialized to initialize the child fields and refinalize it.
  Result<> visit(Expression*);

  // The origin of an expression.
  enum class Origin {
    // The expression originates in the binary we are reading. We track binary
    // locations for such instructions where necessary (for code annotations,
    // etc.).
    Binary = 0,
    // The expression was synthetically added by the IRBuilder (e.g. a local.get
    // of a scratch local).
    Synthetic = 1
  };

  // Like visit, but pushes the expression onto the stack as-is without popping
  // any children or refinalization.
  void push(Expression*, Origin origin = Origin::Binary);
  void pushSynthetic(Expression* expr) { push(expr, Origin::Synthetic); }

  // Set the debug location to be attached to the next visited, created, or
  // pushed instruction.
  void setDebugLocation(const std::optional<Function::DebugLocation>&);

  // Give the builder a pointer to the counter tracking the current location in
  // the binary. If this pointer is non-null, the builder will record the binary
  // locations relative to the given code section offset for all instructions
  // and delimiters inside functions.
  void setBinaryLocation(size_t* binaryPos, size_t codeSectionOffset) {
    this->binaryPos = binaryPos;
    this->codeSectionOffset = codeSectionOffset;
  }

  // The current function, used to create scratch locals, add annotations, etc.
  void setFunction(Function* func) { this->func = func; }

  // Handle the boundaries of control flow structures. Users may choose to use
  // the corresponding `makeXYZ` function below instead of `visitXYZStart`, but
  // either way must call `visitEnd` and friends at the appropriate times.
  Result<> visitFunctionStart(Function* func);
  Result<> visitBlockStart(Block* block, Type inputType = Type::none);
  Result<> visitIfStart(If* iff, Name label = {}, Type inputType = Type::none);
  Result<> visitElse();
  Result<> visitLoopStart(Loop* iff, Type inputType = Type::none);
  Result<>
  visitTryStart(Try* tryy, Name label = {}, Type inputType = Type::none);
  Result<> visitCatch(Name tag);
  Result<> visitCatchAll();
  Result<> visitDelegate(Index label);
  Result<> visitTryTableStart(TryTable* trytable,
                              Name label = {},
                              Type inputType = Type::none);
  Result<> visitEnd();

  // Used to visit break nodes when traversing a single block without its
  // context. The type indicates how many values the break carries to its
  // destination.
  Result<> visitBreakWithType(Break*, Type);
  // Used to visit switch nodes when traversing a single block without its
  // context. The type indicates how many values the switch carries to its
  // destination.
  Result<> visitSwitchWithType(Switch*, Type);

  // Binaryen IR uses names to refer to branch targets, but in general there may
  // be branches to constructs that do not yet have names, so in IRBuilder we
  // use indices to refer to branch targets instead, just as the binary format
  // does. This function converts a branch target name to the correct index.
  //
  // Labels in delegates need special handling because the indexing needs to be
  // relative to the try's enclosing scope rather than the try itself.
  Result<Index> getLabelIndex(Name label, bool inDelegate = false);

  // Instead of calling visit, call makeXYZ to have the IRBuilder allocate the
  // nodes. This is generally safer than calling `visit` because the function
  // signatures ensure that there are no missing fields.
  Result<> makeNop();
  Result<> makeBlock(Name label, Signature sig);
  Result<>
  makeIf(Name label, Signature sig, std::optional<bool> likely = std::nullopt);
  Result<> makeLoop(Name label, Signature sig);
  Result<> makeBreak(Index label,
                     bool isConditional,
                     std::optional<bool> likely = std::nullopt);
  Result<> makeSwitch(const std::vector<Index>& labels, Index defaultLabel);
  // Unlike Builder::makeCall, this assumes the function already exists.
  Result<> makeCall(Name func,
                    bool isReturn,
                    std::optional<std::uint8_t> inline_ = std::nullopt);
  Result<> makeCallIndirect(Name table,
                            HeapType type,
                            bool isReturn,
                            std::optional<std::uint8_t> inline_ = std::nullopt);
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
  Result<> makePause();
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
  Result<> makePop(Type type);
  Result<> makeRefNull(HeapType type);
  Result<> makeRefIsNull();
  Result<> makeRefFunc(Name func);
  Result<> makeRefEq();
  Result<> makeTableGet(Name table);
  Result<> makeTableSet(Name table);
  Result<> makeTableSize(Name table);
  Result<> makeTableGrow(Name table);
  Result<> makeTableFill(Name table);
  Result<> makeTableCopy(Name destTable, Name srcTable);
  Result<> makeTableInit(Name elem, Name table);
  Result<> makeElemDrop(Name elem);
  Result<> makeTry(Name label, Signature sig);
  Result<> makeTryTable(Name label,
                        Signature sig,
                        const std::vector<Name>& tags,
                        const std::vector<Index>& labels,
                        const std::vector<bool>& isRefs);
  Result<> makeThrow(Name tag);
  Result<> makeRethrow(Index label);
  Result<> makeThrowRef();
  Result<> makeTupleMake(uint32_t arity);
  Result<> makeTupleExtract(uint32_t arity, uint32_t index);
  Result<> makeTupleDrop(uint32_t arity);
  Result<> makeRefI31(Shareability share);
  Result<> makeI31Get(bool signed_);
  Result<> makeCallRef(HeapType type,
                       bool isReturn,
                       std::optional<std::uint8_t> inline_ = std::nullopt);
  Result<> makeRefTest(Type type);
  Result<> makeRefCast(Type type, bool isDesc);
  Result<> makeRefGetDesc(HeapType type);
  Result<> makeBrOn(Index label,
                    BrOnOp op,
                    Type in = Type::none,
                    Type out = Type::none,
                    std::optional<bool> likely = std::nullopt);
  Result<> makeStructNew(HeapType type);
  Result<> makeStructNewDefault(HeapType type);
  Result<>
  makeStructGet(HeapType type, Index field, bool signed_, MemoryOrder order);
  Result<> makeStructSet(HeapType type, Index field, MemoryOrder order);
  Result<>
  makeStructRMW(AtomicRMWOp op, HeapType type, Index field, MemoryOrder order);
  Result<> makeStructCmpxchg(HeapType type, Index field, MemoryOrder order);
  Result<> makeArrayNew(HeapType type);
  Result<> makeArrayNewDefault(HeapType type);
  Result<> makeArrayNewData(HeapType type, Name data);
  Result<> makeArrayNewElem(HeapType type, Name elem);
  Result<> makeArrayNewFixed(HeapType type, uint32_t arity);
  Result<> makeArrayGet(HeapType type, bool signed_, MemoryOrder order);
  Result<> makeArraySet(HeapType type, MemoryOrder order);
  Result<> makeArrayLen();
  Result<> makeArrayCopy(HeapType destType, HeapType srcType);
  Result<> makeArrayFill(HeapType type);
  Result<> makeArrayInitData(HeapType type, Name data);
  Result<> makeArrayInitElem(HeapType type, Name elem);
  Result<> makeArrayRMW(AtomicRMWOp op, HeapType type, MemoryOrder order);
  Result<> makeArrayCmpxchg(HeapType type, MemoryOrder order);
  Result<> makeRefAs(RefAsOp op);
  Result<> makeStringNew(StringNewOp op);
  Result<> makeStringConst(Name string);
  Result<> makeStringMeasure(StringMeasureOp op);
  Result<> makeStringEncode(StringEncodeOp op);
  Result<> makeStringConcat();
  Result<> makeStringEq(StringEqOp op);
  Result<> makeStringTest();
  Result<> makeStringWTF8Advance();
  Result<> makeStringWTF16Get();
  Result<> makeStringIterNext();
  Result<> makeStringSliceWTF();
  Result<> makeContNew(HeapType ct);
  Result<> makeContBind(HeapType sourceType, HeapType targetType);
  Result<> makeSuspend(Name tag);
  Result<> makeResume(HeapType ct,
                      const std::vector<Name>& tags,
                      const std::vector<std::optional<Index>>& labels);
  Result<> makeResumeThrow(HeapType ct,
                           Name tag,
                           const std::vector<Name>& tags,
                           const std::vector<std::optional<Index>>& labels);
  Result<> makeStackSwitch(HeapType ct, Name tag);

  // Private functions that must be public for technical reasons.
  Result<> visitExpression(Expression*);

  // Do not push pops onto the stack since we generate our own pops as necessary
  // when visiting the beginnings of try blocks.
  Result<> visitPop(Pop*) { return Ok{}; }

private:
  Module& wasm;
  Function* func = nullptr;
  Builder builder;

  // Used for setting DWARF expression locations.
  size_t* binaryPos = nullptr;
  size_t lastBinaryPos = 0;
  size_t codeSectionOffset = 0;

  // The location lacks debug info as it was marked as not having it.
  struct NoDebug : public std::monostate {};
  // The location lacks debug info, but was not marked as not having
  // it, and it can receive it from the parent or its previous sibling
  // (if it has one).
  struct CanReceiveDebug : public std::monostate {};
  using DebugVariant =
    std::variant<NoDebug, CanReceiveDebug, Function::DebugLocation>;

  DebugVariant debugLoc;

  struct ChildPopper;

  void applyDebugLoc(Expression* expr);

  // The context for a single block scope, including the instructions parsed
  // inside that scope so far and the ultimate result type we expect this block
  // to have.
  struct ScopeCtx {
    struct NoScope {};
    struct FuncScope {
      Function* func;
      // Used to determine whether we need to run a fixup after creating the
      // function.
      bool hasSyntheticBlock = false;
      bool hasPop = false;
    };
    struct BlockScope {
      Block* block;
    };
    struct IfScope {
      If* iff;
      Name originalLabel;
    };
    struct ElseScope {
      If* iff;
      Name originalLabel;
    };
    struct LoopScope {
      Loop* loop;
    };
    struct TryScope {
      Try* tryy;
      Name originalLabel;
      Index index;
    };
    struct CatchScope {
      Try* tryy;
      Name originalLabel;
      Index index;
    };
    struct CatchAllScope {
      Try* tryy;
      Name originalLabel;
      Index index;
    };
    struct TryTableScope {
      TryTable* trytable;
      Name originalLabel;
    };
    using Scope = std::variant<NoScope,
                               FuncScope,
                               BlockScope,
                               IfScope,
                               ElseScope,
                               LoopScope,
                               TryScope,
                               CatchScope,
                               CatchAllScope,
                               TryTableScope>;

    // The control flow structure we are building expressions for.
    Scope scope;

    // The branch label name for this scope. Always fresh, never shadowed.
    Name label;

    // For Try/Catch/CatchAll scopes, we need to separately track a label used
    // for branches, since the normal label is only used for delegates.
    Name branchLabel;

    bool labelUsed = false;

    // If the control flow scope has an input type, we need to lower it using a
    // scratch local because we cannot represent control flow input in the IR.
    Type inputType;
    Index inputLocal = -1;

    // If there are br_on_*, try_table, or resume branches that target this
    // scope and carry additional values, we need to use a scratch local to
    // deliver those additional values because the IR does not support them. We
    // may need scratch locals of different arities for the same branch target.
    // For each arity we also need a trampoline label to branch to. TODO:
    // Support additional values on any branch once we have better multivalue
    // optimization support.
    std::vector<Index> outputLocals;
    std::vector<Name> outputLabels;

    // The stack of instructions being built in this scope.
    std::vector<Expression*> exprStack;

    // Whether we have seen an unreachable instruction and are in
    // stack-polymorphic unreachable mode.
    bool unreachable = false;

    // The binary location of the start of the scope, used to set debug info.
    size_t startPos = 0;

    ScopeCtx() : scope(NoScope{}) {}
    ScopeCtx(Scope scope, Type inputType)
      : scope(scope), inputType(inputType) {}
    ScopeCtx(
      Scope scope, Name label, bool labelUsed, Type inputType, Index inputLocal)
      : scope(scope), label(label), labelUsed(labelUsed), inputType(inputType),
        inputLocal(inputLocal) {}
    ScopeCtx(Scope scope, Name label, bool labelUsed, Name branchLabel)
      : scope(scope), label(label), branchLabel(branchLabel),
        labelUsed(labelUsed) {}

    static ScopeCtx makeFunc(Function* func) {
      return ScopeCtx(FuncScope{func}, Type::none);
    }
    static ScopeCtx makeBlock(Block* block, Type inputType) {
      return ScopeCtx(BlockScope{block}, inputType);
    }
    static ScopeCtx makeIf(If* iff, Name originalLabel, Type inputType) {
      return ScopeCtx(IfScope{iff, originalLabel}, inputType);
    }
    static ScopeCtx makeElse(ScopeCtx&& scope) {
      scope.scope = ElseScope{scope.getIf(), scope.getOriginalLabel()};
      scope.resetForDelimiter(/*keepInput=*/true);
      return scope;
    }
    static ScopeCtx makeLoop(Loop* loop, Type inputType) {
      return ScopeCtx(LoopScope{loop}, inputType);
    }
    static ScopeCtx makeTry(Try* tryy, Name originalLabel, Type inputType) {
      return ScopeCtx(TryScope{tryy, originalLabel, 0}, inputType);
    }
    static ScopeCtx makeCatch(ScopeCtx&& scope, Try* tryy) {
      scope.scope =
        CatchScope{tryy, scope.getOriginalLabel(), scope.getIndex() + 1};
      scope.resetForDelimiter(/*keepInput=*/false);
      return scope;
    }
    static ScopeCtx makeCatchAll(ScopeCtx&& scope, Try* tryy) {
      scope.scope =
        CatchAllScope{tryy, scope.getOriginalLabel(), scope.getIndex() + 1};
      scope.resetForDelimiter(/*keepInput=*/false);
      return scope;
    }
    static ScopeCtx
    makeTryTable(TryTable* trytable, Name originalLabel, Type inputType) {
      return ScopeCtx(TryTableScope{trytable, originalLabel}, inputType);
    }
    // When transitioning to a new scope for a delimiter like `else` or catch,
    // most of the scope context is preserved, but some parts need to be reset.
    // `keepInput` means that control flow parameters are available at the
    // begninning of the scope after the delimiter.
    void resetForDelimiter(bool keepInput) {
      exprStack.clear();
      unreachable = false;
      if (!keepInput) {
        inputType = Type::none;
        inputLocal = -1;
      }
    }
    bool isNone() { return std::get_if<NoScope>(&scope); }
    Function* getFunction() {
      if (auto* funcScope = std::get_if<FuncScope>(&scope)) {
        return funcScope->func;
      }
      return nullptr;
    }
    void noteSyntheticBlock() {
      if (auto* funcScope = std::get_if<FuncScope>(&scope)) {
        funcScope->hasSyntheticBlock = true;
      }
    }
    void notePop() {
      if (auto* funcScope = std::get_if<FuncScope>(&scope)) {
        funcScope->hasPop = true;
      }
    }
    bool needsPopFixup() {
      // If the function has a synthetic block and it has a pop, then it's
      // possible that the pop is inside the synthetic block and we should run
      // the fixup. Determining more precisely that a pop is inside the
      // synthetic block when it is created would be complicated and expensive,
      // so we are conservative here.
      if (auto* funcScope = std::get_if<FuncScope>(&scope)) {
        return funcScope->hasSyntheticBlock && funcScope->hasPop;
      }
      return false;
    }
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
    Try* getTry() {
      if (auto* tryScope = std::get_if<TryScope>(&scope)) {
        return tryScope->tryy;
      }
      return nullptr;
    }
    Try* getCatch() {
      if (auto* catchScope = std::get_if<CatchScope>(&scope)) {
        return catchScope->tryy;
      }
      return nullptr;
    }
    Try* getCatchAll() {
      if (auto* catchAllScope = std::get_if<CatchAllScope>(&scope)) {
        return catchAllScope->tryy;
      }
      return nullptr;
    }
    TryTable* getTryTable() {
      if (auto* tryTableScope = std::get_if<TryTableScope>(&scope)) {
        return tryTableScope->trytable;
      }
      return nullptr;
    }
    Type getResultType() {
      if (auto* func = getFunction()) {
        return func->type.getSignature().results;
      }
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
      if (auto* tryy = getTry()) {
        return tryy->type;
      }
      if (auto* tryy = getCatch()) {
        return tryy->type;
      }
      if (auto* tryy = getCatchAll()) {
        return tryy->type;
      }
      if (auto* trytable = getTryTable()) {
        return trytable->type;
      }
      WASM_UNREACHABLE("unexpected scope kind");
    }
    Index getIndex() {
      if (auto* tryScope = std::get_if<TryScope>(&scope)) {
        return tryScope->index;
      }
      if (auto* catchScope = std::get_if<CatchScope>(&scope)) {
        return catchScope->index;
      }
      if (auto* catchAllScope = std::get_if<CatchAllScope>(&scope)) {
        return catchAllScope->index;
      }
      WASM_UNREACHABLE("unexpected scope kind");
    }
    Type getLabelType() {
      // Loops receive their input type rather than their output type.
      return getLoop() ? inputType : getResultType();
    }
    Name getOriginalLabel() {
      if (std::get_if<NoScope>(&scope) || getFunction()) {
        return Name{};
      }
      if (auto* block = getBlock()) {
        return block->name;
      }
      if (auto* ifScope = std::get_if<IfScope>(&scope)) {
        return ifScope->originalLabel;
      }
      if (auto* elseScope = std::get_if<ElseScope>(&scope)) {
        return elseScope->originalLabel;
      }
      if (auto* loop = getLoop()) {
        return loop->name;
      }
      if (auto* tryScope = std::get_if<TryScope>(&scope)) {
        return tryScope->originalLabel;
      }
      if (auto* catchScope = std::get_if<CatchScope>(&scope)) {
        return catchScope->originalLabel;
      }
      if (auto* catchAllScope = std::get_if<CatchAllScope>(&scope)) {
        return catchAllScope->originalLabel;
      }
      if (auto* tryTableScope = std::get_if<TryTableScope>(&scope)) {
        return tryTableScope->originalLabel;
      }
      WASM_UNREACHABLE("unexpected scope kind");
    }
    bool isDelimiter() { return getElse() || getCatch() || getCatchAll(); }
  };

  // The stack of block contexts currently being parsed.
  std::vector<ScopeCtx> scopeStack;

  // Map label names to stacks of label depths at which they appear. The
  // relative index of a label name is the current depth minus the top depth on
  // its stack.
  std::unordered_map<Name, std::vector<Index>> labelDepths;

  Name makeFresh(Name label, Index hint = 0) {
    return Names::getValidName(
      label,
      [&](Name candidate) {
        return labelDepths.insert({candidate, {}}).second;
      },
      hint,
      "");
  }

  Index blockHint = 0;
  Index labelHint = 0;

  Result<> pushScope(ScopeCtx&& scope) {
    if (auto label = scope.getOriginalLabel()) {
      // Assign a fresh label to the scope, if necessary.
      if (!scope.label) {
        scope.label = makeFresh(label);
      }
      // Record the original label to handle references to it correctly.
      labelDepths[label].push_back(scopeStack.size() + 1);
    }
    if (binaryPos) {
      scope.startPos = lastBinaryPos;
      lastBinaryPos = *binaryPos;
    }
    bool hasInput = scope.inputType != Type::none;
    Index inputLocal = scope.inputLocal;
    if (hasInput && !scope.isDelimiter()) {
      if (inputLocal == Index(-1)) {
        auto scratch = addScratchLocal(scope.inputType);
        CHECK_ERR(scratch);
        inputLocal = scope.inputLocal = *scratch;
      }
      CHECK_ERR(makeLocalSet(inputLocal));
    }
    scopeStack.emplace_back(std::move(scope));
    if (hasInput) {
      CHECK_ERR(makeLocalGet(inputLocal));
    }
    return Ok{};
  }

  ScopeCtx& getScope() {
    if (scopeStack.empty()) {
      // We are not in a block context, so push a dummy scope.
      scopeStack.push_back({});
    }
    return scopeStack.back();
  }

  Result<ScopeCtx*> getScope(Index label) {
    Index numLabels = scopeStack.size();
    if (!scopeStack.empty() && scopeStack[0].isNone()) {
      --numLabels;
    }
    if (label >= numLabels) {
      return Err{"label index out of bounds"};
    }
    return &scopeStack[scopeStack.size() - 1 - label];
  }

  // Collect the current scope into a single expression. If it has multiple
  // top-level expressions, this requires collecting them into a block. If we
  // are in a block context, we can collect them directly into the destination
  // `block`, but otherwise we will have to allocate a new block.
  Result<Expression*> finishScope(Block* block = nullptr);

  Result<Name> getLabelName(Index label, bool forDelegate = false);
  Result<Name> getDelegateLabelName(Index label) {
    return getLabelName(label, true);
  }
  Result<Index> addScratchLocal(Type);

  struct HoistedVal {
    // The index in the stack of the original value-producing expression.
    Index valIndex;
    // The local.get placed on the stack, if any.
    LocalGet* get;
  };

  // Find the last value-producing expression, if any, and hoist its value to
  // the top of the stack using a scratch local if necessary.
  MaybeResult<HoistedVal> hoistLastValue();
  // Transform the stack as necessary such that the original producer of the
  // hoisted value will be popped along with the final expression that produces
  // the value, if they are different. May only be called directly after
  // hoistLastValue(). `sizeHint` is the size of the type we ultimately want to
  // consume, so if the hoisted value has `sizeHint` elements, it is left intact
  // even if it is a tuple. Otherwise, hoisted tuple values will be broken into
  // pieces.
  Result<> packageHoistedValue(const HoistedVal&, size_t sizeHint = 1);

  Result<Type> getLabelType(Index label);
  Result<Type> getLabelType(Name labelName);

  Result<std::pair<Index, Name>> getExtraOutputLocalAndLabel(Index label,
                                                             size_t extraArity);
  Expression* fixExtraOutput(ScopeCtx& scope, Name label, Expression* expr);
  void fixLoopWithInput(Loop* loop, Type inputType, Index scratch);

  // Add a branch hint, if |likely| is present.
  void addBranchHint(Expression* expr, std::optional<bool> likely);

  // Add an inlining hint, if |inline_| is present.
  void addInlineHint(Expression* expr, std::optional<std::uint8_t> inline_);

  void dump();
};

} // namespace wasm

#endif // wasm_wasm_ir_builder_h
