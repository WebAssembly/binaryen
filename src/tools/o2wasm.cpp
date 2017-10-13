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

#include "ast/trapping.h"
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
  default: Fatal() << "Unknown reloc type: " << type << "\n";
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
    uint32_t addend;
    switch (type) {
    case R_WEBASSEMBLY_FUNCTION_INDEX_LEB:
    case R_WEBASSEMBLY_TABLE_INDEX_SLEB:
    case R_WEBASSEMBLY_TABLE_INDEX_I32:
    case R_WEBASSEMBLY_TYPE_INDEX_LEB:
    case R_WEBASSEMBLY_GLOBAL_INDEX_LEB:
      break;
    case R_WEBASSEMBLY_MEMORY_ADDR_LEB:
    case R_WEBASSEMBLY_MEMORY_ADDR_SLEB:
    case R_WEBASSEMBLY_MEMORY_ADDR_I32:
      addend = readNext();
      break;
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

  // if (allowMemoryGrowth && !generateEmscriptenGlue) {
  //   Fatal() << "Error: adding memory growth code without Emscripten glue. "
  //     "This doesn't do anything.\n";
  // }

  // auto debugFlag = options.debug ? Flags::Debug : Flags::Release;
  // auto input(read_file<std::string>(options.extra["infile"], Flags::Text, debugFlag));

  // if (options.debug) std::cerr << "Parsing and wasming..." << std::endl;
  // uint64_t globalBase = options.extra.find("global-base") != options.extra.end()
  //                         ? std::stoull(options.extra["global-base"])
  //                         : 0;
  // uint64_t stackAllocation =
  //     options.extra.find("stack-allocation") != options.extra.end()
  //         ? std::stoull(options.extra["stack-allocation"])
  //         : 0;
  // uint64_t initialMem =
  //     options.extra.find("initial-memory") != options.extra.end()
  //         ? std::stoull(options.extra["initial-memory"])
  //         : 0;
  // uint64_t maxMem =
  //     options.extra.find("max-memory") != options.extra.end()
  //         ? std::stoull(options.extra["max-memory"])
  //         : 0;
  // if (options.debug) std::cerr << "Global base " << globalBase << '\n';

  // Linker linker(globalBase, stackAllocation, initialMem, maxMem,
  //               importMemory || generateEmscriptenGlue, ignoreUnknownSymbols, startFunction,
  //               options.debug);

  // S2WasmBuilder mainbuilder(input.c_str(), options.debug);
  // linker.linkObject(mainbuilder);

  // if (trapMode != TrapMode::Allow) {
  //   Module* wasm = &(linker.getOutput().wasm);
  //   PassRunner runner(wasm);
  //   addTrapModePass(runner, trapMode);
  //   runner.run();
  // }

  // for (const auto& m : archiveLibraries) {
  //   auto archiveFile(read_file<std::vector<char>>(m, Flags::Binary, debugFlag));
  //   bool error;
  //   Archive lib(archiveFile, error);
  //   if (error) Fatal() << "Error opening archive " << m << "\n";
  //   linker.linkArchive(lib);
  // }

  // if (generateEmscriptenGlue) {
  //   emscripten::generateRuntimeFunctions(linker.getOutput());
  // }

  // linker.layout();

  // std::stringstream meta;
  // if (generateEmscriptenGlue) {
  //   if (options.debug) std::cerr << "Emscripten gluing..." << std::endl;
  //   if (allowMemoryGrowth) {
  //     emscripten::generateMemoryGrowthFunction(linker.getOutput().wasm);
  //   }

  //   // dyncall thunks
  //   linker.emscriptenGlue(meta);
  // }

  // if (options.extra["validate"] != "none") {
  //   if (options.debug) std::cerr << "Validating..." << std::endl;
  //   if (!wasm::WasmValidator().validate(linker.getOutput().wasm,
  //        WasmValidator::Globally | (options.extra["validate"] == "web" ? WasmValidator::Web : 0))) {
  //     Fatal() << "Error: linked module is not valid.\n";
  //   }
  // }

  // if (options.debug) std::cerr << "Printing..." << std::endl;
  // Output output(options.extra["output"], Flags::Text, options.debug ? Flags::Debug : Flags::Release);
  // WasmPrinter::printModule(&linker.getOutput().wasm, output.getStream());
  // output << meta.str();

  // if (options.debug) std::cerr << "Done." << std::endl;
  return 0;
}
