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
 * 2:   (i32.add
 * 3:     (i32.const 20)
 * 4:     (i32.const 10))
 * 5:   (if
 * 6:     (i32.const 0)
 * 7:     (then (return (i32.const 1)))
 * 8:     (else (return (i32.const 0)))
 * 9:   )
 *
 * Would have it's expressions visited in the following order (based on line
 * number):
 * 1, 3, 4, 2, 6, 5, 7, 8
 *
 * Of note:
 *   - The add (line 2) binary operator's left and right children are visited first
 *     as they need to be on the stack before the add operation is executed
 *   - The if-condition (i32.const 0) on line 6 is visited before the if expression
 */
template<typename SubType>
void StringifyWalker<SubType>::walkModule(SubType* self, Module* module) {
  self->wasm = module;
  ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
    /*
     * The ordering of the below lines of code are important. On each function
     * iteration, we:
     * 1. push a task for calling the handler function, to ensure that each
     *    function has an opportunity to dequeue from StringifyWalker's
     *    internally managed queue. This queue exists to provide a way for
     *    control flow to defer scanning their children.
     * 2. push a task for adding a unique symbol, so that after the function
     *    body is visited as a single expression, there is a a separator between
     *    the symbol for the entire function and the symbol for the function's
     *    children
     * 3. then we call walk, which will visit the function body as a single unit
     * 4. finally we call addUniqueSymbol directly to ensure the string encoding
     *    for each function is terminated with a unique symbol, acting as a
     *    separator between each function in the program string
     */
    self->pushTask(StringifyWalker::handler, nullptr);
    self->pushTask(StringifyWalker::addUniqueSymbol, &func->body);
    self->walk(func->body);
    self->addUniqueSymbol(self, &func->body);
  });
}

/*
 * This handler is responsibe for ensuring the children expressions of control
 * flow expressions are visited after the control flow expression has already
 * been visited. In order to perform this responsibility, the handler function
 * needs to always be the very last task in the Walker stack, as the last task
 * will be executed last. This why if the queue is not empty, the first
 * statement pushes a new task to visit the handler again.
 *
 */
template<typename SubType>
void StringifyWalker<SubType>::handler(SubType* self, Expression**) {
  auto& queue = self->queue;
  if (queue.empty()) {
    return;
  }

  self->pushTask(StringifyWalker::handler, nullptr);
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
      auto* block = curr->dynCast<Block>();
      if (block->list.size() > 0) {
        stringify->pushTask(StringifyWalker::addUniqueSymbol, currp);
      }
      auto blockIterator = block->list.end();
      while (blockIterator != block->list.begin()) {
        blockIterator--;
        auto& child = block->list[blockIterator.index];
        stringify->pushTask(StringifyWalker::scan, &child);
      }
      break;
    }
    case Expression::Id::IfId: {
      auto* iff = curr->dynCast<If>();
      stringify->pushTask(StringifyWalker::addUniqueSymbol, &iff->ifFalse);
      stringify->pushTask(StringifyWalker::scan, &iff->ifFalse);
      stringify->pushTask(StringifyWalker::addUniqueSymbol, &iff->ifTrue);
      stringify->pushTask(StringifyWalker::scan, &iff->ifTrue);
      break;
    }
    case Expression::Id::TryId: {
      auto* tryy = curr->dynCast<Try>();
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
      auto* loop = curr->dynCast<Loop>();
      stringify->pushTask(StringifyWalker::addUniqueSymbol, currp);
      stringify->pushTask(StringifyWalker::scan, &loop->body);
      break;
    }
    default: {
      assert(Properties::isControlFlowStructure(curr));
      auto name = getExpressionName(*currp);
      std::cout
        << "deferredScan reached an unimplemented control flow expression: "
        << name << std::endl;
    }
  }
}

template<typename SubType>
void StringifyWalker<SubType>::scan(SubType* self, Expression** currp) {
  Expression* curr = *currp;
  if (curr->_id == Expression::Id::BlockId || curr->_id == Expression::LoopId ||
      curr->_id == Expression::TryId || curr->_id == Expression::IfId) {
    self->pushTask(StringifyWalker::doVisitExpression, currp);
    self->queue.push(currp);
  }

  if (curr->_id == Expression::IfId) {
    auto* iff = curr->dynCast<If>();
    PostWalker<SubType>::scan(self, &iff->condition);
    return;
  }

  if (!Properties::isControlFlowStructure(curr)) {
    PostWalker<SubType>::scan(self, currp);
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

void HashStringifyWalker::walkModule(Module* module) {
  StringifyWalker::walkModule(this, module);
}

void HashStringifyWalker::addUniqueSymbol(HashStringifyWalker* self,
                                          Expression** currp) {
  // string.push_back(monotonic);
  // monotonic++;
}

// Will be replaced by insertExpression
// void insertExpression(Expression *curr)
void HashStringifyWalker::addExpressionHash(Expression* curr, uint64_t hash) {
  /*string.push_back(monotonic);
  auto it = exprToCounter.find(monotonic);
  if (it != exprToCounter.end()) {
    auto name = getExpressionName(curr);
    // std::cout << "Collision on Expression: " << name << std::endl;
    curr->dump();
  }
  auto name = getExpressionName(curr);
  std::cout << "monotonic: " << (unsigned)monotonic << std::endl;
  exprToCounter[hash] = monotonic;
  monotonic++;*/
}

void HashStringifyWalker::visitExpression(Expression* curr) {
  if (Properties::isControlFlowStructure(curr)) {
    // Expression* curr = *currp;
    // uint64_t hashValue = hash(curr);
    // self->insertHash(hashValue, curr);
  } else {
    // uint64_t hash = ExpressionAnalyzer::shallowHash(curr);
    // std::cout << "hash: " << (unsigned)hash << std::endl;
    // this->insertHash(hash, curr);
  }
}

TestStringifyWalker::TestStringifyWalker(std::ostream& os) : os(os){};

void TestStringifyWalker::walkModule(Module* module) {
  StringifyWalker::walkModule(this, module);
}

void TestStringifyWalker::addUniqueSymbol(TestStringifyWalker* self,
                                          Expression** currp) {
  self->os << "adding unique symbol\n";
}

void TestStringifyWalker::visitExpression(Expression* curr) {
  if (Properties::isControlFlowStructure(curr)) {
    this->os << "in visitExpression with CF "
             << ShallowExpression{curr, this->wasm} << std::endl;
  } else {
    this->os << "in visitExpression for " << ShallowExpression{curr, this->wasm}
             << std::endl;
  }
}

struct Outlining : public Pass {

  void run(Module* module) override {
    std::stringstream ss;
    TestStringifyWalker stringify = TestStringifyWalker(ss);
    stringify.walkModule(module);
    std::cout << ss.str();
  }
};

Pass* createOutliningPass() { return new Outlining(); }

} // namespace wasm
