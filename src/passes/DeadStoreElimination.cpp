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
#include <ir/properties.h>
#include <pass.h>
#include <support/unique_deferring_queue.h>
#include <wasm-builder.h>
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

struct DeadStoreFinder
  : public CFGWalker<DeadStoreFinder,
                     UnifiedExpressionVisitor<DeadStoreFinder>,
                     Info> {
  Function* func;
  PassOptions& passOptions;
  FeatureSet features;

  // TODO: make this heavy computation optional?
  LocalGraph localGraph;

  DeadStoreFinder(Module* wasm, Function* func, PassOptions& passOptions)
    : func(func), passOptions(passOptions), features(wasm->features),
      localGraph(func) {
    setModule(wasm);
  }

  virtual ~DeadStoreFinder() {}

  // Hooks for subclasses.
  //
  // Some of these methods receive computed effects, which do not include their
  // children (as in each basic block we process expressions in a linear order,
  // and have already seen the children).
  //
  // These do not need to handle reaching of code outside of the current
  // function: a call, return, etc. will be noted as a possible interaction
  // automatically (as if we reach code outside the function then any
  // interaction is possible).

  // Returns whether an expression is a relevant store for us to consider.
  virtual bool isStore(Expression* curr) = 0;

  // Returns whether the expression is relevant for us to notice in the
  // analysis. (This does not need to include anything isStore() returns true
  // on, as those are definitely relevant.)
  virtual bool isRelevant(Expression* curr,
                          const EffectAnalyzer& currEffects) = 0;

  // Returns whether an expression is a load that corresponds to a store. The
  // load may not load all the data written by the store (that is up to a
  // subclass to decide about), but it loads at least some of that data.
  virtual bool isLoadFrom(Expression* curr,
                          const EffectAnalyzer& currEffects,
                          Expression* store) = 0;

  // Returns whether an expression tramples a store completely, overwriting all
  // the store's written data.
  // This is only called if isLoadFrom returns false.
  virtual bool tramples(Expression* curr,
                        const EffectAnalyzer& currEffects,
                        Expression* store) = 0;

  // Returns whether an expression may interact with store in a way that we
  // cannot fully analyze as a load or a store, and so we must give up. This may
  // be a possible load or a possible store or something else.
  // This is only called if isLoadFrom and tramples return false.
  virtual bool mayInteract(Expression* curr,
                           const EffectAnalyzer& currEffects,
                           Expression* store) = 0;

  // Given a store that is not needed, get drops of its children to replace it
  // with.
  virtual Expression* replaceStoreWithDrops(Expression* store,
                                            Builder& builder) = 0;

  // Walking

  // XXX this is not enough, as we may change a location we store to. Need a
  // whole post-pass to write out changes x->y
  std::unordered_map<Expression*, Expression**> storeLocations;

  void visitExpression(Expression* curr) {
    if (!currBasicBlock) {
      return;
    }

    EffectAnalyzer currEffects(passOptions, features);
    currEffects.visit(curr);

    bool store = isStore(curr);
    if (reachesGlobalCode(curr, currEffects) || isRelevant(curr, currEffects) ||
        store) {
      currBasicBlock->contents.exprs.push_back(curr);
      if (store) {
        storeLocations[curr] = getCurrentPointer();
      }
    }
  }

  // Maps a store to the loads from it. If a store is in this map then all the
  // loads could be analyzed, and are all present in the vector for that store.
  std::unordered_map<Expression*, std::vector<Expression*>> storeLoads;

  void analyze() {
    // create the CFG by walking the IR
    doWalkFunction(func);

    Return ret;
    if (currBasicBlock) {
      // Ensure a final return on the last block, to represent us leaving the
      // function (which just like a return in the middle, means we reach code
      // that can access global state).
      currBasicBlock->contents.exprs.push_back(&ret);
    }

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

        // std::cerr << "store:\n" << *store << '\n';
        // Flow this store forward, looking for what it affects and interacts
        // with.
        UniqueNonrepeatingDeferredQueue<BasicBlock*> work;

        auto scanBlock = [&](BasicBlock* block, size_t from) {
          // std::cerr << "scan block " << block << "\n";
          for (size_t i = from; i < block->contents.exprs.size(); i++) {
            auto* curr = block->contents.exprs[i];

            EffectAnalyzer currEffects(passOptions, features);
            currEffects.visit(curr);
            // std::cerr << "at curr:\n" << *curr << '\n';

            if (isLoadFrom(curr, currEffects, store)) {
              // We found a definite load, note it.
              storeLoads[store].push_back(curr);
              // std::cerr << "  found load\n";
            } else if (tramples(curr, currEffects, store)) {
              // We do not need to look any further along this block, or in
              // anything it can reach.
              // std::cerr << "  found trample\n";
              return;
            } else if (reachesGlobalCode(curr, currEffects) ||
                       mayInteract(curr, currEffects, store)) {
              // std::cerr << "  found mayInteract\n";
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
          // std::cerr << "work iter\n";
          auto* curr = work.pop();
          scanBlock(curr, 0);
        }
        // std::cerr << "work done\n";
      }
    }
    // std::cerr << "all work done\n";
  }

  bool reachesGlobalCode(Expression* curr, const EffectAnalyzer& currEffects) {
    return currEffects.calls || currEffects.throws || currEffects.trap ||
           curr->is<Return>();
  }

  // Check whether the values of two expressions are definitely identical.
  // TODO: move to localgraph?
  bool equivalent(Expression* a, Expression* b) {
    // std::cerr << "eqiv\n" << *a << '\n';
    // std::cerr << "eqiv\n" << *b << '\n';
    a = Properties::getFallthrough(a, passOptions, features);
    b = Properties::getFallthrough(b, passOptions, features);
    // std::cerr << "Zeqiv\n" << *a << '\n';
    // std::cerr << "Zeqiv\n" << *b << '\n';
    if (auto* aGet = a->dynCast<LocalGet>()) {
      if (auto* bGet = b->dynCast<LocalGet>()) {
        if (localGraph.equivalent(aGet, bGet)) {
          return true;
        }
      }
    }
    if (auto* aConst = a->dynCast<Const>()) {
      if (auto* bConst = b->dynCast<Const>()) {
        return aConst->value == bConst->value;
      }
    }
    return false;
  }

  void optimize() {
    analyze();

    Builder builder(*getModule());

    // Optimize the stores that have no unknown interactions.
    for (auto& kv : storeLoads) {
      auto* store = kv.first;
      const auto& loads = kv.second;
      if (loads.empty()) {
        // This store has no loads, and can just be dropped.
        // Note that this is valid even if we care about implicit traps, such as
        // a trap from a store that is out of bounds. We are removing one store,
        // but it was trampled later, which means that a trap will still occur
        // at that time; furthermore, we do not delay the trap in a noticeable
        // way since if the path between the stores crosses anything that
        // affects global state then we would not have considered the store to
        // be trampled (it could have been read there).
        *storeLocations[store] = replaceStoreWithDrops(store, builder);
      } else {
        // TODO: when not empty, use a local and replace loads too, one local
        //       per "lane"
        // TODO: must prove no dangerous store reaches those places
        // TODO: this is technically only possible when ignoring implicit traps
        // std::cerr << "waka " << loads.size() << "\n";
      }
    }
  }
};

