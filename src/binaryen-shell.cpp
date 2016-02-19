/*
 * Copyright 2015 WebAssembly Community Group participants
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
// A WebAssembly shell, loads a .wast file (WebAssembly in S-Expression format)
// and executes it. This provides similar functionality as the reference
// interpreter, like assert_* calls, so it can run the spec test suite.
//

#include <memory>

#include "pass.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-interpreter.h"
#include "wasm-printing.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"

using namespace cashew;
using namespace wasm;

// Globals

MixedArena globalAllocator;

IString ASSERT_RETURN("assert_return"),
        ASSERT_TRAP("assert_trap"),
        ASSERT_INVALID("assert_invalid"),
        SPECTEST("spectest"),
        PRINT("print"),
        INVOKE("invoke"),
        EXIT("exit");

struct ExitException {};
struct TrapException {};
struct ParseException {};

//
// Implementation of the shell interpreter execution environment
//

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
      static_assert(!(alignof(T) & (alignof(T) - 1)), "must be a power of 2");
      return 0 == (reinterpret_cast<uintptr_t>(address) & (alignof(T) - 1));
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
    memory.resize(wasm.memory.initial);
    // apply memory segments
    for (auto segment : wasm.memory.segments) {
      assert(segment.offset + segment.size <= wasm.memory.initial);
      for (size_t i = 0; i != segment.size; ++i) {
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
      std::cout << "exit()\n";
      throw ExitException();
    }
    std::cout << "callImport " << import->name.str << "\n";
    abort();
  }

  Literal load(Load* load, size_t addr) override {
    // ignore align - assume we are on x86 etc. which does that
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

  void store(Store* store, size_t addr, Literal value) override {
    // ignore align - assume we are on x86 etc. which does that
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
          case 1: memory.set<int8_t>(addr, value.geti64()); break;
          case 2: memory.set<int16_t>(addr, value.geti64()); break;
          case 4: memory.set<int32_t>(addr, value.geti64()); break;
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

  void growMemory(size_t /*oldSize*/, size_t newSize) override {
    memory.resize(newSize);
  }

  void trap(const char* why) override {
    std::cerr << "[trap " << why << "]\n";
    throw TrapException();
  }
};

//
// An invocation into a module
//

struct Invocation {
  ModuleInstance* instance;
  IString name;
  ModuleInstance::LiteralList arguments;

  Invocation(Element& invoke, ModuleInstance* instance, SExpressionWasmBuilder& builder) : instance(instance) {
    assert(invoke[0]->str() == INVOKE);
    name = invoke[1]->str();
    for (size_t j = 2; j < invoke.size(); j++) {
      Expression* argument = builder.parseExpression(*invoke[j]);
      arguments.push_back(argument->dyn_cast<Const>()->value);
    }
  }

  Literal invoke() {
    return instance->callExport(name, arguments);
  }
};

static void verify_result(Literal a, Literal b) {
  if (a == b) return;
  // accept equal nans if equal in all bits
  assert(a.type == b.type);
  if (a.type == f32) {
    assert(a.reinterpreti32() == b.reinterpreti32());
  } else if (a.type == f64) {
    assert(a.reinterpreti64() == b.reinterpreti64());
  } else {
    abort();
  }
}

