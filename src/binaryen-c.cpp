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

//===============================
// Binaryen C API implementation
//===============================

#include <mutex>

#include "binaryen-c.h"
#include "pass.h"
#include "wasm.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-interpreter.h"
#include "wasm-printing.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"
#include "wasm2js.h"
#include "cfg/Relooper.h"
#include "ir/function-type-utils.h"
#include "ir/utils.h"
#include "shell-interface.h"

using namespace wasm;

// Literal utilities

static_assert(sizeof(BinaryenLiteral) == sizeof(Literal), "Binaryen C API literal must match wasm.h");

BinaryenLiteral toBinaryenLiteral(Literal x) {
  BinaryenLiteral ret;
  ret.type = x.type;
  switch (x.type) {
    case Type::i32: ret.i32 = x.geti32(); break;
    case Type::i64: ret.i64 = x.geti64(); break;
    case Type::f32: ret.i32 = x.reinterpreti32(); break;
    case Type::f64: ret.i64 = x.reinterpreti64(); break;
    default: abort();
  }
  return ret;
}

Literal fromBinaryenLiteral(BinaryenLiteral x) {
  switch (x.type) {
    case Type::i32: return Literal(x.i32);
    case Type::i64: return Literal(x.i64);
    case Type::f32: return Literal(x.i32).castToF32();
    case Type::f64: return Literal(x.i64).castToF64();
    default: abort();
  }
}

// Mutexes (global for now; in theory if multiple modules
// are used at once this should be optimized to be per-
// module, but likely it doesn't matter)

static std::mutex BinaryenFunctionMutex;
static std::mutex BinaryenFunctionTypeMutex;

// Optimization options
static PassOptions globalPassOptions = PassOptions::getWithDefaultOptimizationOptions();

// Tracing support

static int tracing = 0;

void traceNameOrNULL(const char* name) {
  if (name) std::cout << "\"" << name << "\"";
  else std::cout << "NULL";
}

std::map<BinaryenFunctionTypeRef, size_t> functionTypes;
std::map<BinaryenExpressionRef, size_t> expressions;
std::map<BinaryenFunctionRef, size_t> functions;
std::map<BinaryenGlobalRef, size_t> globals;
std::map<BinaryenExportRef, size_t> exports;
std::map<RelooperBlockRef, size_t> relooperBlocks;

size_t noteExpression(BinaryenExpressionRef expression) {
  auto id = expressions.size();
  assert(expressions.find(expression) == expressions.end());
  expressions[expression] = id;
  return id;
}

extern "C" {

//
// ========== Module Creation ==========
//

// Core types

BinaryenType BinaryenTypeNone(void) { return none; }
BinaryenType BinaryenTypeInt32(void) { return i32; }
BinaryenType BinaryenTypeInt64(void) { return i64; }
BinaryenType BinaryenTypeFloat32(void) { return f32; }
BinaryenType BinaryenTypeFloat64(void) { return f64; }
BinaryenType BinaryenTypeUnreachable(void) { return unreachable; }
BinaryenType BinaryenTypeAuto(void) { return uint32_t(-1); }

WASM_DEPRECATED BinaryenType BinaryenNone(void) { return none; }
WASM_DEPRECATED BinaryenType BinaryenInt32(void) { return i32; }
WASM_DEPRECATED BinaryenType BinaryenInt64(void) { return i64; }
WASM_DEPRECATED BinaryenType BinaryenFloat32(void) { return f32; }
WASM_DEPRECATED BinaryenType BinaryenFloat64(void) { return f64; }
WASM_DEPRECATED BinaryenType BinaryenUndefined(void) { return uint32_t(-1); }

// Expression ids

BinaryenExpressionId BinaryenInvalidId(void) { return Expression::Id::InvalidId; }
BinaryenExpressionId BinaryenBlockId(void) { return Expression::Id::BlockId; }
BinaryenExpressionId BinaryenIfId(void) { return Expression::Id::IfId; }
BinaryenExpressionId BinaryenLoopId(void) { return Expression::Id::LoopId; }
BinaryenExpressionId BinaryenBreakId(void) { return Expression::Id::BreakId; }
BinaryenExpressionId BinaryenSwitchId(void) { return Expression::Id::SwitchId; }
BinaryenExpressionId BinaryenCallId(void) { return Expression::Id::CallId; }
BinaryenExpressionId BinaryenCallIndirectId(void) { return Expression::Id::CallIndirectId; }
BinaryenExpressionId BinaryenGetLocalId(void) { return Expression::Id::GetLocalId; }
BinaryenExpressionId BinaryenSetLocalId(void) { return Expression::Id::SetLocalId; }
BinaryenExpressionId BinaryenGetGlobalId(void) { return Expression::Id::GetGlobalId; }
BinaryenExpressionId BinaryenSetGlobalId(void) { return Expression::Id::SetGlobalId; }
BinaryenExpressionId BinaryenLoadId(void) { return Expression::Id::LoadId; }
BinaryenExpressionId BinaryenStoreId(void) { return Expression::Id::StoreId; }
BinaryenExpressionId BinaryenConstId(void) { return Expression::Id::ConstId; }
BinaryenExpressionId BinaryenUnaryId(void) { return Expression::Id::UnaryId; }
BinaryenExpressionId BinaryenBinaryId(void) { return Expression::Id::BinaryId; }
BinaryenExpressionId BinaryenSelectId(void) { return Expression::Id::SelectId; }
BinaryenExpressionId BinaryenDropId(void) { return Expression::Id::DropId; }
BinaryenExpressionId BinaryenReturnId(void) { return Expression::Id::ReturnId; }
BinaryenExpressionId BinaryenHostId(void) { return Expression::Id::HostId; }
BinaryenExpressionId BinaryenNopId(void) { return Expression::Id::NopId; }
BinaryenExpressionId BinaryenUnreachableId(void) { return Expression::Id::UnreachableId; }
BinaryenExpressionId BinaryenAtomicCmpxchgId(void) { return Expression::Id::AtomicCmpxchgId; }
BinaryenExpressionId BinaryenAtomicRMWId(void) { return Expression::Id::AtomicRMWId; }
BinaryenExpressionId BinaryenAtomicWaitId(void) { return Expression::Id::AtomicWaitId; }
BinaryenExpressionId BinaryenAtomicWakeId(void) { return Expression::Id::AtomicWakeId; }

// External kinds

BinaryenExternalKind BinaryenExternalFunction(void) { return static_cast<BinaryenExternalKind>(ExternalKind::Function); }
BinaryenExternalKind BinaryenExternalTable(void) { return static_cast<BinaryenExternalKind>(ExternalKind::Table); }
BinaryenExternalKind BinaryenExternalMemory(void) { return static_cast<BinaryenExternalKind>(ExternalKind::Memory); }
BinaryenExternalKind BinaryenExternalGlobal(void) { return static_cast<BinaryenExternalKind>(ExternalKind::Global); }

// Modules

BinaryenModuleRef BinaryenModuleCreate(void) {
  if (tracing) {
    std::cout << "  the_module = BinaryenModuleCreate();\n";
    std::cout << "  expressions[size_t(NULL)] = BinaryenExpressionRef(NULL);\n";
    expressions[NULL] = 0;
  }

  return new Module();
}
void BinaryenModuleDispose(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleDispose(the_module);\n";
    std::cout << "  functionTypes.clear();\n";
    std::cout << "  expressions.clear();\n";
    std::cout << "  functions.clear();\n";
    std::cout << "  globals.clear();\n";
    std::cout << "  exports.clear();\n";
    std::cout << "  relooperBlocks.clear();\n";
    functionTypes.clear();
    expressions.clear();
    functions.clear();
    globals.clear();
    exports.clear();
    relooperBlocks.clear();
  }

  delete (Module*)module;
}

// Function types

