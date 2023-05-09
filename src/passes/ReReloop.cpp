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
// This pass depends on flatten being run before it.
//

#include <memory>

#include "cfg/Relooper.h"
#include "ir/flat.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

struct ReReloop final : public Pass {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<ReReloop>();
  }

  std::unique_ptr<CFG::Relooper> relooper;
  std::unique_ptr<Builder> builder;

  // block handling

  CFG::Block* currCFGBlock = nullptr;

  CFG::Block* makeCFGBlock() {
    return relooper->AddBlock(builder->makeBlock());
  }

  CFG::Block* setCurrCFGBlock(CFG::Block* curr) {
    if (currCFGBlock) {
      finishBlock();
    }
    return currCFGBlock = curr;
  }

  CFG::Block* startCFGBlock() { return setCurrCFGBlock(makeCFGBlock()); }

  CFG::Block* getCurrCFGBlock() { return currCFGBlock; }

  Block* getCurrBlock() { return currCFGBlock->Code->cast<Block>(); }

  void finishBlock() { getCurrBlock()->finalize(); }

  // break handling

  std::map<Name, CFG::Block*> breakTargets;

  void addBreakTarget(Name name, CFG::Block* target) {
    breakTargets[name] = target;
  }

  CFG::Block* getBreakTarget(Name name) { return breakTargets[name]; }

  // branch handling

  void
  addBranch(CFG::Block* from, CFG::Block* to, Expression* condition = nullptr) {
    from->AddBranchTo(to, condition);
  }

  void addSwitchBranch(CFG::Block* from,
                       CFG::Block* to,
                       const std::set<Index>& values) {
    std::vector<Index> list;
    for (auto i : values) {
      list.push_back(i);
    }
    from->AddSwitchBranchTo(to, std::move(list));
  }

  // we work using a stack of control flow tasks

  struct Task {
    virtual ~Task() = default;
    ReReloop& parent;
    Task(ReReloop& parent) : parent(parent) {}
    virtual void run() { WASM_UNREACHABLE("unimpl"); }
  };

  using TaskPtr = std::shared_ptr<Task>;
  std::vector<TaskPtr> stack;

  struct TriageTask final : public Task {
    Expression* curr;

    TriageTask(ReReloop& parent, Expression* curr) : Task(parent), curr(curr) {}

    void run() override { parent.triage(curr); }
  };

  struct BlockTask final : public Task {
    Block* curr;
    CFG::Block* later;

    BlockTask(ReReloop& parent, Block* curr) : Task(parent), curr(curr) {}

    static void handle(ReReloop& parent, Block* curr) {
      if (curr->name.is()) {
        // we may be branched to. create a target, and
        // ensure we are called at the join point
        auto task = std::make_shared<BlockTask>(parent, curr);
        task->curr = curr;
        task->later = parent.makeCFGBlock();
        parent.addBreakTarget(curr->name, task->later);
        parent.stack.push_back(task);
      }
      auto& list = curr->list;
      for (int i = int(list.size()) - 1; i >= 0; i--) {
        parent.stack.push_back(std::make_shared<TriageTask>(parent, list[i]));
      }
    }

    void run() override {
      // add fallthrough
      parent.addBranch(parent.getCurrCFGBlock(), later);
      parent.setCurrCFGBlock(later);
    }
  };

  struct LoopTask final : public Task {
    static void handle(ReReloop& parent, Loop* curr) {
      parent.stack.push_back(std::make_shared<TriageTask>(parent, curr->body));
      if (curr->name.is()) {
        // we may be branched to. create a target
        auto* before = parent.getCurrCFGBlock();
        auto* top = parent.startCFGBlock();
        parent.addBreakTarget(curr->name, top);
        parent.addBranch(before, top);
      }
    }
  };

  struct IfTask final : public Task {
    If* curr;
    CFG::Block* condition;
    CFG::Block* ifTrueEnd;
    int phase = 0;

    IfTask(ReReloop& parent, If* curr) : Task(parent), curr(curr) {}

    static void handle(ReReloop& parent, If* curr) {
      auto task = std::make_shared<IfTask>(parent, curr);
      task->curr = curr;
      task->condition = parent.getCurrCFGBlock();
      auto* ifTrueBegin = parent.startCFGBlock();
      parent.addBranch(task->condition, ifTrueBegin, curr->condition);
      if (curr->ifFalse) {
        parent.stack.push_back(task);
        parent.stack.push_back(
          std::make_shared<TriageTask>(parent, curr->ifFalse));
      }
      parent.stack.push_back(task);
      parent.stack.push_back(
        std::make_shared<TriageTask>(parent, curr->ifTrue));
    }

    void run() override {
      if (phase == 0) {
        // end of ifTrue
        ifTrueEnd = parent.getCurrCFGBlock();
        auto* after = parent.startCFGBlock();
        // if condition was false, go after the ifTrue, to ifFalse or outside
        parent.addBranch(condition, after);
        if (!curr->ifFalse) {
          parent.addBranch(ifTrueEnd, after);
        }
        phase++;
      } else if (phase == 1) {
        // end if ifFalse
        auto* ifFalseEnd = parent.getCurrCFGBlock();
        auto* after = parent.startCFGBlock();
        parent.addBranch(ifTrueEnd, after);
        parent.addBranch(ifFalseEnd, after);
      } else {
        WASM_UNREACHABLE("invalid phase");
      }
    }
  };

  struct BreakTask : public Task {
    static void handle(ReReloop& parent, Break* curr) {
      // add the branch. note how if the condition is false, it is the right
      // value there as well
      auto* before = parent.getCurrCFGBlock();
      parent.addBranch(
        before, parent.getBreakTarget(curr->name), curr->condition);
      if (curr->condition) {
        auto* after = parent.startCFGBlock();
        parent.addBranch(before, after);
      } else {
        parent.stopControlFlow();
      }
    }
  };

  struct SwitchTask : public Task {
    static void handle(ReReloop& parent, Switch* curr) {
      // set the switch condition for the block ending now
      auto* before = parent.getCurrCFGBlock();
      assert(!before->SwitchCondition);
      before->SwitchCondition = curr->condition;
      std::map<Name, std::set<Index>> targetValues;
      auto& targets = curr->targets;
      auto num = targets.size();
      for (Index i = 0; i < num; i++) {
        targetValues[targets[i]].insert(i);
      }
      for (auto& [name, indices] : targetValues) {
        parent.addSwitchBranch(before, parent.getBreakTarget(name), indices);
      }
      // the default may be among the targets, in which case, we can't add it
      // simply as it would be a duplicate, so create a temp block
      if (targetValues.count(curr->default_) == 0) {
        parent.addSwitchBranch(
          before, parent.getBreakTarget(curr->default_), std::set<Index>());
      } else {
        auto* temp = parent.startCFGBlock();
        parent.addSwitchBranch(before, temp, std::set<Index>());
        parent.addBranch(temp, parent.getBreakTarget(curr->default_));
      }
      parent.stopControlFlow();
    }
  };

  struct ReturnTask : public Task {
    static void handle(ReReloop& parent, Return* curr) {
      // reuse the return
      parent.getCurrBlock()->list.push_back(curr);
      parent.stopControlFlow();
    }
  };

  struct UnreachableTask : public Task {
    static void handle(ReReloop& parent, Unreachable* curr) {
      // reuse the unreachable
      parent.getCurrBlock()->list.push_back(curr);
      parent.stopControlFlow();
    }
  };

  // handle an element we encounter

  void triage(Expression* curr) {
    if (auto* block = curr->dynCast<Block>()) {
      BlockTask::handle(*this, block);
    } else if (auto* loop = curr->dynCast<Loop>()) {
      LoopTask::handle(*this, loop);
    } else if (auto* iff = curr->dynCast<If>()) {
      IfTask::handle(*this, iff);
    } else if (auto* br = curr->dynCast<Break>()) {
      BreakTask::handle(*this, br);
    } else if (auto* sw = curr->dynCast<Switch>()) {
      SwitchTask::handle(*this, sw);
    } else if (auto* ret = curr->dynCast<Return>()) {
      ReturnTask::handle(*this, ret);
    } else if (auto* un = curr->dynCast<Unreachable>()) {
      UnreachableTask::handle(*this, un);
    } else if (curr->is<Try>() || curr->is<Throw>() || curr->is<Rethrow>()) {
      Fatal() << "ReReloop does not support EH instructions yet";
    } else {
      // not control flow, so just a simple element
      getCurrBlock()->list.push_back(curr);
    }
  }

  void stopControlFlow() {
    startCFGBlock();
    // TODO: optimize with this?
  }

  void runOnFunction(Module* module, Function* function) override {
    Flat::verifyFlatness(function);

    // since control flow is flattened, this is pretty simple
    // first, traverse the function body. note how we don't need to traverse
    // into expressions, as we know they contain no control flow
    builder = std::make_unique<Builder>(*module);
    relooper = std::make_unique<CFG::Relooper>(module);
    auto* entry = startCFGBlock();
    stack.push_back(TaskPtr(new TriageTask(*this, function->body)));
    // main loop
    while (stack.size() > 0) {
      TaskPtr curr = stack.back();
      stack.pop_back();
      curr->run();
    }
    // finish the current block
    finishBlock();
    // blocks that do not have any exits are dead ends in the relooper. we need
    // to make sure that are in fact dead ends, and do not flow control
    // anywhere. add a return as needed
    for (auto& cfgBlock : relooper->Blocks) {
      auto* block = cfgBlock->Code->cast<Block>();
      if (cfgBlock->BranchesOut.empty() && block->type != Type::unreachable) {
        block->list.push_back(function->getResults() == Type::none
                                ? (Expression*)builder->makeReturn()
                                : (Expression*)builder->makeUnreachable());
        block->finalize();
      }
    }
#ifdef RERELOOP_DEBUG
    std::cout << "rerelooping " << function->name << '\n';
    for (auto* block : relooper->Blocks) {
      std::cout << block << " block:\n" << block->Code << '\n';
      for (auto& [target, branch] : block->BranchesOut) {
        std::cout << "branch to " << target << "\n";
        if (branch->Condition) {
          std::cout << "  with condition\n" << branch->Condition << '\n';
        }
      }
    }
#endif
    // run the relooper to recreate control flow
    relooper->Calculate(entry);
    // render
    {
      auto temp = builder->addVar(function, Type::i32);
      CFG::RelooperBuilder builder(*module, temp);
      function->body = relooper->Render(builder);
      // if the function has a result, and the relooper emitted
      // something that seems like it flows out without a value
      // (but that path is never reached; it just has a br to it
      // because of the relooper's boilerplate switch-handling
      // code, for example, which could be optimized out later
      // but isn't yet), then make sure it has a proper type
      if (function->getResults() != Type::none &&
          function->body->type == Type::none) {
        function->body =
          builder.makeSequence(function->body, builder.makeUnreachable());
      }
    }
    // TODO: should this be in the relooper itself?
    ReFinalize().walkFunctionInModule(function, module);
  }
};

Pass* createReReloopPass() { return new ReReloop(); }

} // namespace wasm
