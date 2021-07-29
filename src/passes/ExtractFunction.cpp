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

// Removes code from all functions but one, leaving a valid module with (mostly)
// just the code from that function, as best we can.
//
// This pass will run --remove-unused-module-elements automatically for you, in
// order to remove as many things as possible.

#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

static void extract(PassRunner* runner, Module* module, Name name) {
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
    Fatal() << "could not find the function to extract\n";
  }

  // Leave just one export, for the thing we want.
  module->exports.clear();
  module->updateMaps();
  module->addExport(Builder::makeExport(name, name, ExternalKind::Function));

  // Remove unneeded things.
  PassRunner postRunner(runner);
  postRunner.add("remove-unused-module-elements");
  postRunner.setIsNested(true);
  postRunner.run();
}

struct ExtractFunction : public Pass {
  void run(PassRunner* runner, Module* module) override {
    Name name = runner->options.getArgument(
      "extract-function",
      "ExtractFunction usage:  wasm-opt --extract-function=FUNCTION_NAME");
    extract(runner, module, name);
  }
};

struct ExtractFunctionIndex : public Pass {
  void run(PassRunner* runner, Module* module) override {
    std::string index =
      runner->options.getArgument("extract-function-index",
                                  "ExtractFunctionIndex usage: wasm-opt "
                                  "--extract-function-index=FUNCTION_INDEX");
    for (char c : index) {
      if (!std::isdigit(c)) {
        Fatal() << "Expected numeric function index";
      }
    }
    Index i = std::stoi(index);
    if (i >= module->functions.size()) {
      Fatal() << "Invalid function index";
    }
    // Assumes imports are at the beginning
    Name name = module->functions[std::stoi(index)]->name;
    extract(runner, module, name);
  }
};

// declare passes

Pass* createExtractFunctionPass() { return new ExtractFunction(); }
Pass* createExtractFunctionIndexPass() { return new ExtractFunctionIndex(); }

} // namespace wasm
