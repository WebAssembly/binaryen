#include "stringify-walker.h"

#ifndef wasm_passes_stringify_walker_impl_h
#define wasm_passes_stringify_walker_impl_h

namespace wasm {

// This walker supplies its own doWalkModule because it does not make sense to
// walk anything besides defined functions.
template<typename SubType>
inline void StringifyWalker<SubType>::doWalkModule(Module* module) {
  ModuleUtils::iterDefinedFunctions(
    *module, [&](Function* func) { this->walkFunction(func); });
}

template<typename SubType>
inline void StringifyWalker<SubType>::doWalkFunction(Function* func) {
  walk(func->body);
  /*
   * We add a unique symbol after walking the function body to separate the
   * string generated from visiting the function body as a single unit from the
   * subsequent strings that will be generated from visiting the sub-expressions
   * of the function body. If we did not add this unique symbol and a program
   * had two functions with the same instructions, we would incorrectly create a
   * new function with the instructions repeated twice.
   */
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

// This dequeueControlFlow is responsible for visiting the children expressions
// of control flow.
template<typename SubType> void StringifyWalker<SubType>::dequeueControlFlow() {
  auto& queue = controlFlowQueue;
  if (queue.empty()) {
    return;
  }

  Expression** currp = queue.front();
  queue.pop();
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
        addUniqueSymbol();
        Super::walk(iff->ifFalse);
      }
      break;
    }
    case Expression::Id::TryId: {
      auto* tryy = curr->cast<Try>();
      Super::walk(tryy->body);
      for (auto& child : tryy->catchBodies) {
        addUniqueSymbol();
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
  // TODO: Add the following static_assert when the compilers running our GitHub
  // actions are updated enough to know that this is a constant condition:
  // static_assert(&StringifyWalker<SubType>::addUniqueSymbol !=
  // &SubType::addUniqueSymbol);
  auto self = static_cast<SubType*>(this);
  self->addUniqueSymbol();
}

} // namespace wasm

#endif // wasm_passes_stringify_walker_impl_h
