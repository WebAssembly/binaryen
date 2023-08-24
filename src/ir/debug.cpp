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
#include "ir/properties.h"

namespace wasm::debug {

void forageDebugInfo(Expression* curr,
                     Expression* other,
                     Function* func,
                     const PassOptions& options,
                     Module& wasm) {
  auto& debug = func->debugLocations;

  // Check if |other| has debug info.
  auto iter = debug.find(other);
  if (iter != debug.end()) {
    debug[curr] = iter->second;
    return;
  }

  // Check if |other| has a fallthrough with debug info. This is often the right
  // thing, as the fallthrough value is what is actually computed here, e.g.,
  //
  //  (block
  //    (i32.const 42))
  //
  // Debug info on the const can be used in place of the block (e.g. when we
  // optimize away the block).
  auto fallthrough = Properties::getFallthrough(curr, options, wasm);
  iter = debug.find(fallthrough);
  if (iter != debug.end()) {
    debug[curr] = iter->second;
  }

  // TODO: We can look in a more sophisticated manner that depends on what kind
  //       of expression |curr| is.
};

} // namespace wasm::debug
