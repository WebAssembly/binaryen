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

#ifndef wasm_wasm_emscripten_h
#define wasm_wasm_emscripten_h

#include "support/file.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

Global* getStackPointerGlobal(Module& wasm);

// Class which modifies a wasm module for use with emscripten. Generates
// runtime functions and emits metadata.
class EmscriptenGlueGenerator {
public:
  EmscriptenGlueGenerator(Module& wasm, Address stackPointerOffset = Address(0))
    : wasm(wasm), builder(wasm), stackPointerOffset(stackPointerOffset),
      useStackPointerGlobal(stackPointerOffset == 0) {}

  std::string generateEmscriptenMetadata();

  void fixInvokeFunctionNames();

  // clang uses name mangling to rename the argc/argv form of main to
  // __main_argc_argv.  Emscripten in non-standalone mode expects that function
  // to be exported as main.  This function renames __main_argc_argv to main
  // as expected by emscripten.
  void renameMainArgcArgv();

  // Emits the data segments to a file. The file contains data from address base
  // onwards (we must pass in base, as we can't tell it from the wasm - the
  // first segment may start after a run of zeros, but we need those zeros in
  // the file).
  void separateDataSegments(Output* outfile, Address base);

  bool standalone = false;
  bool sideModule = false;
  bool minimizeWasmChanges = false;
  bool noDynCalls = false;
  bool onlyI64DynCalls = false;

private:
  Module& wasm;
  Builder builder;
  Address stackPointerOffset;
  bool useStackPointerGlobal;
};

} // namespace wasm

#endif // wasm_wasm_emscripten_h
