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
// Computes liveness information for locals.
//

#ifndef liveness_traversal_h
#define liveness_traversal_h

#include "support/sorted_vector.h"
#include "wasm.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "cfg-traversal.h"
#include "ir/utils.h"

namespace wasm {

// A set of locals. This is optimized for comparisons,
// mergings, and iteration on elements, assuming that there
// may be a great many potential elements but actual sets
// may be fairly small. Specifically, we use a sorted
// vector.
typedef SortedVector LocalSet;

// A liveness-relevant action. Supports a get, a set, or an
// "other" which can be used for other purposes, to mark
// their position in a block
struct LivenessAction {
  enum What {
    Get = 0,
    Set = 1,
    Other = 2
  };
  What what;
  Index index; // the local index read or written
  Expression** origin; // the origin
  bool effective; // whether a store is actually effective, i.e., may be read

  LivenessAction(What what, Index index, Expression** origin) : what(what), index(index), origin(origin), effective(false) {
    assert(what != Other);
    if (what == Get) assert((*origin)->is<GetLocal>());
    if (what == Set) assert((*origin)->is<SetLocal>());
  }
  LivenessAction(Expression** origin) : what(Other), origin(origin) {}

  bool isGet() { return what == Get; }
  bool isSet() { return what == Set; }
  bool isOther() { return what == Other; }

  // Helper to remove a set that is a copy we know is not needed. This
  // updates both the IR and the action.
  void removeCopy() {
    auto* set = (*origin)->cast<SetLocal>();
    if (set->isTee()) {
      *origin = set->value->cast<GetLocal>();
    } else {
      ExpressionManipulator::nop(set);
    }
    // Mark as an other: even if we turned the origin into a get,
    // we already have another Action for that get, that properly
    // represents it.
    what = Other;
  }
};

// information about liveness in a basic block
struct Liveness {
  LocalSet start, end; // live locals at the start and end
  std::vector<LivenessAction> actions; // actions occurring in this block

#if LIVENESS_DEBUG
  void dump(Function* func) {
    if (actions.empty()) return;
    std::cout << "    actions:\n";
    for (auto& action : actions) {
      std::cout << "      " << (action.isGet() ? "get" : (action.isSet() ? "set" : "other")) << " " << func->getLocalName(action.index) << "\n";
    }
  }
#endif // LIVENESS_DEBUG
};

template<typename SubType, typename VisitorType>
struct LivenessWalker : public CFGWalker<SubType, VisitorType, Liveness> {
  typedef typename CFGWalker<SubType, VisitorType, Liveness>::BasicBlock BasicBlock;

  Index numLocals;
  std::unordered_set<BasicBlock*> liveBlocks;
  std::vector<uint8_t> copies; // canonicalized - accesses should check (low, high) TODO: use a map for high N, as this tends to be sparse? or don't look at copies at all for big N?
  std::vector<Index> totalCopies; // total # of copies for each local, with all others

  // cfg traversal work

  static void doVisitGetLocal(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<GetLocal>();
     // if in unreachable code, ignore
    if (!self->currBasicBlock) {
      *currp = Builder(*self->getModule()).replaceWithIdenticalType(curr);
      return;
    }
    self->currBasicBlock->contents.actions.emplace_back(LivenessAction::Get, curr->index, currp);
  }

  static void doVisitSetLocal(SubType* self, Expression** currp) {
    auto* curr = (*currp)->cast<SetLocal>();
    // if in unreachable code, we don't need the tee (but might need the value, if it has side effects)
    if (!self->currBasicBlock) {
      if (curr->isTee()) {
        *currp = curr->value;
      } else {
        *currp = Builder(*self->getModule()).makeDrop(curr->value);
      }
      return;
    }
    self->currBasicBlock->contents.actions.emplace_back(LivenessAction::Set, curr->index, currp);
    // if this is a copy, note it
    if (auto* get = self->getCopy(curr)) {
      // add 2 units, so that backedge prioritization can decide ties, but not much more
      self->addCopy(curr->index, get->index);
      self->addCopy(curr->index, get->index);
    }
  }

