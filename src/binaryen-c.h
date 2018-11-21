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

#include "compiler-support.h"

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

BinaryenType BinaryenTypeNone(void);
BinaryenType BinaryenTypeInt32(void);
BinaryenType BinaryenTypeInt64(void);
BinaryenType BinaryenTypeFloat32(void);
BinaryenType BinaryenTypeFloat64(void);
BinaryenType BinaryenTypeUnreachable(void);
// Not a real type. Used as the last parameter to BinaryenBlock to let
// the API figure out the type instead of providing one.
BinaryenType BinaryenTypeAuto(void);

WASM_DEPRECATED BinaryenType BinaryenNone(void);
WASM_DEPRECATED BinaryenType BinaryenInt32(void);
WASM_DEPRECATED BinaryenType BinaryenInt64(void);
WASM_DEPRECATED BinaryenType BinaryenFloat32(void);
WASM_DEPRECATED BinaryenType BinaryenFloat64(void);
WASM_DEPRECATED BinaryenType BinaryenUndefined(void);

// Expression ids (call to get the value of each; you can cache them)

typedef uint32_t BinaryenExpressionId;

BinaryenExpressionId BinaryenInvalidId(void);
BinaryenExpressionId BinaryenBlockId(void);
BinaryenExpressionId BinaryenIfId(void);
BinaryenExpressionId BinaryenLoopId(void);
BinaryenExpressionId BinaryenBreakId(void);
BinaryenExpressionId BinaryenSwitchId(void);
BinaryenExpressionId BinaryenCallId(void);
BinaryenExpressionId BinaryenCallIndirectId(void);
BinaryenExpressionId BinaryenGetLocalId(void);
BinaryenExpressionId BinaryenSetLocalId(void);
BinaryenExpressionId BinaryenGetGlobalId(void);
BinaryenExpressionId BinaryenSetGlobalId(void);
BinaryenExpressionId BinaryenLoadId(void);
BinaryenExpressionId BinaryenStoreId(void);
BinaryenExpressionId BinaryenConstId(void);
BinaryenExpressionId BinaryenUnaryId(void);
BinaryenExpressionId BinaryenBinaryId(void);
BinaryenExpressionId BinaryenSelectId(void);
BinaryenExpressionId BinaryenDropId(void);
BinaryenExpressionId BinaryenReturnId(void);
BinaryenExpressionId BinaryenHostId(void);
BinaryenExpressionId BinaryenNopId(void);
BinaryenExpressionId BinaryenUnreachableId(void);
BinaryenExpressionId BinaryenAtomicCmpxchgId(void);
BinaryenExpressionId BinaryenAtomicRMWId(void);
BinaryenExpressionId BinaryenAtomicWaitId(void);
BinaryenExpressionId BinaryenAtomicWakeId(void);

// External kinds (call to get the value of each; you can cache them)

typedef uint32_t BinaryenExternalKind;

BinaryenExternalKind BinaryenExternalFunction(void);
BinaryenExternalKind BinaryenExternalTable(void);
BinaryenExternalKind BinaryenExternalMemory(void);
BinaryenExternalKind BinaryenExternalGlobal(void);

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

BinaryenModuleRef BinaryenModuleCreate(void);
void BinaryenModuleDispose(BinaryenModuleRef module);

// Function types

typedef void* BinaryenFunctionTypeRef;

// Add a new function type. This is thread-safe.
// Note: name can be NULL, in which case we auto-generate a name
BinaryenFunctionTypeRef BinaryenAddFunctionType(BinaryenModuleRef module, const char* name, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams);
// Removes a function type.
void BinaryenRemoveFunctionType(BinaryenModuleRef module, const char* name);

// Literals. These are passed by value.

