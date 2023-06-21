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

// This pass is a placeholder, encapsulating a suffix tree data structure that
// will eventually be moved to src/support

#include "ir/module-utils.h"
#include "ir/names.h"
#include "pass.h"
#include "src/ir/utils.h"
#include "stringify-walker.h"
#include "wasm-builder.h"
#include "wasm-stack.h"
#include "wasm.h"

namespace wasm {

template <typename SubType>
void StringifyWalker<SubType>::walkModule(SubType *self, Module* module) {
  self->wasm = module;
  self->pushTask(StringifyWalker::handler, nullptr);
  ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
    self->functionDidBegin(self);
    self->walk(func->body);
  });
}

template <typename SubType>
void StringifyWalker<SubType>::deferredScan(SubType* stringify,
                                   Expression** currp) {
  Expression* curr = *currp;
  switch (curr->_id) {
    case Expression::Id::BlockId: {
      auto* block = curr->dynCast<Block>();
      auto blockIterator = block->list.end();
      while (blockIterator != block->list.begin()) {
        blockIterator--;
        auto& child = block->list[blockIterator.index];
        [[maybe_unused]] auto name = getExpressionName(child);
        // std::cout << "Pushing a task to call StringifyWalker::scan with block
        // list item: " << name  << " " << child << std::endl;
        stringify->pushTask(StringifyWalker::scan, &child);
      }
      break;
    }
    case Expression::Id::IfId: {
      auto* iff = curr->dynCast<If>();
      stringify->pushTask(StringifyWalker::scan, &iff->ifFalse);
      // std::cout << "Pushing an task to call StingifyWalker::scan on ifFalse "
      // << std::endl;
      stringify->pushTask(StringifyWalker::scan, &iff->ifTrue);
      // std::cout << "Pushing an task to call StingifyWalker::scan on ifTrue "
      // << std::endl;
      stringify->pushTask(StringifyWalker::scan, &iff->condition);
      // std::cout << "Pushing an task to call StingifyWalker::scan on
      // ifCondition " << std::endl;
      break;
    }
    case Expression::Id::TryId: {
      auto* tryy = curr->dynCast<Try>();
      auto blockIterator = tryy->catchBodies.end();
      while (blockIterator != tryy->catchBodies.begin()) {
        blockIterator--;
        auto& child = tryy->catchBodies[blockIterator.index];
        [[maybe_unused]] auto name = getExpressionName(child);
        // std::cout << "Pushing a task to call StringifyWalker::scan with try
        // catchBody: " << name  << " " << child << std::endl;
        stringify->pushTask(StringifyWalker::scan, &child);
      }
      stringify->pushTask(StringifyWalker::scan, &tryy->body);
      break;
    }
    case Expression::Id::LoopId: {
      auto* loop = curr->dynCast<Loop>();
      stringify->pushTask(StringifyWalker::scan, &loop->body);
      break;
    }
    default: {
      auto name = getExpressionName(*currp);
      std::cout << "scanChildren reached an unimplemented expression: " << name
                << std::endl;
    }
  }
}

template <typename SubType>
void StringifyWalker<SubType>::handler(SubType* self, Expression**) {
  if (self->queue.empty()) {
    return;
  }

  auto& queue = self->queue;
  self->pushTask(StringifyWalker::handler, nullptr);
  Expression** currp = queue.front();
  queue.pop();
  [[maybe_unused]] auto name = getExpressionName(*currp);
  StringifyWalker<SubType>::deferredScan(self, currp);
}

template <typename SubType>
void StringifyWalker<SubType>::scan(SubType* self, Expression** currp) {
  Expression* curr = *currp;
  [[maybe_unused]] auto name = getExpressionName(curr);
  // std::cout << "StringifyWalker::scan() on: " << name << std::endl;
  // curr->dump();

  switch (curr->_id) {
    case Expression::Id::BlockId:
    case Expression::Id::IfId:
    case Expression::Id::LoopId:
    case Expression::Id::TryId: {
      self->visitControlFlow(self, currp);
      // std::cout << "Adding " << name << " to queue" << std::endl;
      self->queue.push(currp);
      break;
    }
    default: {
      // std::cout << "Calling PostWalker::scan" << std::endl;
      PostWalker<SubType>::scan(self, currp);
    }
  }


}


template <typename SubType>
void StringifyWalker<SubType>::visitControlFlow(SubType* self,
                                       Expression** currp) {
  self->visitControlFlow(self, currp);
}

template <typename SubType>
void StringifyWalker<SubType>::visitExpression(Expression* curr) {
  if (!Properties::isControlFlowStructure(curr)) {
    static_cast<SubType*>(this)->visitExpression(curr);
  }
}

void HashStringifyWalker::walkModule(Module* module) {
  StringifyWalker::walkModule(this, module);
}

void HashStringifyWalker::functionDidBegin(HashStringifyWalker* self){
  // self->appendGloballyUniqueChar();
}

void HashStringifyWalker::visitExpression(Expression* curr) {
  // uint64_t hash = ExpressionAnalyzer::shallowHash(curr);
  // std::cout << "hash: " << (unsigned)hash << std::endl;
  // this->insertHash(hash, curr);
}

void HashStringifyWalker::appendGloballyUniqueChar() {
  // printf("inserting globally unique char\n");
  string.push_back(monotonic);
  monotonic++;
}

// Will be replaced by insertExpression
// void insertExpression(Expression *curr)
void HashStringifyWalker::appendExpressionHash(Expression* curr, uint64_t hash) {
  string.push_back(monotonic);
  auto it = exprToCounter.find(monotonic);
  if (it != exprToCounter.end()) {
    [[maybe_unused]] auto name = getExpressionName(curr);
    // std::cout << "Collision on Expression: " << name << std::endl;
    curr->dump();
  }
  // auto name = getExpressionName(curr);
  // std::cout << "monotonic: " << (unsigned)monotonic << std::endl;
  exprToCounter[hash] = monotonic;
  monotonic++;
}

void HashStringifyWalker::visitControlFlow(HashStringifyWalker* self,
                                       Expression** currp) {
  [[maybe_unused]] Expression* curr = *currp;
  // uint64_t hashValue = hash(curr);
  // self->insertHash(hashValue, curr);
}

TestStringifyWalker::TestStringifyWalker(std::ostream& os) : os(os) {};

void TestStringifyWalker::walkModule(Module* module) {
  StringifyWalker::walkModule(this, module);
}

void TestStringifyWalker::functionDidBegin(TestStringifyWalker* self) {
  self->os << "append function begin\n";
}

void TestStringifyWalker::visitControlFlow(TestStringifyWalker* self,
                                       Expression** currp) {
  [[maybe_unused]] Expression* curr = *currp;
  self->os << "in visitControlFlow with " << ShallowExpression{curr, self->wasm} << std::endl;
}

void TestStringifyWalker::visitExpression(Expression* curr) {
  this->os << "in visitExpression for " << ShallowExpression{curr, this->wasm} << std::endl;
}

struct Outlining : public Pass {

  void run(Module* module) override {
    std::stringstream ss;
    TestStringifyWalker stringify = TestStringifyWalker(ss);
    stringify.walkModule(module);
    std::cout << ss.str();
    printf("Outlining is done\n");
  }
};

Pass* createOutliningPass() { return new Outlining(); }

} // namespace wasm
