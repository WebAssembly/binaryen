
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include <binaryen-c.h>


// kitchen sink, tests the full API


// helpers

BinaryenExpressionRef makeUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenType inputType) {
  if (inputType == BinaryenInt32()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralInt32(-10)));
  if (inputType == BinaryenInt64()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralInt64(-22)));
  if (inputType == BinaryenFloat32()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralFloat32(-33.612f)));
  if (inputType == BinaryenFloat64()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralFloat64(-9005.841)));
  abort();
}

BinaryenExpressionRef makeBinary(BinaryenModuleRef module, BinaryenOp op, BinaryenType type) {
  if (type == BinaryenInt32()) return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralInt32(-10)), BinaryenConst(module, BinaryenLiteralInt32(-11)));
  if (type == BinaryenInt64()) return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralInt64(-22)), BinaryenConst(module, BinaryenLiteralInt64(-23)));
  if (type == BinaryenFloat32()) return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralFloat32(-33.612f)), BinaryenConst(module, BinaryenLiteralFloat32(-62.5f)));
  if (type == BinaryenFloat64()) return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralFloat64(-9005.841)), BinaryenConst(module, BinaryenLiteralFloat64(-9007.333)));
  abort();
}

BinaryenExpressionRef makeInt32(BinaryenModuleRef module, int x) {
  return BinaryenConst(module, BinaryenLiteralInt32(x));
}

BinaryenExpressionRef makeFloat32(BinaryenModuleRef module, float x) {
  return BinaryenConst(module, BinaryenLiteralFloat32(x));
}

BinaryenExpressionRef makeInt64(BinaryenModuleRef module, int64_t x) {
  return BinaryenConst(module, BinaryenLiteralInt64(x));
}

BinaryenExpressionRef makeFloat64(BinaryenModuleRef module, double x) {
  return BinaryenConst(module, BinaryenLiteralFloat64(x));
}

BinaryenExpressionRef makeSomething(BinaryenModuleRef module) {
  return makeInt32(module, 1337);
}

// tests