struct BinaryenLiteral {
  int32_t type;
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
//
// For more information, see wasm.h

typedef int32_t BinaryenOp;

BinaryenOp BinaryenClzInt32(void);
BinaryenOp BinaryenCtzInt32(void);
BinaryenOp BinaryenPopcntInt32(void);
BinaryenOp BinaryenNegFloat32(void);
BinaryenOp BinaryenAbsFloat32(void);
BinaryenOp BinaryenCeilFloat32(void);
BinaryenOp BinaryenFloorFloat32(void);
BinaryenOp BinaryenTruncFloat32(void);
BinaryenOp BinaryenNearestFloat32(void);
BinaryenOp BinaryenSqrtFloat32(void);
BinaryenOp BinaryenEqZInt32(void);
BinaryenOp BinaryenClzInt64(void);
BinaryenOp BinaryenCtzInt64(void);
BinaryenOp BinaryenPopcntInt64(void);
BinaryenOp BinaryenNegFloat64(void);
BinaryenOp BinaryenAbsFloat64(void);
BinaryenOp BinaryenCeilFloat64(void);
BinaryenOp BinaryenFloorFloat64(void);
BinaryenOp BinaryenTruncFloat64(void);
BinaryenOp BinaryenNearestFloat64(void);
BinaryenOp BinaryenSqrtFloat64(void);
BinaryenOp BinaryenEqZInt64(void);
BinaryenOp BinaryenExtendSInt32(void);
BinaryenOp BinaryenExtendUInt32(void);
BinaryenOp BinaryenWrapInt64(void);
BinaryenOp BinaryenTruncSFloat32ToInt32(void);
BinaryenOp BinaryenTruncSFloat32ToInt64(void);
BinaryenOp BinaryenTruncUFloat32ToInt32(void);
BinaryenOp BinaryenTruncUFloat32ToInt64(void);
BinaryenOp BinaryenTruncSFloat64ToInt32(void);
BinaryenOp BinaryenTruncSFloat64ToInt64(void);
BinaryenOp BinaryenTruncUFloat64ToInt32(void);
BinaryenOp BinaryenTruncUFloat64ToInt64(void);
BinaryenOp BinaryenReinterpretFloat32(void);
BinaryenOp BinaryenReinterpretFloat64(void);
BinaryenOp BinaryenConvertSInt32ToFloat32(void);
BinaryenOp BinaryenConvertSInt32ToFloat64(void);
BinaryenOp BinaryenConvertUInt32ToFloat32(void);
BinaryenOp BinaryenConvertUInt32ToFloat64(void);
BinaryenOp BinaryenConvertSInt64ToFloat32(void);
BinaryenOp BinaryenConvertSInt64ToFloat64(void);
BinaryenOp BinaryenConvertUInt64ToFloat32(void);
BinaryenOp BinaryenConvertUInt64ToFloat64(void);
BinaryenOp BinaryenPromoteFloat32(void);
BinaryenOp BinaryenDemoteFloat64(void);
BinaryenOp BinaryenReinterpretInt32(void);
BinaryenOp BinaryenReinterpretInt64(void);
BinaryenOp BinaryenExtendS8Int32(void);
BinaryenOp BinaryenExtendS16Int32(void);
BinaryenOp BinaryenExtendS8Int64(void);
BinaryenOp BinaryenExtendS16Int64(void);
BinaryenOp BinaryenExtendS32Int64(void);
BinaryenOp BinaryenAddInt32(void);
BinaryenOp BinaryenSubInt32(void);
BinaryenOp BinaryenMulInt32(void);
BinaryenOp BinaryenDivSInt32(void);
BinaryenOp BinaryenDivUInt32(void);
BinaryenOp BinaryenRemSInt32(void);
BinaryenOp BinaryenRemUInt32(void);
BinaryenOp BinaryenAndInt32(void);
BinaryenOp BinaryenOrInt32(void);
BinaryenOp BinaryenXorInt32(void);
BinaryenOp BinaryenShlInt32(void);
BinaryenOp BinaryenShrUInt32(void);
BinaryenOp BinaryenShrSInt32(void);
BinaryenOp BinaryenRotLInt32(void);
BinaryenOp BinaryenRotRInt32(void);
BinaryenOp BinaryenEqInt32(void);
BinaryenOp BinaryenNeInt32(void);
BinaryenOp BinaryenLtSInt32(void);
BinaryenOp BinaryenLtUInt32(void);
BinaryenOp BinaryenLeSInt32(void);
BinaryenOp BinaryenLeUInt32(void);
BinaryenOp BinaryenGtSInt32(void);
BinaryenOp BinaryenGtUInt32(void);
BinaryenOp BinaryenGeSInt32(void);
BinaryenOp BinaryenGeUInt32(void);
BinaryenOp BinaryenAddInt64(void);
BinaryenOp BinaryenSubInt64(void);
BinaryenOp BinaryenMulInt64(void);
BinaryenOp BinaryenDivSInt64(void);
BinaryenOp BinaryenDivUInt64(void);
BinaryenOp BinaryenRemSInt64(void);
BinaryenOp BinaryenRemUInt64(void);
BinaryenOp BinaryenAndInt64(void);
BinaryenOp BinaryenOrInt64(void);
BinaryenOp BinaryenXorInt64(void);
BinaryenOp BinaryenShlInt64(void);
BinaryenOp BinaryenShrUInt64(void);
BinaryenOp BinaryenShrSInt64(void);
BinaryenOp BinaryenRotLInt64(void);
BinaryenOp BinaryenRotRInt64(void);
BinaryenOp BinaryenEqInt64(void);
BinaryenOp BinaryenNeInt64(void);
BinaryenOp BinaryenLtSInt64(void);
BinaryenOp BinaryenLtUInt64(void);
BinaryenOp BinaryenLeSInt64(void);
BinaryenOp BinaryenLeUInt64(void);
BinaryenOp BinaryenGtSInt64(void);
BinaryenOp BinaryenGtUInt64(void);
BinaryenOp BinaryenGeSInt64(void);
BinaryenOp BinaryenGeUInt64(void);
BinaryenOp BinaryenAddFloat32(void);
BinaryenOp BinaryenSubFloat32(void);
BinaryenOp BinaryenMulFloat32(void);
BinaryenOp BinaryenDivFloat32(void);
BinaryenOp BinaryenCopySignFloat32(void);
BinaryenOp BinaryenMinFloat32(void);
BinaryenOp BinaryenMaxFloat32(void);
BinaryenOp BinaryenEqFloat32(void);
BinaryenOp BinaryenNeFloat32(void);
BinaryenOp BinaryenLtFloat32(void);
BinaryenOp BinaryenLeFloat32(void);
BinaryenOp BinaryenGtFloat32(void);
BinaryenOp BinaryenGeFloat32(void);
BinaryenOp BinaryenAddFloat64(void);
BinaryenOp BinaryenSubFloat64(void);
BinaryenOp BinaryenMulFloat64(void);
BinaryenOp BinaryenDivFloat64(void);
BinaryenOp BinaryenCopySignFloat64(void);
BinaryenOp BinaryenMinFloat64(void);
BinaryenOp BinaryenMaxFloat64(void);
BinaryenOp BinaryenEqFloat64(void);
BinaryenOp BinaryenNeFloat64(void);
BinaryenOp BinaryenLtFloat64(void);
BinaryenOp BinaryenLeFloat64(void);
BinaryenOp BinaryenGtFloat64(void);
BinaryenOp BinaryenGeFloat64(void);
BinaryenOp BinaryenCurrentMemory(void);
BinaryenOp BinaryenGrowMemory(void);
BinaryenOp BinaryenAtomicRMWAdd(void);
BinaryenOp BinaryenAtomicRMWSub(void);
BinaryenOp BinaryenAtomicRMWAnd(void);
BinaryenOp BinaryenAtomicRMWOr(void);
BinaryenOp BinaryenAtomicRMWXor(void);
BinaryenOp BinaryenAtomicRMWXchg(void);

typedef void* BinaryenExpressionRef;

// Block: name can be NULL. Specifying BinaryenUndefined() as the 'type'
//        parameter indicates that the block's type shall be figured out
//        automatically instead of explicitly providing it. This conforms
//        to the behavior before the 'type' parameter has been introduced.
BinaryenExpressionRef BinaryenBlock(BinaryenModuleRef module, const char* name, BinaryenExpressionRef* children, BinaryenIndex numChildren, BinaryenType type);
// If: ifFalse can be NULL
BinaryenExpressionRef BinaryenIf(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse);
BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module, const char* in, BinaryenExpressionRef body);
// Break: value and condition can be NULL
BinaryenExpressionRef BinaryenBreak(BinaryenModuleRef module, const char* name, BinaryenExpressionRef condition, BinaryenExpressionRef value);
// Switch: value can be NULL
BinaryenExpressionRef BinaryenSwitch(BinaryenModuleRef module, const char** names, BinaryenIndex numNames, const char* defaultName, BinaryenExpressionRef condition, BinaryenExpressionRef value);
// Call: Note the 'returnType' parameter. You must declare the
//       type returned by the function being called, as that
//       function might not have been created yet, so we don't
//       know what it is.
BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module, const char* target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenType returnType);
BinaryenExpressionRef BinaryenCallIndirect(BinaryenModuleRef module, BinaryenExpressionRef target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, const char* type);
// GetLocal: Note the 'type' parameter. It might seem redundant, since the
//           local at that index must have a type. However, this API lets you
//           build code "top-down": create a node, then its parents, and so
//           on, and finally create the function at the end. (Note that in fact
//           you do not mention a function when creating ExpressionRefs, only
//           a module.) And since GetLocal is a leaf node, we need to be told
//           its type. (Other nodes detect their type either from their
//           type or their opcode, or failing that, their children. But
//           GetLocal has no children, it is where a "stream" of type info
//           begins.)
//           Note also that the index of a local can refer to a param or
//           a var, that is, either a parameter to the function or a variable
//           declared when you call BinaryenAddFunction. See BinaryenAddFunction
//           for more details.
BinaryenExpressionRef BinaryenGetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenType type);
BinaryenExpressionRef BinaryenSetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value);
BinaryenExpressionRef BinaryenTeeLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value);
BinaryenExpressionRef BinaryenGetGlobal(BinaryenModuleRef module, const char* name, BinaryenType type);
BinaryenExpressionRef BinaryenSetGlobal(BinaryenModuleRef module, const char* name, BinaryenExpressionRef value);
// Load: align can be 0, in which case it will be the natural alignment (equal to bytes)
BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module, uint32_t bytes, int8_t signed_, uint32_t offset, uint32_t align, BinaryenType type, BinaryenExpressionRef ptr);
// Store: align can be 0, in which case it will be the natural alignment (equal to bytes)
BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, uint32_t align, BinaryenExpressionRef ptr, BinaryenExpressionRef value, BinaryenType type);
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module, struct BinaryenLiteral value);
BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef value);
BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef left, BinaryenExpressionRef right);
BinaryenExpressionRef BinaryenSelect(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse);
BinaryenExpressionRef BinaryenDrop(BinaryenModuleRef module, BinaryenExpressionRef value);
// Return: value can be NULL
BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module, BinaryenExpressionRef value);
// Host: name may be NULL
BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module, BinaryenOp op, const char* name, BinaryenExpressionRef* operands, BinaryenIndex numOperands);
BinaryenExpressionRef BinaryenNop(BinaryenModuleRef module);
BinaryenExpressionRef BinaryenUnreachable(BinaryenModuleRef module);
BinaryenExpressionRef BinaryenAtomicLoad(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, BinaryenType type, BinaryenExpressionRef ptr);
BinaryenExpressionRef BinaryenAtomicStore(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, BinaryenExpressionRef ptr, BinaryenExpressionRef value, BinaryenType type);
BinaryenExpressionRef BinaryenAtomicRMW(BinaryenModuleRef module, BinaryenOp op, BinaryenIndex bytes, BinaryenIndex offset, BinaryenExpressionRef ptr, BinaryenExpressionRef value, BinaryenType type);
BinaryenExpressionRef BinaryenAtomicCmpxchg(BinaryenModuleRef module, BinaryenIndex bytes, BinaryenIndex offset, BinaryenExpressionRef ptr, BinaryenExpressionRef expected, BinaryenExpressionRef replacement, BinaryenType type);
BinaryenExpressionRef BinaryenAtomicWait(BinaryenModuleRef module, BinaryenExpressionRef ptr, BinaryenExpressionRef expected, BinaryenExpressionRef timeout, BinaryenType type);
BinaryenExpressionRef BinaryenAtomicWake(BinaryenModuleRef module, BinaryenExpressionRef ptr, BinaryenExpressionRef wakeCount);

