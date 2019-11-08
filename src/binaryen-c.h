/*
 * Copyright 2016 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

//================
// Binaryen C API
//
// The first part of the API lets you create modules and their parts.
//
// The second part of the API lets you perform operations on modules.
//
// The third part of the API lets you provide a general control-flow
//   graph (CFG) as input.
//
// The final part of the API contains miscellaneous utilities like
//   debugging/tracing for the API itself.
//
// ---------------
//
// Thread safety: You can create Expressions in parallel, as they do not
//                refer to global state. BinaryenAddFunction and
//                BinaryenAddFunctionType are also thread-safe, which means
//                that you can create functions and their contents in multiple
//                threads. This is important since functions are where the
//                majority of the work is done.
//                Other methods - creating imports, exports, etc. - are
//                not currently thread-safe (as there is typically no need
//                to parallelize them).
//
//================

#ifndef wasm_binaryen_c_h
#define wasm_binaryen_c_h

#include <stddef.h>
#include <stdint.h>

#ifdef __GNUC__
#define WASM_DEPRECATED __attribute__((deprecated))
#elif defined(_MSC_VER)
#define WASM_DEPRECATED __declspec(deprecated)
#else
#define WASM_DEPRECATED
#endif

#if defined(_MSC_VER) && !defined(BUILD_STATIC_LIBRARY)
#define BINARYEN_API __declspec(dllexport)
#else
#define BINARYEN_API
#endif

#ifdef __cplusplus
extern "C" {
#endif

//
// ========== Module Creation ==========
//

// BinaryenIndex
//
// Used for internal indexes and list sizes.

typedef uint32_t BinaryenIndex;

// Core types (call to get the value of each; you can cache them, they
// never change)

typedef uint32_t BinaryenType;

BINARYEN_API BinaryenType BinaryenTypeNone(void);
BINARYEN_API BinaryenType BinaryenTypeInt32(void);
BINARYEN_API BinaryenType BinaryenTypeInt64(void);
BINARYEN_API BinaryenType BinaryenTypeFloat32(void);
BINARYEN_API BinaryenType BinaryenTypeFloat64(void);
BINARYEN_API BinaryenType BinaryenTypeVec128(void);
BINARYEN_API BinaryenType BinaryenTypeAnyref(void);
BINARYEN_API BinaryenType BinaryenTypeExnref(void);
BINARYEN_API BinaryenType BinaryenTypeUnreachable(void);
// Not a real type. Used as the last parameter to BinaryenBlock to let
// the API figure out the type instead of providing one.
BINARYEN_API BinaryenType BinaryenTypeAuto(void);

WASM_DEPRECATED BinaryenType BinaryenNone(void);
WASM_DEPRECATED BinaryenType BinaryenInt32(void);
WASM_DEPRECATED BinaryenType BinaryenInt64(void);
WASM_DEPRECATED BinaryenType BinaryenFloat32(void);
WASM_DEPRECATED BinaryenType BinaryenFloat64(void);
WASM_DEPRECATED BinaryenType BinaryenUndefined(void);

// Expression ids (call to get the value of each; you can cache them)

typedef uint32_t BinaryenExpressionId;

BINARYEN_API BinaryenExpressionId BinaryenInvalidId(void);
BINARYEN_API BinaryenExpressionId BinaryenBlockId(void);
BINARYEN_API BinaryenExpressionId BinaryenIfId(void);
BINARYEN_API BinaryenExpressionId BinaryenLoopId(void);
BINARYEN_API BinaryenExpressionId BinaryenBreakId(void);
BINARYEN_API BinaryenExpressionId BinaryenSwitchId(void);
BINARYEN_API BinaryenExpressionId BinaryenCallId(void);
BINARYEN_API BinaryenExpressionId BinaryenCallIndirectId(void);
BINARYEN_API BinaryenExpressionId BinaryenLocalGetId(void);
BINARYEN_API BinaryenExpressionId BinaryenLocalSetId(void);
BINARYEN_API BinaryenExpressionId BinaryenGlobalGetId(void);
BINARYEN_API BinaryenExpressionId BinaryenGlobalSetId(void);
BINARYEN_API BinaryenExpressionId BinaryenLoadId(void);
BINARYEN_API BinaryenExpressionId BinaryenStoreId(void);
BINARYEN_API BinaryenExpressionId BinaryenConstId(void);
BINARYEN_API BinaryenExpressionId BinaryenUnaryId(void);
BINARYEN_API BinaryenExpressionId BinaryenBinaryId(void);
BINARYEN_API BinaryenExpressionId BinaryenSelectId(void);
BINARYEN_API BinaryenExpressionId BinaryenDropId(void);
BINARYEN_API BinaryenExpressionId BinaryenReturnId(void);
BINARYEN_API BinaryenExpressionId BinaryenHostId(void);
BINARYEN_API BinaryenExpressionId BinaryenNopId(void);
BINARYEN_API BinaryenExpressionId BinaryenUnreachableId(void);
BINARYEN_API BinaryenExpressionId BinaryenAtomicCmpxchgId(void);
BINARYEN_API BinaryenExpressionId BinaryenAtomicRMWId(void);
BINARYEN_API BinaryenExpressionId BinaryenAtomicWaitId(void);
BINARYEN_API BinaryenExpressionId BinaryenAtomicNotifyId(void);
BINARYEN_API BinaryenExpressionId BinaryenAtomicFenceId(void);
BINARYEN_API BinaryenExpressionId BinaryenSIMDExtractId(void);
BINARYEN_API BinaryenExpressionId BinaryenSIMDReplaceId(void);
BINARYEN_API BinaryenExpressionId BinaryenSIMDShuffleId(void);
BINARYEN_API BinaryenExpressionId BinaryenSIMDTernaryId(void);
BINARYEN_API BinaryenExpressionId BinaryenSIMDShiftId(void);
BINARYEN_API BinaryenExpressionId BinaryenSIMDLoadId(void);
BINARYEN_API BinaryenExpressionId BinaryenMemoryInitId(void);
BINARYEN_API BinaryenExpressionId BinaryenDataDropId(void);
BINARYEN_API BinaryenExpressionId BinaryenMemoryCopyId(void);
BINARYEN_API BinaryenExpressionId BinaryenMemoryFillId(void);
BINARYEN_API BinaryenExpressionId BinaryenTryId(void);
BINARYEN_API BinaryenExpressionId BinaryenThrowId(void);
BINARYEN_API BinaryenExpressionId BinaryenRethrowId(void);
BINARYEN_API BinaryenExpressionId BinaryenBrOnExnId(void);
BINARYEN_API BinaryenExpressionId BinaryenPushId(void);
BINARYEN_API BinaryenExpressionId BinaryenPopId(void);

// External kinds (call to get the value of each; you can cache them)

typedef uint32_t BinaryenExternalKind;

BINARYEN_API BinaryenExternalKind BinaryenExternalFunction(void);
BINARYEN_API BinaryenExternalKind BinaryenExternalTable(void);
BINARYEN_API BinaryenExternalKind BinaryenExternalMemory(void);
BINARYEN_API BinaryenExternalKind BinaryenExternalGlobal(void);
BINARYEN_API BinaryenExternalKind BinaryenExternalEvent(void);

// Features. Call to get the value of each; you can cache them. Use bitwise
// operators to combine and test particular features.

typedef uint32_t BinaryenFeatures;

BINARYEN_API BinaryenFeatures BinaryenFeatureMVP(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureAtomics(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureBulkMemory(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureMutableGlobals(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureNontrappingFPToInt(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureSignExt(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureSIMD128(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureExceptionHandling(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureTailCall(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureReferenceTypes(void);
BINARYEN_API BinaryenFeatures BinaryenFeatureAll(void);

// Modules
//
// Modules contain lists of functions, imports, exports, function types. The
// Add* methods create them on a module. The module owns them and will free
// their memory when the module is disposed of.
//
// Expressions are also allocated inside modules, and freed with the module.
// They are not created by Add* methods, since they are not added directly on
// the module, instead, they are arguments to other expressions (and then they
// are the children of that AST node), or to a function (and then they are the
// body of that function).
//
// A module can also contain a function table for indirect calls, a memory,
// and a start method.

typedef void* BinaryenModuleRef;

BINARYEN_API BinaryenModuleRef BinaryenModuleCreate(void);
BINARYEN_API void BinaryenModuleDispose(BinaryenModuleRef module);

// Function types

typedef void* BinaryenFunctionTypeRef;

// Add a new function type. This is thread-safe.
// Note: name can be NULL, in which case we auto-generate a name
BINARYEN_API BinaryenFunctionTypeRef
BinaryenAddFunctionType(BinaryenModuleRef module,
                        const char* name,
                        BinaryenType result,
                        BinaryenType* paramTypes,
                        BinaryenIndex numParams);
// Removes a function type.
BINARYEN_API void BinaryenRemoveFunctionType(BinaryenModuleRef module,
                                             const char* name);

// Literals. These are passed by value.

struct BinaryenLiteral {
  int32_t type;
  union {
    int32_t i32;
    int64_t i64;
    float f32;
    double f64;
    uint8_t v128[16];
  };
};

BINARYEN_API struct BinaryenLiteral BinaryenLiteralInt32(int32_t x);
BINARYEN_API struct BinaryenLiteral BinaryenLiteralInt64(int64_t x);
BINARYEN_API struct BinaryenLiteral BinaryenLiteralFloat32(float x);
BINARYEN_API struct BinaryenLiteral BinaryenLiteralFloat64(double x);
BINARYEN_API struct BinaryenLiteral BinaryenLiteralVec128(const uint8_t x[16]);
BINARYEN_API struct BinaryenLiteral BinaryenLiteralFloat32Bits(int32_t x);
BINARYEN_API struct BinaryenLiteral BinaryenLiteralFloat64Bits(int64_t x);

// Expressions
//
// Some expressions have a BinaryenOp, which is the more
// specific operation/opcode.
//
// Some expressions have optional parameters, like Return may not
// return a value. You can supply a NULL pointer in those cases.
//
// For more information, see wasm.h

typedef int32_t BinaryenOp;

BINARYEN_API BinaryenOp BinaryenClzInt32(void);
BINARYEN_API BinaryenOp BinaryenCtzInt32(void);
BINARYEN_API BinaryenOp BinaryenPopcntInt32(void);
BINARYEN_API BinaryenOp BinaryenNegFloat32(void);
BINARYEN_API BinaryenOp BinaryenAbsFloat32(void);
BINARYEN_API BinaryenOp BinaryenCeilFloat32(void);
BINARYEN_API BinaryenOp BinaryenFloorFloat32(void);
BINARYEN_API BinaryenOp BinaryenTruncFloat32(void);
BINARYEN_API BinaryenOp BinaryenNearestFloat32(void);
BINARYEN_API BinaryenOp BinaryenSqrtFloat32(void);
BINARYEN_API BinaryenOp BinaryenEqZInt32(void);
BINARYEN_API BinaryenOp BinaryenClzInt64(void);
BINARYEN_API BinaryenOp BinaryenCtzInt64(void);
BINARYEN_API BinaryenOp BinaryenPopcntInt64(void);
BINARYEN_API BinaryenOp BinaryenNegFloat64(void);
BINARYEN_API BinaryenOp BinaryenAbsFloat64(void);
BINARYEN_API BinaryenOp BinaryenCeilFloat64(void);
BINARYEN_API BinaryenOp BinaryenFloorFloat64(void);
BINARYEN_API BinaryenOp BinaryenTruncFloat64(void);
BINARYEN_API BinaryenOp BinaryenNearestFloat64(void);
BINARYEN_API BinaryenOp BinaryenSqrtFloat64(void);
BINARYEN_API BinaryenOp BinaryenEqZInt64(void);
BINARYEN_API BinaryenOp BinaryenExtendSInt32(void);
BINARYEN_API BinaryenOp BinaryenExtendUInt32(void);
BINARYEN_API BinaryenOp BinaryenWrapInt64(void);
BINARYEN_API BinaryenOp BinaryenTruncSFloat32ToInt32(void);
BINARYEN_API BinaryenOp BinaryenTruncSFloat32ToInt64(void);
BINARYEN_API BinaryenOp BinaryenTruncUFloat32ToInt32(void);
BINARYEN_API BinaryenOp BinaryenTruncUFloat32ToInt64(void);
BINARYEN_API BinaryenOp BinaryenTruncSFloat64ToInt32(void);
BINARYEN_API BinaryenOp BinaryenTruncSFloat64ToInt64(void);
BINARYEN_API BinaryenOp BinaryenTruncUFloat64ToInt32(void);
BINARYEN_API BinaryenOp BinaryenTruncUFloat64ToInt64(void);
BINARYEN_API BinaryenOp BinaryenReinterpretFloat32(void);
BINARYEN_API BinaryenOp BinaryenReinterpretFloat64(void);
BINARYEN_API BinaryenOp BinaryenConvertSInt32ToFloat32(void);
BINARYEN_API BinaryenOp BinaryenConvertSInt32ToFloat64(void);
BINARYEN_API BinaryenOp BinaryenConvertUInt32ToFloat32(void);
BINARYEN_API BinaryenOp BinaryenConvertUInt32ToFloat64(void);
BINARYEN_API BinaryenOp BinaryenConvertSInt64ToFloat32(void);
BINARYEN_API BinaryenOp BinaryenConvertSInt64ToFloat64(void);
BINARYEN_API BinaryenOp BinaryenConvertUInt64ToFloat32(void);
BINARYEN_API BinaryenOp BinaryenConvertUInt64ToFloat64(void);
BINARYEN_API BinaryenOp BinaryenPromoteFloat32(void);
BINARYEN_API BinaryenOp BinaryenDemoteFloat64(void);
BINARYEN_API BinaryenOp BinaryenReinterpretInt32(void);
BINARYEN_API BinaryenOp BinaryenReinterpretInt64(void);
BINARYEN_API BinaryenOp BinaryenExtendS8Int32(void);
BINARYEN_API BinaryenOp BinaryenExtendS16Int32(void);
BINARYEN_API BinaryenOp BinaryenExtendS8Int64(void);
BINARYEN_API BinaryenOp BinaryenExtendS16Int64(void);
BINARYEN_API BinaryenOp BinaryenExtendS32Int64(void);
BINARYEN_API BinaryenOp BinaryenAddInt32(void);
BINARYEN_API BinaryenOp BinaryenSubInt32(void);
BINARYEN_API BinaryenOp BinaryenMulInt32(void);
BINARYEN_API BinaryenOp BinaryenDivSInt32(void);
BINARYEN_API BinaryenOp BinaryenDivUInt32(void);
BINARYEN_API BinaryenOp BinaryenRemSInt32(void);
BINARYEN_API BinaryenOp BinaryenRemUInt32(void);
BINARYEN_API BinaryenOp BinaryenAndInt32(void);
BINARYEN_API BinaryenOp BinaryenOrInt32(void);
BINARYEN_API BinaryenOp BinaryenXorInt32(void);
BINARYEN_API BinaryenOp BinaryenShlInt32(void);
BINARYEN_API BinaryenOp BinaryenShrUInt32(void);
BINARYEN_API BinaryenOp BinaryenShrSInt32(void);
BINARYEN_API BinaryenOp BinaryenRotLInt32(void);
BINARYEN_API BinaryenOp BinaryenRotRInt32(void);
BINARYEN_API BinaryenOp BinaryenEqInt32(void);
BINARYEN_API BinaryenOp BinaryenNeInt32(void);
BINARYEN_API BinaryenOp BinaryenLtSInt32(void);
BINARYEN_API BinaryenOp BinaryenLtUInt32(void);
BINARYEN_API BinaryenOp BinaryenLeSInt32(void);
BINARYEN_API BinaryenOp BinaryenLeUInt32(void);
BINARYEN_API BinaryenOp BinaryenGtSInt32(void);
BINARYEN_API BinaryenOp BinaryenGtUInt32(void);
BINARYEN_API BinaryenOp BinaryenGeSInt32(void);
BINARYEN_API BinaryenOp BinaryenGeUInt32(void);
BINARYEN_API BinaryenOp BinaryenAddInt64(void);
BINARYEN_API BinaryenOp BinaryenSubInt64(void);
BINARYEN_API BinaryenOp BinaryenMulInt64(void);
BINARYEN_API BinaryenOp BinaryenDivSInt64(void);
BINARYEN_API BinaryenOp BinaryenDivUInt64(void);
BINARYEN_API BinaryenOp BinaryenRemSInt64(void);
BINARYEN_API BinaryenOp BinaryenRemUInt64(void);
BINARYEN_API BinaryenOp BinaryenAndInt64(void);
BINARYEN_API BinaryenOp BinaryenOrInt64(void);
BINARYEN_API BinaryenOp BinaryenXorInt64(void);
BINARYEN_API BinaryenOp BinaryenShlInt64(void);
BINARYEN_API BinaryenOp BinaryenShrUInt64(void);
BINARYEN_API BinaryenOp BinaryenShrSInt64(void);
BINARYEN_API BinaryenOp BinaryenRotLInt64(void);
BINARYEN_API BinaryenOp BinaryenRotRInt64(void);
BINARYEN_API BinaryenOp BinaryenEqInt64(void);
BINARYEN_API BinaryenOp BinaryenNeInt64(void);
BINARYEN_API BinaryenOp BinaryenLtSInt64(void);
BINARYEN_API BinaryenOp BinaryenLtUInt64(void);
BINARYEN_API BinaryenOp BinaryenLeSInt64(void);
BINARYEN_API BinaryenOp BinaryenLeUInt64(void);
BINARYEN_API BinaryenOp BinaryenGtSInt64(void);
BINARYEN_API BinaryenOp BinaryenGtUInt64(void);
BINARYEN_API BinaryenOp BinaryenGeSInt64(void);
BINARYEN_API BinaryenOp BinaryenGeUInt64(void);
BINARYEN_API BinaryenOp BinaryenAddFloat32(void);
BINARYEN_API BinaryenOp BinaryenSubFloat32(void);
BINARYEN_API BinaryenOp BinaryenMulFloat32(void);
BINARYEN_API BinaryenOp BinaryenDivFloat32(void);
BINARYEN_API BinaryenOp BinaryenCopySignFloat32(void);
BINARYEN_API BinaryenOp BinaryenMinFloat32(void);
BINARYEN_API BinaryenOp BinaryenMaxFloat32(void);
BINARYEN_API BinaryenOp BinaryenEqFloat32(void);
BINARYEN_API BinaryenOp BinaryenNeFloat32(void);
BINARYEN_API BinaryenOp BinaryenLtFloat32(void);
BINARYEN_API BinaryenOp BinaryenLeFloat32(void);
BINARYEN_API BinaryenOp BinaryenGtFloat32(void);
BINARYEN_API BinaryenOp BinaryenGeFloat32(void);
BINARYEN_API BinaryenOp BinaryenAddFloat64(void);
BINARYEN_API BinaryenOp BinaryenSubFloat64(void);
BINARYEN_API BinaryenOp BinaryenMulFloat64(void);
BINARYEN_API BinaryenOp BinaryenDivFloat64(void);
BINARYEN_API BinaryenOp BinaryenCopySignFloat64(void);
BINARYEN_API BinaryenOp BinaryenMinFloat64(void);
BINARYEN_API BinaryenOp BinaryenMaxFloat64(void);
BINARYEN_API BinaryenOp BinaryenEqFloat64(void);
BINARYEN_API BinaryenOp BinaryenNeFloat64(void);
BINARYEN_API BinaryenOp BinaryenLtFloat64(void);
BINARYEN_API BinaryenOp BinaryenLeFloat64(void);
BINARYEN_API BinaryenOp BinaryenGtFloat64(void);
BINARYEN_API BinaryenOp BinaryenGeFloat64(void);
BINARYEN_API BinaryenOp BinaryenMemorySize(void);
BINARYEN_API BinaryenOp BinaryenMemoryGrow(void);
BINARYEN_API BinaryenOp BinaryenAtomicRMWAdd(void);
BINARYEN_API BinaryenOp BinaryenAtomicRMWSub(void);
BINARYEN_API BinaryenOp BinaryenAtomicRMWAnd(void);
BINARYEN_API BinaryenOp BinaryenAtomicRMWOr(void);
BINARYEN_API BinaryenOp BinaryenAtomicRMWXor(void);
BINARYEN_API BinaryenOp BinaryenAtomicRMWXchg(void);
BINARYEN_API BinaryenOp BinaryenTruncSatSFloat32ToInt32(void);
BINARYEN_API BinaryenOp BinaryenTruncSatSFloat32ToInt64(void);
BINARYEN_API BinaryenOp BinaryenTruncSatUFloat32ToInt32(void);
BINARYEN_API BinaryenOp BinaryenTruncSatUFloat32ToInt64(void);
BINARYEN_API BinaryenOp BinaryenTruncSatSFloat64ToInt32(void);
BINARYEN_API BinaryenOp BinaryenTruncSatSFloat64ToInt64(void);
BINARYEN_API BinaryenOp BinaryenTruncSatUFloat64ToInt32(void);
BINARYEN_API BinaryenOp BinaryenTruncSatUFloat64ToInt64(void);
BINARYEN_API BinaryenOp BinaryenSplatVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenExtractLaneSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenExtractLaneUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenSplatVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenExtractLaneSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenExtractLaneUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenSplatVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenExtractLaneVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenSplatVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenExtractLaneVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenSplatVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenExtractLaneVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenSplatVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenExtractLaneVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenEqVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenNeVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenLtSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenLtUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenGtSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenGtUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenLeSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenLeUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenGeSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenGeUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenEqVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenNeVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenLtSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenLtUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenGtSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenGtUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenLeSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenLeUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenGeSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenGeUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenEqVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenNeVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenLtSVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenLtUVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenGtSVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenGtUVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenLeSVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenLeUVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenGeSVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenGeUVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenEqVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenNeVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenLtVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenGtVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenLeVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenGeVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenEqVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenNeVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenLtVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenGtVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenLeVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenGeVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenNotVec128(void);
BINARYEN_API BinaryenOp BinaryenAndVec128(void);
BINARYEN_API BinaryenOp BinaryenOrVec128(void);
BINARYEN_API BinaryenOp BinaryenXorVec128(void);
BINARYEN_API BinaryenOp BinaryenAndNotVec128(void);
BINARYEN_API BinaryenOp BinaryenBitselectVec128(void);
BINARYEN_API BinaryenOp BinaryenNegVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenAnyTrueVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenAllTrueVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenShlVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenShrSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenShrUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenAddVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenAddSatSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenAddSatUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenSubVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenSubSatSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenSubSatUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenMulVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenMinSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenMinUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenMaxSVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenMaxUVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenNegVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenAnyTrueVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenAllTrueVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenShlVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenShrSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenShrUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenAddVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenAddSatSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenAddSatUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenSubVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenSubSatSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenSubSatUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenMulVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenMinSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenMinUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenMaxSVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenMaxUVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenNegVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenAnyTrueVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenAllTrueVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenShlVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenShrSVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenShrUVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenAddVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenSubVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenMulVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenMinSVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenMinUVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenMaxSVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenMaxUVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenDotSVecI16x8ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenNegVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenAnyTrueVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenAllTrueVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenShlVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenShrSVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenShrUVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenAddVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenSubVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenAbsVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenNegVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenSqrtVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenQFMAVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenQFMSVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenAddVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenSubVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenMulVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenDivVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenMinVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenMaxVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenAbsVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenNegVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenSqrtVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenQFMAVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenQFMSVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenAddVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenSubVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenMulVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenDivVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenMinVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenMaxVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenTruncSatSVecF32x4ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenTruncSatUVecF32x4ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenTruncSatSVecF64x2ToVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenTruncSatUVecF64x2ToVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenConvertSVecI32x4ToVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenConvertUVecI32x4ToVecF32x4(void);
BINARYEN_API BinaryenOp BinaryenConvertSVecI64x2ToVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenConvertUVecI64x2ToVecF64x2(void);
BINARYEN_API BinaryenOp BinaryenLoadSplatVec8x16(void);
BINARYEN_API BinaryenOp BinaryenLoadSplatVec16x8(void);
BINARYEN_API BinaryenOp BinaryenLoadSplatVec32x4(void);
BINARYEN_API BinaryenOp BinaryenLoadSplatVec64x2(void);
BINARYEN_API BinaryenOp BinaryenLoadExtSVec8x8ToVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenLoadExtUVec8x8ToVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenLoadExtSVec16x4ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenLoadExtUVec16x4ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenLoadExtSVec32x2ToVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenLoadExtUVec32x2ToVecI64x2(void);
BINARYEN_API BinaryenOp BinaryenNarrowSVecI16x8ToVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenNarrowUVecI16x8ToVecI8x16(void);
BINARYEN_API BinaryenOp BinaryenNarrowSVecI32x4ToVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenNarrowUVecI32x4ToVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenWidenLowSVecI8x16ToVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenWidenHighSVecI8x16ToVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenWidenLowUVecI8x16ToVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenWidenHighUVecI8x16ToVecI16x8(void);
BINARYEN_API BinaryenOp BinaryenWidenLowSVecI16x8ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenWidenHighSVecI16x8ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenWidenLowUVecI16x8ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenWidenHighUVecI16x8ToVecI32x4(void);
BINARYEN_API BinaryenOp BinaryenSwizzleVec8x16(void);

typedef void* BinaryenExpressionRef;

// Block: name can be NULL. Specifying BinaryenUndefined() as the 'type'
//        parameter indicates that the block's type shall be figured out
//        automatically instead of explicitly providing it. This conforms
//        to the behavior before the 'type' parameter has been introduced.
BINARYEN_API BinaryenExpressionRef
BinaryenBlock(BinaryenModuleRef module,
              const char* name,
              BinaryenExpressionRef* children,
              BinaryenIndex numChildren,
              BinaryenType type);
// If: ifFalse can be NULL
BINARYEN_API BinaryenExpressionRef BinaryenIf(BinaryenModuleRef module,
                                              BinaryenExpressionRef condition,
                                              BinaryenExpressionRef ifTrue,
                                              BinaryenExpressionRef ifFalse);
BINARYEN_API BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module,
                                                const char* in,
                                                BinaryenExpressionRef body);
// Break: value and condition can be NULL
BINARYEN_API BinaryenExpressionRef
BinaryenBreak(BinaryenModuleRef module,
              const char* name,
              BinaryenExpressionRef condition,
              BinaryenExpressionRef value);
// Switch: value can be NULL
BINARYEN_API BinaryenExpressionRef
BinaryenSwitch(BinaryenModuleRef module,
               const char** names,
               BinaryenIndex numNames,
               const char* defaultName,
               BinaryenExpressionRef condition,
               BinaryenExpressionRef value);
// Call: Note the 'returnType' parameter. You must declare the
//       type returned by the function being called, as that
//       function might not have been created yet, so we don't
//       know what it is.
BINARYEN_API BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module,
                                                const char* target,
                                                BinaryenExpressionRef* operands,
                                                BinaryenIndex numOperands,
                                                BinaryenType returnType);
BINARYEN_API BinaryenExpressionRef
BinaryenCallIndirect(BinaryenModuleRef module,
                     BinaryenExpressionRef target,
                     BinaryenExpressionRef* operands,
                     BinaryenIndex numOperands,
                     const char* type);
BINARYEN_API BinaryenExpressionRef
BinaryenReturnCall(BinaryenModuleRef module,
                   const char* target,
                   BinaryenExpressionRef* operands,
                   BinaryenIndex numOperands,
                   BinaryenType returnType);
BINARYEN_API BinaryenExpressionRef
BinaryenReturnCallIndirect(BinaryenModuleRef module,
                           BinaryenExpressionRef target,
                           BinaryenExpressionRef* operands,
                           BinaryenIndex numOperands,
                           const char* type);

// LocalGet: Note the 'type' parameter. It might seem redundant, since the
//           local at that index must have a type. However, this API lets you
//           build code "top-down": create a node, then its parents, and so
//           on, and finally create the function at the end. (Note that in fact
//           you do not mention a function when creating ExpressionRefs, only
//           a module.) And since LocalGet is a leaf node, we need to be told
//           its type. (Other nodes detect their type either from their
//           type or their opcode, or failing that, their children. But
//           LocalGet has no children, it is where a "stream" of type info
//           begins.)
//           Note also that the index of a local can refer to a param or
//           a var, that is, either a parameter to the function or a variable
//           declared when you call BinaryenAddFunction. See BinaryenAddFunction
//           for more details.
BINARYEN_API BinaryenExpressionRef BinaryenLocalGet(BinaryenModuleRef module,
                                                    BinaryenIndex index,
                                                    BinaryenType type);
BINARYEN_API BinaryenExpressionRef BinaryenLocalSet(
  BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value);
BINARYEN_API BinaryenExpressionRef BinaryenLocalTee(
  BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value);
BINARYEN_API BinaryenExpressionRef BinaryenGlobalGet(BinaryenModuleRef module,
                                                     const char* name,
                                                     BinaryenType type);
BINARYEN_API BinaryenExpressionRef BinaryenGlobalSet(
  BinaryenModuleRef module, const char* name, BinaryenExpressionRef value);
// Load: align can be 0, in which case it will be the natural alignment (equal
// to bytes)
BINARYEN_API BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module,
                                                uint32_t bytes,
                                                int8_t signed_,
                                                uint32_t offset,
                                                uint32_t align,
                                                BinaryenType type,
                                                BinaryenExpressionRef ptr);
// Store: align can be 0, in which case it will be the natural alignment (equal
// to bytes)
BINARYEN_API BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module,
                                                 uint32_t bytes,
                                                 uint32_t offset,
                                                 uint32_t align,
                                                 BinaryenExpressionRef ptr,
                                                 BinaryenExpressionRef value,
                                                 BinaryenType type);
BINARYEN_API BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module,
                                                 struct BinaryenLiteral value);
BINARYEN_API BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module,
                                                 BinaryenOp op,
                                                 BinaryenExpressionRef value);
BINARYEN_API BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module,
                                                  BinaryenOp op,
                                                  BinaryenExpressionRef left,
                                                  BinaryenExpressionRef right);
BINARYEN_API BinaryenExpressionRef
BinaryenSelect(BinaryenModuleRef module,
               BinaryenExpressionRef condition,
               BinaryenExpressionRef ifTrue,
               BinaryenExpressionRef ifFalse);
BINARYEN_API BinaryenExpressionRef BinaryenDrop(BinaryenModuleRef module,
                                                BinaryenExpressionRef value);
// Return: value can be NULL
BINARYEN_API BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module,
                                                  BinaryenExpressionRef value);
// Host: name may be NULL
BINARYEN_API BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module,
                                                BinaryenOp op,
                                                const char* name,
                                                BinaryenExpressionRef* operands,
                                                BinaryenIndex numOperands);
BINARYEN_API BinaryenExpressionRef BinaryenNop(BinaryenModuleRef module);
BINARYEN_API BinaryenExpressionRef
BinaryenUnreachable(BinaryenModuleRef module);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicLoad(BinaryenModuleRef module,
                   uint32_t bytes,
                   uint32_t offset,
                   BinaryenType type,
                   BinaryenExpressionRef ptr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicStore(BinaryenModuleRef module,
                    uint32_t bytes,
                    uint32_t offset,
                    BinaryenExpressionRef ptr,
                    BinaryenExpressionRef value,
                    BinaryenType type);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicRMW(BinaryenModuleRef module,
                  BinaryenOp op,
                  BinaryenIndex bytes,
                  BinaryenIndex offset,
                  BinaryenExpressionRef ptr,
                  BinaryenExpressionRef value,
                  BinaryenType type);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicCmpxchg(BinaryenModuleRef module,
                      BinaryenIndex bytes,
                      BinaryenIndex offset,
                      BinaryenExpressionRef ptr,
                      BinaryenExpressionRef expected,
                      BinaryenExpressionRef replacement,
                      BinaryenType type);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicWait(BinaryenModuleRef module,
                   BinaryenExpressionRef ptr,
                   BinaryenExpressionRef expected,
                   BinaryenExpressionRef timeout,
                   BinaryenType type);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicNotify(BinaryenModuleRef module,
                     BinaryenExpressionRef ptr,
                     BinaryenExpressionRef notifyCount);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicFence(BinaryenModuleRef module);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDExtract(BinaryenModuleRef module,
                    BinaryenOp op,
                    BinaryenExpressionRef vec,
                    uint8_t index);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDReplace(BinaryenModuleRef module,
                    BinaryenOp op,
                    BinaryenExpressionRef vec,
                    uint8_t index,
                    BinaryenExpressionRef value);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShuffle(BinaryenModuleRef module,
                    BinaryenExpressionRef left,
                    BinaryenExpressionRef right,
                    const uint8_t mask[16]);
BINARYEN_API BinaryenExpressionRef BinaryenSIMDTernary(BinaryenModuleRef module,
                                                       BinaryenOp op,
                                                       BinaryenExpressionRef a,
                                                       BinaryenExpressionRef b,
                                                       BinaryenExpressionRef c);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShift(BinaryenModuleRef module,
                  BinaryenOp op,
                  BinaryenExpressionRef vec,
                  BinaryenExpressionRef shift);
BINARYEN_API BinaryenExpressionRef BinaryenSIMDLoad(BinaryenModuleRef module,
                                                    BinaryenOp op,
                                                    uint32_t offset,
                                                    uint32_t align,
                                                    BinaryenExpressionRef ptr);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryInit(BinaryenModuleRef module,
                   uint32_t segment,
                   BinaryenExpressionRef dest,
                   BinaryenExpressionRef offset,
                   BinaryenExpressionRef size);
BINARYEN_API BinaryenExpressionRef BinaryenDataDrop(BinaryenModuleRef module,
                                                    uint32_t segment);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryCopy(BinaryenModuleRef module,
                   BinaryenExpressionRef dest,
                   BinaryenExpressionRef source,
                   BinaryenExpressionRef size);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryFill(BinaryenModuleRef module,
                   BinaryenExpressionRef dest,
                   BinaryenExpressionRef value,
                   BinaryenExpressionRef size);
BINARYEN_API BinaryenExpressionRef BinaryenTry(BinaryenModuleRef module,
                                               BinaryenExpressionRef body,
                                               BinaryenExpressionRef catchBody);
BINARYEN_API BinaryenExpressionRef
BinaryenThrow(BinaryenModuleRef module,
              const char* event,
              BinaryenExpressionRef* operands,
              BinaryenIndex numOperands);
BINARYEN_API BinaryenExpressionRef
BinaryenRethrow(BinaryenModuleRef module, BinaryenExpressionRef exnref);
BINARYEN_API BinaryenExpressionRef
BinaryenBrOnExn(BinaryenModuleRef module,
                const char* name,
                const char* eventName,
                BinaryenExpressionRef exnref);
BINARYEN_API BinaryenExpressionRef BinaryenPush(BinaryenModuleRef module,
                                                BinaryenExpressionRef value);
BINARYEN_API BinaryenExpressionRef BinaryenPop(BinaryenModuleRef module,
                                               BinaryenType type);

BINARYEN_API BinaryenExpressionId
BinaryenExpressionGetId(BinaryenExpressionRef expr);
BINARYEN_API BinaryenType BinaryenExpressionGetType(BinaryenExpressionRef expr);
BINARYEN_API void BinaryenExpressionPrint(BinaryenExpressionRef expr);

BINARYEN_API const char* BinaryenBlockGetName(BinaryenExpressionRef expr);
BINARYEN_API BinaryenIndex
BinaryenBlockGetNumChildren(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenBlockGetChild(BinaryenExpressionRef expr, BinaryenIndex index);

BINARYEN_API BinaryenExpressionRef
BinaryenIfGetCondition(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenIfGetIfTrue(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenIfGetIfFalse(BinaryenExpressionRef expr);

BINARYEN_API const char* BinaryenLoopGetName(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenLoopGetBody(BinaryenExpressionRef expr);

BINARYEN_API const char* BinaryenBreakGetName(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenBreakGetCondition(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenBreakGetValue(BinaryenExpressionRef expr);

BINARYEN_API BinaryenIndex
BinaryenSwitchGetNumNames(BinaryenExpressionRef expr);
BINARYEN_API const char* BinaryenSwitchGetName(BinaryenExpressionRef expr,
                                               BinaryenIndex index);
BINARYEN_API const char*
BinaryenSwitchGetDefaultName(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSwitchGetCondition(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSwitchGetValue(BinaryenExpressionRef expr);

BINARYEN_API const char* BinaryenCallGetTarget(BinaryenExpressionRef expr);
BINARYEN_API BinaryenIndex
BinaryenCallGetNumOperands(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenCallGetOperand(BinaryenExpressionRef expr, BinaryenIndex index);

BINARYEN_API BinaryenExpressionRef
BinaryenCallIndirectGetTarget(BinaryenExpressionRef expr);
BINARYEN_API BinaryenIndex
BinaryenCallIndirectGetNumOperands(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenCallIndirectGetOperand(BinaryenExpressionRef expr, BinaryenIndex index);

BINARYEN_API BinaryenIndex BinaryenLocalGetGetIndex(BinaryenExpressionRef expr);

BINARYEN_API int BinaryenLocalSetIsTee(BinaryenExpressionRef expr);
BINARYEN_API BinaryenIndex BinaryenLocalSetGetIndex(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenLocalSetGetValue(BinaryenExpressionRef expr);

BINARYEN_API const char* BinaryenGlobalGetGetName(BinaryenExpressionRef expr);

BINARYEN_API const char* BinaryenGlobalSetGetName(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenGlobalSetGetValue(BinaryenExpressionRef expr);

BINARYEN_API BinaryenOp BinaryenHostGetOp(BinaryenExpressionRef expr);
BINARYEN_API const char* BinaryenHostGetNameOperand(BinaryenExpressionRef expr);
BINARYEN_API BinaryenIndex
BinaryenHostGetNumOperands(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenHostGetOperand(BinaryenExpressionRef expr, BinaryenIndex index);

BINARYEN_API int BinaryenLoadIsAtomic(BinaryenExpressionRef expr);
BINARYEN_API int BinaryenLoadIsSigned(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenLoadGetOffset(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenLoadGetBytes(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenLoadGetAlign(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenLoadGetPtr(BinaryenExpressionRef expr);

BINARYEN_API int BinaryenStoreIsAtomic(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenStoreGetBytes(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenStoreGetOffset(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenStoreGetAlign(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenStoreGetPtr(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenStoreGetValue(BinaryenExpressionRef expr);

BINARYEN_API int32_t BinaryenConstGetValueI32(BinaryenExpressionRef expr);
BINARYEN_API int64_t BinaryenConstGetValueI64(BinaryenExpressionRef expr);
BINARYEN_API int32_t BinaryenConstGetValueI64Low(BinaryenExpressionRef expr);
BINARYEN_API int32_t BinaryenConstGetValueI64High(BinaryenExpressionRef expr);
BINARYEN_API float BinaryenConstGetValueF32(BinaryenExpressionRef expr);
BINARYEN_API double BinaryenConstGetValueF64(BinaryenExpressionRef expr);
BINARYEN_API void BinaryenConstGetValueV128(BinaryenExpressionRef expr,
                                            uint8_t* out);

BINARYEN_API BinaryenOp BinaryenUnaryGetOp(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenUnaryGetValue(BinaryenExpressionRef expr);

BINARYEN_API BinaryenOp BinaryenBinaryGetOp(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenBinaryGetLeft(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenBinaryGetRight(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenSelectGetIfTrue(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSelectGetIfFalse(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSelectGetCondition(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenDropGetValue(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenReturnGetValue(BinaryenExpressionRef expr);

BINARYEN_API BinaryenOp BinaryenAtomicRMWGetOp(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenAtomicRMWGetBytes(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenAtomicRMWGetOffset(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicRMWGetPtr(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicRMWGetValue(BinaryenExpressionRef expr);

BINARYEN_API uint32_t BinaryenAtomicCmpxchgGetBytes(BinaryenExpressionRef expr);
BINARYEN_API uint32_t
BinaryenAtomicCmpxchgGetOffset(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicCmpxchgGetPtr(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicCmpxchgGetExpected(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicCmpxchgGetReplacement(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenAtomicWaitGetPtr(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicWaitGetExpected(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicWaitGetTimeout(BinaryenExpressionRef expr);
BINARYEN_API BinaryenType
BinaryenAtomicWaitGetExpectedType(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenAtomicNotifyGetPtr(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicNotifyGetNotifyCount(BinaryenExpressionRef expr);

BINARYEN_API uint8_t BinaryenAtomicFenceGetOrder(BinaryenExpressionRef expr);

BINARYEN_API BinaryenOp BinaryenSIMDExtractGetOp(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDExtractGetVec(BinaryenExpressionRef expr);
BINARYEN_API uint8_t BinaryenSIMDExtractGetIndex(BinaryenExpressionRef expr);

BINARYEN_API BinaryenOp BinaryenSIMDReplaceGetOp(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDReplaceGetVec(BinaryenExpressionRef expr);
BINARYEN_API uint8_t BinaryenSIMDReplaceGetIndex(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDReplaceGetValue(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShuffleGetLeft(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShuffleGetRight(BinaryenExpressionRef expr);
BINARYEN_API void BinaryenSIMDShuffleGetMask(BinaryenExpressionRef expr,
                                             uint8_t* mask);

BINARYEN_API BinaryenOp BinaryenSIMDTernaryGetOp(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDTernaryGetA(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDTernaryGetB(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDTernaryGetC(BinaryenExpressionRef expr);

BINARYEN_API BinaryenOp BinaryenSIMDShiftGetOp(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShiftGetVec(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShiftGetShift(BinaryenExpressionRef expr);

BINARYEN_API BinaryenOp BinaryenSIMDLoadGetOp(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenSIMDLoadGetOffset(BinaryenExpressionRef expr);
BINARYEN_API uint32_t BinaryenSIMDLoadGetAlign(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDLoadGetPtr(BinaryenExpressionRef expr);

BINARYEN_API uint32_t BinaryenMemoryInitGetSegment(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryInitGetDest(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryInitGetOffset(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryInitGetSize(BinaryenExpressionRef expr);

BINARYEN_API uint32_t BinaryenDataDropGetSegment(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenMemoryCopyGetDest(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryCopyGetSource(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryCopyGetSize(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenMemoryFillGetDest(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryFillGetValue(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryFillGetSize(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenTryGetBody(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenTryGetCatchBody(BinaryenExpressionRef expr);

BINARYEN_API const char* BinaryenThrowGetEvent(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenThrowGetOperand(BinaryenExpressionRef expr, BinaryenIndex index);
BINARYEN_API BinaryenIndex
BinaryenThrowGetNumOperands(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenRethrowGetExnref(BinaryenExpressionRef expr);

BINARYEN_API const char* BinaryenBrOnExnGetEvent(BinaryenExpressionRef expr);
BINARYEN_API const char* BinaryenBrOnExnGetName(BinaryenExpressionRef expr);
BINARYEN_API BinaryenExpressionRef
BinaryenBrOnExnGetExnref(BinaryenExpressionRef expr);

BINARYEN_API BinaryenExpressionRef
BinaryenPushGetValue(BinaryenExpressionRef expr);

// Functions

typedef void* BinaryenFunctionRef;

// Adds a function to the module. This is thread-safe.
// @varTypes: the types of variables. In WebAssembly, vars share
//            an index space with params. In other words, params come from
//            the function type, and vars are provided in this call, and
//            together they are all the locals. The order is first params
//            and then vars, so if you have one param it will be at index
//            0 (and written $0), and if you also have 2 vars they will be
//            at indexes 1 and 2, etc., that is, they share an index space.
BINARYEN_API BinaryenFunctionRef
BinaryenAddFunction(BinaryenModuleRef module,
                    const char* name,
                    BinaryenFunctionTypeRef type,
                    BinaryenType* varTypes,
                    BinaryenIndex numVarTypes,
                    BinaryenExpressionRef body);
// Gets a function reference by name.
BINARYEN_API BinaryenFunctionRef BinaryenGetFunction(BinaryenModuleRef module,
                                                     const char* name);
// Removes a function by name.
BINARYEN_API void BinaryenRemoveFunction(BinaryenModuleRef module,
                                         const char* name);

// Gets the number of functions in the module.
BINARYEN_API uint32_t BinaryenGetNumFunctions(BinaryenModuleRef module);
// Get function pointer from its index.
BINARYEN_API BinaryenFunctionRef
BinaryenGetFunctionByIndex(BinaryenModuleRef module, BinaryenIndex id);

// Imports

BINARYEN_API void
BinaryenAddFunctionImport(BinaryenModuleRef module,
                          const char* internalName,
                          const char* externalModuleName,
                          const char* externalBaseName,
                          BinaryenFunctionTypeRef functionType);
BINARYEN_API void BinaryenAddTableImport(BinaryenModuleRef module,
                                         const char* internalName,
                                         const char* externalModuleName,
                                         const char* externalBaseName);
BINARYEN_API void BinaryenAddMemoryImport(BinaryenModuleRef module,
                                          const char* internalName,
                                          const char* externalModuleName,
                                          const char* externalBaseName,
                                          uint8_t shared);
BINARYEN_API void BinaryenAddGlobalImport(BinaryenModuleRef module,
                                          const char* internalName,
                                          const char* externalModuleName,
                                          const char* externalBaseName,
                                          BinaryenType globalType,
                                          int mutable_);
BINARYEN_API void BinaryenAddEventImport(BinaryenModuleRef module,
                                         const char* internalName,
                                         const char* externalModuleName,
                                         const char* externalBaseName,
                                         uint32_t attribute,
                                         BinaryenFunctionTypeRef eventType);

// Exports

typedef void* BinaryenExportRef;

WASM_DEPRECATED BinaryenExportRef BinaryenAddExport(BinaryenModuleRef module,
                                                    const char* internalName,
                                                    const char* externalName);
BINARYEN_API BinaryenExportRef BinaryenAddFunctionExport(
  BinaryenModuleRef module, const char* internalName, const char* externalName);
BINARYEN_API BinaryenExportRef BinaryenAddTableExport(BinaryenModuleRef module,
                                                      const char* internalName,
                                                      const char* externalName);
BINARYEN_API BinaryenExportRef BinaryenAddMemoryExport(
  BinaryenModuleRef module, const char* internalName, const char* externalName);
BINARYEN_API BinaryenExportRef BinaryenAddGlobalExport(
  BinaryenModuleRef module, const char* internalName, const char* externalName);
BINARYEN_API BinaryenExportRef BinaryenAddEventExport(BinaryenModuleRef module,
                                                      const char* internalName,
                                                      const char* externalName);
BINARYEN_API void BinaryenRemoveExport(BinaryenModuleRef module,
                                       const char* externalName);

// Globals

typedef void* BinaryenGlobalRef;

BINARYEN_API BinaryenGlobalRef BinaryenAddGlobal(BinaryenModuleRef module,
                                                 const char* name,
                                                 BinaryenType type,
                                                 int8_t mutable_,
                                                 BinaryenExpressionRef init);
// Gets a global reference by name.
BINARYEN_API BinaryenGlobalRef BinaryenGetGlobal(BinaryenModuleRef module,
                                                 const char* name);
BINARYEN_API void BinaryenRemoveGlobal(BinaryenModuleRef module,
                                       const char* name);

// Events

typedef void* BinaryenEventRef;

BINARYEN_API BinaryenEventRef BinaryenAddEvent(BinaryenModuleRef module,
                                               const char* name,
                                               uint32_t attribute,
                                               BinaryenFunctionTypeRef type);
BINARYEN_API BinaryenEventRef BinaryenGetEvent(BinaryenModuleRef module,
                                               const char* name);
BINARYEN_API void BinaryenRemoveEvent(BinaryenModuleRef module,
                                      const char* name);

// Function table. One per module

BINARYEN_API void BinaryenSetFunctionTable(BinaryenModuleRef module,
                                           BinaryenIndex initial,
                                           BinaryenIndex maximum,
                                           const char** funcNames,
                                           BinaryenIndex numFuncNames,
                                           BinaryenExpressionRef offset);

// Memory. One per module

// Each segment has data in segments, a start offset in segmentOffsets, and a
// size in segmentSizes. exportName can be NULL
BINARYEN_API void BinaryenSetMemory(BinaryenModuleRef module,
                                    BinaryenIndex initial,
                                    BinaryenIndex maximum,
                                    const char* exportName,
                                    const char** segments,
                                    int8_t* segmentPassive,
                                    BinaryenExpressionRef* segmentOffsets,
                                    BinaryenIndex* segmentSizes,
                                    BinaryenIndex numSegments,
                                    uint8_t shared);

// Memory segments. Query utilities.

BINARYEN_API uint32_t BinaryenGetNumMemorySegments(BinaryenModuleRef module);
BINARYEN_API int64_t
BinaryenGetMemorySegmentByteOffset(BinaryenModuleRef module, BinaryenIndex id);
BINARYEN_API size_t BinaryenGetMemorySegmentByteLength(BinaryenModuleRef module,
                                                       BinaryenIndex id);
BINARYEN_API void BinaryenCopyMemorySegmentData(BinaryenModuleRef module,
                                                BinaryenIndex id,
                                                char* buffer);

// Start function. One per module

BINARYEN_API void BinaryenSetStart(BinaryenModuleRef module,
                                   BinaryenFunctionRef start);

// Features

// These control what features are allowed when validation and in passes.
BINARYEN_API BinaryenFeatures
BinaryenModuleGetFeatures(BinaryenModuleRef module);
BINARYEN_API void BinaryenModuleSetFeatures(BinaryenModuleRef module,
                                            BinaryenFeatures features);

//
// ========== Module Operations ==========
//

// Parse a module in s-expression text format
BINARYEN_API BinaryenModuleRef BinaryenModuleParse(const char* text);

// Print a module to stdout in s-expression text format. Useful for debugging.
BINARYEN_API void BinaryenModulePrint(BinaryenModuleRef module);

// Print a module to stdout in asm.js syntax.
BINARYEN_API void BinaryenModulePrintAsmjs(BinaryenModuleRef module);

// Validate a module, showing errors on problems.
//  @return 0 if an error occurred, 1 if validated succesfully
BINARYEN_API int BinaryenModuleValidate(BinaryenModuleRef module);

// Runs the standard optimization passes on the module. Uses the currently set
// global optimize and shrink level.
BINARYEN_API void BinaryenModuleOptimize(BinaryenModuleRef module);

// Gets the currently set optimize level. Applies to all modules, globally.
// 0, 1, 2 correspond to -O0, -O1, -O2 (default), etc.
BINARYEN_API int BinaryenGetOptimizeLevel(void);

// Sets the optimization level to use. Applies to all modules, globally.
// 0, 1, 2 correspond to -O0, -O1, -O2 (default), etc.
BINARYEN_API void BinaryenSetOptimizeLevel(int level);

// Gets the currently set shrink level. Applies to all modules, globally.
// 0, 1, 2 correspond to -O0, -Os (default), -Oz.
BINARYEN_API int BinaryenGetShrinkLevel(void);

// Sets the shrink level to use. Applies to all modules, globally.
// 0, 1, 2 correspond to -O0, -Os (default), -Oz.
BINARYEN_API void BinaryenSetShrinkLevel(int level);

// Gets whether generating debug information is currently enabled or not.
// Applies to all modules, globally.
BINARYEN_API int BinaryenGetDebugInfo(void);

// Enables or disables debug information in emitted binaries.
// Applies to all modules, globally.
BINARYEN_API void BinaryenSetDebugInfo(int on);

// Runs the specified passes on the module. Uses the currently set global
// optimize and shrink level.
BINARYEN_API void BinaryenModuleRunPasses(BinaryenModuleRef module,
                                          const char** passes,
                                          BinaryenIndex numPasses);

// Auto-generate drop() operations where needed. This lets you generate code
// without worrying about where they are needed. (It is more efficient to do it
// yourself, but simpler to use autodrop).
BINARYEN_API void BinaryenModuleAutoDrop(BinaryenModuleRef module);

// Serialize a module into binary form. Uses the currently set global debugInfo
// option.
// @return how many bytes were written. This will be less than or equal to
//         outputSize
size_t BINARYEN_API BinaryenModuleWrite(BinaryenModuleRef module,
                                        char* output,
                                        size_t outputSize);

// Serialize a module in s-expression text format.
// @return how many bytes were written. This will be less than or equal to
//         outputSize
BINARYEN_API size_t BinaryenModuleWriteText(BinaryenModuleRef module,
                                            char* output,
                                            size_t outputSize);

typedef struct BinaryenBufferSizes {
  size_t outputBytes;
  size_t sourceMapBytes;
} BinaryenBufferSizes;

// Serialize a module into binary form including its source map. Uses the
// currently set global debugInfo option.
// @returns how many bytes were written. This will be less than or equal to
//          outputSize
BINARYEN_API BinaryenBufferSizes
BinaryenModuleWriteWithSourceMap(BinaryenModuleRef module,
                                 const char* url,
                                 char* output,
                                 size_t outputSize,
                                 char* sourceMap,
                                 size_t sourceMapSize);

// Result structure of BinaryenModuleAllocateAndWrite. Contained buffers have
// been allocated using malloc() and the user is expected to free() them
// manually once not needed anymore.
typedef struct BinaryenModuleAllocateAndWriteResult {
  void* binary;
  size_t binaryBytes;
  char* sourceMap;
} BinaryenModuleAllocateAndWriteResult;

// Serializes a module into binary form, optionally including its source map if
// sourceMapUrl has been specified. Uses the currently set global debugInfo
// option. Differs from BinaryenModuleWrite in that it implicitly allocates
// appropriate buffers using malloc(), and expects the user to free() them
// manually once not needed anymore.
BINARYEN_API BinaryenModuleAllocateAndWriteResult
BinaryenModuleAllocateAndWrite(BinaryenModuleRef module,
                               const char* sourceMapUrl);

// Serialize a module in s-expression form. Implicity allocates the returned
// char* with malloc(), and expects the user to free() them manually
// once not needed anymore.
BINARYEN_API char* BinaryenModuleAllocateAndWriteText(BinaryenModuleRef module);

// Deserialize a module from binary form.
BINARYEN_API BinaryenModuleRef BinaryenModuleRead(char* input,
                                                  size_t inputSize);

// Execute a module in the Binaryen interpreter. This will create an instance of
// the module, run it in the interpreter - which means running the start method
// - and then destroying the instance.
BINARYEN_API void BinaryenModuleInterpret(BinaryenModuleRef module);

// Adds a debug info file name to the module and returns its index.
BINARYEN_API BinaryenIndex BinaryenModuleAddDebugInfoFileName(
  BinaryenModuleRef module, const char* filename);

// Gets the name of the debug info file at the specified index. Returns `NULL`
// if it does not exist.
BINARYEN_API const char*
BinaryenModuleGetDebugInfoFileName(BinaryenModuleRef module,
                                   BinaryenIndex index);

//
// ======== FunctionType Operations ========
//

// Gets the name of the specified `FunctionType`.
BINARYEN_API const char*
BinaryenFunctionTypeGetName(BinaryenFunctionTypeRef ftype);
// Gets the number of parameters of the specified `FunctionType`.
BINARYEN_API BinaryenIndex
BinaryenFunctionTypeGetNumParams(BinaryenFunctionTypeRef ftype);
// Gets the type of the parameter at the specified index of the specified
// `FunctionType`.
BINARYEN_API BinaryenType BinaryenFunctionTypeGetParam(
  BinaryenFunctionTypeRef ftype, BinaryenIndex index);
// Gets the result type of the specified `FunctionType`.
BINARYEN_API BinaryenType
BinaryenFunctionTypeGetResult(BinaryenFunctionTypeRef ftype);

//
// ========== Function Operations ==========
//

// Gets the name of the specified `Function`.
BINARYEN_API const char* BinaryenFunctionGetName(BinaryenFunctionRef func);
// Gets the name of the `FunctionType` associated with the specified `Function`.
// May be `NULL` if the signature is implicit.
BINARYEN_API const char* BinaryenFunctionGetType(BinaryenFunctionRef func);
// Gets the number of parameters of the specified `Function`.
BINARYEN_API BinaryenIndex
BinaryenFunctionGetNumParams(BinaryenFunctionRef func);
// Gets the type of the parameter at the specified index of the specified
// `Function`.
BINARYEN_API BinaryenType BinaryenFunctionGetParam(BinaryenFunctionRef func,
                                                   BinaryenIndex index);
// Gets the result type of the specified `Function`.
BINARYEN_API BinaryenType BinaryenFunctionGetResult(BinaryenFunctionRef func);
// Gets the number of additional locals within the specified `Function`.
BINARYEN_API BinaryenIndex BinaryenFunctionGetNumVars(BinaryenFunctionRef func);
// Gets the type of the additional local at the specified index within the
// specified `Function`.
BINARYEN_API BinaryenType BinaryenFunctionGetVar(BinaryenFunctionRef func,
                                                 BinaryenIndex index);
// Gets the body of the specified `Function`.
BINARYEN_API BinaryenExpressionRef
BinaryenFunctionGetBody(BinaryenFunctionRef func);

// Runs the standard optimization passes on the function. Uses the currently set
// global optimize and shrink level.
BINARYEN_API void BinaryenFunctionOptimize(BinaryenFunctionRef func,
                                           BinaryenModuleRef module);

// Runs the specified passes on the function. Uses the currently set global
// optimize and shrink level.
BINARYEN_API void BinaryenFunctionRunPasses(BinaryenFunctionRef func,
                                            BinaryenModuleRef module,
                                            const char** passes,
                                            BinaryenIndex numPasses);

// Sets the debug location of the specified `Expression` within the specified
// `Function`.
BINARYEN_API void BinaryenFunctionSetDebugLocation(BinaryenFunctionRef func,
                                                   BinaryenExpressionRef expr,
                                                   BinaryenIndex fileIndex,
                                                   BinaryenIndex lineNumber,
                                                   BinaryenIndex columnNumber);

//
// ========== Global Operations ==========
//

// Gets the name of the specified `Global`.
BINARYEN_API const char* BinaryenGlobalGetName(BinaryenGlobalRef global);
// Gets the name of the `GlobalType` associated with the specified `Global`. May
// be `NULL` if the signature is implicit.
BINARYEN_API BinaryenType BinaryenGlobalGetType(BinaryenGlobalRef global);
// Returns true if the specified `Global` is mutable.
BINARYEN_API int BinaryenGlobalIsMutable(BinaryenGlobalRef global);
// Gets the initialization expression of the specified `Global`.
BINARYEN_API BinaryenExpressionRef
BinaryenGlobalGetInitExpr(BinaryenGlobalRef global);

//
// ========== Event Operations ==========
//

// Gets the name of the specified `Event`.
BINARYEN_API const char* BinaryenEventGetName(BinaryenEventRef event);
// Gets the attribute of the specified `Event`.
BINARYEN_API int BinaryenEventGetAttribute(BinaryenEventRef event);
// Gets the name of the `FunctionType` associated with the specified `Event`.
BINARYEN_API const char* BinaryenEventGetType(BinaryenEventRef event);
// Gets the number of parameters of the specified `Event`.
BINARYEN_API BinaryenIndex BinaryenEventGetNumParams(BinaryenEventRef event);
// Gets the type of the parameter at the specified index of the specified
// `Event`.
BINARYEN_API BinaryenType BinaryenEventGetParam(BinaryenEventRef event,
                                                BinaryenIndex index);

//
// ========== Import Operations ==========
//

// Gets the external module name of the specified import.
BINARYEN_API const char*
BinaryenFunctionImportGetModule(BinaryenFunctionRef import);
BINARYEN_API const char*
BinaryenGlobalImportGetModule(BinaryenGlobalRef import);
BINARYEN_API const char* BinaryenEventImportGetModule(BinaryenEventRef import);
// Gets the external base name of the specified import.
BINARYEN_API const char*
BinaryenFunctionImportGetBase(BinaryenFunctionRef import);
BINARYEN_API const char* BinaryenGlobalImportGetBase(BinaryenGlobalRef import);
BINARYEN_API const char* BinaryenEventImportGetBase(BinaryenEventRef import);

//
// ========== Export Operations ==========
//

// Gets the external kind of the specified export.
BINARYEN_API BinaryenExternalKind
BinaryenExportGetKind(BinaryenExportRef export_);
// Gets the external name of the specified export.
BINARYEN_API const char* BinaryenExportGetName(BinaryenExportRef export_);
// Gets the internal name of the specified export.
BINARYEN_API const char* BinaryenExportGetValue(BinaryenExportRef export_);
// Gets the number of exports in the module.
BINARYEN_API uint32_t BinaryenGetNumExports(BinaryenModuleRef module);
// Get export pointer from its index.
BINARYEN_API BinaryenExportRef
BinaryenGetExportByIndex(BinaryenModuleRef module, BinaryenIndex id);

//
// ========= Custom sections =========
//

BINARYEN_API void BinaryenAddCustomSection(BinaryenModuleRef module,
                                           const char* name,
                                           const char* contents,
                                           BinaryenIndex contentsSize);

//
// ========== CFG / Relooper ==========
//
// General usage is (1) create a relooper, (2) create blocks, (3) add
// branches between them, (4) render the output.
//
// For more details, see src/cfg/Relooper.h and
// https://github.com/WebAssembly/binaryen/wiki/Compiling-to-WebAssembly-with-Binaryen#cfg-api

typedef void* RelooperRef;
typedef void* RelooperBlockRef;

// Create a relooper instance
BINARYEN_API RelooperRef RelooperCreate(BinaryenModuleRef module);

// Create a basic block that ends with nothing, or with some simple branching
BINARYEN_API RelooperBlockRef RelooperAddBlock(RelooperRef relooper,
                                               BinaryenExpressionRef code);

// Create a branch to another basic block
// The branch can have code on it, that is executed as the branch happens. this
// is useful for phis. otherwise, code can be NULL
BINARYEN_API void RelooperAddBranch(RelooperBlockRef from,
                                    RelooperBlockRef to,
                                    BinaryenExpressionRef condition,
                                    BinaryenExpressionRef code);

// Create a basic block that ends a switch on a condition
BINARYEN_API RelooperBlockRef
RelooperAddBlockWithSwitch(RelooperRef relooper,
                           BinaryenExpressionRef code,
                           BinaryenExpressionRef condition);

// Create a switch-style branch to another basic block. The block's switch table
// will have these indexes going to that target
BINARYEN_API void RelooperAddBranchForSwitch(RelooperBlockRef from,
                                             RelooperBlockRef to,
                                             BinaryenIndex* indexes,
                                             BinaryenIndex numIndexes,
                                             BinaryenExpressionRef code);

// Generate structed wasm control flow from the CFG of blocks and branches that
// were created on this relooper instance. This returns the rendered output, and
// also disposes of the relooper and its blocks and branches, as they are no
// longer needed.
// @param labelHelper To render irreducible control flow, we may need a helper
//        variable to guide us to the right target label. This value should be
//        an index of an i32 local variable that is free for us to use.
BINARYEN_API BinaryenExpressionRef RelooperRenderAndDispose(
  RelooperRef relooper, RelooperBlockRef entry, BinaryenIndex labelHelper);

//
// ========= Other APIs =========
//

// Sets whether API tracing is on or off. It is off by default. When on, each
// call to an API method will print out C code equivalent to it, which is useful
// for auto-generating standalone testcases from projects using the API. When
// calling this to turn on tracing, the prelude of the full program is printed,
// and when calling it to turn it off, the ending of the program is printed,
// giving you the full compilable testcase.
// TODO: compile-time option to enable/disable this feature entirely at build
// time?
BINARYEN_API void BinaryenSetAPITracing(int on);

//
// ========= Utilities =========
//

// Note that this function has been added because there is no better alternative
// currently and is scheduled for removal once there is one. It takes the same
// set of parameters as BinaryenAddFunctionType but instead of adding a new
// function signature, it returns a pointer to the existing signature or NULL if
// there is no such signature yet.
BINARYEN_API BinaryenFunctionTypeRef
BinaryenGetFunctionTypeBySignature(BinaryenModuleRef module,
                                   BinaryenType result,
                                   BinaryenType* paramTypes,
                                   BinaryenIndex numParams);

// Enable or disable coloring for the WASM printer
BINARYEN_API void BinaryenSetColorsEnabled(int enabled);

// Query whether color is enable for the WASM printer
BINARYEN_API int BinaryenAreColorsEnabled();
#ifdef __cplusplus
} // extern "C"
#endif

#endif // wasm_binaryen_c_h
