/*
 * Copyright 2016 WebAssembly Community Group participants
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

#ifndef wasm_wasm_builder_h
#define wasm_wasm_builder_h

#include "ir/manipulation.h"
#include "wasm.h"

namespace wasm {

// Useful data structures

struct NameType {
  Name name;
  Type type;
  NameType() : name(nullptr), type(Type::none) {}
  NameType(Name name, Type type) : name(name), type(type) {}
};

// General AST node builder

class Builder {
  Module& wasm;

public:
  Builder(Module& wasm) : wasm(wasm) {}

  // make* functions, other globals

  Function* makeFunction(Name name,
                         Signature sig,
                         std::vector<Type>&& vars,
                         Expression* body = nullptr) {
    auto* func = new Function;
    func->name = name;
    func->sig = sig;
    func->body = body;
    func->vars.swap(vars);
    return func;
  }

  Function* makeFunction(Name name,
                         std::vector<NameType>&& params,
                         Type resultType,
                         std::vector<NameType>&& vars,
                         Expression* body = nullptr) {
    auto* func = new Function;
    func->name = name;
    func->body = body;
    std::vector<Type> paramVec;
    for (auto& param : params) {
      paramVec.push_back(param.type);
      Index index = func->localNames.size();
      func->localIndices[param.name] = index;
      func->localNames[index] = param.name;
    }
    func->sig = Signature(Type(paramVec), resultType);
    for (auto& var : vars) {
      func->vars.push_back(var.type);
      Index index = func->localNames.size();
      func->localIndices[var.name] = index;
      func->localNames[index] = var.name;
    }
    return func;
  }

  Export* makeExport(Name name, Name value, ExternalKind kind) {
    auto* export_ = new Export();
    export_->name = name;
    export_->value = value;
    export_->kind = kind;
    return export_;
  }

  // IR nodes

  Nop* makeNop() { return wasm.allocator.alloc<Nop>(); }
  Block* makeBlock(Expression* first = nullptr) {
    auto* ret = wasm.allocator.alloc<Block>();
    if (first) {
      ret->list.push_back(first);
      ret->finalize();
    }
    return ret;
  }
  Block* makeBlock(Name name, Expression* first = nullptr) {
    auto* ret = makeBlock(first);
    ret->name = name;
    ret->finalize();
    return ret;
  }
  Block* makeBlock(const std::vector<Expression*>& items) {
    auto* ret = wasm.allocator.alloc<Block>();
    ret->list.set(items);
    ret->finalize();
    return ret;
  }
  Block* makeBlock(const std::vector<Expression*>& items, Type type) {
    auto* ret = wasm.allocator.alloc<Block>();
    ret->list.set(items);
    ret->finalize(type);
    return ret;
  }
  Block* makeBlock(const ExpressionList& items) {
    auto* ret = wasm.allocator.alloc<Block>();
    ret->list.set(items);
    ret->finalize();
    return ret;
  }
  Block* makeBlock(const ExpressionList& items, Type type) {
    auto* ret = wasm.allocator.alloc<Block>();
    ret->list.set(items);
    ret->finalize(type);
    return ret;
  }
  Block* makeBlock(Name name, const ExpressionList& items) {
    auto* ret = wasm.allocator.alloc<Block>();
    ret->name = name;
    ret->list.set(items);
    ret->finalize();
    return ret;
  }
  Block* makeBlock(Name name, const ExpressionList& items, Type type) {
    auto* ret = wasm.allocator.alloc<Block>();
    ret->name = name;
    ret->list.set(items);
    ret->finalize(type);
    return ret;
  }
  If* makeIf(Expression* condition,
             Expression* ifTrue,
             Expression* ifFalse = nullptr) {
    auto* ret = wasm.allocator.alloc<If>();
    ret->condition = condition;
    ret->ifTrue = ifTrue;
    ret->ifFalse = ifFalse;
    ret->finalize();
    return ret;
  }
  If* makeIf(Expression* condition,
             Expression* ifTrue,
             Expression* ifFalse,
             Type type) {
    auto* ret = wasm.allocator.alloc<If>();
    ret->condition = condition;
    ret->ifTrue = ifTrue;
    ret->ifFalse = ifFalse;
    ret->finalize(type);
    return ret;
  }
  Loop* makeLoop(Name name, Expression* body) {
    auto* ret = wasm.allocator.alloc<Loop>();
    ret->name = name;
    ret->body = body;
    ret->finalize();
    return ret;
  }
  Loop* makeLoop(Name name, Expression* body, Type type) {
    auto* ret = wasm.allocator.alloc<Loop>();
    ret->name = name;
    ret->body = body;
    ret->finalize(type);
    return ret;
  }
  Break* makeBreak(Name name,
                   Expression* value = nullptr,
                   Expression* condition = nullptr) {
    auto* ret = wasm.allocator.alloc<Break>();
    ret->name = name;
    ret->value = value;
    ret->condition = condition;
    ret->finalize();
    return ret;
  }
  template<typename T>
  Switch* makeSwitch(T& list,
                     Name default_,
                     Expression* condition,
                     Expression* value = nullptr) {
    auto* ret = wasm.allocator.alloc<Switch>();
    ret->targets.set(list);
    ret->default_ = default_;
    ret->value = value;
    ret->condition = condition;
    return ret;
  }
  Call* makeCall(Name target,
                 const std::vector<Expression*>& args,
                 Type type,
                 bool isReturn = false) {
    auto* call = wasm.allocator.alloc<Call>();
    // not all functions may exist yet, so type must be provided
    call->type = type;
    call->target = target;
    call->operands.set(args);
    call->isReturn = isReturn;
    return call;
  }
  template<typename T>
  Call* makeCall(Name target, const T& args, Type type, bool isReturn = false) {
    auto* call = wasm.allocator.alloc<Call>();
    // not all functions may exist yet, so type must be provided
    call->type = type;
    call->target = target;
    call->operands.set(args);
    call->isReturn = isReturn;
    call->finalize();
    return call;
  }
  template<typename T>
  CallIndirect* makeCallIndirect(Expression* target,
                                 const T& args,
                                 Signature sig,
                                 bool isReturn = false) {
    auto* call = wasm.allocator.alloc<CallIndirect>();
    call->sig = sig;
    call->type = sig.results;
    call->target = target;
    call->operands.set(args);
    call->isReturn = isReturn;
    call->finalize();
    return call;
  }
  template<typename T>
  Call* makeCallRef(Expression* target, const T& args, Type type, bool isReturn = false) {
    auto* call = wasm.allocator.alloc<CallRef>();
    call->type = type;
    call->target = target;
    call->operands.set(args);
    call->isReturn = isReturn;
    call->finalize();
    return call;
  }
  LocalGet* makeLocalGet(Index index, Type type) {
    auto* ret = wasm.allocator.alloc<LocalGet>();
    ret->index = index;
    ret->type = type;
    return ret;
  }
  LocalSet* makeLocalSet(Index index, Expression* value) {
    auto* ret = wasm.allocator.alloc<LocalSet>();
    ret->index = index;
    ret->value = value;
    ret->makeSet();
    ret->finalize();
    return ret;
  }
  LocalSet* makeLocalTee(Index index, Expression* value, Type type) {
    auto* ret = wasm.allocator.alloc<LocalSet>();
    ret->index = index;
    ret->value = value;
    ret->makeTee(type);
    return ret;
  }
  GlobalGet* makeGlobalGet(Name name, Type type) {
    auto* ret = wasm.allocator.alloc<GlobalGet>();
    ret->name = name;
    ret->type = type;
    return ret;
  }
  GlobalSet* makeGlobalSet(Name name, Expression* value) {
    auto* ret = wasm.allocator.alloc<GlobalSet>();
    ret->name = name;
    ret->value = value;
    ret->finalize();
    return ret;
  }
  Load* makeLoad(unsigned bytes,
                 bool signed_,
                 uint32_t offset,
                 unsigned align,
                 Expression* ptr,
                 Type type) {
    auto* ret = wasm.allocator.alloc<Load>();
    ret->isAtomic = false;
    ret->bytes = bytes;
    ret->signed_ = signed_;
    ret->offset = offset;
    ret->align = align;
    ret->ptr = ptr;
    ret->type = type;
    return ret;
  }
  Load*
  makeAtomicLoad(unsigned bytes, uint32_t offset, Expression* ptr, Type type) {
    Load* load = makeLoad(bytes, false, offset, bytes, ptr, type);
    load->isAtomic = true;
    return load;
  }
  AtomicWait* makeAtomicWait(Expression* ptr,
                             Expression* expected,
                             Expression* timeout,
                             Type expectedType,
                             Address offset) {
    auto* wait = wasm.allocator.alloc<AtomicWait>();
    wait->offset = offset;
    wait->ptr = ptr;
    wait->expected = expected;
    wait->timeout = timeout;
    wait->expectedType = expectedType;
    wait->finalize();
    return wait;
  }
  AtomicNotify*
  makeAtomicNotify(Expression* ptr, Expression* notifyCount, Address offset) {
    auto* notify = wasm.allocator.alloc<AtomicNotify>();
    notify->offset = offset;
    notify->ptr = ptr;
    notify->notifyCount = notifyCount;
    notify->finalize();
    return notify;
  }
  AtomicFence* makeAtomicFence() { return wasm.allocator.alloc<AtomicFence>(); }
  Store* makeStore(unsigned bytes,
                   uint32_t offset,
                   unsigned align,
                   Expression* ptr,
                   Expression* value,
                   Type type) {
    auto* ret = wasm.allocator.alloc<Store>();
    ret->isAtomic = false;
    ret->bytes = bytes;
    ret->offset = offset;
    ret->align = align;
    ret->ptr = ptr;
    ret->value = value;
    ret->valueType = type;
    ret->finalize();
    assert(ret->value->type.isConcrete() ? ret->value->type == type : true);
    return ret;
  }
  Store* makeAtomicStore(unsigned bytes,
                         uint32_t offset,
                         Expression* ptr,
                         Expression* value,
                         Type type) {
    Store* store = makeStore(bytes, offset, bytes, ptr, value, type);
    store->isAtomic = true;
    return store;
  }
  AtomicRMW* makeAtomicRMW(AtomicRMWOp op,
                           unsigned bytes,
                           uint32_t offset,
                           Expression* ptr,
                           Expression* value,
                           Type type) {
    auto* ret = wasm.allocator.alloc<AtomicRMW>();
    ret->op = op;
    ret->bytes = bytes;
    ret->offset = offset;
    ret->ptr = ptr;
    ret->value = value;
    ret->type = type;
    ret->finalize();
    return ret;
  }
  AtomicCmpxchg* makeAtomicCmpxchg(unsigned bytes,
                                   uint32_t offset,
                                   Expression* ptr,
                                   Expression* expected,
                                   Expression* replacement,
                                   Type type) {
    auto* ret = wasm.allocator.alloc<AtomicCmpxchg>();
    ret->bytes = bytes;
    ret->offset = offset;
    ret->ptr = ptr;
    ret->expected = expected;
    ret->replacement = replacement;
    ret->type = type;
    ret->finalize();
    return ret;
  }
  SIMDExtract*
  makeSIMDExtract(SIMDExtractOp op, Expression* vec, uint8_t index) {
    auto* ret = wasm.allocator.alloc<SIMDExtract>();
    ret->op = op;
    ret->vec = vec;
    ret->index = index;
    ret->finalize();
    return ret;
  }
  SIMDReplace* makeSIMDReplace(SIMDReplaceOp op,
                               Expression* vec,
                               uint8_t index,
                               Expression* value) {
    auto* ret = wasm.allocator.alloc<SIMDReplace>();
    ret->op = op;
    ret->vec = vec;
    ret->index = index;
    ret->value = value;
    ret->finalize();
    return ret;
  }
  SIMDShuffle* makeSIMDShuffle(Expression* left,
                               Expression* right,
                               const std::array<uint8_t, 16>& mask) {
    auto* ret = wasm.allocator.alloc<SIMDShuffle>();
    ret->left = left;
    ret->right = right;
    ret->mask = mask;
    ret->finalize();
    return ret;
  }
  SIMDTernary* makeSIMDTernary(SIMDTernaryOp op,
                               Expression* a,
                               Expression* b,
                               Expression* c) {
    auto* ret = wasm.allocator.alloc<SIMDTernary>();
    ret->op = op;
    ret->a = a;
    ret->b = b;
    ret->c = c;
    ret->finalize();
    return ret;
  }
  SIMDShift* makeSIMDShift(SIMDShiftOp op, Expression* vec, Expression* shift) {
    auto* ret = wasm.allocator.alloc<SIMDShift>();
    ret->op = op;
    ret->vec = vec;
    ret->shift = shift;
    ret->finalize();
    return ret;
  }
  SIMDLoad*
  makeSIMDLoad(SIMDLoadOp op, Address offset, Address align, Expression* ptr) {
    auto* ret = wasm.allocator.alloc<SIMDLoad>();
    ret->op = op;
    ret->offset = offset;
    ret->align = align;
    ret->ptr = ptr;
    ret->finalize();
    return ret;
  }
  SIMDLoadStoreLane* makeSIMDLoadStoreLane(SIMDLoadStoreLaneOp op,
                                           Address offset,
                                           Address align,
                                           uint8_t index,
                                           Expression* ptr,
                                           Expression* vec) {
    auto* ret = wasm.allocator.alloc<SIMDLoadStoreLane>();
    ret->op = op;
    ret->offset = offset;
    ret->align = align;
    ret->index = index;
    ret->ptr = ptr;
    ret->vec = vec;
    ret->finalize();
    return ret;
  }
  MemoryInit* makeMemoryInit(uint32_t segment,
                             Expression* dest,
                             Expression* offset,
                             Expression* size) {
    auto* ret = wasm.allocator.alloc<MemoryInit>();
    ret->segment = segment;
    ret->dest = dest;
    ret->offset = offset;
    ret->size = size;
    ret->finalize();
    return ret;
  }
  DataDrop* makeDataDrop(uint32_t segment) {
    auto* ret = wasm.allocator.alloc<DataDrop>();
    ret->segment = segment;
    ret->finalize();
    return ret;
  }
  MemoryCopy*
  makeMemoryCopy(Expression* dest, Expression* source, Expression* size) {
    auto* ret = wasm.allocator.alloc<MemoryCopy>();
    ret->dest = dest;
    ret->source = source;
    ret->size = size;
    ret->finalize();
    return ret;
  }
  MemoryFill*
  makeMemoryFill(Expression* dest, Expression* value, Expression* size) {
    auto* ret = wasm.allocator.alloc<MemoryFill>();
    ret->dest = dest;
    ret->value = value;
    ret->size = size;
    ret->finalize();
    return ret;
  }
  Const* makeConst(Literal value) {
    assert(value.type.isNumber());
    auto* ret = wasm.allocator.alloc<Const>();
    ret->value = value;
    ret->type = value.type;
    return ret;
  }
  template<typename T> Const* makeConst(T x) { return makeConst(Literal(x)); }
  Unary* makeUnary(UnaryOp op, Expression* value) {
    auto* ret = wasm.allocator.alloc<Unary>();
    ret->op = op;
    ret->value = value;
    ret->finalize();
    return ret;
  }
  Const* makeConstPtr(uint64_t val) {
    return makeConst(Literal::makeFromInt64(val, wasm.memory.indexType));
  }
  Binary* makeBinary(BinaryOp op, Expression* left, Expression* right) {
    auto* ret = wasm.allocator.alloc<Binary>();
    ret->op = op;
    ret->left = left;
    ret->right = right;
    ret->finalize();
    return ret;
  }
  Select*
  makeSelect(Expression* condition, Expression* ifTrue, Expression* ifFalse) {
    auto* ret = wasm.allocator.alloc<Select>();
    ret->condition = condition;
    ret->ifTrue = ifTrue;
    ret->ifFalse = ifFalse;
    ret->finalize();
    return ret;
  }
  Select* makeSelect(Expression* condition,
                     Expression* ifTrue,
                     Expression* ifFalse,
                     Type type) {
    auto* ret = wasm.allocator.alloc<Select>();
    ret->condition = condition;
    ret->ifTrue = ifTrue;
    ret->ifFalse = ifFalse;
    ret->finalize(type);
    return ret;
  }
  Return* makeReturn(Expression* value = nullptr) {
    auto* ret = wasm.allocator.alloc<Return>();
    ret->value = value;
    return ret;
  }
  MemorySize* makeMemorySize() {
    auto* ret = wasm.allocator.alloc<MemorySize>();
    if (wasm.memory.is64()) {
      ret->make64();
    }
    ret->finalize();
    return ret;
  }
  MemoryGrow* makeMemoryGrow(Expression* delta) {
    auto* ret = wasm.allocator.alloc<MemoryGrow>();
    if (wasm.memory.is64()) {
      ret->make64();
    }
    ret->delta = delta;
    ret->finalize();
    return ret;
  }
  RefNull* makeRefNull(Type type) {
    auto* ret = wasm.allocator.alloc<RefNull>();
    ret->finalize(type);
    return ret;
  }
  RefIsNull* makeRefIsNull(Expression* value) {
    auto* ret = wasm.allocator.alloc<RefIsNull>();
    ret->value = value;
    ret->finalize();
    return ret;
  }
  RefFunc* makeRefFunc(Name func, Type type) {
    auto* ret = wasm.allocator.alloc<RefFunc>();
    ret->func = func;
    ret->finalize(type);
    return ret;
  }
  RefEq* makeRefEq(Expression* left, Expression* right) {
    auto* ret = wasm.allocator.alloc<RefEq>();
    ret->left = left;
    ret->right = right;
    ret->finalize();
    return ret;
  }
  Try* makeTry(Expression* body, Expression* catchBody) {
    auto* ret = wasm.allocator.alloc<Try>();
    ret->body = body;
    ret->catchBody = catchBody;
    ret->finalize();
    return ret;
  }
  Try* makeTry(Expression* body, Expression* catchBody, Type type) {
    auto* ret = wasm.allocator.alloc<Try>();
    ret->body = body;
    ret->catchBody = catchBody;
    ret->finalize(type);
    return ret;
  }
  Throw* makeThrow(Event* event, const std::vector<Expression*>& args) {
    return makeThrow(event->name, args);
  }
  Throw* makeThrow(Name event, const std::vector<Expression*>& args) {
    auto* ret = wasm.allocator.alloc<Throw>();
    ret->event = event;
    ret->operands.set(args);
    ret->finalize();
    return ret;
  }
  Rethrow* makeRethrow(Expression* exnref) {
    auto* ret = wasm.allocator.alloc<Rethrow>();
    ret->exnref = exnref;
    ret->finalize();
    return ret;
  }
  BrOnExn* makeBrOnExn(Name name, Event* event, Expression* exnref) {
    return makeBrOnExn(name, event->name, exnref, event->sig.params);
  }
  BrOnExn* makeBrOnExn(Name name, Name event, Expression* exnref, Type sent) {
    auto* ret = wasm.allocator.alloc<BrOnExn>();
    ret->name = name;
    ret->event = event;
    ret->exnref = exnref;
    // Copy params info into BrOnExn, because it is necessary when BrOnExn is
    // refinalized without the module.
    ret->sent = sent;
    ret->finalize();
    return ret;
  }
  Unreachable* makeUnreachable() { return wasm.allocator.alloc<Unreachable>(); }
  Pop* makePop(Type type) {
    auto* ret = wasm.allocator.alloc<Pop>();
    ret->type = type;
    ret->finalize();
    return ret;
  }
  template<typename ListType> TupleMake* makeTupleMake(ListType&& operands) {
    auto* ret = wasm.allocator.alloc<TupleMake>();
    ret->operands.set(operands);
    ret->finalize();
    return ret;
  }
  TupleExtract* makeTupleExtract(Expression* tuple, Index index) {
    auto* ret = wasm.allocator.alloc<TupleExtract>();
    ret->tuple = tuple;
    ret->index = index;
    ret->finalize();
    return ret;
  }
  I31New* makeI31New(Expression* value) {
    auto* ret = wasm.allocator.alloc<I31New>();
    ret->value = value;
    ret->finalize();
    return ret;
  }
  I31Get* makeI31Get(Expression* i31, bool signed_) {
    auto* ret = wasm.allocator.alloc<I31Get>();
    ret->i31 = i31;
    ret->signed_ = signed_;
    ret->finalize();
    return ret;
  }
  RefTest* makeRefTest() {
    auto* ret = wasm.allocator.alloc<RefTest>();
    WASM_UNREACHABLE("TODO (gc): ref.test");
    ret->finalize();
    return ret;
  }
  RefCast* makeRefCast() {
    auto* ret = wasm.allocator.alloc<RefCast>();
    WASM_UNREACHABLE("TODO (gc): ref.cast");
    ret->finalize();
    return ret;
  }
  BrOnCast* makeBrOnCast() {
    auto* ret = wasm.allocator.alloc<BrOnCast>();
    WASM_UNREACHABLE("TODO (gc): br_on_cast");
    ret->finalize();
    return ret;
  }
  RttCanon* makeRttCanon() {
    auto* ret = wasm.allocator.alloc<RttCanon>();
    WASM_UNREACHABLE("TODO (gc): rtt.canon");
    ret->finalize();
    return ret;
  }
  RttSub* makeRttSub() {
    auto* ret = wasm.allocator.alloc<RttSub>();
    WASM_UNREACHABLE("TODO (gc): rtt.sub");
    ret->finalize();
    return ret;
  }
  StructNew* makeStructNew() {
    auto* ret = wasm.allocator.alloc<StructNew>();
    WASM_UNREACHABLE("TODO (gc): struct.new");
    ret->finalize();
    return ret;
  }
  StructGet* makeStructGet() {
    auto* ret = wasm.allocator.alloc<StructGet>();
    WASM_UNREACHABLE("TODO (gc): struct.get");
    ret->finalize();
    return ret;
  }
  StructSet* makeStructSet() {
    auto* ret = wasm.allocator.alloc<StructSet>();
    WASM_UNREACHABLE("TODO (gc): struct.set");
    ret->finalize();
    return ret;
  }
  ArrayNew* makeArrayNew() {
    auto* ret = wasm.allocator.alloc<ArrayNew>();
    WASM_UNREACHABLE("TODO (gc): array.new");
    ret->finalize();
    return ret;
  }
  ArrayGet* makeArrayGet() {
    auto* ret = wasm.allocator.alloc<ArrayGet>();
    WASM_UNREACHABLE("TODO (gc): array.get");
    ret->finalize();
    return ret;
  }
  ArraySet* makeArraySet() {
    auto* ret = wasm.allocator.alloc<ArraySet>();
    WASM_UNREACHABLE("TODO (gc): array.set");
    ret->finalize();
    return ret;
  }
  ArrayLen* makeArrayLen() {
    auto* ret = wasm.allocator.alloc<ArrayLen>();
    WASM_UNREACHABLE("TODO (gc): array.len");
    ret->finalize();
    return ret;
  }

  // Additional helpers

  Drop* makeDrop(Expression* value) {
    auto* ret = wasm.allocator.alloc<Drop>();
    ret->value = value;
    ret->finalize();
    return ret;
  }

  // Make a constant expression. This might be a wasm Const, or something
  // else of constant value like ref.null.
  Expression* makeConstantExpression(Literal value) {
    auto type = value.type;
    if (type.isNumber()) {
      return makeConst(value);
    }
    if (type.isFunction()) {
      if (!value.isNull()) {
        return makeRefFunc(value.getFunc(), type);
      }
      return makeRefNull(type);
    }
    TODO_SINGLE_COMPOUND(type);
    switch (type.getBasic()) {
      case Type::externref:
      case Type::exnref: // TODO: ExceptionPackage?
      case Type::anyref:
      case Type::eqref:
        assert(value.isNull() && "unexpected non-null reference type literal");
        return makeRefNull(type);
      case Type::i31ref:
        return makeI31New(makeConst(value.geti31()));
      default: {
        WASM_UNREACHABLE("invalid constant expression");
      }
    }
  }

  Expression* makeConstantExpression(Literals values) {
    assert(values.size() > 0);
    if (values.size() == 1) {
      return makeConstantExpression(values[0]);
    } else {
      std::vector<Expression*> consts;
      for (auto value : values) {
        consts.push_back(makeConstantExpression(value));
      }
      return makeTupleMake(consts);
    }
  }

  // Additional utility functions for building on top of nodes
  // Convenient to have these on Builder, as it has allocation built in

  static Index addParam(Function* func, Name name, Type type) {
    // only ok to add a param if no vars, otherwise indices are invalidated
    assert(func->localIndices.size() == func->sig.params.size());
    assert(name.is());
    std::vector<Type> params(func->sig.params.begin(), func->sig.params.end());
    params.push_back(type);
    func->sig.params = Type(params);
    Index index = func->localNames.size();
    func->localIndices[name] = index;
    func->localNames[index] = name;
    return index;
  }

  static Index addVar(Function* func, Name name, Type type) {
    // always ok to add a var, it does not affect other indices
    assert(type.isConcrete());
    Index index = func->getNumLocals();
    if (name.is()) {
      func->localIndices[name] = index;
      func->localNames[index] = name;
    }
    func->vars.emplace_back(type);
    return index;
  }

  static Index addVar(Function* func, Type type) {
    return addVar(func, Name(), type);
  }

  static void clearLocalNames(Function* func) {
    func->localNames.clear();
    func->localIndices.clear();
  }

  static void clearLocals(Function* func) {
    func->sig.params = Type::none;
    func->vars.clear();
    clearLocalNames(func);
  }

  // ensure a node is a block, if it isn't already, and optionally append to the
  // block
  Block* blockify(Expression* any, Expression* append = nullptr) {
    Block* block = nullptr;
    if (any) {
      block = any->dynCast<Block>();
    }
    if (!block) {
      block = makeBlock(any);
    }
    if (append) {
      block->list.push_back(append);
      block->finalize();
    }
    return block;
  }

  template<typename... Ts>
  Block* blockify(Expression* any, Expression* append, Ts... args) {
    return blockify(blockify(any, append), args...);
  }

  // ensure a node is a block, if it isn't already, and optionally append to the
  // block this variant sets a name for the block, so it will not reuse a block
  // already named
  Block*
  blockifyWithName(Expression* any, Name name, Expression* append = nullptr) {
    Block* block = nullptr;
    if (any) {
      block = any->dynCast<Block>();
    }
    if (!block || block->name.is()) {
      block = makeBlock(any);
    }
    block->name = name;
    if (append) {
      block->list.push_back(append);
      block->finalize();
    }
    return block;
  }

  // a helper for the common pattern of a sequence of two expressions. Similar
  // to blockify, but does *not* reuse a block if the first is one.
  Block* makeSequence(Expression* left, Expression* right) {
    auto* block = makeBlock(left);
    block->list.push_back(right);
    block->finalize();
    return block;
  }

  Block* makeSequence(Expression* left, Expression* right, Type type) {
    auto* block = makeBlock(left);
    block->list.push_back(right);
    block->finalize(type);
    return block;
  }

  // Grab a slice out of a block, replacing it with nops, and returning
  // either another block with the contents (if more than 1) or a single
  // expression
  Expression* stealSlice(Block* input, Index from, Index to) {
    Expression* ret;
    if (to == from + 1) {
      // just one
      ret = input->list[from];
    } else {
      auto* block = wasm.allocator.alloc<Block>();
      for (Index i = from; i < to; i++) {
        block->list.push_back(input->list[i]);
      }
      block->finalize();
      ret = block;
    }
    if (to == input->list.size()) {
      input->list.resize(from);
    } else {
      for (Index i = from; i < to; i++) {
        input->list[i] = wasm.allocator.alloc<Nop>();
      }
    }
    input->finalize();
    return ret;
  }

  // Drop an expression if it has a concrete type
  Expression* dropIfConcretelyTyped(Expression* curr) {
    if (!curr->type.isConcrete()) {
      return curr;
    }
    return makeDrop(curr);
  }

  void flip(If* iff) {
    std::swap(iff->ifTrue, iff->ifFalse);
    iff->condition = makeUnary(EqZInt32, iff->condition);
  }

  // returns a replacement with the precise same type, and with
  // minimal contents. as a replacement, this may reuse the
  // input node
  template<typename T> Expression* replaceWithIdenticalType(T* curr) {
    if (curr->type.isTuple()) {
      return makeConstantExpression(Literal::makeZeros(curr->type));
    }
    if (curr->type.isFunction()) {
      return ExpressionManipulator::refNull(curr, curr->type);
    }
    Literal value;
    // TODO: reuse node conditionally when possible for literals
    TODO_SINGLE_COMPOUND(curr->type);
    switch (curr->type.getBasic()) {
      case Type::i32:
        value = Literal(int32_t(0));
        break;
      case Type::i64:
        value = Literal(int64_t(0));
        break;
      case Type::f32:
        value = Literal(float(0));
        break;
      case Type::f64:
        value = Literal(double(0));
        break;
      case Type::v128: {
        std::array<uint8_t, 16> bytes;
        bytes.fill(0);
        value = Literal(bytes.data());
        break;
      }
      case Type::funcref:
        WASM_UNREACHABLE("handled above");
      case Type::externref:
      case Type::exnref:
      case Type::anyref:
      case Type::eqref:
        return ExpressionManipulator::refNull(curr, curr->type);
      case Type::i31ref:
        return makeI31New(makeConst(0));
      case Type::none:
        return ExpressionManipulator::nop(curr);
      case Type::unreachable:
        return ExpressionManipulator::unreachable(curr);
    }
    return makeConst(value);
  }

  // Module-level helpers

  enum Mutability { Mutable, Immutable };

  static Global*
  makeGlobal(Name name, Type type, Expression* init, Mutability mutable_) {
    auto* glob = new Global;
    glob->name = name;
    glob->type = type;
    glob->init = init;
    glob->mutable_ = mutable_ == Mutable;
    return glob;
  }

  static Event* makeEvent(Name name, uint32_t attribute, Signature sig) {
    auto* event = new Event;
    event->name = name;
    event->attribute = attribute;
    event->sig = sig;
    return event;
  }
};

} // namespace wasm

#endif // wasm_wasm_builder_h
