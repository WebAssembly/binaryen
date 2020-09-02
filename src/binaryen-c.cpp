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
#include "cfg/Relooper.h"
#include "ir/utils.h"
#include "pass.h"
#include "shell-interface.h"
#include "support/colors.h"
#include "wasm-binary.h"
#include "wasm-builder.h"
#include "wasm-interpreter.h"
#include "wasm-printing.h"
#include "wasm-s-parser.h"
#include "wasm-validator.h"
#include "wasm.h"
#include "wasm2js.h"
#include <iostream>
#include <sstream>

#ifdef __EMSCRIPTEN__
#include <emscripten.h>
#endif

using namespace wasm;

// Literal utilities

static_assert(sizeof(BinaryenLiteral) == sizeof(Literal),
              "Binaryen C API literal must match wasm.h");

BinaryenLiteral toBinaryenLiteral(Literal x) {
  BinaryenLiteral ret;
  ret.type = x.type.getID();
  TODO_SINGLE_COMPOUND(x.type);
  switch (x.type.getBasic()) {
    case Type::i32:
      ret.i32 = x.geti32();
      break;
    case Type::i64:
      ret.i64 = x.geti64();
      break;
    case Type::f32:
      ret.i32 = x.reinterpreti32();
      break;
    case Type::f64:
      ret.i64 = x.reinterpreti64();
      break;
    case Type::v128:
      memcpy(&ret.v128, x.getv128Ptr(), 16);
      break;
    case Type::funcref:
      ret.func = x.getFunc().c_str();
      break;
    case Type::nullref:
      break;
    case Type::externref:
    case Type::exnref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  return ret;
}

Literal fromBinaryenLiteral(BinaryenLiteral x) {
  switch (x.type) {
    case Type::i32:
      return Literal(x.i32);
    case Type::i64:
      return Literal(x.i64);
    case Type::f32:
      return Literal(x.i32).castToF32();
    case Type::f64:
      return Literal(x.i64).castToF64();
    case Type::v128:
      return Literal(x.v128);
    case Type::funcref:
      return Literal::makeFuncref(x.func);
    case Type::nullref:
      return Literal::makeNullref();
    case Type::externref:
    case Type::exnref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
  WASM_UNREACHABLE("invalid type");
}

// Mutexes (global for now; in theory if multiple modules
// are used at once this should be optimized to be per-
// module, but likely it doesn't matter)

static std::mutex BinaryenFunctionMutex;

// Optimization options
static PassOptions globalPassOptions =
  PassOptions::getWithDefaultOptimizationOptions();

extern "C" {

//
// ========== Module Creation ==========
//

// Core types

BinaryenType BinaryenTypeNone(void) { return Type::none; }
BinaryenType BinaryenTypeInt32(void) { return Type::i32; }
BinaryenType BinaryenTypeInt64(void) { return Type::i64; }
BinaryenType BinaryenTypeFloat32(void) { return Type::f32; }
BinaryenType BinaryenTypeFloat64(void) { return Type::f64; }
BinaryenType BinaryenTypeVec128(void) { return Type::v128; }
BinaryenType BinaryenTypeFuncref(void) { return Type::funcref; }
BinaryenType BinaryenTypeExternref(void) { return Type::externref; }
BinaryenType BinaryenTypeNullref(void) { return Type::nullref; }
BinaryenType BinaryenTypeExnref(void) { return Type::exnref; }
BinaryenType BinaryenTypeUnreachable(void) { return Type::unreachable; }
BinaryenType BinaryenTypeAuto(void) { return uintptr_t(-1); }

BinaryenType BinaryenTypeCreate(BinaryenType* types, uint32_t numTypes) {
  std::vector<Type> typeVec;
  typeVec.reserve(numTypes);
  for (size_t i = 0; i < numTypes; ++i) {
    typeVec.push_back(Type(types[i]));
  }
  return Type(typeVec).getID();
}

uint32_t BinaryenTypeArity(BinaryenType t) { return Type(t).size(); }

void BinaryenTypeExpand(BinaryenType t, BinaryenType* buf) {
  Type types(t);
  size_t i = 0;
  for (const auto& type : types) {
    buf[i++] = type.getID();
  }
}

WASM_DEPRECATED BinaryenType BinaryenNone(void) { return Type::none; }
WASM_DEPRECATED BinaryenType BinaryenInt32(void) { return Type::i32; }
WASM_DEPRECATED BinaryenType BinaryenInt64(void) { return Type::i64; }
WASM_DEPRECATED BinaryenType BinaryenFloat32(void) { return Type::f32; }
WASM_DEPRECATED BinaryenType BinaryenFloat64(void) { return Type::f64; }
WASM_DEPRECATED BinaryenType BinaryenUndefined(void) { return uint32_t(-1); }

// Expression ids

BinaryenExpressionId BinaryenInvalidId(void) {
  return Expression::Id::InvalidId;
}
BinaryenExpressionId BinaryenBlockId(void) { return Expression::Id::BlockId; }
BinaryenExpressionId BinaryenIfId(void) { return Expression::Id::IfId; }
BinaryenExpressionId BinaryenLoopId(void) { return Expression::Id::LoopId; }
BinaryenExpressionId BinaryenBreakId(void) { return Expression::Id::BreakId; }
BinaryenExpressionId BinaryenSwitchId(void) { return Expression::Id::SwitchId; }
BinaryenExpressionId BinaryenCallId(void) { return Expression::Id::CallId; }
BinaryenExpressionId BinaryenCallIndirectId(void) {
  return Expression::Id::CallIndirectId;
}
BinaryenExpressionId BinaryenLocalGetId(void) {
  return Expression::Id::LocalGetId;
}
BinaryenExpressionId BinaryenLocalSetId(void) {
  return Expression::Id::LocalSetId;
}
BinaryenExpressionId BinaryenGlobalGetId(void) {
  return Expression::Id::GlobalGetId;
}
BinaryenExpressionId BinaryenGlobalSetId(void) {
  return Expression::Id::GlobalSetId;
}
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
BinaryenExpressionId BinaryenUnreachableId(void) {
  return Expression::Id::UnreachableId;
}
BinaryenExpressionId BinaryenAtomicCmpxchgId(void) {
  return Expression::Id::AtomicCmpxchgId;
}
BinaryenExpressionId BinaryenAtomicRMWId(void) {
  return Expression::Id::AtomicRMWId;
}
BinaryenExpressionId BinaryenAtomicWaitId(void) {
  return Expression::Id::AtomicWaitId;
}
BinaryenExpressionId BinaryenAtomicNotifyId(void) {
  return Expression::Id::AtomicNotifyId;
}
BinaryenExpressionId BinaryenAtomicFenceId(void) {
  return Expression::Id::AtomicFenceId;
}
BinaryenExpressionId BinaryenSIMDExtractId(void) {
  return Expression::Id::SIMDExtractId;
}
BinaryenExpressionId BinaryenSIMDReplaceId(void) {
  return Expression::Id::SIMDReplaceId;
}
BinaryenExpressionId BinaryenSIMDShuffleId(void) {
  return Expression::Id::SIMDShuffleId;
}
BinaryenExpressionId BinaryenSIMDTernaryId(void) {
  return Expression::Id::SIMDTernaryId;
}
BinaryenExpressionId BinaryenSIMDShiftId(void) {
  return Expression::Id::SIMDShiftId;
}
BinaryenExpressionId BinaryenSIMDLoadId(void) {
  return Expression::Id::SIMDLoadId;
}
BinaryenExpressionId BinaryenMemoryInitId(void) {
  return Expression::Id::MemoryInitId;
}
BinaryenExpressionId BinaryenDataDropId(void) {
  return Expression::Id::DataDropId;
}
BinaryenExpressionId BinaryenMemoryCopyId(void) {
  return Expression::Id::MemoryCopyId;
}
BinaryenExpressionId BinaryenMemoryFillId(void) {
  return Expression::Id::MemoryFillId;
}
BinaryenExpressionId BinaryenRefNullId(void) {
  return Expression::Id::RefNullId;
}
BinaryenExpressionId BinaryenRefIsNullId(void) {
  return Expression::Id::RefIsNullId;
}
BinaryenExpressionId BinaryenRefFuncId(void) {
  return Expression::Id::RefFuncId;
}
BinaryenExpressionId BinaryenTryId(void) { return Expression::Id::TryId; }
BinaryenExpressionId BinaryenThrowId(void) { return Expression::Id::ThrowId; }
BinaryenExpressionId BinaryenRethrowId(void) {
  return Expression::Id::RethrowId;
}
BinaryenExpressionId BinaryenBrOnExnId(void) {
  return Expression::Id::BrOnExnId;
}
BinaryenExpressionId BinaryenTupleMakeId(void) {
  return Expression::Id::TupleMakeId;
}
BinaryenExpressionId BinaryenTupleExtractId(void) {
  return Expression::Id::TupleExtractId;
}
BinaryenExpressionId BinaryenPopId(void) { return Expression::Id::PopId; }

// External kinds

BinaryenExternalKind BinaryenExternalFunction(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Function);
}
BinaryenExternalKind BinaryenExternalTable(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Table);
}
BinaryenExternalKind BinaryenExternalMemory(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Memory);
}
BinaryenExternalKind BinaryenExternalGlobal(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Global);
}
BinaryenExternalKind BinaryenExternalEvent(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Event);
}

// Features

BinaryenFeatures BinaryenFeatureMVP(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::MVP);
}
BinaryenFeatures BinaryenFeatureAtomics(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Atomics);
}
BinaryenFeatures BinaryenFeatureBulkMemory(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::BulkMemory);
}
BinaryenFeatures BinaryenFeatureMutableGlobals(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::MutableGlobals);
}
BinaryenFeatures BinaryenFeatureNontrappingFPToInt(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::TruncSat);
}
BinaryenFeatures BinaryenFeatureSignExt(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::SignExt);
}
BinaryenFeatures BinaryenFeatureSIMD128(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::SIMD);
}
BinaryenFeatures BinaryenFeatureExceptionHandling(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::ExceptionHandling);
}
BinaryenFeatures BinaryenFeatureTailCall(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::TailCall);
}
BinaryenFeatures BinaryenFeatureReferenceTypes(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::ReferenceTypes);
}
BinaryenFeatures BinaryenFeatureMultivalue(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Multivalue);
}
BinaryenFeatures BinaryenFeatureAll(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::All);
}

// Modules

BinaryenModuleRef BinaryenModuleCreate(void) { return new Module(); }
void BinaryenModuleDispose(BinaryenModuleRef module) { delete (Module*)module; }

// Literals

