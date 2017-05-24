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

#ifndef wasm_ast_literl_utils_h
#define wasm_ast_literl_utils_h

#include "wasm.h"

namespace wasm {

namespace LiteralUtils {

inline Expression* makeZero(WasmType type, Module& wasm) {
  Literal value;
  switch (type) {
    case i32: value = Literal(int32_t(0)); break;
    case i64: value = Literal(int64_t(0)); break;
    case f32: value = Literal(float(0)); break;
    case f64: value = Literal(double(0)); break;
    default: WASM_UNREACHABLE();
  }
  auto* ret = wasm.allocator.alloc<Const>();
  ret->value = value;
  ret->type = value.type;
  return ret;
}

} // namespace LiteralUtils

} // namespace wasm

#endif // wasm_ast_literl_utils_h