// Gets the id (kind) of the specified expression.
BinaryenExpressionId BinaryenExpressionGetId(BinaryenExpressionRef expr);
// Gets the type of the specified expression.
BinaryenType BinaryenExpressionGetType(BinaryenExpressionRef expr);
// Prints an expression to stdout. Useful for debugging.
void BinaryenExpressionPrint(BinaryenExpressionRef expr);

// Gets the name of the specified `Block` expression. May be `NULL`.
const char* BinaryenBlockGetName(BinaryenExpressionRef expr);
// Gets the number of nested child expressions within the specified `Block` expression.
BinaryenIndex BinaryenBlockGetNumChildren(BinaryenExpressionRef expr);
// Gets the nested child expression at the specified index within the specified `Block` expression.
BinaryenExpressionRef BinaryenBlockGetChild(BinaryenExpressionRef expr, BinaryenIndex index);

// Gets the nested condition expression within the specified `If` expression.
BinaryenExpressionRef BinaryenIfGetCondition(BinaryenExpressionRef expr);
// Gets the nested ifTrue expression within the specified `If` expression.
BinaryenExpressionRef BinaryenIfGetIfTrue(BinaryenExpressionRef expr);
// Gets the nested ifFalse expression within the specified `If` expression.
BinaryenExpressionRef BinaryenIfGetIfFalse(BinaryenExpressionRef expr);

