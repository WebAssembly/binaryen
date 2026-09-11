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
#include "wasm.h"

namespace wasm {

namespace {

struct TailCall : public WalkerPass<PostWalker<TailCall>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<TailCall>();
  }

  // Expressions whose evaluation is immediately followed by exiting the
  // function.
  std::unordered_set<Expression*> tailExprs;
  // Names of blocks whose exit flows directly out of the function.
  std::unordered_set<Name> tailBlocks;
  // Nesting depth of active exception handlers that catch or redirect
  // exceptions within the current function.
  size_t ehDepth = 0;
  // Whether any call in the current function was converted to a return call.
  bool changed = false;

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

  bool isTailTransfer(Expression* expr) {
    if (expr->is<Return>()) {
      return true;
    }
    if (auto* br = expr->dynCast<Break>()) {
      if (!tailBlocks.contains(br->name)) {
        return false;
      }
      // Converting a call in a conditional branch or br_table to a return_call
      // skips evaluating the condition, so the condition must not have side
      // effects.
      return !br->condition || (tailExprs.contains(br) &&
                                !hasUnremovableSideEffects(br->condition));
    }
    if (auto* curr = expr->dynCast<Switch>()) {
      return allTargetsInTailBlocks(curr) &&
             !hasUnremovableSideEffects(curr->condition);
    }
    return false;
  }

  static void doEnterTryBody(TailCall* self, Expression** currp) {
    ++self->ehDepth;
  }

  static void doLeaveTryBody(TailCall* self, Expression** currp) {
    assert(self->ehDepth > 0);
    --self->ehDepth;
  }

  static void scan(TailCall* self, Expression** currp) {
    Expression* curr = *currp;
    bool isTail = self->tailExprs.contains(curr);

    if (auto* ret = curr->dynCast<Return>()) {
      if (ret->value) {
        self->tailExprs.insert(ret->value);
      }
    } else if (auto* block = curr->dynCast<Block>()) {
      if (isTail) {
        if (block->name.is()) {
          self->tailBlocks.insert(block->name);
        }
        if (!block->list.empty()) {
          self->tailExprs.insert(block->list.back());
        }
      }
      // In none-returning functions, returns and branches to tail blocks never
      // carry values; mark the preceding statement as a tail expression.
      if (self->getFunction()->getResults() == Type::none) {
        for (Index i = 0; i + 1 < block->list.size(); ++i) {
          if (self->isTailTransfer(block->list[i + 1])) {
            self->tailExprs.insert(block->list[i]);
          }
        }
      }
    } else if (auto* iff = curr->dynCast<If>()) {
      if (isTail) {
        self->tailExprs.insert(iff->ifTrue);
        if (iff->ifFalse) {
          self->tailExprs.insert(iff->ifFalse);
        }
      }
    } else if (auto* loop = curr->dynCast<Loop>()) {
      // Loops fall through to their body, but their label is a backedge to the
      // header rather than an exit, so we do not add loop->name to tailBlocks.
      if (isTail) {
        self->tailExprs.insert(loop->body);
      }
    } else if (auto* br = curr->dynCast<Break>()) {
      if (br->value && self->isTailTransfer(br)) {
        self->tailExprs.insert(br->value);
      }
    } else if (auto* sw = curr->dynCast<Switch>()) {
      if (sw->value && self->isTailTransfer(sw)) {
        self->tailExprs.insert(sw->value);
      }
    } else if (auto* tryy = curr->dynCast<Try>()) {
      if (isTail) {
        self->tailExprs.insert(tryy->body);
        for (auto* catchBody : tryy->catchBodies) {
          self->tailExprs.insert(catchBody);
        }
      }
      for (int i = int(tryy->catchBodies.size()) - 1; i >= 0; --i) {
        self->pushTask(TailCall::scan, &tryy->catchBodies[i]);
      }
      // A try block that delegates directly to the caller does not catch any
      // exceptions in this function; exceptions thrown in its body already
      // unwind the frame to the caller just like a return_call would. All other
      // try blocks (catch/catch_all or delegating to an outer try) establish a
      // local handler that would be bypassed by return_call.
      bool hasLocalHandler =
        !tryy->isDelegate() || tryy->delegateTarget != DELEGATE_CALLER_TARGET;
      if (hasLocalHandler) {
        self->pushTask(doLeaveTryBody, currp);
      }
      self->pushTask(TailCall::scan, &tryy->body);
      if (hasLocalHandler) {
        self->pushTask(doEnterTryBody, currp);
      }
      return;
    } else if (auto* tryTable = curr->dynCast<TryTable>()) {
      if (isTail) {
        self->tailExprs.insert(tryTable->body);
      }
      bool hasLocalHandler = !tryTable->catchTags.empty();
      if (hasLocalHandler) {
        self->pushTask(doLeaveTryBody, currp);
      }
      self->pushTask(TailCall::scan, &tryTable->body);
      if (hasLocalHandler) {
        self->pushTask(doEnterTryBody, currp);
      }
      return;
    } else {
      assert(!Properties::isControlFlowStructure(curr) &&
             "unexpected control flow structure");
    }

    PostWalker<TailCall>::scan(self, currp);
  }

  template<typename CallType> void handleCall(CallType* call) {
    // A call in tail position can have a type incompatible with the function's
    // return type if it is dead code at the end of a block following an earlier
    // unreachable instruction.
    if (call->isReturn || !tailExprs.contains(call) ||
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

  void visitCall(Call* curr) { handleCall(curr); }

  void visitCallIndirect(CallIndirect* curr) { handleCall(curr); }

  void visitCallRef(CallRef* curr) { handleCall(curr); }

  void doWalkFunction(Function* func) {
    if (!getModule()->features.hasTailCall() || func->imported()) {
      return;
    }
    tailExprs.insert(func->body);
    Super::doWalkFunction(func);
    if (changed) {
      ReFinalize().walkFunctionInModule(func, getModule());
      PassRunner runner(getModule(), getPassOptions());
      runner.setIsNested(true);
      runner.add("dce");
      runner.runOnFunction(func);
    }
  }
};

} // anonymous namespace

Pass* createTailCallPass() { return new TailCall(); }

} // namespace wasm
