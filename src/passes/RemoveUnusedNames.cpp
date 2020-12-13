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

#include <ir/branch-utils.h>
#include <pass.h>
#include <wasm.h>

namespace wasm {

struct RemoveUnusedNames : public WalkerPass<PostWalker<RemoveUnusedNames>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new RemoveUnusedNames; }

  // We maintain a list of branches that we saw in children, then when we reach
  // a parent block, we know if it was branched to
  std::map<Name, std::set<Expression*>> branchesSeen;

  void visit(Expression* curr) {
    if (auto* block = curr->dynCast<Block>()) {
      visitBlock(block);
      return;
    }
    if (auto* loop = curr->dynCast<Loop>()) {
      visitLoop(loop);
      return;
    }

    // For all break instructions, note their information.

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id)                                                     \
  auto* cast = curr->cast<id>();                                               \
  WASM_UNUSED(cast);

#define DELEGATE_GET_FIELD(id, name) cast->name

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)                                \
  branchesSeen[cast->name].insert(curr);

#define DELEGATE_FIELD_CHILD(id, name)
#define DELEGATE_FIELD_INT(id, name)
#define DELEGATE_FIELD_LITERAL(id, name)
#define DELEGATE_FIELD_NAME(id, name)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)
#define DELEGATE_FIELD_SIGNATURE(id, name)
#define DELEGATE_FIELD_TYPE(id, name)
#define DELEGATE_FIELD_ADDRESS(id, name)
#define DELEGATE_FIELD_CHILD_VECTOR(id, name)
#define DELEGATE_FIELD_INT_ARRAY(id, name)

#include "wasm-delegations-fields.h"
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

  void visitBlock(Block* curr) {
    if (curr->name.is() && curr->list.size() == 1) {
      auto* child = curr->list[0]->dynCast<Block>();
      if (child && child->name.is() && child->type == curr->type) {
        // we have just one child, this block, so breaking out of it goes to the
        // same place as breaking out of us, we just need one name (and block)
        auto& branches = branchesSeen[curr->name];
        for (auto* branch : branches) {
          BranchUtils::replacePossibleTarget(branch, curr->name, child->name);
        }
        child->finalize(child->type);
        replaceCurrent(child);
      }
    }
    handleBreakTarget(curr->name);
  }

  void visitLoop(Loop* curr) {
    handleBreakTarget(curr->name);
    if (!curr->name.is() && curr->body->type == curr->type) {
      replaceCurrent(curr->body);
    }
  }

  void visitFunction(Function* curr) { assert(branchesSeen.empty()); }
};

Pass* createRemoveUnusedNamesPass() { return new RemoveUnusedNames(); }

} // namespace wasm
