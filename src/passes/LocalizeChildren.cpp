/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include "ir/localize.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

struct LocalizeChildren : public WalkerPass<PostWalker<LocalizeChildren>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<LocalizeChildren>();
  }

  // TODO add other things that might benefit
  void visitBinary(Expression* curr) {
    ChildLocalizer localizer(curr, getFunction(), *getModule(), getPassOptions());
    auto* rep = localizer.getReplacement();
    if (rep != curr) {
      replaceCurrent(rep);
    }
  }
};

Pass* createLocalizeChildrenPass() { return new LocalizeChildren(); }

} // namespace wasm
