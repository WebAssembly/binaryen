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
//    (func $example
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

#include "ir/bits.h"
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

// Core analysis that provides an escapes() method to check if an allocation
// escapes in a way that prevents optimizing it away as described above. It also
// stashes information about the relevant expressions as it goes, which helps
// optimization later (|reached|).
struct EscapeAnalyzer {
  // To find what escapes, we need to follow where values flow, both up to
  // parents, and via branches, and through locals.
  // TODO: for efficiency, only scan reference types in LocalGraph
  const LocalGraph& localGraph;
  const Parents& parents;
  const BranchUtils::BranchTargets& branchTargets;

  const PassOptions& passOptions;
  Module& wasm;

  EscapeAnalyzer(const LocalGraph& localGraph,
                 const Parents& parents,
                 const BranchUtils::BranchTargets& branchTargets,
                 const PassOptions& passOptions,
                 Module& wasm)
    : localGraph(localGraph), parents(parents), branchTargets(branchTargets),
      passOptions(passOptions), wasm(wasm) {}

  // We must track all the local.sets that write the allocation, to verify
  // exclusivity.
  std::unordered_set<LocalSet*> sets;

  // All the expressions we reached during the flow analysis. That is exactly
  // all the places where our allocation is used. We track these so that we
  // can fix them up at the end, if the optimization ends up possible.
  std::unordered_set<Expression*> reached;

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

  // Analyze an allocation to see if it escapes or not.
  bool escapes(Expression* allocation) {
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

      auto interaction = getParentChildInteraction(allocation, parent, child);
      if (interaction == ParentChildInteraction::Escapes ||
          interaction == ParentChildInteraction::Mixes) {
        // If the parent may let us escape, or the parent mixes other values
        // up with us, give up.
        return true;
      }

      // The parent either fully consumes us, or flows us onwards; either way,
      // we can proceed here, hopefully.
      assert(interaction == ParentChildInteraction::FullyConsumes ||
             interaction == ParentChildInteraction::Flows);

      // We can proceed, as the parent interacts with us properly, and we are
      // the only allocation to get here.

      if (interaction == ParentChildInteraction::Flows) {
        // The value flows through the parent; we need to look further at the
        // grandparent.
        flows.push({parent, parents.getParent(parent)});
      }

      if (auto* set = parent->dynCast<LocalSet>()) {
        // This is one of the sets we are written to, and so we must check for
        // exclusive use of our allocation by all the gets that read the value.
        // Note the set, and we will check the gets at the end once we know all
        // of our sets.
        sets.insert(set);

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
      reached.insert(parent);
      reached.insert(child);
    }

    // We finished the loop over the flows. Do the final checks.
    if (!getsAreExclusiveToSets()) {
      return true;
    }

    // Nothing escapes, hurray!
    return false;
  }

