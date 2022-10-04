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

//
// This file contains passes used for internal testing. This file can be used to
// test utility functions separately.
//

#include "ir/eh-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// Pass to test EHUtil::handleBlockNestedPops function
struct CatchPopFixup : public WalkerPass<PostWalker<CatchPopFixup>> {
  bool isFunctionParallel() override { return true; }
  std::unique_ptr<Pass> create() override {
    return std::make_unique<CatchPopFixup>();
  }

  void doWalkFunction(Function* func) {
    EHUtils::handleBlockNestedPops(func, *getModule());
  }
};

} // anonymous namespace

Pass* createCatchPopFixupPass() { return new CatchPopFixup(); }

} // namespace wasm
