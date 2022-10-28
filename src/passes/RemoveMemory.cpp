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
// Removeds memory segments, leaving only code in the module.
//

#include <pass.h>
#include <wasm.h>

namespace wasm {

struct RemoveMemory : public Pass {
  void run(Module* module) override {
    module->removeDataSegments([&](DataSegment* curr) { return true; });
  }
};

Pass* createRemoveMemoryPass() { return new RemoveMemory(); }

} // namespace wasm
