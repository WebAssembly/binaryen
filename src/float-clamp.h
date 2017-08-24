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

namespace wasm {

enum class FloatTrapMode {
  Allow,
  Clamp,
  JS
};

// Some binary opts might trap, so emit them safely if necessary
Expression* makeTrappingI32Binary(
    BinaryOp op, Expression* left, Expression* right,
    FloatTrapMode trapMode, Module& wasm, MixedArena& allocator, Builder& builder) {
  if (trapMode == FloatTrapMode::Allow) return builder.makeBinary(op, left, right);
  // the wasm operation might trap if done over 0, so generate a safe call
  auto *call = allocator.alloc<Call>();
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
    wasm.addFunction(func);
  }
  return call;
}

} // namespace wasm

#endif // wasm_float_clamp_h
