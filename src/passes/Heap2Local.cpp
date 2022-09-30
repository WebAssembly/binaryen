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
// allocation's data into locals. That is, avoid allocating a GC object, and
// instead use one local for each of its fields.
//
// To get a sense for what this pass does, here is an example to clarify. First,
// in pseudocode:
//
//   ref = new Int(42)
//   do {
//     ref.set(ref.get() + 1)
//   } while (import(ref.get())
//
// That is, we allocate an int on the heap and use it as a counter.
// Unnecessarily, as it could be a normal int on the stack.
//
// Wat:
//
//   (module
//    ;; A boxed integer: an entire struct just to hold an int.
//    (type $boxed-int (struct (field (mut i32))))
//
//    (import "env" "import" (func $import (param i32) (result i32)))
//
//    (func "example"
//     (local $ref (ref null $boxed-int))
//
//     ;; Allocate a boxed integer of 42 and save the reference to it.
//     (local.set $ref
//      (struct.new $boxed-int
//       (i32.const 42)
//      )
//     )
//
//     ;; Increment the integer in a loop, looking for some condition.
//     (loop $loop
//      (struct.set $boxed-int 0
//       (local.get $ref)
//       (i32.add
//        (struct.get $boxed-int 0
//         (local.get $ref)
//        )
//        (i32.const 1)
//       )
//      )
//      (br_if $loop
//       (call $import
//        (struct.get $boxed-int 0
//         (local.get $ref)
//        )
//       )
//      )
//     )
//    )
//   )
//
// Before this pass, the optimizer could do essentially nothing with this. Even
// with this pass, running -O1 has no effect, as the pass is only used in -O2+.
// However, running --heap2local -O1 leads to this:
//
//    (func $0
//     (local $0 i32)
//     (local.set $0
//      (i32.const 42)
//     )
//     (loop $loop
//      (br_if $loop
//       (call $import
//        (local.tee $0
//         (i32.add
//          (local.get $0)
//          (i32.const 1)
//         )
//        )
//       )
//      )
//     )
//    )
//
// All the GC heap operations have been removed, and we just have a plain int
// now, allowing a bunch of other opts to run.
//
// For us to replace an allocation with locals, we need to prove two things:
//
//  * It must not escape from the function. If it escapes, we must pass out a
//    reference anyhow. (In theory we could do a whole-program transformation
//    to replace the reference with parameters in some cases, but inlining can
//    hopefully let us optimize most cases.)
//  * It must be used "exclusively", without overlap. That is, we cannot
//    handle the case where a local.get might return our allocation, but might
//    also get some other value. We also cannot handle a select where one arm
//    is our allocation and another is something else. If the use is exclusive
//    then we have a simple guarantee of being able to replace the heap
//    allocation with the locals.
//
// Non-exclusive uses are optimizable too, but they require more work and add
// overhead. For example, here is a non-exclusive use:
//
//   var x;
//   if (..) {
//     x = new Something(); // the allocation we want to optimize
//   } else {
//     x = something_else;
//   }
//   // 'x' here is not used exclusively by our allocation
//   return x.field0;
//
// To optimize x.field0, we'd need to check if it contains our allocation or
// not, perhaps marking a boolean as true when it is, then doing an if on that
// local, etc.:
//
//   var x_is_our_alloc; // whether x is our allocation
//   var x; // keep x around for when it is not our allocation
//   var x_field0; // the value of field0 on x, when x is our allocation
//   if (..) {
//     x_field0 = ..default value for the type..
//     x_is_our_alloc = true;
//   } else {
//     x = something_else;
//     x_is_our_alloc = false;
//   }
//   return x_is_our_alloc ? x_field0 : x.field0;
//
// (node splitting/code duplication is another possible approach). On the other
// hand, if the allocation is used exclusively in all places (the if-else above
// does not have an else any more) then we can do this:
//
//   var x_field0; // the value of field0 on x
//   if (..) {
//     x_field0 = ..default value for the type..
//   }
//   return x_field0;
//
// This optimization focuses on such cases.
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
  // can see how allocations flow from sets to gets and so forth.
  // TODO: only scan reference types
  LocalGraph localGraph;

  // To find what escapes, we need to follow where values flow, both up to
  // parents, and via branches.
  Parents parents;
  BranchUtils::BranchTargets branchTargets;

  Heap2LocalOptimizer(Function* func,
                      Module* module,
                      const PassOptions& passOptions)
    : func(func), module(module), passOptions(passOptions), localGraph(func),
      parents(func->body), branchTargets(func->body) {
    // We need to track what each set influences, to see where its value can
    // flow to.
    localGraph.computeSetInfluences();

    // All the allocations in the function.
    // TODO: Arrays (of constant size) as well.
    FindAll<StructNew> allocations(func->body);

    for (auto* allocation : allocations.list) {
      // The point of this optimization is to replace heap allocations with
      // locals, so we must be able to place the data in locals.
      if (!canHandleAsLocals(allocation->type)) {
        continue;
      }

      convertToLocals(allocation);
    }
  }

  bool canHandleAsLocals(Type type) {
    if (type == Type::unreachable) {
      return false;
    }
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
  // data that rewriting will need here, while we analyze, and then if we can do
  // the optimization, we tell it to run.
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
    // exclusivity.
    std::unordered_set<LocalSet*> sets;

    // All the expressions we reached during the flow analysis. That is exactly
    // all the places where our allocation is used. We track these so that we
    // can fix them up at the end, if the optimization ends up possible.
    std::unordered_set<Expression*> reached;

    // Maps indexes in the struct to the local index that will replace them.
    std::vector<Index> localIndexes;

    void applyOptimization() {
      // Allocate locals to store the allocation's fields in.
      for (auto field : fields) {
        localIndexes.push_back(builder.addVar(func, field.type));
      }

      // Replace the things we need to using the visit* methods.
      walk(func->body);
    }

    // Rewrite the code in visit* methods. The general approach taken is to
    // replace the allocation with a null reference (which may require changing
    // types in some places, like making a block return value nullable), and to
    // remove all uses of it as much as possible, using the information we have
    // (for example, when our allocation reaches a RefAsNonNull we can simply
    // remove that operation as we know it would not throw). Some things are
    // left to other passes, like getting rid of dropped code without side
    // effects.

    // Adjust the type that flows through an expression, updating that type as
    // necessary.
    void adjustTypeFlowingThrough(Expression* curr) {
      if (!reached.count(curr)) {
        return;
      }

      // Our allocation passes through this expr. We must turn its type into a
      // nullable one, because we will remove things like RefAsNonNull of it,
      // which means we may no longer have a non-nullable value as our input,
      // and we could fail to validate. It is safe to make this change in terms
      // of our parent, since we know very specifically that only safe things
      // will end up using our value, like a StructGet or a Drop, which do not
      // care about non-nullability.
      assert(curr->type.isRef());
      curr->type = Type(curr->type.getHeapType(), Nullable);
    }

    void visitBlock(Block* curr) { adjustTypeFlowingThrough(curr); }

    void visitLoop(Loop* curr) { adjustTypeFlowingThrough(curr); }

    void visitLocalSet(LocalSet* curr) {
      if (!reached.count(curr)) {
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

    void visitLocalGet(LocalGet* curr) {
      if (!reached.count(curr)) {
        return;
      }

      // Uses of this get will drop it, so the value does not matter. Replace it
      // with something else, which avoids issues with non-nullability (when
      // non-nullable locals are enabled), which could happen like this:
      //
      //   (local $x (ref $foo))
      //   (local.set $x ..)
      //   (.. (local.get $x))
      //
      // If we remove the set but not the get then the get would appear to read
      // the default value of a non-nullable local, which is not allowed.
      //
      // For simplicity, replace the get with a null. We anyhow have null types
      // in the places where our allocation was earlier, see notes on
      // visitBlock, and so using a null here adds no extra complexity.
      replaceCurrent(builder.makeRefNull(curr->type.getHeapType()));
    }

    void visitBreak(Break* curr) {
      if (!reached.count(curr)) {
        return;
      }

      // Breaks that our allocation flows through may change type, as we now
      // have a nullable type there.
      curr->finalize();
    }

    void visitStructNew(StructNew* curr) {
      if (curr != allocation) {
        return;
      }

      // First, assign the initial values to the new locals.
      std::vector<Expression*> contents;

      if (!allocation->isWithDefault()) {
        // We must assign the initial values to temp indexes, then copy them
        // over all at once. If instead we did set them as we go, then we might
        // hit a problem like this:
        //
        //  (local.set X (new_X))
        //  (local.set Y (block (result ..)
        //                 (.. (local.get X) ..) ;; returns new_X, wrongly
        //                 (new_Y)
        //               )
        //
        // Note how we assign to the local X and use it during the assignment to
        // the local Y - but we should still see the old value of X, not new_X.
        // Temp locals X', Y' can ensure that:
        //
        //  (local.set X' (new_X))
        //  (local.set Y' (block (result ..)
        //                  (.. (local.get X) ..) ;; returns the proper, old X
        //                  (new_Y)
        //                )
        //  ..
        //  (local.set X (local.get X'))
        //  (local.set Y (local.get Y'))
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

        // TODO Check if the nondefault case does not increase code size in some
        //      cases. A heap allocation that implicitly sets the default values
        //      is smaller than multiple explicit settings of locals to
        //      defaults.
      } else {
        // Set the default values.
        // Note that we must assign the defaults because we might be in a loop,
        // that is, there might be a previous value.
        for (Index i = 0; i < localIndexes.size(); i++) {
          contents.push_back(builder.makeLocalSet(
            localIndexes[i],
            builder.makeConstantExpression(Literal::makeZero(fields[i].type))));
        }
      }

      // Replace the allocation with a null reference. This changes the type
      // from non-nullable to nullable, but as we optimize away the code that
      // the allocation reaches, we will handle that.
      contents.push_back(builder.makeRefNull(allocation->type.getHeapType()));
      replaceCurrent(builder.makeBlock(contents));
    }

    void visitRefAs(RefAs* curr) {
      if (!reached.count(curr)) {
        return;
      }

      // It is safe to optimize out this RefAsNonNull, since we proved it
      // contains our allocation, and so cannot trap.
      assert(curr->op == RefAsNonNull);
      replaceCurrent(curr->value);
    }

    void visitStructSet(StructSet* curr) {
      if (!reached.count(curr)) {
        return;
      }

      // Drop the ref (leaving it to other opts to remove, when possible), and
      // write the data to the local instead of the heap allocation.
      replaceCurrent(builder.makeSequence(
        builder.makeDrop(curr->ref),
        builder.makeLocalSet(localIndexes[curr->index], curr->value)));
    }

    void visitStructGet(StructGet* curr) {
      if (!reached.count(curr)) {
        return;
      }

      replaceCurrent(
        builder.makeSequence(builder.makeDrop(curr->ref),
                             builder.makeLocalGet(localIndexes[curr->index],
                                                  fields[curr->index].type)));
    }
  };

  // All the expressions we have already looked at.
  std::unordered_set<Expression*> seen;

  enum class ParentChildInteraction {
    // The parent lets the child escape. E.g. the parent is a call.
    Escapes,
    // The parent fully consumes the child in a safe, non-escaping way, and
    // after consuming it nothing remains to flow further through the parent.
    // E.g. the parent is a struct.get, which reads from the allocated heap
    // value and does nothing more with the reference.
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
  void convertToLocals(StructNew* allocation) {
    Rewriter rewriter(allocation, func, module);

    // A queue of flows from children to parents. When something is in the queue
    // here then it assumed that it is ok for the allocation to be at the child
    // (that is, we have already checked the child before placing it in the
    // queue), and we need to check if it is ok to be at the parent, and to flow
    // from the child to the parent. We will analyze that (see
    // ParentChildInteraction, above) and continue accordingly.
    using ChildAndParent = std::pair<Expression*, Expression*>;
    UniqueNonrepeatingDeferredQueue<ChildAndParent> flows;

    // Start the flow from the allocation itself to its parent.
    flows.push({allocation, parents.getParent(allocation)});

    // Keep flowing while we can.
    while (!flows.empty()) {
      auto flow = flows.pop();
      auto* child = flow.first;
      auto* parent = flow.second;

      // If we've already seen an expression, stop since we cannot optimize
      // things that overlap in any way (see the notes on exclusivity, above).
      // Note that we use a nonrepeating queue here, so we already do not visit
      // the same thing more than once; what this check does is verify we don't
      // look at something that another allocation reached, which would be in a
      // different call to this function and use a different queue (any overlap
      // between calls would prove non-exclusivity).
      if (!seen.emplace(parent).second) {
        return;
      }

      switch (getParentChildInteraction(parent, child)) {
        case ParentChildInteraction::Escapes: {
          // If the parent may let us escape then we are done.
          return;
        }
        case ParentChildInteraction::FullyConsumes: {
          // If the parent consumes us without letting us escape then all is
          // well (and there is nothing flowing from the parent to check).
          break;
        }
        case ParentChildInteraction::Flows: {
          // The value flows through the parent; we need to look further at the
          // grandparent.
          flows.push({parent, parents.getParent(parent)});
          break;
        }
        case ParentChildInteraction::Mixes: {
          // Our allocation is not used exclusively via the parent, as other
          // values are mixed with it. Give up.
          return;
        }
      }

      if (auto* set = parent->dynCast<LocalSet>()) {
        // This is one of the sets we are written to, and so we must check for
        // exclusive use of our allocation by all the gets that read the value.
        // Note the set, and we will check the gets at the end once we know all
        // of our sets.
        rewriter.sets.insert(set);

        // We must also look at how the value flows from those gets.
        if (auto* getsReached = getGetsReached(set)) {
          for (auto* get : *getsReached) {
            flows.push({get, parents.getParent(get)});
          }
        }
      }

      // If the parent may send us on a branch, we will need to look at the flow
      // to the branch target(s).
      for (auto name : branchesSentByParent(child, parent)) {
        flows.push({child, branchTargets.getTarget(name)});
      }

      // If we got to here, then we can continue to hope that we can optimize
      // this allocation. Mark the parent and child as reached by it, and
      // continue.
      rewriter.reached.insert(parent);
      rewriter.reached.insert(child);
    }

    // We finished the loop over the flows. Do the final checks.
    if (!getsAreExclusiveToSets(rewriter.sets)) {
      return;
    }

    // We can do it, hurray!
    rewriter.applyOptimization();
  }

  ParentChildInteraction getParentChildInteraction(Expression* parent,
                                                   Expression* child) {
    // If there is no parent then we are the body of the function, and that
    // means we escape by flowing to the caller.
    if (!parent) {
      return ParentChildInteraction::Escapes;
    }

    struct Checker : public Visitor<Checker> {
      Expression* child;

      // Assume escaping (or some other problem we cannot analyze) unless we are
      // certain otherwise.
      bool escapes = true;

      // Assume we do not fully consume the value unless we are certain
      // otherwise. If this is set to true, then we do not need to check any
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
      // Note that If is not supported here, because for our value to flow
      // through it there must be an if-else, and that means there is no single
      // value falling through anyhow.
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

      // Reference operations. TODO add more
      void visitRefAs(RefAs* curr) {
        // TODO General OptimizeInstructions integration, that is, since we know
        //      that our allocation is what flows into this RefAs, we can
        //      know the exact outcome of the operation.
        if (curr->op == RefAsNonNull) {
          // As it is our allocation that flows through here, we know it is not
          // null (so there is no trap), and we can continue to (hopefully)
          // optimize this allocation.
          escapes = false;
        }
      }

      // GC operations.
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

      // TODO Array and I31 operations
    } checker;

    checker.child = child;
    checker.visit(parent);

    if (checker.escapes) {
      return ParentChildInteraction::Escapes;
    }

    // If the parent returns a type that is not a reference, then by definition
    // it fully consumes the value as it does not flow our allocation onward.
    if (checker.fullyConsumes || !parent->type.isRef()) {
      return ParentChildInteraction::FullyConsumes;
    }

    // Finally, check for mixing. If the child is the immediate fallthrough
    // of the parent then no other values can be mixed in.
    if (Properties::getImmediateFallthrough(parent, passOptions, *module) ==
        child) {
      return ParentChildInteraction::Flows;
    }

    // Likewise, if the child branches to the parent, and it is the sole branch,
    // with no other value exiting the block (in particular, no final value at
    // the end that flows out), then there is no mixing.
    auto branches =
      branchTargets.getBranches(BranchUtils::getDefinedName(parent));
    if (branches.size() == 1 &&
        BranchUtils::getSentValue(*branches.begin()) == child) {
      // TODO: support more types of branch targets.
      if (auto* parentAsBlock = parent->dynCast<Block>()) {
        if (parentAsBlock->list.back()->type == Type::unreachable) {
          return ParentChildInteraction::Flows;
        }
      }
    }

    // TODO: Also check for safe merges where our allocation is in all places,
    //       like two if or select arms, or branches.

    return ParentChildInteraction::Mixes;
  }

  LocalGraph::SetInfluences* getGetsReached(LocalSet* set) {
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Heap2Local>();
  }

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
    Heap2LocalOptimizer(func, getModule(), getPassOptions());
  }
};

} // anonymous namespace

Pass* createHeap2LocalPass() { return new Heap2Local(); }

} // namespace wasm
