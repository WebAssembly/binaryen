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

#include <wasm.h>

namespace wasm {

// Useful data structures

struct NameType {
  Name name;
  WasmType type;
  NameType() : name(nullptr), type(none) {}
  NameType(Name name, WasmType type) : name(name), type(type) {}
};

// General AST node builder

class Builder {
  MixedArena& allocator;

public:
  Builder(MixedArena& allocator) : allocator(allocator) {}
  Builder(Module& wasm) : allocator(wasm.allocator) {}

  // make* functions, create nodes

  Function* makeFunction(Name name,
                         std::vector<NameType>&& params,
                         WasmType resultType,
                         std::vector<NameType>&& vars,
                         Expression* body = nullptr) {
    auto* func = new Function;
    func->name = name;
    func->result = resultType;
    func->body = body;

    for (auto& param : params) {
      func->params.push_back(param.type);
      func->localIndices[param.name] = func->localNames.size();
      func->localNames.push_back(param.name);
    }
    for (auto& var : vars) {
      func->vars.push_back(var.type);
      func->localIndices[var.name] = func->localNames.size();
      func->localNames.push_back(var.name);
    }

    return func;
  }

  Nop* makeNop() {
    return allocator.alloc<Nop>();
  }
  Block* makeBlock(Expression* first = nullptr) {
    auto* ret = allocator.alloc<Block>();
    if (first) {
      ret->list.push_back(first);
      ret->finalize();
    }
    return ret;
  }
  If* makeIf(Expression* condition, Expression* ifTrue, Expression* ifFalse = nullptr) {
    auto* ret = allocator.alloc<If>();
    ret->condition = condition; ret->ifTrue = ifTrue; ret->ifFalse = ifFalse;
    ret->finalize();
    return ret;
  }
  Loop* makeLoop(Name name, Expression* body) {
    auto* ret = allocator.alloc<Loop>();
    ret->name = name; ret->body = body;
    ret->finalize();
    return ret;
  }
  Break* makeBreak(Name name, Expression* value = nullptr, Expression* condition = nullptr) {
    auto* ret = allocator.alloc<Break>();
    ret->name = name; ret->value = value; ret->condition = condition;
    ret->finalize();
    return ret;
  }
  template<typename T>
  Switch* makeSwitch(T& list, Name default_, Expression* condition, Expression* value = nullptr) {
    auto* ret = allocator.alloc<Switch>();
    ret->targets.set(list);
    ret->default_ = default_; ret->value = value; ret->condition = condition;
    return ret;
  }
  Call* makeCall(Name target, const std::vector<Expression*>& args, WasmType type) {
    auto* call = allocator.alloc<Call>();
    call->type = type; // not all functions may exist yet, so type must be provided
    call->target = target;
    call->operands.set(args);
    return call;
  }
  CallImport* makeCallImport(Name target, const std::vector<Expression*>& args, WasmType type) {
    auto* call = allocator.alloc<CallImport>();
    call->type = type; // similar to makeCall, for consistency
    call->target = target;
    call->operands.set(args);
    return call;
  }
  template<typename T>
  Call* makeCall(Name target, const T& args, WasmType type) {
    auto* call = allocator.alloc<Call>();
    call->type = type; // not all functions may exist yet, so type must be provided
    call->target = target;
    call->operands.set(args);
    return call;
  }
  template<typename T>
  CallImport* makeCallImport(Name target, const T& args, WasmType type) {
    auto* call = allocator.alloc<CallImport>();
    call->type = type; // similar to makeCall, for consistency
    call->target = target;
    call->operands.set(args);
    return call;
  }
  CallIndirect* makeCallIndirect(FunctionType* type, Expression* target, const std::vector<Expression*>& args) {
    auto* call = allocator.alloc<CallIndirect>();
    call->fullType = type->name;
    call->type = type->result;
    call->target = target;
    call->operands.set(args);
    return call;
  }
  CallIndirect* makeCallIndirect(Name fullType, Expression* target, const std::vector<Expression*>& args, WasmType type) {
    auto* call = allocator.alloc<CallIndirect>();
    call->fullType = fullType;
    call->type = type;
    call->target = target;
    call->operands.set(args);
    return call;
  }
  // FunctionType
  GetLocal* makeGetLocal(Index index, WasmType type) {
    auto* ret = allocator.alloc<GetLocal>();
    ret->index = index;
    ret->type = type;
    return ret;
  }
  SetLocal* makeSetLocal(Index index, Expression* value) {
    auto* ret = allocator.alloc<SetLocal>();
    ret->index = index;
    ret->value = value;
    ret->type = none;
    return ret;
  }
  SetLocal* makeTeeLocal(Index index, Expression* value) {
    auto* ret = allocator.alloc<SetLocal>();
    ret->index = index;
    ret->value = value;
    ret->type = value->type;
    return ret;
  }
  GetGlobal* makeGetGlobal(Name name, WasmType type) {
    auto* ret = allocator.alloc<GetGlobal>();
    ret->name = name;
    ret->type = type;
    return ret;
  }
  SetGlobal* makeSetGlobal(Name name, Expression* value) {
    auto* ret = allocator.alloc<SetGlobal>();
    ret->name = name;
    ret->value = value;
    return ret;
  }
  Load* makeLoad(unsigned bytes, bool signed_, uint32_t offset, unsigned align, Expression *ptr, WasmType type) {
    auto* ret = allocator.alloc<Load>();
    ret->bytes = bytes; ret->signed_ = signed_; ret->offset = offset; ret->align = align; ret->ptr = ptr;
    ret->type = type;
    return ret;
  }
  Store* makeStore(unsigned bytes, uint32_t offset, unsigned align, Expression *ptr, Expression *value, WasmType type) {
    auto* ret = allocator.alloc<Store>();
    ret->bytes = bytes; ret->offset = offset; ret->align = align; ret->ptr = ptr; ret->value = value; ret->valueType = type;
    ret->finalize();
    assert(isConcreteWasmType(ret->value->type) ? ret->value->type == type : true);
    return ret;
  }
  Const* makeConst(Literal value) {
    assert(isConcreteWasmType(value.type));
    auto* ret = allocator.alloc<Const>();
    ret->value = value;
    ret->type = value.type;
    return ret;
  }
  Unary* makeUnary(UnaryOp op, Expression *value) {
    auto* ret = allocator.alloc<Unary>();
    ret->op = op; ret->value = value;
    ret->finalize();
    return ret;
  }
  Binary* makeBinary(BinaryOp op, Expression *left, Expression *right) {
    auto* ret = allocator.alloc<Binary>();
    ret->op = op; ret->left = left; ret->right = right;
    ret->finalize();
    return ret;
  }
  Select* makeSelect(Expression* condition, Expression *ifTrue, Expression *ifFalse) {
    auto* ret = allocator.alloc<Select>();
    ret->condition = condition; ret->ifTrue = ifTrue; ret->ifFalse = ifFalse;
    ret->finalize();
    return ret;
  }
  Return* makeReturn(Expression *value = nullptr) {
    auto* ret = allocator.alloc<Return>();
    ret->value = value;
    return ret;
  }
  Host* makeHost(HostOp op, Name nameOperand, std::vector<Expression*>&& operands) {
    auto* ret = allocator.alloc<Host>();
    ret->op = op;
    ret->nameOperand = nameOperand;
    ret->operands.set(operands);
    ret->finalize();
    return ret;
  }
  Unreachable* makeUnreachable() {
    return allocator.alloc<Unreachable>();
  }