// Gets the name of the specified `Loop` expression. May be `NULL`.
const char* BinaryenLoopGetName(BinaryenExpressionRef expr);
// Gets the nested body expression within the specified `Loop` expression.
BinaryenExpressionRef BinaryenLoopGetBody(BinaryenExpressionRef expr);

// Gets the name of the specified `Break` expression. May be `NULL`.
const char* BinaryenBreakGetName(BinaryenExpressionRef expr);
// Gets the nested condition expression within the specified `Break` expression. Returns `NULL` if this is a `br` and not a `br_if`.
BinaryenExpressionRef BinaryenBreakGetCondition(BinaryenExpressionRef expr);
// Gets the nested value expression within the specified `Break` expression. May be `NULL`.
BinaryenExpressionRef BinaryenBreakGetValue(BinaryenExpressionRef expr);

// Gets the number of names within the specified `Switch` expression.
BinaryenIndex BinaryenSwitchGetNumNames(BinaryenExpressionRef expr);
// Gets the name at the specified index within the specified `Switch` expression.
const char* BinaryenSwitchGetName(BinaryenExpressionRef expr, BinaryenIndex index);
// Gets the default name of the specified `Switch` expression.
const char* BinaryenSwitchGetDefaultName(BinaryenExpressionRef expr);
// Gets the nested condition expression within the specified `Switch` expression.
BinaryenExpressionRef BinaryenSwitchGetCondition(BinaryenExpressionRef expr);
// Gets the nested value expression within the specifiedd `Switch` expression. May be `NULL`.
BinaryenExpressionRef BinaryenSwitchGetValue(BinaryenExpressionRef expr);

// Gets the name of the target of the specified `Call` expression.
const char* BinaryenCallGetTarget(BinaryenExpressionRef expr);
// Gets the number of nested operand expressions within the specified `Call` expression.
BinaryenIndex BinaryenCallGetNumOperands(BinaryenExpressionRef expr);
// Gets the nested operand expression at the specified index within the specified `Call` expression.
BinaryenExpressionRef BinaryenCallGetOperand(BinaryenExpressionRef expr, BinaryenIndex index);

// Gets the nested target expression of the specified `CallIndirect` expression.
BinaryenExpressionRef BinaryenCallIndirectGetTarget(BinaryenExpressionRef expr);
// Gets the number of nested operand expressions within the specified `CallIndirect` expression.
BinaryenIndex BinaryenCallIndirectGetNumOperands(BinaryenExpressionRef expr);
// Gets the nested operand expression at the specified index within the specified `CallIndirect` expression.
BinaryenExpressionRef BinaryenCallIndirectGetOperand(BinaryenExpressionRef expr, BinaryenIndex index);

// Gets the index of the specified `GetLocal` expression.
BinaryenIndex BinaryenGetLocalGetIndex(BinaryenExpressionRef expr);

// Tests if the specified `SetLocal` expression performs a `tee_local` instead of a `set_local`.
int BinaryenSetLocalIsTee(BinaryenExpressionRef expr);
// Gets the index of the specified `SetLocal` expression.
BinaryenIndex BinaryenSetLocalGetIndex(BinaryenExpressionRef expr);
// Gets the nested value expression within the specified `SetLocal` expression.
BinaryenExpressionRef BinaryenSetLocalGetValue(BinaryenExpressionRef expr);

