
#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include <binaryen-c.h>


// kitchen sink, tests the full API


// helpers

BinaryenExpressionRef makeUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenType inputType) {
  if (inputType == BinaryenInt32()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralInt32(-10)));
  if (inputType == BinaryenInt64()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralInt64(-22)));
  if (inputType == BinaryenFloat32()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralFloat32(-33.612)));
  if (inputType == BinaryenFloat64()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralFloat64(-9005.841)));
  abort();
}

BinaryenExpressionRef makeBinary(BinaryenModuleRef module, BinaryenOp op, BinaryenType type) {
  if (type == BinaryenInt32()) return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralInt32(-10)), BinaryenConst(module, BinaryenLiteralInt32(-11)));
  if (type == BinaryenInt64()) return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralInt64(-22)), BinaryenConst(module, BinaryenLiteralInt64(-23)));
  if (type == BinaryenFloat32()) return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralFloat32(-33.612)), BinaryenConst(module, BinaryenLiteralFloat32(-62.5)));
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
                        constF32 = BinaryenConst(module, BinaryenLiteralFloat32(3.14)),
                        constF64 = BinaryenConst(module, BinaryenLiteralFloat64(2.1828)),
                        constF32Bits = BinaryenConst(module, BinaryenLiteralFloat32Bits(0xffff1234)),
                        constF64Bits = BinaryenConst(module, BinaryenLiteralFloat64Bits(0xffff12345678abcdLL));

  const char* switchValueNames[] = { "the-value" };
  const char* switchBodyNames[] = { "the-body" };

  BinaryenExpressionRef callOperands2[] = { makeInt32(module, 13), makeFloat64(module, 3.7) };
  BinaryenExpressionRef callOperands4[] = { makeInt32(module, 13), makeInt64(module, 37), makeFloat32(module, 1.3), makeFloat64(module, 3.7) };

  BinaryenType params[4] = { BinaryenInt32(), BinaryenInt64(), BinaryenFloat32(), BinaryenFloat64() };
  BinaryenFunctionTypeRef iiIfF = BinaryenAddFunctionType(module, "iiIfF", BinaryenInt32(), params, 4);

  BinaryenExpressionRef bodyList[] = {
    // Unary
    makeUnary(module, BinaryenClz(), 1),
    makeUnary(module, BinaryenCtz(), 2),
    makeUnary(module, BinaryenPopcnt(), 1),
    makeUnary(module, BinaryenNeg(), 3),
    makeUnary(module, BinaryenAbs(), 4),
    makeUnary(module, BinaryenCeil(), 3),
    makeUnary(module, BinaryenFloor(), 4),
    makeUnary(module, BinaryenTrunc(), 3),
    makeUnary(module, BinaryenNearest(), 3),
    makeUnary(module, BinaryenSqrt(), 4),
    makeUnary(module, BinaryenEqZ(), 1),
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
    makeUnary(module, BinaryenReinterpretInt64(), 1),
    // Binary
    makeBinary(module, BinaryenAdd(), 1),
    makeBinary(module, BinaryenSub(), 4),
    makeBinary(module, BinaryenDivS(), 1),
    makeBinary(module, BinaryenDivU(), 2),
    makeBinary(module, BinaryenRemS(), 2),
    makeBinary(module, BinaryenRemU(), 1),
    makeBinary(module, BinaryenAnd(), 1),
    makeBinary(module, BinaryenOr(), 2),
    makeBinary(module, BinaryenXor(), 1),
    makeBinary(module, BinaryenShl(), 2),
    makeBinary(module, BinaryenShrU(), 2),
    makeBinary(module, BinaryenShrS(), 1),
    makeBinary(module, BinaryenRotL(), 1),
    makeBinary(module, BinaryenRotR(), 2),
    makeBinary(module, BinaryenDiv(), 3),
    makeBinary(module, BinaryenCopySign(), 4),
    makeBinary(module, BinaryenMin(), 3),
    makeBinary(module, BinaryenMax(), 4),
    makeBinary(module, BinaryenEq(), 1),
    makeBinary(module, BinaryenNe(), 3),
    makeBinary(module, BinaryenLtS(), 1),
    makeBinary(module, BinaryenLtU(), 2),
    makeBinary(module, BinaryenLeS(), 2),
    makeBinary(module, BinaryenLeU(), 1),
    makeBinary(module, BinaryenGtS(), 2),
    makeBinary(module, BinaryenGtU(), 1),
    makeBinary(module, BinaryenGeS(), 1),
    makeBinary(module, BinaryenGeU(), 2),
    makeBinary(module, BinaryenLt(), 3),
    makeBinary(module, BinaryenLe(), 4),
    makeBinary(module, BinaryenGt(), 4),
    makeBinary(module, BinaryenGe(), 3),
    // All the rest
    BinaryenBlock(module, NULL, NULL, 0), // block with no name
    BinaryenIf(module, makeInt32(module, 1), makeInt32(module, 2), makeInt32(module, 3)),
    BinaryenIf(module, makeInt32(module, 4), makeInt32(module, 5), NULL),
    BinaryenLoop(module, "out", "in", makeInt32(module, 0)),
    BinaryenLoop(module, NULL, "in2", makeInt32(module, 0)),
    BinaryenLoop(module, NULL, NULL, makeInt32(module, 0)),
    BinaryenBreak(module, "the-value", makeInt32(module, 0), makeInt32(module, 1)),
    BinaryenBreak(module, "the-body", makeInt32(module, 2), NULL),
    BinaryenBreak(module, "the-value", NULL, makeInt32(module, 3)),
    BinaryenBreak(module, "the-body", NULL, NULL),
    BinaryenSwitch(module, switchValueNames, 1, "the-value", makeInt32(module, 0), makeInt32(module, 1)),
    BinaryenSwitch(module, switchBodyNames, 1, "the-body", makeInt32(module, 2), NULL),
    BinaryenCall(module, "kitchen-sinker", callOperands4, 4),
    BinaryenCallImport(module, "an-imported", callOperands2, 2),
    BinaryenCallIndirect(module, makeInt32(module, 2449), callOperands4, 4, iiIfF),
    BinaryenGetLocal(module, 0, BinaryenInt32()),
    BinaryenSetLocal(module, 0, makeInt32(module, 101)),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenInt32(), makeInt32(module, 1)),
    BinaryenLoad(module, 1, 1, 2, 4, BinaryenInt64(), makeInt32(module, 8)),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenFloat32(), makeInt32(module, 2)),
    BinaryenLoad(module, 8, 0, 2, 8, BinaryenFloat64(), makeInt32(module, 9)),
    BinaryenStore(module, 4, 0, 0, makeInt32(module, 10), makeInt32(module, 11)),
    BinaryenStore(module, 8, 2, 4, makeInt32(module, 110), makeInt64(module, 111)),
    BinaryenSelect(module, makeInt32(module, 1), makeInt32(module, 3), makeInt32(module, 5)),
    BinaryenReturn(module, NULL),
    BinaryenReturn(module, makeFloat32(module, 1)),
    // TODO: Host
    BinaryenNop(module),
    BinaryenUnreachable(module),
  };

  // Make the main body of the function. one block with a return value, one without
  BinaryenExpressionRef value = BinaryenBlock(module, "the-value", bodyList, sizeof(bodyList) / sizeof(BinaryenExpressionRef));
  BinaryenExpressionRef body = BinaryenBlock(module, "the-body", &value, 1);

  // Create the function
  BinaryenType localTypes[] = { BinaryenInt32() };
  BinaryenFunctionRef sinker = BinaryenAddFunction(module, "kitchen-sinker", iiIfF, localTypes, 1, body);

  // Imports

  BinaryenType iparams[2] = { BinaryenInt32(), BinaryenFloat64() };
  BinaryenFunctionTypeRef viF = BinaryenAddFunctionType(module, "viF", BinaryenNone(), iparams, 2);
  BinaryenAddImport(module, "an-imported", "module", "base", viF);

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
    BinaryenExpressionRef add = BinaryenBinary(module, BinaryenAdd(), x, y);
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

