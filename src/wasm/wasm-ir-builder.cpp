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

// Handle the common case of instructions with a constant number of children
// uniformly.
Result<> IRBuilder::visitExpression(Expression* curr) {
#define DELEGATE_ID curr->_id
#define DELEGATE_START(id) auto* expr = curr->cast<id>();
#define DELEGATE_FIELD_CHILD(id, field)                                        \
  auto field = pop();                                                          \
  CHECK_ERR(field);                                                            \
  expr->field = *field;
#define DELEGATE_END(id) expr->finalize();

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

  return push(curr);
}

Result<> IRBuilder::visitBlock(Block* curr) {
  // TODO: Handle popping scope and filling block here instead of externally.
  return push(curr);
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
  curr->finalize();
  return push(curr);
}

Result<> IRBuilder::visitStructNew(StructNew* curr) {
  if (curr->isWithDefault()) {
    return push(curr);
  }
  assert(curr->type.isRef());
  assert(curr->type.getHeapType().isStruct());
  assert(curr->operands.size() ==
         curr->type.getHeapType().getStruct().fields.size());
  for (size_t i = 0, n = curr->operands.size(); i < n; ++i) {
    auto val = pop();
    CHECK_ERR(val);
    curr->operands[n - 1 - i] = *val;
  }
  curr->finalize();
  return push(curr);
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
  curr->finalize();
  return push(curr);
}

Result<> IRBuilder::makeNop() { return visit(wasm.allocator.alloc<Nop>()); }

Result<> IRBuilder::makeBlock() { return visit(wasm.allocator.alloc<Block>()); }

// Result<> IRBuilder::makeIf() {
//   auto* curr = wasm.allocator.alloc<If>();
//   return visitBlock(curr);
// }

// Result<> IRBuilder::makeLoop() {
//   auto* curr = wasm.allocator.alloc<Loop>();
//   return visitLoop(curr);
// }

// Result<> IRBuilder::makeBreak() {
//   auto* curr = wasm.allocator.alloc<Break>();
//   return visitBreak(curr);
// }

// Result<> IRBuilder::makeSwitch() {
//   auto* curr = wasm.allocator.alloc<Switch>();
//   return visitSwitch(curr);
// }

// Result<> IRBuilder::makeCall() {
//   auto* curr = wasm.allocator.alloc<Call>();
//   return visitCall(curr);
// }

// Result<> IRBuilder::makeCallIndirect() {
//   auto* curr = wasm.allocator.alloc<CallIndirect>();
//   return visitCallIndirect(curr);
// }

Result<> IRBuilder::makeLocalGet(Index local) {
  if (!func) {
    return Err{"local.get must be inside a function"};
  }
  if (local >= func->getNumLocals()) {
    return Err{"local index out of bounds"};
  }
  auto* curr = wasm.allocator.alloc<LocalGet>();
  curr->type = func->getLocalType(local);
  curr->index = local;
  return visitLocalGet(curr);
}

Result<> IRBuilder::makeLocalSet(Index local) {
  if (!func) {
    return Err{"local.set must be inside a function"};
  }
  if (local >= func->getNumLocals()) {
    return Err{"local index out of bounds"};
  }
  auto* curr = wasm.allocator.alloc<LocalSet>();
  curr->index = local;
  return visitLocalSet(curr);
}

Result<> IRBuilder::makeLocalTee(Index local) {
  if (!func) {
    return Err{"local.tee must be inside a function"};
  }
  if (local >= func->getNumLocals()) {
    return Err{"local index out of bounds"};
  }
  auto* curr = wasm.allocator.alloc<LocalSet>();
  curr->type = func->getLocalType(local);
  curr->index = local;
  return visitLocalSet(curr);
}

Result<> IRBuilder::makeGlobalGet(Name global) {
  if (!wasm.getGlobalOrNull(global)) {
    return Err{"global '"s + global.toString() + "' does not exist"};
  }
  auto* curr = wasm.allocator.alloc<GlobalGet>();
  curr->type = wasm.getGlobal(global)->type;
  curr->name = global;
  return visitGlobalGet(curr);
}

