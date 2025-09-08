/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "ir/module-utils.h"
#include "pass.h"
#include "wasm.h"

//
// Ensures each type has a name. This can be useful for debugging.
//

namespace wasm {

// An arbitrary limit, above which we rename types.
static const size_t NameLenLimit = 20;

struct NameTypes : public Pass {
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    // Find all the types.
    std::vector<HeapType> types = ModuleUtils::collectHeapTypes(*module);

    std::unordered_set<Name> used;

    // Ensure simple names. If a name already exists, and is short enough, keep
    // it.
    size_t i = 0;
    for (auto& type : types) {
      if (module->typeNames.count(type) == 0 ||
          module->typeNames[type].name.size() >= NameLenLimit) {
        module->typeNames[type].name = "type_" + std::to_string(i++);
      }
      used.insert(module->typeNames[type].name);
    }

    // "Lint" the names a little. In particular a name with a "_7" or such
    // suffix, as TypeSSA creates, can be removed if it does not cause a
    // collision. This keeps the names unique while removing 'noise.'
    //
    // Note we must iterate in a deterministic order here, so do it on |types|.
    for (auto& type : types) {
      auto& names = module->typeNames[type];
      std::string name = names.name.toString();
      while (name.size() > 1 && isdigit(name.back())) {
        name.pop_back();
      }
      if (name.size() > 1 && name.back() == '_') {
        name.pop_back();
        if (!used.count(name)) {
          names.name = name;
          used.insert(name);
        }
      }
    }
  }
};

Pass* createNameTypesPass() { return new NameTypes(); }

} // namespace wasm
