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
#include "wasm-builder.h"
#include "pass.h"
#include "wasm-stack.h"
#include <wasm.h>
#include "ir/module-utils.h"
#include "src/ir/utils.h"
#include "stringify-walker.h"

namespace wasm {

void StringifyWalker::walkModule(Module *module) {
 this->pushTask(StringifyWalker::handler, nullptr);
 ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
   this->emitFunctionBegin(this);
    this->walk(func->body);
 });
}

void StringifyWalker::scanChildren(StringifyWalker *stringify, Expression **currp) {
  Expression *curr = *currp;
  switch (curr->_id) {
    case Expression::Id::BlockId: {
      auto *block = curr->dynCast<Block>();
      auto blockIterator = block->list.end();
      while (blockIterator != block->list.begin()) {
        blockIterator--;
        auto& child = block->list[blockIterator.index];
        [[maybe_unused]] auto name = getExpressionName(child);
        //std::cout << "Pushing a task to call StringifyWalker::scan with block list item: " << name  << " " << child << std::endl;
        stringify->pushTask(StringifyWalker::scan, &child);
      }
      break;
    }
    case Expression::Id::IfId: {
      auto *iff = curr->dynCast<If>();
      stringify->pushTask(StringifyWalker::scan, &iff->ifFalse);
      //std::cout << "Pushing an task to call StingifyWalker::scan on ifFalse " << std::endl;
      stringify->pushTask(StringifyWalker::scan, &iff->ifTrue);
      //std::cout << "Pushing an task to call StingifyWalker::scan on ifTrue " << std::endl;
      stringify->pushTask(StringifyWalker::scan, &iff->condition);
      //std::cout << "Pushing an task to call StingifyWalker::scan on ifCondition " << std::endl;
      break;
    }
    case Expression::Id::TryId: {
      auto *tryy = curr->dynCast<Try>();
      auto blockIterator = tryy->catchBodies.end();
      while (blockIterator != tryy->catchBodies.begin()) {
        blockIterator--;
        auto& child = tryy->catchBodies[blockIterator.index];
        [[maybe_unused]] auto name = getExpressionName(child);
        //std::cout << "Pushing a task to call StringifyWalker::scan with try catchBody: " << name  << " " << child << std::endl;
        stringify->pushTask(StringifyWalker::scan, &child);
      }
      stringify->pushTask(StringifyWalker::scan, &tryy->body);
      break;
    }
    case Expression::Id::LoopId: {
      auto *loop = curr->dynCast<Loop>();
      stringify->pushTask(StringifyWalker::scan, &loop->body);
      break;
    }
    default: {
      auto name = getExpressionName(*currp);
      std::cout << "scanChildren reached an unimplemented expression: " << name << std::endl;
    }
  }
}

void StringifyWalker::handler(StringifyWalker *stringify, Expression**) {
  //printf("In StringifyWalker::handler\n");
  auto& queue = stringify->queue;
  if (!queue.empty()) {
    stringify->pushTask(StringifyWalker::handler, nullptr);
    Expression **currp = queue.front();
    queue.pop();
    [[maybe_unused]] auto name = getExpressionName(*currp);
    //std::cout << "queue has an item, " << name << std::endl;
    StringifyWalker::scanChildren(stringify, currp);
  } else {
    //std::cout << "queue is empty" << std::endl;
  }
}

void StringifyWalker::scan(StringifyWalker* self, Expression** currp) {
  Expression *curr = *currp;
  [[maybe_unused]] auto name = getExpressionName(curr);
  //std::cout << "StringifyWalker::scan() on: " << name << std::endl;
  //curr->dump();

 switch (curr->_id) {
   case Expression::Id::BlockId:
   case Expression::Id::IfId:
   case Expression::Id::LoopId:
   case Expression::Id::TryId: {
      self->visitControlFlow(self, currp);
      //std::cout << "Adding " << name << " to queue" << std::endl;
      self->queue.push(currp);
      break;
    }
    default: {
      //std::cout << "Calling PostWalker::scan" << std::endl;
      PostWalker::scan(self, currp);
    }
  }
}

void StringifyWalker::insertGloballyUniqueChar() {
  //printf("inserting globally unique char\n");
  string.push_back(monotonic);
  monotonic++;
  printString();
}

  // Will be replaced by insertExpression
  // void insertExpression(Expression *curr)
void StringifyWalker::insertHash(uint64_t hash, Expression *curr) {
  string.push_back(monotonic);
  auto it = exprToCounter.find(monotonic);
  if (it != exprToCounter.end()) {
    [[maybe_unused]] auto name = getExpressionName(curr);
    //std::cout << "Collision on Expression: " << name << std::endl;
    curr->dump();
  }
    //auto name = getExpressionName(curr);
    //std::cout << "monotonic: " << (unsigned)monotonic << std::endl;
  exprToCounter[hash] = monotonic;
  monotonic++;
  printString();
}

  // Expression handling
void StringifyWalker::emitFunctionBegin(StringifyWalker *self) {
  printf("emit function begin\n");
  //self->insertGloballyUniqueChar();
}

void StringifyWalker::visitControlFlow(StringifyWalker* self, Expression** currp) {
  auto name = getExpressionName(*currp);
  std::cout << "in visitControlFlow with " << name << std::endl;
  [[maybe_unused]] Expression *curr = *currp;
  curr->dump();
  //uint64_t hashValue = hash(curr);
  //self->insertHash(hashValue, curr);
}

  // UnifiedExpressionVisitor
void StringifyWalker::visitExpression(Expression *curr) {
  std::cout << "in visitExpression";
  auto name = getExpressionName(curr);
  std::cout << " for " << name << std::endl;
  curr->dump();
  if (!Properties::isControlFlowStructure(curr)) {
    //uint64_t hash = ExpressionAnalyzer::shallowHash(curr);
    //std::cout << "hash: " << (unsigned)hash << std::endl;
    //this->insertHash(hash, curr);
  } else {
    //std::cout << "\n";
  }
}

  // Debug
void StringifyWalker::printString() {
  std::cout << "----printing string----" << std::endl;
  for (auto symbol : string) {
    std::cout << symbol << ", ";
  }
  std::cout << "\n\n";
}


struct Outlining : public Pass {

  void run(Module* module) override {
   printf("Hello from outlining!\n");

   StringifyWalker stringify = StringifyWalker();
   stringify.walkModule(module);
   printf("Outlining is done\n");
  }
};

Pass* createOutliningPass() { return new Outlining(); }

}
