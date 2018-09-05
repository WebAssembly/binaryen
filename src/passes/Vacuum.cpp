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

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <ir/block-utils.h>
#include <ir/effects.h>
#include <ir/type-updating.h>

namespace wasm {

struct Vacuum : public WalkerPass<PostWalker<Vacuum>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Vacuum; }

  TypeUpdater typeUpdater;

  Expression* replaceCurrent(Expression* expression) {
    auto* old = getCurrent();
    super::replaceCurrent(expression);
    // also update the type updater
    typeUpdater.noteReplacement(old, expression);
    return expression;
  }

  void doWalkFunction(Function* func) {
    typeUpdater.walk(func->body);
    walk(func->body);
  }

  // returns nullptr if curr is dead, curr if it must stay as is, or another node if it can be replaced
  Expression* optimize(Expression* curr, bool resultUsed) {
    // an unreachable node must not be changed
    if (curr->type == unreachable) return curr;
    while (1) {
      switch (curr->_id) {
        case Expression::Id::NopId: return nullptr; // never needed

        case Expression::Id::BlockId: return curr; // not always needed, but handled in visitBlock()
        case Expression::Id::IfId: return curr; // not always needed, but handled in visitIf()
        case Expression::Id::LoopId: return curr; // not always needed, but handled in visitLoop()
        case Expression::Id::DropId: return curr; // not always needed, but handled in visitDrop()

        case Expression::Id::BreakId:
        case Expression::Id::SwitchId:
        case Expression::Id::CallId:
        case Expression::Id::CallIndirectId:
        case Expression::Id::SetLocalId:
        case Expression::Id::StoreId:
        case Expression::Id::ReturnId:
        case Expression::Id::SetGlobalId:
        case Expression::Id::HostId:
        case Expression::Id::UnreachableId: return curr; // always needed

        case Expression::Id::LoadId: {
          // it is ok to remove a load if the result is not used, and it has no
          // side effects (the load itself may trap, if we are not ignoring such things)
          if (!resultUsed && !EffectAnalyzer(getPassOptions(), curr).hasSideEffects()) {
            return curr->cast<Load>()->ptr;
          }
          return curr;
        }
        case Expression::Id::ConstId:
        case Expression::Id::GetLocalId:
        case Expression::Id::GetGlobalId: {
          if (!resultUsed) return nullptr;
          return curr;
        }

        case Expression::Id::UnaryId:
        case Expression::Id::BinaryId:
        case Expression::Id::SelectId: {
          if (resultUsed) {
            return curr; // used, keep it
          }
          // for unary, binary, and select, we need to check their arguments for side effects,
          // as well as the node itself, as some unaries and binaries have implicit traps
          if (auto* unary = curr->dynCast<Unary>()) {
            EffectAnalyzer tester(getPassOptions());
            tester.visitUnary(unary);
            if (tester.hasSideEffects()) {
              return curr;
            }
            if (EffectAnalyzer(getPassOptions(), unary->value).hasSideEffects()) {
              curr = unary->value;
              continue;
            } else {
              return nullptr;
            }
          } else if (auto* binary = curr->dynCast<Binary>()) {
            EffectAnalyzer tester(getPassOptions());
            tester.visitBinary(binary);
            if (tester.hasSideEffects()) {
              return curr;
            }
            if (EffectAnalyzer(getPassOptions(), binary->left).hasSideEffects()) {
              if (EffectAnalyzer(getPassOptions(), binary->right).hasSideEffects()) {
                return curr; // leave them
              } else {
                curr = binary->left;
                continue;
              }
            } else {
              if (EffectAnalyzer(getPassOptions(), binary->right).hasSideEffects()) {
                curr = binary->right;
                continue;
              } else {
                return nullptr;
              }
            }
          } else {
            // TODO: if two have side effects, we could replace the select with say an add?
            auto* select = curr->cast<Select>();
            if (EffectAnalyzer(getPassOptions(), select->ifTrue).hasSideEffects()) {
              if (EffectAnalyzer(getPassOptions(), select->ifFalse).hasSideEffects()) {
                return curr; // leave them
              } else {
                if (EffectAnalyzer(getPassOptions(), select->condition).hasSideEffects()) {
                  return curr; // leave them
                } else {
                  curr = select->ifTrue;
                  continue;
                }
              }
            } else {
              if (EffectAnalyzer(getPassOptions(), select->ifFalse).hasSideEffects()) {
                if (EffectAnalyzer(getPassOptions(), select->condition).hasSideEffects()) {
                  return curr; // leave them
                } else {
                  curr = select->ifFalse;
                  continue;
                }
              } else {
                if (EffectAnalyzer(getPassOptions(), select->condition).hasSideEffects()) {
                  curr = select->condition;
                  continue;
                } else {
                  return nullptr;
                }
              }
            }
          }
        }

        default: return curr; // assume needed
      }
    }
  }

  void visitBlock(Block *curr) {
    // compress out nops and other dead code
    int skip = 0;
    auto& list = curr->list;
    size_t size = list.size();
    for (size_t z = 0; z < size; z++) {
      auto* child = list[z];
      auto* optimized = optimize(child, z == size - 1 && isConcreteType(curr->type));
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
        if (list[z - skip]->type == unreachable && z < size - 1) {
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
    // the block may now be a trivial one that we can get rid of and just leave its contents
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
    if (curr->condition->type == unreachable) {
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
        curr->condition = Builder(*getModule()).makeUnary(EqZInt32, curr->condition);
      } else if (curr->ifTrue->is<Drop>() && curr->ifFalse->is<Drop>()) {
        // instead of dropping both sides, drop the if, if they are the same type
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
      // no else
      if (curr->ifTrue->is<Nop>()) {
        // no nothing
        replaceCurrent(Builder(*getModule()).makeDrop(curr->condition));
      }
    }
  }

  void visitLoop(Loop* curr) {
    if (curr->body->is<Nop>()) ExpressionManipulator::nop(curr);
  }

  void visitDrop(Drop* curr) {
    // optimize the dropped value, maybe leaving nothing
    curr->value = optimize(curr->value, false);
    if (curr->value == nullptr) {
      ExpressionManipulator::nop(curr);
      return;
    }
    // a drop of a tee is a set
    if (auto* set = curr->value->dynCast<SetLocal>()) {
      assert(set->isTee());
      set->setTee(false);
      replaceCurrent(set);
      return;
    }
    // if we are dropping a block's return value, we might be able to remove it entirely
    if (auto* block = curr->value->dynCast<Block>()) {
      auto* last = block->list.back();
      // note that the last element may be concrete but not the block, if the
      // block has an unreachable element in the middle, making the block unreachable
      // despite later elements and in particular the last
      if (isConcreteType(last->type) && block->type == last->type) {
        last = optimize(last, false);
        if (!last) {
          // we may be able to remove this, if there are no brs
          bool canPop = true;
          if (block->name.is()) {
            BranchUtils::BranchSeeker seeker(block->name);
            seeker.named = true;
            Expression* temp = block;
            seeker.walk(temp);
            if (seeker.found && seeker.valueType != none) {
              canPop = false;
            }
          }
          if (canPop) {
            block->list.back() = last;
            block->list.pop_back();
            block->type = none;
            // we don't need the drop anymore, let's see what we have left in the block
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
    // sink a drop into an arm of an if-else if the other arm ends in an unreachable, as it if is a branch, this can make that branch optimizable and more vaccuming possible
    auto* iff = curr->value->dynCast<If>();
    if (iff && iff->ifFalse && isConcreteType(iff->type)) {
      // reuse the drop in both cases
      if (iff->ifTrue->type == unreachable && isConcreteType(iff->ifFalse->type)) {
        curr->value = iff->ifFalse;
        iff->ifFalse = curr;
        iff->type = none;
        replaceCurrent(iff);
      } else if (iff->ifFalse->type == unreachable && isConcreteType(iff->ifTrue->type)) {
        curr->value = iff->ifTrue;
        iff->ifTrue = curr;
        iff->type = none;
        replaceCurrent(iff);
      }
    }
  }

  void visitFunction(Function* curr) {
    auto* optimized = optimize(curr->body, curr->result != none);
    if (optimized) {
      curr->body = optimized;
    } else {
      ExpressionManipulator::nop(curr->body);
    }
    if (curr->result == none && !EffectAnalyzer(getPassOptions(), curr->body).hasSideEffects()) {
      ExpressionManipulator::nop(curr->body);
    }
  }
};

Pass *createVacuumPass() {
  return new Vacuum();
}

} // namespace wasm

