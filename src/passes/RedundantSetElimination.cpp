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
// A risk here is that we extend live ranges, e.g. we may use the default
// value at the very end of a function, keeping that local alive throughout.
// For that reason it is probably better to run this near the end of
// optimization, and especially after coalesce-locals. A final vaccum
// should be done after it, as this pass can leave around drop()s of
// values no longer necessary.
//
// So far this tracks constant values, and for everything else it considers
// them unique (so each set_local of a non-constant is a unique value, each
// merge is a unique value, etc.).
// TODO expand it into more of a GVN value analysis.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>
#include <cfg/cfg-traversal.h>
#include <ir/literal-utils.h>
#include <ir/utils.h>

namespace wasm {

// We do a very simple numbering of local values, just a unique
// number for constants so far, enough to see
// trivial duplication. LocalValues maps each local index to
// its current value
typedef std::vector<Index> LocalValues;

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
  std::unordered_map<SetLocal*, Index> setValues; // each set has a value
  std::unordered_map<BasicBlock*, std::unordered_map<Index, Index>> blockMergeValues; // each block has values for each merge

  Index getUnseenValue() { // we haven't seen this location yet
    return 0;
  }
  Index getUniqueValue() {
    return nextValue++;
  }

  Index getLiteralValue(Literal lit) {
    auto iter = literalValues.find(lit);
    if (iter != literalValues.end()) {
      return iter->second;
    }
    return literalValues[lit] = getUniqueValue();
  }

  Index getSetValue(SetLocal* set) {
    auto iter = setValues.find(set);
    if (iter != setValues.end()) {
      return iter->second;
    }
    return setValues[set] = getUniqueValue();
  }

  Index getBlockMergeValue(BasicBlock* block, Index index) {
    auto& mergeValues = blockMergeValues[block];
    auto iter = mergeValues.find(index);
    if (iter != mergeValues.end()) {
      return iter->second;
    }
    return mergeValues[index] = getUniqueValue();
  }

  Index getValueForSet(SetLocal* set, LocalValues& currValues) {
    if (auto* c = set->value->dynCast<Const>()) {
      // a constant
      return getLiteralValue(c->value);
    } else if (auto* get = set->value->dynCast<GetLocal>()) {
      // a copy of whatever that was
      return currValues[get->index];
    } else {
      // get the sets own unique value
      return getSetValue(set);
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
    // keep working while stuff is flowing
    std::unordered_set<BasicBlock*> queue;
    queue.insert(entry);
    while (queue.size() > 0) {
      auto iter = queue.begin();
      auto* curr = *iter;
      queue.erase(iter);
      // process a block: first, update its start based on those reaching it
      if (!curr->in.empty()) {
        if (curr->in.size() == 1) {
          // just copy the pred, nothing to merge
          curr->contents.start = (*curr->in.begin())->contents.end;
        } else {
          // perform a merge
          auto in = curr->in;
          for (Index i = 0; i < numLocals; i++) {
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
      // flow values through it, then add those we can reach if they need an update.
      auto currValues = curr->contents.start; // we'll modify this as we go
      auto& setps = curr->contents.setps;
      for (auto** setp : setps) {
        auto* set = (*setp)->cast<SetLocal>();
        currValues[set->index] = getValueForSet(set, currValues);
      }
      if (currValues == curr->contents.end) {
        // nothing changed, so no more work to do
        // note that the first iteration this is always not the case,
        // since end contains unseen (and then the comparison ends on
        // the first element)
        continue;
      }
      // update the end state and update children
      curr->contents.end.swap(currValues);
      for (auto* next : curr->out) {
        queue.insert(next);
      }
    }
  }

  // optimizing
  void optimize() {
    // in each block, run the values through the sets,
    // and remove redundant sets when we see them
    for (auto& block : basicBlocks) {
      auto currValues = block->contents.start; // we'll modify this as we go
#if 0 // scavenging code, useful for gvn, not useful yet
      // track the values present in all locals, so we can scavenge
      std::unordered_map<Index, std::set<Index>> presentValues; // value # => set of locals having it
      for (Index i = 0; i < numLocals; i++) {
        presentValues[currValues[i]].insert(i);
      }
#endif
      auto& setps = block->contents.setps;
      for (auto** setp : setps) {
        auto* set = (*setp)->cast<SetLocal>();
        auto oldValue = currValues[set->index];
        auto newValue = getValueForSet(set, currValues);
        auto index = set->index;
        if (newValue == oldValue) {
          remove(setp);
          continue; // no more work to do
        }
#if 0
        // perhaps it makes sense to scavenge, that is, get it from a local that
        // carries that value right now anyhow. if it's a trivial value
        // anyhow, cheaper than a get, just leave it.
        // TODO more careful analysis of size and cost
        auto* value = set->value;
        if (!value->is<Const>() && !value->is<GetLocal>()) {
          auto iter = presentValues.find(newValue);
          if (iter != presentValues.end()) {
            auto& haveValue = iter->second;
            if (!haveValue.empty()) {
              set->value = Builder(*getModule()).makeGetLocal(
                *haveValue.begin(),
                getFunction()->getLocalType(set->index)
              );
            }
          }
        }
#endif
        // update for later steps
        currValues[index] = newValue;
#if 0
        presentValues[oldValue].erase(set->index);
        presentValues[newValue].insert(set->index);
#endif
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

};

Pass *createRedundantSetEliminationPass() {
  return new RedundantSetElimination();
}

} // namespace wasm

