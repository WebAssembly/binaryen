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
#include "ir/module-utils.h"
#include "shared-constants.h"
#include "support/name.h"
#include "wasm-interpreter.h"
#include "wasm.h"

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
    template<typename T> static bool aligned(const char* address) {
      static_assert(!(sizeof(T) & (sizeof(T) - 1)), "must be a power of 2");
      return 0 == (reinterpret_cast<uintptr_t>(address) & (sizeof(T) - 1));
    }
    Memory(Memory&) = delete;
    Memory& operator=(const Memory&) = delete;

  public:
    Memory() = default;
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
    template<typename T> void set(size_t address, T value) {
      if (aligned<T>(&memory[address])) {
        *reinterpret_cast<T*>(&memory[address]) = value;
      } else {
        std::memcpy(&memory[address], &value, sizeof(T));
      }
    }
    template<typename T> T get(size_t address) {
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
  virtual ~ShellExternalInterface() = default;

  void init(Module& wasm, ModuleInstance& instance) override {
    memory.resize(wasm.memory.initial * wasm::Memory::kPageSize);
    table.resize(wasm.table.initial);
  }

  void importGlobals(std::map<Name, Literals>& globals, Module& wasm) override {
    // add spectest globals
    ModuleUtils::iterImportedGlobals(wasm, [&](Global* import) {
      if (import->module == SPECTEST && import->base.startsWith(GLOBAL)) {
        TODO_SINGLE_COMPOUND(import->type);
        switch (import->type.getBasic()) {
          case Type::i32:
            globals[import->name] = {Literal(int32_t(666))};
            break;
          case Type::i64:
            globals[import->name] = {Literal(int64_t(666))};
            break;
          case Type::f32:
            globals[import->name] = {Literal(float(666.6))};
            break;
          case Type::f64:
            globals[import->name] = {Literal(double(666.6))};
            break;
          case Type::v128:
            assert(false && "v128 not implemented yet");
          case Type::funcref:
          case Type::externref:
          case Type::exnref:
          case Type::anyref:
            globals[import->name] = {Literal::makeNull(import->type)};
            break;
          case Type::none:
          case Type::unreachable:
            WASM_UNREACHABLE("unexpected type");
        }
      }
    });
    if (wasm.memory.imported() && wasm.memory.module == SPECTEST &&
        wasm.memory.base == MEMORY) {
      // imported memory has initial 1 and max 2
      wasm.memory.initial = 1;
      wasm.memory.max = 2;
    }
  }

  Literals callImport(Function* import, LiteralList& arguments) override {
    if (import->module == SPECTEST && import->base.startsWith(PRINT)) {
      for (auto argument : arguments) {
        std::cout << argument << " : " << argument.type << '\n';
      }
      return {};
    } else if (import->module == ENV && import->base == EXIT) {
      // XXX hack for torture tests
      std::cout << "exit()\n";
      throw ExitException();
    }
    Fatal() << "callImport: unknown import: " << import->module.str << "."
            << import->name.str;
  }

  Literals callTable(Index index,
                     Signature sig,
                     LiteralList& arguments,
                     Type results,
                     ModuleInstance& instance) override {
    if (index >= table.size()) {
      trap("callTable overflow");
    }
    auto* func = instance.wasm.getFunctionOrNull(table[index]);
    if (!func) {
      trap("uninitialized table element");
    }
    if (sig != func->sig) {
      trap("callIndirect: function signatures don't match");
    }
    if (func->sig.params.size() != arguments.size()) {
      trap("callIndirect: bad # of arguments");
    }
    size_t i = 0;
    for (const auto& param : func->sig.params) {
      if (!Type::isSubType(arguments[i++].type, param)) {
        trap("callIndirect: bad argument type");
      }
    }
    if (func->sig.results != results) {
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
  std::array<uint8_t, 16> load128(Address addr) override {
    return memory.get<std::array<uint8_t, 16>>(addr);
  }

  void store8(Address addr, int8_t value) override {
    memory.set<int8_t>(addr, value);
  }
  void store16(Address addr, int16_t value) override {
    memory.set<int16_t>(addr, value);
  }
  void store32(Address addr, int32_t value) override {
    memory.set<int32_t>(addr, value);
  }
  void store64(Address addr, int64_t value) override {
    memory.set<int64_t>(addr, value);
  }
  void store128(Address addr, const std::array<uint8_t, 16>& value) override {
    memory.set<std::array<uint8_t, 16>>(addr, value);
  }

  void tableStore(Address addr, Name entry) override { table[addr] = entry; }

  void growMemory(Address /*oldSize*/, Address newSize) override {
    memory.resize(newSize);
  }

  void trap(const char* why) override {
    std::cout << "[trap " << why << "]\n";
    throw TrapException();
  }

  void throwException(Literal exn) override { throw WasmException(exn); }
};

} // namespace wasm

#endif // wasm_shell_interface_h
