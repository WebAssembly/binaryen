//
// wasm2asm console tool
//

#include "wasm2asm.h"
#include "wasm-s-parser.h"

using namespace cashew;
using namespace wasm;

namespace wasm {
int debug = 0;
}

int main(int argc, char **argv) {
  debug = getenv("WASM2ASM_DEBUG") ? getenv("WASM2ASM_DEBUG")[0] - '0' : 0;

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

  if (debug) std::cerr << "s-parsing...\n";
  SExpressionParser parser(input);
  Element& root = *parser.root;

  if (debug) std::cerr << "w-parsing...\n";
  AllocatingModule wasm;
  SExpressionWasmBuilder builder(wasm, *root[0], [&]() { abort(); });

  if (debug) std::cerr << "asming...\n";
  Wasm2AsmBuilder wasm2asm;
  Ref asmjs = wasm2asm.processWasm(&wasm);

  if (debug) std::cerr << "a-printing...\n";
  asmjs->stringify(std::cout);
  std::cout << '\n';

  if (debug) std::cerr << "j-printing...\n";
  JSPrinter jser(true, true, asmjs);
  jser.printAst();
  std::cout << jser.buffer << "\n";

  if (debug) std::cerr << "done.\n";
}

