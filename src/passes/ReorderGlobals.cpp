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
    if (always || module->globals.size() < 128) {
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

    // To sort, we must first find dependencies, since if $b's definition
    // depends on $a then $b must appear later:
    //
    //   (global $a i32 (i32.const 10))
    //   (global $b i32 (global.get $a)) ;; $b depends on $a
    //
    // To compute this we fill out a map of each global name to the set of
    // other globals it depends on, then compute the transitive closure.
    std::unordered_map<Name, std::unordered_set<Name>> dependsOn;
    for (auto& global : module->globals) {
      if (global->imported()) {
        continue;
      }
      for (auto get : FindAll<GlobalGet>(global->init).list) {
        dependsOn[global->name].insert(get->name);
      }
    }
    while (true) {
      // Compute the transitive closure in a simple but inefficient way. Long
      // chains of deps are very rare, so this should be good enough.
      bool more = false;

      // Transitive property: If curr depends on dep, and dep depends on dep2,
      // then curr depends on dep2.
      for (auto& [curr, currDeps] : dependsOn) {
        auto currDepsCopy = currDeps;
        for (auto dep : currDepsCopy) {
          // Chains are impossible.
          assert(dep != curr);

          for (auto dep2 : dependsOn[dep]) {
            // Chains are impossible.
            assert(dep2 != dep && dep2 != curr);

            if (!currDepsCopy.count(dep2)) {
              currDeps.insert(dep2);
              more = true;
            }
          }
        }
      }
      if (!more) {
        break;
      }
    }

    // Sort.
    std::sort(module->globals.begin(),
              module->globals.end(),
              [&](const std::unique_ptr<Global>& a,
                  const std::unique_ptr<Global>& b) -> bool {
                // If one depends on the other, the other must be first.
                if (dependsOn[a->name].count(b->name)) {
                  return false;
                }
                if (dependsOn[b->name].count(a->name)) {
                  return true;
                }

                // Break ties by the name.
                if (counts[a->name] == counts[b->name]) {
                  return a->name.toString().compare(b->name.toString()) > 0;
                }

                return counts[a->name] > counts[b->name];
              });
  }
};

Pass* createReorderGlobalsPass() { return new ReorderGlobals(false); }

Pass* createReorderGlobalsAlwaysPass() { return new ReorderGlobals(true); }

} // namespace wasm