// Gets the name of the specified `GetGlobal` expression.
const char* BinaryenGetGlobalGetName(BinaryenExpressionRef expr);

// Gets the name of the specified `SetGlobal` expression.
const char* BinaryenSetGlobalGetName(BinaryenExpressionRef expr);
// Gets the nested value expression within the specified `SetLocal` expression.
BinaryenExpressionRef BinaryenSetGlobalGetValue(BinaryenExpressionRef expr);

// Gets the operator of the specified `Host` expression.
BinaryenOp BinaryenHostGetOp(BinaryenExpressionRef expr);
// Gets the name operand of the specified `Host` expression. May be `NULL`.
const char* BinaryenHostGetNameOperand(BinaryenExpressionRef expr);
// Gets the number of nested operand expressions within the specified `Host` expression.
BinaryenIndex BinaryenHostGetNumOperands(BinaryenExpressionRef expr);
// Gets the nested operand expression at the specified index within the specified `Host` expression.
BinaryenExpressionRef BinaryenHostGetOperand(BinaryenExpressionRef expr, BinaryenIndex index);

// Tests if the specified `Load` expression is atomic.
int BinaryenLoadIsAtomic(BinaryenExpressionRef expr);
// Tests if the specified `Load` expression is signed.
int BinaryenLoadIsSigned(BinaryenExpressionRef expr);
// Gets the offset of the specified `Load` expression.
uint32_t BinaryenLoadGetOffset(BinaryenExpressionRef expr);
// Gets the byte size of the specified `Load` expression.
uint32_t BinaryenLoadGetBytes(BinaryenExpressionRef expr);
// Gets the alignment of the specified `Load` expression.
uint32_t BinaryenLoadGetAlign(BinaryenExpressionRef expr);
// Gets the nested pointer expression within the specified `Load` expression.
BinaryenExpressionRef BinaryenLoadGetPtr(BinaryenExpressionRef expr);

// Tests if the specified `Store` expression is atomic.
int BinaryenStoreIsAtomic(BinaryenExpressionRef expr);
// Gets the byte size of the specified `Store` expression.
uint32_t BinaryenStoreGetBytes(BinaryenExpressionRef expr);
// Gets the offset of the specified store expression.
uint32_t BinaryenStoreGetOffset(BinaryenExpressionRef expr);
// Gets the alignment of the specified `Store` expression.
uint32_t BinaryenStoreGetAlign(BinaryenExpressionRef expr);
// Gets the nested pointer expression within the specified `Store` expression.
BinaryenExpressionRef BinaryenStoreGetPtr(BinaryenExpressionRef expr);
// Gets the nested value expression within the specified `Store` expression.
BinaryenExpressionRef BinaryenStoreGetValue(BinaryenExpressionRef expr);

// Gets the 32-bit integer value of the specified `Const` expression.
int32_t BinaryenConstGetValueI32(BinaryenExpressionRef expr);
// Gets the 64-bit integer value of the specified `Const` expression.
int64_t BinaryenConstGetValueI64(BinaryenExpressionRef expr);
// Gets the low 32-bits of a 64-bit integer value of the specified `Const` expression. Useful where I64 returning exports are illegal, i.e. binaryen.js.
int32_t BinaryenConstGetValueI64Low(BinaryenExpressionRef expr);
// Gets the high 32-bits of a 64-bit integer value of the specified `Const` expression. Useful where I64 returning exports are illegal, i.e. binaryen.js.
int32_t BinaryenConstGetValueI64High(BinaryenExpressionRef expr);
// Gets the 32-bit float value of the specified `Const` expression.
float BinaryenConstGetValueF32(BinaryenExpressionRef expr);
// Gets the 64-bit float value of the specified `Const` expression.
double BinaryenConstGetValueF64(BinaryenExpressionRef expr);

// Gets the operator of the specified `Unary` expression.
BinaryenOp BinaryenUnaryGetOp(BinaryenExpressionRef expr);
// Gets the nested value expression within the specified `Unary` expression.
BinaryenExpressionRef BinaryenUnaryGetValue(BinaryenExpressionRef expr);

// Gets the operator of the specified `Binary` expression.
BinaryenOp BinaryenBinaryGetOp(BinaryenExpressionRef expr);
// Gets the nested left expression within the specified `Binary` expression.
BinaryenExpressionRef BinaryenBinaryGetLeft(BinaryenExpressionRef expr);
// Gets the nested right expression within the specified `Binary` expression.
BinaryenExpressionRef BinaryenBinaryGetRight(BinaryenExpressionRef expr);

// Gets the nested ifTrue expression within the specified `Select` expression.
BinaryenExpressionRef BinaryenSelectGetIfTrue(BinaryenExpressionRef expr);
// Gets the nested ifFalse expression within the specified `Select` expression.
BinaryenExpressionRef BinaryenSelectGetIfFalse(BinaryenExpressionRef expr);
// Gets the nested condition expression within the specified `Select` expression.
BinaryenExpressionRef BinaryenSelectGetCondition(BinaryenExpressionRef expr);

// Gets the nested value expression within the specified `Drop` expression.
BinaryenExpressionRef BinaryenDropGetValue(BinaryenExpressionRef expr);

// Gets the nested value expression within the specified `Return` expression.
BinaryenExpressionRef BinaryenReturnGetValue(BinaryenExpressionRef expr);

