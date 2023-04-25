/*
 * Copyright 2017 WebAssembly Community Group participants
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
// A WebAssembly merger: loads multiple files, mashes them together, and emits
// the result. Unlike wasm-ld, this does not have the full semantics of native
// linkers. Instead, wasm-merge does at compile time what you can do with JS at
// runtime: connect some wasm modules together by hooking up imports to exports.
// The result of wasm-merge is a single module that behaves the same as the
// multiple original modules, but you don't need that JS to set up the
// connections between the modules any more, and DCE and inlining can help
// inside the module, etc. (While JS is mentioned here, this could also be
// helpful with the component model for wasm that is in development.)
//

#include "support/colors.h"
#include "support/file.h"
#include "wasm-io.h"
#include "wasm.h"

#include "tool-options.h"

using namespace wasm;

namespace {

// Merges an input module into an existing target module.
void mergeInto(Module& input, Module& target) {
}

} // anonymous namespace

int main(int argc, const char* argv[]) {
  std::vector<std::string> inputFiles;
  bool emitBinary = true;
  bool debugInfo = false;

  const std::string WasmMergeOption = "wasm-merge options";

  ToolOptions options("wasm-merge",
                      "Merge wasm files into one");
  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         WasmMergeOption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::setEnabled(false);
         })
    .add_positional("INFILES",
                    Options::Arguments::N,
                    [](Options* o, const std::string& argument) {
                      inputFiles.push_back(argument);
                    })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file",
         WasmMetaDCEOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { emitBinary = false; })
    .add("--debuginfo",
         "-g",
         "Emit names section and debug info",
         WasmMetaDCEOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { debugInfo = true; });
  options.parse(argc, argv);

  // The module we'll merge into.
  Module merged;

  // Inputs.

  bool first = true;
  for (auto& input : inputFiles) {
    if (options.debug) {
      std::cerr << "reading input '" << input << "'...\n";
    }
    // For the first input, we'll just read it in directly. For later inputs,
    // we read them and then merge.
    std::unique_ptr<Module> laterInput;
    Module* currModule;
    if (first) {
      currModule = &merged;
      first = false;
    } else {
      laterInput = std::make_unique<Module>();
      currModule = laterInput.get();
    }

    options.applyFeatures(*currModule);

    ModuleReader reader;
    try {
      reader.read(options.extra["infile"], *currModule);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing wasm input";
    }

    if (options.passOptions.validate) {
      if (!WasmValidator().validate(*currModule)) {
        std::cout << *currModule << '\n';
        Fatal() << "error in validating input";
      }
    }

    if (laterInput) {
      mergeInto(*currModule, merged);
    }
  }

  // Output.
  if (options.extra.count("output") > 0) {
    ModuleWriter writer;
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    writer.write(merged, options.extra["output"]);
  }
}