Result<> IRBuilder::makeGlobalSet(Name global) {
  if (!wasm.getGlobalOrNull(global)) {
    return Err{"global '"s + global.toString() + "' does not exist"};
  }
  auto* curr = wasm.allocator.alloc<GlobalSet>();
  curr->name = global;
  return visitGlobalSet(curr);
}

Result<> IRBuilder::makeLoad(unsigned bytes,
                             bool signed_,
                             Address offset,
                             unsigned align,
                             Type type,
                             Name mem) {
  auto* curr = wasm.allocator.alloc<Load>();
  curr->isAtomic = false;
  curr->bytes = bytes;
  curr->signed_ = signed_;
  curr->offset = offset;
  curr->align = align;
  curr->type = type;
  curr->memory = mem;
  return visitLoad(curr);
}

Result<> IRBuilder::makeStore(
  unsigned bytes, Address offset, unsigned align, Type type, Name mem) {
  auto* curr = wasm.allocator.alloc<Store>();
  curr->isAtomic = false;
  curr->bytes = bytes;
  curr->offset = offset;
  curr->align = align;
  curr->valueType = type;
  curr->memory = mem;
  return visitStore(curr);
}

Result<>
IRBuilder::makeAtomicLoad(unsigned bytes, Address offset, Type type, Name mem) {
  auto* curr = wasm.allocator.alloc<Load>();
  curr->isAtomic = true;
  curr->bytes = bytes;
  curr->signed_ = false;
  curr->offset = offset;
  curr->align = bytes;
  curr->type = type;
  curr->memory = mem;
  return visitLoad(curr);
}

Result<> IRBuilder::makeAtomicStore(unsigned bytes,
                                    Address offset,
                                    Type type,
                                    Name mem) {
  auto* curr = wasm.allocator.alloc<Store>();
  curr->isAtomic = true;
  curr->bytes = bytes;
  curr->offset = offset;
  curr->align = bytes;
  curr->valueType = type;
  curr->memory = mem;
  return visitStore(curr);
}

Result<> IRBuilder::makeAtomicRMW(
  AtomicRMWOp op, unsigned bytes, Address offset, Type type, Name mem) {
  auto* curr = wasm.allocator.alloc<AtomicRMW>();
  curr->op = op;
  curr->bytes = bytes;
  curr->offset = offset;
  curr->type = type;
  curr->memory = mem;
  return visitAtomicRMW(curr);
}

Result<> IRBuilder::makeAtomicCmpxchg(unsigned bytes,
                                      Address offset,
                                      Type type,
                                      Name mem) {
  auto* curr = wasm.allocator.alloc<AtomicCmpxchg>();
  curr->bytes = bytes;
  curr->offset = offset;
  curr->type = type;
  curr->memory = mem;
  return visitAtomicCmpxchg(curr);
}

Result<> IRBuilder::makeAtomicWait(Type type, Address offset, Name mem) {
  auto* curr = wasm.allocator.alloc<AtomicWait>();
  curr->offset = offset;
  curr->expectedType = type;
  curr->memory = mem;
  return visitAtomicWait(curr);
}

Result<> IRBuilder::makeAtomicNotify(Address offset, Name mem) {
  auto* curr = wasm.allocator.alloc<AtomicNotify>();
  curr->offset = offset;
  curr->memory = mem;
  return visitAtomicNotify(curr);
}

Result<> IRBuilder::makeAtomicFence() {
  return visit(wasm.allocator.alloc<AtomicFence>());
}

Result<> IRBuilder::makeSIMDExtract(SIMDExtractOp op, uint8_t lane) {
  auto* curr = wasm.allocator.alloc<SIMDExtract>();
  curr->op = op;
  curr->index = lane;
  return visitSIMDExtract(curr);
}

