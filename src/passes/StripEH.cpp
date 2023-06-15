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

//
// Remove catch blocks and convert 'throw's into 'unreachable's. Any exception
// thrown will crash the program as they are now traps.
//

#include <ir/drop.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

struct StripEH : public WalkerPass<ExpressionStackWalker<StripEH>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<StripEH>();
  }

  void visitThrow(Throw* curr) {
    auto& wasm = *getModule();
    Builder builder(wasm);
    replaceCurrent(getDroppedChildrenAndAppend(curr,
                                               wasm,
                                               getPassOptions(),
                                               builder.makeUnreachable(),
                                               DropMode::IgnoreParentEffects));
  }

  void visitTry(Try* curr) { replaceCurrent(curr->body); }
};

Pass* createStripEHPass() { return new StripEH(); }

} // namespace wasm