struct GlobalDeadStoreFinder : public DeadStoreFinder {
  GlobalDeadStoreFinder(Module* wasm, Function* func, PassOptions& passOptions)
    : DeadStoreFinder(wasm, func, passOptions) {}

  bool isStore(Expression* curr) override { return curr->is<GlobalSet>(); }

  bool isRelevant(Expression* curr,
                  const EffectAnalyzer& currEffects) override {
    return curr->is<GlobalGet>();
  }

  bool isLoadFrom(Expression* curr,
                  const EffectAnalyzer& currEffects,
                  Expression* store_) override {
    if (auto* load = curr->dynCast<GlobalGet>()) {
      auto* store = store_->cast<GlobalSet>();
      return load->name == store->name;
    }
    return false;
  }

  bool tramples(Expression* curr,
                const EffectAnalyzer& currEffects,
                Expression* store_) override {
    if (auto* otherStore = curr->dynCast<GlobalSet>()) {
      auto* store = store_->cast<GlobalSet>();
      return otherStore->name == store->name;
    }
    return false;
  }

  bool mayInteract(Expression* curr,
                   const EffectAnalyzer& currEffects,
                   Expression* store) override {
    // We have already handled everything in isLoadFrom() and tramples().
    return false;
  }

  Expression* replaceStoreWithDrops(Expression* store,
                                    Builder& builder) override {
    return builder.makeDrop(store->cast<GlobalSet>()->value);
  }
};

struct MemoryDeadStoreFinder : public DeadStoreFinder {
  MemoryDeadStoreFinder(Module* wasm, Function* func, PassOptions& passOptions)
    : DeadStoreFinder(wasm, func, passOptions) {}

  bool isStore(Expression* curr) override { return curr->is<Store>(); }

  bool isRelevant(Expression* curr,
                  const EffectAnalyzer& currEffects) override {
    return currEffects.readsMemory || currEffects.writesMemory;
  }

