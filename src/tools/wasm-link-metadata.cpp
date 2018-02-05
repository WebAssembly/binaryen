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
// wasm-link-metadata console tool
// Reads wasm .o file and emits .json metadata
//

#include <exception>

#include "abi/wasm-object.h"
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

void parseLinkingSection(std::vector<char> const& data, uint32_t &dataSize) {
  unsigned idx = 0;
  auto get = [&idx, &data](){ return data[idx++]; };
  auto readNext = [get](){
    U32LEB leb;
    leb.read(get);
    return leb.value;
  };

  while (idx < data.size()) {
    ABI::LinkType type = static_cast<ABI::LinkType>(readNext());
    uint32_t size = readNext();
    uint32_t startIdx = idx;

    switch(type) {
    case ABI::WASM_DATA_SIZE: {
      dataSize = readNext();
      break;
    }
    default: {
      break;
    }
    }
    // Always go to the end of the subsection based on size, not contents.
    idx = startIdx + size;
  }
}

int main(int argc, const char *argv[]) {
  std::string infile;
  std::string outfile;
  Options options("wasm-link-metadata",
                  "Reads wasm .o file and emits .json metadata");
  options
      .add("--output", "-o", "Output file",
           Options::Arguments::One,
           [&outfile](Options *o, const std::string& argument) {
             outfile = argument;
             Colors::disable();
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [&infile](Options *o, const std::string& argument) {
                        infile = argument;
                      });
  options.parse(argc, argv);

  if (infile == "") {
    Fatal() << "Need to specify an infile\n";
  }

  Module wasm;
  try {
    ModuleReader reader;
    reader.readBinary(infile, wasm);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing wasm binary";
  }

  if (options.debug) {
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  uint32_t dataSize = 0;
  for (auto &section : wasm.userSections) {
    if (section.name == "linking") {
      parseLinkingSection(section.data, dataSize);
    }
  }

  std::vector<Name> initializerFunctions;
  initializerFunctions.push_back("__wasm_call_ctors");

  EmscriptenGlueGenerator generator(wasm);
  std::string metadata = generator.generateEmscriptenMetadata(dataSize, initializerFunctions);
  Output output(outfile, Flags::Text, Flags::Release);
  output << metadata;

  return 0;
}
