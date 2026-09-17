/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Convert calls in tail position to return calls (tail calls).
//

#include <unordered_set>

#include "ir/effects.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

// We are doing a pre-order traversal (i.e. parents before children) rather
// than the normal post-order traversal because whether an expression is in
// tail position is propagated down from parents to children. Define our own
// pre-order traversal task stack, and take the opportunity to pass `isTail`
// as an extra parameter to each task rather than storing it in a side table.
template<typename SubType>
struct PreWalker : public Walker<SubType, Visitor<SubType>> {
  using TaskFunc = void (*)(SubType*, Expression**, bool);

  struct Task {
    TaskFunc func;
    Expression** currp;
    bool isTail;
    Task() = default;
    Task(TaskFunc func, Expression** currp, bool isTail)
      : func(func), currp(currp), isTail(isTail) {}
  };

  SmallVector<Task, 10> stack;

  void push(Expression** currp, bool isTail) {
    assert(*currp);
    stack.emplace_back(doVisit, currp, isTail);
  }

  void maybePush(Expression** currp, bool isTail) {
    if (*currp) {
      stack.emplace_back(doVisit, currp, isTail);
    }
  }

  Task popTask() {
    auto ret = stack.back();
    stack.pop_back();
    return ret;
  }

  static void doVisit(SubType* self, Expression** currp, bool isTail) {
    self->visit(*currp, isTail);
  }

  void walk(Expression*& root) {
    assert(stack.empty());
    push(&root, true);
    while (!stack.empty()) {
      auto task = popTask();
      task.func(static_cast<SubType*>(this), task.currp, task.isTail);
    }
  }

  void doWalkFunction(Function* func) { walk(func->body); }

  void visitExpression(Expression* curr, bool isTail) {
    assert(!Properties::isControlFlowStructure(curr) &&
           "unexpected control flow structure");

#define DELEGATE_ID curr->_id
#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();
#define DELEGATE_END(id)
#define DELEGATE_GET_FIELD(id, field) cast->field
#define DELEGATE_FIELD_CHILD(id, field) push(&cast->field, false);
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field) maybePush(&cast->field, false);
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"
  }

#define DELEGATE(CLASS_TO_VISIT)                                               \
  void visit##CLASS_TO_VISIT(CLASS_TO_VISIT* curr, bool isTail) {              \
    static_cast<SubType*>(this)->visitExpression(curr, isTail);                \
  }

#include "wasm-delegations.def"

  void visit(Expression* curr, bool isTail) {
    assert(curr);
    switch (curr->_id) {
#define DELEGATE(CLASS_TO_VISIT)                                               \
  case Expression::Id::CLASS_TO_VISIT##Id:                                     \
    return static_cast<SubType*>(this)->visit##CLASS_TO_VISIT(                 \
      static_cast<CLASS_TO_VISIT*>(curr), isTail);

#include "wasm-delegations.def"

      default:
        WASM_UNREACHABLE("unexpected expression type");
    }
  }
};

