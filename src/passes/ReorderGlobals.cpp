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
#include "support/topological_sort.h"
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
  // benefit is minor. That is useful for testing.
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

    // Do a toplogical sort to ensure we keep dependencies before the things
    // that need them. For example, if $b's definition depends on $a then $b
    // must appear later:
    //
    //   (global $a i32 (i32.const 10))
    //   (global $b i32 (global.get $a)) ;; $b depends on $a
    //
    struct DependencySort : TopologicalSort<Name, DependencySort> {
      Module& wasm;
      const NameCountMap& counts;

      std::unordered_map<Name, std::vector<Name>> deps;

      DependencySort(Module& wasm, const NameCountMap& counts)
        : wasm(wasm), counts(counts) {
        // Sort a list of global names by their counts.
        auto sort = [&](std::vector<Name>& globals) {
          std::stable_sort(
            globals.begin(), globals.end(), [&](const Name& a, const Name& b) {
              return counts.at(a) < counts.at(b);
            });
        };

        // Sort the globals.
        std::vector<Name> sortedNames;
        for (auto& global : wasm.globals) {
          sortedNames.push_back(global->name);
        }
        sort(sortedNames);

        // Everything is a root (we need to emit all globals).
        for (auto global : sortedNames) {
          push(global);
        }

        // The dependencies are the globals referred to.
        for (auto& global : wasm.globals) {
          if (global->imported()) {
            continue;
          }
          std::vector<Name> vec;
          for (auto* get : FindAll<GlobalGet>(global->init).list) {
            vec.push_back(get->name);
          }
          sort(vec);
          deps[global->name] = std::move(vec);
        }
      }

      void pushPredecessors(Name global) {
        for (auto pred : deps[global]) {
          push(pred);
        }
      }
    };

    std::unordered_map<Name, Index> sortedIndexes;
    for (auto global : DependencySort(*module, counts)) {
      auto index = sortedIndexes.size();
      sortedIndexes[global] = index;
    }

    std::sort(
      module->globals.begin(),
      module->globals.end(),
      [&](const std::unique_ptr<Global>& a, const std::unique_ptr<Global>& b) {
        return sortedIndexes[a->name] < sortedIndexes[b->name];
      });

    module->updateMaps();
  }
};

Pass* createReorderGlobalsPass() { return new ReorderGlobals(false); }

Pass* createReorderGlobalsAlwaysPass() { return new ReorderGlobals(true); }

} // namespace wasm
