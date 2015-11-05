
//
// A WebAssembly shell, loads a .wast file (WebAssembly in S-Expression format) and executes it.
//

#include "wasm-s-parser.h"

using namespace cashew;
using namespace wasm;

IString ASSERT_RETURN("assert_return"),
        ASSERT_TRAP("assert_trap"),
        INVOKE("invoke");

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

    if (print_wasm) {
      if (debug) std::cerr << "printing...\n";
      std::cout << wasm;
    }

    // run asserts
    while (i < root.size()) {
      Element& curr = *root[i];
      IString id = curr[0]->str();
      if (id == MODULE) break;
      Element& invoke = *curr[1];
      assert(invoke[0]->str() == INVOKE);
      IString name = invoke[1]->str();
      LiteralList arguments;
      for (size_t j = 2; j < invoke.size(); j++) {
        Expression* argument = builder.parseExpression(*invoke[2]);
        arguments.push_back(argument->dyn_cast<Const>()->value);
      }
      interpreter.callFunction(name, arguments);
      i++;
    }
  }

  if (debug) std::cerr << "done.\n";
}