BinaryenLiteral BinaryenLiteralInt32(int32_t x) {
  return toBinaryenLiteral(Literal(x));
}
BinaryenLiteral BinaryenLiteralInt64(int64_t x) {
  return toBinaryenLiteral(Literal(x));
}
BinaryenLiteral BinaryenLiteralFloat32(float x) {
  return toBinaryenLiteral(Literal(x));
}
BinaryenLiteral BinaryenLiteralFloat64(double x) {
  return toBinaryenLiteral(Literal(x));
}
BinaryenLiteral BinaryenLiteralVec128(const uint8_t x[16]) {
  return toBinaryenLiteral(Literal(x));
}
BinaryenLiteral BinaryenLiteralFloat32Bits(int32_t x) {
  return toBinaryenLiteral(Literal(x).castToF32());
}
BinaryenLiteral BinaryenLiteralFloat64Bits(int64_t x) {
  return toBinaryenLiteral(Literal(x).castToF64());
}

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
BinaryenOp BinaryenConvertSInt32ToFloat32(void) {
  return ConvertSInt32ToFloat32;
}
BinaryenOp BinaryenConvertSInt32ToFloat64(void) {
  return ConvertSInt32ToFloat64;
}
BinaryenOp BinaryenConvertUInt32ToFloat32(void) {
  return ConvertUInt32ToFloat32;
}
BinaryenOp BinaryenConvertUInt32ToFloat64(void) {
  return ConvertUInt32ToFloat64;
}
BinaryenOp BinaryenConvertSInt64ToFloat32(void) {
  return ConvertSInt64ToFloat32;
}
BinaryenOp BinaryenConvertSInt64ToFloat64(void) {
  return ConvertSInt64ToFloat64;
}
BinaryenOp BinaryenConvertUInt64ToFloat32(void) {
  return ConvertUInt64ToFloat32;
}
BinaryenOp BinaryenConvertUInt64ToFloat64(void) {
  return ConvertUInt64ToFloat64;
}
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
BinaryenOp BinaryenMemorySize(void) { return MemorySize; }
BinaryenOp BinaryenMemoryGrow(void) { return MemoryGrow; }
BinaryenOp BinaryenAtomicRMWAdd(void) { return AtomicRMWOp::Add; }
BinaryenOp BinaryenAtomicRMWSub(void) { return AtomicRMWOp::Sub; }
BinaryenOp BinaryenAtomicRMWAnd(void) { return AtomicRMWOp::And; }
BinaryenOp BinaryenAtomicRMWOr(void) { return AtomicRMWOp::Or; }
BinaryenOp BinaryenAtomicRMWXor(void) { return AtomicRMWOp::Xor; }
BinaryenOp BinaryenAtomicRMWXchg(void) { return AtomicRMWOp::Xchg; }
BinaryenOp BinaryenTruncSatSFloat32ToInt32(void) {
  return TruncSatSFloat32ToInt32;
}
BinaryenOp BinaryenTruncSatSFloat32ToInt64(void) {
  return TruncSatSFloat32ToInt64;
}
BinaryenOp BinaryenTruncSatUFloat32ToInt32(void) {
  return TruncSatUFloat32ToInt32;
}
BinaryenOp BinaryenTruncSatUFloat32ToInt64(void) {
  return TruncSatUFloat32ToInt64;
}
BinaryenOp BinaryenTruncSatSFloat64ToInt32(void) {
  return TruncSatSFloat64ToInt32;
}
BinaryenOp BinaryenTruncSatSFloat64ToInt64(void) {
  return TruncSatSFloat64ToInt64;
}
BinaryenOp BinaryenTruncSatUFloat64ToInt32(void) {
  return TruncSatUFloat64ToInt32;
}
BinaryenOp BinaryenTruncSatUFloat64ToInt64(void) {
  return TruncSatUFloat64ToInt64;
}
BinaryenOp BinaryenSplatVecI8x16(void) { return SplatVecI8x16; }
BinaryenOp BinaryenExtractLaneSVecI8x16(void) { return ExtractLaneSVecI8x16; }
BinaryenOp BinaryenExtractLaneUVecI8x16(void) { return ExtractLaneUVecI8x16; }
BinaryenOp BinaryenReplaceLaneVecI8x16(void) { return ReplaceLaneVecI8x16; }
BinaryenOp BinaryenSplatVecI16x8(void) { return SplatVecI16x8; }
BinaryenOp BinaryenExtractLaneSVecI16x8(void) { return ExtractLaneSVecI16x8; }
BinaryenOp BinaryenExtractLaneUVecI16x8(void) { return ExtractLaneUVecI16x8; }
BinaryenOp BinaryenReplaceLaneVecI16x8(void) { return ReplaceLaneVecI16x8; }
BinaryenOp BinaryenSplatVecI32x4(void) { return SplatVecI32x4; }
BinaryenOp BinaryenExtractLaneVecI32x4(void) { return ExtractLaneVecI32x4; }
BinaryenOp BinaryenReplaceLaneVecI32x4(void) { return ReplaceLaneVecI32x4; }
BinaryenOp BinaryenSplatVecI64x2(void) { return SplatVecI64x2; }
BinaryenOp BinaryenExtractLaneVecI64x2(void) { return ExtractLaneVecI64x2; }
BinaryenOp BinaryenReplaceLaneVecI64x2(void) { return ReplaceLaneVecI64x2; }
BinaryenOp BinaryenSplatVecF32x4(void) { return SplatVecF32x4; }
BinaryenOp BinaryenExtractLaneVecF32x4(void) { return ExtractLaneVecF32x4; }
BinaryenOp BinaryenReplaceLaneVecF32x4(void) { return ReplaceLaneVecF32x4; }
BinaryenOp BinaryenSplatVecF64x2(void) { return SplatVecF64x2; }
BinaryenOp BinaryenExtractLaneVecF64x2(void) { return ExtractLaneVecF64x2; }
BinaryenOp BinaryenReplaceLaneVecF64x2(void) { return ReplaceLaneVecF64x2; }
BinaryenOp BinaryenEqVecI8x16(void) { return EqVecI8x16; }
BinaryenOp BinaryenNeVecI8x16(void) { return NeVecI8x16; }
BinaryenOp BinaryenLtSVecI8x16(void) { return LtSVecI8x16; }
BinaryenOp BinaryenLtUVecI8x16(void) { return LtUVecI8x16; }
BinaryenOp BinaryenGtSVecI8x16(void) { return GtSVecI8x16; }
BinaryenOp BinaryenGtUVecI8x16(void) { return GtUVecI8x16; }
BinaryenOp BinaryenLeSVecI8x16(void) { return LeSVecI8x16; }
BinaryenOp BinaryenLeUVecI8x16(void) { return LeUVecI8x16; }
BinaryenOp BinaryenGeSVecI8x16(void) { return GeSVecI8x16; }
BinaryenOp BinaryenGeUVecI8x16(void) { return GeUVecI8x16; }
BinaryenOp BinaryenEqVecI16x8(void) { return EqVecI16x8; }
BinaryenOp BinaryenNeVecI16x8(void) { return NeVecI16x8; }
BinaryenOp BinaryenLtSVecI16x8(void) { return LtSVecI16x8; }
BinaryenOp BinaryenLtUVecI16x8(void) { return LtUVecI16x8; }
BinaryenOp BinaryenGtSVecI16x8(void) { return GtSVecI16x8; }
BinaryenOp BinaryenGtUVecI16x8(void) { return GtUVecI16x8; }
BinaryenOp BinaryenLeSVecI16x8(void) { return LeSVecI16x8; }
BinaryenOp BinaryenLeUVecI16x8(void) { return LeUVecI16x8; }
BinaryenOp BinaryenGeSVecI16x8(void) { return GeSVecI16x8; }
BinaryenOp BinaryenGeUVecI16x8(void) { return GeUVecI16x8; }
BinaryenOp BinaryenEqVecI32x4(void) { return EqVecI32x4; }
BinaryenOp BinaryenNeVecI32x4(void) { return NeVecI32x4; }
BinaryenOp BinaryenLtSVecI32x4(void) { return LtSVecI32x4; }
BinaryenOp BinaryenLtUVecI32x4(void) { return LtUVecI32x4; }
BinaryenOp BinaryenGtSVecI32x4(void) { return GtSVecI32x4; }
BinaryenOp BinaryenGtUVecI32x4(void) { return GtUVecI32x4; }
BinaryenOp BinaryenLeSVecI32x4(void) { return LeSVecI32x4; }
BinaryenOp BinaryenLeUVecI32x4(void) { return LeUVecI32x4; }
BinaryenOp BinaryenGeSVecI32x4(void) { return GeSVecI32x4; }
BinaryenOp BinaryenGeUVecI32x4(void) { return GeUVecI32x4; }
BinaryenOp BinaryenEqVecF32x4(void) { return EqVecF32x4; }
BinaryenOp BinaryenNeVecF32x4(void) { return NeVecF32x4; }
BinaryenOp BinaryenLtVecF32x4(void) { return LtVecF32x4; }
BinaryenOp BinaryenGtVecF32x4(void) { return GtVecF32x4; }
BinaryenOp BinaryenLeVecF32x4(void) { return LeVecF32x4; }
BinaryenOp BinaryenGeVecF32x4(void) { return GeVecF32x4; }
BinaryenOp BinaryenEqVecF64x2(void) { return EqVecF64x2; }
BinaryenOp BinaryenNeVecF64x2(void) { return NeVecF64x2; }
BinaryenOp BinaryenLtVecF64x2(void) { return LtVecF64x2; }
BinaryenOp BinaryenGtVecF64x2(void) { return GtVecF64x2; }
BinaryenOp BinaryenLeVecF64x2(void) { return LeVecF64x2; }
BinaryenOp BinaryenGeVecF64x2(void) { return GeVecF64x2; }
BinaryenOp BinaryenNotVec128(void) { return NotVec128; }
BinaryenOp BinaryenAndVec128(void) { return AndVec128; }
BinaryenOp BinaryenOrVec128(void) { return OrVec128; }
BinaryenOp BinaryenXorVec128(void) { return XorVec128; }
BinaryenOp BinaryenAndNotVec128(void) { return AndNotVec128; }
BinaryenOp BinaryenBitselectVec128(void) { return Bitselect; }
BinaryenOp BinaryenAbsVecI8x16(void) { return AbsVecI8x16; }
BinaryenOp BinaryenNegVecI8x16(void) { return NegVecI8x16; }
BinaryenOp BinaryenAnyTrueVecI8x16(void) { return AnyTrueVecI8x16; }
BinaryenOp BinaryenAllTrueVecI8x16(void) { return AllTrueVecI8x16; }
BinaryenOp BinaryenBitmaskVecI8x16(void) { return BitmaskVecI8x16; }
BinaryenOp BinaryenShlVecI8x16(void) { return ShlVecI8x16; }
BinaryenOp BinaryenShrSVecI8x16(void) { return ShrSVecI8x16; }
BinaryenOp BinaryenShrUVecI8x16(void) { return ShrUVecI8x16; }
BinaryenOp BinaryenAddVecI8x16(void) { return AddVecI8x16; }
BinaryenOp BinaryenAddSatSVecI8x16(void) { return AddSatSVecI8x16; }
BinaryenOp BinaryenAddSatUVecI8x16(void) { return AddSatUVecI8x16; }
BinaryenOp BinaryenSubVecI8x16(void) { return SubVecI8x16; }
BinaryenOp BinaryenSubSatSVecI8x16(void) { return SubSatSVecI8x16; }
BinaryenOp BinaryenSubSatUVecI8x16(void) { return SubSatUVecI8x16; }
BinaryenOp BinaryenMulVecI8x16(void) { return MulVecI8x16; }
BinaryenOp BinaryenMinSVecI8x16(void) { return MinSVecI8x16; }
BinaryenOp BinaryenMinUVecI8x16(void) { return MinUVecI8x16; }
BinaryenOp BinaryenMaxSVecI8x16(void) { return MaxSVecI8x16; }
BinaryenOp BinaryenMaxUVecI8x16(void) { return MaxUVecI8x16; }
BinaryenOp BinaryenAvgrUVecI8x16(void) { return AvgrUVecI8x16; }
BinaryenOp BinaryenAbsVecI16x8(void) { return AbsVecI16x8; }
BinaryenOp BinaryenNegVecI16x8(void) { return NegVecI16x8; }
BinaryenOp BinaryenAnyTrueVecI16x8(void) { return AnyTrueVecI16x8; }
BinaryenOp BinaryenAllTrueVecI16x8(void) { return AllTrueVecI16x8; }
BinaryenOp BinaryenBitmaskVecI16x8(void) { return BitmaskVecI16x8; }
BinaryenOp BinaryenShlVecI16x8(void) { return ShlVecI16x8; }
BinaryenOp BinaryenShrSVecI16x8(void) { return ShrSVecI16x8; }
BinaryenOp BinaryenShrUVecI16x8(void) { return ShrUVecI16x8; }
BinaryenOp BinaryenAddVecI16x8(void) { return AddVecI16x8; }
BinaryenOp BinaryenAddSatSVecI16x8(void) { return AddSatSVecI16x8; }
BinaryenOp BinaryenAddSatUVecI16x8(void) { return AddSatUVecI16x8; }
BinaryenOp BinaryenSubVecI16x8(void) { return SubVecI16x8; }
BinaryenOp BinaryenSubSatSVecI16x8(void) { return SubSatSVecI16x8; }
BinaryenOp BinaryenSubSatUVecI16x8(void) { return SubSatUVecI16x8; }
BinaryenOp BinaryenMulVecI16x8(void) { return MulVecI16x8; }
BinaryenOp BinaryenMinSVecI16x8(void) { return MinSVecI16x8; }
BinaryenOp BinaryenMinUVecI16x8(void) { return MinUVecI16x8; }
BinaryenOp BinaryenMaxSVecI16x8(void) { return MaxSVecI16x8; }
BinaryenOp BinaryenMaxUVecI16x8(void) { return MaxUVecI16x8; }
BinaryenOp BinaryenAvgrUVecI16x8(void) { return AvgrUVecI16x8; }
BinaryenOp BinaryenAbsVecI32x4(void) { return AbsVecI32x4; }
BinaryenOp BinaryenNegVecI32x4(void) { return NegVecI32x4; }
BinaryenOp BinaryenAnyTrueVecI32x4(void) { return AnyTrueVecI32x4; }
BinaryenOp BinaryenAllTrueVecI32x4(void) { return AllTrueVecI32x4; }
BinaryenOp BinaryenBitmaskVecI32x4(void) { return BitmaskVecI32x4; }
BinaryenOp BinaryenShlVecI32x4(void) { return ShlVecI32x4; }
BinaryenOp BinaryenShrSVecI32x4(void) { return ShrSVecI32x4; }
BinaryenOp BinaryenShrUVecI32x4(void) { return ShrUVecI32x4; }
BinaryenOp BinaryenAddVecI32x4(void) { return AddVecI32x4; }
BinaryenOp BinaryenSubVecI32x4(void) { return SubVecI32x4; }
BinaryenOp BinaryenMulVecI32x4(void) { return MulVecI32x4; }
BinaryenOp BinaryenMinSVecI32x4(void) { return MinSVecI32x4; }
BinaryenOp BinaryenMinUVecI32x4(void) { return MinUVecI32x4; }
BinaryenOp BinaryenMaxSVecI32x4(void) { return MaxSVecI32x4; }
BinaryenOp BinaryenMaxUVecI32x4(void) { return MaxUVecI32x4; }
BinaryenOp BinaryenDotSVecI16x8ToVecI32x4(void) {
  return DotSVecI16x8ToVecI32x4;
}
BinaryenOp BinaryenNegVecI64x2(void) { return NegVecI64x2; }
BinaryenOp BinaryenAnyTrueVecI64x2(void) { return AnyTrueVecI64x2; }
BinaryenOp BinaryenAllTrueVecI64x2(void) { return AllTrueVecI64x2; }
BinaryenOp BinaryenShlVecI64x2(void) { return ShlVecI64x2; }
BinaryenOp BinaryenShrSVecI64x2(void) { return ShrSVecI64x2; }
BinaryenOp BinaryenShrUVecI64x2(void) { return ShrUVecI64x2; }
BinaryenOp BinaryenAddVecI64x2(void) { return AddVecI64x2; }
BinaryenOp BinaryenSubVecI64x2(void) { return SubVecI64x2; }
BinaryenOp BinaryenMulVecI64x2(void) { return MulVecI64x2; }
BinaryenOp BinaryenAbsVecF32x4(void) { return AbsVecF32x4; }
BinaryenOp BinaryenNegVecF32x4(void) { return NegVecF32x4; }
BinaryenOp BinaryenSqrtVecF32x4(void) { return SqrtVecF32x4; }
BinaryenOp BinaryenQFMAVecF32x4(void) { return QFMAF32x4; }
BinaryenOp BinaryenQFMSVecF32x4(void) { return QFMSF32x4; }
BinaryenOp BinaryenAddVecF32x4(void) { return AddVecF32x4; }
BinaryenOp BinaryenSubVecF32x4(void) { return SubVecF32x4; }
BinaryenOp BinaryenMulVecF32x4(void) { return MulVecF32x4; }
BinaryenOp BinaryenDivVecF32x4(void) { return DivVecF32x4; }
BinaryenOp BinaryenMinVecF32x4(void) { return MinVecF32x4; }
BinaryenOp BinaryenMaxVecF32x4(void) { return MaxVecF32x4; }
BinaryenOp BinaryenPMinVecF32x4(void) { return PMinVecF32x4; }
BinaryenOp BinaryenCeilVecF32x4(void) { return CeilVecF32x4; }
BinaryenOp BinaryenFloorVecF32x4(void) { return FloorVecF32x4; }
BinaryenOp BinaryenTruncVecF32x4(void) { return TruncVecF32x4; }
BinaryenOp BinaryenNearestVecF32x4(void) { return NearestVecF32x4; }
BinaryenOp BinaryenPMaxVecF32x4(void) { return PMaxVecF32x4; }
BinaryenOp BinaryenAbsVecF64x2(void) { return AbsVecF64x2; }
BinaryenOp BinaryenNegVecF64x2(void) { return NegVecF64x2; }
BinaryenOp BinaryenSqrtVecF64x2(void) { return SqrtVecF64x2; }
BinaryenOp BinaryenQFMAVecF64x2(void) { return QFMAF64x2; }
BinaryenOp BinaryenQFMSVecF64x2(void) { return QFMSF64x2; }
BinaryenOp BinaryenAddVecF64x2(void) { return AddVecF64x2; }
BinaryenOp BinaryenSubVecF64x2(void) { return SubVecF64x2; }
BinaryenOp BinaryenMulVecF64x2(void) { return MulVecF64x2; }
BinaryenOp BinaryenDivVecF64x2(void) { return DivVecF64x2; }
BinaryenOp BinaryenMinVecF64x2(void) { return MinVecF64x2; }
BinaryenOp BinaryenMaxVecF64x2(void) { return MaxVecF64x2; }
BinaryenOp BinaryenPMinVecF64x2(void) { return PMinVecF64x2; }
BinaryenOp BinaryenPMaxVecF64x2(void) { return PMaxVecF64x2; }
BinaryenOp BinaryenCeilVecF64x2(void) { return CeilVecF64x2; }
BinaryenOp BinaryenFloorVecF64x2(void) { return FloorVecF64x2; }
BinaryenOp BinaryenTruncVecF64x2(void) { return TruncVecF64x2; }
BinaryenOp BinaryenNearestVecF64x2(void) { return NearestVecF64x2; }
BinaryenOp BinaryenTruncSatSVecF32x4ToVecI32x4(void) {
  return TruncSatSVecF32x4ToVecI32x4;
}
BinaryenOp BinaryenTruncSatUVecF32x4ToVecI32x4(void) {
  return TruncSatUVecF32x4ToVecI32x4;
}
BinaryenOp BinaryenTruncSatSVecF64x2ToVecI64x2(void) {
  return TruncSatSVecF64x2ToVecI64x2;
}
BinaryenOp BinaryenTruncSatUVecF64x2ToVecI64x2(void) {
  return TruncSatUVecF64x2ToVecI64x2;
}
BinaryenOp BinaryenConvertSVecI32x4ToVecF32x4(void) {
  return ConvertSVecI32x4ToVecF32x4;
}
BinaryenOp BinaryenConvertUVecI32x4ToVecF32x4(void) {
  return ConvertUVecI32x4ToVecF32x4;
}
BinaryenOp BinaryenConvertSVecI64x2ToVecF64x2(void) {
  return ConvertSVecI64x2ToVecF64x2;
}
BinaryenOp BinaryenConvertUVecI64x2ToVecF64x2(void) {
  return ConvertUVecI64x2ToVecF64x2;
}
BinaryenOp BinaryenLoadSplatVec8x16(void) { return LoadSplatVec8x16; }
BinaryenOp BinaryenLoadSplatVec16x8(void) { return LoadSplatVec16x8; }
BinaryenOp BinaryenLoadSplatVec32x4(void) { return LoadSplatVec32x4; }
BinaryenOp BinaryenLoadSplatVec64x2(void) { return LoadSplatVec64x2; }
BinaryenOp BinaryenLoadExtSVec8x8ToVecI16x8(void) {
  return LoadExtSVec8x8ToVecI16x8;
}
BinaryenOp BinaryenLoadExtUVec8x8ToVecI16x8(void) {
  return LoadExtUVec8x8ToVecI16x8;
}
BinaryenOp BinaryenLoadExtSVec16x4ToVecI32x4(void) {
  return LoadExtSVec16x4ToVecI32x4;
}
BinaryenOp BinaryenLoadExtUVec16x4ToVecI32x4(void) {
  return LoadExtUVec16x4ToVecI32x4;
}
BinaryenOp BinaryenLoadExtSVec32x2ToVecI64x2(void) {
  return LoadExtSVec32x2ToVecI64x2;
}
BinaryenOp BinaryenLoadExtUVec32x2ToVecI64x2(void) {
  return LoadExtUVec32x2ToVecI64x2;
}
BinaryenOp BinaryenNarrowSVecI16x8ToVecI8x16(void) {
  return NarrowSVecI16x8ToVecI8x16;
}
BinaryenOp BinaryenNarrowUVecI16x8ToVecI8x16(void) {
  return NarrowUVecI16x8ToVecI8x16;
}
BinaryenOp BinaryenNarrowSVecI32x4ToVecI16x8(void) {
  return NarrowSVecI32x4ToVecI16x8;
}
BinaryenOp BinaryenNarrowUVecI32x4ToVecI16x8(void) {
  return NarrowUVecI32x4ToVecI16x8;
}
BinaryenOp BinaryenWidenLowSVecI8x16ToVecI16x8(void) {
  return WidenLowSVecI8x16ToVecI16x8;
}
BinaryenOp BinaryenWidenHighSVecI8x16ToVecI16x8(void) {
  return WidenHighSVecI8x16ToVecI16x8;
}
BinaryenOp BinaryenWidenLowUVecI8x16ToVecI16x8(void) {
  return WidenLowUVecI8x16ToVecI16x8;
}
BinaryenOp BinaryenWidenHighUVecI8x16ToVecI16x8(void) {
  return WidenHighUVecI8x16ToVecI16x8;
}
BinaryenOp BinaryenWidenLowSVecI16x8ToVecI32x4(void) {
  return WidenLowSVecI16x8ToVecI32x4;
}
BinaryenOp BinaryenWidenHighSVecI16x8ToVecI32x4(void) {
  return WidenHighSVecI16x8ToVecI32x4;
}
BinaryenOp BinaryenWidenLowUVecI16x8ToVecI32x4(void) {
  return WidenLowUVecI16x8ToVecI32x4;
}
BinaryenOp BinaryenWidenHighUVecI16x8ToVecI32x4(void) {
  return WidenHighUVecI16x8ToVecI32x4;
}
BinaryenOp BinaryenSwizzleVec8x16(void) { return SwizzleVec8x16; }

