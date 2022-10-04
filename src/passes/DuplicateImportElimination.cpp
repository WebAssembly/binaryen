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
  // This pass does not alter function contents.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    ImportInfo imports(*module);
    std::map<Name, Name> replacements;
    std::map<std::pair<Name, Name>, Name> seen;
    std::vector<Name> toRemove;
    for (auto* func : imports.importedFunctions) {
      auto pair = std::pair{func->module, func->base};
      auto iter = seen.find(pair);
      if (iter != seen.end()) {
        auto previousName = iter->second;
        auto previousFunc = module->getFunction(previousName);
        // It is ok to import the same thing with multiple types; we can only
        // merge if the types match, of course.
        if (previousFunc->type == func->type) {
          replacements[func->name] = previousName;
          toRemove.push_back(func->name);
          continue;
        }
      }
      seen[pair] = func->name;
    }
    if (!replacements.empty()) {
      module->updateMaps();
      OptUtils::replaceFunctions(getPassRunner(), *module, replacements);
      for (auto name : toRemove) {
        module->removeFunction(name);
      }
    }
  }
};

Pass* createDuplicateImportEliminationPass() {
  return new DuplicateImportElimination();
}

} // namespace wasm
