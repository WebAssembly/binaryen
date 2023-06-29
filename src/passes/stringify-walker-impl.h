#include "stringify-walker.h"

#ifndef wasm_passes_stringify_walker_impl_h
#define wasm_passes_stringify_walker_impl_h

namespace wasm {

template<typename SubType>
inline void StringifyWalker<SubType>::doWalkModule(Module* module) {
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
     *    the string for the top-level function body and subsequent strings for
     *    each control flow structure in the function.
     * 3. then we call walk, which will visit the function body as a single unit
     * 4. finally we call addUniqueSymbol directly to ensure the string encoding
     *    for each function is terminated with a unique symbol, acting as a
     *    separator between each function in the program string
     */
    this->walkFunction(func);
  });
}

template<typename SubType>
inline void StringifyWalker<SubType>::doWalkFunction(Function* func) {
  // call our walk and emit the unique symbol for the function body
  this->walk(func->body);
  this->addUniqueSymbol();
}

template<typename SubType>
inline void StringifyWalker<SubType>::walk(Expression* curr) {
  Super::walk(curr);
  do {
    this->addUniqueSymbol();
    this->dequeueControlFlow();
  } while (controlFlowQueue.size() > 0);
}

template<typename SubType>
inline void StringifyWalker<SubType>::scan(SubType* self, Expression** currp) {
  Expression* curr = *currp;
  if (Properties::isControlFlowStructure(curr)) {
    self->controlFlowQueue.push(currp);
    self->pushTask(doVisitExpression, currp);
    if (auto* iff = curr->dynCast<If>()) {
      Super::scan(self, &iff->condition);
    }
  } else {
    Super::scan(self, currp);
    return;
  }
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
template<typename SubType> void StringifyWalker<SubType>::dequeueControlFlow() {
  auto& queue = this->controlFlowQueue;
  if (queue.empty()) {
    return;
  }

  Expression** currp = queue.front();
  queue.pop();
  this->deferredScan(currp);
}

template<typename SubType>
void StringifyWalker<SubType>::deferredScan(Expression** currp) {
  auto self = static_cast<SubType*>(this);
  Expression* curr = *currp;
  switch (curr->_id) {
    case Expression::Id::BlockId: {
      auto* block = curr->cast<Block>();
      // TODO: The below code could be simplified if ArenaVector supported
      // reverse iterators
      for (auto& child : block->list) {
        Super::walk(child);
      }
      break;
    }
    case Expression::Id::IfId: {
      auto* iff = curr->cast<If>();
      Super::walk(iff->ifTrue);
      self->addUniqueSymbol();
      if (iff->ifFalse) {
        Super::walk(iff->ifFalse);
      }
      break;
    }
    case Expression::Id::TryId: {
      auto* tryy = curr->cast<Try>();
      Super::walk(tryy->body);
      this->addUniqueSymbol();
      for (auto& child : tryy->catchBodies) {
        Super::walk(child);
      }
      break;
    }
    case Expression::Id::LoopId: {
      auto* loop = curr->cast<Loop>();
      Super::walk(loop->body);
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

template<typename SubType>
inline void StringifyWalker<SubType>::addUniqueSymbol() {
  auto self = static_cast<SubType*>(this);
  self->addUniqueSymbol();
}

} // namespace wasm

#endif // wasm_passes_stringify_walker_impl_h
