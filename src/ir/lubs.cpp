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

#include "ir/lubs.h"
#include "ir/find_all.h"
#include "ir/utils.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace LUB {

LUBFinder getResultsLUB(Function* func, Module& wasm) {
  LUBFinder lub;

  if (!wasm.features.hasGC()) {
    return lub;
  }

  Type originalType = func->getResults();
  if (!originalType.hasRef()) {
    // Nothing to refine.
    return lub;
  }

  // Before we do anything, we must refinalize the function, because otherwise
  // its body may contain a block with a forced type,
  //
  // (func (result X)
  //  (block (result X)
  //   (..content with more specific type Y..)
  //  )
  ReFinalize().walkFunctionInModule(func, &wasm);

  lub.note(func->body->type);
  if (lub.getLUB() == originalType) {
    return lub;
  }

  // Scan the body and look at the returns. First, return expressions.
  for (auto* ret : FindAll<Return>(func->body).list) {
    lub.note(ret->value->type);
    if (lub.getLUB() == originalType) {
      return lub;
    }
  }

  // Process return_calls and call_refs. Unlike return expressions which we
  // just handled, these only get a type to update, not a value.
  auto processReturnType = [&](Type type) {
    // Return whether we still look ok to do the optimization. If this is
    // false then we can stop here.
    lub.note(type);
    return lub.getLUB() != originalType;
  };

  for (auto* call : FindAll<Call>(func->body).list) {
    if (call->isReturn &&
        !processReturnType(wasm.getFunction(call->target)->getResults())) {
      return lub;
    }
  }
  for (auto* call : FindAll<CallIndirect>(func->body).list) {
    if (call->isReturn &&
        !processReturnType(call->heapType.getSignature().results)) {
      return lub;
    }
  }
  for (auto* call : FindAll<CallRef>(func->body).list) {
    if (call->isReturn) {
      auto targetType = call->target->type;
      // We can skip unreachable code and calls to bottom types, as both trap.
      if (targetType == Type::unreachable) {
        continue;
      }
      auto targetHeapType = targetType.getHeapType();
      if (targetHeapType.isBottom()) {
        continue;
      }
      if (!processReturnType(targetHeapType.getSignature().results)) {
        return lub;
      }
    }
  }

  return lub;
}

} // namespace LUB

} // namespace wasm
