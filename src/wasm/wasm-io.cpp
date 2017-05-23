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
#include "wasm-s-parser.h"
#include "wasm-binary.h"
#include "support/file.h"

namespace wasm {

void ModuleReader::readText(std::string filename, Module& wasm) {
  if (debug) std::cerr << "reading text from " << filename << "\n";
  auto input(read_file<std::string>(filename, Flags::Text, debug ? Flags::Debug : Flags::Release));
  SExpressionParser parser(const_cast<char*>(input.c_str()));
  Element& root = *parser.root;
  SExpressionWasmBuilder builder(wasm, *root[0]);
}

void ModuleReader::readBinary(std::string filename, Module& wasm) {
  if (debug) std::cerr << "reading binary from " << filename << "\n";
  auto input(read_file<std::vector<char>>(filename, Flags::Binary, debug ? Flags::Debug : Flags::Release));
  WasmBinaryBuilder parser(wasm, input, debug);
  parser.read();
}

void ModuleReader::read(std::string filename, Module& wasm) {
  // see if this is a wasm binary
  std::ifstream infile;
  std::ios_base::openmode flags = std::ifstream::in | std::ifstream::binary;
  infile.open(filename, flags);
  char buffer[4] = { 1, 2, 3, 4 };
  infile.read(buffer, 4);
  infile.close();
  if (buffer[0] == '\0' && buffer[1] == 'a' && buffer[2] == 's' && buffer[3] == 'm') {
    readBinary(filename, wasm);
  } else {
    // default to text
    readText(filename, wasm);
  }
}

void ModuleWriter::writeText(Module& wasm, std::string filename) {
  if (debug) std::cerr << "writing text to " << filename << "\n";
  Output output(filename, Flags::Text, debug ? Flags::Debug : Flags::Release);
  WasmPrinter::printModule(&wasm, output.getStream());
}

void ModuleWriter::writeBinary(Module& wasm, std::string filename) {
  if (debug) std::cerr << "writing binary to " << filename << "\n";
  BufferWithRandomAccess buffer(debug);
  WasmBinaryWriter writer(&wasm, buffer, debug);
  // if debug info is used, then we want to emit the names section
  writer.setNamesSection(debugInfo);
  std::unique_ptr<std::ofstream> sourceMapStream;
  if (sourceMapFilename.size()) {
    sourceMapStream = make_unique<std::ofstream>();
    sourceMapStream->open(sourceMapFilename);
    writer.setSourceMap(sourceMapStream.get(), sourceMapUrl);
  }
  if (symbolMap.size() > 0) writer.setSymbolMap(symbolMap);
  writer.write();
  Output output(filename, Flags::Binary, debug ? Flags::Debug : Flags::Release);
  buffer.writeTo(output);
  if (sourceMapStream) {
    sourceMapStream->close();
  }
}

void ModuleWriter::write(Module& wasm, std::string filename) {
  if (binary && filename.size() > 0) {
    writeBinary(wasm, filename);
  } else {
    writeText(wasm, filename);
  }
}

}
