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
#include <ast_utils.h>

namespace wasm {

struct Vacuum : public WalkerPass<PostWalker<Vacuum, Visitor<Vacuum>>> {
  bool isFunctionParallel() { return true; }

  void visitBlock(Block *curr) {
    // compress out nops
    int skip = 0;
    auto& list = curr->list;
    size_t size = list.size();
    bool needResize = false;
    for (size_t z = 0; z < size; z++) {
      if (list[z]->is<Nop>()) {
        skip++;
        needResize = true;
      } else {
        if (skip > 0) {
          list[z - skip] = list[z];
        }
        // if this is an unconditional br, the rest is dead code
        Break* br = list[z - skip]->dynCast<Break>();
        Switch* sw = list[z - skip]->dynCast<Switch>();
        if ((br && !br->condition) || sw) {
          list.resize(z - skip + 1);
          needResize = false;
          break;
        }
      }
    }
    if (needResize) {
      list.resize(size - skip);
    }
    if (!curr->name.is()) {
      if (list.size() == 1) {
        replaceCurrent(list[0]);
      } else if (list.size() == 0) {
        ExpressionManipulator::nop(curr);
      }
    }
  }
};

static RegisterPass<Vacuum> registerPass("vacuum", "removes obviously unneeded code");

} // namespace wasm

