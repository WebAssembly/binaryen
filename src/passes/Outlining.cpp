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
struct StringifyWalker : public Walker<StringifyWalker, Visitor<StringifyWalker>> {
  private:
    uint64_t monotonic = 0;
    std::vector<uint64_t> string;
    // Change key to Expression
    // [[maybe_unused]] std::unordered_map<Expression *, uint64_t> exprToCounter;
    [[maybe_unused]] std::unordered_map<uint64_t, uint64_t> exprToCounter;

  public:
  static void scan(StringifyWalker* self, Expression** currp) {
    [[maybe_unused]] Expression *curr = *currp;
    curr->dump();
    auto name = getExpressionName(curr);
    printf(name);
    printf("\n\n");

    switch (curr->_id) {
      // Control Flow Section
      // 1. hash control flow
      // 2. pushTask to scan expressions in the control flow
      case Expression::Id::BlockId: {
        auto *block = curr->dynCast<Block>();
        for (auto *&child : block->list) {
          self->pushTask(StringifyWalker::scan, &child);
        }
        self->pushTask(visitControlFlow, currp);
        break;
      }
      case Expression::Id::IfId: {
        auto *iff = curr->dynCast<If>();
        self->pushTask(StringifyWalker::scan, &iff->ifFalse);
        self->pushTask(StringifyWalker::scan, &iff->ifTrue);
        self->pushTask(StringifyWalker::scan, &iff->condition);
        self->pushTask(visitControlFlow, currp);
        break;
      }
      case Expression::Id::LoopId:
      case Expression::Id::TryId: {
        self->pushTask(visitControlFlow, currp);
        break;
      }
      case Expression::Id::DropId: {
        auto *drop = curr->dynCast<Drop>();
        self->pushTask(StringifyWalker::scan, &drop->value);
        break;
      }

      //
      case Expression::Id::BinaryId: {
        auto *binary = curr->dynCast<Binary>();
        self->pushTask(visitBinary, currp);
        self->pushTask(parent::scan, &binary->right);
        self->pushTask(StringifyWalker::scan, &binary->left);
        break;
      }

      // Values Section
      // 1. shallowHash single expression
      case Expression::Id::ConstId: {
        self->pushTask(visitConst, currp);
        break;
      }

      default: {
        std::cout << "In default\n";
        curr->dump();
      }
    }
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
      std::cout << "Collision on Expression: ";
      curr->dump();
    }
    exprToCounter[hash] = counter();
    advanceCounter();
    printString();
  }

  // Expression handling
  static void emitFunctionBegin(StringifyWalker *self) {
    self->insertGloballyUniqueChar();
  }

  static void visitControlFlow(StringifyWalker* self, Expression** currp) {
    std::cout << "in visitControlFlow" << std::endl;
    Expression *curr = *currp;
    [[maybe_unused]] uint64_t hashValue = hash(curr);
    self->insertHash(hashValue, curr);
  }

  static void visitBinary(StringifyWalker* self, Expression** currp) {
    std::cout << "in visitBinary" << std::endl;
    Expression *curr = *currp;
    uint64_t hashValue = hash(curr);
    self->insertHash(hashValue, curr);
  }

  static void visitConst(StringifyWalker* self, Expression** currp) {
    std::cout << "in visitConst" << std::endl;
    Expression *curr = *currp;
    uint64_t hashValue = hash(curr);
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

   ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
     stringify->emitFunctionBegin(stringify);
     stringify->walk(func->body);
   });
  }
};

Pass* createOutliningPass() { return new Outlining(); }

}
