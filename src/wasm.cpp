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
  std::vector<WasmType> types;

  BlockTypeSeeker(Block* target) : target(target) {}

  void visitBreak(Break *curr) {
    if (curr->name == target->name) {
      types.push_back(curr->value ? curr->value->type : none);
    }
  }

  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      if (name == target->name) types.push_back(curr->value ? curr->value->type : none);
    }
  }

  void visitBlock(Block *curr) {
    if (curr == target) {
      if (curr->list.size() > 0) {
        types.push_back(curr->list.back()->type);
      } else {
        types.push_back(none);
      }
    } else if (curr->name == target->name) {
      types.clear(); // ignore all breaks til now, they were captured by someone with the same name
    }
  }
};

void Block::finalize() {
  if (!name.is()) {
    // nothing branches here, so this is easy
    if (list.size() > 0) {
      type = list.back()->type;
    } else {
      type = unreachable;
    }
    return;
  }

  BlockTypeSeeker seeker(this);
  Expression* temp = this;
  seeker.walk(temp);
  type = unreachable;
  for (auto other : seeker.types) {
    // once none, stop. it then indicates a poison value, that must not be consumed
    // and ignore unreachable
    if (type != none) {
      if (other == none) {
        type = none;
      } else if (other != unreachable) {
        if (type == unreachable) {
          type = other;
        } else if (type != other) {
          type = none; // poison value, we saw multiple types; this should not be consumed
        }
      }
    }
  }
}

} // namespace wasm