void test_core() {

  // Core types

  printf("BinaryenNone: %d\n", BinaryenNone());
  printf("BinaryenInt32: %d\n", BinaryenInt32());
  printf("BinaryenInt64: %d\n", BinaryenInt64());
  printf("BinaryenFloat32: %d\n", BinaryenFloat32());
  printf("BinaryenFloat64: %d\n", BinaryenFloat64());

  // Module creation

  BinaryenModuleRef module = BinaryenModuleCreate();

  // Literals and consts

  BinaryenExpressionRef constI32 = BinaryenConst(module, BinaryenLiteralInt32(1)),
                        constI64 = BinaryenConst(module, BinaryenLiteralInt64(2)),
                        constF32 = BinaryenConst(module, BinaryenLiteralFloat32(3.14f)),
                        constF64 = BinaryenConst(module, BinaryenLiteralFloat64(2.1828)),
                        constF32Bits = BinaryenConst(module, BinaryenLiteralFloat32Bits(0xffff1234)),
                        constF64Bits = BinaryenConst(module, BinaryenLiteralFloat64Bits(0xffff12345678abcdLL));

  const char* switchValueNames[] = { "the-value" };
  const char* switchBodyNames[] = { "the-nothing" };

  BinaryenExpressionRef callOperands2[] = { makeInt32(module, 13), makeFloat64(module, 3.7) };
  BinaryenExpressionRef callOperands4[] = { makeInt32(module, 13), makeInt64(module, 37), makeFloat32(module, 1.3f), makeFloat64(module, 3.7) };

  BinaryenType params[4] = { BinaryenInt32(), BinaryenInt64(), BinaryenFloat32(), BinaryenFloat64() };
  BinaryenFunctionTypeRef iiIfF = BinaryenAddFunctionType(module, "iiIfF", BinaryenInt32(), params, 4);

  BinaryenExpressionRef valueList[] = {
    // Unary
    makeUnary(module, BinaryenClzInt32(), 1),
    makeUnary(module, BinaryenCtzInt64(), 2),
    makeUnary(module, BinaryenPopcntInt32(), 1),
    makeUnary(module, BinaryenNegFloat32(), 3),
    makeUnary(module, BinaryenAbsFloat64(), 4),
    makeUnary(module, BinaryenCeilFloat32(), 3),
    makeUnary(module, BinaryenFloorFloat64(), 4),
    makeUnary(module, BinaryenTruncFloat32(), 3),
    makeUnary(module, BinaryenNearestFloat32(), 3),
    makeUnary(module, BinaryenSqrtFloat64(), 4),
    makeUnary(module, BinaryenEqZInt32(), 1),
    makeUnary(module, BinaryenExtendSInt32(), 1),
    makeUnary(module, BinaryenExtentUInt32(), 1),
    makeUnary(module, BinaryenWrapInt64(), 2),
    makeUnary(module, BinaryenTruncSFloat32ToInt32(), 3),
    makeUnary(module, BinaryenTruncSFloat32ToInt64(), 3),
    makeUnary(module, BinaryenTruncUFloat32ToInt32(), 3),
    makeUnary(module, BinaryenTruncUFloat32ToInt64(), 3),
    makeUnary(module, BinaryenTruncSFloat64ToInt32(), 4),
    makeUnary(module, BinaryenTruncSFloat64ToInt64(), 4),
    makeUnary(module, BinaryenTruncUFloat64ToInt32(), 4),
    makeUnary(module, BinaryenTruncUFloat64ToInt64(), 4),
    makeUnary(module, BinaryenReinterpretFloat32(), 3),
    makeUnary(module, BinaryenReinterpretFloat64(), 4),
    makeUnary(module, BinaryenConvertSInt32ToFloat32(), 1),
    makeUnary(module, BinaryenConvertSInt32ToFloat64(), 1),
    makeUnary(module, BinaryenConvertUInt32ToFloat32(), 1),
    makeUnary(module, BinaryenConvertUInt32ToFloat64(), 1),
    makeUnary(module, BinaryenConvertSInt64ToFloat32(), 2),
    makeUnary(module, BinaryenConvertSInt64ToFloat64(), 2),
    makeUnary(module, BinaryenConvertUInt64ToFloat32(), 2),
    makeUnary(module, BinaryenConvertUInt64ToFloat64(), 2),
    makeUnary(module, BinaryenPromoteFloat32(), 3),
    makeUnary(module, BinaryenDemoteFloat64(), 4),
    makeUnary(module, BinaryenReinterpretInt32(), 1),
    makeUnary(module, BinaryenReinterpretInt64(), 2),
    // Binary
    makeBinary(module, BinaryenAddInt32(), 1),
    makeBinary(module, BinaryenSubFloat64(), 4),
    makeBinary(module, BinaryenDivSInt32(), 1),
    makeBinary(module, BinaryenDivUInt64(), 2),
    makeBinary(module, BinaryenRemSInt64(), 2),
    makeBinary(module, BinaryenRemUInt32(), 1),
    makeBinary(module, BinaryenAndInt32(), 1),
    makeBinary(module, BinaryenOrInt64(), 2),
    makeBinary(module, BinaryenXorInt32(), 1),
    makeBinary(module, BinaryenShlInt64(), 2),
    makeBinary(module, BinaryenShrUInt64(), 2),
    makeBinary(module, BinaryenShrSInt32(), 1),
    makeBinary(module, BinaryenRotLInt32(), 1),
    makeBinary(module, BinaryenRotRInt64(), 2),
    makeBinary(module, BinaryenDivFloat32(), 3),
    makeBinary(module, BinaryenCopySignFloat64(), 4),
    makeBinary(module, BinaryenMinFloat32(), 3),
    makeBinary(module, BinaryenMaxFloat64(), 4),
    makeBinary(module, BinaryenEqInt32(), 1),
    makeBinary(module, BinaryenNeFloat32(), 3),
    makeBinary(module, BinaryenLtSInt32(), 1),
    makeBinary(module, BinaryenLtUInt64(), 2),
    makeBinary(module, BinaryenLeSInt64(), 2),
    makeBinary(module, BinaryenLeUInt32(), 1),
    makeBinary(module, BinaryenGtSInt64(), 2),
    makeBinary(module, BinaryenGtUInt32(), 1),
    makeBinary(module, BinaryenGeSInt32(), 1),
    makeBinary(module, BinaryenGeUInt64(), 2),
    makeBinary(module, BinaryenLtFloat32(), 3),
    makeBinary(module, BinaryenLeFloat64(), 4),
    makeBinary(module, BinaryenGtFloat64(), 4),
    makeBinary(module, BinaryenGeFloat32(), 3),
    // All the rest
    BinaryenBlock(module, NULL, NULL, 0), // block with no name
    BinaryenIf(module, makeInt32(module, 1), makeInt32(module, 2), makeInt32(module, 3)),
    BinaryenIf(module, makeInt32(module, 4), makeInt32(module, 5), NULL),
    BinaryenLoop(module, "out", "in", makeInt32(module, 0)),
    BinaryenLoop(module, NULL, "in2", makeInt32(module, 0)),
    BinaryenLoop(module, NULL, NULL, makeInt32(module, 0)),
    BinaryenBreak(module, "the-value", makeInt32(module, 0), makeInt32(module, 1)),
    BinaryenBreak(module, "the-nothing", makeInt32(module, 2), NULL),
    BinaryenBreak(module, "the-value", NULL, makeInt32(module, 3)),
    BinaryenBreak(module, "the-nothing", NULL, NULL),
    BinaryenSwitch(module, switchValueNames, 1, "the-value", makeInt32(module, 0), makeInt32(module, 1)),
    BinaryenSwitch(module, switchBodyNames, 1, "the-nothing", makeInt32(module, 2), NULL),
    BinaryenUnary(module, BinaryenEqZInt32(), // check the output type of the call node
      BinaryenCall(module, "kitchen-sinker", callOperands4, 4, BinaryenInt32())
    ),
    BinaryenUnary(module, BinaryenEqZInt32(), // check the output type of the call node
      BinaryenUnary(module,
        BinaryenTruncSFloat32ToInt32(),
        BinaryenCallImport(module, "an-imported", callOperands2, 2, BinaryenFloat32())
      )
    ),
    BinaryenUnary(module, BinaryenEqZInt32(), // check the output type of the call node
      BinaryenCallIndirect(module, makeInt32(module, 2449), callOperands4, 4, "iiIfF")
    ),
    BinaryenGetLocal(module, 0, BinaryenInt32()),
    BinaryenSetLocal(module, 0, makeInt32(module, 101)),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(), makeInt32(module, 1)),
    BinaryenLoad(module, 1, 1, 2, 4, BinaryenInt64(), makeInt32(module, 8)),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenFloat32(), makeInt32(module, 2)),
    BinaryenLoad(module, 8, 0, 2, 8, BinaryenFloat64(), makeInt32(module, 9)),
    BinaryenStore(module, 4, 0, 0, makeInt32(module, 10), makeInt32(module, 11)),
    BinaryenStore(module, 8, 2, 4, makeInt32(module, 110), makeInt64(module, 111)),
    BinaryenSelect(module, makeInt32(module, 1), makeInt32(module, 3), makeInt32(module, 5)),
    BinaryenReturn(module, makeInt32(module, 1337)),
    // TODO: Host
    BinaryenNop(module),
    BinaryenUnreachable(module),
  };

  // Make the main body of the function. and one block with a return value, one without
  BinaryenExpressionRef value = BinaryenBlock(module, "the-value", valueList, sizeof(valueList) / sizeof(BinaryenExpressionRef));
  BinaryenExpressionRef nothing = BinaryenBlock(module, "the-nothing", &value, 1);
  BinaryenExpressionRef bodyList[] = { nothing, makeInt32(module, 42) };
  BinaryenExpressionRef body = BinaryenBlock(module, "the-body", bodyList, 2);

  // Create the function
  BinaryenType localTypes[] = { BinaryenInt32() };
  BinaryenFunctionRef sinker = BinaryenAddFunction(module, "kitchen-sinker", iiIfF, localTypes, 1, body);

  // Imports

  BinaryenType iparams[2] = { BinaryenInt32(), BinaryenFloat64() };
  BinaryenFunctionTypeRef fiF = BinaryenAddFunctionType(module, "fiF", BinaryenFloat32(), iparams, 2);
  BinaryenAddImport(module, "an-imported", "module", "base", fiF);

  // Exports

  BinaryenAddExport(module, "kitchen-sinker", "kitchen_sinker");

  // Function table. One per module
  BinaryenFunctionRef functions[] = { sinker };
  BinaryenSetFunctionTable(module, functions, 1);

  // Memory. One per module

  const char *segments[] = { "hello, world" };
  BinaryenIndex segmentOffsets[] = { 10 };
  BinaryenIndex segmentSizes[] = { 12 };
  BinaryenSetMemory(module, 1, 256, "mem", segments, segmentOffsets, segmentSizes, 1);

  // Start function. One per module

  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v", BinaryenNone(), NULL, 0);
  BinaryenFunctionRef starter = BinaryenAddFunction(module, "starter", v, NULL, 0, BinaryenNop(module));
  BinaryenSetStart(module, starter);

  // Unnamed function type

  BinaryenFunctionTypeRef noname = BinaryenAddFunctionType(module, NULL, BinaryenNone(), NULL, 0);

  // Verify it validates
  assert(BinaryenModuleValidate(module));

  // Print it out
  BinaryenModulePrint(module);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);
}

