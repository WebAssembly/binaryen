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
struct StringifyWalker : public PostWalker<StringifyWalker, Visitor<StringifyWalker>> {
  private:
    uint64_t monotonic = 0;
    std::vector<uint64_t> string;
    // Change key to Expression
    // [[maybe_unused]] std::unordered_map<Expression *, uint64_t> exprToCounter;
    [[maybe_unused]] std::unordered_map<uint64_t, uint64_t> exprToCounter;

  public:
  static void scan(StringifyWalker* self, Expression** currp) {
    Expression *curr = *currp;
    auto name = getExpressionName(curr);
    std::cout << "StringifyWalker::scan() on: " << name << std::endl;
    curr->dump();
    printf("\n\n");

    /*switch (curr->_id) {
      case Expression::Id::BlockId: {
        self->pushTask(visitControlFlow, currp);
        break;
      }
      case Expression::Id::IfId: {
        self->pushTask(visitControlFlow, currp);
        break;
      }
      case Expression::Id::LoopId:{
        self->pushTask(visitControlFlow, currp);
        break;
      }
      case Expression::Id::TryId: {
        self->pushTask(visitControlFlow, currp);
        break;
      }
      default: {
      }
    }

    PostWalker<StringifyWalker, Visitor>::scan(self, currp);*/
  }

  // Take out all the non-control flow
  // Call parent::scan
  // need to maintain a queue of control flow nodes whose body you haven't
  // scanned yet and when the task stack is empty, then you would pop something
  // off and scan some more. And when you're done, scanning it, take something
  // from the queue.
  // normal walkers would stop if the stack is empty. you need to not stop if
  // you're stack & queue is empty
  // when the task stack is empty, at the very beginning, it might be a good
  // idea to push a task onto it, where the task dequeues from the control flow
  // queue, so the task stack never actually becomes empty. Then the normal
  // walker logic will continue working. The first thing in the task stack
  // should re-insert itself and then dequeue the control flow structure, as
  // long as there is another control flow dequeue.

  // Counter handling
  // accessor pattern, remove
  uint64_t counter() {
    return monotonic;
  }

  void advanceCounter() {
    monotonic++;
  }

  void insertGloballyUniqueChar() {
    printf("inserting globally unique char\n");
    string.push_back(counter());
    advanceCounter();
    printString();
  }

  // Will be replaced by insertExpression
  // void insertExpression(Expression *curr) {
  void insertHash(uint64_t hash, Expression *curr) {
    string.push_back(counter());
    auto it = exprToCounter.find(counter());
    if (it != exprToCounter.end()) {
      auto name = getExpressionName(curr);
      std::cout << "Collision on Expression: " << name << std::endl;
      curr->dump();
    }
    exprToCounter[hash] = counter();
    advanceCounter();
    printString();
  }

  // Expression handling
  static void emitFunctionBegin(StringifyWalker *self) {
    printf("emit function begin\n");
    self->insertGloballyUniqueChar();
  }

  static void visitControlFlow(StringifyWalker* self, Expression** currp) {
    std::cout << "in visitControlFlow" << std::endl;
    Expression *curr = *currp;
    [[maybe_unused]] uint64_t hashValue = hash(curr);
    self->insertHash(hashValue, curr);
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

   int counter = 1;
   ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
     if (counter == 1) {
      stringify->emitFunctionBegin(stringify);
     stringify->walk(func->body);
     }
     counter+=1;
   });
  }
};

Pass* createOutliningPass() { return new Outlining(); }

}
