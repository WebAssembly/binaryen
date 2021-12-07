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
// ways. For example, a store that is never read, because the global state will
// be trampled anyhow, can be removed as dead.
//
// "Store" is used generically here to mean a write to a non-local location,
// which includes:
//
//  * Stores to linear memory (Store).
//  * Stores to globals (GlobalSet).
//  * Stores to GC data (StructSet, ArraySet)
//
// This pass optimizes all of the above. It does so using a generic framework in
// order to share as much code as possible between them. This has downsides for
// globals, in particular, as they could be optimized with an IR that is tailor-
// made for scanning of global indexes (much as we do in our analyses of locals
// in other places). However, global operations are also less common than memory
// and GC operations, so hopefully the tradeoff is reasonable.
//
// The generic framework here can handle both "statically" connected loads and
// stores - for example, a load of a global of index N, after a store to that
// index - and "dynamically" connected loads and stores - for example, a load of
// a GC struct field N from a pointer P, after a store to that same pointer and
// field. "Dynamic" here is used in the sense that we don't have a simple static
// indexing of all the things we care about, sometimes called "lanes" in other
// implementations. Instead we need to care about pointer identity, aliasing,
// etc., which means we need to "dynamically" compare loads and stores and not
// just a "lane" index computed for them. Note that in theory an index could
// still be computed for such things, but probably at the cost of greater
// complexity; if speed becomes an issue, then a refactoring in that direction
// may be necessary. Such a refactoring might have downsides, however: While
// having a single index for each operation is efficient, we would also need a
// a way to represent "wildcards" - things that affect multiple indexes. For
// example, an indirect call must be assumed to affect anything. But more
// complex cases include a GC store of a certain type, which we can infer may
// affect anything with a relevant subtype (but others cannot alias). To handle
// that, we would need to store a set of indexes, already losing much of the
// benefit of the indexed approach. Instead, the current code keeps things very
// simple by just asking "may these two things interact", in which we can just
// check the subtyping, etc.
//

#include <cfg/cfg-traversal.h>
#include <ir/effects.h>
#include <ir/local-graph.h>
#include <ir/properties.h>
#include <ir/replacer.h>
#include <pass.h>
#include <support/unique_deferring_queue.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

namespace {

// A variation of LocalGraph that can also compare expressions to check for
// their equivalence. Basic LocalGraph just looks at locals, while this class
// goes further and looks at the structure of the expression, taking into
// account fallthrough values and other factors, in order to handle common
// cases of obviously-identical things. To achieve that, it needs to know the
// pass options and features used, which we avoid adding to the basic
// LocalGraph.
struct ComparingLocalGraph : public LocalGraph {
  PassOptions& passOptions;
  FeatureSet features;

  ComparingLocalGraph(Function* func,
                      PassOptions& passOptions,
                      FeatureSet features)
    : LocalGraph(func), passOptions(passOptions), features(features) {}

