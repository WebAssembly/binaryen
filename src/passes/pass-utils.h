/*
 * Copyright 2023 WebAssembly Community Group participants
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

#ifndef wasm_passes_pass_utils_h
#define wasm_passes_pass_utils_h

#include <unordered_set>

#include <pass.h>
#include <wasm.h>

namespace wasm::PassUtils {

using FuncSet = std::unordered_set<Function*>;

// A wrapper around a parallel pass that filters it to run run only on select
// functions.
struct FilteredPass : public Pass {
  std::unique_ptr<Pass> create() override {
    // Function-parallel passes get a new instance per function. Create a copy
    // of the wrapped pass along with ourselves.
    return std::make_unique<FilteredPass>(pass->create(), relevantFuncs);
  }

  FilteredPass(std::unique_ptr<Pass>&& pass, const FuncSet& relevantFuncs)
    : pass(std::move(pass)), relevantFuncs(relevantFuncs) {}

  bool isFunctionParallel() override {
    assert(pass->isFunctionParallel());
    return true;
  }

  void runOnFunction(Module* module, Function* func) override {
    if (!relevantFuncs.count(func)) {
      return;
    }

    // The pass runner calling us set our pass runner, which we must do for the
    // wrapped pass.
    pass->setPassRunner(getPassRunner());
    pass->runOnFunction(module, func);
  }

  bool modifiesBinaryenIR() override { return pass->modifiesBinaryenIR(); }

  bool invalidatesDWARF() override { return pass->invalidatesDWARF(); }

  bool addsEffects() override { return pass->addsEffects(); }

  bool requiresNonNullableLocalFixups() override {
    return pass->requiresNonNullableLocalFixups();
  }

private:
  std::unique_ptr<Pass> pass;
  const FuncSet& relevantFuncs;
};

// A pass runner that wraps all passes, filtering so that they only run on
// select functions.
struct FilteredPassRunner : public PassRunner {
  FilteredPassRunner(Module* wasm, const FuncSet& relevantFuncs)
    : PassRunner(wasm), relevantFuncs(relevantFuncs) {}

  FilteredPassRunner(Module* wasm,
                     const FuncSet& relevantFuncs,
                     const PassOptions& options)
    : PassRunner(wasm, options), relevantFuncs(relevantFuncs) {}

protected:
  void doAdd(std::unique_ptr<Pass> pass) override {
    PassRunner::doAdd(
      std::make_unique<FilteredPass>(std::move(pass), relevantFuncs));
  }

private:
  const FuncSet& relevantFuncs;
};

} // namespace wasm::PassUtils

#endif // wasm_passes_pass_utils_h
