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
// When we see a call foo(arg1, arg2) and at least one of the arguments has a
// more refined type than is declared in the function being called, create a
// copy of the function with the refined type. That copy can then potentially be
// optimized in useful ways later.
//
// Inlining also monomorphizes in effect. What this pass does is handle the
// cases where inlining cannot be done.
//
// TODO: Not just direct calls? But updating vtables is complex.
//

#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Monomorphize : public Pass {
  // ???
  // bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    // First, find all the calls.

    struct Info {
      std::vector<Call*> calls;
    };

    ModuleUtils::ParallelFunctionAnalysis<Info> analysis(
      *module, [&](Function* func, Info& info) {
        if (func->imported()) {
          return;
        }
        info.calls = std::move(FindAll<Call>(func->body).list);
      });

    for (auto& [_, info] : analysis.map) {
      for (auto* call : info.calls) {
        if (call->type == Type::unreachable) {
          // Ignore unreachable code.
          // TODO: call_return?
          return;
        }

        call->target = getRefinedTarget(call, module);
      }
    }
  }

  // Given a call, make a copy of the function it is calling that has more
  // refined arguments that fit the arguments being passed perfectly.
  Name getRefinedTarget(Call* call, Module* module) {
    auto target = call->target;
    auto* func = module->getFunction(target);
    if (func->imported()) {
      // Nothing to do since this calls outside of the module.
      return target;
    }
    auto params = func->getParams();
    bool hasRefinedParam = false;
    for (Index i = 0; i < call->operands.size(); i++) {
      if (call->operands[i]->type != params[i]) {
        hasRefinedParam = true;
        break;
      }
    }
    if (!hasRefinedParam) {
      // Nothing to do since all params are fully refined already.
      return target;
    }

    std::vector<Type> refinedTypes;
    for (auto* operand : call->operands) {
      refinedTypes.push_back(operand->type);
    }
    auto refinedParams = Type(refinedTypes);
    auto iter = funcParamMap.find({target, refinedParams});
    if (iter != funcParamMap.end()) {
      return iter->second;
    }

    // This is the first time we see this situation. Let's see if it is worth
    // monomorphizing.

    // Create a new function with refined parameters.
    auto refinedTarget = Names::getValidFunctionName(*module, target);
    auto* refinedFunc = ModuleUtils::copyFunction(func, *module, refinedTarget);
    TypeUpdating::updateParamTypes(refinedFunc, refinedTypes, *module);
    refinedFunc->type = HeapType(Signature(refinedParams, func->getResults()));
    funcParamMap[{target, refinedParams}] = refinedTarget;

    // Optimize both functions.
    doMinimalOpts(func);
    doMinimalOpts(refinedFunc);

    auto costBefore = CostAnalyzer(func->body).cost;
    auto costAfter = CostAnalyzer(refinedFunc->body).cost;
    if (costAfter < costBefore) {
      return refinedTarget;
    }

    // Otherwise, we failed to improve, return the old function name.
    return target;
  }

  void doMinimalOpts(Function* func) {
    PassRunner runner(getPassRunner());
    runner.options.optLevel = 1;
    runner.addDefaultFunctionOptimizationPasses();
    runner.setIsNested(true);
    runner.runOnFunction(func);
  }

  // Maps [func name, param types] to the name of a new function whose params
  // have those types.
  std::unordered_map<std::pair<Name, Type>, Name> funcParamMap;
};

} // anonymous namespace

Pass* createMonomorphizePass() { return new Monomorphize(); }

} // namespace wasm
