/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Convert the AST to a CFG, while traversing it.
//
// Note that this is not the same as the relooper CFG. The relooper is
// designed for compilation to an AST, this is for processing. There is
// no built-in support for transforming this CFG into the AST back
// again, it is just metadata on the side for computation purposes.
//
// Usage: As the traversal proceeds, you can note information and add it to
// the current basic block using currBasicBlock, on the contents
// property, whose type is user-defined.
//

#ifndef cfg_traversal_h
#define cfg_traversal_h

#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

template<typename SubType, typename VisitorType, typename Contents>
struct CFGWalker : public ControlFlowWalker<SubType, VisitorType> {

  // public interface

  struct BasicBlock {
    Contents contents; // custom contents
    std::vector<BasicBlock*> out, in;
  };

  BasicBlock* entry; // the entry block

  // override this with code to create a BasicBlock if necessary
  BasicBlock* makeBasicBlock() { return new BasicBlock(); }

  // internal details

  std::vector<std::unique_ptr<BasicBlock>> basicBlocks; // all the blocks
  // blocks that are the tops of loops, i.e., have backedges to them
  std::vector<BasicBlock*> loopTops;

  // traversal state
  // the current block in play during traversal. can be nullptr if unreachable,
  // but note that we don't do a deep unreachability analysis - just enough to
  // avoid constructing obviously-unreachable blocks (we do a full reachability
  // analysis on the CFG once it is constructed).
  BasicBlock* currBasicBlock;
  // a block or loop => its branches
  std::map<Expression*, std::vector<BasicBlock*>> branches;
  // stack of the last blocks of if conditions + the last blocks of if true
  // bodies
  std::vector<BasicBlock*> ifStack;
  // stack of the first blocks of loops
  std::vector<BasicBlock*> loopStack;

  // stack of the last blocks of try bodies
  std::vector<BasicBlock*> tryStack;
  // stack of the first blocks of catches that throwing instructions should
  // unwind to at any moment. Because there can be multiple catch blocks for a
  // try, we maintain a vector of first blocks of catches.
  std::vector<std::vector<BasicBlock*>> unwindCatchStack;
  // stack of 'Try' expressions corresponding to unwindCatchStack.
  std::vector<Expression*> unwindExprStack;
  // A stack for each try, where each entry is a list of blocks, one for each
  // catch, used during processing. We start by assigning the start blocks to
  // here, and then read those at the appropriate time; when we finish a catch
  // we write to here the end block, so that when we finish with them all we can
  // connect the ends to the outside. In principle two vectors could be used,
  // but their usage does not overlap in time, and this is more efficient.
  std::vector<std::vector<BasicBlock*>> processCatchStack;

  BasicBlock* startBasicBlock() {
    currBasicBlock = ((SubType*)this)->makeBasicBlock();
    basicBlocks.push_back(std::unique_ptr<BasicBlock>(currBasicBlock));
    return currBasicBlock;
  }

  void startUnreachableBlock() { currBasicBlock = nullptr; }

  static void doStartUnreachableBlock(SubType* self, Expression** currp) {
    self->startUnreachableBlock();
  }

  void link(BasicBlock* from, BasicBlock* to) {
    if (!from || !to) {
      return; // if one of them is not reachable, ignore
    }
    from->out.push_back(to);
    to->in.push_back(from);
  }

  static void doEndBlock(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Block>();
    if (!curr->name.is()) {
      return;
    }
    auto iter = self->branches.find(curr);
    if (iter == self->branches.end()) {
      return;
    }
    auto& origins = iter->second;
    if (origins.size() == 0) {
      return;
    }
    // we have branches to here, so we need a new block
    auto* last = self->currBasicBlock;
    self->startBasicBlock();
    self->link(last, self->currBasicBlock); // fallthrough
    // branches to the new one
    for (auto* origin : origins) {
      self->link(origin, self->currBasicBlock);
    }
    self->branches.erase(curr);
  }

  static void doStartIfTrue(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    self->link(last, self->startBasicBlock()); // ifTrue
    self->ifStack.push_back(last);          // the block before the ifTrue
  }

  static void doStartIfFalse(SubType* self, Expression** currp) {
    self->ifStack.push_back(self->currBasicBlock); // the ifTrue fallthrough
    self->link(self->ifStack[self->ifStack.size() - 2],
               self->startBasicBlock()); // before if -> ifFalse
  }

