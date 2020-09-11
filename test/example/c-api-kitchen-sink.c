// We always need asserts here
#ifdef NDEBUG
#undef NDEBUG
#endif

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

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

BinaryenExpressionRef makeSIMDTernary(BinaryenModuleRef module, BinaryenOp op) {
  BinaryenExpressionRef a = makeVec128(module, v128_bytes);
  BinaryenExpressionRef b = makeVec128(module, v128_bytes);
  BinaryenExpressionRef c = makeVec128(module, v128_bytes);
  return BinaryenSIMDTernary(module, op, a, b, c);
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
  BinaryenType valueType = 0xdeadbeef;

  BinaryenType none = BinaryenTypeNone();
  printf("  // BinaryenTypeNone: %d\n", none);
  assert(BinaryenTypeArity(none) == 0);
  BinaryenTypeExpand(none, &valueType);
  assert(valueType == 0xdeadbeef);

  BinaryenType unreachable = BinaryenTypeUnreachable();
  printf("  // BinaryenTypeUnreachable: %d\n", unreachable);
  assert(BinaryenTypeArity(unreachable) == 1);
  BinaryenTypeExpand(unreachable, &valueType);
  assert(valueType == unreachable);

  BinaryenType i32 = BinaryenTypeInt32();
  printf("  // BinaryenTypeInt32: %d\n", i32);
  assert(BinaryenTypeArity(i32) == 1);
  BinaryenTypeExpand(i32, &valueType);
  assert(valueType == i32);

  BinaryenType i64 = BinaryenTypeInt64();
  printf("  // BinaryenTypeInt64: %d\n", i64);
  assert(BinaryenTypeArity(i64) == 1);
  BinaryenTypeExpand(i64, &valueType);
  assert(valueType == i64);

  BinaryenType f32 = BinaryenTypeFloat32();
  printf("  // BinaryenTypeFloat32: %d\n", f32);
  assert(BinaryenTypeArity(f32) == 1);
  BinaryenTypeExpand(f32, &valueType);
  assert(valueType == f32);

  BinaryenType f64 = BinaryenTypeFloat64();
  printf("  // BinaryenTypeFloat64: %d\n", f64);
  assert(BinaryenTypeArity(f64) == 1);
  BinaryenTypeExpand(f64, &valueType);
  assert(valueType == f64);

  BinaryenType v128 = BinaryenTypeVec128();
  printf("  // BinaryenTypeVec128: %d\n", v128);
  assert(BinaryenTypeArity(v128) == 1);
  BinaryenTypeExpand(v128, &valueType);
  assert(valueType == v128);

  BinaryenType funcref = BinaryenTypeFuncref();
  printf("  // BinaryenTypeFuncref: %d\n", funcref);
  assert(BinaryenTypeArity(funcref) == 1);
  BinaryenTypeExpand(funcref, &valueType);
  assert(valueType == funcref);

  BinaryenType externref = BinaryenTypeExternref();
  printf("  // BinaryenTypeExternref: %d\n", externref);
  assert(BinaryenTypeArity(externref) == 1);
  BinaryenTypeExpand(externref, &valueType);
  assert(valueType == externref);

  BinaryenType exnref = BinaryenTypeExnref();
  printf("  // BinaryenTypeExnref: %d\n", exnref);
  assert(BinaryenTypeArity(exnref) == 1);
  BinaryenTypeExpand(exnref, &valueType);
  assert(valueType == exnref);

  BinaryenType anyref = BinaryenTypeAnyref();
  printf("  // BinaryenTypeAnyref: %d\n", anyref);
  assert(BinaryenTypeArity(anyref) == 1);
  BinaryenTypeExpand(anyref, &valueType);
  assert(valueType == anyref);

  printf("  // BinaryenTypeAuto: %d\n", BinaryenTypeAuto());

  BinaryenType pair[] = {i32, i32};

  BinaryenType i32_pair = BinaryenTypeCreate(pair, 2);
  assert(BinaryenTypeArity(i32_pair) == 2);
  pair[0] = pair[1] = none;
  BinaryenTypeExpand(i32_pair, pair);
  assert(pair[0] == i32 && pair[1] == i32);

  BinaryenType duplicate_pair = BinaryenTypeCreate(pair, 2);
  assert(duplicate_pair == i32_pair);

  pair[0] = pair[1] = f32;
  BinaryenType float_pair = BinaryenTypeCreate(pair, 2);
  assert(float_pair != i32_pair);
}

