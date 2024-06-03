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
#include "ir/numbering.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/learning.h"
#include "support/permutations.h"
#include "support/sparse_square_matrix.h"
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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<CoalesceLocals>();
  }

  // Branches outside of the function can be ignored, as we only look at locals
  // which vanish when we leave.
  bool ignoreBranchesOutsideOfFunc = true;

  // main entry point

  void doWalkFunction(Function* func);

  void increaseBackEdgePriorities();

  // Calculate interferences between locals. This will will fill
  // the data structure |interferences|.
  void calculateInterferences();

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
  sparse_square_matrix<bool> interferences;

  void interfere(Index i, Index j) {
    if (i == j) {
      return;
    }
    interferences.set(std::min(i, j), std::max(i, j), true);
  }

  // optimized version where you know that low < high
  void interfereLowHigh(Index low, Index high) {
    assert(low < high);
    interferences.set(low, high, true);
  }

  void unInterfere(Index i, Index j) {
    interferences.set(std::min(i, j), std::max(i, j), false);
  }

  bool interferes(Index i, Index j) {
    return interferences.get(std::min(i, j), std::max(i, j));
  }

private:
  // In some cases we need to refinalize at the end.
  bool refinalize = false;
};

void CoalesceLocals::doWalkFunction(Function* func) {
  super::doWalkFunction(func);
  // prioritize back edges
  increaseBackEdgePriorities();
  // use liveness to find interference
  calculateInterferences();
  // pick new indices
  std::vector<Index> indices;
  pickIndices(indices);
  // apply indices
  applyIndices(indices, func->body);

  if (refinalize) {
    ReFinalize().walkFunctionInModule(func, getModule());
  }
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
  interferences.recreate(numLocals);

  // We will track the values in each local, using a numbering where each index
  // represents a unique different value. This array maps a local index to the
  // value index it contains.
  //
  // To avoid reallocating this array all the time, allocate it once outside the
  // loop.
  std::vector<Index> values(numLocals);

  ValueNumbering valueNumbering;

  auto* func = getFunction();

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
        // This is a set. Check if the local is alive after it; if it is then
        // the set if effective as there is some get that can read the value.
        if (live.erase(index)) {
          action.effective = true;
        }
      }
    }

    // We have processed from the end of the block to the start, updating |live|
    // as we go, and now it must be equal to the state at the start of the
    // block. We will also use |live| in the next loop, and assume it begins
    // in that state.
    assert(live == curr->contents.start);

    // Now that we know live ranges, check if locals interfere in this block.
    // Locals interfere if they might contain different values on areas where
    // their live ranges overlap. To evaluate that, we do an analysis inside
    // the block that gives each set a unique value number, and as those flow
    // around through copies between sets we can see when sets are guaranteed to
    // be equal.

    if (curr.get() == entry) {
      // Each parameter is assumed to have a different value on entry.
      for (Index i = 0; i < func->getNumParams(); i++) {
        values[i] = valueNumbering.getUniqueValue();
      }

      for (Index i = func->getNumParams(); i < func->getNumLocals(); i++) {
        auto type = func->getLocalType(i);
        if (!LiteralUtils::canMakeZero(type)) {
          // The default value for a type for which we can't make a zero cannot
          // be used anyhow, but we must give it some value in this analysis. A
          // unique one seems least likely to result in surprise during
          // debugging.
          values[i] = valueNumbering.getUniqueValue();
        } else {
          values[i] = valueNumbering.getValue(Literal::makeZeros(type));
        }
      }
    } else {
      // In any block but the entry, assume that each live local might have a
      // different value at the start.
      // TODO: Propagating value IDs across blocks could identify more copies,
      //       however, it would also be nonlinear.
      for (auto index : curr->contents.start) {
        values[index] = valueNumbering.getUniqueValue();
      }
    }

    // Traverse through the block from start to finish. We keep track of both
    // liveness (in |live|) and the value IDs in each local (in |values|)
    // while doing so.
    for (Index i = 0; i < actions.size(); i++) {
      auto& action = actions[i];
      auto index = action.index;
      if (action.isGet()) {
        if (endsLiveRange[i]) {
          [[maybe_unused]] bool erased = live.erase(action.index);
          assert(erased);
        }
        continue;
      }

      // This is a set. Find the value being assigned to the local.
      auto* set = (*action.origin)->cast<LocalSet>();
      Index newValue;
      if (set->value->is<LocalGet>() || set->value->is<LocalSet>()) {
        // This is a copy: Either it is a get or a tee, that occurs right
        // before us. Set our new value to theirs.
        assert(i > 0 && set->value == *actions[i - 1].origin);
        newValue = values[actions[i - 1].index];
      } else {
        // This is not a copy.
        newValue = valueNumbering.getValue(set->value);
      }
      values[index] = newValue;

      // If this set has no gets that read from it, then it does not start a
      // live range, and it cannot cause interference.
      if (!action.effective) {
        continue;
      }

      // Update interferences: This will interfere with any other local that
      // is currently live and contains a different value.
      for (auto other : live) {
        // This index cannot have been live before this set (as we would be
        // trampling some other set before us, if so; and then that set would
        // have been ineffective). We will mark this index as live right after
        // this loop).
        assert(other != index);
        if (values[other] != newValue) {
          interfere(other, index);
        }
      }
      live.insert(action.index);
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
    // and so blocks only need to reason about their own contents and not what
    // arrives to them.
    //
    // The one exception here is the entry to the function, see below.
  }

  // We must not try to coalesce parameters as they are fixed. Mark them as
  // "interfering" so that we do not need to special-case them later.
  auto numParams = getFunction()->getNumParams();
  for (Index i = 0; i < numParams; i++) {
    for (Index j = i + 1; j < numParams; j++) {
      interfereLowHigh(i, j);
    }
  }

  // We must handle interference between uses of the zero-init value and
  // parameters manually. A zero initialization represents a set (to a default
  // value), and that set would be what alerts us to a conflict, but there is no
  // actual set in the IR since the zero-init value is applied implicitly.
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
  sparse_square_matrix<bool> newInterferences;

  // new index * numLocals => list of all copies of locals merged to it
  sparse_square_matrix<uint8_t> newCopies;

  indices.resize(numLocals);
  types.resize(numLocals);

  auto numParams = getFunction()->getNumParams();

  newInterferences.recreate(numLocals);
  newCopies.recreate(numLocals);

  Index nextFree = 0;
  removedCopies = 0;
  // we can't reorder parameters, they are fixed in order, and cannot coalesce
  Index i = 0;
  for (; i < numParams; i++) {
    assert(order[i] == i); // order must leave the params in place
    indices[i] = i;
    types[i] = getFunction()->getLocalType(i);
    for (Index j = numParams; j < numLocals; j++) {
      newInterferences.set(i, j, interferes(i, j));
      newCopies.set(i, j, getCopies(i, j));
    }
    nextFree++;
  }
  for (; i < numLocals; i++) {
    Index actual = order[i];
    Index found = -1;
    uint8_t foundCopies = -1;
    for (Index j = 0; j < nextFree; j++) {
      if (!newInterferences.get(j, actual) &&
          getFunction()->getLocalType(actual) == types[j]) {
        // this does not interfere, so it might be what we want. but pick the
        // one eliminating the most copies (we could stop looking forward when
        // there are no more items that have copies anyhow, but it doesn't seem
        // to help)
        auto currCopies = newCopies.get(j, actual);
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
      newInterferences.set(
        found, j, newInterferences.get(found, j) || interferes(actual, j));
      newCopies.set(found, j, newCopies.get(found, j) + getCopies(actual, j));
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
        if (auto* subSet = set->value->dynCast<LocalSet>()) {
          // Only do so if not only the index matches but also the type. If the
          // inner type is more refined, leave that for other passes.
          if (subSet->index == set->index &&
              subSet->value->type == subSet->type) {
            set->value = subSet->value;
            continue;
          }
        }

        // Remove ineffective actions, that is, dead stores.
        //
        // Note that this may have downsides for non-nullable locals:
        //
        //   x = whatever; // dead set for validation
        //   if (..) {
        //     x = value1;
        //   } else {
        //     x = value2;
        //   }
        //
        // The dead set ensures validation, at the cost of extra code size and
        // slower speed in some tiers (the optimizing tier, at least, will
        // remove such dead sets anyhow). In theory keeping such a dead set may
        // be worthwhile, as it may save code size (by keeping the local
        // non-nullable and avoiding ref.as_non_nulls later). But the tradeoff
        // here isn't clear, so do the simple thing for now and remove all dead
        // sets.
        if (!action.effective) {
          // value may have no side effects, further optimizations can eliminate
          // it
          auto* value = set->value;
          if (!set->isTee()) {
            // we need to drop it
            Drop* drop = ExpressionManipulator::convert<LocalSet, Drop>(set);
            drop->value = value;
            *action.origin = drop;
          } else {
            auto originalType = (*action.origin)->type;
            if (originalType != set->value->type) {
              // The value had a more refined type, which we must propagate at
              // the end.
              refinalize = true;
            }
            *action.origin = set->value;
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
  std::unique_ptr<Pass> create() override {
    return std::make_unique<CoalesceLocalsWithLearning>();
  }

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
