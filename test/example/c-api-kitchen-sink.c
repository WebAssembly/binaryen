
// We always need asserts here
#ifdef NDEBUG
#undef NDEBUG
#endif

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include <binaryen-c.h>

// kitchen sink, tests the full API


// helpers

static const uint8_t v128_bytes[] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16};

BinaryenExpressionRef makeUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenType inputType) {
  if (inputType == BinaryenTypeInt32()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralInt32(-10)));
  if (inputType == BinaryenTypeInt64()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralInt64(-22)));
  if (inputType == BinaryenTypeFloat32()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralFloat32(-33.612f)));
  if (inputType == BinaryenTypeFloat64()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralFloat64(-9005.841)));
  if (inputType == BinaryenTypeVec128()) return BinaryenUnary(module, op, BinaryenConst(module, BinaryenLiteralVec128(v128_bytes)));
  abort();
}

BinaryenExpressionRef makeBinary(BinaryenModuleRef module, BinaryenOp op, BinaryenType type) {
  if (type == BinaryenTypeInt32()) {
    // use temp vars to ensure optimization doesn't change the order of operation in our trace recording
    BinaryenExpressionRef temp = BinaryenConst(module, BinaryenLiteralInt32(-11));
    return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralInt32(-10)), temp);
  }
  if (type == BinaryenTypeInt64()) {
    BinaryenExpressionRef temp = BinaryenConst(module, BinaryenLiteralInt64(-23));
    return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralInt64(-22)), temp);
  }
  if (type == BinaryenTypeFloat32()) {
    BinaryenExpressionRef temp = BinaryenConst(module, BinaryenLiteralFloat32(-62.5f));
    return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralFloat32(-33.612f)), temp);
  }
  if (type == BinaryenTypeFloat64()) {
    BinaryenExpressionRef temp = BinaryenConst(module, BinaryenLiteralFloat64(-9007.333));
    return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralFloat64(-9005.841)), temp);
  }
  if (type == BinaryenTypeVec128()) {
    BinaryenExpressionRef temp = BinaryenConst(module, BinaryenLiteralVec128(v128_bytes));
    return BinaryenBinary(module, op, BinaryenConst(module, BinaryenLiteralVec128(v128_bytes)), temp);
  }
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

BinaryenExpressionRef makeVec128(BinaryenModuleRef module, uint8_t const *bytes) {
  return BinaryenConst(module, BinaryenLiteralVec128(bytes));
}

BinaryenExpressionRef makeSomething(BinaryenModuleRef module) {
  return makeInt32(module, 1337);
}

BinaryenExpressionRef makeDroppedInt32(BinaryenModuleRef module, int x) {
  return BinaryenDrop(module, BinaryenConst(module, BinaryenLiteralInt32(x)));
}

BinaryenExpressionRef makeSIMDExtract(BinaryenModuleRef module, BinaryenOp op) {
  return BinaryenSIMDExtract(module, op, makeVec128(module, v128_bytes), 0);
}

BinaryenExpressionRef makeSIMDReplace(BinaryenModuleRef module, BinaryenOp op, BinaryenType type) {
  BinaryenExpressionRef val;
  if (type == BinaryenTypeInt32()) {
    val = makeInt32(module, 42);
  }
  if (type == BinaryenTypeInt64()) {
    val = makeInt64(module, 42);
  }
  if (type == BinaryenTypeFloat32()) {
    val = makeFloat32(module, 42.);
  }
  if (type == BinaryenTypeFloat64()) {
    val = makeFloat64(module, 42.);
  }
  if (!val) {
    abort();
  }
  return BinaryenSIMDReplace(module, op, makeVec128(module, v128_bytes), 0, val);
}

BinaryenExpressionRef makeSIMDShuffle(BinaryenModuleRef module) {
  BinaryenExpressionRef left = makeVec128(module, v128_bytes);
  BinaryenExpressionRef right = makeVec128(module, v128_bytes);
  return BinaryenSIMDShuffle(module, left, right, (uint8_t[16]) {});
}

BinaryenExpressionRef makeSIMDBitselect(BinaryenModuleRef module) {
  BinaryenExpressionRef left = makeVec128(module, v128_bytes);
  BinaryenExpressionRef right = makeVec128(module, v128_bytes);
  BinaryenExpressionRef cond = makeVec128(module, v128_bytes);
  return BinaryenSIMDBitselect(module, left, right, cond);
}

BinaryenExpressionRef makeSIMDShift(BinaryenModuleRef module, BinaryenOp op) {
  BinaryenExpressionRef vec = makeVec128(module, v128_bytes);
  return BinaryenSIMDShift(module, op, vec, makeInt32(module, 1));
}

