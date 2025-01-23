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

#include "ir/branch-utils.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

template<typename SubType, typename VisitorType, typename Contents>
struct CFGWalker : public PostWalker<SubType, VisitorType> {

  // public interface

  struct BasicBlock {
    Contents contents; // custom contents
    std::vector<BasicBlock*> out, in;
  };

  // The entry block at the function's start. This always exists, although it
  // might be empty if the function is empty.
  BasicBlock* entry = nullptr;

  // The exit block for the function: either the single block that returns or
  // flows values out of the function, or an empty synthetic block that is a
  // successor of all such blocks. This block may not exist if a function
  // traps, infinitely loops, throws, or otherwise never exits normally.
  //
  // Analyses that care about reaching the end of the function can just look at
  // this block instead of all the individual returns.
  BasicBlock* exit = nullptr;

  // override this with code to create a BasicBlock if necessary
  BasicBlock* makeBasicBlock() { return new BasicBlock(); }

  // internal details

  // The list of basic blocks in the function.
  //
  // This is populated in reverse postorder, that is, a block appears after all
  // those that dominate it. This is trivial to do given wasm's structured
  // control flow: we simply create blocks only after the things that can reach
  // them (the only nontrivial things are loops, but if the dominator was before
  // the loop, then again, we would have created it before the loop body).
  std::vector<std::unique_ptr<BasicBlock>> basicBlocks;

  // blocks that are the tops of loops, i.e., have backedges to them
  std::vector<BasicBlock*> loopTops;

  // traversal state
  // the current block in play during traversal. can be nullptr if unreachable,
  // but note that we don't do a deep unreachability analysis - just enough to
  // avoid constructing obviously-unreachable blocks (we do a full reachability
  // analysis on the CFG once it is constructed).
  BasicBlock* currBasicBlock;
  // a block or loop => its branches
  std::map<Name, std::vector<BasicBlock*>> branches;
  // stack of the last blocks of if conditions + the last blocks of if true
  // bodies
  std::vector<BasicBlock*> ifLastBlockStack;
  // stack of the first blocks of loops
  std::vector<BasicBlock*> loopLastBlockStack;

  // stack of the last blocks of try bodies
  std::vector<BasicBlock*> tryLastBlockStack;
  // Stack of the blocks that contain a throwing instruction, and therefore they
  // can reach the first blocks of catches that throwing instructions should
  // unwind to at any moment. That is, the topmost item in this vector relates
  // to the current try-catch scope, and the vector there is a list of the items
  // that can reach catch blocks (each item is assumed to be able to reach any
  // of the catches, although that could be improved perhaps).
  std::vector<std::vector<BasicBlock*>> throwingInstsStack;
  // stack of 'Try'/'TryTable' expressions corresponding to throwingInstsStack.
  std::vector<Expression*> tryStack;
  // A stack for each try, where each entry is a list of blocks, one for each
  // catch, used during processing. We start by assigning the start blocks to
  // here, and then read those at the appropriate time; when we finish a catch
  // we write to here the end block, so that when we finish with them all we can
  // connect the ends to the outside. In principle two vectors could be used,
  // but their usage does not overlap in time, and this is more efficient.
  std::vector<std::vector<BasicBlock*>> processCatchStack;

