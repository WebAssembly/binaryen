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

#include <ir/block-utils.h>
#include <ir/branch-utils.h>
#include <ir/type-updating.h>
#include <pass.h>
#include <vector>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

struct DeadCodeElimination
  : public WalkerPass<PostWalker<DeadCodeElimination>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DeadCodeElimination; }

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

  // whether the current code is actually reachable
  bool reachable;

  void doWalkFunction(Function* func) {
    reachable = true;
    typeUpdater.walk(func->body);
    walk(func->body);
  }

  std::set<Name> reachableBreaks;

  void addBreak(Name name) {
    // we normally have already reduced unreachable code into (unreachable)
    // nodes, so we would not get to this place at all anyhow, the breaking
    // instruction itself would be removed. However, an exception are things
    // like  (block (result i32) (call $x) (unreachable)) , which has type i32
    // despite not being exited.
    // TODO: optimize such cases
    if (reachable) {
      reachableBreaks.insert(name);
    }
  }

  // if a child exists and is unreachable, we can replace ourselves with it
  bool isDead(Expression* child) { return child && child->type == unreachable; }

  // a similar check, assumes the child exists
  bool isUnreachable(Expression* child) { return child->type == unreachable; }

  // things that stop control flow

  void visitBreak(Break* curr) {
    if (isDead(curr->value)) {
      // the condition is evaluated last, so if the value was unreachable, the
      // whole thing is
      replaceCurrent(curr->value);
      return;
    }
    if (isDead(curr->condition)) {
      if (curr->value) {
        auto* block = getModule()->allocator.alloc<Block>();
        block->list.resize(2);
        block->list[0] = drop(curr->value);
        block->list[1] = curr->condition;
        // if we previously returned a value, then this block
        // must have the same type, so it fits in the ast
        // properly. it ends in an unreachable
        // anyhow, so that is ok.
        block->finalize(curr->type);
        replaceCurrent(block);
      } else {
        replaceCurrent(curr->condition);
      }
      return;
    }
    addBreak(curr->name);
    if (!curr->condition) {
      reachable = false;
    }
  }

  void visitSwitch(Switch* curr) {
    if (isDead(curr->value)) {
      replaceCurrent(curr->value);
      return;
    }
    if (isUnreachable(curr->condition)) {
      if (curr->value) {
        auto* block = getModule()->allocator.alloc<Block>();
        block->list.resize(2);
        block->list[0] = drop(curr->value);
        block->list[1] = curr->condition;
        block->finalize(curr->type);
        replaceCurrent(block);
      } else {
        replaceCurrent(curr->condition);
      }
      return;
    }
    for (auto target : curr->targets) {
      addBreak(target);
    }
    addBreak(curr->default_);
    reachable = false;
  }

  void visitBrOnExn(BrOnExn* curr) {
    if (isDead(curr->exnref)) {
      replaceCurrent(curr->exnref);
      return;
    }
    addBreak(curr->name);
  }

  void visitReturn(Return* curr) {
    if (isDead(curr->value)) {
      replaceCurrent(curr->value);
      return;
    }
    reachable = false;
  }

  void visitUnreachable(Unreachable* curr) { reachable = false; }

  void visitBlock(Block* curr) {
    auto& list = curr->list;
    // if we are currently unreachable (before we take into account
    // breaks to the block) then a child may be unreachable, and we
    // can shorten
    if (!reachable && list.size() > 1) {
      // to do here: nothing to remove after it)
      for (Index i = 0; i < list.size() - 1; i++) {
        if (list[i]->type == unreachable) {
          list.resize(i + 1);
          break;
        }
      }
    }
    if (curr->name.is()) {
      reachable = reachable || reachableBreaks.count(curr->name);
      reachableBreaks.erase(curr->name);
    }
    if (list.size() == 1 && isUnreachable(list[0])) {
      replaceCurrent(
        BlockUtils::simplifyToContentsWithPossibleTypeChange(curr, this));
    } else {
      // the block may have had a type, but can now be unreachable, which allows
      // more reduction outside
      typeUpdater.maybeUpdateTypeToUnreachable(curr);
    }
  }

  void visitLoop(Loop* curr) {
    if (curr->name.is()) {
      reachableBreaks.erase(curr->name);
    }
    if (isUnreachable(curr->body) &&
        !BranchUtils::BranchSeeker::has(curr->body, curr->name)) {
      replaceCurrent(curr->body);
      return;
    }
  }

  // ifs and trys need special handling: only one of (if body and else body /
  // try body and catch body) should be reachable to make the whole of (if /
  // try) to be reachable.

  // stack of reachable state, for forking and joining
  std::vector<bool> ifStack;
  std::vector<bool> tryStack;

  static void doAfterIfCondition(DeadCodeElimination* self,
                                 Expression** currp) {
    self->ifStack.push_back(self->reachable);
  }

  static void doAfterIfElseTrue(DeadCodeElimination* self, Expression** currp) {
    assert((*currp)->cast<If>()->ifFalse);
    bool reachableBefore = self->ifStack.back();
    self->ifStack.pop_back();
    self->ifStack.push_back(self->reachable);
    self->reachable = reachableBefore;
  }

  void visitIf(If* curr) {
    // the ifStack has the branch that joins us, either from before if just an
    // if, or the ifTrue if an if-else
    reachable = reachable || ifStack.back();
    ifStack.pop_back();
    if (isUnreachable(curr->condition)) {
      replaceCurrent(curr->condition);
    }
    // the if may have had a type, but can now be unreachable, which allows more
    // reduction outside
    typeUpdater.maybeUpdateTypeToUnreachable(curr);
  }

  static void doBeforeTryBody(DeadCodeElimination* self, Expression** currp) {
    self->tryStack.push_back(self->reachable);
  }

  static void doAfterTryBody(DeadCodeElimination* self, Expression** currp) {
    bool reachableBefore = self->tryStack.back();
    self->tryStack.pop_back();
    self->tryStack.push_back(self->reachable);
    self->reachable = reachableBefore;
  }

  void visitTry(Try* curr) {
    // the tryStack has the branch that joins us
    reachable = reachable || tryStack.back();
    tryStack.pop_back();
    // the try may have had a type, but can now be unreachable, which allows
    // more reduction outside
    typeUpdater.maybeUpdateTypeToUnreachable(curr);
  }

  static void scan(DeadCodeElimination* self, Expression** currp) {
    auto* curr = *currp;
    if (!self->reachable) {
// convert to an unreachable safely
#define DELEGATE(CLASS_TO_VISIT)                                               \
  {                                                                            \
    auto* parent = self->typeUpdater.parents[curr];                            \
    self->typeUpdater.noteRecursiveRemoval(curr);                              \
    ExpressionManipulator::convert<CLASS_TO_VISIT, Unreachable>(               \
      static_cast<CLASS_TO_VISIT*>(curr));                                     \
    self->typeUpdater.noteAddition(curr, parent);                              \
    break;                                                                     \
  }
      switch (curr->_id) {
        case Expression::Id::BlockId:
          DELEGATE(Block);
        case Expression::Id::IfId:
          DELEGATE(If);
        case Expression::Id::LoopId:
          DELEGATE(Loop);
        case Expression::Id::BreakId:
          DELEGATE(Break);
        case Expression::Id::SwitchId:
          DELEGATE(Switch);
        case Expression::Id::CallId:
          DELEGATE(Call);
        case Expression::Id::CallIndirectId:
          DELEGATE(CallIndirect);
        case Expression::Id::LocalGetId:
          DELEGATE(LocalGet);
        case Expression::Id::LocalSetId:
          DELEGATE(LocalSet);
        case Expression::Id::GlobalGetId:
          DELEGATE(GlobalGet);
        case Expression::Id::GlobalSetId:
          DELEGATE(GlobalSet);
        case Expression::Id::LoadId:
          DELEGATE(Load);
        case Expression::Id::StoreId:
          DELEGATE(Store);
        case Expression::Id::ConstId:
          DELEGATE(Const);
        case Expression::Id::UnaryId:
          DELEGATE(Unary);
        case Expression::Id::BinaryId:
          DELEGATE(Binary);
        case Expression::Id::SelectId:
          DELEGATE(Select);
        case Expression::Id::DropId:
          DELEGATE(Drop);
        case Expression::Id::ReturnId:
          DELEGATE(Return);
        case Expression::Id::HostId:
          DELEGATE(Host);
        case Expression::Id::NopId:
          DELEGATE(Nop);
        case Expression::Id::UnreachableId:
          break;
        case Expression::Id::AtomicCmpxchgId:
          DELEGATE(AtomicCmpxchg);
        case Expression::Id::AtomicRMWId:
          DELEGATE(AtomicRMW);
        case Expression::Id::AtomicWaitId:
          DELEGATE(AtomicWait);
        case Expression::Id::AtomicNotifyId:
          DELEGATE(AtomicNotify);
        case Expression::Id::AtomicFenceId:
          DELEGATE(AtomicFence);
        case Expression::Id::SIMDExtractId:
          DELEGATE(SIMDExtract);
        case Expression::Id::SIMDReplaceId:
          DELEGATE(SIMDReplace);
        case Expression::Id::SIMDShuffleId:
          DELEGATE(SIMDShuffle);
        case Expression::Id::SIMDTernaryId:
          DELEGATE(SIMDTernary);
        case Expression::Id::SIMDShiftId:
          DELEGATE(SIMDShift);
        case Expression::Id::SIMDLoadId:
          DELEGATE(SIMDLoad);
        case Expression::Id::MemoryInitId:
          DELEGATE(MemoryInit);
        case Expression::Id::DataDropId:
          DELEGATE(DataDrop);
        case Expression::Id::MemoryCopyId:
          DELEGATE(MemoryCopy);
        case Expression::Id::MemoryFillId:
          DELEGATE(MemoryFill);
        case Expression::Id::PushId:
          DELEGATE(Push);
        case Expression::Id::PopId:
          DELEGATE(Pop);
        case Expression::Id::TryId:
          DELEGATE(Try);
        case Expression::Id::ThrowId:
          DELEGATE(Throw);
        case Expression::Id::RethrowId:
          DELEGATE(Rethrow);
        case Expression::Id::BrOnExnId:
          DELEGATE(BrOnExn);
        case Expression::Id::InvalidId:
          WASM_UNREACHABLE("unimp");
        case Expression::Id::NumExpressionIds:
          WASM_UNREACHABLE("unimp");
      }
#undef DELEGATE
      return;
    }
    if (curr->is<If>()) {
      self->pushTask(DeadCodeElimination::doVisitIf, currp);
      if (curr->cast<If>()->ifFalse) {
        self->pushTask(DeadCodeElimination::scan, &curr->cast<If>()->ifFalse);
        self->pushTask(DeadCodeElimination::doAfterIfElseTrue, currp);
      }
      self->pushTask(DeadCodeElimination::scan, &curr->cast<If>()->ifTrue);
      self->pushTask(DeadCodeElimination::doAfterIfCondition, currp);
      self->pushTask(DeadCodeElimination::scan, &curr->cast<If>()->condition);
    } else if (curr->is<Try>()) {
      self->pushTask(DeadCodeElimination::doVisitTry, currp);
      self->pushTask(DeadCodeElimination::scan, &curr->cast<Try>()->catchBody);
      self->pushTask(DeadCodeElimination::doAfterTryBody, currp);
      self->pushTask(DeadCodeElimination::scan, &curr->cast<Try>()->body);
      self->pushTask(DeadCodeElimination::doBeforeTryBody, currp);
    } else {
      super::scan(self, currp);
    }
  }

  // other things

  // we don't need to drop unreachable nodes
  Expression* drop(Expression* toDrop) {
    if (toDrop->type == unreachable) {
      return toDrop;
    }
    return Builder(*getModule()).makeDrop(toDrop);
  }

  template<typename T> Expression* handleCall(T* curr) {
    for (Index i = 0; i < curr->operands.size(); i++) {
      if (isUnreachable(curr->operands[i])) {
        if (i > 0) {
          auto* block = getModule()->allocator.alloc<Block>();
          Index newSize = i + 1;
          block->list.resize(newSize);
          Index j = 0;
          for (; j < newSize; j++) {
            block->list[j] = drop(curr->operands[j]);
          }
          block->finalize(curr->type);
          return replaceCurrent(block);
        } else {
          return replaceCurrent(curr->operands[i]);
        }
      }
    }
    return curr;
  }

  void visitCall(Call* curr) {
    handleCall(curr);
    if (curr->isReturn) {
      reachable = false;
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (handleCall(curr) != curr) {
      return;
    }
    if (isUnreachable(curr->target)) {
      auto* block = getModule()->allocator.alloc<Block>();
      for (auto* operand : curr->operands) {
        block->list.push_back(drop(operand));
      }
      block->list.push_back(curr->target);
      block->finalize(curr->type);
      replaceCurrent(block);
    }
    if (curr->isReturn) {
      reachable = false;
    }
  }

  // Append the reachable operands of the current node to a block, and replace
  // it with the block
  void blockifyReachableOperands(std::vector<Expression*>&& list, Type type) {
    for (size_t i = 0; i < list.size(); ++i) {
      auto* elem = list[i];
      if (isUnreachable(elem)) {
        auto* replacement = elem;
        if (i > 0) {
          auto* block = getModule()->allocator.alloc<Block>();
          for (size_t j = 0; j < i; ++j) {
            block->list.push_back(drop(list[j]));
          }
          block->list.push_back(list[i]);
          block->finalize(type);
          replacement = block;
        }
        replaceCurrent(replacement);
        return;
      }
    }
  }

  void visitLocalSet(LocalSet* curr) {
    blockifyReachableOperands({curr->value}, curr->type);
  }

  void visitGlobalSet(GlobalSet* curr) {
    blockifyReachableOperands({curr->value}, curr->type);
  }

  void visitLoad(Load* curr) {
    blockifyReachableOperands({curr->ptr}, curr->type);
  }

  void visitStore(Store* curr) {
    blockifyReachableOperands({curr->ptr, curr->value}, curr->type);
  }

  void visitAtomicRMW(AtomicRMW* curr) {
    blockifyReachableOperands({curr->ptr, curr->value}, curr->type);
  }

  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    blockifyReachableOperands({curr->ptr, curr->expected, curr->replacement},
                              curr->type);
  }

  void visitUnary(Unary* curr) {
    blockifyReachableOperands({curr->value}, curr->type);
  }

  void visitBinary(Binary* curr) {
    blockifyReachableOperands({curr->left, curr->right}, curr->type);
  }

  void visitSelect(Select* curr) {
    blockifyReachableOperands({curr->ifTrue, curr->ifFalse, curr->condition},
                              curr->type);
  }

  void visitDrop(Drop* curr) {
    blockifyReachableOperands({curr->value}, curr->type);
  }

  void visitHost(Host* curr) { handleCall(curr); }

  void visitFunction(Function* curr) { assert(reachableBreaks.size() == 0); }
};

Pass* createDeadCodeEliminationPass() { return new DeadCodeElimination(); }

} // namespace wasm