BinaryenExpressionRef makeMemoryInit(BinaryenModuleRef module) {
  BinaryenExpressionRef dest = makeInt32(module, 1024);
  BinaryenExpressionRef offset = makeInt32(module, 0);
  BinaryenExpressionRef size = makeInt32(module, 12);
  return BinaryenMemoryInit(module, 0, dest, offset, size);
};

BinaryenExpressionRef makeDataDrop(BinaryenModuleRef module) {
  return BinaryenDataDrop(module, 0);
};

BinaryenExpressionRef makeMemoryCopy(BinaryenModuleRef module) {
  BinaryenExpressionRef dest = makeInt32(module, 2048);
  BinaryenExpressionRef source = makeInt32(module, 1024);
  BinaryenExpressionRef size = makeInt32(module, 12);
  return BinaryenMemoryCopy(module, dest, source, size);
};

BinaryenExpressionRef makeMemoryFill(BinaryenModuleRef module) {
  BinaryenExpressionRef dest = makeInt32(module, 0);
  BinaryenExpressionRef value = makeInt32(module, 42);
  BinaryenExpressionRef size = makeInt32(module, 1024);
  return BinaryenMemoryFill(module, dest, value, size);
};

// tests

void test_types() {
  printf("BinaryenTypeNone: %d\n", BinaryenTypeNone());
  printf("BinaryenTypeInt32: %d\n", BinaryenTypeInt32());
  printf("BinaryenTypeInt64: %d\n", BinaryenTypeInt64());
  printf("BinaryenTypeFloat32: %d\n", BinaryenTypeFloat32());
  printf("BinaryenTypeFloat64: %d\n", BinaryenTypeFloat64());
  printf("BinaryenTypeVec128: %d\n", BinaryenTypeVec128());
  printf("BinaryenTypeUnreachable: %d\n", BinaryenTypeUnreachable());
  printf("BinaryenTypeAuto: %d\n", BinaryenTypeAuto());
}

