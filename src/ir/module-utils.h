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

#ifndef wasm_ir_module_h
#define wasm_ir_module_h

#include "wasm.h"

namespace wasm {

namespace ModuleUtils {

// Computes the indexes in a wasm binary, i.e., with function imports
// and function implementations sharing a single index space, etc.
struct BinaryIndexes {
  std::unordered_map<Name, Index> functionIndexes;
  std::unordered_map<Name, Index> globalIndexes;

  BinaryIndexes(Module& wasm) {
    for (Index i = 0; i < wasm.imports.size(); i++) {
      auto& import = wasm.imports[i];
      if (import->kind == ExternalKind::Function) {
        auto index = functionIndexes.size();
        functionIndexes[import->name] = index;
      } else if (import->kind == ExternalKind::Global) {
        auto index = globalIndexes.size();
        globalIndexes[import->name] = index;
      }
    }
    for (Index i = 0; i < wasm.functions.size(); i++) {
      auto index = functionIndexes.size();
      functionIndexes[wasm.functions[i]->name] = index;
    }
    for (Index i = 0; i < wasm.globals.size(); i++) {
      auto index = globalIndexes.size();
      globalIndexes[wasm.globals[i]->name] = index;
    }
  }
};

} // namespace ModuleUtils

} // namespace wasm

#endif // wasm_ir_module_h

