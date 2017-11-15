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

std::string relocTypeName(RelocType type) {
  switch (type) {
  case R_WEBASSEMBLY_FUNCTION_INDEX_LEB: return "R_WEBASSEMBLY_FUNCTION_INDEX_LEB";
  case R_WEBASSEMBLY_TABLE_INDEX_SLEB:   return "R_WEBASSEMBLY_TABLE_INDEX_SLEB";
  case R_WEBASSEMBLY_TABLE_INDEX_I32:    return "R_WEBASSEMBLY_TABLE_INDEX_I32";
  case R_WEBASSEMBLY_MEMORY_ADDR_LEB:    return "R_WEBASSEMBLY_MEMORY_ADDR_LEB";
  case R_WEBASSEMBLY_MEMORY_ADDR_SLEB:   return "R_WEBASSEMBLY_MEMORY_ADDR_SLEB";
  case R_WEBASSEMBLY_MEMORY_ADDR_I32:    return "R_WEBASSEMBLY_MEMORY_ADDR_I32";
  case R_WEBASSEMBLY_TYPE_INDEX_LEB:     return "R_WEBASSEMBLY_TYPE_INDEX_LEB";
  case R_WEBASSEMBLY_GLOBAL_INDEX_LEB:   return "R_WEBASSEMBLY_GLOBAL_INDEX_LEB";
  default: Fatal() << "Unknown reloc type: " << type << "\n"; return "";
  }
}

void parseReloc(std::vector<char> const& data) {
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
    case R_WEBASSEMBLY_FUNCTION_INDEX_LEB:
    case R_WEBASSEMBLY_TABLE_INDEX_SLEB:
    case R_WEBASSEMBLY_TABLE_INDEX_I32:
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

  std::cerr << "User sections:\n";
  for (auto &section : wasm.userSections) {
    std::cerr << "  " << section.name << "\n";
    if (startsWith(section.name, "reloc")) {
      std::cerr << "    starts with reloc!\n";
      parseReloc(section.data);
    }
  }

  auto memoryExport = make_unique<Export>();
  memoryExport->name = MEMORY;
  memoryExport->value = Name::fromInt(0);
  memoryExport->kind = ExternalKind::Memory;
  wasm.addExport(memoryExport.release());

  ModuleWriter writer;
  writer.writeBinary(wasm, outfile);

  return 0;
}