void test_core() {

  // Module creation

  BinaryenModuleRef module = BinaryenModuleCreate();

  // Literals and consts

  BinaryenExpressionRef constI32 = BinaryenConst(module, BinaryenLiteralInt32(1)),
                        constI64 = BinaryenConst(module, BinaryenLiteralInt64(2)),
                        constF32 = BinaryenConst(module, BinaryenLiteralFloat32(3.14f)),
                        constF64 = BinaryenConst(module, BinaryenLiteralFloat64(2.1828)),
                        constF32Bits = BinaryenConst(module, BinaryenLiteralFloat32Bits(0xffff1234)),
                        constF64Bits = BinaryenConst(module, BinaryenLiteralFloat64Bits(0xffff12345678abcdLL)),
                        constV128 = BinaryenConst(module, BinaryenLiteralVec128(v128_bytes));

  const char* switchValueNames[] = { "the-value" };
  const char* switchBodyNames[] = { "the-nothing" };

  BinaryenExpressionRef callOperands2[] = { makeInt32(module, 13), makeFloat64(module, 3.7) };
  BinaryenExpressionRef callOperands4[] = { makeInt32(module, 13), makeInt64(module, 37), makeFloat32(module, 1.3f), makeFloat64(module, 3.7) };
  BinaryenExpressionRef callOperands4b[] = { makeInt32(module, 13), makeInt64(module, 37), makeFloat32(module, 1.3f), makeFloat64(module, 3.7) };

  BinaryenType params[4] = { BinaryenTypeInt32(), BinaryenTypeInt64(), BinaryenTypeFloat32(), BinaryenTypeFloat64() };
  BinaryenFunctionTypeRef iiIfF = BinaryenAddFunctionType(module, "iiIfF", BinaryenTypeInt32(), params, 4);

  BinaryenExpressionRef temp1 = makeInt32(module, 1), temp2 = makeInt32(module, 2), temp3 = makeInt32(module, 3),
                        temp4 = makeInt32(module, 4), temp5 = makeInt32(module, 5),
                        temp6 = makeInt32(module, 0), temp7 = makeInt32(module, 1),
                        temp8 = makeInt32(module, 0), temp9 = makeInt32(module, 1),
                        temp10 = makeInt32(module, 1), temp11 = makeInt32(module, 3), temp12 = makeInt32(module, 5),
                        temp13 = makeInt32(module, 10), temp14 = makeInt32(module, 11),
                        temp15 = makeInt32(module, 110), temp16 = makeInt64(module, 111);

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
    makeUnary(module, BinaryenExtendUInt32(), 1),
    makeUnary(module, BinaryenWrapInt64(), 2),
    makeUnary(module, BinaryenTruncSFloat32ToInt32(), 3),
    makeUnary(module, BinaryenTruncSFloat32ToInt64(), 3),
    makeUnary(module, BinaryenTruncUFloat32ToInt32(), 3),
    makeUnary(module, BinaryenTruncUFloat32ToInt64(), 3),
    makeUnary(module, BinaryenTruncSFloat64ToInt32(), 4),
    makeUnary(module, BinaryenTruncSFloat64ToInt64(), 4),
    makeUnary(module, BinaryenTruncUFloat64ToInt32(), 4),
    makeUnary(module, BinaryenTruncUFloat64ToInt64(), 4),
    makeUnary(module, BinaryenTruncSatSFloat32ToInt32(), 3),
    makeUnary(module, BinaryenTruncSatSFloat32ToInt64(), 3),
    makeUnary(module, BinaryenTruncSatUFloat32ToInt32(), 3),
    makeUnary(module, BinaryenTruncSatUFloat32ToInt64(), 3),
    makeUnary(module, BinaryenTruncSatSFloat64ToInt32(), 4),
    makeUnary(module, BinaryenTruncSatSFloat64ToInt64(), 4),
    makeUnary(module, BinaryenTruncSatUFloat64ToInt32(), 4),
    makeUnary(module, BinaryenTruncSatUFloat64ToInt64(), 4),
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
    makeUnary(module, BinaryenSplatVecI8x16(), 1),
    makeUnary(module, BinaryenSplatVecI16x8(), 1),
    makeUnary(module, BinaryenSplatVecI32x4(), 1),
    makeUnary(module, BinaryenSplatVecI64x2(), 2),
    makeUnary(module, BinaryenSplatVecF32x4(), 3),
    makeUnary(module, BinaryenSplatVecF64x2(), 4),
    makeUnary(module, BinaryenNotVec128(), 5),
    makeUnary(module, BinaryenNegVecI8x16(), 5),
    makeUnary(module, BinaryenAnyTrueVecI8x16(), 5),
    makeUnary(module, BinaryenAllTrueVecI8x16(), 5),
    makeUnary(module, BinaryenNegVecI16x8(), 5),
    makeUnary(module, BinaryenAnyTrueVecI16x8(), 5),
    makeUnary(module, BinaryenAllTrueVecI16x8(), 5),
    makeUnary(module, BinaryenNegVecI32x4(), 5),
    makeUnary(module, BinaryenAnyTrueVecI32x4(), 5),
    makeUnary(module, BinaryenAllTrueVecI32x4(), 5),
    makeUnary(module, BinaryenNegVecI64x2(), 5),
    makeUnary(module, BinaryenAnyTrueVecI64x2(), 5),
    makeUnary(module, BinaryenAllTrueVecI64x2(), 5),
    makeUnary(module, BinaryenAbsVecF32x4(), 5),
    makeUnary(module, BinaryenNegVecF32x4(), 5),
    makeUnary(module, BinaryenSqrtVecF32x4(), 5),
    makeUnary(module, BinaryenAbsVecF64x2(), 5),
    makeUnary(module, BinaryenNegVecF64x2(), 5),
    makeUnary(module, BinaryenSqrtVecF64x2(), 5),
    makeUnary(module, BinaryenTruncSatSVecF32x4ToVecI32x4(), 5),
    makeUnary(module, BinaryenTruncSatUVecF32x4ToVecI32x4(), 5),
    makeUnary(module, BinaryenTruncSatSVecF64x2ToVecI64x2(), 5),
    makeUnary(module, BinaryenTruncSatUVecF64x2ToVecI64x2(), 5),
    makeUnary(module, BinaryenConvertSVecI32x4ToVecF32x4(), 5),
    makeUnary(module, BinaryenConvertUVecI32x4ToVecF32x4(), 5),
    makeUnary(module, BinaryenConvertSVecI64x2ToVecF64x2(), 5),
    makeUnary(module, BinaryenConvertUVecI64x2ToVecF64x2(), 5),
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
    makeBinary(module, BinaryenEqVecI8x16(), 5),
    makeBinary(module, BinaryenNeVecI8x16(), 5),
    makeBinary(module, BinaryenLtSVecI8x16(), 5),
    makeBinary(module, BinaryenLtUVecI8x16(), 5),
    makeBinary(module, BinaryenGtSVecI8x16(), 5),
    makeBinary(module, BinaryenGtUVecI8x16(), 5),
    makeBinary(module, BinaryenLeSVecI8x16(), 5),
    makeBinary(module, BinaryenLeUVecI8x16(), 5),
    makeBinary(module, BinaryenGeSVecI8x16(), 5),
    makeBinary(module, BinaryenGeUVecI8x16(), 5),
    makeBinary(module, BinaryenEqVecI16x8(), 5),
    makeBinary(module, BinaryenNeVecI16x8(), 5),
    makeBinary(module, BinaryenLtSVecI16x8(), 5),
    makeBinary(module, BinaryenLtUVecI16x8(), 5),
    makeBinary(module, BinaryenGtSVecI16x8(), 5),
    makeBinary(module, BinaryenGtUVecI16x8(), 5),
    makeBinary(module, BinaryenLeSVecI16x8(), 5),
    makeBinary(module, BinaryenLeUVecI16x8(), 5),
    makeBinary(module, BinaryenGeSVecI16x8(), 5),
    makeBinary(module, BinaryenGeUVecI16x8(), 5),
    makeBinary(module, BinaryenEqVecI32x4(), 5),
    makeBinary(module, BinaryenNeVecI32x4(), 5),
    makeBinary(module, BinaryenLtSVecI32x4(), 5),
    makeBinary(module, BinaryenLtUVecI32x4(), 5),
    makeBinary(module, BinaryenGtSVecI32x4(), 5),
    makeBinary(module, BinaryenGtUVecI32x4(), 5),
    makeBinary(module, BinaryenLeSVecI32x4(), 5),
    makeBinary(module, BinaryenLeUVecI32x4(), 5),
    makeBinary(module, BinaryenGeSVecI32x4(), 5),
    makeBinary(module, BinaryenGeUVecI32x4(), 5),
    makeBinary(module, BinaryenEqVecF32x4(), 5),
    makeBinary(module, BinaryenNeVecF32x4(), 5),
    makeBinary(module, BinaryenLtVecF32x4(), 5),
    makeBinary(module, BinaryenGtVecF32x4(), 5),
    makeBinary(module, BinaryenLeVecF32x4(), 5),
    makeBinary(module, BinaryenGeVecF32x4(), 5),
    makeBinary(module, BinaryenEqVecF64x2(), 5),
    makeBinary(module, BinaryenNeVecF64x2(), 5),
    makeBinary(module, BinaryenLtVecF64x2(), 5),
    makeBinary(module, BinaryenGtVecF64x2(), 5),
    makeBinary(module, BinaryenLeVecF64x2(), 5),
    makeBinary(module, BinaryenGeVecF64x2(), 5),
    makeBinary(module, BinaryenAndVec128(), 5),
    makeBinary(module, BinaryenOrVec128(), 5),
    makeBinary(module, BinaryenXorVec128(), 5),
    makeBinary(module, BinaryenAddVecI8x16(), 5),
    makeBinary(module, BinaryenAddSatSVecI8x16(), 5),
    makeBinary(module, BinaryenAddSatUVecI8x16(), 5),
    makeBinary(module, BinaryenSubVecI8x16(), 5),
    makeBinary(module, BinaryenSubSatSVecI8x16(), 5),
    makeBinary(module, BinaryenSubSatUVecI8x16(), 5),
    makeBinary(module, BinaryenMulVecI8x16(), 5),
    makeBinary(module, BinaryenAddVecI16x8(), 5),
    makeBinary(module, BinaryenAddSatSVecI16x8(), 5),
    makeBinary(module, BinaryenAddSatUVecI16x8(), 5),
    makeBinary(module, BinaryenSubVecI16x8(), 5),
    makeBinary(module, BinaryenSubSatSVecI16x8(), 5),
    makeBinary(module, BinaryenSubSatUVecI16x8(), 5),
    makeBinary(module, BinaryenMulVecI16x8(), 5),
    makeBinary(module, BinaryenAddVecI32x4(), 5),
    makeBinary(module, BinaryenSubVecI32x4(), 5),
    makeBinary(module, BinaryenMulVecI32x4(), 5),
    makeBinary(module, BinaryenAddVecI64x2(), 5),
    makeBinary(module, BinaryenSubVecI64x2(), 5),
    makeBinary(module, BinaryenAddVecF32x4(), 5),
    makeBinary(module, BinaryenSubVecF32x4(), 5),
    makeBinary(module, BinaryenMulVecF32x4(), 5),
    makeBinary(module, BinaryenDivVecF32x4(), 5),
    makeBinary(module, BinaryenMinVecF32x4(), 5),
    makeBinary(module, BinaryenMaxVecF32x4(), 5),
    makeBinary(module, BinaryenAddVecF64x2(), 5),
    makeBinary(module, BinaryenSubVecF64x2(), 5),
    makeBinary(module, BinaryenMulVecF64x2(), 5),
    makeBinary(module, BinaryenDivVecF64x2(), 5),
    makeBinary(module, BinaryenMinVecF64x2(), 5),
    makeBinary(module, BinaryenMaxVecF64x2(), 5),
    // SIMD lane manipulation
    makeSIMDExtract(module, BinaryenExtractLaneSVecI8x16()),
    makeSIMDExtract(module, BinaryenExtractLaneUVecI8x16()),
    makeSIMDExtract(module, BinaryenExtractLaneSVecI16x8()),
    makeSIMDExtract(module, BinaryenExtractLaneUVecI16x8()),
    makeSIMDExtract(module, BinaryenExtractLaneVecI32x4()),
    makeSIMDExtract(module, BinaryenExtractLaneVecI64x2()),
    makeSIMDExtract(module, BinaryenExtractLaneVecF32x4()),
    makeSIMDExtract(module, BinaryenExtractLaneVecF64x2()),
    makeSIMDReplace(module, BinaryenReplaceLaneVecI8x16(), 1),
    makeSIMDReplace(module, BinaryenReplaceLaneVecI16x8(), 1),
    makeSIMDReplace(module, BinaryenReplaceLaneVecI32x4(), 1),
    makeSIMDReplace(module, BinaryenReplaceLaneVecI64x2(), 2),
    makeSIMDReplace(module, BinaryenReplaceLaneVecF32x4(), 3),
    makeSIMDReplace(module, BinaryenReplaceLaneVecF64x2(), 4),
    // SIMD shift
    makeSIMDShift(module, BinaryenShlVecI8x16()),
    makeSIMDShift(module, BinaryenShrSVecI8x16()),
    makeSIMDShift(module, BinaryenShrUVecI8x16()),
    makeSIMDShift(module, BinaryenShlVecI16x8()),
    makeSIMDShift(module, BinaryenShrSVecI16x8()),
    makeSIMDShift(module, BinaryenShrUVecI16x8()),
    makeSIMDShift(module, BinaryenShlVecI32x4()),
    makeSIMDShift(module, BinaryenShrSVecI32x4()),
    makeSIMDShift(module, BinaryenShrUVecI32x4()),
    makeSIMDShift(module, BinaryenShlVecI64x2()),
    makeSIMDShift(module, BinaryenShrSVecI64x2()),
    makeSIMDShift(module, BinaryenShrUVecI64x2()),
    // Other SIMD
    makeSIMDShuffle(module),
    makeSIMDBitselect(module),
    // Bulk memory
    makeMemoryInit(module),
    makeDataDrop(module),
    makeMemoryCopy(module),
    makeMemoryFill(module),
    // All the rest
    BinaryenBlock(module, NULL, NULL, 0, -1), // block with no name and no type
    BinaryenIf(module, temp1, temp2, temp3),
    BinaryenIf(module, temp4, temp5, NULL),
    BinaryenLoop(module, "in", makeInt32(module, 0)),
    BinaryenLoop(module, NULL, makeInt32(module, 0)),
    BinaryenBreak(module, "the-value", temp6, temp7),
    BinaryenBreak(module, "the-nothing", makeInt32(module, 2), NULL),
    BinaryenBreak(module, "the-value", NULL, makeInt32(module, 3)),
    BinaryenBreak(module, "the-nothing", NULL, NULL),
    BinaryenSwitch(module, switchValueNames, 1, "the-value", temp8, temp9),
    BinaryenSwitch(module, switchBodyNames, 1, "the-nothing", makeInt32(module, 2), NULL),
    BinaryenUnary(module, BinaryenEqZInt32(), // check the output type of the call node
      BinaryenCall(module, "kitchen()sinker", callOperands4, 4, BinaryenTypeInt32())
    ),
    BinaryenUnary(module, BinaryenEqZInt32(), // check the output type of the call node
      BinaryenUnary(module,
        BinaryenTruncSFloat32ToInt32(),
        BinaryenCall(module, "an-imported", callOperands2, 2, BinaryenTypeFloat32())
      )
    ),
    BinaryenUnary(module, BinaryenEqZInt32(), // check the output type of the call node
      BinaryenCallIndirect(module, makeInt32(module, 2449), callOperands4b, 4, "iiIfF")
    ),
    BinaryenDrop(module, BinaryenGetLocal(module, 0, BinaryenTypeInt32())),
    BinaryenSetLocal(module, 0, makeInt32(module, 101)),
    BinaryenDrop(module, BinaryenTeeLocal(module, 0, makeInt32(module, 102))),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(), makeInt32(module, 1)),
    BinaryenLoad(module, 2, 1, 2, 1, BinaryenTypeInt64(), makeInt32(module, 8)),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeFloat32(), makeInt32(module, 2)),
    BinaryenLoad(module, 8, 0, 2, 8, BinaryenTypeFloat64(), makeInt32(module, 9)),
    BinaryenStore(module, 4, 0, 0, temp13, temp14, BinaryenTypeInt32()),
    BinaryenStore(module, 8, 2, 4, temp15, temp16, BinaryenTypeInt64()),
    BinaryenSelect(module, temp10, temp11, temp12),
    BinaryenReturn(module, makeInt32(module, 1337)),
    // TODO: Host
    BinaryenNop(module),
    BinaryenUnreachable(module),
  };

  BinaryenExpressionPrint(valueList[3]); // test printing a standalone expression

  // Make the main body of the function. and one block with a return value, one without
  BinaryenExpressionRef value = BinaryenBlock(module, "the-value", valueList, sizeof(valueList) / sizeof(BinaryenExpressionRef), -1);
  BinaryenExpressionRef droppedValue = BinaryenDrop(module, value);
  BinaryenExpressionRef nothing = BinaryenBlock(module, "the-nothing", &droppedValue, 1, -1);
  BinaryenExpressionRef bodyList[] = { nothing, makeInt32(module, 42) };
  BinaryenExpressionRef body = BinaryenBlock(module, "the-body", bodyList, 2, -1);

  // Create the function
  BinaryenType localTypes[] = { BinaryenTypeInt32() };
  BinaryenFunctionRef sinker = BinaryenAddFunction(module, "kitchen()sinker", iiIfF, localTypes, 1, body);

  // Globals

  BinaryenAddGlobal(module, "a-global", BinaryenTypeInt32(), 0, makeInt32(module, 7));
  BinaryenAddGlobal(module, "a-mutable-global", BinaryenTypeFloat32(), 1, makeFloat32(module, 7.5));

  // Imports

  BinaryenType iparams[2] = { BinaryenTypeInt32(), BinaryenTypeFloat64() };
  BinaryenFunctionTypeRef fiF = BinaryenAddFunctionType(module, "fiF", BinaryenTypeFloat32(), iparams, 2);
  BinaryenAddFunctionImport(module, "an-imported", "module", "base", fiF);

  // Exports

  BinaryenAddFunctionExport(module, "kitchen()sinker", "kitchen_sinker");

  // Function table. One per module
  const char* funcNames[] = { BinaryenFunctionGetName(sinker) };
  BinaryenSetFunctionTable(module, 1, 1, funcNames, 1);

  // Memory. One per module

  const char* segments[] = { "hello, world" };
  BinaryenExpressionRef segmentOffsets[] = { BinaryenConst(module, BinaryenLiteralInt32(10)) };
  BinaryenIndex segmentSizes[] = { 12 };
  BinaryenSetMemory(module, 1, 256, "mem", segments, segmentOffsets, segmentSizes, 1, 0);

  // Start function. One per module

  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v", BinaryenTypeNone(), NULL, 0);
  BinaryenFunctionRef starter = BinaryenAddFunction(module, "starter", v, NULL, 0, BinaryenNop(module));
  BinaryenSetStart(module, starter);

  // Unnamed function type

  BinaryenFunctionTypeRef noname = BinaryenAddFunctionType(module, NULL, BinaryenTypeNone(), NULL, 0);

  // A bunch of our code needs drop(), auto-add it
  BinaryenModuleAutoDrop(module);

  // Verify it validates
  assert(BinaryenModuleValidate(module));

  // Print it out
  BinaryenModulePrint(module);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);
}

