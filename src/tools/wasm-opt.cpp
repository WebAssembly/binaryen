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

//
// A WebAssembly optimizer, loads code, optionally runs passes on it,
// then writes it.
//

#include <memory>

#include "pass.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-printing.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"

using namespace wasm;

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::vector<std::string> passes;
  PassOptions passOptions;

  Options options("wasm-opt", "Optimize .wast files");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("", "-O", "execute default optimization passes",
           Options::Arguments::Zero,
           [&passes, &passOptions](Options*, const std::string&) {
             passOptions.setDefaultOptimizationOptions();
             passes.push_back("O");
           })
      .add("", "-Os", "execute default optimization passes, focusing on code size",
           Options::Arguments::Zero,
           [&passes, &passOptions](Options*, const std::string&) {
             passOptions.setDefaultOptimizationOptions();
             passOptions.shrinkLevel = 1;
             passes.push_back("O");
           })
      .add("--shrink-level", "-s", "How much to focus on shrinking code size",
           Options::Arguments::One,
           [&passOptions](Options* o, const std::string& argument) {
             passOptions.shrinkLevel = atoi(argument.c_str());
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options* o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  for (const auto& p : PassRegistry::get()->getRegisteredNames()) {
    options.add(
        std::string("--") + p, "", PassRegistry::get()->getPassDescription(p),
        Options::Arguments::Zero,
        [&passes, p](Options*, const std::string&) { passes.push_back(p); });
  }
  options.parse(argc, argv);

  auto input(read_file<std::string>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));

  Module wasm;

  try {
    if (options.debug) std::cerr << "s-parsing..." << std::endl;
    SExpressionParser parser(const_cast<char*>(input.c_str()));
    Element& root = *parser.root;
    if (options.debug) std::cerr << "w-parsing..." << std::endl;
    SExpressionWasmBuilder builder(wasm, *root[0]);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing input";
  }

  if (!WasmValidator().validate(wasm)) {
    Fatal() << "error in validating input";
  }

  if (passes.size() > 0) {
    if (options.debug) std::cerr << "running passes...\n";
    PassRunner passRunner(&wasm, passOptions);
    if (options.debug) passRunner.setDebug(true);
    for (auto& passName : passes) {
      if (passName == "O") {
        passRunner.addDefaultOptimizationPasses();
      } else {
        passRunner.add(passName);
      }
    }
    passRunner.run();
    assert(WasmValidator().validate(wasm));
  }

  if (options.extra.count("output") > 0) {
    if (options.debug) std::cerr << "writing..." << std::endl;
    Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
    WasmPrinter::printModule(&wasm, output.getStream());
  }
}
