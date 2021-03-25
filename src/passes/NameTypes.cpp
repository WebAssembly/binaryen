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
// TODO: keep existing useful (short-enough) names, and just replace ones that
//       are bothersome
//

using namespace std;

namespace wasm {

struct NameTypes : public Pass {
  void run(PassRunner* runner, Module* module) override {
    // Find all the types.
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(*module, types, typeIndices);

    // Ensure simple names.
    size_t i = 0;
    for (auto& type : types) {
      module->typeNames[type].name = "type$" + std::to_string(i++);
    }
  }
};

Pass* createNameTypesPass() { return new NameTypes(); }

} // namespace wasm
