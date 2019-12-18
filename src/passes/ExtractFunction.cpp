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

#include "pass.h"
#include "wasm.h"

namespace wasm {

struct ExtractFunction : public Pass {
  void run(PassRunner* runner, Module* module) override {
    Name name = runner->options.getArgument(
      "extract",
      "ExtractFunction usage:  wasm-opt --pass-arg=extract@FUNCTION_NAME");
    std::cerr << "extracting " << name << "\n";
    bool found = false;
    for (auto& func : module->functions) {
      if (func->name != name) {
        // Turn it into an import.
        func->module = "env";
        func->base = func->name;
        func->vars.clear();
        func->body = nullptr;
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
    if (!module->getExportOrNull(name)) {
      module->exports.clear();
      auto* export_ = new Export;
      export_->name = name;
      export_->value = name;
      export_->kind = ExternalKind::Function;
      module->addExport(export_);
    }
  }
};

// declare pass

Pass* createExtractFunctionPass() { return new ExtractFunction(); }

} // namespace wasm
