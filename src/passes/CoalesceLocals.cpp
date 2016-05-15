/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Coalesce locals, in order to reduce the total number of locals. This
// is similar to register allocation, however, there is never any
// spilling, and there isn't a fixed number of locals.
//


#include <memory>
#include <unordered_set>

#include "wasm.h"
#include "pass.h"
#include "ast_utils.h"
#include "cfg/cfg-traversal.h"

namespace wasm {

// A set of locals
struct LocalSet : std::vector<bool> {
  LocalSet() {}
  LocalSet(size_t size) {
    clear(size);
  }

  void clear(size_t size) {
    resize(size);
    std::fill(begin(), end(), 0);
  }

  size_t count() {
    size_t ret = 0;
    for (size_t i = 0; i < size(); i++) {
      ret += (*this)[i];
    }
    return ret;
  }
};

// a liveness-relevant action
struct Action {
  enum What {
    Get, Set
  };
  What what;
  Index index; // the local index read or written
  Expression** origin; // the origin
  bool effective; // whether a store is actually effective, i.e., may be read

  Action(What what, Index index, Expression** origin) : what(what), index(index), origin(origin), effective(false) {}

  bool isGet() { return what == Get; }
  bool isSet() { return what == Set; }
};

// information about liveness in a basic block
struct Liveness {
  LocalSet start, end; // live locals at the start and end
  std::vector<Action> actions; // actions occurring in this block

  void dump(Function* func) {
    if (actions.empty()) return;
    std::cout << "    actions:\n";
    for (auto& action : actions) {
      std::cout << "      " << (action.isGet() ? "get" : "set") << " " << func->getLocalName(action.index) << "\n";
    }
  }
};

struct CoalesceLocals : public WalkerPass<CFGWalker<CoalesceLocals, Visitor<CoalesceLocals>, Liveness>> {
  bool isFunctionParallel() { return true; }

  Index numLocals;

  BasicBlock* makeBasicBlock() {
    auto ret = new BasicBlock();
    ret->contents.start.clear(numLocals);
    ret->contents.end.clear(numLocals);
    return ret;
  }

  // cfg traversal work

  static void doVisitGetLocal(CoalesceLocals* self, Expression** currp) {
    auto* curr = (*currp)->cast<GetLocal>();
    self->currBasicBlock->contents.actions.emplace_back(Action::Get, curr->index, currp);
  }

  static void doVisitSetLocal(CoalesceLocals* self, Expression** currp) {
    auto* curr = (*currp)->cast<SetLocal>();
    self->currBasicBlock->contents.actions.emplace_back(Action::Set, curr->index, currp);
  }

  // main entry point

  void walk(Expression*& root) {
    numLocals = getFunction()->getNumLocals();
    // collect initial liveness info
    WalkerPass<CFGWalker<CoalesceLocals, Visitor<CoalesceLocals>, Liveness>>::walk(root);
    // ignore links to dead blocks, so they don't confuse us and we can see their stores are all ineffective
    liveBlocks = findLiveBlocks();
    unlinkDeadBlocks(liveBlocks);
#ifdef CFG_DEBUG
    dumpCFG("the cfg", getFunction());
#endif
    // flow liveness across blocks
    flowLiveness();
    // pick new indices
    auto indices = pickIndices();
    // apply indices
    applyIndices(indices, root);
  }

  // inteference state

  LocalSet interferences;
  std::unordered_set<BasicBlock*> liveBlocks;

  void interfere(Index i, Index j) {
    if (i == j) return;
#ifdef CFG_DEBUG
    if (!interferences[i + j * numLocals]) {
      std::cout << getFunction()->name << ": interfere " << getFunction()->getLocalName(std::min(i, j)) << " : " << getFunction()->getLocalName(std::max(i, j)) << "\n";
    }
#endif
    interferences[i + j * numLocals] = 1;
    interferences[j + i * numLocals] = 1;
  }