  // Additional helpers

  Drop* makeDrop(Expression *value) {
    auto* ret = allocator.alloc<Drop>();
    ret->value = value;
    ret->finalize();
    return ret;
  }

  // Additional utility functions for building on top of nodes
  // Convenient to have these on Builder, as it has allocation built in

  static Index addParam(Function* func, Name name, WasmType type) {
    // only ok to add a param if no vars, otherwise indices are invalidated
    assert(func->localIndices.size() == func->params.size());
    func->params.push_back(type);
    Index index = func->localNames.size();
    func->localIndices[name] = index;
    func->localNames.push_back(name);
    return index;
  }

  static Index addVar(Function* func, Name name, WasmType type) {
    // always ok to add a var, it does not affect other indices
    Index index = func->getNumLocals();
    if (name.is()) {
      // if there is a name, apply it, but here we assume all the rest have names too FIXME
      assert(func->localIndices.size() == func->params.size() + func->vars.size());
      func->localIndices[name] = index;
      func->localNames.push_back(name);
    }
    func->vars.emplace_back(type);
    return index;
  }

  static Index addVar(Function* func, WasmType type) {
    return addVar(func, Name(), type);
  }

  static void clearLocals(Function* func) {
    func->params.clear();
    func->vars.clear();
    func->localNames.clear();
    func->localIndices.clear();
  }

