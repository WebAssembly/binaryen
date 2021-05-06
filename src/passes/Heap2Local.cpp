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
// Find heap allocations that never escape the current function, and lower the
// object into locals.
//
// For us to replace an allocation with locals, need to prove two things:
//
//  * It must not escape from the function. If it escapes, we must pass out a
//    reference anyhow. (In theory we could do a whole-program transformation
//    to replace the reference with parameters in some cases, but inlining can
//    hopefully let us optimize common cases.)
//  * It must be used "exclusively", without overlap. That is, we cannot
//    handle the case where a local.get might return our allocation, but might
//    also get some other value. We also cannot handle a select where one arm
//    is our allocation and another is something else.
//

#include "ir/branch-utils.h"
#include "ir/find_all.h"
#include "ir/local-graph.h"
#include "ir/parents.h"
#include "ir/properties.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Heap2LocalOptimizer {
  Function* func;
  Module* module;
  const PassOptions& passOptions;

  // To find allocations that do not escape, we must track locals so that we
  // can see which gets refer to the same allocation.
  // TODO: only scan reference types
  LocalGraph localGraph;

  // To find what escapes, we need to follow where values flow, both up to
  // parents, and via branches.
  Parents parents;
  BranchUtils::BranchTargets branchTargets;

  // All the allocations in the function.
  // TODO: Arrays (of constant size) as well.
  FindAll<StructNew> allocations;

  bool optimized = false;

  Heap2LocalOptimizer(Function* func,
                      Module* module,
                      const PassOptions& passOptions)
    : func(func), module(module), passOptions(passOptions), localGraph(func),
      parents(func->body), branchTargets(func->body), allocations(func->body) {
    // We need to track what each set influences, to see where its value can
    // flow to.
    localGraph.computeSetInfluences();

    for (auto* allocation : allocations.list) {
      // The point of this optimization is to replace heap allocations with
      // locals, so we must be able to place the data in locals.
      if (!canHandleAsLocals(allocation->type)) {
        continue;
      }

      if (convertToLocals(allocation)) {
        optimized = true;
      }
    }
  }

  bool canHandleAsLocals(Type type) {
    auto& fields = type.getHeapType().getStruct().fields;
    for (auto field : fields) {
      if (!TypeUpdating::canHandleAsLocal(field.type)) {
        return false;
      }
      if (field.isPacked()) {
        // TODO: support packed fields by adding coercions/truncations.
        return false;
      }
    }
    return true;
  }

  // Handles the rewriting that we do to perform the optimization. We store the
  // data that rewriting will need later here while we analyze, and then if we
  // can do the optimization, we tell it to run.
  //
  // TODO: Doing a single rewrite walk at the end would be more efficient, but
  //       it would need to be more complex.
  struct Rewriter : PostWalker<Rewriter> {
    StructNew* allocation;
    Function* func;
    Builder builder;
    const FieldList& fields;

    Rewriter(StructNew* allocation, Function* func, Module* module)
      : allocation(allocation), func(func), builder(*module),
        fields(allocation->type.getHeapType().getStruct().fields) {}

    // We must track all the local.sets that write the allocation, to verify
    // exclusivity. We also want to update them later, if we can do the
    // optimization.
    std::unordered_set<LocalSet*> sets;

    // We must track all the reads and writes from the allocation so that we can
    // fix them up at the end, if the optimization ends up possible.
    std::unordered_set<StructSet*> writes;
    std::unordered_set<StructGet*> reads;

    // Maps indexes in the struct to the local index that will replace them.
    std::vector<Index> localIndexes;

    void applyOptimization() {
      // Allocate locals to store the allocation's data in.
      for (auto field : fields) {
        localIndexes.push_back(builder.addVar(func, field.type));
      }

      // Replace the things we need to using the visit* methods.
      walk(func->body);
    }

    void visitLocalSet(LocalSet* curr) {
      if (!sets.count(curr)) {
        return;
      }

      // We don't need any sets of the reference to any of the locals it
      // originally was written to.
      if (curr->isTee()) {
        replaceCurrent(curr->value);
      } else {
        replaceCurrent(builder.makeDrop(curr->value));
      }
    }

    void visitStructNew(StructNew* curr) {
      if (curr != allocation) {
        return;
      }

      // We do not remove the allocation itself here, rather we make it
      // unnecessary, and then depend on other optimizations to clean up. (We
      // cannot simply remove it because we need to replace it with something of
      // the same non-nullable type.) First, assign the initial values to the
      // new locals.

      std::vector<Expression*> contents;

      if (!allocation->isWithDefault()) {
        // We must assign the initial values to temp indexes, then copy them
        // over all at once. If instead we did set directly, then imagine if
        // right after the initial value for field K we read field K in the
        // initial value of field K+1. We should still see the old value there,
        // not the new one.
        std::vector<Index> tempIndexes;

        for (auto field : fields) {
          tempIndexes.push_back(builder.addVar(func, field.type));
        }

        // Store the initial values into the temp locals.
        for (Index i = 0; i < tempIndexes.size(); i++) {
          contents.push_back(
            builder.makeLocalSet(tempIndexes[i], allocation->operands[i]));
        }

        // Copy them to the normal ones.
        for (Index i = 0; i < tempIndexes.size(); i++) {
          contents.push_back(builder.makeLocalSet(
            localIndexes[i],
            builder.makeLocalGet(tempIndexes[i], fields[i].type)));
        }

        // Read the values in the allocation (we don't need to, as the
        // allocation is not used, but we need something with the right type
        // anyhow).
        for (Index i = 0; i < tempIndexes.size(); i++) {
          allocation->operands[i] =
            builder.makeLocalGet(localIndexes[i], fields[i].type);
        }
      } else {
        // Set the default values, and replace the allocation with a block that
        // first does that, then contains the allocation.
        // Note that we must assign the defaults because we might be in a loop,
        // that is, there might be a previous value.
        for (Index i = 0; i < localIndexes.size(); i++) {
          contents.push_back(builder.makeLocalSet(
            localIndexes[i],
            builder.makeConstantExpression(Literal::makeZero(fields[i].type))));
        }
      }

      // Put the allocation itself at the end of the block, so the block has the
      // exact same type as the allocation it replaces.
      contents.push_back(allocation);
      replaceCurrent(builder.makeBlock(contents));
    }

    void visitStructSet(StructSet* curr) {
      if (!writes.count(curr)) {
        return;
      }

      // Drop the ref (leaving it to other opts to remove, when possible), and
      // write the data to the local instead of the heap allocation.
      replaceCurrent(builder.makeSequence(
        builder.makeDrop(curr->ref),
        builder.makeLocalSet(localIndexes[curr->index], curr->value)));
    }

    void visitStructGet(StructGet* curr) {
      if (!reads.count(curr)) {
        return;
      }

      replaceCurrent(
        builder.makeSequence(builder.makeDrop(curr->ref),
                             builder.makeLocalGet(localIndexes[curr->index],
                                                  fields[curr->index].type)));
    }
  };

  enum class ParentChildInteraction {
    // The parent lets the child escape. E.g. the parent is a call.
    Escapes,
    // The parent fully consumes the child in a safe, non-escaping way, and
    // after
    // consuming it nothing remains to flow further through the parent. E.g.
    // the parent is a struct.get, which reads from the allocated heap value and
    // does nothing more with the reference.
    FullyConsumes,
    // The parent flows the child out, that is, the child is the single value
    // that can flow out from the parent. E.g. the parent is a block with no
    // branches and the child is the final value that is returned.
    Flows,
    // The parent does not consume the child completely, so the child's value
    // can be used through it. However the child does not flow cleanly through.
    // E.g. the parent is a block with branches, and the value on them may be
    // returned from the block and not only the child. This means the allocation
    // is not used in an exclusive way, and we cannot optimize it.
    Mixes,
  };

  // Analyze an allocation to see if we can convert it from a heap allocation to
  // locals.
  bool convertToLocals(StructNew* allocation) {
    Rewriter rewriter(allocation, func, module);

    // A queue of expressions that have already been checked themselves, and we
    // need to check when happens further up, that is, what happens in the
    // interaction between the chlid and the parent.
    UniqueNonrepeatingDeferredQueue<Expression*> flows;

    // Start the flow from the expression itself.
    flows.push(allocation);

    // Keep flowing while we can.
    while (!flows.empty()) {
      auto* child = flows.pop();

      // If we've already seen an expression, stop since we cannot optimize
      // things that overlap in any way (see the notes on exclusivity, above).
      if (seen.count(child)) {
        return false;
      }
      seen.insert(child);

      auto* parent = parents.getParent(child);

      switch (getParentChildInteraction(parent, child)) {
        case ParentChildInteraction::Escapes: {
          // If the parent may let us escape then we are done.
          return false;
        }
        case ParentChildInteraction::FullyConsumes: {
          // If the parent consumes us without escaping (e.g. the parent is a
          // StructGet of the allocation), then all is well, and we do not need
          // to check for flowing through the parent.
          break;
        }
        case ParentChildInteraction::Flows: {
          // The value flows through the parent; we need to look further at the
          // grandparent.
          flows.push(parent);
          break;
        }
        case ParentChildInteraction::Mixes: {
          // Our allocation is not used exclusively via the parent, as other
          // values are mixed with it. Give up.
          return false;
        }
      }

      if (auto* set = parent->dynCast<LocalSet>()) {
        // This is one of the sets we are written to, and so we must check for
        // exclusive use of our allocation there. The first part of that is to
        // see that only we are written by the set, and no other value (so the
        // value is exclusive for our use). That is already handled by our
        // checks above, as we see that things flow through their parents (if
        // a child flows through the parent, that means it is the single value
        // that flows out, unless a trap etc. happens).

        // The second part of exclusivity is to see that any gets reading this
        // set are exclusive to our allocation. We do that at the end, once we
        // know all of our sets.
        rewriter.sets.insert(set);

        // We must also look at all the places that read what the set writes.
        if (auto* getsReached = getGetsReached(set)) {
          for (auto* get : *getsReached) {
            flows.push(get);
          }
        }
      }

      if (auto* write = parent->dynCast<StructSet>()) {
        rewriter.writes.insert(write);
      }
      if (auto* read = parent->dynCast<StructGet>()) {
        rewriter.reads.insert(read);
      }

      // If the parent may send us on a branch, we will need to look at the
      // branch target(s).
      for (auto name : branchesSentByParent(child, parent)) {
        flows.push(branchTargets.getTarget(name));
      }
    }

    if (rewriter.sets.empty() && rewriter.writes.empty() &&
        rewriter.reads.empty()) {
      // The allocation is never used in any significant way in this function,
      // so there is nothing worth optimizing here.
      return false;
    }

    if (!getsAreExclusiveToSets(rewriter.sets)) {
      return false;
    }

    // We can do it, hurray!
    rewriter.applyOptimization();

    return true;
  }

  // All the expressions we have already looked at.
  std::unordered_set<Expression*> seen;

  ParentChildInteraction getParentChildInteraction(Expression* parent,
                                                   Expression* child) {
    // If there is no parent then we are the body of the function, and that
    // means we escape by flowing to the caller.
    if (!parent) {
      return ParentChildInteraction::Escapes;
    }

    struct Checker : public Visitor<Checker> {
      Expression* child;

      // Assume escaping unless we are certain otherwise.
      bool escapes = true;

      // Assume we do not fully consume the value unless we are certain
      // otherwise. If this is set to true, then do not need to check any
      // further. If it remains false, then we will analyze the value that
      // falls through later to check for mixing.
      //
      // Note that this does not need to be set for expressions if their type
      // proves that the value does not continue onwards (e.g. if their type is
      // none, or not a reference type), but for clarity some do still mark this
      // field as true when it is clearly so.
      bool fullyConsumes = false;

      // General operations
      void visitBlock(Block* curr) {
        escapes = false;
        // We do not mark fullyConsumes as the value may continue through this
        // and other control flow structures.
      }
      void visitLoop(Loop* curr) { escapes = false; }
      void visitDrop(Drop* curr) {
        escapes = false;
        fullyConsumes = true;
      }
      void visitBreak(Break* curr) { escapes = false; }
      void visitSwitch(Switch* curr) { escapes = false; }

      // Local operations. Locals by themselves do not escape; the analysis
      // tracks where locals are used.
      void visitLocalGet(LocalGet* curr) { escapes = false; }
      void visitLocalSet(LocalSet* curr) { escapes = false; }

      void visitStructSet(StructSet* curr) {
        // The reference does not escape (but the value is stored to memory and
        // therefore might).
        if (curr->ref == child) {
          escapes = false;
          fullyConsumes = true;
        }
      }
      void visitStructGet(StructGet* curr) {
        escapes = false;
        fullyConsumes = true;
      }

      // TODO Reference operations like ref.is etc. They do not escape, but we
      //      will need to replace them properly if we optimize.

      // TODO Array and I31 operations
    } checker;

    checker.child = child;
    checker.visit(parent);

    if (checker.escapes) {
      return ParentChildInteraction::Escapes;
    }

    // If the parent returns a type that is not a reference, then it by
    // definition it fully consumes the value as it does not flow our
    // allocation onward.
    if (checker.fullyConsumes || !parent->type.isRef()) {
      return ParentChildInteraction::FullyConsumes;
    }

    // Finally, check for mixing. If the child is the immediate fallthrough
    // of the parent then no other values can be mixed in.
    if (Properties::getImmediateFallthrough(
          parent, passOptions, module->features) == child) {
      return ParentChildInteraction::Flows;
    }

    return ParentChildInteraction::Mixes;
  }

  std::unordered_set<LocalGet*>* getGetsReached(LocalSet* set) {
    auto iter = localGraph.setInfluences.find(set);
    if (iter != localGraph.setInfluences.end()) {
      return &iter->second;
    }
    return nullptr;
  }

  BranchUtils::NameSet branchesSentByParent(Expression* child,
                                            Expression* parent) {
    BranchUtils::NameSet names;
    BranchUtils::operateOnScopeNameUsesAndSentValues(
      parent, [&](Name name, Expression* value) {
        if (value == child) {
          names.insert(name);
        }
      });
    return names;
  }

  // Verify exclusivity of all the gets for a bunch of sets. That is, assuming
  // the sets are exclusive (they all write exactly our allocation, and nothing
  // else), we need to check whether all the gets that read that value cannot
  // read anything else (which would be the case if another set writes to that
  // local, in the right live range).
  bool getsAreExclusiveToSets(const std::unordered_set<LocalSet*>& sets) {
    // Find all the relevant gets (which may overlap between the sets).
    std::unordered_set<LocalGet*> gets;
    for (auto* set : sets) {
      if (auto* getsReached = getGetsReached(set)) {
        for (auto* get : *getsReached) {
          gets.insert(get);
        }
      }
    }

    // Check that the gets can only read from the specific known sets.
    for (auto* get : gets) {
      for (auto* set : localGraph.getSetses[get]) {
        if (sets.count(set) == 0) {
          return false;
        }
      }
    }

    return true;
  }
};

struct Heap2Local : public WalkerPass<PostWalker<Heap2Local>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new Heap2Local(); }

  void doWalkFunction(Function* func) {
    // Multiple rounds of optimization may work in theory, as once we turn one
    // allocation into locals, references written to its fields become
    // references written to locals, which we may see do not escape. However,
    // this does not work yet, since we do not remove the original allocation -
    // we just "detach" it from other things and then depend on other
    // optimizations to remove it. That means this pass must be interleaved with
    // vacuum, in particular, to optimize such nested allocations.
    // TODO Consider running multiple iterations here, and running vacuum in
    //      between them.
    if (Heap2LocalOptimizer(func, getModule(), getPassOptions()).optimized) {
      TypeUpdating::handleNonDefaultableLocals(func, *getModule());
    }
  }
};

} // anonymous namespace

Pass* createHeap2LocalPass() { return new Heap2Local(); }

} // namespace wasm