  // Stack to store the catch indices within catch bodies. To be used in
  // doStartCatch and doEndCatch.
  std::vector<Index> catchIndexStack;

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
    auto iter = self->branches.find(curr->name);
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
    self->branches.erase(curr->name);
  }

  // Whether we have created a synthetic, empty exit block for multiple other
  // exit blocks to flow to.
  bool hasSyntheticExit = false;

  static void doEndReturn(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    self->startUnreachableBlock();
    if (!self->exit) {
      // This is our first exit block and may be our only exit block, so just
      // set it.
      self->exit = last;
    } else if (!self->hasSyntheticExit) {
      // We now have multiple exit blocks, so we need to create a synthetic one.
      // It will be added to the list of basic blocks at the end of the
      // function.
      auto* lastExit = self->exit;
      self->exit = self->makeBasicBlock();
      self->link(lastExit, self->exit);
      self->link(last, self->exit);
      self->hasSyntheticExit = true;
    } else {
      // We already have a synthetic exit block. Just link it up.
      self->link(last, self->exit);
    }
  }

  static void doStartIfTrue(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    self->link(last, self->startBasicBlock()); // ifTrue
    self->ifLastBlockStack.push_back(last);    // the block before the ifTrue
  }

  static void doStartIfFalse(SubType* self, Expression** currp) {
    self->ifLastBlockStack.push_back(
      self->currBasicBlock); // the ifTrue fallthrough
    self->link(self->ifLastBlockStack[self->ifLastBlockStack.size() - 2],
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
      self->link(self->ifLastBlockStack.back(), self->currBasicBlock);
      self->ifLastBlockStack.pop_back();
    } else {
      // no ifFalse, so add a fallthrough for if the if is not taken
      self->link(self->ifLastBlockStack.back(), self->currBasicBlock);
    }
    self->ifLastBlockStack.pop_back();
  }

  static void doStartLoop(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    self->startBasicBlock();
    // a loop with no backedges would still be counted here, but oh well
    self->loopTops.push_back(self->currBasicBlock);
    self->link(last, self->currBasicBlock);
    self->loopLastBlockStack.push_back(self->currBasicBlock);
  }

  static void doEndLoop(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    self->link(last, self->startBasicBlock()); // fallthrough
    auto* curr = (*currp)->cast<Loop>();
    // branches to the top of the loop
    if (curr->name.is()) {
      auto* loopStart = self->loopLastBlockStack.back();
      auto& origins = self->branches[curr->name];
      for (auto* origin : origins) {
        self->link(origin, loopStart);
      }
      self->branches.erase(curr->name);
    }
    self->loopLastBlockStack.pop_back();
  }

  static void doEndBranch(SubType* self, Expression** currp) {
    auto* curr = *currp;
    auto branchTargets = BranchUtils::getUniqueTargets(curr);
    // Add branches to the targets.
    for (auto target : branchTargets) {
      self->branches[target].push_back(self->currBasicBlock);
    }
    if (curr->type != Type::unreachable) {
      auto* last = self->currBasicBlock;
      self->link(last, self->startBasicBlock()); // we might fall through
    } else {
      self->startUnreachableBlock();
    }
  }

  static void doEndThrowingInst(SubType* self, Expression** currp) {
    // If the innermost try/try_table does not have a catch_all clause, an
    // exception thrown can be caught by any of its outer catch block. And if
    // that outer try/try_table also does not have a catch_all, this continues
    // until we encounter a try/try_table-catch_all. Create a link to all those
    // possible catch unwind destinations.
    // TODO This can be more precise for `throw`s if we compare tag types and
    // create links to outer catch BBs only when the exception is not caught.
    // TODO This can also be more precise if we analyze the structure of nested
    // try-catches. For example, in the example below, 'call $foo' doesn't need
    // a link to the BB of outer 'catch $e1', because if the exception thrown by
    // the call is of tag $e1, it would've already been caught by the inner
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
    assert(self->tryStack.size() == self->throwingInstsStack.size());
    for (int i = self->throwingInstsStack.size() - 1; i >= 0;) {
      if (auto* tryy = self->tryStack[i]->template dynCast<Try>()) {
        if (tryy->isDelegate()) {
          // If this delegates to the caller, there is no possibility that this
          // instruction can throw to outer catches.
          if (tryy->delegateTarget == DELEGATE_CALLER_TARGET) {
            break;
          }
          // If this delegates to an outer try, we skip catches between this try
          // and the target try.
          [[maybe_unused]] bool found = false;
          for (int j = i - 1; j >= 0; j--) {
            if (self->tryStack[j]->template cast<Try>()->name ==
                tryy->delegateTarget) {
              i = j;
              found = true;
              break;
            }
          }
          assert(found);
          continue;
        }
      }

      // Exception thrown. Note outselves so that we will create a link to each
      // catch within the try / each destination block within the try_table when
      // we get there.
      self->throwingInstsStack[i].push_back(self->currBasicBlock);

      if (auto* tryy = self->tryStack[i]->template dynCast<Try>()) {
        // If this try has catch_all, there is no possibility that this
        // instruction can throw to outer catches. Stop here.
        if (tryy->hasCatchAll()) {
          break;
        }
      } else if (auto* tryTable =
                   self->tryStack[i]->template dynCast<TryTable>()) {
        if (tryTable->hasCatchAll()) {
          break;
        }
      } else {
        WASM_UNREACHABLE("invalid throwingInstsStack item");
      }
      i--;
    }
  }

  // We can optionally ignore branches to outside of the function. Such a branch
  // does not link two basic blocks (since the target is outside of the
  // function), but it can cause us to end the current basic block and link to a
  // new one, just in order to preserve the property that blocks do not have
  // instructions in the middle that can transfer control flow somewhere. That
  // property is useful to have in general, but if a user of this code just does
  // not care about what happens when we leave the current function (say, if it
  // only reads locals, which are gone anyhow if we leave) then it can flip this
  // option to avoid creating new blocks just for such branches.
  //
  // The main situation where this matters is calls, which can throw if EH is
  // enabled. With this set to ignore, we don't create new basic blocks just
  // because of that, which can save a significant amount of overhead (~10%).
  bool ignoreBranchesOutsideOfFunc = false;

  static void doEndCall(SubType* self, Expression** currp) {
    doEndThrowingInst(self, currp);
    if (!self->throwingInstsStack.empty() ||
        !self->ignoreBranchesOutsideOfFunc) {
      // |doEndThrowingInst| added a link from the current block to a catch, so
      // we must end the current block and start another. Or, we are not
      // ignoring branches to outside of the function, so even without a branch
      // to a catch we want to start a new basic block here, to preserve the
      // property that control flow transfers (both within the function or to
      // the outside) can only happen at the end of basic blocks.
      auto* last = self->currBasicBlock;
      self->link(last, self->startBasicBlock());
    }
  }

  static void doStartTry(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Try>();
    self->throwingInstsStack.emplace_back();
    self->tryStack.push_back(curr);
  }

  static void doStartCatches(SubType* self, Expression** currp) {
    self->tryLastBlockStack.push_back(
      self->currBasicBlock); // last block of try body

    // Now that we are starting the catches, create the basic blocks that they
    // begin with.
    auto* last = self->currBasicBlock;
    auto* tryy = (*currp)->cast<Try>();
    self->processCatchStack.emplace_back();
    auto& entries = self->processCatchStack.back();
    for (Index i = 0; i < tryy->catchBodies.size(); i++) {
      entries.push_back(self->startBasicBlock());
    }
    self->currBasicBlock = last; // reset to the current block

    // Create links from things that reach those new basic blocks.
    auto& preds = self->throwingInstsStack.back();
    for (auto* pred : preds) {
      for (Index i = 0; i < entries.size(); i++) {
        self->link(pred, entries[i]);
      }
    }

    self->throwingInstsStack.pop_back();
    self->tryStack.pop_back();
    self->catchIndexStack.push_back(0);
  }

  static void doStartCatch(SubType* self, Expression** currp) {
    // Get the block that starts this catch
    self->currBasicBlock =
      self->processCatchStack.back()[self->catchIndexStack.back()];
  }

  static void doEndCatch(SubType* self, Expression** currp) {
    // We are done with this catch; set the block that ends it
    self->processCatchStack.back()[self->catchIndexStack.back()] =
      self->currBasicBlock;
    self->catchIndexStack.back()++;
  }

  static void doEndTry(SubType* self, Expression** currp) {
    self->startBasicBlock(); // continuation block after try-catch
    // each catch body's last block -> continuation block
    for (auto* last : self->processCatchStack.back()) {
      self->link(last, self->currBasicBlock);
    }
    // try body's last block -> continuation block
    self->link(self->tryLastBlockStack.back(), self->currBasicBlock);
    self->tryLastBlockStack.pop_back();
    self->processCatchStack.pop_back();
    self->catchIndexStack.pop_back();
  }

  static void doEndThrow(SubType* self, Expression** currp) {
    doEndThrowingInst(self, currp);
    self->startUnreachableBlock();
  }

  static void doStartTryTable(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<TryTable>();
    self->throwingInstsStack.emplace_back();
    self->tryStack.push_back(curr);
  }

  static void doEndTryTable(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<TryTable>();

    auto catchTargets = BranchUtils::getUniqueTargets(curr);
    // Add catch destinations to the targets.
    for (auto target : catchTargets) {
      auto& preds = self->throwingInstsStack.back();
      for (auto* pred : preds) {
        self->branches[target].push_back(pred);
      }
    }

    self->throwingInstsStack.pop_back();
    self->tryStack.pop_back();
  }

  static bool isReturnCall(Expression* curr) {
    switch (curr->_id) {
      case Expression::Id::CallId:
        return curr->cast<Call>()->isReturn;
      case Expression::Id::CallIndirectId:
        return curr->cast<CallIndirect>()->isReturn;
      case Expression::Id::CallRefId:
        return curr->cast<CallRef>()->isReturn;
      default:
        WASM_UNREACHABLE("not a call");
    }
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
      case Expression::Id::CallId:
      case Expression::Id::CallIndirectId:
      case Expression::Id::CallRefId: {
        if (isReturnCall(curr)) {
          self->pushTask(SubType::doEndReturn, currp);
        } else {
          auto* module = self->getModule();
          if (!module || module->features.hasExceptionHandling()) {
            // This call might throw, so run the code to handle that.
            self->pushTask(SubType::doEndCall, currp);
          }
        }
        break;
      }
      case Expression::Id::ReturnId:
        self->pushTask(SubType::doEndReturn, currp);
        break;
      case Expression::Id::TryId: {
        self->pushTask(SubType::doEndTry, currp);
        auto& catchBodies = curr->cast<Try>()->catchBodies;
        for (Index i = 0; i < catchBodies.size(); i++) {
          self->pushTask(doEndCatch, currp);
          self->pushTask(SubType::scan, &catchBodies[i]);
          self->pushTask(doStartCatch, currp);
        }
        self->pushTask(SubType::doStartCatches, currp);
        self->pushTask(SubType::scan, &curr->cast<Try>()->body);
        self->pushTask(SubType::doStartTry, currp);
        return; // don't do anything else
      }
      case Expression::Id::TryTableId: {
        self->pushTask(SubType::doEndTryTable, currp);
        break;
      }
      case Expression::Id::ThrowId:
      case Expression::Id::RethrowId:
      case Expression::Id::ThrowRefId: {
        self->pushTask(SubType::doEndThrow, currp);
        break;
      }
      default: {
        if (Properties::isBranch(curr)) {
          self->pushTask(SubType::doEndBranch, currp);
        } else if (curr->type == Type::unreachable) {
          self->pushTask(SubType::doStartUnreachableBlock, currp);
        }
      }
    }

    PostWalker<SubType, VisitorType>::scan(self, currp);

    switch (curr->_id) {
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doStartLoop, currp);
        break;
      }
      case Expression::Id::TryTableId: {
        self->pushTask(SubType::doStartTryTable, currp);
        break;
      }
      default: {}
    }
  }

  void doWalkFunction(Function* func) {
    basicBlocks.clear();
    debugIds.clear();
    exit = nullptr;
    hasSyntheticExit = false;

    startBasicBlock();
    entry = currBasicBlock;
    PostWalker<SubType, VisitorType>::doWalkFunction(func);

    // The last block, if it exists, implicitly returns.
    if (currBasicBlock) {
      auto* self = static_cast<SubType*>(this);
      self->doEndReturn(self, nullptr);
    }

    // If we have a synthetic exit block, add it to the list of basic blocks
    // here so it always comes at the end.
    if (hasSyntheticExit) {
      basicBlocks.push_back(std::unique_ptr<BasicBlock>(exit));
    }

    assert(branches.size() == 0);
    assert(ifLastBlockStack.size() == 0);
    assert(loopLastBlockStack.size() == 0);
    assert(tryLastBlockStack.size() == 0);
    assert(throwingInstsStack.size() == 0);
    assert(tryStack.size() == 0);
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
      auto res = seen.emplace(curr);
      assert(res.second);
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
