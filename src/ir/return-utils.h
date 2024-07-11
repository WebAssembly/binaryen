/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_ir_return_h
#define wasm_ir_return_h

#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm::ReturnUtils {

// Removes values from both explicit returns and implicit ones (values that flow
// from the body). This is useful after changing a function's type to no longer
// return anything.
struct ReturnValueRemover : public PostWalker<ReturnValueRemover> {
  void visitReturn(Return* curr) {
    auto* value = curr->value;
    assert(value);
    curr->value = nullptr;
    Builder builder(*module);
    replaceCurrent(builder.makeSequence(builder.makeDrop(value), curr));
  }

  void visitFunction(Function* curr) {
    if (curr->body->type.isConcrete()) {
      curr->body = Builder(*module).makeDrop(curr->body);
    }
  }
};

} // namespace wasm::ReturnUtils

#endif // wasm_ir_return_h
