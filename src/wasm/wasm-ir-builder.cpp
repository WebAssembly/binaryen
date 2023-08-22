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

#include <cassert>

#include "ir/names.h"
#include "ir/utils.h"
#include "wasm-ir-builder.h"

using namespace std::string_literals;

namespace wasm {

namespace {

Result<> validateTypeAnnotation(HeapType type, Expression* child) {
  if (child->type == Type::unreachable) {
    return Ok{};
  }
  if (!child->type.isRef() ||
      !HeapType::isSubType(child->type.getHeapType(), type)) {
    return Err{"invalid reference type on stack"};
  }
  return Ok{};
}

} // anonymous namespace

std::vector<Expression*>& IRBuilder::getExprStack() {
  if (scopeStack.empty()) {
    // We are not in a function, so push a dummy scope.
    scopeStack.push_back({{}, Type::none});
  }
  return scopeStack.back().exprStack;
}

Result<Index> IRBuilder::addScratchLocal(Type type) {
  if (!func) {
    return Err{"scratch local required, but there is no function context"};
  }
  Name name = Names::getValidLocalName(*func, "scratch");
  return Builder::addVar(func, name, type);
}

Result<> IRBuilder::push(Expression* expr) {
  auto& exprStack = getExprStack();
  if (expr->type == Type::unreachable) {
    // We want to avoid popping back past this most recent unreachable
    // instruction. Drop all prior instructions so they won't be consumed by
    // later instructions but will still be emitted for their side effects, if
    // any.
    for (auto& expr : exprStack) {
      expr = builder.dropIfConcretelyTyped(expr);
    }
    unreachable = true;
    exprStack.push_back(expr);
  } else if (expr->type.isTuple()) {
    auto scratchIdx = addScratchLocal(expr->type);
    CHECK_ERR(scratchIdx);
    CHECK_ERR(push(builder.makeLocalSet(*scratchIdx, expr)));
    for (Index i = 0; i < expr->type.size(); ++i) {
      CHECK_ERR(push(builder.makeTupleExtract(
        builder.makeLocalGet(*scratchIdx, expr->type), i)));
    }
  } else {
    exprStack.push_back(expr);
  }
  return Ok{};
}

Result<Expression*> IRBuilder::pop() {
  auto& exprStack = getExprStack();

  // Find the suffix of expressions that do not produce values.
  auto firstNone = exprStack.size();
  for (; firstNone > 0; --firstNone) {
    auto* expr = exprStack[firstNone - 1];
    if (expr->type != Type::none) {
      break;
    }
  }

  if (firstNone == 0) {
    // There are no expressions that produce values.
    if (unreachable) {
      return builder.makeUnreachable();
    }
    return Err{"popping from empty stack"};
  }

  if (firstNone == exprStack.size()) {
    // The last expression produced a value.
    auto expr = exprStack.back();
    exprStack.pop_back();
    return expr;
  }

  // We need to assemble a block of expressions that returns the value of the
  // first one using a scratch local (unless it's unreachable, in which case
  // we can throw the following expressions away).
  auto* expr = exprStack[firstNone - 1];
  if (expr->type == Type::unreachable) {
    exprStack.resize(firstNone - 1);
    return expr;
  }
  auto scratchIdx = addScratchLocal(expr->type);
  CHECK_ERR(scratchIdx);
  std::vector<Expression*> exprs;
  exprs.reserve(exprStack.size() - firstNone + 2);
  exprs.push_back(builder.makeLocalSet(*scratchIdx, expr));
  exprs.insert(exprs.end(), exprStack.begin() + firstNone, exprStack.end());
  exprs.push_back(builder.makeLocalGet(*scratchIdx, expr->type));

  exprStack.resize(firstNone - 1);
  return builder.makeBlock(exprs, expr->type);
}

Expression* IRBuilder::build() {
  auto& exprStack = getExprStack();
  assert(scopeStack.size() == 1);
  assert(exprStack.size() == 1);

  auto e = exprStack.back();
  exprStack.clear();
  unreachable = false;
  return e;
}

Result<std::vector<Expression*>> IRBuilder::finishInstrs() {
  auto& exprStack = getExprStack();
  auto type = getResultType();

  // We have finished parsing a sequence of instructions. Fix up the parsed
  // instructions and reset the context for the next sequence.
  if (type.isTuple()) {
    std::vector<Expression*> elems(type.size());
    bool hadUnreachableElem = false;
    for (size_t i = 0; i < elems.size(); ++i) {
      auto elem = pop();
      CHECK_ERR(elem);
      elems[elems.size() - 1 - i] = *elem;
      if ((*elem)->type == Type::unreachable) {
        // We don't want to pop back past an unreachable here. Push the
        // unreachable back and throw away any post-unreachable values we have
        // popped.
        exprStack.push_back(*elem);
        hadUnreachableElem = true;
        break;
      }
    }
    if (!hadUnreachableElem) {
      exprStack.push_back(builder.makeTupleMake(std::move(elems)));
    }
  } else if (type != Type::none) {
    // Ensure the last expression produces the value.
    auto expr = pop();
    CHECK_ERR(expr);
    exprStack.push_back(*expr);
  }
  unreachable = false;
  auto ret = std::move(exprStack);
  scopeStack.pop_back();
  return ret;
}

Result<> IRBuilder::visit(Expression* curr) {
  UnifiedExpressionVisitor<IRBuilder, Result<>>::visit(curr);
  if (auto* block = curr->dynCast<Block>()) {
    block->finalize(block->type);
  } else {
    // TODO: Call more efficient versions of finalize() that take the known type
    // for other kinds of nodes as well, as done above.
    ReFinalizeNode{}.visit(curr);
  }
  return push(curr);
}

// Handle the common case of instructions with a constant number of children
// uniformly.
Result<> IRBuilder::visitExpression(Expression* curr) {
#define DELEGATE_ID curr->_id
#define DELEGATE_START(id) [[maybe_unused]] auto* expr = curr->cast<id>();
#define DELEGATE_FIELD_CHILD(id, field)                                        \
  auto field = pop();                                                          \
  CHECK_ERR(field);                                                            \
  expr->field = *field;
#define DELEGATE_END(id)

#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  WASM_UNREACHABLE("should have called visit" #id " because " #id              \
                   " has optional child " #field);
#define DELEGATE_FIELD_CHILD_VECTOR(id, field)                                 \
  WASM_UNREACHABLE("should have called visit" #id " because " #id              \
                   " has child vector " #field);

#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"

  return Ok{};
}

Result<> IRBuilder::visitBlock(Block* curr) {
  // TODO: Handle popping scope and filling block here instead of externally.
  return Ok{};
}

Result<> IRBuilder::visitReturn(Return* curr) {
  if (!func) {
    return Err{"cannot return outside of a function"};
  }
  size_t n = func->getResults().size();
  if (n == 0) {
    curr->value = nullptr;
  } else if (n == 1) {
    auto val = pop();
    CHECK_ERR(val);
    curr->value = *val;
  } else {
    std::vector<Expression*> vals(n);
    for (size_t i = 0; i < n; ++i) {
      auto val = pop();
      CHECK_ERR(val);
      vals[n - i - 1] = *val;
    }
    curr->value = builder.makeTupleMake(vals);
  }
  return Ok{};
}

Result<> IRBuilder::visitStructNew(StructNew* curr) {
  for (size_t i = 0, n = curr->operands.size(); i < n; ++i) {
    auto val = pop();
    CHECK_ERR(val);
    curr->operands[n - 1 - i] = *val;
  }
  return Ok{};
}

Result<> IRBuilder::visitArrayNew(ArrayNew* curr) {
  auto size = pop();
  CHECK_ERR(size);
  curr->size = *size;
  if (!curr->isWithDefault()) {
    auto init = pop();
    CHECK_ERR(init);
    curr->init = *init;
  }
  return Ok{};
}

Result<> IRBuilder::makeNop() { return push(builder.makeNop()); }

Result<> IRBuilder::makeBlock() { return push(builder.makeBlock()); }

// Result<> IRBuilder::makeIf() {}

// Result<> IRBuilder::makeLoop() {}

// Result<> IRBuilder::makeBreak() {}

// Result<> IRBuilder::makeSwitch() {}

// Result<> IRBuilder::makeCall() {}

// Result<> IRBuilder::makeCallIndirect() {}

Result<> IRBuilder::makeLocalGet(Index local) {
  return push(builder.makeLocalGet(local, func->getLocalType(local)));
}

Result<> IRBuilder::makeLocalSet(Index local) {
  LocalSet curr;
  CHECK_ERR(visitLocalSet(&curr));
  return push(builder.makeLocalSet(local, curr.value));
}

Result<> IRBuilder::makeLocalTee(Index local) {
  LocalSet curr;
  CHECK_ERR(visitLocalSet(&curr));
  return push(
    builder.makeLocalTee(local, curr.value, func->getLocalType(local)));
}

Result<> IRBuilder::makeGlobalGet(Name global) {
  return push(builder.makeGlobalGet(global, wasm.getGlobal(global)->type));
}

Result<> IRBuilder::makeGlobalSet(Name global) {
  GlobalSet curr;
  CHECK_ERR(visitGlobalSet(&curr));
  return push(builder.makeGlobalSet(global, curr.value));
}

Result<> IRBuilder::makeLoad(unsigned bytes,
                             bool signed_,
                             Address offset,
                             unsigned align,
                             Type type,
                             Name mem) {
  Load curr;
  CHECK_ERR(visitLoad(&curr));
  return push(
    builder.makeLoad(bytes, signed_, offset, align, curr.ptr, type, mem));
}

Result<> IRBuilder::makeStore(
  unsigned bytes, Address offset, unsigned align, Type type, Name mem) {
  Store curr;
  CHECK_ERR(visitStore(&curr));
  return push(
    builder.makeStore(bytes, offset, align, curr.ptr, curr.value, type, mem));
}

Result<>
IRBuilder::makeAtomicLoad(unsigned bytes, Address offset, Type type, Name mem) {
  Load curr;
  CHECK_ERR(visitLoad(&curr));
  return push(builder.makeAtomicLoad(bytes, offset, curr.ptr, type, mem));
}

Result<> IRBuilder::makeAtomicStore(unsigned bytes,
                                    Address offset,
                                    Type type,
                                    Name mem) {
  Store curr;
  CHECK_ERR(visitStore(&curr));
  return push(
    builder.makeAtomicStore(bytes, offset, curr.ptr, curr.value, type, mem));
}

Result<> IRBuilder::makeAtomicRMW(
  AtomicRMWOp op, unsigned bytes, Address offset, Type type, Name mem) {
  AtomicRMW curr;
  CHECK_ERR(visitAtomicRMW(&curr));
  return push(
    builder.makeAtomicRMW(op, bytes, offset, curr.ptr, curr.value, type, mem));
}

Result<> IRBuilder::makeAtomicCmpxchg(unsigned bytes,
                                      Address offset,
                                      Type type,
                                      Name mem) {
  AtomicCmpxchg curr;
  CHECK_ERR(visitAtomicCmpxchg(&curr));
  return push(builder.makeAtomicCmpxchg(
    bytes, offset, curr.ptr, curr.expected, curr.replacement, type, mem));
}

Result<> IRBuilder::makeAtomicWait(Type type, Address offset, Name mem) {
  AtomicWait curr;
  CHECK_ERR(visitAtomicWait(&curr));
  return push(builder.makeAtomicWait(
    curr.ptr, curr.expected, curr.timeout, type, offset, mem));
}

Result<> IRBuilder::makeAtomicNotify(Address offset, Name mem) {
  AtomicNotify curr;
  CHECK_ERR(visitAtomicNotify(&curr));
  return push(
    builder.makeAtomicNotify(curr.ptr, curr.notifyCount, offset, mem));
}

Result<> IRBuilder::makeAtomicFence() {
  return push(builder.makeAtomicFence());
}

Result<> IRBuilder::makeSIMDExtract(SIMDExtractOp op, uint8_t lane) {
  SIMDExtract curr;
  CHECK_ERR(visitSIMDExtract(&curr));
  return push(builder.makeSIMDExtract(op, curr.vec, lane));
}

Result<> IRBuilder::makeSIMDReplace(SIMDReplaceOp op, uint8_t lane) {
  SIMDReplace curr;
  CHECK_ERR(visitSIMDReplace(&curr));
  return push(builder.makeSIMDReplace(op, curr.vec, lane, curr.value));
}

Result<> IRBuilder::makeSIMDShuffle(const std::array<uint8_t, 16>& lanes) {
  SIMDShuffle curr;
  CHECK_ERR(visitSIMDShuffle(&curr));
  return push(builder.makeSIMDShuffle(curr.left, curr.right, lanes));
}

Result<> IRBuilder::makeSIMDTernary(SIMDTernaryOp op) {
  SIMDTernary curr;
  CHECK_ERR(visitSIMDTernary(&curr));
  return push(builder.makeSIMDTernary(op, curr.a, curr.b, curr.c));
}

Result<> IRBuilder::makeSIMDShift(SIMDShiftOp op) {
  SIMDShift curr;
  CHECK_ERR(visitSIMDShift(&curr));
  return push(builder.makeSIMDShift(op, curr.vec, curr.shift));
}

Result<> IRBuilder::makeSIMDLoad(SIMDLoadOp op,
                                 Address offset,
                                 unsigned align,
                                 Name mem) {
  SIMDLoad curr;
  CHECK_ERR(visitSIMDLoad(&curr));
  return push(builder.makeSIMDLoad(op, offset, align, curr.ptr, mem));
}

Result<> IRBuilder::makeSIMDLoadStoreLane(SIMDLoadStoreLaneOp op,
                                          Address offset,
                                          unsigned align,
                                          uint8_t lane,
                                          Name mem) {
  SIMDLoadStoreLane curr;
  CHECK_ERR(visitSIMDLoadStoreLane(&curr));
  return push(builder.makeSIMDLoadStoreLane(
    op, offset, align, lane, curr.ptr, curr.vec, mem));
}

Result<> IRBuilder::makeMemoryInit(Name data, Name mem) {
  MemoryInit curr;
  CHECK_ERR(visitMemoryInit(&curr));
  return push(
    builder.makeMemoryInit(data, curr.dest, curr.offset, curr.size, mem));
}

Result<> IRBuilder::makeDataDrop(Name data) {
  return push(builder.makeDataDrop(data));
}

Result<> IRBuilder::makeMemoryCopy(Name destMem, Name srcMem) {
  MemoryCopy curr;
  CHECK_ERR(visitMemoryCopy(&curr));
  return push(
    builder.makeMemoryCopy(curr.dest, curr.source, curr.size, destMem, srcMem));
}

Result<> IRBuilder::makeMemoryFill(Name mem) {
  MemoryFill curr;
  CHECK_ERR(visitMemoryFill(&curr));
  return push(builder.makeMemoryFill(curr.dest, curr.value, curr.size, mem));
}

Result<> IRBuilder::makeConst(Literal val) {
  return push(builder.makeConst(val));
}

Result<> IRBuilder::makeUnary(UnaryOp op) {
  Unary curr;
  CHECK_ERR(visitUnary(&curr));
  return push(builder.makeUnary(op, curr.value));
}

Result<> IRBuilder::makeBinary(BinaryOp op) {
  Binary curr;
  CHECK_ERR(visitBinary(&curr));
  return push(builder.makeBinary(op, curr.left, curr.right));
}

Result<> IRBuilder::makeSelect(std::optional<Type> type) {
  Select curr;
  CHECK_ERR(visitSelect(&curr));
  auto* built =
    type ? builder.makeSelect(curr.condition, curr.ifTrue, curr.ifFalse, *type)
         : builder.makeSelect(curr.condition, curr.ifTrue, curr.ifFalse);
  if (type && !Type::isSubType(built->type, *type)) {
    return Err{"select type does not match expected type"};
  }
  return push(built);
}

Result<> IRBuilder::makeDrop() {
  Drop curr;
  CHECK_ERR(visitDrop(&curr));
  return push(builder.makeDrop(curr.value));
}

Result<> IRBuilder::makeReturn() {
  Return curr;
  CHECK_ERR(visitReturn(&curr));
  return push(builder.makeReturn(curr.value));
}

Result<> IRBuilder::makeMemorySize(Name mem) {
  return push(builder.makeMemorySize(mem));
}

Result<> IRBuilder::makeMemoryGrow(Name mem) {
  MemoryGrow curr;
  CHECK_ERR(visitMemoryGrow(&curr));
  return push(builder.makeMemoryGrow(curr.delta, mem));
}

Result<> IRBuilder::makeUnreachable() {
  return push(builder.makeUnreachable());
}

// Result<> IRBuilder::makePop() {}

Result<> IRBuilder::makeRefNull(HeapType type) {
  return push(builder.makeRefNull(type));
}

Result<> IRBuilder::makeRefIsNull() {
  RefIsNull curr;
  CHECK_ERR(visitRefIsNull(&curr));
  return push(builder.makeRefIsNull(curr.value));
}

// Result<> IRBuilder::makeRefFunc() {}

Result<> IRBuilder::makeRefEq() {
  RefEq curr;
  CHECK_ERR(visitRefEq(&curr));
  return push(builder.makeRefEq(curr.left, curr.right));
}

// Result<> IRBuilder::makeTableGet() {}

// Result<> IRBuilder::makeTableSet() {}

// Result<> IRBuilder::makeTableSize() {}

// Result<> IRBuilder::makeTableGrow() {}

// Result<> IRBuilder::makeTry() {}

// Result<> IRBuilder::makeThrow() {}

// Result<> IRBuilder::makeRethrow() {}

// Result<> IRBuilder::makeTupleMake() {}

// Result<> IRBuilder::makeTupleExtract() {}

Result<> IRBuilder::makeI31New() {
  I31New curr;
  CHECK_ERR(visitI31New(&curr));
  return push(builder.makeI31New(curr.value));
}

Result<> IRBuilder::makeI31Get(bool signed_) {
  I31Get curr;
  CHECK_ERR(visitI31Get(&curr));
  return push(builder.makeI31Get(curr.i31, signed_));
}

// Result<> IRBuilder::makeCallRef() {}

// Result<> IRBuilder::makeRefTest() {}

// Result<> IRBuilder::makeRefCast() {}

// Result<> IRBuilder::makeBrOn() {}

Result<> IRBuilder::makeStructNew(HeapType type) {
  StructNew curr(wasm.allocator);
  // Differentiate from struct.new_default with a non-empty expression list.
  curr.operands.resize(type.getStruct().fields.size());
  CHECK_ERR(visitStructNew(&curr));
  return push(builder.makeStructNew(type, std::move(curr.operands)));
}

Result<> IRBuilder::makeStructNewDefault(HeapType type) {
  return push(builder.makeStructNew(type, {}));
}

Result<> IRBuilder::makeStructGet(HeapType type, Index field, bool signed_) {
  const auto& fields = type.getStruct().fields;
  StructGet curr;
  CHECK_ERR(visitStructGet(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  return push(
    builder.makeStructGet(field, curr.ref, fields[field].type, signed_));
}

Result<> IRBuilder::makeStructSet(HeapType type, Index field) {
  StructSet curr;
  CHECK_ERR(visitStructSet(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  return push(builder.makeStructSet(field, curr.ref, curr.value));
}

Result<> IRBuilder::makeArrayNew(HeapType type) {
  ArrayNew curr;
  // Differentiate from array.new_default with dummy initializer.
  curr.init = (Expression*)0x01;
  CHECK_ERR(visitArrayNew(&curr));
  return push(builder.makeArrayNew(type, curr.size, curr.init));
}

Result<> IRBuilder::makeArrayNewDefault(HeapType type) {
  ArrayNew curr;
  CHECK_ERR(visitArrayNew(&curr));
  return push(builder.makeArrayNew(type, curr.size));
}

Result<> IRBuilder::makeArrayNewData(HeapType type, Name data) {
  ArrayNewData curr;
  CHECK_ERR(visitArrayNewData(&curr));
  return push(builder.makeArrayNewData(type, data, curr.offset, curr.size));
}

Result<> IRBuilder::makeArrayNewElem(HeapType type, Name elem) {
  ArrayNewElem curr;
  CHECK_ERR(visitArrayNewElem(&curr));
  return push(builder.makeArrayNewElem(type, elem, curr.offset, curr.size));
}

// Result<> IRBuilder::makeArrayNewFixed() {}

Result<> IRBuilder::makeArrayGet(HeapType type, bool signed_) {
  ArrayGet curr;
  CHECK_ERR(visitArrayGet(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  return push(builder.makeArrayGet(
    curr.ref, curr.index, type.getArray().element.type, signed_));
}

Result<> IRBuilder::makeArraySet(HeapType type) {
  ArraySet curr;
  CHECK_ERR(visitArraySet(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  return push(builder.makeArraySet(curr.ref, curr.index, curr.value));
}

Result<> IRBuilder::makeArrayLen() {
  ArrayLen curr;
  CHECK_ERR(visitArrayLen(&curr));
  return push(builder.makeArrayLen(curr.ref));
}

Result<> IRBuilder::makeArrayCopy(HeapType destType, HeapType srcType) {
  ArrayCopy curr;
  CHECK_ERR(visitArrayCopy(&curr));
  CHECK_ERR(validateTypeAnnotation(destType, curr.destRef));
  CHECK_ERR(validateTypeAnnotation(srcType, curr.srcRef));
  return push(builder.makeArrayCopy(
    curr.destRef, curr.destIndex, curr.srcRef, curr.srcIndex, curr.length));
}

Result<> IRBuilder::makeArrayFill(HeapType type) {
  ArrayFill curr;
  CHECK_ERR(visitArrayFill(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  return push(
    builder.makeArrayFill(curr.ref, curr.index, curr.value, curr.size));
}

// Result<> IRBuilder::makeArrayInitData() {}

// Result<> IRBuilder::makeArrayInitElem() {}

// Result<> IRBuilder::makeRefAs() {}

// Result<> IRBuilder::makeStringNew() {}

// Result<> IRBuilder::makeStringConst() {}

// Result<> IRBuilder::makeStringMeasure() {}

// Result<> IRBuilder::makeStringEncode() {}

// Result<> IRBuilder::makeStringConcat() {}

// Result<> IRBuilder::makeStringEq() {}

// Result<> IRBuilder::makeStringAs() {}

// Result<> IRBuilder::makeStringWTF8Advance() {}

// Result<> IRBuilder::makeStringWTF16Get() {}

// Result<> IRBuilder::makeStringIterNext() {}

// Result<> IRBuilder::makeStringIterMove() {}

// Result<> IRBuilder::makeStringSliceWTF() {}

// Result<> IRBuilder::makeStringSliceIter() {}

} // namespace wasm
