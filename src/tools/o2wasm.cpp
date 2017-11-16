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

//*/
#define P(x) std::cerr << #x ": " << x << std::endl
/*/
#define P(x) (void)x
//*/

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

#define STR_CASE(val) case val: return #val;

std::string relocTypeName(RelocType type) {
  switch (type) {
  STR_CASE(R_WEBASSEMBLY_FUNCTION_INDEX_LEB)
  STR_CASE(R_WEBASSEMBLY_TABLE_INDEX_SLEB)
  STR_CASE(R_WEBASSEMBLY_TABLE_INDEX_I32)
  STR_CASE(R_WEBASSEMBLY_MEMORY_ADDR_LEB)
  STR_CASE(R_WEBASSEMBLY_MEMORY_ADDR_SLEB)
  STR_CASE(R_WEBASSEMBLY_MEMORY_ADDR_I32)
  STR_CASE(R_WEBASSEMBLY_TYPE_INDEX_LEB)
  STR_CASE(R_WEBASSEMBLY_GLOBAL_INDEX_LEB)
  default:
    Fatal() << "Unknown reloc type: " << type << "\n";
    return "";
  }
}

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
  P(section_id);
  P(count);
  for (uint32_t i = 0; i < count; ++i) {
    RelocType type = static_cast<RelocType>(readNext());
    uint32_t offset = readNext();
    uint32_t index = readNext();
    P(relocTypeName(type));
    P(offset);
    P(index);
    switch (type) {
    case R_WEBASSEMBLY_TABLE_INDEX_I32: {
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
      std::cerr << "Read an addend: " << addend << "\n";
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

std::string linkTypeName(LinkType type) {
  switch (type) {
  STR_CASE(WASM_STACK_POINTER)
  STR_CASE(WASM_SYMBOL_INFO)
  STR_CASE(WASM_DATA_SIZE)
  STR_CASE(WASM_DATA_ALIGNMENT)
  STR_CASE(WASM_SEGMENT_INFO)
  default:
    Fatal() << "Unknown reloc type: " << type << "\n";
    return "";
  }
}

void parseLinkingSection(std::vector<char> const& data, uint32_t &dataSize) {
  unsigned idx = 0;
  auto get = [&idx, &data](){ return data[idx++]; };
  auto readNext = [get](){
    U32LEB leb;
    leb.read(get);
    return leb.value;
  };
  auto readString = [get, readNext](){
    uint32_t len = readNext();
    std::string str = "";
    for (uint32_t i = 0; i < len; ++i) {
      str += (char)readNext();
    }
    return str;
  };
  P(data.size());

  while (idx < data.size()) {
    P(idx);
    LinkType type = static_cast<LinkType>(readNext());
    uint32_t size = readNext();
    std::cerr << "link-section " << linkTypeName(type) << " of size " << size << '\n';

    // !! stackPointerOffset !! - find by scanning Imports for "__stack_pointer"
    switch(type) {
    case WASM_SYMBOL_INFO: {
      uint32_t count = readNext();
      for (uint32_t i = 0; i < count; ++i) {
        std::string sym = readString();
        uint32_t flags = readNext();
        std::cerr << "  sym: " << sym << " , flags=" << flags << '\n';
      }
      break;
    }
    case WASM_DATA_SIZE: {
      dataSize = readNext(); // !! staticBump !!
      std::cerr << "  datasize: " << dataSize << '\n';
      break;
    }
    case WASM_SEGMENT_INFO: {
      uint32_t count = readNext();
      for (uint32_t i = 0; i < count; ++i) {
        std::string name = readString();
        uint32_t alignment = readNext();
        uint32_t flags = readNext();
        std::cerr << "  name: " << name << " , align=" << alignment
          << " flags=" << flags << '\n';
      }
      break;
    }
    default:
      idx += size;
      break;
    }
  }
  P(idx);
}

int main(int argc, const char *argv[]) {
  // bool ignoreUnknownSymbols = false;
  // bool generateEmscriptenGlue = false;
  // bool allowMemoryGrowth = false;
  // bool importMemory = false;
  // std::string startFunction;
  std::string infile;
  std::string outfile;
  // std::vector<std::string> archiveLibraries;
  // TrapMode trapMode = TrapMode::Allow;
  Options options("o2wasm", "Link .o file into .wasm");
  // options.extra["validate"] = "wasm";
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
  if (outfile == "") {
    Fatal() << "Need to specify an outfile\n";
  }

  Module wasm;
  ModuleReader reader;
  reader.readBinary(infile, wasm);

  std::cerr << "Oh hey we made it, nice\n";

  if (options.debug) {
    WasmPrinter::printModule(&wasm, std::cerr);
  }

  uint32_t dataSize = 0;
  std::vector<Name> initializerFunctions;

  std::cerr << "User sections:\n";
  for (auto &section : wasm.userSections) {
    std::cerr << "  " << section.name << "\n";
    if (startsWith(section.name, "reloc")) {
      std::cerr << "    starts with reloc!\n";
      parseRelocSection(section.data, wasm, initializerFunctions);
    } else if (startsWith(section.name, "linking")) {
      std::cerr << "    starts with linking!\n";
      parseLinkingSection(section.data, dataSize);
    }
  }

  EmscriptenGlueGenerator generator(wasm);
  std::string metadata = generator.generateEmscriptenMetadata(dataSize, initializerFunctions);
  std::cerr << "Generated metadata:\n\n" << metadata << '\n';

  auto memoryExport = make_unique<Export>();
  memoryExport->name = MEMORY;
  memoryExport->value = Name::fromInt(0);
  memoryExport->kind = ExternalKind::Memory;
  wasm.addExport(memoryExport.release());

  ModuleWriter writer;
  writer.writeBinary(wasm, outfile);

  return 0;
}