void test_unreachable() {
  BinaryenModuleRef module = BinaryenModuleCreate();
  BinaryenFunctionTypeRef i = BinaryenAddFunctionType(module, "i", BinaryenTypeInt32(), NULL, 0);
  BinaryenFunctionTypeRef I = BinaryenAddFunctionType(module, "I", BinaryenTypeInt64(), NULL, 0);

  BinaryenExpressionRef body = BinaryenCallIndirect(module, BinaryenUnreachable(module), NULL, 0, "I");
  BinaryenFunctionRef fn = BinaryenAddFunction(module, "unreachable-fn", i, NULL, 0, body);

  assert(BinaryenModuleValidate(module));
  BinaryenModulePrint(module);
  BinaryenModuleDispose(module);
}

BinaryenExpressionRef makeCallCheck(BinaryenModuleRef module, int x) {
  BinaryenExpressionRef callOperands[] = { makeInt32(module, x) };
  return BinaryenCall(module, "check", callOperands, 1, BinaryenTypeNone());
}

void test_relooper() {
  BinaryenModuleRef module = BinaryenModuleCreate();
  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v", BinaryenTypeNone(), NULL, 0);
  BinaryenType localTypes[] = { BinaryenTypeInt32() };

  {
    BinaryenType iparams[1] = { BinaryenTypeInt32() };
    BinaryenFunctionTypeRef vi = BinaryenAddFunctionType(module, "vi", BinaryenTypeNone(), iparams, 1);
    BinaryenAddFunctionImport(module, "check", "module", "check", vi);
  }

  { // trivial: just one block
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block = RelooperAddBlock(relooper, makeCallCheck(module, 1337));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "just-one-block", v, localTypes, 1, body);
  }
  { // two blocks
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperAddBranch(block0, block1, NULL, NULL); // no condition, no code on branch
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "two-blocks", v, localTypes, 1, body);
  }
  { // two blocks with code between them
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperAddBranch(block0, block1, NULL, makeDroppedInt32(module, 77)); // code on branch
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "two-blocks-plus-code", v, localTypes, 1, body);
  }
  { // two blocks in a loop
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperAddBranch(block0, block1, NULL, NULL);
    RelooperAddBranch(block1, block0, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "loop", v, localTypes, 1, body);
  }
  { // two blocks in a loop with codes
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperAddBranch(block0, block1, NULL, makeDroppedInt32(module, 33));
    RelooperAddBranch(block1, block0, NULL, makeDroppedInt32(module, -66));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "loop-plus-code", v, localTypes, 1, body);
  }
  { // split
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), NULL);
    RelooperAddBranch(block0, block2, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "split", v, localTypes, 1, body);
  }
  { // split + code
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    BinaryenExpressionRef temp = makeDroppedInt32(module, 10);
    RelooperAddBranch(block0, block1, makeInt32(module, 55), temp);
    RelooperAddBranch(block0, block2, NULL, makeDroppedInt32(module, 20));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "split-plus-code", v, localTypes, 1, body);
  }
  { // if
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), NULL);
    RelooperAddBranch(block0, block2, NULL, NULL);
    RelooperAddBranch(block1, block2, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "if", v, localTypes, 1, body);
  }
  { // if + code
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    BinaryenExpressionRef temp = makeDroppedInt32(module, -1);
    RelooperAddBranch(block0, block1, makeInt32(module, 55), temp);
    RelooperAddBranch(block0, block2, NULL, makeDroppedInt32(module, -2));
    RelooperAddBranch(block1, block2, NULL, makeDroppedInt32(module, -3));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "if-plus-code", v, localTypes, 1, body);
  }
  { // if-else
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    RelooperBlockRef block3 = RelooperAddBlock(relooper, makeCallCheck(module,  3));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), NULL);
    RelooperAddBranch(block0, block2, NULL, NULL);
    RelooperAddBranch(block1, block3, NULL, NULL);
    RelooperAddBranch(block2, block3, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "if-else", v, localTypes, 1, body);
  }
  { // loop+tail
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    RelooperAddBranch(block0, block1, NULL, NULL);
    RelooperAddBranch(block1, block0, makeInt32(module, 10), NULL);
    RelooperAddBranch(block1, block2, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "loop-tail", v, localTypes, 1, body);
  }
  { // nontrivial loop + phi to head
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    RelooperBlockRef block3 = RelooperAddBlock(relooper, makeCallCheck(module,  3));
    RelooperBlockRef block4 = RelooperAddBlock(relooper, makeCallCheck(module,  4));
    RelooperBlockRef block5 = RelooperAddBlock(relooper, makeCallCheck(module,  5));
    RelooperBlockRef block6 = RelooperAddBlock(relooper, makeCallCheck(module,  6));
    RelooperAddBranch(block0, block1, NULL, makeDroppedInt32(module, 10));
    RelooperAddBranch(block1, block2, makeInt32(module, -2), NULL);
    RelooperAddBranch(block1, block6, NULL, makeDroppedInt32(module, 20));
    RelooperAddBranch(block2, block3, makeInt32(module, -6), NULL);
    RelooperAddBranch(block2, block1, NULL, makeDroppedInt32(module, 30));
    RelooperAddBranch(block3, block4, makeInt32(module, -10), NULL);
    RelooperAddBranch(block3, block5, NULL, NULL);
    RelooperAddBranch(block4, block5, NULL, NULL);
    RelooperAddBranch(block5, block6, NULL, makeDroppedInt32(module, 40));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "nontrivial-loop-plus-phi-to-head", v, localTypes, 1, body);
  }
  { // switch
    RelooperRef relooper = RelooperCreate(module);
    BinaryenExpressionRef temp = makeInt32(module, -99);
    RelooperBlockRef block0 = RelooperAddBlockWithSwitch(relooper, makeCallCheck(module,  0), temp);
    // TODO: this example is not very good, the blocks should end in a |return| as otherwise they
    //       fall through to each other. A relooper block should end in something that stops control
    //       flow, if it doesn't have branches going out
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    RelooperBlockRef block3 = RelooperAddBlock(relooper, makeCallCheck(module,  3));
    BinaryenIndex to_block1[] = { 2, 5 };
    RelooperAddBranchForSwitch(block0, block1, to_block1, 2, NULL);
    BinaryenIndex to_block2[] = { 4 };
    RelooperAddBranchForSwitch(block0, block2, to_block2, 1, makeDroppedInt32(module, 55));
    RelooperAddBranchForSwitch(block0, block3, NULL, 0, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "switch", v, localTypes, 1, body);
  }
  { // duff's device
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    RelooperAddBranch(block0, block1, makeInt32(module, 10), NULL);
    RelooperAddBranch(block0, block2, NULL, NULL);
    RelooperAddBranch(block1, block2, NULL, NULL);
    RelooperAddBranch(block2, block1, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 3); // use $3 as the helper var
    BinaryenType localTypes[] = { BinaryenTypeInt32(), BinaryenTypeInt32(), BinaryenTypeInt64(), BinaryenTypeInt32(), BinaryenTypeFloat32(), BinaryenTypeFloat64(), BinaryenTypeInt32() };
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "duffs-device", v, localTypes, sizeof(localTypes)/sizeof(BinaryenType), body);
  }

  BinaryenFunctionTypeRef i = BinaryenAddFunctionType(module, "i", BinaryenTypeInt32(), NULL, 0);

  { // return in a block
    RelooperRef relooper = RelooperCreate(module);
    BinaryenExpressionRef listList[] = { makeCallCheck(module,  42), BinaryenReturn(module, makeInt32(module, 1337)) };
    BinaryenExpressionRef list = BinaryenBlock(module, "the-list", listList, 2, -1);
    RelooperBlockRef block = RelooperAddBlock(relooper, list);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module, "return", i, localTypes, 1, body);
  }

  printf("raw:\n");
  BinaryenModulePrint(module);

  assert(BinaryenModuleValidate(module));

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
    BinaryenType params[2] = { BinaryenTypeInt32(), BinaryenTypeInt32() };
    BinaryenFunctionTypeRef iii = BinaryenAddFunctionType(module, "iii", BinaryenTypeInt32(), params, 2);
    BinaryenExpressionRef x = BinaryenGetLocal(module, 0, BinaryenTypeInt32()),
                          y = BinaryenGetLocal(module, 1, BinaryenTypeInt32());
    BinaryenExpressionRef add = BinaryenBinary(module, BinaryenAddInt32(), x, y);
    BinaryenFunctionRef adder = BinaryenAddFunction(module, "adder", iii, NULL, 0, add);
    BinaryenSetDebugInfo(1); // include names section
    size = BinaryenModuleWrite(module, buffer, 1024); // write out the module
    BinaryenSetDebugInfo(0);
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

