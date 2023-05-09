/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_ir_boolean_h
#define wasm_ir_boolean_h

#include "wasm.h"

namespace wasm::Properties {

inline bool emitsBoolean(Expression* curr) {
  if (auto* unary = curr->dynCast<Unary>()) {
    return unary->isRelational();
  } else if (auto* binary = curr->dynCast<Binary>()) {
    return binary->isRelational();
  } else if (curr->is<RefIsNull>() || curr->is<RefEq>() ||
             curr->is<RefTest>()) {
    return true;
  } else if (auto* eq = curr->dynCast<StringEq>()) {
    return eq->op == StringEqEqual;
  }
  return false;
}

} // namespace wasm::Properties

#endif // wasm_ir_boolean_h