  bool isLoadFrom(Expression* curr,
                  const EffectAnalyzer& currEffects,
                  Expression* store_) override {
    if (auto* load = curr->dynCast<Load>()) {
      auto* store = store_->cast<Store>();
      // Atomic stores are dangerous, since they have additional trapping
      // behavior - they trap on unaligned addresses. For that reason we can't
      // consider an atomic store to be loaded by a non-atomic one, though the
      // reverse is valid.
      if (store->isAtomic && !load->isAtomic) {
        return false;
      }
      // TODO: For now, only handle the obvious case where the
      // operations are identical in size and offset.
      // TODO: handle cases where the sign may matter.
      return load->bytes == store->bytes &&
             load->bytes == load->type.getByteSize() &&
             load->offset == store->offset && equivalent(load->ptr, store->ptr);
    }
    return false;
  }

  bool tramples(Expression* curr,
                const EffectAnalyzer& currEffects,
                Expression* store_) override {
    if (auto* otherStore = curr->dynCast<Store>()) {
      auto* store = store_->cast<Store>();
      // As in isLoadFrom, atomic stores are dangerous.
      if (store->isAtomic && !otherStore->isAtomic) {
        return false;
      }
      // TODO: compare in detail. For now, handle the obvious case where the
      // stores are identical in size, offset, etc., so that identical repeat
      // stores are handled.
      return otherStore->bytes == store->bytes &&
             otherStore->offset == store->offset &&
             equivalent(otherStore->ptr, store->ptr);
    }
    return false;
  }

  bool mayInteract(Expression* curr,
                   const EffectAnalyzer& currEffects,
                   Expression* store) override {
    // Anything we did not identify so far is dangerous.
    return currEffects.readsMemory || currEffects.writesMemory;
  }

  Expression* replaceStoreWithDrops(Expression* store,
                                    Builder& builder) override {
    auto* castStore = store->cast<Store>();
    return builder.makeSequence(builder.makeDrop(castStore->ptr),
                                builder.makeDrop(castStore->value));
  }
};

struct GCDeadStoreFinder : public DeadStoreFinder {
  GCDeadStoreFinder(Module* wasm, Function* func, PassOptions& passOptions)
    : DeadStoreFinder(wasm, func, passOptions) {}

  bool isStore(Expression* curr) override { return curr->is<StructSet>(); }

  bool isRelevant(Expression* curr,
                  const EffectAnalyzer& currEffects) override {
    return curr->is<StructGet>();
  }

  bool isLoadFrom(Expression* curr,
                  const EffectAnalyzer& currEffects,
                  Expression* store_) override {
    if (auto* load = curr->dynCast<StructGet>()) {
      auto* store = store_->cast<StructSet>();
      // TODO: consider subtyping as well.
      return equivalent(load->ref, store->ref) &&
             load->ref->type == store->ref->type && load->index == store->index;
    }
    return false;
  }

  bool tramples(Expression* curr,
                const EffectAnalyzer& currEffects,
                Expression* store_) override {
    if (auto* otherStore = curr->dynCast<StructSet>()) {
      auto* store = store_->cast<StructSet>();
      // TODO: consider subtyping as well.
      return equivalent(otherStore->ref, store->ref) &&
             otherStore->ref->type == store->ref->type &&
             otherStore->index == store->index;
    }
    return false;
  }

  bool mayInteract(Expression* curr,
                   const EffectAnalyzer& currEffects,
                   Expression* store) override {
    // We already checked isLoadFrom and tramples; if this is a struct
    // operation that we did not recognize, then give up.
    // TODO if we can identify the ref, use the type system here
    return currEffects.readsHeap || currEffects.writesHeap;
  }

  Expression* replaceStoreWithDrops(Expression* store,
                                    Builder& builder) override {
    auto* castStore = store->cast<StructSet>();
    return builder.makeSequence(builder.makeDrop(castStore->ref),
                                builder.makeDrop(castStore->value));
  }
};

struct DeadStoreElimination
  : public WalkerPass<PostWalker<DeadStoreElimination>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new DeadStoreElimination; }

  void doWalkFunction(Function* func) {
    GlobalDeadStoreFinder(getModule(), func, getPassOptions()).optimize();
    MemoryDeadStoreFinder(getModule(), func, getPassOptions()).optimize();
    if (getModule()->features.hasGC()) {
      GCDeadStoreFinder(getModule(), func, getPassOptions()).optimize();
    }
  }
};

Pass* createDeadStoreEliminationPass() { return new DeadStoreElimination(); }

} // namespace wasm