// Gets the operator of the specified `AtomicRMW` expression.
BinaryenOp BinaryenAtomicRMWGetOp(BinaryenExpressionRef expr);
// Gets the byte size of the specified `AtomicRMW` expression.
uint32_t BinaryenAtomicRMWGetBytes(BinaryenExpressionRef expr);
// Gets the offset of the specified `AtomicRMW` expression.
uint32_t BinaryenAtomicRMWGetOffset(BinaryenExpressionRef expr);
// Gets the nested pointer expression within the specified `AtomicRMW` expression.
BinaryenExpressionRef BinaryenAtomicRMWGetPtr(BinaryenExpressionRef expr);
// Gets the nested value expression within the specified `AtomicRMW` expression.
BinaryenExpressionRef BinaryenAtomicRMWGetValue(BinaryenExpressionRef expr);

// Gets the byte size of the specified `AtomicCmpxchg` expression.
uint32_t BinaryenAtomicCmpxchgGetBytes(BinaryenExpressionRef expr);
// Gets the offset of the specified `AtomicCmpxchg` expression.
uint32_t BinaryenAtomicCmpxchgGetOffset(BinaryenExpressionRef expr);
// Gets the nested pointer expression within the specified `AtomicCmpxchg` expression.
BinaryenExpressionRef BinaryenAtomicCmpxchgGetPtr(BinaryenExpressionRef expr);
// Gets the nested expected value expression within the specified `AtomicCmpxchg` expression.
BinaryenExpressionRef BinaryenAtomicCmpxchgGetExpected(BinaryenExpressionRef expr);
// Gets the nested replacement value expression within the specified `AtomicCmpxchg` expression.
BinaryenExpressionRef BinaryenAtomicCmpxchgGetReplacement(BinaryenExpressionRef expr);

// Gets the nested pointer expression within the specified `AtomicWait` expression.
BinaryenExpressionRef BinaryenAtomicWaitGetPtr(BinaryenExpressionRef expr);
// Gets the nested expected value expression within the specified `AtomicWait` expression.
BinaryenExpressionRef BinaryenAtomicWaitGetExpected(BinaryenExpressionRef expr);
// Gets the nested timeout expression within the specified `AtomicWait` expression.
BinaryenExpressionRef BinaryenAtomicWaitGetTimeout(BinaryenExpressionRef expr);
// Gets the expected type of the specified `AtomicWait` expression.
BinaryenType BinaryenAtomicWaitGetExpectedType(BinaryenExpressionRef expr);

// Gets the nested pointer expression within the specified `AtomicWake` expression.
BinaryenExpressionRef BinaryenAtomicWakeGetPtr(BinaryenExpressionRef expr);
// Gets the nested wake count expression within the specified `AtomicWake` expression.
BinaryenExpressionRef BinaryenAtomicWakeGetWakeCount(BinaryenExpressionRef expr);

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
BinaryenFunctionRef BinaryenAddFunction(BinaryenModuleRef module, const char* name, BinaryenFunctionTypeRef type, BinaryenType* varTypes, BinaryenIndex numVarTypes, BinaryenExpressionRef body);

// Gets a function reference by name.
BinaryenFunctionRef BinaryenGetFunction(BinaryenModuleRef module, const char* name);

// Removes a function by name.
void BinaryenRemoveFunction(BinaryenModuleRef module, const char* name);

// Imports

void BinaryenAddFunctionImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char* externalBaseName, BinaryenFunctionTypeRef functionType);
void BinaryenAddTableImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char* externalBaseName);
void BinaryenAddMemoryImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char* externalBaseName, uint8_t shared);
void BinaryenAddGlobalImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char* externalBaseName, BinaryenType globalType);

// Exports

typedef void* BinaryenExportRef;

WASM_DEPRECATED BinaryenExportRef BinaryenAddExport(BinaryenModuleRef module, const char* internalName, const char* externalName);
BinaryenExportRef BinaryenAddFunctionExport(BinaryenModuleRef module, const char* internalName, const char* externalName);
BinaryenExportRef BinaryenAddTableExport(BinaryenModuleRef module, const char* internalName, const char* externalName);
BinaryenExportRef BinaryenAddMemoryExport(BinaryenModuleRef module, const char* internalName, const char* externalName);
BinaryenExportRef BinaryenAddGlobalExport(BinaryenModuleRef module, const char* internalName, const char* externalName);
void BinaryenRemoveExport(BinaryenModuleRef module, const char* externalName);

// Globals

typedef void* BinaryenGlobalRef;

BinaryenGlobalRef BinaryenAddGlobal(BinaryenModuleRef module, const char* name, BinaryenType type, int8_t mutable_, BinaryenExpressionRef init);
void BinaryenRemoveGlobal(BinaryenModuleRef module, const char* name);

// Function table. One per module

void BinaryenSetFunctionTable(BinaryenModuleRef module, BinaryenIndex initial, BinaryenIndex maximum, const char** funcNames, BinaryenIndex numFuncNames);

// Memory. One per module

// Each segment has data in segments, a start offset in segmentOffsets, and a size in segmentSizes.
// exportName can be NULL
void BinaryenSetMemory(BinaryenModuleRef module, BinaryenIndex initial, BinaryenIndex maximum, const char* exportName, const char** segments, BinaryenExpressionRef* segmentOffsets, BinaryenIndex* segmentSizes, BinaryenIndex numSegments, uint8_t shared);

