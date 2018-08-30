/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Simple loop invariant code motion (licm): for every none-typed
// expression in a loop, see if it conflicts with the body of the
// loop minus itself. If not, it can be moved out.
//
// Flattening is not necessary here, but may help (as separating
// out expressions may allow movng at least part of a larger whole).
//

#include <unordered_map>

#include "wasm.h"
#include "pass.h"
#include "wasm-builder.h"
#include "ir/local-graph.h"
#include "ir/effects.h"
#include <ir/find_all.h>

namespace wasm {

namespace {

struct LoopInvariantCodeMotion : public WalkerPass<ExpressionStackWalker<LoopInvariantCodeMotion, UnifiedExpressionVisitor<LoopInvariantCodeMotion>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new LoopInvariantCodeMotion; }

  // main entry point

  LocalGraph* localGraph;

  void doWalkFunction(Function* func) {
    // Compute all dependencies first.
    LocalGraph localGraphInstance(func);
    localGraph = &localGraphInstance;
    // Traverse the function. While doing so, we note the nesting of
    // each expression we might try to move. That way, when we get
    // to a loop, we know the nesting of all the code in it and before
    // it, which is all we need to know to decide what to optimize.
    super::doWalkFunction(func);
  }

  bool interestingToMove(Expression* curr) {
    // In theory we could consider blocks, but then heavy nesting of
    // switch patterns would be heavy, and almost always pointless.
    return curr->type == none && !curr->is<Nop>() && !curr->is<Block>()
                              && !curr->is<Loop>();
  }

  // For each set_local, its nesting stack. We use this to tell
  // if relevant sets are in or out of the loop we are optimizing.
  // TODO: share stacks!
  std::unordered_map<Expression*, std::vector<Expression*>> expressionStacks;

  void visitExpression(Expression* curr) {
    if (curr->is<SetLocal>()) {
      auto& stack = expressionStacks[curr] = expressionStack;
      // We don't need the expression itself on top of the stack
      stack.pop_back();
    } else if (auto* loop = curr->dynCast<Loop>()) {
      handleLoop(loop);
    }
  }

