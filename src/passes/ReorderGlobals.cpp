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

#include "memory"

#include "ir/find_all.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

using NameCountMap = std::unordered_map<Name, std::atomic<Index>>;

struct UseCountScanner : public WalkerPass<PostWalker<UseCountScanner>> {
  bool isFunctionParallel() override { return true; }

  bool modifiesBinaryenIR() override { return false; }

  UseCountScanner(NameCountMap& counts) : counts(counts) {}

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
  NameCountMap& counts;
};

struct ReorderGlobals : public Pass {
  // Whether to always reorder globals, even if there are very few and the
  // benefit is minor. That is useful for testing, and also internally in passes
  // that use us to reorder them so dependencies appear first (that is, if a
  // pass ends up with an earlier global reading a later one, the sorting in
  // this pass will reorder them properly; we need to take those dependencies
  // into account anyhow here).
  bool always;

  ReorderGlobals(bool always) : always(always) {}

  // We will consider more than one possible sorting result.
  struct SortResult {
    // For each global, its index in this sorting.
    std::unordered_map<Name, Index> sortedIndexes;
    // The total size of relevant parts of the wasm, given this sorting. Less is
    // better.
    size_t size;
  };

  // To break ties we use the original order, to avoid churn.
  std::unordered_map<Name, Index> originalIndexes;

  // We must take into account dependencies, so that globals appear before
  // their users in other globals:
  //
  //   (global $a i32 (i32.const 10))
  //   (global $b i32 (global.get $a)) ;; $b depends on $a; $a must be first
  //
  // To do so we construct a map from each global to those it depends on. We
  // also build the reverse map, of those that it is depended on from.
  std::unordered_map<Name, std::unordered_set<Name>> dependsOn;
  std::unordered_map<Name, std::unordered_set<Name>> dependedUpon;


  void run(Module* module) override {
    auto& globals = module->globals;

    if (globals.size() < 128 && !always) {
      // The module has so few globals that they all fit in a single-byte U32LEB
      // value, so no reordering we can do can actually decrease code size. Note
      // that this is the common case with wasm MVP modules where the only
      // globals are typically the stack pointer and perhaps a handful of others
      // (however, features like wasm GC there may be a great many globals).
      return;
    }

    NameCountMap counts;
    // Fill in info, as we'll operate on it in parallel.
    for (auto& global : globals) {
      counts[global->name];
    }

    // Count uses.
    UseCountScanner scanner(counts);
    scanner.run(getPassRunner(), module);
    scanner.runOnModuleCode(getPassRunner(), module);

    // Compute dependencies.
    for (auto& global : globals) {
      if (!global->imported()) {
        for (auto* get : FindAll<GlobalGet>(global->init).list) {
          dependsOn[global->name].insert(get->name);
          dependedUpon[get->name].insert(global->name);
        }
      }
    }

    // Compute original indexes.
    for (Index i = 0; i < globals.size(); i++) {
      originalIndexes[globals[i]->name] = i;
    }

    // Compute some sorts, and pick the best.

    // A pure greedy sort uses the counts as we generated them, that is, at each
    // point it time it picks the global with the highest count that it can.
    auto pureGreedy = doSort(counts);

    // Compute the closest thing we can to the original, unoptimized sort, by
    // setting all counts to 0 there, so it only takes into account dependencies
    // and the original ordering.
    NameCountMap zeroes;
    for (auto& global : globals) {
      zeroes[global] = 0;
    }
    auto original = doSort(zeroes);

    auto& best = pureGreedy.size <= original.size ? pureGreedy : original;

    // Apply the indexes we computed.
    std::sort(
      globals.begin(),
      globals.end(),
      [&](const std::unique_ptr<Global>& a, const std::unique_ptr<Global>& b) {
        return best.sortedIndexes[a->name] < best.sortedIndexes[b->name];
      });

    module->updateMaps();
  }

