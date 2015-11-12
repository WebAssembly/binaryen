
//
// A WebAssembly shell, loads a .wast file (WebAssembly in S-Expression format)
// and executes it. This provides similar functionality as the reference
// interpreter, like assert_* calls, so it can run the spec test suite.
//

#include <setjmp.h>

#include "wasm-s-parser.h"
#include "wasm-interpreter.h"
#include "wasm-validator.h"

using namespace cashew;
using namespace wasm;

IString ASSERT_RETURN("assert_return"),
        ASSERT_TRAP("assert_trap"),
        ASSERT_INVALID("assert_invalid"),
        STDIO("stdio"),
        PRINT("print"),
        INVOKE("invoke");

//
// Implementation of the shell interpreter execution environment
//

struct ShellExternalInterface : ModuleInstance::ExternalInterface {
  char *memory;

  ShellExternalInterface() : memory(nullptr) {}

  void init(Module& wasm) override {
    memory = (char*)malloc(wasm.memory.initial);
    // apply memory segments
    for (auto segment : wasm.memory.segments) {
      memcpy(memory + segment.offset, segment.data, segment.size);
    }
  }

  Literal callImport(Import *import, ModuleInstance::LiteralList& arguments) override {
    if (import->module == STDIO && import->base == PRINT) {
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
      case f32: *((float*)(memory+addr)) = value.getf32(); break;
      case f64: *((double*)(memory+addr)) = value.getf64(); break;
      default: abort();
    }
  }

  void growMemory(size_t oldSize, size_t newSize) override {
    memory = (char*)realloc(memory, newSize);
  }

  jmp_buf trapState;

  void trap() override {
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
  debug = getenv("WASM_SHELL_DEBUG") ? getenv("WASM_SHELL_DEBUG")[0] - '0' : 0;

  char *infile = nullptr;
  bool print_before = false;

  for (size_t i = 1; i < argc; i++) {
    char* curr = argv[i];
    if (curr[0] == '-') {
      std::string arg = curr;
      if (arg == "--print-before") {
        print_before = true;
      } else {
        if (infile) {
          printf("error: unrecognized argument: %s\n", curr);
          exit(1);
        }
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
  FILE *f = fopen(argv[1], "r");
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
  size_t i = 0;
  while (i < root.size()) {
    if (debug) std::cerr << "parsing s-expressions to wasm...\n";
    Module wasm;
    SExpressionWasmBuilder builder(wasm, *root[i], [&]() { abort(); });
    i++;

    auto interface = new ShellExternalInterface();
    auto instance = new ModuleInstance(wasm, interface);

    if (print_before) {
      if (debug) std::cerr << "printing...\n";
      std::cout << wasm;
    }

    // run asserts
    while (i < root.size()) {
      Element& curr = *root[i];
      IString id = curr[0]->str();
      if (id == MODULE) break;
      Colors::red(std::cerr);
      std::cerr << i << '/' << (root.size()-1);
      Colors::green(std::cerr);
      std::cerr << " CHECKING: ";
      Colors::normal(std::cerr);
      std::cerr << curr << '\n';
      if (id == ASSERT_INVALID) {
        // a module invalidity test
        Module wasm;
        bool invalid = false;
        jmp_buf trapState;
        if (setjmp(trapState) == 0) {
          SExpressionWasmBuilder builder(wasm, *curr[1], [&]() {
            invalid = true;
            longjmp(trapState, 1);
          });
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

  if (debug) {
    Colors::green(std::cerr);
    Colors::bold(std::cerr);
    std::cerr << "\ndone.\n";
    Colors::normal(std::cerr);
  }
}

