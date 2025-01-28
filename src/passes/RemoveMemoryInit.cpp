/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Removes memory segments, leaving only code in the module. It also removes
// the start function, which (in LLVM use cases) is only used for initializing
// the memory.

#include <pass.h>
#include <wasm.h>

namespace wasm {

struct RemoveMemoryInit : public Pass {
  void run(Module* module) override {
    module->removeDataSegments([&](DataSegment* curr) { return true; });
    if (module->start) {
      module->removeFunction(module->start);
      module->start = Name();
    }
  }
};

Pass* createRemoveMemoryInitPass() { return new RemoveMemoryInit(); }

} // namespace wasm
