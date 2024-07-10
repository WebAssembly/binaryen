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

#include "execution-results.h"
#include "fuzzing.h"
#include "optimization-options.h"
#include "pass.h"
#include "shell-interface.h"
#include "spec-wrapper.h"
#include "support/command-line.h"
#include "support/debug.h"
#include "support/file.h"
#include "support/path.h"
#include "wasm-binary.h"
#include "wasm-interpreter.h"
#include "wasm-io.h"
#include "wasm-stack.h"
#include "wasm-validator.h"
#include "wasm2c-wrapper.h"

#define DEBUG_TYPE "opt"

using namespace wasm;

// runs a command and returns its output TODO: portability, return code checking
static std::string runCommand(std::string command) {
#ifdef __linux__
  std::string output;
  const int MAX_BUFFER = 1024;
  char buffer[MAX_BUFFER];
  FILE* stream = popen(command.c_str(), "r");
  while (fgets(buffer, MAX_BUFFER, stream) != NULL) {
    output.append(buffer);
  }
  pclose(stream);
  return output;
#else
  Fatal() << "TODO: portability for wasm-opt runCommand";
#endif
}

static bool
willRemoveDebugInfo(const std::vector<OptimizationOptions::PassInfo>& passes) {
  for (auto& pass : passes) {
    if (PassRunner::passRemovesDebugInfo(pass.name)) {
      return true;
    }
  }
  return false;
}

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  bool emitBinary = true;
  bool converge = false;
  bool fuzzExecBefore = false;
  bool fuzzExecAfter = false;
  std::string extraFuzzCommand;
  bool translateToFuzz = false;
  std::string initialFuzz;
  bool fuzzPasses = false;
  bool fuzzMemory = true;
  bool fuzzOOB = true;
  std::string emitSpecWrapper;
  std::string emitWasm2CWrapper;
  std::string inputSourceMapFilename;
  std::string outputSourceMapFilename;
  std::string outputSourceMapUrl;
  bool emitExnref = false;

  const std::string WasmOptOption = "wasm-opt options";

  OptimizationOptions options("wasm-opt", "Read, write, and optimize files");
  options
    .add("--output",
         "-o",
         "Output file (stdout if not specified)",
         WasmOptOption,
         Options::Arguments::One,
         [](Options* o, const std::string& argument) {
           o->extra["output"] = argument;
           Colors::setEnabled(false);
         })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file",
         WasmOptOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) { emitBinary = false; })
    .add("--converge",
         "-c",
         "Run passes to convergence, continuing while binary size decreases",
         WasmOptOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { converge = true; })
    .add(
      "--fuzz-exec-before",
      "-feh",
      "Execute functions before optimization, helping fuzzing find bugs",
      WasmOptOption,
      Options::Arguments::Zero,
      [&](Options* o, const std::string& arguments) { fuzzExecBefore = true; })
    .add("--fuzz-exec",
         "-fe",
         "Execute functions before and after optimization, helping fuzzing "
         "find bugs",
         WasmOptOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) {
           fuzzExecBefore = fuzzExecAfter = true;
         })
    .add("--extra-fuzz-command",
         "-efc",
         "An extra command to run on the output before and after optimizing. "
         "The output is compared between the two, and an error occurs if they "
         "are not equal",
         WasmOptOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& arguments) {
           extraFuzzCommand = arguments;
         })
    .add(
      "--translate-to-fuzz",
      "-ttf",
      "Translate the input into a valid wasm module *somehow*, useful for "
      "fuzzing",
      WasmOptOption,
      Options::Arguments::Zero,
      [&](Options* o, const std::string& arguments) { translateToFuzz = true; })
    .add("--initial-fuzz",
         "-if",
         "Initial wasm content in translate-to-fuzz (-ttf) mode",
         WasmOptOption,
         Options::Arguments::One,
         [&initialFuzz](Options* o, const std::string& argument) {
           initialFuzz = argument;
         })
    .add("--fuzz-passes",
         "-fp",
         "Pick a random set of passes to run, useful for fuzzing. this depends "
         "on translate-to-fuzz (it picks the passes from the input)",
         WasmOptOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { fuzzPasses = true; })
    .add("--no-fuzz-memory",
         "",
         "don't emit memory ops when fuzzing",
         WasmOptOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { fuzzMemory = false; })
    .add("--no-fuzz-oob",
         "",
         "don't emit out-of-bounds loads/stores/indirect calls when fuzzing",
         WasmOptOption,
         Options::Arguments::Zero,
         [&](Options* o, const std::string& arguments) { fuzzOOB = false; })
    .add("--emit-spec-wrapper",
         "-esw",
         "Emit a wasm spec interpreter wrapper file that can run the wasm with "
         "some test values, useful for fuzzing",
         WasmOptOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& arguments) {
           emitSpecWrapper = arguments;
         })
    .add("--emit-wasm2c-wrapper",
         "-esw",
         "Emit a C wrapper file that can run the wasm after it is compiled "
         "with wasm2c, useful for fuzzing",
         WasmOptOption,
         Options::Arguments::One,
         [&](Options* o, const std::string& arguments) {
           emitWasm2CWrapper = arguments;
         })
    .add("--input-source-map",
         "-ism",
         "Consume source map from the specified file",
         WasmOptOption,
         Options::Arguments::One,
         [&inputSourceMapFilename](Options* o, const std::string& argument) {
           inputSourceMapFilename = argument;
         })
    .add("--output-source-map",
         "-osm",
         "Emit source map to the specified file",
         WasmOptOption,
         Options::Arguments::One,
         [&outputSourceMapFilename](Options* o, const std::string& argument) {
           outputSourceMapFilename = argument;
         })
    .add("--output-source-map-url",
         "-osu",
         "Emit specified string as source map URL",
         WasmOptOption,
         Options::Arguments::One,
         [&outputSourceMapUrl](Options* o, const std::string& argument) {
           outputSourceMapUrl = argument;
         })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [](Options* o, const std::string& argument) {
                      o->extra["infile"] = argument;
                    })
    .add("--experimental-new-eh",
         "",
         "Deprecated; same as --emit-exnref",
         WasmOptOption,
         Options::Arguments::Zero,
         [&emitExnref](Options*, const std::string&) { emitExnref = true; })
    .add("--emit-exnref",
         "",
         "After running all requested transformations / optimizations, "
         "translate the instruction to use the new EH instructions at the end. "
         "Depending on the optimization level specified, this may do some more "
         "post-translation optimizations.",
         WasmOptOption,
         Options::Arguments::Zero,
         [&emitExnref](Options*, const std::string&) { emitExnref = true; });
  options.parse(argc, argv);

  Module wasm;
  options.applyFeatures(wasm);

  BYN_TRACE("reading...\n");

  auto exitOnInvalidWasm = [&](const char* message) {
    // If the user asked to print the module, print it even if invalid,
    // as otherwise there is no way to print the broken module (the pass
    // to print would not be reached).
    if (std::any_of(options.passes.begin(),
                    options.passes.end(),
                    [](const OptimizationOptions::PassInfo& info) {
                      return info.name == "print";
                    })) {
      std::cout << wasm << '\n';
    }
    Fatal() << message;
  };

  // In normal (non-translate-to-fuzz) mode we read the input file. In
  // translate-to-fuzz mode the input file is the random data, and used later
  // down in TranslateToFuzzReader, but there is also an optional initial fuzz
  // file that if it exists we read it, then add more fuzz on top.
  if (!translateToFuzz || initialFuzz.size()) {
    std::string inputFile =
      translateToFuzz ? initialFuzz : options.extra["infile"];
    ModuleReader reader;
    // Enable DWARF parsing if we were asked for debug info, and were not
    // asked to remove it.
    reader.setDWARF(options.passOptions.debugInfo &&
                    !willRemoveDebugInfo(options.passes));
    reader.setProfile(options.profile);
    try {
      reader.read(inputFile, wasm, inputSourceMapFilename);
    } catch (ParseException& p) {
      p.dump(std::cerr);
      std::cerr << '\n';
      if (options.debug) {
        Fatal() << "error parsing wasm. here is what we read up to the error:\n"
                << wasm;
      } else {
        Fatal() << "error parsing wasm (try --debug for more info)";
      }
    } catch (MapParseException& p) {
      p.dump(std::cerr);
      std::cerr << '\n';
      Fatal() << "error parsing wasm source map";
    } catch (std::bad_alloc&) {
      Fatal() << "error building module, std::bad_alloc (possibly invalid "
                 "request for silly amounts of memory)";
    }

    if (options.passOptions.validate) {
      if (!WasmValidator().validate(wasm, options.passOptions)) {
        exitOnInvalidWasm("error validating input");
      }
    }
  }
  if (translateToFuzz) {
    TranslateToFuzzReader reader(wasm, options.extra["infile"]);
    if (fuzzPasses) {
      reader.pickPasses(options);
    }
    reader.setAllowMemory(fuzzMemory);
    reader.setAllowOOB(fuzzOOB);
    reader.build();
    if (options.passOptions.validate) {
      if (!WasmValidator().validate(wasm, options.passOptions)) {
        std::cout << wasm << '\n';
        Fatal() << "error after translate-to-fuzz";
      }
    }
  }

  ExecutionResults results;
  if (fuzzExecBefore) {
    results.get(wasm);
  }

  if (emitSpecWrapper.size() > 0) {
    std::ofstream outfile;
    outfile.open(wasm::Path::to_path(emitSpecWrapper), std::ofstream::out);
    outfile << generateSpecWrapper(wasm);
    outfile.close();
  }
  if (emitWasm2CWrapper.size() > 0) {
    std::ofstream outfile;
    outfile.open(wasm::Path::to_path(emitWasm2CWrapper), std::ofstream::out);
    outfile << generateWasm2CWrapper(wasm);
    outfile.close();
  }

  std::string firstOutput;

  if (extraFuzzCommand.size() > 0 && options.extra.count("output") > 0) {
    BYN_TRACE("writing binary before opts, for extra fuzz command...\n");
    ModuleWriter writer(options.passOptions);
    writer.setBinary(emitBinary);
    writer.setDebugInfo(options.passOptions.debugInfo);
    writer.write(wasm, options.extra["output"]);
    firstOutput = runCommand(extraFuzzCommand);
    std::cout << "[extra-fuzz-command first output:]\n" << firstOutput << '\n';
  }

  bool translateToExnref = wasm.features.hasExceptionHandling() && emitExnref;

  if (!options.runningPasses()) {
    if (!options.quiet && !translateToExnref) {
      std::cerr << "warning: no passes specified, not doing any work\n";
    }
  } else {
    BYN_TRACE("running passes...\n");
    auto runPasses = [&]() {
      options.runPasses(wasm);
      if (options.passOptions.validate) {
        bool valid = WasmValidator().validate(wasm, options.passOptions);
        if (!valid) {
          exitOnInvalidWasm("error after opts");
        }
      }
    };
    runPasses();
    if (converge) {
      // Keep on running passes to convergence, defined as binary
      // size no longer decreasing.
      auto getSize = [&]() {
        BufferWithRandomAccess buffer;
        WasmBinaryWriter writer(&wasm, buffer, options.passOptions);
        writer.write();
        return buffer.size();
      };
      auto lastSize = getSize();
      while (1) {
        BYN_TRACE("running iteration for convergence (" << lastSize << ")..\n");
        runPasses();
        auto currSize = getSize();
        if (currSize >= lastSize) {
          break;
        }
        lastSize = currSize;
      }
    }
  }

  if (translateToExnref) {
    BYN_TRACE("translating to new EH instructions...\n");
    PassRunner runner(&wasm, options.passOptions);
    runner.add("translate-to-exnref");
    runner.run();
    if (options.passOptions.validate) {
      bool valid = WasmValidator().validate(wasm, options.passOptions);
      if (!valid) {
        exitOnInvalidWasm("error after opts");
      }
    }
  }

  if (fuzzExecAfter) {
    results.check(wasm);
  }

  if (options.passOptions.printStackIR) {
    printStackIR(std::cout, &wasm, options.passOptions);
  }

  if (options.extra.count("output") == 0) {
    if (!options.quiet) {
      std::cerr << "warning: no output file specified, not emitting output\n";
    }
    return 0;
  }

  BYN_TRACE("writing...\n");
  ModuleWriter writer(options.passOptions);
  writer.setBinary(emitBinary);
  writer.setDebugInfo(options.passOptions.debugInfo);
  if (outputSourceMapFilename.size()) {
    writer.setSourceMapFilename(outputSourceMapFilename);
    writer.setSourceMapUrl(outputSourceMapUrl);
  }
  writer.write(wasm, options.extra["output"]);

  if (extraFuzzCommand.size() > 0) {
    auto secondOutput = runCommand(extraFuzzCommand);
    std::cout << "[extra-fuzz-command second output:]\n" << firstOutput << '\n';
    if (firstOutput != secondOutput) {
      Fatal() << "extra fuzz command output differs\n";
    }
  }
  return 0;
}