Result<> IRBuilder::makeSIMDReplace(SIMDReplaceOp op, uint8_t lane) {
  auto* curr = wasm.allocator.alloc<SIMDReplace>();
  curr->op = op;
  curr->index = lane;
  return visitSIMDReplace(curr);
}

Result<> IRBuilder::makeSIMDShuffle(const std::array<uint8_t, 16>& lanes) {
  auto* curr = wasm.allocator.alloc<SIMDShuffle>();
  curr->mask = lanes;
  return visitSIMDShuffle(curr);
}

Result<> IRBuilder::makeSIMDTernary(SIMDTernaryOp op) {
  auto* curr = wasm.allocator.alloc<SIMDTernary>();
  curr->op = op;
  return visitSIMDTernary(curr);
}

Result<> IRBuilder::makeSIMDShift(SIMDShiftOp op) {
  auto* curr = wasm.allocator.alloc<SIMDShift>();
  curr->op = op;
  return visitSIMDShift(curr);
}

Result<> IRBuilder::makeSIMDLoad(SIMDLoadOp op,
                                 Address offset,
                                 unsigned align,
                                 Name mem) {
  auto* curr = wasm.allocator.alloc<SIMDLoad>();
  curr->op = op;
  curr->offset = offset;
  curr->align = align;
  curr->memory = mem;
  return visitSIMDLoad(curr);
}

Result<> IRBuilder::makeSIMDLoadStoreLane(SIMDLoadStoreLaneOp op,
                                          Address offset,
                                          unsigned align,
                                          uint8_t lane,
                                          Name mem) {
  auto* curr = wasm.allocator.alloc<SIMDLoadStoreLane>();
  curr->op = op;
  curr->offset = offset;
  curr->align = align;
  curr->index = lane;
  curr->memory = mem;
  return visitSIMDLoadStoreLane(curr);
}

Result<> IRBuilder::makeMemoryInit(Name data, Name mem) {
  auto* curr = wasm.allocator.alloc<MemoryInit>();
  curr->segment = data;
  curr->memory = mem;
  return visitMemoryInit(curr);
}

Result<> IRBuilder::makeDataDrop(Name data) {
  auto* curr = wasm.allocator.alloc<DataDrop>();
  curr->segment = data;
  return visitDataDrop(curr);
}

Result<> IRBuilder::makeMemoryCopy(Name destMem, Name srcMem) {
  auto* curr = wasm.allocator.alloc<MemoryCopy>();
  curr->destMemory = destMem;
  curr->sourceMemory = srcMem;
  return visitMemoryCopy(curr);
}

Result<> IRBuilder::makeMemoryFill(Name mem) {
  auto* curr = wasm.allocator.alloc<MemoryFill>();
  curr->memory = mem;
  return visitMemoryFill(curr);
}

Result<> IRBuilder::makeConst(Literal val) {
  if (!val.type.isNumber()) {
    return Err{"const value must be numeric"};
  }
  auto* curr = wasm.allocator.alloc<Const>();
  curr->value = val;
  curr->type = val.type;
  return visitConst(curr);
}

Result<> IRBuilder::makeUnary(UnaryOp op) {
  auto* curr = wasm.allocator.alloc<Unary>();
  curr->op = op;
  return visitUnary(curr);
}

Result<> IRBuilder::makeBinary(BinaryOp op) {
  auto* curr = wasm.allocator.alloc<Binary>();
  curr->op = op;
  return visitBinary(curr);
}

Result<> IRBuilder::makeSelect(std::optional<Type> type) {
  auto* curr = wasm.allocator.alloc<Select>();
  CHECK_ERR(visitSelect(curr));
  if (type && !Type::isSubType(curr->type, *type)) {
    return Err{"select type does not match expected type"};
  }
  return Ok{};
}

Result<> IRBuilder::makeDrop() { return visit(wasm.allocator.alloc<Drop>()); }

Result<> IRBuilder::makeReturn() {
  return visit(wasm.allocator.alloc<Return>());
}

