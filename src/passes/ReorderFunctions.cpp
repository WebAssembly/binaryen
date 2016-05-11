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
// Sorts functions by their static use count. This helps reduce the size of wasm
// binaries because fewer bytes are needed to encode references to frequently
// used functions.
//


#include <memory>

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct ReorderFunctions : public WalkerPass<PostWalker<ReorderFunctions, Visitor<ReorderFunctions>>> {
  std::map<Name, uint32_t> counts;

  void visitModule(Module *module) {
    if (module->start.is()) {
      counts[module->start]++;
    }
    for (auto& curr : module->exports) {
      counts[curr->value]++;
    }
    for (auto& curr : module->table.names) {
      counts[curr]++;
    }
    std::sort(module->functions.begin(), module->functions.end(), [this](
      const std::unique_ptr<Function>& a,
      const std::unique_ptr<Function>& b) -> bool {
      if (this->counts[a->name] == this->counts[b->name]) {
        return strcmp(a->name.str, b->name.str) > 0;
      }
      return this->counts[a->name] > this->counts[b->name];
    });
    counts.clear();
  }

  void visitCall(Call *curr) {
    counts[curr->target]++;
  }
};

static RegisterPass<ReorderFunctions> registerPass("reorder-functions", "sorts functions by access frequency");

} // namespace wasm
