#include <binaryen-c.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  FILE *input;
  input = fopen(argv[1], "rb");
  fseek( input, 0, SEEK_END );
  size_t size = ftell(input);
  fseek( input, 0, SEEK_SET );
  char *buf = malloc(size);
  fread(buf, size, 1, input);
  fclose(input);
  BinaryenModuleRef module = BinaryenModuleRead(buf, size);
  // Optimization, wasi imports are consequtive
  int visitWasi = 0;

  BinaryenIndex numFunctions = BinaryenGetNumFunctions(module);
  for (BinaryenIndex i = 0; i < numFunctions; i++) {
    BinaryenFunctionRef fid = BinaryenGetFunctionByIndex(module, i);
    if (strcmp(BinaryenFunctionImportGetModule(fid), "wasi_snapshot_preview1") == 0) {
      visitWasi = 1;
      printf("%s\n", BinaryenFunctionImportGetBase(fid));
      BinaryenFunctionImportToFunction(fid);
    } else if (visitWasi) {
      break;
    }
  }
  size_t output_size = 2*size;
  char* output_buf = malloc(output_size);
  size_t output_actual_size = BinaryenModuleWrite(module, output_buf, output_size);
  FILE *output;
  output = fopen(argv[1], "wb");
  fwrite(output_buf, output_actual_size, 1, output);
  fclose(output);
  free(output_buf);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);
  free(buf);

  return 0;
}
