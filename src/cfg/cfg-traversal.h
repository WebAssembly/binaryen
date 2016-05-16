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

#include "wasm.h"
#include "wasm-traversal.h"

namespace wasm {

template<typename SubType, typename VisitorType, typename Contents>
struct CFGWalker : public PostWalker<SubType, VisitorType> {

  // public interface

  struct BasicBlock {
    Contents contents; // custom contents
    std::vector<BasicBlock*> out, in;
  };

  BasicBlock* entry; // the entry block

  BasicBlock* makeBasicBlock() { // override this with code to create a BasicBlock if necessary
    return new BasicBlock();
  }

  // internal details

  std::vector<std::unique_ptr<BasicBlock>> basicBlocks; // all the blocks

  // traversal state
  BasicBlock* currBasicBlock; // the current block in play during traversal
  std::map<Name, std::vector<BasicBlock*>> branches;
  std::vector<BasicBlock*> ifStack;
  std::vector<BasicBlock*> loopStack;

  static void doStartBasicBlock(SubType* self, Expression** currp) {
    self->currBasicBlock = self->makeBasicBlock();
    self->basicBlocks.push_back(std::unique_ptr<BasicBlock>(self->currBasicBlock));
  }

  void link(BasicBlock* from, BasicBlock* to) {
    from->out.push_back(to);
    to->in.push_back(from);
  }

  static void doEndBlock(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Block>();
    if (!curr->name.is()) return;
    auto iter = self->branches.find(curr->name);
    if (iter == self->branches.end()) return;
    auto& origins = iter->second;
    if (origins.size() == 0) return;
    // we have branches to here, so we need a new block
    auto* last = self->currBasicBlock;
    doStartBasicBlock(self, currp);
    self->link(last, self->currBasicBlock); // fallthrough
    // branches to the new one
    if (curr->name.is()) {
      for (auto* origin : origins) {
        self->link(origin, self->currBasicBlock);
      }
      self->branches.erase(curr->name);
    }
  }

  static void doStartIfTrue(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    doStartBasicBlock(self, currp);
    self->link(last, self->currBasicBlock); // ifTrue
    self->ifStack.push_back(last); // the block before the ifTrue
  }

  static void doStartIfFalse(SubType* self, Expression** currp) {
    self->ifStack.push_back(self->currBasicBlock); // the ifTrue fallthrough
    doStartBasicBlock(self, currp);
    self->link(self->ifStack[self->ifStack.size() - 2], self->currBasicBlock); // before if -> ifFalse
  }

  static void doEndIf(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    doStartBasicBlock(self, currp);
    self->link(last, self->currBasicBlock); // last one is ifFalse's fallthrough if there was one, otherwise it's the ifTrue fallthrough
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
    doStartBasicBlock(self, currp);
    self->link(last, self->currBasicBlock);
    self->loopStack.push_back(self->currBasicBlock);
  }

  static void doEndLoop(SubType* self, Expression** currp) {
    auto* last = self->currBasicBlock;
    doStartBasicBlock(self, currp);
    self->link(last, self->currBasicBlock); // fallthrough
    // branches to the new one
    auto* curr = (*currp)->cast<Loop>();
    if (curr->out.is()) {
      auto& origins = self->branches[curr->out];
      for (auto* origin : origins) {
        self->link(origin, self->currBasicBlock);
      }
      self->branches.erase(curr->out);
    }
    // branches to the top of the loop
    if (curr->in.is()) {
      auto* loopStart = self->loopStack.back();
      auto& origins = self->branches[curr->in];
      for (auto* origin : origins) {
        self->link(origin, loopStart);
      }
      self->branches.erase(curr->in);
    }
    self->loopStack.pop_back();
  }

  static void doEndBreak(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Break>();
    self->branches[curr->name].push_back(self->currBasicBlock); // branch to the target
    auto* last = self->currBasicBlock;
    doStartBasicBlock(self, currp);
    if (curr->condition) {
      self->link(last, self->currBasicBlock); // we might fall through
    }
  }

  static void doEndSwitch(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<Switch>();
    std::set<Name> seen; // we might see the same label more than once; do not spam branches
    for (Name target : curr->targets) {
      if (!seen.count(target)) {
        self->branches[target].push_back(self->currBasicBlock); // branch to the target
        seen.insert(target);
      }
    }
    if (!seen.count(curr->default_)) {
      self->branches[curr->default_].push_back(self->currBasicBlock); // branch to the target
    }
    doStartBasicBlock(self, currp);
  }