  // A simple copy is a set of a get. A more interesting copy
  // is a set of an if with a value, where one side a get.
  // That can happen when we create an if value in simplify-locals. TODO: recurse into
  // nested ifs, and block return values? Those cases are trickier, need to
  // count to see if worth it.
  // TODO: an if can have two copies
  GetLocal* getCopy(SetLocal* set) {
    if (auto* get = set->value->dynCast<GetLocal>()) return get;
    if (auto* iff = set->value->dynCast<If>()) {
      if (auto* get = iff->ifTrue->dynCast<GetLocal>()) return get;
      if (iff->ifFalse) {
        if (auto* get = iff->ifFalse->dynCast<GetLocal>()) return get;
      }
    }
    return nullptr;
  }

  // main entry point

  void doWalkFunction(Function* func) {
    numLocals = func->getNumLocals();
    copies.resize(numLocals * numLocals);
    std::fill(copies.begin(), copies.end(), 0);
    totalCopies.resize(numLocals);
    std::fill(totalCopies.begin(), totalCopies.end(), 0);
    // create the CFG by walking the IR
    CFGWalker<SubType, VisitorType, Liveness>::doWalkFunction(func);
    // ignore links to dead blocks, so they don't confuse us and we can see their stores are all ineffective
    liveBlocks = CFGWalker<SubType, VisitorType, Liveness>::findLiveBlocks();
    CFGWalker<SubType, VisitorType, Liveness>::unlinkDeadBlocks(liveBlocks);
    // flow liveness across blocks
    flowLiveness();
  }

  void flowLiveness() {
    // keep working while stuff is flowing
    std::unordered_set<BasicBlock*> queue;
    for (auto& curr : CFGWalker<SubType, VisitorType, Liveness>::basicBlocks) {
      if (liveBlocks.count(curr.get()) == 0) continue; // ignore dead blocks
      queue.insert(curr.get());
      // do the first scan through the block, starting with nothing live at the end, and updating the liveness at the start
      scanLivenessThroughActions(curr->contents.actions, curr->contents.start);
    }
    // at every point in time, we assume we already noted interferences between things already known alive at the end, and scanned back through the block using that
    while (queue.size() > 0) {
      auto iter = queue.begin();
      auto* curr = *iter;
      queue.erase(iter);
      LocalSet live;
      if (!mergeStartsAndCheckChange(curr->out, curr->contents.end, live)) continue;
      assert(curr->contents.end.size() < live.size());
      curr->contents.end = live;
      scanLivenessThroughActions(curr->contents.actions, live);
      // liveness is now calculated at the start. if something
      // changed, all predecessor blocks need recomputation
      if (curr->contents.start == live) continue;
      assert(curr->contents.start.size() < live.size());
      curr->contents.start = live;
      for (auto* in : curr->in) {
        queue.insert(in);
      }
    }
  }

  // merge starts of a list of blocks. return
  // whether anything changed vs an old state (which indicates further processing is necessary).
  bool mergeStartsAndCheckChange(std::vector<BasicBlock*>& blocks, LocalSet& old, LocalSet& ret) {
    if (blocks.size() == 0) return false;
    ret = blocks[0]->contents.start;
    if (blocks.size() > 1) {
      // more than one, so we must merge
      for (Index i = 1; i < blocks.size(); i++) {
        ret = ret.merge(blocks[i]->contents.start);
      }
    }
    return old != ret;
  }

  void scanLivenessThroughActions(std::vector<LivenessAction>& actions, LocalSet& live) {
    // move towards the front
    for (int i = int(actions.size()) - 1; i >= 0; i--) {
      auto& action = actions[i];
      if (action.isGet()) {
        live.insert(action.index);
      } else if (action.isSet()) {
        live.erase(action.index);
      }
    }
  }

  void addCopy(Index i, Index j) {
    auto k = std::min(i, j) * numLocals + std::max(i, j);
    copies[k] = std::min(copies[k], uint8_t(254)) + 1;
    totalCopies[i]++;
    totalCopies[j]++;
  }

  uint8_t getCopies(Index i, Index j) {
    return copies[std::min(i, j) * numLocals + std::max(i, j)];
  }
};

} // namespace wasm

#endif // liveness_traversal_h
