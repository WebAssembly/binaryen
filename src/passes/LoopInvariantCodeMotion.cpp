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
// expression in a loop, see if we can move it out.
//
// Flattening is not necessary here, but may help (as separating
// out expressions may allow moving at least part of a larger whole).
//

#include <unordered_map>

#include "ir/effects.h"
#include "ir/find_all.h"
#include "ir/local-graph.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct LoopInvariantCodeMotion
  : public WalkerPass<ExpressionStackWalker<LoopInvariantCodeMotion>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<LoopInvariantCodeMotion>();
  }

  using LoopSets = std::unordered_set<LocalSet*>;

  // main entry point

  LazyLocalGraph* localGraph;

  void doWalkFunction(Function* func) {
    // Prepare to compute the local dependencies we care about. We may only need
    // very few, so use a lazy LocalGraph.
    LazyLocalGraph localGraphInstance(func, getModule());
    localGraph = &localGraphInstance;
    // Traverse the function.
    super::doWalkFunction(func);
  }

  void visitLoop(Loop* loop) {
    // We accumulate all the code we can move out, and will place it
    // in a block just preceding the loop.
    std::vector<Expression*> movedCode;
    // Accumulate effects of things we can't move out - things
    // we move out later must cross them, so we must verify it
    // is ok to do so.
    EffectAnalyzer effectsSoFar(getPassOptions(), *getModule());
    // The loop's total effects also matter. For example, a store
    // in the loop means we can't move a load outside.
    // FIXME: we look at the loop "tail" area too, after the last
    //        possible branch back, which can cause false positives
    //        for bad effect interactions.
    EffectAnalyzer loopEffects(getPassOptions(), *getModule(), loop);
    // Note all the sets in each loop, and how many per index. Currently
    // EffectAnalyzer can't do that, and we need it to know if we
    // can move a set out of the loop (if there is another set
    // still there, we can't). Another possible option here is for
    // LocalGraph to track interfering sets. TODO
    // FIXME: also the loop tail issue from above.
    auto numLocals = getFunction()->getNumLocals();
    std::vector<Index> numSetsForIndex(numLocals);
    LoopSets loopSets;
    {
      FindAll<LocalSet> finder(loop);
      for (auto* set : finder.list) {
        numSetsForIndex[set->index]++;
        loopSets.insert(set);
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
        while (i > 0) {
          i--;
          work.push_back(&list[i]);
        }
        continue;
        // Note that if the block had a merge at the end, we would have seen
        // a branch to it anyhow, so we would stop before that point anyhow.
      }
      // If this may branch, we are done.
      EffectAnalyzer effects(getPassOptions(), *getModule(), curr);
      if (effects.transfersControlFlow()) {
        break;
      }
      if (interestingToMove(curr)) {
        // Let's see if we can move this out.
        // Global state changes would prevent this - we might end up
        // executing them just once.
        // And we must also move across anything not moved out already,
        // so check for issues there too.
        // The rest of the loop's effects matter too, we must also
        // take into account global state like interacting loads and
        // stores.
        bool unsafeToMove = effects.writesGlobalState() ||
                            effectsSoFar.invalidates(effects) ||
                            (effects.readsMutableGlobalState() &&
                             loopEffects.writesGlobalState());
        // TODO: look into optimizing this with exceptions. for now, disallow
        if (effects.throws() || loopEffects.throws()) {
          unsafeToMove = true;
        }
        if (!unsafeToMove) {
          // So far so good. Check if our local dependencies are all
          // outside of the loop, in which case everything is good -
          // either they are before the loop and constant for us, or
          // they are after and don't matter.
          if (effects.localsRead.empty() ||
              !hasGetDependingOnLoopSet(curr, loopSets)) {
            // We have checked if our gets are influenced by sets in the loop,
            // and must also check if our sets interfere with them. To do so,
            // assume temporarily that we are moving curr out; see if any sets
            // remain for its indexes.
            FindAll<LocalSet> currSets(curr);
            for (auto* set : currSets.list) {
              assert(numSetsForIndex[set->index] > 0);
              numSetsForIndex[set->index]--;
            }
            bool canMove = true;
            for (auto* set : currSets.list) {
              if (numSetsForIndex[set->index] > 0) {
                canMove = false;
                break;
              }
            }
            if (!canMove) {
              // We failed to move the code, undo those changes.
              for (auto* set : currSets.list) {
                numSetsForIndex[set->index]++;
              }
            } else {
              // We can move it! Leave the changes, move the code, and update
              // loopSets.
              movedCode.push_back(curr);
              *currp = Builder(*getModule()).makeNop();
              for (auto* set : currSets.list) {
                loopSets.erase(set);
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

  bool interestingToMove(Expression* curr) {
    // In theory we could consider blocks, but then heavy nesting of
    // switch patterns would be heavy, and almost always pointless.
    if (curr->type != Type::none || curr->is<Nop>() || curr->is<Block>() ||
        curr->is<Loop>()) {
      return false;
    }
    // Don't move copies (set of a get, or set of a tee of a get, etc.),
    // as they often do not turn into actual work inside the loop
    // (after later optimizations by us or the VM), and if we move them
    // out it will prevent other opts from potentially eliminating the
    // copy, as we don't have another pass that considers moving code
    // back *into* loops.
    // Likewise, constants also are not worth moving out.
    // Note that the issue remains for moving things out which later
    // optimizations turn into a copy or a constant, so in general
    // it is beneficial to run this pass later on (but that has downsides
    // too, as with more nesting moving code is harder - so something
    // like -O --flatten --licm -O may be best).
    if (auto* set = curr->dynCast<LocalSet>()) {
      while (1) {
        auto* next = set->value->dynCast<LocalSet>();
        if (!next) {
          break;
        }
        set = next;
      }
      if (set->value->is<LocalGet>() || set->value->is<Const>()) {
        return false;
      }
    }
    return true;
  }

  bool hasGetDependingOnLoopSet(Expression* curr, LoopSets& loopSets) {
    FindAll<LocalGet> gets(curr);
    for (auto* get : gets.list) {
      auto& sets = localGraph->getSets(get);
      for (auto* set : sets) {
        // nullptr means a parameter or zero-init value;
        // no danger to us.
        if (!set) {
          continue;
        }
        // Check if the set is in the loop. If not, it's either before,
        // which is fine, or after, which is also fine - moving curr
        // to just outside the loop will preserve those relationships.
        // TODO: this still counts curr's sets as inside the loop, which
        //       might matter in non-flat mode.
        if (loopSets.count(set)) {
          return true;
        }
      }
    }
    return false;
  }
};

Pass* createLoopInvariantCodeMotionPass() {
  return new LoopInvariantCodeMotion();
}

} // namespace wasm
