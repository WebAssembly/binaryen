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

#ifndef wasm_ast_properties_h
#define wasm_ast_properties_h

#include "wasm.h"

namespace wasm {

struct Properties {
  static bool emitsBoolean(Expression* curr) {
    if (auto* unary = curr->dynCast<Unary>()) {
      return unary->isRelational();
    } else if (auto* binary = curr->dynCast<Binary>()) {
      return binary->isRelational();
    }
    return false;
  }

  static bool isSymmetric(Binary* binary) {
    switch (binary->op) {
      case AddInt32:
      case MulInt32: 
      case AndInt32:
      case OrInt32:
      case XorInt32:
      case EqInt32:
      case NeInt32:

      case AddInt64:
      case MulInt64: 
      case AndInt64:
      case OrInt64:
      case XorInt64:
      case EqInt64:
      case NeInt64: return true;

      default: return false;
    }
  }
};

} // wasm

#endif // wams_ast_properties_h

