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
// Abstracts reading and writing, supporting both text and binary.
//

#ifndef wasm_wasm_io_h
#define wasm_wasm_io_h

#include "wasm.h"
#include "parsing.h"

namespace wasm {

class ModuleIO {
protected:
  bool debug = false;

public:
  void setDebug(bool debug_) { debug = debug_; }
};

class ModuleReader : public ModuleIO {
public:
  // read text
  void readText(std::string filename, Module& wasm);
  // read binary
  void readBinary(std::string filename, Module& wasm);
  // read text or binary, checking the contents for what it is
  void read(std::string filename, Module& wasm);
};

class ModuleWriter : public ModuleIO {
  bool binary = true;
  bool debugInfo = false;
  std::string symbolMap;
  std::string sourceMapFilename;
  std::string sourceMapUrl;

public:
  void setBinary(bool binary_) { binary = binary_; }
  void setDebugInfo(bool debugInfo_) { debugInfo = debugInfo_; }
  void setSymbolMap(std::string symbolMap_) { symbolMap = symbolMap_; }
  void setSourceMapFilename(std::string sourceMapFilename_) { sourceMapFilename = sourceMapFilename_; }
  void setSourceMapUrl(std::string sourceMapUrl_) { sourceMapUrl = sourceMapUrl_; }

  // write text
  void writeText(Module& wasm, std::string filename);
  // write binary
  void writeBinary(Module& wasm, std::string filename);
  // write text or binary, defaulting to binary unless setBinary(false),
  // and unless there is no output file (in which case we write text
  // to stdout).
  void write(Module& wasm, std::string filename);
};

}

#endif // wasm_wasm_io_h