struct TailCall : public WalkerPass<PreWalker<TailCall>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TailCall>();
  }

  // Names of blocks whose exit flows directly out of the function.
  std::unordered_set<Name> tailBlocks;
  // Nesting depth of active exception handlers that catch or redirect
  // exceptions within the current function.
  size_t ehDepth = 0;
  // Whether any call in the current function was converted to a return call.
  bool changed = false;

  void pushEnterTry() { stack.emplace_back(doEnterTryBody, nullptr, false); }

  void pushLeaveTry() { stack.emplace_back(doLeaveTryBody, nullptr, false); }

  static void doEnterTryBody(TailCall* self, Expression**, bool) {
    ++self->ehDepth;
  }

  static void doLeaveTryBody(TailCall* self, Expression**, bool) {
    assert(self->ehDepth > 0);
    --self->ehDepth;
  }

  bool hasUnremovableSideEffects(Expression* expr) {
    return EffectAnalyzer(getPassOptions(), *getModule(), expr)
      .hasUnremovableSideEffects();
  }

  bool allTargetsInTailBlocks(Switch* curr) {
    if (!tailBlocks.contains(curr->default_)) {
      return false;
    }
    for (auto target : curr->targets) {
      if (!tailBlocks.contains(target)) {
        return false;
      }
    }
    return true;
  }

  bool isTailTransfer(Break* curr, bool isTail) {
    if (!tailBlocks.contains(curr->name)) {
      return false;
    }
    // Converting a call in a conditional branch or br_table to a return_call
    // skips evaluating the condition, so the condition must not have side
    // effects.
    return !curr->condition ||
           (isTail && !hasUnremovableSideEffects(curr->condition));
  }

  bool isTailTransfer(Switch* curr) {
    return allTargetsInTailBlocks(curr) &&
           !hasUnremovableSideEffects(curr->condition);
  }

  bool isTailTransfer(Expression* curr, bool isTail) {
    if (curr->is<Return>()) {
      return true;
    }
    if (auto* br = curr->dynCast<Break>()) {
      return isTailTransfer(br, isTail);
    }
    if (auto* sw = curr->dynCast<Switch>()) {
      return isTailTransfer(sw);
    }
    return false;
  }

  template<typename CallType> void handleCall(CallType* call, bool isTail) {
    // A call in tail position can have a type incompatible with the function's
    // return type if it is dead code at the end of a block following an earlier
    // unreachable instruction. Also avoid optimizing unreachable calls (e.g.
    // calls with unreachable operands), since their callee return type may not
    // match the caller return type.
    if (call->isReturn || !isTail || call->type == Type::unreachable ||
        !Type::isSubType(call->type, getFunction()->getResults())) {
      return;
    }
    if (ehDepth > 0 &&
        ShallowEffectAnalyzer(getPassOptions(), *getModule(), call).throws()) {
      return;
    }
    call->isReturn = true;
    call->finalize();
    changed = true;
  }

  void visitBlock(Block* curr, bool isTail) {
    if (isTail && curr->name.is()) {
      tailBlocks.insert(curr->name);
    }
    bool nextIsTail = isTail;
    for (int i = int(curr->list.size()) - 1; i >= 0; --i) {
      bool itemIsTail = false;
      if (i == int(curr->list.size()) - 1) {
        itemIsTail = isTail;
      } else if (getFunction()->getResults() == Type::none &&
                 isTailTransfer(curr->list[i + 1], nextIsTail)) {
        itemIsTail = true;
      }
      nextIsTail = itemIsTail;
      push(&curr->list[i], itemIsTail);
    }
  }

  void visitIf(If* curr, bool isTail) {
    maybePush(&curr->ifFalse, isTail);
    push(&curr->ifTrue, isTail);
    push(&curr->condition, false);
  }

  void visitLoop(Loop* curr, bool isTail) { push(&curr->body, isTail); }

  void visitBreak(Break* curr, bool isTail) {
    bool valueIsTail = curr->value && isTailTransfer(curr, isTail);
    maybePush(&curr->condition, false);
    maybePush(&curr->value, valueIsTail);
  }

  void visitSwitch(Switch* curr, bool isTail) {
    bool valueIsTail = curr->value && isTailTransfer(curr);
    push(&curr->condition, false);
    maybePush(&curr->value, valueIsTail);
  }

  void visitReturn(Return* curr, bool isTail) { maybePush(&curr->value, true); }

  void visitTry(Try* curr, bool isTail) {
    for (int i = int(curr->catchBodies.size()) - 1; i >= 0; --i) {
      push(&curr->catchBodies[i], isTail);
    }
    // A try block that delegates directly to the caller does not catch any
    // exceptions in this function; exceptions thrown in its body already unwind
    // the frame to the caller just like a return_call would. All other try
    // blocks (catch/catch_all or delegating to an outer try) establish a local
    // handler that would be bypassed by return_call.
    bool hasLocalHandler =
      !curr->isDelegate() || curr->delegateTarget != DELEGATE_CALLER_TARGET;
    if (hasLocalHandler) {
      pushLeaveTry();
    }
    push(&curr->body, isTail);
    if (hasLocalHandler) {
      pushEnterTry();
    }
  }

  void visitTryTable(TryTable* curr, bool isTail) {
    bool hasLocalHandler = !curr->catchTags.empty();
    if (hasLocalHandler) {
      pushLeaveTry();
    }
    push(&curr->body, isTail);
    if (hasLocalHandler) {
      pushEnterTry();
    }
  }

  void visitCall(Call* curr, bool isTail) {
    handleCall(curr, isTail);
    visitExpression(curr, false);
  }

  void visitCallIndirect(CallIndirect* curr, bool isTail) {
    handleCall(curr, isTail);
    visitExpression(curr, false);
  }

  void visitCallRef(CallRef* curr, bool isTail) {
    handleCall(curr, isTail);
    visitExpression(curr, false);
  }

  void doWalkFunction(Function* func) {
    if (!getModule()->features.hasTailCall() || func->imported()) {
      return;
    }
    tailBlocks.clear();
    walk(func->body);
    if (changed) {
      ReFinalize().walkFunctionInModule(func, getModule());
    }
  }
};

} // anonymous namespace

Pass* createTailCallPass() { return new TailCall(); }

} // namespace wasm
