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

#include "wasm-s-parser.h"
#include "wasm-interpreter.h"
#include "wasm-validator.h"
#include "pass.h"

using namespace cashew;
using namespace wasm;

namespace wasm {
int debug = 0;
}

// Globals

MixedArena globalAllocator;

IString ASSERT_RETURN("assert_return"),
        ASSERT_TRAP("assert_trap"),
        ASSERT_INVALID("assert_invalid"),
        SPECTEST("spectest"),
        PRINT("print"),
        INVOKE("invoke");

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
      memcpy(memory + segment.offset, segment.data, segment.size);
    }
  }

  Literal callImport(Import *import, ModuleInstance::LiteralList& arguments) override {
    if (import->module == SPECTEST && import->base == PRINT) {
      for (auto argument : arguments) {
        std::cout << argument << '\n';
      }
      return Literal();
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

//
// main
//

int main(int argc, char **argv) {
  debug = getenv("BINARYEN_DEBUG") ? getenv("BINARYEN_DEBUG")[0] - '0' : 0;

  char *infile = nullptr;
  bool print_before = false;
  bool print_after = false;
  std::vector<std::string> passes;

  assert(argc > 0 && "expect at least program name as an argument");
  for (size_t i = 1, e = argc; i != e; i++) {
    char* curr = argv[i];
    if (curr[0] == '-') {
      std::string arg = curr;
      if (arg == "-print-before") {
        print_before = true;
      } else if (arg == "-print-after") {
        print_after = true;
      } else if (arg == "--help") {
        std::cout << "\n";
        std::cout << "binaryen shell\n";
        std::cout << "--------------\n\n";
        std::cout << "printing options:\n";
        std::cout << "  -print-before : print modules before processing them\n";
        std::cout << "  -print-after  : print modules after processing them\n";
        std::cout << "\n";
        std::cout << "passes:\n";
        std::cout << "  -O : execute default optimization passes\n";
        auto allPasses = PassRegistry::get()->getRegisteredNames();
        for (auto& name : allPasses) {
          std::cout << "  -" << name << " : " << PassRegistry::get()->getPassDescription(name) << "\n";
        }
        std::cout << "\n";
        exit(0);
      } else if (arg == "-O") {
        passes.push_back("remove-unused-brs");
        passes.push_back("remove-unused-names");
        passes.push_back("merge-blocks");
      } else {
        // otherwise, assumed to be a pass
        const char* name = curr + 1;
        auto check = PassRegistry::get()->createPass(name);
        if (!check) {
          printf("error: invalid option %s\n", curr);
          exit(1);
        }
        delete check;
        passes.push_back(name);
      }
    } else {
      if (infile) {
        printf("error: too many input files provided.\n");
        exit(1);
      }
      infile = curr;
    }
  }

  if (!infile) {
    printf("error: no input file provided.\n");
    exit(1);
  }

  if (debug) std::cerr << "loading '" << infile << "'...\n";
  FILE *f = fopen(infile, "r");
  if (!f) {
    printf("error: could not open input file: %s\n", infile);
    exit(1);
  }
  fseek(f, 0, SEEK_END);
  int size = ftell(f);
  char *input = new char[size+1];
  rewind(f);
  int num = fread(input, 1, size, f);
  // On Windows, ftell() gives the byte position (\r\n counts as two bytes), but when
  // reading, fread() returns the number of characters read (\r\n is read as one char \n, and counted as one),
  // so return value of fread can be less than size reported by ftell, and that is normal.
  assert((num > 0 || size == 0) && num <= size);
  fclose(f);
  input[num] = 0;

  if (debug) std::cerr << "parsing text to s-expressions...\n";
  SExpressionParser parser(input);
  Element& root = *parser.root;
  if (debug) std::cout << root << '\n';

  // A .wast may have multiple modules, with some asserts after them
  bool checked = false;
  size_t i = 0;
  while (i < root.size()) {
    if (debug) std::cerr << "parsing s-expressions to wasm...\n";
    AllocatingModule wasm;
    SExpressionWasmBuilder builder(wasm, *root[i], [&]() { abort(); }, debug);
    i++;

    auto interface = new ShellExternalInterface();
    auto instance = new ModuleInstance(wasm, interface);

    if (print_before) {
      Colors::bold(std::cout);
      std::cerr << "printing before:\n";
      Colors::normal(std::cout);
      std::cout << wasm;
    }

    MixedArena moreModuleAllocations;

    if (passes.size() > 0) {
      if (debug) std::cerr << "running passes...\n";
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

    // run asserts
    while (i < root.size()) {
      Element& curr = *root[i];
      IString id = curr[0]->str();
      if (id == MODULE) break;
      checked = true;
      Colors::red(std::cerr);
      std::cerr << i << '/' << (root.size()-1);
      Colors::green(std::cerr);
      std::cerr << " CHECKING: ";
      Colors::normal(std::cerr);
      std::cerr << curr << '\n';
      if (id == ASSERT_INVALID) {
        // a module invalidity test
        AllocatingModule wasm;
        bool invalid = false;
        jmp_buf trapState;
        std::unique_ptr<SExpressionWasmBuilder> builder;
        if (setjmp(trapState) == 0) {
          builder = std::unique_ptr<SExpressionWasmBuilder>(new SExpressionWasmBuilder(wasm, *curr[1], [&]() {
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
        Invocation invocation(curr, instance, builder);
        invocation.invoke();
      } else {
        // an invoke test
        Invocation invocation(*curr[1], instance, builder);
        bool trapped = false;
        Literal result;
        if (setjmp(interface->trapState) == 0) {
          result = invocation.invoke();
        } else {
          trapped = true;
        }
        if (id == ASSERT_RETURN) {
          assert(!trapped);
          Literal expected;
          if (curr.size() >= 3) {
            expected = builder.parseExpression(*curr[2])->dyn_cast<Const>()->value;
          }
          std::cerr << "seen " << result << ", expected " << expected << '\n';
          assert(expected == result);
        }
        if (id == ASSERT_TRAP) assert(trapped);
      }
      i++;
    }
  }

  if (checked) {
    Colors::green(std::cerr);
    Colors::bold(std::cerr);
    std::cerr << "all checks passed.\n";
    Colors::normal(std::cerr);
  }
}
