/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Applies @binaryen.noreturn to relevant functions. The OptimizeNoReturn pass
// can then use that information.
//
// This pass is not run by default, as then the annotations would persist if the
// user forgets to strip them.
//

#include "ir/lubs.h"
#include "ir/module-utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

struct MarkNoReturn : public WalkerPass<PostWalker<MarkNoReturn>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<MarkNoReturn>();
  }

  void doWalkFunction(Function* func) {
    auto* module = getModule();
    if (!LUB::getResultsLUB(func, *module).noted()) {
      func->funcAnnotations.noReturn = true;
    }
  }
};

Pass* createMarkNoReturnPass() { return new MarkNoReturn(); }

} // namespace wasm
