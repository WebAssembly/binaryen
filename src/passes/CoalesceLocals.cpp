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


#include <algorithm>
#include <memory>
#include <unordered_set>

#include "wasm.h"
#include "pass.h"
#include "ast_utils.h"
#include "cfg/cfg-traversal.h"
#include "wasm-builder.h"
#include "support/learning.h"
#include "support/permutations.h"
#ifdef CFG_PROFILE
#include "support/timing.h"
#endif

namespace wasm {

// A set of locals. This is optimized for comparisons,
// mergings, and iteration on elements, assuming that there
// may be a great many potential elements but actual sets
// may be fairly small. Specifically, we use a sorted
// vector.
struct LocalSet : std::vector<Index> {
  LocalSet() {}

  LocalSet merge(const LocalSet& other) const {
    LocalSet ret;
    ret.resize(size() + other.size());
    Index i = 0, j = 0, t = 0;
    while (i < size() && j < other.size()) {
      auto left = (*this)[i];
      auto right = other[j];
      if (left < right) {
        ret[t++] = left;
        i++;
      } else if (left > right) {
        ret[t++] = right;
        j++;
      } else {
        ret[t++] = left;
        i++;
        j++;
      }
    }
    while (i < size()) {
      ret[t++] = (*this)[i];
      i++;
    }
    while (j < other.size()) {
      ret[t++] = other[j];
      j++;
    }
    ret.resize(t);
    return ret;
  }

  void insert(Index x) {
    auto it = std::lower_bound(begin(), end(), x);
    if (it == end()) push_back(x);
    else if (*it > x) {
      Index i = it - begin();
      resize(size() + 1);
      std::move_backward(begin() + i, begin() + size() - 1, end());
      (*this)[i] = x;
    }
  }

  bool erase(Index x) {
    auto it = std::lower_bound(begin(), end(), x);
    if (it != end() && *it == x) {
      std::move(it + 1, end(), it);
      resize(size() - 1);
      return true;
    }
    return false;
  }

  bool has(Index x) {
    auto it = std::lower_bound(begin(), end(), x);
    return it != end() && *it == x;
  }

  void verify() const {
    for (Index i = 1; i < size(); i++) {
      assert((*this)[i - 1] < (*this)[i]);
    }
  }

  void dump(const char* str = nullptr) const {
    std::cout << "LocalSet " << (str ? str : "") << ": ";
    for (auto x : *this) std::cout << x << " ";
    std::cout << '\n';
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
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new CoalesceLocals; }

  Index numLocals;

  // cfg traversal work

  static void doVisitGetLocal(CoalesceLocals* self, Expression** currp) {
    auto* curr = (*currp)->cast<GetLocal>();
     // if in unreachable code, ignore
    if (!self->currBasicBlock) {
      *currp = Builder(*self->getModule()).replaceWithIdenticalType(curr);
      return;
    }
    self->currBasicBlock->contents.actions.emplace_back(Action::Get, curr->index, currp);
  }

  static void doVisitSetLocal(CoalesceLocals* self, Expression** currp) {
    auto* curr = (*currp)->cast<SetLocal>();
    // if in unreachable code, ignore
    if (!self->currBasicBlock) {
      *currp = Builder(*self->getModule()).replaceWithIdenticalType(curr);
      return;
    }
    self->currBasicBlock->contents.actions.emplace_back(Action::Set, curr->index, currp);
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
      if (auto* get = iff->ifFalse->dynCast<GetLocal>()) return get;
    }
    return nullptr;
  }

  // main entry point

  void doWalkFunction(Function* func);

  void increaseBackEdgePriorities();

  void flowLiveness();

  void calculateInterferences();

  void calculateInterferences(const LocalSet& locals);

  // merge starts of a list of blocks, adding new interferences as necessary. return
  // whether anything changed vs an old state (which indicates further processing is necessary).
  bool mergeStartsAndCheckChange(std::vector<BasicBlock*>& blocks, LocalSet& old, LocalSet& ret);

  void scanLivenessThroughActions(std::vector<Action>& actions, LocalSet& live);

  void pickIndicesFromOrder(std::vector<Index>& order, std::vector<Index>& indices);
  void pickIndicesFromOrder(std::vector<Index>& order, std::vector<Index>& indices, Index& removedCopies);