Result<> IRBuilder::makeMemorySize(Name mem) {
  auto* memory = wasm.getMemoryOrNull(mem);
  if (!memory) {
    return Err{"memory '"s + mem.toString() + "' does not exist"};
  }
  auto* curr = wasm.allocator.alloc<MemorySize>();
  curr->memory = mem;
  if (memory->is64()) {
    curr->make64();
  }
  return visitMemorySize(curr);
}

Result<> IRBuilder::makeMemoryGrow(Name mem) {
  auto* memory = wasm.getMemoryOrNull(mem);
  if (!memory) {
    return Err{"memory '"s + mem.toString() + "' does not exist"};
  }
  auto* curr = wasm.allocator.alloc<MemoryGrow>();
  curr->memory = mem;
  if (memory->is64()) {
    curr->make64();
  }
  return visitMemoryGrow(curr);
}

Result<> IRBuilder::makeUnreachable() {
  return visit(wasm.allocator.alloc<Unreachable>());
}

// Result<> IRBuilder::makePop() {}

Result<> IRBuilder::makeRefNull(HeapType type) {
  auto* curr = wasm.allocator.alloc<RefNull>();
  curr->type = Type(type.getBottom(), Nullable);
  return visitRefNull(curr);
}

Result<> IRBuilder::makeRefIsNull() {
  return visit(wasm.allocator.alloc<RefIsNull>());
}

// Result<> IRBuilder::makeRefFunc() {
//   auto* curr = wasm.allocator.alloc<RefFunc>();
//   return visitRefFunc(curr);
// }

Result<> IRBuilder::makeRefEq() { return visit(wasm.allocator.alloc<RefEq>()); }

// Result<> IRBuilder::makeTableGet() {
//   auto* curr = wasm.allocator.alloc<TableGet>();
//   return visitTableGet(curr);
// }

// Result<> IRBuilder::makeTableSet() {
//   auto* curr = wasm.allocator.alloc<TableSet>();
//   return visitTableSet(curr);
// }

// Result<> IRBuilder::makeTableSize() {
//   auto* curr = wasm.allocator.alloc<TableSize>();
//   return visitTableSize(curr);
// }

// Result<> IRBuilder::makeTableGrow() {
//   auto* curr = wasm.allocator.alloc<TableGrow>();
//   return visitTableGrow(curr);
// }

// Result<> IRBuilder::makeTry() {
//   auto* curr = wasm.allocator.alloc<Try>();
//   return visitTry(curr);
// }

// Result<> IRBuilder::makeThrow() {
//   auto* curr = wasm.allocator.alloc<Throw>();
//   return visitThrow(curr);
// }

// Result<> IRBuilder::makeRethrow() {
//   auto* curr = wasm.allocator.alloc<Rethrow>();
//   return visitRethrow(curr);
// }

// Result<> IRBuilder::makeTupleMake() {
//   auto* curr = wasm.allocator.alloc<TupleMake>();
//   return visitTupleMake(curr);
// }

// Result<> IRBuilder::makeTupleExtract() {
//   auto* curr = wasm.allocator.alloc<TupleExtract>();
//   return visitTupleExtract(curr);
// }

Result<> IRBuilder::makeI31New() {
  return visit(wasm.allocator.alloc<I31New>());
}

Result<> IRBuilder::makeI31Get(bool signed_) {
  auto* curr = wasm.allocator.alloc<I31Get>();
  curr->signed_ = signed_;
  return visitI31Get(curr);
}

// Result<> IRBuilder::makeCallRef() {
//   auto* curr = wasm.allocator.alloc<CallRef>();
//   return visitCallRef(curr);
// }

// Result<> IRBuilder::makeRefTest() {
//   auto* curr = wasm.allocator.alloc<RefTest>();
//   return visitRefTest(curr);
// }

// Result<> IRBuilder::makeRefCast() {
//   auto* curr = wasm.allocator.alloc<RefCast>();
//   return visitRefCast(curr);
// }

// Result<> IRBuilder::makeBrOn() {
//   auto* curr = wasm.allocator.alloc<BrOn>();
//   return visitBrOn(curr);
// }

