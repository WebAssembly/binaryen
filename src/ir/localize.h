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

#ifndef wasm_ir_localizer_h
#define wasm_ir_localizer_h

#include <wasm-builder.h>

namespace wasm {

// Make an expression available in a local. If already in one, just
// use that local, otherwise use a new local

struct Localizer {
  Index index;
  Expression* expr;

  Localizer(Expression* input, Function* func, Module* wasm) {
    expr = input;
    if (auto* get = expr->dynCast<GetLocal>()) {
      index = get->index;
    } else if (auto* set = expr->dynCast<SetLocal>()) {
      index = set->index;
    } else {
      index = Builder::addVar(func, expr->type);
      expr = Builder(*wasm).makeTeeLocal(index, expr);
    }
  }
};

} // namespace wasm

#endif // wasm_ir_localizer_h

