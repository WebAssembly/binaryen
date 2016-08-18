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
#include "wasm-validator.h"
#include "cfg/Relooper.h"
#include "shell-interface.h"

using namespace wasm;

// Literal utilities

static_assert(sizeof(BinaryenLiteral) == sizeof(Literal), "Binaryen C API literal must match wasm.h");

BinaryenLiteral toBinaryenLiteral(Literal x) {
  BinaryenLiteral ret;
  ret.type = x.type;
  switch (x.type) {
    case WasmType::i32: ret.i32 = x.geti32(); break;
    case WasmType::i64: ret.i64 = x.geti64(); break;
    case WasmType::f32: ret.i32 = x.reinterpreti32(); break;
    case WasmType::f64: ret.i64 = x.reinterpreti64(); break;
    default: abort();
  }
  return ret;
}

Literal fromBinaryenLiteral(BinaryenLiteral x) {
  switch (x.type) {
    case WasmType::i32: return Literal(x.i32);
    case WasmType::i64: return Literal(x.i64);
    case WasmType::f32: return Literal(x.i32).castToF32();
    case WasmType::f64: return Literal(x.i64).castToF64();
    default: abort();
  }
}

// Tracing support

static int tracing = 0;

void traceNameOrNULL(const char *name) {
  if (name) std::cout << "\"" << name << "\"";
  else std::cout << "NULL";
}

std::map<BinaryenFunctionTypeRef, size_t> functionTypes;
std::map<BinaryenExpressionRef, size_t> expressions;
std::map<BinaryenFunctionRef, size_t> functions;
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

BinaryenType BinaryenNone(void) { return none; }
BinaryenType BinaryenInt32(void) { return i32; }
BinaryenType BinaryenInt64(void) { return i64; }
BinaryenType BinaryenFloat32(void) { return f32; }
BinaryenType BinaryenFloat64(void) { return f64; }

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
    std::cout << "  relooperBlocks.clear();\n";
    functionTypes.clear();
    expressions.clear();
    functions.clear();
    relooperBlocks.clear();
  }

  delete (Module*)module;
}

// Function types