  ParentChildInteraction getParentChildInteraction(Expression* allocation,
                                                   Expression* parent,
                                                   Expression* child) {
    // If there is no parent then we are the body of the function, and that
    // means we escape by flowing to the caller.
    if (!parent) {
      return ParentChildInteraction::Escapes;
    }

    struct Checker : public Visitor<Checker> {
      Expression* allocation;
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
      void visitRefIsNull(RefIsNull* curr) {
        // The reference is compared to null, but nothing more.
        escapes = false;
        fullyConsumes = true;
      }

      void visitRefEq(RefEq* curr) {
        // The reference is compared for identity, but nothing more.
        escapes = false;
        fullyConsumes = true;
      }

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

      void visitRefTest(RefTest* curr) {
        escapes = false;
        fullyConsumes = true;
      }

      void visitRefCast(RefCast* curr) {
        // Whether the cast succeeds or fails, it does not escape.
        escapes = false;

        // If the cast fails then the allocation is fully consumed and does not
        // flow any further (instead, we trap).
        if (!Type::isSubType(allocation->type, curr->type)) {
          fullyConsumes = true;
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
      void visitArraySet(ArraySet* curr) {
        if (!curr->index->is<Const>()) {
          // Array operations on nonconstant indexes do not escape in the normal
          // sense, but they do escape from our being able to analyze them, so
          // stop as soon as we see one.
          return;
        }

        // As StructGet.
        if (curr->ref == child) {
          escapes = false;
          fullyConsumes = true;
        }
      }
      void visitArrayGet(ArrayGet* curr) {
        if (!curr->index->is<Const>()) {
          return;
        }
        escapes = false;
        fullyConsumes = true;
      }
      // TODO other GC operations
    } checker;

    checker.allocation = allocation;
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
    if (Properties::getImmediateFallthrough(parent, passOptions, wasm) ==
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

  const LocalGraph::SetInfluences* getGetsReached(LocalSet* set) {
    auto iter = localGraph.setInfluences.find(set);
    if (iter != localGraph.setInfluences.end()) {
      return &iter->second;
    }
    return nullptr;
  }

  const BranchUtils::NameSet branchesSentByParent(Expression* child,
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
  bool getsAreExclusiveToSets() {
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
      auto iter = localGraph.getSetses.find(get);
      assert(iter != localGraph.getSetses.end());
      for (auto* set : iter->second) {
        if (sets.count(set) == 0) {
          return false;
        }
      }
    }

    return true;
  }
};

// An optimizer that handles the rewriting to turn a struct allocation into
// locals. We run this after proving that allocation does not escape.
//
// TODO: Doing a single rewrite walk at the end (for all structs) would be more
//       efficient, but it would need to be more complex.
struct Struct2Local : PostWalker<Struct2Local> {
  StructNew* allocation;

  // The analyzer is not |const| because we update |analyzer.reached| as we go
  // (see replaceCurrent, below).
  EscapeAnalyzer& analyzer;

  Function* func;
  Module& wasm;
  Builder builder;
  const FieldList& fields;

  Struct2Local(StructNew* allocation,
               EscapeAnalyzer& analyzer,
               Function* func,
               Module& wasm)
    : allocation(allocation), analyzer(analyzer), func(func), wasm(wasm),
      builder(wasm), fields(allocation->type.getHeapType().getStruct().fields) {

    // Allocate locals to store the allocation's fields in.
    for (auto field : fields) {
      localIndexes.push_back(builder.addVar(func, field.type));
    }

    // Replace the things we need to using the visit* methods.
    walk(func->body);

    if (refinalize) {
      ReFinalize().walkFunctionInModule(func, &wasm);
    }
  }

  // Maps indexes in the struct to the local index that will replace them.
  std::vector<Index> localIndexes;

  // In rare cases we may need to refinalize, see below.
  bool refinalize = false;

  Expression* replaceCurrent(Expression* expression) {
    PostWalker<Struct2Local>::replaceCurrent(expression);
    // Also update |reached|: we are replacing something that was reached, so
    // logically the replacement is also reached. This update is necessary if
    // the parent of an expression cares about whether a child was reached.
    analyzer.reached.insert(expression);
    return expression;
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
    if (!analyzer.reached.count(curr)) {
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
    if (!analyzer.reached.count(curr)) {
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
    if (!analyzer.reached.count(curr)) {
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
    if (!analyzer.reached.count(curr)) {
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
        auto* value = builder.makeLocalGet(tempIndexes[i], fields[i].type);
        contents.push_back(builder.makeLocalSet(localIndexes[i], value));
      }

      // TODO Check if the nondefault case does not increase code size in some
      //      cases. A heap allocation that implicitly sets the default values
      //      is smaller than multiple explicit settings of locals to
      //      defaults.
    } else {
      // Set the default values.
      //
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

  void visitRefIsNull(RefIsNull* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // The result must be 0, since the allocation is not null. Drop the RefIs
    // and append that.
    replaceCurrent(builder.makeSequence(
      builder.makeDrop(curr), builder.makeConst(Literal(int32_t(0)))));
  }

  void visitRefEq(RefEq* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    if (curr->type == Type::unreachable) {
      // The result does not matter. Leave things as they are (and let DCE
      // handle it).
      return;
    }

    // If our reference is compared to itself, the result is 1. If it is
    // compared to something else, the result must be 0, as our reference does
    // not escape to any other place.
    int32_t result = analyzer.reached.count(curr->left) > 0 &&
                     analyzer.reached.count(curr->right) > 0;
    replaceCurrent(builder.makeBlock({builder.makeDrop(curr->left),
                                      builder.makeDrop(curr->right),
                                      builder.makeConst(Literal(result))}));
  }

  void visitRefAs(RefAs* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // It is safe to optimize out this RefAsNonNull, since we proved it
    // contains our allocation, and so cannot trap.
    assert(curr->op == RefAsNonNull);
    replaceCurrent(curr->value);
  }

  void visitRefTest(RefTest* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // This test operates on the allocation, which means we can compute whether
    // it will succeed statically. We do not even need
    // GCTypeUtils::evaluateCastCheck because we know the allocation's type
    // precisely (it cannot be a strict subtype of the type - it is the type).
    int32_t result = Type::isSubType(allocation->type, curr->castType);
    // Remove the RefTest and leave only its reference child. If we kept it,
    // we'd need to refinalize (as the input to the test changes, since the
    // reference becomes a null, which has a different type).
    replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                        builder.makeConst(Literal(result))));
  }

  void visitRefCast(RefCast* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // We know this RefCast receives our allocation, so we can see whether it
    // succeeds or fails.
    if (Type::isSubType(allocation->type, curr->type)) {
      // The cast succeeds, so it is a no-op, and we can skip it, since after we
      // remove the allocation it will not even be needed for validation.
      replaceCurrent(curr->ref);
    } else {
      // The cast fails, so this must trap.
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                          builder.makeUnreachable()));
    }

    // Either way, we need to refinalize here (we either added an unreachable,
    // or we replaced a cast with the value being cast, which may have a less-
    // refined type - it will not be used after we remove the allocation, but we
    // must still fix that up for validation).
    refinalize = true;
  }

  void visitStructSet(StructSet* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // Drop the ref (leaving it to other opts to remove, when possible), and
    // write the data to the local instead of the heap allocation.
    replaceCurrent(builder.makeSequence(
      builder.makeDrop(curr->ref),
      builder.makeLocalSet(localIndexes[curr->index], curr->value)));
  }

  void visitStructGet(StructGet* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    auto& field = fields[curr->index];
    auto type = field.type;
    if (type != curr->type) {
      // Normally we are just replacing a struct.get with a local.get of a
      // local that was created to have the same type as the struct's field,
      // but in some cases we may refine, if the struct.get's reference type
      // is less refined than the reference that actually arrives, like here:
      //
      //  (struct.get $parent 0
      //    (block (ref $parent)
      //      (struct.new $child)))
      //
      // We allocated locals for the field of the child, and are replacing a
      // get of the parent field with a local of the same type as the child's,
      // which may be more refined.
      refinalize = true;
    }
    Expression* value = builder.makeLocalGet(localIndexes[curr->index], type);
    // Note that in theory we could try to do better here than to fix up the
    // packing and signedness on gets: we could truncate on sets. That would be
    // more efficient if all gets are unsigned, as gets outnumber sets in
    // general. However, signed gets make that more complicated, so leave this
    // for other opts to handle.
    value = Bits::makePackedFieldGet(value, field, curr->signed_, wasm);
    replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref), value));
  }
};

// An optimizer that handles the rewriting to turn a nonescaping array
// allocation into a struct allocation. Struct2Local can then be run on that
// allocation.
// TODO: As with Struct2Local doing a single rewrite walk at the end (for all
//       structs) would be more efficient, but more complex.
struct Array2Struct : PostWalker<Array2Struct> {
  Expression* allocation;
  EscapeAnalyzer& analyzer;
  Function* func;
  Builder builder;
  // The original type of the allocation, before we turn it into a struct.
  Type originalType;