  virtual void pickIndices(std::vector<Index>& indices); // returns a vector of oldIndex => newIndex

  void applyIndices(std::vector<Index>& indices, Expression* root);

  // interference state

  std::vector<bool> interferences; // canonicalized - accesses should check (low, high)
  std::unordered_set<BasicBlock*> liveBlocks;

  void interfere(Index i, Index j) {
    if (i == j) return;
    interferences[std::min(i, j) * numLocals + std::max(i, j)] = 1;
  }

  void interfereLowHigh(Index low, Index high) { // optimized version where you know that low < high
    assert(low < high);
    interferences[low * numLocals + high] = 1;
  }

  bool interferes(Index i, Index j) {
    return interferences[std::min(i, j) * numLocals + std::max(i, j)];
  }

  // copying state

  std::vector<uint8_t> copies; // canonicalized - accesses should check (low, high) TODO: use a map for high N, as this tends to be sparse? or don't look at copies at all for big N?
  std::vector<Index> totalCopies; // total # of copies for each local, with all others

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

void CoalesceLocals::doWalkFunction(Function* func) {
  numLocals = func->getNumLocals();
  copies.resize(numLocals * numLocals);
  std::fill(copies.begin(), copies.end(), 0);
  totalCopies.resize(numLocals);
  std::fill(totalCopies.begin(), totalCopies.end(), 0);
  // collect initial liveness info
  WalkerPass<CFGWalker<CoalesceLocals, Visitor<CoalesceLocals>, Liveness>>::doWalkFunction(func);
  // ignore links to dead blocks, so they don't confuse us and we can see their stores are all ineffective
  liveBlocks = findLiveBlocks();
  unlinkDeadBlocks(liveBlocks);
  // increase the cost of costly backedges
  increaseBackEdgePriorities();
#ifdef CFG_DEBUG
  dumpCFG("the cfg");
#endif
  // flow liveness across blocks
#ifdef CFG_PROFILE
  static Timer timer("flow");
  timer.start();
#endif
  flowLiveness();
#ifdef CFG_PROFILE
  timer.stop();
  timer.dump();
#endif
  // use liveness to find interference
  calculateInterferences();
  // pick new indices
  std::vector<Index> indices;
  pickIndices(indices);
  // apply indices
  applyIndices(indices, func->body);
}

// A copy on a backedge can be especially costly, forcing us to branch just to do that copy.
// Add weight to such copies, so we prioritize getting rid of them.
void CoalesceLocals::increaseBackEdgePriorities() {
  for (auto* loopTop : loopTops) {
    // ignore the first edge, it is the initial entry, we just want backedges
    auto& in = loopTop->in;
    for (Index i = 1; i < in.size(); i++) {
      auto* arrivingBlock = in[i];
      if (arrivingBlock->out.size() > 1) continue; // we just want unconditional branches to the loop top, true phi fragments
      for (auto& action : arrivingBlock->contents.actions) {
        if (action.what == Action::Set) {
          auto* set = (*action.origin)->cast<SetLocal>();
          if (auto* get = getCopy(set)) {
            // this is indeed a copy, add to the cost (default cost is 2, so this adds 50%, and can mostly break ties)
            addCopy(set->index, get->index);
          }
        }
      }
    }
  }
}

void CoalesceLocals::flowLiveness() {
  interferences.resize(numLocals * numLocals);
  std::fill(interferences.begin(), interferences.end(), 0);
  // keep working while stuff is flowing
  std::unordered_set<BasicBlock*> queue;
  for (auto& curr : basicBlocks) {
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
#ifdef CFG_DEBUG
    std::cout << "change noticed at end of " << debugIds[curr] << " from " << curr->contents.end.size() << " to " << live.size() << " (out of " << numLocals << ")\n";
#endif
    assert(curr->contents.end.size() < live.size());
    curr->contents.end = live;
    scanLivenessThroughActions(curr->contents.actions, live);
    // liveness is now calculated at the start. if something
    // changed, all predecessor blocks need recomputation
    if (curr->contents.start == live) continue;
#ifdef CFG_DEBUG
    std::cout << "change noticed at start of " << debugIds[curr] << " from " << curr->contents.start.size() << " to " << live.size() << ", more work to do\n";
#endif
    assert(curr->contents.start.size() < live.size());
    curr->contents.start = live;
    for (auto* in : curr->in) {
      queue.insert(in);
    }
  }
#ifdef CFG_DEBUG
  std::hash<std::vector<bool>> hasher;
  std::cout << getFunction()->name << ": interference hash: " << hasher(*(std::vector<bool>*)&interferences) << "\n";
  for (Index i = 0; i < numLocals; i++) {
    std::cout << "int for " << getFunction()->getLocalName(i) << " [" << i << "]: ";
    for (Index j = 0; j < numLocals; j++) {
      if (interferes(i, j)) std::cout << getFunction()->getLocalName(j) << " ";
    }
    std::cout << "\n";
  }
#endif
}

// merge starts of a list of blocks. return
// whether anything changed vs an old state (which indicates further processing is necessary).
bool CoalesceLocals::mergeStartsAndCheckChange(std::vector<BasicBlock*>& blocks, LocalSet& old, LocalSet& ret) {
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

void CoalesceLocals::scanLivenessThroughActions(std::vector<Action>& actions, LocalSet& live) {
  // move towards the front
  for (int i = int(actions.size()) - 1; i >= 0; i--) {
    auto& action = actions[i];
    if (action.isGet()) {
      live.insert(action.index);
    } else {
      live.erase(action.index);
    }
  }
}

void CoalesceLocals::calculateInterferences() {
  for (auto& curr : basicBlocks) {
    if (liveBlocks.count(curr.get()) == 0) continue; // ignore dead blocks
    // everything coming in might interfere, as it might come from a different block
    auto live = curr->contents.end;
    calculateInterferences(live);
    // scan through the block itself
    auto& actions = curr->contents.actions;
    for (int i = int(actions.size()) - 1; i >= 0; i--) {
      auto& action = actions[i];
      auto index = action.index;
      if (action.isGet()) {
        // new live local, interferes with all the rest
        live.insert(index);
        for (auto i : live) {
          interfere(i, index);
        }
      } else {
        if (live.erase(index)) {
          action.effective = true;
        }
      }
    }
  }
  // Params have a value on entry, so mark them as live, as variables
  // live at the entry expect their zero-init value.
  LocalSet start = entry->contents.start;
  auto numParams = getFunction()->getNumParams();
  for (Index i = 0; i < numParams; i++) {
    start.insert(i);
  }
  calculateInterferences(start);
}

void CoalesceLocals::calculateInterferences(const LocalSet& locals) {
  Index size = locals.size();
  for (Index i = 0; i < size; i++) {
    for (Index j = i + 1; j < size; j++) {
      interfereLowHigh(locals[i], locals[j]);
    }
  }
}

// Indices decision making

void CoalesceLocals::pickIndicesFromOrder(std::vector<Index>& order, std::vector<Index>& indices) {
  Index removedCopies;
  pickIndicesFromOrder(order, indices, removedCopies);
}

void CoalesceLocals::pickIndicesFromOrder(std::vector<Index>& order, std::vector<Index>& indices, Index& removedCopies) {
  // mostly-simple greedy coloring
#if CFG_DEBUG
  std::cerr << "\npickIndicesFromOrder on " << getFunction()->name << '\n';
  std::cerr << getFunction()->body << '\n';
  std::cerr << "order:\n";
  for (auto i : order) std::cerr << i << ' ';
  std::cerr << '\n';
  std::cerr << "interferences:\n";
  for (Index i = 0; i < numLocals; i++) {
    for (Index j = 0; j < i + 1; j++) {
      std::cerr << "  ";
    }
    for (Index j = i + 1; j < numLocals; j++) {
      std::cerr << int(interferes(i, j)) << ' ';
    }
    std::cerr << " : $" << i << '\n';
  }
  std::cerr << "copies:\n";
  for (Index i = 0; i < numLocals; i++) {
    for (Index j = 0; j < i + 1; j++) {
      std::cerr << "  ";
    }
    for (Index j = i + 1; j < numLocals; j++) {
      std::cerr << int(getCopies(i, j)) << ' ';
    }
    std::cerr << " : $" << i << '\n';
  }
  std::cerr << "total copies:\n";
  for (Index i = 0; i < numLocals; i++) {
    std::cerr << " $" << i << ": " << totalCopies[i] << '\n';
  }
#endif
  // TODO: take into account distribution (99-1 is better than 50-50 with two registers, for gzip)
  std::vector<WasmType> types;
  std::vector<bool> newInterferences; // new index * numLocals => list of all interferences of locals merged to it
  std::vector<uint8_t> newCopies; // new index * numLocals => list of all copies of locals merged to it
  indices.resize(numLocals);
  types.resize(numLocals);
  newInterferences.resize(numLocals * numLocals);
  std::fill(newInterferences.begin(), newInterferences.end(), 0);
  auto numParams = getFunction()->getNumParams();
  newCopies.resize(numParams * numLocals); // start with enough room for the params
  std::fill(newCopies.begin(), newCopies.end(), 0);
  Index nextFree = 0;
  removedCopies = 0;
  // we can't reorder parameters, they are fixed in order, and cannot coalesce
  Index i = 0;
  for (; i < numParams; i++) {
    assert(order[i] == i); // order must leave the params in place
    indices[i] = i;
    types[i] = getFunction()->getLocalType(i);
    for (Index j = numParams; j < numLocals; j++) {
      newInterferences[numLocals * i + j] = interferes(i, j);
      newCopies[numLocals * i + j] = getCopies(i, j);
    }
    nextFree++;
  }
  for (; i < numLocals; i++) {
    Index actual = order[i];
    Index found = -1;
    uint8_t foundCopies = -1;
    for (Index j = 0; j < nextFree; j++) {
      if (!newInterferences[j * numLocals + actual] && getFunction()->getLocalType(actual) == types[j]) {
        // this does not interfere, so it might be what we want. but pick the one eliminating the most copies
        // (we could stop looking forward when there are no more items that have copies anyhow, but it doesn't seem to help)
        auto currCopies = newCopies[j * numLocals + actual];
        if (found == Index(-1) || currCopies > foundCopies) {
          indices[actual] = found = j;
          foundCopies = currCopies;
        }
      }
    }
    if (found == Index(-1)) {
      indices[actual] = found = nextFree;
      types[found] = getFunction()->getLocalType(actual);
      nextFree++;
      removedCopies += getCopies(found, actual);
      newCopies.resize(nextFree * numLocals);
    } else {
      removedCopies += foundCopies;
    }
#if CFG_DEBUG
    std::cerr << "set local $" << actual << " to $" << found << '\n';
#endif
    // merge new interferences and copies for the new index
    for (Index k = i + 1; k < numLocals; k++) {
      auto j = order[k]; // go in the order, we only need to update for those we will see later
      newInterferences[found * numLocals + j] = newInterferences[found * numLocals + j] | interferes(actual, j);
      newCopies[found * numLocals + j] += getCopies(actual, j);
    }
  }
}

// given a baseline order, adjust it based on an important order of priorities (higher values
// are higher priority). The priorities take precedence, unless they are equal and then
// the original order should be kept.
std::vector<Index> adjustOrderByPriorities(std::vector<Index>& baseline, std::vector<Index>& priorities) {
  std::vector<Index> ret = baseline;
  std::vector<Index> reversed = makeReversed(baseline);
  std::sort(ret.begin(), ret.end(), [&priorities, &reversed](Index x, Index y) {
    return priorities[x] > priorities[y] || (priorities[x] == priorities[y] && reversed[x] < reversed[y]);
  });
  return ret;
};

void CoalesceLocals::pickIndices(std::vector<Index>& indices) {
  if (numLocals == 0) return;
  if (numLocals == 1) {
    indices.push_back(0);
    return;
  }
  if (getFunction()->getNumVars() <= 1) {
    // nothing to think about here, since we can't reorder params
    indices = makeIdentity(numLocals);
    return;
  }
  // take into account total copies. but we must keep params in place, so give them max priority
  auto adjustedTotalCopies = totalCopies;
  auto numParams = getFunction()->getNumParams();
  for (Index i = 0; i < numParams; i++) {
    adjustedTotalCopies[i] = std::numeric_limits<Index>::max();
  }
  // first try the natural order. this is less arbitrary than it seems, as the program
  // may have a natural order of locals inherent in it.
  auto order = makeIdentity(numLocals);
  order = adjustOrderByPriorities(order, adjustedTotalCopies);
  Index removedCopies;
  pickIndicesFromOrder(order, indices, removedCopies);
  auto maxIndex = *std::max_element(indices.begin(), indices.end());
  // next try the reverse order. this both gives us another chance at something good,
  // and also the very naturalness of the simple order may be quite suboptimal
  setIdentity(order);
  for (Index i = numParams; i < numLocals; i++) {
    order[i] = numParams + numLocals - 1 - i;
  }
  order = adjustOrderByPriorities(order, adjustedTotalCopies);
  std::vector<Index> reverseIndices;
  Index reverseRemovedCopies;
  pickIndicesFromOrder(order, reverseIndices, reverseRemovedCopies);
  auto reverseMaxIndex = *std::max_element(reverseIndices.begin(), reverseIndices.end());
  // prefer to remove copies foremost, as it matters more for code size (minus gzip), and
  // improves throughput.
  if (reverseRemovedCopies > removedCopies || (reverseRemovedCopies == removedCopies && reverseMaxIndex < maxIndex)) {
    indices.swap(reverseIndices);
  }
}

// Remove a copy from a set of an if, where one if arm is a get of the same set
static void removeIfCopy(Expression** origin, SetLocal* set, If* iff, Expression*& copy, Expression*& other, Module* module) {
  // replace the origin with the if, and sink the set into the other non-copying arm
  *origin = iff;
  set->value = other;
  set->finalize();
  other = set;
  if (!isConcreteWasmType(set->type)) {
    // we don't need the copy at all
    copy = nullptr;
    if (!iff->ifTrue) {
      Builder(*module).flip(iff);
    }
    iff->finalize();
  }
}

void CoalesceLocals::applyIndices(std::vector<Index>& indices, Expression* root) {
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
          if (set->isTee()) {
            *action.origin = get;
          } else {
            ExpressionManipulator::nop(set);
          }
          continue;
        }
        // remove ineffective actions
        if (!action.effective) {
          *action.origin = set->value; // value may have no side effects, further optimizations can eliminate it
          if (!set->isTee()) {
            // we need to drop it
            Drop* drop = ExpressionManipulator::convert<SetLocal, Drop>(set);
            drop->value = *action.origin;
            *action.origin = drop;
          }
          continue;
        }
        if (auto* iff = set->value->dynCast<If>()) {
          if (auto* get = iff->ifTrue->dynCast<GetLocal>()) {
            if (get->index == set->index) {
              removeIfCopy(action.origin, set, iff, iff->ifTrue, iff->ifFalse, getModule());
              continue;
            }
          }
          if (auto* get = iff->ifFalse->dynCast<GetLocal>()) {
            if (get->index == set->index) {
              removeIfCopy(action.origin, set, iff, iff->ifFalse, iff->ifTrue, getModule());
              continue;
            }
          }
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
  for (Index index = numParams; index < numLocals; index++) {
    Index newIndex = indices[index];
    if (newIndex >= numParams) {
      getFunction()->vars[newIndex - numParams] = oldVars[index - numParams];
    }
  }
  // names are gone
  getFunction()->localNames.clear();
  getFunction()->localIndices.clear();
}

struct CoalesceLocalsWithLearning : public CoalesceLocals {
  virtual Pass* create() override { return new CoalesceLocalsWithLearning; }

  virtual void pickIndices(std::vector<Index>& indices) override;
};

void CoalesceLocalsWithLearning::pickIndices(std::vector<Index>& indices) {
  if (getFunction()->getNumVars() <= 1) {
    // nothing to think about here
    CoalesceLocals::pickIndices(indices);
    return;
  }

  struct Order : public std::vector<Index> {
    void setFitness(double f) { fitness = f; }
    double getFitness() { return fitness; }
    void dump(std::string text) {
      std::cout << text + ": ( ";
      for (Index i = 0; i < size(); i++) std::cout << (*this)[i] << " ";
      std::cout << ")\n";
      std::cout << "of quality: " << getFitness() << "\n";
    }
  private:
    double fitness;
  };

  struct Generator {
    Generator(CoalesceLocalsWithLearning* parent) : parent(parent), noise(42) {}

    void calculateFitness(Order* order) {
      // apply the order
      std::vector<Index> indices; // the phenotype
      Index removedCopies;
      parent->pickIndicesFromOrder(*order, indices, removedCopies);
      auto maxIndex = *std::max_element(indices.begin(), indices.end());
      assert(maxIndex <= parent->numLocals);
      // main part of fitness is the number of locals
      double fitness = parent->numLocals - maxIndex; // higher fitness is better
      // secondarily, it is nice to not reorder locals unnecessarily
      double fragment = 1.0 / (2.0 * parent->numLocals);
      for (Index i = 0; i < parent->numLocals; i++) {
        if ((*order)[i] == i) fitness += fragment; // boost for each that wasn't moved
      }
      fitness = (100 * fitness) + removedCopies; // removing copies is a secondary concern
      order->setFitness(fitness);
    }

    Order* makeRandom() {
      auto* ret = new Order;
      ret->resize(parent->numLocals);
      for (Index i = 0; i < parent->numLocals; i++) {
        (*ret)[i] = i;
      }
      if (first) {
        // as the first guess, use the natural order. this is not arbitrary for two reasons.
        // first, there may be an inherent order in the input (frequent indices are lower,
        // etc.). second, by ensuring we start with the natural order, we ensure we are at
        // least as good as the non-learning variant.
        // TODO: use ::pickIndices from the parent, so we literally get the simpler approach
        //       as our first option
        first = false;
      } else {
        // leave params alone, shuffle the rest
        std::shuffle(ret->begin() + parent->getFunction()->getNumParams(), ret->end(), noise);
      }
      calculateFitness(ret);
#ifdef CFG_LEARN_DEBUG
      order->dump("new rando");
#endif
      return ret;
    }

    Order* makeMixture(Order* left, Order* right) {
      // perturb left using right. this is useful since
      // we don't care about absolute locations, relative ones matter more,
      // and a true merge of two vectors could obscure that (e.g.
      // a.......... and ..........a would merge a into the middle, for no
      // reason), and cause a lot of unnecessary noise
      Index size = left->size();
      Order reverseRight; // reverseRight[x] is the index of x in right
      reverseRight.resize(size);
      for (Index i = 0; i < size; i++) {
        reverseRight[(*right)[i]] = i;
      }
      auto* ret = new Order;
      *ret = *left;
      assert(size >= 1);
      for (Index i = parent->getFunction()->getNumParams(); i < size - 1; i++) {
        // if (i, i + 1) is in reverse order in right, flip them
        if (reverseRight[(*ret)[i]] > reverseRight[(*ret)[i + 1]]) {
          std::swap((*ret)[i], (*ret)[i + 1]);
          i++; // if we don't skip, we might end up pushing an element all the way to the end, which is not very perturbation-y
        }
      }
      calculateFitness(ret);
#ifdef CFG_LEARN_DEBUG
      ret->dump("new mixture");
#endif
      return ret;
    }

  private:
    CoalesceLocalsWithLearning* parent;
    std::mt19937 noise;
    bool first = true;
  };

#ifdef CFG_LEARN_DEBUG
  std::cout << "[learning for " << getFunction()->name << "]\n";
#endif
  auto numVars = this->getFunction()->getNumVars();
  const int GENERATION_SIZE = std::min(Index(numVars * (numVars - 1)), Index(20));
  Generator generator(this);
  GeneticLearner<Order, double, Generator> learner(generator, GENERATION_SIZE);
#ifdef CFG_LEARN_DEBUG
  learner.getBest()->dump("first best");
#endif
  // keep working while we see improvement
  auto oldBest = learner.getBest()->getFitness();
  while (1) {
    learner.runGeneration();
    auto newBest = learner.getBest()->getFitness();
    if (newBest == oldBest) break; // unlikely we can improve
    oldBest = newBest;
#ifdef CFG_LEARN_DEBUG
    learner.getBest()->dump("current best");
#endif
  }
#ifdef CFG_LEARN_DEBUG
  learner.getBest()->dump("the best");
#endif
  this->pickIndicesFromOrder(*learner.getBest(), indices); // TODO: cache indices in Orders, at the cost of more memory?
}

// declare passes

Pass *createCoalesceLocalsPass() {
  return new CoalesceLocals();
}

Pass *createCoalesceLocalsWithLearningPass() {
  return new CoalesceLocalsWithLearning();
}

} // namespace wasm
