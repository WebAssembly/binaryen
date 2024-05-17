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
    if (module->globals.size() < 128 && !always) {
      // The module has so few globals that they all fit in a single-byte U32LEB
      // value, so no reordering we can do can actually decrease code size. Note
      // that this is the common case with wasm MVP modules where the only
      // globals are typically the stack pointer and perhaps a handful of others
      // (however, features like wasm GC there may be a great many globals).
      return;
    }

    NameCountMap counts;
    // Fill in info, as we'll operate on it in parallel.
    for (auto& global : module->globals) {
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
    // globals it transitively depends on. We also build a reverse map for the
    // later processing.
    std::unordered_map<Name, std::unordered_set<Name>> deps;
    std::unordered_map<Name, std::unordered_set<Name>> reverseDeps;

    // Find the direct dependencies, then compute the transitive closure. Our
    // work items are a global and a new dependency we recently added for it.
    UniqueDeferredQueue<std::pair<Name, Name>> work;
    auto addDep = [&](Name global, Name dep) {
      auto [_, inserted] = deps[global].insert(dep);
      if (inserted) {
        reverseDeps[dep].insert(global);
        work.push({global, dep});
      }
    };
    for (auto& global : module->globals) {
      if (!global->imported()) {
        for (auto* get : FindAll<GlobalGet>(global->init).list) {
          addDep(global->name, get->name);
        }
      }
    }

    // The immediate dependencies are the ones we just computed, before the
    // transitive closure we are about to do.
    auto immediateDeps = deps;
    auto immediateReverseDeps = reverseDeps;

    while (!work.empty()) {
      auto [global, dep] = work.pop();
      // Wasm (and Binaryen IR) do not allow self-dependencies.
      assert(global != dep);

      // We are notified of a dep we've already added. We only need to consider
      // consequences downstream.
      assert(deps[global].count(dep));

      // If we recently added global->dep, and we also have rev->global, then
      // we may need to add rev->dep. Note that we may modify reverseDeps as we
      // iterate here, so we operate on a copy.
      auto copy = reverseDeps[global];
      for (auto rev : copy) {
        addDep(rev, dep);
      }
    }

    // We are now aware of all dependencies. Before we sort, we must define a
    // total ordering, for which we compute the topological depth from the deps:
    // things that nothing depends on have depth 0, depth 1 are the things they
    // depend on immediately, and so forth. We build up a map of global names to
    // their depth, using a work queue of globals to process.
    std::unordered_map<Name, Index> depths;
    UniqueDeferredQueue<Name> work2;
    for (auto& global : module->globals) {
      work2.push(global->name);
    }
    while (!work2.empty()) {
      auto global = work2.pop();
      auto& depth = depths[global];
      auto old = depth;
      for (auto rev : immediateReverseDeps[global]) {
        // Each global's depth is at least 1 more than things that depend on it.
        depth = std::max(depth, depths[rev] + 1);
      }
      if (depth != old) {
        // We added, which means things that we depend on may need updating.
        for (auto dep : immediateDeps[global]) {
          work2.push(dep);
        }
      }
    }

    // Sort!
    std::stable_sort(module->globals.begin(), module->globals.end(),
      [&](const std::unique_ptr<Global>& a, const std::unique_ptr<Global>& b) {
        // If one depends on the other, the dependency must appear first.
        if (deps[b->name].count(a->name)) {
          return true;
        }
        if (deps[a->name].count(b->name)) {
          return false;
        }

        // There is no dependence between them, so use the counts.
        if (counts[a->name] > counts[b->name]) {
          return true;
        }
        if (counts[b->name] > counts[a->name]) {
          return false;
        }

        // Finally, use the topological sort to break ties.
        return depths[a->name] > depths[b->name];
      });

    module->updateMaps();
  }
};

Pass* createReorderGlobalsPass() { return new ReorderGlobals(false); }

Pass* createReorderGlobalsAlwaysPass() { return new ReorderGlobals(true); }

} // namespace wasm
