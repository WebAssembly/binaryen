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
#include "wasm-binary.h"
#include "shell-interface.h"
#include "optimization-options.h"
#include "execution-results.h"
#include "fuzzing.h"
#include "js-wrapper.h"
#include "spec-wrapper.h"

using namespace wasm;

// runs a command and returns its output TODO: portability, return code checking
std::string runCommand(std::string command) {
#ifdef __linux__
  std::string output;
  const int MAX_BUFFER = 1024;
  char buffer[MAX_BUFFER];
  FILE *stream = popen(command.c_str(), "r");
  while (fgets(buffer, MAX_BUFFER, stream) != NULL) {
    output.append(buffer);
  }
  pclose(stream);
  return output;
#else
  Fatal() << "TODO: portability for wasm-opt runCommand";
#endif
}

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  bool emitBinary = true;
  bool debugInfo = false;
  bool converge = false;
  bool fuzzExec = false;
  bool fuzzBinary = false;
  std::string extraFuzzCommand;
  bool translateToFuzz = false;
  bool fuzzAtomics = true;
  bool fuzzPasses = false;
  std::string emitJSWrapper;
  std::string emitSpecWrapper;
  std::string inputSourceMapFilename;
  std::string outputSourceMapFilename;
  std::string outputSourceMapUrl;

  OptimizationOptions options("wasm-opt", "Read, write, and optimize files");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--emit-text", "-S", "Emit text instead of binary for the output file",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& argument) { emitBinary = false; })
      .add("--debuginfo", "-g", "Emit names section and debug info",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { debugInfo = true; })
      .add("--converge", "-c", "Run passes to convergence, continuing while binary size decreases",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { converge = true; })
      .add("--fuzz-exec", "-fe", "Execute functions before and after optimization, helping fuzzing find bugs",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { fuzzExec = true; })
      .add("--fuzz-binary", "-fb", "Convert to binary and back after optimizations and before fuzz-exec, helping fuzzing find binary format bugs",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { fuzzBinary = true; })
      .add("--extra-fuzz-command", "-efc", "An extra command to run on the output before and after optimizing. The output is compared between the two, and an error occurs if they are not equal",
           Options::Arguments::One,
           [&](Options *o, const std::string& arguments) { extraFuzzCommand = arguments; })
      .add("--translate-to-fuzz", "-ttf", "Translate the input into a valid wasm module *somehow*, useful for fuzzing",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { translateToFuzz = true; })
      .add("--no-fuzz-atomics", "-nfa", "Disable generation of atomic opcodes with translate-to-fuzz (on by default)",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { fuzzAtomics = false; })
      .add("--fuzz-passes", "-fp", "Pick a random set of passes to run, useful for fuzzing. this depends on translate-to-fuzz (it picks the passes from the input)",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { fuzzPasses = true; })
      .add("--emit-js-wrapper", "-ejw", "Emit a JavaScript wrapper file that can run the wasm with some test values, useful for fuzzing",
           Options::Arguments::One,
           [&](Options *o, const std::string& arguments) { emitJSWrapper = arguments; })
      .add("--emit-spec-wrapper", "-esw", "Emit a wasm spec interpreter wrapper file that can run the wasm with some test values, useful for fuzzing",
           Options::Arguments::One,
           [&](Options *o, const std::string& arguments) { emitSpecWrapper = arguments; })
      .add("--input-source-map", "-ism", "Consume source map from the specified file",
           Options::Arguments::One,
           [&inputSourceMapFilename](Options *o, const std::string& argument) { inputSourceMapFilename = argument; })
      .add("--output-source-map", "-osm", "Emit source map to the specified file",
           Options::Arguments::One,
           [&outputSourceMapFilename](Options *o, const std::string& argument) { outputSourceMapFilename = argument; })
      .add("--output-source-map-url", "-osu", "Emit specified string as source map URL",
           Options::Arguments::One,
           [&outputSourceMapUrl](Options *o, const std::string& argument) { outputSourceMapUrl = argument; })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options* o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  Module wasm;
  // It should be safe to just always enable atomics in wasm-opt, because we
  // don't expect any passes to accidentally generate atomic ops
  FeatureSet features = Feature::Atomics;

  if (options.debug) std::cerr << "reading...\n";

  if (!translateToFuzz) {
    ModuleReader reader;
    reader.setDebug(options.debug);
    try {
      reader.read(options.extra["infile"], wasm, inputSourceMapFilename);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      std::cerr << '\n';
      Fatal() << "error in parsing input";
    } catch (MapParseException& p) {
      p.dump(std::cerr);
      std::cerr << '\n';
      Fatal() << "error in parsing wasm source map";
    } catch (std::bad_alloc&) {
      Fatal() << "error in building module, std::bad_alloc (possibly invalid request for silly amounts of memory)";
    }

    if (options.passOptions.validate) {
      if (!WasmValidator().validate(wasm, features)) {
        WasmPrinter::printModule(&wasm);
        Fatal() << "error in validating input";
      }
    }
  } else {
    // translate-to-fuzz
    TranslateToFuzzReader reader(wasm, options.extra["infile"]);
    if (fuzzPasses) {
      reader.pickPasses(options);
    }
    reader.build(fuzzAtomics);
    if (options.passOptions.validate) {
      if (!WasmValidator().validate(wasm, features)) {
        WasmPrinter::printModule(&wasm);
        std::cerr << "translate-to-fuzz must always generate a valid module";
        abort();
      }
    }
  }

  ExecutionResults results;
  if (fuzzExec) {
    results.get(wasm);
  }

  if (emitJSWrapper.size() > 0) {
    std::ofstream outfile;
    outfile.open(emitJSWrapper, std::ofstream::out);
    outfile << generateJSWrapper(wasm);
    outfile.close();
  }

  if (emitSpecWrapper.size() > 0) {
    std::ofstream outfile;
    outfile.open(emitSpecWrapper, std::ofstream::out);
    outfile << generateSpecWrapper(wasm);
    outfile.close();
  }

  std::string firstOutput;

  if (extraFuzzCommand.size() > 0 && options.extra.count("output") > 0) {
    if (options.debug) std::cerr << "writing binary before opts, for extra fuzz command..." << std::endl;
    ModuleWriter writer;
    writer.setDebug(options.debug);
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    writer.write(wasm, options.extra["output"]);
    firstOutput = runCommand(extraFuzzCommand);
    std::cout << "[extra-fuzz-command first output:]\n" << firstOutput << '\n';
  }

  Module* curr = &wasm;
  Module other;

  if (fuzzExec && fuzzBinary) {
    BufferWithRandomAccess buffer(false);
    // write the binary
    WasmBinaryWriter writer(&wasm, buffer, false);
    writer.write();
    // read the binary
    auto input = buffer.getAsChars();
    WasmBinaryBuilder parser(other, input, false);
    parser.read();
    if (options.passOptions.validate) {
      bool valid = WasmValidator().validate(other, features);
      if (!valid) {
        WasmPrinter::printModule(&other);
      }
      assert(valid);
    }
    curr = &other;
  }

  if (options.runningPasses()) {
    if (options.debug) std::cerr << "running passes...\n";
    auto runPasses = [&]() {
      options.runPasses(*curr);
      if (options.passOptions.validate) {
        bool valid = WasmValidator().validate(*curr, features);
        if (!valid) {
          WasmPrinter::printModule(&*curr);
        }
        assert(valid);
      }
    };
    runPasses();
    if (converge) {
      // Keep on running passes to convergence, defined as binary
      // size no longer decreasing.
      auto getSize = [&]() {
        BufferWithRandomAccess buffer;
        WasmBinaryWriter writer(curr, buffer);
        writer.write();
        return buffer.size();
      };
      auto lastSize = getSize();
      while (1) {
        if (options.debug) std::cerr << "running iteration for convergence (" << lastSize << ")...\n";
        runPasses();
        auto currSize = getSize();
        if (currSize >= lastSize) break;
        lastSize = currSize;
      }
    }
  }

  if (fuzzExec) {
    results.check(*curr);
  }

  if (options.extra.count("output") > 0) {
    if (options.debug) std::cerr << "writing..." << std::endl;
    ModuleWriter writer;
    writer.setDebug(options.debug);
    writer.setBinary(emitBinary);
    writer.setDebugInfo(debugInfo);
    if (outputSourceMapFilename.size()) {
      writer.setSourceMapFilename(outputSourceMapFilename);
      writer.setSourceMapUrl(outputSourceMapUrl);
    }
    writer.write(*curr, options.extra["output"]);

    if (extraFuzzCommand.size() > 0) {
      auto secondOutput = runCommand(extraFuzzCommand);
      std::cout << "[extra-fuzz-command second output:]\n" << firstOutput << '\n';
      if (firstOutput != secondOutput) {
        std::cerr << "extra fuzz command output differs\n";
        abort();
      }
    }
  }
}
