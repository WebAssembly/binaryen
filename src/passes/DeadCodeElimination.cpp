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

namespace wasm {

struct DeadCodeElimination : public WalkerPass<PostWalker<DeadCodeElimination, Visitor<DeadCodeElimination>>> {
  bool isFunctionParallel() { return true; }

  // whether the current code is actually reachable
  bool reachable = true;

  std::set<Name> reachableBreaks;

  void addBreak(Name name) {
    assert(reachable);
    reachableBreaks.insert(name);
  }

  bool isDead(Expression* curr) {
    return curr && curr->is<Unreachable>();
  }

  // things that stop control flow

  void visitBreak(Break* curr) {
    if (isDead(curr->value)) {
      // the condition is evaluated last, so if the value was unreachable, the whole thing is
      replaceCurrent(curr->value);
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
      // control flow ended in the middle of the block
      // note that we still visit the rest, so if we already truncated, do not lengthen.
      // note that it is ok that we visit the others even though the list was shortened;
      // our arena vectors leave things as they are when shrinking.
      if (block->list.size() > i + 1) {
        block->list.resize(i + 1);
      }
    }
  }

  void visitBlock(Block* curr) {
    blockStack.pop_back();
    if (curr->name.is()) {
      reachable = reachable || reachableBreaks.count(curr->name);
      reachableBreaks.erase(curr->name);
    }
    if (curr->list.size() == 1 && isDead(curr->list[0])) {
      replaceCurrent(curr->list[0]);
    }
  }

  void visitLoop(Loop* curr) {
    if (curr->in.is()) {
      reachableBreaks.erase(curr->in);
    }
    if (curr->out.is()) {
      reachable = reachable || reachableBreaks.count(curr->out);
      reachableBreaks.erase(curr->out);
    }
    if (isDead(curr->body)) {
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
    auto* curr = (*currp)->cast<If>();
    assert(curr->ifFalse);
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
        case Expression::Id::LoadId: DELEGATE(Load);
        case Expression::Id::StoreId: DELEGATE(Store);
        case Expression::Id::ConstId: DELEGATE(Const);
        case Expression::Id::UnaryId: DELEGATE(Unary);
        case Expression::Id::BinaryId: DELEGATE(Binary);
        case Expression::Id::SelectId: DELEGATE(Select);
        case Expression::Id::ReturnId: DELEGATE(Return);
        case Expression::Id::HostId: DELEGATE(Host);
        case Expression::Id::NopId: DELEGATE(Nop);
        case Expression::Id::UnreachableId: DELEGATE(Unreachable);
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
      WalkerPass<PostWalker<DeadCodeElimination, Visitor<DeadCodeElimination>>>::scan(self, currp);
    }
  }

  // other things

  template<typename T>
  void handleCall(T* curr, Expression* initial) {
    for (Index i = 0; i < curr->operands.size(); i++) {
      if (isDead(curr->operands[i])) {
        if (i > 0 || initial != nullptr) {
          auto* block = getModule()->allocator.alloc<Block>();
          Index newSize = i + 1 + (initial ? 1 : 0);
          block->list.resize(newSize);
          Index j = 0;
          if (initial) {
            block->list[j] = initial;
            j++;
          }
          for (; j < newSize; j++) {
            block->list[j] = curr->operands[j - (initial ? 1 : 0)];
          }
          block->finalize();
          replaceCurrent(block);
        } else {
          replaceCurrent(curr->operands[i]);
        }
        return;
      }
    }
  }

  void visitCall(Call* curr) {
    handleCall(curr, nullptr);
  }

  void visitCallImport(CallImport* curr) {
    handleCall(curr, nullptr);
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (isDead(curr->target)) {
      replaceCurrent(curr->target);
      return;
    }
    handleCall(curr, curr->target);
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
      block->list[0] = curr->ptr;
      block->list[1] = curr->value;
      block->finalize();
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
      block->list[0] = curr->left;
      block->list[1] = curr->right;
      block->finalize();
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
      block->list[0] = curr->ifTrue;
      block->list[1] = curr->ifFalse;
      block->finalize();
      replaceCurrent(block);
      return;
    }
    if (isDead(curr->condition)) {
      auto* block = getModule()->allocator.alloc<Block>();
      block->list.resize(3);
      block->list[0] = curr->ifTrue;
      block->list[1] = curr->ifFalse;
      block->list[2] = curr->condition;
      block->finalize();
      replaceCurrent(block);
      return;
    }
  }

  void visitHost(Host* curr) {
    // TODO
  }

  void visitFunction(Function* curr) {
    assert(reachableBreaks.size() == 0);
  }
};

static RegisterPass<DeadCodeElimination> registerPass("dce", "removes unreachable code");

} // namespace wasm

