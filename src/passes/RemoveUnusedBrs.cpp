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
// Removes branches that go to where they go anyhow
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct RemoveUnusedBrs : public Pass {
  void visitBlock(Block *curr) override {
    if (curr->name.isNull()) return;
    if (curr->list.size() == 0) return;
    Break* last = curr->list.back()->dyn_cast<Break>();
    if (!last) return;
    if (last->value) return;
    if (last->name == curr->name) {
      curr->list.pop_back();
    }
  }
};

static RegisterPass<RemoveUnusedBrs> registerPass("remove-unused-brs", "removes breaks from locations that are never branched to");

} // namespace wasm
