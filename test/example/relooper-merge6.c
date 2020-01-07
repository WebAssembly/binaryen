#include <assert.h>
#include <stdio.h>

#include "binaryen-c.h"

// globals: address 4 is index
// decisions are at address 8+

int main() {
  BinaryenModuleRef module = BinaryenModuleCreate();

  // check()

  // if the end, halt
  BinaryenExpressionRef halter = BinaryenIf(module,
    BinaryenBinary(module,
      BinaryenGeUInt32(),
      BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                   BinaryenConst(module, BinaryenLiteralInt32(4))),
      BinaryenConst(module, BinaryenLiteralInt32(4 * 12)) // jumps of 4 bytes
    ),
    BinaryenUnreachable(module),
    NULL
  );
  // increment index
  BinaryenExpressionRef incer = BinaryenStore(module,
    4, 0, 0,
    BinaryenConst(module, BinaryenLiteralInt32(4)),
    BinaryenBinary(module,
      BinaryenAddInt32(),
      BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                   BinaryenConst(module, BinaryenLiteralInt32(4))),
      BinaryenConst(module, BinaryenLiteralInt32(4))
    ),
    BinaryenTypeInt32()
  );

  // optionally, print the return value
  BinaryenExpressionRef args[] = {
    BinaryenBinary(module,
      BinaryenSubInt32(),
      BinaryenConst(module, BinaryenLiteralInt32(0)),
      BinaryenLoad(module,
        4, 0, 4, 0, BinaryenTypeInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4)))
      )
    )
  };
  BinaryenExpressionRef debugger;
  if (1) debugger = BinaryenCall(module, "print", args, 1,
                                 BinaryenTypeNone());
  else debugger = BinaryenNop(module);

  // return the decision. need to subtract 4 that we just added,
  // and add 8 since that's where we start, so overall offset 4
  BinaryenExpressionRef returner = BinaryenLoad(module,
    4, 0, 4, 0, BinaryenTypeInt32(),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
    BinaryenConst(module, BinaryenLiteralInt32(4)))
  );
  BinaryenExpressionRef checkBodyList[] = { halter, incer, debugger,
                                            returner };
  BinaryenExpressionRef checkBody = BinaryenBlock(module,
    NULL, checkBodyList, sizeof(checkBodyList) / sizeof(BinaryenExpressionRef),
    BinaryenTypeInt32()
  );
  BinaryenAddFunction(module,
                      "check",
                      BinaryenTypeNone(),
                      BinaryenTypeInt32(),
                      NULL,
                      0,
                      checkBody);

  // contents of main() begin here

  RelooperRef relooper = RelooperCreate(module);


  RelooperBlockRef b0;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenLocalSet(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b0 = RelooperAddBlockWithSwitch(relooper,
      BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()),
      BinaryenBinary(module,
        BinaryenRemUInt32(),
        BinaryenLocalGet(module, 0, BinaryenTypeInt32()),
        BinaryenConst(module, BinaryenLiteralInt32(1))
      )
    );

  }

  RelooperBlockRef b1;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(1))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenLocalSet(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b1 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));

  }

  RelooperBlockRef b2;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(1))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenLocalSet(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b2 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));

  }

  RelooperBlockRef b3;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(1))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenLocalSet(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b3 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));
  }

  RelooperBlockRef b4;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(1))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenLocalSet(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b4 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));
  }

  // Separate branch for each.
  // In this testcase, we can merge multiple consecutive blocks with phis.
  RelooperAddBranch(b0, b1, NULL, BinaryenDrop(module, BinaryenConst(module, BinaryenLiteralInt32(10))));
  RelooperAddBranch(b1, b2, NULL, BinaryenDrop(module, BinaryenConst(module, BinaryenLiteralInt32(11))));
  RelooperAddBranch(b2, b3, NULL, NULL);
  RelooperAddBranch(b3, b4, NULL, BinaryenDrop(module, BinaryenConst(module, BinaryenLiteralInt32(12))));

  BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, b0, 1);

  // locals: state, free-for-label
  BinaryenType localTypes[] = { BinaryenTypeInt32(), BinaryenTypeInt32() };
  BinaryenFunctionRef theMain = BinaryenAddFunction(module,
                                                    "main",
                                                    BinaryenTypeNone(),
                                                    BinaryenTypeNone(),
                                                    localTypes,
                                                    2,
                                                    body);
  BinaryenSetStart(module, theMain);

  // import
  BinaryenAddFunctionImport(module,
                            "print",
                            "spectest",
                            "print",
                            BinaryenTypeInt32(),
                            BinaryenTypeNone());

  // memory
  BinaryenSetMemory(module, 1, 1, "mem", NULL, NULL, NULL, NULL, 0, 0);

  // optionally, optimize
  if (0) BinaryenModuleOptimize(module);

  assert(BinaryenModuleValidate(module));

  // write it out

  BinaryenModulePrint(module);

  BinaryenModuleDispose(module);

  return 0;
}
