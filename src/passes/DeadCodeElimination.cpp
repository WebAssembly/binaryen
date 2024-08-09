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
// Removes dead, i.e. unreachable, code.
//
// We keep a record of when control flow is reachable. When it isn't, we
// kill (turn into unreachable). We then fold away entire unreachable
// expressions.
//
// When dead code causes an operation to not happen, like a store, a call
// or an add, we replace with a block with a list of what does happen.
// That isn't necessarily smaller, but blocks are friendlier to other
// optimizations: blocks can be merged and eliminated, and they clearly
// have no side effects.
//

#include "ir/eh-utils.h"
#include "ir/iteration.h"
#include "ir/properties.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "vector"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct DeadCodeElimination
  : public WalkerPass<
      PostWalker<DeadCodeElimination,
                 UnifiedExpressionVisitor<DeadCodeElimination>>> {
  bool isFunctionParallel() override { return true; }

  // This pass removes dead code, which can only help validation (a dead
  // local.get might have prevented validation).
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<DeadCodeElimination>();
  }

  // as we remove code, we must keep the types of other nodes valid
  TypeUpdater typeUpdater;

  Expression* replaceCurrent(Expression* expression) {
    auto* old = getCurrent();
    if (old == expression) {
      return expression;
    }
    super::replaceCurrent(expression);
    // also update the type updater
    typeUpdater.noteReplacement(old, expression);
    return expression;
  }

  void doWalkFunction(Function* func) {
    typeUpdater.walk(func->body);
    walk(func->body);
  }

  void visitExpression(Expression* curr) {
    if (!Properties::isControlFlowStructure(curr)) {
      // Control flow structures require special handling, but others are
      // simple.
      if (curr->type == Type::unreachable) {
        // This may be dead code. Check if there is an unreachable child.
        bool hasUnreachableChild = false;
        for (auto* child : ChildIterator(curr)) {
          if (child->type == Type::unreachable) {
            hasUnreachableChild = true;
            break;
          }
        }
        if (hasUnreachableChild) {
          // This is indeed unreachable code, made unreachable by that child.
          Builder builder(*getModule());
          std::vector<Expression*> remainingChildren;
          bool afterUnreachable = false;
          bool hasPop = false;
          for (auto* child : ChildIterator(curr)) {
            if (child->is<Pop>()) {
              hasPop = true;
            }
            if (afterUnreachable) {
              typeUpdater.noteRecursiveRemoval(child);
              continue;
            }
            if (child->type == Type::unreachable) {
              remainingChildren.push_back(child);
              afterUnreachable = true;
            } else {
              remainingChildren.push_back(builder.makeDrop(child));
            }
          }
          if (remainingChildren.size() == 1) {
            replaceCurrent(remainingChildren[0]);
          } else {
            replaceCurrent(builder.makeBlock(remainingChildren));
            if (hasPop) {
              // We are moving a pop into a new block we just created, which
              // means we may need to fix things up here.
              needEHFixups = true;
            }
          }
        }
      }
      return;
    }
    // This is a control flow structure.
    if (auto* block = curr->dynCast<Block>()) {
      auto& list = block->list;
      // The index from which to remove, which is one after the first
      // unreachable instruction. Note that 0 is not a valid value, so we can
      // use it as such.
      Index removeFromHere = 0;
      for (Index i = 0; i < list.size(); i++) {
        if (list[i]->type == Type::unreachable) {
          removeFromHere = i + 1;
          break;
        }
      }
      if (removeFromHere != 0) {
        for (Index i = removeFromHere; i < list.size(); i++) {
          typeUpdater.noteRecursiveRemoval(list[i]);
        }
        list.resize(removeFromHere);
        if (list.size() == 1 && list[0]->is<Unreachable>()) {
          replaceCurrent(list[0]);
          return;
        }
      }
      // Finally, if there is no need for a concrete type (which is when there
      // is one marked, but nothing breaks to it, and also the block does not
      // have a concrete value flowing out) then remove it, which may allow
      // more reduction.
      if (block->type.isConcrete() && list.back()->type == Type::unreachable &&
          !typeUpdater.hasBreaks(block)) {
        typeUpdater.changeType(block, Type::unreachable);
      }
    } else if (auto* iff = curr->dynCast<If>()) {
      if (iff->condition->type == Type::unreachable) {
        typeUpdater.noteRecursiveRemoval(iff->ifTrue);
        if (iff->ifFalse) {
          typeUpdater.noteRecursiveRemoval(iff->ifFalse);
        }
        replaceCurrent(iff->condition);
        return;
      }
      // If both arms are unreachable, there is no need for a concrete type,
      // which may allow more reduction.
      if (iff->type != Type::unreachable && iff->ifFalse &&
          iff->ifTrue->type == Type::unreachable &&
          iff->ifFalse->type == Type::unreachable) {
        typeUpdater.changeType(iff, Type::unreachable);
      }
    } else if (auto* loop = curr->dynCast<Loop>()) {
      // The loop body may have unreachable type if it branches back to the
      // loop top, for example. The only case we look for here is where we've
      // already removed the entire body as dead code.
      if (loop->body->is<Unreachable>()) {
        replaceCurrent(loop->body);
      }
    } else if (auto* tryy = curr->dynCast<Try>()) {
      // If both try body and catch body are unreachable, there is no need for a
      // concrete type, which may allow more reduction.
      bool allCatchesUnreachable = true;
      for (auto* catchBody : tryy->catchBodies) {
        allCatchesUnreachable &= catchBody->type == Type::unreachable;
      }
      if (tryy->type != Type::unreachable &&
          tryy->body->type == Type::unreachable && allCatchesUnreachable) {
        typeUpdater.changeType(tryy, Type::unreachable);
      }
    } else if (auto* tryTable = curr->dynCast<TryTable>()) {
      // try_table can finish normally only if its body finishes normally.
      if (tryTable->type != Type::unreachable &&
          tryTable->body->type == Type::unreachable) {
        typeUpdater.changeType(tryTable, Type::unreachable);
      }
    } else {
      WASM_UNREACHABLE("unimplemented DCE control flow structure");
    }
  }

  bool needEHFixups = false;

  void visitFunction(Function* curr) {
    if (needEHFixups) {
      EHUtils::handleBlockNestedPops(curr, *getModule());
    }
  }
};

Pass* createDeadCodeEliminationPass() { return new DeadCodeElimination(); }

} // namespace wasm
