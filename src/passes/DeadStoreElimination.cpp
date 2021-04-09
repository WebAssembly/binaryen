/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Finds stores that are trampled over by other stores anyhow, before they can
// be read.
//

#include <cfg/cfg-traversal.h>
#include <ir/effects.h>
#include <ir/utils.h>
#include <pass.h>
#include <support/unique_deferring_queue.h>
#include <wasm.h>

namespace wasm {

namespace {

// Information in a basic block.
struct Info {
  // The list of relevant expressions, that are either stores or things that
  // interact with stores.
  std::vector<Expression*> exprs;
};

} // anonymous namespace

struct DeadStoreFinder : public CFGWalker<DeadStoreFinder,
                                UnifiedExpressionVisitor<DeadStoreFinder>,
                                Info> {

  PassOptions& passOptions;
  FeatureSet features;

  DeadStoreFinder(Function* func, PassOptions& passOptions, FeatureSet features) : passOptions(passOptions), features(features) {
    // create the CFG by walking the IR
    doWalkFunction(func);

    // Ensure a final return on the last block, to represent us leaving the
    // function (which just like a return in the middle, means we reach code
    // that can access global state).
    Return ret;
    currBasicBlock->contents.exprs.push_back(&ret);

    // Flow stores to perform the analysis.
    flow();
  }

  virtual ~DeadStoreFinder();

  // Hooks for subclasses

  // Returns whether the expression is relevant for us: either a store, or a
  // thing that may interact with a store.
  virtual bool isRelevant(Expression* curr) = 0;

  // Returns whether an expression is a relevant store for us to consider.
  virtual bool isStore(Expression* curr) = 0;

  // Returns whether an expression is a load that corresponds to a store. The
  // load may not load all the data written by the store (that is up to a
  // subclass to decide about), but it loads at least some of that data.
  virtual bool isLoadFrom(Expression* curr, Expression* store) = 0;

  // Returns whether an expression tramples a store completely, overwriting all
  // the store's written data.
  virtual bool tramples(Expression* curr, Expression* store) = 0;

  // Returns whether an expression may interact with store in a way that we
  // cannot fully analyze as a load or a store, and so we must give up. This may
  // be a possible load or a possible store or something else.
  // This does not need to handle reaching of code outside of the current function: a
  // call, return, etc. will be noted as a possible interaction automatically (as if we
  // reach code outside the function then any interaction is possible).
  virtual bool mayInteract(Expression* curr, Expression* store) = 0;

  // Walking

  void visitExpression(Expression* curr) {
    if (!currBasicBlock) {
      return;
    }
    if (isRelevant(curr)) {
      currBasicBlock->contents.exprs.push_back(curr);
    }
  }

  // Maps a store to the loads from it. If a store is in this map then all the
  // loads could be analyzed, and are all present in the vector for that store.
  std::unordered_map<Expression*, std::vector<Expression*>> storeLoads;

  void flow() {
    // TODO: Optimize. This is a pretty naive way to flow the values, but it
    //       should be reasonable assuming most stores are quickly seen as
    //       having possible interactions (e.g., the first time we see a call)
    //       and so most flows are halted very quickly.
    for (auto& block : basicBlocks) {
      for (size_t i = 0; i < block->contents.exprs.size(); i++) {
        auto* store = block->contents.exprs[i];
        if (!isStore(store)) {
          continue;
        }

        // Flow this store forward, looking for what it affects and interacts
        // with.
        UniqueNonrepeatingDeferredQueue<BasicBlock*> work;

        auto scanBlock = [&](BasicBlock* block, size_t from) {
          for (size_t i = from; i < block->contents.exprs.size(); i++) {
            auto* curr = block->contents.exprs[i];

            EffectAnalyzer effects(passOptions, features, curr);

            // Check if we can reach code outside of this function, in which
            // case the store may have interactions we cannot see. Also call the
            // subclass hook to check for such interactions.
            if (effects.calls || effects.throws || effects.trap || curr->is<Return>() || mayInteract(curr, store)) {
              // Stop: we cannot fully analyze the uses of this store.
              // TODO: it may be valuable to still optimize some of the loads
              //       from a store, even if others cannot be analyzed. We can
              //       do the store and also a tee, and load from the local in
              //       the loads we are sure of. Code size tradeoffs are 
              //       unclear, however.
              work.clear();
              storeLoads.erase(store);
              return;
            }

            if (isLoadFrom(curr, store)) {
              // We found a definite load, note it.
              storeLoads[store].push_back(curr);
            }

            if (tramples(curr, store)) {
              // We do not need to look any further along this block, or in
              // anything it can reach.
              return;
            }
          }

          // We reached the end of the block, prepare to flow onward.
          for (auto* out : block->out) {
            work.push(out);
          }
        };

        // First, start in the current location in the block.
        scanBlock(block.get(), i + 1);

        // Next, continue flowing through other blocks.
        while (!work.empty()) {
          auto* curr = work.pop();
          scanBlock(curr, 0);
        }
      }
    }
  }
};

struct DeadStoreElimination
  : public WalkerPass<PostWalker<DeadStoreElimination>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DeadStoreElimination; }

  void doWalkFunction(Function* curr) {
  }
};

Pass* createDeadStoreEliminationPass() { return new DeadStoreElimination(); }

} // namespace wasm