BinaryenExpressionRef BinaryenBlock(BinaryenModuleRef module,
                                    const char* name,
                                    BinaryenExpressionRef* children,
                                    BinaryenIndex numChildren,
                                    BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<Block>();
  if (name) {
    ret->name = name;
  }
  for (BinaryenIndex i = 0; i < numChildren; i++) {
    ret->list.push_back((Expression*)children[i]);
  }
  if (type != BinaryenTypeAuto()) {
    ret->finalize(Type(type));
  } else {
    ret->finalize();
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenIf(BinaryenModuleRef module,
                                 BinaryenExpressionRef condition,
                                 BinaryenExpressionRef ifTrue,
                                 BinaryenExpressionRef ifFalse) {
  auto* ret = ((Module*)module)->allocator.alloc<If>();
  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module,
                                   const char* name,
                                   BinaryenExpressionRef body) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeLoop(name ? Name(name) : Name(), (Expression*)body));
}
BinaryenExpressionRef BinaryenBreak(BinaryenModuleRef module,
                                    const char* name,
                                    BinaryenExpressionRef condition,
                                    BinaryenExpressionRef value) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeBreak(name, (Expression*)value, (Expression*)condition));
}
BinaryenExpressionRef BinaryenSwitch(BinaryenModuleRef module,
                                     const char** names,
                                     BinaryenIndex numNames,
                                     const char* defaultName,
                                     BinaryenExpressionRef condition,
                                     BinaryenExpressionRef value) {
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
static BinaryenExpressionRef makeBinaryenCall(BinaryenModuleRef module,
                                              const char* target,
                                              BinaryenExpressionRef* operands,
                                              BinaryenIndex numOperands,
                                              BinaryenType returnType,
                                              bool isReturn) {
  auto* ret = ((Module*)module)->allocator.alloc<Call>();
  ret->target = target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->type = Type(returnType);
  ret->isReturn = isReturn;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module,
                                   const char* target,
                                   BinaryenExpressionRef* operands,
                                   BinaryenIndex numOperands,
                                   BinaryenType returnType) {
  return makeBinaryenCall(
    module, target, operands, numOperands, returnType, false);
}
BinaryenExpressionRef BinaryenReturnCall(BinaryenModuleRef module,
                                         const char* target,
                                         BinaryenExpressionRef* operands,
                                         BinaryenIndex numOperands,
                                         BinaryenType returnType) {
  return makeBinaryenCall(
    module, target, operands, numOperands, returnType, true);
}
static BinaryenExpressionRef
makeBinaryenCallIndirect(BinaryenModuleRef module,
                         BinaryenExpressionRef target,
                         BinaryenExpressionRef* operands,
                         BinaryenIndex numOperands,
                         BinaryenType params,
                         BinaryenType results,
                         bool isReturn) {
  auto* ret = ((Module*)module)->allocator.alloc<CallIndirect>();
  ret->target = (Expression*)target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->sig = Signature(Type(params), Type(results));
  ret->type = Type(results);
  ret->isReturn = isReturn;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenCallIndirect(BinaryenModuleRef module,
                                           BinaryenExpressionRef target,
                                           BinaryenExpressionRef* operands,
                                           BinaryenIndex numOperands,
                                           BinaryenType params,
                                           BinaryenType results) {
  return makeBinaryenCallIndirect(
    module, target, operands, numOperands, params, results, false);
}
BinaryenExpressionRef
BinaryenReturnCallIndirect(BinaryenModuleRef module,
                           BinaryenExpressionRef target,
                           BinaryenExpressionRef* operands,
                           BinaryenIndex numOperands,
                           BinaryenType params,
                           BinaryenType results) {
  return makeBinaryenCallIndirect(
    module, target, operands, numOperands, params, results, true);
}
BinaryenExpressionRef BinaryenLocalGet(BinaryenModuleRef module,
                                       BinaryenIndex index,
                                       BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<LocalGet>();
  ret->index = index;
  ret->type = Type(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLocalSet(BinaryenModuleRef module,
                                       BinaryenIndex index,
                                       BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<LocalSet>();
  ret->index = index;
  ret->value = (Expression*)value;
  ret->makeSet();
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLocalTee(BinaryenModuleRef module,
                                       BinaryenIndex index,
                                       BinaryenExpressionRef value,
                                       BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<LocalSet>();
  ret->index = index;
  ret->value = (Expression*)value;
  ret->makeTee(Type(type));
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenGlobalGet(BinaryenModuleRef module,
                                        const char* name,
                                        BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<GlobalGet>();
  ret->name = name;
  ret->type = Type(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenGlobalSet(BinaryenModuleRef module,
                                        const char* name,
                                        BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<GlobalSet>();
  ret->name = name;
  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module,
                                   uint32_t bytes,
                                   int8_t signed_,
                                   uint32_t offset,
                                   uint32_t align,
                                   BinaryenType type,
                                   BinaryenExpressionRef ptr) {
  auto* ret = ((Module*)module)->allocator.alloc<Load>();
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
BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module,
                                    uint32_t bytes,
                                    uint32_t offset,
                                    uint32_t align,
                                    BinaryenExpressionRef ptr,
                                    BinaryenExpressionRef value,
                                    BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<Store>();
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
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module,
                                    BinaryenLiteral value) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeConst(fromBinaryenLiteral(value)));
}
BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module,
                                    BinaryenOp op,
                                    BinaryenExpressionRef value) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeUnary(UnaryOp(op), (Expression*)value));
}
BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module,
                                     BinaryenOp op,
                                     BinaryenExpressionRef left,
                                     BinaryenExpressionRef right) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeBinary(BinaryOp(op), (Expression*)left, (Expression*)right));
}
BinaryenExpressionRef BinaryenSelect(BinaryenModuleRef module,
                                     BinaryenExpressionRef condition,
                                     BinaryenExpressionRef ifTrue,
                                     BinaryenExpressionRef ifFalse,
                                     BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<Select>();
  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  if (type != BinaryenTypeAuto()) {
    ret->finalize(Type(type));
  } else {
    ret->finalize();
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenDrop(BinaryenModuleRef module,
                                   BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<Drop>();
  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module,
                                     BinaryenExpressionRef value) {
  auto* ret = Builder(*(Module*)module).makeReturn((Expression*)value);
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module,
                                   BinaryenOp op,
                                   const char* name,
                                   BinaryenExpressionRef* operands,
                                   BinaryenIndex numOperands) {
  auto* ret = ((Module*)module)->allocator.alloc<Host>();
  ret->op = HostOp(op);
  if (name) {
    ret->nameOperand = name;
  }
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
  return static_cast<Expression*>(
    ((Module*)module)->allocator.alloc<Unreachable>());
}
BinaryenExpressionRef BinaryenAtomicLoad(BinaryenModuleRef module,
                                         uint32_t bytes,
                                         uint32_t offset,
                                         BinaryenType type,
                                         BinaryenExpressionRef ptr) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeAtomicLoad(bytes, offset, (Expression*)ptr, Type(type)));
}
BinaryenExpressionRef BinaryenAtomicStore(BinaryenModuleRef module,
                                          uint32_t bytes,
                                          uint32_t offset,
                                          BinaryenExpressionRef ptr,
                                          BinaryenExpressionRef value,
                                          BinaryenType type) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeAtomicStore(
        bytes, offset, (Expression*)ptr, (Expression*)value, Type(type)));
}
BinaryenExpressionRef BinaryenAtomicRMW(BinaryenModuleRef module,
                                        BinaryenOp op,
                                        BinaryenIndex bytes,
                                        BinaryenIndex offset,
                                        BinaryenExpressionRef ptr,
                                        BinaryenExpressionRef value,
                                        BinaryenType type) {
  return static_cast<Expression*>(Builder(*(Module*)module)
                                    .makeAtomicRMW(AtomicRMWOp(op),
                                                   bytes,
                                                   offset,
                                                   (Expression*)ptr,
                                                   (Expression*)value,
                                                   Type(type)));
}
BinaryenExpressionRef BinaryenAtomicCmpxchg(BinaryenModuleRef module,
                                            BinaryenIndex bytes,
                                            BinaryenIndex offset,
                                            BinaryenExpressionRef ptr,
                                            BinaryenExpressionRef expected,
                                            BinaryenExpressionRef replacement,
                                            BinaryenType type) {
  return static_cast<Expression*>(Builder(*(Module*)module)
                                    .makeAtomicCmpxchg(bytes,
                                                       offset,
                                                       (Expression*)ptr,
                                                       (Expression*)expected,
                                                       (Expression*)replacement,
                                                       Type(type)));
}
BinaryenExpressionRef BinaryenAtomicWait(BinaryenModuleRef module,
                                         BinaryenExpressionRef ptr,
                                         BinaryenExpressionRef expected,
                                         BinaryenExpressionRef timeout,
                                         BinaryenType expectedType) {
  return static_cast<Expression*>(Builder(*(Module*)module)
                                    .makeAtomicWait((Expression*)ptr,
                                                    (Expression*)expected,
                                                    (Expression*)timeout,
                                                    Type(expectedType),
                                                    0));
}
BinaryenExpressionRef BinaryenAtomicNotify(BinaryenModuleRef module,
                                           BinaryenExpressionRef ptr,
                                           BinaryenExpressionRef notifyCount) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeAtomicNotify((Expression*)ptr, (Expression*)notifyCount, 0));
}
BinaryenExpressionRef BinaryenAtomicFence(BinaryenModuleRef module) {
  return static_cast<Expression*>(Builder(*(Module*)module).makeAtomicFence());
}
BinaryenExpressionRef BinaryenSIMDExtract(BinaryenModuleRef module,
                                          BinaryenOp op,
                                          BinaryenExpressionRef vec,
                                          uint8_t index) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeSIMDExtract(SIMDExtractOp(op), (Expression*)vec, index));
}
BinaryenExpressionRef BinaryenSIMDReplace(BinaryenModuleRef module,
                                          BinaryenOp op,
                                          BinaryenExpressionRef vec,
                                          uint8_t index,
                                          BinaryenExpressionRef value) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeSIMDReplace(
        SIMDReplaceOp(op), (Expression*)vec, index, (Expression*)value));
}
BinaryenExpressionRef BinaryenSIMDShuffle(BinaryenModuleRef module,
                                          BinaryenExpressionRef left,
                                          BinaryenExpressionRef right,
                                          const uint8_t mask_[16]) {
  assert(mask_); // nullptr would be wrong
  std::array<uint8_t, 16> mask;
  memcpy(mask.data(), mask_, 16);
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeSIMDShuffle((Expression*)left, (Expression*)right, mask));
}
BinaryenExpressionRef BinaryenSIMDTernary(BinaryenModuleRef module,
                                          BinaryenOp op,
                                          BinaryenExpressionRef a,
                                          BinaryenExpressionRef b,
                                          BinaryenExpressionRef c) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeSIMDTernary(
        SIMDTernaryOp(op), (Expression*)a, (Expression*)b, (Expression*)c));
}
BinaryenExpressionRef BinaryenSIMDShift(BinaryenModuleRef module,
                                        BinaryenOp op,
                                        BinaryenExpressionRef vec,
                                        BinaryenExpressionRef shift) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeSIMDShift(SIMDShiftOp(op), (Expression*)vec, (Expression*)shift));
}
BinaryenExpressionRef BinaryenSIMDLoad(BinaryenModuleRef module,
                                       BinaryenOp op,
                                       uint32_t offset,
                                       uint32_t align,
                                       BinaryenExpressionRef ptr) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeSIMDLoad(
        SIMDLoadOp(op), Address(offset), Address(align), (Expression*)ptr));
}
BinaryenExpressionRef BinaryenMemoryInit(BinaryenModuleRef module,
                                         uint32_t segment,
                                         BinaryenExpressionRef dest,
                                         BinaryenExpressionRef offset,
                                         BinaryenExpressionRef size) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeMemoryInit(
        segment, (Expression*)dest, (Expression*)offset, (Expression*)size));
}

BinaryenExpressionRef BinaryenDataDrop(BinaryenModuleRef module,
                                       uint32_t segment) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeDataDrop(segment));
}

BinaryenExpressionRef BinaryenMemoryCopy(BinaryenModuleRef module,
                                         BinaryenExpressionRef dest,
                                         BinaryenExpressionRef source,
                                         BinaryenExpressionRef size) {
  return static_cast<Expression*>(Builder(*(Module*)module)
                                    .makeMemoryCopy((Expression*)dest,
                                                    (Expression*)source,
                                                    (Expression*)size));
}

BinaryenExpressionRef BinaryenMemoryFill(BinaryenModuleRef module,
                                         BinaryenExpressionRef dest,
                                         BinaryenExpressionRef value,
                                         BinaryenExpressionRef size) {
  return static_cast<Expression*>(Builder(*(Module*)module)
                                    .makeMemoryFill((Expression*)dest,
                                                    (Expression*)value,
                                                    (Expression*)size));
}

BinaryenExpressionRef BinaryenTupleMake(BinaryenModuleRef module,
                                        BinaryenExpressionRef* operands,
                                        BinaryenIndex numOperands) {
  std::vector<Expression*> ops;
  ops.resize(numOperands);
  for (size_t i = 0; i < numOperands; ++i) {
    ops[i] = (Expression*)operands[i];
  }
  return static_cast<Expression*>(Builder(*(Module*)module).makeTupleMake(ops));
}

BinaryenExpressionRef BinaryenTupleExtract(BinaryenModuleRef module,
                                           BinaryenExpressionRef tuple,
                                           BinaryenIndex index) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeTupleExtract((Expression*)tuple, index));
}

BinaryenExpressionRef BinaryenPop(BinaryenModuleRef module, BinaryenType type) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makePop(Type(type)));
}

BinaryenExpressionRef BinaryenRefNull(BinaryenModuleRef module) {
  return static_cast<Expression*>(Builder(*(Module*)module).makeRefNull());
}

BinaryenExpressionRef BinaryenRefIsNull(BinaryenModuleRef module,
                                        BinaryenExpressionRef value) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeRefIsNull((Expression*)value));
}

BinaryenExpressionRef BinaryenRefFunc(BinaryenModuleRef module,
                                      const char* func) {
  return static_cast<Expression*>(Builder(*(Module*)module).makeRefFunc(func));
}

BinaryenExpressionRef BinaryenTry(BinaryenModuleRef module,
                                  BinaryenExpressionRef body,
                                  BinaryenExpressionRef catchBody) {
  return static_cast<Expression*>(
    Builder(*(Module*)module)
      .makeTry((Expression*)body, (Expression*)catchBody));
}

