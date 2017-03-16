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
// Instruments the build with code to log execution at each function
// entry and loop header. This can be useful in debugging, to log out
// a trace, and diff it to another (running in another browser, to
// check for bugs, for example).
//
// The logging is performed by calling an ffi with an id for each
// call site. You need to provide that import on the JS side.
//

#include <wasm.h>
#include <wasm-builder.h>
#include <pass.h>
#include "shared-constants.h"
#include "asmjs/shared-constants.h"
#include "asm_v_wasm.h"

namespace wasm {

Name LOGGER("log_execution");

struct LogExecution : public WalkerPass<PostWalker<LogExecution>> {
  void visitLoop(Loop* curr) {
    curr->body = makeLogCall(curr->body);
  }

  void visitFunction(Function* curr) {
    curr->body = makeLogCall(curr->body);
  }

  void visitModule(Module *curr) {
    // Add the import
    auto import = new Import;
    import->name = LOGGER;
    import->module = ENV;
    import->base = LOGGER;
    import->functionType = ensureFunctionType("vi", curr)->name;
    import->kind = ExternalKind::Function;
    curr->addImport(import);
  }

private:
  Expression* makeLogCall(Expression* curr) {
    static Index id = 0;
    Builder builder(*getModule());
    return builder.makeSequence(
      builder.makeCallImport(
        LOGGER,
        { builder.makeConst(Literal(int32_t(id++))) },
        none
      ),
      curr
    );
  }
};

Pass *createLogExecutionPass() {
  return new LogExecution();
}

} // namespace wasm
