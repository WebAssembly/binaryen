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
// Embed Wasm binaries into a JS file, or extract embedded Wasm binaries from a
// JS file.
//

#include <iostream>
#include <string>
#include <vector>

#include "parsing.h"
#include "pass.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/js-embedded-module.h"
#include "support/utilities.h"
#include "wasm-io.h"
#include "wasm-validator.h"

using namespace wasm;

int main(int argc, const char* argv[]) {
  const std::string WasmEmbedOption = "wasm-embed options";

  bool extract = false;
  std::string output;
  std::vector<std::string> positionals;

  Options options(
    "wasm-embed",
    "Embed Wasm binaries into a JS file, or extract embedded Wasm binaries "
    "from a JS file");
  options
    .add("--extract",
         "-e",
         "Extract embedded Wasm modules from the input JS file into "
         "<output>.0.wasm, <output>.1.wasm, ...",
         WasmEmbedOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { extract = true; })
    .add("--output",
         "-o",
         "Output JS file (or output prefix when --extract is used)",
         WasmEmbedOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& argument) { output = argument; })
    .add_positional("INFILE.js [WASM_FILES...] [OUTFILE]",
                    Options::Arguments::N,
                    [&](Options* o, const std::string& argument) {
                      positionals.push_back(argument);
                    });
  options.parse(argc, argv);

  if (extract) {
    std::string inJsFile;
    if (output.empty()) {
      if (positionals.size() != 2) {
        Fatal() << "Expected input JS file and output prefix";
      }
      inJsFile = positionals[0];
      output = positionals[1];
    } else {
      if (positionals.size() != 1) {
        Fatal() << "Expected a single input JS file when --output is specified";
      }
      inJsFile = positionals[0];
    }

    auto js = read_file<std::string>(inJsFile, Flags::Text);
    auto modules = findEmbeddedModules(js);
    for (size_t i = 0; i < modules.size(); ++i) {
      write_file(output + "." + std::to_string(i) + ".wasm", modules[i].bytes);
    }
    flush_and_quick_exit(0);
  }

  std::string inJsFile;
  std::vector<std::string> wasmFiles;
  if (output.empty()) {
    if (positionals.size() < 2) {
      Fatal() << "Expected input JS file, wasm files, and output JS file";
    }
    inJsFile = positionals.front();
    output = positionals.back();
    wasmFiles.assign(positionals.begin() + 1, positionals.end() - 1);
  } else {
    if (positionals.empty()) {
      Fatal() << "Expected input JS file";
    }
    inJsFile = positionals.front();
    wasmFiles.assign(positionals.begin() + 1, positionals.end());
  }

  auto js = read_file<std::string>(inJsFile, Flags::Text);
  auto existing = findEmbeddedModules(js);
  if (existing.size() != wasmFiles.size()) {
    Fatal() << "Number of embedded wasm modules in " << inJsFile << " ("
            << existing.size()
            << ") does not match number of provided wasm files ("
            << wasmFiles.size() << ")";
  }

  for (size_t i = existing.size(); i > 0; --i) {
    const auto& mod = existing[i - 1];
    const auto& wasmFile = wasmFiles[i - 1];
    auto bytes = read_file<std::vector<char>>(wasmFile, Flags::Binary);
    bool isBinary = bytes.size() >= 4 && bytes[0] == '\0' && bytes[1] == 'a' &&
                    bytes[2] == 's' && bytes[3] == 'm';

    Module wasm;
    wasm.features = FeatureSet::All;
    try {
      ModuleReader().readData(bytes, wasm);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      std::cerr << '\n';
      Fatal() << "error parsing wasm (" << wasmFile << ")";
    }

    if (!WasmValidator().validate(wasm)) {
      Fatal() << "error validating module (" << wasmFile << ")";
    }

    if (!isBinary) {
      PassOptions passOptions;
      ModuleWriter writer(passOptions);
      writer.setBinary(true);
      writer.write(wasm, bytes);
    }

    js.replace(mod.start, mod.end - mod.start, formatByteArray(bytes));
  }

  write_file(output, js);
  flush_and_quick_exit(0);
}