void test_features() {
  printf("BinaryenFeatureMVP: %d\n", BinaryenFeatureMVP());
  printf("BinaryenFeatureAtomics: %d\n", BinaryenFeatureAtomics());
  printf("BinaryenFeatureBulkMemory: %d\n", BinaryenFeatureBulkMemory());
  printf("BinaryenFeatureMutableGlobals: %d\n", BinaryenFeatureMutableGlobals());
  printf("BinaryenFeatureNontrappingFPToInt: %d\n", BinaryenFeatureNontrappingFPToInt());
  printf("BinaryenFeatureSignExt: %d\n", BinaryenFeatureSignExt());
  printf("BinaryenFeatureSIMD128: %d\n", BinaryenFeatureSIMD128());
  printf("BinaryenFeatureExceptionHandling: %d\n", BinaryenFeatureExceptionHandling());
  printf("BinaryenFeatureTailCall: %d\n", BinaryenFeatureTailCall());
  printf("BinaryenFeatureReferenceTypes: %d\n", BinaryenFeatureReferenceTypes());
  printf("BinaryenFeatureMultivalue: %d\n", BinaryenFeatureMultivalue());
  printf("BinaryenFeatureAnyref: %d\n", BinaryenFeatureAnyref());
  printf("BinaryenFeatureAll: %d\n", BinaryenFeatureAll());
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
  BinaryenExpressionRef tupleElements4a[] = {makeInt32(module, 13),
                                             makeInt64(module, 37),
                                             makeFloat32(module, 1.3f),
                                             makeFloat64(module, 3.7)};
  BinaryenExpressionRef tupleElements4b[] = {makeInt32(module, 13),
                                             makeInt64(module, 37),
                                             makeFloat32(module, 1.3f),
                                             makeFloat64(module, 3.7)};

  BinaryenType iIfF_[4] = {BinaryenTypeInt32(),
                           BinaryenTypeInt64(),
                           BinaryenTypeFloat32(),
                           BinaryenTypeFloat64()};
  BinaryenType iIfF = BinaryenTypeCreate(iIfF_, 4);

  BinaryenExpressionRef temp1 = makeInt32(module, 1), temp2 = makeInt32(module, 2), temp3 = makeInt32(module, 3),
                        temp4 = makeInt32(module, 4), temp5 = makeInt32(module, 5),
                        temp6 = makeInt32(module, 0), temp7 = makeInt32(module, 1),
                        temp8 = makeInt32(module, 0), temp9 = makeInt32(module, 1),
                        temp10 = makeInt32(module, 1), temp11 = makeInt32(module, 3), temp12 = makeInt32(module, 5),
                        temp13 = makeInt32(module, 10), temp14 = makeInt32(module, 11),
                        temp15 = makeInt32(module, 110), temp16 = makeInt64(module, 111);
  BinaryenExpressionRef externrefExpr = BinaryenRefNull(module, BinaryenTypeExternref());
  BinaryenExpressionRef funcrefExpr = BinaryenRefNull(module, BinaryenTypeFuncref());
  funcrefExpr = BinaryenRefFunc(module, "kitchen()sinker");
  BinaryenExpressionRef exnrefExpr = BinaryenRefNull(module, BinaryenTypeExnref());

  // Events
  BinaryenAddEvent(
    module, "a-event", 0, BinaryenTypeInt32(), BinaryenTypeNone());

  // Exception handling

  // (try
  //   (do
  //     (throw $a-event (i32.const 0))
  //   )
  //   (catch
  //     ;; We don't support multi-value yet. Use locals instead.
  //     (local.set 0 (exnref.pop))
  //     (drop
  //       (block $try-block (result i32)
  //         (rethrow
  //           (br_on_exn $try-block $a-event (local.get 5))
  //         )
  //       )
  //     )
  //   )
  // )
  BinaryenExpressionRef tryBody = BinaryenThrow(
    module, "a-event", (BinaryenExpressionRef[]){makeInt32(module, 0)}, 1);
  BinaryenExpressionRef catchBody = BinaryenBlock(
    module,
    NULL,
    (BinaryenExpressionRef[]){
      BinaryenLocalSet(module, 5, BinaryenPop(module, BinaryenTypeExnref())),
      BinaryenDrop(
        module,
        BinaryenBlock(module,
                      "try-block",
                      (BinaryenExpressionRef[]){BinaryenRethrow(
                        module,
                        BinaryenBrOnExn(
                          module,
                          "try-block",
                          "a-event",
                          BinaryenLocalGet(module, 5, BinaryenTypeExnref())))},
                      1,
                      BinaryenTypeInt32()))},
    2,
    BinaryenTypeNone());

  BinaryenType i32 = BinaryenTypeInt32();
  BinaryenType i64 = BinaryenTypeInt64();
  BinaryenType f32 = BinaryenTypeFloat32();
  BinaryenType f64 = BinaryenTypeFloat64();
  BinaryenType v128 = BinaryenTypeVec128();

  BinaryenExpressionRef valueList[] = {
    // Unary
    makeUnary(module, BinaryenClzInt32(), i32),
    makeUnary(module, BinaryenCtzInt64(), i64),
    makeUnary(module, BinaryenPopcntInt32(), i32),
    makeUnary(module, BinaryenNegFloat32(), f32),
    makeUnary(module, BinaryenAbsFloat64(), f64),
    makeUnary(module, BinaryenCeilFloat32(), f32),
    makeUnary(module, BinaryenFloorFloat64(), f64),
    makeUnary(module, BinaryenTruncFloat32(), f32),
    makeUnary(module, BinaryenNearestFloat32(), f32),
    makeUnary(module, BinaryenSqrtFloat64(), f64),
    makeUnary(module, BinaryenEqZInt32(), i32),
    makeUnary(module, BinaryenExtendSInt32(), i32),
    makeUnary(module, BinaryenExtendUInt32(), i32),
    makeUnary(module, BinaryenWrapInt64(), i64),
    makeUnary(module, BinaryenTruncSFloat32ToInt32(), f32),
    makeUnary(module, BinaryenTruncSFloat32ToInt64(), f32),
    makeUnary(module, BinaryenTruncUFloat32ToInt32(), f32),
    makeUnary(module, BinaryenTruncUFloat32ToInt64(), f32),
    makeUnary(module, BinaryenTruncSFloat64ToInt32(), f64),
    makeUnary(module, BinaryenTruncSFloat64ToInt64(), f64),
    makeUnary(module, BinaryenTruncUFloat64ToInt32(), f64),
    makeUnary(module, BinaryenTruncUFloat64ToInt64(), f64),
    makeUnary(module, BinaryenTruncSatSFloat32ToInt32(), f32),
    makeUnary(module, BinaryenTruncSatSFloat32ToInt64(), f32),
    makeUnary(module, BinaryenTruncSatUFloat32ToInt32(), f32),
    makeUnary(module, BinaryenTruncSatUFloat32ToInt64(), f32),
    makeUnary(module, BinaryenTruncSatSFloat64ToInt32(), f64),
    makeUnary(module, BinaryenTruncSatSFloat64ToInt64(), f64),
    makeUnary(module, BinaryenTruncSatUFloat64ToInt32(), f64),
    makeUnary(module, BinaryenTruncSatUFloat64ToInt64(), f64),
    makeUnary(module, BinaryenReinterpretFloat32(), f32),
    makeUnary(module, BinaryenReinterpretFloat64(), f64),
    makeUnary(module, BinaryenConvertSInt32ToFloat32(), i32),
    makeUnary(module, BinaryenConvertSInt32ToFloat64(), i32),
    makeUnary(module, BinaryenConvertUInt32ToFloat32(), i32),
    makeUnary(module, BinaryenConvertUInt32ToFloat64(), i32),
    makeUnary(module, BinaryenConvertSInt64ToFloat32(), i64),
    makeUnary(module, BinaryenConvertSInt64ToFloat64(), i64),
    makeUnary(module, BinaryenConvertUInt64ToFloat32(), i64),
    makeUnary(module, BinaryenConvertUInt64ToFloat64(), i64),
    makeUnary(module, BinaryenPromoteFloat32(), f32),
    makeUnary(module, BinaryenDemoteFloat64(), f64),
    makeUnary(module, BinaryenReinterpretInt32(), i32),
    makeUnary(module, BinaryenReinterpretInt64(), i64),
    makeUnary(module, BinaryenSplatVecI8x16(), i32),
    makeUnary(module, BinaryenSplatVecI16x8(), i32),
    makeUnary(module, BinaryenSplatVecI32x4(), i32),
    makeUnary(module, BinaryenSplatVecI64x2(), i64),
    makeUnary(module, BinaryenSplatVecF32x4(), f32),
    makeUnary(module, BinaryenSplatVecF64x2(), f64),
    makeUnary(module, BinaryenNotVec128(), v128),
    makeUnary(module, BinaryenAbsVecI8x16(), v128),
    makeUnary(module, BinaryenNegVecI8x16(), v128),
    makeUnary(module, BinaryenAnyTrueVecI8x16(), v128),
    makeUnary(module, BinaryenAllTrueVecI8x16(), v128),
    makeUnary(module, BinaryenBitmaskVecI8x16(), v128),
    makeUnary(module, BinaryenAbsVecI16x8(), v128),
    makeUnary(module, BinaryenNegVecI16x8(), v128),
    makeUnary(module, BinaryenAnyTrueVecI16x8(), v128),
    makeUnary(module, BinaryenAllTrueVecI16x8(), v128),
    makeUnary(module, BinaryenBitmaskVecI16x8(), v128),
    makeUnary(module, BinaryenAbsVecI32x4(), v128),
    makeUnary(module, BinaryenNegVecI32x4(), v128),
    makeUnary(module, BinaryenAnyTrueVecI32x4(), v128),
    makeUnary(module, BinaryenAllTrueVecI32x4(), v128),
    makeUnary(module, BinaryenBitmaskVecI32x4(), v128),
    makeUnary(module, BinaryenNegVecI64x2(), v128),
    makeUnary(module, BinaryenAnyTrueVecI64x2(), v128),
    makeUnary(module, BinaryenAllTrueVecI64x2(), v128),
    makeUnary(module, BinaryenAbsVecF32x4(), v128),
    makeUnary(module, BinaryenNegVecF32x4(), v128),
    makeUnary(module, BinaryenSqrtVecF32x4(), v128),
    makeUnary(module, BinaryenAbsVecF64x2(), v128),
    makeUnary(module, BinaryenNegVecF64x2(), v128),
    makeUnary(module, BinaryenSqrtVecF64x2(), v128),
    makeUnary(module, BinaryenTruncSatSVecF32x4ToVecI32x4(), v128),
    makeUnary(module, BinaryenTruncSatUVecF32x4ToVecI32x4(), v128),
    makeUnary(module, BinaryenTruncSatSVecF64x2ToVecI64x2(), v128),
    makeUnary(module, BinaryenTruncSatUVecF64x2ToVecI64x2(), v128),
    makeUnary(module, BinaryenConvertSVecI32x4ToVecF32x4(), v128),
    makeUnary(module, BinaryenConvertUVecI32x4ToVecF32x4(), v128),
    makeUnary(module, BinaryenConvertSVecI64x2ToVecF64x2(), v128),
    makeUnary(module, BinaryenConvertUVecI64x2ToVecF64x2(), v128),
    makeUnary(module, BinaryenWidenLowSVecI8x16ToVecI16x8(), v128),
    makeUnary(module, BinaryenWidenHighSVecI8x16ToVecI16x8(), v128),
    makeUnary(module, BinaryenWidenLowUVecI8x16ToVecI16x8(), v128),
    makeUnary(module, BinaryenWidenHighUVecI8x16ToVecI16x8(), v128),
    makeUnary(module, BinaryenWidenLowSVecI16x8ToVecI32x4(), v128),
    makeUnary(module, BinaryenWidenHighSVecI16x8ToVecI32x4(), v128),
    makeUnary(module, BinaryenWidenLowUVecI16x8ToVecI32x4(), v128),
    makeUnary(module, BinaryenWidenHighUVecI16x8ToVecI32x4(), v128),
    // Binary
    makeBinary(module, BinaryenAddInt32(), i32),
    makeBinary(module, BinaryenSubFloat64(), f64),
    makeBinary(module, BinaryenDivSInt32(), i32),
    makeBinary(module, BinaryenDivUInt64(), i64),
    makeBinary(module, BinaryenRemSInt64(), i64),
    makeBinary(module, BinaryenRemUInt32(), i32),
    makeBinary(module, BinaryenAndInt32(), i32),
    makeBinary(module, BinaryenOrInt64(), i64),
    makeBinary(module, BinaryenXorInt32(), i32),
    makeBinary(module, BinaryenShlInt64(), i64),
    makeBinary(module, BinaryenShrUInt64(), i64),
    makeBinary(module, BinaryenShrSInt32(), i32),
    makeBinary(module, BinaryenRotLInt32(), i32),
    makeBinary(module, BinaryenRotRInt64(), i64),
    makeBinary(module, BinaryenDivFloat32(), f32),
    makeBinary(module, BinaryenCopySignFloat64(), f64),
    makeBinary(module, BinaryenMinFloat32(), f32),
    makeBinary(module, BinaryenMaxFloat64(), f64),
    makeBinary(module, BinaryenEqInt32(), i32),
    makeBinary(module, BinaryenNeFloat32(), f32),
    makeBinary(module, BinaryenLtSInt32(), i32),
    makeBinary(module, BinaryenLtUInt64(), i64),
    makeBinary(module, BinaryenLeSInt64(), i64),
    makeBinary(module, BinaryenLeUInt32(), i32),
    makeBinary(module, BinaryenGtSInt64(), i64),
    makeBinary(module, BinaryenGtUInt32(), i32),
    makeBinary(module, BinaryenGeSInt32(), i32),
    makeBinary(module, BinaryenGeUInt64(), i64),
    makeBinary(module, BinaryenLtFloat32(), f32),
    makeBinary(module, BinaryenLeFloat64(), f64),
    makeBinary(module, BinaryenGtFloat64(), f64),
    makeBinary(module, BinaryenGeFloat32(), f32),
    makeBinary(module, BinaryenEqVecI8x16(), v128),
    makeBinary(module, BinaryenNeVecI8x16(), v128),
    makeBinary(module, BinaryenLtSVecI8x16(), v128),
    makeBinary(module, BinaryenLtUVecI8x16(), v128),
    makeBinary(module, BinaryenGtSVecI8x16(), v128),
    makeBinary(module, BinaryenGtUVecI8x16(), v128),
    makeBinary(module, BinaryenLeSVecI8x16(), v128),
    makeBinary(module, BinaryenLeUVecI8x16(), v128),
    makeBinary(module, BinaryenGeSVecI8x16(), v128),
    makeBinary(module, BinaryenGeUVecI8x16(), v128),
    makeBinary(module, BinaryenEqVecI16x8(), v128),
    makeBinary(module, BinaryenNeVecI16x8(), v128),
    makeBinary(module, BinaryenLtSVecI16x8(), v128),
    makeBinary(module, BinaryenLtUVecI16x8(), v128),
    makeBinary(module, BinaryenGtSVecI16x8(), v128),
    makeBinary(module, BinaryenGtUVecI16x8(), v128),
    makeBinary(module, BinaryenLeSVecI16x8(), v128),
    makeBinary(module, BinaryenLeUVecI16x8(), v128),
    makeBinary(module, BinaryenGeSVecI16x8(), v128),
    makeBinary(module, BinaryenGeUVecI16x8(), v128),
    makeBinary(module, BinaryenEqVecI32x4(), v128),
    makeBinary(module, BinaryenNeVecI32x4(), v128),
    makeBinary(module, BinaryenLtSVecI32x4(), v128),
    makeBinary(module, BinaryenLtUVecI32x4(), v128),
    makeBinary(module, BinaryenGtSVecI32x4(), v128),
    makeBinary(module, BinaryenGtUVecI32x4(), v128),
    makeBinary(module, BinaryenLeSVecI32x4(), v128),
    makeBinary(module, BinaryenLeUVecI32x4(), v128),
    makeBinary(module, BinaryenGeSVecI32x4(), v128),
    makeBinary(module, BinaryenGeUVecI32x4(), v128),
    makeBinary(module, BinaryenEqVecF32x4(), v128),
    makeBinary(module, BinaryenNeVecF32x4(), v128),
    makeBinary(module, BinaryenLtVecF32x4(), v128),
    makeBinary(module, BinaryenGtVecF32x4(), v128),
    makeBinary(module, BinaryenLeVecF32x4(), v128),
    makeBinary(module, BinaryenGeVecF32x4(), v128),
    makeBinary(module, BinaryenEqVecF64x2(), v128),
    makeBinary(module, BinaryenNeVecF64x2(), v128),
    makeBinary(module, BinaryenLtVecF64x2(), v128),
    makeBinary(module, BinaryenGtVecF64x2(), v128),
    makeBinary(module, BinaryenLeVecF64x2(), v128),
    makeBinary(module, BinaryenGeVecF64x2(), v128),
    makeBinary(module, BinaryenAndVec128(), v128),
    makeBinary(module, BinaryenOrVec128(), v128),
    makeBinary(module, BinaryenXorVec128(), v128),
    makeBinary(module, BinaryenAndNotVec128(), v128),
    makeBinary(module, BinaryenAddVecI8x16(), v128),
    makeBinary(module, BinaryenAddSatSVecI8x16(), v128),
    makeBinary(module, BinaryenAddSatUVecI8x16(), v128),
    makeBinary(module, BinaryenSubVecI8x16(), v128),
    makeBinary(module, BinaryenSubSatSVecI8x16(), v128),
    makeBinary(module, BinaryenSubSatUVecI8x16(), v128),
    makeBinary(module, BinaryenMulVecI8x16(), v128),
    makeBinary(module, BinaryenMinSVecI8x16(), v128),
    makeBinary(module, BinaryenMinUVecI8x16(), v128),
    makeBinary(module, BinaryenMaxSVecI8x16(), v128),
    makeBinary(module, BinaryenMaxUVecI8x16(), v128),
    makeBinary(module, BinaryenAvgrUVecI8x16(), v128),
    makeBinary(module, BinaryenAddVecI16x8(), v128),
    makeBinary(module, BinaryenAddSatSVecI16x8(), v128),
    makeBinary(module, BinaryenAddSatUVecI16x8(), v128),
    makeBinary(module, BinaryenSubVecI16x8(), v128),
    makeBinary(module, BinaryenSubSatSVecI16x8(), v128),
    makeBinary(module, BinaryenSubSatUVecI16x8(), v128),
    makeBinary(module, BinaryenMulVecI16x8(), v128),
    makeBinary(module, BinaryenMinSVecI16x8(), v128),
    makeBinary(module, BinaryenMinUVecI16x8(), v128),
    makeBinary(module, BinaryenMaxSVecI16x8(), v128),
    makeBinary(module, BinaryenMaxUVecI16x8(), v128),
    makeBinary(module, BinaryenAvgrUVecI16x8(), v128),
    makeBinary(module, BinaryenAddVecI32x4(), v128),
    makeBinary(module, BinaryenSubVecI32x4(), v128),
    makeBinary(module, BinaryenMulVecI32x4(), v128),
    makeBinary(module, BinaryenAddVecI64x2(), v128),
    makeBinary(module, BinaryenSubVecI64x2(), v128),
    makeBinary(module, BinaryenMulVecI64x2(), v128),
    makeBinary(module, BinaryenAddVecF32x4(), v128),
    makeBinary(module, BinaryenSubVecF32x4(), v128),
    makeBinary(module, BinaryenMulVecF32x4(), v128),
    makeBinary(module, BinaryenMinSVecI32x4(), v128),
    makeBinary(module, BinaryenMinUVecI32x4(), v128),
    makeBinary(module, BinaryenMaxSVecI32x4(), v128),
    makeBinary(module, BinaryenMaxUVecI32x4(), v128),
    makeBinary(module, BinaryenDotSVecI16x8ToVecI32x4(), v128),
    makeBinary(module, BinaryenDivVecF32x4(), v128),
    makeBinary(module, BinaryenMinVecF32x4(), v128),
    makeBinary(module, BinaryenMaxVecF32x4(), v128),
    makeBinary(module, BinaryenPMinVecF32x4(), v128),
    makeBinary(module, BinaryenPMaxVecF32x4(), v128),
    makeBinary(module, BinaryenCeilVecF32x4(), v128),
    makeBinary(module, BinaryenFloorVecF32x4(), v128),
    makeBinary(module, BinaryenTruncVecF32x4(), v128),
    makeBinary(module, BinaryenNearestVecF32x4(), v128),
    makeBinary(module, BinaryenAddVecF64x2(), v128),
    makeBinary(module, BinaryenSubVecF64x2(), v128),
    makeBinary(module, BinaryenMulVecF64x2(), v128),
    makeBinary(module, BinaryenDivVecF64x2(), v128),
    makeBinary(module, BinaryenMinVecF64x2(), v128),
    makeBinary(module, BinaryenMaxVecF64x2(), v128),
    makeBinary(module, BinaryenPMinVecF64x2(), v128),
    makeBinary(module, BinaryenPMaxVecF64x2(), v128),
    makeBinary(module, BinaryenCeilVecF64x2(), v128),
    makeBinary(module, BinaryenFloorVecF64x2(), v128),
    makeBinary(module, BinaryenTruncVecF64x2(), v128),
    makeBinary(module, BinaryenNearestVecF64x2(), v128),
    makeBinary(module, BinaryenNarrowSVecI16x8ToVecI8x16(), v128),
    makeBinary(module, BinaryenNarrowUVecI16x8ToVecI8x16(), v128),
    makeBinary(module, BinaryenNarrowSVecI32x4ToVecI16x8(), v128),
    makeBinary(module, BinaryenNarrowUVecI32x4ToVecI16x8(), v128),
    makeBinary(module, BinaryenSwizzleVec8x16(), v128),
    // SIMD lane manipulation
    makeSIMDExtract(module, BinaryenExtractLaneSVecI8x16()),
    makeSIMDExtract(module, BinaryenExtractLaneUVecI8x16()),
    makeSIMDExtract(module, BinaryenExtractLaneSVecI16x8()),
    makeSIMDExtract(module, BinaryenExtractLaneUVecI16x8()),
    makeSIMDExtract(module, BinaryenExtractLaneVecI32x4()),
    makeSIMDExtract(module, BinaryenExtractLaneVecI64x2()),
    makeSIMDExtract(module, BinaryenExtractLaneVecF32x4()),
    makeSIMDExtract(module, BinaryenExtractLaneVecF64x2()),
    makeSIMDReplace(module, BinaryenReplaceLaneVecI8x16(), i32),
    makeSIMDReplace(module, BinaryenReplaceLaneVecI16x8(), i32),
    makeSIMDReplace(module, BinaryenReplaceLaneVecI32x4(), i32),
    makeSIMDReplace(module, BinaryenReplaceLaneVecI64x2(), i64),
    makeSIMDReplace(module, BinaryenReplaceLaneVecF32x4(), f32),
    makeSIMDReplace(module, BinaryenReplaceLaneVecF64x2(), f64),
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
    // SIMD load
    BinaryenSIMDLoad(
      module, BinaryenLoadSplatVec8x16(), 0, 1, makeInt32(module, 128)),
    BinaryenSIMDLoad(
      module, BinaryenLoadSplatVec16x8(), 16, 1, makeInt32(module, 128)),
    BinaryenSIMDLoad(
      module, BinaryenLoadSplatVec32x4(), 16, 4, makeInt32(module, 128)),
    BinaryenSIMDLoad(
      module, BinaryenLoadSplatVec64x2(), 0, 4, makeInt32(module, 128)),
    BinaryenSIMDLoad(
      module, BinaryenLoadExtSVec8x8ToVecI16x8(), 0, 8, makeInt32(module, 128)),
    BinaryenSIMDLoad(
      module, BinaryenLoadExtUVec8x8ToVecI16x8(), 0, 8, makeInt32(module, 128)),
    BinaryenSIMDLoad(module,
                     BinaryenLoadExtSVec16x4ToVecI32x4(),
                     0,
                     8,
                     makeInt32(module, 128)),
    BinaryenSIMDLoad(module,
                     BinaryenLoadExtUVec16x4ToVecI32x4(),
                     0,
                     8,
                     makeInt32(module, 128)),
    BinaryenSIMDLoad(module,
                     BinaryenLoadExtSVec32x2ToVecI64x2(),
                     0,
                     8,
                     makeInt32(module, 128)),
    BinaryenSIMDLoad(module,
                     BinaryenLoadExtUVec32x2ToVecI64x2(),
                     0,
                     8,
                     makeInt32(module, 128)),
    // Other SIMD
    makeSIMDShuffle(module),
    makeSIMDTernary(module, BinaryenBitselectVec128()),
    makeSIMDTernary(module, BinaryenQFMAVecF32x4()),
    makeSIMDTernary(module, BinaryenQFMSVecF32x4()),
    makeSIMDTernary(module, BinaryenQFMAVecF64x2()),
    makeSIMDTernary(module, BinaryenQFMSVecF64x2()),
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
    BinaryenSwitch(
      module, switchBodyNames, 1, "the-nothing", makeInt32(module, 2), NULL),
    BinaryenUnary(
      module,
      BinaryenEqZInt32(), // check the output type of the call node
      BinaryenCall(
        module, "kitchen()sinker", callOperands4, 4, BinaryenTypeInt32())),
    BinaryenUnary(module,
                  BinaryenEqZInt32(), // check the output type of the call node
                  BinaryenUnary(module,
                                BinaryenTruncSFloat32ToInt32(),
                                BinaryenCall(module,
                                             "an-imported",
                                             callOperands2,
                                             2,
                                             BinaryenTypeFloat32()))),
    BinaryenUnary(module,
                  BinaryenEqZInt32(), // check the output type of the call node
                  BinaryenCallIndirect(module,
                                       makeInt32(module, 2449),
                                       callOperands4b,
                                       4,
                                       iIfF,
                                       BinaryenTypeInt32())),
    BinaryenDrop(module, BinaryenLocalGet(module, 0, BinaryenTypeInt32())),
    BinaryenLocalSet(module, 0, makeInt32(module, 101)),
    BinaryenDrop(
      module,
      BinaryenLocalTee(module, 0, makeInt32(module, 102), BinaryenTypeInt32())),
    BinaryenLoad(module, 4, 0, 0, 0, BinaryenTypeInt32(), makeInt32(module, 1)),
    BinaryenLoad(module, 2, 1, 2, 1, BinaryenTypeInt64(), makeInt32(module, 8)),
    BinaryenLoad(
      module, 4, 0, 0, 0, BinaryenTypeFloat32(), makeInt32(module, 2)),
    BinaryenLoad(
      module, 8, 0, 2, 8, BinaryenTypeFloat64(), makeInt32(module, 9)),
    BinaryenStore(module, 4, 0, 0, temp13, temp14, BinaryenTypeInt32()),
    BinaryenStore(module, 8, 2, 4, temp15, temp16, BinaryenTypeInt64()),
    BinaryenSelect(module, temp10, temp11, temp12, BinaryenTypeAuto()),
    BinaryenReturn(module, makeInt32(module, 1337)),
    // Tail call
    BinaryenReturnCall(
      module, "kitchen()sinker", callOperands4, 4, BinaryenTypeInt32()),
    BinaryenReturnCallIndirect(module,
                               makeInt32(module, 2449),
                               callOperands4b,
                               4,
                               iIfF,
                               BinaryenTypeInt32()),
    // Reference types
    BinaryenRefIsNull(module, externrefExpr),
    BinaryenRefIsNull(module, funcrefExpr),
    BinaryenRefIsNull(module, exnrefExpr),
    BinaryenSelect(
      module, temp10, BinaryenRefNull(module, BinaryenTypeFuncref()), BinaryenRefFunc(module, "kitchen()sinker"), BinaryenTypeFuncref()),
    // Exception handling
    BinaryenTry(module, tryBody, catchBody),
    // Atomics
    BinaryenAtomicStore(
      module,
      4,
      0,
      temp6,
      BinaryenAtomicLoad(module, 4, 0, BinaryenTypeInt32(), temp6),
      BinaryenTypeInt32()),
    BinaryenDrop(
      module,
      BinaryenAtomicWait(module, temp6, temp6, temp16, BinaryenTypeInt32())),
    BinaryenDrop(module, BinaryenAtomicNotify(module, temp6, temp6)),
    BinaryenAtomicFence(module),
    // Tuples
    BinaryenTupleMake(module, tupleElements4a, 4),
    BinaryenTupleExtract(
      module, BinaryenTupleMake(module, tupleElements4b, 4), 2),
    // Pop
    BinaryenPop(module, BinaryenTypeInt32()),
    BinaryenPop(module, BinaryenTypeInt64()),
    BinaryenPop(module, BinaryenTypeFloat32()),
    BinaryenPop(module, BinaryenTypeFloat64()),
    BinaryenPop(module, BinaryenTypeFuncref()),
    BinaryenPop(module, BinaryenTypeExternref()),
    BinaryenPop(module, BinaryenTypeExnref()),

    // TODO: Host
    BinaryenNop(module),
    BinaryenUnreachable(module),
  };

  BinaryenExpressionPrint(valueList[3]); // test printing a standalone expression

  // Make the main body of the function. and one block with a return value, one without
  BinaryenExpressionRef value =
    BinaryenBlock(module,
                  "the-value",
                  valueList,
                  sizeof(valueList) / sizeof(BinaryenExpressionRef),
                  BinaryenTypeAuto());
  BinaryenExpressionRef droppedValue = BinaryenDrop(module, value);
  BinaryenExpressionRef nothing = BinaryenBlock(module, "the-nothing", &droppedValue, 1, -1);
  BinaryenExpressionRef bodyList[] = { nothing, makeInt32(module, 42) };
  BinaryenExpressionRef body =
    BinaryenBlock(module, "the-body", bodyList, 2, BinaryenTypeAuto());

  // Create the function
  BinaryenType localTypes[] = {BinaryenTypeInt32(), BinaryenTypeExnref()};
  BinaryenFunctionRef sinker = BinaryenAddFunction(
    module, "kitchen()sinker", iIfF, BinaryenTypeInt32(), localTypes, 2, body);

  // Globals

  BinaryenAddGlobal(module, "a-global", BinaryenTypeInt32(), 0, makeInt32(module, 7));
  BinaryenAddGlobal(module, "a-mutable-global", BinaryenTypeFloat32(), 1, makeFloat32(module, 7.5));

  // Imports

  BinaryenType iF_[2] = {BinaryenTypeInt32(), BinaryenTypeFloat64()};
  BinaryenType iF = BinaryenTypeCreate(iF_, 2);
  BinaryenAddFunctionImport(
    module, "an-imported", "module", "base", iF, BinaryenTypeFloat32());

  // Exports

  BinaryenAddFunctionExport(module, "kitchen()sinker", "kitchen_sinker");

  // Function table. One per module
  const char* funcNames[] = { BinaryenFunctionGetName(sinker) };
  BinaryenSetFunctionTable(module, 1, 1, funcNames, 1, BinaryenConst(module, BinaryenLiteralInt32(0)));

  // Memory. One per module

  const char* segments[] = { "hello, world", "I am passive" };
  int8_t segmentPassive[] = { 0, 1 };
  BinaryenExpressionRef segmentOffsets[] = { BinaryenConst(module, BinaryenLiteralInt32(10)), NULL };
  BinaryenIndex segmentSizes[] = { 12, 12 };
  BinaryenSetMemory(module, 1, 256, "mem", segments, segmentPassive, segmentOffsets, segmentSizes, 2, 1);

  // Start function. One per module

  BinaryenFunctionRef starter = BinaryenAddFunction(module,
                                                    "starter",
                                                    BinaryenTypeNone(),
                                                    BinaryenTypeNone(),
                                                    NULL,
                                                    0,
                                                    BinaryenNop(module));
  BinaryenSetStart(module, starter);

  // A bunch of our code needs drop(), auto-add it
  BinaryenModuleAutoDrop(module);

  BinaryenFeatures features = BinaryenFeatureAll();
  BinaryenModuleSetFeatures(module, features);
  assert(BinaryenModuleGetFeatures(module) == features);

  // Verify it validates
  assert(BinaryenModuleValidate(module));

  // Print it out
  BinaryenModulePrint(module);

  // Clean up the module, which owns all the objects we created above
  BinaryenModuleDispose(module);
}

