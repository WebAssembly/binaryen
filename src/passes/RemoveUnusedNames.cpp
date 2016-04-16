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

struct RemoveUnusedNames : public WalkerPass<PostWalker<RemoveUnusedNames, Visitor<RemoveUnusedNames>>> {
  bool isFunctionParallel() { return true; }

  // We maintain a list of branches that we saw in children, then when we reach
  // a parent block, we know if it was branched to
  std::set<Name> branchesSeen;

  void visitBreak(Break *curr) {
    branchesSeen.insert(curr->name);
  }

  void visitBlock(Block *curr) {
    if (curr->name.is() && branchesSeen.count(curr->name) == 0) {
      curr->name = Name();
    }
  }

  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      branchesSeen.insert(name);
    }
    branchesSeen.insert(curr->default_);
  }

  void visitFunction(Function *curr) {
    branchesSeen.clear();
  }
};

static RegisterPass<RemoveUnusedNames> registerPass("remove-unused-names", "removes names from locations that are never branched to");

} // namespace wasm
