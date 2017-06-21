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
// Folds duplicate code together, saving space
//
// We fold tails of code where they merge and moving the code
// to the merge point is helpful. There are two cases here:
//  * blocks, we merge the fallthrough + the breaks
//  * if-else, we merge the arms
//

#include <iterator>

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "ast_utils.h"

namespace wasm {

static const Index WORTH_ADDING_BLOCK_TO_REMOVE_THIS_MUCH = 3;

struct CodeFolding : public WalkerPass<ControlFlowWalker<CodeFolding>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new CodeFolding; }

  // information about a "tail" - code that reaches a point that we can
  // merge (e.g., a branch and some code leading up to it)
  struct Tail {
    Expression* expr; // nullptr if this is a fallthrough
    Expression** pointer; // pointer in parent, for updating
    Block* block; // the enclosing block where we are at the tail
    Tail(Block* block) : expr(nullptr), pointer(nullptr), block(block) {}
    Tail(Expression* expr, Expression** pointer, Block* block) : expr(expr), pointer(pointer), block(block) {}
  };

  std::map<Name, std::vector<Tail>> breakTails; // break target name => tails that reach it

  void visitBlock(Block* curr) {
  }

  void visitIf(If* curr) {
    if (!curr->ifFalse) return;
    if (ExpressionAnalyzer::equal(curr->ifTrue, curr->ifFalse)) {
      Builder builder(*getModule());
      // remove if (4 bytes), remove one arm, add drop (1), add block (3),
      // so this must be a net savings
      replaceCurrent(builder.makeSequence(
        builder.makeDrop(curr->condition),
        curr->ifTrue
      ));
    } else {
      // if both are blocks, look for a tail we can merge
      auto* left = curr->ifTrue->dynCast<Block>();
      auto* right = curr->ifFalse->dynCast<Block>();
      // we need nameless blocks, as if there is a name, someone might branch
      // to the end, skipping the code we want to merge
      if (left && right &&
          !left->name.is() && !right->name.is()) {
        optimizeTails({ Tail(left), Tail(right) }, curr);
      }
    }
  }

  void doWalkFunction(Function* func) {
    // TODO: multiple passes?
    WalkerPass<ControlFlowWalker<CodeFolding>>::walk(func->body);
    assert(breakTails.empty());
  }

private:
  // given a set of tails that all arrive at the end of an expression,
  // optimize foldable code out of the separate tails and put it right
  // after this expression
  template<typename T>
  void optimizeTails(const std::vector<Tail>& tails, T* curr) {
    assert(tails.size() > 1);
    // we are going to remove duplicate elements and add a block.
    // so for this to make sense, we need the size of the duplicate
    // elements to be worth that extra block (although, there is
    // some chance the block would get merged higher up...)
    std::vector<Expression*> mergeable; // the elements we can merge
    Index num = 0; // how many elements back from the tail to look at
    Index saved = 0; // how much we can save
    while (1) {
      // check if this num is still relevant
      bool stop = false;
      for (auto& tail : tails) {
        assert(tail.block);
        if (num >= tail.block->list.size()) {
          // one of the lists is too short
          stop = true;
          break;
        }
      }
      if (stop) break;
      auto* item = tails[0].block->list[tails[0].block->list.size() - num - 1];
      for (auto& tail : tails) {
        if (!ExpressionAnalyzer::equal(item, tail.block->list[tail.block->list.size() - num - 1])) {
          // one of the lists has a different item
          stop = true;
          break;
        }
      }
      if (stop) break;
      // we found another one we can merge
      mergeable.push_back(item);
      num++;
      saved += Measurer::measure(item);
    }
    if (saved == 0) return;
    // we may be able to save enough.
    if (saved < WORTH_ADDING_BLOCK_TO_REMOVE_THIS_MUCH) {
      // it's not obvious we can save enough. see if we get rid
      // of a block, that would justify this
      bool willEmptyBlock = false;
      for (auto& tail : tails) {
        if (num == tail.block->list.size()) {
          willEmptyBlock = true;
          break;
        }
      }
      if (!willEmptyBlock) return;
    }
    // this is worth doing, do it!
    for (auto& tail : tails) {
      for (Index i = 0; i < mergeable.size(); i++) {
        tail.block->list.pop_back();
      }
      tail.block->finalize();
    }
    curr->finalize();
    Builder builder(*getModule());
    auto* block = builder.makeBlock();
    block->list.push_back(curr);
    while (!mergeable.empty()) {
      block->list.push_back(mergeable.back());
      mergeable.pop_back();
    }
    block->finalize();
    replaceCurrent(block);
    // TODO: vacuuming (emptied out blocks etc.)?
  }
};

Pass *createCodeFoldingPass() {
  return new CodeFolding();
}

} // namespace wasm

