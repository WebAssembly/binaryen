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
// asm2wasm console tool
//

#include <exception>

#include "ir/trapping.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-builder.h"
#include "wasm-printing.h"
#include "wasm-io.h"
#include "wasm-validator.h"
#include "optimization-options.h"

#include "asm2wasm.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  bool legalizeJavaScriptFFI = true;
  TrapMode trapMode = TrapMode::JS;
  bool wasmOnly = false;
  std::string sourceMapFilename;
  std::string sourceMapUrl;
  std::string symbolMap;
  bool emitBinary = true;

  OptimizationOptions options("asm2wasm", "Translate asm.js files to .wast files");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--mapped-globals", "-n", "Mapped globals", Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             std::cerr << "warning: the --mapped-globals/-m option is deprecated (a mapped globals file is no longer needed as we use wasm globals)" << std::endl;
           })
      .add("--mem-init", "-t", "Import a memory initialization file into the output module", Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             o->extra["mem init"] = argument;
           })
      .add("--mem-base", "-mb", "Set the location to write the memory initialization (--mem-init) file (GLOBAL_BASE in emscripten). If not provided, the __memory_base global import is used.", Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             o->extra["mem base"] = argument;
           })
      .add("--mem-max", "-mm", "Set the maximum size of memory in the wasm module (in bytes). -1 means no limit. Without this, TOTAL_MEMORY is used (as it is used for the initial value), or if memory growth is enabled, no limit is set. This overrides both of those.", Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             o->extra["mem max"] = argument;
           })
      .add("--total-memory", "-m", "Total memory size", Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             o->extra["total memory"] = argument;
           })
      .add("--table-max", "-tM", "Set the maximum size of the table. Without this, it is set depending on how many functions are in the module. -1 means no limit", Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             o->extra["table max"] = argument;
           })
      .add("--no-opts", "-n", "Disable optimization passes (deprecated)", Options::Arguments::Zero,
           [](Options *o, const std::string& ) {
             std::cerr << "--no-opts is deprecated (use -O0, etc.)\n";
           })
      .add("--trap-mode", "",
           "Strategy for handling potentially trapping instructions. Valid "
             "values are \"allow\", \"js\", and \"clamp\"",
           Options::Arguments::One,
           [&trapMode](Options *o, const std::string& argument) {
             try {
               trapMode = trapModeFromString(argument);
             } catch (std::invalid_argument& e) {
               std::cerr << "Error: " << e.what() << "\n";
               exit(EXIT_FAILURE);
             }
           })
      .add("--wasm-only", "-w", "Input is in WebAssembly-only format, and not actually valid asm.js", Options::Arguments::Zero,
           [&wasmOnly](Options *o, const std::string& ) {
             wasmOnly = true;
           })
      .add("--no-legalize-javascript-ffi", "-nj", "Do not legalize (i64->i32, f32->f64) the imports and exports for interfacing with JS", Options::Arguments::Zero,
           [&legalizeJavaScriptFFI](Options *o, const std::string& ) {
             legalizeJavaScriptFFI = false;
           })
      .add("--debuginfo", "-g", "Emit names section in wasm binary (or full debuginfo in wast)",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { options.passOptions.debugInfo = true; })
      .add("--source-map", "-sm", "Emit source map (if using binary output) to the specified file",
           Options::Arguments::One,
           [&sourceMapFilename](Options *o, const std::string& argument) { sourceMapFilename = argument; })
      .add("--source-map-url", "-su", "Use specified string as source map URL",
           Options::Arguments::One,
           [&sourceMapUrl](Options *o, const std::string& argument) { sourceMapUrl = argument; })
      .add("--symbolmap", "-s", "Emit a symbol map (indexes => names)",
           Options::Arguments::One,
           [&](Options *o, const std::string& argument) { symbolMap = argument; })
      .add("--emit-text", "-S", "Emit text instead of binary for the output file",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& argument) { emitBinary = false; })
      .add("--enable-threads", "-a", "Enable the Atomics wasm feature",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& argument) { options.passOptions.features |= Feature::Atomics; })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  // finalize arguments
  if (options.extra["output"].size() == 0) {
    // when no output file is specified, we emit text to stdout
    emitBinary = false;
  }

  if (options.runningDefaultOptimizationPasses()) {
    if (options.passes.size() > 1) {
      Fatal() << "asm2wasm can only run default optimization passes (-O, -Ox, etc.), and not specific additional passes";
    }
  }

  const auto &tm_it = options.extra.find("total memory");
  size_t totalMemory =
      tm_it == options.extra.end() ? 16 * 1024 * 1024 : atoll(tm_it->second.c_str());
  if (totalMemory & ~Memory::kPageMask) {
    std::cerr << "Error: total memory size " << totalMemory <<
        " is not a multiple of the 64k wasm page size\n";
    exit(EXIT_FAILURE);
  }

  Asm2WasmPreProcessor pre;
  // wasm binaries can contain a names section, but not full debug info --
  // debug info is disabled if a map file is not specified with wasm binary
  pre.debugInfo = options.passOptions.debugInfo && (!emitBinary || sourceMapFilename.size());
  auto input(
      read_file<std::vector<char>>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));
  char *start = pre.process(input.data());

  if (options.debug) std::cerr << "parsing..." << std::endl;
  cashew::Parser<Ref, DotZeroValueBuilder> builder;
  Ref asmjs = builder.parseToplevel(start);

  if (options.debug) std::cerr << "wasming..." << std::endl;
  Module wasm;

  // set up memory
  wasm.memory.initial = wasm.memory.max = totalMemory / Memory::kPageSize;

  // import mem init file, if provided (do this before compiling the module,
  // since the optimizer should see the memory segments)
  const auto &memInit = options.extra.find("mem init");
  if (memInit != options.extra.end()) {
    auto filename = memInit->second.c_str();
    auto data(read_file<std::vector<char>>(filename, Flags::Binary, options.debug ? Flags::Debug : Flags::Release));
    // create the memory segment
    Expression* init;
    const auto &memBase = options.extra.find("mem base");
    if (memBase == options.extra.end()) {
      init = Builder(wasm).makeGetGlobal(MEMORY_BASE, i32);
    } else {
      init = Builder(wasm).makeConst(Literal(int32_t(atoi(memBase->second.c_str()))));
    }
    wasm.memory.segments.emplace_back(init, data);
  }

  // compile the code
  Asm2WasmBuilder asm2wasm(wasm, pre, options.debug, trapMode, options.passOptions, legalizeJavaScriptFFI, options.runningDefaultOptimizationPasses(), wasmOnly);
  asm2wasm.processAsm(asmjs);

  // finalize the imported mem init
  if (memInit != options.extra.end()) {
    if (options.runningDefaultOptimizationPasses()) {
      PassRunner runner(&wasm);
      runner.setFeatures(options.features);
      runner.add("memory-packing");
      runner.run();
    }
  }

  // Set the max memory size, if requested
  const auto &memMax = options.extra.find("mem max");
  if (memMax != options.extra.end()) {
    uint64_t max = strtoull(memMax->second.c_str(), nullptr, 10);
    if (max != uint64_t(-1)) {
      wasm.memory.max = max / Memory::kPageSize;
    } else {
      wasm.memory.max = Memory::kUnlimitedSize;
    }
  }
  // Set the table sizes, if requested
  const auto &tableMax = options.extra.find("table max");
  if (tableMax != options.extra.end()) {
    int max = atoi(tableMax->second.c_str());
    if (max >= 0) {
      wasm.table.max = max;
    } else {
      wasm.table.max = Table::kUnlimitedSize;
    }
  }

  if (options.passOptions.validate) {
    if (!WasmValidator().validate(wasm, options.passOptions.features)) {
      WasmPrinter::printModule(&wasm);
      Fatal() << "error in validating output";
    }
  }

  if (options.debug) std::cerr << "emitting..." << std::endl;
  ModuleWriter writer;
  writer.setDebug(options.debug);
  writer.setDebugInfo(options.passOptions.debugInfo);
  writer.setSymbolMap(symbolMap);
  writer.setBinary(emitBinary);
  if (emitBinary) {
    writer.setSourceMapFilename(sourceMapFilename);
    writer.setSourceMapUrl(sourceMapUrl);
  }
  writer.write(wasm, options.extra["output"]);

  if (options.debug) std::cerr << "done." << std::endl;
}
