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
// lld-metadata console tool
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

enum LinkType : unsigned {
  WASM_STACK_POINTER  = 0x1,
  WASM_SYMBOL_INFO    = 0x2,
  WASM_DATA_SIZE      = 0x3,
  WASM_DATA_ALIGNMENT = 0x4,
  WASM_SEGMENT_INFO   = 0x5,
  WASM_INIT_FUNCS     = 0x6,
};

void parseLinkingSection(
    std::vector<char> const& data,
    Module& wasm,
    uint32_t &dataSize,
    std::vector<Name> &initializerFunctions) {
  unsigned idx = 0;
  auto get = [&idx, &data](){ return data[idx++]; };
  auto readNext = [get](){
    U32LEB leb;
    leb.read(get);
    return leb.value;
  };

  uint32_t importedFunctions = 0;
  for (auto& import : wasm.imports) {
    if (import->kind != ExternalKind::Function) continue;
    importedFunctions++;
  }

  while (idx < data.size()) {
    LinkType type = static_cast<LinkType>(readNext());
    uint32_t size = readNext();
    uint32_t startIdx = idx;

    switch(type) {
    case WASM_DATA_SIZE: {
      dataSize = readNext();
      break;
    }
    case WASM_INIT_FUNCS: {
      uint32_t numInit = readNext();
      for (uint32_t i = 0; i < numInit; ++i) {
        uint32_t priority = readNext();
        (void)priority;
        uint32_t rawIdx = readNext();
        uint32_t functionIdx = rawIdx - importedFunctions;
        auto name = wasm.functions[functionIdx]->name;
        initializerFunctions.push_back(name);
      }
      break;
    }
    default:
      break;
    }
    idx = startIdx + size;
  }
}

int main(int argc, const char *argv[]) {
  std::string infile;
  std::string outfile;
  Options options("o2wasm", "Link .o file into .wasm");
  options
      .add("--output", "-o", "Output file",
           Options::Arguments::One,
           [&outfile](Options *o, const std::string &argument) {
             outfile = argument;
             Colors::disable();
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [&infile](Options *o, const std::string &argument) {
                        infile = argument;
                      });
  options.parse(argc, argv);

  if (infile == "") {
    Fatal() << "Need to specify an infile\n";
  }

  Module wasm;
  try {
    ModuleReader reader;
    reader.readObject(infile, wasm);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing wasm binary";
  }

  if (options.debug) {
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  uint32_t dataSize = 0;
  std::vector<Name> initializerFunctions;

  for (auto &section : wasm.userSections) {
    if (section.name == "linking") {
      parseLinkingSection(section.data, wasm, dataSize, initializerFunctions);
    }
  }

  EmscriptenGlueGenerator generator(wasm);
  std::string metadata = generator.generateEmscriptenMetadata(dataSize, initializerFunctions);
  Output output(outfile, Flags::Text, Flags::Release);
  output << metadata;

  return 0;
}