  static void doEndIf(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    self->startBasicBlock();
    // last one is ifFalse's fallthrough if there was one, otherwise it's the
    // ifTrue fallthrough
    self->link(last, self->currBasicBlock);
    if ((*currp)->cast<If>()->ifFalse) {
      // we just linked ifFalse, need to link ifTrue to the end
      self->link(self->ifStack.back(), self->currBasicBlock);
      self->ifStack.pop_back();
    } else {
      // no ifFalse, so add a fallthrough for if the if is not taken
      self->link(self->ifStack.back(), self->currBasicBlock);
    }
    self->ifStack.pop_back();
  }

  static void doStartLoop(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    self->startBasicBlock();
    // a loop with no backedges would still be counted here, but oh well
    self->loopTops.push_back(self->currBasicBlock);
    self->link(last, self->currBasicBlock);
    self->loopStack.push_back(self->currBasicBlock);
  }

  static void doEndLoop(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    self->link(last, self->startBasicBlock()); // fallthrough
    auto* curr = (*currp)->cast<Loop>();
    // branches to the top of the loop
    if (curr->name.is()) {
      auto* loopStart = self->loopStack.back();
      auto& origins = self->branches[curr];
      for (auto* origin : origins) {
        self->link(origin, loopStart);
      }
      self->branches.erase(curr);
    }
    self->loopStack.pop_back();
  }

  static void doEndBreak(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Break>();
    self->branches[self->findBreakTarget(curr->name)].push_back(
      self->currBasicBlock); // branch to the target
    if (curr->condition) {
      auto* last = self->currBasicBlock;
      self->link(last, self->startBasicBlock()); // we might fall through
    } else {
      self->startUnreachableBlock();
    }
  }

  static void doEndSwitch(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Switch>();
    // we might see the same label more than once; do not spam branches
    std::set<Name> seen;
    for (Name target : curr->targets) {
      if (!seen.count(target)) {
        self->branches[self->findBreakTarget(target)].push_back(
          self->currBasicBlock); // branch to the target
        seen.insert(target);
      }
    }
    if (!seen.count(curr->default_)) {
      self->branches[self->findBreakTarget(curr->default_)].push_back(
        self->currBasicBlock); // branch to the target
    }
    self->startUnreachableBlock();
  }

  static void doEndThrowingInst(SubType* self, Expression** currp) {
    // Even if the instruction can possibly throw, we don't end the current
    // basic block unless the instruction is within a try-catch, because the CFG
    // will have too many blocks that way, and if an exception is thrown, the
    // function will be exited anyway.
    if (self->unwindCatchStack.empty()) {
      return;
    }

    // Exception thrown. Create a link to each catch within the innermost try.
    for (auto* block : self->unwindCatchStack.back()) {
      self->link(self->currBasicBlock, block);
    }
    // If the innermost try does not have a catch_all clause, an exception
    // thrown can be caught by any of its outer catch block. And if that outer
    // try-catch also does not have a catch_all, this continues until we
    // encounter a try-catch_all. Create a link to all those possible catch
    // unwind destinations.
    // TODO This can be more precise for `throw`s if we compare event types
    // and create links to outer catch BBs only when the exception is not
    // caught.
    // TODO This can also be more precise if we analyze the structure of nested
    // try-catches. For example, in the example below, 'call $foo' doesn't need
    // a link to the BB of outer 'catch $e1', because if the exception thrown by
    // the call is of event $e1, it would've already been caught by the inner
    // 'catch $e1'. Optimize these cases later.
    // try
    //   try
    //     call $foo
    //   catch $e1
    //     ...
    //   catch $e2
    //     ...
    //   end
    // catch $e1
    //   ...
    // catch $e3
    //   ...
    // end
    for (int i = self->unwindCatchStack.size() - 1; i > 0; i--) {
      if (self->unwindExprStack[i]->template cast<Try>()->hasCatchAll()) {
        break;
      }
      for (auto* block : self->unwindCatchStack[i - 1]) {
        self->link(self->currBasicBlock, block);
      }
    }
  }

