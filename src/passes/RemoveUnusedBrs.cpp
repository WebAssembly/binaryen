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

struct RemoveUnusedBrs : public WalkerPass<PostWalker<RemoveUnusedBrs>> {
  bool isFunctionParallel() { return true; }

  // preparation: try to unify branches, as the fewer there are, the higher a chance we can remove them
  // specifically for if-else, turn an if-else with branches to the same target at the end of each
  // child, and with a value, to a branch to that target containing the if-else
  void visitIf(If* curr) {
    if (!curr->ifFalse) {
      // try to reduce an   if (condition) br  =>  br_if (condition) , which might open up other optimization opportunities
      Break* br = curr->ifTrue->dynCast<Break>();
      if (br && !br->condition) { // TODO: if there is a condition, join them
        br->condition = curr->condition;
        replaceCurrent(br);
      }
      return;
    }
    if (isConcreteWasmType(curr->type)) return; // already has a returned value
    // an if_else that indirectly returns a value by breaking to the same target can potentially remove both breaks, and break outside once
    auto getLast = [](Expression *side) -> Expression* {
      Block* b = side->dynCast<Block>();
      if (!b) return nullptr;
      if (b->list.size() == 0) return nullptr;
      return b->list.back();
    };
    auto process = [&](Expression *side, bool doIt) {
      Expression* last = getLast(side);
      if (!last) return Name();
      Block* b = side->cast<Block>();
      Break* br = last->dynCast<Break>();
      if (!br) return Name();
      if (br->condition) return Name();
      if (!br->value) return Name();
      if (doIt) {
        b->list[b->list.size()-1] = br->value;
      }
      return br->name;
    };
    // do both, or none
    if (process(curr->ifTrue, false).is() && process(curr->ifTrue, false) == process(curr->ifFalse, false)) {
      auto br = getLast(curr->ifTrue)->cast<Break>(); // we are about to discard this, so why not reuse it!
      process(curr->ifTrue, true);
      process(curr->ifFalse, true);
      curr->type = br->value->type; // if_else now returns a value
      br->value = curr;
      // no need to change anything else in the br - target is correct already
      replaceCurrent(br);
    }
  }

  // main portion
  void visitBlock(Block *curr) {
    if (curr->name.isNull()) return;
    if (curr->list.size() == 0) return;
    // preparation - remove all code after an unconditional break, since it can't execute, and it might confuse us (we look at the last)
    for (size_t i = 0; i < curr->list.size()-1; i++) {
      Break* br = curr->list[i]->dynCast<Break>();
      if (br && !br->condition) {
        curr->list.resize(i+1);
        break;
      }
    }
    Expression* last = curr->list.back();
    if (Break* br = last->dynCast<Break>()) {
      if (br->condition) return;
      if (br->name == curr->name) {
        if (!br->value) {
          curr->list.pop_back();
        } else {
          curr->list[curr->list.size()-1] = br->value; // can replace with the value
        }
      }
    }
  }
};

static RegisterPass<RemoveUnusedBrs> registerPass("remove-unused-brs", "removes breaks from locations that are never branched to");

} // namespace wasm
