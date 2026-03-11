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
    // std::stringstream ss;
    std::cerr << msg << ": " << lhs << " > " << rhs << "\n";
    // ss.str();
    // std::cerr<<ss
    throw TrapException{};
  }
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

Address getFinalAddress(Address addr,
                        Address offset,
                        Index bytes,
                        Address memorySizeBytes) {
  trapIfGt(offset, memorySizeBytes, "offset > memory");
  trapIfGt(addr, memorySizeBytes - offset, "final > memory");

  // TODO: overflow here?
  addr = size_t(addr) + offset;
  trapIfGt(bytes, memorySizeBytes, "bytes > memory");

  // checkLoadAddress(addr, bytes, memorySizeBytes);
  trapIfGt(addr, memorySizeBytes - bytes, "highest > memory");
  return addr;
}

template<typename T> static bool aligned(const uint8_t* address) {
  static_assert(!(sizeof(T) & (sizeof(T) - 1)), "must be a power of 2");
  return 0 == (reinterpret_cast<uintptr_t>(address) & (sizeof(T) - 1));
}

template<typename T>
T asdf(const std::vector<uint8_t>& memory, size_t address) {
  if (aligned<T>(&memory[address])) {
    return *reinterpret_cast<const T*>(&memory[address]);
  } else {
    T loaded;
    std::memcpy(&loaded, &memory[address], sizeof(T));
    return loaded;
  }
}
} // namespace

// TODO split into pure virtual class
class RuntimeMemory {
public:
  // todo: might want a constructor that takes data segments
  RuntimeMemory(Memory memory)
    : memoryDefinition(std::move(memory)), memory(memory.initialByteSize(), 0) {
    // this->memory.reserve(memory.initialByteSize());
  }

  virtual ~RuntimeMemory() = default;

  // variants for load8 etc?
  // Do we care about the order here?
  // todo: address types? Address::address32_t is strange
  // todo: type of offset?
  virtual Literal load(Address addr,
                       Address offset,
                       uint8_t byteCount,
                       MemoryOrder order) const {
    Address final = getFinalAddress(addr, offset, byteCount, memory.size());
    (void) final;

    // return memory.get()

    return Literal(asdf<int32_t>(memory, (size_t) final));

    // return Literal(1);
  }
  virtual Literal load(uint64_t addr) const { return {}; }

  const Memory* getDefinition() const { return &memoryDefinition; }

protected:
  const Memory memoryDefinition;

private:
  std::vector<uint8_t> memory;
};

class RealRuntimeMemory : public RuntimeMemory {
public:
  using RuntimeMemory::RuntimeMemory;
};

} // namespace wasm

#endif // wasm_ir_runtime_memory_h