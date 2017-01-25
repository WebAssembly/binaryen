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

class ModuleIO {
  bool debug = false;

public:
  void setDebug(bool debug_) { debug = debug_; }
};

class ModuleReader : public ModuleIO {
  void readText(std::string filename, Module& wasm);
  void readBinary(std::string filename, Module& wasm);

public:
  void read(std::string filename, Module& wasm);
};

class ModuleWriter : public ModuleIO {
  bool debugInfo = false;
  std::string symbolMap;

  void writeText(Module& wasm, std::string filename);
  void writeBinary(Module& wasm, std::string filename);

public:
  void setDebugInfo(bool debugInfo_) { debugInfo = debugInfo_; }
  void setSymbolMap(bool symbolMap_) { symbolMap = symbolMap_; }

  void write(Module& wasm, std::string filename);
};

}

#endif // wasm_wasm_io_h
