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
// Sorts locals by access frequency.
//


#include <memory>

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct ReorderLocals : public WalkerPass<WasmWalker<ReorderLocals, void>> {

  std::map<Name, uint32_t> counts;

  void finalize(PassRunner* runner, Module *module) override {

  }

  void visitFunction(Function *curr) {
    sort(curr->locals.begin(), curr->locals.end(), [this](NameType a, NameType b) -> bool {
        return this->counts[a.name] > this->counts[b.name];
    });
    counts.clear();
  }

  void visitGetLocal(GetLocal *curr) {
    counts[curr->name]++;
  }

  void visitSetLocal(SetLocal *curr) {
    counts[curr->name]++;
  }
};

static RegisterPass<ReorderLocals> registerPass("reorder-locals", "sorts locals by access frequency");

} // namespace wasm
