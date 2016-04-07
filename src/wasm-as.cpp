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
#include "wasm-binary.h"
#include "wasm-s-parser.h"

using namespace cashew;
using namespace wasm;

int main(int argc, const char *argv[]) {
  bool useOpcodeTable = false;
  Options options("wasm-as", "Assemble a .wast (WebAssembly text format) into a .wasm (WebAssembly binary format)");
  options.add("--output", "-o", "Output file (stdout if not specified)",
              Options::Arguments::One,
              [](Options *o, const std::string &argument) {
                o->extra["output"] = argument;
                Colors::disable();
              })
    .add("--use-opcode-table", "", "uses opcode tables",
         Options::Arguments::Zero,
         [&useOpcodeTable](Options*, const std::string&) {
           useOpcodeTable = true;
         })
    .add_positional("INFILE", Options::Arguments::One,
                      [](Options *o, const std::string &argument) {
                        o->extra["infile"] = argument;
                      });
  options.parse(argc, argv);

  auto input(read_file<std::string>(options.extra["infile"], Flags::Text, options.debug ? Flags::Debug : Flags::Release));

  if (options.debug) std::cerr << "s-parsing..." << std::endl;
  SExpressionParser parser(const_cast<char*>(input.c_str()));
  Element& root = *parser.root;

  if (options.debug) std::cerr << "w-parsing..." << std::endl;
  AllocatingModule wasm;
  SExpressionWasmBuilder builder(wasm, *root[0], [&]() { abort(); }, false);

  if (options.debug) std::cerr << "binarification..." << std::endl;
  BufferWithRandomAccess buffer(options.debug);
  WasmBinaryWriter writer(&wasm, buffer, useOpcodeTable, options.debug);
  writer.write();

  if (options.debug) std::cerr << "writing to output..." << std::endl;
  Output output(options.extra["output"], Flags::Binary, options.debug ? Flags::Debug : Flags::Release);
  buffer.writeTo(output);

  if (options.debug) std::cerr << "Done." << std::endl;
}
