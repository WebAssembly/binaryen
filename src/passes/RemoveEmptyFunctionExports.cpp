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
// Remove exports of empty defined functions, for runtimes that treat missing
// exports as optional. The functions themselves are left intact; run
// --remove-unused-module-elements afterwards to remove any that become unused.
//

#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

struct RemoveEmptyFunctionExports : public Pass {
  // Only exports are removed, so function contents need no fixups.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    module->removeExports([&](Export* curr) {
      if (curr->kind != ExternalKind::Function) {
        return false;
      }
      const auto* func = module->getFunction(*curr->getInternalName());
      if (func->imported()) {
        return false;
      }
      if (func->body->is<Nop>()) {
        return true;
      }
      if (auto* block = func->body->dynCast<Block>()) {
        return block->list.empty();
      }
      return false;
    });
  }
};

} // anonymous namespace

Pass* createRemoveEmptyFunctionExportsPass() {
  return new RemoveEmptyFunctionExports();
}

} // namespace wasm
