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

#ifndef wasm_ir_import_h
#define wasm_ir_import_h

#include "literal.h"
#include "wasm.h"

namespace wasm {

struct ImportInfo {
  Module& wasm;

  std::vector<Global*> importedGlobals;
  std::vector<Function*> importedFunctions;

  ImportInfo(Module& wasm) {
    for (auto& import : wasm.globals) {
      if (import->module == module && import->base == base) {
        importedGlobals.push_back(import.get());
      }
    }
    for (auto& import : wasm.functions) {
      if (import->module == module && import->base == base) {
        importedFunctions.push_back(import.get());
      }
    }
  }

  Global* getImportedGlobal(Name module, Name base) {
    for (auto* import : importedGlobals) {
      if (import->module == module && import->base == base) {
        return import;
      }
    }
    return nullptr;
  }

  Function* getImportedFunction(Name module, Name base) {
    for (auto* import : importedFunctions) {
      if (import->module == module && import->base == base) {
        return import;
      }
    }
    return nullptr;
  }

  Index getNumGlobalImports() {
    return importedGlobals.size();
  }

  Index getNumFunctionImports() {
    return importedFunctions.size();
  }

  Index getNumImports() {
    return getNumGlobalImports() + getNumFunctionImports();
  }
};

} // namespace wasm

#endif // wasm_ir_import_h

