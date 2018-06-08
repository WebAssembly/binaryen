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
// wasm2asm console tool
//

#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-io.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"

#include "tool-utils.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  bool debugInfo = false;
  std::string symbolMap;
  std::string sourceMapFilename;
  std::string sourceMapUrl;
  Options options("wasm-as", "Assemble a .wast (WebAssembly text format) into a .wasm (WebAssembly binary format)");
  options.extra["validate"] = "wasm";
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--validate", "-v", "Control validation of the output module",
           Options::Arguments::One,
           [](Options *o, const std::string& argument) {
             if (argument != "web" && argument != "none" && argument != "wasm") {
               std::cerr << "Valid arguments for --validate flag are 'wasm', 'web', and 'none'.\n";
               exit(1);
             }
             o->extra["validate"] = argument;
           })
      .add("--debuginfo", "-g", "Emit names section and debug info",
           Options::Arguments::Zero,
           [&](Options *o, const std::string& arguments) { debugInfo = true; })
      .add("--source-map", "-sm", "Emit source map to the specified file",
           Options::Arguments::One,
           [&sourceMapFilename](Options *o, const std::string& argument) { sourceMapFilename = argument; })
      .add("--source-map-url", "-su", "Use specified string as source map URL",
           Options::Arguments::One,
           [&sourceMapUrl](Options *o, const std::string& argument) { sourceMapUrl = argument; })
      .add("--symbolmap", "-s", "Emit a symbol map (indexes => names)",
           Options::Arguments::One,
           [&](Options *o, const std::string& argument) { symbolMap = argument; })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  // default output is infile with changed suffix
  if (options.extra.find("output") == options.extra.end()) {
    options.extra["output"] = removeSpecificSuffix(options.extra["infile"], ".wast") + ".wasm";
  }

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

  if (options.extra["validate"] != "none") {
    if (options.debug) std::cerr << "Validating..." << std::endl;
    if (!wasm::WasmValidator().validate(wasm, Feature::All,
         WasmValidator::Globally | (options.extra["validate"] == "web" ? WasmValidator::Web : 0))) {
      WasmPrinter::printModule(&wasm);
      Fatal() << "Error: input module is not valid.\n";
    }
  }

  if (options.debug) std::cerr << "writing..." << std::endl;
  ModuleWriter writer;
  writer.setBinary(true);
  writer.setDebugInfo(debugInfo);
  if (sourceMapFilename.size()) {
    writer.setSourceMapFilename(sourceMapFilename);
    writer.setSourceMapUrl(sourceMapUrl);
  }
  if (symbolMap.size() > 0) {
    writer.setSymbolMap(symbolMap);
  }
  writer.write(wasm, options.extra["output"]);

  if (options.debug) std::cerr << "Done." << std::endl;
}