BinaryenExpressionRef BinaryenThrow(BinaryenModuleRef module,
                                    const char* event,
                                    BinaryenExpressionRef* operands,
                                    BinaryenIndex numOperands) {
  std::vector<Expression*> args;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    args.push_back((Expression*)operands[i]);
  }
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeThrow(event, args));
}

BinaryenExpressionRef BinaryenRethrow(BinaryenModuleRef module,
                                      BinaryenExpressionRef exnref) {
  return static_cast<Expression*>(
    Builder(*(Module*)module).makeRethrow((Expression*)exnref));
}

BinaryenExpressionRef BinaryenBrOnExn(BinaryenModuleRef module,
                                      const char* name,
                                      const char* eventName,
                                      BinaryenExpressionRef exnref) {
  auto* wasm = (Module*)module;
  auto* event = wasm->getEventOrNull(eventName);
  assert(event && "br_on_exn's event must exist");
  return static_cast<Expression*>(
    Builder(*wasm).makeBrOnExn(name, event, (Expression*)exnref));
}

// Expression utility

BinaryenExpressionId BinaryenExpressionGetId(BinaryenExpressionRef expr) {
  return ((Expression*)expr)->_id;
}
BinaryenType BinaryenExpressionGetType(BinaryenExpressionRef expr) {
  return ((Expression*)expr)->type.getID();
}
void BinaryenExpressionSetType(BinaryenExpressionRef expr, BinaryenType type) {
  ((Expression*)expr)->type = Type(type);
}
void BinaryenExpressionPrint(BinaryenExpressionRef expr) {
  WasmPrinter::printExpression((Expression*)expr, std::cout);
  std::cout << '\n';
}
void BinaryenExpressionFinalize(BinaryenExpressionRef expr) {
  ReFinalizeNode().visit((Expression*)expr);
}

BinaryenExpressionRef BinaryenExpressionCopy(BinaryenExpressionRef expr,
                                             BinaryenModuleRef module) {
  return ExpressionManipulator::copy(expr, *(Module*)module);
}

// Specific expression utility