  // Check whether the values of two expressions will definitely be equal at
  // runtime.
  // TODO: move to LocalGraph if we find more users?
  bool equalValues(Expression* a, Expression* b) {
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

// Parent class of all implementations of the logic of identifying stores etc.
// One implementation of Logic can handle globals, another memory, and another
// GC, etc., implementing the various hooks appropriately.
struct Logic {
  Function* func;

  Logic(Function* func, PassOptions& passOptions, FeatureSet features)
    : func(func) {}

  //============================================================================
  // Hooks to identify relevant things to include in the analysis.
  //============================================================================

  // Returns whether an expression is a store.
  //
  // The main code will automatically ignore unreachable (irrelevant) stores.
  bool isStore(Expression* curr) { WASM_UNREACHABLE("unimp"); };

  // Returns whether an expression is a load.
  //
  // The main code will automatically ignore unreachable (irrelevant) loads.
  bool isLoad(Expression* curr) { WASM_UNREACHABLE("unimp"); };

  // Returns whether the expression is a barrier to our analysis: something that
  // we should stop when we see it, because it could do things that we cannot
  // analyze. A barrier will definitely pose a problem for us, as opposed to
  // something mayInteract() returns true for - we will check for interactions
  // later for mayInteract()s, but with barriers we don't need to.
  //
  // The default behavior here considers all calls to be barriers. Subclasses
  // can use whole-program information to do better.
  bool isBarrier(Expression* curr, const ShallowEffectAnalyzer& currEffects) {
    // TODO: ignore throws of an exception that is definitely caught in this
    //       function
    // TODO: if we add an "ignore after trap mode" (to assume nothing happens
    //       after a trap) then we could stop assuming any trap can lead to
    //       access of global data, likely greatly reducing the number of
    //       barriers.
    return currEffects.calls || currEffects.throws || currEffects.trap ||
           currEffects.branchesOut;
  };

  // Returns whether an expression may interact with loads and stores in
  // interesting ways. This is only called if isStore(), isLoad(), and
  // isBarrier() all return false; that is, if we cannot identify the expression
  // as one of those simple categories, this allows us to still care about it in
  // our analysis.
  bool mayInteract(Expression* curr, const ShallowEffectAnalyzer& currEffects) {
    WASM_UNREACHABLE("unimp");
  }

  //============================================================================
  // Hooks that run during the analysis
  //============================================================================

  // Returns whether an expression is a load that corresponds to a store, that
  // is, that loads the exact data that the store writes.
  bool isLoadFrom(Expression* curr,
                  const ShallowEffectAnalyzer& currEffects,
                  Expression* store) {
    WASM_UNREACHABLE("unimp");
  };

  // Returns whether an expression tramples a store completely, overwriting all
  // the store's written data.
  //
  // This is only called if isLoadFrom() returns false, as we assume there is no
  // single instruction of interest to us that can do both.
  bool isTrample(Expression* curr,
                 const ShallowEffectAnalyzer& currEffects,
                 Expression* store) {
    WASM_UNREACHABLE("unimp");
  };

  // Returns whether an expression may interact with another in a way that we
  // cannot fully analyze, and so we must give up and assume the very worst.
  // This is only called if isLoadFrom() and isTrample() both return false.
  //
  // This is similar to mayInteract(), but considers a specific interaction with
  // another particular expression. mayInteract() leads to it being included in
  // the analysis, during which mayInteractWith() will be called.
  bool mayInteractWith(Expression* curr,
                       const ShallowEffectAnalyzer& currEffects,
                       Expression* store) {
    WASM_UNREACHABLE("unimp");
  };

  //============================================================================
  // Hooks used when applying optimizations after the analysis.
  //============================================================================

  // Given a store that is not needed, get drops of its children to replace it
  // with. This effectively removes the store without removing its children.
  Expression* replaceStoreWithDrops(Expression* store, Builder& builder) {
    WASM_UNREACHABLE("unimp");
  };
};

// Represent all barriers in a simple way.
static Nop nop;
static Expression* const barrier = &nop;

// Information in a basic block in the main analysis. All we use is a simple
// list of relevant expressions (stores, loads, and things that interact with
// them).
struct BasicBlockInfo {
  std::vector<Expression*> exprs;
};

// Core code to generate the relevant CFG, analyze it, and optimize it.
//
// This is as generic as possible over what a "store" actually is; all the
// specific logic of handling globals vs memory vs the GC heap is all left to a
// to a LogicType that this is templated on, which subclasses from Logic.
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

  void visitExpression(Expression* curr) {
    if (!this->currBasicBlock) {
      return;
    }

    ShallowEffectAnalyzer currEffects(passOptions, features, curr);

    auto& exprs = this->currBasicBlock->contents.exprs;

    // Add all relevant things to the list of exprs for the current basic block.
    if (isStore(curr) || isLoad(curr)) {
      exprs.push_back(curr);
    } else if (logic.isBarrier(curr, currEffects)) {
      // Barriers can be very common, so as a minor optimization avoid having
      // consecutive ones; a single barrier will stop us.
      if (exprs.empty() || exprs.back() != barrier) {
        exprs.push_back(barrier);
      }
    } else if (logic.mayInteract(curr, currEffects)) {
      exprs.push_back(curr);
    }
  }

  // Filter out unreachable (irrelevant) loads and stores.
  bool isStore(Expression* curr) {
    return curr->type != Type::unreachable && logic.isStore(curr);
  }
  bool isLoad(Expression* curr) {
    return curr->type != Type::unreachable && logic.isLoad(curr);
  }

  // All the stores we can optimize, that is, stores that write to a non-local
  // place from which we have a full understanding of all the loads. This data
  // structure maps such an understood store to the list of loads for it. In
  // particular, if that list is empty then the store is dead (since we have
  // a full understanding of all the loads, and there are none), and if the list
  // is non-empty then only those loads read that store's value, and nothing
  // else.
  std::unordered_map<Expression*, std::vector<Expression*>> understoodStores;

  using Self = DeadStoreCFG<LogicType>;

  using BasicBlock = typename CFGWalker<Self,
                                        UnifiedExpressionVisitor<Self>,
                                        BasicBlockInfo>::BasicBlock;

  void analyze() {
    // create the CFG by walking the IR
    this->walkFunction(func);

    // Flow the values and conduct the analysis. This finds each relevant store
    // and then flows from it to all possible uses through the CFG.
    //
    // TODO: Optimize. This is a pretty naive way to flow the values, but it
    //       should be reasonable assuming most stores are quickly seen as
    //       having possible interactions (e.g., when we encounter a barrier),
    //       and so most flows are halted very quickly.

    for (auto& block : this->basicBlocks) {
      for (size_t i = 0; i < block->contents.exprs.size(); i++) {
        auto* store = block->contents.exprs[i];

        if (!isStore(store)) {
          continue;
        }

        // The store is assumed to be understood (and hence present on the map)
        // until we see a problem.
        understoodStores[store];

        // Flow this store forward through basic blocks, looking for
        // interactions.
        UniqueNonrepeatingDeferredQueue<BasicBlock*> work;

        // When we find something we cannot optimize, stop flowing and mark the
        // store as unoptimizable.
        auto halt = [&]() {
          work.clear();
          understoodStores.erase(store);
        };

        // Scan through a block, starting from a certain position, looking for
        // interactions.
        auto scanBlock = [&](BasicBlock* block, size_t from) {
          for (size_t i = from; i < block->contents.exprs.size(); i++) {
            auto* curr = block->contents.exprs[i];

            if (curr == barrier) {
              halt();
              return;
            }

            ShallowEffectAnalyzer currEffects(passOptions, features, curr);

            if (logic.isLoadFrom(curr, currEffects, store)) {
              // We found a definite load of this store, note it.
              understoodStores[store].push_back(curr);
            } else if (logic.isTrample(curr, currEffects, store)) {
              // We do not need to look any further along this block, or in
              // anything it can reach, as this store has been trampled.
              return;
            } else if (logic.mayInteractWith(curr, currEffects, store)) {
              // Stop: we cannot fully analyze the uses of this store.
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

        // Start the flow in the current location in the block, right after the
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

    ExpressionReplacer replacer;

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
        // at that time, if the store is out of bounds; furthermore, we do not
        // delay the trap in a noticeable way since if the path between the
        // stores crosses anything that affects global state then we would not
        // have considered the store to be trampled (it could have been
        // interacted with, which would have stopped the analysis).
        replacer.replacements[store] =
          logic.replaceStoreWithDrops(store, builder);
      }
      // TODO: When there are loads, we can replace the loads as well (by saving
      //       the value to a local for that global, etc.).
      //       Note that we may need to leave the loads if they have side
      //       effects, like a possible trap on memory loads, but they can be
      //       left as dropped, the same as with store inputs.
    }

    if (replacer.replacements.empty()) {
      return false;
    }

    replacer.walk(this->func->body);

    return true;
  }
};

// A logic that uses a local graph, as it needs to compare pointers.
// TODO: run the LocalGraph only on relevant locals (only i32s can be pointers
//       for loads and stores; only references can be pointers for GC)
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

  bool isLoad(Expression* curr) { return curr->is<GlobalGet>(); }

  bool mayInteract(Expression* curr, const ShallowEffectAnalyzer& currEffects) {
    // Globals are easy to statically analyze: there are no interactions we
    // cannot be sure about.
    return false;
  }

  bool isLoadFrom(Expression* curr,
                  const ShallowEffectAnalyzer& currEffects,
                  Expression* store_) {
    if (auto* load = curr->dynCast<GlobalGet>()) {
      auto* store = store_->cast<GlobalSet>();
      return load->name == store->name;
    }
    return false;
  }

  bool isTrample(Expression* curr,
                 const ShallowEffectAnalyzer& currEffects,
                 Expression* store_) {
    if (auto* otherStore = curr->dynCast<GlobalSet>()) {
      auto* store = store_->cast<GlobalSet>();
      return otherStore->name == store->name;
    }
    return false;
  }

  bool mayInteractWith(Expression* curr,
                       const ShallowEffectAnalyzer& currEffects,
                       Expression* store) {
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

  bool isLoad(Expression* curr) { return curr->is<Load>(); }

  bool mayInteract(Expression* curr, const ShallowEffectAnalyzer& currEffects) {
    return currEffects.readsMemory || currEffects.writesMemory;
  }

  bool isLoadFrom(Expression* curr,
                  const ShallowEffectAnalyzer& currEffects,
                  Expression* store_) {
    if (curr->type == Type::unreachable) {
      return false;
    }
    if (auto* load = curr->dynCast<Load>()) {
      auto* store = store_->cast<Store>();

      // Atomic stores are dangerous, since they have additional trapping
      // behavior - they trap on unaligned addresses. For simplicity, only
      // consider the case where atomicity is identical.
      // TODO: use ignoreImplicitTraps
      if (store->isAtomic != load->isAtomic) {
        return false;
      }

      // TODO: For now, only handle the obvious case where the operations are
      //       identical in size and offset.
      return load->bytes == store->bytes &&
             load->bytes == load->type.getByteSize() &&
             load->offset == store->offset &&
             localGraph.equalValues(load->ptr, store->ptr);
    }
    return false;
  }

  bool isTrample(Expression* curr,
                 const ShallowEffectAnalyzer& currEffects,
                 Expression* store_) {
    if (auto* otherStore = curr->dynCast<Store>()) {
      auto* store = store_->cast<Store>();

      // As in isLoadFrom, atomic stores are dangerous.
      if (store->isAtomic != otherStore->isAtomic) {
        return false;
      }

      // TODO: Compare in detail. For now, handle the obvious case where the
      //       stores are identical in size, offset, etc., so that identical
      //       repeat stores are handled. (An example of a case we do not handle
      //       yet is a store of 1 byte that is trampled by a store of 2 bytes.)
      return otherStore->bytes == store->bytes &&
             otherStore->offset == store->offset &&
             localGraph.equalValues(otherStore->ptr, store->ptr);
    }
    return false;
  }

  bool mayInteractWith(Expression* curr,
                       const ShallowEffectAnalyzer& currEffects,
                       Expression* store) {
    // Anything we did not identify so far is dangerous.
    //
    // Among other things, this includes compare-and-swap, which does both a
    // read and a write, which our infrastructure is not build to optimize.
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

  bool isLoad(Expression* curr) { return curr->is<StructGet>(); }

  bool mayInteract(Expression* curr, const ShallowEffectAnalyzer& currEffects) {
    return currEffects.readsHeap || currEffects.writesHeap;
  }

  bool isLoadFrom(Expression* curr,
                  const ShallowEffectAnalyzer& currEffects,
                  Expression* store_) {
    if (auto* load = curr->dynCast<StructGet>()) {
      auto* store = store_->cast<StructSet>();

      // Note that we do not need to check the type: we check that the
      // reference is identical, and if it is then the types must be compatible
      // in addition to them pointing to the same memory.
      return localGraph.equalValues(load->ref, store->ref) &&
             load->index == store->index;
    }
    return false;
  }

  bool isTrample(Expression* curr,
                 const ShallowEffectAnalyzer& currEffects,
                 Expression* store_) {
    if (auto* otherStore = curr->dynCast<StructSet>()) {
      auto* store = store_->cast<StructSet>();

      // See note in isLoadFrom about typing.
      return localGraph.equalValues(otherStore->ref, store->ref) &&
             otherStore->index == store->index;
    }
    return false;
  }

  // Check whether two GC operations may alias memory.
  template<typename U, typename V> bool mayAlias(U* u, V* v) {
    // If one of the inputs is unreachable, it does not execute, and so there
    // cannot be aliasing.
    auto uType = u->ref->type;
    auto vType = v->ref->type;
    if (uType == Type::unreachable || vType == Type::unreachable) {
      return false;
    }

    // If the index does not match, no aliasing is possible.
    if (u->index != v->index) {
      return false;
    }

    // Even if the index is identical, aliasing still may be impossible. For
    // aliasing to occur, the same data must be pointed to by both references,
    // which means the actual data is a subtype of both the present types. For
    // that to be possible, one of the present heap types must be a subtype of
    // the other (note that we check heap types, in order to ignore
    // nullability).
    auto uHeapType = uType.getHeapType();
    auto vHeapType = vType.getHeapType();
    return HeapType::isSubType(uHeapType, vHeapType) ||
           HeapType::isSubType(vHeapType, uHeapType);
  }

  bool mayInteractWith(Expression* curr,
                       const ShallowEffectAnalyzer& currEffects,
                       Expression* store_) {
    auto* store = store_->cast<StructSet>();

    // We already checked isLoadFrom and isTrample and it was neither of those,
    // so just check if the memory can possibly alias.
    if (auto* otherStore = curr->dynCast<StructSet>()) {
      return mayAlias(otherStore, store);
    }
    if (auto* load = curr->dynCast<StructGet>()) {
      return mayAlias(load, store);
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
// program analysis. This is not very powerful, but can catch simple patterns of
// obviously dead stores, and is useful for testing.
//
// This does all the optimizations (globals, memory, GC) in sequence on each
// function, which is good for cache locality. That is the reason there are not
// separate passes for each one.
// TODO: the optimizations can perhaps share more things between them
struct LocalDeadStoreElimination
  : public WalkerPass<PostWalker<LocalDeadStoreElimination>> {
  bool isFunctionParallel() { return true; }

  Pass* create() { return new LocalDeadStoreElimination; }

  void doWalkFunction(Function* func) {
    // Optimize globals.
    DeadStoreCFG<GlobalLogic>(getModule(), func, getPassOptions()).optimize();

    // Optimize memory.
    DeadStoreCFG<MemoryLogic>(getModule(), func, getPassOptions()).optimize();

    // Optimize GC heap.
    if (getModule()->features.hasGC()) {
      DeadStoreCFG<GCLogic>(getModule(), func, getPassOptions()).optimize();
    }
  }
};

} // anonymous namespace

Pass* createLocalDeadStoreEliminationPass() {
  return new LocalDeadStoreElimination();
}

} // namespace wasm
