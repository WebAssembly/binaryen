/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Analyzes stores and loads of non-local state, and optimizes them in various
// ways. For example, a store that is never read can be removed as dead.
//
// "Store" is used generically here to mean a write to a non-local location,
// which includes:
//
//  * Stores to linear memory (Store).
//  * Stores to globals (GlobalSet).
//  * Stores to GC data (StructSet, ArraySet)
//
// This pass optimizes all of the above.
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
struct BasicBlockInfo {
  // The list of relevant expressions, that are either stores or things that
  // interact with stores.
  std::vector<Expression*> exprs;
};

// A variation of LocalGraph that can also compare expressions to check for
// their equivalence. Basic LocalGraph just looks at locals, while this class
// goes further and looks at the structure of the expression, taking into
// account fallthrough values and other factors, in order to handle common
// cases of obviously-equivalent things.
struct ComparingLocalGraph : public LocalGraph {
  PassOptions& passOptions;
  FeatureSet features;

  ComparingLocalGraph(Function* func,
                      PassOptions& passOptions,
                      FeatureSet features)
    : LocalGraph(func), passOptions(passOptions), features(features) {}

  // Check whether the values of two expressions are definitely identical. This
  // is important for stores and loads that receive an input (like GC data),
  // since we need to see that the pointer input is equivalent before we can
  // tell if two stores overlap.
  // TODO: move to LocalGraph if we find more users?
  bool equivalent(Expression* a, Expression* b) {
    a = Properties::getFallthrough(a, passOptions, features);
    b = Properties::getFallthrough(b, passOptions, features);
    if (auto* aGet = a->dynCast<LocalGet>()) {
      if (auto* bGet = b->dynCast<LocalGet>()) {
        if (LocalGraph::equivalent(aGet, bGet)) {
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
};

// Whether this instruction can reach code we cannot reason about, that is,
// outside of the current function. Until we use whole-program information,
// we must assume such code can read and write to all global state.
static bool reachesUnknownCode(Expression* curr, const EffectAnalyzer& currEffects) {
  // TODO: ignore throws of an exception that is definitely caught in this
  //       function
  return currEffects.calls || currEffects.throws || currEffects.trap ||
         currEffects.branchesOut;
}

// Core code to generate the relevant CFG, analyze it, and optimize it.
//
// This is as generic as possible over what a "store" actually is; all the
// specific logic of handling globals vs memory vs the GC heap is all left to a
// to a LogicClass that this is templated on.
template<typename LogicType>
struct DeadStoreCFG
  : public CFGWalker<DeadStoreCFG<LogicType>,
                     UnifiedExpressionVisitor<DeadStoreCFG<LogicType>>,
                     BasicBlockInfo> {
  Function* func;
  PassOptions& passOptions;
  FeatureSet features;
  LogicType logic;

  DeadStoreCFG(Module* wasm, Function* func, PassOptions& passOptions)
    : func(func), passOptions(passOptions), features(wasm->features),
      logic(func, passOptions, wasm->features) {
    this->setModule(wasm);
  }

  ~DeadStoreCFG() {}

  // Walking

  // Map stores to the pointers to them, so that we can replace them. Note that
  // this assumes a pointer to a store is not on another store, as then we would
  // get invalidated; that can happen with locals,
  //  (local.tee $x
  //   (local.tee $y ..))
  // but it cannot happen with the stores we handle in this pass, as there is
  // no store that is a direct child of another store.
  // FIXME: when we replace loads as well, this will need to be generalized.
  std::unordered_map<Expression*, Expression**> storeLocations;

  void visitExpression(Expression* curr) {
    if (!this->currBasicBlock) {
      return;
    }

    ShallowEffectAnalyzer currEffects(passOptions, features, curr);

    // Add all relevant things to the list of exprs for the current basic block.
    bool store = logic.isStore(curr);
    if (store || reachesUnknownCode(curr, currEffects) ||
        logic.isAlsoRelevant(curr, currEffects)) {
      this->currBasicBlock->contents.exprs.push_back(curr);
      if (store) {
        storeLocations[curr] = this->getCurrentPointer();
      }
    }
  }

  // All the stores we can optimize, that is, stores that write to a non-local
  // place from which we have a full understanding of all the loads. This data
  // structure maps such an understood store to the list of loads for it. In
  // particular, if that list is empty then the store is dead (since we have
  // a full understanding of all the loads, and there are none), and if the list
  // is non-empty then only those loads read that store's value, and nothing
  // else.
  std::unordered_map<Expression*, std::vector<Expression*>> understoodStores;

  using BasicBlock =
    typename CFGWalker<DeadStoreCFG<LogicType>,
                       UnifiedExpressionVisitor<DeadStoreCFG<LogicType>>,
                       BasicBlockInfo>::BasicBlock;

  void analyze() {
    // create the CFG by walking the IR
    this->walkFunction(func);

    // Flow the values and conduct the analysis. This finds each relevant store
    // and then flows from it to all possible uses through the CFG.
    //
    // TODO: Optimize. This is a pretty naive way to flow the values, but it
    //       should be reasonable assuming most stores are quickly seen as
    //       having possible interactions (e.g., the first time we see a call)
    //       and so most flows are halted very quickly. A much faster lane-based
    //       flow is possible for some things like globals, but that would not
    //       work for things like memory and GC which do not have simple "lanes"
    //       as they have a pointer input as well and not just an absolute
    //       location that we can interprete as a "lane".

    for (auto& block : this->basicBlocks) {
      for (size_t i = 0; i < block->contents.exprs.size(); i++) {
        auto* store = block->contents.exprs[i];
        if (!logic.isStore(store)) {
          continue;
        }

        // The store is assumed to be understood (and hence present on the map)
        // until we see a problem.
        understoodStores[store];

        // Flow this store forward through basic blocks, looking for what it
        // affects and interacts with.
        UniqueNonrepeatingDeferredQueue<BasicBlock*> work;

        // When we find something we cannot optimize, stop flowing and mark the
        // store as unoptimizable.
        auto halt = [&]() {
          work.clear();
          understoodStores.erase(store);
        };

        // Scan through a block, starting from a certain position, looking for
        // loads, tramples, and other interactions with our store.
        auto scanBlock = [&](BasicBlock* block, size_t from) {
          for (size_t i = from; i < block->contents.exprs.size(); i++) {
            auto* curr = block->contents.exprs[i];

            ShallowEffectAnalyzer currEffects(passOptions, features, curr);

            if (logic.isLoadFrom(curr, currEffects, store)) {
              // We found a definite load of this store, note it.
              understoodStores[store].push_back(curr);
            } else if (logic.tramples(curr, currEffects, store)) {
              // We do not need to look any further along this block, or in
              // anything it can reach, as this store has been trampled.
              return;
            } else if (reachesUnknownCode(curr, currEffects) ||
                       logic.mayInteract(curr, currEffects, store)) {
              // Stop: we cannot fully analyze the uses of this store as
              // there are interactions we cannot see.
              // TODO: it may be valuable to still optimize some of the loads
              //       from a store, even if others cannot be analyzed. We can
              //       do the store and also a tee, and load from the local in
              //       the loads we are sure of. Code size tradeoffs are
              //       unclear, however.
              halt();
              return;
            }
          }

          // We reached the end of the block, prepare to flow onward.
          for (auto* out : block->out) {
            work.push(out);
          }

          if (block == this->exit) {
            // Any value flowing out can be reached by global code outside the
            // function after we leave.
            halt();
          }
        };

        // First, start in the current location in the block, right after the
        // store itself.
        scanBlock(block.get(), i + 1);

        // Next, continue flowing through other blocks.
        while (!work.empty()) {
          auto* curr = work.pop();
          scanBlock(curr, 0);
        }
      }
    }
  }

  // Optimizes the function, and returns whether we made any changes.
  bool optimize() {
    analyze();

    Builder builder(*this->getModule());

    bool optimized = false;

    // Optimize the stores that have no unknown interactions.
    for (auto& kv : understoodStores) {
      auto* store = kv.first;
      const auto& loads = kv.second;
      if (loads.empty()) {
        // This store has no loads, which means it is trampled by other stores
        // before it is read, and so it can just be dropped.
        //
        // Note that this is valid even if we care about implicit traps, such as
        // a trap from a store that is out of bounds. We are removing one store,
        // but it was trampled later, which means that a trap will still occur
        // at that time; furthermore, we do not delay the trap in a noticeable
        // way since if the path between the stores crosses anything that
        // affects global state then we would not have considered the store to
        // be trampled (it could have been read there).
        *storeLocations[store] = logic.replaceStoreWithDrops(store, builder);
        optimized = true;
      }
      // TODO: When there are loads, we can replace the loads as well (by saving
      //       the value to a local for that global, etc.).
      //       Note that we may need to leave the loads if they have side
      //       effects, like a possible trap on memory loads, but they can be
      //       left as dropped, the same as with store inputs.
    }

    return optimized;
  }
};

// Parent class of all implementations of the logic of identifying stores etc.
struct Logic {
  Function* func;

  Logic(Function* func, PassOptions& passOptions, FeatureSet features)
    : func(func) {}

  // Hooks for subclasses to override. (If one forgets to implement one then the
  // unreachables here will be hit.)
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
  bool isStore(Expression* curr) { WASM_UNREACHABLE("unimp"); };

  // Returns whether the expression is relevant for us to notice in the
  // analysis. This does not need to include anything isStore() returns true
  // on, as those are definitely relevant; hence the name.
  bool isAlsoRelevant(Expression* curr, const EffectAnalyzer& currEffects) {
    WASM_UNREACHABLE("unimp");
  };

  // Returns whether an expression is a load that corresponds to a store. The
  // load may not load all the data written by the store (that is up to a
  // subclass to decide about), but it loads at least some of that data.
  bool isLoadFrom(Expression* curr,
                  const EffectAnalyzer& currEffects,
                  Expression* store) {
    WASM_UNREACHABLE("unimp");
  };

  // Returns whether an expression tramples a store completely, overwriting all
  // the store's written data.
  // This is only called if isLoadFrom() returns false, as we assume there is no
  // single instruction that can do both.
  bool tramples(Expression* curr,
                const EffectAnalyzer& currEffects,
                Expression* store) {
    WASM_UNREACHABLE("unimp");
  };

  // Returns whether an expression may interact with store in a way that we
  // cannot fully analyze as a load or a store, and so we must give up. This may
  // be a possible load or a possible store or something else.
  // This is only called if isLoadFrom() and tramples() both return false, as
  // this method indicates an interaction we cannot analyze as either a load or
  // a trample.
  bool mayInteract(Expression* curr,
                   const EffectAnalyzer& currEffects,
                   Expression* store) {
    WASM_UNREACHABLE("unimp");
  };

  // Given a store that is not needed, get drops of its children to replace it
  // with. This effectively removes the store without removes its children.
  Expression* replaceStoreWithDrops(Expression* store, Builder& builder) {
    WASM_UNREACHABLE("unimp");
  };
};

// A logic that uses a local graph, as it needs to compare pointers.
struct ComparingLogic : public Logic {
  ComparingLocalGraph localGraph;

  ComparingLogic(Function* func, PassOptions& passOptions, FeatureSet features)
    : Logic(func, passOptions, features),
      localGraph(func, passOptions, features) {}
};

// Optimize module globals: GlobalSet/GlobalGet.
struct GlobalLogic : public Logic {
  GlobalLogic(Function* func, PassOptions& passOptions, FeatureSet features)
    : Logic(func, passOptions, features) {}

  bool isStore(Expression* curr) { return curr->is<GlobalSet>(); }

  bool isAlsoRelevant(Expression* curr, const EffectAnalyzer& currEffects) {
    return curr->is<GlobalGet>();
  }

  bool isLoadFrom(Expression* curr,
                  const EffectAnalyzer& currEffects,
                  Expression* store_) {
    if (auto* load = curr->dynCast<GlobalGet>()) {
      auto* store = store_->cast<GlobalSet>();
      return load->name == store->name;
    }
    return false;
  }

  bool tramples(Expression* curr,
                const EffectAnalyzer& currEffects,
                Expression* store_) {
    if (auto* otherStore = curr->dynCast<GlobalSet>()) {
      auto* store = store_->cast<GlobalSet>();
      return otherStore->name == store->name;
    }
    return false;
  }

  bool mayInteract(Expression* curr,
                   const EffectAnalyzer& currEffects,
                   Expression* store) {
    // We have already handled everything in isLoadFrom() and tramples().
    return false;
  }

  Expression* replaceStoreWithDrops(Expression* store, Builder& builder) {
    return builder.makeDrop(store->cast<GlobalSet>()->value);
  }
};

// Optimize memory stores/loads.
struct MemoryLogic : public ComparingLogic {
  MemoryLogic(Function* func, PassOptions& passOptions, FeatureSet features)
    : ComparingLogic(func, passOptions, features) {}

  bool isStore(Expression* curr) { return curr->is<Store>(); }

  bool isAlsoRelevant(Expression* curr, const EffectAnalyzer& currEffects) {
    return currEffects.readsMemory || currEffects.writesMemory;
  }

  bool isLoadFrom(Expression* curr,
                  const EffectAnalyzer& currEffects,
                  Expression* store_) {
    if (curr->type == Type::unreachable) {
      return false;
    }
    if (auto* load = curr->dynCast<Load>()) {
      auto* store = store_->cast<Store>();
      // Atomic stores are dangerous, since they have additional trapping
      // behavior - they trap on unaligned addresses. For simplicity, only
      // consider the case where atomicity is identical.
      if (store->isAtomic != load->isAtomic) {
        return false;
      }
      // TODO: For now, only handle the obvious case where the
      // operations are identical in size and offset.
      // TODO: handle cases where the sign may matter.
      return load->bytes == store->bytes &&
             load->bytes == load->type.getByteSize() &&
             load->offset == store->offset &&
             localGraph.equivalent(load->ptr, store->ptr);
    }
    return false;
  }

  bool tramples(Expression* curr,
                const EffectAnalyzer& currEffects,
                Expression* store_) {
    if (auto* otherStore = curr->dynCast<Store>()) {
      auto* store = store_->cast<Store>();
      // As in isLoadFrom, atomic stores are dangerous.
      if (store->isAtomic != otherStore->isAtomic) {
        return false;
      }
      // TODO: compare in detail. For now, handle the obvious case where the
      // stores are identical in size, offset, etc., so that identical repeat
      // stores are handled.
      return otherStore->bytes == store->bytes &&
             otherStore->offset == store->offset &&
             localGraph.equivalent(otherStore->ptr, store->ptr);
    }
    return false;
  }

  bool mayInteract(Expression* curr,
                   const EffectAnalyzer& currEffects,
                   Expression* store) {
    // Anything we did not identify so far is dangerous.
    return currEffects.readsMemory || currEffects.writesMemory;
  }

  Expression* replaceStoreWithDrops(Expression* store, Builder& builder) {
    auto* castStore = store->cast<Store>();
    return builder.makeSequence(builder.makeDrop(castStore->ptr),
                                builder.makeDrop(castStore->value));
  }
};

// Optimize GC data: StructGet/StructSet.
// TODO: Arrays.
struct GCLogic : public ComparingLogic {
  GCLogic(Function* func, PassOptions& passOptions, FeatureSet features)
    : ComparingLogic(func, passOptions, features) {}

  bool isStore(Expression* curr) { return curr->is<StructSet>(); }

  bool isAlsoRelevant(Expression* curr, const EffectAnalyzer& currEffects) {
    return curr->is<StructGet>();
  }

  bool isLoadFrom(Expression* curr,
                  const EffectAnalyzer& currEffects,
                  Expression* store_) {
    if (auto* load = curr->dynCast<StructGet>()) {
      auto* store = store_->cast<StructSet>();
      // Note that we do not need to check the type: we check that the
      // reference is equivalent, and if it is then the types must be compatible
      // in addition to them pointing to the same memory.
      return localGraph.equivalent(load->ref, store->ref) &&
             load->index == store->index;
    }
    return false;
  }

  bool tramples(Expression* curr,
                const EffectAnalyzer& currEffects,
                Expression* store_) {
    if (auto* otherStore = curr->dynCast<StructSet>()) {
      auto* store = store_->cast<StructSet>();
      // See note in isLoadFrom about typing.
      return localGraph.equivalent(otherStore->ref, store->ref) &&
             otherStore->index == store->index;
    }
    return false;
  }

  bool mayInteract(Expression* curr,
                   const EffectAnalyzer& currEffects,
                   Expression* store_) {
    auto* store = store_->cast<StructSet>();
    // We already checked isLoadFrom and tramples and it was neither of those,
    // so just check if the memory can possibly alias, which is whether this has
    // the same index.
    // TODO: use the type system more here
    if (auto* otherStore = curr->dynCast<StructSet>()) {
      return otherStore->index == store->index;
    }
    if (auto* load = curr->dynCast<StructGet>()) {
      return load->index == store->index;
    }
    // This is not a load or a store that we recognize; check for generic heap
    // interactions.
    return currEffects.readsHeap || currEffects.writesHeap;
  }

  Expression* replaceStoreWithDrops(Expression* store, Builder& builder) {
    auto* castStore = store->cast<StructSet>();
    return builder.makeSequence(builder.makeDrop(castStore->ref),
                                builder.makeDrop(castStore->value));
  }
};

// Perform dead store elimination 100% locally, that is, without any whole-
// program analysis. This is not very powerful, but is useful for testing.
struct LocalDeadStoreElimination
  : public WalkerPass<PostWalker<LocalDeadStoreElimination>> {
  bool isFunctionParallel() { return true; }

  Pass* create() { return new LocalDeadStoreElimination; }

  void doWalkFunction(Function* func) {
    // Optimize globals.
    DeadStoreCFG<GlobalLogic>(getModule(), func, getPassOptions())
      .optimize();

    // Optimize memory.
    DeadStoreCFG<MemoryLogic>(getModule(), func, getPassOptions())
      .optimize();

    // Optimize GC heap.
    if (getModule()->features.hasGC()) {
      DeadStoreCFG<GCLogic>(getModule(), func, getPassOptions()).optimize();
    }
  }
};

} // anonymous namespace

// TODO: make global/local/optimizing variants

Pass* createLocalDeadStoreEliminationPass() {
  return new LocalDeadStoreElimination();
}

} // namespace wasm