  // The type of the struct we are changing to (nullable and non-nullable
  // variations).
  Type nullStruct;
  Type nonNullStruct;

  Array2Struct(Expression* allocation,
               EscapeAnalyzer& analyzer,
               Function* func,
               Module& wasm)
    : allocation(allocation), analyzer(analyzer), func(func), builder(wasm),
      originalType(allocation->type) {

    // Build the struct type we need: as many fields as the size of the array,
    // all of the same type as the array's element.
    numFields = getArrayNewSize(allocation);
    auto arrayType = allocation->type.getHeapType();
    auto element = arrayType.getArray().element;
    FieldList fields;
    for (Index i = 0; i < numFields; i++) {
      fields.push_back(element);
    }
    HeapType structType = Struct(fields);

    // Generate a StructNew to replace the ArrayNew*.
    if (auto* arrayNew = allocation->dynCast<ArrayNew>()) {
      if (arrayNew->isWithDefault()) {
        structNew = builder.makeStructNew(structType, {});
        arrayNewReplacement = structNew;
      } else {
        // The ArrayNew is writing the same value to each slot of the array. To
        // do the same for the struct, we store that value in an local and
        // generate multiple local.gets of it.
        auto local = builder.addVar(func, element.type);
        auto* set = builder.makeLocalSet(local, arrayNew->init);
        std::vector<Expression*> gets;
        for (Index i = 0; i < numFields; i++) {
          gets.push_back(builder.makeLocalGet(local, element.type));
        }
        structNew = builder.makeStructNew(structType, gets);
        // The ArrayNew* will be replaced with a block containing the local.set
        // and the structNew.
        arrayNewReplacement = builder.makeSequence(set, structNew);
      }
    } else if (auto* arrayNewFixed = allocation->dynCast<ArrayNewFixed>()) {
      // Simply use the same values as the array.
      structNew = builder.makeStructNew(structType, arrayNewFixed->values);
      arrayNewReplacement = structNew;
    } else {
      WASM_UNREACHABLE("bad allocation");
    }

    // Mark the new expressions we created as reached by the analysis. We need
    // to inform the analysis of this because Struct2Local will only process
    // such code (it depends on the analysis to tell it what the allocation is
    // and where it flowed). Note that the two values here may be identical but
    // there is no harm to calling it twice in that case.
    noteIsReached(structNew);
    noteIsReached(arrayNewReplacement);

    // Update types along the path reached by the allocation: whenever we see
    // the array type, it should be the struct type. Note that we do this before
    // the walk that is after us, because the walk may read these types and
    // depend on them to be valid.
    //
    // Note that |reached| contains array.get operations, which are reached in
    // the analysis, and so we will update their types if they happen to have
    // the array type (which can be the case of an array of arrays). But that is
    // fine to do as the array.get is rewritten to a struct.get which is then
    // lowered away to locals anyhow.
    auto nullArray = Type(arrayType, Nullable);
    auto nonNullArray = Type(arrayType, NonNullable);
    nullStruct = Type(structType, Nullable);
    nonNullStruct = Type(structType, NonNullable);
    for (auto* reached : analyzer.reached) {
      if (reached->is<RefCast>()) {
        // Casts must be handled later: We need to see the old type, and to
        // potentially replace the cast based on that, see below.
        continue;
      }

      // We must check subtyping here because the allocation may be upcast as it
      // flows around. If we do see such upcasting then we are refining here and
      // must refinalize.
      if (Type::isSubType(nullArray, reached->type)) {
        if (nullArray != reached->type) {
          refinalize = true;
        }
        reached->type = nullStruct;
      } else if (Type::isSubType(nonNullArray, reached->type)) {
        if (nonNullArray != reached->type) {
          refinalize = true;
        }
        reached->type = nonNullStruct;
      }
    }

    // Technically we should also fix up the types of locals as well, but after
    // Struct2Local those locals will no longer be used anyhow (the locals hold
    // allocations that are removed), so avoid that work (though it makes the
    // IR temporarily invalid in between Array2Struct and Struct2Local).

    // Replace the things we need to using the visit* methods.
    walk(func->body);

    if (refinalize) {
      ReFinalize().walkFunctionInModule(func, &wasm);
    }
  }

