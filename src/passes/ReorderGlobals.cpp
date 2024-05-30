/*
 * Copyright 2022 WebAssembly Community Group participants
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
// Sorts globals by their static use count. This helps reduce the size of wasm
// binaries because fewer bytes are needed to encode references to frequently
// used globals.
//
// This pass also sorts by dependencies, as each global can only appear after
// those it refers to. Other passes can use this internally to fix the ordering
// after they add new globals.
//
// The "always" variant of this pass will always sort globals, even if there are
// so few they all fit in a single LEB. In "always" mode we sort regardless and
// we measure size by considering each subsequent index to have a higher cost.
// That is, in reality the size of all globals up to 128 is a single byte, and
// then the LEB grows to 2, while in "always" mode we increase the size by 1/128
// for each global in a smooth manner. "Always" is mainly useful for testing.
//

#include "memory"

#include "ir/find_all.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

// We'll count uses in parallel.
using AtomicNameCountMap = std::unordered_map<Name, std::atomic<Index>>;

struct UseCountScanner : public WalkerPass<PostWalker<UseCountScanner>> {
  bool isFunctionParallel() override { return true; }

  bool modifiesBinaryenIR() override { return false; }

  UseCountScanner(AtomicNameCountMap& counts) : counts(counts) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<UseCountScanner>(counts);
  }

  void visitGlobalGet(GlobalGet* curr) {
    // We can't add a new element to the map in parallel.
    assert(counts.count(curr->name) > 0);
    counts[curr->name]++;
  }
  void visitGlobalSet(GlobalSet* curr) {
    assert(counts.count(curr->name) > 0);
    counts[curr->name]++;
  }

private:
  AtomicNameCountMap& counts;
};

struct ReorderGlobals : public Pass {
  bool always;

  ReorderGlobals(bool always) : always(always) {}

  // For efficiency we will use global indices rather than names. That is, we
  // use the index of the global in the original ordering to identify each
  // global. A different ordering is then a vector of new indices, saying where
  // each one moves, which is logically a mapping between indices.
  using IndexIndexMap = std::vector<Index>;

  // We will also track counts of uses for each global. We use floating-point
  // values here since while the initial counts are integers, we will be
  // considering fractional sums of them later.
  using IndexCountMap = std::vector<double>;

  // We must take into account dependencies, so that globals appear before
  // their users in other globals:
  //
  //   (global $a i32 (i32.const 10))
  //   (global $b i32 (global.get $a)) ;; $b depends on $a; $a must be first
  //
  // To do so we construct a map from each global to those it depends on. We
  // also build the reverse map, of those that it is depended upon by.
  struct Dependencies {
    std::unordered_map<Index, std::unordered_set<Index>> dependsOn;
    std::unordered_map<Index, std::unordered_set<Index>> dependedUpon;
  };

  void run(Module* module) override {
    auto& globals = module->globals;

    if (globals.size() < 128 && !always) {
      // The module has so few globals that they all fit in a single-byte U32LEB
      // value, so no reordering we can do can actually decrease code size. Note
      // that this is the common case with wasm MVP modules where the only
      // globals are typically the stack pointer and perhaps a handful of others
      // (however, features like wasm GC there may be a great many globals).
      // TODO: we still need to sort here to fix dependencies sometimes
      return;
    }

    AtomicNameCountMap atomicCounts;
    // Fill in info, as we'll operate on it in parallel.
    for (auto& global : globals) {
      atomicCounts[global->name];
    }

    // Count uses.
    UseCountScanner scanner(atomicCounts);
    scanner.run(getPassRunner(), module);
    scanner.runOnModuleCode(getPassRunner(), module);

    // Switch to non-atomic for all further processing, and convert names to
    // indices.
    std::unordered_map<Name, Index> originalIndices;
    for (Index i = 0; i < globals.size(); i++) {
      originalIndices[globals[i]->name] = i;
    }
    IndexCountMap counts(globals.size());
    for (auto& [name, count] : atomicCounts) {
      counts[originalIndices[name]] = count;
    }

    // Compute dependencies.
    Dependencies deps;
    for (Index i = 0; i < globals.size(); i++) {
      auto& global = globals[i];
      if (!global->imported()) {
        for (auto* get : FindAll<GlobalGet>(global->init).list) {
          auto getIndex = originalIndices[get->name];
          deps.dependsOn[i].insert(getIndex);
          deps.dependedUpon[getIndex].insert(i);
        }
      }
    }

    // Compute various sorting options. All the options use a variation of the
    // algorithm in doSort() below, see there for more details; the only
    // difference between the sorts is in the use counts we provide it.
    struct SortAndSize {
      IndexIndexMap sort;
      double size;
      SortAndSize(IndexIndexMap&& sort, double size) : sort(sort), size(size) {}
    };
    std::vector<SortAndSize> options;
    auto addOption = [&](const IndexCountMap& customCounts) {
      // Compute the sort using custom counts that guide us how to order.
      auto sort = doSort(customCounts, deps, module);
      // Compute the size using the true counts.
      auto size = computeSize(sort, counts);
      options.emplace_back(std::move(sort), size);
    };

    // Compute the closest thing we can to the original, unoptimized sort, by
    // setting all counts to 0 there, so it only takes into account dependencies
    // and the original ordering and nothing else.
    //
    // We put this sort first because if they all end up with equal size we
    // prefer it (as it avoids pointless changes).
    IndexCountMap zeroes(globals.size());
    addOption(zeroes);

    // A simple sort that uses the counts. As the algorithm in doSort() is
    // greedy (see below), this is a pure greedy sort (at each point it time it
    // picks the global with the highest count that it can).
    addOption(counts);

    // We can make the sort less greedy by adding to each global's count some of
    // the count of its children. Then we'd still be picking in a greedy manner
    // but our choices would be influenced by the bigger picture of what can be
    // unlocked by emitting a particular global (it may have a low count itself,
    // but allow emitting something that depends on it that has a high count).
    // We try two variations of this, one which is a simple sum (add the
    // dependent's counts to the global's) and one which exponentially decreases
    // them (that is, we add a small multiple of the dependent's counts, which
    // may help as the dependents also depend on other things potentially, so a
    // simple sum may be too naive).
    double const EXPONENTIAL_FACTOR = 0.095;
    IndexCountMap sumCounts(globals.size()), exponentialCounts(globals.size());
    // We add items to |sumCounts, exponentialCounts| after they are computed,
    // so anything not there must be pushed to a stack before we can handle it.
    std::vector<Index> stack;
    // Do a simple recursion to compute children before parents, while tracking
    // which have been computed.
    std::vector<bool> computed(globals.size());
    for (Index i = 0; i < globals.size(); i++) {
      stack.push_back(i);
    }
    while (!stack.empty()) {
      auto global = stack.back();
      if (computed[global]) {
        // We've already computed this.
        stack.pop_back();
        continue;
      }
      // Leave ourselves on the stack and push any unresolved deps.
      auto pushed = false;
      for (auto dep : deps.dependedUpon[global]) {
        if (!computed[dep]) {
          stack.push_back(dep);
          pushed = true;
        }
      }
      if (pushed) {
        continue;
      }
      // We can handle this now, as all deps are resolved.
      stack.pop_back();
      // Start with the self-count, then add the deps.
      sumCounts[global] = exponentialCounts[global] = counts[global];
      for (auto dep : deps.dependedUpon[global]) {
        sumCounts[global] += sumCounts[dep];
        exponentialCounts[global] +=
          EXPONENTIAL_FACTOR * exponentialCounts[dep];
      }
      computed[global] = true;
    }
    addOption(sumCounts);
    addOption(exponentialCounts);

    // Pick the best out of all the options we computed.
    IndexIndexMap* best = nullptr;
    double bestSize;
    for (auto& [sort, size] : options) {
      if (!best || size < bestSize) {
        best = &sort;
        bestSize = size;
      }
    }

    // Apply the indices we computed.
    std::sort(
      globals.begin(),
      globals.end(),
      [&](const std::unique_ptr<Global>& a, const std::unique_ptr<Global>& b) {
        return (*best)[originalIndices[a->name]] <
               (*best)[originalIndices[b->name]];
      });

    module->updateMaps();
  }

  IndexIndexMap doSort(const IndexCountMap& counts,
                       const Dependencies& originalDeps,
                       Module* module) {
    auto& globals = module->globals;

    // Copy the deps as we will operate on them as we go.
    auto deps = originalDeps;

    // To sort the globals we do a simple greedy approach of always picking the
    // global with the highest count at every point in time, subject to the
    // constraint that we can only emit globals that have all of their
    // dependencies already emitted. To do so we keep a list of the "available"
    // globals, which are those with no remaining dependencies. Then by keeping
    // the list of available globals in heap form we can simply pop the largest
    // from the heap each time, and add new available ones as they become so.
    //
    // Other approaches here could be to do a topological sort, but the optimal
    // order may not require strict ordering by topological depth, e.g.:
    /*
    //     $c - $a
    //    /
    //  $e
    //    \
    //     $d - $b
    */
    // Here $e depends on $c and $d, $c depends on $a, and $d on $b. This is a
    // partial order, as $d can be before or after $a, for example. As a result,
    // if we sorted topologically by sub-trees here then we'd keep $c and $a
    // together, and $d and $b, but a better order might interleave them. A good
    // order also may not keep topological depths separated, e.g. we may want to
    // put $a in between $c and $d despite it having a greater depth.
    //
    // The greedy approach here may also be unoptimal, however. Consider that we
    // might see that the best available global is $a, but if we popped $b
    // instead that could unlock $c which depends on $b, and $c may have a much
    // higher use count than $a. For that reason we try several variations of
    // this with different counts, see earlier.
    std::vector<Index> availableHeap;

    // Comparison function. This is used in a heap, where "highest" means
    // "popped first", so if we compare the counts 10 and 20 we will return 1,
    // which means 10 appears first in a simple sort, as 20 is higher. Later, 20
    // will be popped earlier as it is higher and then it will appear earlier in
    // the actual final sort.
    auto cmp = [&](Index a, Index b) {
      // Imports always go first. The binary writer takes care of this itself
      // anyhow, but it is better to do it here in the IR so we can actually
      // see what the final layout will be.
      auto aImported = globals[a]->imported();
      auto bImported = globals[b]->imported();
      if (!aImported && bImported) {
        return true;
      }
      if (aImported && !bImported) {
        return false;
      }

      // Sort by the counts.
      auto aCount = counts[a];
      auto bCount = counts[b];
      if (aCount < bCount) {
        return true;
      }
      if (aCount > bCount) {
        return false;
      }

      // Break ties using the original order, which means just using the
      // indices we have.
      return a > b;
    };

    // Push an item that just became available to the available heap.
    auto push = [&](Index global) {
      availableHeap.push_back(global);
      std::push_heap(availableHeap.begin(), availableHeap.end(), cmp);
    };

    // The initially available globals are those with no dependencies.
    for (Index i = 0; i < globals.size(); i++) {
      if (deps.dependsOn[i].empty()) {
        push(i);
      }
    }

    // Pop off the heap: Emit the global and it its final, sorted index. Keep
    // doing that until we finish processing all the globals.
    IndexIndexMap sortedindices(globals.size());
    Index numSortedindices = 0;
    while (!availableHeap.empty()) {
      std::pop_heap(availableHeap.begin(), availableHeap.end(), cmp);
      auto global = availableHeap.back();
      sortedindices[global] = numSortedindices++;
      availableHeap.pop_back();

      // Each time we pop we emit the global, which means anything that only
      // depended on it becomes available to be popped as well.
      for (auto other : deps.dependedUpon[global]) {
        assert(deps.dependsOn[other].count(global));
        deps.dependsOn[other].erase(global);
        if (deps.dependsOn[other].empty()) {
          push(other);
        }
      }
    }

    // All globals must have been handled. Cycles would prevent this, but they
    // cannot exist in valid IR.
    assert(numSortedindices == globals.size());

    return sortedindices;
  }

  // Given an indexing of the globals and the counts of how many times each is
  // used, estimate the size of relevant parts of the wasm binary (that is, of
  // LEBs in global.gets).
  double computeSize(IndexIndexMap& indices, IndexCountMap& counts) {
    // |indices| maps each old index to its new position in the sort. We need
    // the reverse map here, which at index 0 has the old index of the global
    // that will be first, and so forth.
    IndexIndexMap actualOrder(indices.size());
    for (Index i = 0; i < indices.size(); i++) {
      // Each global has a unique index, so we only replace 0's here, and they
      // must be in bounds.
      assert(indices[i] < indices.size());
      assert(actualOrder[indices[i]] == 0);

      actualOrder[indices[i]] = i;
    }

    if (always) {
      // In this mode we gradually increase the cost of later globals, in an
      // unrealistic but manner.
      double total = 0;
      for (Index i = 0; i < actualOrder.size(); i++) {
        // Multiply the count for this global by a smoothed LEB factor, which
        // starts at 1 (for 1 byte) at index 0, and then increases linearly with
        // i, so that after 128 globals we reach 2 (which is the true index at
        // which the LEB size normally jumps from 1 to 2), and so forth.
        total += counts[actualOrder[i]] * (1.0 + (i / 128.0));
      }
      return total;
    }

    // The total size we are computing.
    double total = 0;
    // Track the size in bits and the next index at which the size increases. At
    // the first iteration we'll compute the size of the LEB for index 0, and so
    // forth.
    size_t sizeInBits = 0;
    size_t nextSizeIncrease = 0;
    for (Index i = 0; i < actualOrder.size(); i++) {
      if (i == nextSizeIncrease) {
        sizeInBits++;
        // At the current size we have 7 * sizeInBits bits to use.  For example,
        // at index 0 the size is 1 and we'll compute 128 here, and indeed after
        // emitting 128 globals (0,..,127) the 129th (at index 128) requires a
        // larger LEB.
        nextSizeIncrease = 1 << (7 * sizeInBits);
      }
      total += counts[actualOrder[i]] * sizeInBits;
    }
    return total;
  }
};

Pass* createReorderGlobalsPass() { return new ReorderGlobals(false); }

Pass* createReorderGlobalsAlwaysPass() { return new ReorderGlobals(true); }

} // namespace wasm
