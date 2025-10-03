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

//
// Adds imports from a given module, using a random seed, for fuzzing purposes.
// The module will be able to validly link and use parts of the given module.
//
// The seed is generated deterministically from the filename of the wasm to
// import.
//

#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct AddFuzzImports : public Pass {
  // Makes various changes for fuzzing purposes, possibly effectful ones.
  bool addsEffects() override { return true; }

  void run(Module* module) override {
    Name inputFile = getArgument(
      "add-fuzz-imports",
      "AddFuzzImports usage:  wasm-opt --add-fuzz-imports=IMPORTED_WASM");

    Module input;
    ModuleReader reader;
    reader.read(inputFile, wasm);

    addImports(*module, input);
  }

  void addImports(Module& wasm, Module& imported) {
  }
};

Pass* createAddFuzzImportsPass() { return new AddFuzzImports(); }

} // namespace wasm