void test_relooper() {
  BinaryenModuleRef module = BinaryenModuleCreate();
  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v", BinaryenNone(), NULL, 0);
  BinaryenType localTypes[] = { BinaryenInt32() };

  { // trivial: just one block
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block = RelooperAddBlock(relooper, makeSomething(module));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "just-one-block", v, localTypes, 1, body);
  }
  { // two blocks
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperAddBranch(block0, block1, NULL, NULL); // no condition, no code on branch
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "two-blocks", v, localTypes, 1, body);
  }
  { // two blocks with code between them
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperAddBranch(block0, block1, NULL, makeInt32(module, 77)); // code on branch
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "two-blocks-plus-code", v, localTypes, 1, body);
  }
  { // two blocks in a loop
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperAddBranch(block0, block1, NULL, NULL);
    RelooperAddBranch(block1, block0, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "loop", v, localTypes, 1, body);
  }
  { // two blocks in a loop with codes
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperAddBranch(block0, block1, NULL, makeInt32(module, 33));
    RelooperAddBranch(block1, block0, NULL, makeInt32(module, -66));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "loop-plus-code", v, localTypes, 1, body);
  }
  { // split
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeInt32(module, 2));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), NULL);
    RelooperAddBranch(block0, block2, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "split", v, localTypes, 1, body);
  }
  { // split + code
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeInt32(module, 2));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), makeInt32(module, 10));
    RelooperAddBranch(block0, block2, NULL, makeInt32(module, 20));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "split-plus-code", v, localTypes, 1, body);
  }
  { // if
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeInt32(module, 2));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), NULL);
    RelooperAddBranch(block0, block2, NULL, NULL);
    RelooperAddBranch(block1, block2, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "if", v, localTypes, 1, body);
  }
  { // if + code
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeInt32(module, 2));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), makeInt32(module, -1));
    RelooperAddBranch(block0, block2, NULL, makeInt32(module, -2));
    RelooperAddBranch(block1, block2, NULL, makeInt32(module, -3));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "if-plus-code", v, localTypes, 1, body);
  }
  { // if-else
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeInt32(module, 2));
    RelooperBlockRef block3 = RelooperAddBlock(relooper, makeInt32(module, 3));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), NULL);
    RelooperAddBranch(block0, block2, NULL, NULL);
    RelooperAddBranch(block1, block3, NULL, NULL);
    RelooperAddBranch(block2, block3, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "if-else", v, localTypes, 1, body);
  }
  { // loop+tail
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeInt32(module, 2));
    RelooperAddBranch(block0, block1, NULL, NULL);
    RelooperAddBranch(block1, block0, makeInt32(module, 10), NULL);
    RelooperAddBranch(block1, block2, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "loop-tail", v, localTypes, 1, body);
  }
  { // nontrivial loop + phi to head
    RelooperRef relooper = RelooperCreate();
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeInt32(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeInt32(module, 1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeInt32(module, 2));
    RelooperBlockRef block3 = RelooperAddBlock(relooper, makeInt32(module, 3));
    RelooperBlockRef block4 = RelooperAddBlock(relooper, makeInt32(module, 4));
    RelooperBlockRef block5 = RelooperAddBlock(relooper, makeInt32(module, 5));
    RelooperBlockRef block6 = RelooperAddBlock(relooper, makeInt32(module, 6));
    RelooperAddBranch(block0, block1, NULL, makeInt32(module, 10));
    RelooperAddBranch(block1, block2, makeInt32(module, -2), NULL);
    RelooperAddBranch(block1, block6, NULL, makeInt32(module, 20));
    RelooperAddBranch(block2, block3, makeInt32(module, -6), NULL);
    RelooperAddBranch(block2, block1, NULL, makeInt32(module, 30));
    RelooperAddBranch(block3, block4, makeInt32(module, -10), NULL);
    RelooperAddBranch(block3, block5, NULL, NULL);
    RelooperAddBranch(block4, block5, NULL, NULL);
    RelooperAddBranch(block5, block6, NULL, makeInt32(module, 40));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0, module);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "nontrivial-loop-plus-phi-to-head", v, localTypes, 1, body);
  }

  assert(BinaryenModuleValidate(module));

  printf("raw:\n");
  BinaryenModulePrint(module);

  BinaryenModuleOptimize(module);

  assert(BinaryenModuleValidate(module));

  printf("optimized:\n");
  BinaryenModulePrint(module);

  BinaryenModuleDispose(module);
}

