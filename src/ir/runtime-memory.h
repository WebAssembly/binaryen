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

#include "fp16.h"
#include "interpreter/exception.h"
#include "wasm.h"

namespace wasm {

namespace {

void trapIfGt(uint64_t lhs, uint64_t rhs, const char* msg) {
  if (lhs > rhs) {
    std::cerr << msg << ": " << lhs << " > " << rhs << "\n";
    throw TrapException{};
  }
}

Address getFinalAddress(Address addr,
                        Address offset,
                        Index bytes,
                        Address memorySizeBytes) {
  trapIfGt(offset, memorySizeBytes, "offset > memory");
  trapIfGt(addr, memorySizeBytes - offset, "final > memory");

  addr = size_t(addr) + offset;
  trapIfGt(bytes, memorySizeBytes, "bytes > memory");

  trapIfGt(addr, memorySizeBytes - bytes, "highest > memory");
  return addr;
}

} // namespace

class RuntimeMemory {
public:
  RuntimeMemory(Memory memory) : memoryDefinition(std::move(memory)) {
    resize(memoryDefinition.initialByteSize());
  }

  virtual ~RuntimeMemory() = default;

  virtual Literal load(Address addr,
                       Address offset,
                       uint8_t byteCount,
                       MemoryOrder order,
                       Type type,
                       bool signed_) const {
    Address final = getFinalAddress(addr, offset, byteCount, size());
    if (order != MemoryOrder::Unordered) {
      checkAtomicAddress(final, byteCount, size());
    }
    switch (type.getBasic()) {
      case Type::i32: {
        switch (byteCount) {
          case 1:
            return signed_ ? Literal((int32_t)get<int8_t>(final))
                           : Literal((int32_t)get<uint8_t>(final));
          case 2:
            return signed_ ? Literal((int32_t)get<int16_t>(final))
                           : Literal((int32_t)get<uint16_t>(final));
          case 4:
            return Literal((int32_t)get<int32_t>(final));
          default:
            WASM_UNREACHABLE("invalid size");
        }
      }
      case Type::i64: {
        switch (byteCount) {
          case 1:
            return signed_ ? Literal((int64_t)get<int8_t>(final))
                           : Literal((int64_t)get<uint8_t>(final));
          case 2:
            return signed_ ? Literal((int64_t)get<int16_t>(final))
                           : Literal((int64_t)get<uint16_t>(final));
          case 4:
            return signed_ ? Literal((int64_t)get<int32_t>(final))
                           : Literal((int64_t)get<uint32_t>(final));
          case 8:
            return Literal((int64_t)get<int64_t>(final));
          default:
            WASM_UNREACHABLE("invalid size");
        }
      }
      case Type::f32: {
        switch (byteCount) {
          case 2:
            return Literal(bit_cast<int32_t>(
                             fp16_ieee_to_fp32_value(get<uint16_t>(final))))
              .castToF32();
          case 4:
            return Literal(get<uint32_t>(final)).castToF32();
          default:
            WASM_UNREACHABLE("invalid size");
        }
      }
      case Type::f64:
        return Literal(get<uint64_t>(final)).castToF64();
      case Type::v128:
        return Literal(get<std::array<uint8_t, 16>>(final).data());
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }

  virtual void store(Address addr,
                     Address offset,
                     uint8_t byteCount,
                     MemoryOrder order,
                     Literal value,
                     Type type) {
    Address final = getFinalAddress(addr, offset, byteCount, size());
    if (order != MemoryOrder::Unordered) {
      checkAtomicAddress(final, byteCount, size());
    }
    switch (type.getBasic()) {
      case Type::i32: {
        switch (byteCount) {
          case 1:
            set<int8_t>(final, value.geti32());
            break;
          case 2:
            set<int16_t>(final, value.geti32());
            break;
          case 4:
            set<int32_t>(final, value.geti32());
            break;
          default:
            WASM_UNREACHABLE("invalid size");
        }
        break;
      }
      case Type::i64: {
        switch (byteCount) {
          case 1:
            set<int8_t>(final, value.geti64());
            break;
          case 2:
            set<int16_t>(final, value.geti64());
            break;
          case 4:
            set<int32_t>(final, value.geti64());
            break;
          case 8:
            set<int64_t>(final, value.geti64());
            break;
          default:
            WASM_UNREACHABLE("invalid size");
        }
        break;
      }
      case Type::f32: {
        switch (byteCount) {
          case 2:
            set<uint16_t>(final,
                          fp16_ieee_from_fp32_value(
                            bit_cast<float>(value.reinterpreti32())));
            break;
          case 4:
            set<int32_t>(final, value.reinterpreti32());
            break;
          default:
            WASM_UNREACHABLE("invalid size");
        }
        break;
      }
      case Type::f64:
        set<int64_t>(final, value.reinterpreti64());
        break;
      case Type::v128:
        set<std::array<uint8_t, 16>>(final, value.getv128());
        break;
      default:
        WASM_UNREACHABLE("unexpected type");
    }
  }

  virtual bool grow(Address delta) {
    Address pageSize = memoryDefinition.pageSize();
    Address oldPages = intendedSize / pageSize;
    Address newPages = oldPages + delta;
    if (newPages > memoryDefinition.max && memoryDefinition.hasMax()) {
      return false;
    }
    // Apply a reasonable limit on memory size, 1GB, to avoid DOS on the
    // interpreter.
    if (newPages * pageSize > 1024 * 1024 * 1024) {
      return false;
    }
    resize(newPages * pageSize);
    return true;
  }

  virtual Address size() const { return intendedSize; }

  virtual void
  init(Address dest, Address src, Address byteCount, const DataSegment* data) {
    trapIfGt(uint64_t(src), uint64_t(data->data.size()), "src > data");
    trapIfGt(uint64_t(byteCount),
             uint64_t(data->data.size() - src),
             "src + size > data");
    Address final = getFinalAddress(dest, 0, byteCount, size());
    std::memcpy(&memory[final], &data->data[src], byteCount);
  }

  virtual void
  copy(Address dest, Address src, Address byteCount, const RuntimeMemory* srcMemory) {
    Address finalDest = getFinalAddress(dest, 0, byteCount, size());
    Address finalSrc = getFinalAddress(src, 0, byteCount, srcMemory->size());
    std::memmove(&memory[finalDest], &srcMemory->memory[finalSrc], byteCount);
  }

  virtual void fill(Address dest, uint8_t value, Address byteCount) {
    Address final = getFinalAddress(dest, 0, byteCount, size());
    std::memset(&memory[final], value, byteCount);
  }

  void resize(size_t newSize) {
    intendedSize = newSize;
    const size_t minSize = 1 << 12;
    size_t oldAllocatedSize = memory.size();
    memory.resize(std::max(minSize, newSize), 0);
    if (newSize < oldAllocatedSize && newSize < minSize) {
      std::memset(&memory[newSize], 0, minSize - newSize);
    }
  }

  const Memory* getDefinition() const { return &memoryDefinition; }

  template<typename T> T get(size_t address) const {
    if (aligned<T>(&memory[address])) {
      return *reinterpret_cast<const T*>(&memory[address]);
    } else {
      T loaded;
      std::memcpy(&loaded, &memory[address], sizeof(T));
      return loaded;
    }
  }

  template<typename T> void set(size_t address, T value) {
    if (aligned<T>(&memory[address])) {
      *reinterpret_cast<T*>(&memory[address]) = value;
    } else {
      std::memcpy(&memory[address], &value, sizeof(T));
    }
  }

  void checkLoadAddress(Address addr, Index bytes, Address memorySizeBytes) const {
    trapIfGt(addr, memorySizeBytes - bytes, "highest > memory");
  }

  void
  checkAtomicAddress(Address addr, Index bytes, Address memorySizeBytes) const {
    checkLoadAddress(addr, bytes, memorySizeBytes);
    // Unaligned atomics trap.
    if (bytes > 1) {
      if (addr & (bytes - 1)) {
        std::cerr << "unaligned atomic operation: " << addr << " " << bytes
                  << "\n";
        throw TrapException{};
      }
    }
  }

protected:
  const Memory memoryDefinition;
  std::vector<uint8_t> memory;
  Address intendedSize = 0;

  template<typename T> static bool aligned(const uint8_t* address) {
    static_assert(!(sizeof(T) & (sizeof(T) - 1)), "must be a power of 2");
    return 0 == (reinterpret_cast<uintptr_t>(address) & (sizeof(T) - 1));
  }
};

class RealRuntimeMemory : public RuntimeMemory {
public:
  using RuntimeMemory::RuntimeMemory;
};

} // namespace wasm

#endif // wasm_ir_runtime_memory_h
