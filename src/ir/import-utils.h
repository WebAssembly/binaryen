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

// Collects info on imports, into a form convenient for summarizing
// and searching.
struct ImportInfo {
  Module& wasm;

  std::vector<Global*> importedGlobals;
  std::vector<Function*> importedFunctions;
  std::vector<Table*> importedTables;
  std::vector<Memory*> importedMemories;
  std::vector<Tag*> importedTags;

  ImportInfo(Module& wasm) : wasm(wasm) {
    for (auto& import : wasm.globals) {
      if (import->imported()) {
        importedGlobals.push_back(import.get());
      }
    }
    for (auto& import : wasm.functions) {
      if (import->imported()) {
        importedFunctions.push_back(import.get());
      }
    }
    for (auto& import : wasm.tables) {
      if (import->imported()) {
        importedTables.push_back(import.get());
      }
    }
    for (auto& import : wasm.memories) {
      if (import->imported()) {
        importedMemories.push_back(import.get());
      }
    }
    for (auto& import : wasm.tags) {
      if (import->imported()) {
        importedTags.push_back(import.get());
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

  Tag* getImportedTag(Name module, Name base) {
    for (auto* import : importedTags) {
      if (import->module == module && import->base == base) {
        return import;
      }
    }
    return nullptr;
  }

  Index getNumImportedGlobals() { return importedGlobals.size(); }

  Index getNumImportedFunctions() { return importedFunctions.size(); }

  Index getNumImportedTables() { return importedTables.size(); }

  Index getNumImportedMemories() { return importedMemories.size(); }

  Index getNumImportedTags() { return importedTags.size(); }

  Index getNumImports() {
    return getNumImportedGlobals() + getNumImportedFunctions() +
           getNumImportedTags() + getNumImportedMemories() +
           getNumImportedTables();
  }

  Index getNumDefinedGlobals() {
    return wasm.globals.size() - getNumImportedGlobals();
  }

  Index getNumDefinedFunctions() {
    return wasm.functions.size() - getNumImportedFunctions();
  }

  Index getNumDefinedTables() {
    return wasm.tables.size() - getNumImportedTables();
  }

  Index getNumDefinedMemories() {
    return wasm.memories.size() - getNumImportedMemories();
  }

  Index getNumDefinedTags() { return wasm.tags.size() - getNumImportedTags(); }
};

} // namespace wasm

#endif // wasm_ir_import_h