  static void doEndCall(SubType* self, Expression** currp) {
    doEndThrowingInst(self, currp);
    if (!self->unwindCatchStack.empty()) {
      // exception not thrown. link to the continuation BB
      auto* last = self->currBasicBlock;
      self->link(last, self->startBasicBlock());
    }
  }

  static void doStartTry(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Try>();
    auto* last = self->currBasicBlock;
    self->unwindCatchStack.emplace_back();
    self->unwindExprStack.push_back(curr);
    for (Index i = 0; i < curr->catchBodies.size(); i++) {
      // Create the catch body's first block
      self->unwindCatchStack.back().push_back(self->startBasicBlock());
    }
    self->currBasicBlock = last; // reset to the current block
  }

  static void doStartCatches(SubType* self, Expression** currp) {
    self->tryStack.push_back(self->currBasicBlock); // last block of try body
    self->processCatchStack.push_back(self->unwindCatchStack.back());
    self->unwindCatchStack.pop_back();
    self->unwindExprStack.pop_back();
  }

  static void doStartCatch(SubType* self, Expression** currp, Index i) {
    // Get the block that starts this catch
    self->currBasicBlock = self->processCatchStack.back()[i];
  }

  static void doEndCatch(SubType* self, Expression** currp, Index i) {
    // We are done with this catch; set the block that ends it
    self->processCatchStack.back()[i] = self->currBasicBlock;
  }

  static void doEndTry(SubType* self, Expression** currp) {
    self->startBasicBlock(); // continuation block after try-catch
    // each catch body's last block -> continuation block
    for (auto* last : self->processCatchStack.back()) {
      self->link(last, self->currBasicBlock);
    }
    // try body's last block -> continuation block
    self->link(self->tryStack.back(), self->currBasicBlock);
    self->tryStack.pop_back();
    self->processCatchStack.pop_back();
  }

  static void doEndThrow(SubType* self, Expression** currp) {
    doEndThrowingInst(self, currp);
    self->startUnreachableBlock();
  }

