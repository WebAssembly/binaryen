/*
 * Copyright 2024 WebAssembly Community Group participants
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
// DebugLocationPropagation aim to pass debug location from parents or
// previous siblings to expression which has no debug location. This is
// useful for compilers that use Binaryen API to generate WebAssembly modules.
//

#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"
#include <cassert>
#include <unordered_map>

namespace wasm {

struct DebugLocationPropagation
  : WalkerPass<PostWalker<DebugLocationPropagation>> {

  // The top element of this stack is the previous sibling or parent of the
  // current expression in `doPrevisit`. To maintain this invariant, expressions
  // are only popped once we are done visiting their parents.
  ExpressionStack expressionStack;

  using Super = WalkerPass<PostWalker<DebugLocationPropagation>>;
  bool isFunctionParallel() override { return true; }
  bool modifiesBinaryenIR() override { return false; }
  bool requiresNonNullableLocalFixups() override { return false; }
  void runOnFunction(Module* module, Function* func) override {
    if (!func->debugLocations.empty()) {
      Super::runOnFunction(module, func);
    }
  }

  Expression* getPrevious() {
    if (expressionStack.empty()) {
      return nullptr;
    }
    assert(expressionStack.size() >= 1);
    return expressionStack[expressionStack.size() - 1];
  }

  static void doPreVisit(DebugLocationPropagation* self, Expression** currp) {
    auto* curr = *currp;
    auto& locs = self->getFunction()->debugLocations;
    auto& expressionStack = self->expressionStack;
    if (locs.find(curr) == locs.end()) {
      // No debug location, see if we should inherit one.
      if (auto* previous = self->getPrevious()) {
        if (auto it = locs.find(previous); it != locs.end()) {
          locs[curr] = it->second;
        }
      } else if (self->getFunction()->prologLocation.size()) {
        // Instructions may inherit their locations from the function
        // prolog.
        locs[curr] = *self->getFunction()->prologLocation.begin();
      }
    }
    expressionStack.push_back(curr);
  }

  static void doPostVisit(DebugLocationPropagation* self, Expression** currp) {
    auto& exprStack = self->expressionStack;
    while (exprStack.back() != *currp) {
      // pop all the child expressions and keep current expression in stack.
      exprStack.pop_back();
    }
    // the stack should never be empty
    assert(!exprStack.empty());
  }

  static void scan(DebugLocationPropagation* self, Expression** currp) {
    self->pushTask(DebugLocationPropagation::doPostVisit, currp);

    PostWalker<DebugLocationPropagation>::scan(self, currp);

    self->pushTask(DebugLocationPropagation::doPreVisit, currp);
  }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<DebugLocationPropagation>();
  }
};

Pass* createDebugLocationPropagationPass() {
  return new DebugLocationPropagation();
}

} // namespace wasm
