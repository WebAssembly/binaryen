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

namespace wasm::Properties {

bool isGenerative(Expression* curr, FeatureSet features) {
  // Practically no wasm instructions are generative. Exceptions occur only in
  // GC atm.
  if (!features.hasGC()) {
    return false;
  }

  struct Scanner : public PostWalker<Scanner> {
    bool generative = false;
    void visitStructNew(StructNew* curr) { generative = true; }
    void visitArrayNew(ArrayNew* curr) { generative = true; }
    void visitArrayInit(ArrayInit* curr) { generative = true; }
  } scanner;
  scanner.walk(curr);
  return scanner.generative;
}

} // namespace wasm::Properties
