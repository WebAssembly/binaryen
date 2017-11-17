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
// o2wasm console tool
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

bool startsWith(std::string const& str, std::string const& prefix) {
  for (unsigned i = 0; i < prefix.size(); ++i) {
    if (i >= str.size() || str[i] != prefix[i]) {
      return false;
    }
  }
  return true;
}

enum RelocType {
  R_WEBASSEMBLY_FUNCTION_INDEX_LEB = 0,
  R_WEBASSEMBLY_TABLE_INDEX_SLEB   = 1,
  R_WEBASSEMBLY_TABLE_INDEX_I32    = 2,
  R_WEBASSEMBLY_MEMORY_ADDR_LEB    = 3,
  R_WEBASSEMBLY_MEMORY_ADDR_SLEB   = 4,
  R_WEBASSEMBLY_MEMORY_ADDR_I32    = 5,
  R_WEBASSEMBLY_TYPE_INDEX_LEB     = 6,
  R_WEBASSEMBLY_GLOBAL_INDEX_LEB   = 7,
};

void parseRelocSection(
    std::vector<char> const& data,
    Module& wasm,
    std::vector<Name> &initializerFunctions) {
  unsigned idx = 0;
  auto get = [&idx, &data](){ return data[idx++]; };
  auto readNext = [get](){
    U32LEB leb;
    leb.read(get);
    return leb.value;
  };
  uint32_t section_id = readNext();
  if (section_id == 0) {
    Fatal() << "TODO: implement section_id=0\n";
  }
  uint32_t count = readNext();
  for (uint32_t i = 0; i < count; ++i) {
    RelocType type = static_cast<RelocType>(readNext());
    uint32_t offset = readNext();
    (void)offset;
    uint32_t index = readNext();
    switch (type) {
    case R_WEBASSEMBLY_TABLE_INDEX_I32: {
      // Assumption: LLD only creates a table for initializer functions.
      Function* func = wasm.functions[index].get();
      initializerFunctions.push_back(func->name);
      break;
    }
    case R_WEBASSEMBLY_FUNCTION_INDEX_LEB:
    case R_WEBASSEMBLY_TABLE_INDEX_SLEB:
    case R_WEBASSEMBLY_TYPE_INDEX_LEB:
    case R_WEBASSEMBLY_GLOBAL_INDEX_LEB:
      break;
    case R_WEBASSEMBLY_MEMORY_ADDR_LEB:
    case R_WEBASSEMBLY_MEMORY_ADDR_SLEB:
    case R_WEBASSEMBLY_MEMORY_ADDR_I32: {
      uint32_t addend = readNext();
      (void)addend;
      break;
    }
    default:
      Fatal() << "Invalid relocation type: " << type << "\n";
    }
  }
}

enum LinkType : unsigned {
  WASM_STACK_POINTER  = 0x1,
  WASM_SYMBOL_INFO    = 0x2,
  WASM_DATA_SIZE      = 0x3,
  WASM_DATA_ALIGNMENT = 0x4,
  WASM_SEGMENT_INFO   = 0x5,
};

void parseLinkingSection(std::vector<char> const& data, uint32_t &dataSize) {
  unsigned idx = 0;
  auto get = [&idx, &data](){ return data[idx++]; };
  auto readNext = [get](){
    U32LEB leb;
    leb.read(get);
    return leb.value;
  };

  while (idx < data.size()) {
    LinkType type = static_cast<LinkType>(readNext());
    uint32_t size = readNext();

    switch(type) {
    case WASM_DATA_SIZE: {
      dataSize = readNext();
      break;
    }
    default:
      idx += size;
      break;
    }
  }
}

int main(int argc, const char *argv[]) {
  std::string infile;
  Options options("o2wasm", "Link .o file into .wasm");
  options
      .add_positional("INFILE", Options::Arguments::One,
                      [&infile](Options *o, const std::string &argument) {
                        infile = argument;
                      });
  options.parse(argc, argv);

  if (infile == "") {
    Fatal() << "Need to specify an infile\n";
  }

  Module wasm;
  ModuleReader reader;
  reader.readBinary(infile, wasm);

  if (options.debug) {
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  uint32_t dataSize = 0;
  std::vector<Name> initializerFunctions;

  for (auto &section : wasm.userSections) {
    if (startsWith(section.name, "reloc")) {
      parseRelocSection(section.data, wasm, initializerFunctions);
    } else if (section.name == "linking") {
      parseLinkingSection(section.data, dataSize);
    }
  }

  EmscriptenGlueGenerator generator(wasm);
  std::string metadata = generator.generateEmscriptenMetadata(dataSize, initializerFunctions);
  std::cout << metadata;

  return 0;
}
