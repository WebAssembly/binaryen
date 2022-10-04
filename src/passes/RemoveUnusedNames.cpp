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
#include <shared-constants.h>
#include <wasm.h>

namespace wasm {

struct RemoveUnusedNames
  : public WalkerPass<PostWalker<RemoveUnusedNames,
                                 UnifiedExpressionVisitor<RemoveUnusedNames>>> {
  bool isFunctionParallel() override { return true; }

  // This pass only removes names, which can only help validation (as blocks
  // without names are ignored, see the README section on non-nullable locals).
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<RemoveUnusedNames>();
  }

  // We maintain a list of branches that we saw in children, then when we reach
  // a parent block, we know if it was branched to
  std::map<Name, std::set<Expression*>> branchesSeen;

  void visitExpression(Expression* curr) {
    BranchUtils::operateOnScopeNameUses(curr, [&](Name& name) {
      if (name.is()) {
        branchesSeen[name].insert(curr);
      }
    });
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

  void visitTry(Try* curr) {
    handleBreakTarget(curr->name);
    // Try has not just a break target but also an optional delegate with a
    // target name, so call the generic visitor as well to handle that.
    visitExpression(curr);
  }

  void visitFunction(Function* curr) {
    // When we reach the function body we can erase delegations to the caller.
    branchesSeen.erase(DELEGATE_CALLER_TARGET);
    assert(branchesSeen.empty());
  }
};

Pass* createRemoveUnusedNamesPass() { return new RemoveUnusedNames(); }

} // namespace wasm
