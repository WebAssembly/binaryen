/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Prints the a map of function indexes to function names. This can be
// useful for interpreting a stack trace from a production environment
// where names did not exist on the client. The map looks like this:
//
// 0:foo
// 1:bar
// 2:baz
//

#include "ir/module-utils.h"
#include "pass.h"
#include "support/file.h"
#include "wasm.h"

namespace wasm {

struct PrintFunctionMap : public Pass {
  bool modifiesBinaryenIR() override { return false; }

  void run(Module* module) override {
    // If an argument is provided, write to that file; otherwise write to
    // stdout.
    auto outFile = getArgumentOrDefault("symbolmap", "");
    Output output(outFile, Flags::Text);
    auto& o = output.getStream();
    Index i = 0;
    auto write = [&](Function* func) {
      o << i++ << ':' << func->name.str << '\n';
    };
    ModuleUtils::iterImportedFunctions(*module, write);
    ModuleUtils::iterDefinedFunctions(*module, write);
  }
};

Pass* createPrintFunctionMapPass() { return new PrintFunctionMap(); }

} // namespace wasm
