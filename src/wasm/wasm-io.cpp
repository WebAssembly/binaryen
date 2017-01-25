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

static std::string getSuffix(std::string filename) {
  auto index = filename.rfind('.');
  if (index == std::string::npos) return "";
  return filename.substr(index + 1);
}

void Reader::readText(std::string filename, Module& wasm) {
  auto input(read_file<std::string>(filename, Flags::Text, Flags::Release));
  SExpressionParser parser(const_cast<char*>(input.c_str()));
  Element& root = *parser.root;
  SExpressionWasmBuilder builder(wasm, *root[0]);
}

void Reader::readBinary(std::string filename, Module& wasm) {
  auto input(read_file<std::vector<char>>(filename, Flags::Binary, Flags::Release));
  WasmBinaryBuilder parser(wasm, input);
  parser.read();
}

void Reader::read(std::string filename, Module& wasm) {
  auto suffix = getSuffix(filename);
  if (suffix == "wast") {
    readText(filename, wasm);
  } else if (suffix == "wasm") {
    readBinary(filename, wasm);
  } else {
    // unclear suffix, see if this is a binary
    auto contents = read_file<std::vector<char>>(filename, Flags::Binary, Flags::Release);
    if (contents.size() >= 4 && contents[0] == '\0' && contents[0] == 'a' && contents[0] == 's' && contents[0] == 'm') {
      readBinary(filename, wasm);
    } else {
      // default to text
      readText(filename, wasm);
    }
  }
}

void Writer::writeText(Module& wasm, std::string filename) {
  Output output(filename, Flags::Text, Flags::Release);
  WasmPrinter::printModule(&wasm, output.getStream());
  output << '\n';
}

void Writer::writeBinary(Module& wasm, std::string filename) {
  BufferWithRandomAccess buffer;
  WasmBinaryWriter writer(&wasm, buffer);
  writer.write();
  Output output(filename, Flags::Binary, Flags::Release);
  buffer.writeTo(output);
}

void Writer::write(Module& wasm, std::string filename) {
  auto suffix = getSuffix(filename);
  if (suffix == "wasm") {
    writeBinary(wasm, filename);
  } else {
    // default to text
    writeText(wasm, filename);
  }
}

}

