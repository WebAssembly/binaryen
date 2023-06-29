#include "stringify-walker.h"

#ifndef wasm_passes_stringify_walker_impl_h
#define wasm_passes_stringify_walker_impl_h

namespace wasm {

template<typename SubType>
inline void StringifyWalker<SubType>::doWalkModule(Module* module) {
  ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
    this->walkFunction(func);
  });
}

template<typename SubType>
inline void StringifyWalker<SubType>::doWalkFunction(Function* func) {
  walk(func->body);
  addUniqueSymbol();
}

template<typename SubType>
inline void StringifyWalker<SubType>::walk(Expression* curr) {
  Super::walk(curr);
  do {
    addUniqueSymbol();
    dequeueControlFlow();
  } while (!controlFlowQueue.empty());
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
  auto self = static_cast<SubType*>(this);
  Expression* curr = *currp;

  switch (curr->_id) {
    case Expression::Id::BlockId: {
      auto* block = curr->cast<Block>();
      for (auto& child : block->list) {
        Super::walk(child);
      }
      break;
    }
    case Expression::Id::IfId: {
      auto* iff = curr->cast<If>();
      Super::walk(iff->ifTrue);
      if (iff->ifFalse) {
        self->addUniqueSymbol();
        Super::walk(iff->ifFalse);
      }
      break;
    }
    case Expression::Id::TryId: {
      auto* tryy = curr->cast<Try>();
      Super::walk(tryy->body);
      for (auto& child : tryy->catchBodies) {
        this->addUniqueSymbol();
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
  self->visit(curr);
}

template<typename SubType>
inline void StringifyWalker<SubType>::addUniqueSymbol() {
  // TODO: Add the following static_assert when the compilers running our GitHub actions are updated enough to know that this is a constant condition: static_assert(&StringifyWalker<SubType>::addUniqueSymbol != &SubType::addUniqueSymbol);
  auto self = static_cast<SubType*>(this);
  self->addUniqueSymbol();
}

} // namespace wasm

#endif // wasm_passes_stringify_walker_impl_h
