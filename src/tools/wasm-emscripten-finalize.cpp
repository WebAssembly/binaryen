/*
 * Copyright 2017 WebAssembly Community Group participants
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
// wasm-emscripten-finalize console tool
// Performs Emscripten-specific transforms on .wasm files
//

#include <exception>

#include "ir/trapping.h"
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-binary.h"
#include "wasm-emscripten.h"
#include "wasm-io.h"
#include "wasm-linker.h"
#include "wasm-printing.h"
#include "wasm-validator.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  std::string infile;
  std::string outfile;
  bool emitBinary = true;
  unsigned numReservedFunctionPointers = 0;
  uint64_t globalBase;
  Options options("wasm-emscripten-finalize",
                  "Performs Emscripten-specific transforms on .wasm files");
  options
      .add("--output", "-o", "Output file",
           Options::Arguments::One,
           [&outfile](Options*, const std::string& argument) {
             outfile = argument;
             Colors::disable();
           })
      .add("--emit-text", "-S", "Emit text instead of binary for the output file",
           Options::Arguments::Zero,
           [&emitBinary](Options*, const std::string& ) {
             emitBinary = false;
           })
      .add("--emscripten-reserved-function-pointers", "",
           "Number of reserved function pointers for emscripten addFunction "
           "support",
           Options::Arguments::One,
           [&numReservedFunctionPointers](Options *,
                                          const std::string &argument) {
             numReservedFunctionPointers = std::stoi(argument);
           })
      .add("--global-base", "", "Where lld started to place globals",
           Options::Arguments::One,
           [&globalBase](Options*, const std::string&argument ) {
             globalBase = std::stoull(argument);
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [&infile](Options *o, const std::string& argument) {
                        infile = argument;
                      });
  options.parse(argc, argv);

  if (infile == "") {
    Fatal() << "Need to specify an infile\n";
  }
  if (outfile == "" && emitBinary) {
    Fatal() << "Need to specify an outfile, or use text output\n";
  }

  Module wasm;
  ModuleReader reader;
  reader.read(infile, wasm);

  if (options.debug) {
    std::cerr << "Module before:\n";
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  Export* dataEndExport = wasm.getExport("__data_end");
  if (dataEndExport == nullptr) {
    Fatal() << "__data_end export not found";
  }
  Global* dataEnd = wasm.getGlobal(dataEndExport->value);
  if (dataEnd == nullptr) {
    Fatal() << "__data_end global not found";
  }
  if (dataEnd->type != Type::i32) {
    Fatal() << "__data_end global has wrong type";
  }
  Const* dataEndConst = dataEnd->init->cast<Const>();
  uint32_t dataSize = dataEndConst->value.geti32() - globalBase;

  std::vector<Name> initializerFunctions;
  initializerFunctions.push_back("__wasm_call_ctors");

  EmscriptenGlueGenerator generator(wasm);
  generator.generateRuntimeFunctions();
  generator.generateMemoryGrowthFunction();
  generator.generateDynCallThunks();
  generator.generateJSCallThunks(numReservedFunctionPointers);
  std::string metadata = generator.generateEmscriptenMetadata(dataSize, initializerFunctions, numReservedFunctionPointers);

  if (options.debug) {
    std::cerr << "Module after:\n";
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  auto outputBinaryFlag = emitBinary ? Flags::Binary : Flags::Text;
  Output output(outfile, outputBinaryFlag, Flags::Release);
  ModuleWriter writer;
  // writer.setDebug(options.debug);
  writer.setDebugInfo(true);
  // writer.setDebugInfo(options.passOptions.debugInfo);
  // writer.setSymbolMap(symbolMap);
  writer.setBinary(emitBinary);
  // if (emitBinary) {
  //   writer.setSourceMapFilename(sourceMapFilename);
  //   writer.setSourceMapUrl(sourceMapUrl);
  // }
  writer.write(wasm, output);
  if (!emitBinary) {
    output << ";; METADATA: ";
  }
  output << metadata;

  return 0;
}
