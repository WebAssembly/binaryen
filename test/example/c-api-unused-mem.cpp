// beginning a Binaryen API trace
#include <stdio.h>
#include <math.h>
#include <map>
#include "binaryen-c.h"
int main() {
  std::map<size_t, BinaryenFunctionTypeRef> functionTypes;
  std::map<size_t, BinaryenExpressionRef> expressions;
  std::map<size_t, BinaryenFunctionRef> functions;
  std::map<size_t, RelooperBlockRef> relooperBlocks;
  BinaryenModuleRef the_module = NULL;
  RelooperRef the_relooper = NULL;
  the_module = BinaryenModuleCreate();
  expressions[size_t(NULL)] = BinaryenExpressionRef(NULL);
  BinaryenModuleAutoDrop(the_module);
  {
    const char* segments[] = { 0 };
    BinaryenExpressionRef segmentOffsets[] = { 0 };
    BinaryenIndex segmentSizes[] = { 0 };
    BinaryenSetMemory(the_module, 256, 256, "memory", segments, segmentOffsets, segmentSizes, 0);
  }
  the_relooper = RelooperCreate();
  {
    BinaryenExpressionRef children[] = { 0 };
    expressions[1] = BinaryenBlock(the_module, "bb0", children, 0, BinaryenUndefined());
  }
  relooperBlocks[0] = RelooperAddBlock(the_relooper, expressions[1]);
  expressions[2] = BinaryenGetLocal(the_module, 0, 1);
  expressions[3] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[4] = BinaryenStore(the_module, 4, 0, 0, expressions[3], expressions[2], 1);
  expressions[5] = BinaryenReturn(the_module, expressions[0]);
  {
    BinaryenExpressionRef children[] = { expressions[4], expressions[5] };
    expressions[6] = BinaryenBlock(the_module, "bb1", children, 2, BinaryenUndefined());
  }
  relooperBlocks[1] = RelooperAddBlock(the_relooper, expressions[6]);
  RelooperAddBranch(relooperBlocks[0], relooperBlocks[1], expressions[0], expressions[0]);
  {
    BinaryenType paramTypes[] = { 0 };
    functionTypes[0] = BinaryenAddFunctionType(the_module, "rustfn-0-3", 0, paramTypes, 0);
  }
  expressions[7] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[8] = BinaryenLoad(the_module, 4, 0, 0, 0, 1, expressions[7]);
  expressions[9] = BinaryenSetLocal(the_module, 0, expressions[8]);
  relooperBlocks[2] = RelooperAddBlock(the_relooper, expressions[9]);
  RelooperAddBranch(relooperBlocks[2], relooperBlocks[0], expressions[0], expressions[0]);
  expressions[10] = RelooperRenderAndDispose(the_relooper, relooperBlocks[2], 1, the_module);
  {
    BinaryenType varTypes[] = { 1, 1, 2 };
    functions[0] = BinaryenAddFunction(the_module, "main", functionTypes[0], varTypes, 3, expressions[10]);
  }
  BinaryenAddExport(the_module, "main", "main");
  {
    BinaryenType paramTypes[] = { 0 };
    functionTypes[1] = BinaryenAddFunctionType(the_module, "__wasm_start", 0, paramTypes, 0);
  }
  {
    const char* segments[] = { 0 };
    BinaryenExpressionRef segmentOffsets[] = { 0 };
    BinaryenIndex segmentSizes[] = { 0 };
    BinaryenSetMemory(the_module, 1024, 1024, NULL, segments, segmentOffsets, segmentSizes, 0);
  }
  expressions[11] = BinaryenConst(the_module, BinaryenLiteralInt32(65535));
  expressions[12] = BinaryenConst(the_module, BinaryenLiteralInt32(0));
  expressions[13] = BinaryenStore(the_module, 4, 0, 0, expressions[12], expressions[11], 1);
  {
    BinaryenExpressionRef operands[] = { 0 };
    expressions[14] = BinaryenCall(the_module, "main", operands, 0, 0);
  }
  {
    BinaryenExpressionRef children[] = { expressions[13], expressions[14] };
    expressions[15] = BinaryenBlock(the_module, NULL, children, 2, BinaryenUndefined());
  }
  BinaryenAddExport(the_module, "__wasm_start", "rust_entry");
  {
    BinaryenType varTypes[] = { 0 };
    functions[1] = BinaryenAddFunction(the_module, "__wasm_start", functionTypes[1], varTypes, 0, expressions[15]);
  }
  BinaryenModuleValidate(the_module);
  BinaryenModulePrint(the_module);
  // check that binary read-write works
  {
    char buffer[1024];
    size_t size = BinaryenModuleWrite(the_module, buffer, 1024);
    printf("%d\n", size);
    BinaryenModuleRef copy = BinaryenModuleRead(buffer, size);
    BinaryenModulePrint(copy);
    BinaryenModuleDispose(copy);
  }
  BinaryenModuleDispose(the_module);
  return 0;
}

