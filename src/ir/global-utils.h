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

#ifndef wasm_ir_global_h
#define wasm_ir_global_h

#include <algorithm>
#include <vector>

#include "literal.h"
#include "wasm.h"
#include "ir/module-utils.h"

namespace wasm {

namespace GlobalUtils {
  // find a global initialized to the value of an import, or null if no such global
  inline Global* getGlobalInitializedToImport(Module& wasm, Name module, Name base) {
    // find the import
    Name imported;
    ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
      if (import->module == module && import->base == base) {
        imported = import->name;
      }
    });
    if (imported.isNull()) return nullptr;
    // find a global inited to it
    Global* ret = nullptr;
    ModuleUtils::iterDefinedGlobals(wasm, [&](Global* defined) {
      if (auto* init = defined->init->dynCast<GetGlobal>()) {
        if (init->name == imported) {
          ret = defined;
        }
      }
    });
    return ret;
  }
};

} // namespace wasm

#endif // wasm_ir_global_h

