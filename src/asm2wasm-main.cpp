//
// asm2wasm console tool
//

#include "asm2wasm.h"

using namespace cashew;
using namespace wasm;

int main(int argc, char **argv) {
  debug = getenv("ASM2WASM_DEBUG") ? getenv("ASM2WASM_DEBUG")[0] - '0' : 0;

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

  // emcc --separate-asm modules look like
  //
  //    Module["asm"] = (function(global, env, buffer) {
  //      ..
  //    });
  //
  // we need to clean that up.
  if (*input == 'M') {
    while (*input != 'f') {
      input++;
      num--;
    }
    char *end = input + num - 1;
    while (*end != '}') {
      *end = 0;
      end--;
    }
  }

  if (debug) std::cerr << "parsing...\n";
  cashew::Parser<Ref, DotZeroValueBuilder> builder;
  Ref asmjs = builder.parseToplevel(input);

  if (debug) std::cerr << "wasming...\n";
  Module wasm;
  wasm.memorySize = 16*1024*1024; // we would normally receive this from the compiler
  Asm2WasmBuilder asm2wasm(wasm);
  asm2wasm.processAsm(asmjs);

  if (debug) std::cerr << "optimizing...\n";
  asm2wasm.optimize();

  if (debug) std::cerr << "printing...\n";
  std::cout << wasm;

  if (debug) std::cerr << "done.\n";
}

