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
#include "wasm-io.h"

using namespace wasm;

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::vector<std::string> passes;
  bool runOptimizationPasses = false;
  PassOptions passOptions;
  bool emitBinary = true;
  bool debugInfo = false;

  Options options("wasm-opt", "Optimize .wast files");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      #include "optimization-options.h"
      .add("--emit-text", "-S", "Emit text instead of binary for the output file",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &argument) { emitBinary = false; })
      .add("--debuginfo", "-g", "Emit names section and debug info",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &arguments) { debugInfo = true; })
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

  if (runOptimizationPasses) {
    passes.resize(passes.size() + 1);
    std::move_backward(passes.begin(), passes.begin() + passes.size() - 1, passes.end());
    passes[0] = "O";
  }

  auto input(read_file<std::string>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));

  Module wasm;

  {
    if (options.debug) std::cerr << "reading...\n";
    ModuleReader reader;
    reader.setDebug(options.debug);

    try {
      reader.read(options.extra["infile"], wasm);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      Fatal() << "error in parsing input";
    } catch (std::bad_alloc& b) {
      Fatal() << "error in building module, std::bad_alloc (possibly invalid request for silly amounts of memory)";
    }
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
    ModuleWriter writer;
    writer.setDebug(options.debug);
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    writer.write(wasm, options.extra["output"]);
  }
}