// Start function. One per module

void BinaryenSetStart(BinaryenModuleRef module, BinaryenFunctionRef start);

//
// ========== Module Operations ==========
//

// Parse a module in s-expression text format
BinaryenModuleRef BinaryenModuleParse(const char* text);

// Print a module to stdout in s-expression text format. Useful for debugging.
void BinaryenModulePrint(BinaryenModuleRef module);

// Print a module to stdout in asm.js syntax.
void BinaryenModulePrintAsmjs(BinaryenModuleRef module);

// Validate a module, showing errors on problems.
//  @return 0 if an error occurred, 1 if validated succesfully
int BinaryenModuleValidate(BinaryenModuleRef module);

// Runs the standard optimization passes on the module. Uses the currently set
// global optimize and shrink level.
void BinaryenModuleOptimize(BinaryenModuleRef module);

// Gets the currently set optimize level. Applies to all modules, globally.
// 0, 1, 2 correspond to -O0, -O1, -O2 (default), etc.
int BinaryenGetOptimizeLevel();

// Sets the optimization level to use. Applies to all modules, globally.
// 0, 1, 2 correspond to -O0, -O1, -O2 (default), etc.
void BinaryenSetOptimizeLevel(int level);

// Gets the currently set shrink level. Applies to all modules, globally.
// 0, 1, 2 correspond to -O0, -Os (default), -Oz.
int BinaryenGetShrinkLevel();

// Sets the shrink level to use. Applies to all modules, globally.
// 0, 1, 2 correspond to -O0, -Os (default), -Oz.
void BinaryenSetShrinkLevel(int level);

// Gets whether generating debug information is currently enabled or not.
// Applies to all modules, globally.
int BinaryenGetDebugInfo();

// Enables or disables debug information in emitted binaries.
// Applies to all modules, globally.
void BinaryenSetDebugInfo(int on);

// Runs the specified passes on the module. Uses the currently set global
// optimize and shrink level.
void BinaryenModuleRunPasses(BinaryenModuleRef module, const char** passes, BinaryenIndex numPasses);

// Auto-generate drop() operations where needed. This lets you generate code without
// worrying about where they are needed. (It is more efficient to do it yourself,
// but simpler to use autodrop).
void BinaryenModuleAutoDrop(BinaryenModuleRef module);

// Serialize a module into binary form. Uses the currently set global debugInfo option.
// @return how many bytes were written. This will be less than or equal to outputSize
size_t BinaryenModuleWrite(BinaryenModuleRef module, char* output, size_t outputSize);

typedef struct BinaryenBufferSizes {
  size_t outputBytes;
  size_t sourceMapBytes;
} BinaryenBufferSizes;

// Serialize a module into binary form including its source map. Uses the currently set
// global debugInfo option.
// @returns how many bytes were written. This will be less than or equal to outputSize
BinaryenBufferSizes BinaryenModuleWriteWithSourceMap(BinaryenModuleRef module, const char* url, char* output, size_t outputSize, char* sourceMap, size_t sourceMapSize);

// Result structure of BinaryenModuleAllocateAndWrite. Contained buffers have been allocated
// using malloc() and the user is expected to free() them manually once not needed anymore.
typedef struct BinaryenModuleAllocateAndWriteResult {
  void* binary;
  size_t binaryBytes;
  char* sourceMap;
} BinaryenModuleAllocateAndWriteResult;

// Serializes a module into binary form, optionally including its source map if
// sourceMapUrl has been specified. Uses the currently set global debugInfo option.
// Differs from BinaryenModuleWrite in that it implicitly allocates appropriate buffers
// using malloc(), and expects the user to free() them manually once not needed anymore.
BinaryenModuleAllocateAndWriteResult BinaryenModuleAllocateAndWrite(BinaryenModuleRef module, const char* sourceMapUrl);

// Deserialize a module from binary form.
BinaryenModuleRef BinaryenModuleRead(char* input, size_t inputSize);

// Execute a module in the Binaryen interpreter. This will create an instance of
// the module, run it in the interpreter - which means running the start method -
// and then destroying the instance.
void BinaryenModuleInterpret(BinaryenModuleRef module);

// Adds a debug info file name to the module and returns its index.
BinaryenIndex BinaryenModuleAddDebugInfoFileName(BinaryenModuleRef module, const char* filename);

// Gets the name of the debug info file at the specified index. Returns `NULL` if it
// does not exist.
const char* BinaryenModuleGetDebugInfoFileName(BinaryenModuleRef module, BinaryenIndex index);

//
// ======== FunctionType Operations ========
//

// Gets the name of the specified `FunctionType`.
const char* BinaryenFunctionTypeGetName(BinaryenFunctionTypeRef ftype);
// Gets the number of parameters of the specified `FunctionType`.
BinaryenIndex BinaryenFunctionTypeGetNumParams(BinaryenFunctionTypeRef ftype);
// Gets the type of the parameter at the specified index of the specified `FunctionType`.
BinaryenType BinaryenFunctionTypeGetParam(BinaryenFunctionTypeRef ftype, BinaryenIndex index);
// Gets the result type of the specified `FunctionType`.
BinaryenType BinaryenFunctionTypeGetResult(BinaryenFunctionTypeRef ftype);

