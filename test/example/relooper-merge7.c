
#include <assert.h>
#include <stdio.h>

#include "binaryen-c.h"

int main() {
  BinaryenModuleRef module = BinaryenModuleCreate();

  RelooperRef relooper = RelooperCreate(module);

  // Create the basic blocks
  RelooperBlockRef b[4];
  int hasTerminator[4] = {0, 0, 0, 1};

  int numBlocks = sizeof(b) / sizeof(RelooperBlockRef);
  assert(sizeof(hasTerminator) / sizeof(int) == numBlocks);
  int i;
  for (i = 0; i < numBlocks; i++) {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(i))};
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenReturn(module, NULL) // relevant only if hasTerminator[i]
    };
    b[i] = RelooperAddBlock(
      relooper,
      BinaryenBlock(
        module, NULL, list, 1 + hasTerminator[i], BinaryenTypeNone()));
  }

  // Create the branches.
  // In this testcase, only b[2] and b[3] can be merged.
  RelooperAddBranch(b[0], b[1], NULL, NULL);
  RelooperAddBranch(
    b[0], b[2], BinaryenConst(module, BinaryenLiteralInt32(-10)), NULL);
  RelooperAddBranch(b[1], b[0], NULL, NULL);
  RelooperAddBranch(b[2], b[3], NULL, NULL);

  BinaryenExpressionRef all = RelooperRenderAndDispose(relooper, b[0], 1);

  // Print it out
  BinaryenExpressionPrint(all);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);

  return 0;
}
