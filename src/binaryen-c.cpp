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
#include "pass.h"
#include "wasm.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-printing.h"
#include "wasm-validator.h"
#include "cfg/Relooper.h"

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

BinaryenModuleRef BinaryenModuleCreate(void) { return new Module(); }
void BinaryenModuleDispose(BinaryenModuleRef module) { delete (Module*)module; }

// Function types

BinaryenFunctionTypeRef BinaryenAddFunctionType(BinaryenModuleRef module, const char* name, BinaryenType result, BinaryenType* paramTypes, BinaryenIndex numParams) {
  auto* wasm = (Module*)module;
  auto* ret = new FunctionType;
  if (name) ret->name = name;
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
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenIf(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse) {
  auto* ret = ((Module*)module)->allocator.alloc<If>();
  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module, const char* out, const char* in, BinaryenExpressionRef body) {
  if (out && !in) abort();
  return static_cast<Expression*>(Builder(*((Module*)module)).makeLoop(out ? Name(out) : Name(), in ? Name(in) : Name(), (Expression*)body));
}
BinaryenExpressionRef BinaryenBreak(BinaryenModuleRef module, const char* name, BinaryenExpressionRef condition, BinaryenExpressionRef value) {
  return static_cast<Expression*>(Builder(*((Module*)module)).makeBreak(name, (Expression*)value, (Expression*)condition));
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
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module, const char *target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenType returnType) {
  auto* ret = ((Module*)module)->allocator.alloc<Call>();
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
  ret->target = target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->type = WasmType(returnType);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenCallIndirect(BinaryenModuleRef module, BinaryenExpressionRef target, BinaryenExpressionRef* operands, BinaryenIndex numOperands, BinaryenFunctionTypeRef type) {
  auto* ret = ((Module*)module)->allocator.alloc<CallIndirect>();
  ret->target = (Expression*)target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->fullType = (FunctionType*)type;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenGetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<GetLocal>();
  ret->index = index;
  ret->type = WasmType(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSetLocal(BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<SetLocal>();
  ret->index = index;
  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module, uint32_t bytes, int8_t signed_, uint32_t offset, uint32_t align, BinaryenType type, BinaryenExpressionRef ptr) {
  auto* ret = ((Module*)module)->allocator.alloc<Load>();
  ret->bytes = bytes;
  ret->signed_ = !!signed_;
  ret->offset = offset;
  ret->align = align ? align : bytes;
  ret->type = WasmType(type);
  ret->ptr = (Expression*)ptr;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module, uint32_t bytes, uint32_t offset, uint32_t align, BinaryenExpressionRef ptr, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<Store>();
  ret->bytes = bytes;
  ret->offset = offset;
  ret->align = align ? align : bytes;
  ret->ptr = (Expression*)ptr;
  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module, BinaryenLiteral value) {
  return static_cast<Expression*>(Builder(*((Module*)module)).makeConst(fromBinaryenLiteral(value)));
}
BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef value) {
  return static_cast<Expression*>(Builder(*((Module*)module)).makeUnary(UnaryOp(op), (Expression*)value));
}
BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module, BinaryenOp op, BinaryenExpressionRef left, BinaryenExpressionRef right) {
  return static_cast<Expression*>(Builder(*((Module*)module)).makeBinary(BinaryOp(op), (Expression*)left, (Expression*)right));
}
BinaryenExpressionRef BinaryenSelect(BinaryenModuleRef module, BinaryenExpressionRef condition, BinaryenExpressionRef ifTrue, BinaryenExpressionRef ifFalse) {
  auto* ret = ((Module*)module)->allocator.alloc<Select>();
  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module, BinaryenExpressionRef value) {
  return static_cast<Expression*>(Builder(*((Module*)module)).makeReturn((Expression*)value));
}
BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module, BinaryenOp op, const char* name, BinaryenExpressionRef* operands, BinaryenIndex numOperands) {
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
  return static_cast<Expression*>(((Module*)module)->allocator.alloc<Nop>());
}
BinaryenExpressionRef BinaryenUnreachable(BinaryenModuleRef module) {
  return static_cast<Expression*>(((Module*)module)->allocator.alloc<Unreachable>());
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
  ret->value = internalName;
  ret->name = externalName;
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
  if (exportName) wasm->memory.exportName = exportName;
  for (BinaryenIndex i = 0; i < numSegments; i++) {
    wasm->memory.segments.emplace_back(segmentOffsets[i], segments[i], segmentSizes[i]);
  }
}

// Start function. One per module

void BinaryenSetStart(BinaryenModuleRef module, BinaryenFunctionRef start) {
  auto* wasm = (Module*)module;
  wasm->addStart(((Function*)start)->name);
}

//
// ========== Module Operations ==========
//

void BinaryenModulePrint(BinaryenModuleRef module) {
  WasmPrinter::printModule((Module*)module);
}

int BinaryenModuleValidate(BinaryenModuleRef module) {
  Module* wasm = (Module*)module;
  return WasmValidator().validate(*wasm) ? 1 : 0;
}

void BinaryenModuleOptimize(BinaryenModuleRef module) {
  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.addDefaultOptimizationPasses();
  passRunner.run();
}

size_t BinaryenModuleWrite(BinaryenModuleRef module, char* output, size_t outputSize) {
  Module* wasm = (Module*)module;
  BufferWithRandomAccess buffer(false);
  WasmBinaryWriter writer(wasm, buffer, false);
  writer.write();
  size_t bytes = std::min(buffer.size(), outputSize);
  std::copy_n(buffer.begin(), bytes, output);
  return bytes;
}

BinaryenModuleRef BinaryenModuleRead(char* input, size_t inputSize) {
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

//
// ========== CFG / Relooper ==========
//

RelooperRef RelooperCreate(void) {
  return RelooperRef(new CFG::Relooper());
}

RelooperBlockRef RelooperAddBlock(RelooperRef relooper, BinaryenExpressionRef code) {
  auto* R = (CFG::Relooper*)relooper;
  auto* ret = new CFG::Block((Expression*)code);
  R->AddBlock(ret);
  return RelooperRef(ret);
}

void RelooperAddBranch(RelooperBlockRef from, RelooperBlockRef to, BinaryenExpressionRef condition, BinaryenExpressionRef code) {
  auto* fromBlock = (CFG::Block*)from;
  auto* toBlock = (CFG::Block*)to;
  fromBlock->AddBranchTo(toBlock, (Expression*)condition, (Expression*)code);
}

RelooperBlockRef RelooperAddBlockWithSwitch(RelooperRef relooper, BinaryenExpressionRef code, BinaryenExpressionRef condition) {
  auto* R = (CFG::Relooper*)relooper;
  auto* ret = new CFG::Block((Expression*)code, (Expression*)condition);
  R->AddBlock(ret);
  return RelooperRef(ret);
}

void RelooperAddBranchForSwitch(RelooperBlockRef from, RelooperBlockRef to, BinaryenIndex index, BinaryenExpressionRef code) {
  auto* fromBlock = (CFG::Block*)from;
  auto* toBlock = (CFG::Block*)to;
  fromBlock->AddBranchTo(toBlock, (wasm::Index)index, (Expression*)code);
}

BinaryenExpressionRef RelooperRenderAndDispose(RelooperRef relooper, RelooperBlockRef entry, BinaryenIndex labelHelper, BinaryenModuleRef module) {
  auto* R = (CFG::Relooper*)relooper;
  R->Calculate((CFG::Block*)entry);
  CFG::RelooperBuilder builder(*(Module*)module, labelHelper);
  auto* ret = R->Render(builder);
  delete R;
  return BinaryenExpressionRef(ret);
}

} // extern "C"
