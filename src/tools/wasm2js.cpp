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

#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-s-parser.h"
#include "wasm2js.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  Wasm2JSBuilder::Flags builderFlags;
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
      reader.read(input, wasm, "");

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
  jser.printAst();
  Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  output << jser.buffer << std::endl;

  if (options.debug) std::cerr << "done." << std::endl;
}
