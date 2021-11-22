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
#include "support/debug.h"
#include "support/file.h"
#include "tool-options.h"
#include "wasm-binary.h"
#include "wasm-emscripten.h"
#include "wasm-io.h"
#include "wasm-validator.h"

#define DEBUG_TYPE "emscripten"

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
  bool DWARF = false;
  bool sideModule = false;
  bool legalizeJavaScriptFFI = true;
  bool bigInt = false;
  bool checkStackOverflow = false;
  uint64_t globalBase = INVALID_BASE;
  bool standaloneWasm = false;
  // TODO: remove after https://github.com/WebAssembly/binaryen/issues/3043
  bool minimizeWasmChanges = false;
  bool noDynCalls = false;
  bool onlyI64DynCalls = false;

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
    .add("--dwarf",
         "",
         "Update DWARF debug info",
         Options::Arguments::Zero,
         [&DWARF](Options*, const std::string&) { DWARF = true; })
    .add("--emit-text",
         "-S",
         "Emit text instead of binary for the output file. "
         "In this mode if no output file is specified, we write to stdout.",
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
         [&sideModule](Options* o, const std::string& argument) {
           sideModule = true;
         })
    .add("--new-pic-abi",
         "",
         "Use new/llvm PIC abi",
         Options::Arguments::Zero,
         [&](Options* o, const std::string& argument) {})
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
    .add("--bigint",
         "-bi",
         "Assume JS will use wasm/JS BigInt integration, so wasm i64s will "
         "turn into JS BigInts, and there is no need for any legalization at "
         "all (not even minimal legalization of dynCalls)",
         Options::Arguments::Zero,
         [&bigInt](Options* o, const std::string&) { bigInt = true; })
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
    .add("--check-stack-overflow",
         "",
         "Check for stack overflows every time the stack is extended",
         Options::Arguments::Zero,
         [&checkStackOverflow](Options* o, const std::string&) {
           checkStackOverflow = true;
         })
    .add("--standalone-wasm",
         "",
         "Emit a wasm file that does not depend on JS, as much as possible,"
         " using wasi and other standard conventions etc. where possible",
         Options::Arguments::Zero,
         [&standaloneWasm](Options* o, const std::string&) {
           standaloneWasm = true;
         })
    .add("--minimize-wasm-changes",
         "",
         "Modify the wasm as little as possible. This is useful during "
         "development as we reduce the number of changes to the wasm, as it "
         "lets emscripten control how much modifications to do.",
         Options::Arguments::Zero,
         [&minimizeWasmChanges](Options* o, const std::string&) {
           minimizeWasmChanges = true;
         })
    .add("--no-dyncalls",
         "",
         "",
         Options::Arguments::Zero,
         [&noDynCalls](Options* o, const std::string&) { noDynCalls = true; })
    .add("--dyncalls-i64",
         "",
         "",
         Options::Arguments::Zero,
         [&onlyI64DynCalls](Options* o, const std::string&) {
           onlyI64DynCalls = true;
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

  // We will write the modified wasm if the user asked us to, either by
  // specifying an output file or requesting text output (which goes to stdout
  // by default).
  auto writeOutput = outfile.size() > 0 || !emitBinary;

  Module wasm;
  options.applyFeatures(wasm);
  ModuleReader reader;
  // If we are not writing output then we definitely don't need to read debug
  // info, as it does not affect the metadata we will emit. (However, if we
  // emit output then definitely load the names section so that we roundtrip
  // names properly.)
  reader.setDebugInfo(writeOutput);
  reader.setDWARF(DWARF && writeOutput);
  if (!writeOutput) {
    // If we are not writing the output then all we are doing is simple parsing
    // of metadata from global parts of the wasm such as imports and exports. In
    // that case, it is unnecessary to parse function contents which are the
    // great bulk of the work, and we can skip all that.
    // Note that the one case we do need function bodies for, pthreads + EM_ASM
    // parsing, requires special handling. The start function has code that we
    // parse in order to find the EM_ASMs, and for that reason the binary reader
    // will still parse the start function even in this mode.
    reader.setSkipFunctionBodies(true);
  }
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

  BYN_TRACE_WITH_TYPE("emscripten-dump", "Module before:\n");
  BYN_DEBUG_WITH_TYPE("emscripten-dump", std::cerr << &wasm);

  EmscriptenGlueGenerator generator(wasm);
  generator.standalone = standaloneWasm;
  generator.sideModule = sideModule;
  generator.minimizeWasmChanges = minimizeWasmChanges;
  generator.onlyI64DynCalls = onlyI64DynCalls;
  generator.noDynCalls = noDynCalls;

  if (!standaloneWasm) {
    // This is also not needed in standalone mode since standalone mode uses
    // crt1.c to invoke the main and is aware of __main_argc_argv mangling.
    generator.renameMainArgcArgv();
  }

  PassRunner passRunner(&wasm, options.passOptions);
  passRunner.setDebug(options.debug);
  passRunner.setDebugInfo(debugInfo);

  if (checkStackOverflow) {
    if (!standaloneWasm) {
      // In standalone mode we don't set a handler at all.. which means
      // just trap on overflow.
      passRunner.options.arguments["stack-check-handler"] =
        "__handle_stack_overflow";
    }
    passRunner.add("stack-check");
  }

  if (!noDynCalls && !standaloneWasm) {
    // If not standalone wasm then JS is relevant and we need dynCalls.
    if (onlyI64DynCalls) {
      passRunner.add("generate-i64-dyncalls");
    } else {
      passRunner.add("generate-dyncalls");
    }
  }

  // Legalize the wasm, if BigInts don't make that moot.
  if (!bigInt) {
    passRunner.add(ABI::getLegalizationPass(
      legalizeJavaScriptFFI ? ABI::LegalizationLevel::Full
                            : ABI::LegalizationLevel::Minimal));
  }

  // Strip target features section (its information is in the metadata)
  passRunner.add("strip-target-features");

  // If DWARF is unused, strip it out. This avoids us keeping it alive
  // until wasm-opt strips it later.
  if (!DWARF) {
    passRunner.add("strip-dwarf");
  }

  passRunner.run();

  BYN_TRACE("generated metadata\n");
  // Substantial changes to the wasm are done, enough to create the metadata.
  std::string metadata = generator.generateEmscriptenMetadata();

  // Finally, separate out data segments if relevant (they may have been needed
  // for metadata).
  if (!dataSegmentFile.empty()) {
    Output memInitFile(dataSegmentFile, Flags::Binary);
    if (globalBase == INVALID_BASE) {
      Fatal() << "globalBase must be set";
    }
    generator.separateDataSegments(&memInitFile, globalBase);
  }

  BYN_TRACE_WITH_TYPE("emscripten-dump", "Module after:\n");
  BYN_DEBUG_WITH_TYPE("emscripten-dump", std::cerr << wasm << '\n');

  if (writeOutput) {
    Output output(outfile, emitBinary ? Flags::Binary : Flags::Text);
    ModuleWriter writer;
    writer.setDebugInfo(debugInfo);
    // writer.setSymbolMap(symbolMap);
    writer.setBinary(emitBinary);
    if (outputSourceMapFilename.size()) {
      writer.setSourceMapFilename(outputSourceMapFilename);
      writer.setSourceMapUrl(outputSourceMapUrl);
    }
    writer.write(wasm, output);
    if (!emitBinary) {
      output << "(;\n";
      output << "--BEGIN METADATA --\n" << metadata << "-- END METADATA --\n";
      output << ";)\n";
    }
  }
  // If we emit text then we emitted the metadata together with that text
  // earlier. Otherwise emit it to stdout.
  if (emitBinary) {
    std::cout << metadata;
  }
  return 0;
}
