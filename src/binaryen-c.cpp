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
  ret.type = x.type;
  switch (x.type) {
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
    case Type::anyref:
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
    case Type::anyref:
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

// Tracing support

static int tracing = 0;

void traceNameOrNULL(const char* name, std::ostream& out = std::cout) {
  if (name) {
    out << "\"" << name << "\"";
  } else {
    out << "NULL";
  }
}

std::map<BinaryenExpressionRef, size_t> expressions;
std::map<BinaryenFunctionRef, size_t> functions;
std::map<BinaryenGlobalRef, size_t> globals;
std::map<BinaryenEventRef, size_t> events;
std::map<BinaryenExportRef, size_t> exports;
std::map<RelooperBlockRef, size_t> relooperBlocks;

size_t noteExpression(BinaryenExpressionRef expression) {
  auto id = expressions.size();
  assert(expressions.find(expression) == expressions.end());
  expressions[expression] = id;
  return id;
}

std::string getTemp() {
  static size_t n = 0;
  return "t" + std::to_string(n++);
}

template<typename T>
void printArg(std::ostream& setup, std::ostream& out, T arg) {
  out << arg;
}

template<>
void printArg(std::ostream& setup,
              std::ostream& out,
              BinaryenExpressionRef arg) {
  out << "expressions[" << expressions[arg] << "]";
}

struct StringLit {
  const char* name;
  StringLit(const char* name) : name(name){};
};

template<>
void printArg(std::ostream& setup, std::ostream& out, StringLit arg) {
  traceNameOrNULL(arg.name, out);
}

template<>
void printArg(std::ostream& setup, std::ostream& out, BinaryenType arg) {
  if (arg == BinaryenTypeAuto()) {
    out << "BinaryenTypeAuto()";
  } else {
    out << arg;
  }
}

template<>
void printArg(std::ostream& setup, std::ostream& out, BinaryenLiteral arg) {
  switch (arg.type) {
    case Type::i32:
      out << "BinaryenLiteralInt32(" << arg.i32 << ")";
      break;
    case Type::i64:
      out << "BinaryenLiteralInt64(" << arg.i64 << ")";
      break;
    case Type::f32:
      if (std::isnan(arg.f32)) {
        out << "BinaryenLiteralFloat32(NAN)";
        break;
      } else {
        out << "BinaryenLiteralFloat32(" << arg.f32 << ")";
        break;
      }
    case Type::f64:
      if (std::isnan(arg.f64)) {
        out << "BinaryenLiteralFloat64(NAN)";
        break;
      } else {
        out << "BinaryenLiteralFloat64(" << arg.f64 << ")";
        break;
      }
    case Type::v128: {
      std::string array = getTemp();
      setup << "uint8_t " << array << "[] = {";
      for (size_t i = 0; i < 16; ++i) {
        setup << int(arg.v128[i]);
        if (i < 15) {
          setup << ", ";
        }
      }
      setup << "};\n";
      out << "BinaryenLiteralVec128(" << array << ")";
      break;
    }
    case Type::funcref:
      out << "BinaryenLiteralFuncref(" << arg.func << ")";
      break;
    case Type::nullref:
      out << "BinaryenLiteralNullref()";
      break;
    case Type::anyref:
    case Type::exnref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("unexpected type");
  }
}

template<typename T>
void traceArgs(std::ostream& setup, std::ostream& out, T arg) {
  printArg(setup, out, arg);
}

template<typename T, typename S, typename... Ts>
void traceArgs(
  std::ostream& setup, std::ostream& out, T arg, S next, Ts... rest) {
  printArg(setup, out, arg);
  out << ", ";
  traceArgs(setup, out, next, rest...);
}

template<typename... Ts>
void traceExpression(BinaryenExpressionRef expr,
                     const char* constructor,
                     Ts... args) {
  auto id = noteExpression(expr);
  std::stringstream setup, out;
  out << "expressions[" << id << "] = " << constructor << "(";
  traceArgs(setup, out, "the_module", args...);
  out << ");\n";
  if (!setup.str().empty()) {
    std::cout << "  {\n";
    for (std::string line; getline(setup, line);) {
      std::cout << "    " << line << "\n";
    }
    std::cout << "    " << out.str();
    std::cout << "  }\n";
  } else {
    std::cout << "  " << out.str();
  }
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
BinaryenType BinaryenTypeVec128(void) { return v128; }
BinaryenType BinaryenTypeFuncref(void) { return funcref; }
BinaryenType BinaryenTypeAnyref(void) { return anyref; }
BinaryenType BinaryenTypeNullref(void) { return nullref; }
BinaryenType BinaryenTypeExnref(void) { return exnref; }
BinaryenType BinaryenTypeUnreachable(void) { return unreachable; }
BinaryenType BinaryenTypeAuto(void) { return uint32_t(-1); }

BinaryenType BinaryenTypeCreate(BinaryenType* types, uint32_t numTypes) {
  std::vector<Type> typeVec;
  typeVec.reserve(numTypes);
  for (size_t i = 0; i < numTypes; ++i) {
    typeVec.push_back(Type(types[i]));
  }
  Type result(typeVec);

  if (tracing) {
    std::string array = getTemp();
    std::cout << "  {\n";
    std::cout << "    BinaryenType " << array << "[] = {";
    for (size_t i = 0; i < numTypes; ++i) {
      std::cout << uint32_t(types[i]);
      if (i < numTypes - 1) {
        std::cout << ", ";
      }
    }
    std::cout << "};\n";
    std::cout << "    BinaryenTypeCreate(" << array << ", " << numTypes
              << "); // " << uint32_t(result) << "\n";
    std::cout << "  }\n";
  }

  return uint32_t(result);
}

uint32_t BinaryenTypeArity(BinaryenType t) { return Type(t).size(); }

void BinaryenTypeExpand(BinaryenType t, BinaryenType* buf) {
  const std::vector<Type>& types = Type(t).expand();
  for (size_t i = 0; i < types.size(); ++i) {
    buf[i] = types[i];
  }
}

WASM_DEPRECATED BinaryenType BinaryenNone(void) { return none; }
WASM_DEPRECATED BinaryenType BinaryenInt32(void) { return i32; }
WASM_DEPRECATED BinaryenType BinaryenInt64(void) { return i64; }
WASM_DEPRECATED BinaryenType BinaryenFloat32(void) { return f32; }
WASM_DEPRECATED BinaryenType BinaryenFloat64(void) { return f64; }
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
BinaryenExpressionId BinaryenPushId(void) { return Expression::Id::PushId; }
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
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::MVP);
}
BinaryenFeatures BinaryenFeatureAtomics(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::Atomics);
}
BinaryenFeatures BinaryenFeatureBulkMemory(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::BulkMemory);
}
BinaryenFeatures BinaryenFeatureMutableGlobals(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::MutableGlobals);
}
BinaryenFeatures BinaryenFeatureNontrappingFPToInt(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::TruncSat);
}
BinaryenFeatures BinaryenFeatureSignExt(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::SignExt);
}
BinaryenFeatures BinaryenFeatureSIMD128(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::SIMD);
}
BinaryenFeatures BinaryenFeatureExceptionHandling(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::ExceptionHandling);
}
BinaryenFeatures BinaryenFeatureTailCall(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::TailCall);
}
BinaryenFeatures BinaryenFeatureReferenceTypes(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::ReferenceTypes);
}
BinaryenFeatures BinaryenFeatureAll(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::All);
}

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
    std::cout << "  expressions.clear();\n";
    std::cout << "  functions.clear();\n";
    std::cout << "  globals.clear();\n";
    std::cout << "  events.clear();\n";
    std::cout << "  exports.clear();\n";
    std::cout << "  relooperBlocks.clear();\n";
    expressions.clear();
    functions.clear();
    globals.clear();
    events.clear();
    exports.clear();
    relooperBlocks.clear();
  }

  delete (Module*)module;
}

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
BinaryenOp BinaryenNegVecI8x16(void) { return NegVecI8x16; }
BinaryenOp BinaryenAnyTrueVecI8x16(void) { return AnyTrueVecI8x16; }
BinaryenOp BinaryenAllTrueVecI8x16(void) { return AllTrueVecI8x16; }
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
BinaryenOp BinaryenNegVecI16x8(void) { return NegVecI16x8; }
BinaryenOp BinaryenAnyTrueVecI16x8(void) { return AnyTrueVecI16x8; }
BinaryenOp BinaryenAllTrueVecI16x8(void) { return AllTrueVecI16x8; }
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
BinaryenOp BinaryenNegVecI32x4(void) { return NegVecI32x4; }
BinaryenOp BinaryenAnyTrueVecI32x4(void) { return AnyTrueVecI32x4; }
BinaryenOp BinaryenAllTrueVecI32x4(void) { return AllTrueVecI32x4; }
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

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef children[] = { ";
    for (BinaryenIndex i = 0; i < numChildren; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      if (i % 6 == 5) {
        std::cout << "\n       "; // don't create hugely long lines
      }
      std::cout << "expressions[" << expressions[children[i]] << "]";
    }
    if (numChildren == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n  ";
    traceExpression(
      ret, "BinaryenBlock", StringLit(name), "children", numChildren, type);
    std::cout << "  }\n";
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

  if (tracing) {
    traceExpression(ret, "BinaryenIf", condition, ifTrue, ifFalse);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module,
                                   const char* name,
                                   BinaryenExpressionRef body) {
  auto* ret = Builder(*(Module*)module)
                .makeLoop(name ? Name(name) : Name(), (Expression*)body);

  if (tracing) {
    traceExpression(ret, "BinaryenLoop", StringLit(name), body);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenBreak(BinaryenModuleRef module,
                                    const char* name,
                                    BinaryenExpressionRef condition,
                                    BinaryenExpressionRef value) {
  auto* ret = Builder(*(Module*)module)
                .makeBreak(name, (Expression*)value, (Expression*)condition);

  if (tracing) {
    traceExpression(ret, "BinaryenBreak", StringLit(name), condition, value);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSwitch(BinaryenModuleRef module,
                                     const char** names,
                                     BinaryenIndex numNames,
                                     const char* defaultName,
                                     BinaryenExpressionRef condition,
                                     BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<Switch>();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char* names[] = { ";
    for (BinaryenIndex i = 0; i < numNames; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "\"" << names[i] << "\"";
    }
    if (numNames == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n  ";
    traceExpression(ret,
                    "BinaryenSwitch",
                    "names",
                    numNames,
                    StringLit(defaultName),
                    condition,
                    value);
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
static BinaryenExpressionRef makeBinaryenCall(BinaryenModuleRef module,
                                              const char* target,
                                              BinaryenExpressionRef* operands,
                                              BinaryenIndex numOperands,
                                              BinaryenType returnType,
                                              bool isReturn) {
  auto* ret = ((Module*)module)->allocator.alloc<Call>();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef operands[] = { ";
    for (BinaryenIndex i = 0; i < numOperands; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "expressions[" << expressions[operands[i]] << "]";
    }
    if (numOperands == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n  ";
    traceExpression(ret,
                    (isReturn ? "BinaryenReturnCall" : "BinaryenCall"),
                    StringLit(target),
                    "operands",
                    numOperands,
                    returnType);
    std::cout << "  }\n";
  }

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
  auto* wasm = (Module*)module;
  auto* ret = wasm->allocator.alloc<CallIndirect>();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef operands[] = { ";
    for (BinaryenIndex i = 0; i < numOperands; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "expressions[" << expressions[operands[i]] << "]";
    }
    if (numOperands == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n  ";
    traceExpression(
      ret,
      (isReturn ? "BinaryenReturnCallIndirect" : "BinaryenCallIndirect"),
      target,
      "operands",
      numOperands,
      params,
      results);
    std::cout << "  }\n";
  }

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

  if (tracing) {
    traceExpression(ret, "BinaryenLocalGet", index, type);
  }

  ret->index = index;
  ret->type = Type(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenLocalSet(BinaryenModuleRef module,
                                       BinaryenIndex index,
                                       BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<LocalSet>();

  if (tracing) {
    traceExpression(ret, "BinaryenLocalSet", index, value);
  }

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

  if (tracing) {
    traceExpression(ret, "BinaryenLocalTee", index, value, type);
  }

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

  if (tracing) {
    traceExpression(ret, "BinaryenGlobalGet", StringLit(name), type);
  }

  ret->name = name;
  ret->type = Type(type);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenGlobalSet(BinaryenModuleRef module,
                                        const char* name,
                                        BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<GlobalSet>();

  if (tracing) {
    traceExpression(ret, "BinaryenGlobalSet", StringLit(name), value);
  }

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

  if (tracing) {
    traceExpression(
      ret, "BinaryenLoad", bytes, int(signed_), offset, align, type, ptr);
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
BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module,
                                    uint32_t bytes,
                                    uint32_t offset,
                                    uint32_t align,
                                    BinaryenExpressionRef ptr,
                                    BinaryenExpressionRef value,
                                    BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<Store>();

  if (tracing) {
    traceExpression(
      ret, "BinaryenStore", bytes, offset, align, ptr, value, type);
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
BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module,
                                    BinaryenLiteral value) {
  auto* ret = Builder(*(Module*)module).makeConst(fromBinaryenLiteral(value));
  if (tracing) {
    traceExpression(ret, "BinaryenConst", value);
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module,
                                    BinaryenOp op,
                                    BinaryenExpressionRef value) {
  auto* ret =
    Builder(*(Module*)module).makeUnary(UnaryOp(op), (Expression*)value);

  if (tracing) {
    traceExpression(ret, "BinaryenUnary", op, value);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module,
                                     BinaryenOp op,
                                     BinaryenExpressionRef left,
                                     BinaryenExpressionRef right) {
  auto* ret =
    Builder(*(Module*)module)
      .makeBinary(BinaryOp(op), (Expression*)left, (Expression*)right);

  if (tracing) {
    traceExpression(ret, "BinaryenBinary", op, left, right);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSelect(BinaryenModuleRef module,
                                     BinaryenExpressionRef condition,
                                     BinaryenExpressionRef ifTrue,
                                     BinaryenExpressionRef ifFalse,
                                     BinaryenType type) {
  auto* ret = ((Module*)module)->allocator.alloc<Select>();

  if (tracing) {
    traceExpression(ret, "BinaryenSelect", condition, ifTrue, ifFalse, type);
  }

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

  if (tracing) {
    traceExpression(ret, "BinaryenDrop", value);
  }

  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module,
                                     BinaryenExpressionRef value) {
  auto* ret = Builder(*(Module*)module).makeReturn((Expression*)value);

  if (tracing) {
    traceExpression(ret, "BinaryenReturn", value);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module,
                                   BinaryenOp op,
                                   const char* name,
                                   BinaryenExpressionRef* operands,
                                   BinaryenIndex numOperands) {
  auto* ret = ((Module*)module)->allocator.alloc<Host>();

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef operands[] = { ";
    for (BinaryenIndex i = 0; i < numOperands; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "expressions[" << expressions[operands[i]] << "]";
    }
    if (numOperands == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n  ";
    traceExpression(
      ret, "BinaryenHost", StringLit(name), "operands", numOperands);
    std::cout << "  }\n";
  }

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
  auto* ret = ((Module*)module)->allocator.alloc<Nop>();

  if (tracing) {
    traceExpression(ret, "BinaryenNop");
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenUnreachable(BinaryenModuleRef module) {
  auto* ret = ((Module*)module)->allocator.alloc<Unreachable>();

  if (tracing) {
    traceExpression(ret, "BinaryenUnreachable");
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicLoad(BinaryenModuleRef module,
                                         uint32_t bytes,
                                         uint32_t offset,
                                         BinaryenType type,
                                         BinaryenExpressionRef ptr) {
  auto* ret = Builder(*(Module*)module)
                .makeAtomicLoad(bytes, offset, (Expression*)ptr, Type(type));

  if (tracing) {
    traceExpression(ret, "BinaryenAtomicLoad", bytes, offset, type, ptr);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicStore(BinaryenModuleRef module,
                                          uint32_t bytes,
                                          uint32_t offset,
                                          BinaryenExpressionRef ptr,
                                          BinaryenExpressionRef value,
                                          BinaryenType type) {
  auto* ret =
    Builder(*(Module*)module)
      .makeAtomicStore(
        bytes, offset, (Expression*)ptr, (Expression*)value, Type(type));

  if (tracing) {
    traceExpression(
      ret, "BinaryenAtomicStore", bytes, offset, ptr, value, type);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicRMW(BinaryenModuleRef module,
                                        BinaryenOp op,
                                        BinaryenIndex bytes,
                                        BinaryenIndex offset,
                                        BinaryenExpressionRef ptr,
                                        BinaryenExpressionRef value,
                                        BinaryenType type) {
  auto* ret = Builder(*(Module*)module)
                .makeAtomicRMW(AtomicRMWOp(op),
                               bytes,
                               offset,
                               (Expression*)ptr,
                               (Expression*)value,
                               Type(type));

  if (tracing) {
    traceExpression(
      ret, "BinaryenAtomicRMW", op, bytes, offset, ptr, value, type);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicCmpxchg(BinaryenModuleRef module,
                                            BinaryenIndex bytes,
                                            BinaryenIndex offset,
                                            BinaryenExpressionRef ptr,
                                            BinaryenExpressionRef expected,
                                            BinaryenExpressionRef replacement,
                                            BinaryenType type) {
  auto* ret = Builder(*(Module*)module)
                .makeAtomicCmpxchg(bytes,
                                   offset,
                                   (Expression*)ptr,
                                   (Expression*)expected,
                                   (Expression*)replacement,
                                   Type(type));

  if (tracing) {
    traceExpression(ret,
                    "BinaryenAtomicCmpxchg",
                    bytes,
                    offset,
                    ptr,
                    expected,
                    replacement,
                    type);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicWait(BinaryenModuleRef module,
                                         BinaryenExpressionRef ptr,
                                         BinaryenExpressionRef expected,
                                         BinaryenExpressionRef timeout,
                                         BinaryenType expectedType) {
  auto* ret = Builder(*(Module*)module)
                .makeAtomicWait((Expression*)ptr,
                                (Expression*)expected,
                                (Expression*)timeout,
                                Type(expectedType),
                                0);

  if (tracing) {
    traceExpression(
      ret, "BinaryenAtomicWait", ptr, expected, timeout, expectedType);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicNotify(BinaryenModuleRef module,
                                           BinaryenExpressionRef ptr,
                                           BinaryenExpressionRef notifyCount) {
  auto* ret =
    Builder(*(Module*)module)
      .makeAtomicNotify((Expression*)ptr, (Expression*)notifyCount, 0);

  if (tracing) {
    traceExpression(ret, "BinaryenAtomicNotify", ptr, notifyCount);
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenAtomicFence(BinaryenModuleRef module) {
  auto* ret = Builder(*(Module*)module).makeAtomicFence();

  if (tracing) {
    traceExpression(ret, "BinaryenAtomicFence");
  }

  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSIMDExtract(BinaryenModuleRef module,
                                          BinaryenOp op,
                                          BinaryenExpressionRef vec,
                                          uint8_t index) {
  auto* ret = Builder(*(Module*)module)
                .makeSIMDExtract(SIMDExtractOp(op), (Expression*)vec, index);
  if (tracing) {
    traceExpression(ret, "BinaryenSIMDExtract", op, vec, int(index));
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSIMDReplace(BinaryenModuleRef module,
                                          BinaryenOp op,
                                          BinaryenExpressionRef vec,
                                          uint8_t index,
                                          BinaryenExpressionRef value) {
  auto* ret =
    Builder(*(Module*)module)
      .makeSIMDReplace(
        SIMDReplaceOp(op), (Expression*)vec, index, (Expression*)value);
  if (tracing) {
    traceExpression(ret, "BinaryenSIMDReplace", op, vec, int(index), value);
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSIMDShuffle(BinaryenModuleRef module,
                                          BinaryenExpressionRef left,
                                          BinaryenExpressionRef right,
                                          const uint8_t mask_[16]) {
  std::array<uint8_t, 16> mask;
  memcpy(mask.data(), mask_, 16);
  auto* ret = Builder(*(Module*)module)
                .makeSIMDShuffle((Expression*)left, (Expression*)right, mask);
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    uint8_t mask[] = {";
    for (size_t i = 0; i < mask.size(); ++i) {
      std::cout << int(mask[i]);
      if (i < mask.size() - 1) {
        std::cout << ", ";
      }
    }
    std::cout << "};\n  ";
    traceExpression(ret, "BinaryenSIMDShuffle", left, right, "mask");
    std::cout << "  }\n";
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSIMDTernary(BinaryenModuleRef module,
                                          BinaryenOp op,
                                          BinaryenExpressionRef a,
                                          BinaryenExpressionRef b,
                                          BinaryenExpressionRef c) {
  auto* ret =
    Builder(*(Module*)module)
      .makeSIMDTernary(
        SIMDTernaryOp(op), (Expression*)a, (Expression*)b, (Expression*)c);
  if (tracing) {
    traceExpression(ret, "BinaryenSIMDTernary", op, a, b, c);
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSIMDShift(BinaryenModuleRef module,
                                        BinaryenOp op,
                                        BinaryenExpressionRef vec,
                                        BinaryenExpressionRef shift) {
  auto* ret =
    Builder(*(Module*)module)
      .makeSIMDShift(SIMDShiftOp(op), (Expression*)vec, (Expression*)shift);
  if (tracing) {
    traceExpression(ret, "BinaryenSIMDShift", op, vec, shift);
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenSIMDLoad(BinaryenModuleRef module,
                                       BinaryenOp op,
                                       uint32_t offset,
                                       uint32_t align,
                                       BinaryenExpressionRef ptr) {
  auto* ret =
    Builder(*(Module*)module)
      .makeSIMDLoad(
        SIMDLoadOp(op), Address(offset), Address(align), (Expression*)ptr);
  if (tracing) {
    traceExpression(ret, "BinaryenSIMDLoad", op, offset, align, ptr);
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenMemoryInit(BinaryenModuleRef module,
                                         uint32_t segment,
                                         BinaryenExpressionRef dest,
                                         BinaryenExpressionRef offset,
                                         BinaryenExpressionRef size) {
  auto* ret =
    Builder(*(Module*)module)
      .makeMemoryInit(
        segment, (Expression*)dest, (Expression*)offset, (Expression*)size);
  if (tracing) {
    traceExpression(ret, "BinaryenMemoryInit", segment, dest, offset, size);
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenDataDrop(BinaryenModuleRef module,
                                       uint32_t segment) {
  auto* ret = Builder(*(Module*)module).makeDataDrop(segment);
  if (tracing) {
    traceExpression(ret, "BinaryenDataDrop", segment);
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenMemoryCopy(BinaryenModuleRef module,
                                         BinaryenExpressionRef dest,
                                         BinaryenExpressionRef source,
                                         BinaryenExpressionRef size) {
  auto* ret = Builder(*(Module*)module)
                .makeMemoryCopy(
                  (Expression*)dest, (Expression*)source, (Expression*)size);
  if (tracing) {
    traceExpression(ret, "BinaryenMemoryCopy", dest, source, size);
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenMemoryFill(BinaryenModuleRef module,
                                         BinaryenExpressionRef dest,
                                         BinaryenExpressionRef value,
                                         BinaryenExpressionRef size) {
  auto* ret =
    Builder(*(Module*)module)
      .makeMemoryFill((Expression*)dest, (Expression*)value, (Expression*)size);
  if (tracing) {
    traceExpression(ret, "BinaryenMemoryFill", dest, value, size);
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenPush(BinaryenModuleRef module,
                                   BinaryenExpressionRef value) {
  auto* ret = Builder(*(Module*)module).makePush((Expression*)value);
  if (tracing) {
    traceExpression(ret, "BinaryenPush", value);
  }
  return static_cast<Expression*>(ret);
}
BinaryenExpressionRef BinaryenPop(BinaryenModuleRef module, BinaryenType type) {
  auto* ret = Builder(*(Module*)module).makePop(Type(type));
  if (tracing) {
    traceExpression(ret, "BinaryenPop", type);
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenRefNull(BinaryenModuleRef module) {
  auto* ret = Builder(*(Module*)module).makeRefNull();
  if (tracing) {
    traceExpression(ret, "BinaryenRefNull");
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenRefIsNull(BinaryenModuleRef module,
                                        BinaryenExpressionRef value) {
  auto* ret = Builder(*(Module*)module).makeRefIsNull((Expression*)value);
  if (tracing) {
    traceExpression(ret, "BinaryenRefIsNull", value);
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenRefFunc(BinaryenModuleRef module,
                                      const char* func) {
  auto* ret = Builder(*(Module*)module).makeRefFunc(func);
  if (tracing) {
    traceExpression(ret, "BinaryenRefFunc", StringLit(func));
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenTry(BinaryenModuleRef module,
                                  BinaryenExpressionRef body,
                                  BinaryenExpressionRef catchBody) {
  auto* ret = Builder(*(Module*)module)
                .makeTry((Expression*)body, (Expression*)catchBody);
  if (tracing) {
    traceExpression(ret, "BinaryenTry", body, catchBody);
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenThrow(BinaryenModuleRef module,
                                    const char* event,
                                    BinaryenExpressionRef* operands,
                                    BinaryenIndex numOperands) {
  std::vector<Expression*> args;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    args.push_back((Expression*)operands[i]);
  }
  auto* ret = Builder(*(Module*)module).makeThrow(event, args);

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenExpressionRef operands[] = { ";
    for (BinaryenIndex i = 0; i < numOperands; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "expressions[" << expressions[operands[i]] << "]";
    }
    if (numOperands == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n  ";
    traceExpression(
      ret, "BinaryenThrow", StringLit(event), "operands", numOperands);
    std::cout << "  }\n";
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenRethrow(BinaryenModuleRef module,
                                      BinaryenExpressionRef exnref) {
  auto* ret = Builder(*(Module*)module).makeRethrow((Expression*)exnref);
  if (tracing) {
    traceExpression(ret, "BinaryenRethrow", exnref);
  }
  return static_cast<Expression*>(ret);
}

BinaryenExpressionRef BinaryenBrOnExn(BinaryenModuleRef module,
                                      const char* name,
                                      const char* eventName,
                                      BinaryenExpressionRef exnref) {
  Module* wasm = (Module*)module;
  Event* event = wasm->getEventOrNull(eventName);
  assert(event && "br_on_exn's event must exist");
  auto* ret = Builder(*wasm).makeBrOnExn(name, event, (Expression*)exnref);

  if (tracing) {
    traceExpression(
      ret, "BinaryenBrOnExn", StringLit(name), StringLit(eventName), exnref);
  }
  return static_cast<Expression*>(ret);
}

// Expression utility

BinaryenExpressionId BinaryenExpressionGetId(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionGetId(expressions[" << expressions[expr]
              << "]);\n";
  }

  return ((Expression*)expr)->_id;
}
BinaryenType BinaryenExpressionGetType(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionGetType(expressions[" << expressions[expr]
              << "]);\n";
  }

  return ((Expression*)expr)->type;
}
void BinaryenExpressionPrint(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionPrint(expressions[" << expressions[expr]
              << "]);\n";
  }

  WasmPrinter::printExpression((Expression*)expr, std::cout);
  std::cout << '\n';
}

// Specific expression utility

// Block
const char* BinaryenBlockGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBlockGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->name.c_str();
}
BinaryenIndex BinaryenBlockGetNumChildren(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBlockGetNumChildren(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->list.size();
}
BinaryenExpressionRef BinaryenBlockGetChild(BinaryenExpressionRef expr,
                                            BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenBlockGetChild(expressions[" << expressions[expr]
              << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  assert(index < static_cast<Block*>(expression)->list.size());
  return static_cast<Block*>(expression)->list[index];
}
// If
BinaryenExpressionRef BinaryenIfGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetCondition(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->condition;
}
BinaryenExpressionRef BinaryenIfGetIfTrue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetIfTrue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->ifTrue;
}
BinaryenExpressionRef BinaryenIfGetIfFalse(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetIfFalse(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->ifFalse;
}
// Loop
const char* BinaryenLoopGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoopGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  return static_cast<Loop*>(expression)->name.c_str();
}
BinaryenExpressionRef BinaryenLoopGetBody(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoopGetBody(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  return static_cast<Loop*>(expression)->body;
}
// Break
const char* BinaryenBreakGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->name.c_str();
}
BinaryenExpressionRef BinaryenBreakGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetCondition(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->condition;
}
BinaryenExpressionRef BinaryenBreakGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->value;
}
// Switch
BinaryenIndex BinaryenSwitchGetNumNames(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetNumNames(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->targets.size();
}
const char* BinaryenSwitchGetName(BinaryenExpressionRef expr,
                                  BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetName(expressions[" << expressions[expr]
              << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  assert(index < static_cast<Switch*>(expression)->targets.size());
  return static_cast<Switch*>(expression)->targets[index].c_str();
}
const char* BinaryenSwitchGetDefaultName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetDefaultName(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->default_.c_str();
}
BinaryenExpressionRef BinaryenSwitchGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetCondition(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->condition;
}
BinaryenExpressionRef BinaryenSwitchGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->value;
}
// Call
const char* BinaryenCallGetTarget(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallGetTarget(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->target.c_str();
}
BinaryenIndex BinaryenCallGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallGetNumOperands(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenCallGetOperand(BinaryenExpressionRef expr,
                                             BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenCallGetOperand(expressions[" << expressions[expr]
              << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(index < static_cast<Call*>(expression)->operands.size());
  return static_cast<Call*>(expression)->operands[index];
}
// CallIndirect
BinaryenExpressionRef
BinaryenCallIndirectGetTarget(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallIndirectGetTarget(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->target;
}
BinaryenIndex BinaryenCallIndirectGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallIndirectGetNumOperands(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenCallIndirectGetOperand(BinaryenExpressionRef expr,
                                                     BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenCallIndirectGetOperand(expressions["
              << expressions[expr] << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  assert(index < static_cast<CallIndirect*>(expression)->operands.size());
  return static_cast<CallIndirect*>(expression)->operands[index];
}
// LocalGet
BinaryenIndex BinaryenLocalGetGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLocalGetGetIndex(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<LocalGet>());
  return static_cast<LocalGet*>(expression)->index;
}
// LocalSet
int BinaryenLocalSetIsTee(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLocalSetIsTee(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->isTee();
}
BinaryenIndex BinaryenLocalSetGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLocalSetGetIndex(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->index;
}
BinaryenExpressionRef BinaryenLocalSetGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLocalSetGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->value;
}
// GlobalGet
const char* BinaryenGlobalGetGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenGlobalGetGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalGet>());
  return static_cast<GlobalGet*>(expression)->name.c_str();
}
// GlobalSet
const char* BinaryenGlobalSetGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenGlobalSetGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalSet>());
  return static_cast<GlobalSet*>(expression)->name.c_str();
}
BinaryenExpressionRef BinaryenGlobalSetGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenGlobalSetGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalSet>());
  return static_cast<GlobalSet*>(expression)->value;
}
// Host
BinaryenOp BinaryenHostGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->op;
}
const char* BinaryenHostGetNameOperand(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetNameOperand(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->nameOperand.c_str();
}
BinaryenIndex BinaryenHostGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetNumOperands(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->operands.size();
}
BinaryenExpressionRef BinaryenHostGetOperand(BinaryenExpressionRef expr,
                                             BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenHostGetOperand(expressions[" << expressions[expr]
              << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  assert(index < static_cast<Host*>(expression)->operands.size());
  return static_cast<Host*>(expression)->operands[index];
}
// Load
int BinaryenLoadIsAtomic(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadIsAtomic(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->isAtomic;
}
int BinaryenLoadIsSigned(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadIsSigned(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->signed_;
}
uint32_t BinaryenLoadGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetBytes(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->bytes;
}
uint32_t BinaryenLoadGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetOffset(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->offset;
}
uint32_t BinaryenLoadGetAlign(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetAlign(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->align;
}
BinaryenExpressionRef BinaryenLoadGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetPtr(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->ptr;
}
// Store
int BinaryenStoreIsAtomic(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreIsAtomic(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->isAtomic;
}
uint32_t BinaryenStoreGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetBytes(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->bytes;
}
uint32_t BinaryenStoreGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetOffset(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->offset;
}
uint32_t BinaryenStoreGetAlign(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetAlign(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->align;
}
BinaryenExpressionRef BinaryenStoreGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetPtr(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->ptr;
}
BinaryenExpressionRef BinaryenStoreGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->value;
}
// Const
int32_t BinaryenConstGetValueI32(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI32(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.geti32();
}
int64_t BinaryenConstGetValueI64(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.geti64();
}
int32_t BinaryenConstGetValueI64Low(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64Low(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return (int32_t)(static_cast<Const*>(expression)->value.geti64() &
                   0xffffffff);
}
int32_t BinaryenConstGetValueI64High(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64High(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return (int32_t)(static_cast<Const*>(expression)->value.geti64() >> 32);
}
float BinaryenConstGetValueF32(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueF32(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.getf32();
}
double BinaryenConstGetValueF64(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueF64(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.getf64();
}
void BinaryenConstGetValueV128(BinaryenExpressionRef expr, uint8_t* out) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueV128(expressions[" << expressions[expr]
              << "], " << out << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  memcpy(out, static_cast<Const*>(expression)->value.getv128().data(), 16);
}
// Unary
BinaryenOp BinaryenUnaryGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenUnaryGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  return static_cast<Unary*>(expression)->op;
}
BinaryenExpressionRef BinaryenUnaryGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenUnaryGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  return static_cast<Unary*>(expression)->value;
}
// Binary
BinaryenOp BinaryenBinaryGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->op;
}
BinaryenExpressionRef BinaryenBinaryGetLeft(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetLeft(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->left;
}
BinaryenExpressionRef BinaryenBinaryGetRight(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetRight(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->right;
}
// Select
BinaryenExpressionRef BinaryenSelectGetIfTrue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetIfTrue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->ifTrue;
}
BinaryenExpressionRef BinaryenSelectGetIfFalse(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetIfFalse(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->ifFalse;
}
BinaryenExpressionRef BinaryenSelectGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetCondition(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->condition;
}
// Drop
BinaryenExpressionRef BinaryenDropGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenDropGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Drop>());
  return static_cast<Drop*>(expression)->value;
}
// Return
BinaryenExpressionRef BinaryenReturnGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenReturnGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Return>());
  return static_cast<Return*>(expression)->value;
}
// AtomicRMW
BinaryenOp BinaryenAtomicRMWGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->op;
}
uint32_t BinaryenAtomicRMWGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetBytes(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->bytes;
}
uint32_t BinaryenAtomicRMWGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetOffset(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->offset;
}
BinaryenExpressionRef BinaryenAtomicRMWGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetPtr(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->ptr;
}
BinaryenExpressionRef BinaryenAtomicRMWGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->value;
}
// AtomicCmpxchg
uint32_t BinaryenAtomicCmpxchgGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetBytes(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->bytes;
}
uint32_t BinaryenAtomicCmpxchgGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetOffset(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->offset;
}
BinaryenExpressionRef BinaryenAtomicCmpxchgGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetPtr(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->ptr;
}
BinaryenExpressionRef
BinaryenAtomicCmpxchgGetExpected(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetExpected(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->expected;
}
BinaryenExpressionRef
BinaryenAtomicCmpxchgGetReplacement(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetReplacement(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->replacement;
}
// AtomicWait
BinaryenExpressionRef BinaryenAtomicWaitGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetPtr(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->ptr;
}
BinaryenExpressionRef
BinaryenAtomicWaitGetExpected(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetExpected(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->expected;
}
BinaryenExpressionRef BinaryenAtomicWaitGetTimeout(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetTimeout(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->timeout;
}
BinaryenType BinaryenAtomicWaitGetExpectedType(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetExpectedType(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->expectedType;
}
// AtomicNotify
BinaryenExpressionRef BinaryenAtomicNotifyGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicNotifyGetPtr(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicNotify>());
  return static_cast<AtomicNotify*>(expression)->ptr;
}
BinaryenExpressionRef
BinaryenAtomicNotifyGetNotifyCount(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicNotifyGetNotifyCount(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicNotify>());
  return static_cast<AtomicNotify*>(expression)->notifyCount;
}
// AtomicFence
uint8_t BinaryenAtomicFenceGetOrder(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicFenceGetOrder(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicFence>());
  return static_cast<AtomicFence*>(expression)->order;
}
// SIMDExtract
BinaryenOp BinaryenSIMDExtractGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDExtractGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->op;
}
BinaryenExpressionRef BinaryenSIMDExtractGetVec(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDExtractGetVec(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->vec;
}
uint8_t BinaryenSIMDExtractGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDExtractGetIndex(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->index;
}
// SIMDReplace
BinaryenOp BinaryenSIMDReplaceGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDReplaceGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->op;
}
BinaryenExpressionRef BinaryenSIMDReplaceGetVec(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDReplaceGetVec(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->vec;
}
uint8_t BinaryenSIMDReplaceGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDReplaceGetIndex(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->index;
}
BinaryenExpressionRef BinaryenSIMDReplaceGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDReplaceGetValue(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->value;
}
// SIMDShuffle
BinaryenExpressionRef BinaryenSIMDShuffleGetLeft(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShuffleGetLeft(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  return static_cast<SIMDShuffle*>(expression)->left;
}
BinaryenExpressionRef BinaryenSIMDShuffleGetRight(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShuffleGetRight(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  return static_cast<SIMDShuffle*>(expression)->right;
}
void BinaryenSIMDShuffleGetMask(BinaryenExpressionRef expr, uint8_t* mask) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShuffleGetMask(expressions["
              << expressions[expr] << "], " << mask << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  memcpy(mask, static_cast<SIMDShuffle*>(expression)->mask.data(), 16);
}
// SIMDTernary
BinaryenOp BinaryenSIMDTernaryGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDTernaryOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->op;
}
BinaryenExpressionRef BinaryenSIMDTernaryGetA(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDTernaryGetA(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->a;
}
BinaryenExpressionRef BinaryenSIMDTernaryGetB(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDTernaryGetB(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->b;
}
BinaryenExpressionRef BinaryenSIMDTernaryGetC(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDTernaryGetC(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->c;
}
// SIMDShift
BinaryenOp BinaryenSIMDShiftGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShiftGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->op;
}
BinaryenExpressionRef BinaryenSIMDShiftGetVec(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShiftGetVec(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->vec;
}
BinaryenExpressionRef BinaryenSIMDShiftGetShift(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShiftGetShift(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->shift;
}
// SIMDLoad
BinaryenOp BinaryenSIMDLoadGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDLoadGetOp(expressions[" << expressions[expr]
              << "])\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  return static_cast<SIMDLoad*>(expression)->op;
}
uint32_t BinaryenSIMDLoadGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDLoadGetOffset(expressions[" << expressions[expr]
              << "])\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  return static_cast<SIMDLoad*>(expression)->offset;
}
uint32_t BinaryenSIMDLoadGetAlign(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDLoadGetAlign(expressions[" << expressions[expr]
              << "])\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  return static_cast<SIMDLoad*>(expression)->align;
}
BinaryenExpressionRef BinaryenSIMDLoadGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDLoadGetPtr(expressions[" << expressions[expr]
              << "])\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDLoad>());
  return static_cast<SIMDLoad*>(expression)->ptr;
}
// MemoryInit
uint32_t BinaryenMemoryInitGetSegment(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryInitGetSegment(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->segment;
}
BinaryenExpressionRef BinaryenMemoryInitGetDest(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryInitGetDest(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->dest;
}
BinaryenExpressionRef BinaryenMemoryInitGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryInitGetOffset(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->offset;
}
BinaryenExpressionRef BinaryenMemoryInitGetSize(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryInitGetSize(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->size;
}
// DataDrop
uint32_t BinaryenDataDropGetSegment(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenDataDropGetSegment(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<DataDrop>());
  return static_cast<DataDrop*>(expression)->segment;
}
// MemoryCopy
BinaryenExpressionRef BinaryenMemoryCopyGetDest(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryCopyGetDest(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->dest;
}
BinaryenExpressionRef BinaryenMemoryCopyGetSource(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryCopyGetSource(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->source;
}
BinaryenExpressionRef BinaryenMemoryCopyGetSize(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryCopyGetSize(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->size;
}
// MemoryFill
BinaryenExpressionRef BinaryenMemoryFillGetDest(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryFillGetDest(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->dest;
}
BinaryenExpressionRef BinaryenMemoryFillGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryFillGetValue(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->value;
}
BinaryenExpressionRef BinaryenMemoryFillGetSize(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryFillGetSize(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->size;
}
// Push
BinaryenExpressionRef BinaryenPushGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenPushGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Push>());
  return static_cast<Push*>(expression)->value;
}
// RefIsNull
BinaryenExpressionRef BinaryenRefIsNullGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenRefIsNullGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<RefIsNull>());
  return static_cast<RefIsNull*>(expression)->value;
}
// RefFunc
const char* BinaryenRefFuncGetFunc(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenRefFuncGetFunc(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<RefFunc>());
  return static_cast<RefFunc*>(expression)->func.c_str();
}
// Try
BinaryenExpressionRef BinaryenTryGetBody(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenTryGetBody(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Try>());
  return static_cast<Try*>(expression)->body;
}
BinaryenExpressionRef BinaryenTryGetCatchBody(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenTryGetCatchBody(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Try>());
  return static_cast<Try*>(expression)->catchBody;
}
// Throw
const char* BinaryenThrowGetEvent(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenThrowGetEvent(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  return static_cast<Throw*>(expression)->event.c_str();
}
BinaryenExpressionRef BinaryenThrowGetOperand(BinaryenExpressionRef expr,
                                              BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenThrowGetOperand(expressions[" << expressions[expr]
              << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  assert(index < static_cast<Throw*>(expression)->operands.size());
  return static_cast<Throw*>(expression)->operands[index];
}
BinaryenIndex BinaryenThrowGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenThrowGetNumOperands(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  return static_cast<Throw*>(expression)->operands.size();
}
// Rethrow
BinaryenExpressionRef BinaryenRethrowGetExnref(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenRethrowGetExnref(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Rethrow>());
  return static_cast<Rethrow*>(expression)->exnref;
}
// BrOnExn
const char* BinaryenBrOnExnGetEvent(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBrOnExnGetEvent(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->event.c_str();
}
const char* BinaryenBrOnExnGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBrOnExnGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->name.c_str();
}
BinaryenExpressionRef BinaryenBrOnExnGetExnref(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBrOnExnGetExnref(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->exnref;
}

// Functions

BinaryenFunctionRef BinaryenAddFunction(BinaryenModuleRef module,
                                        const char* name,
                                        BinaryenType params,
                                        BinaryenType results,
                                        BinaryenType* varTypes,
                                        BinaryenIndex numVarTypes,
                                        BinaryenExpressionRef body) {
  auto* wasm = (Module*)module;
  auto* ret = new Function;

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenType varTypes[] = { ";
    for (BinaryenIndex i = 0; i < numVarTypes; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << varTypes[i];
    }
    if (numVarTypes == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n";
    auto id = functions.size();
    functions[ret] = id;
    std::cout << "    functions[" << id
              << "] = BinaryenAddFunction(the_module, \"" << name << "\", "
              << params << ", " << results << ", varTypes, " << numVarTypes
              << ", expressions[" << expressions[body] << "]);\n";
    std::cout << "  }\n";
  }

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
    wasm->addFunction(ret);
  }

  return ret;
}
BinaryenFunctionRef BinaryenGetFunction(BinaryenModuleRef module,
                                        const char* name) {
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
uint32_t BinaryenGetNumFunctions(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenGetNumFunctions(the_module);\n";
  }

  auto* wasm = (Module*)module;
  return wasm->functions.size();
}
BinaryenFunctionRef BinaryenGetFunctionByIndex(BinaryenModuleRef module,
                                               BinaryenIndex id) {
  if (tracing) {
    std::cout << "  BinaryenGetFunctionByIndex(the_module, " << id << ");\n";
  }

  auto* wasm = (Module*)module;
  if (wasm->functions.size() <= id) {
    Fatal() << "invalid function id.";
  }
  return wasm->functions[id].get();
}

// Globals

BinaryenGlobalRef BinaryenAddGlobal(BinaryenModuleRef module,
                                    const char* name,
                                    BinaryenType type,
                                    int8_t mutable_,
                                    BinaryenExpressionRef init) {
  auto* wasm = (Module*)module;
  auto* ret = new Global();

  if (tracing) {
    auto id = globals.size();
    globals[ret] = id;
    std::cout << "  globals[" << id << "] = BinaryenAddGlobal(the_module, \""
              << name << "\", " << type << ", " << int(mutable_)
              << ", expressions[" << expressions[init] << "]);\n";
  }

  ret->name = name;
  ret->type = Type(type);
  ret->mutable_ = !!mutable_;
  ret->init = (Expression*)init;
  wasm->addGlobal(ret);
  return ret;
}
BinaryenGlobalRef BinaryenGetGlobal(BinaryenModuleRef module,
                                    const char* name) {
  if (tracing) {
    std::cout << "  BinaryenGetGlobal(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  return wasm->getGlobal(name);
}
void BinaryenRemoveGlobal(BinaryenModuleRef module, const char* name) {
  if (tracing) {
    std::cout << "  BinaryenRemoveGlobal(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeGlobal(name);
}

// Events

BinaryenEventRef BinaryenAddEvent(BinaryenModuleRef module,
                                  const char* name,
                                  uint32_t attribute,
                                  BinaryenType params,
                                  BinaryenType results) {
  if (tracing) {
    std::cout << "  BinaryenAddEvent(the_module, \"" << name << "\", "
              << attribute << ", " << params << ", " << results << ");\n";
  }

  auto* wasm = (Module*)module;
  auto* ret = new Event();
  ret->name = name;
  ret->attribute = attribute;
  ret->sig = Signature(Type(params), Type(results));
  wasm->addEvent(ret);
  return ret;
}

BinaryenEventRef BinaryenGetEvent(BinaryenModuleRef module, const char* name) {
  if (tracing) {
    std::cout << "  BinaryenGetEvent(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  return wasm->getEvent(name);
}
void BinaryenRemoveEvent(BinaryenModuleRef module, const char* name) {
  if (tracing) {
    std::cout << "  BinaryenRemoveEvent(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeEvent(name);
}

// Imports

void BinaryenAddFunctionImport(BinaryenModuleRef module,
                               const char* internalName,
                               const char* externalModuleName,
                               const char* externalBaseName,
                               BinaryenType params,
                               BinaryenType results) {
  auto* wasm = (Module*)module;
  auto* ret = new Function();

  if (tracing) {
    std::cout << "  BinaryenAddFunctionImport(the_module, \"" << internalName
              << "\", \"" << externalModuleName << "\", \"" << externalBaseName
              << "\", " << params << ", " << results << ");\n";
  }

  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->sig = Signature(Type(params), Type(results));
  wasm->addFunction(ret);
}
void BinaryenAddTableImport(BinaryenModuleRef module,
                            const char* internalName,
                            const char* externalModuleName,
                            const char* externalBaseName) {
  auto* wasm = (Module*)module;

  if (tracing) {
    std::cout << "  BinaryenAddTableImport(the_module, \"" << internalName
              << "\", \"" << externalModuleName << "\", \"" << externalBaseName
              << "\");\n";
  }

  wasm->table.module = externalModuleName;
  wasm->table.base = externalBaseName;
}
void BinaryenAddMemoryImport(BinaryenModuleRef module,
                             const char* internalName,
                             const char* externalModuleName,
                             const char* externalBaseName,
                             uint8_t shared) {
  auto* wasm = (Module*)module;

  if (tracing) {
    std::cout << "  BinaryenAddMemoryImport(the_module, \"" << internalName
              << "\", \"" << externalModuleName << "\", \"" << externalBaseName
              << "\", " << int(shared) << ");\n";
  }

  wasm->memory.module = externalModuleName;
  wasm->memory.base = externalBaseName;
  wasm->memory.shared = shared;
}
void BinaryenAddGlobalImport(BinaryenModuleRef module,
                             const char* internalName,
                             const char* externalModuleName,
                             const char* externalBaseName,
                             BinaryenType globalType,
                             int mutable_) {
  auto* wasm = (Module*)module;
  auto* ret = new Global();

  if (tracing) {
    std::cout << "  BinaryenAddGlobalImport(the_module, \"" << internalName
              << "\", \"" << externalModuleName << "\", \"" << externalBaseName
              << "\", " << globalType << ", " << mutable_ << ");\n";
  }

  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->type = Type(globalType);
  ret->mutable_ = mutable_ != 0;
  wasm->addGlobal(ret);
}
void BinaryenAddEventImport(BinaryenModuleRef module,
                            const char* internalName,
                            const char* externalModuleName,
                            const char* externalBaseName,
                            uint32_t attribute,
                            BinaryenType params,
                            BinaryenType results) {
  auto* wasm = (Module*)module;
  auto* ret = new Event();

  if (tracing) {
    std::cout << "  BinaryenAddEventImport(the_module, \"" << internalName
              << "\", \"" << externalModuleName << "\", \"" << externalBaseName
              << "\", " << attribute << ", " << params << ", " << results
              << ");\n";
  }

  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->sig = Signature(Type(params), Type(results));
  wasm->addEvent(ret);
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
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id
              << "] = BinaryenAddFunctionExport(the_module, \"" << internalName
              << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Function;
  wasm->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddTableExport(BinaryenModuleRef module,
                                         const char* internalName,
                                         const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id
              << "] = BinaryenAddTableExport(the_module, \"" << internalName
              << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Table;
  wasm->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddMemoryExport(BinaryenModuleRef module,
                                          const char* internalName,
                                          const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id
              << "] = BinaryenAddMemoryExport(the_module, \"" << internalName
              << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Memory;
  wasm->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddGlobalExport(BinaryenModuleRef module,
                                          const char* internalName,
                                          const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id
              << "] = BinaryenAddGlobalExport(the_module, \"" << internalName
              << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Global;
  wasm->addExport(ret);
  return ret;
}
BinaryenExportRef BinaryenAddEventExport(BinaryenModuleRef module,
                                         const char* internalName,
                                         const char* externalName) {
  auto* wasm = (Module*)module;
  auto* ret = new Export();

  if (tracing) {
    auto id = exports.size();
    exports[ret] = id;
    std::cout << "  exports[" << id
              << "] = BinaryenAddEventExport(the_module, \"" << internalName
              << "\", \"" << externalName << "\");\n";
  }

  ret->value = internalName;
  ret->name = externalName;
  ret->kind = ExternalKind::Event;
  wasm->addExport(ret);
  return ret;
}
void BinaryenRemoveExport(BinaryenModuleRef module, const char* externalName) {
  if (tracing) {
    std::cout << "  BinaryenRemoveExport(the_module, \"" << externalName
              << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeExport(externalName);
}

// Function table. One per module

void BinaryenSetFunctionTable(BinaryenModuleRef module,
                              BinaryenIndex initial,
                              BinaryenIndex maximum,
                              const char** funcNames,
                              BinaryenIndex numFuncNames,
                              BinaryenExpressionRef offset) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char* funcNames[] = { ";
    for (BinaryenIndex i = 0; i < numFuncNames; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "\"" << funcNames[i] << "\"";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenSetFunctionTable(the_module, " << initial << ", "
              << maximum << ", funcNames, " << numFuncNames << ", expressions["
              << expressions[offset] << "]);\n";
    std::cout << "  }\n";
  }

  auto* wasm = (Module*)module;
  Table::Segment segment((Expression*)offset);
  for (BinaryenIndex i = 0; i < numFuncNames; i++) {
    segment.data.push_back(funcNames[i]);
  }
  wasm->table.initial = initial;
  wasm->table.max = maximum;
  wasm->table.exists = true;
  wasm->table.segments.push_back(segment);
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
  if (tracing) {
    std::cout << "  {\n";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      std::cout << "    const char segment" << i << "[] = { ";
      for (BinaryenIndex j = 0; j < segmentSizes[i]; j++) {
        if (j > 0) {
          std::cout << ", ";
        }
        std::cout << int(segments[i][j]);
      }
      std::cout << " };\n";
    }
    std::cout << "    const char* segments[] = { ";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "segment" << i;
    }
    if (numSegments == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n";
    std::cout << "    int8_t segmentPassive[] = { ";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << int(segmentPassive[i]);
    }
    if (numSegments == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenExpressionRef segmentOffsets[] = { ";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "expressions[" << expressions[segmentOffsets[i]] << "]";
    }
    if (numSegments == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenIndex segmentSizes[] = { ";
    for (BinaryenIndex i = 0; i < numSegments; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << segmentSizes[i];
    }
    if (numSegments == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenSetMemory(the_module, " << initial << ", "
              << maximum << ", ";
    traceNameOrNULL(exportName);
    std::cout << ", segments, segmentPassive, segmentOffsets, segmentSizes, "
              << numSegments << ", " << int(shared) << ");\n";
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
    wasm->memory.segments.emplace_back(segmentPassive[i],
                                       (Expression*)segmentOffsets[i],
                                       segments[i],
                                       segmentSizes[i]);
  }
}

// Memory segments

uint32_t BinaryenGetNumMemorySegments(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenGetNumMemorySegments(the_module);\n";
  }

  auto* wasm = (Module*)module;
  return wasm->memory.segments.size();
}
uint32_t BinaryenGetMemorySegmentByteOffset(BinaryenModuleRef module,
                                            BinaryenIndex id) {
  if (tracing) {
    std::cout << "  BinaryenGetMemorySegmentByteOffset(the_module, " << id
              << ");\n";
  }

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

  const Memory::Segment& segment = wasm->memory.segments[id];

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
  if (tracing) {
    std::cout << "  BinaryenGetMemorySegmentByteLength(the_module, " << id
              << ");\n";
  }

  auto* wasm = (Module*)module;
  if (wasm->memory.segments.size() <= id) {
    Fatal() << "invalid segment id.";
  }
  const Memory::Segment& segment = wasm->memory.segments[id];
  return segment.data.size();
}
void BinaryenCopyMemorySegmentData(BinaryenModuleRef module,
                                   BinaryenIndex id,
                                   char* buffer) {
  if (tracing) {
    std::cout << "  BinaryenCopyMemorySegmentData(the_module, " << id << ", "
              << static_cast<void*>(buffer) << ");\n";
  }

  auto* wasm = (Module*)module;
  if (wasm->memory.segments.size() <= id) {
    Fatal() << "invalid segment id.";
  }
  const Memory::Segment& segment = wasm->memory.segments[id];
  std::copy(segment.data.cbegin(), segment.data.cend(), buffer);
}

// Start function. One per module

void BinaryenSetStart(BinaryenModuleRef module, BinaryenFunctionRef start) {
  if (tracing) {
    std::cout << "  BinaryenSetStart(the_module, functions[" << functions[start]
              << "]);\n";
  }

  auto* wasm = (Module*)module;
  wasm->addStart(((Function*)start)->name);
}

// Features

BinaryenFeatures BinaryenModuleGetFeatures(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleGetFeatures(the_module);\n";
  }
  auto* wasm = static_cast<Module*>(module);
  return wasm->features.features;
}

void BinaryenModuleSetFeatures(BinaryenModuleRef module,
                               BinaryenFeatures features) {
  if (tracing) {
    std::cout << "  BinaryenModuleSetFeatures(the_module, " << features
              << ");\n";
  }
  auto* wasm = static_cast<Module*>(module);
  wasm->features.features = features;
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
  Wasm2JSBuilder::Flags flags;
  Wasm2JSBuilder wasm2js(flags, globalPassOptions);
  Ref asmjs = wasm2js.processWasm(wasm);
  JSPrinter jser(true, true, asmjs);
  Output out("", Flags::Text); // stdout
  Wasm2JSGlue glue(*wasm, out, flags, "asmFunc");
  glue.emitPre();
  jser.printAst();
  std::cout << jser.buffer << std::endl;
  glue.emitPost();
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
  passRunner.options = globalPassOptions;
  passRunner.addDefaultOptimizationPasses();
  passRunner.run();
}

int BinaryenGetOptimizeLevel(void) {
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

int BinaryenGetShrinkLevel(void) {
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

int BinaryenGetDebugInfo(void) {
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

void BinaryenModuleRunPasses(BinaryenModuleRef module,
                             const char** passes,
                             BinaryenIndex numPasses) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char* passes[] = { ";
    for (BinaryenIndex i = 0; i < numPasses; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "\"" << passes[i] << "\"";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenModuleRunPasses(the_module, passes, " << numPasses
              << ");\n";
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
  PassRunner runner(wasm, globalPassOptions);
  AutoDrop().run(&runner, wasm);
}

static BinaryenBufferSizes writeModule(BinaryenModuleRef module,
                                       char* output,
                                       size_t outputSize,
                                       const char* sourceMapUrl,
                                       char* sourceMap,
                                       size_t sourceMapSize) {
  Module* wasm = (Module*)module;
  BufferWithRandomAccess buffer;
  WasmBinaryWriter writer(wasm, buffer);
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
  if (tracing) {
    std::cout << "  // BinaryenModuleWrite\n";
  }

  return writeModule((Module*)module, output, outputSize, nullptr, nullptr, 0)
    .outputBytes;
}

size_t BinaryenModuleWriteText(BinaryenModuleRef module,
                               char* output,
                               size_t outputSize) {

  if (tracing) {
    std::cout << "  // BinaryenModuleWriteTextr\n";
  }

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
  if (tracing) {
    std::cout << "  // BinaryenModuleWriteWithSourceMap\n";
  }

  assert(url);
  assert(sourceMap);
  return writeModule(
    (Module*)module, output, outputSize, url, sourceMap, sourceMapSize);
}

BinaryenModuleAllocateAndWriteResult
BinaryenModuleAllocateAndWrite(BinaryenModuleRef module,
                               const char* sourceMapUrl) {
  if (tracing) {
    std::cout << " // BinaryenModuleAllocateAndWrite(the_module, ";
    traceNameOrNULL(sourceMapUrl);
    std::cout << ");\n";
  }

  Module* wasm = (Module*)module;
  BufferWithRandomAccess buffer;
  WasmBinaryWriter writer(wasm, buffer);
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
  if (tracing) {
    std::cout << " // BinaryenModuleAllocateAndWriteText(the_module);";
  }

  std::stringstream ss;
  WasmPrinter::printModule((Module*)module, ss);

  const std::string out = ss.str();
  const int len = out.length() + 1;
  char* cout = (char*)malloc(len);
  strncpy(cout, out.c_str(), len);
  return cout;
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
    WasmBinaryBuilder parser(*wasm, buffer);
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

BinaryenIndex BinaryenModuleAddDebugInfoFileName(BinaryenModuleRef module,
                                                 const char* filename) {
  if (tracing) {
    std::cout << "  BinaryenModuleAddDebugInfoFileName(the_module, \""
              << filename << "\");\n";
  }

  Module* wasm = (Module*)module;
  BinaryenIndex index = wasm->debugInfoFileNames.size();
  wasm->debugInfoFileNames.push_back(filename);
  return index;
}

const char* BinaryenModuleGetDebugInfoFileName(BinaryenModuleRef module,
                                               BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenModuleGetDebugInfoFileName(the_module, \"" << index
              << "\");\n";
  }

  Module* wasm = (Module*)module;
  return index < wasm->debugInfoFileNames.size()
           ? wasm->debugInfoFileNames.at(index).c_str()
           : nullptr;
}

//
// ========== Function Operations ==========
//

const char* BinaryenFunctionGetName(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetName(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->name.c_str();
}
BinaryenType BinaryenFunctionGetParams(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetParams(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->sig.params;
}
BinaryenType BinaryenFunctionGetResults(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetResults(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->sig.results;
}
BinaryenIndex BinaryenFunctionGetNumVars(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetNumVars(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->vars.size();
}
BinaryenType BinaryenFunctionGetVar(BinaryenFunctionRef func,
                                    BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetVar(functions[" << functions[func]
              << "], " << index << ");\n";
  }

  auto* fn = (Function*)func;
  assert(index < fn->vars.size());
  return fn->vars[index];
}
BinaryenExpressionRef BinaryenFunctionGetBody(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetBody(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->body;
}
void BinaryenFunctionOptimize(BinaryenFunctionRef func,
                              BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenFunctionOptimize(functions[" << functions[func]
              << "], the_module);\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.options = globalPassOptions;
  passRunner.addDefaultOptimizationPasses();
  passRunner.runOnFunction((Function*)func);
}
void BinaryenFunctionRunPasses(BinaryenFunctionRef func,
                               BinaryenModuleRef module,
                               const char** passes,
                               BinaryenIndex numPasses) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char* passes[] = { ";
    for (BinaryenIndex i = 0; i < numPasses; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << "\"" << passes[i] << "\"";
    }
    std::cout << " };\n";
    std::cout << "    BinaryenFunctionRunPasses(functions[" << functions[func]
              << ", the_module, passes, " << numPasses << ");\n";
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
void BinaryenFunctionSetDebugLocation(BinaryenFunctionRef func,
                                      BinaryenExpressionRef expr,
                                      BinaryenIndex fileIndex,
                                      BinaryenIndex lineNumber,
                                      BinaryenIndex columnNumber) {
  if (tracing) {
    std::cout << "  BinaryenFunctionSetDebugLocation(functions["
              << functions[func] << "], expressions[" << expressions[expr]
              << "], " << fileIndex << ", " << lineNumber << ", "
              << columnNumber << ");\n";
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
// =========== Global operations ===========
//

const char* BinaryenGlobalGetName(BinaryenGlobalRef global) {
  if (tracing) {
    std::cout << "  BinaryenGlobalGetName(globals[" << globals[global]
              << "]);\n";
  }

  return ((Global*)global)->name.c_str();
}
BinaryenType BinaryenGlobalGetType(BinaryenGlobalRef global) {
  if (tracing) {
    std::cout << "  BinaryenGlobalGetType(globals[" << globals[global]
              << "]);\n";
  }

  return ((Global*)global)->type;
}
int BinaryenGlobalIsMutable(BinaryenGlobalRef global) {
  if (tracing) {
    std::cout << "  BinaryenGlobalIsMutable(globals[" << globals[global]
              << "]);\n";
  }

  return ((Global*)global)->mutable_;
}
BinaryenExpressionRef BinaryenGlobalGetInitExpr(BinaryenGlobalRef global) {
  if (tracing) {
    std::cout << "  BinaryenGlobalGetInitExpr(globals[" << globals[global]
              << "]);\n";
  }

  return ((Global*)global)->init;
}

//
// =========== Event operations ===========
//

const char* BinaryenEventGetName(BinaryenEventRef event) {
  if (tracing) {
    std::cout << "  BinaryenEventGetName(events[" << events[event] << "]);\n";
  }

  return ((Event*)event)->name.c_str();
}
int BinaryenEventGetAttribute(BinaryenEventRef event) {
  if (tracing) {
    std::cout << "  BinaryenEventGetAttribute(events[" << events[event]
              << "]);\n";
  }

  return ((Event*)event)->attribute;
}
BinaryenType BinaryenEventGetParams(BinaryenEventRef event) {
  if (tracing) {
    std::cout << "  BinaryenEventGetParams(events[" << events[event] << "]);\n";
  }

  return ((Event*)event)->sig.params;
}

BinaryenType BinaryenEventGetResults(BinaryenEventRef event) {
  if (tracing) {
    std::cout << "  BinaryenEventGetResults(events[" << events[event]
              << "]);\n";
  }

  return ((Event*)event)->sig.results;
}

//
// =========== Import operations ===========
//

const char* BinaryenFunctionImportGetModule(BinaryenFunctionRef import) {
  if (tracing) {
    std::cout << "  BinaryenFunctionImportGetModule(functions["
              << functions[import] << "]);\n";
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
    std::cout << "  BinaryenGlobalImportGetModule(globals[" << globals[import]
              << "]);\n";
  }

  auto* global = (Global*)import;
  if (global->imported()) {
    return global->module.c_str();
  } else {
    return "";
  }
}
const char* BinaryenEventImportGetModule(BinaryenEventRef import) {
  if (tracing) {
    std::cout << "  BinaryenEventImportGetModule(events[" << events[import]
              << "]);\n";
  }

  auto* event = (Event*)import;
  if (event->imported()) {
    return event->module.c_str();
  } else {
    return "";
  }
}
const char* BinaryenFunctionImportGetBase(BinaryenFunctionRef import) {
  if (tracing) {
    std::cout << "  BinaryenFunctionImportGetBase(functions["
              << functions[import] << "]);\n";
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
    std::cout << "  BinaryenGlobalImportGetBase(globals[" << globals[import]
              << "]);\n";
  }

  auto* global = (Global*)import;
  if (global->imported()) {
    return global->base.c_str();
  } else {
    return "";
  }
}
const char* BinaryenEventImportGetBase(BinaryenEventRef import) {
  if (tracing) {
    std::cout << "  BinaryenEventImportGetBase(events[" << events[import]
              << "]);\n";
  }

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
  if (tracing) {
    std::cout << "  BinaryenExportGetKind(exports[" << exports[export_]
              << "]);\n";
  }

  return BinaryenExternalKind(((Export*)export_)->kind);
}
const char* BinaryenExportGetName(BinaryenExportRef export_) {
  if (tracing) {
    std::cout << "  BinaryenExportGetName(exports[" << exports[export_]
              << "]);\n";
  }

  return ((Export*)export_)->name.c_str();
}
const char* BinaryenExportGetValue(BinaryenExportRef export_) {
  if (tracing) {
    std::cout << "  BinaryenExportGetValue(exports[" << exports[export_]
              << "]);\n";
  }

  return ((Export*)export_)->value.c_str();
}
uint32_t BinaryenGetNumExports(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenGetNumExports(the_module);\n";
  }

  auto* wasm = (Module*)module;
  return wasm->exports.size();
}
BinaryenExportRef BinaryenGetExportByIndex(BinaryenModuleRef module,
                                           BinaryenIndex id) {
  if (tracing) {
    std::cout << "  BinaryenGetExportByIndex(the_module, " << id << ");\n";
  }

  auto* wasm = (Module*)module;
  if (wasm->exports.size() <= id) {
    Fatal() << "invalid export id.";
  }
  return wasm->exports[id].get();
}

//
// ========= Custom sections =========
//

void BinaryenAddCustomSection(BinaryenModuleRef module,
                              const char* name,
                              const char* contents,
                              BinaryenIndex contentsSize) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    const char contents[] = { ";
    for (BinaryenIndex i = 0; i < contentsSize; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << int(contents[i]);
    }
    std::cout << " };\n";
    std::cout << "    BinaryenAddCustomSection(the_module, ";
    traceNameOrNULL(name);
    std::cout << ", contents, " << contentsSize << ");\n";
    std::cout << "  }\n";
  }

  auto* wasm = (Module*)module;
  wasm::UserSection customSection;
  customSection.name = name;
  customSection.data = std::vector<char>(contents, contents + contentsSize);
  wasm->userSections.push_back(customSection);
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

RelooperBlockRef RelooperAddBlock(RelooperRef relooper,
                                  BinaryenExpressionRef code) {
  auto* R = (CFG::Relooper*)relooper;
  auto* ret = new CFG::Block((Expression*)code);

  if (tracing) {
    auto id = relooperBlocks.size();
    relooperBlocks[ret] = id;
    std::cout << "  relooperBlocks[" << id
              << "] = RelooperAddBlock(the_relooper, expressions["
              << expressions[code] << "]);\n";
  }

  R->AddBlock(ret);
  return RelooperBlockRef(ret);
}

void RelooperAddBranch(RelooperBlockRef from,
                       RelooperBlockRef to,
                       BinaryenExpressionRef condition,
                       BinaryenExpressionRef code) {
  if (tracing) {
    std::cout << "  RelooperAddBranch(relooperBlocks[" << relooperBlocks[from]
              << "], relooperBlocks[" << relooperBlocks[to] << "], expressions["
              << expressions[condition] << "], expressions["
              << expressions[code] << "]);\n";
  }

  auto* fromBlock = (CFG::Block*)from;
  auto* toBlock = (CFG::Block*)to;
  fromBlock->AddBranchTo(toBlock, (Expression*)condition, (Expression*)code);
}

RelooperBlockRef RelooperAddBlockWithSwitch(RelooperRef relooper,
                                            BinaryenExpressionRef code,
                                            BinaryenExpressionRef condition) {
  auto* R = (CFG::Relooper*)relooper;
  auto* ret = new CFG::Block((Expression*)code, (Expression*)condition);

  if (tracing) {
    std::cout << "  relooperBlocks[" << relooperBlocks[ret]
              << "] = RelooperAddBlockWithSwitch(the_relooper, expressions["
              << expressions[code] << "], expressions["
              << expressions[condition] << "]);\n";
  }

  R->AddBlock(ret);
  return RelooperBlockRef(ret);
}

void RelooperAddBranchForSwitch(RelooperBlockRef from,
                                RelooperBlockRef to,
                                BinaryenIndex* indexes,
                                BinaryenIndex numIndexes,
                                BinaryenExpressionRef code) {
  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenIndex indexes[] = { ";
    for (BinaryenIndex i = 0; i < numIndexes; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << indexes[i];
    }
    if (numIndexes == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n";
    std::cout << "    RelooperAddBranchForSwitch(relooperBlocks["
              << relooperBlocks[from] << "], relooperBlocks["
              << relooperBlocks[to] << "], indexes, " << numIndexes
              << ", expressions[" << expressions[code] << "]);\n";
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

BinaryenExpressionRef RelooperRenderAndDispose(RelooperRef relooper,
                                               RelooperBlockRef entry,
                                               BinaryenIndex labelHelper) {
  auto* R = (CFG::Relooper*)relooper;
  R->Calculate((CFG::Block*)entry);
  CFG::RelooperBuilder builder(*R->Module, labelHelper);
  auto* ret = R->Render(builder);

  if (tracing) {
    auto id = noteExpression(ret);
    std::cout << "  expressions[" << id
              << "] = RelooperRenderAndDispose(the_relooper, relooperBlocks["
              << relooperBlocks[entry] << "], " << labelHelper << ");\n";
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
                 "#include \"binaryen-c.h\"\n"
                 "int main() {\n"
                 "  std::map<size_t, BinaryenExpressionRef> expressions;\n"
                 "  std::map<size_t, BinaryenFunctionRef> functions;\n"
                 "  std::map<size_t, BinaryenGlobalRef> globals;\n"
                 "  std::map<size_t, BinaryenEventRef> events;\n"
                 "  std::map<size_t, BinaryenExportRef> exports;\n"
                 "  std::map<size_t, RelooperBlockRef> relooperBlocks;\n"
                 "  BinaryenModuleRef the_module = NULL;\n"
                 "  RelooperRef the_relooper = NULL;\n";
  } else {
    std::cout << "  return 0;\n";
    std::cout << "}\n";
    std::cout << "// ending a Binaryen API trace\n";
  }
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