void test_binaries() {
  char buffer[1024];
  size_t size;

  { // create a module and write it to binary
    BinaryenModuleRef module = BinaryenModuleCreate();
    BinaryenType params[2] = { BinaryenInt32(), BinaryenInt32() };
    BinaryenFunctionTypeRef iii = BinaryenAddFunctionType(module, "iii", BinaryenInt32(), params, 2);
    BinaryenExpressionRef x = BinaryenGetLocal(module, 0, BinaryenInt32()),
                          y = BinaryenGetLocal(module, 1, BinaryenInt32());
    BinaryenExpressionRef add = BinaryenBinary(module, BinaryenAddInt32(), x, y);
    BinaryenFunctionRef adder = BinaryenAddFunction(module, "adder", iii, NULL, 0, add);
    size = BinaryenModuleWrite(module, buffer, 1024); // write out the module
    BinaryenModuleDispose(module);
  }

  assert(size > 0);
  assert(size < 512); // this is a tiny module

  // read the module from the binary
  BinaryenModuleRef module = BinaryenModuleRead(buffer, size);

  // validate, print, and free
  assert(BinaryenModuleValidate(module));
  printf("module loaded from binary form:\n");
  BinaryenModulePrint(module);
  BinaryenModuleDispose(module);
}

int main() {
  test_core();
  test_relooper();
  test_binaries();
}
