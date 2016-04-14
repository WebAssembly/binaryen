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
// Removes obviously unneeded code
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct Vacuum : public WalkerPass<PostWalker<Vacuum>> {
  bool isFunctionParallel() { return true; }

  void visitBlock(Block *curr) {
    // compress out nops
    int skip = 0;
    auto& list = curr->list;
    size_t size = list.size();
    for (size_t z = 0; z < size; z++) {
      if (list[z]->is<Nop>()) {
        skip++;
      } else if (skip > 0) {
        list[z - skip] = list[z];
      }
    }
    if (skip > 0) {
      list.resize(size - skip);
    }
  }
};

static RegisterPass<Vacuum> registerPass("vacuum", "removes obviously unneeded code");

} // namespace wasm

