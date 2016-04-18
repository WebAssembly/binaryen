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

class Builder {
  MixedArena &allocator;

public:
  Builder(Module& wasm) : allocator(wasm.allocator) {}

  Function* makeFunction(Name name,
                         std::vector<NameType>&& params,
                         WasmType resultType,
                         std::vector<NameType>&& vars) {
    auto* func = allocator.alloc<Function>();
    func->name = name;
    func->params = params;
    func->result = resultType;
    func->vars = vars;
    return func;
  }

  // Nop TODO: add all the rest
  // Block
  If* makeIf(Expression* condition, Expression* ifTrue, Expression* ifFalse=nullptr) {
    auto* ret = allocator.alloc<If>();
    ret->condition = condition; ret->ifTrue = ifTrue; ret->ifFalse = ifFalse;
    ret->finalize();
    return ret;
  }
  // Loop
  // Break
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
    call->operands = args;
    return call;
  }
  // FunctionType
  GetLocal* makeGetLocal(Name name, WasmType type) {
    auto* ret = allocator.alloc<GetLocal>();
    ret->name = name;
    ret->type = type;
    return ret;
  }
  SetLocal* makeSetLocal(Name name, Expression* value) {
    auto* ret = allocator.alloc<SetLocal>();
    ret->name = name;
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
  Unary* makeUnary(UnaryOp op, Expression *value, WasmType type=none) {
    auto* ret = allocator.alloc<Unary>();
    ret->op = op; ret->value = value;
    if (type != none) {
      ret->type = type; // some opcodes have more than one type, user must provide it
    } else {
      switch (op) {
        case Clz:
        case Ctz:
        case Popcnt:
        case Neg:
        case Abs:
        case Ceil:
        case Floor:
        case Trunc:
        case Nearest:
        case Sqrt: ret->type = value->type; break;
        case EqZ: ret->type = i32; break;
        case ExtendSInt32: case ExtendUInt32: ret->type = i64; break;
        case WrapInt64: ret->type = i32; break;
        case PromoteFloat32: ret->type = f64; break;
        case DemoteFloat64: ret->type = f32; break;
        case TruncSFloat32: case TruncUFloat32: case TruncSFloat64: case TruncUFloat64: case ReinterpretFloat:
        case ConvertSInt32: case ConvertUInt32: case ConvertSInt64: case ConvertUInt64: case ReinterpretInt: abort(); // user needs to say the type
        default: abort();
      }
    }
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
  // Host
  // Unreachable

};

} // namespace wasm

#endif // wasm_builder_h
