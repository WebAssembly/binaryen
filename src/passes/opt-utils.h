/*
 * Copyright 2018 WebAssembly Community Group participants
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

#ifndef wasm_passes_opt_utils_h
#define wasm_passes_opt_utils_h

#include <unordered_set>

#include <pass.h>
#include <wasm.h>

namespace wasm {

namespace OptUtils {

// Run useful optimizations after inlining new code into a set
// of functions.
inline void optimizeAfterInlining(std::unordered_set<Function*>& funcs,
                                  Module* module,
                                  PassRunner* parentRunner) {
  // save the full list of functions on the side
  std::vector<std::unique_ptr<Function>> all;
  all.swap(module->functions);
  module->updateMaps();
  for (auto& func : funcs) {
    module->addFunction(func);
  }
  PassRunner runner(module, parentRunner->options);
  runner.setIsNested(true);
  runner.setValidateGlobally(false); // not a full valid module
  // this is especially useful after inlining
  runner.add("precompute-propagate");
  runner.addDefaultFunctionOptimizationPasses(); // do all the usual stuff
  runner.run();
  // restore all the funcs
  for (auto& func : module->functions) {
    func.release();
  }
  all.swap(module->functions);
  module->updateMaps();
}

struct CallTargetReplacer : public WalkerPass<PostWalker<CallTargetReplacer>> {
  bool isFunctionParallel() override { return true; }

  CallTargetReplacer(std::map<Name, Name>* replacements)
    : replacements(replacements) {}

  CallTargetReplacer* create() override {
    return new CallTargetReplacer(replacements);
  }

  void visitCall(Call* curr) {
    auto iter = replacements->find(curr->target);
    if (iter != replacements->end()) {
      curr->target = iter->second;
    }
  }

private:
  std::map<Name, Name>* replacements;
};

inline void replaceFunctions(PassRunner* runner,
                             Module& module,
                             std::map<Name, Name>& replacements) {
  // replace direct calls
  CallTargetReplacer(&replacements).run(runner, &module);
  // replace in table
  for (auto& segment : module.table.segments) {
    for (auto& name : segment.data) {
      auto iter = replacements.find(name);
      if (iter != replacements.end()) {
        name = iter->second;
      }
    }
  }
  // replace in start
  if (module.start.is()) {
    auto iter = replacements.find(module.start);
    if (iter != replacements.end()) {
      module.start = iter->second;
    }
  }
  // replace in exports
  for (auto& exp : module.exports) {
    auto iter = replacements.find(exp->value);
    if (iter != replacements.end()) {
      exp->value = iter->second;
    }
  }
}

} // namespace OptUtils
} // namespace wasm

#endif // wasm_passes_opt_utils_h
