/*
 * Copyright 2019 WebAssembly Community Group participants
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

//
// Removes duplicate imports.
//
// TODO: non-function imports too
//

#include "ir/import-utils.h"
#include "opt-utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

struct DuplicateImportElimination : public Pass {
  void run(PassRunner* runner, Module* module) override {
    ImportInfo imports(*module);
    std::map<Name, Name> replacements;
    std::map<std::pair<Name, Name>, Name> seen;
    for (auto* func : imports.importedFunctions) {
      auto pair = std::make_pair(func->module, func->base);
      auto iter = seen.find(pair);
      if (iter != seen.end()) {
        module->removeFunction(func->name);
        replacements[func->name] = iter->second;
      } else {
        seen[pair] = func->name;
      }
    }
    if (!replacements.empty()) {
      module->updateMaps();
      OptUtils::replaceFunctions(runner, *module, replacements);
    }
  }
};

Pass* createDuplicateImportEliminationPass() {
  return new DuplicateImportElimination();
}

} // namespace wasm
