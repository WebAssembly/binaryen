/*
 * Copyright 2019 WebAssembly Community Group participants
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

#include "ir/stackification.h"
#include "pass.h"
#include "wasm-builder.h"
#include <memory>

namespace wasm {

class Stackify
  : public WalkerPass<
      ExpressionStackWalker<Stackify, UnifiedExpressionVisitor<Stackify>>> {
  std::vector<Expression*> pushed;
  std::vector<size_t> pushBoundaryDepths = {0};

  // Materialize all pushes at the current nesting level into a block
  Block* blockifyPushed() {
    assert(pushBoundaryDepths.size());
    assert(pushed.size() >= pushBoundaryDepths.back());
    size_t depth = pushBoundaryDepths.back();
    if (pushed.size() == pushBoundaryDepths.back()) {
      return nullptr;
    }
    Builder builder(*getModule());
    Block* block = builder.makeBlock();
    for (size_t i = depth, size = pushed.size(); i < size; ++i) {
      block = builder.blockify(block, builder.makePush(pushed[i]));
    }
    pushed.resize(depth);
    return block;
  }

  // Introduce a new nesting level, preventing pending pushes from being
  // materialized until we have returned to the previous nesting level
  void pushPushBoundary() {
    assert(pushBoundaryDepths.size());
    pushBoundaryDepths.push_back(pushed.size());
  }

  // Materialize all pushes at the current nesting level and pop up a level
  void materializePushes(Expression* curr) {
    assert(pushBoundaryDepths.size());
    if (Block* pushes = blockifyPushed()) {
      replaceCurrent(Builder(*getModule()).blockify(pushes, curr));
    }
    pushBoundaryDepths.pop_back();
  }

  static bool shouldMaterializePushes(Expression* curr, Expression* parent) {
    if (!parent) {
      return true;
    }
    if (parent->is<Block>() || parent->is<Loop>() || parent->is<Push>()) {
      return true;
    }
    if (If* if_ = parent->dynCast<If>()) {
      return curr != if_->condition;
    }
    return false;
  }

public:
  static void doPreVisit(Stackify* self, Expression** currp) {
    super::doPreVisit(self, currp);
    if (shouldMaterializePushes(*currp, self->getParent())) {
      self->pushPushBoundary();
    }
  }

  static void doPostVisit(Stackify* self, Expression** currp) {
    if (shouldMaterializePushes(*currp, self->getParent())) {
      self->materializePushes(*currp);
    }
    super::doPostVisit(self, currp);
  }

  void visitExpression(Expression* curr) {
    // Don't push pops
    if (curr->is<Pop>()) {
      return;
    }

    if (!shouldMaterializePushes(curr, getParent())) {
      // Replace self with a Pop, materialize self later
      assert(curr->type != none);
      pushed.push_back(curr);
      replaceCurrent(Builder(*getModule()).makePop(curr->type));
    }
  }
};

namespace Stackification {

Expression* stackify(Module& module, Expression*& curr) {
  Stackify stackifier;
  stackifier.setModule(&module);
  stackifier.walk(curr);
  return curr;
}

} // namespace Stackification

Pass* createStackifyPass() { return new Stackify(); }

} // namespace wasm
