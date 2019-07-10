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

#include "abi/js.h"
#include "ir/trapping.h"
#include "support/colors.h"
#include "support/file.h"
#include "tool-options.h"
#include "wasm-binary.h"
#include "wasm-emscripten.h"
#include "wasm-io.h"
#include "wasm-printing.h"
#include "wasm-validator.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char* argv[]) {
  const uint64_t INVALID_BASE = -1;

  std::string infile;
  std::string outfile;
  std::string inputSourceMapFilename;
  std::string outputSourceMapFilename;
  std::string outputSourceMapUrl;
  std::string dataSegmentFile;
  bool emitBinary = true;
  bool debugInfo = false;
  bool isSideModule = false;
  bool legalizeJavaScriptFFI = true;
  uint64_t globalBase = INVALID_BASE;
  ToolOptions options("wasm-emscripten-finalize",
                      "Performs Emscripten-specific transforms on .wasm files");
  options
    .add("--output",
         "-o",
         "Output file",
         Options::Arguments::One,
         [&outfile](Options*, const std::string& argument) {
           outfile = argument;
           Colors::setEnabled(false);
         })
    .add("--debuginfo",
         "-g",
         "Emit names section in wasm binary (or full debuginfo in wast)",
         Options::Arguments::Zero,
         [&debugInfo](Options*, const std::string&) { debugInfo = true; })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file",
         Options::Arguments::Zero,
         [&emitBinary](Options*, const std::string&) { emitBinary = false; })
    .add("--global-base",
         "",
         "The address at which static globals were placed",
         Options::Arguments::One,
         [&globalBase](Options*, const std::string& argument) {
           globalBase = std::stoull(argument);
         })
    // TODO(sbc): Remove this one this argument is no longer passed by
    // emscripten. See https://github.com/emscripten-core/emscripten/issues/8905
    .add("--initial-stack-pointer",
         "",
         "ignored - will be removed in a future release",
         Options::Arguments::One,
         [](Options*, const std::string& argument) {})
    .add("--side-module",
         "",
         "Input is an emscripten side module",
         Options::Arguments::Zero,
         [&isSideModule](Options* o, const std::string& argument) {
           isSideModule = true;
         })
    .add("--input-source-map",
         "-ism",
         "Consume source map from the specified file",
         Options::Arguments::One,
         [&inputSourceMapFilename](Options* o, const std::string& argument) {
           inputSourceMapFilename = argument;
         })
    .add("--no-legalize-javascript-ffi",
         "-nj",
         "Do not fully legalize (i64->i32, "
         "f32->f64) the imports and exports for interfacing with JS",
         Options::Arguments::Zero,
         [&legalizeJavaScriptFFI](Options* o, const std::string&) {
           legalizeJavaScriptFFI = false;
         })
    .add("--output-source-map",
         "-osm",
         "Emit source map to the specified file",
         Options::Arguments::One,
         [&outputSourceMapFilename](Options* o, const std::string& argument) {
           outputSourceMapFilename = argument;
         })
    .add("--output-source-map-url",
         "-osu",
         "Emit specified string as source map URL",
         Options::Arguments::One,
         [&outputSourceMapUrl](Options* o, const std::string& argument) {
           outputSourceMapUrl = argument;
         })
    .add("--separate-data-segments",
         "",
         "Separate data segments to a file",
         Options::Arguments::One,
         [&dataSegmentFile](Options* o, const std::string& argument) {
           dataSegmentFile = argument;
         })
    .add_positional("INFILE",
                    Options::Arguments::One,
                    [&infile](Options* o, const std::string& argument) {
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
  try {
    reader.read(infile, wasm, inputSourceMapFilename);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    Fatal() << "error in parsing input";
  } catch (MapParseException& p) {
    p.dump(std::cerr);
    std::cerr << '\n';
    Fatal() << "error in parsing wasm source map";
  }

  options.applyFeatures(wasm);

  if (options.debug) {
    std::cerr << "Module before:\n";
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  uint32_t dataSize = 0;

  if (!isSideModule) {
    if (globalBase == INVALID_BASE) {
      Fatal() << "globalBase must be set";
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
    dataSize = dataEndConst->value.geti32() - globalBase;
  }

  EmscriptenGlueGenerator generator(wasm);
  generator.fixInvokeFunctionNames();

  std::vector<Name> initializerFunctions;

  if (wasm.table.imported()) {
    if (wasm.table.base != "table") {
      wasm.table.base = Name("table");
    }
  }
  if (wasm.memory.imported()) {
    if (wasm.table.base != "memory") {
      wasm.memory.base = Name("memory");
    }
  }
  wasm.updateMaps();

  if (isSideModule) {
    generator.replaceStackPointerGlobal();
    generator.generatePostInstantiateFunction();
  } else {
    generator.generateRuntimeFunctions();
    generator.internalizeStackPointerGlobal();
    generator.generateMemoryGrowthFunction();
    // For side modules these gets called via __post_instantiate
    if (Function* F = generator.generateAssignGOTEntriesFunction()) {
      auto* ex = new Export();
      ex->value = F->name;
      ex->name = F->name;
      ex->kind = ExternalKind::Function;
      wasm.addExport(ex);
      initializerFunctions.push_back(F->name);
    }
    if (auto* e = wasm.getExportOrNull(WASM_CALL_CTORS)) {
      initializerFunctions.push_back(e->value);
    }
  }

  generator.generateDynCallThunks();

  // Legalize the wasm.
  {
    PassRunner passRunner(&wasm);
    passRunner.setDebug(options.debug);
    passRunner.setDebugInfo(debugInfo);
    passRunner.add(ABI::getLegalizationPass(
      legalizeJavaScriptFFI ? ABI::LegalizationLevel::Full
                            : ABI::LegalizationLevel::Minimal));
    passRunner.run();
  }

  // Substantial changes to the wasm are done, enough to create the metadata.
  std::string metadata =
    generator.generateEmscriptenMetadata(dataSize, initializerFunctions);

  // Finally, separate out data segments if relevant (they may have been needed
  // for metadata).
  if (!dataSegmentFile.empty()) {
    Output memInitFile(dataSegmentFile, Flags::Binary, Flags::Release);
    if (globalBase == INVALID_BASE) {
      Fatal() << "globalBase must be set";
    }
    generator.separateDataSegments(&memInitFile, globalBase);
  }

  if (options.debug) {
    std::cerr << "Module after:\n";
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  // Strip target features section (its information is in the metadata)
  {
    PassRunner passRunner(&wasm);
    passRunner.add("strip-target-features");
    passRunner.run();
  }

  auto outputBinaryFlag = emitBinary ? Flags::Binary : Flags::Text;
  Output output(outfile, outputBinaryFlag, Flags::Release);
  ModuleWriter writer;
  writer.setDebug(options.debug);
  writer.setDebugInfo(debugInfo);
  // writer.setSymbolMap(symbolMap);
  writer.setBinary(emitBinary);
  if (outputSourceMapFilename.size()) {
    writer.setSourceMapFilename(outputSourceMapFilename);
    writer.setSourceMapUrl(outputSourceMapUrl);
  }
  writer.write(wasm, output);
  if (emitBinary) {
    std::cout << metadata;
  } else {
    output << "(;\n";
    output << "--BEGIN METADATA --\n" << metadata << "-- END METADATA --\n";
    output << ";)\n";
  }

  return 0;
}
