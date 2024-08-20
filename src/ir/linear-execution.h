/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_ir_linear_execution_h
#define wasm_ir_linear_execution_h

#include "ir/properties.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

// Traversal in the order of execution. This is quick and simple, but
// does not provide the same comprehensive information that a full
// conversion to basic blocks would. What it does give is a quick
// way to view straightline execution traces, i.e., that have no
// branching. This can let optimizations get most of what they
// want without the cost of creating another AST.
//
// When execution is no longer linear, this notifies via a call
// to noteNonLinear().

template<typename SubType, typename VisitorType = Visitor<SubType>>
struct LinearExecutionWalker : public PostWalker<SubType, VisitorType> {
  LinearExecutionWalker() = default;

  // subclasses should implement this
  void noteNonLinear(Expression* curr) { abort(); }

  static void doNoteNonLinear(SubType* self, Expression** currp) {
    self->noteNonLinear(*currp);
  }

  // Optionally, we can connect adjacent basic blocks. "Adjacent" here means
  // that the first branches to the second, and that there is no other code in
  // between them. As a result, the first dominates the second, but it might not
  // reach it.
  //
  // For example, a call may branch if exceptions are enabled, but if this
  // option is flipped on then we will *not* call doNoteNonLinear on the call:
  //
  //  ..A..
  //  call();
  //  ..B..
  //
  // As a result, we'd consider A and B to be together. Another example is an
  // if:
  //
  //  ..A..
  //  if
  //    ..B..
  //  else
  //    ..C..
  //  end
  //
  // Here we will connect A and B, but *not* A and C (there is code in between)
  // or B and C (they do not branch to each other).
  //
  // As the if case shows, this can be useful for cases where we want to look at
  // dominated blocks with their dominator, but it only handles the trivial
  // adjacent cases of such dominance. Passes should generally uses a full CFG
  // and dominator tree for this, but this option does help some very common
  // cases (calls, if without an else) and it has very low overhead (we still
  // only do a simple postorder walk on the IR, no CFG is constructed, etc.).
  bool connectAdjacentBlocks = false;

  static void scan(SubType* self, Expression** currp) {
    Expression* curr = *currp;

    auto handleCall = [&](bool isReturn) {
      if (!self->connectAdjacentBlocks) {
        // Control is nonlinear if we return, or if EH is enabled or may be.
        if (isReturn || !self->getModule() ||
            self->getModule()->features.hasExceptionHandling()) {
          self->pushTask(SubType::doNoteNonLinear, currp);
        }
      }

      // Scan the children normally.
      PostWalker<SubType, VisitorType>::scan(self, currp);
    };

    switch (curr->_id) {
      case Expression::Id::InvalidId:
        WASM_UNREACHABLE("bad id");
      case Expression::Id::BlockId: {
        self->pushTask(SubType::doVisitBlock, currp);
        if (curr->cast<Block>()->name.is()) {
          self->pushTask(SubType::doNoteNonLinear, currp);
        }
        auto& list = curr->cast<Block>()->list;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::IfId: {
        self->pushTask(SubType::doVisitIf, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->maybePushTask(SubType::scan, &curr->cast<If>()->ifFalse);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<If>()->ifTrue);
        if (!self->connectAdjacentBlocks) {
          self->pushTask(SubType::doNoteNonLinear, currp);
        }
        self->pushTask(SubType::scan, &curr->cast<If>()->condition);
        break;
      }
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doVisitLoop, currp);
        self->pushTask(SubType::scan, &curr->cast<Loop>()->body);
        self->pushTask(SubType::doNoteNonLinear, currp);
        break;
      }
      case Expression::Id::BreakId: {
        self->pushTask(SubType::doVisitBreak, currp);
        auto* br = curr->cast<Break>();
        // If there is no condition then we note non-linearity as the code after
        // us is unreachable anyhow (we do the same for Switch, Return, etc.).
        // If there is a condition, then we note or do not note depending on
        // whether we allow adjacent blocks.
        if (!br->condition || !self->connectAdjacentBlocks) {
          self->pushTask(SubType::doNoteNonLinear, currp);
        }
        self->maybePushTask(SubType::scan, &br->condition);
        self->maybePushTask(SubType::scan, &br->value);
        break;
      }
      case Expression::Id::SwitchId: {
        self->pushTask(SubType::doVisitSwitch, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<Switch>()->condition);
        self->maybePushTask(SubType::scan, &curr->cast<Switch>()->value);
        break;
      }
      case Expression::Id::ReturnId: {
        self->pushTask(SubType::doVisitReturn, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Return>()->value);
        break;
      }
      case Expression::Id::CallId: {
        handleCall(curr->cast<Call>()->isReturn);
        return;
      }
      case Expression::Id::CallRefId: {
        handleCall(curr->cast<CallRef>()->isReturn);
        return;
      }
      case Expression::Id::TryId: {
        self->pushTask(SubType::doVisitTry, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        auto& list = curr->cast<Try>()->catchBodies;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
          self->pushTask(SubType::doNoteNonLinear, currp);
        }
        self->pushTask(SubType::scan, &curr->cast<Try>()->body);
        break;
      }
      case Expression::Id::TryTableId: {
        self->pushTask(SubType::doVisitTryTable, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        self->pushTask(SubType::scan, &curr->cast<TryTable>()->body);
        break;
      }
      case Expression::Id::ThrowId: {
        self->pushTask(SubType::doVisitThrow, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        auto& list = curr->cast<Throw>()->operands;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::RethrowId: {
        self->pushTask(SubType::doVisitRethrow, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        break;
      }
      case Expression::Id::UnreachableId: {
        self->pushTask(SubType::doVisitUnreachable, currp);
        self->pushTask(SubType::doNoteNonLinear, currp);
        break;
      }
      case Expression::Id::BrOnId: {
        self->pushTask(SubType::doVisitBrOn, currp);
        if (!self->connectAdjacentBlocks) {
          self->pushTask(SubType::doNoteNonLinear, currp);
        }
        self->pushTask(SubType::scan, &curr->cast<BrOn>()->ref);
        break;
      }
      default: {
        // All relevant things should have been handled.
        assert(!Properties::isControlFlowStructure(curr));
        assert(!Properties::isBranch(curr));
        // other node types do not have control flow, use regular post-order
        PostWalker<SubType, VisitorType>::scan(self, currp);
      }
    }
  }
};

} // namespace wasm

#endif // wasm_ir_linear_execution_h
