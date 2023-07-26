/*
 * Copyright 2017 WebAssembly Community Group participants
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
// Eliminate redundant local.sets: if a local already has a particular
// value, we don't need to set it again. A common case here is loops
// that start at zero, since the default value is initialized to
// zero anyhow.
//
// A risk here is that we extend live ranges, e.g. we may use the default
// value at the very end of a function, keeping that local alive throughout.
// For that reason it is probably better to run this near the end of
// optimization, and especially after coalesce-locals. A final vaccum
// should be done after it, as this pass can leave around drop()s of
// values no longer necessary.
//
// So far this tracks constant values, and for everything else it considers
// them unique (so each local.set of a non-constant is a unique value, each
// merge is a unique value, etc.; there is no sophisticated value numbering
// here).
//

#include <cfg/cfg-traversal.h>
#include <ir/literal-utils.h>
#include <ir/numbering.h>
#include <ir/properties.h>
#include <ir/utils.h>
#include <pass.h>
#include <support/small_set.h>
#include <support/unique_deferring_queue.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

// Map each local index to its current value number (which is computed in
// ValueNumbering).
using LocalValues = std::vector<Index>;

namespace {

// information in a basic block
struct Info {
  LocalValues start, end; // the local values at the start and end of the block
  std::vector<Expression**> items;
};

struct RedundantSetElimination
  : public WalkerPass<CFGWalker<RedundantSetElimination,
                                Visitor<RedundantSetElimination>,
                                Info>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<RedundantSetElimination>();
  }

  // Branches outside of the function can be ignored, as we only look at locals
  // which vanish when we leave.
  bool ignoreBranchesOutsideOfFunc = true;

  Index numLocals;

  // In rare cases we make a change to a type that requires a refinalize.
  bool refinalize = false;

  // cfg traversal work

  static void doVisitLocalGet(RedundantSetElimination* self,
                              Expression** currp) {
    if (self->currBasicBlock) {
      self->currBasicBlock->contents.items.push_back(currp);
    }
  }
  static void doVisitLocalSet(RedundantSetElimination* self,
                              Expression** currp) {
    if (self->currBasicBlock) {
      self->currBasicBlock->contents.items.push_back(currp);
    }
  }

  // main entry point

  void doWalkFunction(Function* func) {
    numLocals = func->getNumLocals();
    if (numLocals == 0) {
      return; // nothing to do
    }

    // Create a unique value for use to mark unseen locations.
    unseenValue = valueNumbering.getUniqueValue();

    // create the CFG by walking the IR
    CFGWalker<RedundantSetElimination, Visitor<RedundantSetElimination>, Info>::
      doWalkFunction(func);
    // flow values across blocks
    flowValues(func);
    // remove redundant sets
    optimize(func);

    if (refinalize) {
      ReFinalize().walkFunctionInModule(func, this->getModule());
    }
  }

  // Use a value numbering for the values of expressions.
  ValueNumbering valueNumbering;

  // In additon to valueNumbering, each block has values for each merge.
  std::unordered_map<BasicBlock*, std::unordered_map<Index, Index>>
    blockMergeValues;

  // A value that indicates we haven't seen this location yet.
  Index unseenValue;

  Index getUniqueValue() {
    auto value = valueNumbering.getUniqueValue();
#ifdef RSE_DEBUG
    std::cout << "new unique value " << value << '\n';
#endif
    return value;
  }

  Index getValue(Literals lit) {
    auto value = valueNumbering.getValue(lit);
#ifdef RSE_DEBUG
    std::cout << "lit value " << value << '\n';
#endif
    return value;
  }

  Index getBlockMergeValue(BasicBlock* block, Index index) {
    auto& mergeValues = blockMergeValues[block];
    auto iter = mergeValues.find(index);
    if (iter != mergeValues.end()) {
      return iter->second;
    }
#ifdef RSE_DEBUG
    std::cout << "new block-merge value for " << block << " : " << index
              << '\n';
#endif
    return mergeValues[index] = getUniqueValue();
  }

  bool isBlockMergeValue(BasicBlock* block, Index index, Index value) {
    auto iter = blockMergeValues.find(block);
    if (iter == blockMergeValues.end()) {
      return false;
    }
    auto& mergeValues = iter->second;
    auto iter2 = mergeValues.find(index);
    if (iter2 == mergeValues.end()) {
      return false;
    }
    return value == iter2->second;
  }

  Index getValue(Expression* expr, LocalValues& currValues) {
    if (auto* get = expr->dynCast<LocalGet>()) {
      // a copy of whatever that was
      return currValues[get->index];
    }
    auto value = valueNumbering.getValue(expr);
#ifdef RSE_DEBUG
    std::cout << "expr value " << value << '\n';
#endif
    return value;
  }

  // flowing

  void flowValues(Function* func) {
    for (auto& block : basicBlocks) {
      LocalValues& start = block->contents.start;
      start.resize(numLocals);
      if (block.get() == entry) {
        // params are complex values we can't optimize; vars are zeros
        for (Index i = 0; i < numLocals; i++) {
          auto type = func->getLocalType(i);
          if (func->isParam(i)) {
#ifdef RSE_DEBUG
            std::cout << "new param value for " << i << '\n';
#endif
            start[i] = getUniqueValue();
          } else if (!LiteralUtils::canMakeZero(type)) {
#ifdef RSE_DEBUG
            std::cout << "new unique value for non-zeroable " << i << '\n';
#endif
            start[i] = getUniqueValue();
          } else {
            start[i] = getValue(Literal::makeZeros(type));
          }
        }
      } else {
        // other blocks have all unseen values to begin with
        for (Index i = 0; i < numLocals; i++) {
          start[i] = unseenValue;
        }
      }
      // the ends all begin unseen
      LocalValues& end = block->contents.end;
      end.resize(numLocals);
      for (Index i = 0; i < numLocals; i++) {
        end[i] = unseenValue;
      }
    }
    // keep working while stuff is flowing. we use a unique deferred queue
    // which ensures both FIFO and that we don't do needless work - if
    // A and B reach C, and both queue C, we only want to do C at the latest
    // time, when we have information from all those reaching it.
    UniqueDeferredQueue<BasicBlock*> work;
    work.push(entry);
    while (!work.empty()) {
      auto* curr = work.pop();
#ifdef RSE_DEBUG
      std::cout << "flow block " << curr << '\n';
#endif
      // process a block: first, update its start based on those reaching it
      if (!curr->in.empty()) {
        if (curr->in.size() == 1) {
          // just copy the pred, nothing to merge
          curr->contents.start = (*curr->in.begin())->contents.end;
        } else {
          // perform a merge
          auto in = curr->in;
          for (Index i = 0; i < numLocals; i++) {
            auto old = curr->contents.start[i];
            // If we already had a merge value here, keep it.
            // TODO This may have some false positives, as we may e.g. have
            //      a single pred that first gives us x, then later y after
            //      flow led to a merge, and we may see x and y at the same
            //      time due to flow from a successor, and then it looks like
            //      we need a merge but we don't. avoiding that would require
            //      more memory and is probably not worth it, but might be
            //      worth investigating
            // NB While suboptimal, this simplification provides a simple proof
            //    of convergence. We prove that, in each fixed block+local,
            //    the value number at the end is nondecreasing across
            //    iterations, by induction on the iteration:
            //     * The first iteration is on the entry block. It increases
            //       the value number at the end from 0 (unseen) to something
            //       else (a value number for 0 for locals, a unique value
            //       for params; all >0).
            //     * Induction step: assuming the property holds for all past
            //       iterations, consider the current iteration. Of our
            //       predecessors, those that we iterated on have the property;
            //       those that we haven't will have 0 (unseen).
            //        * If we assign to that local in this block, that will be
            //          the value in the output, forever, and it is greater
            //          than the initial value of 0.
            //        * If we see different values coming in, we create a merge
            //          value number. Its number is higher than everything
            //          else since we give it the next available number, so we
            //          do not decrease in this iteration, and we will output
            //          the same value in the future too (here is where we use
            //          the simplification property).
            //        * Otherwise, we will flow the incoming value through,
            //          and it did not decrease (by induction), so neither do
            //          we.
            //    Finally, given value numbers are nondecreasing, we must
            //    converge since we only keep working as long as we see new
            //    values at the end of a block.
            //
            //    Not that we don't trust this proof, but the convergence
            //    property (value numbers at block ends do not decrease) is
            //    verified later down.
            if (isBlockMergeValue(curr, i, old)) {
              continue;
            }
            auto iter = in.begin();
            auto value = (*iter)->contents.end[i];
            iter++;
            while (iter != in.end()) {
              auto otherValue = (*iter)->contents.end[i];
              if (value == unseenValue) {
                value = otherValue;
              } else if (otherValue == unseenValue) {
                // nothing to do, other has no information
              } else if (value != otherValue) {
                // 2 different values, this is a merged value
                value = getBlockMergeValue(curr, i);
                break; // no more work once we see a merge
              }
              iter++;
            }
            curr->contents.start[i] = value;
          }
        }
      }
#ifdef RSE_DEBUG
      dump("start", curr->contents.start);
#endif
      // flow values through it, then add those we can reach if they need an
      // update.
      auto currValues = curr->contents.start; // we'll modify this as we go
      auto& items = curr->contents.items;
      for (auto** item : items) {
        if (auto* set = (*item)->dynCast<LocalSet>()) {
          auto* value = Properties::getFallthrough(
            set->value, getPassOptions(), *getModule());
          currValues[set->index] = getValue(value, currValues);
        }
      }
      if (currValues == curr->contents.end) {
        // nothing changed, so no more work to do
        // note that the first iteration this is always not the case,
        // since end contains unseen (and then the comparison ends on
        // the first element)
        continue;
      }
      // update the end state and update children
#ifndef NDEBUG
      // verify the convergence property mentioned in the NB comment
      // above: the value numbers at the end must be nondecreasing
      for (Index i = 0; i < numLocals; i++) {
        assert(currValues[i] >= curr->contents.end[i]);
      }
#endif
      curr->contents.end.swap(currValues);
#ifdef RSE_DEBUG
      dump("end  ", curr->contents.end);
#endif
      for (auto* next : curr->out) {
        work.push(next);
      }
    }
  }

  // optimizing
  void optimize(Function* func) {
    // Find which locals are refinable, that is, that when we see a global.get
    // of them we may consider switching to another local index that has the
    // same value but in a refined type. Computing which locals are relevant for
    // that optimization is efficient because it avoids a bunch of work below
    // for hashing numbers etc.
    std::vector<bool> isRefinable(numLocals, false);
    for (Index i = 0; i < numLocals; i++) {
      // TODO: we could also note which locals have "maximal" types, where no
      //       other local is a refinement of them
      if (func->getLocalType(i).isRef()) {
        isRefinable[i] = true;
      }
    }

    // in each block, run the values through the sets,
    // and remove redundant sets when we see them
    for (auto& block : basicBlocks) {
      auto currValues = block->contents.start; // we'll modify this as we go
      auto& items = block->contents.items;

      // Set up the equivalences at the beginning of the block. We'll update
      // them as we go, so we can use them at any point in the middle. This data
      // structure maps a value number to the local indexes that have that
      // value.
      //
      // Note that the set here must be ordered to avoid nondeterminism when
      // picking between multiple equally-good indexes (we'll pick the first in
      // the iteration, which will have the lowest index).
      std::unordered_map<Index, SmallSet<Index, 3>> valueToLocals;
      assert(currValues.size() == numLocals);
      for (Index i = 0; i < numLocals; i++) {
        if (isRefinable[i]) {
          valueToLocals[currValues[i]].insert(i);
        }
      }

      for (auto** item : items) {
        if (auto* set = (*item)->dynCast<LocalSet>()) {
          auto oldValue = currValues[set->index];
          auto* value = Properties::getFallthrough(
            set->value, getPassOptions(), *getModule());
          auto newValue = getValue(value, currValues);
          auto index = set->index;
          if (newValue == oldValue) {
            remove(item);
          } else {
            // update for later steps
            currValues[index] = newValue;
            if (isRefinable[index]) {
              valueToLocals[oldValue].erase(index);
              valueToLocals[newValue].insert(index);
            }
          }
          continue;
        }

        // For gets, see if there is another index with that value, of a more
        // refined type.
        auto* get = (*item)->dynCast<LocalGet>();
        if (!isRefinable[get->index]) {
          continue;
        }

        for (auto i : valueToLocals[getValue(get, currValues)]) {
          auto currType = func->getLocalType(get->index);
          auto possibleType = func->getLocalType(i);
          if (possibleType != currType &&
              Type::isSubType(possibleType, currType)) {
            // We found an improvement!
            get->index = i;
            get->type = possibleType;
            refinalize = true;
          }
        }
      }
    }
  }

  void remove(Expression** item) {
    auto* set = (*item)->cast<LocalSet>();
    auto* value = set->value;
    if (!set->isTee()) {
      auto* drop = ExpressionManipulator::convert<LocalSet, Drop>(set);
      drop->value = value;
      drop->finalize();
    } else {
      // If we are replacing the set with something of a more specific type,
      // then we need to refinalize, for example:
      //
      //  (struct.get $X 0
      //    (local.tee $x
      //      (..something of type $Y, a subtype of $X..)
      //    )
      //  )
      //
      // After the replacement the struct.get will read from $Y, whose field may
      // have a more refined type.
      if (value->type != set->type) {
        refinalize = true;
      }
      *item = value;
    }
  }

  // debugging

  void dump(BasicBlock* block) {
    std::cout << "====\n";
    if (block) {
      std::cout << "block: " << block << '\n';
      for (auto* out : block->out) {
        std::cout << "  goes to " << out << '\n';
      }
    }
    for (Index i = 0; i < block->contents.start.size(); i++) {
      std::cout << "  start[" << i << "] = " << block->contents.start[i]
                << '\n';
    }
    for (auto** item : block->contents.items) {
      std::cout << "  " << *item << '\n';
    }
    std::cout << "====\n";
  }

  void dump(const char* desc, LocalValues& values) {
    std::cout << desc << ": ";
    for (auto x : values) {
      std::cout << x << ' ';
    }
    std::cout << '\n';
  }
};

} // namespace

Pass* createRedundantSetEliminationPass() {
  return new RedundantSetElimination();
}

} // namespace wasm
