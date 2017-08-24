/*
 * Copyright 2017 WebAssembly Community Group participants
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

//
// Helper functions for supporting potentially-trapping float operations.
//

#ifndef wasm_float_clamp_h
#define wasm_float_clamp_h

#include "mixed_arena.h"
#include "wasm.h"
#include "wasm-builder.h"
#include "support/name.h"

namespace wasm {

enum class FloatTrapMode {
  Allow,
  Clamp,
  JS
};

struct FloatTrapContext {
  FloatTrapMode trapMode;
  Module& wasm;
  MixedArena& allocator;
  Builder& builder;

  FloatTrapContext(FloatTrapMode trapMode, Module& wasm,
                   MixedArena& allocator, Builder& builder)
    : trapMode(trapMode),
      wasm(wasm),
      allocator(allocator),
      builder(builder) {}
};

Name I64S_REM("i64s-rem"),
     I64U_REM("i64u-rem"),
     I64S_DIV("i64s-div"),
     I64U_DIV("i64u-div");

// Some binary opts might trap, so emit them safely if necessary
Expression* makeTrappingI32Binary(
    BinaryOp op, Expression* left, Expression* right, FloatTrapContext context) {
  if (context.trapMode == FloatTrapMode::Allow) {
    return context.builder.makeBinary(op, left, right);
  }
  // the wasm operation might trap if done over 0, so generate a safe call
  auto *call = context.allocator.alloc<Call>();
  switch (op) {
    case BinaryOp::RemSInt32: call->target = I32S_REM; break;
    case BinaryOp::RemUInt32: call->target = I32U_REM; break;
    case BinaryOp::DivSInt32: call->target = I32S_DIV; break;
    case BinaryOp::DivUInt32: call->target = I32U_DIV; break;
    default: WASM_UNREACHABLE();
  }
  call->operands.push_back(left);
  call->operands.push_back(right);
  call->type = i32;
  static std::set<Name> addedFunctions;
  if (addedFunctions.count(call->target) == 0) {
    Builder& builder = context.builder;
    Expression* result = builder.makeBinary(op,
      builder.makeGetLocal(0, i32),
      builder.makeGetLocal(1, i32)
    );
    if (op == DivSInt32) {
      // guard against signed division overflow
      result = builder.makeIf(
        builder.makeBinary(AndInt32,
          builder.makeBinary(EqInt32,
            builder.makeGetLocal(0, i32),
            builder.makeConst(Literal(std::numeric_limits<int32_t>::min()))
          ),
          builder.makeBinary(EqInt32,
            builder.makeGetLocal(1, i32),
            builder.makeConst(Literal(int32_t(-1)))
          )
        ),
        builder.makeConst(Literal(int32_t(0))),
        result
      );
    }
    addedFunctions.insert(call->target);
    auto func = new Function;
    func->name = call->target;
    func->params.push_back(i32);
    func->params.push_back(i32);
    func->result = i32;
    func->body = builder.makeIf(
      builder.makeUnary(EqZInt32,
        builder.makeGetLocal(1, i32)
      ),
      builder.makeConst(Literal(int32_t(0))),
      result
    );
    context.wasm.addFunction(func);
  }
  return call;
}

Expression* makeTrappingI64Binary(
    BinaryOp op, Expression* left, Expression* right, FloatTrapContext context) {
  if (context.trapMode == FloatTrapMode::Allow) {
    return context.builder.makeBinary(op, left, right);
  }
  // wasm operation might trap if done over 0, so generate a safe call
  auto *call = context.allocator.alloc<Call>();
  switch (op) {
    case BinaryOp::RemSInt64: call->target = I64S_REM; break;
    case BinaryOp::RemUInt64: call->target = I64U_REM; break;
    case BinaryOp::DivSInt64: call->target = I64S_DIV; break;
    case BinaryOp::DivUInt64: call->target = I64U_DIV; break;
    default: WASM_UNREACHABLE();
  }
  call->operands.push_back(left);
  call->operands.push_back(right);
  call->type = i64;
  static std::set<Name> addedFunctions;
  if (addedFunctions.count(call->target) == 0) {
    Builder& builder = context.builder;
    Expression* result = builder.makeBinary(op,
      builder.makeGetLocal(0, i64),
      builder.makeGetLocal(1, i64)
    );
    if (op == DivSInt64) {
      // guard against signed division overflow
      result = builder.makeIf(
        builder.makeBinary(AndInt32,
          builder.makeBinary(EqInt64,
            builder.makeGetLocal(0, i64),
            builder.makeConst(Literal(std::numeric_limits<int64_t>::min()))
          ),
          builder.makeBinary(EqInt64,
            builder.makeGetLocal(1, i64),
            builder.makeConst(Literal(int64_t(-1)))
          )
        ),
        builder.makeConst(Literal(int64_t(0))),
        result
      );
    }
    addedFunctions.insert(call->target);
    auto func = new Function;
    func->name = call->target;
    func->params.push_back(i64);
    func->params.push_back(i64);
    func->result = i64;
    func->body = builder.makeIf(
      builder.makeUnary(EqZInt64,
        builder.makeGetLocal(1, i64)
      ),
      builder.makeConst(Literal(int64_t(0))),
      result
    );
    context.wasm.addFunction(func);
  }
  return call;
}

} // namespace wasm

#endif // wasm_float_clamp_h