  static void scan(SubType* self, Expression** currp) {
    Expression* curr = *currp;

    switch (curr->_id) {
      case Expression::Id::BlockId: {
        self->pushTask(SubType::doEndBlock, currp);
        break;
      }
      case Expression::Id::IfId: {
        self->pushTask(SubType::doEndIf, currp);
        auto* ifFalse = curr->cast<If>()->ifFalse;
        if (ifFalse) {
          self->pushTask(SubType::scan, &curr->cast<If>()->ifFalse);
          self->pushTask(SubType::doStartIfFalse, currp);
        }
        self->pushTask(SubType::scan, &curr->cast<If>()->ifTrue);
        self->pushTask(SubType::doStartIfTrue, currp);
        self->pushTask(SubType::scan, &curr->cast<If>()->condition);
        return; // don't do anything else
      }
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doEndLoop, currp);
        break;
      }
      case Expression::Id::BreakId: {
        self->pushTask(SubType::doEndBreak, currp);
        break;
      }
      case Expression::Id::SwitchId: {
        self->pushTask(SubType::doEndSwitch, currp);
        break;
      }
      case Expression::Id::ReturnId: {
        self->pushTask(SubType::doStartUnreachableBlock, currp);
        break;
      }
      case Expression::Id::UnreachableId: {
        self->pushTask(SubType::doStartUnreachableBlock, currp);
        break;
      }
      case Expression::Id::CallId:
      case Expression::Id::CallIndirectId: {
        self->pushTask(SubType::doEndCall, currp);
        break;
      }
      case Expression::Id::TryId: {
        self->pushTask(SubType::doEndTry, currp);
        auto& catchBodies = curr->cast<Try>()->catchBodies;
        using namespace std::placeholders;
        for (Index i = 0; i < catchBodies.size(); i++) {
          auto doEndCatchI = [i](SubType* self, Expression** currp) {
            doEndCatch(self, currp, i);
          };
          self->pushTask(doEndCatchI, currp);
          self->pushTask(SubType::scan, &catchBodies[i]);
          auto doStartCatchI = [i](SubType* self, Expression** currp) {
            doStartCatch(self, currp, i);
          };
          self->pushTask(doStartCatchI, currp);
        }
        self->pushTask(SubType::doStartCatches, currp);
        self->pushTask(SubType::scan, &curr->cast<Try>()->body);
        self->pushTask(SubType::doStartTry, currp);
        return; // don't do anything else
      }
      case Expression::Id::ThrowId:
      case Expression::Id::RethrowId: {
        self->pushTask(SubType::doEndThrow, currp);
        break;
      }
      default: {}
    }

    ControlFlowWalker<SubType, VisitorType>::scan(self, currp);

    switch (curr->_id) {
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doStartLoop, currp);
        break;
      }
      default: {}
    }
  }

  void doWalkFunction(Function* func) {
    basicBlocks.clear();
    debugIds.clear();

    startBasicBlock();
    entry = currBasicBlock;
    ControlFlowWalker<SubType, VisitorType>::doWalkFunction(func);

    assert(branches.size() == 0);
    assert(ifStack.size() == 0);
    assert(loopStack.size() == 0);
    assert(tryStack.size() == 0);
    assert(unwindCatchStack.size() == 0);
    assert(unwindExprStack.size() == 0);
    assert(processCatchStack.size() == 0);
  }

  std::unordered_set<BasicBlock*> findLiveBlocks() {
    std::unordered_set<BasicBlock*> alive;
    std::unordered_set<BasicBlock*> queue;
    queue.insert(entry);
    while (queue.size() > 0) {
      auto iter = queue.begin();
      auto* curr = *iter;
      queue.erase(iter);
      alive.insert(curr);
      for (auto* out : curr->out) {
        if (!alive.count(out)) {
          queue.insert(out);
        }
      }
    }
    return alive;
  }

  void unlinkDeadBlocks(std::unordered_set<BasicBlock*> alive) {
    for (auto& block : basicBlocks) {
      if (!alive.count(block.get())) {
        block->in.clear();
        block->out.clear();
        continue;
      }
      block->in.erase(std::remove_if(block->in.begin(),
                                     block->in.end(),
                                     [&alive](BasicBlock* other) {
                                       return !alive.count(other);
                                     }),
                      block->in.end());
      block->out.erase(std::remove_if(block->out.begin(),
                                      block->out.end(),
                                      [&alive](BasicBlock* other) {
                                        return !alive.count(other);
                                      }),
                       block->out.end());
    }
  }

  // TODO: utility method for optimizing cfg, removing empty blocks depending on
  // their .content

  std::map<BasicBlock*, size_t> debugIds;

  void generateDebugIds() {
    if (debugIds.size() > 0) {
      return;
    }
    for (auto& block : basicBlocks) {
      debugIds[block.get()] = debugIds.size();
    }
  }

  void dumpCFG(std::string message) {
    std::cout << "<==\nCFG [" << message << "]:\n";
    generateDebugIds();
    for (auto& block : basicBlocks) {
      assert(debugIds.count(block.get()) > 0);
      std::cout << "  block " << debugIds[block.get()] << " (" << block.get()
                << "):\n";
      block->contents.dump(static_cast<SubType*>(this)->getFunction());
      for (auto& in : block->in) {
        assert(debugIds.count(in) > 0);
        assert(std::find(in->out.begin(), in->out.end(), block.get()) !=
               in->out.end()); // must be a parallel link back
      }
      for (auto& out : block->out) {
        assert(debugIds.count(out) > 0);
        std::cout << "    out: " << debugIds[out] << "\n";
        assert(std::find(out->in.begin(), out->in.end(), block.get()) !=
               out->in.end()); // must be a parallel link back
      }
      checkDuplicates(block->in);
      checkDuplicates(block->out);
    }
    std::cout << "==>\n";
  }

private:
  // links in out and in must be unique
  void checkDuplicates(std::vector<BasicBlock*>& list) {
    std::unordered_set<BasicBlock*> seen;
    for (auto* curr : list) {
      assert(seen.count(curr) == 0);
      seen.insert(curr);
    }
  }

  void removeLink(std::vector<BasicBlock*>& list, BasicBlock* toRemove) {
    if (list.size() == 1) {
      list.clear();
      return;
    }
    for (size_t i = 0; i < list.size(); i++) {
      if (list[i] == toRemove) {
        list[i] = list.back();
        list.pop_back();
        return;
      }
    }
    WASM_UNREACHABLE("not found");
  }
};

} // namespace wasm

#endif // cfg_traversal_h
