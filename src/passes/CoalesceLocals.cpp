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
// NB: This pass is nonlinear in the number of locals. It is best to run it
//     after the number of locals has been somewhat reduced by other passes,
//     for example by simplify-locals (to remove unneeded uses of locals) and
//     reorder-locals (to sort them by # of uses and remove all unneeded ones).
//

#include <algorithm>
#include <memory>
#include <unordered_set>

#include "cfg/liveness-traversal.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/learning.h"
#include "support/permutations.h"
#include "wasm.h"
#ifdef CFG_PROFILE
#include "support/timing.h"
#endif

namespace wasm {

struct CoalesceLocals
  : public WalkerPass<LivenessWalker<CoalesceLocals, Visitor<CoalesceLocals>>> {
  bool isFunctionParallel() override { return true; }

  // This pass merges locals, mapping the originals to new ones.
  // FIXME DWARF updating does not handle local changes yet.
  bool invalidatesDWARF() override { return true; }

  Pass* create() override { return new CoalesceLocals; }

  // main entry point

  void doWalkFunction(Function* func);

  void increaseBackEdgePriorities();

  void calculateInterferences();

  void calculateInterferences(const SetOfLocals& locals);

  void calculateInterferencesWhileIgnoringCopies();

  void pickIndicesFromOrder(std::vector<Index>& order,
                            std::vector<Index>& indices);
  void pickIndicesFromOrder(std::vector<Index>& order,
                            std::vector<Index>& indices,
                            Index& removedCopies);

  // returns a vector of oldIndex => newIndex
  virtual void pickIndices(std::vector<Index>& indices);

  void applyIndices(std::vector<Index>& indices, Expression* root);

  // interference state

  // canonicalized - accesses should check (low, high)
  std::vector<bool> interferences;

  void interfere(Index i, Index j) {
    if (i == j) {
      return;
    }
    interferences[std::min(i, j) * numLocals + std::max(i, j)] = 1;
  }

  // optimized version where you know that low < high
  void interfereLowHigh(Index low, Index high) {
    assert(low < high);
    interferences[low * numLocals + high] = 1;
  }

  void unInterfere(Index i, Index j) {
    interferences[std::min(i, j) * numLocals + std::max(i, j)] = 0;
  }

  bool interferes(Index i, Index j) {
    return interferences[std::min(i, j) * numLocals + std::max(i, j)];
  }
};

void CoalesceLocals::doWalkFunction(Function* func) {
  if (!canRun(func)) {
    return;
  }
  super::doWalkFunction(func);
  // prioritize back edges
  increaseBackEdgePriorities();
  // use liveness to find interference
  calculateInterferencesWhileIgnoringCopies();
  // pick new indices
  std::vector<Index> indices;
  pickIndices(indices);
  // apply indices
  applyIndices(indices, func->body);
}

// A copy on a backedge can be especially costly, forcing us to branch just to
// do that copy. Add weight to such copies, so we prioritize getting rid of
// them.
void CoalesceLocals::increaseBackEdgePriorities() {
  for (auto* loopTop : loopTops) {
    // ignore the first edge, it is the initial entry, we just want backedges
    auto& in = loopTop->in;
    for (Index i = 1; i < in.size(); i++) {
      auto* arrivingBlock = in[i];
      if (arrivingBlock->out.size() > 1) {
        // we just want unconditional branches to the loop top, true phi
        // fragments
        continue;
      }
      for (auto& action : arrivingBlock->contents.actions) {
        if (action.isSet()) {
          auto* set = (*action.origin)->cast<LocalSet>();
          if (auto* get = getCopy(set)) {
            // this is indeed a copy, add to the cost (default cost is 2, so
            // this adds 50%, and can mostly break ties)
            addCopy(set->index, get->index);
          }
        }
      }
    }
  }
}

void CoalesceLocals::calculateInterferences() {
  interferences.resize(numLocals * numLocals);
  std::fill(interferences.begin(), interferences.end(), false);
  for (auto& curr : basicBlocks) {
    if (liveBlocks.count(curr.get()) == 0) {
      continue; // ignore dead blocks
    }
    // everything coming in might interfere, as it might come from a different
    // block
    auto live = curr->contents.end;
    calculateInterferences(live);
    // scan through the block itself
    auto& actions = curr->contents.actions;
    for (int i = int(actions.size()) - 1; i >= 0; i--) {
      auto& action = actions[i];
      auto index = action.index;
      if (action.isGet()) {
        // new live local, interferes with all the rest
        // TODO: this could be faster if it only does the loop if it actually
        //       inserts?
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
  SetOfLocals start = entry->contents.start;
  auto numParams = getFunction()->getNumParams();
  for (Index i = 0; i < numParams; i++) {
    start.insert(i);
  }
  calculateInterferences(start);
}

void CoalesceLocals::calculateInterferences(const SetOfLocals& locals) {
  Index size = locals.size();
  for (Index i = 0; i < size; i++) {
    for (Index j = i + 1; j < size; j++) {
      interfereLowHigh(locals[i], locals[j]);
    }
  }
}

void CoalesceLocals::calculateInterferencesWhileIgnoringCopies() {
  interferences.resize(numLocals * numLocals);
  std::fill(interferences.begin(), interferences.end(), false);
  for (auto& curr : basicBlocks) {
    if (liveBlocks.count(curr.get()) == 0) {
      continue; // ignore dead blocks
    }

    // First, find which gets end a live range. While doing so, also calculate
    // the effectiveness of sets.
    auto& actions = curr->contents.actions;
    std::vector<bool> endsLiveRange(actions.size(), false);
    auto live = curr->contents.end;
    for (int i = int(actions.size()) - 1; i >= 0; i--) {
      auto& action = actions[i];
      auto index = action.index;
      if (action.isGet()) {
        if (!live.has(index)) {
          // The local is not live after us, so its liveness ends here.
          endsLiveRange[i] = true;
          live.insert(index);
        }
      } else {
        if (live.erase(index)) {
          // This set is effective: there are gets that read from it.
          action.effective = true;
        }
      }
    }

    // Aside from live necessarily being the same as the set of live locals at
    // the start, we will also use live in the next loop, and assume it begins
    // at that state.
    assert(live == curr->contents.start);

    // Now that we know live ranges, check if locals interfere in this block.
    // Locals interfere if they might have different values where their live
    // ranges overlap; what we do here over what calculateInterferences() does
    // is that we do an SSA-like analysis inside the block to see where their
    // values are identical. That is, if one local is known to be a copy of
    // another, then we can ignore interferences there.
    //
    // ??! To track copies, we maintain a range of the current copying operation.
    // That is, if index i has a get, and index i+1 has a tee of that get, and
    // index i+2 is a set of that tee, then indexes [i, i+2] form a
    // "copy range" and all the locals involved there do not conflict.

    // Track the values in each local, using a numbering where each index
    // represents a unique different value.
    // TODO: optimize: map? hoist out of loop?
    std::vector<Index> values(numLocals);

    // Locals with the same type have the same default value, so we can give all
    // default values the same ID (since we do not coalesce across types anyhow,
    // comparisons across types are not relevant).
    auto zeroInit = 0;
    Index nextValue = 1;

    if (curr.get() == entry) {
      // Each parameter is assumed to have a different value on entry.
      for (Index i = 0; i < getFunction()->getNumParams(); i++) {
        values[i] = nextValue++;
      }

      for (Index i = getFunction()->getNumParams(); i < getFunction()->getNumLocals(); i++) {
        values[i] = zeroInit;
      }
    } else {
      // In any block but the entry, assume that each live local might have a
      // different value at the start.
      // TODO: Propagating SSA values across blocks could identify more copies.
      for (auto index : curr->contents.start) {
        values[index] = nextValue++;
      }
    }

    for (Index i = 0; i < actions.size(); i++) {
      auto& action = actions[i];
      auto index = action.index;
      if (action.isGet()) {
        if (endsLiveRange[i]) {
          bool erased = live.erase(action.index);
          assert(erased);
          WASM_UNUSED(erased);
        }
      } else if (action.effective) {
        // This is an effective set. Find the value being assigned to the local.
        auto* set = (*action.origin)->cast<LocalSet>();
        Index newValue;
        if (set->value->is<LocalGet>() || set->value->is<LocalSet>()) {
          // This is a copy: Either it is a get or a tee, that occurs right
          // before us.
          assert(i > 0 && set->value == *actions[i - 1].origin);
          newValue = values[actions[i - 1].index];
        } else {
          // This is not a copy; assign a new unique value.
          newValue = nextValue++;
        }
        values[index] = newValue;

        // Update interferences: This will interfere with any other local that
        // is currently live and contains a different value.
        for (auto other : live) {
          // This index was not live before this set (we will mark it as live
          // right after this loop).
          assert(other != index);
          if (values[other] != newValue) {
            interfere(other, index);
          }
        }

        // Finally, note that this index is now live, as a live range has begun
        // by this effective set.
        live.insert(action.index);
      }
    }

    // Note that we do not need to do anything for merges: while in general an
    // interference can happen either in a block or when control flow merges,
    // in wasm we have default values for all locals. As a result, if a local is
    // live at the beginning of a block, it will be live at the ends of *all*
    // the blocks reaching it: there is no possibility of an "unset local." That
    // is, imagine we have this merge with a conflict:
    //
    //  [a is set to some value] ->-
    //                              |
    //                              |->- [merge block where a and b are used]
    //                              |
    //  [b is set to some value] ->-
    //
    // It is true that a conflict happens in the merge block, and if we had
    // unset locals then the top block would have b unset, and the bottom block
    // would have a unset, and so there would be no conflict there and the
    // problem would only appear in the merge. But in wasm, that a and b are
    // used in the merge block means that they are live at the end of both the
    // top and bottom block, and that liveness will extend all the way back to
    // *some* set of those values, possibly only the zero-initialization at the
    // function start. Therefore a conflict will be noticed in both the top and
    // bottom blocks, and that merge block does not need to reason about merging
    // its inputs. In other words, a conflict will appear in the middle of a
    // block, somewhere, and therefore we leave it to that block to identify,
    // and so blocks only need to reason about their contents, not what arrives
    // to them.
    //
    // The one exception here is the entry to the function, see below.
  }

  // Finally, we must not try to coalesce parameters are they are fixed. Mark
  // them as "interfering" so that we do not need to special-case them later.
  auto numParams = getFunction()->getNumParams();
  for (Index i = 0; i < numParams; i++) {
    for (Index j = i + 1; j < numParams; j++) {
      interfereLowHigh(i, j);
    }
  }

  // Parameters also interfere with locals that use the zero-init value, as they
  // are live at the same place with different values (the start of the entry
  // block) and there is no previous block with a set that would represent the
  // place where the conflict happens: the conflict occurs due to the zero-init
  // value, which is set implicitly, without a local.set (which would have
  // alerted us to the conflict).
  for (auto i : entry->contents.start) {
    if (i >= numParams) {
      for (Index j = 0; j < numParams; j++) {
        interfereLowHigh(j, i);
      }
    }
  }
}

// Indices decision making

void CoalesceLocals::pickIndicesFromOrder(std::vector<Index>& order,
                                          std::vector<Index>& indices) {
  Index removedCopies;
  pickIndicesFromOrder(order, indices, removedCopies);
}

void CoalesceLocals::pickIndicesFromOrder(std::vector<Index>& order,
                                          std::vector<Index>& indices,
                                          Index& removedCopies) {
// mostly-simple greedy coloring
#if CFG_DEBUG
  std::cerr << "\npickIndicesFromOrder on " << getFunction()->name << '\n';
  std::cerr << getFunction()->body << '\n';
  std::cerr << "order:\n";
  for (auto i : order)
    std::cerr << i << ' ';
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
  // TODO: take into account distribution (99-1 is better than 50-50 with two
  // registers, for gzip)
  std::vector<Type> types;
  // new index * numLocals => list of all interferences of locals merged to it
  std::vector<bool> newInterferences;
  // new index * numLocals => list of all copies of locals merged to it
  std::vector<uint8_t> newCopies;
  indices.resize(numLocals);
  types.resize(numLocals);
  newInterferences.resize(numLocals * numLocals);
  std::fill(newInterferences.begin(), newInterferences.end(), false);
  auto numParams = getFunction()->getNumParams();
  // start with enough room for the params
  newCopies.resize(numParams * numLocals);
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
      if (!newInterferences[j * numLocals + actual] &&
          getFunction()->getLocalType(actual) == types[j]) {
        // this does not interfere, so it might be what we want. but pick the
        // one eliminating the most copies (we could stop looking forward when
        // there are no more items that have copies anyhow, but it doesn't seem
        // to help)
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
      // go in the order, we only need to update for those we will see later
      auto j = order[k];
      newInterferences[found * numLocals + j] =
        newInterferences[found * numLocals + j] || interferes(actual, j);
      newCopies[found * numLocals + j] += getCopies(actual, j);
    }
  }
}

// given a baseline order, adjust it based on an important order of priorities
// (higher values are higher priority). The priorities take precedence, unless
// they are equal and then the original order should be kept.
std::vector<Index> adjustOrderByPriorities(std::vector<Index>& baseline,
                                           std::vector<Index>& priorities) {
  std::vector<Index> ret = baseline;
  std::vector<Index> reversed = makeReversed(baseline);
  std::sort(ret.begin(), ret.end(), [&priorities, &reversed](Index x, Index y) {
    return priorities[x] > priorities[y] ||
           (priorities[x] == priorities[y] && reversed[x] < reversed[y]);
  });
  return ret;
}

void CoalesceLocals::pickIndices(std::vector<Index>& indices) {
  if (numLocals == 0) {
    return;
  }
  if (numLocals == 1) {
    indices.push_back(0);
    return;
  }
  // take into account total copies. but we must keep params in place, so give
  // them max priority
  auto adjustedTotalCopies = totalCopies;
  auto numParams = getFunction()->getNumParams();
  for (Index i = 0; i < numParams; i++) {
    adjustedTotalCopies[i] = std::numeric_limits<Index>::max();
  }
  // first try the natural order. this is less arbitrary than it seems, as the
  // program may have a natural order of locals inherent in it.
  auto order = makeIdentity(numLocals);
  order = adjustOrderByPriorities(order, adjustedTotalCopies);
  Index removedCopies;
  pickIndicesFromOrder(order, indices, removedCopies);
  auto maxIndex = *std::max_element(indices.begin(), indices.end());
  // next try the reverse order. this both gives us another chance at something
  // good, and also the very naturalness of the simple order may be quite
  // suboptimal
  setIdentity(order);
  for (Index i = numParams; i < numLocals; i++) {
    order[i] = numParams + numLocals - 1 - i;
  }
  order = adjustOrderByPriorities(order, adjustedTotalCopies);
  std::vector<Index> reverseIndices;
  Index reverseRemovedCopies;
  pickIndicesFromOrder(order, reverseIndices, reverseRemovedCopies);
  auto reverseMaxIndex =
    *std::max_element(reverseIndices.begin(), reverseIndices.end());
  // prefer to remove copies foremost, as it matters more for code size (minus
  // gzip), and improves throughput.
  if (reverseRemovedCopies > removedCopies ||
      (reverseRemovedCopies == removedCopies && reverseMaxIndex < maxIndex)) {
    indices.swap(reverseIndices);
  }
}

void CoalesceLocals::applyIndices(std::vector<Index>& indices,
                                  Expression* root) {
  assert(indices.size() == numLocals);
  for (auto& curr : basicBlocks) {
    auto& actions = curr->contents.actions;
    for (auto& action : actions) {
      if (action.isGet()) {
        auto* get = (*action.origin)->cast<LocalGet>();
        get->index = indices[get->index];
      } else if (action.isSet()) {
        auto* set = (*action.origin)->cast<LocalSet>();
        set->index = indices[set->index];
        // in addition, we can optimize out redundant copies and ineffective
        // sets
        if (auto* get = set->value->dynCast<LocalGet>()) {
          if (get->index == set->index) {
            action.removeCopy();
            continue;
          }
        }
        /* TODO
        if (auto* subSet = set->value->dynCast<LocalSet>()) {
          if (subSet->index == set->index) {
            set->value = subSet->value;
            continue;
          }
        }
        */
        // remove ineffective actions
        if (!action.effective) {
          // value may have no side effects, further optimizations can eliminate
          // it
          *action.origin = set->value;
          if (!set->isTee()) {
            // we need to drop it
            Drop* drop = ExpressionManipulator::convert<LocalSet, Drop>(set);
            drop->value = *action.origin;
            *action.origin = drop;
          }
          continue;
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
      for (Index i = 0; i < size(); i++) {
        std::cout << (*this)[i] << " ";
      }
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
        if ((*order)[i] == i) {
          fitness += fragment; // boost for each that wasn't moved
        }
      }
      // removing copies is a secondary concern
      fitness = (100 * fitness) + removedCopies;
      order->setFitness(fitness);
    }

    Order* makeRandom() {
      auto* ret = new Order;
      ret->resize(parent->numLocals);
      for (Index i = 0; i < parent->numLocals; i++) {
        (*ret)[i] = i;
      }
      if (first) {
        // as the first guess, use the natural order. this is not arbitrary for
        // two reasons. first, there may be an inherent order in the input
        // (frequent indices are lower, etc.). second, by ensuring we start with
        // the natural order, we ensure we are at least as good as the
        // non-learning variant.
        // TODO: use ::pickIndices from the parent, so we literally get the
        //       simpler approach as our first option
        first = false;
      } else {
        // leave params alone, shuffle the rest
        std::shuffle(ret->begin() + parent->getFunction()->getNumParams(),
                     ret->end(),
                     noise);
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
          // if we don't skip, we might end up pushing an element all the way to
          // the end, which is not very perturbation-y
          i++;
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
  const int GENERATION_SIZE =
    std::min(Index(numVars * (numVars - 1)), Index(20));
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
    if (newBest == oldBest) {
      break; // unlikely we can improve
    }
    oldBest = newBest;
#ifdef CFG_LEARN_DEBUG
    learner.getBest()->dump("current best");
#endif
  }
#ifdef CFG_LEARN_DEBUG
  learner.getBest()->dump("the best");
#endif
  // TODO: cache indices in Orders, at the cost of more memory?
  this->pickIndicesFromOrder(*learner.getBest(), indices);
}

// declare passes

Pass* createCoalesceLocalsPass() { return new CoalesceLocals(); }

Pass* createCoalesceLocalsWithLearningPass() {
  return new CoalesceLocalsWithLearning();
}

} // namespace wasm
