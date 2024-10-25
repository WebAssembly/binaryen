/*
 * Copyright 2024 WebAssembly Community Group participants
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
// Optimizes heap (GC) stores.
//
// TODO: Add dead store elimination / load forwarding here.
//

#include "cfg/cfg-traversal.h"
#include "ir/effects.h"
#include "ir/local-graph.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// In each basic block we will store the relevant heap store operations and
// other actions that matter to our analysis.
struct Info {
  std::vector<Expression**> actions;
};

struct HeapStoreOptimization
  : public WalkerPass<
      CFGWalker<HeapStoreOptimization, Visitor<HeapStoreOptimization>, Info>> {
  bool isFunctionParallel() override { return true; }

  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<HeapStoreOptimization>();
  }

  // Branches outside of the function can be ignored, as we only look at local
  // state in the function. (This may need to change if we do more general dead
  // store elimination.)
  bool ignoreBranchesOutsideOfFunc = true;

  // Store struct.sets and blocks, as we can find patterns among those.
  void addAction() {
    if (currBasicBlock) {
      currBasicBlock->contents.actions.push_back(getCurrentPointer());
    }
  }
  void visitStructSet(StructSet* curr) { addAction(); }
  void visitBlock(Block* curr) { addAction(); }

  void visitFunction(Function* curr) {
    // Now that the walk is complete and we have a CFG, find things to optimize.
    for (auto& block : basicBlocks) {
      for (auto** currp : block->contents.actions) {
        auto* curr = *currp;
        if (auto* set = curr->dynCast<StructSet>()) {
          optimizeStructSet(set, currp);
        } else if (auto* block = curr->dynCast<Block>()) {
          optimizeBlock(block);
        } else {
          WASM_UNREACHABLE("bad action");
        }
      }
    }
  }

  // Optimize a struct.set. Receives also a pointer to where it is referred to,
  // so we can replace it (which we do if we optimize).
  void optimizeStructSet(StructSet* curr, Expression** currp) {
    // If our reference is a tee of a struct.new, we may be able to fold the
    // stored value into the new itself:
    //
    //  (struct.set (local.tee $x (struct.new X Y Z)) X')
    // =>
    //  (local.set $x (struct.new X' Y Z))
    //
    if (auto* tee = curr->ref->dynCast<LocalSet>()) {
      if (auto* new_ = tee->value->dynCast<StructNew>()) {
        if (optimizeSubsequentStructSet(new_, curr, tee)) {
          // Success, so we do not need the struct.set any more, and the tee
          // can just be a set instead of us.
          tee->makeSet();
          *currp = tee;
        }
      }
    }
  }

  // Similar to the above with struct.set whose reference is a tee of a new, we
  // can do the same for subsequent sets in a list:
  //
  //  (local.set $x (struct.new X Y Z))
  //  (struct.set (local.get $x) X')
  // =>
  //  (local.set $x (struct.new X' Y Z))
  //
  // We also handle other struct.sets immediately after this one. If the
  // instruction following the new is not a struct.set we push the new down if
  // possible.
  void optimizeBlock(Block* curr) {
    auto& list = curr->list;

    for (Index i = 0; i < list.size(); i++) {
      auto* localSet = list[i]->dynCast<LocalSet>();
      if (!localSet) {
        continue;
      }
      auto* new_ = localSet->value->dynCast<StructNew>();
      if (!new_) {
        continue;
      }

      // This local.set of a struct.new looks good. Find struct.sets after it to
      // optimize.
      Index localSetIndex = i;
      for (Index j = localSetIndex + 1; j < list.size(); j++) {

        // Check that the next instruction is a struct.set on the same local as
        // the struct.new.
        auto* structSet = list[j]->dynCast<StructSet>();
        auto* localGet =
          structSet ? structSet->ref->dynCast<LocalGet>() : nullptr;
        if (!structSet || !localGet || localGet->index != localSet->index) {
          // Any time the pattern no longer matches, we try to push the
          // struct.new further down but if it is not possible we stop
          // optimizing possible struct.sets for this struct.new.
          if (trySwap(list, localSetIndex, j)) {
            // Update the index and continue to try again.
            localSetIndex = j;
            continue;
          }
          break;
        }

        // The pattern matches, try to optimize.
        if (!optimizeSubsequentStructSet(new_, structSet, localSet)) {
          break;
        } else {
          // Success. Replace the set with a nop, and continue to perhaps
          // optimize more.
          ExpressionManipulator::nop(structSet);
        }
      }
    }
  }

  // Helper function for optimizeHeapStores. Tries pushing the struct.new at
  // index i down to index j, swapping it with the instruction already at j, so
  // that it is closer to (potential) later struct.sets.
  bool trySwap(ExpressionList& list, Index i, Index j) {
    if (j == list.size() - 1) {
      // There is no reason to swap with the last element of the list as it
      // won't match the pattern because there wont be anything after. This also
      // avoids swapping an instruction that does not leave anything in the
      // stack by one that could leave something, and that which would be
      // incorrect.
      return false;
    }

    if (list[j]->is<LocalSet>() &&
        list[j]->dynCast<LocalSet>()->value->is<StructNew>()) {
      // Don't swap two struct.new instructions to avoid going back and forth.
      return false;
    }
    // Check if the two expressions can be swapped safely considering their
    // effects.
    auto firstEffects = effects(list[i]);
    auto secondEffects = effects(list[j]);
    if (secondEffects.invalidates(firstEffects)) {
      return false;
    }

    std::swap(list[i], list[j]);
    return true;
  }

  // Given a struct.new and a struct.set that occurs right after it, and that
  // applies to the same data, try to apply the set during the new. This can be
  // either with a nested tee:
  //
  //  (struct.set
  //    (local.tee $x (struct.new X Y Z))
  //    X'
  //  )
  // =>
  //  (local.set $x (struct.new X' Y Z))
  //
  // or without:
  //
  //  (local.set $x (struct.new X Y Z))
  //  (struct.set (local.get $x) X')
  // =>
  //  (local.set $x (struct.new X' Y Z))
  //
  // Returns true if we succeeded.
  bool optimizeSubsequentStructSet(StructNew* new_,
                                   StructSet* set,
                                   LocalSet* localSet) {
    // Leave unreachable code for DCE, to avoid updating types here.
    if (new_->type == Type::unreachable || set->type == Type::unreachable) {
      return false;
    }

    auto index = set->index;
    auto& operands = new_->operands;
    auto refLocalIndex = localSet->index;

    // Check for effects that prevent us moving the struct.set's value (X' in
    // the function comment) into its new position in the struct.new. First, it
    // must be ok to move it past the local.set (otherwise, it might read from
    // memory using that local, and depend on the struct.new having already
    // occurred; or, if it writes to that local, then it would cross another
    // write).
    auto setValueEffects = effects(set->value);
    if (setValueEffects.localsRead.count(refLocalIndex) ||
        setValueEffects.localsWritten.count(refLocalIndex)) {
      return false;
    }

    // We must move the set's value past indexes greater than it (Y and Z in
    // the example in the comment on this function). If this is not with_default
    // then we must check for effects.
    // TODO When this function is called repeatedly in a sequence this can
    //      become quadratic - perhaps we should memoize (though, struct sizes
    //      tend to not be ridiculously large).
    if (!new_->isWithDefault()) {
      for (Index i = index + 1; i < operands.size(); i++) {
        auto operandEffects = effects(operands[i]);
        if (operandEffects.invalidates(setValueEffects)) {
          // TODO: we could use locals to reorder everything
          return false;
        }
      }
    }

    // We must also be careful of branches out from the value that skip the
    // local.set, see below.
    if (canSkipLocalSet(new_, set, localSet, setValueEffects)) {
      return false;
    }

    // We can optimize here!
    Builder builder(*getModule());

    // If this was with_default then we add default values now. That does
    // increase code size in some cases (if there are many values, and few sets
    // that get removed), but in general this optimization is worth it.
    if (new_->isWithDefault()) {
      auto& fields = new_->type.getHeapType().getStruct().fields;
      for (auto& field : fields) {
        auto zero = Literal::makeZero(field.type);
        operands.push_back(builder.makeConstantExpression(zero));
      }
    }

    // See if we need to keep the old value.
    if (effects(operands[index]).hasUnremovableSideEffects()) {
      operands[index] =
        builder.makeSequence(builder.makeDrop(operands[index]), set->value);
    } else {
      operands[index] = set->value;
    }

    return true;
  }

  // We must be careful of branches that skip the local.set. For example:
  //
  //  (block $out
  //    (local.set $x (struct.new X Y Z))
  //    (struct.set (local.get $x) (..br $out..))  ;; X' here has a br
  //  )
  //  ..local.get $x..
  //
  // Note how we do the local.set first. Imagine we optimized to this:
  //
  //  (block $out
  //    (local.set $x (struct.new (..br $out..) Y Z))
  //  )
  //  ..local.get $x..
  //
  // Now the br happens first, skipping the local.set entirely, and the use
  // later down will not get the proper value. This is the problem we must
  // detect here.
  //
  // We are given a struct.set, the computed effects of its value (the caller
  // already has those, so this is an optimization to avoid recomputation), and
  // the local.set.
  bool canSkipLocalSet(StructNew* new_,
                       StructSet* set,
                       LocalSet* localSet,
                       const EffectAnalyzer& setValueEffects) {
    // To detect the above problem, consider this code in more detail, where the
    // value being set is a br_if, which can branch:
    //
    //  (if
    //    (..condition..)
    //    (then
    //      (block $out
    //        (local.set $x (struct.new X Y Z))
    //        (struct.set (local.get $x) (br_if $out)) ;; A
    //        (struct.set (local.get $x) (..))         ;; B
    //      )
    //      (struct.set (local.get $x) (..))           ;; C
    //    )
    //  )
    //  (struct.set (local.get $x) (..))               ;; D
    //
    // We annotate the struct.sets here with A, B, C, D. If we optimize, we'd
    // move the br_if to the struct.new, and comment out A:
    //
    //  (if
    //    (..condition..)
    //    (then
    //      (block $out
    //        (local.set $x (struct.new (br_if $out) Y Z)) ;; br_if moved here
    //        ;; (struct.set (local.get $x) )              ;; A is commented out
    //        (struct.set (local.get $x) (..))             ;; B
    //      )
    //      (struct.set (local.get $x) (..))               ;; C
    //    )
    //  )
    //  (struct.set (local.get $x) (..))                   ;; D
    //
    // No problem occurs on B: if we do not branch then we keep reading from
    // the struct.new, including the br_if value that was applied to it, and if
    // we do branch then we skip it anyhow. C, however, is a problem: if we
    // branch then the optimized version will skip the struct.new entirely,
    // rather than just skip A. D is also a problem: if we enter the if, then we
    // hit the same issue as with C.
    //
    // To detect this, we can use a LocalGraph on the IR after the optimization:
    // C and D's local.gets read not only the local.set here, but the value of
    // that local before the code here. For C, this is because of the branch,
    // and for D, it was true even before the optimization, because of the if.
    // It is that mixing of our local.set with another that is a problem here,
    // since it means we can read the value even if we branch. Note that we must
    // compute the graph *after* the optimization, as C has no mixing before: it
    // is the placing of the br_if in the struct.new that causes the mixing.

    // First, if the set's value cannot branch at all, then we have no problem.
    if (!setValueEffects.transfersControlFlow()) {
      return false;
    }

    // We may branch, so do the analysis above. As mentioned above, we must
    // analyze the state *after* the optimization. We simulate that by using the
    // struct.set we are trying to optimize way as a blocker in a LocalGraph. In
    // the above figures, the struct.set is on line A. If it blocks $x from
    // progress then the set of $x no longer reaches B at all. That is good, as
    // it shows that if the local.set were moved to the struct.set then we
    // would affect B in the same way. However, this blocking is not enough to
    // stop the set of $x from reaching C and D, because of the dangerous
    // branch: The branch skips the struct.set (the blocker), which means the
    // original local.set reaches a place that, if we optimized that set to the
    // blocker, it would no longer reach.

    // TODO: reuse!!1
    LazyLocalGraph graph(getFunction(), getModule(), StructSet::Id);





..
    bool hasOldValue;
    if (new_->isWithDefault()) {
      // Place the value as the first item. It is in the wrong index, but that
      // does not matter.
      hasOldValue = false;
      new_->operands.push_back(set->value);
    } else {
      // Combined the old and new values in a sequence (we don't want to just
      // remove the old). Note that the sequence is not fully valid IR (the
      // first element returns a value), but that does not matter in the
      // analysis.
      new_->operands[set->index] =
        Builder(*getModule())
          .makeSequence(new_->operands[set->index], set->value);
      hasOldValue = true;
    }
    // TODO: Can we reuse the LocalGraph? Not really, as it is on the new,
    //       modified IR. So we are scanning the entire function each time here,
    //       which can be very slow... maybe a blocker
    LazyLocalGraph graph(getFunction(), getModule());
    auto foundProblem = false;
    for (auto* get : graph.getSetInfluences(localSet)) {
      auto& sets = graph.getSets(get);
      // Our localSet must be present: these are the sets of a get influenced
      // by it.
      assert(sets.count(localSet) == 1);
      // If there is anything other than us, there is dangerous mixing.
      if (sets.size() > 1) {
        foundProblem = true;
        break;
      }
    }

    // Undo the IR changes regardless.
    if (!hasOldValue) {
      // Just remove the added operand.
      new_->operands.pop_back();
    } else {
      // The old value is the first in the sequence.
      new_->operands[set->index] =
        new_->operands[set->index]->cast<Block>()->list[0];
    }
..





    return foundProblem;
  }

  EffectAnalyzer effects(Expression* expr) {
    return EffectAnalyzer(getPassOptions(), *getModule(), expr);
  }
};

} // anonymous namespace

Pass* createHeapStoreOptimizationPass() { return new HeapStoreOptimization(); }

} // namespace wasm
