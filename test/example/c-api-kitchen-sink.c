
#include <stdio.h>
#include <stdlib.h>

#include <binaryen-c.h>


// kitchen sink, tests the full API


// helpers

BinaryenExpressionRef makeUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenType inputType, BinaryenType outputType) {
  if (inputType == BinaryenInt32()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralInt32(-10)), outputType);
  if (inputType == BinaryenInt64()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralInt64(-22)), outputType);
  if (inputType == BinaryenFloat32()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralFloat32(-33.612)), outputType);
  if (inputType == BinaryenFloat64()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralFloat64(-9005.841)), outputType);
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

// main

int main() {

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

  const char* switchNames[] = { "the-body" };

  BinaryenExpressionRef callOperands2[] = { makeInt32(module, 13), makeFloat64(module, 3.7) };
  BinaryenExpressionRef callOperands4[] = { makeInt32(module, 13), makeInt64(module, 37), makeFloat32(module, 1.3), makeFloat64(module, 3.7) };

  BinaryenType params[4] = { BinaryenInt32(), BinaryenInt64(), BinaryenFloat32(), BinaryenFloat64() };
  BinaryenFunctionTypeRef iiIfF = BinaryenAddFunctionType(module, "iiIfF", BinaryenInt32(), params, 4);

  BinaryenExpressionRef bodyList[] = {
    // Unary
    makeUnary(module, BinaryenClz(), 1, 1),
    makeUnary(module, BinaryenCtz(), 2, 2),
    makeUnary(module, BinaryenPopcnt(), 1, 1),
    makeUnary(module, BinaryenNeg(), 3, 3),
    makeUnary(module, BinaryenAbs(), 4, 3),
    makeUnary(module, BinaryenCeil(), 3, 3),
    makeUnary(module, BinaryenFloor(), 4, 4),
    makeUnary(module, BinaryenTrunc(), 3, 3),
    makeUnary(module, BinaryenNearest(), 3, 3),
    makeUnary(module, BinaryenSqrt(), 4, 4),
    makeUnary(module, BinaryenEqZ(), 1, 1),
    makeUnary(module, BinaryenExtendSInt32(), 1, 2),
    makeUnary(module, BinaryenExtentUInt32(), 1, 2),
    makeUnary(module, BinaryenWrapInt64(), 2, 1),
    makeUnary(module, BinaryenTruncSFloat32(), 3, 1),
    makeUnary(module, BinaryenTruncUFloat32(), 3, 2),
    makeUnary(module, BinaryenTruncSFloat64(), 4, 2),
    makeUnary(module, BinaryenTruncUFloat64(), 4, 1),
    makeUnary(module, BinaryenReinterpretFloat(), 3, 1),
    makeUnary(module, BinaryenConvertSInt32(), 1, 3),
    makeUnary(module, BinaryenConvertUInt32(), 1, 4),
    makeUnary(module, BinaryenConvertSInt64(), 2, 3),
    makeUnary(module, BinaryenConvertUInt64(), 2, 4),
    makeUnary(module, BinaryenPromoteFloat32(), 3, 4),
    makeUnary(module, BinaryenDemoteFloat64(), 4, 3),
    makeUnary(module, BinaryenReinterpretInt(), 1, 3),
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
    BinaryenBreak(module, "the-body", makeInt32(module, 0), makeInt32(module, 1)),
    BinaryenBreak(module, "the-body", makeInt32(module, 2), NULL),
    BinaryenBreak(module, "the-body", NULL, makeInt32(module, 3)),
    BinaryenBreak(module, "the-body", NULL, NULL),
    BinaryenSwitch(module, switchNames, 1, "the-body", makeInt32(module, 0), makeInt32(module, 1)),
    BinaryenSwitch(module, switchNames, 1, "the-body", makeInt32(module, 2), NULL),
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

  // Make the main body of the function
  BinaryenExpressionRef body = BinaryenBlock(module, "the-body", bodyList, sizeof(bodyList) / sizeof(BinaryenExpressionRef));

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

  BinaryenSetStart(module, "sinker");

  // Print it out
  BinaryenModulePrint(module);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);
}

