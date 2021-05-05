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

#include "ir/branch-utils.h"
#include "ir/find_all.h"
#include "ir/local-graph.h"
#include "ir/parents.h"
#include "ir/properties.h"
#include "ir/replacer.h"
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

  ExpressionReplacer replacer;

  Heap2LocalOptimizer(Function* func, Module* module, const PassOptions& passOptions)
    : passOptions(passOptions), localGraph(func), parents(func->body), branchTargets(func->body),
      allocations(func->body) {
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

    // Perform the replacements all at the end in a safe way, avoiding possible
    // issues with the ordering.
    if (!replacer.replacements.empty()) {
      replacer.walk(func->body);
      TypeUpdating::handleNonDefaultableLocals(func, *module);
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

  // Analyze an allocation to see if we can convert it from a heap allocation to
  // locals. For that we need to prove two things:
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
  // If we can do the optimization, then this returns true, and it set up the
  // necessary replacements on the replacer object.
  bool convertToLocals(StructNew* allocation) {
    // We must track all the sets we are written to so that we can verify
    // exclusivity.
    std::unordered_set<LocalSet*> sets;

    // We must track all the reads and writes from the allocation so that we can
    // fix them up at the end, if the optimization ends up possible.
    std::vector<StructSet*> writes;
    std::vector<StructGet*> reads;

    // A queue of expressions that have already been checked themselves, and we
    // need to check if by flowing to their parents they may escape.
    UniqueNonrepeatingDeferredQueue<Expression*> flows;

    // Start the flow from the expression itself.
    flows.push(allocation);

    // Keep flowing while we can.
    while (!flows.empty()) {
      auto* child = flows.pop();

      // If we've already seen an expression, stop since we cannot optimize
      // things that overlap in any way (see the notes on exclusivity, above).
      //
      // Note that our simple check whether something has already been seen is
      // slightly stricter than we need, for example:
      //
      //    (select (A) (A) ..)
      //
      // Both arms are identical. We will reach the select twice, and assume the
      // worst at that point, even though we could allow this. The assumption in
      // this code is that often things like such a redundant select will be
      // removed by other optimizations anyhow.
      if (seen.count(child)) {
        return false;
      }
      seen.insert(child);

      auto* parent = parents.getParent(child);

      // If the parent may let us escape, then we are done.
      if (escapesViaParent(child, parent)) {
        return false;
      }

      // If the value flows through the parent, we need to look further at
      // the grandparent.
      if (flowsThroughParent(child, parent)) {
        flows.push(parent);
      }

      if (auto* set = parent->dynCast<LocalSet>()) {
        // This is one of the sets we are written to, and so we must check for
        // exclusive use of our allocation there. The first part of that is to
        // see that only we are written by the set, and no other value (so the
        // value is exclusive for our use).
        if (!flowsSingleValue(child)) {
          return false;
        }

        // The second part of exclusivity is to see that any gets reading this
        // set are exclusive to our allocation. We do that at the end, once we
        // know all of our sets.
        sets.insert(set);

        // We must also look at all the places that read what the set writes.
        if (auto* getsReached = getGetsReached(set)) {
          for (auto* get : *getsReached) {
            flows.push(get);
          }
        }
      }

      if (auto* write = parent->dynCast<StructSet>()) {
        writes.push_back(write);
      }
      if (auto* read = parent->dynCast<StructGet>()) {
        reads.push_back(read);
      }

      // If the parent may send us on a branch, we will need to look at the
      // branch target(s).
      for (auto name : branchesSentByParent(child, parent)) {
        flows.push(branchTargets.getTarget(name));
      }
    }

    if (!getsAreExclusiveToSets(sets)) {
      return false;
    }

    // We can do it, hurray! All we have left to do is to set up the proper
    // replacements.
    Builder builder(*module);

    auto& fields = allocation->type.getHeapType().getStruct().fields;

    // Map indexes in the struct to local index that will replace them.
    std::vector<Index> localIndexes;
    for (auto field : fields) {
      localIndexes.push_back(builder.addVar(func, field.type));
    }

    // We do not remove the allocation itself here, rather we make it
    // unnecessary, and then depend on other optimizations to clean up. (We
    // cannot simply remove it because we need to replace it with something of
    // the same non-nullable type.) First, assign the initial values to the
    // new locals.
    if (!allocation->isWithDefault()) {
      // Add a tee to save the initial values in the proper locals.
      for (Index i = 0; i < localIndexes.size(); i++) {
        allocation->operands[i] = builder.makeLocalTee(
          localIndexes[i], allocation->operands[i], fields[i].type);
      }
    } else {
      // Set the default values, and replace the allocation with a block that
      // first does that, then contains the allocation.
      // Note that we must assign the defaults because we might be in a loop,
      // that is, there might be a previous value.
      std::vector<Expression*> contents;
      for (Index i = 0; i < localIndexes.size(); i++) {
        contents.push_back(builder.makeConstantExpression(Literal::makeZero(fields[i].type)));
      }
      contents.push_back(allocation);
      replacer.replacements[allocation] = builder.makeBlock(contents);
    }

    // Next, replace StructGet and StructSets of the allocation with uses of the
    // locals.
    for (auto* write : writes) {
      replacer.replacements[write] = builder.makeSequence(
        builder.makeDrop(write->ref),
        builder.makeLocalSet(localIndexes[write->index], write->value));
    }
    for (auto* read : reads) {
      replacer.replacements[read] = builder.makeSequence(
        builder.makeDrop(read->ref),
        builder.makeLocalGet(localIndexes[read->index], fields[read->index].type));
    }

    return true;
  }

  // All the expressions we have already looked at.
  std::unordered_set<Expression*> seen;

  // Checks if a parent's use of a child may cause it to escape.
  bool escapesViaParent(Expression* child, Expression* parent) {
    // If there is no parent then we are the body of the function, and that
    // means we escape by flowing to the caller.
    if (!parent) {
      return true;
    }

    struct EscapeChecker : public Visitor<EscapeChecker> {
      Expression* child;

      // Assume escaping unless we are certain otherwise.
      bool escapes = true;

      // Local operations. Locals by themselves do not escape; the analysis
      // tracks where locals are used.
      void visitLocalGet(LocalGet* curr) { escapes = false; }
      void visitLocalSet(LocalSet* curr) { escapes = false; }

      // Reference operations
      void visitRefIs(RefIs* curr) { escapes = false; }
      void visitRefEq(RefEq* curr) { escapes = false; }
      void visitI31Get(I31Get* curr) { escapes = false; }
      void visitRefTest(RefTest* curr) { escapes = false; }
      void visitRefCast(RefCast* curr) { escapes = false; }
      void visitBrOn(BrOn* curr) { escapes = false; }
      void visitRefAs(RefAs* curr) { escapes = false; }
      void visitStructSet(StructSet* curr) {
        // The reference does not escape (but the value is stored to memory and
        // therefore might).
        if (curr->ref == child) {
          escapes = false;
        }
      }
      void visitStructGet(StructGet* curr) { escapes = false; }
      // TODO: Array operations
    } checker;

    checker.child = child;
    checker.visit(parent);
    return checker.escapes;
  }

  bool flowsThroughParent(Expression* child, Expression* parent) {
    return child == Properties::getImmediateFallthrough(
                      parent, passOptions, module->features);
  }

  // Checks whether a single value flows here. That is, we need to avoid things
  // like
  //
  //  (if ..
  //    (value1)
  //    (value2)
  //  )
  //
  // (It is ok if zero values flow out, or if some paths end in a trap or
  // exception; we just cannot tolerate multiple values, if a value does in fact
  // flow out.)
  //
  // This is not a general-purpose analysis, rather it is only valid in the
  // context we use it, which is to follow the uses of an allocation via flowing
  // out and via locals.
  bool flowsSingleValue(Expression* value) {
    auto* fallthrough = Properties::getFallthrough(
      value, passOptions, module->features);
    if (fallthrough->is<StructNew>()) {
      // This is our allocation (one allocation cannot fall through another, so
      // it must be ours).
      return true;
    }
    if (fallthrough->is<LocalGet>()) {
      // This is a local.get of our allocation.
      return true;
    }
    // TODO: branches
    return false;
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
    // Multiple rounds of optimization may work, as once we turn one allocation
    // into locals, references written to its fields become references written
    // to locals, which we may see do not escape;
    while (Heap2LocalOptimizer(func, getModule(), getPassOptions()).optimized) {
    }
  }
};

} // anonymous namespace

Pass* createHeap2LocalPass() { return new Heap2Local(); }

} // namespace wasm
