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
// TODO measure
//

#include <memory>

#include <ir/element-utils.h>
#include <pass.h>
#include <wasm.h>

namespace wasm {

using NameCountMap = std::unordered_map<Name, std::atomic<Index>>;

struct UseCountScanner : public WalkerPass<PostWalker<UseCountScanner>> {
  bool isFunctionParallel() override { return true; }

  bool modifiesBinaryenIR() override { return false; }

  UseCountScanner(NameCountMap& counts) : counts(counts) {}

  UseCountScanner* create() override { return new UseCountScanner(counts); }

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
  void run(PassRunner* runner, Module* module) override {
    NameCountMap counts;
    // Fill in info, as we'll operate on it in parallel.
    for (auto& global : module->globals) {
      counts[global->name];
    }

    // Count uses.
    UseCountScanner scanner(counts);
    scanner.run(runner, module);
    scanner.runOnModuleCode(runner, module);

    // Sort.
    std::sort(module->globals.begin(),
              module->globals.end(),
              [&counts](const std::unique_ptr<Global>& a,
                        const std::unique_ptr<Global>& b) -> bool {
                // Break ties by the name.
                if (counts[a->name] == counts[b->name]) {
                  return strcmp(a->name.str, b->name.str) > 0;
                }
                return counts[a->name] > counts[b->name];
              });
  }
};

Pass* createReorderGlobalsPass() { return new ReorderGlobals(); }

} // namespace wasm