BinaryenFunctionTypeRef BinaryenAddFunctionType(BinaryenModuleRef module, const char* name, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams) {
  auto* wasm = (Module*)module;
  auto* ret = new FunctionType;
  if (name) ret->name = name;
  else ret->name = Name::fromInt(wasm->functionTypes.size());
  ret->result = Type(result);
  for (BinaryenIndex i = 0; i < numParams; i++) {
    ret->params.push_back(Type(paramTypes[i]));
  }

  // Lock. This can be called from multiple threads at once, and is a
  // point where they all access and modify the module.
  {
    std::lock_guard<std::mutex> lock(BinaryenFunctionTypeMutex);
    wasm->addFunctionType(ret);
  }

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenType paramTypes[] = { ";
    for (BinaryenIndex i = 0; i < numParams; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << paramTypes[i];
    }
    if (numParams == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    size_t id = functionTypes.size();
    std::cout << "    functionTypes[" << id << "] = BinaryenAddFunctionType(the_module, ";
    functionTypes[ret] = id;
    traceNameOrNULL(name);
    std::cout << ", " << result << ", paramTypes, " << numParams << ");\n";
    std::cout << "  }\n";
  }

  return ret;
}
void BinaryenRemoveFunctionType(BinaryenModuleRef module, const char* name) {
  if (tracing) {
    std::cout << "  BinaryenRemoveFunctionType(the_module, ";
    traceNameOrNULL(name);
    std::cout << ");\n";
  }

  auto* wasm = (Module*)module;
  assert(name != NULL);

  // Lock. This can be called from multiple threads at once, and is a
  // point where they all access and modify the module.
  {
    std::lock_guard<std::mutex> lock(BinaryenFunctionTypeMutex);
    wasm->removeFunctionType(name);
  }
}

BinaryenLiteral BinaryenLiteralInt32(int32_t x) { return toBinaryenLiteral(Literal(x)); }
BinaryenLiteral BinaryenLiteralInt64(int64_t x) { return toBinaryenLiteral(Literal(x)); }
BinaryenLiteral BinaryenLiteralFloat32(float x) { return toBinaryenLiteral(Literal(x)); }
BinaryenLiteral BinaryenLiteralFloat64(double x) { return toBinaryenLiteral(Literal(x)); }
BinaryenLiteral BinaryenLiteralFloat32Bits(int32_t x) { return toBinaryenLiteral(Literal(x).castToF32()); }
BinaryenLiteral BinaryenLiteralFloat64Bits(int64_t x) { return toBinaryenLiteral(Literal(x).castToF64()); }

// Expressions

BinaryenOp BinaryenClzInt32(void) { return ClzInt32; }
BinaryenOp BinaryenCtzInt32(void) { return CtzInt32; }
BinaryenOp BinaryenPopcntInt32(void) { return PopcntInt32; }
BinaryenOp BinaryenNegFloat32(void) { return NegFloat32; }
BinaryenOp BinaryenAbsFloat32(void) { return AbsFloat32; }
BinaryenOp BinaryenCeilFloat32(void) { return CeilFloat32; }
BinaryenOp BinaryenFloorFloat32(void) { return FloorFloat32; }
BinaryenOp BinaryenTruncFloat32(void) { return TruncFloat32; }
BinaryenOp BinaryenNearestFloat32(void) { return NearestFloat32; }
BinaryenOp BinaryenSqrtFloat32(void) { return SqrtFloat32; }
BinaryenOp BinaryenEqZInt32(void) { return EqZInt32; }
BinaryenOp BinaryenClzInt64(void) { return ClzInt64; }
BinaryenOp BinaryenCtzInt64(void) { return CtzInt64; }
BinaryenOp BinaryenPopcntInt64(void) { return PopcntInt64; }
BinaryenOp BinaryenNegFloat64(void) { return NegFloat64; }
BinaryenOp BinaryenAbsFloat64(void) { return AbsFloat64; }
BinaryenOp BinaryenCeilFloat64(void) { return CeilFloat64; }
BinaryenOp BinaryenFloorFloat64(void) { return FloorFloat64; }
BinaryenOp BinaryenTruncFloat64(void) { return TruncFloat64; }
BinaryenOp BinaryenNearestFloat64(void) { return NearestFloat64; }
BinaryenOp BinaryenSqrtFloat64(void) { return SqrtFloat64; }
BinaryenOp BinaryenEqZInt64(void) { return EqZInt64; }
BinaryenOp BinaryenExtendSInt32(void) { return ExtendSInt32; }
BinaryenOp BinaryenExtendUInt32(void) { return ExtendUInt32; }
BinaryenOp BinaryenWrapInt64(void) { return WrapInt64; }
BinaryenOp BinaryenTruncSFloat32ToInt32(void) { return TruncSFloat32ToInt32; }
BinaryenOp BinaryenTruncSFloat32ToInt64(void) { return TruncSFloat32ToInt64; }
BinaryenOp BinaryenTruncUFloat32ToInt32(void) { return TruncUFloat32ToInt32; }
BinaryenOp BinaryenTruncUFloat32ToInt64(void) { return TruncUFloat32ToInt64; }
BinaryenOp BinaryenTruncSFloat64ToInt32(void) { return TruncSFloat64ToInt32; }
BinaryenOp BinaryenTruncSFloat64ToInt64(void) { return TruncSFloat64ToInt64; }
BinaryenOp BinaryenTruncUFloat64ToInt32(void) { return TruncUFloat64ToInt32; }
BinaryenOp BinaryenTruncUFloat64ToInt64(void) { return TruncUFloat64ToInt64; }
BinaryenOp BinaryenReinterpretFloat32(void) { return ReinterpretFloat32; }
BinaryenOp BinaryenReinterpretFloat64(void) { return ReinterpretFloat64; }
BinaryenOp BinaryenExtendS8Int32(void) { return ExtendS8Int32; }
BinaryenOp BinaryenExtendS16Int32(void) { return ExtendS16Int32; }
BinaryenOp BinaryenExtendS8Int64(void) { return ExtendS8Int64; }
BinaryenOp BinaryenExtendS16Int64(void) { return ExtendS16Int64; }
BinaryenOp BinaryenExtendS32Int64(void) { return ExtendS32Int64; }
BinaryenOp BinaryenConvertSInt32ToFloat32(void) { return ConvertSInt32ToFloat32; }
BinaryenOp BinaryenConvertSInt32ToFloat64(void) { return ConvertSInt32ToFloat64; }
BinaryenOp BinaryenConvertUInt32ToFloat32(void) { return ConvertUInt32ToFloat32; }
BinaryenOp BinaryenConvertUInt32ToFloat64(void) { return ConvertUInt32ToFloat64; }
BinaryenOp BinaryenConvertSInt64ToFloat32(void) { return ConvertSInt64ToFloat32; }
BinaryenOp BinaryenConvertSInt64ToFloat64(void) { return ConvertSInt64ToFloat64; }
BinaryenOp BinaryenConvertUInt64ToFloat32(void) { return ConvertUInt64ToFloat32; }
BinaryenOp BinaryenConvertUInt64ToFloat64(void) { return ConvertUInt64ToFloat64; }
BinaryenOp BinaryenPromoteFloat32(void) { return PromoteFloat32; }
BinaryenOp BinaryenDemoteFloat64(void) { return DemoteFloat64; }
BinaryenOp BinaryenReinterpretInt32(void) { return ReinterpretInt32; }
BinaryenOp BinaryenReinterpretInt64(void) { return ReinterpretInt64; }
BinaryenOp BinaryenAddInt32(void) { return AddInt32; }
BinaryenOp BinaryenSubInt32(void) { return SubInt32; }
BinaryenOp BinaryenMulInt32(void) { return MulInt32; }
BinaryenOp BinaryenDivSInt32(void) { return DivSInt32; }
BinaryenOp BinaryenDivUInt32(void) { return DivUInt32; }
BinaryenOp BinaryenRemSInt32(void) { return RemSInt32; }
BinaryenOp BinaryenRemUInt32(void) { return RemUInt32; }
BinaryenOp BinaryenAndInt32(void) { return AndInt32; }
BinaryenOp BinaryenOrInt32(void) { return OrInt32; }
BinaryenOp BinaryenXorInt32(void) { return XorInt32; }
BinaryenOp BinaryenShlInt32(void) { return ShlInt32; }
BinaryenOp BinaryenShrUInt32(void) { return ShrUInt32; }
BinaryenOp BinaryenShrSInt32(void) { return ShrSInt32; }
BinaryenOp BinaryenRotLInt32(void) { return RotLInt32; }
BinaryenOp BinaryenRotRInt32(void) { return RotRInt32; }
BinaryenOp BinaryenEqInt32(void) { return EqInt32; }
BinaryenOp BinaryenNeInt32(void) { return NeInt32; }
BinaryenOp BinaryenLtSInt32(void) { return LtSInt32; }
BinaryenOp BinaryenLtUInt32(void) { return LtUInt32; }
BinaryenOp BinaryenLeSInt32(void) { return LeSInt32; }
BinaryenOp BinaryenLeUInt32(void) { return LeUInt32; }
BinaryenOp BinaryenGtSInt32(void) { return GtSInt32; }
BinaryenOp BinaryenGtUInt32(void) { return GtUInt32; }
BinaryenOp BinaryenGeSInt32(void) { return GeSInt32; }
BinaryenOp BinaryenGeUInt32(void) { return GeUInt32; }
BinaryenOp BinaryenAddInt64(void) { return AddInt64; }
BinaryenOp BinaryenSubInt64(void) { return SubInt64; }
BinaryenOp BinaryenMulInt64(void) { return MulInt64; }
BinaryenOp BinaryenDivSInt64(void) { return DivSInt64; }
BinaryenOp BinaryenDivUInt64(void) { return DivUInt64; }
BinaryenOp BinaryenRemSInt64(void) { return RemSInt64; }
BinaryenOp BinaryenRemUInt64(void) { return RemUInt64; }
BinaryenOp BinaryenAndInt64(void) { return AndInt64; }
BinaryenOp BinaryenOrInt64(void) { return OrInt64; }
BinaryenOp BinaryenXorInt64(void) { return XorInt64; }
BinaryenOp BinaryenShlInt64(void) { return ShlInt64; }
BinaryenOp BinaryenShrUInt64(void) { return ShrUInt64; }
BinaryenOp BinaryenShrSInt64(void) { return ShrSInt64; }
BinaryenOp BinaryenRotLInt64(void) { return RotLInt64; }
BinaryenOp BinaryenRotRInt64(void) { return RotRInt64; }
BinaryenOp BinaryenEqInt64(void) { return EqInt64; }
BinaryenOp BinaryenNeInt64(void) { return NeInt64; }
BinaryenOp BinaryenLtSInt64(void) { return LtSInt64; }
BinaryenOp BinaryenLtUInt64(void) { return LtUInt64; }
BinaryenOp BinaryenLeSInt64(void) { return LeSInt64; }
BinaryenOp BinaryenLeUInt64(void) { return LeUInt64; }
BinaryenOp BinaryenGtSInt64(void) { return GtSInt64; }
BinaryenOp BinaryenGtUInt64(void) { return GtUInt64; }
BinaryenOp BinaryenGeSInt64(void) { return GeSInt64; }
BinaryenOp BinaryenGeUInt64(void) { return GeUInt64; }
BinaryenOp BinaryenAddFloat32(void) { return AddFloat32; }
BinaryenOp BinaryenSubFloat32(void) { return SubFloat32; }
BinaryenOp BinaryenMulFloat32(void) { return MulFloat32; }
BinaryenOp BinaryenDivFloat32(void) { return DivFloat32; }
BinaryenOp BinaryenCopySignFloat32(void) { return CopySignFloat32; }
BinaryenOp BinaryenMinFloat32(void) { return MinFloat32; }
BinaryenOp BinaryenMaxFloat32(void) { return MaxFloat32; }
BinaryenOp BinaryenEqFloat32(void) { return EqFloat32; }
BinaryenOp BinaryenNeFloat32(void) { return NeFloat32; }
BinaryenOp BinaryenLtFloat32(void) { return LtFloat32; }
BinaryenOp BinaryenLeFloat32(void) { return LeFloat32; }
BinaryenOp BinaryenGtFloat32(void) { return GtFloat32; }
BinaryenOp BinaryenGeFloat32(void) { return GeFloat32; }
BinaryenOp BinaryenAddFloat64(void) { return AddFloat64; }
BinaryenOp BinaryenSubFloat64(void) { return SubFloat64; }
BinaryenOp BinaryenMulFloat64(void) { return MulFloat64; }
BinaryenOp BinaryenDivFloat64(void) { return DivFloat64; }
BinaryenOp BinaryenCopySignFloat64(void) { return CopySignFloat64; }
BinaryenOp BinaryenMinFloat64(void) { return MinFloat64; }
BinaryenOp BinaryenMaxFloat64(void) { return MaxFloat64; }
BinaryenOp BinaryenEqFloat64(void) { return EqFloat64; }
BinaryenOp BinaryenNeFloat64(void) { return NeFloat64; }
BinaryenOp BinaryenLtFloat64(void) { return LtFloat64; }
BinaryenOp BinaryenLeFloat64(void) { return LeFloat64; }
BinaryenOp BinaryenGtFloat64(void) { return GtFloat64; }
BinaryenOp BinaryenGeFloat64(void) { return GeFloat64; }
BinaryenOp BinaryenCurrentMemory(void) { return CurrentMemory; }
BinaryenOp BinaryenGrowMemory(void) { return GrowMemory; }
BinaryenOp BinaryenAtomicRMWAdd(void) { return AtomicRMWOp::Add; }
BinaryenOp BinaryenAtomicRMWSub(void) { return AtomicRMWOp::Sub; }
BinaryenOp BinaryenAtomicRMWAnd(void) { return AtomicRMWOp::And; }
BinaryenOp BinaryenAtomicRMWOr(void) { return AtomicRMWOp::Or; }
BinaryenOp BinaryenAtomicRMWXor(void) { return AtomicRMWOp::Xor; }
BinaryenOp BinaryenAtomicRMWXchg(void) { return AtomicRMWOp::Xchg; }

BinaryenExpressionRef BinaryenBlock(BinaryenModuleRef module, const char* name, BinaryenExpressionRef* children, BinaryenIndex numChildren, BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<Block>();
  if (name) ret->name = name;
  for (BinaryenIndex i = 0; i < numChildren; i++) {
    ret->list.push_back((Expression*)children[i]);
  }
  if (type != BinaryenTypeAuto()) ret->finalize(Type(type));
  else ret->finalize();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef children[] = { ";
    for (BinaryenIndex i = 0; i < numChildren; i++) {
      if (i > 0) std::cout << ", ";
      if (i % 6 == 5) std::cout << "\n       "; // don't create hugely long lines
      std::cout << "expressions[" << expressions[children[i]] << "]";
    }
    if (numChildren == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    auto id = noteExpression(ret);
    std::cout << "    expressions[" << id << "] = BinaryenBlock(the_module, ";
    traceNameOrNULL(name);
    std::cout << ", children, " << numChildren << ", ";
    if (type == BinaryenTypeAuto()) std::cout << "BinaryenTypeAuto()";
    else std::cout << type;
    std::cout <<  ");\n";
    std::cout << "  }\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenIf(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse) {
  auto* ret = ((Module*)module)->allocator.alloc<If>();
  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  ret->finalize();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "    expressions[" << id << "] = BinaryenIf(the_module, expressions[" << expressions[condition] << "], expressions[" << expressions[ifTrue] << "], expressions[" << expressions[ifFalse] << "]);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module, const char* name, BinaryenExpressionRef body) {
  auto* ret = Builder(*((Module*)module)).makeLoop(name ? Name(name) : Name(), (Expression*)body);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "    expressions[" << id << "] = BinaryenLoop(the_module, ";
    traceNameOrNULL(name);
    std::cout << ", expressions[" << expressions[body] << "]);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenBreak(BinaryenModuleRef module, const char* name, BinaryenExpressionRef condition, BinaryenExpressionRef value) {
  auto* ret = Builder(*((Module*)module)).makeBreak(name, (Expression*)value, (Expression*)condition);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "    expressions[" << id << "] = BinaryenBreak(the_module, \"" << name << "\", expressions[" << expressions[condition] << "], expressions[" << expressions[value] << "]);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSwitch(BinaryenModuleRef module, const char** names, BinaryenIndex numNames, const char* defaultName, BinaryenExpressionRef condition, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<Switch>();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char* names[] = { ";
    for (BinaryenIndex i = 0; i < numNames; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "\"" << names[i] << "\"";
    }
    if (numNames == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    auto id = noteExpression(ret);
    std::cout << "    expressions[" << id << "] = BinaryenSwitch(the_module, names, " << numNames << ", \"" << defaultName << "\", expressions[" << expressions[condition] << "], expressions[" << expressions[value] << "]);\n";
    std::cout << "  }\n";
  }

  for (BinaryenIndex i = 0; i < numNames; i++) {
    ret->targets.push_back(names[i]);
  }
  ret->default_ = defaultName;
  ret->condition = (Expression*)condition;
  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module, const char* target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenType returnType) {
  auto* ret = ((Module*)module)->allocator.alloc<Call>();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef operands[] = { ";
    for (BinaryenIndex i = 0; i < numOperands; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "expressions[" << expressions[operands[i]] << "]";
    }
    if (numOperands == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    auto id = noteExpression(ret);
    std::cout << "    expressions[" << id << "] = BinaryenCall(the_module, \"" << target << "\", operands, " << numOperands << ", " << returnType << ");\n";
    std::cout << "  }\n";
  }

  ret->target = target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->type = Type(returnType);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenCallIndirect(BinaryenModuleRef module, BinaryenExpressionRef target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, const char* type) {
  auto* wasm = (Module*)module;
  auto* ret = wasm->allocator.alloc<CallIndirect>();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef operands[] = { ";
    for (BinaryenIndex i = 0; i < numOperands; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "expressions[" << expressions[operands[i]] << "]";
    }
    if (numOperands == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    auto id = noteExpression(ret);
    std::cout << "    expressions[" << id << "] = BinaryenCallIndirect(the_module, expressions[" << expressions[target] << "], operands, " << numOperands << ", \"" << type << "\");\n";
    std::cout << "  }\n";
  }

  ret->target = (Expression*)target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->fullType = type;
  ret->type = wasm->getFunctionType(ret->fullType)->result;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenGetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<GetLocal>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenGetLocal(the_module, " << index << ", " << type << ");\n";
  }

  ret->index = index;
  ret->type = Type(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<SetLocal>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenSetLocal(the_module, " << index << ", expressions[" << expressions[value] << "]);\n";
  }

  ret->index = index;
  ret->value = (Expression*)value;
  ret->setTee(false);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenTeeLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<SetLocal>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenTeeLocal(the_module, " << index << ", expressions[" << expressions[value] << "]);\n";
  }

  ret->index = index;
  ret->value = (Expression*)value;
  ret->setTee(true);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenGetGlobal(BinaryenModuleRef module, const char* name, BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<GetGlobal>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenGetGlobal(the_module, \"" << name << "\", " << type << ");\n";
  }

  ret->name = name;
  ret->type = Type(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSetGlobal(BinaryenModuleRef module, const char* name, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<SetGlobal>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenSetGlobal(the_module, \"" << name << "\", expressions[" << expressions[value] << "]);\n";
  }

  ret->name = name;
  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module, uint32_t bytes, int8_t signed_, uint32_t offset, uint32_t align, BinaryenType type, BinaryenExpressionRef ptr) {
  auto* ret = ((Module*)module)->allocator.alloc<Load>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenLoad(the_module, " << bytes << ", " << int(signed_) << ", " << offset << ", " << align << ", " << type << ", expressions[" << expressions[ptr] << "]);\n";
  }
  ret->isAtomic = false;
  ret->bytes = bytes;
  ret->signed_ = !!signed_;
  ret->offset = offset;
  ret->align = align ? align : bytes;
  ret->type = Type(type);
  ret->ptr = (Expression*)ptr;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, uint32_t align, BinaryenExpressionRef ptr, BinaryenExpressionRef value, BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<Store>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenStore(the_module, " << bytes << ", " << offset << ", " << align << ", expressions[" << expressions[ptr] << "], expressions[" << expressions[value] << "], " << type << ");\n";
  }
  ret->isAtomic = false;
  ret->bytes = bytes;
  ret->offset = offset;
  ret->align = align ? align : bytes;
  ret->ptr = (Expression*)ptr;
  ret->value = (Expression*)value;
  ret->valueType = Type(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module, BinaryenLiteral value) {
  auto* ret = Builder(*((Module*)module)).makeConst(fromBinaryenLiteral(value));
  if (tracing) {
    auto id = noteExpression(ret);
    switch (value.type) {
      case Type::i32: std::cout << "  expressions[" << id << "] = BinaryenConst(the_module, BinaryenLiteralInt32(" << value.i32 << "));\n"; break;
      case Type::i64: std::cout << "  expressions[" << id << "] = BinaryenConst(the_module, BinaryenLiteralInt64(" << value.i64 << "));\n"; break;
      case Type::f32: {
        std::cout << "  expressions[" << id << "] = BinaryenConst(the_module, BinaryenLiteralFloat32(";
        if (std::isnan(value.f32)) std::cout << "NAN";
        else std::cout << value.f32;
        std::cout << "));\n";
        break;
      }
      case Type::f64: {
        std::cout << "  expressions[" << id << "] = BinaryenConst(the_module, BinaryenLiteralFloat64(";
        if (std::isnan(value.f64)) std::cout << "NAN";
        else std::cout << value.f64;
        std::cout << "));\n";
        break;
      }
      default: WASM_UNREACHABLE();
    }
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef value) {
  auto* ret = Builder(*((Module*)module)).makeUnary(UnaryOp(op), (Expression*)value);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenUnary(the_module, " << op << ", expressions[" << expressions[value] << "]);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef left, BinaryenExpressionRef right) {
  auto* ret = Builder(*((Module*)module)).makeBinary(BinaryOp(op), (Expression*)left, (Expression*)right);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenBinary(the_module, " << op << ", expressions[" << expressions[left] << "], expressions[" << expressions[right] << "]);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSelect(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse) {
  auto* ret = ((Module*)module)->allocator.alloc<Select>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenSelect(the_module, expressions[" << expressions[condition] << "], expressions[" << expressions[ifTrue] << "], expressions[" << expressions[ifFalse] << "]);\n";
  }

  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenDrop(BinaryenModuleRef module, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<Drop>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenDrop(the_module, expressions[" << expressions[value] << "]);\n";
  }

  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module, BinaryenExpressionRef value) {
  auto* ret = Builder(*((Module*)module)).makeReturn((Expression*)value);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenReturn(the_module, expressions[" << expressions[value] << "]);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module, BinaryenOp op, const char* name, BinaryenExpressionRef* operands, BinaryenIndex numOperands) {
  auto* ret = ((Module*)module)->allocator.alloc<Host>();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef operands[] = { ";
    for (BinaryenIndex i = 0; i < numOperands; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "expressions[" << expressions[operands[i]] << "]";
    }
    if (numOperands == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenHost(the_module, " << op << ", \"" << name << "\", operands, " << numOperands << ");\n";
    std::cout << "  }\n";
  }

  ret->op = HostOp(op);
  if (name) ret->nameOperand = name;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenNop(BinaryenModuleRef module) {
  auto* ret = ((Module*)module)->allocator.alloc<Nop>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenNop(the_module);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenUnreachable(BinaryenModuleRef module) {
  auto* ret = ((Module*)module)->allocator.alloc<Unreachable>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenUnreachable(the_module);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicLoad(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, BinaryenType type, BinaryenExpressionRef ptr) {
  auto* ret = Builder(*((Module*)module)).makeAtomicLoad(bytes, offset, (Expression*)ptr, Type(type));

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenAtomicLoad(the_module, " << bytes << ", " << offset << ", " << type << ", expressions[" << expressions[ptr] << "]);\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicStore(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, BinaryenExpressionRef ptr, BinaryenExpressionRef value, BinaryenType type) {
  auto* ret = Builder(*((Module*)module)).makeAtomicStore(bytes, offset, (Expression*)ptr, (Expression*)value, Type(type));

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenAtomicStore(the_module, " << bytes << ", " << offset << ", expressions[" << expressions[ptr] << "], expressions[" << expressions[value] << "], " << type << ");\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicRMW(BinaryenModuleRef module, BinaryenOp op, BinaryenIndex bytes, BinaryenIndex offset, BinaryenExpressionRef ptr, BinaryenExpressionRef value, BinaryenType type) {
  auto* ret = Builder(*((Module*)module)).makeAtomicRMW(AtomicRMWOp(op), bytes, offset, (Expression*)ptr, (Expression*)value, Type(type));

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenAtomicRMW(the_module, " << op << ", " << bytes << ", " << offset << ", expressions[" << expressions[ptr] << "], expressions[" << expressions[value] << "], " << type << ");\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicCmpxchg(BinaryenModuleRef module, BinaryenIndex bytes, BinaryenIndex offset, BinaryenExpressionRef ptr, BinaryenExpressionRef expected, BinaryenExpressionRef replacement, BinaryenType type) {
  auto* ret = Builder(*((Module*)module)).makeAtomicCmpxchg(bytes, offset, (Expression*)ptr, (Expression*)expected, (Expression*)replacement, Type(type));

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenAtomicCmpxchg(the_module, " << bytes << ", " << offset << ", expressions[" << expressions[ptr] << "], expressions[" << expressions[expected] << "], expressions[" << expressions[replacement] << "], " << type << ");\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicWait(BinaryenModuleRef module, BinaryenExpressionRef ptr, BinaryenExpressionRef expected, BinaryenExpressionRef timeout, BinaryenType expectedType) {
  auto* ret = Builder(*((Module*)module)).makeAtomicWait((Expression*)ptr, (Expression*)expected, (Expression*)timeout, Type(expectedType), 0);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenAtomicWait(the_module, expressions[" << expressions[ptr] << "], expressions[" << expressions[expected] << "], expressions[" << expressions[timeout] << "], " << expectedType << ");\n";
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicWake(BinaryenModuleRef module, BinaryenExpressionRef ptr, BinaryenExpressionRef wakeCount) {
  auto* ret = Builder(*((Module*)module)).makeAtomicWake((Expression*)ptr, (Expression*)wakeCount, 0);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenAtomicWake(the_module, expressions[" << expressions[ptr] << "], expressions[" << expressions[wakeCount] << "]);\n";
  }

  return static_cast<Expression*>(ret);
}

// Expression utility

BinaryenExpressionId BinaryenExpressionGetId(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionGetId(expressions[" << expressions[expr] << "]);\n";
  }

  return ((Expression*)expr)->_id;
}
BinaryenType BinaryenExpressionGetType(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionGetType(expressions[" << expressions[expr] << "]);\n";
  }

  return ((Expression*)expr)->type;
}
void BinaryenExpressionPrint(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionPrint(expressions[" << expressions[expr] << "]);\n";
  }

  WasmPrinter::printExpression((Expression*)expr, std::cout);
  std::cout << '\n';
}

// Specific expression utility

// Block
const char* BinaryenBlockGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBlockGetName(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->name.c_str();
}
BinaryenIndex BinaryenBlockGetNumChildren(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBlockGetNumChildren(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->list.size();
}
BinaryenExpressionRef BinaryenBlockGetChild(BinaryenExpressionRef expr, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenBlockGetChild(expressions[" << expressions[expr] << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  assert(index < static_cast<Block*>(expression)->list.size());
  return static_cast<Block*>(expression)->list[index];
}
// If
BinaryenExpressionRef BinaryenIfGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetCondition(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->condition;
}
BinaryenExpressionRef BinaryenIfGetIfTrue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetIfTrue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->ifTrue;
}
BinaryenExpressionRef BinaryenIfGetIfFalse(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetIfFalse(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->ifFalse;
}
// Loop
const char* BinaryenLoopGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoopGetName(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  return static_cast<Loop*>(expression)->name.c_str();
}
BinaryenExpressionRef BinaryenLoopGetBody(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoopGetBody(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  return static_cast<Loop*>(expression)->body;
}
// Break
const char* BinaryenBreakGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetName(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->name.c_str();
}
BinaryenExpressionRef BinaryenBreakGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetCondition(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->condition;
}
BinaryenExpressionRef BinaryenBreakGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->value;
}
// Switch
BinaryenIndex BinaryenSwitchGetNumNames(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetNumNames(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->targets.size();
}
const char* BinaryenSwitchGetName(BinaryenExpressionRef expr, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetName(expressions[" << expressions[expr] << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  assert(index < static_cast<Switch*>(expression)->targets.size());
  return static_cast<Switch*>(expression)->targets[index].c_str();
}
const char* BinaryenSwitchGetDefaultName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetDefaultName(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->default_.c_str();
}
BinaryenExpressionRef BinaryenSwitchGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetCondition(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->condition;
}
BinaryenExpressionRef BinaryenSwitchGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->value;
}
// Call
const char* BinaryenCallGetTarget(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallGetTarget(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->target.c_str();
}
BinaryenIndex BinaryenCallGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallGetNumOperands(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenCallGetOperand(BinaryenExpressionRef expr, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenCallGetOperand(expressions[" << expressions[expr] << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(index < static_cast<Call*>(expression)->operands.size());
  return static_cast<Call*>(expression)->operands[index];
}
// CallIndirect
BinaryenExpressionRef BinaryenCallIndirectGetTarget(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallIndirectGetTarget(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->target;
}
BinaryenIndex BinaryenCallIndirectGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallIndirectGetNumOperands(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenCallIndirectGetOperand(BinaryenExpressionRef expr, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenCallIndirectGetOperand(expressions[" << expressions[expr] << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  assert(index < static_cast<CallIndirect*>(expression)->operands.size());
  return static_cast<CallIndirect*>(expression)->operands[index];
}
// GetLocal
BinaryenIndex BinaryenGetLocalGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenGetLocalGetIndex(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<GetLocal>());
  return static_cast<GetLocal*>(expression)->index;
}
// SetLocal
int BinaryenSetLocalIsTee(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSetLocalIsTee(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SetLocal>());
  return static_cast<SetLocal*>(expression)->isTee();
}
BinaryenIndex BinaryenSetLocalGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSetLocalGetIndex(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SetLocal>());
  return static_cast<SetLocal*>(expression)->index;
}
BinaryenExpressionRef BinaryenSetLocalGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSetLocalGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SetLocal>());
  return static_cast<SetLocal*>(expression)->value;
}
// GetGlobal
const char* BinaryenGetGlobalGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenGetGlobalGetName(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<GetGlobal>());
  return static_cast<GetGlobal*>(expression)->name.c_str();
}
// SetGlobal
const char* BinaryenSetGlobalGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSetGlobalGetName(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SetGlobal>());
  return static_cast<SetGlobal*>(expression)->name.c_str();
}
BinaryenExpressionRef BinaryenSetGlobalGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSetGlobalGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SetGlobal>());
  return static_cast<SetGlobal*>(expression)->value;
}
// Host
BinaryenOp BinaryenHostGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetOp(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->op;
}
const char* BinaryenHostGetNameOperand(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetNameOperand(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->nameOperand.c_str();
}
BinaryenIndex BinaryenHostGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetNumOperands(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenHostGetOperand(BinaryenExpressionRef expr, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenHostGetOperand(expressions[" << expressions[expr] << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(index < static_cast<Host*>(expression)->operands.size());
  return static_cast<Host*>(expression)->operands[index];
}
// Load
int BinaryenLoadIsAtomic(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadIsAtomic(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->isAtomic;
}
int BinaryenLoadIsSigned(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadIsSigned(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->signed_;
}
uint32_t BinaryenLoadGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetBytes(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->bytes;
}
uint32_t BinaryenLoadGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetOffset(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->offset;
}
uint32_t BinaryenLoadGetAlign(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetAlign(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->align;
}
BinaryenExpressionRef BinaryenLoadGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetPtr(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->ptr;
}
// Store
int BinaryenStoreIsAtomic(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreIsAtomic(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->isAtomic;
}
uint32_t BinaryenStoreGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetBytes(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->bytes;
}
uint32_t BinaryenStoreGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetOffset(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->offset;
}
uint32_t BinaryenStoreGetAlign(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetAlign(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->align;
}
BinaryenExpressionRef BinaryenStoreGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetPtr(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->ptr;
}
BinaryenExpressionRef BinaryenStoreGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->value;
}
// Const
int32_t BinaryenConstGetValueI32(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI32(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.geti32();
}
int64_t BinaryenConstGetValueI64(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.geti64();
}
int32_t BinaryenConstGetValueI64Low(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64Low(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return (int32_t)(static_cast<Const*>(expression)->value.geti64() & 0xffffffff);
}
int32_t BinaryenConstGetValueI64High(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64High(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return (int32_t)(static_cast<Const*>(expression)->value.geti64() >> 32);
}
float BinaryenConstGetValueF32(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueF32(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.getf32();
}
double BinaryenConstGetValueF64(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueF64(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.getf64();
}
// Unary
BinaryenOp BinaryenUnaryGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenUnaryGetOp(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  return static_cast<Unary*>(expression)->op;
}
BinaryenExpressionRef BinaryenUnaryGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenUnaryGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  return static_cast<Unary*>(expression)->value;
}
// Binary
BinaryenOp BinaryenBinaryGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetOp(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->op;
}
BinaryenExpressionRef BinaryenBinaryGetLeft(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetLeft(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->left;
}
BinaryenExpressionRef BinaryenBinaryGetRight(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetRight(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->right;
}
// Select
BinaryenExpressionRef BinaryenSelectGetIfTrue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetIfTrue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->ifTrue;
}
BinaryenExpressionRef BinaryenSelectGetIfFalse(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetIfFalse(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->ifFalse;
}
BinaryenExpressionRef BinaryenSelectGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetCondition(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->condition;
}
// Drop
BinaryenExpressionRef BinaryenDropGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenDropGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Drop>());
  return static_cast<Drop*>(expression)->value;
}
// Return
BinaryenExpressionRef BinaryenReturnGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenReturnGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Return>());
  return static_cast<Return*>(expression)->value;
}
// AtomicRMW
BinaryenOp BinaryenAtomicRMWGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetOp(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->op;
}
uint32_t BinaryenAtomicRMWGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetBytes(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->bytes;
}
uint32_t BinaryenAtomicRMWGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetOffset(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->offset;
}
BinaryenExpressionRef BinaryenAtomicRMWGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetPtr(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->ptr;
}
BinaryenExpressionRef BinaryenAtomicRMWGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetValue(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->value;
}
// AtomicCmpxchg
uint32_t BinaryenAtomicCmpxchgGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetBytes(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->bytes;
}
uint32_t BinaryenAtomicCmpxchgGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetOffset(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->offset;
}
BinaryenExpressionRef BinaryenAtomicCmpxchgGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetPtr(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->ptr;
}
BinaryenExpressionRef BinaryenAtomicCmpxchgGetExpected(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetExpected(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->expected;
}
BinaryenExpressionRef BinaryenAtomicCmpxchgGetReplacement(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetReplacement(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->replacement;
}
// AtomicWait
BinaryenExpressionRef BinaryenAtomicWaitGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetPtr(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->ptr;
}
BinaryenExpressionRef BinaryenAtomicWaitGetExpected(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetExpected(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->expected;
}
BinaryenExpressionRef BinaryenAtomicWaitGetTimeout(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetTimeout(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->timeout;
}
BinaryenType BinaryenAtomicWaitGetExpectedType(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetExpectedType(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->expectedType;
}
// AtomicWake
BinaryenExpressionRef BinaryenAtomicWakeGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWakeGetPtr(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWake>());
  return static_cast<AtomicWake*>(expression)->ptr;
}
BinaryenExpressionRef BinaryenAtomicWakeGetWakeCount(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWakeGetWakeCount(expressions[" << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWake>());
  return static_cast<AtomicWake*>(expression)->wakeCount;
}

// Functions

BinaryenFunctionRef BinaryenAddFunction(BinaryenModuleRef module, const char* name, BinaryenFunctionTypeRef type, BinaryenType* varTypes, BinaryenIndex numVarTypes, BinaryenExpressionRef body) {
  auto* wasm = (Module*)module;
  auto* ret = new Function;

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenType varTypes[] = { ";
    for (BinaryenIndex i = 0; i < numVarTypes; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << varTypes[i];
    }
    if (numVarTypes == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    auto id = functions.size();
    functions[ret] = id;
    std::cout << "    functions[" << id << "] = BinaryenAddFunction(the_module, \"" << name << "\", functionTypes[" << functionTypes[type] << "], varTypes, " << numVarTypes << ", expressions[" << expressions[body] << "]);\n";
    std::cout << "  }\n";
  }

  ret->name = name;
  ret->type = ((FunctionType*)type)->name;
  auto* functionType = wasm->getFunctionType(ret->type);
  ret->result = functionType->result;
  ret->params = functionType->params;
  for (BinaryenIndex i = 0; i < numVarTypes; i++) {
    ret->vars.push_back(Type(varTypes[i]));
  }
  ret->body = (Expression*)body;

  // Lock. This can be called from multiple threads at once, and is a
  // point where they all access and modify the module.
  {
    std::lock_guard<std::mutex> lock(BinaryenFunctionMutex);
    wasm->addFunction(ret);
  }

  return ret;
}
BinaryenFunctionRef BinaryenGetFunction(BinaryenModuleRef module, const char* name) {
  if (tracing) {
    std::cout << "  BinaryenGetFunction(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  return wasm->getFunction(name);
}
void BinaryenRemoveFunction(BinaryenModuleRef module, const char* name) {
  if (tracing) {
    std::cout << "  BinaryenRemoveFunction(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeFunction(name);
}

BinaryenGlobalRef BinaryenAddGlobal(BinaryenModuleRef module, const char* name, BinaryenType type, int8_t mutable_, BinaryenExpressionRef init) {
  if (tracing) {
    std::cout << "  BinaryenAddGlobal(the_module, \"" << name << "\", " << type << ", " << int(mutable_) << ", expressions[" << expressions[init] << "]);\n";
  }

  auto* wasm = (Module*)module;
  auto* ret = new Global();
  ret->name = name;
  ret->type = Type(type);
  ret->mutable_ = !!mutable_;
  ret->init = (Expression*)init;
  wasm->addGlobal(ret);
  return ret;
}
void BinaryenRemoveGlobal(BinaryenModuleRef module, const char* name) {
  if (tracing) {
    std::cout << "  BinaryenRemoveGlobal(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeGlobal(name);
}

// Imports

void BinaryenAddFunctionImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char* externalBaseName, BinaryenFunctionTypeRef functionType) {
  auto* wasm = (Module*)module;
  auto* ret = new Function();

  if (tracing) {
    std::cout << "  BinaryenAddFunctionImport(the_module, \"" << internalName << "\", \"" << externalModuleName << "\", \"" << externalBaseName << "\", functionTypes[" << functionTypes[functionType] << "]);\n";
  }

  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->type = ((FunctionType*)functionType)->name;
  FunctionTypeUtils::fillFunction(ret, (FunctionType*)functionType);
  wasm->addFunction(ret);
}
void BinaryenAddTableImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char* externalBaseName) {
  auto* wasm = (Module*)module;

  if (tracing) {
    std::cout << "  BinaryenAddTableImport(the_module, \"" << internalName << "\", \"" << externalModuleName << "\", \"" << externalBaseName << "\");\n";
  }

  wasm->table.module = externalModuleName;
  wasm->table.base = externalBaseName;
}
void BinaryenAddMemoryImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char* externalBaseName, uint8_t shared) {
  auto* wasm = (Module*)module;

  if (tracing) {
    std::cout << "  BinaryenAddMemoryImport(the_module, \"" << internalName << "\", \"" << externalModuleName << "\", \"" << externalBaseName << "\", " << int(shared) << ");\n";
  }

  wasm->memory.module = externalModuleName;
  wasm->memory.base = externalBaseName;
  wasm->memory.shared = shared;
}
void BinaryenAddGlobalImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char* externalBaseName, BinaryenType globalType) {
  auto* wasm = (Module*)module;
  auto* ret = new Global();

  if (tracing) {
    std::cout << "  BinaryenAddGlobalImport(the_module, \"" << internalName << "\", \"" << externalModuleName << "\", \"" << externalBaseName << "\", " << globalType << ");\n";
  }

  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->type = Type(globalType);
  wasm->addGlobal(ret);
}

// Exports

WASM_DEPRECATED BinaryenExportRef BinaryenAddExport(BinaryenModuleRef module, const char* internalName, const char* externalName) {
  return BinaryenAddFunctionExport(module, internalName, externalName);
}
BinaryenExportRef BinaryenAddFunctionExport(BinaryenModuleRef module, const char* internalName, const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id << "] = BinaryenAddFunctionExport(the_module, \"" << internalName << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Function;
  wasm->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddTableExport(BinaryenModuleRef module, const char* internalName, const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id << "] = BinaryenAddTableExport(the_module, \"" << internalName << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Table;
  wasm->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddMemoryExport(BinaryenModuleRef module, const char* internalName, const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id << "] = BinaryenAddMemoryExport(the_module, \"" << internalName << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Memory;
  wasm->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddGlobalExport(BinaryenModuleRef module, const char* internalName, const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id << "] = BinaryenAddGlobalExport(the_module, \"" << internalName << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Global;
  wasm->addExport(ret);
  return ret;
}
void BinaryenRemoveExport(BinaryenModuleRef module, const char* externalName) {
  if (tracing) {
    std::cout << "  BinaryenRemoveExport(the_module, \"" << externalName << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeExport(externalName);
}

// Function table. One per module

void BinaryenSetFunctionTable(BinaryenModuleRef module, BinaryenIndex initial, BinaryenIndex maximum, const char** funcNames, BinaryenIndex numFuncNames) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char* funcNames[] = { ";
    for (BinaryenIndex i = 0; i < numFuncNames; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "\"" << funcNames[i] << "\"";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenSetFunctionTable(the_module, " << initial << ", " << maximum << ", funcNames, " << numFuncNames << ");\n";
    std::cout << "  }\n";
  }

  auto* wasm = (Module*)module;
  Table::Segment segment(wasm->allocator.alloc<Const>()->set(Literal(int32_t(0))));
  for (BinaryenIndex i = 0; i < numFuncNames; i++) {
    segment.data.push_back(funcNames[i]);
  }
  wasm->table.initial = initial;
  wasm->table.max = maximum;
  wasm->table.exists = true;
  wasm->table.segments.push_back(segment);
}

// Memory. One per module

void BinaryenSetMemory(BinaryenModuleRef module, BinaryenIndex initial, BinaryenIndex maximum, const char* exportName, const char** segments, BinaryenExpressionRef* segmentOffsets, BinaryenIndex* segmentSizes, BinaryenIndex numSegments, uint8_t shared) {
  if (tracing) {
    std::cout << "  {\n";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      std::cout << "    const char segment" << i << "[] = { ";
      for (BinaryenIndex j = 0; j < segmentSizes[i]; j++) {
        if (j > 0) std::cout << ", ";
        std::cout << int(segments[i][j]);
      }
      std::cout << " };\n";
    }
    std::cout << "    const char* segments[] = { ";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "segment" << i;
    }
    if (numSegments == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    std::cout << "    BinaryenExpressionRef segmentOffsets[] = { ";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "expressions[" << expressions[segmentOffsets[i]] << "]";
    }
    if (numSegments == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    std::cout << "    BinaryenIndex segmentSizes[] = { ";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << segmentSizes[i];
    }
    if (numSegments == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    std::cout << "    BinaryenSetMemory(the_module, " << initial << ", " << maximum << ", ";
    traceNameOrNULL(exportName);
    std::cout << ", segments, segmentOffsets, segmentSizes, " << numSegments << ", " << int(shared) << ");\n";
    std::cout << "  }\n";
  }

  auto* wasm = (Module*)module;
  wasm->memory.initial = initial;
  wasm->memory.max = maximum;
  wasm->memory.exists = true;
  wasm->memory.shared = shared;
  if (exportName) {
    auto memoryExport = make_unique<Export>();
    memoryExport->name = exportName;
    memoryExport->value = Name::fromInt(0);
    memoryExport->kind = ExternalKind::Memory;
    wasm->addExport(memoryExport.release());
  }
  for (BinaryenIndex i = 0; i < numSegments; i++) {
    wasm->memory.segments.emplace_back((Expression*)segmentOffsets[i], segments[i], segmentSizes[i]);
  }
}

// Start function. One per module

void BinaryenSetStart(BinaryenModuleRef module, BinaryenFunctionRef start) {
  if (tracing) {
    std::cout << "  BinaryenSetStart(the_module, functions[" << functions[start] << "]);\n";
  }

  auto* wasm = (Module*)module;
  wasm->addStart(((Function*)start)->name);
}

//
// ========== Module Operations ==========
//

BinaryenModuleRef BinaryenModuleParse(const char* text) {
  if (tracing) {
    std::cout << "  // BinaryenModuleRead\n";
  }

  auto* wasm = new Module;
  try {
    SExpressionParser parser(const_cast<char*>(text));
    Element& root = *parser.root;
    SExpressionWasmBuilder builder(*wasm, *root[0]);
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing wasm text";
  }
  return wasm;
}

void BinaryenModulePrint(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModulePrint(the_module);\n";
  }

  WasmPrinter::printModule((Module*)module);
}

void BinaryenModulePrintAsmjs(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModulePrintAsmjs(the_module);\n";
  }

  Module* wasm = (Module*)module;
  Wasm2JSBuilder::Flags builderFlags;
  Wasm2JSBuilder wasm2js(builderFlags);
  Ref asmjs = wasm2js.processWasm(wasm);
  JSPrinter jser(true, true, asmjs);
  jser.printAst();

  std::cout << jser.buffer;
}

int BinaryenModuleValidate(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleValidate(the_module);\n";
  }

  Module* wasm = (Module*)module;
  // TODO add feature selection support to C API
  FeatureSet features = Feature::Atomics;
  return WasmValidator().validate(*wasm, features) ? 1 : 0;
}

void BinaryenModuleOptimize(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleOptimize(the_module);\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.options = globalPassOptions;
  passRunner.addDefaultOptimizationPasses();
  passRunner.run();
}

int BinaryenGetOptimizeLevel() {
  if (tracing) {
    std::cout << "  BinaryenGetOptimizeLevel();\n";
  }

  return globalPassOptions.optimizeLevel;
}

void BinaryenSetOptimizeLevel(int level) {
  if (tracing) {
    std::cout << "  BinaryenSetOptimizeLevel(" << level << ");\n";
  }

  globalPassOptions.optimizeLevel = level;
}

int BinaryenGetShrinkLevel() {
  if (tracing) {
    std::cout << "  BinaryenGetShrinkLevel();\n";
  }

  return globalPassOptions.shrinkLevel;
}

void BinaryenSetShrinkLevel(int level) {
  if (tracing) {
    std::cout << "  BinaryenSetShrinkLevel(" << level << ");\n";
  }

  globalPassOptions.shrinkLevel = level;
}

int BinaryenGetDebugInfo() {
  if (tracing) {
    std::cout << "  BinaryenGetDebugInfo();\n";
  }

  return globalPassOptions.debugInfo;
}

void BinaryenSetDebugInfo(int on) {
  if (tracing) {
    std::cout << "  BinaryenSetDebugInfo(" << on << ");\n";
  }

  globalPassOptions.debugInfo = on != 0;
}

void BinaryenModuleRunPasses(BinaryenModuleRef module, const char** passes, BinaryenIndex numPasses) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char* passes[] = { ";
    for (BinaryenIndex i = 0; i < numPasses; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "\"" << passes[i] << "\"";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenModuleRunPasses(the_module, passes, " << numPasses << ");\n";
    std::cout << "  }\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.options = globalPassOptions;
  for (BinaryenIndex i = 0; i < numPasses; i++) {
    passRunner.add(passes[i]);
  }
  passRunner.run();
}

void BinaryenModuleAutoDrop(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleAutoDrop(the_module);\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.options = globalPassOptions;
  passRunner.add<AutoDrop>();
  passRunner.run();
}

static BinaryenBufferSizes writeModule(BinaryenModuleRef module, char* output, size_t outputSize, const char* sourceMapUrl, char* sourceMap, size_t sourceMapSize) {
  Module* wasm = (Module*)module;
  BufferWithRandomAccess buffer(false);
  WasmBinaryWriter writer(wasm, buffer, false);
  writer.setNamesSection(globalPassOptions.debugInfo);
  std::ostringstream os;
  if (sourceMapUrl) {
    writer.setSourceMap(&os, sourceMapUrl);
  }
  writer.write();
  size_t bytes = std::min(buffer.size(), outputSize);
  std::copy_n(buffer.begin(), bytes, output);
  size_t sourceMapBytes = 0;
  if (sourceMapUrl) {
    auto str = os.str();
    sourceMapBytes = std::min(str.length(), sourceMapSize);
    std::copy_n(str.c_str(), sourceMapBytes, sourceMap);
  }
  return { bytes, sourceMapBytes };
}

size_t BinaryenModuleWrite(BinaryenModuleRef module, char* output, size_t outputSize) {
  if (tracing) {
    std::cout << "  // BinaryenModuleWrite\n";
  }

  return writeModule((Module*)module, output, outputSize, nullptr, nullptr, 0).outputBytes;
}

BinaryenBufferSizes BinaryenModuleWriteWithSourceMap(BinaryenModuleRef module, const char* url, char* output, size_t outputSize, char* sourceMap, size_t sourceMapSize) {
  if (tracing) {
    std::cout << "  // BinaryenModuleWriteWithSourceMap\n";
  }

  assert(url);
  assert(sourceMap);
  return writeModule((Module*)module, output, outputSize, url, sourceMap, sourceMapSize);
}

BinaryenModuleAllocateAndWriteResult BinaryenModuleAllocateAndWrite(BinaryenModuleRef module, const char* sourceMapUrl) {
  if (tracing) {
    std::cout << " // BinaryenModuleAllocateAndWrite(the_module, ";
    traceNameOrNULL(sourceMapUrl);
    std::cout << ");\n";
  }

  Module* wasm = (Module*)module;
  BufferWithRandomAccess buffer(false);
  WasmBinaryWriter writer(wasm, buffer, false);
  writer.setNamesSection(globalPassOptions.debugInfo);
  std::ostringstream os;
  if (sourceMapUrl) {
    writer.setSourceMap(&os, sourceMapUrl);
  }
  writer.write();
  void* binary = malloc(buffer.size());
  std::copy_n(buffer.begin(), buffer.size(), static_cast<char*>(binary));
  char* sourceMap = nullptr;
  if (sourceMapUrl) {
    auto str = os.str();
    sourceMap = (char*)malloc(str.length() + 1);
    std::copy_n(str.c_str(), str.length() + 1, sourceMap);
  }
  return { binary, buffer.size(), sourceMap };
}

BinaryenModuleRef BinaryenModuleRead(char* input, size_t inputSize) {
  if (tracing) {
    std::cout << "  // BinaryenModuleRead\n";
  }

  auto* wasm = new Module;
  std::vector<char> buffer(false);
  buffer.resize(inputSize);
  std::copy_n(input, inputSize, buffer.begin());
  try {
    WasmBinaryBuilder parser(*wasm, buffer, false);
    parser.read();
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing wasm binary";
  }
  return wasm;
}

void BinaryenModuleInterpret(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleInterpret(the_module);\n";
  }

  Module* wasm = (Module*)module;
  ShellExternalInterface interface;
  ModuleInstance instance(*wasm, &interface);
}

BinaryenIndex BinaryenModuleAddDebugInfoFileName(BinaryenModuleRef module, const char* filename) {
  if (tracing) {
    std::cout << "  BinaryenModuleAddDebugInfoFileName(the_module, \"" << filename << "\");\n";
  }

  Module* wasm = (Module*)module;
  BinaryenIndex index = wasm->debugInfoFileNames.size();
  wasm->debugInfoFileNames.push_back(filename);
  return index;
}

const char* BinaryenModuleGetDebugInfoFileName(BinaryenModuleRef module, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenModuleGetDebugInfoFileName(the_module, \"" << index << "\");\n";
  }

  Module* wasm = (Module*)module;
  return index < wasm->debugInfoFileNames.size() ? wasm->debugInfoFileNames.at(index).c_str() : nullptr;
}

//
// ======== FunctionType Operations ========
//

const char* BinaryenFunctionTypeGetName(BinaryenFunctionTypeRef ftype) {
  if (tracing) {
    std::cout << "  BinaryenFunctionTypeGetName(functionsTypes[" << functions[ftype] << "]);\n";
  }

  return ((FunctionType*)ftype)->name.c_str();
}
BinaryenIndex BinaryenFunctionTypeGetNumParams(BinaryenFunctionTypeRef ftype) {
  if (tracing) {
    std::cout << "  BinaryenFunctionTypeGetNumParams(functionsTypes[" << functions[ftype] << "]);\n";
  }

  return ((FunctionType*)ftype)->params.size();
}
BinaryenType BinaryenFunctionTypeGetParam(BinaryenFunctionTypeRef ftype, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenFunctionTypeGetParam(functionsTypes[" << functions[ftype] << "], " << index << ");\n";
  }

  auto* ft = (FunctionType*)ftype;
  assert(index < ft->params.size());
  return ft->params[index];
}
BinaryenType BinaryenFunctionTypeGetResult(BinaryenFunctionTypeRef ftype) {
  if (tracing) {
    std::cout << "  BinaryenFunctionTypeGetResult(functionsTypes[" << functions[ftype] << "]);\n";
  }

  return ((FunctionType*)ftype)->result;
}

//
// ========== Function Operations ==========
//

const char* BinaryenFunctionGetName(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetName(functions[" << functions[func] << "]);\n";
  }

  return ((Function*)func)->name.c_str();
}
const char* BinaryenFunctionGetType(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetType(functions[" << functions[func] << "]);\n";
  }

  return ((Function*)func)->type.c_str();
}
BinaryenIndex BinaryenFunctionGetNumParams(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetNumParams(functions[" << functions[func] << "]);\n";
  }

  return ((Function*)func)->params.size();
}
BinaryenType BinaryenFunctionGetParam(BinaryenFunctionRef func, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetParam(functions[" << functions[func] << "], " << index << ");\n";
  }

  auto* fn = (Function*)func;
  assert(index < fn->params.size());
  return fn->params[index];
}
BinaryenType BinaryenFunctionGetResult(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetResult(functions[" << functions[func] << "]);\n";
  }

  return ((Function*)func)->result;
}
BinaryenIndex BinaryenFunctionGetNumVars(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetNumVars(functions[" << functions[func] << "]);\n";
  }

  return ((Function*)func)->vars.size();
}
BinaryenType BinaryenFunctionGetVar(BinaryenFunctionRef func, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetVar(functions[" << functions[func] << "], " << index << ");\n";
  }

  auto* fn = (Function*)func;
  assert(index < fn->vars.size());
  return fn->vars[index];
}
BinaryenExpressionRef BinaryenFunctionGetBody(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetBody(functions[" << functions[func] << "]);\n";
  }

  return ((Function*)func)->body;
}
void BinaryenFunctionOptimize(BinaryenFunctionRef func, BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenFunctionOptimize(functions[" << functions[func] << "], the_module);\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.options = globalPassOptions;
  passRunner.addDefaultOptimizationPasses();
  passRunner.runOnFunction((Function*)func);
}
void BinaryenFunctionRunPasses(BinaryenFunctionRef func, BinaryenModuleRef module, const char** passes, BinaryenIndex numPasses) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char* passes[] = { ";
    for (BinaryenIndex i = 0; i < numPasses; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "\"" << passes[i] << "\"";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenFunctionRunPasses(functions[" << functions[func] << ", the_module, passes, " << numPasses << ");\n";
    std::cout << "  }\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.options = globalPassOptions;
  for (BinaryenIndex i = 0; i < numPasses; i++) {
    passRunner.add(passes[i]);
  }
  passRunner.runOnFunction((Function*)func);
}
void BinaryenFunctionSetDebugLocation(BinaryenFunctionRef func, BinaryenExpressionRef expr, BinaryenIndex fileIndex, BinaryenIndex lineNumber, BinaryenIndex columnNumber) {
  if (tracing) {
    std::cout << "  BinaryenFunctionSetDebugLocation(functions[" << functions[func] << "], expressions[" << expressions[expr] << "], " << fileIndex << ", " << lineNumber << ", " << columnNumber << ");\n";
  }

  auto* fn = (Function*)func;
  auto* ex = (Expression*)expr;

  Function::DebugLocation loc;
  loc.fileIndex = fileIndex;
  loc.lineNumber = lineNumber;
  loc.columnNumber = columnNumber;

  fn->debugLocations[ex] = loc;
}

//
// =========== Import operations ===========
//

const char* BinaryenFunctionImportGetModule(BinaryenFunctionRef import) {
  if (tracing) {
    std::cout << "  BinaryenFunctionImportGetModule(functions[" << functions[import] << "]);\n";
  }

  auto* func = (Function*)import;
  if (func->imported()) {
    return func->module.c_str();
  } else {
    return "";
  }
}
const char* BinaryenGlobalImportGetModule(BinaryenGlobalRef import) {
  if (tracing) {
    std::cout << "  BinaryenGlobalImportGetModule(globals[" << globals[import] << "]);\n";
  }

  auto* global = (Global*)import;
  if (global->imported()) {
    return global->module.c_str();
  } else {
    return "";
  }
}
const char* BinaryenFunctionImportGetBase(BinaryenFunctionRef import) {
  if (tracing) {
    std::cout << "  BinaryenFunctionImportGetBase(functions[" << functions[import] << "]);\n";
  }

  auto* func = (Function*)import;
  if (func->imported()) {
    return func->base.c_str();
  } else {
    return "";
  }
}
const char* BinaryenGlobalImportGetBase(BinaryenGlobalRef import) {
  if (tracing) {
    std::cout << "  BinaryenGlobalImportGetBase(globals[" << globals[import] << "]);\n";
  }

  auto* global = (Global*)import;
  if (global->imported()) {
    return global->base.c_str();
  } else {
    return "";
  }
}

//
// =========== Export operations ===========
//

BinaryenExternalKind BinaryenExportGetKind(BinaryenExportRef export_) {
  if (tracing) {
    std::cout << "  BinaryenExportGetKind(exports[" << exports[export_] << "]);\n";
  }

  return BinaryenExternalKind(((Export*)export_)->kind);
}
const char* BinaryenExportGetName(BinaryenExportRef export_) {
  if (tracing) {
    std::cout << "  BinaryenExportGetName(exports[" << exports[export_] << "]);\n";
  }

  return ((Export*)export_)->name.c_str();
}
const char* BinaryenExportGetValue(BinaryenExportRef export_) {
  if (tracing) {
    std::cout << "  BinaryenExportGetValue(exports[" << exports[export_] << "]);\n";
  }

  return ((Export*)export_)->value.c_str();
}

//
// ========== CFG / Relooper ==========
//

RelooperRef RelooperCreate(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  the_relooper = RelooperCreate(the_module);\n";
  }

  auto* wasm = (Module*)module;
  return RelooperRef(new CFG::Relooper(wasm));
}

RelooperBlockRef RelooperAddBlock(RelooperRef relooper, BinaryenExpressionRef code) {
  auto* R = (CFG::Relooper*)relooper;
  auto* ret = new CFG::Block((Expression*)code);

  if (tracing) {
    auto id = relooperBlocks.size();
    relooperBlocks[ret] = id;
    std::cout << "  relooperBlocks[" << id << "] = RelooperAddBlock(the_relooper, expressions[" << expressions[code] << "]);\n";
  }

  R->AddBlock(ret);
  return RelooperRef(ret);
}

void RelooperAddBranch(RelooperBlockRef from, RelooperBlockRef to, BinaryenExpressionRef condition, BinaryenExpressionRef code) {
  if (tracing) {
    std::cout << "  RelooperAddBranch(relooperBlocks[" << relooperBlocks[from] << "], relooperBlocks[" << relooperBlocks[to] << "], expressions[" << expressions[condition] << "], expressions[" << expressions[code] << "]);\n";
  }

  auto* fromBlock = (CFG::Block*)from;
  auto* toBlock = (CFG::Block*)to;
  fromBlock->AddBranchTo(toBlock, (Expression*)condition, (Expression*)code);
}

RelooperBlockRef RelooperAddBlockWithSwitch(RelooperRef relooper, BinaryenExpressionRef code, BinaryenExpressionRef condition) {
  auto* R = (CFG::Relooper*)relooper;
  auto* ret = new CFG::Block((Expression*)code, (Expression*)condition);

  if (tracing) {
    std::cout << "  relooperBlocks[" << relooperBlocks[ret] << "] = RelooperAddBlockWithSwitch(the_relooper, expressions[" << expressions[code] << "], expressions[" << expressions[condition] << "]);\n";
  }

  R->AddBlock(ret);
  return RelooperRef(ret);
}

void RelooperAddBranchForSwitch(RelooperBlockRef from, RelooperBlockRef to, BinaryenIndex* indexes, BinaryenIndex numIndexes, BinaryenExpressionRef code) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenIndex indexes[] = { ";
    for (BinaryenIndex i = 0; i < numIndexes; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << indexes[i];
    }
    if (numIndexes == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    std::cout << "    RelooperAddBranchForSwitch(relooperBlocks[" << relooperBlocks[from] << "], relooperBlocks[" << relooperBlocks[to] << "], indexes, " << numIndexes << ", expressions[" << expressions[code] << "]);\n";
    std::cout << "  }\n";
  }

  auto* fromBlock = (CFG::Block*)from;
  auto* toBlock = (CFG::Block*)to;
  std::vector<Index> values;
  for (Index i = 0; i < numIndexes; i++) {
    values.push_back(indexes[i]);
  }
  fromBlock->AddSwitchBranchTo(toBlock, std::move(values), (Expression*)code);
}

BinaryenExpressionRef RelooperRenderAndDispose(RelooperRef relooper, RelooperBlockRef entry, BinaryenIndex labelHelper) {
  auto* R = (CFG::Relooper*)relooper;
  R->Calculate((CFG::Block*)entry);
  CFG::RelooperBuilder builder(*R->Module, labelHelper);
  auto* ret = R->Render(builder);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = RelooperRenderAndDispose(the_relooper, relooperBlocks[" << relooperBlocks[entry] << "], " << labelHelper << ");\n";
    relooperBlocks.clear();
  }

  delete R;
  return BinaryenExpressionRef(ret);
}

//
// ========= Other APIs =========
//

void BinaryenSetAPITracing(int on) {
  tracing = on;

  if (tracing) {
    std::cout << "// beginning a Binaryen API trace\n"
                 "#include <math.h>\n"
                 "#include <map>\n"
                 "#include \"src/binaryen-c.h\"\n"
                 "int main() {\n"
                 "  std::map<size_t, BinaryenFunctionTypeRef> functionTypes;\n"
                 "  std::map<size_t, BinaryenExpressionRef> expressions;\n"
                 "  std::map<size_t, BinaryenFunctionRef> functions;\n"
                 "  std::map<size_t, BinaryenGlobalRef> globals;\n"
                 "  std::map<size_t, BinaryenExportRef> exports;\n"
                 "  std::map<size_t, RelooperBlockRef> relooperBlocks;\n"
                 "  BinaryenModuleRef the_module = NULL;\n"
                 "  RelooperRef the_relooper = NULL;\n";
  } else {
    std::cout << "  return 0;\n";
    std::cout << "}\n";
  }
}

//
// ========= Utilities =========
//

BinaryenFunctionTypeRef BinaryenGetFunctionTypeBySignature(BinaryenModuleRef module, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams) {
  if (tracing) {
    std::cout << "  // BinaryenGetFunctionTypeBySignature\n";
  }

  auto* wasm = (Module*)module;
  FunctionType test;
  test.result = Type(result);
  for (BinaryenIndex i = 0; i < numParams; i++) {
    test.params.push_back(Type(paramTypes[i]));
  }

  // Lock. Guard against reading the list while types are being added.
  {
    std::lock_guard<std::mutex> lock(BinaryenFunctionTypeMutex);
    for (BinaryenIndex i = 0; i < wasm->functionTypes.size(); i++) {
      FunctionType* curr = wasm->functionTypes[i].get();
      if (curr->structuralComparison(test)) {
        return curr;
      }
    }
  }

  return NULL;
}

#ifdef __EMSCRIPTEN__
// Override atexit - we don't need any global ctors to actually run, and
// otherwise we get clutter in the output in debug builds
int atexit(void (*function)(void)) {
  return 0;
}
#endif

} // extern "C"
