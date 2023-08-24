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

#include "ir/debug.h"
#include "ir/iteration.h"
#include "ir/properties.h"

namespace wasm::debug {

void scavengeDebugInfo(Expression* replacement,
                       Expression* original,
                       Function* func,
                       const PassOptions& options,
                       Module& wasm) {
  auto& debug = func->debugLocations;

  // Given an expression, use its debug info if it has any, and return true if
  // so.
  auto useDebugInfo = [&](Expression* expr) {
    auto iter = debug.find(expr);
    if (iter != debug.end()) {
      debug[replacement] = iter->second;
      return true;
    }
    return false;
  };

  // Check if |original| has debug info. If so, that is the best info to use.
  if (useDebugInfo(original)) {
    return;
  }

  // Check if |original| has a fallthrough with debug info. This is often good,
  // as the fallthrough value is what actually is emitted here, e.g.,
  //
  //  (block
  //    (i32.const 42))
  //
  // Debug info on the const can be used in place of the block (e.g. when we
  // optimize away the block).
  auto fallthrough = Properties::getFallthrough(original, options, wasm);
  if (fallthrough != original && useDebugInfo(fallthrough)) {
    return;
  }

  // Failing the above, see if any child has debug info, and use that. This may
  // not always be accurate, but should help much more than it confuses. We at
  // least only look at direct children (as ones farther away may be more
  // confusing).
  // TODO: go expression type by type and decide specifically.
  for (auto* child : ChildIterator(original)) {
    if (useDebugInfo(child)) {
      return;
    }
  }
}

} // namespace wasm::debug
