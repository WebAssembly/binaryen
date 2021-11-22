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

#include <functional>
#include <unordered_set>

#include <ir/element-utils.h>
#include <ir/module-utils.h>
#include <pass.h>
#include <wasm.h>

namespace wasm {

namespace OptUtils {

// Run useful optimizations after inlining new code into a set
// of functions.
inline void optimizeAfterInlining(const std::unordered_set<Function*>& funcs,
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

struct FunctionRefReplacer
  : public WalkerPass<PostWalker<FunctionRefReplacer>> {
  bool isFunctionParallel() override { return true; }

  using MaybeReplace = std::function<void(Name&)>;

  FunctionRefReplacer(MaybeReplace maybeReplace) : maybeReplace(maybeReplace) {}

  FunctionRefReplacer* create() override {
    return new FunctionRefReplacer(maybeReplace);
  }

  void visitCall(Call* curr) { maybeReplace(curr->target); }

  void visitRefFunc(RefFunc* curr) { maybeReplace(curr->func); }

private:
  MaybeReplace maybeReplace;
};

inline void replaceFunctions(PassRunner* runner,
                             Module& module,
                             const std::map<Name, Name>& replacements) {
  auto maybeReplace = [&](Name& name) {
    auto iter = replacements.find(name);
    if (iter != replacements.end()) {
      name = iter->second;
    }
  };
  // replace direct calls in code both functions and module elements
  FunctionRefReplacer replacer(maybeReplace);
  replacer.run(runner, &module);
  replacer.runOnModuleCode(runner, &module);

  // replace in start
  if (module.start.is()) {
    maybeReplace(module.start);
  }
  // replace in exports
  for (auto& exp : module.exports) {
    if (exp->kind == ExternalKind::Function) {
      maybeReplace(exp->value);
    }
  }
}

} // namespace OptUtils
} // namespace wasm

#endif // wasm_passes_opt_utils_h
