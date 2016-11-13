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

#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-builder.h"
#include "wasm-printing.h"

#include "asm2wasm.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  PassOptions passOptions;
  bool runOptimizationPasses = false;
  bool imprecise = false;
  bool wasmOnly = false;

  Options options("asm2wasm", "Translate asm.js files to .wast files");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--mapped-globals", "-n", "Mapped globals", Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             std::cerr << "warning: the --mapped-globals/-m option is deprecated (a mapped globals file is no longer needed as we use wasm globals)" << std::endl;
           })
      .add("--mem-init", "-t", "Import a memory initialization file into the output module", Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["mem init"] = argument;
           })
      .add("--mem-base", "-mb", "Set the location to write the memory initialization (--mem-init) file (GLOBAL_BASE in emscripten). If not provided, the memoryBase global import is used.", Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["mem base"] = argument;
           })
      .add("--mem-max", "-mm", "Set the maximum size of memory in the wasm module (in bytes). -1 means no limit. Without this, TOTAL_MEMORY is used (as it is used for the initial value), or if memory growth is enabled, no limit is set. This overrides both of those.", Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["mem max"] = argument;
           })
      .add("--total-memory", "-m", "Total memory size", Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["total memory"] = argument;
           })
      .add("--table-max", "-tM", "Set the maximum size of the table. Without this, it is set depending on how many functions are in the module. -1 means no limit", Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["table max"] = argument;
           })
      #include "optimization-options.h"
      .add("--no-opts", "-n", "Disable optimization passes (deprecated)", Options::Arguments::Zero,
           [](Options *o, const std::string &) {
             std::cerr << "--no-opts is deprecated (use -O0, etc.)\n";
           })
      .add("--imprecise", "-i", "Imprecise optimizations", Options::Arguments::Zero,
           [&imprecise](Options *o, const std::string &) {
             imprecise = true;
           })
      .add("--wasm-only", "-w", "Input is in WebAssembly-only format, and not actually valid asm.js", Options::Arguments::Zero,
           [&wasmOnly](Options *o, const std::string &) {
             wasmOnly = true;
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string &argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  const auto &tm_it = options.extra.find("total memory");
  size_t totalMemory =
      tm_it == options.extra.end() ? 16 * 1024 * 1024 : atoi(tm_it->second.c_str());
  if (totalMemory & ~Memory::kPageMask) {
    std::cerr << "Error: total memory size " << totalMemory <<
        " is not a multiple of the 64k wasm page size\n";
    exit(EXIT_FAILURE);
  }

  Asm2WasmPreProcessor pre;
  auto input(
      read_file<std::vector<char>>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));
  char *start = pre.process(input.data());

  if (options.debug) std::cerr << "parsing..." << std::endl;
  cashew::Parser<Ref, DotZeroValueBuilder> builder;
  Ref asmjs = builder.parseToplevel(start);

  if (options.debug) std::cerr << "wasming..." << std::endl;
  Module wasm;
  wasm.memory.initial = wasm.memory.max = totalMemory / Memory::kPageSize;
  Asm2WasmBuilder asm2wasm(wasm, pre.memoryGrowth, options.debug, imprecise, passOptions, runOptimizationPasses, wasmOnly);
  asm2wasm.processAsm(asmjs);

  // import mem init file, if provided
  const auto &memInit = options.extra.find("mem init");
  if (memInit != options.extra.end()) {
    auto filename = memInit->second.c_str();
    auto data(read_file<std::vector<char>>(filename, Flags::Binary, options.debug ? Flags::Debug : Flags::Release));
    // create the memory segment
    Expression* init;
    const auto &memBase = options.extra.find("mem base");
    if (memBase == options.extra.end()) {
      init = Builder(wasm).makeGetGlobal(Name("memoryBase"), i32);
    } else {
      init = Builder(wasm).makeConst(Literal(int32_t(atoi(memBase->second.c_str()))));
    }
    wasm.memory.segments.emplace_back(init, data);
    if (runOptimizationPasses) {
      PassRunner runner(&wasm);
      runner.add("memory-packing");
      runner.run();
    }
  }

  // Set the max memory size, if requested
  const auto &memMax = options.extra.find("mem max");
  if (memMax != options.extra.end()) {
    int max = atoi(memMax->second.c_str());
    if (max >= 0) {
      wasm.memory.max = max / Memory::kPageSize;
    } else {
      wasm.memory.max = Memory::kMaxSize;
    }
  }
  // Set the table sizes, if requested
  const auto &tableMax = options.extra.find("table max");
  if (tableMax != options.extra.end()) {
    int max = atoi(tableMax->second.c_str());
    if (max >= 0) {
      wasm.table.max = max;
    } else {
      wasm.table.max = Table::kMaxSize;
    }
  }

  if (options.debug) std::cerr << "printing..." << std::endl;
  Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  WasmPrinter::printModule(&wasm, output.getStream());

  if (options.debug) std::cerr << "done." << std::endl;
}
