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
// Note about running this after coalesce-locals, due to live range
// enlargement risk otherwise
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
  LocalValues start; // the local values at the start of the block
  std::vector<Expression**> setps;
};

struct RedundantSetElimination : public WalkerPass<CFGWalker<RedundantSetElimination, Visitor<RedundantSetElimination>, Info>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new RedundantSetElimination(); }

// XXX FIXMEtypedef typename CFGWalker<RedundantSetElimination, VisitorType, Info>::BasicBlock BasicBlock;

  Index numLocals;

  // cfg traversal work

  static void doVisitSetLocal(RedundantSetElimination* self, Expression** currp) {
    self->currBasicBlock->contents.setps.push_back(currp);
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

  Index nextValue = 2; // 0 and 1 are reserved
  std::unordered_map<Literal, Index> literalValues;

  Index getUnseenValue() { // we haven't seen this location yet
    return 0;
  }
  Index getMergeValue() { // this could be anything - we can't do any work here
    return 0;
  }

  Index getLiteralValue(Literal lit) {
    auto iter = literalValues.find(lit);
    if (iter != literalValues.end()) {
      return iter->second;
    }
    Index ret = nextValue++;
    literalValues[lit] = ret;
    return ret;
  }

  // flowing

  void flowValues(Function* func) {
    for (auto& block : basicBlocks) {
      LocalValues& values = block->contents.start;
      values.resize(numLocals);
      if (block.get() == entry) {
        // params are complex values we can't optimize; vars are zeros
        for (Index i = 0; i < numLocals; i++) {
          if (func->isParam(i)) {
            values[i] = getMergeValue();
          } else {
            values[i] = getLiteralValue(LiteralUtils::makeLiteralZero(func->getLocalType(i)));
          }
        }
      } else {
        // other blocks have all unseen values to begin with
        for (Index i = 0; i < numLocals; i++) {
          values[i] = getUnseenValue();
        }
      }
    }
    // keep working while stuff is flowing
    std::unordered_set<BasicBlock*> queue;
    queue.insert(entry);
    while (queue.size() > 0) {
      auto iter = queue.begin();
      auto* curr = *iter;
      queue.erase(iter);
      // flow the values at the start to the end, and apply to the blocks we reach,
      // adding them to the queue if necessary
      auto currValues = curr->contents.start; // we'll modify this as we go
      auto& setps = curr->contents.setps;
      for (auto** setp : setps) {
        auto* set = (*setp)->cast<SetLocal>();
        if (auto* c = set->value->dynCast<Const>()) {
          // a constant
          currValues[set->index] = getLiteralValue(c->value);
        } else if (auto* get = set->value->dynCast<GetLocal>()) {
          // a copy of whatever that was
          currValues[set->index] = currValues[get->index];
        } else {
          // we don't know
          currValues[set->index] = getMergeValue();
        }
      }
      for (auto* next : curr->out) {
        auto& nextValues = next->contents.start;
        bool changed = false;
        for (Index i = 0; i < numLocals; i++) {
          if (nextValues[i] == getUnseenValue()) {
            // first time we see something here
            nextValues[i] = currValues[i];
            changed = true;
          } else if (nextValues[i] != currValues[i]) {
            // a merge, we don't know any more
            nextValues[i] = getMergeValue();
            changed = true;
          }
          // otherwise, it's the same, leave it
        }
        if (changed) {
          queue.insert(next);
        }
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
        if (currValues[set->index] == getMergeValue()) {
          // the analysis can't help
          continue;
        }
        // if it's an getUnseenValue, it means we are in dead code. but don't
        // bother to try to optimize it, leave that for DCE
        if (auto* c = set->value->dynCast<Const>()) {
          // a constant
          if (currValues[set->index] == getLiteralValue(c->value)) {
            remove(setp);
          }
        } else if (auto* get = set->value->dynCast<GetLocal>()) {
          // a copy of whatever that was
          if (currValues[set->index] == currValues[get->index]) {
            remove(setp);
          }
        }
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
};

Pass *createRedundantSetEliminationPass() {
  return new RedundantSetElimination();
}

} // namespace wasm

