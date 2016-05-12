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
// Implementation of the shell interpreter execution environment
//

#ifndef wasm_shell_interface_h
#define wasm_shell_interface_h

#include "asmjs/shared-constants.h"
#include "wasm.h"
#include "wasm-interpreter.h"

namespace wasm {

struct ExitException {};
struct TrapException {};

struct ShellExternalInterface : ModuleInstance::ExternalInterface {
  // The underlying memory can be accessed through unaligned pointers which
  // isn't well-behaved in C++. WebAssembly nonetheless expects it to behave
  // properly. Avoid emitting unaligned load/store by checking for alignment
  // explicitly, and performing memcpy if unaligned.
  //
  // The allocated memory tries to have the same alignment as the memory being
  // simulated.
  class Memory {
    // Use char because it doesn't run afoul of aliasing rules.
    std::vector<char> memory;
    template <typename T>
    static bool aligned(const char* address) {
      static_assert(!(sizeof(T) & (sizeof(T) - 1)), "must be a power of 2");
      return 0 == (reinterpret_cast<uintptr_t>(address) & (sizeof(T) - 1));
    }
    Memory(Memory&) = delete;
    Memory& operator=(const Memory&) = delete;

   public:
    Memory() {}
    void resize(size_t newSize) {
      // Ensure the smallest allocation is large enough that most allocators
      // will provide page-aligned storage. This hopefully allows the
      // interpreter's memory to be as aligned as the memory being simulated,
      // ensuring that the performance doesn't needlessly degrade.
      //
      // The code is optimistic this will work until WG21's p0035r0 happens.
      const size_t minSize = 1 << 12;
      size_t oldSize = memory.size();
      memory.resize(std::max(minSize, newSize));
      if (newSize < oldSize && newSize < minSize) {
        std::memset(&memory[newSize], 0, minSize - newSize);
      }
    }
    template <typename T>
    void set(size_t address, T value) {
      if (aligned<T>(&memory[address])) {
        *reinterpret_cast<T*>(&memory[address]) = value;
      } else {
        std::memcpy(&memory[address], &value, sizeof(T));
      }
    }
    template <typename T>
    T get(size_t address) {
      if (aligned<T>(&memory[address])) {
        return *reinterpret_cast<T*>(&memory[address]);
      } else {
        T loaded;
        std::memcpy(&loaded, &memory[address], sizeof(T));
        return loaded;
      }
    }
  } memory;

  ShellExternalInterface() : memory() {}

  void init(Module& wasm) override {
    memory.resize(wasm.memory.initial * wasm::Memory::kPageSize);
    // apply memory segments
    for (auto& segment : wasm.memory.segments) {
      assert(segment.offset + segment.data.size() <= wasm.memory.initial * wasm::Memory::kPageSize);
      for (size_t i = 0; i != segment.data.size(); ++i) {
        memory.set(segment.offset + i, segment.data[i]);
      }
    }
  }

  Literal callImport(Import *import, ModuleInstance::LiteralList& arguments) override {
    if (import->module == SPECTEST && import->base == PRINT) {
      for (auto argument : arguments) {
        std::cout << argument << '\n';
      }
      return Literal();
    } else if (import->module == ENV && import->base == EXIT) {
      // XXX hack for torture tests
      std::cout << "exit()\n";
      throw ExitException();
    }
    std::cout << "callImport " << import->name.str << "\n";
    abort();
  }

  Literal load(Load* load, Address addr) override {
    switch (load->type) {
      case i32: {
        switch (load->bytes) {
          case 1: return load->signed_ ? Literal((int32_t)memory.get<int8_t>(addr)) : Literal((int32_t)memory.get<uint8_t>(addr));
          case 2: return load->signed_ ? Literal((int32_t)memory.get<int16_t>(addr)) : Literal((int32_t)memory.get<uint16_t>(addr));
          case 4: return load->signed_ ? Literal((int32_t)memory.get<int32_t>(addr)) : Literal((int32_t)memory.get<uint32_t>(addr));
          default: abort();
        }
        break;
      }
      case i64: {
        switch (load->bytes) {
          case 1: return load->signed_ ? Literal((int64_t)memory.get<int8_t>(addr)) : Literal((int64_t)memory.get<uint8_t>(addr));
          case 2: return load->signed_ ? Literal((int64_t)memory.get<int16_t>(addr)) : Literal((int64_t)memory.get<uint16_t>(addr));
          case 4: return load->signed_ ? Literal((int64_t)memory.get<int32_t>(addr)) : Literal((int64_t)memory.get<uint32_t>(addr));
          case 8: return load->signed_ ? Literal((int64_t)memory.get<int64_t>(addr)) : Literal((int64_t)memory.get<uint64_t>(addr));
          default: abort();
        }
        break;
      }
      case f32: return Literal(memory.get<float>(addr));
      case f64: return Literal(memory.get<double>(addr));
      default: abort();
    }
  }

  void store(Store* store, Address addr, Literal value) override {
    switch (store->type) {
      case i32: {
        switch (store->bytes) {
          case 1: memory.set<int8_t>(addr, value.geti32()); break;
          case 2: memory.set<int16_t>(addr, value.geti32()); break;
          case 4: memory.set<int32_t>(addr, value.geti32()); break;
          default: abort();
        }
        break;
      }
      case i64: {
        switch (store->bytes) {
          case 1: memory.set<int8_t>(addr, (int8_t)value.geti64()); break;
          case 2: memory.set<int16_t>(addr, (int16_t)value.geti64()); break;
          case 4: memory.set<int32_t>(addr, (int32_t)value.geti64()); break;
          case 8: memory.set<int64_t>(addr, value.geti64()); break;
          default: abort();
        }
        break;
      }
      // write floats carefully, ensuring all bits reach memory
      case f32: memory.set<int32_t>(addr, value.reinterpreti32()); break;
      case f64: memory.set<int64_t>(addr, value.reinterpreti64()); break;
      default: abort();
    }
  }

  void growMemory(Address /*oldSize*/, Address newSize) override {
    memory.resize(newSize);
  }

  void trap(const char* why) override {
    std::cerr << "[trap " << why << "]\n";
    throw TrapException();
  }
};

}

#endif // wasm_shell_interface_h
