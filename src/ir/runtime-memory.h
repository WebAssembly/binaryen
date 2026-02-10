/*
 * Copyright 2026 WebAssembly Community Group participants
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

#ifndef wasm_ir_runtime_memory_h
#define wasm_ir_runtime_memory_h

#include "wasm.h"

namespace wasm {

// TODO split into pure virtual class
class RuntimeMemory {
  RuntimeMemory(Memory memory) : memoryDefinition(memory) {}

  // variants for load8 etc?
  // Do we care about the order here?
  Literal load(Address addr) const { return {}; }

  const Memory* getDefinition() const { return &memoryDefinition; }

private:
  const Memory memoryDefinition;
};

} // namespace wasm

#endif // wasm_ir_runtime_memory_h