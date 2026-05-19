/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "ir/intrinsics.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "wasm-builder.h"

namespace wasm {

static Name BinaryenIntrinsicsModule("binaryen-intrinsics"),
  CallWithoutEffects("call.without.effects"),
  JSPrototypesModule("wasm:js-prototypes"), ConfigureAll("configureAll");

bool Intrinsics::isCallWithoutEffects(Function* func) {
  if (func->module != BinaryenIntrinsicsModule) {
    return false;
  }
  if (func->base == CallWithoutEffects) {
    return true;
  }
  Fatal() << "Unrecognized intrinsic";
}

Call* Intrinsics::isCallWithoutEffects(Expression* curr) {
  if (auto* call = curr->dynCast<Call>()) {
    // The target function may not exist if the module is still being
    // constructed.
    if (auto* func = module.getFunctionOrNull(call->target)) {
      if (isCallWithoutEffects(func)) {
        return call;
      }
    }
  }
  return nullptr;
}

bool Intrinsics::isConfigureAll(Function* func) {
  return func->module == JSPrototypesModule && func->base == ConfigureAll;
}

Call* Intrinsics::isConfigureAll(Expression* curr) {
  if (auto* call = curr->dynCast<Call>()) {
    if (auto* func = module.getFunctionOrNull(call->target)) {
      if (isConfigureAll(func)) {
        return call;
      }
    }
  }
  return nullptr;
}

std::vector<Name> Intrinsics::getConfigureAllFunctions(Call* call) {
  assert(isConfigureAll(call));

  auto error = [&](const char* msg) {
    Fatal() << "Invalid configureAll( " << msg << "): " << *call;
  };

  // The second operand is an array of signature-called function refs.
  auto& operands = call->operands;
  if (operands.size() <= 2) {
    error("insufficient operands");
  }
  auto* arrayNew = operands[1]->dynCast<ArrayNewElem>();
  if (!arrayNew) {
    error("not array.new_elem");
  }
  auto start = arrayNew->offset->dynCast<Const>();
  if (!start || start->value.geti32() != 0) {
    error("start != 0");
  }
  auto size = arrayNew->size->dynCast<Const>();
  if (!size) {
    error("size not const");
  }
  auto* seg = module.getElementSegment(arrayNew->segment);
  if (seg->data.size() != size->value.getUnsigned()) {
    error("wrong seg size");
  }
  std::vector<Name> ret;
  for (auto* curr : seg->data) {
    if (auto* refFunc = curr->dynCast<RefFunc>()) {
      ret.push_back(refFunc->func);
    } else {
      error("non-function ref");
    }
  }
  return ret;
}

std::vector<Name> Intrinsics::getJSCalledFunctions() {
  using JSCalledSet = std::unordered_set<Name>;

  // Gather the js.called functions, and find the configureAll, which can add
  // more.
  JSCalledSet jsCalled;
  Function* configureAll = nullptr;
  for (auto& func : module.functions) {
    if (getAnnotations(func.get()).jsCalled) {
      jsCalled.insert(func->name);
    }

    if (isConfigureAll(func.get())) {
      configureAll = func.get();
    }
  }

  // ConfigureAlls make their functions callable. To avoid always scanning the
  // the entire module, only do so when we saw the proper import.
  if (configureAll) {
    ModuleUtils::ParallelFunctionAnalysis<JSCalledSet> analysis(
      module, [&](Function* func, JSCalledSet& jsCalled) {
        if (func->imported()) {
          return;
        }

        FindAll<Call> calls(func->body);
        for (auto* call : calls.list) {
          if (isConfigureAll(call)) {
            for (auto name : getConfigureAllFunctions(call)) {
              jsCalled.insert(name);
            }
          }
        }
      });

    for (auto& [_, set] : analysis.map) {
      jsCalled.insert(set.begin(), set.end());
    }
  }

  // Return the set as a sorted vector to avoid nondeterminism.
  std::vector<Name> ret(jsCalled.begin(), jsCalled.end());
  std::sort(ret.begin(), ret.end());
  return ret;
}

} // namespace wasm
