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
// Sorts functions by their static use count. This helps reduce the size of wasm
// binaries because fewer bytes are needed to encode references to frequently
// used functions.
//
// This may incur a tradeoff, though, as while it reduces binary size, it may
// increase gzip size. This might be because the new order has the functions in
// a less beneficial position for compression, that is, mutually-compressible
// functions are no longer together (when they were before, in the original order,
// the has some natural tendency one way or the other). TODO: investigate
// similarity ordering here.
//


#include <memory>

#include <wasm.h>
#include <pass.h>

namespace wasm {

typedef std::unordered_map<Name, std::atomic<Index>> NameCountMap;

struct CallCountScanner : public WalkerPass<PostWalker<CallCountScanner>> {
  bool isFunctionParallel() override { return true; }

  CallCountScanner(NameCountMap* counts) : counts(counts) {}

  CallCountScanner* create() override {
    return new CallCountScanner(counts);
  }

  void visitCall(Call* curr) {
    assert(counts->count(curr->target) > 0); // can't add a new element in parallel
    (*counts)[curr->target]++;
  }

private:
  NameCountMap* counts;
};

struct ReorderFunctions : public Pass {
  void run(PassRunner* runner, Module* module) override {
    NameCountMap counts;
    // fill in info, as we operate on it in parallel (each function to its own entry)
    for (auto& func : module->functions) {
      counts[func->name];
    }
    // find counts on function calls
    {
      PassRunner runner(module);
      runner.setIsNested(true);
      runner.add<CallCountScanner>(&counts);
      runner.run();
    }
    // find counts on global usages
    if (module->start.is()) {
      counts[module->start]++;
    }
    for (auto& curr : module->exports) {
      counts[curr->value]++;
    }
    for (auto& segment : module->table.segments) {
      for (auto& curr : segment.data) {
        counts[curr]++;
      }
    }
    // sort
    std::sort(module->functions.begin(), module->functions.end(), [&counts](
      const std::unique_ptr<Function>& a,
      const std::unique_ptr<Function>& b) -> bool {
      if (counts[a->name] == counts[b->name]) {
        return strcmp(a->name.str, b->name.str) > 0;
      }
      return counts[a->name] > counts[b->name];
    });
  }
};

Pass *createReorderFunctionsPass() {
  return new ReorderFunctions();
}

} // namespace wasm
