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

namespace ImportUtils {
  // find an import by the module.base that is being imported.
  // return the internal name
  inline Import* getImport(Module& wasm, Name module, Name base) {
    for (auto& import : wasm.imports) {
      if (import->module == module && import->base == base) {
        return import.get();
      }
    }
    return nullptr;
  }
};

} // namespace wasm

#endif // wasm_ir_import_h

