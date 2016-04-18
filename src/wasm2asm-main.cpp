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
// wasm2asm console tool
//


#include "support/colors.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-s-parser.h"
#include "wasm2asm.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  Options options("wasm2asm", "Transform .wast files to asm.js");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options *o, const std::string &argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string &argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  auto input(
      read_file<std::vector<char>>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));

  if (options.debug) std::cerr << "s-parsing..." << std::endl;
  SExpressionParser parser(input.data());
  Element &root = *parser.root;

  if (options.debug) std::cerr << "w-parsing..." << std::endl;
  Module wasm;
  SExpressionWasmBuilder builder(wasm, *root[0], [&]() { abort(); });

  if (options.debug) std::cerr << "asming..." << std::endl;
  Wasm2AsmBuilder wasm2asm(options.debug);
  Ref asmjs = wasm2asm.processWasm(&wasm);

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
