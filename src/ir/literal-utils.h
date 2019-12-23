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

namespace wasm {

namespace LiteralUtils {

inline Expression* makeFromInt32(int32_t x, Type type, Module& wasm) {
  auto* ret = wasm.allocator.alloc<Const>();
  ret->value = Literal::makeFromInt32(x, type);
  ret->type = type;
  return ret;
}

inline Expression* makeZero(Type type, Module& wasm) {
  // TODO: Switch to using v128.const once V8 supports it
  // (https://bugs.chromium.org/p/v8/issues/detail?id=8460)
  if (type == v128) {
    Builder builder(wasm);
    return builder.makeUnary(SplatVecI32x4,
                             builder.makeConst(Literal(int32_t(0))));
  }
  if (type.isRef()) {
    Builder builder(wasm);
    return builder.makeRefNull();
  }
  return makeFromInt32(0, type, wasm);
}

} // namespace LiteralUtils

} // namespace wasm

#endif // wasm_ir_literal_utils_h
