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

// Removes code from all functions but one, leaving a valid module
// with (mostly) just the code you want to debug (function-parallel,
// non-lto) passes on.

#include "wasm.h"
#include "pass.h"

namespace wasm {


struct ExtractFunction : public Pass {
  void run(PassRunner* runner, Module* module) override {
    auto* leave = getenv("BINARYEN_EXTRACT");
    if (!leave) {
      std::cerr << "usage: set BINARYEN_EXTRACT in the env\n";
      abort();
    }
    Name LEAVE(leave);
    std::cerr << "extracting " << LEAVE << "\n";
    bool found = false;
    for (auto& func : module->functions) {
      if (func->name != LEAVE) {
        // wipe out all the contents
        func->vars.clear();
        func->body = module->allocator.alloc<Unreachable>();
      } else {
        found = true;
      }
    }
    if (!found) {
      std::cerr << "could not find the function to extract\n";
      abort();
    }
    // clear data
    module->memory.segments.clear();
    module->table.segments.clear();
    // leave just an export for the thing we want
    module->exports.clear();
    auto* export_ = new Export;
    export_->name = LEAVE;
    export_->value = LEAVE;
    export_->kind = ExternalKind::Function;
    module->addExport(export_);
  }
};

// declare pass

Pass *createExtractFunctionPass() {
  return new ExtractFunction();
}

} // namespace wasm

