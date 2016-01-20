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

#include <setjmp.h>
#include <memory>

#include "pass.h"
#include "support/command-line.h"
#include "support/file.h"
#include "wasm-interpreter.h"
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

struct ExitException {
};

//
// Implementation of the shell interpreter execution environment
//

struct ShellExternalInterface : ModuleInstance::ExternalInterface {
  char *memory;

  ShellExternalInterface() : memory(nullptr) {}

  void init(Module& wasm) override {
    memory = (char*)calloc(wasm.memory.initial, 1);
    // apply memory segments
    for (auto segment : wasm.memory.segments) {
      assert(segment.offset + segment.size <= wasm.memory.initial);
      memcpy(memory + segment.offset, segment.data, segment.size);
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
          case 1: return load->signed_ ? (int32_t)*((int8_t*)(memory+addr))  : (int32_t)*((uint8_t*)(memory+addr));
          case 2: return load->signed_ ? (int32_t)*((int16_t*)(memory+addr)) : (int32_t)*((uint16_t*)(memory+addr));
          case 4: return load->signed_ ? (int32_t)*((int32_t*)(memory+addr)) : (int32_t)*((uint32_t*)(memory+addr));
          default: abort();
        }
        break;
      }
      case i64: {
        switch (load->bytes) {
          case 1: return load->signed_ ? (int64_t)*((int8_t*)(memory+addr))  : (int64_t)*((uint8_t*)(memory+addr));
          case 2: return load->signed_ ? (int64_t)*((int16_t*)(memory+addr)) : (int64_t)*((uint16_t*)(memory+addr));
          case 4: return load->signed_ ? (int64_t)*((int32_t*)(memory+addr)) : (int64_t)*((uint32_t*)(memory+addr));
          case 8: return load->signed_ ? (int64_t)*((int64_t*)(memory+addr)) : (int64_t)*((uint64_t*)(memory+addr));
          default: abort();
        }
        break;
      }
      case f32: return *((float*)(memory+addr));
      case f64: return *((double*)(memory+addr));
      default: abort();
    }
  }

  void store(Store* store, size_t addr, Literal value) override {
    // ignore align - assume we are on x86 etc. which does that
    switch (store->type) {
      case i32: {
        switch (store->bytes) {
          case 1: *((int8_t*)(memory+addr)) = value.geti32(); break;
          case 2: *((int16_t*)(memory+addr)) = value.geti32(); break;
          case 4: *((int32_t*)(memory+addr)) = value.geti32(); break;
          default: abort();
        }
        break;
      }
      case i64: {
        switch (store->bytes) {
          case 1: *((int8_t*)(memory+addr)) = value.geti64(); break;
          case 2: *((int16_t*)(memory+addr)) = value.geti64(); break;
          case 4: *((int32_t*)(memory+addr)) = value.geti64(); break;
          case 8: *((int64_t*)(memory+addr)) = value.geti64(); break;
          default: abort();
        }
        break;
      }
      // write floats carefully, ensuring all bits reach memory
      case f32: *((int32_t*)(memory+addr)) = value.reinterpreti32(); break;
      case f64: *((int64_t*)(memory+addr)) = value.reinterpreti64(); break;
      default: abort();
    }
  }

  void growMemory(size_t oldSize, size_t newSize) override {
    memory = (char*)realloc(memory, newSize);
    if (newSize > oldSize) {
      memset(memory + oldSize, 0, newSize - oldSize);
    }
  }

  jmp_buf trapState;

  void trap(const char* why) override {
    std::cerr << "[trap " << why << "]\n";
    longjmp(trapState, 1);
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

static void run_asserts(size_t* i, bool* checked, AllocatingModule* wasm,
                        Element* root,
                        std::unique_ptr<SExpressionWasmBuilder>* builder,
                        bool print_before, bool print_after,
                        Name entry) {
  auto interface = new ShellExternalInterface();
  auto instance = new ModuleInstance(*wasm, interface);
  if (entry.is() > 0) {
    ModuleInstance::LiteralList arguments;
    try {
      instance->callExport(entry, arguments);
    } catch (ExitException& x) {
    }
  }
  while (*i < root->size()) {
    Element& curr = *(*root)[*i];
    IString id = curr[0]->str();
    if (id == MODULE) break;
    *checked = true;
    Colors::red(std::cerr);
    std::cerr << *i << '/' << (root->size()-1);
    Colors::green(std::cerr);
    std::cerr << " CHECKING: ";
    Colors::normal(std::cerr);
    std::cerr << curr << '\n';
    if (id == ASSERT_INVALID) {
      // a module invalidity test
      AllocatingModule wasm;
      bool invalid = false;
      jmp_buf trapState;
      if (setjmp(trapState) == 0) {
        *builder = std::unique_ptr<SExpressionWasmBuilder>(new SExpressionWasmBuilder(wasm, *curr[1], [&]() {
          invalid = true;
          longjmp(trapState, 1);
        }));
      }
      if (print_before || print_after) {
        Colors::bold(std::cout);
        std::cerr << "printing in module invalidity test:\n";
        Colors::normal(std::cout);
        std::cout << wasm;
      }
      if (!invalid) {
        // maybe parsed ok, but otherwise incorrect
        invalid = !WasmValidator().validate(wasm);
      }
      assert(invalid);
    } else if (id == INVOKE) {
      Invocation invocation(curr, instance, *builder->get());
      invocation.invoke();
    } else {
      // an invoke test
      Invocation invocation(*curr[1], instance, *builder->get());
      bool trapped = false;
      Literal result;
      if (setjmp(interface->trapState) == 0) {
        result = invocation.invoke();
      } else {
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
          assert(expected == result);
        } else {
          Literal expected;
          std::cerr << "seen " << result << ", expected " << expected << '\n';
          assert(expected == result);
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
  bool print_before = false;
  bool print_after = false;
  Name entry;
  std::vector<std::string> passes;

  static const char* default_passes[] = {"remove-unused-brs",
                                         "remove-unused-names", "merge-blocks",
                                         "simplify-locals"};

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
      .add("--print-before", "", "Print modules before processing them",
           Options::Arguments::Zero,
           [&print_before](Options*, const std::string&) {
             print_before = true;
           })
      .add("--print-after", "", "Print modules after processing them",
           Options::Arguments::Zero,
           [&print_after](Options*, const std::string&) { print_after = true; })
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
    if (options.debug) std::cerr << "parsing s-expressions to wasm...\n";
    AllocatingModule wasm;
    std::unique_ptr<SExpressionWasmBuilder> builder(
        new SExpressionWasmBuilder(wasm, *root[i], [&]() { abort(); }, options.debug));
    i++;

    if (print_before) {
      Colors::bold(std::cout);
      std::cerr << "printing before:\n";
      Colors::normal(std::cout);
      std::cout << wasm;
    }

    MixedArena moreModuleAllocations;

    if (passes.size() > 0) {
      if (options.debug) std::cerr << "running passes...\n";
      PassRunner passRunner(&moreModuleAllocations);
      for (auto& passName : passes) {
        passRunner.add(passName);
      }
      passRunner.run(&wasm);
    }

    if (print_after) {
      Colors::bold(std::cout);
      std::cerr << "printing after:\n";
      Colors::normal(std::cout);
      std::cout << wasm;
    }

    run_asserts(&i, &checked, &wasm, &root, &builder, print_before,
                print_after, entry);
  }

  if (checked) {
    Colors::green(std::cerr);
    Colors::bold(std::cerr);
    std::cerr << "all checks passed.\n";
    Colors::normal(std::cerr);
  }
}
