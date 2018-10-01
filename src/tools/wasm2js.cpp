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
// wasm2js console tool
//

#include <fstream>
#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "support/vlq.h"
#include "wasm-s-parser.h"
#include "wasm2js.h"

using namespace cashew;
using namespace wasm;

void writeSourceMap(const std::string& outputSourceMapFilename,
                    const std::vector<JSDebugLocMapping>& debugLocMappings,
                    const std::vector<std::string>& debugInfoFileNames) {
  std::ofstream map(outputSourceMapFilename.c_str());
  map << "{\"version\":3,\"sources\":[";
  for (size_t i = 0; i < debugInfoFileNames.size(); i++) {
    if (i > 0) map << ",";
    // TODO respect JSON string encoding, e.g. quotes and control chars.
    map << "\"" << debugInfoFileNames[i] << "\"";
  }
  map << "],\"names\":[],\"mappings\":\"";
  JSDebugLocMapping lastLoc = { {0, 0}, {0, /* lineNumber = */ 1, 0} };
  for (const auto &mapping : debugLocMappings) {
    while (lastLoc.generated.lineNumber < mapping.generated.lineNumber) {
      lastLoc.generated.lineNumber++;
      lastLoc.generated.columnNumber = 0;
      map << ";";
    }
    if (lastLoc.generated.columnNumber > 0) {
      map << ",";
    }
    writeBase64VLQ(map, int32_t(mapping.generated.columnNumber - lastLoc.generated.columnNumber));
    writeBase64VLQ(map, int32_t(mapping.original.fileIndex - lastLoc.original.fileIndex));
    writeBase64VLQ(map, int32_t(mapping.original.lineNumber - lastLoc.original.lineNumber));
    writeBase64VLQ(map, int32_t(mapping.original.columnNumber - lastLoc.original.columnNumber));
    lastLoc = mapping;
  }
  map << "\"}";
}

int main(int argc, const char *argv[]) {
  Wasm2JSBuilder::Flags builderFlags;
  std::string inputSourceMapFilename;
  std::string outputSourceMapFilename;
  std::string outputSourceMapUrl;
  Options options("wasm2js", "Transform .wasm/.wast files to asm.js");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add("--allow-asserts", "", "Allow compilation of .wast testing asserts",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             builderFlags.allowAsserts = true;
             o->extra["asserts"] = "1";
           })
      .add("--pedantic", "", "Emulate WebAssembly trapping behavior",
           Options::Arguments::Zero,
           [&](Options* o, const std::string& argument) {
             builderFlags.pedantic = true;
           })
      .add("--input-source-map", "-ism", "Consume source map from the specified .wasm file",
           Options::Arguments::One,
           [&inputSourceMapFilename](Options *o, const std::string& argument) { inputSourceMapFilename = argument; })
      .add("--output-source-map", "-osm", "Emit source map to the specified .js file",
           Options::Arguments::One,
           [&outputSourceMapFilename](Options *o, const std::string& argument) { outputSourceMapFilename = argument; })
      .add("--output-source-map-url", "-osu", "Emit specified string as source map URL",
           Options::Arguments::One,
           [&outputSourceMapUrl](Options *o, const std::string& argument) { outputSourceMapUrl = argument; })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);
  if (options.debug) builderFlags.debug = true;

  Element* root;
  Module wasm;
  Ref asmjs;

  try {
    // If the input filename ends in `.wasm`, then parse it in binary form,
    // otherwise assume it's a `*.wast` file and go from there.
    //
    // Note that we're not using the built-in `ModuleReader` which will also do
    // similar logic here because when testing JS files we use the
    // `--allow-asserts` flag which means we need to parse the extra
    // s-expressions that come at the end of the `*.wast` file after the module
    // is defined.
    auto &input = options.extra["infile"];
    std::string suffix(".wasm");
    if (input.size() >= suffix.size() &&
        input.compare(input.size() - suffix.size(), suffix.size(), suffix) == 0) {
      ModuleReader reader;
      reader.setDebug(options.debug);
      reader.read(input, wasm, inputSourceMapFilename);

      if (options.debug) std::cerr << "asming..." << std::endl;
      Wasm2JSBuilder wasm2js(builderFlags);
      asmjs = wasm2js.processWasm(&wasm);

    } else {
      auto input(
          read_file<std::vector<char>>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));
      if (options.debug) std::cerr << "s-parsing..." << std::endl;
      SExpressionParser parser(input.data());
      root = parser.root;

      if (options.debug) std::cerr << "w-parsing..." << std::endl;
      SExpressionWasmBuilder builder(wasm, *(*root)[0]);

      if (options.debug) std::cerr << "asming..." << std::endl;
      Wasm2JSBuilder wasm2js(builderFlags);
      asmjs = wasm2js.processWasm(&wasm);

      if (options.extra["asserts"] == "1") {
        if (options.debug) std::cerr << "asserting..." << std::endl;
        flattenAppend(asmjs, wasm2js.processAsserts(&wasm, *root, builder));
      }
    }
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing input";
  } catch (std::bad_alloc&) {
    Fatal() << "error in building module, std::bad_alloc (possibly invalid request for silly amounts of memory)";
  }

  if (options.debug) {
    std::cerr << "a-printing..." << std::endl;
    asmjs->stringify(std::cout, true);
    std::cout << '\n';
  }

  if (options.debug) std::cerr << "j-printing..." << std::endl;
  JSPrinter jser(true, true, asmjs);
  jser.enableDebugLocation = outputSourceMapFilename.size();
  jser.printAst();
  Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  output << jser.buffer << std::endl;
  if (outputSourceMapUrl.size()) {
    output << "//# sourceMappingURL=" << outputSourceMapUrl;
  }
  if (outputSourceMapFilename.size()) {
    writeSourceMap(outputSourceMapFilename, jser.debugLocMappings, wasm.debugInfoFileNames);
  }

  if (options.debug) std::cerr << "done." << std::endl;
}