  static void scan(SubType* self, Expression** currp) {
    Expression* curr = *currp;

    switch (curr->_id) {
      case Expression::Id::BlockId: {
        self->pushTask(SubType::doEndBlock, currp);
        self->pushTask(SubType::doVisitBlock, currp);
        auto& list = curr->cast<Block>()->list;
        for (int i = int(list.size()) - 1; i >= 0; i--) {
          self->pushTask(SubType::scan, &list[i]);
        }
        break;
      }
      case Expression::Id::IfId: {
        self->pushTask(SubType::doEndIf, currp);
        self->pushTask(SubType::doVisitIf, currp);
        auto* ifFalse = curr->cast<If>()->ifFalse;
        if (ifFalse) {
          self->pushTask(SubType::scan, &curr->cast<If>()->ifFalse);
          self->pushTask(SubType::doStartIfFalse, currp);
        }
        self->pushTask(SubType::scan, &curr->cast<If>()->ifTrue);
        self->pushTask(SubType::doStartIfTrue, currp);
        self->pushTask(SubType::scan, &curr->cast<If>()->condition);
        break;
      }
      case Expression::Id::LoopId: {
        self->pushTask(SubType::doEndLoop, currp);
        self->pushTask(SubType::doVisitLoop, currp);
        self->pushTask(SubType::scan, &curr->cast<Loop>()->body);
        self->pushTask(SubType::doStartLoop, currp);
        break;
      }
      case Expression::Id::BreakId: {
        self->pushTask(SubType::doEndBreak, currp);
        self->pushTask(SubType::doVisitBreak, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Break>()->condition);
        self->maybePushTask(SubType::scan, &curr->cast<Break>()->value);
        break;
      }
      case Expression::Id::SwitchId: {
        self->pushTask(SubType::doEndSwitch, currp);
        self->pushTask(SubType::doVisitSwitch, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Switch>()->value);
        self->pushTask(SubType::scan, &curr->cast<Switch>()->condition);
        break;
      }
      case Expression::Id::ReturnId: {
        self->pushTask(SubType::doStartBasicBlock, currp);
        self->pushTask(SubType::doVisitReturn, currp);
        self->maybePushTask(SubType::scan, &curr->cast<Return>()->value);
        break;
      }
      case Expression::Id::UnreachableId: {
        self->pushTask(SubType::doStartBasicBlock, currp);
        self->pushTask(SubType::doVisitUnreachable, currp);
        break;
      }
      default: {
        // other node types do not have control flow, use regular post-order
        PostWalker<SubType, VisitorType>::scan(self, currp);
      }
    }
  }

  void walk(Expression*& root) {
    basicBlocks.clear();

    doStartBasicBlock(static_cast<SubType*>(this), nullptr);
    entry = currBasicBlock;
    PostWalker<SubType, VisitorType>::walk(root);

    assert(branches.size() == 0);
    assert(ifStack.size() == 0);
    assert(loopStack.size() == 0);
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
        if (!alive.count(out)) queue.insert(out);
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
      block->in.erase(std::remove_if(block->in.begin(), block->in.end(), [&alive](BasicBlock* other) {
        return !alive.count(other);
      }), block->in.end());
      block->out.erase(std::remove_if(block->out.begin(), block->out.end(), [&alive](BasicBlock* other) {
        return !alive.count(other);
      }), block->out.end());
    }
  }

  // TODO: utility method for optimizing cfg, removing empty blocks depending on their .content

  std::map<BasicBlock*, size_t> debugIds;

  void generateDebugIds() {
    if (debugIds.size() > 0) return;
    for (auto& block : basicBlocks) {
      debugIds[block.get()] = debugIds.size();
    }
  }

  void dumpCFG(std::string message) {
    std::cout << "<==\nCFG [" << message << "]:\n";
    generateDebugIds();
    for (auto& block : basicBlocks) {
      assert(debugIds.count(block.get()) > 0);
      std::cout << "  block " << debugIds[block.get()] << ":\n";
      block->contents.dump(static_cast<SubType*>(this)->getFunction());
      for (auto& in : block->in) {
        assert(debugIds.count(in) > 0);
        assert(std::find(in->out.begin(), in->out.end(), block.get()) != in->out.end()); // must be a parallel link back
      }
      for (auto& out : block->out) {
        assert(debugIds.count(out) > 0);
        std::cout << "    out: " << debugIds[out] << "\n";
        assert(std::find(out->in.begin(), out->in.end(), block.get()) != out->in.end()); // must be a parallel link back
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
    WASM_UNREACHABLE();
  }
};

} // namespace wasm

#endif // cfg_traversal_h