void test_interpret() {
  // create a simple module with a start method that prints a number, and interpret it, printing that number.
  BinaryenModuleRef module = BinaryenModuleCreate();

  BinaryenType iparams[2] = { BinaryenTypeInt32() };
  BinaryenFunctionTypeRef vi = BinaryenAddFunctionType(module, "vi", BinaryenTypeNone(), iparams, 1);
  BinaryenAddFunctionImport(module, "print-i32", "spectest", "print", vi);

  BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v", BinaryenTypeNone(), NULL, 0);
  BinaryenExpressionRef callOperands[] = { makeInt32(module, 1234) };
  BinaryenExpressionRef call = BinaryenCall(module, "print-i32", callOperands, 1, BinaryenTypeNone());
  BinaryenFunctionRef starter = BinaryenAddFunction(module, "starter", v, NULL, 0, call);
  BinaryenSetStart(module, starter);

  BinaryenModulePrint(module);
  assert(BinaryenModuleValidate(module));
  BinaryenModuleInterpret(module);
  BinaryenModuleDispose(module);
}

void test_nonvalid() {
  // create a module that fails to validate
  {
    BinaryenModuleRef module = BinaryenModuleCreate();

    BinaryenFunctionTypeRef v = BinaryenAddFunctionType(module, "v", BinaryenTypeNone(), NULL, 0);
    BinaryenType localTypes[] = { BinaryenTypeInt32() };
    BinaryenFunctionRef func = BinaryenAddFunction(module, "func", v, localTypes, 1,
      BinaryenSetLocal(module, 0, makeInt64(module, 1234)) // wrong type!
    );

    BinaryenModulePrint(module);
    printf("validation: %d\n", BinaryenModuleValidate(module));

    BinaryenModuleDispose(module);
  }
}

void test_tracing() {
  BinaryenSetAPITracing(1);
  test_core();
  test_relooper();
  BinaryenSetAPITracing(0);
}

int main() {
  test_types();
  test_core();
  test_unreachable();
  test_relooper();
  test_binaries();
  test_interpret();
  test_nonvalid();
  test_tracing();

  return 0;
}
