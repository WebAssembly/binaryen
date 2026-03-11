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

#include "ir/runtime-memory.h"
#include "fp16.h"
#include "interpreter/exception.h"

namespace wasm {

RuntimeMemory::RuntimeMemory(Memory memory,
                             ExternalInterface* externalInterface)
  : externalInterface(externalInterface), memoryDefinition(std::move(memory)) {}

namespace {

Address getFinalAddress(const RuntimeMemory& runtimeMemory,
                        Address addr,
                        Address offset,
                        Index bytes,
                        Address memorySizeBytes) {
  if (offset > memorySizeBytes) {
    std::string msg = "offset > memory: ";
    msg += std::to_string(uint64_t(offset));
    msg += " > ";
    msg += std::to_string(uint64_t(memorySizeBytes));
    runtimeMemory.trap(msg);
  }
  if (addr > memorySizeBytes - offset) {
    std::string msg = "final > memory: ";
    msg += std::to_string(uint64_t(addr));
    msg += " > ";
    msg += std::to_string(uint64_t(memorySizeBytes - offset));
    runtimeMemory.trap(msg);
  }

  addr = size_t(addr) + offset;

  if (bytes > memorySizeBytes - addr) {
    std::string msg = "highest > memory: ";
    msg += std::to_string(uint64_t(addr));
    msg += " + ";
    msg += std::to_string(uint64_t(bytes));
    msg += " > ";
    msg += std::to_string(uint64_t(memorySizeBytes));
    runtimeMemory.trap(msg);
  }
  return addr;
}

void checkLoadAddress(const RuntimeMemory& runtimeMemory,
                      Address addr,
                      Index bytes,
                      Address memorySizeBytes) {
  if (addr > memorySizeBytes || bytes > memorySizeBytes - addr) {
    std::string msg = "highest > memory: ";
    msg += std::to_string(uint64_t(addr));
    msg += " + ";
    msg += std::to_string(uint64_t(bytes));
    msg += " > ";
    msg += std::to_string(uint64_t(memorySizeBytes));
    runtimeMemory.trap(msg);
  }
}

void checkAtomicAddress(const RuntimeMemory& runtimeMemory,
                        Address addr,
                        Index bytes,
                        Address memorySizeBytes) {
  checkLoadAddress(runtimeMemory, addr, bytes, memorySizeBytes);
  // Unaligned atomics trap.
  if (bytes > 1) {
    if (addr & (bytes - 1)) {
      runtimeMemory.trap("unaligned atomic operation");
    }
  }
}

template<typename T> bool aligned(const uint8_t* address) {
  static_assert(!(sizeof(T) & (sizeof(T) - 1)), "must be a power of 2");
  return 0 == (reinterpret_cast<uintptr_t>(address) & (sizeof(T) - 1));
}

} // namespace

RealRuntimeMemory::RealRuntimeMemory(Memory memory,
                                     ExternalInterface* externalInterface)
  : RuntimeMemory(std::move(memory), externalInterface) {
  resize(memoryDefinition.initialByteSize());
}

Literal RealRuntimeMemory::load(Address addr,
                                Address offset,
                                uint8_t byteCount,
                                MemoryOrder order,
                                Type type,
                                bool signed_) const {
  Address final = getFinalAddress(*this, addr, offset, byteCount, size());
  if (order != MemoryOrder::Unordered) {
    checkAtomicAddress(*this, final, byteCount, size());
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

void RealRuntimeMemory::store(Address addr,
                              Address offset,
                              uint8_t byteCount,
                              MemoryOrder order,
                              Literal value,
                              Type type) {
  Address final = getFinalAddress(*this, addr, offset, byteCount, size());
  if (order != MemoryOrder::Unordered) {
    checkAtomicAddress(*this, final, byteCount, size());
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
          set<uint16_t>(
            final,
            fp16_ieee_from_fp32_value(bit_cast<float>(value.reinterpreti32())));
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

bool RealRuntimeMemory::grow(Address delta) {
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

Address RealRuntimeMemory::size() const { return intendedSize; }

void RealRuntimeMemory::init(Address dest,
                             Address src,
                             Address byteCount,
                             const DataSegment* data) {
  if (src > data->data.size() || byteCount > data->data.size() - src) {
    trap("out of bounds segment access in memory.init");
  }
  Address final = getFinalAddress(*this, dest, 0, byteCount, size());
  if (byteCount > 0) {
    std::memcpy(&memory[final], &data->data[src], byteCount);
  }
}

void RealRuntimeMemory::copy(Address dest,
                             Address src,
                             Address byteCount,
                             const RuntimeMemory* srcMemory) {
  Address finalDest = getFinalAddress(*this, dest, 0, byteCount, size());
  Address finalSrc =
    getFinalAddress(*srcMemory, src, 0, byteCount, srcMemory->size());
  const std::vector<uint8_t>* srcBuffer = srcMemory->getBuffer();
  if (!srcBuffer) {
    // If it's not a memory with a direct buffer, we might need another way to
    // access it, or we can just fail if this is the only implementation we
    // support for now.
    WASM_UNREACHABLE("unsupported srcMemory type in copy");
  }
  if (byteCount > 0) {
    std::memmove(&memory[finalDest], &(*srcBuffer)[finalSrc], byteCount);
  }
}

void RealRuntimeMemory::fill(Address dest, uint8_t value, Address byteCount) {
  Address final = getFinalAddress(*this, dest, 0, byteCount, size());
  if (byteCount > 0) {
    std::memset(&memory[final], value, byteCount);
  }
}

void RealRuntimeMemory::resize(size_t newSize) {
  intendedSize = newSize;
  const size_t minSize = 1 << 12;
  size_t oldAllocatedSize = memory.size();
  size_t newAllocatedSize = std::max(minSize, newSize);
  if (newAllocatedSize > oldAllocatedSize) {
    memory.resize(newAllocatedSize);
    std::memset(
      &memory[oldAllocatedSize], 0, newAllocatedSize - oldAllocatedSize);
  }
  if (newSize < oldAllocatedSize && newSize < minSize) {
    std::memset(&memory[newSize], 0, minSize - newSize);
  }
}

template<typename T> T RealRuntimeMemory::get(size_t address) const {
  if (aligned<T>(&memory[address])) {
    return *reinterpret_cast<const T*>(&memory[address]);
  } else {
    T loaded;
    std::memcpy(&loaded, &memory[address], sizeof(T));
    return loaded;
  }
}

template<typename T> void RealRuntimeMemory::set(size_t address, T value) {
  if (aligned<T>(&memory[address])) {
    *reinterpret_cast<T*>(&memory[address]) = value;
  } else {
    std::memcpy(&memory[address], &value, sizeof(T));
  }
}

// Explicit instantiations for the templates
template int8_t RealRuntimeMemory::get<int8_t>(size_t) const;
template uint8_t RealRuntimeMemory::get<uint8_t>(size_t) const;
template int16_t RealRuntimeMemory::get<int16_t>(size_t) const;
template uint16_t RealRuntimeMemory::get<uint16_t>(size_t) const;
template int32_t RealRuntimeMemory::get<int32_t>(size_t) const;
template uint32_t RealRuntimeMemory::get<uint32_t>(size_t) const;
template int64_t RealRuntimeMemory::get<int64_t>(size_t) const;
template uint64_t RealRuntimeMemory::get<uint64_t>(size_t) const;
template std::array<uint8_t, 16>
RealRuntimeMemory::get<std::array<uint8_t, 16>>(size_t) const;

template void RealRuntimeMemory::set<int8_t>(size_t, int8_t);
template void RealRuntimeMemory::set<uint8_t>(size_t, uint8_t);
template void RealRuntimeMemory::set<int16_t>(size_t, int16_t);
template void RealRuntimeMemory::set<uint16_t>(size_t, uint16_t);
template void RealRuntimeMemory::set<int32_t>(size_t, int32_t);
template void RealRuntimeMemory::set<uint32_t>(size_t, uint32_t);
template void RealRuntimeMemory::set<int64_t>(size_t, int64_t);
template void RealRuntimeMemory::set<uint64_t>(size_t, uint64_t);
template void
RealRuntimeMemory::set<std::array<uint8_t, 16>>(size_t,
                                                std::array<uint8_t, 16>);

} // namespace wasm
