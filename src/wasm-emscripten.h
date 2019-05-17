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

// Class which modifies a wasm module for use with emscripten. Generates
// runtime functions and emits metadata.
class EmscriptenGlueGenerator {
public:
  EmscriptenGlueGenerator(Module& wasm, Address stackPointerOffset = Address(0))
    : wasm(wasm), builder(wasm), stackPointerOffset(stackPointerOffset),
      useStackPointerGlobal(stackPointerOffset == 0) {}

  void generateRuntimeFunctions();
  Function* generateMemoryGrowthFunction();
  Function* generateAssignGOTEntriesFunction();
  void generateStackInitialization(Address addr);
  void generatePostInstantiateFunction();

  // Create thunks for use with emscripten Runtime.dynCall. Creates one for each
  // signature in the indirect function table.
  void generateDynCallThunks();

  // Convert stack pointer access from global.get/global.set to calling save
  // and restore functions.
  void replaceStackPointerGlobal();

  std::string
  generateEmscriptenMetadata(Address staticBump,
                             std::vector<Name> const& initializerFunctions);

  void fixInvokeFunctionNames();

  // Emits the data segments to a file. The file contains data from address base
  // onwards (we must pass in base, as we can't tell it from the wasm - the
  // first segment may start after a run of zeros, but we need those zeros in
  // the file).
  void separateDataSegments(Output* outfile, Address base);

private:
  Module& wasm;
  Builder builder;
  Address stackPointerOffset;
  bool useStackPointerGlobal;
  // Used by generateDynCallThunk to track all the dynCall functions created
  // so far.
  std::unordered_set<std::string> sigs;

  Global* getStackPointerGlobal();
  Expression* generateLoadStackPointer();
  Expression* generateStoreStackPointer(Expression* value);
  void generateDynCallThunk(std::string sig);
  void generateStackSaveFunction();
  void generateStackAllocFunction();
  void generateStackRestoreFunction();
};

} // namespace wasm

#endif // wasm_wasm_emscripten_h
