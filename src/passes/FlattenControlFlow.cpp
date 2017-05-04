/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Flattens control flow, e.g.
//
//  (i32.add
//    (if (..condition..)
//      (..if true..)
//      (..if false..)
//    )
//    (i32.const 1)
//  )
// =>
//  (if (..condition..)
//    (set_local $temp
//      (..if true..)
//    )
//    (set_local $temp
//      (..if false..)
//    )
//  )
//  (i32.add
//    (get_local $temp)
//    (i32.const 1)
//  )
//
// This leaves control flow to only show up as a block element,
// and not nested inside other code. Blocks themselves are allowed
// only on other blocks, or as the body of a function, loop, or arm
// of an if.
//

#include <wasm.h>
#include <pass.h>
#include <ast_utils.h>
#include <wasm-builder.h>
#include <ast/literal-utils.h>

namespace wasm {

// Looks for control flow changes and structures, excluding blocks (as we
// want to put all control flow on them)
struct ControlFlowFinder : public PostWalker<ControlFlowFinder> {
  static has(Expression *ast) {
    walk(ast);
    return hasControlFlow;
  }

  bool hasControlFlow = false;

  void visitBreak(Break *curr) { hasControlFlow = true; }
  void visitSwitch(Switch *curr) { hasControlFlow = true; }
  void visitLoop(Loop* curr) { hasControlFlow = true; }
  void visitIf(If* curr) { hasControlFlow = true; }
  void visitReturn(Return *curr) { hasControlFlow = true; }
  void visitUnreachable(Unreachable *curr) { hasControlFlow = true; }
};

struct FlattenControlFlow : public WalkerPass<ExpressionStackWalker<FlattenControlFlow>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FlattenControlFlow; }

  std::unique_ptr<Builder> builder;

  void doWalkFunction(Function* func) {
    builder = make_unique<Builder>(*getModule());
    // ensure the top level is a block
    func->body = builder->blockify(func->body);
    walk(func->body);
  }

  bool isOnBlock() {
// XXX used?
    // we are at the top, so look one below. by design, we ensure a toplevel
    // block, and we never call this method on that block, so there must be 2
    assert(expressionStack.size() >= 2);
    return expressionStack[expressionStack.size() - 2]->is<Block>();
  }

  // splits out a child expression, replacing the current expression with
  // (child, curr) and using a temp variable as necessary
  // We need to know the type for the child replacement, as the child may
  // have unreachable type.
  // returns the new expression after replaceCurrent()ing with it
  Expression* maybeSplitOut(Expression* curr, Expression*& child, WasmType childReplacementType) {
    if (!ControlFlowFinder::has(child)) {
      // nothing to do here, no control flow to split out
      return
    }
    // if the child has a concrete type, we need a temp var
    Expression* pre = child;
    if (isConcreteWasmType(child->type)) {
      auto temp = builder->addVar(getFunction(), child->type);
      pre = builder->makeSetLocal(temp, child);
      child = builder->makeGetLocal(temp);
    } else {
      // as a child expression, it is either concrete or unreachable
      assert(child->type == unreachable);
      pre = child;
      child = LiteralUtils::makeZero(childReplacementType); // never used
    }
    return replaceCurrent(builder->makeSequence(pre, curr));
  }

  void visitIf(If* curr) {
    maybeSplitOut(curr, curr->condition, i32);
    curr->ifTrue = builder->blockify(curr->ifTrue);
    if (curr->ifFalse) {
      curr->ifFalse = builder->blockify(curr->ifFalse);
    }
  }
  void visitLoop(Loop* curr) {
    curr->body = builder->blockify(curr->body);
  }
  void visitBreak(Break* curr) {
    Expression* chain = curr;
    if (curr->value) {
      chain = maybeSplitOut(chain, curr->value, XXX);
    }
    if (curr->value) {
      chain = maybeSplitOut(chain, curr->value, XXX);
    }

  }
  void visitSwitch(Switch* curr) {
  }
  void visitCall(Call* curr) {
  }
  void visitCallImport(CallImport* curr) {
  }
  void visitCallIndirect(CallIndirect* curr) {
  }
  void visitGetLocal(GetLocal* curr) {
  }
  void visitSetLocal(SetLocal* curr) {
  }
  void visitGetGlobal(GetGlobal* curr) {
  }
  void visitSetGlobal(SetGlobal* curr) {
  }
  void visitLoad(Load* curr) {
  }
  void visitStore(Store* curr) {
  }
  void visitConst(Const* curr) {
  }
  void visitUnary(Unary* curr) {
  }
  void visitBinary(Binary* curr) {
  }
  void visitSelect(Select* curr) {
  }
  void visitDrop(Drop* curr) {
  }
  void visitReturn(Return* curr) {
  }
  void visitHost(Host* curr) {
  }
  void visitNop(Nop* curr) {
  }
  void visitUnreachable(Unreachable* curr) {
  }


















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

  static void doPreBlock(FlattenControlFlow* self, Expression** currp) {
    self->blockStack.push_back(0);
  }

  static void doAfterBlockElement(FlattenControlFlow* self, Expression** currp) {
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

  static void doAfterIfCondition(FlattenControlFlow* self, Expression** currp) {
    self->ifStack.push_back(self->reachable);
  }

  static void doAfterIfElseTrue(FlattenControlFlow* self, Expression** currp) {
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

  static void scan(FlattenControlFlow* self, Expression** currp) {
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
      self->pushTask(FlattenControlFlow::doVisitIf, currp);
      if (curr->cast<If>()->ifFalse) {
        self->pushTask(FlattenControlFlow::scan, &curr->cast<If>()->ifFalse);
        self->pushTask(FlattenControlFlow::doAfterIfElseTrue, currp);
      }
      self->pushTask(FlattenControlFlow::scan, &curr->cast<If>()->ifTrue);
      self->pushTask(FlattenControlFlow::doAfterIfCondition, currp);
      self->pushTask(FlattenControlFlow::scan, &curr->cast<If>()->condition);
    } else if (curr->is<Block>()) {
      self->pushTask(FlattenControlFlow::doVisitBlock, currp);
      auto& list = curr->cast<Block>()->list;
      for (int i = int(list.size()) - 1; i >= 0; i--) {
        self->pushTask(FlattenControlFlow::doAfterBlockElement, currp);
        self->pushTask(FlattenControlFlow::scan, &list[i]);
      }
      self->pushTask(FlattenControlFlow::doPreBlock, currp);
    } else {
      WalkerPass<PostWalker<FlattenControlFlow>>::scan(self, currp);
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

Pass *createFlattenControlFlowPass() {
  return new FlattenControlFlow();
}

} // namespace wasm

