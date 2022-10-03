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
// Removes duplicate functions. That can happen due to C++ templates,
// and also due to types being different at the source level, but
// identical when finally lowered into concrete wasm code.
//

#include "ir/function-utils.h"
#include "ir/hashed.h"
#include "ir/module-utils.h"
#include "ir/utils.h"
#include "opt-utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

struct DuplicateFunctionElimination : public Pass {
  // FIXME Merge DWARF info
  bool invalidatesDWARF() override { return true; }

  // This pass merges functions but does not alter their contents.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    // Multiple iterations may be necessary: A and B may be identical only after
    // we see the functions C1 and C2 that they call are in fact identical.
    // Rarely, such "chains" can be very long, so we limit how many we do.
    auto& options = getPassOptions();
    Index limit;
    if (options.optimizeLevel >= 3 || options.shrinkLevel >= 1) {
      limit = module->functions.size(); // no limit
    } else if (options.optimizeLevel >= 2) {
      // 10 passes usually does most of the work, as this is typically
      // logarithmic
      limit = 10;
    } else {
      limit = 1;
    }
    while (limit > 0) {
      limit--;
      // Hash all the functions
      auto hashes = FunctionHasher::createMap(module);
      FunctionHasher(&hashes).run(getPassRunner(), module);
      // Find hash-equal groups
      std::map<uint32_t, std::vector<Function*>> hashGroups;
      ModuleUtils::iterDefinedFunctions(*module, [&](Function* func) {
        hashGroups[hashes[func]].push_back(func);
      });
      // Find actually equal functions and prepare to replace them
      std::map<Name, Name> replacements;
      std::set<Name> duplicates;
      for (auto& [_, group] : hashGroups) {
        Index size = group.size();
        if (size == 1) {
          continue;
        }
        // The groups should be fairly small, and even if a group is large we
        // should have almost all of them identical, so we should not hit actual
        // O(N^2) here unless the hash is quite poor.
        for (Index i = 0; i < size - 1; i++) {
          auto* first = group[i];
          if (duplicates.count(first->name)) {
            continue;
          }
          for (Index j = i + 1; j < size; j++) {
            auto* second = group[j];
            if (duplicates.count(second->name)) {
              continue;
            }
            if (FunctionUtils::equal(first, second)) {
              // great, we can replace the second with the first!
              replacements[second->name] = first->name;
              duplicates.insert(second->name);
            }
          }
        }
      }
      // perform replacements
      if (replacements.size() > 0) {
        // remove the duplicates
        module->removeFunctions(
          [&](Function* func) { return duplicates.count(func->name) > 0; });
        OptUtils::replaceFunctions(getPassRunner(), *module, replacements);
      } else {
        break;
      }
    }
  }
};

Pass* createDuplicateFunctionEliminationPass() {
  return new DuplicateFunctionElimination();
}

} // namespace wasm