Result<> IRBuilder::makeStructNew(HeapType type) {
  if (!type.isStruct()) {
    return Err{"type is not a struct type"};
  }
  auto* curr = wasm.allocator.alloc<StructNew>();
  curr->type = Type(type, NonNullable);
  // Differentiate from struct.new_default with a non-empty expression list.
  curr->operands.resize(type.getStruct().fields.size());
  return visitStructNew(curr);
}

Result<> IRBuilder::makeStructNewDefault(HeapType type) {
  auto* curr = wasm.allocator.alloc<StructNew>();
  curr->type = Type(type, NonNullable);
  curr->operands.clear();
  return visitStructNew(curr);
}

Result<> IRBuilder::makeStructGet(HeapType type, Index field, bool signed_) {
  if (!type.isStruct()) {
    return Err{"type is not a struct type"};
  }
  const auto& fields = type.getStruct().fields;
  if (field >= fields.size()) {
    return Err{"field index is out of bounds"};
  }
  auto* curr = wasm.allocator.alloc<StructGet>();
  curr->type = fields[field].type;
  curr->index = field;
  curr->signed_ = signed_;
  CHECK_ERR(visitStructGet(curr));
  return validateTypeAnnotation(type, curr->ref);
}

Result<> IRBuilder::makeStructSet(HeapType type, Index field) {
  if (!type.isStruct()) {
    return Err{"type is not a struct type"};
  }
  const auto& fields = type.getStruct().fields;
  if (field >= fields.size()) {
    return Err{"field index is out of bounds"};
  }
  auto* curr = wasm.allocator.alloc<StructSet>();
  curr->index = field;
  CHECK_ERR(visitStructSet(curr));
  return validateTypeAnnotation(type, curr->ref);
}

Result<> IRBuilder::makeArrayNew(HeapType type) {
  if (!type.isArray()) {
    return Err{"type is not an array type"};
  }
  auto* curr = wasm.allocator.alloc<ArrayNew>();
  curr->type = Type(type, NonNullable);
  // Differentiate from array.new_default with dummy initializer.
  curr->init = (Expression*)0x01;
  return visitArrayNew(curr);
}

Result<> IRBuilder::makeArrayNewDefault(HeapType type) {
  if (!type.isArray()) {
    return Err{"type is not an array type"};
  }
  auto* curr = wasm.allocator.alloc<ArrayNew>();
  curr->type = Type(type, NonNullable);
  curr->init = nullptr;
  return visitArrayNew(curr);
}

Result<> IRBuilder::makeArrayNewData(HeapType type, Name data) {
  if (!type.isArray()) {
    return Err{"type is not an array type"};
  }
  if (!wasm.getDataSegmentOrNull(data)) {
    return Err{"data segment does not exist"};
  }
  auto* curr = wasm.allocator.alloc<ArrayNewData>();
  curr->type = Type(type, NonNullable);
  curr->segment = data;
  return visitArrayNewData(curr);
}

Result<> IRBuilder::makeArrayNewElem(HeapType type, Name elem) {
  if (!type.isArray()) {
    return Err{"type is not an array type"};
  }
  if (!wasm.getElementSegmentOrNull(elem)) {
    return Err{"element segment does not exist"};
  }
  auto* curr = wasm.allocator.alloc<ArrayNewElem>();
  curr->type = Type(type, NonNullable);
  curr->segment = elem;
  return visitArrayNewElem(curr);
}

// Result<> IRBuilder::makeArrayNewFixed() {
//   auto* curr = wasm.allocator.alloc<ArrayNewFixed>();
//   return visitArrayNewFixed(curr);
// }

Result<> IRBuilder::makeArrayGet(HeapType type, bool signed_) {
  if (!type.isArray()) {
    return Err{"type is not an array type"};
  }
  auto* curr = wasm.allocator.alloc<ArrayGet>();
  curr->type = type.getArray().element.type;
  curr->signed_ = signed_;
  CHECK_ERR(visitArrayGet(curr));
  return validateTypeAnnotation(type, curr->ref);
}

