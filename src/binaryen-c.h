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
// The second part of the API lets you perform operations on modules.
//================

#ifndef binaryen_h
#define binaryen_h

#include <stddef.h>
#include <stdint.h>

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

BinaryenType BinaryenNone(void);
BinaryenType BinaryenInt32(void);
BinaryenType BinaryenInt64(void);
BinaryenType BinaryenFloat32(void);
BinaryenType BinaryenFloat64(void);

// Modules
//
// Modules contain lists of functions, imports, exports, function types. The
// Add* methods create them on a module. The module owns them and will free their
// memory when the module is disposed of.
//
// Expressions are also allocated inside modules, and freed with the module. They
// are not created by Add* methods, since they are not added directly on the
// module, instead, they are arguments to other expressions (and then they are
// the children of that AST node), or to a function (and then they are the body
// of that function).
//
// A module can also contain a function table for indirect calls, a memory,
// and a start method.

typedef void* BinaryenModuleRef;

BinaryenModuleRef BinaryenModuleCreate();
void BinaryenModuleDispose(BinaryenModuleRef module);

// Function types

typedef void* BinaryenFunctionTypeRef;

BinaryenFunctionTypeRef BinaryenAddFunctionType(BinaryenModuleRef module, const char* name, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams);

// Literals. These are passed by value.

struct BinaryenLiteral {
  int type; // size of enum in c++
  union {
    int32_t i32;
    int64_t i64;
    float f32;
    double f64;
  };
};

struct BinaryenLiteral BinaryenLiteralInt32(int32_t x);
struct BinaryenLiteral BinaryenLiteralInt64(int64_t x);
struct BinaryenLiteral BinaryenLiteralFloat32(float x);
struct BinaryenLiteral BinaryenLiteralFloat64(double x);
struct BinaryenLiteral BinaryenLiteralFloat32Bits(int32_t x);
struct BinaryenLiteral BinaryenLiteralFloat64Bits(int64_t x);

// Expressions
//
// Some expressions have a BinaryenOp, which is the more
// specific operation/opcode.
//
// Some expressions have optional parameters, like Return may not
// return a value. You can supply a NULL pointer in those cases.

typedef int32_t BinaryenOp;

BinaryenOp BinaryenClz(void);
BinaryenOp BinaryenCtz(void);
BinaryenOp BinaryenPopcnt(void);
BinaryenOp BinaryenNeg(void);
BinaryenOp BinaryenAbs(void);
BinaryenOp BinaryenCeil(void);
BinaryenOp BinaryenFloor(void);
BinaryenOp BinaryenTrunc(void);
BinaryenOp BinaryenNearest(void);
BinaryenOp BinaryenSqrt(void);
BinaryenOp BinaryenEqZ(void);
BinaryenOp BinaryenExtendSInt32(void);
BinaryenOp BinaryenExtentUInt32(void);
BinaryenOp BinaryenWrapInt64(void);
BinaryenOp BinaryenTruncSFloat32(void);
BinaryenOp BinaryenTruncUFloat32(void);
BinaryenOp BinaryenTruncSFloat64(void);
BinaryenOp BinaryenTruncUFloat64(void);
BinaryenOp BinaryenReinterpretFloat(void);
BinaryenOp BinaryenConvertSInt32(void);
BinaryenOp BinaryenConvertUInt32(void);
BinaryenOp BinaryenConvertSInt64(void);
BinaryenOp BinaryenConvertUInt64(void);
BinaryenOp BinaryenPromoteFloat32(void);
BinaryenOp BinaryenDemoteFloat64(void);
BinaryenOp BinaryenReinterpretInt(void);
BinaryenOp BinaryenAdd(void);
BinaryenOp BinaryenSub(void);
BinaryenOp BinaryenMul(void);
BinaryenOp BinaryenDivS(void);
BinaryenOp BinaryenDivU(void);
BinaryenOp BinaryenRemS(void);
BinaryenOp BinaryenRemU(void);
BinaryenOp BinaryenAnd(void);
BinaryenOp BinaryenOr(void);
BinaryenOp BinaryenXor(void);
BinaryenOp BinaryenShl(void);
BinaryenOp BinaryenShrU(void);
BinaryenOp BinaryenShrS(void);
BinaryenOp BinaryenRotL(void);
BinaryenOp BinaryenRotR(void);
BinaryenOp BinaryenDiv(void);
BinaryenOp BinaryenCopySign(void);
BinaryenOp BinaryenMin(void);
BinaryenOp BinaryenMax(void);
BinaryenOp BinaryenEq(void);
BinaryenOp BinaryenNe(void);
BinaryenOp BinaryenLtS(void);
BinaryenOp BinaryenLtU(void);
BinaryenOp BinaryenLeS(void);
BinaryenOp BinaryenLeU(void);
BinaryenOp BinaryenGtS(void);
BinaryenOp BinaryenGtU(void);
BinaryenOp BinaryenGeS(void);
BinaryenOp BinaryenGeU(void);
BinaryenOp BinaryenLt(void);
BinaryenOp BinaryenLe(void);
BinaryenOp BinaryenGt(void);
BinaryenOp BinaryenGe(void);
BinaryenOp BinaryenPageSize(void);
BinaryenOp BinaryenCurrentMemory(void);
BinaryenOp BinaryenGrowMemory(void);
BinaryenOp BinaryenHasFeature(void);

