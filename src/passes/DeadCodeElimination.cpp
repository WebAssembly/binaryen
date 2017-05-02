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

#include <wasm.h>
#include <pass.h>
#include <ast_utils.h>
#include <wasm-builder.h>

namespace wasm {

struct DeadCodeElimination : public WalkerPass<PostWalker<DeadCodeElimination>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DeadCodeElimination; }

  // whether the current code is actually reachable
  bool reachable;

  void doWalkFunction(Function* func) {
    reachable = true;
    walk(func->body);
  }

  std::set<Name> reachableBreaks;

  void addBreak(Name name) {
    // we normally have already reduced unreachable code into (unreachable)
    // nodes, so we would not get to this function at all anyhow, the breaking
    // instruction itself would be removed. However, an exception are things
    // like  (block i32 (call $x) (unreachable)) , which has type i32
    // despite not being exited.
    // TODO: optimize such cases
    if (reachable) {
      reachableBreaks.insert(name);
    }
  }

  // if a child is unreachable, we can replace ourselves with it
  bool isDead(Expression* child) {
    return child && child->type == unreachable;
  }

  // things that stop control flow

  void visitBreak(Break* curr) {
    if (isDead(curr->value)) {
      // the condition is evaluated last, so if the value was unreachable, the whole thing is
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
    if (isDead(curr->condition)) {
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

  void visitReturn(Return* curr) {
    if (isDead(curr->value)) {
      replaceCurrent(curr->value);
      return;
    }
    reachable = false;
  }

  void visitUnreachable(Unreachable* curr) {
    reachable = false;
  }

  // we maintain a stack for blocks, as we visit each item, and the parameter is the index

  std::vector<Index> blockStack; // index in current block

  static void doPreBlock(DeadCodeElimination* self, Expression** currp) {
    self->blockStack.push_back(0);
  }

  static void doAfterBlockElement(DeadCodeElimination* self, Expression** currp) {
    auto* block = (*currp)->cast<Block>();
    Index i = self->blockStack.back();
    self->blockStack.back()++;
    if (!self->reachable) {
      // control flow ended in the middle of the block, so we can truncate the rest.
      // note that we still visit the rest, so if we already truncated, do not lengthen.
      // note that it is ok that we visit the others even though the list was shortened;
      // our arena vectors leave things as they are when shrinking.
      if (block->list.size() > i + 1) {
        // but note that it is not legal to truncate a block if it leaves a bad last element,
        // given the wasm type rules. For example, if the last element is a return, then
        // the block doesn't care about it for type checking purposes, but if removing
        // it would leave an element with type none as the last, that could be a problem,
        // see https://github.com/WebAssembly/spec/issues/355
        if (!(isConcreteWasmType(block->type) && block->list[i]->type == none)) {
          block->list.resize(i + 1);
          // note that we do *not* finalize here. it is incorrect to re-finalize a block
          // after removing elements, as it may no longer have branches to it that would
          // determine its type, so re-finalizing would just wipe out an existing type
          // that it had.
        }
      }
    }
  }

  void visitBlock(Block* curr) {
    blockStack.pop_back();
    if (curr->name.is()) {
      reachable = reachable || reachableBreaks.count(curr->name);
      reachableBreaks.erase(curr->name);
    }
    if (curr->list.size() == 1 && isDead(curr->list[0]) && !BreakSeeker::has(curr->list[0], curr->name)) {
      replaceCurrent(curr->list[0]);
    }
  }

  void visitLoop(Loop* curr) {
    if (curr->name.is()) {
      reachableBreaks.erase(curr->name);
    }
    if (isDead(curr->body) && !BreakSeeker::has(curr->body, curr->name)) {
      replaceCurrent(curr->body);
      return;
    }
  }

  // ifs need special handling

  std::vector<bool> ifStack; // stack of reachable state, for forking and joining

  static void doAfterIfCondition(DeadCodeElimination* self, Expression** currp) {
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
    // the ifStack has the branch that joins us, either from before if just an if, or the ifTrue if an if-else
    reachable = reachable || ifStack.back();
    ifStack.pop_back();
    if (isDead(curr->condition)) {
      replaceCurrent(curr->condition);
    }
  }

  static void scan(DeadCodeElimination* self, Expression** currp) {
    if (!self->reachable) {
      // convert to an unreachable. do this without UB, even though we have no destructors on AST nodes
      #define DELEGATE(CLASS_TO_VISIT) \
        { ExpressionManipulator::convert<CLASS_TO_VISIT, Unreachable>(static_cast<CLASS_TO_VISIT*>(*currp)); break; }
      switch ((*currp)->_id) {
        case Expression::Id::BlockId: DELEGATE(Block);
        case Expression::Id::IfId: DELEGATE(If);
        case Expression::Id::LoopId: DELEGATE(Loop);
        case Expression::Id::BreakId: DELEGATE(Break);
        case Expression::Id::SwitchId: DELEGATE(Switch);
        case Expression::Id::CallId: DELEGATE(Call);
        case Expression::Id::CallImportId: DELEGATE(CallImport);
        case Expression::Id::CallIndirectId: DELEGATE(CallIndirect);
        case Expression::Id::GetLocalId: DELEGATE(GetLocal);
        case Expression::Id::SetLocalId: DELEGATE(SetLocal);
        case Expression::Id::GetGlobalId: DELEGATE(GetGlobal);
        case Expression::Id::SetGlobalId: DELEGATE(SetGlobal);
        case Expression::Id::LoadId: DELEGATE(Load);
        case Expression::Id::StoreId: DELEGATE(Store);
        case Expression::Id::ConstId: DELEGATE(Const);
        case Expression::Id::UnaryId: DELEGATE(Unary);
        case Expression::Id::BinaryId: DELEGATE(Binary);
        case Expression::Id::SelectId: DELEGATE(Select);
        case Expression::Id::DropId: DELEGATE(Drop);
        case Expression::Id::ReturnId: DELEGATE(Return);
        case Expression::Id::HostId: DELEGATE(Host);
        case Expression::Id::NopId: DELEGATE(Nop);
        case Expression::Id::UnreachableId: break;
        case Expression::Id::InvalidId:
        default: WASM_UNREACHABLE();
      }
      #undef DELEGATE
      return;
    }
    auto* curr =* currp;
    if (curr->is<If>()) {
      self->pushTask(DeadCodeElimination::doVisitIf, currp);
      if (curr->cast<If>()->ifFalse) {
        self->pushTask(DeadCodeElimination::scan, &curr->cast<If>()->ifFalse);
        self->pushTask(DeadCodeElimination::doAfterIfElseTrue, currp);
      }
      self->pushTask(DeadCodeElimination::scan, &curr->cast<If>()->ifTrue);
      self->pushTask(DeadCodeElimination::doAfterIfCondition, currp);
      self->pushTask(DeadCodeElimination::scan, &curr->cast<If>()->condition);
    } else if (curr->is<Block>()) {
      self->pushTask(DeadCodeElimination::doVisitBlock, currp);
      auto& list = curr->cast<Block>()->list;
      for (int i = int(list.size()) - 1; i >= 0; i--) {
        self->pushTask(DeadCodeElimination::doAfterBlockElement, currp);
        self->pushTask(DeadCodeElimination::scan, &list[i]);
      }
      self->pushTask(DeadCodeElimination::doPreBlock, currp);
    } else {
      WalkerPass<PostWalker<DeadCodeElimination>>::scan(self, currp);
    }
  }

  // other things

  // we don't need to drop unreachable nodes
  Expression* drop(Expression* toDrop) {
    if (toDrop->type == unreachable) return toDrop;
    return Builder(*getModule()).makeDrop(toDrop);
  }

  template<typename T>
  Expression* handleCall(T* curr) {
    for (Index i = 0; i < curr->operands.size(); i++) {
      if (isDead(curr->operands[i])) {
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
  }

  void visitCallImport(CallImport* curr) {
    handleCall(curr);
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (handleCall(curr) != curr) return;
    if (isDead(curr->target)) {
      auto* block = getModule()->allocator.alloc<Block>();
      for (auto* operand : curr->operands) {
        block->list.push_back(drop(operand));
      }
      block->list.push_back(curr->target);
      block->finalize(curr->type);
      replaceCurrent(block);
    }
  }

  void visitSetLocal(SetLocal* curr) {
    if (isDead(curr->value)) {
      replaceCurrent(curr->value);
    }
  }

  void visitLoad(Load* curr) {
    if (isDead(curr->ptr)) {
      replaceCurrent(curr->ptr);
    }
  }

  void visitStore(Store* curr) {
    if (isDead(curr->ptr)) {
      replaceCurrent(curr->ptr);
      return;
    }
    if (isDead(curr->value)) {
      auto* block = getModule()->allocator.alloc<Block>();
      block->list.resize(2);
      block->list[0] = drop(curr->ptr);
      block->list[1] = curr->value;
      block->finalize(curr->type);
      replaceCurrent(block);
    }
  }

  void visitUnary(Unary* curr) {
    if (isDead(curr->value)) {
      replaceCurrent(curr->value);
    }
  }

  void visitBinary(Binary* curr) {
    if (isDead(curr->left)) {
      replaceCurrent(curr->left);
      return;
    }
    if (isDead(curr->right)) {
      auto* block = getModule()->allocator.alloc<Block>();
      block->list.resize(2);
      block->list[0] = drop(curr->left);
      block->list[1] = curr->right;
      block->finalize(curr->type);
      replaceCurrent(block);
    }
  }

  void visitSelect(Select* curr) {
    if (isDead(curr->ifTrue)) {
      replaceCurrent(curr->ifTrue);
      return;
    }
    if (isDead(curr->ifFalse)) {
      auto* block = getModule()->allocator.alloc<Block>();
      block->list.resize(2);
      block->list[0] = drop(curr->ifTrue);
      block->list[1] = curr->ifFalse;
      block->finalize(curr->type);
      replaceCurrent(block);
      return;
    }
    if (isDead(curr->condition)) {
      auto* block = getModule()->allocator.alloc<Block>();
      block->list.resize(3);
      block->list[0] = drop(curr->ifTrue);
      block->list[1] = drop(curr->ifFalse);
      block->list[2] = curr->condition;
      block->finalize(curr->type);
      replaceCurrent(block);
      return;
    }
  }

  void visitHost(Host* curr) {
    handleCall(curr);
  }

  void visitFunction(Function* curr) {
    assert(reachableBreaks.size() == 0);
  }
};

Pass *createDeadCodeEliminationPass() {
  return new DeadCodeElimination();
}

} // namespace wasm

