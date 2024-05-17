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

#include "memory"

#include "ir/find_all.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
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

    // We must take into account dependencies, so that globals appear before
    // their users in other globals:
    //
    //   (global $a i32 (i32.const 10))
    //   (global $b i32 (global.get $a)) ;; $b depends on $a; $a must be first
    //
    // To do so we construct a map from each global to the set of all other
    // globals it transitively depends on. We also build a reverse map.
    std::unordered_map<Name, std::unordered_set<Name>> dependsOn;
    std::unordered_map<Name, std::unordered_set<Name>> dependedOn;

    for (auto& global : globals) {
      if (!global->imported()) {
        for (auto* get : FindAll<GlobalGet>(global->init).list) {
std::cout << global->name << " depends on " << get->name << '\n';
          dependsOn[global->name].insert(get->name);
          dependedOn[get->name].insert(global->name);
        }
      }
    }

    // To sort the globals we use the simple approach of always picking the
    // global with the highest count at every point in time, subject to the
    // constraint that we can only emit globals that have all of their
    // dependencies already emitted. To do so we keep a list of the "available"
    // globals, which are those with no remaining dependencies. Then by keeping
    // the list of available globals in heap form we can simply pop the largest
    // from the heap each time.
    std::vector<Name> availableHeap;

    auto cmp = [&](Name a, Name b) {
      // Sort by the counts.
      if (counts[a] < counts[b]) {
        return true;
      }
      if (counts[a] > counts[b]) {
        return false;
      }

      // Break ties using the name. TODO: Perhaps the original order?
      return a > b;
    };

    // Likely not needed on an empty vector, but just to be safe.
    std::make_heap(availableHeap.begin(), availableHeap.end(), cmp);

    // Each time we add to the heap, we may make more things available.
    auto push = [&](Name global) {
      // Pushing an item can make more available, and so on recursively, but
      // avoid recursion here because the chains may be deep.
      std::vector<Name> toPush;
      toPush.push_back(global);
      while (!toPush.empty()) {
        auto curr = toPush.back();
        toPush.pop_back();

        availableHeap.push_back(curr);
        std::push_heap(availableHeap.begin(), availableHeap.end(), cmp);

        for (auto other : dependedOn[curr]) {
          assert(dependsOn[other].count(curr));
          dependsOn[other].erase(curr);
          if (dependsOn[other].empty()) {
            toPush.push_back(other);
          }
        }
      }
    };

    // The initially available globals are those with no dependencies.
    for (auto& global : globals) {
      if (dependsOn[global->name].empty()) {
        push(global->name);
      }
    }

    // Pop off the heap until we finish processing all the globals.
    std::unordered_map<Name, Index> sortedIndexes;
    while (!availableHeap.empty()) {
      std::pop_heap(availableHeap.begin(), availableHeap.end(), cmp);
      sortedIndexes[availableHeap.back()] = sortedIndexes.size();
      availableHeap.pop_back();
    }

    assert(sortedIndexes.size() == globals.size());

    // Use the total ordering of the topological sort + counts.
    std::sort(globals.begin(), globals.end(),
      [&](const std::unique_ptr<Global>& a, const std::unique_ptr<Global>& b) {
        return sortedIndexes[a->name] < sortedIndexes[b->name];
      });

    module->updateMaps();
  }
};

Pass* createReorderGlobalsPass() { return new ReorderGlobals(false); }

Pass* createReorderGlobalsAlwaysPass() { return new ReorderGlobals(true); }

} // namespace wasm