//
// ========== Function Operations ==========
//

// Gets the name of the specified `Function`.
const char* BinaryenFunctionGetName(BinaryenFunctionRef func);
// Gets the name of the `FunctionType` associated with the specified `Function`. May be `NULL` if the signature is implicit.
const char* BinaryenFunctionGetType(BinaryenFunctionRef func);
// Gets the number of parameters of the specified `Function`.
BinaryenIndex BinaryenFunctionGetNumParams(BinaryenFunctionRef func);
// Gets the type of the parameter at the specified index of the specified `Function`.
BinaryenType BinaryenFunctionGetParam(BinaryenFunctionRef func, BinaryenIndex index);
// Gets the result type of the specified `Function`.
BinaryenType BinaryenFunctionGetResult(BinaryenFunctionRef func);
// Gets the number of additional locals within the specified `Function`.
BinaryenIndex BinaryenFunctionGetNumVars(BinaryenFunctionRef func);
// Gets the type of the additional local at the specified index within the specified `Function`.
BinaryenType BinaryenFunctionGetVar(BinaryenFunctionRef func, BinaryenIndex index);
// Gets the body of the specified `Function`.
BinaryenExpressionRef BinaryenFunctionGetBody(BinaryenFunctionRef func);

// Runs the standard optimization passes on the function. Uses the currently set
// global optimize and shrink level.
void BinaryenFunctionOptimize(BinaryenFunctionRef func, BinaryenModuleRef module);

// Runs the specified passes on the function. Uses the currently set global
// optimize and shrink level.
void BinaryenFunctionRunPasses(BinaryenFunctionRef func, BinaryenModuleRef module, const char** passes, BinaryenIndex numPasses);

// Sets the debug location of the specified `Expression` within the specified `Function`.
void BinaryenFunctionSetDebugLocation(BinaryenFunctionRef func, BinaryenExpressionRef expr, BinaryenIndex fileIndex, BinaryenIndex lineNumber, BinaryenIndex columnNumber);

//
// ========== Import Operations ==========
//

// Gets the external module name of the specified import.
const char* BinaryenFunctionImportGetModule(BinaryenFunctionRef import);
const char* BinaryeGlobalImportGetModule(BinaryenGlobalRef import);
// Gets the external base name of the specified import.
const char* BinaryenFunctionImportGetBase(BinaryenFunctionRef import);
const char* BinaryenGlobalImportGetBase(BinaryenGlobalRef import);

//
// ========== Export Operations ==========
//

// Gets the external kind of the specified export.
BinaryenExternalKind BinaryenExportGetKind(BinaryenExportRef export_);
// Gets the external name of the specified export.
const char* BinaryenExportGetName(BinaryenExportRef export_);
// Gets the internal name of the specified export.
const char* BinaryenExportGetValue(BinaryenExportRef export_);

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
RelooperRef RelooperCreate(BinaryenModuleRef module);

// Create a basic block that ends with nothing, or with some simple branching
RelooperBlockRef RelooperAddBlock(RelooperRef relooper, BinaryenExpressionRef code);

// Create a branch to another basic block
// The branch can have code on it, that is executed as the branch happens. this is useful for phis. otherwise, code can be NULL
void RelooperAddBranch(RelooperBlockRef from, RelooperBlockRef to, BinaryenExpressionRef condition, BinaryenExpressionRef code);

// Create a basic block that ends a switch on a condition
RelooperBlockRef RelooperAddBlockWithSwitch(RelooperRef relooper, BinaryenExpressionRef code, BinaryenExpressionRef condition);

// Create a switch-style branch to another basic block. The block's switch table will have these indexes going to that target
void RelooperAddBranchForSwitch(RelooperBlockRef from, RelooperBlockRef to, BinaryenIndex* indexes, BinaryenIndex numIndexes, BinaryenExpressionRef code);

// Generate structed wasm control flow from the CFG of blocks and branches that were created
// on this relooper instance. This returns the rendered output, and also disposes of the
// relooper and its blocks and branches, as they are no longer needed.
//   @param labelHelper To render irreducible control flow, we may need a helper variable to
//                      guide us to the right target label. This value should be an index of
//                      an i32 local variable that is free for us to use.
BinaryenExpressionRef RelooperRenderAndDispose(RelooperRef relooper, RelooperBlockRef entry, BinaryenIndex labelHelper);

//
// ========= Other APIs =========
//

// Sets whether API tracing is on or off. It is off by default. When on, each call
// to an API method will print out C code equivalent to it, which is useful for
// auto-generating standalone testcases from projects using the API.
// When calling this to turn on tracing, the prelude of the full program is printed,
// and when calling it to turn it off, the ending of the program is printed, giving
// you the full compilable testcase.
// TODO: compile-time option to enable/disable this feature entirely at build time?
void BinaryenSetAPITracing(int on);

//
// ========= Utilities =========
//

// Note that this function has been added because there is no better alternative
// currently and is scheduled for removal once there is one. It takes the same set
// of parameters as BinaryenAddFunctionType but instead of adding a new function
// signature, it returns a pointer to the existing signature or NULL if there is no
// such signature yet.
BinaryenFunctionTypeRef BinaryenGetFunctionTypeBySignature(BinaryenModuleRef module, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams);

#ifdef __cplusplus
} // extern "C"
#endif

#endif // wasm_binaryen_c_h