  void handleLoop(Loop* loop) {
    // We accumulate all the code we can move out, and will place it
    // in a block just preceding the loop.
    std::vector<Expression*> movedCode;
    // Accumulate effects of things we can't move out - things
    // we move out later must cross them, so we must verify it
    // is ok to do so.
    EffectAnalyzer effectsSoFar(getPassOptions());
    // The loop's total effects also matter. For example, a store
    // in the loop means we can't move a load outside.
    // FIXME: we look at the loop "tail" area too, after the last
    //        possible branch back, which can cause false positives
    //        for bad effect interactions.
    EffectAnalyzer loopEffects(getPassOptions(), loop);
    // We also count the number of sets of each index, as currently
    // EffectAnalyzer can't do that, and we need it to know if we
    // can move a set out of the loop (if there is another set
    // still there, we can't). Another possible option here is for
    // LocalGraph to track interfering sets. TODO
    // FIXME: also the loop tail issue from above.
    auto numLocals = getFunction()->getNumLocals();
    std::vector<Index> numSetsForIndex(numLocals);
    std::fill(numSetsForIndex.begin(), numSetsForIndex.end(), 0);
    {
      FindAll<SetLocal> loopSets(loop);
      for (auto* set : loopSets.list) {
        numSetsForIndex[set->index]++;
      }
    }
    // Walk along the loop entrance, while all the code there
    // is executed unconditionally. That is the code we want to
    // move out - anything that might or might not be executed
    // may be best left alone anyhow.
    std::vector<Expression**> work;
    work.push_back(&loop->body);
    while (!work.empty()) {
      auto** currp = work.back();
      work.pop_back();
      auto* curr = *currp;
      // Look into blocks.
      if (auto* block = curr->dynCast<Block>()) {
        auto& list = block->list;
        Index i = list.size();
        if (i > 0) {
          do {
            i--;
            work.push_back(&list[i]);
          } while (i != 0);
        }
        continue;
        // Note that if the block had a merge at the end, we would have seen
        // a branch to it anyhow, so we would stop before that point anyhow.
      }
      // If this may branch, we are done.
      EffectAnalyzer effects(getPassOptions(), curr);
      if (effects.branches) {
        break;
      }
      if (interestingToMove(curr)) {
        // Let's see if we can move this out.
        // Global side effects would prevent this - we might end up
        // executing them just once.
        // And we must also move across anything not moved out already,
        // so check for issues there too.
        // The rest of the loop's effects matter too, we must also
        // take into account global state like interacting loads and
        // stores.
        if (!effects.hasGlobalSideEffects() &&
            !effectsSoFar.invalidates(effects) &&
            !(effects.noticesGlobalSideEffects() && loopEffects.hasGlobalSideEffects())) {
          // So far so good. Check if our local dependencies are all
          // outside of the loop, in which case everything is good -
          // either they are before the loop and constant for us, or
          // they are after and don't matter.
          bool canMove = true;
          if (!effects.localsRead.empty()) {
            FindAll<GetLocal> gets(curr);
            for (auto* get : gets.list) {
              auto& sets = localGraph->getSetses[get];
              for (auto* set : sets) {
                // nullptr means a parameter or zero-init value;
                // no danger to us.
                if (!set) continue;
                // The set may not have been seen yet, if it appears after
                // us (in an outer loop). If so, it's not a danger to us,
                // it happens after the loop.
                auto iter = expressionStacks.find(set);
                if (iter != expressionStacks.end()) {
                  // The set may be in the loop - if so, we can't move out.
                  auto& stack = iter->second;
                  for (auto* parent : stack) {
                    if (parent == loop) {
                      canMove = false;
                      break;
                    }
                  }
                }
                if (!canMove) {
                  break;
                }
              }
              if (!canMove) {
                break;
              }
            }
          }
          if (canMove) {
            // We have checked if our gets are influenced by sets in the loop, and
            // must also check if our sets interfere with them. To do so, assume
            // temporarily that we are moving curr out; see if any sets remain for
            // its indexes.
            FindAll<SetLocal> sets(curr);
            for (auto* set : sets.list) {
              assert(numSetsForIndex[set->index] > 0);
              numSetsForIndex[set->index]--;
            }
            for (auto* set : sets.list) {
              if (numSetsForIndex[set->index] > 0) {
                canMove = false;
                break;
              }
            }
            if (!canMove) {
              // We failed to move the code, undo those changes.
              for (auto* set : sets.list) {
                numSetsForIndex[set->index]++;
              }
            } else {
              // We can move it! Leave the changes, and move the code.
              movedCode.push_back(curr);
              *currp = Builder(*getModule()).makeNop();
              // If we have noted our stack, update it, we are no longer in the loop.
              if (curr->is<SetLocal>()) {
                auto& stack = expressionStacks[curr];
                while (1) {
                  assert(!stack.empty());
                  auto* back = stack.back();
                  stack.pop_back();
                  if (back == loop) {
                    break;
                  }
                }
              }
              continue;
            }
          }
        }
      }
      // We did not move this item. Accumulate its effects.
      effectsSoFar.mergeIn(effects);
    }
    // If we moved the code out, finish up by emitting it
    // outside of the loop.
    // Note that this works with nested loops - after moving outside
    // of an inner loop, we can encounter it again in an outer loop,
    // and move it further outside, without requiring any extra pass.
    if (!movedCode.empty()) {
      // Finish the moving by emitting the code outside.
      Builder builder(*getModule());
      auto* ret = builder.makeBlock(movedCode);
      ret->list.push_back(loop);
      ret->finalize(loop->type);
      replaceCurrent(ret);
      // Note that we do not need to modify the localGraph - we keep
      // each get in a position to be influenced by exactly the same
      // sets as before.
    }
  }
};

} // namespace

Pass *createLoopInvariantCodeMotionPass() {
  return new LoopInvariantCodeMotion();
}

} // namespace wasm