  // In rare cases we may need to refinalize, as with Struct2Local.
  bool refinalize = false;

  // The number of slots in the array (which will become the number of fields in
  // the struct).
  Index numFields;

  // The StructNew that replaces the ArrayNew*. The user of this class can then
  // optimize that StructNew using Struct2Local.
  StructNew* structNew;

  // The replacement for the original ArrayNew*. Typically this is |structNew|,
  // unless we have additional code we need alongside it.
  Expression* arrayNewReplacement;

  void visitArrayNew(ArrayNew* curr) {
    if (curr == allocation) {
      replaceCurrent(arrayNewReplacement);
      noteCurrentIsReached();
    }
  }

  void visitArrayNewFixed(ArrayNewFixed* curr) {
    if (curr == allocation) {
      replaceCurrent(arrayNewReplacement);
      noteCurrentIsReached();
    }
  }

  void visitArraySet(ArraySet* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // If this is an OOB array.set then we trap.
    auto index = getIndex(curr->index);
    if (index >= numFields) {
      replaceCurrent(builder.makeBlock({builder.makeDrop(curr->ref),
                                        builder.makeDrop(curr->value),
                                        builder.makeUnreachable()}));
      // We added an unreachable, and must propagate that type.
      refinalize = true;
      return;
    }

    // Convert the ArraySet into a StructSet.
    replaceCurrent(builder.makeStructSet(index, curr->ref, curr->value));
    noteCurrentIsReached();
  }

