/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Miscellaneous locals-related optimizations
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct SimplifyLocals : public WalkerPass<WasmWalker<SimplifyLocals, void> > {
  void visitBlock(Block *curr) {
    // look for pairs of setlocal-getlocal, which can be just a setlocal (since it returns a value)
    if (curr->list.size() == 0) return;
    for (size_t i = 0; i < curr->list.size() - 1; i++) {
      auto set = curr->list[i]->dyn_cast<SetLocal>();
      if (!set) continue;
      auto get = curr->list[i + 1]->dyn_cast<GetLocal>();
      if (!get) continue;
      if (set->name != get->name) continue;
      curr->list.erase(curr->list.begin() + i + 1);
      i -= 1;
    }
  }
};

static RegisterPass<SimplifyLocals> registerPass("simplify-locals", "miscellaneous locals-related optimizations");

} // namespace wasm
