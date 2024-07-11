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

#include "ir/utils.h"
#include "wasm-builder.h"
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
    Builder builder(*getModule());
    replaceCurrent(builder.makeSequence(builder.makeDrop(value), curr));
  }

  void visitCall(Call* curr) {
    handleReturnCall(curr, getModule()->getFunction(curr->target)->getSig());
  }

  void visitCallIndirect(CallIndirect* curr) {
    handleReturnCall(curr, curr->heapType.getSignature());
  }

  void visitCallRef(CallRef* curr) {
    Type targetType = curr->target->type;
    if (!targetType.isSignature()) {
      // We don't know what type the call should return, but it will also never
      // be reached, so we don't need to do anything here.
      return;
    }
    handleReturnCall(curr, targetType.getHeapType().getSignature());
  }


  template<typename T>
  void handleReturnCall(T* curr, Signature sig) {
    if (curr->isReturn) {
      // This can no longer be a return call, as it calls something that returns
      // a value, and we do not. Update the type (note we must handle the case
      // of an unreachable child, and also this change may affect our parent, so
      // refinalize the entire function).
      curr->isReturn = false;
      curr->type = sig.results;
      curr->finalize();
      refinalize = true;

      replaceCurrent(Builder(*getModule()).makeDrop(curr));
    }
  }

  void visitFunction(Function* curr) {
    if (curr->body->type.isConcrete()) {
      curr->body = Builder(*getModule()).makeDrop(curr->body);
    }

    if (refinalize) {
      ReFinalize().walkFunctionInModule(curr, getModule());
    }
  }

private:
  bool refinalize = false;
};

} // namespace wasm::ReturnUtils

#endif // wasm_ir_return_h
