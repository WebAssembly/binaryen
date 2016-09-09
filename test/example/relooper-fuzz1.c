

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
      BinaryenEqInt32(),
      BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(),
                   BinaryenConst(module, BinaryenLiteralInt32(4))),
      BinaryenConst(module, BinaryenLiteralInt32(4 * 30)) // jumps of 4 bytes
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
      BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(),
                   BinaryenConst(module, BinaryenLiteralInt32(4))),
      BinaryenConst(module, BinaryenLiteralInt32(4))
    ),
    BinaryenInt32()
  );

  // optionally, print the return value
  BinaryenExpressionRef args[] = {
    BinaryenBinary(module,
      BinaryenSubInt32(),
      BinaryenConst(module, BinaryenLiteralInt32(0)),
      BinaryenLoad(module,
        4, 0, 4, 0, BinaryenInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4)))
      )
    )
  };
  BinaryenExpressionRef debugger;
  if (1) debugger = BinaryenCallImport(module, "print", args, 1,
                                       BinaryenNone());
  else debugger = BinaryenNop(module);

  // return the decision. need to subtract 4 that we just added,
  // and add 8 since that's where we start, so overall offset 4
  BinaryenExpressionRef returner = BinaryenLoad(module,
    4, 0, 4, 0, BinaryenInt32(),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(),
    BinaryenConst(module, BinaryenLiteralInt32(4)))
  );
  BinaryenExpressionRef checkBodyList[] = { halter, incer, debugger,
                                            returner };
  BinaryenExpressionRef checkBody = BinaryenBlock(module,
    NULL, checkBodyList, sizeof(checkBodyList) / sizeof(BinaryenExpressionRef)
  );
  BinaryenFunctionTypeRef i = BinaryenAddFunctionType(module, "i",
                                                      BinaryenInt32(),
                                                      NULL, 0);
  BinaryenAddFunction(module, "check", i, NULL, 0, checkBody);

  // contents of main() begin here

  RelooperRef relooper = RelooperCreate();


  RelooperBlockRef b0;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b0 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b1;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(1))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b1 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b2;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(2))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b2 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b3;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(3))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b3 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b4;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(4))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b4 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b5;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(5))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b5 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b6;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(6))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b6 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b7;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(7))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b7 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b8;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(8))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b8 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperBlockRef b9;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(9))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenInt32()))
    };

    b9 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2));

  }

  RelooperAddBranch(b0, b2, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(4))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), NULL);

  RelooperAddBranch(b0, b7, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(4))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(2))
  ), NULL);

  RelooperAddBranch(b0, b3, NULL, NULL);

  RelooperAddBranch(b2, b3, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(2))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), NULL);

  RelooperAddBranch(b2, b9, NULL, NULL);

  RelooperAddBranch(b3, b3, NULL, NULL);

  RelooperAddBranch(b7, b2, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(3))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), NULL);

  RelooperAddBranch(b7, b9, NULL, NULL);

  BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, b0, 1,
                                                        module);

  int decisions[] = { 67, 131, 49, 36, 112, 161, 62, 166, 16, 88, 176, 152, 161, 194, 117, 180, 60, 166, 55, 183, 150, 73, 196, 143, 76, 182, 97, 140, 126, 3 };
  int numDecisions = sizeof(decisions)/sizeof(int);

  // write out all the decisions, then the body of the function
  BinaryenExpressionRef full[numDecisions + 1];

  {
    int i;
    for (i = 0; i < numDecisions; i++) {
      full[i] = BinaryenStore(module,
        4, 0, 0,
        BinaryenConst(module, BinaryenLiteralInt32(8 + 4 * i)),
        BinaryenConst(module, BinaryenLiteralInt32(decisions[i])),
        BinaryenInt32()
      );
    }
  }
  full[numDecisions] = body;
  BinaryenExpressionRef all = BinaryenBlock(module, NULL, full,
                                            numDecisions + 1);

  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v",
                                                      BinaryenNone(),
                                                      NULL, 0);
  // locals: state, free-for-label
  BinaryenType localTypes[] = { BinaryenInt32(), BinaryenInt32() };
  BinaryenFunctionRef theMain = BinaryenAddFunction(module, "main", v,
                                                    localTypes, 2, all);
  BinaryenSetStart(module, theMain);

  // import

  BinaryenType iparams[] = { BinaryenInt32() };
  BinaryenFunctionTypeRef vi = BinaryenAddFunctionType(module, "vi",
                                                       BinaryenNone(),
                                                       iparams, 1);
  BinaryenAddImport(module, "print", "spectest", "print", vi);

  // memory
  BinaryenSetMemory(module, 1, 1, "mem", NULL, NULL, NULL, 0);

  assert(BinaryenModuleValidate(module));

  BinaryenModulePrint(module);

  BinaryenModuleOptimize(module);

  assert(BinaryenModuleValidate(module));

  BinaryenModulePrint(module);

  BinaryenModuleDispose(module);

  return 0;
}
