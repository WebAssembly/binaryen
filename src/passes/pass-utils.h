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

#include <functional>
#include <unordered_set>

#include <ir/element-utils.h>
#include <ir/module-utils.h>
#include <pass.h>
#include <wasm.h>

namespace wasm {

namespace PassUtils {

using FuncSet = std::unordered_set<Function*>;

// A wrapper around a parallel pass that runs that pass only on select
// functions.
struct WrappedPass : public Pass {
  std::unique_ptr<Pass> create() override {
    return std::make_unique<WrappedPass>(pass->create(), funcs);
  }

  WrappedPass(std::unique_ptr<Pass> pass, const FuncSet& funcs)
    : pass(std::move(pass)), funcs(funcs) {}

  bool isFunctionParallel() override { return pass->isFunctionParallel(); }

  void runOnFunction(Module* module, Function* func) override {
    if (!funcs.count(func)) {
      return;
    }
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
  const FuncSet& funcs;
};

// A pass runner that wraps all passes, making them run only in select
// functions.
struct WrappedPassRunner : public PassRunner {
  WrappedPassRunner(Module* wasm, const FuncSet& funcs)
    : PassRunner(wasm), funcs(funcs) {}

protected:
  void doAdd(std::unique_ptr<Pass> pass) override {
    pass->setPassRunner(this);
    PassRunner::doAdd(
      std::make_unique<WrappedPass>(std::move(pass), funcs));
  }

private:
  const FuncSet& funcs;
};

} // namespace PassUtils
} // namespace wasm

#endif // wasm_passes_pass_utils_h
