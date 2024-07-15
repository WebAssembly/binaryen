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
// entry, loop header, and return. This can be useful in debugging, to log out
// a trace, and diff it to another (running in another browser, to
// check for bugs, for example).
//
// The logging is performed by calling an ffi with an id for each
// call site. You need to provide that import on the JS side.
//
// This pass is more effective on flat IR (--flatten) since when it
// instruments say a return, there will be no code run in the return's
// value.
//

#include "asmjs/shared-constants.h"
#include "shared-constants.h"
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

Name LOGGER("log_execution");

struct LogExecution : public WalkerPass<PostWalker<LogExecution>> {
  // The module name the logger function is imported from.
  IString loggerModule;

  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    loggerModule = getArgumentOrDefault("log-execution", "");
    super::run(module);
  }

  void visitLoop(Loop* curr) { curr->body = makeLogCall(curr->body); }

  void visitReturn(Return* curr) { replaceCurrent(makeLogCall(curr)); }

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
    auto import =
      Builder::makeFunction(LOGGER, Signature(Type::i32, Type::none), {});

    if (loggerModule != "") {
      import->module = loggerModule;
    } else {
      // Import the log function from import "env" if the module
      // imports other functions from that name.
      for (auto& func : curr->functions) {
        if (func->imported() && func->module == ENV) {
          import->module = func->module;
          break;
        }
      }

      // If not, then pick the import name of the first function we find.
      if (!import->module) {
        for (auto& func : curr->functions) {
          if (func->imported()) {
            import->module = func->module;
            break;
          }
        }
      }

      // If no function was found, use ENV.
      if (!import->module) {
        import->module = ENV;
      }
    }

    import->base = LOGGER;
    curr->addFunction(std::move(import));
  }

private:
  Expression* makeLogCall(Expression* curr) {
    static Index id = 0;
    Builder builder(*getModule());
    return builder.makeSequence(
      builder.makeCall(LOGGER, {builder.makeConst(int32_t(id++))}, Type::none),
      curr);
  }
};

Pass* createLogExecutionPass() { return new LogExecution(); }

} // namespace wasm
