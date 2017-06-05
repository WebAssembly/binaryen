/*
 * Copyright 2015 WebAssembly Community Group participants
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
// wasm2asm console tool
//

#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "s2wasm.h"
#include "wasm-emscripten.h"
#include "wasm-linker.h"
#include "wasm-printing.h"
#include "wasm-validator.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  bool ignoreUnknownSymbols = false;
  bool generateEmscriptenGlue = false;
  bool allowMemoryGrowth = false;
  bool importMemory = false;
  std::string startFunction;
  std::vector<std::string> archiveLibraries;
  Options options("s2wasm", "Link .s file into .wast");
  options.extra["validate"] = "wasm";
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--ignore-unknown", "", "Ignore unknown symbols",
           Options::Arguments::Zero,
           [&ignoreUnknownSymbols](Options *, const std::string &) {
             ignoreUnknownSymbols = true;
           })
      .add("--start", "", "Generate the start method (default: main)",
           Options::Arguments::Optional,
           [&startFunction](Options *, const std::string &argument) {
             startFunction = argument.size() ? argument : "main";
           })
      .add("--global-base", "-g", "Where to start to place globals",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["global-base"] = argument;
           })
      .add("--allocate-stack", "-s", "Size of the user stack in linear memory",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["stack-allocation"] = argument;
           })
      .add("--initial-memory", "-i", "Initial size of the linear memory",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["initial-memory"] = argument;
           })
      .add("--max-memory", "-m", "Maximum size of the linear memory",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["max-memory"] = argument;
           })
      .add("--allow-memory-growth", "", "Allow linear memory to grow at runtime",
           Options::Arguments::Zero,
           [&allowMemoryGrowth](Options *, const std::string &) {
             allowMemoryGrowth = true;
           })
      .add("--emscripten-glue", "-e", "Generate emscripten glue",
           Options::Arguments::Zero,
           [&generateEmscriptenGlue](Options *, const std::string &) {
             generateEmscriptenGlue = true;
           })
      .add("--import-memory", "", "Import the linear memory instead of exporting it",
           Options::Arguments::Zero,
           [&importMemory](Options *, const std::string &) {
             importMemory = true;
           })
      .add("--library", "-l", "Add archive library",
           Options::Arguments::N,
           [&archiveLibraries](Options *o, const std::string &argument) {
             archiveLibraries.push_back(argument);
           })
      .add("--validate", "-v", "Control validation of the output module",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             if (argument != "web" && argument != "none" && argument != "wasm") {
               std::cerr << "Valid arguments for --validate flag are 'wasm', 'web' and 'none'.\n";
               exit(1);
             }
             o->extra["validate"] = argument;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string &argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  if (allowMemoryGrowth && !generateEmscriptenGlue) {
    Fatal() << "Error: adding memory growth code without Emscripten glue. "
      "This doesn't do anything.\n";
  }

  auto debugFlag = options.debug ? Flags::Debug : Flags::Release;
  auto input(read_file<std::string>(options.extra["infile"], Flags::Text, debugFlag));

  if (options.debug) std::cerr << "Parsing and wasming..." << std::endl;
  uint64_t globalBase = options.extra.find("global-base") != options.extra.end()
                          ? std::stoull(options.extra["global-base"])
                          : 0;
  uint64_t stackAllocation =
      options.extra.find("stack-allocation") != options.extra.end()
          ? std::stoull(options.extra["stack-allocation"])
          : 0;
  uint64_t initialMem =
      options.extra.find("initial-memory") != options.extra.end()
          ? std::stoull(options.extra["initial-memory"])
          : 0;
  uint64_t maxMem =
      options.extra.find("max-memory") != options.extra.end()
          ? std::stoull(options.extra["max-memory"])
          : 0;
  if (options.debug) std::cerr << "Global base " << globalBase << '\n';

  Linker linker(globalBase, stackAllocation, initialMem, maxMem,
                importMemory || generateEmscriptenGlue, ignoreUnknownSymbols, startFunction,
                options.debug);

  S2WasmBuilder mainbuilder(input.c_str(), options.debug);
  linker.linkObject(mainbuilder);

  for (const auto& m : archiveLibraries) {
    auto archiveFile(read_file<std::vector<char>>(m, Flags::Binary, debugFlag));
    bool error;
    Archive lib(archiveFile, error);
    if (error) Fatal() << "Error opening archive " << m << "\n";
    linker.linkArchive(lib);
  }

  if (generateEmscriptenGlue) {
    emscripten::generateRuntimeFunctions(linker.getOutput());
  }

  linker.layout();

  std::stringstream meta;
  if (generateEmscriptenGlue) {
    if (options.debug) std::cerr << "Emscripten gluing..." << std::endl;
    if (allowMemoryGrowth) {
      emscripten::generateMemoryGrowthFunction(linker.getOutput().wasm);
    }

    // dyncall thunks
    linker.emscriptenGlue(meta);
  }

  if (options.extra["validate"] != "none") {
    if (options.debug) std::cerr << "Validating..." << std::endl;
    if (!wasm::WasmValidator().validate(linker.getOutput().wasm,
        options.extra["validate"] == "web")) {
      Fatal() << "Error: linked module is not valid.\n";
    }
  }

  if (options.debug) std::cerr << "Printing..." << std::endl;
  Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  WasmPrinter::printModule(&linker.getOutput().wasm, output.getStream());
  output << meta.str();

  if (options.debug) std::cerr << "Done." << std::endl;
  return 0;
}
