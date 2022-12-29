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

#ifndef wasm_tools_wasm_split_instrumenter_h
#define wasm_tools_wasm_split_instrumenter_h

#include "pass.h"
#include "split-options.h"
#include "wasm.h"

namespace wasm {

// Adds code at the beginning of each function that keeps track of whether the function was called in memory,
// and a new exported function for dumping the profile data.
struct Instrumenter : public Pass {
  Module* wasm = nullptr;

  const WasmSplitOptions& options;
  uint64_t moduleHash;

  Name counterGlobal;
  std::vector<Name> functionGlobals;

  Name secondaryMemory;

  Instrumenter(const WasmSplitOptions& options, uint64_t moduleHash);

  void run(Module* wasm) override;

private:
  void ensureFirstMemory(size_t profileSize);
  void addGlobals(size_t numFuncs);
  void addSecondaryMemory(size_t numFuncs);
  void instrumentFuncs();
  void addProfileExport(size_t profileSize, size_t numFuncs);
};

} // namespace wasm

#endif // wasm_tools_wasm_split_instrumenter_h
