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
  addUniqueSymbol(SeparatorCtx::makeFuncStart(func));
  walk(func->body);
}

template<typename SubType>
inline void StringifyWalker<SubType>::walk(Expression* curr) {
  Super::walk(curr);
  addUniqueSymbol(SeparatorCtx::makeFuncEnd(this->getFunction()));
  do {
    dequeueControlFlow();
  } while (!controlFlowQueue.empty());
}

template<typename SubType>
inline void StringifyWalker<SubType>::scan(SubType* self, Expression** currp) {
  Expression* curr = *currp;
  if (Properties::isControlFlowStructure(curr)) {
    self->controlFlowQueue.push(currp);
    self->pushTask(doVisitExpression, currp);
    // The if-condition is a value child consumed by the if control flow, which
    // makes the if-condition a true sibling rather than part of its contents in
    // the binary format
    for (auto*& child : ValueChildIterator(curr)) {
      Super::scan(self, &child);
    }
  } else {
    Super::scan(self, currp);
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

  // TODO: Issue #5796, Make a ControlChildIterator
  switch (curr->_id) {
    case Expression::Id::BlockId: {
      auto* block = curr->cast<Block>();
      addUniqueSymbol(SeparatorCtx::makeBlockStart(block));
      for (auto& child : block->list) {
        Super::walk(child);
      }
      addUniqueSymbol(SeparatorCtx::makeEnd(block));
      break;
    }
    case Expression::Id::IfId: {
      auto* iff = curr->cast<If>();
      addUniqueSymbol(SeparatorCtx::makeIfStart(iff));
      Super::walk(iff->ifTrue);
      addUniqueSymbol(SeparatorCtx::makeEnd(iff));
      if (iff->ifFalse) {
        addUniqueSymbol(SeparatorCtx::makeElseStart(iff));
        Super::walk(iff->ifFalse);
        addUniqueSymbol(SeparatorCtx::makeEnd(iff));
      }
      break;
    }
    // TODO: Support exception handling control flow
    case Expression::Id::LoopId: {
      auto* loop = curr->cast<Loop>();
      addUniqueSymbol(SeparatorCtx::makeLoopStart(loop));
      Super::walk(loop->body);
      addUniqueSymbol(SeparatorCtx::makeEnd(loop));
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
inline void StringifyWalker<SubType>::addUniqueSymbol(SeparatorCtx ctx) {
  // TODO: Add the following static_assert when the compilers running our GitHub
  // actions are updated enough to know that this is a constant condition:
  // static_assert(&StringifyWalker<SubType>::addUniqueSymbol !=
  // &SubType::addUniqueSymbol);
  auto self = static_cast<SubType*>(this);
  self->addUniqueSymbol(ctx);
}

} // namespace wasm

#endif // wasm_passes_stringify_walker_impl_h
