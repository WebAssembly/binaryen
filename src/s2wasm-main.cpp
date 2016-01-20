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

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  Options options("s2wasm", "Link .s file into .wast");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--global-base", "-g", "Where to start to place globals",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["global-base"] = argument;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string &argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  auto input(read_file<std::string>(options.extra["infile"], options.debug));

  if (options.debug) std::cerr << "Parsing and wasming..." << std::endl;
  AllocatingModule wasm;
  size_t globalBase = options.extra.find("global-base") != options.extra.end()
                          ? std::stoull(options.extra["global-base"])
                          : 1;
  if (options.debug) std::cerr << "Global base " << globalBase << '\n';
  S2WasmBuilder s2wasm(wasm, input.c_str(), options.debug, globalBase);

  if (options.debug) std::cerr << "Emscripten gluing..." << std::endl;
  std::stringstream meta;
  s2wasm.emscriptenGlue(meta);

  if (options.debug) std::cerr << "Printing..." << std::endl;
  Output output(options.extra["output"], options.debug);
  output << wasm << meta.str() << std::endl;

  if (options.debug) std::cerr << "Done." << std::endl;
}
