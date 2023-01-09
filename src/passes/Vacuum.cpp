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
// Removes obviously unneeded code
//

#include <ir/block-utils.h>
#include <ir/effects.h>
#include <ir/iteration.h>
#include <ir/literal-utils.h>
#include <ir/type-updating.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

struct Vacuum : public WalkerPass<ExpressionStackWalker<Vacuum>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override { return std::make_unique<Vacuum>(); }

  TypeUpdater typeUpdater;

  // The TypeUpdater class handles efficient updating of unreachability as we
  // go, but we may also refine types, which requires refinalization.
  bool refinalize = false;

  Expression* replaceCurrent(Expression* expression) {
    auto* old = getCurrent();
    if (expression->type != old->type &&
        expression->type != Type::unreachable) {
      // We are changing this to a new type that is not unreachable, so it is a
      // refinement that we need to use refinalize to propagate up.
      refinalize = true;
    }
    super::replaceCurrent(expression);
    // also update the type updater
    typeUpdater.noteReplacement(old, expression);
    return expression;
  }

  void doWalkFunction(Function* func) {
    typeUpdater.walk(func->body);
    walk(func->body);
    if (refinalize) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }

  // Returns nullptr if curr is dead, curr if it must stay as is, or one of its
  // children if it can be replaced. Takes into account:
  //
  //  * The result may be used or unused.
  //  * The type may or may not matter.
  //
  // For example,
  //
  //  (drop
  //   (i32.eqz
  //    (call ..)))
  //
  // The drop means that the value is not used later. And while the call has
  // side effects, the i32.eqz does not. So when we are called on the i32.eqz,
  // and told the result does not matter, we can return the call. Note that in
  // this case the type does not matter either, as drop doesn't care, and anyhow
  // i32.eqz returns the same type as it receives. But for an expression that
  // returns a different type, if the type matters then we cannot replace it.
  Expression* optimize(Expression* curr, bool resultUsed, bool typeMatters) {
    auto type = curr->type;
    // If the type is none, then we can never replace it with another type.
    if (type == Type::none) {
      typeMatters = true;
    }
    // An unreachable node must not be changed. DCE will remove those.
    if (type == Type::unreachable) {
      return curr;
    }
    // resultUsed only makes sense when the type is concrete
    assert(!resultUsed || curr->type != Type::none);
    // If we actually need the result, then we must not change anything.
    // TODO: maybe there is something clever though?
    if (resultUsed) {
      return curr;
    }
    // We iterate on possible replacements.
    auto* prev = curr;
    while (1) {
      // If a replacement changes the type, and the type matters, return the
      // previous one and stop.
      if (typeMatters && curr->type != type) {
        return prev;
      }
      prev = curr;
      // Some instructions have special handling in visit*, and we should do
      // nothing for them here.
      if (curr->is<Drop>() || curr->is<Block>() || curr->is<If>() ||
          curr->is<Loop>() || curr->is<Try>()) {
        return curr;
      }
      // Check if this expression itself has side effects, ignoring children.
      EffectAnalyzer self(getPassOptions(), *getModule());
      self.visit(curr);
      if (self.hasUnremovableSideEffects()) {
        return curr;
      }
      // The result isn't used, and this has no side effects itself, so we can
      // get rid of it. However, the children may have side effects.
      SmallVector<Expression*, 1> childrenWithEffects;
      for (auto* child : ChildIterator(curr)) {
        if (EffectAnalyzer(getPassOptions(), *getModule(), child)
              .hasUnremovableSideEffects()) {
          childrenWithEffects.push_back(child);
        }
      }
      if (childrenWithEffects.empty()) {
        return nullptr;
      }
      if (childrenWithEffects.size() == 1) {
        // We know the result isn't used, and curr has no side effects, so we
        // can skip curr and keep looking into the child.
        curr = childrenWithEffects[0];
        continue;
      }
      // TODO: with multiple children with side effects, we can perhaps figure
      // out something clever, like a block with drops, or an i32.add for just
      // two, etc.
      return curr;
    }
  }

  void visitBlock(Block* curr) {
    // compress out nops and other dead code
    int skip = 0;
    auto& list = curr->list;
    size_t size = list.size();
    for (size_t z = 0; z < size; z++) {
      auto* child = list[z];
      // The last element may be used.
      bool used =
        z == size - 1 && curr->type.isConcrete() &&
        ExpressionAnalyzer::isResultUsed(expressionStack, getFunction());
      auto* optimized = optimize(child, used, true);
      if (!optimized) {
        auto childType = child->type;
        if (childType.isConcrete()) {
          if (LiteralUtils::canMakeZero(childType)) {
            // We can't just skip a final concrete element, even if it isn't
            // used. Instead, replace it with something that's easy to optimize
            // out (for example, code-folding can merge out identical zeros at
            // the end of if arms).
            optimized = LiteralUtils::makeZero(childType, *getModule());
          } else {
            // Don't optimize it out.
            optimized = child;
          }
        } else if (childType == Type::unreachable) {
          // Don't try to optimize out an unreachable child (dce can do that
          // properly).
          optimized = child;
        }
      }
      if (!optimized) {
        typeUpdater.noteRecursiveRemoval(child);
        skip++;
      } else {
        if (optimized != child) {
          typeUpdater.noteReplacement(child, optimized);
          list[z] = optimized;
        }
        if (skip > 0) {
          list[z - skip] = list[z];
          list[z] = nullptr;
        }
        // if this is unreachable, the rest is dead code
        if (list[z - skip]->type == Type::unreachable && z < size - 1) {
          for (Index i = z - skip + 1; i < list.size(); i++) {
            auto* remove = list[i];
            if (remove) {
              typeUpdater.noteRecursiveRemoval(remove);
            }
          }
          list.resize(z - skip + 1);
          typeUpdater.maybeUpdateTypeToUnreachable(curr);
          skip = 0; // nothing more to do on the list
          break;
        }
      }
    }
    if (skip > 0) {
      list.resize(size - skip);
      typeUpdater.maybeUpdateTypeToUnreachable(curr);
    }
    // the block may now be a trivial one that we can get rid of and just leave
    // its contents
    replaceCurrent(BlockUtils::simplifyToContents(curr, this));
  }

  void visitIf(If* curr) {
    // if the condition is a constant, just apply it
    // we can just return the ifTrue or ifFalse.
    if (auto* value = curr->condition->dynCast<Const>()) {
      Expression* child;
      if (value->value.getInteger()) {
        child = curr->ifTrue;
        if (curr->ifFalse) {
          typeUpdater.noteRecursiveRemoval(curr->ifFalse);
        }
      } else {
        if (curr->ifFalse) {
          child = curr->ifFalse;
          typeUpdater.noteRecursiveRemoval(curr->ifTrue);
        } else {
          typeUpdater.noteRecursiveRemoval(curr);
          ExpressionManipulator::nop(curr);
          return;
        }
      }
      replaceCurrent(child);
      return;
    }
    // if the condition is unreachable, just return it
    if (curr->condition->type == Type::unreachable) {
      typeUpdater.noteRecursiveRemoval(curr->ifTrue);
      if (curr->ifFalse) {
        typeUpdater.noteRecursiveRemoval(curr->ifFalse);
      }
      replaceCurrent(curr->condition);
      return;
    }
    // from here on, we can assume the condition executed
    if (curr->ifFalse) {
      if (curr->ifFalse->is<Nop>()) {
        curr->ifFalse = nullptr;
      } else if (curr->ifTrue->is<Nop>()) {
        curr->ifTrue = curr->ifFalse;
        curr->ifFalse = nullptr;
        curr->condition =
          Builder(*getModule()).makeUnary(EqZInt32, curr->condition);
      } else if (curr->ifTrue->is<Drop>() && curr->ifFalse->is<Drop>()) {
        // instead of dropping both sides, drop the if, if they are the same
        // type
        auto* left = curr->ifTrue->cast<Drop>()->value;
        auto* right = curr->ifFalse->cast<Drop>()->value;
        if (left->type == right->type) {
          curr->ifTrue = left;
          curr->ifFalse = right;
          curr->finalize();
          replaceCurrent(Builder(*getModule()).makeDrop(curr));
        }
      }
    } else {
      // This is an if without an else. If the body is empty, we do not need it.
      if (curr->ifTrue->is<Nop>()) {
        replaceCurrent(Builder(*getModule()).makeDrop(curr->condition));
      }
    }
  }

  void visitLoop(Loop* curr) {
    if (curr->body->is<Nop>()) {
      ExpressionManipulator::nop(curr);
    }
  }

  void visitDrop(Drop* curr) {
    // optimize the dropped value, maybe leaving nothing
    curr->value = optimize(curr->value, false, false);
    if (curr->value == nullptr) {
      ExpressionManipulator::nop(curr);
      return;
    }
    // a drop of a tee is a set
    if (auto* set = curr->value->dynCast<LocalSet>()) {
      assert(set->isTee());
      set->makeSet();
      replaceCurrent(set);
      return;
    }

    // If the value has no side effects, or it has side effects we can remove,
    // do so. This basically means that if noTrapsHappen is set then we can
    // use that assumption (that no trap actually happens at runtime) and remove
    // a trapping value.
    //
    // TODO: A complete CFG analysis for noTrapsHappen mode, removing all code
    //       that definitely reaches a trap, *even if* it has side effects.
    //
    // Note that we check the type here to avoid removing unreachable code - we
    // leave that for DCE.
    if (curr->type == Type::none &&
        !EffectAnalyzer(getPassOptions(), *getModule(), curr)
           .hasUnremovableSideEffects()) {
      ExpressionManipulator::nop(curr);
      return;
    }

    // if we are dropping a block's return value, we might be able to remove it
    // entirely
    if (auto* block = curr->value->dynCast<Block>()) {
      auto* last = block->list.back();
      // note that the last element may be concrete but not the block, if the
      // block has an unreachable element in the middle, making the block
      // unreachable despite later elements and in particular the last
      if (last->type.isConcrete() && block->type == last->type) {
        last = optimize(last, false, false);
        if (!last) {
          // we may be able to remove this, if there are no brs
          bool canPop = true;
          if (block->name.is()) {
            BranchUtils::BranchSeeker seeker(block->name);
            Expression* temp = block;
            seeker.walk(temp);
            if (seeker.found && Type::hasLeastUpperBound(seeker.types)) {
              canPop = false;
            }
          }
          if (canPop) {
            block->list.back() = last;
            block->list.pop_back();
            block->type = Type::none;
            // we don't need the drop anymore, let's see what we have left in
            // the block
            if (block->list.size() > 1) {
              replaceCurrent(block);
            } else if (block->list.size() == 1) {
              replaceCurrent(block->list[0]);
            } else {
              ExpressionManipulator::nop(curr);
            }
            return;
          }
        }
      }
    }
    // sink a drop into an arm of an if-else if the other arm ends in an
    // unreachable, as it if is a branch, this can make that branch optimizable
    // and more vaccuming possible
    auto* iff = curr->value->dynCast<If>();
    if (iff && iff->ifFalse && iff->type.isConcrete()) {
      // reuse the drop in both cases
      if (iff->ifTrue->type == Type::unreachable &&
          iff->ifFalse->type.isConcrete()) {
        curr->value = iff->ifFalse;
        iff->ifFalse = curr;
        iff->type = Type::none;
        replaceCurrent(iff);
      } else if (iff->ifFalse->type == Type::unreachable &&
                 iff->ifTrue->type.isConcrete()) {
        curr->value = iff->ifTrue;
        iff->ifTrue = curr;
        iff->type = Type::none;
        replaceCurrent(iff);
      }
    }
  }

  void visitTry(Try* curr) {
    // If try's body does not throw, the whole try-catch can be replaced with
    // the try's body.
    if (!EffectAnalyzer(getPassOptions(), *getModule(), curr->body).throws()) {
      replaceCurrent(curr->body);
      for (auto* catchBody : curr->catchBodies) {
        typeUpdater.noteRecursiveRemoval(catchBody);
      }
      return;
    }

    // The try's body does throw. However, throwing may be the only thing it
    // does, and if the try has a catch-all, then the entire try including
    // children may have no effects. Note that this situation can only happen
    // if we do have a catch-all, so avoid wasted work by checking that first.
    // Also, we can't do this if a result is returned, so check the type.
    if (curr->type == Type::none && curr->hasCatchAll() &&
        !EffectAnalyzer(getPassOptions(), *getModule(), curr)
           .hasUnremovableSideEffects()) {
      typeUpdater.noteRecursiveRemoval(curr);
      ExpressionManipulator::nop(curr);
    }
  }

  void visitFunction(Function* curr) {
    auto* optimized =
      optimize(curr->body, curr->getResults() != Type::none, true);
    if (optimized) {
      curr->body = optimized;
    } else {
      ExpressionManipulator::nop(curr->body);
    }
    if (curr->getResults() == Type::none &&
        !EffectAnalyzer(getPassOptions(), *getModule(), curr)
           .hasUnremovableSideEffects()) {
      ExpressionManipulator::nop(curr->body);
    }
  }
};

Pass* createVacuumPass() { return new Vacuum(); }

} // namespace wasm
