/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Optimize combinations of instructions
//

#include <algorithm>

#include <wasm.h>
#include <pass.h>

namespace wasm {

struct OptimizeInstructions : public WalkerPass<WasmWalker<OptimizeInstructions>> {
  void visitIf(If* curr) {
    // flip branches to get rid of an i32.eqz
    if (curr->ifFalse) {
      auto condition = curr->condition->dyn_cast<Unary>();
      if (condition && condition->op == EqZ && condition->value->type == i32) {
        curr->condition = condition->value;
        std::swap(curr->ifTrue, curr->ifFalse);
      }
    }
  }
};

static RegisterPass<OptimizeInstructions> registerPass("optimize-instructions", "optimizes instruction combinations");

} // namespace wasm
