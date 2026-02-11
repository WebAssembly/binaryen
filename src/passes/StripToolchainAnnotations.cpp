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
// Removes toolchain-specific annotations from the IR. Typically this should be
// done after toolchain optimizations no longer need the annotations, and before
// shipping the final wasm (VMs do not need these toolchain annotations).
//

#include "pass.h"
#include "wasm-binary.h"
#include "wasm.h"

namespace wasm {

struct StripToolchainAnnotations : public WalkerPass<PostWalker<StripToolchainAnnotations>> {
  bool isFunctionParallel() override { return true; }

  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override { return std::make_unique<StripToolchainAnnotations>(); }

  void doWalkFunction(Function* func) {
    auto& annotations = func->codeAnnotations;
    auto iter = annotations.begin();
    while (iter != annotations.end()) {
      // Remove the toolchain-specific annotations.
      auto& annotation = iter->second;
      annotation.removableIfUnused = false;

      // If nothing remains, remove the entire annotation.
      if (annotation == CodeAnnotation()) {
        iter = annotations.erase(iter);
      } else {
        ++iter;
      }
    }
  }
};

Pass* createStripToolchainAnnotationsPass() {
  return new StripToolchainAnnotations();
}

} // namespace wasm
