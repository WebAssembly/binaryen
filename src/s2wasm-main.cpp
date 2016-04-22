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
#include "wasm-linker.h"
#include "wasm-printing.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  bool ignoreUnknownSymbols = false;
  bool generateEmscriptenGlue = false;
  std::string startFunction;
  Options options("s2wasm", "Link .s file into .wast");
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
      .add("--emscripten-glue", "-e", "Generate emscripten glue",
           Options::Arguments::Zero,
           [&generateEmscriptenGlue](Options *, const std::string &) {
             generateEmscriptenGlue = true;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string &argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  auto input(read_file<std::string>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));

  if (options.debug) std::cerr << "Parsing and wasming..." << std::endl;
  Module wasm;
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
  Linker lm(wasm, globalBase, stackAllocation, initialMem, maxMem,
            ignoreUnknownSymbols, startFunction, options.debug);

  S2WasmBuilder s2wasm(wasm, input.c_str(), options.debug, lm);

  std::stringstream meta;
  if (generateEmscriptenGlue) {
    if (options.debug) std::cerr << "Emscripten gluing..." << std::endl;
    // dyncall thunks
    lm.emscriptenGlue(meta);
  }

  if (options.debug) std::cerr << "Printing..." << std::endl;
  Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  WasmPrinter::printModule(&wasm, output.getStream());
  output << meta.str() << std::endl;

  if (options.debug) std::cerr << "Done." << std::endl;
}