// Block
const char* BinaryenBlockGetName(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->name.c_str();
}
void BinaryenBlockSetName(BinaryenExpressionRef expr, const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  // may be null or empty
  static_cast<Block*>(expression)->name = name;
}
BinaryenIndex BinaryenBlockGetNumChildren(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->list.size();
}
BinaryenExpressionRef BinaryenBlockGetChildAt(BinaryenExpressionRef expr,
                                              BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  assert(index < static_cast<Block*>(expression)->list.size());
  return static_cast<Block*>(expression)->list[index];
}
void BinaryenBlockSetChildAt(BinaryenExpressionRef expr,
                             BinaryenIndex index,
                             BinaryenExpressionRef childExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  assert(childExpr);
  auto& list = static_cast<Block*>(expression)->list;
  assert(index < list.size());
  list[index] = (Expression*)childExpr;
}
BinaryenIndex BinaryenBlockAppendChild(BinaryenExpressionRef expr,
                                       BinaryenExpressionRef childExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  assert(childExpr);
  auto& list = static_cast<Block*>(expression)->list;
  auto index = list.size();
  list.push_back((Expression*)childExpr);
  return index;
}
void BinaryenBlockInsertChildAt(BinaryenExpressionRef expr,
                                BinaryenIndex index,
                                BinaryenExpressionRef childExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  assert(childExpr);
  static_cast<Block*>(expression)->list.insertAt(index, (Expression*)childExpr);
}
BinaryenExpressionRef BinaryenBlockRemoveChildAt(BinaryenExpressionRef expr,
                                                 BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->list.removeAt(index);
}
// If
BinaryenExpressionRef BinaryenIfGetCondition(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->condition;
}
void BinaryenIfSetCondition(BinaryenExpressionRef expr,
                            BinaryenExpressionRef condExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  assert(condExpr);
  static_cast<If*>(expression)->condition = (Expression*)condExpr;
}
BinaryenExpressionRef BinaryenIfGetIfTrue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->ifTrue;
}
void BinaryenIfSetIfTrue(BinaryenExpressionRef expr,
                         BinaryenExpressionRef ifTrueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  assert(ifTrueExpr);
  static_cast<If*>(expression)->ifTrue = (Expression*)ifTrueExpr;
}
BinaryenExpressionRef BinaryenIfGetIfFalse(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->ifFalse;
}
void BinaryenIfSetIfFalse(BinaryenExpressionRef expr,
                          BinaryenExpressionRef ifFalseExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  // may be null
  static_cast<If*>(expression)->ifFalse = (Expression*)ifFalseExpr;
}
// Loop
const char* BinaryenLoopGetName(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  return static_cast<Loop*>(expression)->name.c_str();
}
void BinaryenLoopSetName(BinaryenExpressionRef expr, const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  // may be null or empty
  static_cast<Loop*>(expression)->name = name;
}
BinaryenExpressionRef BinaryenLoopGetBody(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  return static_cast<Loop*>(expression)->body;
}
void BinaryenLoopSetBody(BinaryenExpressionRef expr,
                         BinaryenExpressionRef bodyExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  assert(bodyExpr);
  static_cast<Loop*>(expression)->body = (Expression*)bodyExpr;
}
// Break
const char* BinaryenBreakGetName(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->name.c_str();
}
void BinaryenBreakSetName(BinaryenExpressionRef expr, const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  assert(name);
  static_cast<Break*>(expression)->name = name;
}
BinaryenExpressionRef BinaryenBreakGetCondition(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->condition;
}
void BinaryenBreakSetCondition(BinaryenExpressionRef expr,
                               BinaryenExpressionRef condExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  // may be null (br)
  static_cast<Break*>(expression)->condition = (Expression*)condExpr;
}
BinaryenExpressionRef BinaryenBreakGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->value;
}
void BinaryenBreakSetValue(BinaryenExpressionRef expr,
                           BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  // may be null
  static_cast<Break*>(expression)->value = (Expression*)valueExpr;
}
// Switch
BinaryenIndex BinaryenSwitchGetNumNames(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->targets.size();
}
const char* BinaryenSwitchGetNameAt(BinaryenExpressionRef expr,
                                    BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  assert(index < static_cast<Switch*>(expression)->targets.size());
  return static_cast<Switch*>(expression)->targets[index].c_str();
}
void BinaryenSwitchSetNameAt(BinaryenExpressionRef expr,
                             BinaryenIndex index,
                             const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  assert(index < static_cast<Switch*>(expression)->targets.size());
  assert(name);
  static_cast<Switch*>(expression)->targets[index] = name;
}
BinaryenIndex BinaryenSwitchAppendName(BinaryenExpressionRef expr,
                                       const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  assert(name);
  auto& list = static_cast<Switch*>(expression)->targets;
  auto index = list.size();
  list.push_back(name);
  return index;
}
void BinaryenSwitchInsertNameAt(BinaryenExpressionRef expr,
                                BinaryenIndex index,
                                const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  assert(name);
  static_cast<Switch*>(expression)->targets.insertAt(index, name);
}
const char* BinaryenSwitchRemoveNameAt(BinaryenExpressionRef expr,
                                       BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->targets.removeAt(index).c_str();
}
const char* BinaryenSwitchGetDefaultName(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->default_.c_str();
}
void BinaryenSwitchSetDefaultName(BinaryenExpressionRef expr,
                                  const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  // may be null or empty
  static_cast<Switch*>(expression)->default_ = name;
}
BinaryenExpressionRef BinaryenSwitchGetCondition(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->condition;
}
void BinaryenSwitchSetCondition(BinaryenExpressionRef expr,
                                BinaryenExpressionRef condExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  assert(condExpr);
  static_cast<Switch*>(expression)->condition = (Expression*)condExpr;
}
BinaryenExpressionRef BinaryenSwitchGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->value;
}
void BinaryenSwitchSetValue(BinaryenExpressionRef expr,
                            BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  // may be null
  static_cast<Switch*>(expression)->value = (Expression*)valueExpr;
}
// Call
const char* BinaryenCallGetTarget(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->target.c_str();
}
void BinaryenCallSetTarget(BinaryenExpressionRef expr, const char* target) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(target);
  static_cast<Call*>(expression)->target = target;
}
BinaryenIndex BinaryenCallGetNumOperands(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenCallGetOperandAt(BinaryenExpressionRef expr,
                                               BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(index < static_cast<Call*>(expression)->operands.size());
  return static_cast<Call*>(expression)->operands[index];
}
void BinaryenCallSetOperandAt(BinaryenExpressionRef expr,
                              BinaryenIndex index,
                              BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(index < static_cast<Call*>(expression)->operands.size());
  assert(operandExpr);
  static_cast<Call*>(expression)->operands[index] = (Expression*)operandExpr;
}
BinaryenIndex BinaryenCallAppendOperand(BinaryenExpressionRef expr,
                                        BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(operandExpr);
  auto& list = static_cast<Call*>(expression)->operands;
  auto index = list.size();
  list.push_back((Expression*)operandExpr);
  return index;
}
void BinaryenCallInsertOperandAt(BinaryenExpressionRef expr,
                                 BinaryenIndex index,
                                 BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(operandExpr);
  static_cast<Call*>(expression)
    ->operands.insertAt(index, (Expression*)operandExpr);
}
BinaryenExpressionRef BinaryenCallRemoveOperandAt(BinaryenExpressionRef expr,
                                                  BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->operands.removeAt(index);
}
int BinaryenCallIsReturn(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->isReturn;
}
void BinaryenCallSetReturn(BinaryenExpressionRef expr, int isReturn) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  static_cast<Call*>(expression)->isReturn = isReturn != 0;
}
// CallIndirect
BinaryenExpressionRef
BinaryenCallIndirectGetTarget(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->target;
}
void BinaryenCallIndirectSetTarget(BinaryenExpressionRef expr,
                                   BinaryenExpressionRef targetExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  assert(targetExpr);
  static_cast<CallIndirect*>(expression)->target = (Expression*)targetExpr;
}
BinaryenIndex BinaryenCallIndirectGetNumOperands(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->operands.size();
}
BinaryenExpressionRef
BinaryenCallIndirectGetOperandAt(BinaryenExpressionRef expr,
                                 BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  assert(index < static_cast<CallIndirect*>(expression)->operands.size());
  return static_cast<CallIndirect*>(expression)->operands[index];
}
void BinaryenCallIndirectSetOperandAt(BinaryenExpressionRef expr,
                                      BinaryenIndex index,
                                      BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  assert(index < static_cast<CallIndirect*>(expression)->operands.size());
  assert(operandExpr);
  static_cast<CallIndirect*>(expression)->operands[index] =
    (Expression*)operandExpr;
}
BinaryenIndex
BinaryenCallIndirectAppendOperand(BinaryenExpressionRef expr,
                                  BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  assert(operandExpr);
  auto& list = static_cast<CallIndirect*>(expression)->operands;
  auto index = list.size();
  list.push_back((Expression*)operandExpr);
  return index;
}
void BinaryenCallIndirectInsertOperandAt(BinaryenExpressionRef expr,
                                         BinaryenIndex index,
                                         BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  assert(operandExpr);
  static_cast<CallIndirect*>(expression)
    ->operands.insertAt(index, (Expression*)operandExpr);
}
BinaryenExpressionRef
BinaryenCallIndirectRemoveOperandAt(BinaryenExpressionRef expr,
                                    BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->operands.removeAt(index);
}
int BinaryenCallIndirectIsReturn(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->isReturn;
}
void BinaryenCallIndirectSetReturn(BinaryenExpressionRef expr, int isReturn) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  static_cast<CallIndirect*>(expression)->isReturn = isReturn != 0;
}
BinaryenType BinaryenCallIndirectGetParams(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->sig.params.getID();
}
void BinaryenCallIndirectSetParams(BinaryenExpressionRef expr,
                                   BinaryenType params) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  static_cast<CallIndirect*>(expression)->sig.params = Type(params);
}
BinaryenType BinaryenCallIndirectGetResults(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->sig.results.getID();
}
void BinaryenCallIndirectSetResults(BinaryenExpressionRef expr,
                                    BinaryenType results) {
  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  static_cast<CallIndirect*>(expression)->sig.results = Type(results);
}
// LocalGet
BinaryenIndex BinaryenLocalGetGetIndex(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<LocalGet>());
  return static_cast<LocalGet*>(expression)->index;
}
void BinaryenLocalGetSetIndex(BinaryenExpressionRef expr, BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<LocalGet>());
  static_cast<LocalGet*>(expression)->index = index;
}
// LocalSet
int BinaryenLocalSetIsTee(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->isTee();
  // has no setter
}
BinaryenIndex BinaryenLocalSetGetIndex(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->index;
}
void BinaryenLocalSetSetIndex(BinaryenExpressionRef expr, BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  static_cast<LocalSet*>(expression)->index = index;
}
BinaryenExpressionRef BinaryenLocalSetGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->value;
}
void BinaryenLocalSetSetValue(BinaryenExpressionRef expr,
                              BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  assert(valueExpr);
  static_cast<LocalSet*>(expression)->value = (Expression*)valueExpr;
}
// GlobalGet
const char* BinaryenGlobalGetGetName(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalGet>());
  return static_cast<GlobalGet*>(expression)->name.c_str();
}
void BinaryenGlobalGetSetName(BinaryenExpressionRef expr, const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalGet>());
  assert(name);
  static_cast<GlobalGet*>(expression)->name = name;
}
// GlobalSet
const char* BinaryenGlobalSetGetName(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalSet>());
  return static_cast<GlobalSet*>(expression)->name.c_str();
}
void BinaryenGlobalSetSetName(BinaryenExpressionRef expr, const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalSet>());
  assert(name);
  static_cast<GlobalSet*>(expression)->name = name;
}
BinaryenExpressionRef BinaryenGlobalSetGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalSet>());
  return static_cast<GlobalSet*>(expression)->value;
}
void BinaryenGlobalSetSetValue(BinaryenExpressionRef expr,
                               BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalSet>());
  assert(valueExpr);
  static_cast<GlobalSet*>(expression)->value = (Expression*)valueExpr;
}
// Host
BinaryenOp BinaryenHostGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->op;
}
void BinaryenHostSetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  static_cast<Host*>(expression)->op = (HostOp)op;
}
const char* BinaryenHostGetNameOperand(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->nameOperand.c_str();
}
void BinaryenHostSetNameOperand(BinaryenExpressionRef expr, const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  static_cast<Host*>(expression)->nameOperand = name ? name : "";
}
BinaryenIndex BinaryenHostGetNumOperands(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenHostGetOperandAt(BinaryenExpressionRef expr,
                                               BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  assert(index < static_cast<Host*>(expression)->operands.size());
  return static_cast<Host*>(expression)->operands[index];
}
void BinaryenHostSetOperandAt(BinaryenExpressionRef expr,
                              BinaryenIndex index,
                              BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  assert(index < static_cast<Host*>(expression)->operands.size());
  assert(operandExpr);
  static_cast<Host*>(expression)->operands[index] = (Expression*)operandExpr;
}
BinaryenIndex BinaryenHostAppendOperand(BinaryenExpressionRef expr,
                                        BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  assert(operandExpr);
  auto& list = static_cast<Host*>(expression)->operands;
  auto index = list.size();
  list.push_back((Expression*)operandExpr);
  return index;
}
void BinaryenHostInsertOperandAt(BinaryenExpressionRef expr,
                                 BinaryenIndex index,
                                 BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  assert(operandExpr);
  static_cast<Host*>(expression)
    ->operands.insertAt(index, (Expression*)operandExpr);
}
BinaryenExpressionRef BinaryenHostRemoveOperandAt(BinaryenExpressionRef expr,
                                                  BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->operands.removeAt(index);
}
// Load
int BinaryenLoadIsAtomic(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->isAtomic;
}
void BinaryenLoadSetAtomic(BinaryenExpressionRef expr, int isAtomic) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  static_cast<Load*>(expression)->isAtomic = isAtomic != 0;
}
int BinaryenLoadIsSigned(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->signed_;
}
void BinaryenLoadSetSigned(BinaryenExpressionRef expr, int isSigned) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  static_cast<Load*>(expression)->signed_ = isSigned != 0;
}
uint32_t BinaryenLoadGetBytes(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->bytes;
}
void BinaryenLoadSetBytes(BinaryenExpressionRef expr, uint32_t bytes) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  static_cast<Load*>(expression)->bytes = bytes;
}
uint32_t BinaryenLoadGetOffset(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->offset;
}
void BinaryenLoadSetOffset(BinaryenExpressionRef expr, uint32_t offset) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  static_cast<Load*>(expression)->offset = offset;
}
uint32_t BinaryenLoadGetAlign(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->align;
}
void BinaryenLoadSetAlign(BinaryenExpressionRef expr, uint32_t align) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  static_cast<Load*>(expression)->align = align;
}
BinaryenExpressionRef BinaryenLoadGetPtr(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->ptr;
}
void BinaryenLoadSetPtr(BinaryenExpressionRef expr,
                        BinaryenExpressionRef ptrExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  assert(ptrExpr);
  static_cast<Load*>(expression)->ptr = (Expression*)ptrExpr;
}
// Store
int BinaryenStoreIsAtomic(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->isAtomic;
}
void BinaryenStoreSetAtomic(BinaryenExpressionRef expr, int isAtomic) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  static_cast<Store*>(expression)->isAtomic = isAtomic != 0;
}
uint32_t BinaryenStoreGetBytes(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->bytes;
}
void BinaryenStoreSetBytes(BinaryenExpressionRef expr, uint32_t bytes) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  static_cast<Store*>(expression)->bytes = bytes;
}
uint32_t BinaryenStoreGetOffset(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->offset;
}
void BinaryenStoreSetOffset(BinaryenExpressionRef expr, uint32_t offset) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  static_cast<Store*>(expression)->offset = offset;
}
uint32_t BinaryenStoreGetAlign(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->align;
}
void BinaryenStoreSetAlign(BinaryenExpressionRef expr, uint32_t align) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  static_cast<Store*>(expression)->align = align;
}
BinaryenExpressionRef BinaryenStoreGetPtr(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->ptr;
}
void BinaryenStoreSetPtr(BinaryenExpressionRef expr,
                         BinaryenExpressionRef ptrExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  assert(ptrExpr);
  static_cast<Store*>(expression)->ptr = (Expression*)ptrExpr;
}
BinaryenExpressionRef BinaryenStoreGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->value;
}
void BinaryenStoreSetValue(BinaryenExpressionRef expr,
                           BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  assert(valueExpr);
  static_cast<Store*>(expression)->value = (Expression*)valueExpr;
}
BinaryenType BinaryenStoreGetValueType(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->valueType.getID();
}
void BinaryenStoreSetValueType(BinaryenExpressionRef expr,
                               BinaryenType valueType) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  static_cast<Store*>(expression)->valueType = Type(valueType);
}
// Const
int32_t BinaryenConstGetValueI32(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.geti32();
}
void BinaryenConstSetValueI32(BinaryenExpressionRef expr, int32_t value) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  static_cast<Const*>(expression)->value = Literal(value);
}
int64_t BinaryenConstGetValueI64(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.geti64();
}
void BinaryenConstSetValueI64(BinaryenExpressionRef expr, int64_t value) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  static_cast<Const*>(expression)->value = Literal(value);
}
int32_t BinaryenConstGetValueI64Low(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return (int32_t)(static_cast<Const*>(expression)->value.geti64() &
                   0xffffffff);
}
void BinaryenConstSetValueI64Low(BinaryenExpressionRef expr, int32_t valueLow) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  auto& value = static_cast<Const*>(expression)->value;
  int64_t valueI64 = value.type == Type::i64 ? value.geti64() : 0;
  static_cast<Const*>(expression)->value =
    Literal((valueI64 & ~0xffffffff) | (int64_t(valueLow) & 0xffffffff));
}
int32_t BinaryenConstGetValueI64High(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return (int32_t)(static_cast<Const*>(expression)->value.geti64() >> 32);
}
void BinaryenConstSetValueI64High(BinaryenExpressionRef expr,
                                  int32_t valueHigh) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  auto& value = static_cast<Const*>(expression)->value;
  int64_t valueI64 = value.type == Type::i64 ? value.geti64() : 0;
  static_cast<Const*>(expression)->value =
    Literal((int64_t(valueHigh) << 32) | (valueI64 & 0xffffffff));
}
float BinaryenConstGetValueF32(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.getf32();
}
void BinaryenConstSetValueF32(BinaryenExpressionRef expr, float value) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  static_cast<Const*>(expression)->value = Literal(value);
}
double BinaryenConstGetValueF64(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.getf64();
}
void BinaryenConstSetValueF64(BinaryenExpressionRef expr, double value) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  static_cast<Const*>(expression)->value = Literal(value);
}
void BinaryenConstGetValueV128(BinaryenExpressionRef expr, uint8_t* out) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  memcpy(out, static_cast<Const*>(expression)->value.getv128().data(), 16);
}
void BinaryenConstSetValueV128(BinaryenExpressionRef expr,
                               const uint8_t value[16]) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  assert(value); // nullptr would be wrong
  static_cast<Const*>(expression)->value = Literal(value);
}
// Unary
BinaryenOp BinaryenUnaryGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  return static_cast<Unary*>(expression)->op;
}
void BinaryenUnarySetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  static_cast<Unary*>(expression)->op = UnaryOp(op);
}
BinaryenExpressionRef BinaryenUnaryGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  return static_cast<Unary*>(expression)->value;
}
void BinaryenUnarySetValue(BinaryenExpressionRef expr,
                           BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  assert(valueExpr);
  static_cast<Unary*>(expression)->value = (Expression*)valueExpr;
}
// Binary
BinaryenOp BinaryenBinaryGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->op;
}
void BinaryenBinarySetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  static_cast<Binary*>(expression)->op = BinaryOp(op);
}
BinaryenExpressionRef BinaryenBinaryGetLeft(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->left;
}
void BinaryenBinarySetLeft(BinaryenExpressionRef expr,
                           BinaryenExpressionRef leftExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  assert(leftExpr);
  static_cast<Binary*>(expression)->left = (Expression*)leftExpr;
}
BinaryenExpressionRef BinaryenBinaryGetRight(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->right;
}
void BinaryenBinarySetRight(BinaryenExpressionRef expr,
                            BinaryenExpressionRef rightExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  assert(rightExpr);
  static_cast<Binary*>(expression)->right = (Expression*)rightExpr;
}
// Select
BinaryenExpressionRef BinaryenSelectGetIfTrue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->ifTrue;
}
void BinaryenSelectSetIfTrue(BinaryenExpressionRef expr,
                             BinaryenExpressionRef ifTrueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  assert(ifTrueExpr);
  static_cast<Select*>(expression)->ifTrue = (Expression*)ifTrueExpr;
}
BinaryenExpressionRef BinaryenSelectGetIfFalse(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->ifFalse;
}
void BinaryenSelectSetIfFalse(BinaryenExpressionRef expr,
                              BinaryenExpressionRef ifFalseExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  assert(ifFalseExpr);
  static_cast<Select*>(expression)->ifFalse = (Expression*)ifFalseExpr;
}
BinaryenExpressionRef BinaryenSelectGetCondition(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->condition;
}
void BinaryenSelectSetCondition(BinaryenExpressionRef expr,
                                BinaryenExpressionRef condExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  assert(condExpr);
  static_cast<Select*>(expression)->condition = (Expression*)condExpr;
}
// Drop
BinaryenExpressionRef BinaryenDropGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Drop>());
  return static_cast<Drop*>(expression)->value;
}
void BinaryenDropSetValue(BinaryenExpressionRef expr,
                          BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Drop>());
  assert(valueExpr);
  static_cast<Drop*>(expression)->value = (Expression*)valueExpr;
}
// Return
BinaryenExpressionRef BinaryenReturnGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Return>());
  return static_cast<Return*>(expression)->value;
}
void BinaryenReturnSetValue(BinaryenExpressionRef expr,
                            BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Return>());
  // may be null
  static_cast<Return*>(expression)->value = (Expression*)valueExpr;
}
// AtomicRMW
BinaryenOp BinaryenAtomicRMWGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->op;
}
void BinaryenAtomicRMWSetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  static_cast<AtomicRMW*>(expression)->op = AtomicRMWOp(op);
}
uint32_t BinaryenAtomicRMWGetBytes(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->bytes;
}
void BinaryenAtomicRMWSetBytes(BinaryenExpressionRef expr, uint32_t bytes) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  static_cast<AtomicRMW*>(expression)->bytes = bytes;
}
uint32_t BinaryenAtomicRMWGetOffset(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->offset;
}
void BinaryenAtomicRMWSetOffset(BinaryenExpressionRef expr, uint32_t offset) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  static_cast<AtomicRMW*>(expression)->offset = offset;
}
BinaryenExpressionRef BinaryenAtomicRMWGetPtr(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->ptr;
}
void BinaryenAtomicRMWSetPtr(BinaryenExpressionRef expr,
                             BinaryenExpressionRef ptrExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  assert(ptrExpr);
  static_cast<AtomicRMW*>(expression)->ptr = (Expression*)ptrExpr;
}
BinaryenExpressionRef BinaryenAtomicRMWGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->value;
}
void BinaryenAtomicRMWSetValue(BinaryenExpressionRef expr,
                               BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  assert(valueExpr);
  static_cast<AtomicRMW*>(expression)->value = (Expression*)valueExpr;
}
// AtomicCmpxchg
uint32_t BinaryenAtomicCmpxchgGetBytes(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->bytes;
}
void BinaryenAtomicCmpxchgSetBytes(BinaryenExpressionRef expr, uint32_t bytes) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  static_cast<AtomicCmpxchg*>(expression)->bytes = bytes;
}
uint32_t BinaryenAtomicCmpxchgGetOffset(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->offset;
}
void BinaryenAtomicCmpxchgSetOffset(BinaryenExpressionRef expr,
                                    uint32_t offset) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  static_cast<AtomicCmpxchg*>(expression)->offset = offset;
}
BinaryenExpressionRef BinaryenAtomicCmpxchgGetPtr(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->ptr;
}
void BinaryenAtomicCmpxchgSetPtr(BinaryenExpressionRef expr,
                                 BinaryenExpressionRef ptrExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  assert(ptrExpr);
  static_cast<AtomicCmpxchg*>(expression)->ptr = (Expression*)ptrExpr;
}
BinaryenExpressionRef
BinaryenAtomicCmpxchgGetExpected(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->expected;
}
void BinaryenAtomicCmpxchgSetExpected(BinaryenExpressionRef expr,
                                      BinaryenExpressionRef expectedExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  assert(expectedExpr);
  static_cast<AtomicCmpxchg*>(expression)->expected = (Expression*)expectedExpr;
}
BinaryenExpressionRef
BinaryenAtomicCmpxchgGetReplacement(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->replacement;
}
void BinaryenAtomicCmpxchgSetReplacement(
  BinaryenExpressionRef expr, BinaryenExpressionRef replacementExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  assert(replacementExpr);
  static_cast<AtomicCmpxchg*>(expression)->replacement =
    (Expression*)replacementExpr;
}
// AtomicWait
BinaryenExpressionRef BinaryenAtomicWaitGetPtr(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->ptr;
}
void BinaryenAtomicWaitSetPtr(BinaryenExpressionRef expr,
                              BinaryenExpressionRef ptrExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  assert(ptrExpr);
  static_cast<AtomicWait*>(expression)->ptr = (Expression*)ptrExpr;
}
BinaryenExpressionRef
BinaryenAtomicWaitGetExpected(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->expected;
}
void BinaryenAtomicWaitSetExpected(BinaryenExpressionRef expr,
                                   BinaryenExpressionRef expectedExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  assert(expectedExpr);
  static_cast<AtomicWait*>(expression)->expected = (Expression*)expectedExpr;
}
BinaryenExpressionRef BinaryenAtomicWaitGetTimeout(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->timeout;
}
void BinaryenAtomicWaitSetTimeout(BinaryenExpressionRef expr,
                                  BinaryenExpressionRef timeoutExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  assert(timeoutExpr);
  static_cast<AtomicWait*>(expression)->timeout = (Expression*)timeoutExpr;
}
BinaryenType BinaryenAtomicWaitGetExpectedType(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->expectedType.getID();
}
void BinaryenAtomicWaitSetExpectedType(BinaryenExpressionRef expr,
                                       BinaryenType expectedType) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  static_cast<AtomicWait*>(expression)->expectedType = Type(expectedType);
}
// AtomicNotify
BinaryenExpressionRef BinaryenAtomicNotifyGetPtr(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicNotify>());
  return static_cast<AtomicNotify*>(expression)->ptr;
}
void BinaryenAtomicNotifySetPtr(BinaryenExpressionRef expr,
                                BinaryenExpressionRef ptrExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicNotify>());
  assert(ptrExpr);
  static_cast<AtomicNotify*>(expression)->ptr = (Expression*)ptrExpr;
}
BinaryenExpressionRef
BinaryenAtomicNotifyGetNotifyCount(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicNotify>());
  return static_cast<AtomicNotify*>(expression)->notifyCount;
}
void BinaryenAtomicNotifySetNotifyCount(BinaryenExpressionRef expr,
                                        BinaryenExpressionRef notifyCountExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicNotify>());
  assert(notifyCountExpr);
  static_cast<AtomicNotify*>(expression)->notifyCount =
    (Expression*)notifyCountExpr;
}
// AtomicFence
uint8_t BinaryenAtomicFenceGetOrder(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicFence>());
  return static_cast<AtomicFence*>(expression)->order;
}
void BinaryenAtomicFenceSetOrder(BinaryenExpressionRef expr, uint8_t order) {
  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicFence>());
  static_cast<AtomicFence*>(expression)->order = order;
}
// SIMDExtract
BinaryenOp BinaryenSIMDExtractGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->op;
}
void BinaryenSIMDExtractSetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  static_cast<SIMDExtract*>(expression)->op = SIMDExtractOp(op);
}
BinaryenExpressionRef BinaryenSIMDExtractGetVec(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->vec;
}
void BinaryenSIMDExtractSetVec(BinaryenExpressionRef expr,
                               BinaryenExpressionRef vecExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  assert(vecExpr);
  static_cast<SIMDExtract*>(expression)->vec = (Expression*)vecExpr;
}
uint8_t BinaryenSIMDExtractGetIndex(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->index;
}
void BinaryenSIMDExtractSetIndex(BinaryenExpressionRef expr, uint8_t index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  static_cast<SIMDExtract*>(expression)->index = index;
}
// SIMDReplace
BinaryenOp BinaryenSIMDReplaceGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->op;
}
void BinaryenSIMDReplaceSetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  static_cast<SIMDReplace*>(expression)->op = SIMDReplaceOp(op);
}
BinaryenExpressionRef BinaryenSIMDReplaceGetVec(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->vec;
}
void BinaryenSIMDReplaceSetVec(BinaryenExpressionRef expr,
                               BinaryenExpressionRef vecExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  assert(vecExpr);
  static_cast<SIMDReplace*>(expression)->vec = (Expression*)vecExpr;
}
uint8_t BinaryenSIMDReplaceGetIndex(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->index;
}
void BinaryenSIMDReplaceSetIndex(BinaryenExpressionRef expr, uint8_t index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  static_cast<SIMDReplace*>(expression)->index = index;
}
BinaryenExpressionRef BinaryenSIMDReplaceGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->value;
}
void BinaryenSIMDReplaceSetValue(BinaryenExpressionRef expr,
                                 BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  assert(valueExpr);
  static_cast<SIMDReplace*>(expression)->value = (Expression*)valueExpr;
}
// SIMDShuffle
BinaryenExpressionRef BinaryenSIMDShuffleGetLeft(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  return static_cast<SIMDShuffle*>(expression)->left;
}
void BinaryenSIMDShuffleSetLeft(BinaryenExpressionRef expr,
                                BinaryenExpressionRef leftExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  assert(leftExpr);
  static_cast<SIMDShuffle*>(expression)->left = (Expression*)leftExpr;
}
BinaryenExpressionRef BinaryenSIMDShuffleGetRight(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  return static_cast<SIMDShuffle*>(expression)->right;
}
void BinaryenSIMDShuffleSetRight(BinaryenExpressionRef expr,
                                 BinaryenExpressionRef rightExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  assert(rightExpr);
  static_cast<SIMDShuffle*>(expression)->right = (Expression*)rightExpr;
}
void BinaryenSIMDShuffleGetMask(BinaryenExpressionRef expr, uint8_t* mask) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  assert(mask); // nullptr would be wrong
  memcpy(mask, static_cast<SIMDShuffle*>(expression)->mask.data(), 16);
}
void BinaryenSIMDShuffleSetMask(BinaryenExpressionRef expr,
                                const uint8_t mask_[16]) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  assert(mask_); // nullptr would be wrong
  auto& mask = static_cast<SIMDShuffle*>(expression)->mask;
  memcpy(mask.data(), mask_, 16);
}
// SIMDTernary
BinaryenOp BinaryenSIMDTernaryGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->op;
}
void BinaryenSIMDTernarySetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  static_cast<SIMDTernary*>(expression)->op = SIMDTernaryOp(op);
}
BinaryenExpressionRef BinaryenSIMDTernaryGetA(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->a;
}
void BinaryenSIMDTernarySetA(BinaryenExpressionRef expr,
                             BinaryenExpressionRef aExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  assert(aExpr);
  static_cast<SIMDTernary*>(expression)->a = (Expression*)aExpr;
}
BinaryenExpressionRef BinaryenSIMDTernaryGetB(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->b;
}
void BinaryenSIMDTernarySetB(BinaryenExpressionRef expr,
                             BinaryenExpressionRef bExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  assert(bExpr);
  static_cast<SIMDTernary*>(expression)->b = (Expression*)bExpr;
}
BinaryenExpressionRef BinaryenSIMDTernaryGetC(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->c;
}
void BinaryenSIMDTernarySetC(BinaryenExpressionRef expr,
                             BinaryenExpressionRef cExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  assert(cExpr);
  static_cast<SIMDTernary*>(expression)->c = (Expression*)cExpr;
}
// SIMDShift
BinaryenOp BinaryenSIMDShiftGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->op;
}
void BinaryenSIMDShiftSetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  static_cast<SIMDShift*>(expression)->op = SIMDShiftOp(op);
}
BinaryenExpressionRef BinaryenSIMDShiftGetVec(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->vec;
}
void BinaryenSIMDShiftSetVec(BinaryenExpressionRef expr,
                             BinaryenExpressionRef vecExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  assert(vecExpr);
  static_cast<SIMDShift*>(expression)->vec = (Expression*)vecExpr;
}
BinaryenExpressionRef BinaryenSIMDShiftGetShift(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->shift;
}
void BinaryenSIMDShiftSetShift(BinaryenExpressionRef expr,
                               BinaryenExpressionRef shiftExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  assert(shiftExpr);
  static_cast<SIMDShift*>(expression)->shift = (Expression*)shiftExpr;
}
// SIMDLoad
BinaryenOp BinaryenSIMDLoadGetOp(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  return static_cast<SIMDLoad*>(expression)->op;
}
void BinaryenSIMDLoadSetOp(BinaryenExpressionRef expr, BinaryenOp op) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  static_cast<SIMDLoad*>(expression)->op = SIMDLoadOp(op);
}
uint32_t BinaryenSIMDLoadGetOffset(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  return static_cast<SIMDLoad*>(expression)->offset;
}
void BinaryenSIMDLoadSetOffset(BinaryenExpressionRef expr, uint32_t offset) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  static_cast<SIMDLoad*>(expression)->offset = offset;
}
uint32_t BinaryenSIMDLoadGetAlign(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  return static_cast<SIMDLoad*>(expression)->align;
}
void BinaryenSIMDLoadSetAlign(BinaryenExpressionRef expr, uint32_t align) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  static_cast<SIMDLoad*>(expression)->align = align;
}
BinaryenExpressionRef BinaryenSIMDLoadGetPtr(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  return static_cast<SIMDLoad*>(expression)->ptr;
}
void BinaryenSIMDLoadSetPtr(BinaryenExpressionRef expr,
                            BinaryenExpressionRef ptrExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  assert(ptrExpr);
  static_cast<SIMDLoad*>(expression)->ptr = (Expression*)ptrExpr;
}
// MemoryInit
uint32_t BinaryenMemoryInitGetSegment(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->segment;
}
void BinaryenMemoryInitSetSegment(BinaryenExpressionRef expr,
                                  uint32_t segment) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  static_cast<MemoryInit*>(expression)->segment = segment;
}
BinaryenExpressionRef BinaryenMemoryInitGetDest(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->dest;
}
void BinaryenMemoryInitSetDest(BinaryenExpressionRef expr,
                               BinaryenExpressionRef destExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  assert(destExpr);
  static_cast<MemoryInit*>(expression)->dest = (Expression*)destExpr;
}
BinaryenExpressionRef BinaryenMemoryInitGetOffset(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->offset;
}
void BinaryenMemoryInitSetOffset(BinaryenExpressionRef expr,
                                 BinaryenExpressionRef offsetExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  assert(offsetExpr);
  static_cast<MemoryInit*>(expression)->offset = (Expression*)offsetExpr;
}
BinaryenExpressionRef BinaryenMemoryInitGetSize(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->size;
}
void BinaryenMemoryInitSetSize(BinaryenExpressionRef expr,
                               BinaryenExpressionRef sizeExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  assert(sizeExpr);
  static_cast<MemoryInit*>(expression)->size = (Expression*)sizeExpr;
}
// DataDrop
uint32_t BinaryenDataDropGetSegment(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<DataDrop>());
  return static_cast<DataDrop*>(expression)->segment;
}
void BinaryenDataDropSetSegment(BinaryenExpressionRef expr, uint32_t segment) {
  auto* expression = (Expression*)expr;
  assert(expression->is<DataDrop>());
  static_cast<DataDrop*>(expression)->segment = segment;
}
// MemoryCopy
BinaryenExpressionRef BinaryenMemoryCopyGetDest(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->dest;
}
void BinaryenMemoryCopySetDest(BinaryenExpressionRef expr,
                               BinaryenExpressionRef destExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  assert(destExpr);
  static_cast<MemoryCopy*>(expression)->dest = (Expression*)destExpr;
}
BinaryenExpressionRef BinaryenMemoryCopyGetSource(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->source;
}
void BinaryenMemoryCopySetSource(BinaryenExpressionRef expr,
                                 BinaryenExpressionRef sourceExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  assert(sourceExpr);
  static_cast<MemoryCopy*>(expression)->source = (Expression*)sourceExpr;
}
BinaryenExpressionRef BinaryenMemoryCopyGetSize(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->size;
}
void BinaryenMemoryCopySetSize(BinaryenExpressionRef expr,
                               BinaryenExpressionRef sizeExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  assert(sizeExpr);
  static_cast<MemoryCopy*>(expression)->size = (Expression*)sizeExpr;
}
// MemoryFill
BinaryenExpressionRef BinaryenMemoryFillGetDest(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->dest;
}
void BinaryenMemoryFillSetDest(BinaryenExpressionRef expr,
                               BinaryenExpressionRef destExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  assert(destExpr);
  static_cast<MemoryFill*>(expression)->dest = (Expression*)destExpr;
}
BinaryenExpressionRef BinaryenMemoryFillGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->value;
}
void BinaryenMemoryFillSetValue(BinaryenExpressionRef expr,
                                BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  assert(valueExpr);
  static_cast<MemoryFill*>(expression)->value = (Expression*)valueExpr;
}
BinaryenExpressionRef BinaryenMemoryFillGetSize(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->size;
}
void BinaryenMemoryFillSetSize(BinaryenExpressionRef expr,
                               BinaryenExpressionRef sizeExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  assert(sizeExpr);
  static_cast<MemoryFill*>(expression)->size = (Expression*)sizeExpr;
}
// RefIsNull
BinaryenExpressionRef BinaryenRefIsNullGetValue(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<RefIsNull>());
  return static_cast<RefIsNull*>(expression)->value;
}
void BinaryenRefIsNullSetValue(BinaryenExpressionRef expr,
                               BinaryenExpressionRef valueExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<RefIsNull>());
  assert(valueExpr);
  static_cast<RefIsNull*>(expression)->value = (Expression*)valueExpr;
}
// RefFunc
const char* BinaryenRefFuncGetFunc(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<RefFunc>());
  return static_cast<RefFunc*>(expression)->func.c_str();
}
void BinaryenRefFuncSetFunc(BinaryenExpressionRef expr, const char* funcName) {
  auto* expression = (Expression*)expr;
  assert(expression->is<RefFunc>());
  static_cast<RefFunc*>(expression)->func = funcName;
}
// Try
BinaryenExpressionRef BinaryenTryGetBody(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Try>());
  return static_cast<Try*>(expression)->body;
}
void BinaryenTrySetBody(BinaryenExpressionRef expr,
                        BinaryenExpressionRef bodyExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Try>());
  assert(bodyExpr);
  static_cast<Try*>(expression)->body = (Expression*)bodyExpr;
}
BinaryenExpressionRef BinaryenTryGetCatchBody(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Try>());
  return static_cast<Try*>(expression)->catchBody;
}
void BinaryenTrySetCatchBody(BinaryenExpressionRef expr,
                             BinaryenExpressionRef catchBodyExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Try>());
  assert(catchBodyExpr);
  static_cast<Try*>(expression)->catchBody = (Expression*)catchBodyExpr;
}
// Throw
const char* BinaryenThrowGetEvent(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  return static_cast<Throw*>(expression)->event.c_str();
}
void BinaryenThrowSetEvent(BinaryenExpressionRef expr, const char* eventName) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  static_cast<Throw*>(expression)->event = eventName;
}
BinaryenIndex BinaryenThrowGetNumOperands(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  return static_cast<Throw*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenThrowGetOperandAt(BinaryenExpressionRef expr,
                                                BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  assert(index < static_cast<Throw*>(expression)->operands.size());
  return static_cast<Throw*>(expression)->operands[index];
}
void BinaryenThrowSetOperandAt(BinaryenExpressionRef expr,
                               BinaryenIndex index,
                               BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  assert(index < static_cast<Throw*>(expression)->operands.size());
  assert(operandExpr);
  static_cast<Throw*>(expression)->operands[index] = (Expression*)operandExpr;
}
BinaryenIndex BinaryenThrowAppendOperand(BinaryenExpressionRef expr,
                                         BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  assert(operandExpr);
  auto& list = static_cast<Throw*>(expression)->operands;
  auto index = list.size();
  list.push_back((Expression*)operandExpr);
  return index;
}
void BinaryenThrowInsertOperandAt(BinaryenExpressionRef expr,
                                  BinaryenIndex index,
                                  BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  assert(operandExpr);
  static_cast<Throw*>(expression)
    ->operands.insertAt(index, (Expression*)operandExpr);
}
BinaryenExpressionRef BinaryenThrowRemoveOperandAt(BinaryenExpressionRef expr,
                                                   BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  return static_cast<Throw*>(expression)->operands.removeAt(index);
}
// Rethrow
BinaryenExpressionRef BinaryenRethrowGetExnref(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Rethrow>());
  return static_cast<Rethrow*>(expression)->exnref;
}
void BinaryenRethrowSetExnref(BinaryenExpressionRef expr,
                              BinaryenExpressionRef exnrefExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<Rethrow>());
  assert(exnrefExpr);
  static_cast<Rethrow*>(expression)->exnref = (Expression*)exnrefExpr;
}
// BrOnExn
const char* BinaryenBrOnExnGetEvent(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->event.c_str();
}
void BinaryenBrOnExnSetEvent(BinaryenExpressionRef expr,
                             const char* eventName) {
  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  static_cast<BrOnExn*>(expression)->event = eventName;
}
const char* BinaryenBrOnExnGetName(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->name.c_str();
}
void BinaryenBrOnExnSetName(BinaryenExpressionRef expr, const char* name) {
  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  static_cast<BrOnExn*>(expression)->name = name;
}
BinaryenExpressionRef BinaryenBrOnExnGetExnref(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->exnref;
}
void BinaryenBrOnExnSetExnref(BinaryenExpressionRef expr,
                              BinaryenExpressionRef exnrefExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  assert(exnrefExpr);
  static_cast<BrOnExn*>(expression)->exnref = (Expression*)exnrefExpr;
}
// TupleMake
BinaryenIndex BinaryenTupleMakeGetNumOperands(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleMake>());
  return static_cast<TupleMake*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenTupleMakeGetOperandAt(BinaryenExpressionRef expr,
                                                    BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleMake>());
  return static_cast<TupleMake*>(expression)->operands[index];
}
void BinaryenTupleMakeSetOperandAt(BinaryenExpressionRef expr,
                                   BinaryenIndex index,
                                   BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleMake>());
  assert(index < static_cast<TupleMake*>(expression)->operands.size());
  assert(operandExpr);
  static_cast<TupleMake*>(expression)->operands[index] =
    (Expression*)operandExpr;
}
BinaryenIndex
BinaryenTupleMakeAppendOperand(BinaryenExpressionRef expr,
                               BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleMake>());
  assert(operandExpr);
  auto& list = static_cast<TupleMake*>(expression)->operands;
  auto index = list.size();
  list.push_back((Expression*)operandExpr);
  return index;
}
void BinaryenTupleMakeInsertOperandAt(BinaryenExpressionRef expr,
                                      BinaryenIndex index,
                                      BinaryenExpressionRef operandExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleMake>());
  assert(operandExpr);
  static_cast<TupleMake*>(expression)
    ->operands.insertAt(index, (Expression*)operandExpr);
}
BinaryenExpressionRef
BinaryenTupleMakeRemoveOperandAt(BinaryenExpressionRef expr,
                                 BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleMake>());
  return static_cast<TupleMake*>(expression)->operands.removeAt(index);
}

