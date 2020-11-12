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
// Instruments the Wasm binary with code to log execution at each function
// entry with an index. This list of functions will be used when we split the
// wasm later.
//
// The logging is performed by calling an ffi with an id for each
// call site. You need to provide the import on the JS side.
//

#include "asm_v_wasm.h"
#include "asmjs/shared-constants.h"
#include "shared-constants.h"
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

Name FNLOGGER("log_function");

struct LogFunction : public WalkerPass<PostWalker<LogFunction>> {
  void visitFunction(Function* curr) {
    if (curr->imported()) {
      return;
    }
    if (auto* block = curr->body->dynCast<Block>()) {
      if (!block->list.empty()) {
        block->list.back() = makeLogCall(block->list.back());
      }
    }
    curr->body = makeLogCall(curr->body);
  }

  void visitModule(Module* curr) {
    // Add the import
    auto import = new Function;
    import->name = FNLOGGER;
    import->module = ENV;
    import->base = FNLOGGER;
    import->sig = Signature(Type::i32, Type::none);
    curr->addFunction(import);
  }

private:
  Expression* makeLogCall(Expression* curr) {
    static Index id = 0;
    Builder builder(*getModule());
    return builder.makeSequence(
      builder.makeCall(
        FNLOGGER, {builder.makeConst(int32_t(id++))}, Type::none),
      curr);
  }
};

Pass* createLogFunctionPass() { return new LogFunction(); }

} // namespace wasm
