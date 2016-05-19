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

BinaryenModuleRef BinaryenModuleCreate(void);
void BinaryenModuleDispose(BinaryenModuleRef module);

// Function types

typedef void* BinaryenFunctionTypeRef;

// Note: name can be NULL, in which case we auto-generate a name
BinaryenFunctionTypeRef BinaryenAddFunctionType(BinaryenModuleRef module, const char* name, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams);

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
BinaryenOp BinaryenExtentUInt32(void);
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
BinaryenExpressionRef BinaryenBreak(BinaryenModuleRef module, const char* name, BinaryenExpressionRef condition, BinaryenExpressionRef value);
// Switch: value can be NULL
BinaryenExpressionRef BinaryenSwitch(BinaryenModuleRef module, const char **names, BinaryenIndex numNames, const char* defaultName, BinaryenExpressionRef condition, BinaryenExpressionRef value);
// Call, CallImport: Note the 'returnType' parameter. You must declare the
//                   type returned by the function being called, as that
//                   function might not have been created yet, so we don't
//                   know what it is.
BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenType returnType);
BinaryenExpressionRef BinaryenCallImport(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenType returnType);
BinaryenExpressionRef BinaryenCallIndirect(BinaryenModuleRef module, BinaryenExpressionRef target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenFunctionTypeRef type);
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
BinaryenExpressionRef BinaryenGetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenType type);
BinaryenExpressionRef BinaryenSetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value);
// Load: align can be 0, in which case it will be the natural alignment (equal to bytes)
BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module, uint32_t bytes, int8_t signed_, uint32_t offset, uint32_t align, BinaryenType type, BinaryenExpressionRef ptr);
// Store: align can be 0, in which case it will be the natural alignment (equal to bytes)
BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, uint32_t align, BinaryenExpressionRef ptr, BinaryenExpressionRef value);
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module, struct BinaryenLiteral value);
BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef value);
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

void BinaryenSetStart(BinaryenModuleRef module, BinaryenFunctionRef start);

//
// ========== Module Operations ==========
//

// Print a module to stdout.
void BinaryenModulePrint(BinaryenModuleRef module);

// Validate a module, showing errors on problems.
//  @return 0 if an error occurred, 1 if validated succesfully
int BinaryenModuleValidate(BinaryenModuleRef module);

// Run the standard optimization passes on the module.
void BinaryenModuleOptimize(BinaryenModuleRef module);

// Serialize a module into binary form.
// @return how many bytes were written. This will be less than or equal to bufferSize
size_t BinaryenModuleWrite(BinaryenModuleRef module, char* output, size_t outputSize);

// Deserialize a module from binary form.
BinaryenModuleRef BinaryenModuleRead(char* input, size_t inputSize);

//
// ========== CFG / Relooper ==========
//
// General usage is (1) create a relooper, (2) create blocks, (3) add
// branches between them, (4) render the output.
//
// See Relooper.h for more details

typedef void* RelooperRef;
typedef void* RelooperBlockRef;

// Create a relooper instance
RelooperRef RelooperCreate(void);

// Create a basic block that ends with nothing, or with some simple branching
RelooperBlockRef RelooperAddBlock(RelooperRef relooper, BinaryenExpressionRef code);

// Create a branch to another basic block
// The branch can have code on it, that is executed as the branch happens. this is useful for phis. otherwise, code can be NULL
void RelooperAddBranch(RelooperBlockRef from, RelooperBlockRef to, BinaryenExpressionRef condition, BinaryenExpressionRef code);

// Create a basic block that ends a switch on a condition
// TODO RelooperBlockRef RelooperAddBlockWithSwitch(RelooperRef relooper, BinaryenExpressionRef code, BinaryenExpressionRef condition);

// Create a switch-style branch to another basic block. The block's switch table will have an index for this branch
// TODO void RelooperAddBranchForSwitch(RelooperBlockRef from, RelooperBlockRef to, BinaryenIndex index, BinaryenExpressionRef code);

// Generate structed wasm control flow from the CFG of blocks and branches that were created
// on this relooper instance. This returns the rendered output, and also disposes of the
// relooper and its blocks and branches, as they are no longer needed.
//   @param labelHelper To render irreducible control flow, we may need a helper variable to
//                      guide us to the right target label. This value should be an index of
//                      an i32 local variable that is free for us to use.
BinaryenExpressionRef RelooperRenderAndDispose(RelooperRef relooper, RelooperBlockRef entry, BinaryenIndex labelHelper, BinaryenModuleRef module);

#ifdef __cplusplus
} // extern "C"
#endif

#endif  // binaryen_h
