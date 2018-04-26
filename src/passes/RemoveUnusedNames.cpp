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
// Removes names from locations that are never branched to, and
// merge names when possible (by merging their blocks)
//

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct RemoveUnusedNames : public WalkerPass<PostWalker<RemoveUnusedNames>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new RemoveUnusedNames; }

  // We maintain a list of branches that we saw in children, then when we reach
  // a parent block, we know if it was branched to
  std::map<Name, std::set<Expression*>> branchesSeen;

  void visitBreak(Break *curr) {
    branchesSeen[curr->name].insert(curr);
  }

  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      branchesSeen[name].insert(curr);
    }
    branchesSeen[curr->default_].insert(curr);
  }

  void handleBreakTarget(Name& name) {
    if (name.is()) {
      if (branchesSeen.find(name) == branchesSeen.end()) {
        name = Name();
      } else {
        branchesSeen.erase(name);
      }
    }
  }

  void visitBlock(Block *curr) {
    if (curr->name.is() && curr->list.size() == 1) {
      auto* child = curr->list[0]->dynCast<Block>();
      if (child && child->name.is() && child->type == curr->type) {
        // we have just one child, this block, so breaking out of it goes to the same place as breaking out of us, we just need one name (and block)
        auto& branches = branchesSeen[curr->name];
        for (auto* branch : branches) {
          if (Break* br = branch->dynCast<Break>()) {
            if (br->name == curr->name) br->name = child->name;
          } else if (Switch* sw = branch->dynCast<Switch>()) {
            for (auto& target : sw->targets) {
              if (target == curr->name) target = child->name;
            }
            if (sw->default_ == curr->name) sw->default_ = child->name;
          } else {
            WASM_UNREACHABLE();
          }
        }
        child->finalize(child->type);
        replaceCurrent(child);
      }
    }
    handleBreakTarget(curr->name);
  }

  void visitLoop(Loop *curr) {
    handleBreakTarget(curr->name);
    if (!curr->name.is()) {
      replaceCurrent(curr->body);
    }
  }

  void visitFunction(Function *curr) {
    assert(branchesSeen.empty());
  }
};

Pass *createRemoveUnusedNamesPass() {
  return new RemoveUnusedNames();
}

} // namespace wasm
