/*
 * Copyright 2019 WebAssembly Community Group participants
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
// Dump DWARF sections. This results in something similar to llvm-dwarfdump,
// as it uses the same code.
//
// Note that this dumps the DWARF data read from the binary when we loaded it.
// It does not contain changes made since then, which will only be updated
// when we write the binary. To see those changes, you must round-trip.
//

#include "pass.h"
#include "wasm-debug.h"
#include "wasm.h"

namespace wasm {

struct DWARFDump : public Pass {
  void run(Module* module) override { Debug::dumpDWARF(*module); }
};

Pass* createDWARFDumpPass() { return new DWARFDump(); }

} // namespace wasm