void test_unreachable() {
  BinaryenModuleRef module = BinaryenModuleCreate();
  BinaryenExpressionRef body = BinaryenCallIndirect(module,
                                                    BinaryenUnreachable(module),
                                                    NULL,
                                                    0,
                                                    BinaryenTypeNone(),
                                                    BinaryenTypeInt64());
  BinaryenFunctionRef fn = BinaryenAddFunction(module,
                                               "unreachable-fn",
                                               BinaryenTypeNone(),
                                               BinaryenTypeInt32(),
                                               NULL,
                                               0,
                                               body);

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
  BinaryenType localTypes[] = { BinaryenTypeInt32() };

  BinaryenAddFunctionImport(module,
                            "check",
                            "module",
                            "check",
                            BinaryenTypeInt32(),
                            BinaryenTypeNone());

  { // trivial: just one block
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block = RelooperAddBlock(relooper, makeCallCheck(module, 1337));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "just-one-block",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
  }
  { // two blocks
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module, 0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperAddBranch(block0, block1, NULL, NULL); // no condition, no code on branch
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "two-blocks",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
  }
  { // two blocks with code between them
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperAddBranch(block0, block1, NULL, makeDroppedInt32(module, 77)); // code on branch
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "two-blocks-plus-code",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
  }
  { // two blocks in a loop
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperAddBranch(block0, block1, NULL, NULL);
    RelooperAddBranch(block1, block0, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "loop",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
  }
  { // two blocks in a loop with codes
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperAddBranch(block0, block1, NULL, makeDroppedInt32(module, 33));
    RelooperAddBranch(block1, block0, NULL, makeDroppedInt32(module, -66));
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "loop-plus-code",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
  }
  { // split
    RelooperRef relooper = RelooperCreate(module);
    RelooperBlockRef block0 = RelooperAddBlock(relooper, makeCallCheck(module,  0));
    RelooperBlockRef block1 = RelooperAddBlock(relooper, makeCallCheck(module,  1));
    RelooperBlockRef block2 = RelooperAddBlock(relooper, makeCallCheck(module,  2));
    RelooperAddBranch(block0, block1, makeInt32(module, 55), NULL);
    RelooperAddBranch(block0, block2, NULL, NULL);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block0, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "split",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
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
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "split-plus-code",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
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
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "if",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
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
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "if-plus-code",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
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
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "if-else",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
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
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "loop-tail",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
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
    BinaryenFunctionRef sinker =
      BinaryenAddFunction(module,
                          "nontrivial-loop-plus-phi-to-head",
                          BinaryenTypeNone(),
                          BinaryenTypeNone(),
                          localTypes,
                          1,
                          body);
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
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "switch",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeNone(),
                                                     localTypes,
                                                     1,
                                                     body);
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
    BinaryenFunctionRef sinker =
      BinaryenAddFunction(module,
                          "duffs-device",
                          BinaryenTypeNone(),
                          BinaryenTypeNone(),
                          localTypes,
                          sizeof(localTypes) / sizeof(BinaryenType),
                          body);
  }

  { // return in a block
    RelooperRef relooper = RelooperCreate(module);
    BinaryenExpressionRef listList[] = { makeCallCheck(module,  42), BinaryenReturn(module, makeInt32(module, 1337)) };
    BinaryenExpressionRef list = BinaryenBlock(module, "the-list", listList, 2, -1);
    RelooperBlockRef block = RelooperAddBlock(relooper, list);
    BinaryenExpressionRef body = RelooperRenderAndDispose(relooper, block, 0);
    BinaryenFunctionRef sinker = BinaryenAddFunction(module,
                                                     "return",
                                                     BinaryenTypeNone(),
                                                     BinaryenTypeInt32(),
                                                     localTypes,
                                                     1,
                                                     body);
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
    BinaryenType ii_[2] = {BinaryenTypeInt32(), BinaryenTypeInt32()};
    BinaryenType ii = BinaryenTypeCreate(ii_, 2);
    BinaryenExpressionRef x = BinaryenLocalGet(module, 0, BinaryenTypeInt32()),
                          y = BinaryenLocalGet(module, 1, BinaryenTypeInt32());
    BinaryenExpressionRef add = BinaryenBinary(module, BinaryenAddInt32(), x, y);
    BinaryenFunctionRef adder = BinaryenAddFunction(
      module, "adder", ii, BinaryenTypeInt32(), NULL, 0, add);
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

  // write the s-expr representation of the module.
  BinaryenModuleWriteText(module, buffer, 1024);
  printf("module s-expr printed (in memory):\n%s\n", buffer);


  // writ the s-expr representation to a pointer which is managed by the
  // caller
  char *text = BinaryenModuleAllocateAndWriteText(module);
  printf("module s-expr printed (in memory, caller-owned):\n%s\n", text);
  free(text);


  BinaryenModuleDispose(module);
}

void test_interpret() {
  // create a simple module with a start method that prints a number, and interpret it, printing that number.
  BinaryenModuleRef module = BinaryenModuleCreate();

  BinaryenType iparams[2] = { BinaryenTypeInt32() };
  BinaryenAddFunctionImport(module,
                            "print-i32",
                            "spectest",
                            "print",
                            BinaryenTypeInt32(),
                            BinaryenTypeNone());

  BinaryenExpressionRef callOperands[] = { makeInt32(module, 1234) };
  BinaryenExpressionRef call = BinaryenCall(module, "print-i32", callOperands, 1, BinaryenTypeNone());
  BinaryenFunctionRef starter = BinaryenAddFunction(
    module, "starter", BinaryenTypeNone(), BinaryenTypeNone(), NULL, 0, call);
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

    BinaryenType localTypes[] = { BinaryenTypeInt32() };
    BinaryenFunctionRef func = BinaryenAddFunction(
      module,
      "func",
      BinaryenTypeNone(),
      BinaryenTypeNone(),
      localTypes,
      1,
      BinaryenLocalSet(module, 0, makeInt64(module, 1234)) // wrong type!
    );

    BinaryenModulePrint(module);
    printf("validation: %d\n", BinaryenModuleValidate(module));

    BinaryenModuleDispose(module);
  }
}