  // ensure a node is a block, if it isn't already, and optionally append to the block
  Block* blockify(Expression* any, Expression* append = nullptr) {
    Block* block = nullptr;
    if (any) block = any->dynCast<Block>();
    if (!block) block = makeBlock(any);
    if (append) {
      block->list.push_back(append);
      block->finalize(); // TODO: move out of if
    }
    return block;
  }

  // ensure a node is a block, if it isn't already, and optionally append to the block
  // this variant sets a name for the block, so it will not reuse a block already named
  Block* blockifyWithName(Expression* any, Name name, Expression* append = nullptr) {
    Block* block = nullptr;
    if (any) block = any->dynCast<Block>();
    if (!block || block->name.is()) block = makeBlock(any);
    block->name = name;
    if (append) {
      block->list.push_back(append);
      block->finalize(); // TODO: move out of if
    }
    return block;
  }

  // ensures the first node is a block, if it isn't already, and merges in the second,
  // either as a single element or, if a block, by appending to the first block
  Block* blockifyMerge(Expression* any, Expression* append) {
    Block* block = nullptr;
    if (any) block = any->dynCast<Block>();
    if (!block) {
      block = makeBlock(any);
    } else {
      assert(!isConcreteWasmType(block->type));
    }
    auto* other = append->dynCast<Block>();
    if (!other) {
      block->list.push_back(append);
    } else {
      for (auto* item : other->list) {
        block->list.push_back(item);
      }
    }
    block->finalize(); // TODO: move out of if
    return block;
  }

  // a helper for the common pattern of a sequence of two expressions. Similar to
  // blockify, but does *not* reuse a block if the first is one.
  Block* makeSequence(Expression* left, Expression* right) {
    auto* block = makeBlock(left);
    block->list.push_back(right);
    block->finalize();
    return block;
  }

  // Grab a slice out of a block, replacing it with nops, and returning
  // either another block with the contents (if more than 1) or a single expression
  Expression* stealSlice(Block* input, Index from, Index to) {
    Expression* ret;
    if (to == from + 1) {
      // just one
      ret = input->list[from];
    } else {
      auto* block = allocator.alloc<Block>();
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
        input->list[i] = allocator.alloc<Nop>();
      }
    }
    input->finalize();
    return ret;
  }

  // Drop an expression if it has a concrete type
  Expression* dropIfConcretelyTyped(Expression* curr) {
    if (!isConcreteWasmType(curr->type)) return curr;
    return makeDrop(curr);
  }

  void flip(If* iff) {
    std::swap(iff->ifTrue, iff->ifFalse);
    iff->condition = makeUnary(EqZInt32, iff->condition);
  }
};

} // namespace wasm

#endif // wasm_wasm_builder_h
