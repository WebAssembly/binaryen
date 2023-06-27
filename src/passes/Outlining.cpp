/*
 * Copyright 2023 WebAssembly Community Group participants
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

#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/utils.h"
#include "pass.h"
#include "stringify-walker.h"
#include "wasm-builder.h"
#include "wasm-stack.h"
#include "wasm.h"

namespace wasm {

/*
 * This walker performs a shallow visit of control-flow (try, if, block, loop)
 * expressions and their simple expression siblings before then visiting the
 * children of each control-flow expression in postorder. As a result, this
 * walker un-nests nested control flow structures, so the expression visit order
 * does not correspond to a normal postorder traversal of the function.
 *
 * For example, the below (contrived) wat:
 * 1: (block
 * 2:   (drop
 * 3:     (i32.add
 * 4:       (i32.const 20)
 * 5:       (i32.const 10)))
 * 6:   (if
 * 7:     (i32.const 0)
 * 8:     (then (return (i32.const 1)))
 * 9:     (else (return (i32.const 0)))))
 *
 * Would have its expressions visited in the following order (based on line
 * number):
 * 1, 4, 5, 3, 2, 7, 6, 8, 9
 *
 * Of note:
 *   - The add (line 3) binary operator's left and right children (lines 4 - 5)
 *     are visited first as they need to be on the stack before the add
 *     operation is executed
 *   - The if-condition (i32.const 0) on line 7 is visited before the if
 *     expression
 */
template<typename SubType>
void StringifyWalker<SubType>::walkModule(SubType* self, Module* module) {
  self->wasm = module;
  ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
    /*
     * The ordering of the below lines of code are important. On each function
     * iteration, we:
     * 1. push a task for calling the dequeueControlFlow  function, to ensure that each
     *    function has an opportunity to dequeue from StringifyWalker's
     *    internally managed controlFlowQueue. This queue exists to provide a way for
     *    control flow to defer scanning their children.
     * 2. push a task for adding a unique symbol, so that after the function
     *    body is visited as a single expression, there is a a separator between
     *    the symbol for the function and subsequent symbols as each child of
     *    the function body is visited. This assumes the function body is a block.
     * 3. then we call walk, which will visit the function body as a single unit
     * 4. finally we call addUniqueSymbol directly to ensure the string encoding
     *    for each function is terminated with a unique symbol, acting as a
     *    separator between each function in the program string
     */
    self->pushTask(StringifyWalker::dequeueControlFlow, nullptr);
    self->pushTask(StringifyWalker::addUniqueSymbol, &func->body);
    self->walk(func->body);
    self->addUniqueSymbol(self, &func->body);
  });
}

/*
 * This dequeueControlFlow is responsible for ensuring the children expressions of control
 * flow expressions are visited after the control flow expression has already
 * been visited. In order to perform this responsibility, the dequeueControlFlow function
 * needs to always be the very last task in the Walker stack, as the last task
 * will be executed last. This way if the queue is not empty, the first
 * statement pushes a new task to call dequeueControlFlow again.
 *
 */
template<typename SubType>
void StringifyWalker<SubType>::dequeueControlFlow(SubType* self, Expression**) {
  auto& queue = self->controlFlowQueue;
  if (queue.empty()) {
    return;
  }

  self->pushTask(StringifyWalker::dequeueControlFlow, nullptr);
  Expression** currp = queue.front();
  queue.pop();
  StringifyWalker<SubType>::deferredScan(self, currp);
}

template<typename SubType>
void StringifyWalker<SubType>::deferredScan(SubType* stringify,
                                            Expression** currp) {
  Expression* curr = *currp;
  switch (curr->_id) {
    case Expression::Id::BlockId: {
      auto* block = curr->cast<Block>();
      if (block->list.size() > 0) {
        stringify->pushTask(StringifyWalker::addUniqueSymbol, currp);
      }
      // TODO: The below code could be simplified if ArenaVector supported reverse
      // iterators
      auto blockIterator = block->list.end();
      while (blockIterator != block->list.begin()) {
        blockIterator--;
        auto& child = block->list[blockIterator.index];
        stringify->pushTask(StringifyWalker::scan, &child);
      }
      break;
    }
    case Expression::Id::IfId: {
      auto* iff = curr->cast<If>();
      if (iff->ifFalse) {
        stringify->pushTask(StringifyWalker::addUniqueSymbol, &iff->ifFalse);
        stringify->pushTask(StringifyWalker::scan, &iff->ifFalse);
      }
      stringify->pushTask(StringifyWalker::addUniqueSymbol, &iff->ifTrue);
      stringify->pushTask(StringifyWalker::scan, &iff->ifTrue);
      break;
    }
    case Expression::Id::TryId: {
      auto* tryy = curr->cast<Try>();
      if (tryy->catchBodies.size() > 0) {
        stringify->pushTask(StringifyWalker::addUniqueSymbol, currp);
      }
      auto blockIterator = tryy->catchBodies.end();
      while (blockIterator != tryy->catchBodies.begin()) {
        blockIterator--;
        auto& child = tryy->catchBodies[blockIterator.index];
        stringify->pushTask(StringifyWalker::scan, &child);
      }
      stringify->pushTask(StringifyWalker::addUniqueSymbol, &tryy->body);
      stringify->pushTask(StringifyWalker::scan, &tryy->body);
      break;
    }
    case Expression::Id::LoopId: {
      auto* loop = curr->cast<Loop>();
      stringify->pushTask(StringifyWalker::addUniqueSymbol, currp);
      stringify->pushTask(StringifyWalker::scan, &loop->body);
      break;
    }
    default: {
      assert(Properties::isControlFlowStructure(curr));
      WASM_UNREACHABLE("unexpected expression");
    }
  }
}

template<typename SubType>
void StringifyWalker<SubType>::scan(SubType* self, Expression** currp) {
  Expression* curr = *currp;
  if (Properties::isControlFlowStructure(curr)) {
    self->pushTask(StringifyWalker::doVisitExpression, currp);
    self->controlFlowQueue.push(currp);
    if (auto *iff = curr->dynCast<If>()) {
      PostWalker<SubType>::scan(self, &iff->condition);
    }
  } else {
    PostWalker<SubType>::scan(self, currp);
    return;
  }

}

template<typename SubType>
void StringifyWalker<SubType>::doVisitExpression(SubType* self,
                                                 Expression** currp) {
  Expression* curr = *currp;
  self->visitExpression(curr);
}

template<typename SubType>
void StringifyWalker<SubType>::addUniqueSymbol(SubType* self,
                                               Expression** currp) {
  self->addUniqueSymbol(self, currp);
}

} // namespace wasm
