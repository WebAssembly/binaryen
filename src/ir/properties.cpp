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

#include "ir/properties.h"
#include "wasm-traversal.h"

namespace wasm {

namespace Properties {

bool isObservablyDeterministic(Expression* curr, FeatureSet features) {
  // Practically all wasm instructions are observably-deterministic. Exceptions
  // occur only in GC atm.
  if (!features.hasGC()) {
    return true;
  }

  struct Scanner : public PostWalker<Scanner> {
    bool deterministic = true;
    void visitCall(Call* curr) { deterministic = false; }
    void visitCallIndirect(CallIndirect* curr) { deterministic = false; }
    void visitCallRef(CallRef* curr) { deterministic = false; }
    void visitStructNew(StructNew* curr) { deterministic = false; }
    void visitArrayNew(ArrayNew* curr) { deterministic = false; }
  } scanner;
  scanner.walk(curr);
  return scanner.deterministic;
}

} // namespace Properties

} // namespace wasm