  void flowLiveness() {
    interferences.clear(numLocals * numLocals);
    // keep working while stuff is flowing
    std::vector<BasicBlock*> queue; // TODO set to avoid inserting same block more than once at a time period. TODO optimize, an order might be more efficient
    for (auto& curr : basicBlocks) {
      if (liveBlocks.count(curr.get()) == 0) continue; // ignore dead blocks
      queue.push_back(curr.get());
      // do the first scan through the block, starting with nothing live at the end, and updating the liveness at the start
      scanLivenessThroughActions(curr->contents.actions, curr->contents.start);
    }
    // at every point in time, we assume we already noted interferences between things already known alive at the end, and scanned back throught the block using that
    while (queue.size() > 0) {
      auto* curr = queue.back(); // TODO: order?
      queue.pop_back();
      LocalSet live(numLocals);
      if (!mergeStartsAndCheckChange(curr->out, curr->contents.end, live)) continue;
#ifdef CFG_DEBUG
      std::cout << "change noticed at end of " << debugIds[curr] << " from " << curr->contents.end.count() << " to " << live.count() << " (out of " << numLocals << ")\n";
#endif
      assert(curr->contents.end.count() < live.count());
      curr->contents.end = live;
      scanLivenessThroughActions(curr->contents.actions, live);
      // liveness is now calculated at the start. if something
      // changed, all predecessor blocks need recomputation
      if (curr->contents.start == live) continue;
#ifdef CFG_DEBUG
      std::cout << "change noticed at start of " << debugIds[curr] << " from " << curr->contents.start.count() << " to " << live.count() << ", more work to do\n";
#endif
      assert(curr->contents.start.count() < live.count());
      curr->contents.start = live;
      for (auto* in : curr->in) {
        queue.push_back(in);
#ifdef CFG_DEBUG_ORDER
        // alternative code for changing the flow order; results must be the same, as we detect a property of the graph.
        if (queue.empty()) {
          queue.push_back(in);
        } else {
          //abort();
          auto* front = queue[0];
          queue[0] = in;
          queue.push_back(front);
        }
#endif
      }
    }
    // live locals at the entry block include params, obviously, but also
    // vars, in which case the 0-init value is actually used.
#ifdef CFG_DEBUG
    std::hash<std::vector<bool>> hasher;
    std::cout << getFunction()->name << ": interference hash: " << hasher(*(std::vector<bool>*)&interferences) << "\n";
    for (size_t i = 0; i < numLocals; i++) {
      std::cout << "int for " << getFunction()->getLocalName(i) << " [" << i << "]: ";
      for (size_t j = 0; j < numLocals; j++) {
        assert(interferences[i * numLocals + j] == interferences[j * numLocals + i]);
        if (interferences[i * numLocals + j]) std::cout << getFunction()->getLocalName(j) << " ";
      }
      std::cout << "\n";
    }
#endif
  }

  // merge starts of a list of blocks, adding new interferences as necessary. return
  // whether anything changed vs an old state (which indicates further processing is necessary).
  bool mergeStartsAndCheckChange(std::vector<BasicBlock*>& blocks, LocalSet& old, LocalSet& ret) {
    // merge all the live locals, and add interferences that show up from the merging.
    // we can assume that locals live together already are already known to be in conflict.
    if (blocks.size() == 0) return false;
    if (blocks.size() == 1) {
      // new interferences are impossible, they would have already been in conflict in the single predecessor.
      ret = blocks[0]->contents.start;
      return old != ret;
    }
    // more than one, so we must merge
    for (auto* block : blocks) {
      for (size_t i = 0; i < numLocals; i++) {
        ret[i] = ret[i] || block->contents.start[i]; // TODO: optimize
      }
    }
    // If there is no change in the merged result, then no new conflicts are possible.
    // Assume the opposite, that we would be missing a conflict between x and y. Then
    // since the merged result has not changed, x and y were present before as well.
    // If they were present in the same origin block, then they were already in
    // conflict there, and it is not a new conflict. If not, then they each arrive
    // from different origins, with x arriving from X = { b_0..b_i } and y arriving from
    // Y = { b_i+1..b_j }, where all those blocks are unique (since x and y never arrive from
    // the same block, by assumption). Livenesses are monotonic, i.e., flowing only adds
    // locals, never removes, so compared to the past state, we only added to X and Y.
    // Mark the past arrivals X' and Y', and note that those two cannot be empty, since
    // by assumption the merged result has not changed - x and y were already present
    // before. But that means that x and y were already in conflict in the past, so
    // this is not a new conflict.
    if (ret == old) return false;
    // look for conflicts TODO: optimize
    for (size_t i = 0; i < numLocals; i++) {
      for (size_t j = 0; j < numLocals; j++) {
        if (ret[i] && ret[j]) interfere(i, j);
      }
    }
    return true;
  }