// TupleExtract
BinaryenExpressionRef BinaryenTupleExtractGetTuple(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleExtract>());
  return static_cast<TupleExtract*>(expression)->tuple;
}
void BinaryenTupleExtractSetTuple(BinaryenExpressionRef expr,
                                  BinaryenExpressionRef tupleExpr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleExtract>());
  assert(tupleExpr);
  static_cast<TupleExtract*>(expression)->tuple = (Expression*)tupleExpr;
}
BinaryenIndex BinaryenTupleExtractGetIndex(BinaryenExpressionRef expr) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleExtract>());
  return static_cast<TupleExtract*>(expression)->index;
}
void BinaryenTupleExtractSetIndex(BinaryenExpressionRef expr,
                                  BinaryenIndex index) {
  auto* expression = (Expression*)expr;
  assert(expression->is<TupleExtract>());
  static_cast<TupleExtract*>(expression)->index = index;
}

// Functions

BinaryenFunctionRef BinaryenAddFunction(BinaryenModuleRef module,
                                        const char* name,
                                        BinaryenType params,
                                        BinaryenType results,
                                        BinaryenType* varTypes,
                                        BinaryenIndex numVarTypes,
                                        BinaryenExpressionRef body) {
  auto* ret = new Function;
  ret->name = name;
  ret->sig = Signature(Type(params), Type(results));
  for (BinaryenIndex i = 0; i < numVarTypes; i++) {
    ret->vars.push_back(Type(varTypes[i]));
  }
  ret->body = (Expression*)body;

  // Lock. This can be called from multiple threads at once, and is a
  // point where they all access and modify the module.
  {
    std::lock_guard<std::mutex> lock(BinaryenFunctionMutex);
    ((Module*)module)->addFunction(ret);
  }

  return ret;
}
BinaryenFunctionRef BinaryenGetFunction(BinaryenModuleRef module,
                                        const char* name) {
  return ((Module*)module)->getFunction(name);
}
void BinaryenRemoveFunction(BinaryenModuleRef module, const char* name) {
  ((Module*)module)->removeFunction(name);
}
uint32_t BinaryenGetNumFunctions(BinaryenModuleRef module) {
  return ((Module*)module)->functions.size();
}
BinaryenFunctionRef BinaryenGetFunctionByIndex(BinaryenModuleRef module,
                                               BinaryenIndex id) {
  const auto& functions = ((Module*)module)->functions;
  if (functions.size() <= id) {
    Fatal() << "invalid function id.";
  }
  return functions[id].get();
}

// Globals

BinaryenGlobalRef BinaryenAddGlobal(BinaryenModuleRef module,
                                    const char* name,
                                    BinaryenType type,
                                    int8_t mutable_,
                                    BinaryenExpressionRef init) {
  auto* ret = new Global();
  ret->name = name;
  ret->type = Type(type);
  ret->mutable_ = !!mutable_;
  ret->init = (Expression*)init;
  ((Module*)module)->addGlobal(ret);
  return ret;
}
BinaryenGlobalRef BinaryenGetGlobal(BinaryenModuleRef module,
                                    const char* name) {
  return ((Module*)module)->getGlobal(name);
}
void BinaryenRemoveGlobal(BinaryenModuleRef module, const char* name) {
  ((Module*)module)->removeGlobal(name);
}

