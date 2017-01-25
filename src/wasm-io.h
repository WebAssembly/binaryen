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

#ifndef wasm_wasm_io_h
#define wasm_wasm_io_h

#include "wasm.h"

namespace wasm {

class Reader {
  std::string filename;

  void readText();
  void readBinary();

public:
  Reader(std::string filename) : filename(filename) {}
  void read(Module& wasm);
};

class Writer {
  std::string filename;

  void writeText();
  void writeBinary();

public:
  Writer(std::string filename) : filename(filename) {}
  void write(const Module& wasm);
};

}

#endif // wasm_wasm_io_h
