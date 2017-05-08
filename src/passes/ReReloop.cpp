/*
 * Copyright 2017 WebAssembly Community Group participants
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

//
// Convert the AST to a CFG, and optimize+convert it back to the AST
// using the relooper.
//
// This pass depends on flatten-control-flow being run before it.
//

#include <memory>

#include "wasm.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "cfg/Relooper.h"

namespace wasm {

struct ReReloop : public Pass {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new ReReloop; }

  Relooper relooper;
  std::unique_ptr<Builder> builder;

  // block handling

  CFG::Block* currCFGBlock;

  CFG::Block* makeCFGBlock() {
    return new CFG::Block(builder->makeBlock());
  }

  CFG::Block* startCFGBlock() {
    return currCFGBlock = makeCFGBlock();
  }

  Block* getCurrBlock() {
    return currCFGBlock->Code->cast<Block>();
  }

  void finishBlock() {
    getCurrBlock()->finalize();
  }

  // break handling

  std::map<Name, CFG::Block*> breakTargets;

  void addBreakTarget(Name name, CFG::Block* target) {
    breakTargets[name] = target;
  }

  // branch handling

  void addBranch(CFG::Block* from, CFG::Block* to, Expression* condition = nullptr) {
    // XXX handle more than one branch from A to B, need to merge them?
    from->AddBranchTo(to, condition);
  }

  // we work using a stack of control flow tasks

  struct Task {
    ReReloop& parent;
    Task(ReReloop& parent) : parent(parent) {}
    virtual void run() {
      WASM_UNREACHABLE();
    }
  };

  typedef std::shared_ptr<Task> TaskPtr;
  std::vector<TaskPtr> stack;

  struct BlockTask : public Task {
    Block* curr;
    CFG::Block* later;
    BlockTask(ReReloop& parent, Block* curr) : Task(parent), curr(curr) {
      auto& list = curr->list;
      for (int i = int(list.size()) - 1; i >= 0; i--) {
        parent.stack.push_back(list[i]);
      }
      if (curr->name.is()) {
        // we may be branched to. create a target, and
        // ensure we are called at the join point 
        later = parent.makeCFGBlock();
        parent.addBreakTarget(curr->name, later);
        parent.stack.push_back(new BlockTask(*this));
      }
    }

    void run() override {
      // add fallthrough
      parent.addBranchTo(parent.getCurrCFGBlock(), later);
    }
  };

  struct LoopTask : public Task {
    Loop* curr;
    LoopTask(ReReloop& parent, Loop* curr) : Task(parent), curr(curr) {
      parent.stack.push_back(curr->body);
      if (curr->name.is()) {
        // we may be branched to. create a target
        auto* before = parent.getCurrCFGBlock();
        auto* top = parent.startCFGBlock();
        parent.addBreakTarget(curr->name, top);
        parent.addBranchTo(before, top);
      }
    }
  };

  struct IfTask : public Task {
    If* curr;
CFG::Block* later;
    int phase = 0;
    BlockTask(ReReloop& parent, If* curr) : Task(parent), curr(curr) {
      TaskPtr task = new IfTask(*this);
      if (curr->ifFalse) {
        parent.stack.push_back(task);
        parent.stack.push_back(curr->ifFalse);
      }
      parent.stack.push_back(task);
      parent.stack.push_back(curr->ifTrue);
      parent.stack.push_back(task);
      parent.stack.push_back(curr->condition);
        later = parent.makeCFGBlock();
        parent.addBreakTarget(curr->name, later);
        parent.stack.push_back(new BlockTask(this));
      }
    }

    void run() override {
      if (phase == 0) {
        // after the condition
      // add fallthrough
      parent.addBranchTo(parent.getCurrCFGBlock(), later);
    }
  };

  // handle an element we encounter

  void handleElement(Expression* curr) {
    if (auto* block = curr->dynCast<Block>()) {
      BlockTask(*this, block);
    } else if (auto* loop = curr->dynCast<Loop>()) {
      LoopTask(*this, loop);
    } else if (auto* iff = curr->dynCast<If>()) {
      IfTask(*this, iff);
    } else
br, br_table, return, unreachable
    } else {
      // not control flow, so just a simple element
      getCurrBlock()->list.push_back(curr);
    }
  }

  void runFunction(PassRunner* runner, Module* module, Function* function) override {
    // since control flow is flattened, this is pretty simple
    // first, traverse the function body. note how we don't need to traverse
    // into expressions, as we know they contain no control flow
    builder = make_unique<Builder>(*module);
    currCFGBlock = makeCFGBlock();
    stack.push_back(function->body);
    // main loop
    while (stack.size() > 0) {
      auto* curr = stack.back();
      stack.pop_back();
      handleElement(curr);
    }
    // finish the current block
    ..
    // run the relooper to recreate control flow
    ..
  }
};

Pass *createReReloopPass() {
  return new ReReloop();
}

} // namespace wasm