  void visitArrayGet(ArrayGet* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // If this is an OOB array.get then we trap.
    auto index = getIndex(curr->index);
    if (index >= numFields) {
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                          builder.makeUnreachable()));
      // We added an unreachable, and must propagate that type.
      refinalize = true;
      return;
    }

    // Convert the ArrayGet into a StructGet.
    replaceCurrent(
      builder.makeStructGet(index, curr->ref, curr->type, curr->signed_));
    noteCurrentIsReached();
  }

  // Some additional operations need special handling

  void visitRefTest(RefTest* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // When we ref.test an array allocation, we cannot simply turn the array
    // into a struct, as then the test will behave differently. To properly
    // handle this, check if the test succeeds or not, and write out the outcome
    // here (similar to Struct2Local::visitRefTest). Note that we test on
    // |originalType| here and not |allocation->type|, as the allocation has
    // been turned into a struct.
    int32_t result = Type::isSubType(originalType, curr->castType);
    replaceCurrent(builder.makeSequence(builder.makeDrop(curr),
                                        builder.makeConst(Literal(result))));
  }

  void visitRefCast(RefCast* curr) {
    if (!analyzer.reached.count(curr)) {
      return;
    }

    // As with RefTest, we need to check if the cast succeeds with the array
    // type before we turn it into a struct type (as after that change, the
    // outcome of the cast will look different).
    if (!Type::isSubType(originalType, curr->type)) {
      // The cast fails, ensure we trap with an unreachable.
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr),
                                          builder.makeUnreachable()));
    } else {
      // The cast succeeds. Update the type. (It is ok to use the non-nullable
      // type here unconditionally, since we know the allocation flows through
      // here, and anyhow we will be removing the reference during Struct2Local,
      // later.)
      curr->type = nonNullStruct;
    }

    // Regardless of how we altered the type here, refinalize.
    refinalize = true;
  }

  // Get the value in an expression we know must contain a constant index.
  Index getIndex(Expression* curr) {
    return curr->cast<Const>()->value.getUnsigned();
  }

  // Inform the analyzer that the current expression (which we just replaced)
  // has been reached in its analysis. We are replacing something it reached,
  // and want it to consider it as its equivalent.
  void noteCurrentIsReached() { noteIsReached(getCurrent()); }

  void noteIsReached(Expression* curr) { analyzer.reached.insert(curr); }

  // Given an ArrayNew or ArrayNewFixed, return the size of the array that is
  // being allocated.
  Index getArrayNewSize(Expression* allocation) {
    if (auto* arrayNew = allocation->dynCast<ArrayNew>()) {
      return getIndex(arrayNew->size);
    } else if (auto* arrayNewFixed = allocation->dynCast<ArrayNewFixed>()) {
      return arrayNewFixed->values.size();
    } else {
      WASM_UNREACHABLE("bad allocation");
    }
  }
};

// Core Heap2Local optimization that operates on a function: Builds up the data
// structures we need (LocalGraph, etc.) that we will use across multiple
// analyses of allocations, and then runs those analyses and optimizes where
// possible.
struct Heap2Local {
  Function* func;
  Module& wasm;
  const PassOptions& passOptions;

  LocalGraph localGraph;
  Parents parents;
  BranchUtils::BranchTargets branchTargets;

