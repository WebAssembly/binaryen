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
#include "wasm-builder.h"

namespace wasm {

static Name BinaryenIntrinsicsModule("binaryen-intrinsics"),
  CallWithoutEffects("call.without.effects"),
  JSPrototypesModule("wasm:js-prototypes"),
  ConfigureAll("configureAll");

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
  if (func->module != JSPrototypesModule) {
    return false;
  }
  if (func->base == ConfigureAll) {
    return true;
  }
  Fatal() << "Unrecognized intrinsic";
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
  assert(isConfigureAll(curr));

  auto error = [&](const char* msg) {
    Fatal() << "Invalid configureAll( " << msg << "): " << *curr;
  };

  // The second operand is an array of signature-called function refs.
  auto& operands = call->operands;
  if (operands.size() <= 2) {
    error("insufficient operands");
  }
  auto* arrayNew = operands[1]->dynCast<ArrayNewElem>();
  if (!arrayNew) {
    error("not array.new");
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
  if (seg->data.size() != size->value.geti32()) {
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

} // namespace wasm
