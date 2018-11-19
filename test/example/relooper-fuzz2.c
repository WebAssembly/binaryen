

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
      BinaryenConst(module, BinaryenLiteralInt32(4 * 27)) // jumps of 4 bytes
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
  BinaryenFunctionTypeRef i = BinaryenAddFunctionType(module, "i",
                                                      BinaryenTypeInt32(),
                                                      NULL, 0);
  BinaryenAddFunction(module, "check", i, NULL, 0, checkBody);

  // contents of main() begin here

  RelooperRef relooper = RelooperCreate(module);


  RelooperBlockRef b0;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b0 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));

  }

  RelooperBlockRef b1;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b1 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));

  }

  RelooperBlockRef b2;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b2 = RelooperAddBlockWithSwitch(relooper,
      BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()),
      BinaryenBinary(module,
        BinaryenRemUInt32(),
        BinaryenGetLocal(module, 0, BinaryenTypeInt32()),
        BinaryenConst(module, BinaryenLiteralInt32(2))
      )
    );

  }

  RelooperBlockRef b3;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b3 = RelooperAddBlockWithSwitch(relooper,
      BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()),
      BinaryenBinary(module,
        BinaryenRemUInt32(),
        BinaryenGetLocal(module, 0, BinaryenTypeInt32()),
        BinaryenConst(module, BinaryenLiteralInt32(1))
      )
    );

  }

  RelooperBlockRef b4;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(4))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b4 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));

  }

  RelooperBlockRef b5;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b5 = RelooperAddBlockWithSwitch(relooper,
      BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()),
      BinaryenBinary(module,
        BinaryenRemUInt32(),
        BinaryenGetLocal(module, 0, BinaryenTypeInt32()),
        BinaryenConst(module, BinaryenLiteralInt32(1))
      )
    );

  }

  RelooperBlockRef b6;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(6))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b6 = RelooperAddBlockWithSwitch(relooper,
      BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()),
      BinaryenBinary(module,
        BinaryenRemUInt32(),
        BinaryenGetLocal(module, 0, BinaryenTypeInt32()),
        BinaryenConst(module, BinaryenLiteralInt32(3))
      )
    );

  }

  RelooperBlockRef b7;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b7 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));

  }

  RelooperBlockRef b8;
  {
    BinaryenExpressionRef args[] = {
      BinaryenConst(module, BinaryenLiteralInt32(0))
    };
    BinaryenExpressionRef list[] = {
      BinaryenCall(module, "print", args, 1, BinaryenTypeNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0,
                                               BinaryenTypeInt32()))
    };

    b8 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenTypeNone()));

  }

  RelooperAddBranch(b0, b1, NULL, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 4))
      ),
      BinaryenTypeInt32()
    ));

  RelooperAddBranch(b1, b1, NULL, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 4))
      ),
      BinaryenTypeInt32()
    ));

  {
    BinaryenIndex values[] = { 0,2,4,6,8,10,12,14,16,18,20,22,24,26,28,30,32,34,36,38,40,42,44,46,48,50,52,54,56,58,60,62,64,66,68,70,72,74,76,78,80,82,84,86 };
    RelooperAddBranchForSwitch(b2, b7, values,
                               sizeof(values) / sizeof(BinaryenIndex), 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 6))
      ),
      BinaryenTypeInt32()
    ));
  }

  RelooperAddBranchForSwitch(b2, b4, NULL, 0, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 4))
      ),
      BinaryenTypeInt32()
    ));

  RelooperAddBranchForSwitch(b3, b6, NULL, 0, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 5))
      ),
      BinaryenTypeInt32()
    ));

  RelooperAddBranch(b4, b7, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenTypeInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(2))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 5))
      ),
      BinaryenTypeInt32()
    ));

  RelooperAddBranch(b4, b3, NULL, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 3))
      ),
      BinaryenTypeInt32()
    ));

  RelooperAddBranchForSwitch(b5, b1, NULL, 0, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 4))
      ),
      BinaryenTypeInt32()
    ));

  {
    BinaryenIndex values[] = { 0,3,6,9,12,15,18,21,24,27,30,33,36,39,42,45,48,51,54,57,60,63,66,69,72,75,78,81,84,87,90,93,96,99,102,105,108 };
    RelooperAddBranchForSwitch(b6, b1, values,
                               sizeof(values) / sizeof(BinaryenIndex), 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 2))
      ),
      BinaryenTypeInt32()
    ));
  }

  {
    BinaryenIndex values[] = { 1,4,7,10,13,16,19,22,25,28,31,34,37,40,43,46,49,52,55,58,61,64,67,70,73,76,79,82,85,88,91,94,97,100,103,106,109,112,115,118,121,124,127,130,133,136,139,142,145,148,151,154,157,160 };
    RelooperAddBranchForSwitch(b6, b7, values,
                               sizeof(values) / sizeof(BinaryenIndex), 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 3))
      ),
      BinaryenTypeInt32()
    ));
  }

  RelooperAddBranchForSwitch(b6, b2, NULL, 0, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 3))
      ),
      BinaryenTypeInt32()
    ));

  RelooperAddBranch(b7, b5, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenTypeInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(2))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 1))
      ),
      BinaryenTypeInt32()
    ));

  RelooperAddBranch(b7, b1, NULL, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 4))
      ),
      BinaryenTypeInt32()
    ));

  RelooperAddBranch(b8, b8, NULL, 
    BinaryenStore(module,
      4, 0, 0,
      BinaryenConst(module, BinaryenLiteralInt32(4)),
      BinaryenBinary(module,
        BinaryenAddInt32(),
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(),
                     BinaryenConst(module, BinaryenLiteralInt32(4))),
        BinaryenConst(module, BinaryenLiteralInt32(4 * 2))
      ),
      BinaryenTypeInt32()
    ));

  BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, b0, 1);

  int decisions[] = { 5, 111, 119, 17, 179, 41, 32, 3, 171, 126, 13, 95, 70, 91, 9, 140, 99, 161, 38, 87, 153, 117, 140, 11, 157, 48, 4 };
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
        BinaryenTypeInt32()
      );
    }
  }
  full[numDecisions] = body;
  BinaryenExpressionRef all = BinaryenBlock(module, NULL, full,
                                            numDecisions + 1,
                                            BinaryenTypeNone());

  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v",
                                                      BinaryenTypeNone(),
                                                      NULL, 0);
  // locals: state, free-for-label
  BinaryenType localTypes[] = { BinaryenTypeInt32(), BinaryenTypeInt32() };
  BinaryenFunctionRef theMain = BinaryenAddFunction(module, "main", v,
                                                    localTypes, 2, all);
  BinaryenSetStart(module, theMain);

  // import

  BinaryenType iparams[] = { BinaryenTypeInt32() };
  BinaryenFunctionTypeRef vi = BinaryenAddFunctionType(module, "vi",
                                                       BinaryenTypeNone(),
                                                       iparams, 1);
  BinaryenAddFunctionImport(module, "print", "spectest", "print", vi);

  // memory
  BinaryenSetMemory(module, 1, 1, "mem", NULL, NULL, NULL, 0, 0);

  // optionally, optimize
  if (0) BinaryenModuleOptimize(module);

  assert(BinaryenModuleValidate(module));

  // write it out

  BinaryenModulePrint(module);

  BinaryenModuleDispose(module);

  return 0;
}
