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
// Abstracts reading and writing, supporting both text and binary
// depending on the suffix.
//
// When the suffix is unclear, writing defaults to text (this
// allows odd suffixes, which we use in the test suite), while
// reading will check the magic number and default to text if not
// binary.
//

#include "wasm-io.h"
#include "support/debug.h"
#include "wasm-binary.h"
#include "wasm-s-parser.h"
#include "wat-parser.h"


namespace wasm {

bool useNewWATParser = false;

#define DEBUG_TYPE "writer"

static void readTextData(std::string& input, Module& wasm, IRProfile profile) {
  if (useNewWATParser) {
    std::string_view in(input.c_str());
    if (auto parsed = WATParser::parseModule(wasm, in);
        auto err = parsed.getErr()) {
      Fatal() << err->msg;
    }
  } else {
    SExpressionParser parser(const_cast<char*>(input.c_str()));
    Element& root = *parser.root;
    SExpressionWasmBuilder builder(wasm, *root[0], profile);
  }
}

void ModuleReader::readText(wasm::fspath filename, Module& wasm) {
  BYN_TRACE("reading text from " << filename.stdpath() << "\n");
  auto input(read_file<std::string>(filename, Flags::Text));
  readTextData(input, wasm, profile);
}

void ModuleReader::readBinaryData(std::vector<char>& input,
                                  Module& wasm,
                                  wasm::fspath sourceMapFilename) {
  std::unique_ptr<std::ifstream> sourceMapStream;
  // Assume that the wasm has had its initial features applied, and use those
  // while parsing.
  WasmBinaryBuilder parser(wasm, wasm.features, input);
  parser.setDebugInfo(debugInfo);
  parser.setDWARF(DWARF);
  parser.setSkipFunctionBodies(skipFunctionBodies);
  if (sourceMapFilename.stdpath().native().size()) {
    sourceMapStream = make_unique<std::ifstream>();
    sourceMapStream->open(sourceMapFilename.stdpath());
    parser.setDebugLocations(sourceMapStream.get());
  }
  parser.read();
  if (sourceMapStream) {
    sourceMapStream->close();
  }
}

void ModuleReader::readBinary(wasm::fspath filename,
                              Module& wasm,
                              wasm::fspath sourceMapFilename) {
  BYN_TRACE("reading binary from " << filename.stdpath() << "\n");
  auto input(read_file<std::vector<char>>(filename, Flags::Binary));
  readBinaryData(input, wasm, sourceMapFilename);
}

bool ModuleReader::isBinaryFile(wasm::fspath filename) {
  std::ifstream infile;
  std::ios_base::openmode flags = std::ifstream::in | std::ifstream::binary;
  infile.open(filename.stdpath(), flags);
  char buffer[4] = {1, 2, 3, 4};
  infile.read(buffer, 4);
  infile.close();
  return buffer[0] == '\0' && buffer[1] == 'a' && buffer[2] == 's' &&
         buffer[3] == 'm';
}

void ModuleReader::read(wasm::fspath filename,
                        Module& wasm,
                        wasm::fspath sourceMapFilename) {
  // empty filename or "-" means read from stdin
  if (!filename.stdpath().native().size() || filename.stdpath() == "-") {
    readStdin(wasm, sourceMapFilename);
    return;
  }
  if (isBinaryFile(filename)) {
    readBinary(filename, wasm, sourceMapFilename);
  } else {
    // default to text
    if (sourceMapFilename.stdpath().native().size()) {
      std::cerr << "Binaryen ModuleReader::read() - source map filename "
                   "provided, but file appears to not be binary\n";
    }
    readText(filename, wasm);
  }
}

// TODO: reading into a vector<char> then copying into a string is unnecessarily
// inefficient. It would be better to read just once into a stringstream.
void ModuleReader::readStdin(Module& wasm, wasm::fspath sourceMapFilename) {
  std::vector<char> input = read_stdin();
  if (input.size() >= 4 && input[0] == '\0' && input[1] == 'a' &&
      input[2] == 's' && input[3] == 'm') {
    readBinaryData(input, wasm, sourceMapFilename);
  } else {
    std::ostringstream s;
    s.write(input.data(), input.size());
    s << '\0';
    std::string input_str = s.str();
    readTextData(input_str, wasm, profile);
  }
}

#undef DEBUG_TYPE
#define DEBUG_TYPE "writer"

void ModuleWriter::writeText(Module& wasm, Output& output) {
  output.getStream() << wasm;
}

void ModuleWriter::writeText(Module& wasm, wasm::fspath filename) {
  BYN_TRACE("writing text to " << filename.stdpath() << "\n");
  Output output(filename, Flags::Text);
  writeText(wasm, output);
}

void ModuleWriter::writeBinary(Module& wasm, Output& output) {
  BufferWithRandomAccess buffer;
  WasmBinaryWriter writer(&wasm, buffer);
  // if debug info is used, then we want to emit the names section
  writer.setNamesSection(debugInfo);
  if (emitModuleName) {
    writer.setEmitModuleName(true);
  }
  std::unique_ptr<std::ofstream> sourceMapStream;
  if (sourceMapFilename.stdpath().native().size()) {
    sourceMapStream = make_unique<std::ofstream>();
    sourceMapStream->open(sourceMapFilename.stdpath());
    writer.setSourceMap(sourceMapStream.get(), sourceMapUrl);
  }
  if (symbolMap.stdpath().native().size() > 0) {
    writer.setSymbolMap(symbolMap);
  }
  writer.write();
  buffer.writeTo(output);
  if (sourceMapStream) {
    sourceMapStream->close();
  }
}

void ModuleWriter::writeBinary(Module& wasm, wasm::fspath filename) {
  BYN_TRACE("writing binary to " << filename.stdpath() << "\n");
  Output output(filename, Flags::Binary);
  writeBinary(wasm, output);
}

void ModuleWriter::write(Module& wasm, Output& output) {
  if (binary) {
    writeBinary(wasm, output);
  } else {
    writeText(wasm, output);
  }
}

void ModuleWriter::write(Module& wasm, wasm::fspath filename) {
  if (binary && filename.stdpath().native().size() > 0) {
    writeBinary(wasm, filename);
  } else {
    writeText(wasm, filename);
  }
}

} // namespace wasm
