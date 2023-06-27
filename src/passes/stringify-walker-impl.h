#include "wasm-traversal.h"

#ifndef wasm_passes_stringify_walker_impl_h
#define wasm_passes_stringify_walker_impl_h

namespace wasm {

template<typename SubType>
inline void StringifyWalker<SubType>::walkModule(Module* module) {
  auto self = static_cast<SubType*>(this);
  self->wasm = module;
  ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
    /*
     * The ordering of the below lines of code are important. On each function
     * iteration, we:
     * 1. push a task for calling the dequeueControlFlow function, to ensure
     *    that each function has an opportunity to dequeue from
     *    StringifyWalker's internally managed controlFlowQueue. This queue
     *    exists to provide a way for control flow to defer scanning their
     *    children.
     * 2. push a task for adding a unique symbol, so that after the function
     *    body is visited as a single expression, there is a a separator between
     *    the symbol for the function and subsequent symbols as each child of
     *    the function body is visited. This assumes the function body is a
     *    block.
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
 * This dequeueControlFlow is responsible for ensuring the children expressions
 * of control flow expressions are visited after the control flow expression has
 * already been visited. In order to perform this responsibility, the
 * dequeueControlFlow function needs to always be the very last task in the
 * Walker stack, as the last task will be executed last. This way if the queue
 * is not empty, the first statement pushes a new task to call
 * dequeueControlFlow again.
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
inline void StringifyWalker<SubType>::scan(SubType* self, Expression** currp) {
  Expression* curr = *currp;
  if (Properties::isControlFlowStructure(curr)) {
    self->pushTask(StringifyWalker::doVisitExpression, currp);
    self->controlFlowQueue.push(currp);
    if (auto* iff = curr->dynCast<If>()) {
      PostWalker<SubType>::scan(self, &iff->condition);
    }
  } else {
    PostWalker<SubType>::scan(self, currp);
    return;
  }
}

template<typename SubType>
inline void StringifyWalker<SubType>::addUniqueSymbol(SubType* self,
                                                      Expression** currp) {
  self->addUniqueSymbol(self, currp);
}

template<typename SubType>
void StringifyWalker<SubType>::deferredScan(SubType* stringify,
                                            Expression** currp) {
  Expression* curr = *currp;
  stringify->pushTask(StringifyWalker::addUniqueSymbol, currp);
  switch (curr->_id) {
    case Expression::Id::BlockId: {
      auto* block = curr->cast<Block>();
      // TODO: The below code could be simplified if ArenaVector supported
      // reverse iterators
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
        stringify->pushTask(StringifyWalker::scan, &iff->ifFalse);
      }
      stringify->pushTask(StringifyWalker::addUniqueSymbol, &iff->ifTrue);
      stringify->pushTask(StringifyWalker::scan, &iff->ifTrue);
      break;
    }
    case Expression::Id::TryId: {
      auto* tryy = curr->cast<Try>();
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
void StringifyWalker<SubType>::doVisitExpression(SubType* self,
                                                 Expression** currp) {
  Expression* curr = *currp;
  self->visitExpression(curr);
}

} // namespace wasm

#endif // wasm_passes_stringify_walker_impl_h
