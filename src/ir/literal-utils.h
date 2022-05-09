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

#ifndef wasm_ir_literal_utils_h
#define wasm_ir_literal_utils_h

#include "wasm-builder.h"
#include "wasm.h"

namespace wasm::LiteralUtils {

inline Expression* makeFromInt32(int32_t x, Type type, Module& wasm) {
  auto* ret = wasm.allocator.alloc<Const>();
  ret->value = Literal::makeFromInt32(x, type);
  ret->type = type;
  return ret;
}

inline bool canMakeZero(Type type) {
  if (type.isNonNullable()) {
    return false;
  }
  if (type.isRtt() && type.getRtt().hasDepth()) {
    // An rtt with depth cannot be constructed as a simple zero: we'd need to
    // create not just a zero (an rtt.canon) but also some rtt.subs that add to
    // the depth, so disallow that. Also, there is no practical way to create a
    // zero Literal for such a type, as we'd need to supply the list of super
    // types somehow, and creating a zero Literal is how makeZero works.
    return false;
  }
  if (type.isTuple()) {
    for (auto t : type) {
      if (!canMakeZero(t)) {
        return false;
      }
    }
  }
  return true;
}

inline Expression* makeZero(Type type, Module& wasm) {
  assert(canMakeZero(type));
  // TODO: Remove this function once V8 supports v128.const
  // (https://bugs.chromium.org/p/v8/issues/detail?id=8460)
  Builder builder(wasm);
  if (type == Type::v128) {
    return builder.makeUnary(SplatVecI32x4, builder.makeConst(int32_t(0)));
  }
  return builder.makeConstantExpression(Literal::makeZeros(type));
}

} // namespace wasm::LiteralUtils

#endif // wasm_ir_literal_utils_h
