
//
// A WebAssembly shell, loads a .wast file (WebAssembly in S-Expression format) and executes it.
//

#include "wasm-sexpr-parser.h"

using namespace cashew;
using namespace wasm;

int main(int argc, char **argv) {
  debug = getenv("WASM_SHELL_DEBUG") ? getenv("WASM_SHELL_DEBUG")[0] - '0' : 0;

  char *infile = argv[1];

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

  if (debug) std::cerr << "parsing...\n";
  Module wasm;
  SExpressionWasmBuilder builder(wasm, input);

  if (debug) std::cerr << "printing...\n";
  std::cout << wasm;

  if (debug) std::cerr << "done.\n";
}

