
//
// A WebAssembly shell, loads a .wast file (WebAssembly in S-Expression format) and executes it.
//

#include <setjmp.h>

#include "wasm-s-parser.h"
#include "wasm-interpreter.h"

using namespace cashew;
using namespace wasm;

IString ASSERT_RETURN("assert_return"),
        ASSERT_TRAP("assert_trap"),
        PRINT("print"),
        INVOKE("invoke");

//
// Implementation of the shell interpreter execution environment
//

struct ShellExternalInterface : ModuleInstance::ExternalInterface {
  char *memory;
  size_t memorySize;

  ShellExternalInterface() : memory(nullptr) {}

  void init(Module& wasm) override {
    memory = new char[wasm.memory.initial];
    memorySize = wasm.memory.initial;
    // apply memory segments
    for (auto segment : wasm.memory.segments) {
      memcpy(memory + segment.offset, segment.data, segment.size);
    }
  }

  Literal callImport(Import *import, ModuleInstance::LiteralList& arguments) override {
    if (import->name == PRINT) {
      for (auto argument : arguments) {
        std::cout << argument << ' ';
      }
      std::cout << '\n';
      return Literal();
    }
    std::cout << "callImport " << import->name.str << "\n";
    abort();
  }

  Literal load(Load* load, Literal ptr) override {
    // ignore align - assume we are on x86 etc. which does that
    size_t addr = ptr.geti32();
    int64_t full = addr;
    full += load->offset;
    if (full + load->bytes > memorySize) trap();
    addr = full;
    switch (load->type) {
      case i32: {
        switch (load->bytes) {
          case 1: return load->signed_ ? (int32_t)((int8_t*)memory)[addr]  : (int32_t)((uint8_t*)memory)[addr];
          case 2: return load->signed_ ? (int32_t)((int16_t*)memory)[addr] : (int32_t)((uint16_t*)memory)[addr];
          case 4: return load->signed_ ? (int32_t)((int32_t*)memory)[addr] : (int32_t)((uint32_t*)memory)[addr];
          default: abort();
        }
        break;
      }
      case f32: return ((float*)memory)[addr];
      case f64: return ((double*)memory)[addr];
      default: abort();
    }
  }

  void store(Store* store, Literal ptr, Literal value) override {
    // ignore align - assume we are on x86 etc. which does that
    size_t addr = ptr.geti32();
    int64_t full = addr;
    full += store->offset;
    if (full + store->bytes > memorySize) trap();
    switch (store->type) {
      case i32: {
        switch (store->bytes) {
          case 1: ((int8_t*)memory)[addr] = value.geti32();
          case 2: ((int16_t*)memory)[addr] = value.geti32();
          case 4: ((int32_t*)memory)[addr] = value.geti32();
          default: abort();
        }
        break;
      }
      case f32: ((float*)memory)[addr] = value.getf32();
      case f64: ((double*)memory)[addr] = value.getf64();
      default: abort();
    }
  }

  jmp_buf trapState;

  void trap() override {
    longjmp(trapState, 1);
  }
};

int main(int argc, char **argv) {
  debug = getenv("WASM_SHELL_DEBUG") ? getenv("WASM_SHELL_DEBUG")[0] - '0' : 0;

  char *infile = argv[1];
  bool print_wasm = argc >= 3; // second arg means print it out

  if (debug) std::cerr << "loading '" << infile << "'...\n";
  FILE *f = fopen(argv[1], "r");
  assert(f);
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
    SExpressionWasmBuilder builder(wasm, *root[i]);
    i++;

    auto interface = new ShellExternalInterface();
    auto instance = new ModuleInstance(wasm, interface);

    if (print_wasm) {
      if (debug) std::cerr << "printing...\n";
      std::cout << wasm;
    }

    // run asserts
    while (i < root.size()) {
      Element& curr = *root[i];
      IString id = curr[0]->str();
      if (id == MODULE) break;
      std::cerr << "CHECKING| " << curr << '\n';
      Element& invoke = *curr[1];
      assert(invoke[0]->str() == INVOKE);
      IString name = invoke[1]->str();
      ModuleInstance::LiteralList arguments;
      for (size_t j = 2; j < invoke.size(); j++) {
        Expression* argument = builder.parseExpression(*invoke[2]);
        arguments.push_back(argument->dyn_cast<Const>()->value);
      }
      bool trapped = false;
      Literal result;
      if (setjmp(interface->trapState) == 0) {
        result = instance->callFunction(name, arguments);
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
      i++;
    }
  }

  if (debug) std::cerr << "done.\n";
}

