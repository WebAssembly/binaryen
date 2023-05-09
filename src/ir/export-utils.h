/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_ir_export_h
#define wasm_ir_export_h

#include "wasm.h"

namespace wasm::ExportUtils {

std::vector<Function*> getExportedFunctions(Module& wasm);
std::vector<Global*> getExportedGlobals(Module& wasm);

inline bool isExported(const Module& module, const Function& func) {
  for (auto& exportFunc : module.exports) {
    if (exportFunc->kind == ExternalKind::Function &&
        exportFunc->value == func.name) {
      return true;
    }
  }
  return false;
};

} // namespace wasm::ExportUtils

#endif // wasm_ir_export_h
