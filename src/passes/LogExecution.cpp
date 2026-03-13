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
#include <set>
#include <unordered_map>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

Name LOGGER("log_execution");

struct LogExecution : public WalkerPass<PostWalker<LogExecution>> {
  std::unordered_map<Function*, Index> functionOrdinals;
  std::set<Index> usedFunctionOrdinals;
  // The module name the logger function is imported from.
  IString loggerModule;

  // Adds calls to new imports.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    loggerModule = getArgumentOrDefault("log-execution", "");
    Super::run(module);
  }

  Index nextFreeIndex = 0;

  // Tries to convert a string (containing a number) to a function index.
  // Returns (Index)-1 on failure.
  Index stringToIndex(const char* s) {
    for (const char* q = s; *q; ++q) {
      if (!isdigit(*q)) {
        return (Index)-1;
      }
    }
    return std::stoi(s);
  }

  void visitLoop(Loop* curr) {
    curr->body = makeLogCall(curr->body, nextFreeIndex++);
  }

  void visitReturn(Return* curr) {
    replaceCurrent(makeLogCall(curr, nextFreeIndex++));
  }

  void visitFunction(Function* curr) {
    if (curr->imported()) {
      return;
    }

    if (auto* block = curr->body->dynCast<Block>()) {
      if (!block->list.empty()) {
        block->list.back() = makeLogCall(block->list.back(), nextFreeIndex++);
      }
    }

    if (functionOrdinals.find(curr) == functionOrdinals.end()) {
      Fatal() << "LogExecution: Internal mismatch in mapping functions to "
                 "their ordinals for logging execution!";
    }

    curr->body = makeLogCall(curr->body, functionOrdinals.find(curr)->second);
  }

  void doWalkModule(Module* curr) {
    // Add the import
    auto import = Builder::makeFunction(
      LOGGER, Type(Signature(Type::i32, Type::none), NonNullable, Inexact), {});

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

    // Assigning logged function IDs to each WebAssembly function could be done
    // arbitrarily e.g. by assign any which random unique integer to each
    // function, but to provide general purpose to users of the LogExecution
    // pass, strive to assign each function the same log ID that the function
    // ordinal is.

    // As convention, imports have function ordinals [0, numImports[,
    // so skip using those numbers as IDs.
    Index numImports = 0;
    for (auto& func : curr->functions) {
      if (func->imported()) {
        ++numImports;
      }
    }

    // First assign function indices to all functions that do not have a name,
    // but are identified only with ordinals.
    for (auto& func : curr->functions) {
      if (func->imported()) {
        continue;
      }

      Index currentFunctionIndex =
        (Index)stringToIndex(func->name.toString().c_str());

      if (currentFunctionIndex != (Index)-1) {
        functionOrdinals[func.get()] = currentFunctionIndex;
        usedFunctionOrdinals.insert(currentFunctionIndex);
      }
    }

    // Last, assign function indices to all remaining named functions.
    nextFreeIndex = numImports;
    for (auto& func : curr->functions) {
      if (func->imported()) {
        continue;
      }

      // Was this function already assigned a name in previous pass?
      if (functionOrdinals.find(func.get()) != functionOrdinals.end()) {
        continue;
      }

      // Skip over index numbers that were used in the previous pass.
      while (usedFunctionOrdinals.find(nextFreeIndex) !=
             usedFunctionOrdinals.end()) {
        ++nextFreeIndex;
      }

      usedFunctionOrdinals.insert(nextFreeIndex);
      functionOrdinals[func.get()] = nextFreeIndex++;
    }

    PostWalker<LogExecution>::doWalkModule(curr);
  }

private:
  Expression* makeLogCall(Expression* curr, Index index) {
    Builder builder(*getModule());
    return builder.makeSequence(
      builder.makeCall(LOGGER, {builder.makeConst(int32_t(index))}, Type::none),
      curr);
  }
};

Pass* createLogExecutionPass() { return new LogExecution(); }

} // namespace wasm
