/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Removes functions that are never used.
//


#include <memory>

#include <wasm.h>
#include <pass.h>
#include <ast_utils.h>

namespace wasm {

struct RemoveUnusedFunctions : public Pass {
  void run(PassRunner* runner, Module* module) override {
    std::vector<Function*> root;
    // Module start is a root.
    if (module->start.is()) {
      root.push_back(module->getFunction(module->start));
    }
    // Exports are roots.
    for (auto& curr : module->exports) {
      root.push_back(module->getFunction(curr->value));
    }
    // For now, all functions that can be called indirectly are marked as roots.
    for (auto& curr : module->table.names) {
      root.push_back(module->getFunction(curr));
    }
    // Compute function reachability starting from the root set.
    DirectCallGraphAnalyzer analyzer(module, root);
    // Remove unreachable functions.
    std::vector<std::unique_ptr<Function>>::iterator it = module->functions.begin();
    while (it != module->functions.end()) {
      if (analyzer.reachable.count(it->get()) == 0) {
        it = module->functions.erase(it);
      } else {
        it++;
      }
    }
    assert(module->functions.size() == analyzer.reachable.size());
  }
};

static RegisterPass<RemoveUnusedFunctions> registerPass("remove-unused-functions", "removes unused functions");

} // namespace wasm
