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

Result<Index> IRBuilder::addScratchLocal(Type type) {
  if (!func) {
    return Err{"scratch local required, but there is no function context"};
  }
  Name name = Names::getValidLocalName(*func, "scratch");
  return Builder::addVar(func, name, type);
}

MaybeResult<IRBuilder::HoistedVal> IRBuilder::hoistLastValue() {
  auto& stack = getScope().exprStack;
  int index = stack.size() - 1;
  for (; index >= 0; --index) {
    if (stack[index]->type != Type::none) {
      break;
    }
  }
  if (index < 0) {
    // There is no value-producing or unreachable expression.
    return {};
  }
  if (unsigned(index) == stack.size() - 1) {
    // Value-producing expression already on top of the stack.
    return HoistedVal{Index(index), nullptr};
  }
  auto*& expr = stack[index];
  auto type = expr->type;
  if (type == Type::unreachable) {
    // Make sure the top of the stack also has an unreachable expression.
    if (stack.back()->type != Type::unreachable) {
      push(builder.makeUnreachable());
    }
    return HoistedVal{Index(index), nullptr};
  }
  // Hoist with a scratch local.
  auto scratchIdx = addScratchLocal(type);
  CHECK_ERR(scratchIdx);
  expr = builder.makeLocalSet(*scratchIdx, expr);
  auto* get = builder.makeLocalGet(*scratchIdx, type);
  push(get);
  return HoistedVal{Index(index), get};
}

Result<> IRBuilder::packageHoistedValue(const HoistedVal& hoisted) {
  auto& scope = getScope();
  assert(!scope.exprStack.empty());

  auto packageAsBlock = [&](Type type) {
    // Create a block containing the producer of the hoisted value, the final
    // get of the hoisted value, and everything in between.
    std::vector<Expression*> exprs(scope.exprStack.begin() + hoisted.valIndex,
                                   scope.exprStack.end());
    auto* block = builder.makeBlock(exprs, type);
    scope.exprStack.resize(hoisted.valIndex);
    push(block);
  };

  auto type = scope.exprStack.back()->type;

  if (!type.isTuple()) {
    if (hoisted.get) {
      packageAsBlock(type);
    }
    return Ok{};
  }

  // We need to break up the hoisted tuple. Create and push a block setting the
  // tuple to a local and returning its first element, then push additional gets
  // of each of its subsequent elements. Reuse the scratch local we used for
  // hoisting, if it exists.
  Index scratchIdx;
  if (hoisted.get) {
    // Update the get on top of the stack to just return the first element.
    scope.exprStack.back() = builder.makeTupleExtract(hoisted.get, 0);
    packageAsBlock(type[0]);
    scratchIdx = hoisted.get->index;
  } else {
    auto scratch = addScratchLocal(type);
    CHECK_ERR(scratch);
    auto* block = builder.makeSequence(
      builder.makeLocalSet(*scratch, scope.exprStack.back()),
      builder.makeTupleExtract(builder.makeLocalGet(*scratch, type), 0),
      type[0]);
    scope.exprStack.pop_back();
    push(block);
    scratchIdx = *scratch;
  }
  for (Index i = 1, size = type.size(); i < size; ++i) {
    push(builder.makeTupleExtract(builder.makeLocalGet(scratchIdx, type), i));
  }
  return Ok{};
}

void IRBuilder::push(Expression* expr) {
  auto& scope = getScope();
  if (expr->type == Type::unreachable) {
    // We want to avoid popping back past this most recent unreachable
    // instruction. Drop all prior instructions so they won't be consumed by
    // later instructions but will still be emitted for their side effects, if
    // any.
    for (auto& expr : scope.exprStack) {
      expr = builder.dropIfConcretelyTyped(expr);
    }
    scope.unreachable = true;
  }
  scope.exprStack.push_back(expr);
}