// Events

BinaryenEventRef BinaryenAddEvent(BinaryenModuleRef module,
                                  const char* name,
                                  uint32_t attribute,
                                  BinaryenType params,
                                  BinaryenType results) {
  auto* ret = new Event();
  ret->name = name;
  ret->attribute = attribute;
  ret->sig = Signature(Type(params), Type(results));
  ((Module*)module)->addEvent(ret);
  return ret;
}

BinaryenEventRef BinaryenGetEvent(BinaryenModuleRef module, const char* name) {
  return ((Module*)module)->getEvent(name);
}
void BinaryenRemoveEvent(BinaryenModuleRef module, const char* name) {
  ((Module*)module)->removeEvent(name);
}

// Imports

void BinaryenAddFunctionImport(BinaryenModuleRef module,
                               const char* internalName,
                               const char* externalModuleName,
                               const char* externalBaseName,
                               BinaryenType params,
                               BinaryenType results) {
  auto* ret = new Function();
  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->sig = Signature(Type(params), Type(results));
  ((Module*)module)->addFunction(ret);
}
void BinaryenAddTableImport(BinaryenModuleRef module,
                            const char* internalName,
                            const char* externalModuleName,
                            const char* externalBaseName) {
  auto& table = ((Module*)module)->table;
  table.module = externalModuleName;
  table.base = externalBaseName;
}
void BinaryenAddMemoryImport(BinaryenModuleRef module,
                             const char* internalName,
                             const char* externalModuleName,
                             const char* externalBaseName,
                             uint8_t shared) {
  auto& memory = ((Module*)module)->memory;
  memory.module = externalModuleName;
  memory.base = externalBaseName;
  memory.shared = shared;
}
void BinaryenAddGlobalImport(BinaryenModuleRef module,
                             const char* internalName,
                             const char* externalModuleName,
                             const char* externalBaseName,
                             BinaryenType globalType,
                             int mutable_) {
  auto* ret = new Global();
  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->type = Type(globalType);
  ret->mutable_ = mutable_ != 0;
  ((Module*)module)->addGlobal(ret);
}
void BinaryenAddEventImport(BinaryenModuleRef module,
                            const char* internalName,
                            const char* externalModuleName,
                            const char* externalBaseName,
                            uint32_t attribute,
                            BinaryenType params,
                            BinaryenType results) {
  auto* ret = new Event();
  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->sig = Signature(Type(params), Type(results));
  ((Module*)module)->addEvent(ret);
}

// Exports

WASM_DEPRECATED BinaryenExportRef BinaryenAddExport(BinaryenModuleRef module,
                                                    const char* internalName,
                                                    const char* externalName) {
  return BinaryenAddFunctionExport(module, internalName, externalName);
}
BinaryenExportRef BinaryenAddFunctionExport(BinaryenModuleRef module,
                                            const char* internalName,
                                            const char* externalName) {
  auto* ret = new Export();
  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Function;
  ((Module*)module)->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddTableExport(BinaryenModuleRef module,
                                         const char* internalName,
                                         const char* externalName) {
  auto* ret = new Export();
  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Table;
  ((Module*)module)->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddMemoryExport(BinaryenModuleRef module,
                                          const char* internalName,
                                          const char* externalName) {
  auto* ret = new Export();
  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Memory;
  ((Module*)module)->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddGlobalExport(BinaryenModuleRef module,
                                          const char* internalName,
                                          const char* externalName) {
  auto* ret = new Export();
  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Global;
  ((Module*)module)->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddEventExport(BinaryenModuleRef module,
                                         const char* internalName,
                                         const char* externalName) {
  auto* ret = new Export();
  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Event;
  ((Module*)module)->addExport(ret);
  return ret;
}
void BinaryenRemoveExport(BinaryenModuleRef module, const char* externalName) {
  ((Module*)module)->removeExport(externalName);
}

// Function table. One per module

void BinaryenSetFunctionTable(BinaryenModuleRef module,
                              BinaryenIndex initial,
                              BinaryenIndex maximum,
                              const char** funcNames,
                              BinaryenIndex numFuncNames,
                              BinaryenExpressionRef offset) {
  Table::Segment segment((Expression*)offset);
  for (BinaryenIndex i = 0; i < numFuncNames; i++) {
    segment.data.push_back(funcNames[i]);
  }
  auto& table = ((Module*)module)->table;
  table.initial = initial;
  table.max = maximum;
  table.exists = true;
  table.segments.push_back(segment);
}

int BinaryenIsFunctionTableImported(BinaryenModuleRef module) {
  return ((Module*)module)->table.imported();
}
BinaryenIndex BinaryenGetNumFunctionTableSegments(BinaryenModuleRef module) {
  return ((Module*)module)->table.segments.size();
}
BinaryenExpressionRef
BinaryenGetFunctionTableSegmentOffset(BinaryenModuleRef module,
                                      BinaryenIndex segmentId) {
  const auto& segments = ((Module*)module)->table.segments;
  if (segments.size() <= segmentId) {
    Fatal() << "invalid function table segment id.";
  }
  return segments[segmentId].offset;
}
BinaryenIndex BinaryenGetFunctionTableSegmentLength(BinaryenModuleRef module,
                                                    BinaryenIndex segmentId) {
  const auto& segments = ((Module*)module)->table.segments;
  if (segments.size() <= segmentId) {
    Fatal() << "invalid function table segment id.";
  }
  return segments[segmentId].data.size();
}
const char* BinaryenGetFunctionTableSegmentData(BinaryenModuleRef module,
                                                BinaryenIndex segmentId,
                                                BinaryenIndex dataId) {
  const auto& segments = ((Module*)module)->table.segments;
  if (segments.size() <= segmentId ||
      segments[segmentId].data.size() <= dataId) {
    Fatal() << "invalid function table segment or data id.";
  }
  return segments[segmentId].data[dataId].c_str();
}

// Memory. One per module

void BinaryenSetMemory(BinaryenModuleRef module,
                       BinaryenIndex initial,
                       BinaryenIndex maximum,
                       const char* exportName,
                       const char** segments,
                       int8_t* segmentPassive,
                       BinaryenExpressionRef* segmentOffsets,
                       BinaryenIndex* segmentSizes,
                       BinaryenIndex numSegments,
                       uint8_t shared) {
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
    wasm->memory.segments.emplace_back(segmentPassive[i],
                                       (Expression*)segmentOffsets[i],
                                       segments[i],
                                       segmentSizes[i]);
  }
}

// Memory segments

uint32_t BinaryenGetNumMemorySegments(BinaryenModuleRef module) {
  return ((Module*)module)->memory.segments.size();
}
uint32_t BinaryenGetMemorySegmentByteOffset(BinaryenModuleRef module,
                                            BinaryenIndex id) {
  auto* wasm = (Module*)module;
  if (wasm->memory.segments.size() <= id) {
    Fatal() << "invalid segment id.";
  }

  auto globalOffset = [&](const Expression* const& expr,
                          int64_t& result) -> bool {
    if (auto* c = expr->dynCast<Const>()) {
      result = c->value.getInteger();
      return true;
    }
    return false;
  };

  const auto& segment = wasm->memory.segments[id];

  int64_t ret;
  if (globalOffset(segment.offset, ret)) {
    return ret;
  }
  if (auto* get = segment.offset->dynCast<GlobalGet>()) {
    Global* global = wasm->getGlobal(get->name);
    if (globalOffset(global->init, ret)) {
      return ret;
    }
  }

  Fatal() << "non-constant offsets aren't supported yet";
  return 0;
}
size_t BinaryenGetMemorySegmentByteLength(BinaryenModuleRef module,
                                          BinaryenIndex id) {
  const auto& segments = ((Module*)module)->memory.segments;
  if (segments.size() <= id) {
    Fatal() << "invalid segment id.";
  }
  return segments[id].data.size();
}
int BinaryenGetMemorySegmentPassive(BinaryenModuleRef module,
                                    BinaryenIndex id) {
  const auto& segments = ((Module*)module)->memory.segments;
  if (segments.size() <= id) {
    Fatal() << "invalid segment id.";
  }
  return segments[id].isPassive;
}
void BinaryenCopyMemorySegmentData(BinaryenModuleRef module,
                                   BinaryenIndex id,
                                   char* buffer) {
  const auto& segments = ((Module*)module)->memory.segments;
  if (segments.size() <= id) {
    Fatal() << "invalid segment id.";
  }
  const auto& segment = segments[id];
  std::copy(segment.data.cbegin(), segment.data.cend(), buffer);
}

// Start function. One per module

void BinaryenSetStart(BinaryenModuleRef module, BinaryenFunctionRef start) {
  ((Module*)module)->addStart(((Function*)start)->name);
}

// Features

BinaryenFeatures BinaryenModuleGetFeatures(BinaryenModuleRef module) {
  return ((Module*)module)->features.features;
}

void BinaryenModuleSetFeatures(BinaryenModuleRef module,
                               BinaryenFeatures features) {
  ((Module*)module)->features.features = features;
}

//
// ========== Module Operations ==========
//

BinaryenModuleRef BinaryenModuleParse(const char* text) {
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
  WasmPrinter::printModule((Module*)module);
}

void BinaryenModulePrintAsmjs(BinaryenModuleRef module) {
  auto* wasm = (Module*)module;
  Wasm2JSBuilder::Flags flags;
  Wasm2JSBuilder wasm2js(flags, globalPassOptions);
  auto asmjs = wasm2js.processWasm(wasm);
  JSPrinter jser(true, true, asmjs);
  Output out("", Flags::Text); // stdout
  Wasm2JSGlue glue(*wasm, out, flags, "asmFunc");
  glue.emitPre();
  jser.printAst();
  std::cout << jser.buffer << std::endl;
  glue.emitPost();
}

int BinaryenModuleValidate(BinaryenModuleRef module) {
  return WasmValidator().validate(*(Module*)module) ? 1 : 0;
}

void BinaryenModuleOptimize(BinaryenModuleRef module) {
  PassRunner passRunner((Module*)module);
  passRunner.options = globalPassOptions;
  passRunner.addDefaultOptimizationPasses();
  passRunner.run();
}

int BinaryenGetOptimizeLevel(void) { return globalPassOptions.optimizeLevel; }

void BinaryenSetOptimizeLevel(int level) {
  globalPassOptions.optimizeLevel = level;
}

int BinaryenGetShrinkLevel(void) { return globalPassOptions.shrinkLevel; }

void BinaryenSetShrinkLevel(int level) {
  globalPassOptions.shrinkLevel = level;
}

int BinaryenGetDebugInfo(void) { return globalPassOptions.debugInfo; }

void BinaryenSetDebugInfo(int on) { globalPassOptions.debugInfo = on != 0; }

int BinaryenGetLowMemoryUnused(void) {
  return globalPassOptions.lowMemoryUnused;
}

void BinaryenSetLowMemoryUnused(int on) {
  globalPassOptions.lowMemoryUnused = on != 0;
}

const char* BinaryenGetPassArgument(const char* key) {
  assert(key);
  const auto& args = globalPassOptions.arguments;
  auto it = args.find(key);
  if (it == args.end()) {
    return nullptr;
  }
  // internalize the string so it remains valid while the module is
  return Name(it->second).c_str();
}

void BinaryenSetPassArgument(const char* key, const char* value) {
  assert(key);
  if (value) {
    globalPassOptions.arguments[key] = value;
  } else {
    globalPassOptions.arguments.erase(key);
  }
}

void BinaryenClearPassArguments(void) { globalPassOptions.arguments.clear(); }

BinaryenIndex BinaryenGetAlwaysInlineMaxSize(void) {
  return globalPassOptions.inlining.alwaysInlineMaxSize;
}

void BinaryenSetAlwaysInlineMaxSize(BinaryenIndex size) {
  globalPassOptions.inlining.alwaysInlineMaxSize = size;
}

BinaryenIndex BinaryenGetFlexibleInlineMaxSize(void) {
  return globalPassOptions.inlining.flexibleInlineMaxSize;
}

void BinaryenSetFlexibleInlineMaxSize(BinaryenIndex size) {
  globalPassOptions.inlining.flexibleInlineMaxSize = size;
}

BinaryenIndex BinaryenGetOneCallerInlineMaxSize(void) {
  return globalPassOptions.inlining.oneCallerInlineMaxSize;
}

void BinaryenSetOneCallerInlineMaxSize(BinaryenIndex size) {
  globalPassOptions.inlining.oneCallerInlineMaxSize = size;
}

int BinaryenGetAllowHeavyweight(void) {
  return globalPassOptions.inlining.allowHeavyweight;
}

void BinaryenSetAllowHeavyweight(int enabled) {
  globalPassOptions.inlining.allowHeavyweight = enabled;
}

void BinaryenModuleRunPasses(BinaryenModuleRef module,
                             const char** passes,
                             BinaryenIndex numPasses) {
  PassRunner passRunner((Module*)module);
  passRunner.options = globalPassOptions;
  for (BinaryenIndex i = 0; i < numPasses; i++) {
    passRunner.add(passes[i]);
  }
  passRunner.run();
}

void BinaryenModuleAutoDrop(BinaryenModuleRef module) {
  auto* wasm = (Module*)module;
  PassRunner runner(wasm, globalPassOptions);
  AutoDrop().run(&runner, wasm);
}

static BinaryenBufferSizes writeModule(BinaryenModuleRef module,
                                       char* output,
                                       size_t outputSize,
                                       const char* sourceMapUrl,
                                       char* sourceMap,
                                       size_t sourceMapSize) {
  BufferWithRandomAccess buffer;
  WasmBinaryWriter writer((Module*)module, buffer);
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
  return {bytes, sourceMapBytes};
}

size_t
BinaryenModuleWrite(BinaryenModuleRef module, char* output, size_t outputSize) {
  return writeModule((Module*)module, output, outputSize, nullptr, nullptr, 0)
    .outputBytes;
}

size_t BinaryenModuleWriteText(BinaryenModuleRef module,
                               char* output,
                               size_t outputSize) {
  // use a stringstream as an std::ostream. Extract the std::string
  // representation, and then store in the output.
  std::stringstream ss;
  WasmPrinter::printModule((Module*)module, ss);

  const auto temp = ss.str();
  const auto ctemp = temp.c_str();

  strncpy(output, ctemp, outputSize);
  return std::min(outputSize, temp.size());
}

BinaryenBufferSizes BinaryenModuleWriteWithSourceMap(BinaryenModuleRef module,
                                                     const char* url,
                                                     char* output,
                                                     size_t outputSize,
                                                     char* sourceMap,
                                                     size_t sourceMapSize) {
  assert(url);
  assert(sourceMap);
  return writeModule(
    (Module*)module, output, outputSize, url, sourceMap, sourceMapSize);
}

BinaryenModuleAllocateAndWriteResult
BinaryenModuleAllocateAndWrite(BinaryenModuleRef module,
                               const char* sourceMapUrl) {
  BufferWithRandomAccess buffer;
  WasmBinaryWriter writer((Module*)module, buffer);
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
  return {binary, buffer.size(), sourceMap};
}

char* BinaryenModuleAllocateAndWriteText(BinaryenModuleRef module) {
  std::stringstream ss;
  WasmPrinter::printModule((Module*)module, ss);

  const std::string out = ss.str();
  const int len = out.length() + 1;
  char* cout = (char*)malloc(len);
  strncpy(cout, out.c_str(), len);
  return cout;
}

BinaryenModuleRef BinaryenModuleRead(char* input, size_t inputSize) {
  auto* wasm = new Module;
  std::vector<char> buffer(false);
  buffer.resize(inputSize);
  std::copy_n(input, inputSize, buffer.begin());
  try {
    WasmBinaryBuilder parser(*wasm, buffer);
    parser.read();
  } catch (ParseException& p) {
    p.dump(std::cerr);
    Fatal() << "error in parsing wasm binary";
  }
  return wasm;
}

void BinaryenModuleInterpret(BinaryenModuleRef module) {
  ShellExternalInterface interface;
  ModuleInstance instance(*(Module*)module, &interface);
}

BinaryenIndex BinaryenModuleAddDebugInfoFileName(BinaryenModuleRef module,
                                                 const char* filename) {
  auto& debugInfoFileNames = ((Module*)module)->debugInfoFileNames;
  BinaryenIndex index = debugInfoFileNames.size();
  debugInfoFileNames.push_back(filename);
  return index;
}

const char* BinaryenModuleGetDebugInfoFileName(BinaryenModuleRef module,
                                               BinaryenIndex index) {
  const auto& debugInfoFileNames = ((Module*)module)->debugInfoFileNames;
  return index < debugInfoFileNames.size()
           ? debugInfoFileNames.at(index).c_str()
           : nullptr;
}

//
// ========== Function Operations ==========
//

const char* BinaryenFunctionGetName(BinaryenFunctionRef func) {
  return ((Function*)func)->name.c_str();
}
BinaryenType BinaryenFunctionGetParams(BinaryenFunctionRef func) {
  return ((Function*)func)->sig.params.getID();
}
BinaryenType BinaryenFunctionGetResults(BinaryenFunctionRef func) {
  return ((Function*)func)->sig.results.getID();
}
BinaryenIndex BinaryenFunctionGetNumVars(BinaryenFunctionRef func) {
  return ((Function*)func)->vars.size();
}
BinaryenType BinaryenFunctionGetVar(BinaryenFunctionRef func,
                                    BinaryenIndex index) {
  const auto& vars = ((Function*)func)->vars;
  assert(index < vars.size());
  return vars[index].getID();
}
BinaryenExpressionRef BinaryenFunctionGetBody(BinaryenFunctionRef func) {
  return ((Function*)func)->body;
}
void BinaryenFunctionSetBody(BinaryenFunctionRef func,
                             BinaryenExpressionRef body) {
  assert(body);
  ((Function*)func)->body = (Expression*)body;
}
void BinaryenFunctionOptimize(BinaryenFunctionRef func,
                              BinaryenModuleRef module) {
  PassRunner passRunner((Module*)module);
  passRunner.options = globalPassOptions;
  passRunner.addDefaultOptimizationPasses();
  passRunner.runOnFunction((Function*)func);
}
void BinaryenFunctionRunPasses(BinaryenFunctionRef func,
                               BinaryenModuleRef module,
                               const char** passes,
                               BinaryenIndex numPasses) {
  PassRunner passRunner((Module*)module);
  passRunner.options = globalPassOptions;
  for (BinaryenIndex i = 0; i < numPasses; i++) {
    passRunner.add(passes[i]);
  }
  passRunner.runOnFunction((Function*)func);
}
void BinaryenFunctionSetDebugLocation(BinaryenFunctionRef func,
                                      BinaryenExpressionRef expr,
                                      BinaryenIndex fileIndex,
                                      BinaryenIndex lineNumber,
                                      BinaryenIndex columnNumber) {
  Function::DebugLocation loc;
  loc.fileIndex = fileIndex;
  loc.lineNumber = lineNumber;
  loc.columnNumber = columnNumber;
  ((Function*)func)->debugLocations[(Expression*)expr] = loc;
}

//
// =========== Global operations ===========
//

const char* BinaryenGlobalGetName(BinaryenGlobalRef global) {
  return ((Global*)global)->name.c_str();
}
BinaryenType BinaryenGlobalGetType(BinaryenGlobalRef global) {
  return ((Global*)global)->type.getID();
}
int BinaryenGlobalIsMutable(BinaryenGlobalRef global) {
  return ((Global*)global)->mutable_;
}
BinaryenExpressionRef BinaryenGlobalGetInitExpr(BinaryenGlobalRef global) {
  return ((Global*)global)->init;
}

//
// =========== Event operations ===========
//

const char* BinaryenEventGetName(BinaryenEventRef event) {
  return ((Event*)event)->name.c_str();
}
int BinaryenEventGetAttribute(BinaryenEventRef event) {
  return ((Event*)event)->attribute;
}
BinaryenType BinaryenEventGetParams(BinaryenEventRef event) {
  return ((Event*)event)->sig.params.getID();
}

BinaryenType BinaryenEventGetResults(BinaryenEventRef event) {
  return ((Event*)event)->sig.results.getID();
}

//
// =========== Import operations ===========
//

const char* BinaryenFunctionImportGetModule(BinaryenFunctionRef import) {
  auto* func = (Function*)import;
  if (func->imported()) {
    return func->module.c_str();
  } else {
    return "";
  }
}
const char* BinaryenGlobalImportGetModule(BinaryenGlobalRef import) {
  auto* global = (Global*)import;
  if (global->imported()) {
    return global->module.c_str();
  } else {
    return "";
  }
}
const char* BinaryenEventImportGetModule(BinaryenEventRef import) {
  auto* event = (Event*)import;
  if (event->imported()) {
    return event->module.c_str();
  } else {
    return "";
  }
}
const char* BinaryenFunctionImportGetBase(BinaryenFunctionRef import) {
  auto* func = (Function*)import;
  if (func->imported()) {
    return func->base.c_str();
  } else {
    return "";
  }
}
const char* BinaryenGlobalImportGetBase(BinaryenGlobalRef import) {
  auto* global = (Global*)import;
  if (global->imported()) {
    return global->base.c_str();
  } else {
    return "";
  }
}
const char* BinaryenEventImportGetBase(BinaryenEventRef import) {
  auto* event = (Event*)import;
  if (event->imported()) {
    return event->base.c_str();
  } else {
    return "";
  }
}

//
// =========== Export operations ===========
//

BinaryenExternalKind BinaryenExportGetKind(BinaryenExportRef export_) {
  return BinaryenExternalKind(((Export*)export_)->kind);
}
const char* BinaryenExportGetName(BinaryenExportRef export_) {
  return ((Export*)export_)->name.c_str();
}
const char* BinaryenExportGetValue(BinaryenExportRef export_) {
  return ((Export*)export_)->value.c_str();
}
uint32_t BinaryenGetNumExports(BinaryenModuleRef module) {
  return ((Module*)module)->exports.size();
}
BinaryenExportRef BinaryenGetExportByIndex(BinaryenModuleRef module,
                                           BinaryenIndex id) {
  const auto& exports = ((Module*)module)->exports;
  if (exports.size() <= id) {
    Fatal() << "invalid export id.";
  }
  return exports[id].get();
}

//
// ========= Custom sections =========
//

void BinaryenAddCustomSection(BinaryenModuleRef module,
                              const char* name,
                              const char* contents,
                              BinaryenIndex contentsSize) {
  wasm::UserSection customSection;
  customSection.name = name;
  customSection.data = std::vector<char>(contents, contents + contentsSize);
  ((Module*)module)->userSections.push_back(customSection);
}

//
// ========= Effect analyzer =========
//

BinaryenSideEffects BinaryenSideEffectNone(void) {
  return static_cast<BinaryenSideEffects>(EffectAnalyzer::SideEffects::None);
}
BinaryenSideEffects BinaryenSideEffectBranches(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::Branches);
}
BinaryenSideEffects BinaryenSideEffectCalls(void) {
  return static_cast<BinaryenSideEffects>(EffectAnalyzer::SideEffects::Calls);
}
BinaryenSideEffects BinaryenSideEffectReadsLocal(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::ReadsLocal);
}
BinaryenSideEffects BinaryenSideEffectWritesLocal(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::WritesLocal);
}
BinaryenSideEffects BinaryenSideEffectReadsGlobal(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::ReadsGlobal);
}
BinaryenSideEffects BinaryenSideEffectWritesGlobal(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::WritesGlobal);
}
BinaryenSideEffects BinaryenSideEffectReadsMemory(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::ReadsMemory);
}
BinaryenSideEffects BinaryenSideEffectWritesMemory(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::WritesMemory);
}
BinaryenSideEffects BinaryenSideEffectImplicitTrap(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::ImplicitTrap);
}
BinaryenSideEffects BinaryenSideEffectIsAtomic(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::IsAtomic);
}
BinaryenSideEffects BinaryenSideEffectThrows(void) {
  return static_cast<BinaryenSideEffects>(EffectAnalyzer::SideEffects::Throws);
}
BinaryenSideEffects BinaryenSideEffectDanglingPop(void) {
  return static_cast<BinaryenSideEffects>(
    EffectAnalyzer::SideEffects::DanglingPop);
}
BinaryenSideEffects BinaryenSideEffectAny(void) {
  return static_cast<BinaryenSideEffects>(EffectAnalyzer::SideEffects::Any);
}