typedef void* BinaryenExpressionRef;

// Block: name can be NULL
BinaryenExpressionRef BinaryenBlock(BinaryenModuleRef module, const char* name, BinaryenExpressionRef* children, BinaryenIndex numChildren);
// If: ifFalse can be NULL
BinaryenExpressionRef BinaryenIf(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse);
// Loop: both out and in can be NULL, or just out can be NULL
BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module, const char* out, const char* in, BinaryenExpressionRef body);
// Break: value and condition can be NULL
BinaryenExpressionRef BinaryenBreak(BinaryenModuleRef module, const char* name, BinaryenExpressionRef value, BinaryenExpressionRef condition);
// Switch: value can be NULL
BinaryenExpressionRef BinaryenSwitch(BinaryenModuleRef module, const char **names, BinaryenIndex numNames, const char* defaultName, BinaryenExpressionRef condition, BinaryenExpressionRef value);
BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands);
BinaryenExpressionRef BinaryenCallImport(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands);
BinaryenExpressionRef BinaryenCallIndirect(BinaryenModuleRef module, BinaryenExpressionRef target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenFunctionTypeRef type);
BinaryenExpressionRef BinaryenGetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenType type);
BinaryenExpressionRef BinaryenSetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value);
BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module, uint32_t bytes, int8_t signed_, uint32_t offset, uint32_t align, BinaryenType type, BinaryenExpressionRef ptr);
BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, uint32_t align, BinaryenExpressionRef ptr, BinaryenExpressionRef value);
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module, struct BinaryenLiteral value);
BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef value, BinaryenType type);
BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef left, BinaryenExpressionRef right);
BinaryenExpressionRef BinaryenSelect(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse);
// Return: value can be NULL
BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module, BinaryenExpressionRef value);
// Host: name may be NULL
BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module, BinaryenOp op, const char* name, BinaryenExpressionRef* operands, BinaryenIndex numOperands);
BinaryenExpressionRef BinaryenNop(BinaryenModuleRef module);
BinaryenExpressionRef BinaryenUnreachable(BinaryenModuleRef module);

// Functions

typedef void* BinaryenFunctionRef;

BinaryenFunctionRef BinaryenAddFunction(BinaryenModuleRef module, const char* name, BinaryenFunctionTypeRef type, BinaryenType* localTypes, BinaryenIndex numLocalTypes, BinaryenExpressionRef body);

// Imports

typedef void* BinaryenImportRef;

BinaryenImportRef BinaryenAddImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char *externalBaseName, BinaryenFunctionTypeRef type);

// Exports

typedef void* BinaryenExportRef;

BinaryenExportRef BinaryenAddExport(BinaryenModuleRef module, const char* internalName, const char* externalName);

// Function table. One per module

void BinaryenSetFunctionTable(BinaryenModuleRef module, BinaryenFunctionRef* functions, BinaryenIndex numFunctions);

// Memory. One per module

// Each segment has data in segments, a start offset in segmentOffsets, and a size in segmentSizes.
// exportName can be NULL
void BinaryenSetMemory(BinaryenModuleRef module, BinaryenIndex initial, BinaryenIndex maximum, const char* exportName, const char **segments, BinaryenIndex* segmentOffsets, BinaryenIndex* segmentSizes, BinaryenIndex numSegments);

// Start function. One per module

void BinaryenSetStart(BinaryenModuleRef module, const char* name);

//
// ========== Module Operations ==========
//

// Print a module to stdout.
void BinaryenModulePrint(BinaryenModuleRef module);

#ifdef __cplusplus
} // extern "C"
#endif

#endif  // binaryen_h