  void scanLivenessThroughActions(std::vector<Action>& actions, LocalSet& live) {
    // move towards the front
    for (int i = int(actions.size()) - 1; i >= 0; i--) {
      auto& action = actions[i];
      if (action.isGet()) {
        // new live local, interferes with all the rest
        for (size_t i = 0; i < numLocals; i++) { // TODO: vector?
          if (live[i]) interfere(i, action.index);
        }
        live[action.index] = 1;
      } else {
        if (live[action.index]) {
          action.effective = true;
          live[action.index] = 0;
        }
      }
    }
  }

  // Indices decision making

  std::vector<Index> pickIndices() { // returns a vector of oldIndex => newIndex
    // simple greedy coloring
    // TODO: multiple orderings
    // TODO: take into account eliminated copies
    // TODO: take into account distribution (99-1 is better than 50-50 with two registers, for gzip)
    std::vector<Index> indices; // old => new
    std::vector<WasmType> types;
    LocalSet newInterferences; // new index * numLocals => list of all interferences of locals merged to it
    indices.resize(numLocals);
    types.resize(numLocals);
    newInterferences.resize(numLocals * numLocals);
    Index nextFree = 0;
    // we can't reorder parameters, they are fixed in order, and cannot coalesce
    auto numParams = getFunction()->getNumParams();
    Index i = 0;
    for (; i < numParams; i++) {
      indices[i] = i;
      types[i] = getFunction()->getLocalType(i);
      std::copy(interferences.begin() + numLocals * i, interferences.begin() + numLocals * (i + 1), newInterferences.begin() + numLocals * i);
      nextFree++;
    }
    for (; i < numLocals; i++) {
      Index found = -1;
      for (Index j = 0; j < nextFree; j++) {
        if (!newInterferences[j * numLocals + i] && getFunction()->getLocalType(i) == types[j]) {
          indices[i] = found = j;
          break;
        }
      }
      if (found == Index(-1)) {
        indices[i] = found = nextFree;
        types[found] = getFunction()->getLocalType(i);
        nextFree++;
      }
      // merge new interferences for the new index
      for (size_t j = 0; j < numLocals; j++) {
        newInterferences[found * numLocals + j] = newInterferences[found * numLocals + j] | interferences[i * numLocals + j];
      }
    }
    return indices;
  }

  void applyIndices(std::vector<Index>& indices, Expression* root) {
    assert(indices.size() == numLocals);
    for (auto& curr : basicBlocks) {
      auto& actions = curr->contents.actions;
      for (auto& action : actions) {
        if (action.isGet()) {
          auto* get = (*action.origin)->cast<GetLocal>();
          get->index = indices[get->index];
        } else {
          auto* set = (*action.origin)->cast<SetLocal>();
          set->index = indices[set->index];
          // in addition, we can optimize out redundant copies and ineffective sets
          GetLocal* get;
          if ((get = set->value->dynCast<GetLocal>()) && get->index == set->index) {
            *action.origin = get; // further optimizations may get rid of the get, if this is in a place where the output does not matter
          } else if (!action.effective) {
            *action.origin = set->value; // value may have no side effects, further optimizations can eliminate it
          }
        }
      }
    }
    // update type list
    auto numParams = getFunction()->getNumParams();
    Index newNumLocals = 0;
    for (auto index : indices) {
      newNumLocals = std::max(newNumLocals, index + 1);
    }
    auto oldVars = getFunction()->vars;
    getFunction()->vars.resize(newNumLocals - numParams);
    for (size_t index = numParams; index < numLocals; index++) {
      Index newIndex = indices[index];
      if (newIndex >= numParams) {
        getFunction()->vars[newIndex - numParams] = oldVars[index - numParams];
      }
    }
    // names are gone
    getFunction()->localNames.clear();
    getFunction()->localIndices.clear();
  }
};

static RegisterPass<CoalesceLocals> registerPass("coalesce-locals", "reduce # of locals by coalescing");

} // namespace wasm