BinaryenSideEffects
BinaryenExpressionGetSideEffects(BinaryenExpressionRef expr,
                                 BinaryenFeatures features) {
  return EffectAnalyzer(globalPassOptions, features, (Expression*)expr)
    .getSideEffects();
}

//
// ========== CFG / Relooper ==========
//

RelooperRef RelooperCreate(BinaryenModuleRef module) {
  return RelooperRef(new CFG::Relooper((Module*)module));
}

RelooperBlockRef RelooperAddBlock(RelooperRef relooper,
                                  BinaryenExpressionRef code) {
  return RelooperBlockRef(
    ((CFG::Relooper*)relooper)->AddBlock((Expression*)code));
}

void RelooperAddBranch(RelooperBlockRef from,
                       RelooperBlockRef to,
                       BinaryenExpressionRef condition,
                       BinaryenExpressionRef code) {
  ((CFG::Block*)from)
    ->AddBranchTo((CFG::Block*)to, (Expression*)condition, (Expression*)code);
}

RelooperBlockRef RelooperAddBlockWithSwitch(RelooperRef relooper,
                                            BinaryenExpressionRef code,
                                            BinaryenExpressionRef condition) {
  return RelooperBlockRef(
    ((CFG::Relooper*)relooper)
      ->AddBlock((Expression*)code, (Expression*)condition));
}

void RelooperAddBranchForSwitch(RelooperBlockRef from,
                                RelooperBlockRef to,
                                BinaryenIndex* indexes,
                                BinaryenIndex numIndexes,
                                BinaryenExpressionRef code) {
  std::vector<Index> values;
  for (Index i = 0; i < numIndexes; i++) {
    values.push_back(indexes[i]);
  }
  ((CFG::Block*)from)
    ->AddSwitchBranchTo((CFG::Block*)to, std::move(values), (Expression*)code);
}

BinaryenExpressionRef RelooperRenderAndDispose(RelooperRef relooper,
                                               RelooperBlockRef entry,
                                               BinaryenIndex labelHelper) {
  auto* R = (CFG::Relooper*)relooper;
  R->Calculate((CFG::Block*)entry);
  CFG::RelooperBuilder builder(*R->Module, labelHelper);
  auto* ret = R->Render(builder);
  delete R;
  return BinaryenExpressionRef(ret);
}

//
// ========= ExpressionRunner =========
//

namespace wasm {

// Evaluates a suspected constant expression via the C-API. Inherits most of its
// functionality from ConstantExpressionRunner, which it shares with the
// precompute pass, but must be `final` so we can `delete` its instances.
class CExpressionRunner final
  : public ConstantExpressionRunner<CExpressionRunner> {
public:
  CExpressionRunner(Module* module,
                    CExpressionRunner::Flags flags,
                    Index maxDepth,
                    Index maxLoopIterations)
    : ConstantExpressionRunner<CExpressionRunner>(
        module, flags, maxDepth, maxLoopIterations) {}
};

} // namespace wasm

ExpressionRunnerFlags ExpressionRunnerFlagsDefault() {
  return CExpressionRunner::FlagValues::DEFAULT;
}

ExpressionRunnerFlags ExpressionRunnerFlagsPreserveSideeffects() {
  return CExpressionRunner::FlagValues::PRESERVE_SIDEEFFECTS;
}

ExpressionRunnerFlags ExpressionRunnerFlagsTraverseCalls() {
  return CExpressionRunner::FlagValues::TRAVERSE_CALLS;
}

ExpressionRunnerRef ExpressionRunnerCreate(BinaryenModuleRef module,
                                           ExpressionRunnerFlags flags,
                                           BinaryenIndex maxDepth,
                                           BinaryenIndex maxLoopIterations) {
  return static_cast<ExpressionRunnerRef>(
    new CExpressionRunner((Module*)module, flags, maxDepth, maxLoopIterations));
}

int ExpressionRunnerSetLocalValue(ExpressionRunnerRef runner,
                                  BinaryenIndex index,
                                  BinaryenExpressionRef value) {
  auto* R = (CExpressionRunner*)runner;
  auto setFlow = R->visit(value);
  if (!setFlow.breaking()) {
    R->setLocalValue(index, setFlow.values);
    return 1;
  }
  return 0;
}

int ExpressionRunnerSetGlobalValue(ExpressionRunnerRef runner,
                                   const char* name,
                                   BinaryenExpressionRef value) {
  auto* R = (CExpressionRunner*)runner;
  auto setFlow = R->visit(value);
  if (!setFlow.breaking()) {
    R->setGlobalValue(name, setFlow.values);
    return 1;
  }
  return 0;
}

BinaryenExpressionRef
ExpressionRunnerRunAndDispose(ExpressionRunnerRef runner,
                              BinaryenExpressionRef expr) {
  auto* R = (CExpressionRunner*)runner;
  Expression* ret = nullptr;
  try {
    auto flow = R->visit(expr);
    if (!flow.breaking() && !flow.values.empty()) {
      ret = flow.getConstExpression(*R->getModule());
    }
  } catch (CExpressionRunner::NonconstantException&) {
  }
  delete R;
  return ret;
}

//
// ========= Utilities =========
//

void BinaryenSetColorsEnabled(int enabled) { Colors::setEnabled(enabled); }

int BinaryenAreColorsEnabled() { return Colors::isEnabled(); }

#ifdef __EMSCRIPTEN__
// Override atexit - we don't need any global ctors to actually run, and
// otherwise we get clutter in the output in debug builds
int atexit(void (*function)(void)) { return 0; }

// Internal binaryen.js APIs

// Returns the size of a Literal object.
EMSCRIPTEN_KEEPALIVE
size_t BinaryenSizeofLiteral(void) { return sizeof(Literal); }

// Returns the size of an allocate and write result object.
EMSCRIPTEN_KEEPALIVE
size_t BinaryenSizeofAllocateAndWriteResult(void) {
  return sizeof(BinaryenModuleAllocateAndWriteResult);
}

// Helpers for accessing Binaryen's memory from another module without the
// need to round-trip through JS, e.g. when allocating and initializing
// strings passed to / reading strings returned by the C-API.

// TODO: Remove these once Wasm supports multiple memories.

// Stores an 8-bit integer to Binaryen memory.
EMSCRIPTEN_KEEPALIVE
void _i32_store8(int8_t* ptr, int8_t value) { *ptr = value; }

// Stores a 16-bit integer to Binaryen memory.
EMSCRIPTEN_KEEPALIVE
void _i32_store16(int16_t* ptr, int16_t value) { *ptr = value; }

// Stores a 32-bit integer to Binaryen memory.
EMSCRIPTEN_KEEPALIVE
void _i32_store(int32_t* ptr, int32_t value) { *ptr = value; }

// Stores a 32-bit float to Binaryen memory.
EMSCRIPTEN_KEEPALIVE
void _f32_store(float* ptr, float value) { *ptr = value; }

// Stores a 64-bit float to Binaryen memory.
EMSCRIPTEN_KEEPALIVE
void _f64_store(double* ptr, double value) { *ptr = value; }

// Loads an 8-bit signed integer from Binaryen memory.
EMSCRIPTEN_KEEPALIVE
int8_t _i32_load8_s(int8_t* ptr) { return *ptr; }

// Loads an 8-bit unsigned integer from Binaryen memory.
EMSCRIPTEN_KEEPALIVE
uint8_t _i32_load8_u(uint8_t* ptr) { return *ptr; }

// Loads a 16-bit signed integer from Binaryen memory.
EMSCRIPTEN_KEEPALIVE
int16_t _i32_load16_s(int16_t* ptr) { return *ptr; }

// Loads a 16-bit unsigned integer from Binaryen memory.
EMSCRIPTEN_KEEPALIVE
uint16_t _i32_load16_u(uint16_t* ptr) { return *ptr; }

// Loads a 32-bit integer from Binaryen memory.
EMSCRIPTEN_KEEPALIVE
int32_t _i32_load(int32_t* ptr) { return *ptr; }

// Loads a 32-bit float from Binaryen memory.
EMSCRIPTEN_KEEPALIVE
float _f32_load(float* ptr) { return *ptr; }

// Loads a 64-bit float from Binaryen memory.
EMSCRIPTEN_KEEPALIVE
double _f64_load(double* ptr) { return *ptr; }

#endif // __EMSCRIPTEN__

} // extern "C"