BinaryenFunctionTypeRef BinaryenAddFunctionType(BinaryenModuleRef module, const char* name, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams) {
  auto* wasm = (Module*)module;
  auto* ret = new FunctionType;
  if (name) ret->name = name;
  ret->result = WasmType(result);
  for (BinaryenIndex i = 0; i < numParams; i++) {
    ret->params.push_back(WasmType(paramTypes[i]));
  }

  // Lock. This can be called from multiple threads at once, and is a
  // point where they all access and modify the module.
  static std::mutex BinaryenAddFunctionTypeMutex;
  {
    std::lock_guard<std::mutex> lock(BinaryenAddFunctionTypeMutex);
    wasm->addFunctionType(ret);
  }

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenIndex paramTypes[] = { ";
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
BinaryenOp BinaryenExtentUInt32(void) { return ExtendUInt32; }
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
BinaryenOp BinaryenPageSize(void) { return PageSize; }
BinaryenOp BinaryenCurrentMemory(void) { return CurrentMemory; }
BinaryenOp BinaryenGrowMemory(void) { return GrowMemory; }
BinaryenOp BinaryenHasFeature(void) { return HasFeature; }

BinaryenExpressionRef BinaryenBlock(BinaryenModuleRef module, const char* name, BinaryenExpressionRef* children, BinaryenIndex numChildren) {
  auto* ret = ((Module*)module)->allocator.alloc<Block>();
  if (name) ret->name = name;
  for (BinaryenIndex i = 0; i < numChildren; i++) {
    ret->list.push_back((Expression*)children[i]);
  }
  ret->finalize();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef children[] = { ";
    for (BinaryenIndex i = 0; i < numChildren; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "expressions[" << expressions[children[i]] << "]";
    }
    if (numChildren == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    auto id = noteExpression(ret);
    std::cout << "    expressions[" << id << "] = BinaryenBlock(the_module, ";
    traceNameOrNULL(name);
    std::cout << ", children, " << numChildren << ");\n";
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
BinaryenExpressionRef BinaryenSwitch(BinaryenModuleRef module, const char **names, BinaryenIndex numNames, const char* defaultName, BinaryenExpressionRef condition, BinaryenExpressionRef value) {
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
BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenType returnType) {
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
  ret->type = WasmType(returnType);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenCallImport(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenType returnType) {
  auto* ret = ((Module*)module)->allocator.alloc<CallImport>();

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
    std::cout << "    expressions[" << id << "] = BinaryenCallImport(the_module, \"" << target << "\", operands, " << numOperands << ", " << returnType << ");\n";
    std::cout << "  }\n";
  }

  ret->target = target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->type = WasmType(returnType);
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
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenGetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<GetLocal>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenGetLocal(the_module, " << index << ", " << type << ");\n";
  }

  ret->index = index;
  ret->type = WasmType(type);
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
BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module, uint32_t bytes, int8_t signed_, uint32_t offset, uint32_t align, BinaryenType type, BinaryenExpressionRef ptr) {
  auto* ret = ((Module*)module)->allocator.alloc<Load>();

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = BinaryenLoad(the_module, " << bytes << ", " << int(signed_) << ", " << offset << ", " << align << ", " << type << ", expressions[" << expressions[ptr] << "]);\n";
  }

  ret->bytes = bytes;
  ret->signed_ = !!signed_;
  ret->offset = offset;
  ret->align = align ? align : bytes;
  ret->type = WasmType(type);
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

  ret->bytes = bytes;
  ret->offset = offset;
  ret->align = align ? align : bytes;
  ret->ptr = (Expression*)ptr;
  ret->value = (Expression*)value;
  ret->valueType = WasmType(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module, BinaryenLiteral value) {
  auto* ret = Builder(*((Module*)module)).makeConst(fromBinaryenLiteral(value));
  if (tracing) {
    auto id = noteExpression(ret);
    switch (value.type) {
      case WasmType::i32: std::cout << "  expressions[" << id << "] = BinaryenConst(the_module, BinaryenLiteralInt32(" << value.i32 << "));\n"; break;
      case WasmType::i64: std::cout << "  expressions[" << id << "] = BinaryenConst(the_module, BinaryenLiteralInt64(" << value.i64 << "));\n"; break;
      case WasmType::f32: {
        std::cout << "  expressions[" << id << "] = BinaryenConst(the_module, BinaryenLiteralFloat32(";
        if (std::isnan(value.f32)) std::cout << "NAN";
        else std::cout << value.f32;
        std::cout << "));\n";
        break;
      }
      case WasmType::f64: {
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
  if (tracing) {
    std::cout << "  TODO: host...\n";
  }

  auto* ret = ((Module*)module)->allocator.alloc<Host>();
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

void BinaryenExpressionPrint(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionPrint(expressions[" << expressions[expr] << "]);\n";
  }

  WasmPrinter::printExpression((Expression*)expr, std::cout);
  std::cout << '\n';
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
    ret->vars.push_back(WasmType(varTypes[i]));
  }
  ret->body = (Expression*)body;

  // Lock. This can be called from multiple threads at once, and is a
  // point where they all access and modify the module.
  static std::mutex BinaryenAddFunctionMutex;
  {
    std::lock_guard<std::mutex> lock(BinaryenAddFunctionMutex);
    wasm->addFunction(ret);
  }

  return ret;
}

// Imports

BinaryenImportRef BinaryenAddImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char *externalBaseName, BinaryenFunctionTypeRef type) {
  if (tracing) {
    std::cout << "  BinaryenAddImport(the_module, \"" << internalName << "\", \"" << externalModuleName << "\", \"" << externalBaseName << "\", functionTypes[" << functionTypes[type] << "]);\n";
  }

  auto* wasm = (Module*)module;
  auto* ret = new Import();
  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->type = (FunctionType*)type;
  ret->kind = Import::Function;
  wasm->addImport(ret);
  return ret;
}

// Exports

BinaryenExportRef BinaryenAddExport(BinaryenModuleRef module, const char* internalName, const char* externalName) {
  if (tracing) {
    std::cout << "  BinaryenAddExport(the_module, \"" << internalName << "\", \"" << externalName << "\");\n";
  }

  auto* wasm = (Module*)module;
  auto* ret = new Export();
  ret->value = internalName;
  ret->name = externalName;
  wasm->addExport(ret);
  return ret;
}

// Function table. One per module

void BinaryenSetFunctionTable(BinaryenModuleRef module, BinaryenFunctionRef* funcs, BinaryenIndex numFuncs) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenFunctionRef funcs[] = { ";
    for (BinaryenIndex i = 0; i < numFuncs; i++) {
      if (i > 0) std::cout << ", ";
      std::cout << "functions[" << functions[funcs[i]] << "]";
    }
    if (numFuncs == 0) std::cout << "0"; // ensure the array is not empty, otherwise a compiler error on VS
    std::cout << " };\n";
    std::cout << "    BinaryenSetFunctionTable(the_module, funcs, " << numFuncs << ");\n";
    std::cout << "  }\n";
  }

  auto* wasm = (Module*)module;
  Table::Segment segment(wasm->allocator.alloc<Const>()->set(Literal(int32_t(0))));
  for (BinaryenIndex i = 0; i < numFuncs; i++) {
    segment.data.push_back(((Function*)funcs[i])->name);
  }
  wasm->table.segments.push_back(segment);
  wasm->table.initial = wasm->table.max = numFuncs;
}

// Memory. One per module

void BinaryenSetMemory(BinaryenModuleRef module, BinaryenIndex initial, BinaryenIndex maximum, const char* exportName, const char **segments, BinaryenExpressionRef* segmentOffsets, BinaryenIndex* segmentSizes, BinaryenIndex numSegments) {
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
    std::cout << ", segments, segmentOffsets, segmentSizes, " << numSegments << ");\n";
    std::cout << "  }\n";
  }

  auto* wasm = (Module*)module;
  wasm->memory.initial = initial;
  wasm->memory.max = maximum;
  if (exportName) {
    auto memoryExport = make_unique<Export>();
    memoryExport->name = exportName;
    memoryExport->value = Name::fromInt(0);
    memoryExport->kind = Export::Memory;
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

void BinaryenModulePrint(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModulePrint(the_module);\n";
  }

  WasmPrinter::printModule((Module*)module);
}

int BinaryenModuleValidate(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleValidate(the_module);\n";
  }

  Module* wasm = (Module*)module;
  return WasmValidator().validate(*wasm) ? 1 : 0;
}

void BinaryenModuleOptimize(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleOptimize(the_module);\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.addDefaultOptimizationPasses();
  passRunner.run();
}

void BinaryenModuleAutoDrop(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleAutoDrop(the_module);\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.add<AutoDrop>();
  passRunner.run();
}

size_t BinaryenModuleWrite(BinaryenModuleRef module, char* output, size_t outputSize) {
  if (tracing) {
    std::cout << "  // BinaryenModuleWrite\n";
  }

  Module* wasm = (Module*)module;
  BufferWithRandomAccess buffer(false);
  WasmBinaryWriter writer(wasm, buffer, false);
  writer.write();
  size_t bytes = std::min(buffer.size(), outputSize);
  std::copy_n(buffer.begin(), bytes, output);
  return bytes;
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

//
// ========== CFG / Relooper ==========
//

RelooperRef RelooperCreate(void) {
  if (tracing) {
    std::cout << "  the_relooper = RelooperCreate();\n";
  }

  return RelooperRef(new CFG::Relooper());
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

BinaryenExpressionRef RelooperRenderAndDispose(RelooperRef relooper, RelooperBlockRef entry, BinaryenIndex labelHelper, BinaryenModuleRef module) {
  auto* R = (CFG::Relooper*)relooper;
  R->Calculate((CFG::Block*)entry);
  CFG::RelooperBuilder builder(*(Module*)module, labelHelper);
  auto* ret = R->Render(builder);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id << "] = RelooperRenderAndDispose(the_relooper, relooperBlocks[" << relooperBlocks[entry] << "], " << labelHelper << ", the_module);\n";
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
    std::cout << "// beginning a Binaryen API trace\n";
    std::cout << "#include <math.h>\n";
    std::cout << "#include <map>\n";
    std::cout << "#include \"src/binaryen-c.h\"\n";
    std::cout << "int main() {\n";
    std::cout << "  std::map<size_t, BinaryenFunctionTypeRef> functionTypes;\n";
    std::cout << "  std::map<size_t, BinaryenExpressionRef> expressions;\n";
    std::cout << "  std::map<size_t, BinaryenFunctionRef> functions;\n";
    std::cout << "  std::map<size_t, RelooperBlockRef> relooperBlocks;\n";
    std::cout << "  BinaryenModuleRef the_module = NULL;\n";
    std::cout << "  RelooperRef the_relooper = NULL;\n";
  } else {
    std::cout << "  return 0;\n";
    std::cout << "}\n";
  }
}

} // extern "C"
