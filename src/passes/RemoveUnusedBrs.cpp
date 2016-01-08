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
    Expression* last = curr->list.back();
    if (Break* br = last->dyn_cast<Break>()) {
      if (br->condition) return;
      if (br->name == curr->name) {
        if (!br->value) {
          curr->list.pop_back();
        } else {
          curr->list[curr->list.size()-1] = br->value; // can replace with the value
        }
      }
    } else if (If* ifelse = curr->list.back()->dyn_cast<If>()) {
      if (!ifelse->ifFalse) return;
      if (ifelse->type != none) return;
      // an if_else that indirectly returns a value by breaking to this block can potentially remove both breaks
      auto process = [&curr](Expression *side, bool doIt) {
        Block* b = side->dyn_cast<Block>();
        if (!b) return false;
        Expression* last = b->list.back();
        Break* br = last->dyn_cast<Break>();
        if (!br) return false;
        if (br->condition) return false;
        if (!br->value) return false;
        if (br->name != curr->name) return false;
        if (doIt) {
          b->list[b->list.size()-1] = br->value;
        }
        return true;
      };
      // do both, or none
      if (process(ifelse->ifTrue, false) && process(ifelse->ifFalse, false)) {
        process(ifelse->ifTrue, true);
        process(ifelse->ifFalse, true);
        ifelse->type = curr->type; // if_else now returns a value
      }
    }
  }
};

static RegisterPass<RemoveUnusedBrs> registerPass("remove-unused-brs", "removes breaks from locations that are never branched to");

} // namespace wasm
