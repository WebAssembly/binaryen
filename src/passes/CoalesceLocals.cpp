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
#include "support/learning.h"
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

  // TODO: binary search in all the following

  void insert(Index x) {
    for (size_t i = 0; i < size(); i++) {
      auto seen = (*this)[i];
      if (seen == x) return;
      if (seen > x) {
        resize(size() + 1);
        for (size_t j = size() - 1; j > i; j--) {
          (*this)[j] = (*this)[j - 1];
        }
        (*this)[i] = x;
        return;
      }
    }
    // we didn't find anything larger
    push_back(x);
  }

  bool erase(Index x) {
    for (size_t i = 0; i < size(); i++) {
      if ((*this)[i] == x) {
        for (size_t j = i + 1; j < size(); j++) {
          (*this)[j - 1] = (*this)[j];
        }
        resize(size() - 1);
        return true;
      }
    }
    return false;
  }

  bool has(Index x) {
    for (size_t i = 0; i < size(); i++) {
      if ((*this)[i] == x) return true;
    }
    return false;
  }

  void verify() const {
    for (size_t i = 1; i < size(); i++) {
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
  bool isFunctionParallel() { return true; }

  Index numLocals;

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

  void walk(Expression*& root);

  void flowLiveness();

  void calculateInterferences();

  void calculateInterferences(LocalSet& locals);

  // merge starts of a list of blocks, adding new interferences as necessary. return
  // whether anything changed vs an old state (which indicates further processing is necessary).
  bool mergeStartsAndCheckChange(std::vector<BasicBlock*>& blocks, LocalSet& old, LocalSet& ret);

  void scanLivenessThroughActions(std::vector<Action>& actions, LocalSet& live);

  void pickIndicesFromOrder(std::vector<Index>& order, std::vector<Index>& indices);

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
};

void CoalesceLocals::walk(Expression*& root) {
  numLocals = getFunction()->getNumLocals();
  // collect initial liveness info
  WalkerPass<CFGWalker<CoalesceLocals, Visitor<CoalesceLocals>, Liveness>>::walk(root);
  // ignore links to dead blocks, so they don't confuse us and we can see their stores are all ineffective
  liveBlocks = findLiveBlocks();
  unlinkDeadBlocks(liveBlocks);
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
  applyIndices(indices, root);
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
  // at every point in time, we assume we already noted interferences between things already known alive at the end, and scanned back throught the block using that
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
  // live locals at the entry block include params, obviously, but also
  // vars, in which case the 0-init value is actually used.
#ifdef CFG_DEBUG
  std::hash<std::vector<bool>> hasher;
  std::cout << getFunction()->name << ": interference hash: " << hasher(*(std::vector<bool>*)&interferences) << "\n";
  for (size_t i = 0; i < numLocals; i++) {
    std::cout << "int for " << getFunction()->getLocalName(i) << " [" << i << "]: ";
    for (size_t j = 0; j < numLocals; j++) {
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
    for (size_t i = 1; i < blocks.size(); i++) {
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
}

void CoalesceLocals::calculateInterferences(LocalSet& locals) {
  size_t size = locals.size();
  for (size_t i = 0; i < size; i++) {
    for (size_t j = i + 1; j < size; j++) {
      interfereLowHigh(locals[i], locals[j]);
    }
  }
}

// Indices decision making

void CoalesceLocals::pickIndicesFromOrder(std::vector<Index>& order, std::vector<Index>& indices) {
  // simple greedy coloring
  // TODO: take into account eliminated copies
  // TODO: take into account distribution (99-1 is better than 50-50 with two registers, for gzip)
  std::vector<WasmType> types;
  std::vector<bool> newInterferences; // new index * numLocals => list of all interferences of locals merged to it
  indices.resize(numLocals);
  types.resize(numLocals);
  newInterferences.resize(numLocals * numLocals);
  std::fill(newInterferences.begin(), newInterferences.end(), 0);
  Index nextFree = 0;
  // we can't reorder parameters, they are fixed in order, and cannot coalesce
  auto numParams = getFunction()->getNumParams();
  Index i = 0;
  for (; i < numParams; i++) {
    assert(order[i] == i); // order must leave the params in place
    indices[i] = i;
    types[i] = getFunction()->getLocalType(i);
    for (size_t j = 0; j < numLocals; j++) {
      newInterferences[numLocals * i + j] = interferes(i, j);
    }
    nextFree++;
  }
  for (; i < numLocals; i++) {
    Index actual = order[i];
    Index found = -1;
    for (Index j = 0; j < nextFree; j++) {
      if (!newInterferences[j * numLocals + actual] && getFunction()->getLocalType(actual) == types[j]) {
        indices[actual] = found = j;
        break;
      }
    }
    if (found == Index(-1)) {
      indices[actual] = found = nextFree;
      types[found] = getFunction()->getLocalType(actual);
      nextFree++;
    }
    // merge new interferences for the new index
    for (size_t j = 0; j < numLocals; j++) {
      newInterferences[found * numLocals + j] = newInterferences[found * numLocals + j] | interferes(actual, j);
    }
  }
}

void CoalesceLocals::pickIndices(std::vector<Index>& indices) {
  // use the natural order. this is less arbitrary than it seems, as the program
  // may have a natural order of locals inherent in it.
  std::vector<Index> order;
  order.resize(numLocals);
  for (size_t i = 0; i < numLocals; i++) {
    order[i] = i;
  }
  pickIndicesFromOrder(order, indices);
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

struct CoalesceLocalsWithLearning : public CoalesceLocals {
  virtual CoalesceLocals* create() override { return new CoalesceLocalsWithLearning; }

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
      parent->pickIndicesFromOrder(*order, indices);
      auto maxIndex = *std::max_element(indices.begin(), indices.end());
      assert(maxIndex <= parent->numLocals);
      // main part of fitness is the number of locals
      double fitness = parent->numLocals - maxIndex; // higher fitness is better
      // secondarily, it is nice to not reorder locals unnecessarily
      double fragment = 1.0 / (2.0 * parent->numLocals);
      for (Index i = 0; i < parent->numLocals; i++) {
        if ((*order)[i] == i) fitness += fragment; // boost for each that wasn't moved
      }
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
  auto numVars = getFunction()->getNumVars();
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
  pickIndicesFromOrder(*learner.getBest(), indices); // TODO: cache indices in Orders, at the cost of more memory?
}

// declare passes

static RegisterPass<CoalesceLocals> registerPass1("coalesce-locals", "reduce # of locals by coalescing");

static RegisterPass<CoalesceLocalsWithLearning> registerPass2("coalesce-locals-learning", "reduce # of locals by coalescing and learning");

} // namespace wasm
