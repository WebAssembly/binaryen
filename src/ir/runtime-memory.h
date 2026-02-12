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

#include "interpreter/exception.h"
#include "wasm.h"

namespace wasm {

namespace {

void trapIfGt(uint64_t lhs, uint64_t rhs, const char* msg) {
  if (lhs > rhs) {
    std::stringstream ss;
    ss << msg << ": " << lhs << " > " << rhs;
    // ss.str();
    throw TrapException{};
  }
}

void checkLoadAddress(Address addr, Index bytes, Address memorySize) {
  Address memorySizeBytes = memorySize * Memory::kPageSize;
  trapIfGt(addr, memorySizeBytes - bytes, "highest > memory");
}

// void checkAtomicAddress(Address addr, Index bytes, Address memorySize) {
//   checkLoadAddress(addr, bytes, memorySize);
//   // Unaligned atomics trap.
//   if (bytes > 1) {
//     if (addr & (bytes - 1)) {
//      //  "unaligned atomic operation"
//       throw TrapException{};
//     }
//   }
// }

Address
getFinalAddress(uint64_t offset, Literal ptr, Index bytes, Address memorySize) {
  Address memorySizeBytes = memorySize * Memory::kPageSize;
  uint64_t addr = ptr.type == Type::i32 ? ptr.geti32() : ptr.geti64();
  trapIfGt(offset, memorySizeBytes, "offset > memory");
  trapIfGt(addr, memorySizeBytes - offset, "final > memory");
  addr += offset;
  trapIfGt(bytes, memorySizeBytes, "bytes > memory");
  checkLoadAddress(addr, bytes, memorySize);
  return addr;
}

} // namespace

// TODO split into pure virtual class
class RuntimeMemory {
public:
  RuntimeMemory(Memory memory) : memoryDefinition(memory) {}

  virtual ~RuntimeMemory() = default;

  // variants for load8 etc?
  // Do we care about the order here?
  // todo: address types? Address::address32_t is strange
  // todo: type of offset?
  virtual Literal
  load(uint32_t addr, uint64_t offset, MemoryOrder order) const {
    Address address = getFinalAddress(offset, Literal(addr), 4, 1);
    return {};
  }
  virtual Literal load(uint64_t addr) const { return {}; }

  const Memory* getDefinition() const { return &memoryDefinition; }

protected:
  const Memory memoryDefinition;

private:
  std::vector<uint8_t> memory;
};

class RealRuntimeMemory : public RuntimeMemory {};

} // namespace wasm

#endif // wasm_ir_runtime_memory_h