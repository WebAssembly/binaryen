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
// Removes names from locations that are never branched to.
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct RemoveUnusedNames : public Pass {
  std::set<Name> used;

  void prepare(PassRunner* runner, Module *module) override {
    struct Scanner : public WasmWalker {
      std::set<Name>& used;
      Scanner(std::set<Name>& used) : used(used) {}
      void visitBreak(Break *curr) override {
        used.insert(curr->name);
      }
    };
    Scanner scanner(used);
    scanner.startWalk(module);
  }

  void visitBlock(Block *curr) override {
    if (curr->name.is() && used.count(curr->name) == 0) {
      curr->name = Name();
    }
  }
};

static RegisterPass<RemoveUnusedNames> registerPass("remove-unused-names", "removes names from locations that are never branched to");

} // namespace wasm
