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

#include "binaryen-c.h"
#include "wasm.h"
#include "wasm-builder.h"
#include "wasm-printing.h"

using namespace wasm;

// Literal utilities

static_assert(sizeof(BinaryenLiteral) == sizeof(Literal), "Binaryen C API literal must match wasm.h");

BinaryenLiteral toBinaryenLiteral(Literal x) {
  BinaryenLiteral ret;
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

BinaryenModuleRef BinaryenModuleCreate() { return new Module(); }
void BinaryenModuleDispose(BinaryenModuleRef module) { delete (Module*)module; }

// Function types

BinaryenFunctionTypeRef BinaryenAddFunctionType(BinaryenModuleRef module, const char* name, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams) {
  auto* wasm = (Module*)module;
  auto* ret = new FunctionType;
  ret->name = name;
  ret->result = WasmType(result);
  for (BinaryenIndex i = 0; i < numParams; i++) {
    ret->params.push_back(WasmType(paramTypes[i]));
  }
  wasm->addFunctionType(ret);
  return ret;
}

BinaryenLiteral BinaryenLiteralInt32(int32_t x) { return toBinaryenLiteral(Literal(x)); }
BinaryenLiteral BinaryenLiteralInt64(int64_t x) { return toBinaryenLiteral(Literal(x)); }
BinaryenLiteral BinaryenLiteralFloat32(float x) { return toBinaryenLiteral(Literal(x)); }
BinaryenLiteral BinaryenLiteralFloat64(double x) { return toBinaryenLiteral(Literal(x)); }
BinaryenLiteral BinaryenLiteralFloat32Bits(int32_t x) { return toBinaryenLiteral(Literal(x).castToF32()); }
BinaryenLiteral BinaryenLiteralFloat64Bits(int64_t x) { return toBinaryenLiteral(Literal(x).castToF64()); }

// Expressions

BinaryenOp BinaryenClz(void) { return Clz; }
BinaryenOp BinaryenCtz(void) { return Ctz; }
BinaryenOp BinaryenPopcnt(void) { return Popcnt; }
BinaryenOp BinaryenNeg(void) { return Neg; }
BinaryenOp BinaryenAbs(void) { return Abs; }
BinaryenOp BinaryenCeil(void) { return Ceil; }
BinaryenOp BinaryenFloor(void) { return Floor; }
BinaryenOp BinaryenTrunc(void) { return Trunc; }
BinaryenOp BinaryenNearest(void) { return Nearest; }
BinaryenOp BinaryenSqrt(void) { return Sqrt; }
BinaryenOp BinaryenEqz(void) { return EqZ; }
BinaryenOp BinaryenExtendSInt32(void) { return ExtendSInt32; }
BinaryenOp BinaryenExtentUInt32(void) { return ExtendUInt32; }
BinaryenOp BinaryenWrapInt64(void) { return WrapInt64; }
BinaryenOp BinaryenTruncSFloat32(void) { return TruncSFloat32; }
BinaryenOp BinaryenTruncUFloat32(void) { return TruncUFloat32; }
BinaryenOp BinaryenTruncSFloat64(void) { return TruncSFloat64; }
BinaryenOp BinaryenTruncUFloat64(void) { return TruncUFloat64; }
BinaryenOp BinaryenReinterpretFloat(void) { return ReinterpretFloat; }
BinaryenOp BinaryenConvertSInt32(void) { return ConvertSInt32; }
BinaryenOp BinaryenConvertUInt32(void) { return ConvertUInt32; }
BinaryenOp BinaryenConvertSInt64(void) { return ConvertSInt64; }
BinaryenOp BinaryenConvertUInt64(void) { return ConvertUInt64; }
BinaryenOp BinaryenPromoteFloat32(void) { return PromoteFloat32; }
BinaryenOp BinaryenDemoteFloat64(void) { return DemoteFloat64; }
BinaryenOp BinaryenReinterpretInt(void) { return ReinterpretInt; }
BinaryenOp BinaryenAdd(void) { return Add; }
BinaryenOp BinaryenSub(void) { return Sub; }
BinaryenOp BinaryenMul(void) { return Mul; }
BinaryenOp BinaryenDivS(void) { return DivS; }
BinaryenOp BinaryenDivU(void) { return DivU; }
BinaryenOp BinaryenRemS(void) { return RemS; }
BinaryenOp BinaryenRemU(void) { return RemU; }
BinaryenOp BinaryenAnd(void) { return And; }
BinaryenOp BinaryenOr(void) { return Or; }
BinaryenOp BinaryenXor(void) { return Xor; }
BinaryenOp BinaryenShl(void) { return Shl; }
BinaryenOp BinaryenShrU(void) { return ShrU; }
BinaryenOp BinaryenShrS(void) { return ShrS; }
BinaryenOp BinaryenRotL(void) { return RotL; }
BinaryenOp BinaryenRotR(void) { return RotR; }
BinaryenOp BinaryenDiv(void) { return Div; }
BinaryenOp BinaryenCopySign(void) { return CopySign; }
BinaryenOp BinaryenMin(void) { return Min; }
BinaryenOp BinaryenMax(void) { return Max; }
BinaryenOp BinaryenEq(void) { return Eq; }
BinaryenOp BinaryenNe(void) { return Ne; }
BinaryenOp BinaryenLtS(void) { return LtS; }
BinaryenOp BinaryenLtU(void) { return LtU; }
BinaryenOp BinaryenLeS(void) { return LeS; }
BinaryenOp BinaryenLeU(void) { return LeU; }
BinaryenOp BinaryenGtS(void) { return GtS; }
BinaryenOp BinaryenGtU(void) { return GtU; }
BinaryenOp BinaryenGes(void) { return GeS; }
BinaryenOp BinaryenGeU(void) { return GeU; }
BinaryenOp BinaryenLt(void) { return Lt; }
BinaryenOp BinaryenLe(void) { return Le; }
BinaryenOp BinaryenGt(void) { return Gt; }
BinaryenOp BinaryenGe(void) { return Ge; }
BinaryenOp BinaryenPageSize(void) { return PageSize; }
BinaryenOp BinaryenCurrentMemory(void) { return CurrentMemory; }
BinaryenOp BinaryenGrowMemory(void) { return GrowMemory; }
BinaryenOp BinaryenHasFeature(void) { return HasFeature; }

BinaryenExpressionRef BinaryenBlock(BinaryenModuleRef module, const char* name, BinaryenExpressionRef* children, BinaryenIndex numChildren) {
  auto* ret = ((Module*)module)->allocator.alloc<Block>();
  if (name) {
    ret->name = name;
  }
  for (BinaryenIndex i = 0; i < numChildren; i++) {
    ret->list.push_back((Expression*)children[i]);
  }
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenIf(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse) {
  auto* ret = ((Module*)module)->allocator.alloc<If>();
  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module, const char* out, const char* in, BinaryenExpressionRef body) {
  return Builder(*((Module*)module)).makeLoop(out ? Name(out) : Name(), in ? Name(in) : Name(), (Expression*)body);
}
BinaryenExpressionRef BinaryenBreak(BinaryenModuleRef module, const char* name, BinaryenExpressionRef value, BinaryenExpressionRef condition) {
  return Builder(*((Module*)module)).makeBreak(name, (Expression*)value, (Expression*)condition);
}
BinaryenExpressionRef BinaryenSwitch(BinaryenModuleRef module, const char **names, BinaryenIndex numNames, const char* defaultName, BinaryenExpressionRef condition, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<Switch>();
  for (BinaryenIndex i = 0; i < numNames; i++) {
    ret->targets.push_back(names[i]);
  }
  ret->default_ = defaultName;
  ret->condition = (Expression*)condition;
  ret->value = (Expression*)value;
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands) {
  auto* ret = ((Module*)module)->allocator.alloc<Call>();
  ret->target = target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenCallImport(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands) {
  auto* ret = ((Module*)module)->allocator.alloc<CallImport>();
  ret->target = target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenCallIndirect(BinaryenModuleRef module, BinaryenExpressionRef target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenFunctionTypeRef type) {
  auto* ret = ((Module*)module)->allocator.alloc<CallIndirect>();
  ret->target = (Expression*)target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->fullType = (FunctionType*)type;
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenGetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<GetLocal>();
  ret->index = index;
  ret->type = WasmType(type);
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenSetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<SetLocal>();
  ret->index = index;
  ret->value = (Expression*)value;
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module, uint32_t bytes, int8_t signed_, uint32_t offset, uint32_t align, BinaryenExpressionRef ptr) {
  auto* ret = ((Module*)module)->allocator.alloc<Load>();
  ret->bytes = bytes;
  ret->signed_ = signed_;
  ret->offset = offset;
  ret->align = align;
  ret->ptr = (Expression*)ptr;
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, uint32_t align, BinaryenExpressionRef ptr, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<Store>();
  ret->bytes = bytes;
  ret->offset = offset;
  ret->align = align;
  ret->ptr = (Expression*)ptr;
  ret->value = (Expression*)value;
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module, BinaryenLiteral value) {
  return Builder(*((Module*)module)).makeConst(fromBinaryenLiteral(value));
}
BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef value, BinaryenType type) {
  return Builder(*((Module*)module)).makeUnary(UnaryOp(op), (Expression*)value, WasmType(type));
}
BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef left, BinaryenExpressionRef right) {
  return Builder(*((Module*)module)).makeBinary(BinaryOp(op), (Expression*)left, (Expression*)right);
}
BinaryenExpressionRef BinaryenSelect(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse) {
  auto* ret = ((Module*)module)->allocator.alloc<Select>();
  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module, BinaryenExpressionRef value) {
  return Builder(*((Module*)module)).makeReturn((Expression*)value);
}
BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module, BinaryenOp op, const char* name, BinaryenExpressionRef* operands, BinaryenIndex numOperands) {
  auto* ret = ((Module*)module)->allocator.alloc<Host>();
  ret->op = HostOp(op);
  if (name) ret->nameOperand = name;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->finalize();
  return ret;
}
BinaryenExpressionRef BinaryenNop(BinaryenModuleRef module) {
  return ((Module*)module)->allocator.alloc<Nop>();
}
BinaryenExpressionRef BinaryenUnreachable(BinaryenModuleRef module) {
  return ((Module*)module)->allocator.alloc<Unreachable>();
}

// Functions

BinaryenFunctionRef BinaryenAddFunction(BinaryenModuleRef module, const char* name, BinaryenFunctionTypeRef type, BinaryenType* localTypes, BinaryenIndex numLocalTypes, BinaryenExpressionRef body) {
  auto* wasm = (Module*)module;
  auto* ret = new Function;
  ret->name = name;
  ret->type = ((FunctionType*)type)->name;
  auto* functionType = wasm->getFunctionType(ret->type);
  ret->result = functionType->result;
  ret->params = functionType->params;
  for (BinaryenIndex i = 0; i < numLocalTypes; i++) {
    ret->vars.push_back(WasmType(localTypes[i]));
  }
  ret->body = (Expression*)body;
  wasm->addFunction(ret);
  return ret;
}

// Imports

BinaryenImportRef BinaryenAddImport(BinaryenModuleRef module, const char* internalName, const char* externalModuleName, const char *externalBaseName, BinaryenFunctionTypeRef type) {
  auto* wasm = (Module*)module;
  auto* ret = new Import();
  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->type = (FunctionType*)type;
  wasm->addImport(ret);
  return ret;
}

// Exports

BinaryenExportRef BinaryenAddExport(BinaryenModuleRef module, const char* internalName, const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();
  ret->name = internalName;
  ret->value = externalName;
  wasm->addExport(ret);
  return ret;
}

// Function table. One per module

void BinaryenSetFunctionTable(BinaryenModuleRef module, BinaryenFunctionRef* functions, BinaryenIndex numFunctions) {
  auto* wasm = (Module*)module;
  for (BinaryenIndex i = 0; i < numFunctions; i++) {
    wasm->table.names.push_back(((Function*)functions[i])->name);
  }
}

// Memory. One per module

void BinaryenSetMemory(BinaryenModuleRef module, BinaryenIndex initial, BinaryenIndex maximum, const char* exportName, const char **segments, BinaryenIndex* segmentOffsets, BinaryenIndex* segmentSizes, BinaryenIndex numSegments) {
  auto* wasm = (Module*)module;
  wasm->memory.initial = initial;
  wasm->memory.max = maximum;
  wasm->memory.exportName = exportName;
  for (BinaryenIndex i = 0; i < numSegments; i++) {
    wasm->memory.segments.emplace_back(segmentOffsets[i], segments[i], segmentSizes[i]);
  }
}

// Start function. One per module

void BinaryenSetStart(BinaryenModuleRef module, const char* name) {
  auto* wasm = (Module*)module;
  wasm->addStart(name);
}

//
// ========== Module Operations ==========
//

void BinaryenModulePrint(BinaryenModuleRef module) {
  WasmPrinter::printModule((Module*)module);
}

} // extern "C"