Result<Expression*> IRBuilder::pop() {
  auto& scope = getScope();

  // Find the suffix of expressions that do not produce values.
  auto hoisted = hoistLastValue();
  CHECK_ERR(hoisted);

  if (!hoisted) {
    // There are no expressions that produce values.
    if (scope.unreachable) {
      return builder.makeUnreachable();
    }
    return Err{"popping from empty stack"};
  }

  CHECK_ERR(packageHoistedValue(*hoisted));

  auto* ret = scope.exprStack.back();
  scope.exprStack.pop_back();
  return ret;
}

Result<Expression*> IRBuilder::build() {
  if (scopeStack.empty()) {
    return builder.makeNop();
  }
  if (scopeStack.size() > 1 || !scopeStack.back().isNone()) {
    return Err{"unfinished block context"};
  }
  if (scopeStack.back().exprStack.size() > 1) {
    return Err{"unused expressions without block context"};
  }
  assert(scopeStack.back().exprStack.size() == 1);
  auto* expr = scopeStack.back().exprStack.back();
  scopeStack.clear();
  return expr;
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
  push(curr);
  return Ok{};
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
  // No children; pushing and finalizing will be handled by `visit`.
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

Result<> IRBuilder::visitBlockStart(Block* curr) {
  scopeStack.push_back(ScopeCtx::makeBlock(curr));
  return Ok{};
}

Result<> IRBuilder::visitIfStart(If* iff, Name label) {
  auto cond = pop();
  CHECK_ERR(cond);
  iff->condition = *cond;
  scopeStack.push_back(ScopeCtx::makeIf(iff, label));
  return Ok{};
}

Result<> IRBuilder::visitLoopStart(Loop* loop) {
  scopeStack.push_back(ScopeCtx::makeLoop(loop));
  return Ok{};
}

Result<Expression*> IRBuilder::finishScope(Block* block) {
  if (scopeStack.empty() || scopeStack.back().isNone()) {
    return Err{"unexpected end of scope"};
  }

  auto& scope = scopeStack.back();
  auto type = scope.getResultType();
  if (type.isTuple()) {
    if (scope.unreachable) {
      // We may not have enough concrete values on the stack to construct the
      // full tuple, and if we tried to fill out the beginning of a tuple.make
      // with additional popped `unreachable`s, that could cause a trap to
      // happen before important side effects. Instead, just drop everything on
      // the stack and finish with a single unreachable.
      //
      // TODO: Validate that the available expressions are a correct suffix of
      // the expected type, since this will no longer be caught by normal
      // validation?
      for (auto& expr : scope.exprStack) {
        expr = builder.dropIfConcretelyTyped(expr);
      }
      if (scope.exprStack.back()->type != Type::unreachable) {
        scope.exprStack.push_back(builder.makeUnreachable());
      }
    } else {
      auto hoisted = hoistLastValue();
      CHECK_ERR(hoisted);
      auto hoistedType = scope.exprStack.back()->type;
      if (hoistedType.size() != block->type.size()) {
        // We cannot propagate the hoisted value directly because it does not
        // have the correct number of elements. Break it up if necessary and
        // construct our returned tuple from parts.
        CHECK_ERR(packageHoistedValue(*hoisted));
        std::vector<Expression*> elems(block->type.size());
        for (size_t i = 0; i < elems.size(); ++i) {
          auto elem = pop();
          CHECK_ERR(elem);
          elems[elems.size() - 1 - i] = *elem;
        }
        scope.exprStack.push_back(builder.makeTupleMake(std::move(elems)));
      }
    }
  } else if (type.isConcrete()) {
    // If the value is buried in none-typed expressions, we have to bring it to
    // the top.
    auto hoisted = hoistLastValue();
    CHECK_ERR(hoisted);
  }
  Expression* ret = nullptr;
  if (scope.exprStack.size() == 0) {
    // No expressions for this scope, but we need something. If we were given a
    // block, we can empty it out and return it, but otherwise we need a nop.
    if (block) {
      block->list.clear();
      ret = block;
    } else {
      ret = builder.makeNop();
    }
  } else if (scope.exprStack.size() == 1) {
    // We can put our single expression directly into the surrounding scope.
    if (block) {
      block->list.resize(1);
      block->list[0] = scope.exprStack.back();
      ret = block;
    } else {
      ret = scope.exprStack.back();
    }
  } else {
    // More than one expression, so we need a block. Allocate one if we weren't
    // already given one.
    if (!block) {
      block = wasm.allocator.alloc<Block>();
      block->type = type;
    }
    block->list.set(scope.exprStack);
    ret = block;
  }
  scopeStack.pop_back();
  return ret;
}

Result<> IRBuilder::visitElse() {
  auto& scope = getScope();
  auto* iff = scope.getIf();
  if (!iff) {
    return Err{"unexpected else"};
  }
  auto label = scope.getLabel();
  auto expr = finishScope();
  CHECK_ERR(expr);
  iff->ifTrue = *expr;
  scopeStack.push_back(ScopeCtx::makeElse(iff, label));
  return Ok{};
}

Result<> IRBuilder::visitEnd() {
  auto& scope = getScope();
  if (scope.isNone()) {
    return Err{"unexpected end"};
  }
  if (auto* block = scope.getBlock()) {
    auto expr = finishScope(block);
    CHECK_ERR(expr);
    assert(*expr == block);
    // TODO: Track branches so we can know whether this block is a target and
    // finalize more efficiently.
    block->finalize(block->type);
    push(block);
    return Ok{};
  } else if (auto* loop = scope.getLoop()) {
    auto expr = finishScope();
    CHECK_ERR(expr);
    loop->body = *expr;
    loop->finalize(loop->type);
    push(loop);
    return Ok{};
  }
  auto label = scope.getLabel();
  Expression* scopeExpr = nullptr;
  if (auto* iff = scope.getIf()) {
    auto expr = finishScope();
    CHECK_ERR(expr);
    iff->ifTrue = *expr;
    iff->ifFalse = nullptr;
    iff->finalize(iff->type);
    scopeExpr = iff;
  } else if (auto* iff = scope.getElse()) {
    auto expr = finishScope();
    CHECK_ERR(expr);
    iff->ifFalse = *expr;
    iff->finalize(iff->type);
    scopeExpr = iff;
  }
  assert(scopeExpr && "unexpected scope kind");
  if (label) {
    // We cannot directly name an If in Binaryen IR, so we need to wrap it in
    // a block.
    push(builder.makeBlock(label, {scopeExpr}, scopeExpr->type));
  } else {
    push(scopeExpr);
  }
  return Ok{};
}

Result<> IRBuilder::makeNop() {
  push(builder.makeNop());
  return Ok{};
}

Result<> IRBuilder::makeBlock(Name label, Type type) {
  auto* block = wasm.allocator.alloc<Block>();
  block->name = label;
  block->type = type;
  return visitBlockStart(block);
}

Result<> IRBuilder::makeIf(Name label, Type type) {
  auto* iff = wasm.allocator.alloc<If>();
  iff->type = type;
  return visitIfStart(iff, label);
}

Result<> IRBuilder::makeLoop(Name label, Type type) {
  auto* loop = wasm.allocator.alloc<Loop>();
  loop->name = label;
  loop->type = type;
  return visitLoopStart(loop);
}

// Result<> IRBuilder::makeBreak() {}

// Result<> IRBuilder::makeSwitch() {}

// Result<> IRBuilder::makeCall() {}

// Result<> IRBuilder::makeCallIndirect() {}

Result<> IRBuilder::makeLocalGet(Index local) {
  push(builder.makeLocalGet(local, func->getLocalType(local)));
  return Ok{};
}

Result<> IRBuilder::makeLocalSet(Index local) {
  LocalSet curr;
  CHECK_ERR(visitLocalSet(&curr));
  push(builder.makeLocalSet(local, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeLocalTee(Index local) {
  LocalSet curr;
  CHECK_ERR(visitLocalSet(&curr));
  push(builder.makeLocalTee(local, curr.value, func->getLocalType(local)));
  return Ok{};
}

Result<> IRBuilder::makeGlobalGet(Name global) {
  push(builder.makeGlobalGet(global, wasm.getGlobal(global)->type));
  return Ok{};
}

Result<> IRBuilder::makeGlobalSet(Name global) {
  GlobalSet curr;
  CHECK_ERR(visitGlobalSet(&curr));
  push(builder.makeGlobalSet(global, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeLoad(unsigned bytes,
                             bool signed_,
                             Address offset,
                             unsigned align,
                             Type type,
                             Name mem) {
  Load curr;
  CHECK_ERR(visitLoad(&curr));
  push(builder.makeLoad(bytes, signed_, offset, align, curr.ptr, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeStore(
  unsigned bytes, Address offset, unsigned align, Type type, Name mem) {
  Store curr;
  CHECK_ERR(visitStore(&curr));
  push(
    builder.makeStore(bytes, offset, align, curr.ptr, curr.value, type, mem));
  return Ok{};
}

Result<>
IRBuilder::makeAtomicLoad(unsigned bytes, Address offset, Type type, Name mem) {
  Load curr;
  CHECK_ERR(visitLoad(&curr));
  push(builder.makeAtomicLoad(bytes, offset, curr.ptr, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicStore(unsigned bytes,
                                    Address offset,
                                    Type type,
                                    Name mem) {
  Store curr;
  CHECK_ERR(visitStore(&curr));
  push(builder.makeAtomicStore(bytes, offset, curr.ptr, curr.value, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicRMW(
  AtomicRMWOp op, unsigned bytes, Address offset, Type type, Name mem) {
  AtomicRMW curr;
  CHECK_ERR(visitAtomicRMW(&curr));
  push(
    builder.makeAtomicRMW(op, bytes, offset, curr.ptr, curr.value, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicCmpxchg(unsigned bytes,
                                      Address offset,
                                      Type type,
                                      Name mem) {
  AtomicCmpxchg curr;
  CHECK_ERR(visitAtomicCmpxchg(&curr));
  push(builder.makeAtomicCmpxchg(
    bytes, offset, curr.ptr, curr.expected, curr.replacement, type, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicWait(Type type, Address offset, Name mem) {
  AtomicWait curr;
  CHECK_ERR(visitAtomicWait(&curr));
  push(builder.makeAtomicWait(
    curr.ptr, curr.expected, curr.timeout, type, offset, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicNotify(Address offset, Name mem) {
  AtomicNotify curr;
  CHECK_ERR(visitAtomicNotify(&curr));
  push(builder.makeAtomicNotify(curr.ptr, curr.notifyCount, offset, mem));
  return Ok{};
}

Result<> IRBuilder::makeAtomicFence() {
  push(builder.makeAtomicFence());
  return Ok{};
}

Result<> IRBuilder::makeSIMDExtract(SIMDExtractOp op, uint8_t lane) {
  SIMDExtract curr;
  CHECK_ERR(visitSIMDExtract(&curr));
  push(builder.makeSIMDExtract(op, curr.vec, lane));
  return Ok{};
}

Result<> IRBuilder::makeSIMDReplace(SIMDReplaceOp op, uint8_t lane) {
  SIMDReplace curr;
  CHECK_ERR(visitSIMDReplace(&curr));
  push(builder.makeSIMDReplace(op, curr.vec, lane, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeSIMDShuffle(const std::array<uint8_t, 16>& lanes) {
  SIMDShuffle curr;
  CHECK_ERR(visitSIMDShuffle(&curr));
  push(builder.makeSIMDShuffle(curr.left, curr.right, lanes));
  return Ok{};
}

Result<> IRBuilder::makeSIMDTernary(SIMDTernaryOp op) {
  SIMDTernary curr;
  CHECK_ERR(visitSIMDTernary(&curr));
  push(builder.makeSIMDTernary(op, curr.a, curr.b, curr.c));
  return Ok{};
}

Result<> IRBuilder::makeSIMDShift(SIMDShiftOp op) {
  SIMDShift curr;
  CHECK_ERR(visitSIMDShift(&curr));
  push(builder.makeSIMDShift(op, curr.vec, curr.shift));
  return Ok{};
}

Result<> IRBuilder::makeSIMDLoad(SIMDLoadOp op,
                                 Address offset,
                                 unsigned align,
                                 Name mem) {
  SIMDLoad curr;
  CHECK_ERR(visitSIMDLoad(&curr));
  push(builder.makeSIMDLoad(op, offset, align, curr.ptr, mem));
  return Ok{};
}

Result<> IRBuilder::makeSIMDLoadStoreLane(SIMDLoadStoreLaneOp op,
                                          Address offset,
                                          unsigned align,
                                          uint8_t lane,
                                          Name mem) {
  SIMDLoadStoreLane curr;
  CHECK_ERR(visitSIMDLoadStoreLane(&curr));
  push(builder.makeSIMDLoadStoreLane(
    op, offset, align, lane, curr.ptr, curr.vec, mem));
  return Ok{};
}

Result<> IRBuilder::makeMemoryInit(Name data, Name mem) {
  MemoryInit curr;
  CHECK_ERR(visitMemoryInit(&curr));
  push(builder.makeMemoryInit(data, curr.dest, curr.offset, curr.size, mem));
  return Ok{};
}

Result<> IRBuilder::makeDataDrop(Name data) {
  push(builder.makeDataDrop(data));
  return Ok{};
}

Result<> IRBuilder::makeMemoryCopy(Name destMem, Name srcMem) {
  MemoryCopy curr;
  CHECK_ERR(visitMemoryCopy(&curr));
  push(
    builder.makeMemoryCopy(curr.dest, curr.source, curr.size, destMem, srcMem));
  return Ok{};
}

Result<> IRBuilder::makeMemoryFill(Name mem) {
  MemoryFill curr;
  CHECK_ERR(visitMemoryFill(&curr));
  push(builder.makeMemoryFill(curr.dest, curr.value, curr.size, mem));
  return Ok{};
}

Result<> IRBuilder::makeConst(Literal val) {
  push(builder.makeConst(val));
  return Ok{};
}

Result<> IRBuilder::makeUnary(UnaryOp op) {
  Unary curr;
  CHECK_ERR(visitUnary(&curr));
  push(builder.makeUnary(op, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeBinary(BinaryOp op) {
  Binary curr;
  CHECK_ERR(visitBinary(&curr));
  push(builder.makeBinary(op, curr.left, curr.right));
  return Ok{};
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
  push(built);
  return Ok{};
}

Result<> IRBuilder::makeDrop() {
  Drop curr;
  CHECK_ERR(visitDrop(&curr));
  push(builder.makeDrop(curr.value));
  return Ok{};
}

Result<> IRBuilder::makeReturn() {
  Return curr;
  CHECK_ERR(visitReturn(&curr));
  push(builder.makeReturn(curr.value));
  return Ok{};
}

Result<> IRBuilder::makeMemorySize(Name mem) {
  push(builder.makeMemorySize(mem));
  return Ok{};
}

Result<> IRBuilder::makeMemoryGrow(Name mem) {
  MemoryGrow curr;
  CHECK_ERR(visitMemoryGrow(&curr));
  push(builder.makeMemoryGrow(curr.delta, mem));
  return Ok{};
}

Result<> IRBuilder::makeUnreachable() {
  push(builder.makeUnreachable());
  return Ok{};
}

// Result<> IRBuilder::makePop() {}

Result<> IRBuilder::makeRefNull(HeapType type) {
  push(builder.makeRefNull(type));
  return Ok{};
}

Result<> IRBuilder::makeRefIsNull() {
  RefIsNull curr;
  CHECK_ERR(visitRefIsNull(&curr));
  push(builder.makeRefIsNull(curr.value));
  return Ok{};
}

// Result<> IRBuilder::makeRefFunc() {}

Result<> IRBuilder::makeRefEq() {
  RefEq curr;
  CHECK_ERR(visitRefEq(&curr));
  push(builder.makeRefEq(curr.left, curr.right));
  return Ok{};
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

Result<> IRBuilder::makeRefI31() {
  RefI31 curr;
  CHECK_ERR(visitRefI31(&curr));
  push(builder.makeRefI31(curr.value));
  return Ok{};
}

Result<> IRBuilder::makeI31Get(bool signed_) {
  I31Get curr;
  CHECK_ERR(visitI31Get(&curr));
  push(builder.makeI31Get(curr.i31, signed_));
  return Ok{};
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
  push(builder.makeStructNew(type, std::move(curr.operands)));
  return Ok{};
}

Result<> IRBuilder::makeStructNewDefault(HeapType type) {
  push(builder.makeStructNew(type, {}));
  return Ok{};
}

Result<> IRBuilder::makeStructGet(HeapType type, Index field, bool signed_) {
  const auto& fields = type.getStruct().fields;
  StructGet curr;
  CHECK_ERR(visitStructGet(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeStructGet(field, curr.ref, fields[field].type, signed_));
  return Ok{};
}

Result<> IRBuilder::makeStructSet(HeapType type, Index field) {
  StructSet curr;
  CHECK_ERR(visitStructSet(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeStructSet(field, curr.ref, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeArrayNew(HeapType type) {
  ArrayNew curr;
  // Differentiate from array.new_default with dummy initializer.
  curr.init = (Expression*)0x01;
  CHECK_ERR(visitArrayNew(&curr));
  push(builder.makeArrayNew(type, curr.size, curr.init));
  return Ok{};
}

Result<> IRBuilder::makeArrayNewDefault(HeapType type) {
  ArrayNew curr;
  CHECK_ERR(visitArrayNew(&curr));
  push(builder.makeArrayNew(type, curr.size));
  return Ok{};
}

Result<> IRBuilder::makeArrayNewData(HeapType type, Name data) {
  ArrayNewData curr;
  CHECK_ERR(visitArrayNewData(&curr));
  push(builder.makeArrayNewData(type, data, curr.offset, curr.size));
  return Ok{};
}

Result<> IRBuilder::makeArrayNewElem(HeapType type, Name elem) {
  ArrayNewElem curr;
  CHECK_ERR(visitArrayNewElem(&curr));
  push(builder.makeArrayNewElem(type, elem, curr.offset, curr.size));
  return Ok{};
}

// Result<> IRBuilder::makeArrayNewFixed() {}

Result<> IRBuilder::makeArrayGet(HeapType type, bool signed_) {
  ArrayGet curr;
  CHECK_ERR(visitArrayGet(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArrayGet(
    curr.ref, curr.index, type.getArray().element.type, signed_));
  return Ok{};
}

Result<> IRBuilder::makeArraySet(HeapType type) {
  ArraySet curr;
  CHECK_ERR(visitArraySet(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArraySet(curr.ref, curr.index, curr.value));
  return Ok{};
}

Result<> IRBuilder::makeArrayLen() {
  ArrayLen curr;
  CHECK_ERR(visitArrayLen(&curr));
  push(builder.makeArrayLen(curr.ref));
  return Ok{};
}

Result<> IRBuilder::makeArrayCopy(HeapType destType, HeapType srcType) {
  ArrayCopy curr;
  CHECK_ERR(visitArrayCopy(&curr));
  CHECK_ERR(validateTypeAnnotation(destType, curr.destRef));
  CHECK_ERR(validateTypeAnnotation(srcType, curr.srcRef));
  push(builder.makeArrayCopy(
    curr.destRef, curr.destIndex, curr.srcRef, curr.srcIndex, curr.length));
  return Ok{};
}

Result<> IRBuilder::makeArrayFill(HeapType type) {
  ArrayFill curr;
  CHECK_ERR(visitArrayFill(&curr));
  CHECK_ERR(validateTypeAnnotation(type, curr.ref));
  push(builder.makeArrayFill(curr.ref, curr.index, curr.value, curr.size));
  return Ok{};
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