static void run_asserts(size_t* i, bool* checked, AllocatingModule* wasm,
                        Element* root,
                        std::unique_ptr<SExpressionWasmBuilder>* builder,
                        Name entry) {
  ShellExternalInterface* interface = nullptr;
  ModuleInstance* instance = nullptr;
  if (wasm) {
    interface = new ShellExternalInterface();
    instance = new ModuleInstance(*wasm, interface);
    if (entry.is() > 0) {
      Function* function = wasm->functionsMap[entry];
      if (!function) {
        std::cerr << "Unknown entry " << entry << std::endl;
      } else {
        ModuleInstance::LiteralList arguments;
        for (NameType param : function->params) {
          arguments.push_back(Literal(param.type));
        }
        try {
          instance->callExport(entry, arguments);
        } catch (ExitException& x) {
        }
      }
    }
  }
  while (*i < root->size()) {
    Element& curr = *(*root)[*i];
    IString id = curr[0]->str();
    if (id == MODULE) break;
    *checked = true;
    Colors::red(std::cerr);
    std::cerr << *i << '/' << (root->size() - 1);
    Colors::green(std::cerr);
    std::cerr << " CHECKING: ";
    Colors::normal(std::cerr);
    std::cerr << curr << '\n';
    if (id == ASSERT_INVALID) {
      // a module invalidity test
      AllocatingModule wasm;
      bool invalid = false;
      std::unique_ptr<SExpressionWasmBuilder> builder;
      try {
        builder = std::unique_ptr<SExpressionWasmBuilder>(
          new SExpressionWasmBuilder(wasm, *curr[1], [&]() {
            invalid = true;
            throw ParseException();
          })
        );
      } catch (const ParseException& e) {
        invalid = true;
      }
      if (!invalid) {
        // maybe parsed ok, but otherwise incorrect
        invalid = !WasmValidator().validate(wasm);
      }
      assert(invalid);
    } else if (id == INVOKE) {
      assert(wasm);
      Invocation invocation(curr, instance, *builder->get());
      invocation.invoke();
    } else {
      // an invoke test
      assert(wasm);
      bool trapped = false;
      Literal result;
      try {
        Invocation invocation(*curr[1], instance, *builder->get());
        result = invocation.invoke();
      } catch (const TrapException& e) {
        trapped = true;
      }
      if (id == ASSERT_RETURN) {
        assert(!trapped);
        if (curr.size() >= 3) {
          Literal expected = builder->get()
                                 ->parseExpression(*curr[2])
                                 ->dyn_cast<Const>()
                                 ->value;
          std::cerr << "seen " << result << ", expected " << expected << '\n';
          verify_result(expected, result);
        } else {
          Literal expected;
          std::cerr << "seen " << result << ", expected " << expected << '\n';
          verify_result(expected, result);
        }
      }
      if (id == ASSERT_TRAP) assert(trapped);
    }
    *i += 1;
  }
}

//
// main
//

int main(int argc, const char* argv[]) {
  Name entry;
  std::vector<std::string> passes;

  static const char* default_passes[] = {"remove-unused-brs",
                                         "remove-unused-names", "merge-blocks",
                                         "simplify-locals", "reorder-locals"};

  Options options("binaryen-shell", "Execute .wast files");
  options
      .add("--output", "-o", "Output file (stdout if not specified)",
           Options::Arguments::One,
           [](Options* o, const std::string& argument) {
             o->extra["output"] = argument;
             Colors::disable();
           })
      .add(
          "--entry", "-e", "call the entry point after parsing the module",
          Options::Arguments::One,
          [&entry](Options*, const std::string& argument) { entry = argument; })
      .add("", "-O", "execute default optimization passes",
           Options::Arguments::Zero,
           [&passes](Options*, const std::string&) {
             for (const auto* p : default_passes) passes.push_back(p);
           })
      .add_positional("INFILE", Options::Arguments::One,
                      [](Options* o, const std::string& argument) {
                        o->extra["infile"] = argument;
                      });
  for (const auto& p : PassRegistry::get()->getRegisteredNames()) {
    options.add(
        std::string("--") + p, "", PassRegistry::get()->getPassDescription(p),
        Options::Arguments::Zero,
        [&passes, p](Options*, const std::string&) { passes.push_back(p); });
  }
  options.parse(argc, argv);

  auto input(read_file<std::vector<char>>(options.extra["infile"], options.debug));

  if (options.debug) std::cerr << "parsing text to s-expressions...\n";
  SExpressionParser parser(input.data());
  Element& root = *parser.root;
  if (options.debug) std::cout << root << '\n';

  // A .wast may have multiple modules, with some asserts after them
  bool checked = false;
  size_t i = 0;
  while (i < root.size()) {
    Element& curr = *root[i];
    IString id = curr[0]->str();
    if (id == MODULE) {
      if (options.debug) std::cerr << "parsing s-expressions to wasm...\n";
      AllocatingModule wasm;
      std::unique_ptr<SExpressionWasmBuilder> builder(
          new SExpressionWasmBuilder(wasm, *root[i], [&]() { abort(); }, options.debug));
      i++;

      MixedArena moreModuleAllocations;

      if (passes.size() > 0) {
        if (options.debug) std::cerr << "running passes...\n";
        PassRunner passRunner(&moreModuleAllocations);
        for (auto& passName : passes) {
          passRunner.add(passName);
        }
        passRunner.run(&wasm);
      }

      run_asserts(&i, &checked, &wasm, &root, &builder, entry);
    } else {
      run_asserts(&i, &checked, nullptr, &root, nullptr, entry);
    }
  }

  if (checked) {
    Colors::green(std::cerr);
    Colors::bold(std::cerr);
    std::cerr << "all checks passed.\n";
    Colors::normal(std::cerr);
  }
}
