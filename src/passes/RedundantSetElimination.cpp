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
// Eliminate redundant set_locals: if a local already has a particular
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
// them unique (so each set_local of a non-constant is a unique value, each
// merge is a unique value, etc.; there is no sophisticated value numbering
// here).
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <cfg/cfg-traversal.h>
#include <ir/literal-utils.h>
#include <ir/utils.h>
#include <support/unique_deferring_queue.h>

namespace wasm {

// We do a very simple numbering of local values, just a unique
// number for constants so far, enough to see
// trivial duplication. LocalValues maps each local index to
// its current value
typedef std::vector<Index> LocalValues;

namespace {

// information in a basic block
struct Info {
  LocalValues start, end; // the local values at the start and end of the block
  std::vector<Expression**> setps;
};

struct RedundantSetElimination : public WalkerPass<CFGWalker<RedundantSetElimination, Visitor<RedundantSetElimination>, Info>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new RedundantSetElimination(); }

  Index numLocals;

  // cfg traversal work

  static void doVisitSetLocal(RedundantSetElimination* self, Expression** currp) {
    if (self->currBasicBlock) {
      self->currBasicBlock->contents.setps.push_back(currp);
    }
  }

  // main entry point

  void doWalkFunction(Function* func) {
    numLocals = func->getNumLocals();
    // create the CFG by walking the IR
    CFGWalker<RedundantSetElimination, Visitor<RedundantSetElimination>, Info>::doWalkFunction(func);
    // flow values across blocks
    flowValues(func);
    // remove redundant sets
    optimize();
  }

  // numbering

  Index nextValue = 1; // 0 is reserved for the "unseen value"
  std::unordered_map<Literal, Index> literalValues; // each constant has a value
  std::unordered_map<Expression*, Index> expressionValues; // each value can have a value
  std::unordered_map<BasicBlock*, std::unordered_map<Index, Index>> blockMergeValues; // each block has values for each merge

  Index getUnseenValue() { // we haven't seen this location yet
    return 0;
  }
  Index getUniqueValue() {
#ifdef RSE_DEBUG
    std::cout << "new unique value " << nextValue << '\n';
#endif
    return nextValue++;
  }

  Index getLiteralValue(Literal lit) {
    auto iter = literalValues.find(lit);
    if (iter != literalValues.end()) {
      return iter->second;
    }
#ifdef RSE_DEBUG
    std::cout << "new literal value for " << lit << '\n';
#endif
    return literalValues[lit] = getUniqueValue();
  }

  Index getExpressionValue(Expression* expr) {
    auto iter = expressionValues.find(expr);
    if (iter != expressionValues.end()) {
      return iter->second;
    }
#ifdef RSE_DEBUG
    std::cout << "new expr value for " << expr << '\n';
#endif
    return expressionValues[expr] = getUniqueValue();
  }

  Index getBlockMergeValue(BasicBlock* block, Index index) {
    auto& mergeValues = blockMergeValues[block];
    auto iter = mergeValues.find(index);
    if (iter != mergeValues.end()) {
      return iter->second;
    }
#ifdef RSE_DEBUG
    std::cout << "new block-merge value for " << block << " : " << index << '\n';
#endif
    return mergeValues[index] = getUniqueValue();
  }

  bool isBlockMergeValue(BasicBlock* block, Index index, Index value) {
    auto iter = blockMergeValues.find(block);
    if (iter == blockMergeValues.end()) return false;
    auto& mergeValues = iter->second;
    auto iter2 = mergeValues.find(index);
    if (iter2 == mergeValues.end()) return false;
    return value == iter2->second;
  }

  Index getValue(Expression* value, LocalValues& currValues) {
    if (auto* c = value->dynCast<Const>()) {
      // a constant
      return getLiteralValue(c->value);
    } else if (auto* get = value->dynCast<GetLocal>()) {
      // a copy of whatever that was
      return currValues[get->index];
    } else {
      // get the value's own unique value
      return getExpressionValue(value);
    }
  }

  // flowing

  void flowValues(Function* func) {
    for (auto& block : basicBlocks) {
      LocalValues& start = block->contents.start;
      start.resize(numLocals);
      if (block.get() == entry) {
        // params are complex values we can't optimize; vars are zeros
        for (Index i = 0; i < numLocals; i++) {
          if (func->isParam(i)) {
#ifdef RSE_DEBUG
            std::cout << "new param value for " << i << '\n';
#endif
            start[i] = getUniqueValue();
          } else {
            start[i] = getLiteralValue(LiteralUtils::makeLiteralZero(func->getLocalType(i)));
          }
        }
      } else {
        // other blocks have all unseen values to begin with
        for (Index i = 0; i < numLocals; i++) {
          start[i] = getUnseenValue();
        }
      }
      // the ends all begin unseen
      LocalValues& end = block->contents.end;
      end.resize(numLocals);
      for (Index i = 0; i < numLocals; i++) {
        end[i] = getUnseenValue();
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
              if (value == getUnseenValue()) {
                value = otherValue;
              } else if (otherValue == getUnseenValue()) {
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
      // flow values through it, then add those we can reach if they need an update.
      auto currValues = curr->contents.start; // we'll modify this as we go
      auto& setps = curr->contents.setps;
      for (auto** setp : setps) {
        auto* set = (*setp)->cast<SetLocal>();
        currValues[set->index] = getValue(set->value, currValues);
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
  void optimize() {
    // in each block, run the values through the sets,
    // and remove redundant sets when we see them
    for (auto& block : basicBlocks) {
      auto currValues = block->contents.start; // we'll modify this as we go
      auto& setps = block->contents.setps;
      for (auto** setp : setps) {
        auto* set = (*setp)->cast<SetLocal>();
        auto oldValue = currValues[set->index];
        auto newValue = getValue(set->value, currValues);
        auto index = set->index;
        if (newValue == oldValue) {
          remove(setp);
          continue; // no more work to do
        }
        // update for later steps
        currValues[index] = newValue;
      }
    }
  }

  void remove(Expression** setp) {
    auto* set = (*setp)->cast<SetLocal>();
    auto* value = set->value;
    if (!set->isTee()) {
      auto* drop = ExpressionManipulator::convert<SetLocal, Drop>(set);
      drop->value = value;
      drop->finalize();
    } else {
      *setp = value;
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
      std::cout << "  start[" << i << "] = " << block->contents.start[i] << '\n';
    }
    for (auto** setp : block->contents.setps) {
      std::cout << "  " << *setp << '\n';
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

Pass *createRedundantSetEliminationPass() {
  return new RedundantSetElimination();
}

} // namespace wasm

