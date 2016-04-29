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

#include "wasm.h"
#include "wasm-traversal.h"
#include "ast_utils.h"

namespace wasm {

struct BlockTypeSeeker : public PostWalker<BlockTypeSeeker, Visitor<BlockTypeSeeker>> {
  Block* target; // look for this one
  WasmType type = unreachable;

  BlockTypeSeeker(Block* target) : target(target) {}

  void noteType(WasmType other) {
    // once none, stop. it then indicates a poison value, that must not be consumed
    // and ignore unreachable
    if (type != none) {
      if (other == none) {
        type = none;
      } else if (other != unreachable) {
        type = other;
      }
    }
  }

  void visitBreak(Break *curr) {
    if (curr->name == target->name) {
      noteType(curr->value ? curr->value->type : none);
    }
  }

  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      if (name == target->name) noteType(curr->value ? curr->value->type : none);
    }
  }

  void visitBlock(Block *curr) {
    if (curr == target) {
      if (curr->list.size() > 0) noteType(curr->list.back()->type);
    } else {
      type = unreachable; // ignore all breaks til now, they were captured by someone with the same name
    }
  }
};

void Block::finalize() {
  if (list.size() > 0) {
    auto last = list.back()->type;
    if (last != unreachable) {
      // well that was easy
      type = last;
      return;
    }
  }
  if (!name.is()) {
    // that was rather silly
    type = unreachable;
    return;
  }
  // oh no this is hard
  BlockTypeSeeker seeker(this);
  Expression* temp = this;
  seeker.walk(temp);
  type = seeker.type;
}

} // namespace wasm

