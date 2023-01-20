/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_tools_wasm_split_options_h
#define wasm_tools_wasm_split_options_h

#include "tools/tool-options.h"

namespace wasm {

const std::string DEFAULT_PROFILE_EXPORT("__write_profile");

struct WasmSplitOptions : ToolOptions {
  enum class Mode : unsigned {
    Split,
    Instrument,
    MergeProfiles,
    PrintProfile,
  };
  Mode mode = Mode::Split;
  constexpr static size_t NumModes =
    static_cast<unsigned>(Mode::PrintProfile) + 1;

  enum class StorageKind : unsigned {
    InGlobals, // Store profile data in WebAssembly Globals
    InMemory,  // Store profile data in memory, accessible from all threads
    InSecondaryMemory, // Store profile data in memory separate from main memory
  };
  StorageKind storageKind = StorageKind::InGlobals;

  bool unescape = false;
  bool verbose = false;
  bool emitBinary = true;
  bool symbolMap = false;
  bool placeholderMap = false;
  bool jspi = false;

  // TODO: Remove this. See the comment in wasm-binary.h.
  bool emitModuleNames = false;

  std::string profileFile;
  std::string profileExport = DEFAULT_PROFILE_EXPORT;

  std::set<Name> keepFuncs;
  std::set<Name> splitFuncs;

  std::vector<std::string> inputFiles;
  std::string output;
  std::string primaryOutput;
  std::string secondaryOutput;

  std::string importNamespace;
  std::string placeholderNamespace;
  std::string secondaryMemoryName;
  std::string exportPrefix;

  // A hack to ensure the split and instrumented modules have the same table
  // size when using Emscripten's SPLIT_MODULE mode with dynamic linking. TODO:
  // Figure out a more elegant solution for that use case and remove this.
  int initialTableSize = -1;

  // The options that are valid for each mode.
  std::array<std::unordered_set<std::string>, NumModes> validOptions;
  std::vector<std::string> usedOptions;

  WasmSplitOptions();
  WasmSplitOptions& add(const std::string& longName,
                        const std::string& shortName,
                        const std::string& description,
                        const std::string& category,
                        std::vector<Mode>&& modes,
                        Arguments arguments,
                        const Action& action);
  WasmSplitOptions& add(const std::string& longName,
                        const std::string& shortName,
                        const std::string& description,
                        const std::string& category,
                        Arguments arguments,
                        const Action& action);
  bool validate();
  void parse(int argc, const char* argv[]);
};

} // namespace wasm

#endif // wasm_tools_wasm_split_h
