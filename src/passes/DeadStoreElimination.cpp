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
#include <ir/local-graph.h>
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
  Function* func;
  PassOptions& passOptions;
  FeatureSet features;

  // TODO: make this heavy computation optional?
  LocalGraph localGraph;

  DeadStoreFinder(Function* func, PassOptions& passOptions, FeatureSet features) : func(func), passOptions(passOptions), features(features), localGraph(func) {}

  virtual ~DeadStoreFinder() {}

  // Hooks for subclasses.
  //
  // Some of these methods receive computed effects, which do not include their
  // children (as in each basic block we process expressions in a linear order,
  // and have already seen the children).
  //
  // These do not need to handle reaching of code outside of the current function: a
  // call, return, etc. will be noted as a possible interaction automatically (as if we
  // reach code outside the function then any interaction is possible).
  
  // Returns whether an expression is a relevant store for us to consider.
  virtual bool isStore(Expression* curr) = 0;

  // Returns whether the expression is relevant for us to notice in the
  // analysis. (This does not need to include anything isStore() returns true
  // on, as those are definitely relevant.)
  virtual bool isRelevant(Expression* curr, const EffectAnalyzer& currEffects) = 0;

  // Returns whether an expression is a load that corresponds to a store. The
  // load may not load all the data written by the store (that is up to a
  // subclass to decide about), but it loads at least some of that data.
  virtual bool isLoadFrom(Expression* curr, const EffectAnalyzer& currEffects, Expression* store) = 0;

  // Returns whether an expression tramples a store completely, overwriting all
  // the store's written data.
  // This is only called if isLoadFrom returns false.
  virtual bool tramples(Expression* curr, const EffectAnalyzer& currEffects, Expression* store) = 0;

  // Returns whether an expression may interact with store in a way that we
  // cannot fully analyze as a load or a store, and so we must give up. This may
  // be a possible load or a possible store or something else.
  // This is only called if isLoadFrom and tramples return false.
  virtual bool mayInteract(Expression* curr, const EffectAnalyzer& currEffects, Expression* store) = 0;

  // Walking

  void visitExpression(Expression* curr) {
    if (!currBasicBlock) {
      return;
    }

    EffectAnalyzer currEffects(passOptions, features);
    currEffects.visit(curr);

    if (reachesGlobalCode(curr, currEffects) || isRelevant(curr, currEffects) || isStore(curr)) {
      currBasicBlock->contents.exprs.push_back(curr);
    }
  }

  // Maps a store to the loads from it. If a store is in this map then all the
  // loads could be analyzed, and are all present in the vector for that store.
  std::unordered_map<Expression*, std::vector<Expression*>> storeLoads;

  void analyze() {
    // create the CFG by walking the IR
    doWalkFunction(func);

    // Ensure a final return on the last block, to represent us leaving the
    // function (which just like a return in the middle, means we reach code
    // that can access global state).
    Return ret;
    currBasicBlock->contents.exprs.push_back(&ret);

    // Flow the values and conduct the analysis.
    //
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

        // Note the store in storeLoads. It's presence there indicates it has no
        // unseen interactions, and we will remove it if we find any.
        storeLoads[store];

std::cout << "store:\n" << *store << '\n';
        // Flow this store forward, looking for what it affects and interacts
        // with.
        UniqueNonrepeatingDeferredQueue<BasicBlock*> work;

        auto scanBlock = [&](BasicBlock* block, size_t from) {
          for (size_t i = from; i < block->contents.exprs.size(); i++) {
            auto* curr = block->contents.exprs[i];

            EffectAnalyzer currEffects(passOptions, features);
            currEffects.visit(curr);
std::cout << "at curr:\n" << *curr << '\n';

            if (isLoadFrom(curr, currEffects, store)) {
              // We found a definite load, note it.
              storeLoads[store].push_back(curr);
std::cout << "  found load\n";
            } else if (tramples(curr, currEffects, store)) {
              // We do not need to look any further along this block, or in
              // anything it can reach.
std::cout << "  found trample\n";
              return;
            } else if (reachesGlobalCode(curr, currEffects) || mayInteract(curr, currEffects, store)) {
std::cout << "  found mayInteract\n";
              // Stop: we cannot fully analyze the uses of this store as
              // there are interactions we cannot see.
              // TODO: it may be valuable to still optimize some of the loads
              //       from a store, even if others cannot be analyzed. We can
              //       do the store and also a tee, and load from the local in
              //       the loads we are sure of. Code size tradeoffs are 
              //       unclear, however.
              work.clear();
              storeLoads.erase(store);
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

  bool reachesGlobalCode(Expression* curr, const EffectAnalyzer& currEffects) {
    return currEffects.calls || currEffects.throws || currEffects.trap || curr->is<Return>();
  }

  // Check whether the values of two expressions are definitely identical.
  bool equivalent(Expression* a, Expression* b) {
    if (auto* aGet = a->dynCast<LocalGet>()) {
      if (auto* bGet = b->dynCast<LocalGet>()) {
        if (localGraph.equivalent(aGet, bGet)) {
          return true;
        }
      }
    }
    // TODO: Const, etc.
    return false;
  }
};

struct GCDeadStoreFinder : public DeadStoreFinder {
  GCDeadStoreFinder(Function* func, PassOptions& passOptions, FeatureSet features) : DeadStoreFinder(func, passOptions, features) {}

  bool isStore(Expression* curr) override {
    return curr->is<StructSet>();
  }

  bool isRelevant(Expression* curr, const EffectAnalyzer& currEffects) override {
    return curr->is<StructGet>();
  }

  bool isLoadFrom(Expression* curr, const EffectAnalyzer& currEffects, Expression* store_) override {
    if (auto* load = curr->dynCast<StructGet>()) {
      auto* store = store_->cast<StructSet>();
      // TODO: consider subtyping as well.
      return equivalent(load->ref, store->ref) && load->ref->type == store->ref->type && load->index == store->index;
    }
    return false;
  }

  bool tramples(Expression* curr, const EffectAnalyzer& currEffects, Expression* store_) override {
    if (auto* otherStore = curr->dynCast<StructSet>()) {
      auto* store = curr->cast<StructSet>();
      // TODO: consider subtyping as well.
      return equivalent(otherStore->ref, store->ref) && otherStore->ref->type == store->ref->type && otherStore->index == store->index;
    }
    return false;
  }

  bool mayInteract(Expression* curr, const EffectAnalyzer& currEffects, Expression* store) override {
    // We already checked isLoadFrom and tramples; if this is a StructSet that
    // is not a trample then we cannot be sure what is being set (due to not
    // recognizing the ref, etc.), and it may interact.
    return curr->is<StructSet>();
  }
};

struct DeadStoreElimination
  : public WalkerPass<PostWalker<DeadStoreElimination>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DeadStoreElimination; }

  void doWalkFunction(Function* func) {
    GCDeadStoreFinder gcFinder(func, getPassOptions(), getModule()->features);
    gcFinder.analyze();
    for (auto& kv : gcFinder.storeLoads) {
      std::cout << "dead:\n" << *kv.first << '\n';
    }
  }
};

Pass* createDeadStoreEliminationPass() { return new DeadStoreElimination(); }

} // namespace wasm
