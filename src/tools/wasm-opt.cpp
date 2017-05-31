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
#include "wasm-interpreter.h"
#include "shell-interface.h"
#include "optimization-options.h"

using namespace wasm;

// gets execution results from a wasm module. this is useful for fuzzing
//
// we can only get results when there are no imports. we then call each method
// that has a result, with some values
struct ExecutionResults {
  std::map<Name, Literal> results;

  void get(Module& wasm) {
    if (wasm.imports.size() > 0) {
      std::cout << "[fuzz-exec] imports, so quitting\n";
      return;
    }
    for (auto& func : wasm.functions) {
      if (func->result != none) {
        // this is good
        results[func->name] = run(func.get(), wasm);
      }
    }
    std::cout << "[fuzz-exec] " << results.size() << " results noted\n";
  }

  bool operator==(ExecutionResults& other) {
    for (auto& iter : results) {
      auto name = iter.first;
      if (other.results.find(name) != other.results.end()) {
        if (results[name] != other.results[name]) {
          return false;
        }
      }
    }
    return true;
  }

  bool operator!=(ExecutionResults& other) {
    return !((*this) == other);
  }

  Literal run(Function* func, Module& wasm) {
    ShellExternalInterface interface;
    try {
      ModuleInstance instance(wasm, &interface);
      LiteralList arguments;
      for (WasmType param : func->params) {
        // zeros in arguments TODO: more?
        arguments.push_back(Literal(param));
      }
      return instance.callFunction(func->name, arguments);
    } catch (const TrapException&) {
      // may throw in instance creation (init of offsets) or call itself
      return Literal();
    }
  }
};

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::vector<std::string> passes;
  bool emitBinary = true;
  bool debugInfo = false;
  bool fuzzExec = false;

  OptimizationOptions options("wasm-opt", "Optimize .wast files");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--emit-text", "-S", "Emit text instead of binary for the output file",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &argument) { emitBinary = false; })
      .add("--debuginfo", "-g", "Emit names section and debug info",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &arguments) { debugInfo = true; })
      .add("--fuzz-exec", "-fe", "Execute functions before and after optimization, helping fuzzing find bugs",
           Options::Arguments::Zero,
           [&](Options *o, const std::string &arguments) { fuzzExec = true; })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options* o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

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

  ExecutionResults results;
  if (fuzzExec) {
    results.get(wasm);
  }

  if (options.runningPasses()) {
    if (options.debug) std::cerr << "running passes...\n";
    PassRunner passRunner = options.getPassRunner(wasm);
    passRunner.run();
    assert(WasmValidator().validate(wasm));
  }

  if (fuzzExec) {
    ExecutionResults optimizedResults;
    optimizedResults.get(wasm);
    if (optimizedResults != results) {
      Fatal() << "[fuzz-exec] optimization passes changed execution results";
    }
    std::cout << "[fuzz-exec] results match\n";
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
