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

#ifndef wasm_builder_h
#define wasm_builder_h

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
  MixedArena &allocator;

public:
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
  If* makeIf(Expression* condition, Expression* ifTrue, Expression* ifFalse=nullptr) {
    auto* ret = allocator.alloc<If>();
    ret->condition = condition; ret->ifTrue = ifTrue; ret->ifFalse = ifFalse;
    ret->finalize();
    return ret;
  }
  Loop* makeLoop(Name out, Name in, Expression* body) {
    auto* ret = allocator.alloc<Loop>();
    ret->out = out; ret->in = in; ret->body = body;
    ret->finalize();
    return ret;
  }
  Break* makeBreak(Name name, Expression* value=nullptr, Expression* condition=nullptr) {
    auto* ret = allocator.alloc<Break>();
    ret->name = name; ret->value = value; ret->condition = condition;
    ret->finalize();
    return ret;
  }
  // Switch
  // CallBase
  // Call
  // CallImport
  // Also do a version which takes a sig?
  CallIndirect* makeCallIndirect(FunctionType* type, Expression* target, std::vector<Expression*>&& args) {
    auto* call = allocator.alloc<CallIndirect>();
    call->fullType = type;
    call->type = type->result;
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
    ret->type = value->type;
    return ret;
  }
  // Load
  Store* makeStore(unsigned bytes, uint32_t offset, unsigned align, Expression *ptr, Expression *value) {
    auto* ret = allocator.alloc<Store>();
    ret->bytes = bytes; ret->offset = offset; ret->align = align; ret->ptr = ptr; ret->value = value;
    ret->type = value->type;
    return ret;
  }
  Const* makeConst(Literal value) {
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
  // Select
  Return* makeReturn(Expression *value) {
    auto* ret = allocator.alloc<Return>();
    ret->value = value;
    return ret;
  }
  Host* makeHost(HostOp op, Name nameOperand, std::vector<Expression*>&& operands) {
    auto* ret = allocator.alloc<Host>();
    ret->op = op;
    ret->nameOperand = nameOperand;
    ret->operands.set(operands);
    return ret;
  }
  // Unreachable

  // Additional utility functions for building on top of nodes

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
    assert(func->localIndices.size() == func->params.size() + func->vars.size());
    func->vars.emplace_back(type);
    Index index = func->localNames.size();
    func->localIndices[name] = index;
    func->localNames.push_back(name);
    return index;
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
      block->finalize();
    }
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
};

} // namespace wasm

#endif // wasm_builder_h