  SortResult doSort(const NameCountMap& counts) {
    // To sort the globals we do a simple greedy approach of always picking the
    // global with the highest count at every point in time, subject to the
    // constraint that we can only emit globals that have all of their
    // dependencies already emitted. To do so we keep a list of the "available"
    // globals, which are those with no remaining dependencies. Then by keeping
    // the list of available globals in heap form we can simply pop the largest
    // from the heap each time, and add new available ones as they become so.
    //
    // Other approaches here could be to do a topological sort, but we do need
    // this fully general algorithm, because the optimal order may not require
    // strict ordering by topological depth, e.g.:
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
    // higher use count than $a. This algorithm often does well, however, and it
    // runs in linear time in the size of the input.
    std::vector<Name> availableHeap;

    auto cmp = [&](Name a, Name b) {
      // Imports always go first. The binary writer takes care of this itself
      // anyhow, but it is better to do it here in the IR so we can actually
      // see what the final layout will be.
      auto aImported = module->getGlobal(a)->imported();
      auto bImported = module->getGlobal(b)->imported();
      if (!aImported && bImported) {
        return true;
      }
      if (aImported && !bImported) {
        return false;
      }

      // Sort by the counts.
      if (counts[a] < counts[b]) {
        return true;
      }
      if (counts[a] > counts[b]) {
        return false;
      }

      // Break ties using the original order.
      return originalIndexes[a] < originalIndexes[b];
    };

    // Push an item that just became available to the available heap.
    auto push = [&](Name global) {
      availableHeap.push_back(global);
      std::push_heap(availableHeap.begin(), availableHeap.end(), cmp);
    };

    // The initially available globals are those with no dependencies.
    for (auto& global : globals) {
      if (dependsOn[global->name].empty()) {
        push(global->name);
      }
    }

    // Pop off the heap: Emit the global and it its final, sorted index. Keep
    // doing that until we finish processing all the globals.
    std::unordered_map<Name, Index> sortedIndexes;
    while (!availableHeap.empty()) {
      std::pop_heap(availableHeap.begin(), availableHeap.end(), cmp);
      auto global = availableHeap.back();
      sortedIndexes[global] = sortedIndexes.size();
      availableHeap.pop_back();

      // Each time we pop we emit the global, which means anything that only
      // depended on it becomes available to be popped as well.
      for (auto other : dependedUpon[global]) {
        assert(dependsOn[other].count(global));
        dependsOn[other].erase(global);
        if (dependsOn[other].empty()) {
          push(other);
        }
      }
    }

    // All globals must have been handled. Cycles would prevent this, but they
    // cannot exist in valid IR.
    assert(sortedIndexes.size() == globals.size());

    return SortResult{sortedIndexes, computeSize(sortedIndexes)};
  }

  // Given an indexing of the globals (a map from their names to the index of
  // each one, and the counts of how many times each appears, estimate the size
  // of relevant parts of the wasm binary (that is, of LEBs in global.gets).
  size_t computeSize(std::unordered_map<Name, Index>& indexes,
                     NameCountMap& counts) {
    // Go from |indexes| to a vector of the names in order.
    std::vector<Name> globals;
    inOrder.resize(indexes.size());
    for (auto& [global, index] : indexes) {
      // Each global has a unique index, and all are in bounds [0, N).
      assert(index < globals.size());
      assert(globals[index].isNull());
      globals[index] = global;
    }

    // The total size we are computing.
    size_t total = 0;
    // At index 0 the size is bits is 1 byte. We will update this as we go.
    // Each LEB byte has 7 bits of payload, so the ordering only matters modulo
    // clumps of 7 bits, that is, the first increase happens at 128, and so
    // forth.
    size_t sizeInBits = 1;
    size_t nextSizeIncrease = 128;
    for (Index i = 0; i < globals.size(); i++) {
      if (i == nextSizeIncrease) {
        sizeInBits++;
        nextSizeIncrease <<= 7;
      }
      total += counts[globals[i]] * sizeInBits;
    }
    return total;
  }
};

Pass* createReorderGlobalsPass() { return new ReorderGlobals(false); }

Pass* createReorderGlobalsAlwaysPass() { return new ReorderGlobals(true); }

} // namespace wasm
