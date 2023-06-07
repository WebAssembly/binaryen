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

namespace wasm {


// Generate an abstract string representation of the program
struct StringifyWalker : public PostWalker<StringifyWalker, UnifiedExpressionVisitor<StringifyWalker>> {

  struct QueueManager {
    std::queue<Expression **> queue;

    static void scanChildren(StringifyWalker *stringify, Expression **currp) {
      Expression *curr = *currp;
      switch (curr->_id) {
        case Expression::Id::BlockId: {
          auto *block = curr->dynCast<Block>();
          auto blockIterator = block->list.end();
          while (blockIterator != block->list.begin()) {
            blockIterator--;
            auto& child = block->list[blockIterator.index];
            [[maybe_unused]] auto name = getExpressionName(child);
            //std::cout << "Pushing a task to call StringifyWalker::scan with child: " << name  << " " << child << std::endl;
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
          auto *try = curr->dynCast<Try>();
          stringify->pushTask(StringifyWalker::scan, &try->body);
          break;
        }
        case Expression::Id::LoopId: {
          auto *loop = curr->dynCast<Loop>();
          stringify->pushTask(StringifyWalker::scan, &loop->body);
          break;
        }
        default: {
          auto name = getExpressionName(*currp);
          std::cout << "QueueManager reached an unimplemented expression: " << name << std::endl;
        }
      }
    }

    static void handler(StringifyWalker *stringify, Expression**) {
      //printf("In QueueManager::handler\n");
      auto& queue = stringify->queueManager->queue;
      if (!queue.empty()) {
        stringify->pushTask(StringifyWalker::QueueManager::handler, nullptr);
        Expression **currp = queue.front();
        queue.pop();
        [[maybe_unused]] auto name = getExpressionName(*currp);
        //std::cout << "QueueManager has an item, " << name << std::endl;
        QueueManager::scanChildren(stringify, currp);
      } else {
        //std::cout << "QueueManager's queue is empty" << std::endl;
      }
    }
  };

  private:
    uint64_t monotonic = 0;
    std::vector<uint64_t> string;
    // Change key to Expression
    // [[maybe_unused]] std::unordered_map<Expression *, uint64_t> exprToCounter;
    [[maybe_unused]] std::unordered_map<uint64_t, uint64_t> exprToCounter;
    QueueManager *queueManager;

  public:
  StringifyWalker() {
    queueManager = new QueueManager;
  }

  static void scan(StringifyWalker* self, Expression** currp) {
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
        //std::cout << "Adding " << name << " to queueManager's queue" << std::endl;
        self->queueManager->queue.push(currp);
        break;
      }
      default: {
        //std::cout << "Calling PostWalker::scan" << std::endl;
        PostWalker::scan(self, currp);
      }
    }
  }

  void insertGloballyUniqueChar() {
    //printf("inserting globally unique char\n");
    string.push_back(monotonic);
    monotonic++;
    printString();
  }

  // Will be replaced by insertExpression
  // void insertExpression(Expression *curr) {
  void insertHash(uint64_t hash, Expression *curr) {
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
  static void emitFunctionBegin(StringifyWalker *self) {
    printf("emit function begin\n");
    //self->insertGloballyUniqueChar();
  }

  static void visitControlFlow(StringifyWalker* self, Expression** currp) {
    auto name = getExpressionName(*currp);
    std::cout << "in visitControlFlow with " << name << std::endl;
    [[maybe_unused]] Expression *curr = *currp;
    curr->dump();
    //uint64_t hashValue = hash(curr);
    //self->insertHash(hashValue, curr);
  }

  // UnifiedExpressionVisitor
  void visitExpression(Expression *curr) {
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
  void printString() {
    std::cout << "----printing string----" << std::endl;
    for (auto symbol : string) {
      std::cout << symbol << ", ";
    }
    std::cout << "\n\n";
  }
};


struct Outlining : public Pass {

  void run(Module* module) override {
   printf("Hello from outlining!\n");

   StringifyWalker *stringify = new StringifyWalker();
   // pushTask asserts the second parameter is not nil usually, so I commented
   stringify->pushTask(StringifyWalker::QueueManager::handler, nullptr);

   ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
      stringify->emitFunctionBegin(stringify);
      stringify->walk(func->body);
   });
  }
};

Pass* createOutliningPass() { return new Outlining(); }

}