Result<> IRBuilder::makeArraySet(HeapType type) {
  auto* curr = wasm.allocator.alloc<ArraySet>();
  CHECK_ERR(visitArraySet(curr));
  return validateTypeAnnotation(type, curr->ref);
}

Result<> IRBuilder::makeArrayLen() {
  return visit(wasm.allocator.alloc<ArrayLen>());
}

Result<> IRBuilder::makeArrayCopy(HeapType destType, HeapType srcType) {
  auto* curr = wasm.allocator.alloc<ArrayCopy>();
  CHECK_ERR(visitArrayCopy(curr));
  CHECK_ERR(validateTypeAnnotation(destType, curr->destRef));
  CHECK_ERR(validateTypeAnnotation(srcType, curr->srcRef));
  return Ok{};
}

Result<> IRBuilder::makeArrayFill(HeapType type) {
  auto* curr = wasm.allocator.alloc<ArrayFill>();
  CHECK_ERR(visitArrayFill(curr));
  return validateTypeAnnotation(type, curr->ref);
}

// Result<> IRBuilder::makeArrayInitData() {
//   auto* curr = wasm.allocator.alloc<ArrayInitData>();
//   return visitArrayInitData(curr);
// }

// Result<> IRBuilder::makeArrayInitElem() {
//   auto* curr = wasm.allocator.alloc<ArrayInitElem>();
//   return visitArrayInitElem(curr);
// }

// Result<> IRBuilder::makeRefAs() {
//   auto* curr = wasm.allocator.alloc<RefAs>();
//   return visitRefAs(curr);
// }

// Result<> IRBuilder::makeStringNew() {
//   auto* curr = wasm.allocator.alloc<StringNew>();
//   return visitStringNew(curr);
// }

// Result<> IRBuilder::makeStringConst() {
//   auto* curr = wasm.allocator.alloc<StringConst>();
//   return visitStringConst(curr);
// }

// Result<> IRBuilder::makeStringMeasure() {
//   auto* curr = wasm.allocator.alloc<StringMeasure>();
//   return visitStringMeasure(curr);
// }

// Result<> IRBuilder::makeStringEncode() {
//   auto* curr = wasm.allocator.alloc<StringEncode>();
//   return visitStringEncode(curr);
// }

// Result<> IRBuilder::makeStringConcat() {
//   auto* curr = wasm.allocator.alloc<StringConcat>();
//   return visitStringConcat(curr);
// }

// Result<> IRBuilder::makeStringEq() {
//   auto* curr = wasm.allocator.alloc<StringEq>();
//   return visitStringEq(curr);
// }

// Result<> IRBuilder::makeStringAs() {
//   auto* curr = wasm.allocator.alloc<StringAs>();
//   return visitStringAs(curr);
// }

// Result<> IRBuilder::makeStringWTF8Advance() {
//   auto* curr = wasm.allocator.alloc<StringWTF8Advance>();
//   return visitStringWTF8Advance(curr);
// }

// Result<> IRBuilder::makeStringWTF16Get() {
//   auto* curr = wasm.allocator.alloc<StringWTF16Get>();
//   return visitStringWTF16Get(curr);
// }

// Result<> IRBuilder::makeStringIterNext() {
//   auto* curr = wasm.allocator.alloc<StringIterNext>();
//   return visitStringIterNext(curr);
// }

// Result<> IRBuilder::makeStringIterMove() {
//   auto* curr = wasm.allocator.alloc<StringIterMove>();
//   return visitStringIterMove(curr);
// }

// Result<> IRBuilder::makeStringSliceWTF() {
//   auto* curr = wasm.allocator.alloc<StringSliceWTF>();
//   return visitStringSliceWTF(curr);
// }

// Result<> IRBuilder::makeStringSliceIter() {
//   auto* curr = wasm.allocator.alloc<StringSliceIter>();
//   return visitStringSliceIter(curr);
// }

} // namespace wasm
