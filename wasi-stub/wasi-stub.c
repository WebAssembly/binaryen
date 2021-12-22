#include <binaryen-c.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char *argv[]) {
  if (argc < 2) {
    fprintf(stderr, "Usage: wasi-stub file.wasm\n");
    exit(1);
  }

  FILE *input;
  input = fopen(argv[1], "rb");
  if (input == NULL) {
    fprintf(stderr, "Unable to open %s\n", argv[1]);
    exit(1);
  }

  fseek( input, 0, SEEK_END );
  size_t size = ftell(input);
  fseek( input, 0, SEEK_SET );
  char *buf = malloc(size);
  if (buf == NULL) {
    fprintf(stderr, "Unable to alloc buffer to read.\n");
    exit(1);
  }
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
      printf("Find and stub wasi import: %s.\n", BinaryenFunctionImportGetBase(fid));
      BinaryenType retType = BinaryenFunctionGetResults(fid);
      BinaryenFunctionImportToFunction(fid);

      if (BinaryenTypeArity(retType) == 0) {
        BinaryenExpressionRef noop = BinaryenNop(module);
        BinaryenFunctionSetBody(fid, noop);        
      } else {
        BinaryenExpressionRef ret = BinaryenReturn(module, BinaryenConst(module, BinaryenLiteralInt32(76)));
        BinaryenFunctionSetBody(fid, ret);
      }
    } else if (visitWasi) {
      break;
    }
  }

  size_t output_size = 2*size;
  char* output_buf = malloc(output_size);
  if (output_buf == NULL) {
    fprintf(stderr, "Unable to alloc buffer to write.\n");
    exit(1);
  }
  size_t output_actual_size = BinaryenModuleWrite(module, output_buf, output_size);
  FILE *output;
  output = fopen(argv[1], "wb");
  if (output == NULL) {
    fprintf(stderr, "Unable to open %s for write\n", argv[1]);
    exit(1);
  }
  fwrite(output_buf, output_actual_size, 1, output);
  fclose(output);
  free(output_buf);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);
  free(buf);

  return 0;
}
