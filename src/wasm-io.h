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

#include "parsing.h"
#include "pass.h"
#include "support/file.h"
#include "wasm.h"

namespace wasm {

// TODO: Remove this after switching to the new WAT parser by default and
// removing the old one.
extern bool useNewWATParser;

class ModuleIOBase {
protected:
  bool debugInfo;

public:
  // Whether we support debug info (the names section).
  void setDebugInfo(bool debugInfo_) { debugInfo = debugInfo_; }
};

class ModuleReader : public ModuleIOBase {
public:
  // Reading defaults to loading the names section. Name section info is used in
  // various internal ways that we do not opt-in to currently.
  ModuleReader() { setDebugInfo(true); }

  // If DWARF support is enabled, we track the locations of all IR nodes in
  // the binary, so that we can update DWARF sections later when writing.
  void setDWARF(bool DWARF_) { DWARF = DWARF_; }

  void setProfile(IRProfile profile_) { profile = profile_; }

  // TODO: add support for this in the text format as well
  void setSkipFunctionBodies(bool skipFunctionBodies_) {
    skipFunctionBodies = skipFunctionBodies_;
  }

  // read text
  void readText(std::string filename, Module& wasm);
  // read binary
  void readBinary(std::string filename,
                  Module& wasm,
                  std::string sourceMapFilename = "");
  // read text or binary, checking the contents for what it is. If `filename` is
  // empty, read from stdin.
  void
  read(std::string filename, Module& wasm, std::string sourceMapFilename = "");
  // check whether a file is a wasm binary
  bool isBinaryFile(std::string filename);

private:
  bool DWARF = false;

  IRProfile profile = IRProfile::Normal;

  bool skipFunctionBodies = false;

  void readStdin(Module& wasm, std::string sourceMapFilename);

  void readBinaryData(std::vector<char>& input,
                      Module& wasm,
                      std::string sourceMapFilename);
};

class ModuleWriter : public ModuleIOBase {
  const PassOptions& options;

  bool binary = true;

  // TODO: Remove `emitModuleName`. See the comment in wasm-binary.h
  bool emitModuleName = false;

  std::string symbolMap;
  std::string sourceMapFilename;
  std::string sourceMapUrl;

public:
  // Writing defaults to not storing the names section. Storing it is a user-
  // observable fact that must be opted into.
  ModuleWriter(const PassOptions& options) : options(options) {
    setDebugInfo(false);
  }

  void setBinary(bool binary_) { binary = binary_; }
  void setSymbolMap(std::string symbolMap_) { symbolMap = symbolMap_; }
  void setSourceMapFilename(std::string sourceMapFilename_) {
    sourceMapFilename = sourceMapFilename_;
  }
  void setSourceMapUrl(std::string sourceMapUrl_) {
    sourceMapUrl = sourceMapUrl_;
  }
  void setEmitModuleName(bool set) { emitModuleName = set; }

  // write text
  void writeText(Module& wasm, Output& output);
  void writeText(Module& wasm, std::string filename);
  // write binary
  void writeBinary(Module& wasm, Output& output);
  void writeBinary(Module& wasm, std::string filename);
  // write text or binary, defaulting to binary unless setBinary(false),
  // and unless there is no output file (in which case we write text
  // to stdout).
  void write(Module& wasm, Output& output);
  void write(Module& wasm, std::string filename);
};

} // namespace wasm

#endif // wasm_wasm_io_h
