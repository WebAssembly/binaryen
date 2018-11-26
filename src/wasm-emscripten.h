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

#include "wasm.h"
#include "wasm-builder.h"
#include "support/file.h"


namespace wasm {

// Class which modifies a wasm module for use with emscripten. Generates
// runtime functions and emits metadata.
class EmscriptenGlueGenerator {
public:
  EmscriptenGlueGenerator(Module& wasm, Address stackPointerOffset = Address(0))
    : wasm(wasm),
      builder(wasm),
      stackPointerOffset(stackPointerOffset),
      useStackPointerGlobal(stackPointerOffset == 0) { }

  void generateRuntimeFunctions();
  Function* generateMemoryGrowthFunction();

  // Create thunks for use with emscripten Runtime.dynCall. Creates one for each
  // signature in the indirect function table.
  void generateDynCallThunks();

  // Create thunks to support emscripten's addFunction functionality. Creates (#
  // of reserved function pointers) thunks for each indirectly called function
  // signature.
  void generateJSCallThunks(unsigned numReservedFunctionPointers);

  std::string generateEmscriptenMetadata(
      Address staticBump, std::vector<Name> const& initializerFunctions,
      unsigned numReservedFunctionPointers);

  void fixInvokeFunctionNames();

  void separateDataSegments(Output* outfile);

private:
  Module& wasm;
  Builder builder;
  Address stackPointerOffset;
  bool useStackPointerGlobal;

  Global* getStackPointerGlobal();
  Expression* generateLoadStackPointer();
  Expression* generateStoreStackPointer(Expression* value);
  void generateStackSaveFunction();
  void generateStackAllocFunction();
  void generateStackRestoreFunction();
};

} // namespace wasm

#endif // wasm_wasm_emscripten_h