  Heap2Local(Function* func, Module& wasm, const PassOptions& passOptions)
    : func(func), wasm(wasm), passOptions(passOptions), localGraph(func, &wasm),
      parents(func->body), branchTargets(func->body) {
    // We need to track what each set influences, to see where its value can
    // flow to.
    localGraph.computeSetInfluences();

    // Find all the relevant allocations in the function: StructNew, ArrayNew,
    // ArrayNewFixed.
    struct AllocationFinder : public PostWalker<AllocationFinder> {
      std::vector<StructNew*> structNews;
      std::vector<Expression*> arrayNews;

      void visitStructNew(StructNew* curr) {
        // Ignore unreachable allocations that DCE will remove anyhow.
        if (curr->type != Type::unreachable) {
          structNews.push_back(curr);
        }
      }
      void visitArrayNew(ArrayNew* curr) {
        // Only new arrays of fixed size are relevant for us.
        if (curr->type != Type::unreachable && isValidSize(curr->size)) {
          arrayNews.push_back(curr);
        }
      }
      void visitArrayNewFixed(ArrayNewFixed* curr) {
        if (curr->type != Type::unreachable &&
            isValidSize(curr->values.size())) {
          arrayNews.push_back(curr);
        }
      }

      bool isValidSize(Expression* size) {
        // The size of an array is valid if it is constant, and its value is
        // valid.
        if (auto* c = size->dynCast<Const>()) {
          return isValidSize(c->value.getUnsigned());
        }
        return false;
      }

      bool isValidSize(Index size) {
        // Set a reasonable limit on the size here, as valid wasm can contain
        // things like (array.new (i32.const -1)) which will likely fail at
        // runtime on a VM limitation on array size. We also are converting a
        // heap allocation to a stack allocation, which can be noticeable in
        // some cases, so to be careful here use a fairly small limit.
        return size < 20;
      }
    } finder;
    finder.walk(func->body);

    // First, lower non-escaping arrays into structs. That allows us to handle
    // arrays in a single place, and let all the rest of this pass assume we are
    // working on structs. We are in fact only optimizing struct-like arrays
    // here, that is, arrays of a fixed size and whose items are accessed using
    // constant indexes, so they are effectively structs, and turning them into
    // such allows uniform handling later.
    for (auto* allocation : finder.arrayNews) {
      // The point of this optimization is to replace heap allocations with
      // locals, so we must be able to place the data in locals.
      if (!canHandleAsLocals(allocation->type)) {
        continue;
      }

      EscapeAnalyzer analyzer(
        localGraph, parents, branchTargets, passOptions, wasm);
      if (!analyzer.escapes(allocation)) {
        // Convert the allocation and all its uses into a struct. Then convert
        // the struct into locals.
        auto* structNew =
          Array2Struct(allocation, analyzer, func, wasm).structNew;
        Struct2Local(structNew, analyzer, func, wasm);
      }
    }

    // Next, process all structNews.
    for (auto* allocation : finder.structNews) {
      // As above, we must be able to use locals for this data.
      if (!canHandleAsLocals(allocation->type)) {
        continue;
      }

      // Check for escaping, noting relevant information as we go. If this does
      // not escape, optimize it into locals.
      EscapeAnalyzer analyzer(
        localGraph, parents, branchTargets, passOptions, wasm);
      if (!analyzer.escapes(allocation)) {
        Struct2Local(allocation, analyzer, func, wasm);
      }
    }
  }

  bool canHandleAsLocal(const Field& field) {
    return TypeUpdating::canHandleAsLocal(field.type);
  }

  bool canHandleAsLocals(Type type) {
    if (type == Type::unreachable) {
      return false;
    }

    auto heapType = type.getHeapType();
    if (heapType.isStruct()) {
      auto& fields = heapType.getStruct().fields;
      for (auto field : fields) {
        if (!canHandleAsLocal(field)) {
          return false;
        }
      }
      return true;
    }

    assert(heapType.isArray());
    return canHandleAsLocal(heapType.getArray().element);
  }
};

struct Heap2LocalPass : public WalkerPass<PostWalker<Heap2LocalPass>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Heap2LocalPass>();
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
    Heap2Local(func, *getModule(), getPassOptions());
  }
};

} // anonymous namespace

Pass* createHeap2LocalPass() { return new Heap2LocalPass(); }

} // namespace wasm
