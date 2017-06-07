

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
      BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(), BinaryenConst(module, BinaryenLiteralInt32(4))),
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
      BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(), BinaryenConst(module, BinaryenLiteralInt32(4))),
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
        BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(), BinaryenConst(module, BinaryenLiteralInt32(4)))
      )
    )
  };
  BinaryenExpressionRef debugger;
  if (1) debugger = BinaryenCallImport(module, "print", args, 1, BinaryenNone());
  else debugger = BinaryenNop(module);

  // return the decision. need to subtract 4 that we just added, and add 8 since that's where we start, so overall offset 4
  BinaryenExpressionRef returner = BinaryenLoad(module,
    4, 0, 4, 0, BinaryenInt32(),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(), BinaryenConst(module, BinaryenLiteralInt32(4)))
  );
  BinaryenExpressionRef checkBodyList[] = { halter, incer, debugger, returner };
  BinaryenExpressionRef checkBody = BinaryenBlock(module, NULL, checkBodyList, sizeof(checkBodyList) / sizeof(BinaryenExpressionRef), BinaryenUndefined());
  BinaryenFunctionTypeRef i = BinaryenAddFunctionType(module, "i", BinaryenInt32(), NULL, 0);
  BinaryenAddFunction(module, "check", i, NULL, 0, checkBody);

  // contents of main() begin here

  RelooperRef relooper = RelooperCreate();


  RelooperBlockRef b0;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(0)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b0 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperBlockRef b1;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(1)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b1 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperBlockRef b2;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(2)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b2 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperBlockRef b3;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(3)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b3 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperBlockRef b4;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(4)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b4 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperBlockRef b5;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(5)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b5 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperBlockRef b6;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(6)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b6 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperBlockRef b7;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(7)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b7 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperBlockRef b8;
  {
    BinaryenExpressionRef args[] = { BinaryenConst(module, BinaryenLiteralInt32(8)) };
    BinaryenExpressionRef list[] = {
      BinaryenCallImport(module, "print", args, 1, BinaryenNone()),
      BinaryenSetLocal(module, 0, BinaryenCall(module, "check", NULL, 0, BinaryenInt32()))
    };
    b8 = RelooperAddBlock(relooper, BinaryenBlock(module, NULL, list, 2, BinaryenUndefined()));
  }

  RelooperAddBranch(b0, b5, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(2))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), NULL);

  RelooperAddBranch(b0, b8, NULL, NULL);

  RelooperAddBranch(b1, b5, NULL, NULL);

  RelooperAddBranch(b2, b5, NULL, NULL);

  RelooperAddBranch(b3, b5, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(2))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), NULL);

  RelooperAddBranch(b3, b8, NULL, NULL);

  RelooperAddBranch(b4, b4, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(3))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), NULL);

  RelooperAddBranch(b4, b5, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(3))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(1))
  ), NULL);

  RelooperAddBranch(b4, b2, NULL, NULL);

  RelooperAddBranch(b5, b4, BinaryenBinary(module,
    BinaryenEqInt32(),
    BinaryenBinary(module,
      BinaryenRemUInt32(),
      BinaryenGetLocal(module, 0, BinaryenInt32()),
      BinaryenConst(module, BinaryenLiteralInt32(2))
    ),
    BinaryenConst(module, BinaryenLiteralInt32(0))
  ), NULL);

  RelooperAddBranch(b5, b5, NULL, NULL);

  RelooperAddBranch(b6, b6, NULL, NULL);

  RelooperAddBranch(b7, b8, NULL, NULL);

  RelooperAddBranch(b8, b4, NULL, NULL);

  BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, b0, 1, module);

  int decisions[] = { 89, 12, 78, 149, 118, 179, 127, 80, 21, 34, 119, 98, 38, 29, 36, 147, 13, 55, 166, 16, 143, 52, 130, 150, 176, 91, 34 };
  int numDecisions = sizeof(decisions)/sizeof(int);

  BinaryenExpressionRef full[numDecisions + 1]; // write out all the decisions, then the body of the function

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
  BinaryenExpressionRef all = BinaryenBlock(module, NULL, full, numDecisions + 1, BinaryenUndefined());

  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v", BinaryenNone(), NULL, 0);
  BinaryenType localTypes[] = { BinaryenInt32(), BinaryenInt32() }; // state, free-for-label
  BinaryenFunctionRef theMain = BinaryenAddFunction(module, "main", v, localTypes, 2, all);
  BinaryenSetStart(module, theMain);

  // import

  BinaryenType iparams[] = { BinaryenInt32() };
  BinaryenFunctionTypeRef vi = BinaryenAddFunctionType(module, "vi", BinaryenNone(), iparams, 1);
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
