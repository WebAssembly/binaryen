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

#include "shared-constants.h"
#include "asmjs/shared-constants.h"
#include "support/name.h"
#include "wasm.h"
#include "wasm-interpreter.h"
#include "ir/module-utils.h"

namespace wasm {

struct ExitException {};
struct TrapException {};

struct ShellExternalInterface final : ModuleInstance::ExternalInterface {
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

  std::vector<Name> table;

  ShellExternalInterface() : memory() {}

  void init(Module& wasm, ModuleInstance& instance) override {
    memory.resize(wasm.memory.initial * wasm::Memory::kPageSize);
    // apply memory segments
    for (auto& segment : wasm.memory.segments) {
      Address offset = (uint32_t)ConstantExpressionRunner<TrivialGlobalManager>(instance.globals).visit(segment.offset).value.geti32();
      if (offset + segment.data.size() > wasm.memory.initial * wasm::Memory::kPageSize) {
        trap("invalid offset when initializing memory");
      }
      for (size_t i = 0; i != segment.data.size(); ++i) {
        memory.set(offset + i, segment.data[i]);
      }
    }

    table.resize(wasm.table.initial);
    for (auto& segment : wasm.table.segments) {
      Address offset = (uint32_t)ConstantExpressionRunner<TrivialGlobalManager>(instance.globals).visit(segment.offset).value.geti32();
      if (offset + segment.data.size() > wasm.table.initial) {
        trap("invalid offset when initializing table");
      }
      for (size_t i = 0; i != segment.data.size(); ++i) {
        table[offset + i] = segment.data[i];
      }
    }
  }

  void importGlobals(std::map<Name, Literal>& globals, Module& wasm) override {
    // add spectest globals
    ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
      if (import->module == SPECTEST && import->base == GLOBAL) {
        switch (import->type) {
          case i32: globals[import->name] = Literal(int32_t(666)); break;
          case i64: globals[import->name] = Literal(int64_t(666)); break;
          case f32: globals[import->name] = Literal(float(666.6)); break;
          case f64: globals[import->name] = Literal(double(666.6)); break;
          default: WASM_UNREACHABLE();
        }
      }
    });
    if (wasm.memory.imported() && wasm.memory.module == SPECTEST && wasm.memory.base == MEMORY) {
      // imported memory has initial 1 and max 2
      wasm.memory.initial = 1;
      wasm.memory.max = 2;
    }
  }

  Literal callImport(Function* import, LiteralList& arguments) override {
    if (import->module == SPECTEST && import->base == PRINT) {
      for (auto argument : arguments) {
        std::cout << '(' << argument << ')' << '\n';
      }
      return Literal();
    } else if (import->module == ENV && import->base == EXIT) {
      // XXX hack for torture tests
      std::cout << "exit()\n";
      throw ExitException();
    }
    Fatal() << "callImport: unknown import: " << import->module.str << "."
            << import->name.str;
  }

  Literal callTable(Index index, LiteralList& arguments, Type result, ModuleInstance& instance) override {
    if (index >= table.size()) trap("callTable overflow");
    auto* func = instance.wasm.getFunctionOrNull(table[index]);
    if (!func) trap("uninitialized table element");
    if (func->params.size() != arguments.size()) trap("callIndirect: bad # of arguments");
    for (size_t i = 0; i < func->params.size(); i++) {
      if (func->params[i] != arguments[i].type) {
        trap("callIndirect: bad argument type");
      }
    }
    if (func->result != result) {
      trap("callIndirect: bad result type");
    }
    if (func->imported()) {
      return callImport(func, arguments);
    } else {
      return instance.callFunctionInternal(func->name, arguments);
    }
  }

  int8_t load8s(Address addr) override { return memory.get<int8_t>(addr); }
  uint8_t load8u(Address addr) override { return memory.get<uint8_t>(addr); }
  int16_t load16s(Address addr) override { return memory.get<int16_t>(addr); }
  uint16_t load16u(Address addr) override { return memory.get<uint16_t>(addr); }
  int32_t load32s(Address addr) override { return memory.get<int32_t>(addr); }
  uint32_t load32u(Address addr) override { return memory.get<uint32_t>(addr); }
  int64_t load64s(Address addr) override { return memory.get<int64_t>(addr); }
  uint64_t load64u(Address addr) override { return memory.get<uint64_t>(addr); }

  void store8(Address addr, int8_t value) override { memory.set<int8_t>(addr, value); }
  void store16(Address addr, int16_t value) override { memory.set<int16_t>(addr, value); }
  void store32(Address addr, int32_t value) override { memory.set<int32_t>(addr, value); }
  void store64(Address addr, int64_t value) override { memory.set<int64_t>(addr, value); }

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
