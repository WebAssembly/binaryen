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
    Expression* expr;
    Expression** pointer; // pointer in parent, for updating
    Block* block; // the enclosing block where we are at the tail
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
      auto* leftBlock = curr->ifTrue->dynCast<Block>();
      auto* rightBlock = curr->ifFalse->dynCast<Block>();
      if (leftBlock && rightBlock &&
          !leftBlock->name.is() && !rightBlock->name.is()) {
        auto& left = leftBlock->list;
        auto& right = rightBlock->list;
        // we are going to remove duplicate elements and add a block.
        // so for this to make sense, we need the size of the duplicate
        // elements to be worth that extra block (although, there is
        // some chance the block would get merged higher up...)
        std::vector<Expression*> merged;
        Index num = 0;
        Index saved = 0;
        while (num < left.size() && num < right.size()) {
          auto* leftExpr = left[left.size() - num - 1];
          auto* rightExpr = right[right.size() - num - 1];
          if (ExpressionAnalyzer::equal(leftExpr, rightExpr)) {
            merged.push_back(leftExpr);
            num++;
            saved += Measurer::measure(leftExpr);
          } else {
            // we can do no more
            break;
          }
        }
        // if we save enough in elements, or we manage to remove
        // a whole block's contents, then this is a good idea
        if (saved >= WORTH_ADDING_BLOCK_TO_REMOVE_THIS_MUCH ||
            num == left.size() ||
            num == right.size()) {
          // this is worth doing
          for (Index i = 0; i < merged.size(); i++) {
            left.pop_back();
            right.pop_back();
          }
          leftBlock->finalize();
          rightBlock->finalize();
          curr->finalize();
          Builder builder(*getModule());
          auto* block = builder.makeBlock();
          block->list.push_back(curr);
          while (!merged.empty()) {
            block->list.push_back(merged.back());
            merged.pop_back();
          }
          block->finalize();
          replaceCurrent(block);
          // TODO: vacuum an emptied-out block here?
        }
      }
    }
  }

  void doWalkFunction(Function* func) {
    // TODO: multiple passes?
    WalkerPass<ControlFlowWalker<CodeFolding>>::walk(func->body);
    assert(breakTails.empty());
  }
};

Pass *createCodeFoldingPass() {
  return new CodeFolding();
}

} // namespace wasm

