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
#include "pass.h"
#include "support/unique_deferring_queue.h"
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
  : public WalkerPass<CFGWalker<HeapStoreOptimization, Visitor<HeapStoreOptimization>, Info>> {

  bool isFunctionParallel() override { return true; }

  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<HeapStoreOptimization>();
  }

  using Super = WalkerPass<CFGWalker<HeapStoreOptimization, Visitor<HeapStoreOptimization>, Info>>;

  // Branches outside of the function can be ignored, as we only look at local
  // state in the function. (This may need to change if we do more general dead
  // store elimination.)
  bool ignoreBranchesOutsideOfFunc = true;

  // Track the parent block of expressions we care about.
  std::unordered_map<Expression*, BasicBlock*> expressionBlocks;

  // Store the actions we can optimize for later processing.
  void addAction() {
    if (currBasicBlock) {
      currBasicBlock->contents.actions.push_back(getCurrentPointer());
      expressionBlocks[getCurrent()] = currBasicBlock;
    }
  }
  void visitStructSet(StructSet* curr) {
    addAction();
  }
  void visitBlock(Block* curr) {
    addAction();
  }

  // Override scan so we can note the basic block that struct.set's values are
  // in (we will need that later to check for safety, see
  // optimizeSubsequentStructSet).
  static void scan(HeapStoreOptimization* self, Expression** currp) {
    if (auto* set = (*currp)->dynCast<StructSet>()) {
      self->pushTask(HeapStoreOptimization::doVisitStructSet, currp);
      self->pushTask(HeapStoreOptimization::scan, &set->value);
      self->pushTask(HeapStoreOptimization::notePreSetValue, currp);
      self->pushTask(HeapStoreOptimization::scan, &set->ref);
    } else {
      super::scan(self, currp);
    }
  }
  static void notePreSetValue(HeapStoreOptimization* self, Expression** currp) {
    // We are just about to process the struct.set's value, so the current basic
    // block is where the set's reference just ended, which is where the set's
    // value will begin.
    if (self->currBasicBlock) {
      auto* set = (*currp)->cast<StructSet>();
      self->expressionBlocks[set->ref] = self->currBasicBlock;
    }
  }

  // As we optimize we mark blocks we've reached. This is done in post-order,
  // and allows us to check for forward branches in a useful manner, see
  // optimizeSubsequentStructSet().
  std::unordered_set<BasicBlock*> seenBlocks;

  void visitFunction(Function* curr) {
    // Now that the walk is complete and we have a CFG, find things to optimize.
    for (auto& block : basicBlocks) {
      seenBlocks.insert(block.get());
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
        if (optimizeSubsequentStructSet(new_, curr, tee->index)) {
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
        if (!optimizeSubsequentStructSet(new_, structSet, localGet->index)) {
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
                                   Index refLocalIndex) {
    // Leave unreachable code for DCE, to avoid updating types here.
    if (new_->type == Type::unreachable || set->type == Type::unreachable) {
      return false;
    }

    auto index = set->index;
    auto& operands = new_->operands;

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

    // We must also be careful of branches out from the value. For example:
    //
    //  (block $out
    //    (local.set $x (struct.new X Y Z))
    //    (struct.set (local.get $x) (..br $out..))  ;; X' here has a br
    //  )
    //  ..use $x..
    //
    // Note how we do the local.set first. Imagine we optimized to this:
    //
    //  (block $out
    //    (local.set $x (struct.new (..br $out..) Y Z))
    //  )
    //  ..use $x..
    //
    // Now the br happens first, skipping the local.set entirely, and the use
    // later down will not get the proper value.
    //
    // To check for this problem, see which basic blocks can be reached from the
    // value. The structured IR limits what is possible here, since we know that
    // the struct.set follows the local.set: the only problem is one like we
    // showed in the example, where we branch to something after the
    // struct.set's basic block, in post-order. As we are processing the blocks
    // in that same order, we just need to see that we cannot reach any block we
    // have yet to see.
    //
    // Note that there may be more basic blocks after the struct.set, but they
    // cannot be reached due to the structured control flow:
    //
    //  (block $out
    //    (local.set ..
    //    (struct.set ..
    //    (if
    //      ..more control flow..
    //    )
    //  )
    //
    // At this point in the traversal we have reached the block, so we've seen
    // the if's basic blocks. But nothing in the struct.set's value can branch
    // to them: there is no way to jump into the middle of a block.
    UniqueNonrepeatingDeferredQueue<BasicBlock*> reached;
    // We start the flow from right before the value, which means the end of the
    // reference.
    auto* blockBeforeValue = expressionBlocks[set->ref];
    if (!blockBeforeValue) {
      // We are in unreachable code.
      return false;
    }
    // It must have already been reached, since we've processed the struct.set.
    assert(seenBlocks.count(blockBeforeValue));
    reached.push(blockBeforeValue);
    // We will stop the flow when we reach the struct.set itself: it is fine for
    // control flow to get there, that is what normally happens.
    auto* structSetBlock = expressionBlocks[set];
    if (!structSetBlock) {
      // We are in unreachable code.
      return false;
    }
    assert(seenBlocks.count(structSetBlock));
    while (!reached.empty()) {
      // Flow to the successors.
      auto* block = reached.pop();
      if (block == structSetBlock) {
        // This is the normal place control flow should get to, the struct.set
        // that is the parent of the value.
        continue;
      }
      for (auto* out : block->out) {
        if (!seenBlocks.count(out)) {
          // This is a dangerous jump forward, as described above. Give up.
          // TODO: We could be more precise and look for actual local.gets of
          //       our value. If no such gets exist, this is still safe.
          return false;
        }
        reached.push(out);
      }
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

  EffectAnalyzer effects(Expression* expr) {
    return EffectAnalyzer(getPassOptions(), *getModule(), expr);
  }
};

} // anonymous namespace

Pass* createHeapStoreOptimizationPass() { return new HeapStoreOptimization(); }

} // namespace wasm