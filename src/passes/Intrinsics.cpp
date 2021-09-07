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
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

struct IntrinsicLowering : public WalkerPass<PostWalker<IntrinsicLowering>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new IntrinsicLowering; }

  void visitCall(Call* curr) {
    if (Intrinsics(*getModule()).isCallIfUsed(curr)) {
      // Turn into a call_ref, by using the final operand as the call_ref
      // target.
      auto& operands = curr->operands;
      auto* target = operands.back();
      operands.pop_back();
      replaceCurrent(
        Builder(*getModule()).makeCallRef(target, operands, curr->type));
    }
  }
};

Pass* createIntrinsicLoweringPass() { return new IntrinsicLowering(); }

} // namespace wasm
