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

  // Scan the body and look at the returns.
  struct Finder : public PostWalker<Finder> {
    Module& wasm;
    LUBFinder& lub;

    Finder(Module& wasm, LUBFinder& lub) : wasm(wasm), lub(lub) {}

    void visitReturn(Return* curr) { lub.note(curr->value->type); }
    void visitCall(Call* curr) {
      if (curr->isReturn) {
        lub.note(wasm.getFunction(curr->target)->getResults());
      }
    }
    void visitCallIndirect(CallIndirect* curr) {
      if (curr->isReturn) {
        lub.note(curr->heapType.getSignature().results);
      }
    }
    void visitCallRef(CallRef* curr) {
      if (curr->isReturn) {
        auto targetType = curr->target->type;
        // We can skip unreachable code and calls to bottom types, as both trap.
        if (targetType == Type::unreachable) {
          return;
        }
        auto targetHeapType = targetType.getHeapType();
        if (targetHeapType.isBottom()) {
          return;
        }
        lub.note(targetHeapType.getSignature().results);
      }
    }
  } finder(wasm, lub);
  finder.walk(func->body);

  return lub;
}

} // namespace LUB

} // namespace wasm
