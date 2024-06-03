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

#include "ir/iteration.h"
#include "ir/module-utils.h"
#include "literal.h"
#include "wasm.h"

namespace wasm::GlobalUtils {

// find a global initialized to the value of an import, or null if no such
// global
inline Global*
getGlobalInitializedToImport(Module& wasm, Name module, Name base) {
  // find the import
  Name imported;
  ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
    if (import->module == module && import->base == base) {
      imported = import->name;
    }
  });
  if (imported.isNull()) {
    return nullptr;
  }
  // find a global inited to it
  Global* ret = nullptr;
  ModuleUtils::iterDefinedGlobals(wasm, [&](Global* defined) {
    if (auto* init = defined->init->dynCast<GlobalGet>()) {
      if (init->name == imported) {
        ret = defined;
      }
    }
  });
  return ret;
}

inline bool canInitializeGlobal(Module& wasm, Expression* curr) {
  if (auto* tuple = curr->dynCast<TupleMake>()) {
    for (auto* op : tuple->operands) {
      if (!Properties::isValidConstantExpression(wasm, op)) {
        return false;
      }
    }
    return true;
  }
  return Properties::isValidConstantExpression(wasm, curr);
}

// We must take into account dependencies, so that globals appear before
// their users in other globals:
//
//   (global $a i32 (i32.const 10))
//   (global $b i32 (global.get $a)) ;; $b depends on $a; $a must be first
//
// To do so we construct a map from each global to those it depends on. We
// also build the reverse map, of those that it is depended upon by.
struct Dependencies {
  std::unordered_map<Index, std::unordered_set<Index>> dependsOn;
  std::unordered_map<Index, std::unordered_set<Index>> dependedUpon;

  Dependencies(Module& wasm);
};

// Counts the uses (global.gets) of globals in the entire module.
struct GseCounter {
  // The amount of uses for each global name.
  std::unordered_map<Name, Index> globalUses;

  UseCounter(Module& wasm);
};

} // namespace wasm::GlobalUtils

#endif // wasm_ir_global_h
