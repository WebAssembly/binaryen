/*
 * Copyright 2020 WebAssembly Community Group participants
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
// Forces all loads and stores to be completely unaligned, that is, to have
// alignment 1.
//

#include "pass.h"
#include "wasm.h"

namespace wasm {

struct DeAlign : public WalkerPass<PostWalker<DeAlign>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<DeAlign>();
  }

  void visitLoad(Load* curr) { curr->align = 1; }

  void visitStore(Store* curr) { curr->align = 1; }

  void visitSIMDLoad(SIMDLoad* curr) { curr->align = 1; }
};

Pass* createDeAlignPass() { return new DeAlign(); }

} // namespace wasm
