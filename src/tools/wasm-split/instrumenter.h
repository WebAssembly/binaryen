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

// Add a global monotonic counter and a timestamp global for each function, code
// at the beginning of each function to set its timestamp, and a new exported
// function for dumping the profile data.
struct Instrumenter : public Pass {
  PassRunner* runner = nullptr;
  Module* wasm = nullptr;

  const WasmSplitOptions& options;
  uint64_t moduleHash;

  Name counterGlobal;
  std::vector<Name> functionGlobals;

  Instrumenter(const WasmSplitOptions& options, uint64_t moduleHash);

  void run(PassRunner* runner, Module* wasm) override;

private:
  void addGlobals();
  void instrumentFuncs();
  void addProfileExport();
};

} // namespace wasm

#endif // wasm_tools_wasm_split_instrumenter_h