void test_color_status() {
    int i;

    // save old state
    const int old_state = BinaryenAreColorsEnabled();

    // Check that we can set the state to both {0, 1}
    for(i = 0; i <= 1; i++){
        BinaryenSetColorsEnabled(i);
        assert(BinaryenAreColorsEnabled() == i);
    }

    BinaryenSetColorsEnabled(old_state);
}

void test_for_each() {
  BinaryenIndex i;

  BinaryenModuleRef module = BinaryenModuleCreate();
  BinaryenFunctionRef fns[3] = {};
  fns[0] = BinaryenAddFunction(module,
                               "fn0",
                               BinaryenTypeNone(),
                               BinaryenTypeNone(),
                               NULL,
                               0,
                               BinaryenNop(module));
  fns[1] = BinaryenAddFunction(module,
                               "fn1",
                               BinaryenTypeNone(),
                               BinaryenTypeNone(),
                               NULL,
                               0,
                               BinaryenNop(module));
  fns[2] = BinaryenAddFunction(module,
                               "fn2",
                               BinaryenTypeNone(),
                               BinaryenTypeNone(),
                               NULL,
                               0,
                               BinaryenNop(module));
  {
    for (i = 0; i < BinaryenGetNumFunctions(module) ; i++) {
      assert(BinaryenGetFunctionByIndex(module, i) == fns[i]);
    }

    BinaryenExportRef exps[3] = {0};
    exps[0] = BinaryenAddFunctionExport(module, "fn0", "export0");
    exps[1] = BinaryenAddFunctionExport(module, "fn1", "export1");
    exps[2] = BinaryenAddFunctionExport(module, "fn2", "export2");

    for (i = 0; i < BinaryenGetNumExports(module) ; i++) {
      assert(BinaryenGetExportByIndex(module, i) == exps[i]);
    }

    const char* segments[] = { "hello, world", "segment data 2" };
    const uint32_t expected_offsets[] = { 10, 125 };
    int8_t segmentPassive[] = { 0, 0 };
    BinaryenIndex segmentSizes[] = { 12, 14 };

    BinaryenExpressionRef segmentOffsets[] = {
      BinaryenConst(module, BinaryenLiteralInt32(expected_offsets[0])),
      BinaryenGlobalGet(module, "a-global", BinaryenTypeInt32())
    };
    BinaryenSetMemory(module, 1, 256, "mem", segments, segmentPassive, segmentOffsets, segmentSizes, 2, 0);
    BinaryenAddGlobal(module, "a-global", BinaryenTypeInt32(), 0, makeInt32(module, expected_offsets[1]));

    for (i = 0; i < BinaryenGetNumMemorySegments(module) ; i++) {
      char out[15] = {};
      assert(BinaryenGetMemorySegmentByteOffset(module, i) == expected_offsets[i]);
      assert(BinaryenGetMemorySegmentByteLength(module, i) == segmentSizes[i]);
      BinaryenCopyMemorySegmentData(module, i, out);
      assert(0 == strcmp(segments[i], out));
    }
  }
  {
    const char* funcNames[] = {
      BinaryenFunctionGetName(fns[0]),
      BinaryenFunctionGetName(fns[1]),
      BinaryenFunctionGetName(fns[2])
    };
    BinaryenExpressionRef constExprRef = BinaryenConst(module, BinaryenLiteralInt32(0));
    BinaryenSetFunctionTable(module, 1, 1, funcNames, 3, constExprRef);
    assert(0 == BinaryenIsFunctionTableImported(module));
    assert(1 == BinaryenGetNumFunctionTableSegments(module));
    assert(constExprRef == BinaryenGetFunctionTableSegmentOffset(module, 0));
    assert(3 == BinaryenGetFunctionTableSegmentLength(module, 0));
    for (i = 0; i != BinaryenGetFunctionTableSegmentLength(module, 0); ++i)
    {
      const char * str = BinaryenGetFunctionTableSegmentData(module, 0, i);
      assert(0 == strcmp(funcNames[i], str));
    }
  }
  BinaryenModulePrint(module);
  BinaryenModuleDispose(module);
}

int main() {
  test_types();
  test_features();
  test_core();
  test_unreachable();
  test_relooper();
  test_binaries();
  test_interpret();
  test_nonvalid();
  test_color_status();
  test_for_each();

  return 0;
}
