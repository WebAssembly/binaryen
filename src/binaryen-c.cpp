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
#include "ir/function-type-utils.h"
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
    case Type::v128: {
      memcpy(&ret.v128, x.getv128Ptr(), 16);
      break;
    }

    case Type::anyref: // there's no anyref literals
    case Type::exnref: // there's no exnref literals
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE();
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
    case Type::anyref: // there's no anyref literals
    case Type::exnref: // there's no exnref literals
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE();
  }
  WASM_UNREACHABLE();
}

// Mutexes (global for now; in theory if multiple modules
// are used at once this should be optimized to be per-
// module, but likely it doesn't matter)

static std::mutex BinaryenFunctionMutex;
static std::mutex BinaryenFunctionTypeMutex;

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

std::map<BinaryenFunctionTypeRef, size_t> functionTypes;
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
    case Type::anyref: // there's no anyref literals
    case Type::exnref: // there's no exnref literals
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE();
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

BINARYEN_API BinaryenType BinaryenTypeNone(void) { return none; }
BINARYEN_API BinaryenType BinaryenTypeInt32(void) { return i32; }
BINARYEN_API BinaryenType BinaryenTypeInt64(void) { return i64; }
BINARYEN_API BinaryenType BinaryenTypeFloat32(void) { return f32; }
BINARYEN_API BinaryenType BinaryenTypeFloat64(void) { return f64; }
BINARYEN_API BinaryenType BinaryenTypeVec128(void) { return v128; }
BINARYEN_API BinaryenType BinaryenTypeAnyref(void) { return anyref; }
BINARYEN_API BinaryenType BinaryenTypeExnref(void) { return exnref; }
BINARYEN_API BinaryenType BinaryenTypeUnreachable(void) { return unreachable; }
BINARYEN_API BinaryenType BinaryenTypeAuto(void) { return uint32_t(-1); }

WASM_DEPRECATED BinaryenType BinaryenNone(void) { return none; }
WASM_DEPRECATED BinaryenType BinaryenInt32(void) { return i32; }
WASM_DEPRECATED BinaryenType BinaryenInt64(void) { return i64; }
WASM_DEPRECATED BinaryenType BinaryenFloat32(void) { return f32; }
WASM_DEPRECATED BinaryenType BinaryenFloat64(void) { return f64; }
WASM_DEPRECATED BinaryenType BinaryenUndefined(void) { return uint32_t(-1); }

// Expression ids

BINARYEN_API BinaryenExpressionId BinaryenInvalidId(void) {
  return Expression::Id::InvalidId;
}
BINARYEN_API BinaryenExpressionId BinaryenBlockId(void) {
  return Expression::Id::BlockId;
}
BINARYEN_API BinaryenExpressionId BinaryenIfId(void) {
  return Expression::Id::IfId;
}
BINARYEN_API BinaryenExpressionId BinaryenLoopId(void) {
  return Expression::Id::LoopId;
}
BINARYEN_API BinaryenExpressionId BinaryenBreakId(void) {
  return Expression::Id::BreakId;
}
BINARYEN_API BinaryenExpressionId BinaryenSwitchId(void) {
  return Expression::Id::SwitchId;
}
BINARYEN_API BinaryenExpressionId BinaryenCallId(void) {
  return Expression::Id::CallId;
}
BINARYEN_API BinaryenExpressionId BinaryenCallIndirectId(void) {
  return Expression::Id::CallIndirectId;
}
BINARYEN_API BinaryenExpressionId BinaryenLocalGetId(void) {
  return Expression::Id::LocalGetId;
}
BINARYEN_API BinaryenExpressionId BinaryenLocalSetId(void) {
  return Expression::Id::LocalSetId;
}
BINARYEN_API BinaryenExpressionId BinaryenGlobalGetId(void) {
  return Expression::Id::GlobalGetId;
}
BINARYEN_API BinaryenExpressionId BinaryenGlobalSetId(void) {
  return Expression::Id::GlobalSetId;
}
BINARYEN_API BinaryenExpressionId BinaryenLoadId(void) {
  return Expression::Id::LoadId;
}
BINARYEN_API BinaryenExpressionId BinaryenStoreId(void) {
  return Expression::Id::StoreId;
}
BINARYEN_API BinaryenExpressionId BinaryenConstId(void) {
  return Expression::Id::ConstId;
}
BINARYEN_API BinaryenExpressionId BinaryenUnaryId(void) {
  return Expression::Id::UnaryId;
}
BINARYEN_API BinaryenExpressionId BinaryenBinaryId(void) {
  return Expression::Id::BinaryId;
}
BINARYEN_API BinaryenExpressionId BinaryenSelectId(void) {
  return Expression::Id::SelectId;
}
BINARYEN_API BinaryenExpressionId BinaryenDropId(void) {
  return Expression::Id::DropId;
}
BINARYEN_API BinaryenExpressionId BinaryenReturnId(void) {
  return Expression::Id::ReturnId;
}
BINARYEN_API BinaryenExpressionId BinaryenHostId(void) {
  return Expression::Id::HostId;
}
BINARYEN_API BinaryenExpressionId BinaryenNopId(void) {
  return Expression::Id::NopId;
}
BINARYEN_API BinaryenExpressionId BinaryenUnreachableId(void) {
  return Expression::Id::UnreachableId;
}
BINARYEN_API BinaryenExpressionId BinaryenAtomicCmpxchgId(void) {
  return Expression::Id::AtomicCmpxchgId;
}
BINARYEN_API BinaryenExpressionId BinaryenAtomicRMWId(void) {
  return Expression::Id::AtomicRMWId;
}
BINARYEN_API BinaryenExpressionId BinaryenAtomicWaitId(void) {
  return Expression::Id::AtomicWaitId;
}
BINARYEN_API BinaryenExpressionId BinaryenAtomicNotifyId(void) {
  return Expression::Id::AtomicNotifyId;
}
BINARYEN_API BinaryenExpressionId BinaryenAtomicFenceId(void) {
  return Expression::Id::AtomicFenceId;
}
BINARYEN_API BinaryenExpressionId BinaryenSIMDExtractId(void) {
  return Expression::Id::SIMDExtractId;
}
BINARYEN_API BinaryenExpressionId BinaryenSIMDReplaceId(void) {
  return Expression::Id::SIMDReplaceId;
}
BINARYEN_API BinaryenExpressionId BinaryenSIMDShuffleId(void) {
  return Expression::Id::SIMDShuffleId;
}
BINARYEN_API BinaryenExpressionId BinaryenSIMDTernaryId(void) {
  return Expression::Id::SIMDTernaryId;
}
BINARYEN_API BinaryenExpressionId BinaryenSIMDShiftId(void) {
  return Expression::Id::SIMDShiftId;
}
BINARYEN_API BinaryenExpressionId BinaryenMemoryInitId(void) {
  return Expression::Id::MemoryInitId;
}
BINARYEN_API BinaryenExpressionId BinaryenDataDropId(void) {
  return Expression::Id::DataDropId;
}
BINARYEN_API BinaryenExpressionId BinaryenMemoryCopyId(void) {
  return Expression::Id::MemoryCopyId;
}
BINARYEN_API BinaryenExpressionId BinaryenMemoryFillId(void) {
  return Expression::Id::MemoryFillId;
}
BINARYEN_API BinaryenExpressionId BinaryenTryId(void) {
  return Expression::Id::TryId;
}
BINARYEN_API BinaryenExpressionId BinaryenThrowId(void) {
  return Expression::Id::ThrowId;
}
BINARYEN_API BinaryenExpressionId BinaryenRethrowId(void) {
  return Expression::Id::RethrowId;
}
BINARYEN_API BinaryenExpressionId BinaryenBrOnExnId(void) {
  return Expression::Id::BrOnExnId;
}
BINARYEN_API BinaryenExpressionId BinaryenPushId(void) {
  return Expression::Id::PushId;
}
BINARYEN_API BinaryenExpressionId BinaryenPopId(void) {
  return Expression::Id::PopId;
}

// External kinds

BINARYEN_API BinaryenExternalKind BinaryenExternalFunction(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Function);
}
BINARYEN_API BinaryenExternalKind BinaryenExternalTable(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Table);
}
BINARYEN_API BinaryenExternalKind BinaryenExternalMemory(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Memory);
}
BINARYEN_API BinaryenExternalKind BinaryenExternalGlobal(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Global);
}
BINARYEN_API BinaryenExternalKind BinaryenExternalEvent(void) {
  return static_cast<BinaryenExternalKind>(ExternalKind::Event);
}

// Features

BINARYEN_API BinaryenFeatures BinaryenFeatureMVP(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::MVP);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureAtomics(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::Atomics);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureBulkMemory(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::BulkMemory);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureMutableGlobals(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::MutableGlobals);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureNontrappingFPToInt(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::TruncSat);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureSignExt(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::SignExt);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureSIMD128(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::SIMD);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureExceptionHandling(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::ExceptionHandling);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureTailCall(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::TailCall);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureReferenceTypes(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::ReferenceTypes);
}
BINARYEN_API BinaryenFeatures BinaryenFeatureAll(void) {
  return static_cast<BinaryenFeatures>(FeatureSet::Feature::All);
}

// Modules

BINARYEN_API BinaryenModuleRef BinaryenModuleCreate(void) {
  if (tracing) {
    std::cout << "  the_module = BinaryenModuleCreate();\n";
    std::cout << "  expressions[size_t(NULL)] = BinaryenExpressionRef(NULL);\n";
    expressions[NULL] = 0;
  }

  return new Module();
}
BINARYEN_API void BinaryenModuleDispose(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleDispose(the_module);\n";
    std::cout << "  functionTypes.clear();\n";
    std::cout << "  expressions.clear();\n";
    std::cout << "  functions.clear();\n";
    std::cout << "  globals.clear();\n";
    std::cout << "  events.clear();\n";
    std::cout << "  exports.clear();\n";
    std::cout << "  relooperBlocks.clear();\n";
    functionTypes.clear();
    expressions.clear();
    functions.clear();
    globals.clear();
    events.clear();
    exports.clear();
    relooperBlocks.clear();
  }

  delete (Module*)module;
}

// Function types

BINARYEN_API BinaryenFunctionTypeRef
BinaryenAddFunctionType(BinaryenModuleRef module,
                        const char* name,
                        BinaryenType result,
                        BinaryenType* paramTypes,
                        BinaryenIndex numParams) {
  auto* wasm = (Module*)module;
  auto ret = make_unique<FunctionType>();
  if (name) {
    ret->name = name;
  } else {
    ret->name = Name::fromInt(wasm->functionTypes.size());
  }
  ret->result = Type(result);
  for (BinaryenIndex i = 0; i < numParams; i++) {
    ret->params.push_back(Type(paramTypes[i]));
  }

  if (tracing) {
    std::cout << "  {\n";
    std::cout << "    BinaryenType paramTypes[] = { ";
    for (BinaryenIndex i = 0; i < numParams; i++) {
      if (i > 0) {
        std::cout << ", ";
      }
      std::cout << paramTypes[i];
    }
    if (numParams == 0) {
      // ensure the array is not empty, otherwise a compiler error on VS
      std::cout << "0";
    }
    std::cout << " };\n";
    size_t id = functionTypes.size();
    std::cout << "    functionTypes[" << id
              << "] = BinaryenAddFunctionType(the_module, ";
    functionTypes[ret.get()] = id;
    traceNameOrNULL(name);
    std::cout << ", " << result << ", paramTypes, " << numParams << ");\n";
    std::cout << "  }\n";
  }

  // Lock. This can be called from multiple threads at once, and is a
  // point where they all access and modify the module.
  std::lock_guard<std::mutex> lock(BinaryenFunctionTypeMutex);
  return wasm->addFunctionType(std::move(ret));
}
BINARYEN_API void BinaryenRemoveFunctionType(BinaryenModuleRef module,
                                             const char* name) {
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

BINARYEN_API BinaryenLiteral BinaryenLiteralInt32(int32_t x) {
  return toBinaryenLiteral(Literal(x));
}
BINARYEN_API BinaryenLiteral BinaryenLiteralInt64(int64_t x) {
  return toBinaryenLiteral(Literal(x));
}
BINARYEN_API BinaryenLiteral BinaryenLiteralFloat32(float x) {
  return toBinaryenLiteral(Literal(x));
}
BINARYEN_API BinaryenLiteral BinaryenLiteralFloat64(double x) {
  return toBinaryenLiteral(Literal(x));
}
BINARYEN_API BinaryenLiteral BinaryenLiteralVec128(const uint8_t x[16]) {
  return toBinaryenLiteral(Literal(x));
}
BINARYEN_API BinaryenLiteral BinaryenLiteralFloat32Bits(int32_t x) {
  return toBinaryenLiteral(Literal(x).castToF32());
}
BINARYEN_API BinaryenLiteral BinaryenLiteralFloat64Bits(int64_t x) {
  return toBinaryenLiteral(Literal(x).castToF64());
}

// Expressions

BINARYEN_API BinaryenOp BinaryenClzInt32(void) { return ClzInt32; }
BINARYEN_API BinaryenOp BinaryenCtzInt32(void) { return CtzInt32; }
BINARYEN_API BinaryenOp BinaryenPopcntInt32(void) { return PopcntInt32; }
BINARYEN_API BinaryenOp BinaryenNegFloat32(void) { return NegFloat32; }
BINARYEN_API BinaryenOp BinaryenAbsFloat32(void) { return AbsFloat32; }
BINARYEN_API BinaryenOp BinaryenCeilFloat32(void) { return CeilFloat32; }
BINARYEN_API BinaryenOp BinaryenFloorFloat32(void) { return FloorFloat32; }
BINARYEN_API BinaryenOp BinaryenTruncFloat32(void) { return TruncFloat32; }
BINARYEN_API BinaryenOp BinaryenNearestFloat32(void) { return NearestFloat32; }
BINARYEN_API BinaryenOp BinaryenSqrtFloat32(void) { return SqrtFloat32; }
BINARYEN_API BinaryenOp BinaryenEqZInt32(void) { return EqZInt32; }
BINARYEN_API BinaryenOp BinaryenClzInt64(void) { return ClzInt64; }
BINARYEN_API BinaryenOp BinaryenCtzInt64(void) { return CtzInt64; }
BINARYEN_API BinaryenOp BinaryenPopcntInt64(void) { return PopcntInt64; }
BINARYEN_API BinaryenOp BinaryenNegFloat64(void) { return NegFloat64; }
BINARYEN_API BinaryenOp BinaryenAbsFloat64(void) { return AbsFloat64; }
BINARYEN_API BinaryenOp BinaryenCeilFloat64(void) { return CeilFloat64; }
BINARYEN_API BinaryenOp BinaryenFloorFloat64(void) { return FloorFloat64; }
BINARYEN_API BinaryenOp BinaryenTruncFloat64(void) { return TruncFloat64; }
BINARYEN_API BinaryenOp BinaryenNearestFloat64(void) { return NearestFloat64; }
BINARYEN_API BinaryenOp BinaryenSqrtFloat64(void) { return SqrtFloat64; }
BINARYEN_API BinaryenOp BinaryenEqZInt64(void) { return EqZInt64; }
BINARYEN_API BinaryenOp BinaryenExtendSInt32(void) { return ExtendSInt32; }
BINARYEN_API BinaryenOp BinaryenExtendUInt32(void) { return ExtendUInt32; }
BINARYEN_API BinaryenOp BinaryenWrapInt64(void) { return WrapInt64; }
BINARYEN_API BinaryenOp BinaryenTruncSFloat32ToInt32(void) {
  return TruncSFloat32ToInt32;
}
BINARYEN_API BinaryenOp BinaryenTruncSFloat32ToInt64(void) {
  return TruncSFloat32ToInt64;
}
BINARYEN_API BinaryenOp BinaryenTruncUFloat32ToInt32(void) {
  return TruncUFloat32ToInt32;
}
BINARYEN_API BinaryenOp BinaryenTruncUFloat32ToInt64(void) {
  return TruncUFloat32ToInt64;
}
BINARYEN_API BinaryenOp BinaryenTruncSFloat64ToInt32(void) {
  return TruncSFloat64ToInt32;
}
BINARYEN_API BinaryenOp BinaryenTruncSFloat64ToInt64(void) {
  return TruncSFloat64ToInt64;
}
BINARYEN_API BinaryenOp BinaryenTruncUFloat64ToInt32(void) {
  return TruncUFloat64ToInt32;
}
BINARYEN_API BinaryenOp BinaryenTruncUFloat64ToInt64(void) {
  return TruncUFloat64ToInt64;
}
BINARYEN_API BinaryenOp BinaryenReinterpretFloat32(void) {
  return ReinterpretFloat32;
}
BINARYEN_API BinaryenOp BinaryenReinterpretFloat64(void) {
  return ReinterpretFloat64;
}
BINARYEN_API BinaryenOp BinaryenExtendS8Int32(void) { return ExtendS8Int32; }
BINARYEN_API BinaryenOp BinaryenExtendS16Int32(void) { return ExtendS16Int32; }
BINARYEN_API BinaryenOp BinaryenExtendS8Int64(void) { return ExtendS8Int64; }
BINARYEN_API BinaryenOp BinaryenExtendS16Int64(void) { return ExtendS16Int64; }
BINARYEN_API BinaryenOp BinaryenExtendS32Int64(void) { return ExtendS32Int64; }
BINARYEN_API BinaryenOp BinaryenConvertSInt32ToFloat32(void) {
  return ConvertSInt32ToFloat32;
}
BINARYEN_API BinaryenOp BinaryenConvertSInt32ToFloat64(void) {
  return ConvertSInt32ToFloat64;
}
BINARYEN_API BinaryenOp BinaryenConvertUInt32ToFloat32(void) {
  return ConvertUInt32ToFloat32;
}
BINARYEN_API BinaryenOp BinaryenConvertUInt32ToFloat64(void) {
  return ConvertUInt32ToFloat64;
}
BINARYEN_API BinaryenOp BinaryenConvertSInt64ToFloat32(void) {
  return ConvertSInt64ToFloat32;
}
BINARYEN_API BinaryenOp BinaryenConvertSInt64ToFloat64(void) {
  return ConvertSInt64ToFloat64;
}
BINARYEN_API BinaryenOp BinaryenConvertUInt64ToFloat32(void) {
  return ConvertUInt64ToFloat32;
}
BINARYEN_API BinaryenOp BinaryenConvertUInt64ToFloat64(void) {
  return ConvertUInt64ToFloat64;
}
BINARYEN_API BinaryenOp BinaryenPromoteFloat32(void) { return PromoteFloat32; }
BINARYEN_API BinaryenOp BinaryenDemoteFloat64(void) { return DemoteFloat64; }
BINARYEN_API BinaryenOp BinaryenReinterpretInt32(void) {
  return ReinterpretInt32;
}
BINARYEN_API BinaryenOp BinaryenReinterpretInt64(void) {
  return ReinterpretInt64;
}
BINARYEN_API BinaryenOp BinaryenAddInt32(void) { return AddInt32; }
BINARYEN_API BinaryenOp BinaryenSubInt32(void) { return SubInt32; }
BINARYEN_API BinaryenOp BinaryenMulInt32(void) { return MulInt32; }
BINARYEN_API BinaryenOp BinaryenDivSInt32(void) { return DivSInt32; }
BINARYEN_API BinaryenOp BinaryenDivUInt32(void) { return DivUInt32; }
BINARYEN_API BinaryenOp BinaryenRemSInt32(void) { return RemSInt32; }
BINARYEN_API BinaryenOp BinaryenRemUInt32(void) { return RemUInt32; }
BINARYEN_API BinaryenOp BinaryenAndInt32(void) { return AndInt32; }
BINARYEN_API BinaryenOp BinaryenOrInt32(void) { return OrInt32; }
BINARYEN_API BinaryenOp BinaryenXorInt32(void) { return XorInt32; }
BINARYEN_API BinaryenOp BinaryenShlInt32(void) { return ShlInt32; }
BINARYEN_API BinaryenOp BinaryenShrUInt32(void) { return ShrUInt32; }
BINARYEN_API BinaryenOp BinaryenShrSInt32(void) { return ShrSInt32; }
BINARYEN_API BinaryenOp BinaryenRotLInt32(void) { return RotLInt32; }
BINARYEN_API BinaryenOp BinaryenRotRInt32(void) { return RotRInt32; }
BINARYEN_API BinaryenOp BinaryenEqInt32(void) { return EqInt32; }
BINARYEN_API BinaryenOp BinaryenNeInt32(void) { return NeInt32; }
BINARYEN_API BinaryenOp BinaryenLtSInt32(void) { return LtSInt32; }
BINARYEN_API BinaryenOp BinaryenLtUInt32(void) { return LtUInt32; }
BINARYEN_API BinaryenOp BinaryenLeSInt32(void) { return LeSInt32; }
BINARYEN_API BinaryenOp BinaryenLeUInt32(void) { return LeUInt32; }
BINARYEN_API BinaryenOp BinaryenGtSInt32(void) { return GtSInt32; }
BINARYEN_API BinaryenOp BinaryenGtUInt32(void) { return GtUInt32; }
BINARYEN_API BinaryenOp BinaryenGeSInt32(void) { return GeSInt32; }
BINARYEN_API BinaryenOp BinaryenGeUInt32(void) { return GeUInt32; }
BINARYEN_API BinaryenOp BinaryenAddInt64(void) { return AddInt64; }
BINARYEN_API BinaryenOp BinaryenSubInt64(void) { return SubInt64; }
BINARYEN_API BinaryenOp BinaryenMulInt64(void) { return MulInt64; }
BINARYEN_API BinaryenOp BinaryenDivSInt64(void) { return DivSInt64; }
BINARYEN_API BinaryenOp BinaryenDivUInt64(void) { return DivUInt64; }
BINARYEN_API BinaryenOp BinaryenRemSInt64(void) { return RemSInt64; }
BINARYEN_API BinaryenOp BinaryenRemUInt64(void) { return RemUInt64; }
BINARYEN_API BinaryenOp BinaryenAndInt64(void) { return AndInt64; }
BINARYEN_API BinaryenOp BinaryenOrInt64(void) { return OrInt64; }
BINARYEN_API BinaryenOp BinaryenXorInt64(void) { return XorInt64; }
BINARYEN_API BinaryenOp BinaryenShlInt64(void) { return ShlInt64; }
BINARYEN_API BinaryenOp BinaryenShrUInt64(void) { return ShrUInt64; }
BINARYEN_API BinaryenOp BinaryenShrSInt64(void) { return ShrSInt64; }
BINARYEN_API BinaryenOp BinaryenRotLInt64(void) { return RotLInt64; }
BINARYEN_API BinaryenOp BinaryenRotRInt64(void) { return RotRInt64; }
BINARYEN_API BinaryenOp BinaryenEqInt64(void) { return EqInt64; }
BINARYEN_API BinaryenOp BinaryenNeInt64(void) { return NeInt64; }
BINARYEN_API BinaryenOp BinaryenLtSInt64(void) { return LtSInt64; }
BINARYEN_API BinaryenOp BinaryenLtUInt64(void) { return LtUInt64; }
BINARYEN_API BinaryenOp BinaryenLeSInt64(void) { return LeSInt64; }
BINARYEN_API BinaryenOp BinaryenLeUInt64(void) { return LeUInt64; }
BINARYEN_API BinaryenOp BinaryenGtSInt64(void) { return GtSInt64; }
BINARYEN_API BinaryenOp BinaryenGtUInt64(void) { return GtUInt64; }
BINARYEN_API BinaryenOp BinaryenGeSInt64(void) { return GeSInt64; }
BINARYEN_API BinaryenOp BinaryenGeUInt64(void) { return GeUInt64; }
BINARYEN_API BinaryenOp BinaryenAddFloat32(void) { return AddFloat32; }
BINARYEN_API BinaryenOp BinaryenSubFloat32(void) { return SubFloat32; }
BINARYEN_API BinaryenOp BinaryenMulFloat32(void) { return MulFloat32; }
BINARYEN_API BinaryenOp BinaryenDivFloat32(void) { return DivFloat32; }
BINARYEN_API BinaryenOp BinaryenCopySignFloat32(void) {
  return CopySignFloat32;
}
BINARYEN_API BinaryenOp BinaryenMinFloat32(void) { return MinFloat32; }
BINARYEN_API BinaryenOp BinaryenMaxFloat32(void) { return MaxFloat32; }
BINARYEN_API BinaryenOp BinaryenEqFloat32(void) { return EqFloat32; }
BINARYEN_API BinaryenOp BinaryenNeFloat32(void) { return NeFloat32; }
BINARYEN_API BinaryenOp BinaryenLtFloat32(void) { return LtFloat32; }
BINARYEN_API BinaryenOp BinaryenLeFloat32(void) { return LeFloat32; }
BINARYEN_API BinaryenOp BinaryenGtFloat32(void) { return GtFloat32; }
BINARYEN_API BinaryenOp BinaryenGeFloat32(void) { return GeFloat32; }
BINARYEN_API BinaryenOp BinaryenAddFloat64(void) { return AddFloat64; }
BINARYEN_API BinaryenOp BinaryenSubFloat64(void) { return SubFloat64; }
BINARYEN_API BinaryenOp BinaryenMulFloat64(void) { return MulFloat64; }
BINARYEN_API BinaryenOp BinaryenDivFloat64(void) { return DivFloat64; }
BINARYEN_API BinaryenOp BinaryenCopySignFloat64(void) {
  return CopySignFloat64;
}
BINARYEN_API BinaryenOp BinaryenMinFloat64(void) { return MinFloat64; }
BINARYEN_API BinaryenOp BinaryenMaxFloat64(void) { return MaxFloat64; }
BINARYEN_API BinaryenOp BinaryenEqFloat64(void) { return EqFloat64; }
BINARYEN_API BinaryenOp BinaryenNeFloat64(void) { return NeFloat64; }
BINARYEN_API BinaryenOp BinaryenLtFloat64(void) { return LtFloat64; }
BINARYEN_API BinaryenOp BinaryenLeFloat64(void) { return LeFloat64; }
BINARYEN_API BinaryenOp BinaryenGtFloat64(void) { return GtFloat64; }
BINARYEN_API BinaryenOp BinaryenGeFloat64(void) { return GeFloat64; }
BINARYEN_API BinaryenOp BinaryenMemorySize(void) { return MemorySize; }
BINARYEN_API BinaryenOp BinaryenMemoryGrow(void) { return MemoryGrow; }
BINARYEN_API BinaryenOp BinaryenAtomicRMWAdd(void) { return AtomicRMWOp::Add; }
BINARYEN_API BinaryenOp BinaryenAtomicRMWSub(void) { return AtomicRMWOp::Sub; }
BINARYEN_API BinaryenOp BinaryenAtomicRMWAnd(void) { return AtomicRMWOp::And; }
BINARYEN_API BinaryenOp BinaryenAtomicRMWOr(void) { return AtomicRMWOp::Or; }
BINARYEN_API BinaryenOp BinaryenAtomicRMWXor(void) { return AtomicRMWOp::Xor; }
BINARYEN_API BinaryenOp BinaryenAtomicRMWXchg(void) {
  return AtomicRMWOp::Xchg;
}
BINARYEN_API BinaryenOp BinaryenTruncSatSFloat32ToInt32(void) {
  return TruncSatSFloat32ToInt32;
}
BINARYEN_API BinaryenOp BinaryenTruncSatSFloat32ToInt64(void) {
  return TruncSatSFloat32ToInt64;
}
BINARYEN_API BinaryenOp BinaryenTruncSatUFloat32ToInt32(void) {
  return TruncSatUFloat32ToInt32;
}
BINARYEN_API BinaryenOp BinaryenTruncSatUFloat32ToInt64(void) {
  return TruncSatUFloat32ToInt64;
}
BINARYEN_API BinaryenOp BinaryenTruncSatSFloat64ToInt32(void) {
  return TruncSatSFloat64ToInt32;
}
BINARYEN_API BinaryenOp BinaryenTruncSatSFloat64ToInt64(void) {
  return TruncSatSFloat64ToInt64;
}
BINARYEN_API BinaryenOp BinaryenTruncSatUFloat64ToInt32(void) {
  return TruncSatUFloat64ToInt32;
}
BINARYEN_API BinaryenOp BinaryenTruncSatUFloat64ToInt64(void) {
  return TruncSatUFloat64ToInt64;
}
BINARYEN_API BinaryenOp BinaryenSplatVecI8x16(void) { return SplatVecI8x16; }
BINARYEN_API BinaryenOp BinaryenExtractLaneSVecI8x16(void) {
  return ExtractLaneSVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenExtractLaneUVecI8x16(void) {
  return ExtractLaneUVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecI8x16(void) {
  return ReplaceLaneVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenSplatVecI16x8(void) { return SplatVecI16x8; }
BINARYEN_API BinaryenOp BinaryenExtractLaneSVecI16x8(void) {
  return ExtractLaneSVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenExtractLaneUVecI16x8(void) {
  return ExtractLaneUVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecI16x8(void) {
  return ReplaceLaneVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenSplatVecI32x4(void) { return SplatVecI32x4; }
BINARYEN_API BinaryenOp BinaryenExtractLaneVecI32x4(void) {
  return ExtractLaneVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecI32x4(void) {
  return ReplaceLaneVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenSplatVecI64x2(void) { return SplatVecI64x2; }
BINARYEN_API BinaryenOp BinaryenExtractLaneVecI64x2(void) {
  return ExtractLaneVecI64x2;
}
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecI64x2(void) {
  return ReplaceLaneVecI64x2;
}
BINARYEN_API BinaryenOp BinaryenSplatVecF32x4(void) { return SplatVecF32x4; }
BINARYEN_API BinaryenOp BinaryenExtractLaneVecF32x4(void) {
  return ExtractLaneVecF32x4;
}
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecF32x4(void) {
  return ReplaceLaneVecF32x4;
}
BINARYEN_API BinaryenOp BinaryenSplatVecF64x2(void) { return SplatVecF64x2; }
BINARYEN_API BinaryenOp BinaryenExtractLaneVecF64x2(void) {
  return ExtractLaneVecF64x2;
}
BINARYEN_API BinaryenOp BinaryenReplaceLaneVecF64x2(void) {
  return ReplaceLaneVecF64x2;
}
BINARYEN_API BinaryenOp BinaryenEqVecI8x16(void) { return EqVecI8x16; }
BINARYEN_API BinaryenOp BinaryenNeVecI8x16(void) { return NeVecI8x16; }
BINARYEN_API BinaryenOp BinaryenLtSVecI8x16(void) { return LtSVecI8x16; }
BINARYEN_API BinaryenOp BinaryenLtUVecI8x16(void) { return LtUVecI8x16; }
BINARYEN_API BinaryenOp BinaryenGtSVecI8x16(void) { return GtSVecI8x16; }
BINARYEN_API BinaryenOp BinaryenGtUVecI8x16(void) { return GtUVecI8x16; }
BINARYEN_API BinaryenOp BinaryenLeSVecI8x16(void) { return LeSVecI8x16; }
BINARYEN_API BinaryenOp BinaryenLeUVecI8x16(void) { return LeUVecI8x16; }
BINARYEN_API BinaryenOp BinaryenGeSVecI8x16(void) { return GeSVecI8x16; }
BINARYEN_API BinaryenOp BinaryenGeUVecI8x16(void) { return GeUVecI8x16; }
BINARYEN_API BinaryenOp BinaryenEqVecI16x8(void) { return EqVecI16x8; }
BINARYEN_API BinaryenOp BinaryenNeVecI16x8(void) { return NeVecI16x8; }
BINARYEN_API BinaryenOp BinaryenLtSVecI16x8(void) { return LtSVecI16x8; }
BINARYEN_API BinaryenOp BinaryenLtUVecI16x8(void) { return LtUVecI16x8; }
BINARYEN_API BinaryenOp BinaryenGtSVecI16x8(void) { return GtSVecI16x8; }
BINARYEN_API BinaryenOp BinaryenGtUVecI16x8(void) { return GtUVecI16x8; }
BINARYEN_API BinaryenOp BinaryenLeSVecI16x8(void) { return LeSVecI16x8; }
BINARYEN_API BinaryenOp BinaryenLeUVecI16x8(void) { return LeUVecI16x8; }
BINARYEN_API BinaryenOp BinaryenGeSVecI16x8(void) { return GeSVecI16x8; }
BINARYEN_API BinaryenOp BinaryenGeUVecI16x8(void) { return GeUVecI16x8; }
BINARYEN_API BinaryenOp BinaryenEqVecI32x4(void) { return EqVecI32x4; }
BINARYEN_API BinaryenOp BinaryenNeVecI32x4(void) { return NeVecI32x4; }
BINARYEN_API BinaryenOp BinaryenLtSVecI32x4(void) { return LtSVecI32x4; }
BINARYEN_API BinaryenOp BinaryenLtUVecI32x4(void) { return LtUVecI32x4; }
BINARYEN_API BinaryenOp BinaryenGtSVecI32x4(void) { return GtSVecI32x4; }
BINARYEN_API BinaryenOp BinaryenGtUVecI32x4(void) { return GtUVecI32x4; }
BINARYEN_API BinaryenOp BinaryenLeSVecI32x4(void) { return LeSVecI32x4; }
BINARYEN_API BinaryenOp BinaryenLeUVecI32x4(void) { return LeUVecI32x4; }
BINARYEN_API BinaryenOp BinaryenGeSVecI32x4(void) { return GeSVecI32x4; }
BINARYEN_API BinaryenOp BinaryenGeUVecI32x4(void) { return GeUVecI32x4; }
BINARYEN_API BinaryenOp BinaryenEqVecF32x4(void) { return EqVecF32x4; }
BINARYEN_API BinaryenOp BinaryenNeVecF32x4(void) { return NeVecF32x4; }
BINARYEN_API BinaryenOp BinaryenLtVecF32x4(void) { return LtVecF32x4; }
BINARYEN_API BinaryenOp BinaryenGtVecF32x4(void) { return GtVecF32x4; }
BINARYEN_API BinaryenOp BinaryenLeVecF32x4(void) { return LeVecF32x4; }
BINARYEN_API BinaryenOp BinaryenGeVecF32x4(void) { return GeVecF32x4; }
BINARYEN_API BinaryenOp BinaryenEqVecF64x2(void) { return EqVecF64x2; }
BINARYEN_API BinaryenOp BinaryenNeVecF64x2(void) { return NeVecF64x2; }
BINARYEN_API BinaryenOp BinaryenLtVecF64x2(void) { return LtVecF64x2; }
BINARYEN_API BinaryenOp BinaryenGtVecF64x2(void) { return GtVecF64x2; }
BINARYEN_API BinaryenOp BinaryenLeVecF64x2(void) { return LeVecF64x2; }
BINARYEN_API BinaryenOp BinaryenGeVecF64x2(void) { return GeVecF64x2; }
BINARYEN_API BinaryenOp BinaryenNotVec128(void) { return NotVec128; }
BINARYEN_API BinaryenOp BinaryenAndVec128(void) { return AndVec128; }
BINARYEN_API BinaryenOp BinaryenOrVec128(void) { return OrVec128; }
BINARYEN_API BinaryenOp BinaryenXorVec128(void) { return XorVec128; }
BINARYEN_API BinaryenOp BinaryenBitselectVec128(void) { return Bitselect; }
BINARYEN_API BinaryenOp BinaryenNegVecI8x16(void) { return NegVecI8x16; }
BINARYEN_API BinaryenOp BinaryenAnyTrueVecI8x16(void) {
  return AnyTrueVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenAllTrueVecI8x16(void) {
  return AllTrueVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenShlVecI8x16(void) { return ShlVecI8x16; }
BINARYEN_API BinaryenOp BinaryenShrSVecI8x16(void) { return ShrSVecI8x16; }
BINARYEN_API BinaryenOp BinaryenShrUVecI8x16(void) { return ShrUVecI8x16; }
BINARYEN_API BinaryenOp BinaryenAddVecI8x16(void) { return AddVecI8x16; }
BINARYEN_API BinaryenOp BinaryenAddSatSVecI8x16(void) {
  return AddSatSVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenAddSatUVecI8x16(void) {
  return AddSatUVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenSubVecI8x16(void) { return SubVecI8x16; }
BINARYEN_API BinaryenOp BinaryenSubSatSVecI8x16(void) {
  return SubSatSVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenSubSatUVecI8x16(void) {
  return SubSatUVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenMulVecI8x16(void) { return MulVecI8x16; }
BINARYEN_API BinaryenOp BinaryenNegVecI16x8(void) { return NegVecI16x8; }
BINARYEN_API BinaryenOp BinaryenAnyTrueVecI16x8(void) {
  return AnyTrueVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenAllTrueVecI16x8(void) {
  return AllTrueVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenShlVecI16x8(void) { return ShlVecI16x8; }
BINARYEN_API BinaryenOp BinaryenShrSVecI16x8(void) { return ShrSVecI16x8; }
BINARYEN_API BinaryenOp BinaryenShrUVecI16x8(void) { return ShrUVecI16x8; }
BINARYEN_API BinaryenOp BinaryenAddVecI16x8(void) { return AddVecI16x8; }
BINARYEN_API BinaryenOp BinaryenAddSatSVecI16x8(void) {
  return AddSatSVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenAddSatUVecI16x8(void) {
  return AddSatUVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenSubVecI16x8(void) { return SubVecI16x8; }
BINARYEN_API BinaryenOp BinaryenSubSatSVecI16x8(void) {
  return SubSatSVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenSubSatUVecI16x8(void) {
  return SubSatUVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenMulVecI16x8(void) { return MulVecI16x8; }
BINARYEN_API BinaryenOp BinaryenNegVecI32x4(void) { return NegVecI32x4; }
BINARYEN_API BinaryenOp BinaryenAnyTrueVecI32x4(void) {
  return AnyTrueVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenAllTrueVecI32x4(void) {
  return AllTrueVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenShlVecI32x4(void) { return ShlVecI32x4; }
BINARYEN_API BinaryenOp BinaryenShrSVecI32x4(void) { return ShrSVecI32x4; }
BINARYEN_API BinaryenOp BinaryenShrUVecI32x4(void) { return ShrUVecI32x4; }
BINARYEN_API BinaryenOp BinaryenAddVecI32x4(void) { return AddVecI32x4; }
BINARYEN_API BinaryenOp BinaryenSubVecI32x4(void) { return SubVecI32x4; }
BINARYEN_API BinaryenOp BinaryenMulVecI32x4(void) { return MulVecI32x4; }
BINARYEN_API BinaryenOp BinaryenNegVecI64x2(void) { return NegVecI64x2; }
BINARYEN_API BinaryenOp BinaryenAnyTrueVecI64x2(void) {
  return AnyTrueVecI64x2;
}
BINARYEN_API BinaryenOp BinaryenAllTrueVecI64x2(void) {
  return AllTrueVecI64x2;
}
BINARYEN_API BinaryenOp BinaryenShlVecI64x2(void) { return ShlVecI64x2; }
BINARYEN_API BinaryenOp BinaryenShrSVecI64x2(void) { return ShrSVecI64x2; }
BINARYEN_API BinaryenOp BinaryenShrUVecI64x2(void) { return ShrUVecI64x2; }
BINARYEN_API BinaryenOp BinaryenAddVecI64x2(void) { return AddVecI64x2; }
BINARYEN_API BinaryenOp BinaryenSubVecI64x2(void) { return SubVecI64x2; }
BINARYEN_API BinaryenOp BinaryenAbsVecF32x4(void) { return AbsVecF32x4; }
BINARYEN_API BinaryenOp BinaryenNegVecF32x4(void) { return NegVecF32x4; }
BINARYEN_API BinaryenOp BinaryenSqrtVecF32x4(void) { return SqrtVecF32x4; }
BINARYEN_API BinaryenOp BinaryenQFMAVecF32x4(void) { return QFMAF32x4; }
BINARYEN_API BinaryenOp BinaryenQFMSVecF32x4(void) { return QFMSF32x4; }
BINARYEN_API BinaryenOp BinaryenAddVecF32x4(void) { return AddVecF32x4; }
BINARYEN_API BinaryenOp BinaryenSubVecF32x4(void) { return SubVecF32x4; }
BINARYEN_API BinaryenOp BinaryenMulVecF32x4(void) { return MulVecF32x4; }
BINARYEN_API BinaryenOp BinaryenDivVecF32x4(void) { return DivVecF32x4; }
BINARYEN_API BinaryenOp BinaryenMinVecF32x4(void) { return MinVecF32x4; }
BINARYEN_API BinaryenOp BinaryenMaxVecF32x4(void) { return MaxVecF32x4; }
BINARYEN_API BinaryenOp BinaryenAbsVecF64x2(void) { return AbsVecF64x2; }
BINARYEN_API BinaryenOp BinaryenNegVecF64x2(void) { return NegVecF64x2; }
BINARYEN_API BinaryenOp BinaryenSqrtVecF64x2(void) { return SqrtVecF64x2; }
BINARYEN_API BinaryenOp BinaryenQFMAVecF64x2(void) { return QFMAF64x2; }
BINARYEN_API BinaryenOp BinaryenQFMSVecF64x2(void) { return QFMSF64x2; }
BINARYEN_API BinaryenOp BinaryenAddVecF64x2(void) { return AddVecF64x2; }
BINARYEN_API BinaryenOp BinaryenSubVecF64x2(void) { return SubVecF64x2; }
BINARYEN_API BinaryenOp BinaryenMulVecF64x2(void) { return MulVecF64x2; }
BINARYEN_API BinaryenOp BinaryenDivVecF64x2(void) { return DivVecF64x2; }
BINARYEN_API BinaryenOp BinaryenMinVecF64x2(void) { return MinVecF64x2; }
BINARYEN_API BinaryenOp BinaryenMaxVecF64x2(void) { return MaxVecF64x2; }
BINARYEN_API BinaryenOp BinaryenTruncSatSVecF32x4ToVecI32x4(void) {
  return TruncSatSVecF32x4ToVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenTruncSatUVecF32x4ToVecI32x4(void) {
  return TruncSatUVecF32x4ToVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenTruncSatSVecF64x2ToVecI64x2(void) {
  return TruncSatSVecF64x2ToVecI64x2;
}
BINARYEN_API BinaryenOp BinaryenTruncSatUVecF64x2ToVecI64x2(void) {
  return TruncSatUVecF64x2ToVecI64x2;
}
BINARYEN_API BinaryenOp BinaryenConvertSVecI32x4ToVecF32x4(void) {
  return ConvertSVecI32x4ToVecF32x4;
}
BINARYEN_API BinaryenOp BinaryenConvertUVecI32x4ToVecF32x4(void) {
  return ConvertUVecI32x4ToVecF32x4;
}
BINARYEN_API BinaryenOp BinaryenConvertSVecI64x2ToVecF64x2(void) {
  return ConvertSVecI64x2ToVecF64x2;
}
BINARYEN_API BinaryenOp BinaryenConvertUVecI64x2ToVecF64x2(void) {
  return ConvertUVecI64x2ToVecF64x2;
}
BINARYEN_API BinaryenOp BinaryenNarrowSVecI16x8ToVecI8x16(void) {
  return NarrowSVecI16x8ToVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenNarrowUVecI16x8ToVecI8x16(void) {
  return NarrowUVecI16x8ToVecI8x16;
}
BINARYEN_API BinaryenOp BinaryenNarrowSVecI32x4ToVecI16x8(void) {
  return NarrowSVecI32x4ToVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenNarrowUVecI32x4ToVecI16x8(void) {
  return NarrowUVecI32x4ToVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenWidenLowSVecI8x16ToVecI16x8(void) {
  return WidenLowSVecI8x16ToVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenWidenHighSVecI8x16ToVecI16x8(void) {
  return WidenHighSVecI8x16ToVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenWidenLowUVecI8x16ToVecI16x8(void) {
  return WidenLowUVecI8x16ToVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenWidenHighUVecI8x16ToVecI16x8(void) {
  return WidenHighUVecI8x16ToVecI16x8;
}
BINARYEN_API BinaryenOp BinaryenWidenLowSVecI16x8ToVecI32x4(void) {
  return WidenLowSVecI16x8ToVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenWidenHighSVecI16x8ToVecI32x4(void) {
  return WidenHighSVecI16x8ToVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenWidenLowUVecI16x8ToVecI32x4(void) {
  return WidenLowUVecI16x8ToVecI32x4;
}
BINARYEN_API BinaryenOp BinaryenWidenHighUVecI16x8ToVecI32x4(void) {
  return WidenHighUVecI16x8ToVecI32x4;
}

BINARYEN_API BinaryenExpressionRef
BinaryenBlock(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenIf(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenLoop(BinaryenModuleRef module,
                                                const char* name,
                                                BinaryenExpressionRef body) {
  auto* ret = Builder(*(Module*)module)
                .makeLoop(name ? Name(name) : Name(), (Expression*)body);

  if (tracing) {
    traceExpression(ret, "BinaryenLoop", StringLit(name), body);
  }

  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef
BinaryenBreak(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenSwitch(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenCall(BinaryenModuleRef module,
                                                const char* target,
                                                BinaryenExpressionRef* operands,
                                                BinaryenIndex numOperands,
                                                BinaryenType returnType) {
  return makeBinaryenCall(
    module, target, operands, numOperands, returnType, false);
}
BINARYEN_API BinaryenExpressionRef
BinaryenReturnCall(BinaryenModuleRef module,
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
                         const char* type,
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
      StringLit(type));
    std::cout << "  }\n";
  }

  ret->target = (Expression*)target;
  for (BinaryenIndex i = 0; i < numOperands; i++) {
    ret->operands.push_back((Expression*)operands[i]);
  }
  ret->fullType = type;
  ret->type = wasm->getFunctionType(ret->fullType)->result;
  ret->isReturn = isReturn;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef
BinaryenCallIndirect(BinaryenModuleRef module,
                     BinaryenExpressionRef target,
                     BinaryenExpressionRef* operands,
                     BinaryenIndex numOperands,
                     const char* type) {
  return makeBinaryenCallIndirect(
    module, target, operands, numOperands, type, false);
}
BINARYEN_API BinaryenExpressionRef
BinaryenReturnCallIndirect(BinaryenModuleRef module,
                           BinaryenExpressionRef target,
                           BinaryenExpressionRef* operands,
                           BinaryenIndex numOperands,
                           const char* type) {
  return makeBinaryenCallIndirect(
    module, target, operands, numOperands, type, true);
}
BINARYEN_API BinaryenExpressionRef BinaryenLocalGet(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenLocalSet(
  BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<LocalSet>();

  if (tracing) {
    traceExpression(ret, "BinaryenLocalSet", index, value);
  }

  ret->index = index;
  ret->value = (Expression*)value;
  ret->setTee(false);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenLocalTee(
  BinaryenModuleRef module, BinaryenIndex index, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<LocalSet>();

  if (tracing) {
    traceExpression(ret, "BinaryenLocalTee", index, value);
  }

  ret->index = index;
  ret->value = (Expression*)value;
  ret->setTee(true);
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenGlobalGet(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenGlobalSet(
  BinaryenModuleRef module, const char* name, BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<GlobalSet>();

  if (tracing) {
    traceExpression(ret, "BinaryenGlobalSet", StringLit(name), value);
  }

  ret->name = name;
  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenLoad(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenStore(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenConst(BinaryenModuleRef module,
                                                 BinaryenLiteral value) {
  auto* ret = Builder(*(Module*)module).makeConst(fromBinaryenLiteral(value));
  if (tracing) {
    traceExpression(ret, "BinaryenConst", value);
  }
  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenUnary(BinaryenModuleRef module,
                                                 BinaryenOp op,
                                                 BinaryenExpressionRef value) {
  auto* ret =
    Builder(*(Module*)module).makeUnary(UnaryOp(op), (Expression*)value);

  if (tracing) {
    traceExpression(ret, "BinaryenUnary", op, value);
  }

  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenBinary(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenSelect(BinaryenModuleRef module,
               BinaryenExpressionRef condition,
               BinaryenExpressionRef ifTrue,
               BinaryenExpressionRef ifFalse) {
  auto* ret = ((Module*)module)->allocator.alloc<Select>();

  if (tracing) {
    traceExpression(ret, "BinaryenSelect", condition, ifTrue, ifFalse);
  }

  ret->condition = (Expression*)condition;
  ret->ifTrue = (Expression*)ifTrue;
  ret->ifFalse = (Expression*)ifFalse;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenDrop(BinaryenModuleRef module,
                                                BinaryenExpressionRef value) {
  auto* ret = ((Module*)module)->allocator.alloc<Drop>();

  if (tracing) {
    traceExpression(ret, "BinaryenDrop", value);
  }

  ret->value = (Expression*)value;
  ret->finalize();
  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenReturn(BinaryenModuleRef module,
                                                  BinaryenExpressionRef value) {
  auto* ret = Builder(*(Module*)module).makeReturn((Expression*)value);

  if (tracing) {
    traceExpression(ret, "BinaryenReturn", value);
  }

  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenHost(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenNop(BinaryenModuleRef module) {
  auto* ret = ((Module*)module)->allocator.alloc<Nop>();

  if (tracing) {
    traceExpression(ret, "BinaryenNop");
  }

  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef
BinaryenUnreachable(BinaryenModuleRef module) {
  auto* ret = ((Module*)module)->allocator.alloc<Unreachable>();

  if (tracing) {
    traceExpression(ret, "BinaryenUnreachable");
  }

  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicLoad(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicStore(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicRMW(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicCmpxchg(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicWait(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicNotify(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicFence(BinaryenModuleRef module) {
  auto* ret = Builder(*(Module*)module).makeAtomicFence();

  if (tracing) {
    traceExpression(ret, "BinaryenAtomicFence");
  }

  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDExtract(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDReplace(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShuffle(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDTernary(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShift(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryInit(BinaryenModuleRef module,
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

BINARYEN_API BinaryenExpressionRef BinaryenDataDrop(BinaryenModuleRef module,
                                                    uint32_t segment) {
  auto* ret = Builder(*(Module*)module).makeDataDrop(segment);
  if (tracing) {
    traceExpression(ret, "BinaryenDataDrop", segment);
  }
  return static_cast<Expression*>(ret);
}

BINARYEN_API BinaryenExpressionRef
BinaryenMemoryCopy(BinaryenModuleRef module,
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

BINARYEN_API BinaryenExpressionRef
BinaryenMemoryFill(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExpressionRef BinaryenPush(BinaryenModuleRef module,
                                                BinaryenExpressionRef value) {
  auto* ret = Builder(*(Module*)module).makePush((Expression*)value);
  if (tracing) {
    traceExpression(ret, "BinaryenPush", value);
  }
  return static_cast<Expression*>(ret);
}
BINARYEN_API BinaryenExpressionRef BinaryenPop(BinaryenModuleRef module,
                                               BinaryenType type) {
  auto* ret = Builder(*(Module*)module).makePop(Type(type));
  if (tracing) {
    traceExpression(ret, "BinaryenPop", type);
  }
  return static_cast<Expression*>(ret);
}

BINARYEN_API BinaryenExpressionRef
BinaryenTry(BinaryenModuleRef module,
            BinaryenExpressionRef body,
            BinaryenExpressionRef catchBody) {
  auto* ret = Builder(*(Module*)module)
                .makeTry((Expression*)body, (Expression*)catchBody);
  if (tracing) {
    traceExpression(ret, "BinaryenTry", body, catchBody);
  }
  return static_cast<Expression*>(ret);
}

BINARYEN_API BinaryenExpressionRef
BinaryenThrow(BinaryenModuleRef module,
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

BINARYEN_API BinaryenExpressionRef
BinaryenRethrow(BinaryenModuleRef module, BinaryenExpressionRef exnref) {
  auto* ret = Builder(*(Module*)module).makeRethrow((Expression*)exnref);
  if (tracing) {
    traceExpression(ret, "BinaryenRethrow", exnref);
  }
  return static_cast<Expression*>(ret);
}

BINARYEN_API BinaryenExpressionRef
BinaryenBrOnExn(BinaryenModuleRef module,
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

BINARYEN_API BinaryenExpressionId
BinaryenExpressionGetId(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionGetId(expressions[" << expressions[expr]
              << "]);\n";
  }

  return ((Expression*)expr)->_id;
}
BINARYEN_API BinaryenType
BinaryenExpressionGetType(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionGetType(expressions[" << expressions[expr]
              << "]);\n";
  }

  return ((Expression*)expr)->type;
}
BINARYEN_API void BinaryenExpressionPrint(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenExpressionPrint(expressions[" << expressions[expr]
              << "]);\n";
  }

  WasmPrinter::printExpression((Expression*)expr, std::cout);
  std::cout << '\n';
}

// Specific expression utility

// Block
BINARYEN_API const char* BinaryenBlockGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBlockGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->name.c_str();
}
BINARYEN_API BinaryenIndex
BinaryenBlockGetNumChildren(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBlockGetNumChildren(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Block>());
  return static_cast<Block*>(expression)->list.size();
}
BINARYEN_API BinaryenExpressionRef
BinaryenBlockGetChild(BinaryenExpressionRef expr, BinaryenIndex index) {
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
BINARYEN_API BinaryenExpressionRef
BinaryenIfGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetCondition(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->condition;
}
BINARYEN_API BinaryenExpressionRef
BinaryenIfGetIfTrue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetIfTrue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->ifTrue;
}
BINARYEN_API BinaryenExpressionRef
BinaryenIfGetIfFalse(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenIfGetIfFalse(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<If>());
  return static_cast<If*>(expression)->ifFalse;
}
// Loop
BINARYEN_API const char* BinaryenLoopGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoopGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  return static_cast<Loop*>(expression)->name.c_str();
}
BINARYEN_API BinaryenExpressionRef
BinaryenLoopGetBody(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoopGetBody(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Loop>());
  return static_cast<Loop*>(expression)->body;
}
// Break
BINARYEN_API const char* BinaryenBreakGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->name.c_str();
}
BINARYEN_API BinaryenExpressionRef
BinaryenBreakGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetCondition(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->condition;
}
BINARYEN_API BinaryenExpressionRef
BinaryenBreakGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBreakGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Break>());
  return static_cast<Break*>(expression)->value;
}
// Switch
BINARYEN_API BinaryenIndex
BinaryenSwitchGetNumNames(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetNumNames(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->targets.size();
}
BINARYEN_API const char* BinaryenSwitchGetName(BinaryenExpressionRef expr,
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
BINARYEN_API const char*
BinaryenSwitchGetDefaultName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetDefaultName(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->default_.c_str();
}
BINARYEN_API BinaryenExpressionRef
BinaryenSwitchGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetCondition(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->condition;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSwitchGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSwitchGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Switch>());
  return static_cast<Switch*>(expression)->value;
}
// Call
BINARYEN_API const char* BinaryenCallGetTarget(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallGetTarget(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->target.c_str();
}
BINARYEN_API BinaryenIndex
BinaryenCallGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallGetNumOperands(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  return static_cast<Call*>(expression)->operands.size();
}
BINARYEN_API BinaryenExpressionRef
BinaryenCallGetOperand(BinaryenExpressionRef expr, BinaryenIndex index) {
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
BINARYEN_API BinaryenExpressionRef
BinaryenCallIndirectGetTarget(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallIndirectGetTarget(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->target;
}
BINARYEN_API BinaryenIndex
BinaryenCallIndirectGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenCallIndirectGetNumOperands(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<CallIndirect>());
  return static_cast<CallIndirect*>(expression)->operands.size();
}
BINARYEN_API BinaryenExpressionRef BinaryenCallIndirectGetOperand(
  BinaryenExpressionRef expr, BinaryenIndex index) {
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
BINARYEN_API BinaryenIndex
BinaryenLocalGetGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLocalGetGetIndex(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<LocalGet>());
  return static_cast<LocalGet*>(expression)->index;
}
// LocalSet
BINARYEN_API int BinaryenLocalSetIsTee(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLocalSetIsTee(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->isTee();
}
BINARYEN_API BinaryenIndex
BinaryenLocalSetGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLocalSetGetIndex(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->index;
}
BINARYEN_API BinaryenExpressionRef
BinaryenLocalSetGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLocalSetGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<LocalSet>());
  return static_cast<LocalSet*>(expression)->value;
}
// GlobalGet
BINARYEN_API const char* BinaryenGlobalGetGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenGlobalGetGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalGet>());
  return static_cast<GlobalGet*>(expression)->name.c_str();
}
// GlobalSet
BINARYEN_API const char* BinaryenGlobalSetGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenGlobalSetGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalSet>());
  return static_cast<GlobalSet*>(expression)->name.c_str();
}
BINARYEN_API BinaryenExpressionRef
BinaryenGlobalSetGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenGlobalSetGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<GlobalSet>());
  return static_cast<GlobalSet*>(expression)->value;
}
// Host
BINARYEN_API BinaryenOp BinaryenHostGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->op;
}
BINARYEN_API const char*
BinaryenHostGetNameOperand(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetNameOperand(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->nameOperand.c_str();
}
BINARYEN_API BinaryenIndex
BinaryenHostGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenHostGetNumOperands(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Host>());
  return static_cast<Host*>(expression)->operands.size();
}
BINARYEN_API BinaryenExpressionRef
BinaryenHostGetOperand(BinaryenExpressionRef expr, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenHostGetOperand(expressions[" << expressions[expr]
              << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Call>());
  assert(index < static_cast<Host*>(expression)->operands.size());
  return static_cast<Host*>(expression)->operands[index];
}
// Load
BINARYEN_API int BinaryenLoadIsAtomic(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadIsAtomic(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->isAtomic;
}
BINARYEN_API int BinaryenLoadIsSigned(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadIsSigned(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->signed_;
}
BINARYEN_API uint32_t BinaryenLoadGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetBytes(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->bytes;
}
BINARYEN_API uint32_t BinaryenLoadGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetOffset(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->offset;
}
BINARYEN_API uint32_t BinaryenLoadGetAlign(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetAlign(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->align;
}
BINARYEN_API BinaryenExpressionRef
BinaryenLoadGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenLoadGetPtr(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Load>());
  return static_cast<Load*>(expression)->ptr;
}
// Store
BINARYEN_API int BinaryenStoreIsAtomic(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreIsAtomic(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->isAtomic;
}
BINARYEN_API uint32_t BinaryenStoreGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetBytes(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->bytes;
}
BINARYEN_API uint32_t BinaryenStoreGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetOffset(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->offset;
}
BINARYEN_API uint32_t BinaryenStoreGetAlign(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetAlign(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->align;
}
BINARYEN_API BinaryenExpressionRef
BinaryenStoreGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetPtr(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->ptr;
}
BINARYEN_API BinaryenExpressionRef
BinaryenStoreGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenStoreGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Store>());
  return static_cast<Store*>(expression)->value;
}
// Const
BINARYEN_API int32_t BinaryenConstGetValueI32(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI32(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.geti32();
}
BINARYEN_API int64_t BinaryenConstGetValueI64(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.geti64();
}
BINARYEN_API int32_t BinaryenConstGetValueI64Low(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64Low(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return (int32_t)(static_cast<Const*>(expression)->value.geti64() &
                   0xffffffff);
}
BINARYEN_API int32_t BinaryenConstGetValueI64High(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueI64High(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return (int32_t)(static_cast<Const*>(expression)->value.geti64() >> 32);
}
BINARYEN_API float BinaryenConstGetValueF32(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueF32(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.getf32();
}
BINARYEN_API double BinaryenConstGetValueF64(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueF64(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  return static_cast<Const*>(expression)->value.getf64();
}
BINARYEN_API void BinaryenConstGetValueV128(BinaryenExpressionRef expr,
                                            uint8_t* out) {
  if (tracing) {
    std::cout << "  BinaryenConstGetValueV128(expressions[" << expressions[expr]
              << "], " << out << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Const>());
  memcpy(out, static_cast<Const*>(expression)->value.getv128().data(), 16);
}
// Unary
BINARYEN_API BinaryenOp BinaryenUnaryGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenUnaryGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  return static_cast<Unary*>(expression)->op;
}
BINARYEN_API BinaryenExpressionRef
BinaryenUnaryGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenUnaryGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Unary>());
  return static_cast<Unary*>(expression)->value;
}
// Binary
BINARYEN_API BinaryenOp BinaryenBinaryGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->op;
}
BINARYEN_API BinaryenExpressionRef
BinaryenBinaryGetLeft(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetLeft(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->left;
}
BINARYEN_API BinaryenExpressionRef
BinaryenBinaryGetRight(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBinaryGetRight(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Binary>());
  return static_cast<Binary*>(expression)->right;
}
// Select
BINARYEN_API BinaryenExpressionRef
BinaryenSelectGetIfTrue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetIfTrue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->ifTrue;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSelectGetIfFalse(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetIfFalse(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->ifFalse;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSelectGetCondition(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSelectGetCondition(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Select>());
  return static_cast<Select*>(expression)->condition;
}
// Drop
BINARYEN_API BinaryenExpressionRef
BinaryenDropGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenDropGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Drop>());
  return static_cast<Drop*>(expression)->value;
}
// Return
BINARYEN_API BinaryenExpressionRef
BinaryenReturnGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenReturnGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Return>());
  return static_cast<Return*>(expression)->value;
}
// AtomicRMW
BINARYEN_API BinaryenOp BinaryenAtomicRMWGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->op;
}
BINARYEN_API uint32_t BinaryenAtomicRMWGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetBytes(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->bytes;
}
BINARYEN_API uint32_t BinaryenAtomicRMWGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetOffset(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->offset;
}
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicRMWGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetPtr(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->ptr;
}
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicRMWGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicRMWGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicRMW>());
  return static_cast<AtomicRMW*>(expression)->value;
}
// AtomicCmpxchg
BINARYEN_API uint32_t
BinaryenAtomicCmpxchgGetBytes(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetBytes(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->bytes;
}
BINARYEN_API uint32_t
BinaryenAtomicCmpxchgGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetOffset(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->offset;
}
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicCmpxchgGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetPtr(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->ptr;
}
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicCmpxchgGetExpected(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicCmpxchgGetExpected(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicCmpxchg>());
  return static_cast<AtomicCmpxchg*>(expression)->expected;
}
BINARYEN_API BinaryenExpressionRef
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
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicWaitGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetPtr(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->ptr;
}
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicWaitGetExpected(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetExpected(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->expected;
}
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicWaitGetTimeout(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetTimeout(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->timeout;
}
BINARYEN_API BinaryenType
BinaryenAtomicWaitGetExpectedType(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicWaitGetExpectedType(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicWait>());
  return static_cast<AtomicWait*>(expression)->expectedType;
}
// AtomicNotify
BINARYEN_API BinaryenExpressionRef
BinaryenAtomicNotifyGetPtr(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicNotifyGetPtr(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicNotify>());
  return static_cast<AtomicNotify*>(expression)->ptr;
}
BINARYEN_API BinaryenExpressionRef
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
BINARYEN_API uint8_t BinaryenAtomicFenceGetOrder(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenAtomicFenceGetOrder(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<AtomicFence>());
  return static_cast<AtomicFence*>(expression)->order;
}
// SIMDExtract
BINARYEN_API BinaryenOp BinaryenSIMDExtractGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDExtractGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->op;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDExtractGetVec(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDExtractGetVec(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->vec;
}
BINARYEN_API uint8_t BinaryenSIMDExtractGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDExtractGetIndex(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDExtract>());
  return static_cast<SIMDExtract*>(expression)->index;
}
// SIMDReplace
BINARYEN_API BinaryenOp BinaryenSIMDReplaceGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDReplaceGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->op;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDReplaceGetVec(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDReplaceGetVec(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->vec;
}
BINARYEN_API uint8_t BinaryenSIMDReplaceGetIndex(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDReplaceGetIndex(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->index;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDReplaceGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDReplaceGetValue(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDReplace>());
  return static_cast<SIMDReplace*>(expression)->value;
}
// SIMDShuffle
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShuffleGetLeft(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShuffleGetLeft(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  return static_cast<SIMDShuffle*>(expression)->left;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShuffleGetRight(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShuffleGetRight(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  return static_cast<SIMDShuffle*>(expression)->right;
}
BINARYEN_API void BinaryenSIMDShuffleGetMask(BinaryenExpressionRef expr,
                                             uint8_t* mask) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShuffleGetMask(expressions["
              << expressions[expr] << "], " << mask << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShuffle>());
  memcpy(mask, static_cast<SIMDShuffle*>(expression)->mask.data(), 16);
}
// SIMDTernary
BINARYEN_API BinaryenOp BinaryenSIMDTernaryGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDTernaryOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->op;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDTernaryGetA(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDTernaryGetA(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->a;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDTernaryGetB(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDTernaryGetB(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->b;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDTernaryGetC(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDTernaryGetC(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDTernary>());
  return static_cast<SIMDTernary*>(expression)->c;
}
// SIMDShift
BINARYEN_API BinaryenOp BinaryenSIMDShiftGetOp(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShiftGetOp(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->op;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShiftGetVec(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShiftGetVec(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->vec;
}
BINARYEN_API BinaryenExpressionRef
BinaryenSIMDShiftGetShift(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenSIMDShiftGetShift(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<SIMDShift>());
  return static_cast<SIMDShift*>(expression)->shift;
}
// MemoryInit
BINARYEN_API uint32_t BinaryenMemoryInitGetSegment(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryInitGetSegment(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->segment;
}
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryInitGetDest(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryInitGetDest(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->dest;
}
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryInitGetOffset(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryInitGetOffset(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->offset;
}
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryInitGetSize(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryInitGetSize(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryInit>());
  return static_cast<MemoryInit*>(expression)->size;
}
// DataDrop
BINARYEN_API uint32_t BinaryenDataDropGetSegment(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenDataDropGetSegment(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<DataDrop>());
  return static_cast<DataDrop*>(expression)->segment;
}
// MemoryCopy
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryCopyGetDest(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryCopyGetDest(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->dest;
}
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryCopyGetSource(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryCopyGetSource(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->source;
}
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryCopyGetSize(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryCopyGetSize(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryCopy>());
  return static_cast<MemoryCopy*>(expression)->size;
}
// MemoryFill
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryFillGetDest(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryFillGetDest(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->dest;
}
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryFillGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryFillGetValue(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->value;
}
BINARYEN_API BinaryenExpressionRef
BinaryenMemoryFillGetSize(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenMemoryFillGetSize(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<MemoryFill>());
  return static_cast<MemoryFill*>(expression)->size;
}
// Push
BINARYEN_API BinaryenExpressionRef
BinaryenPushGetValue(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenPushGetValue(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Push>());
  return static_cast<Push*>(expression)->value;
}
// Try
BINARYEN_API BinaryenExpressionRef
BinaryenTryGetBody(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenTryGetBody(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Try>());
  return static_cast<Try*>(expression)->body;
}
BINARYEN_API BinaryenExpressionRef
BinaryenTryGetCatchBody(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenTryGetCatchBody(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Try>());
  return static_cast<Try*>(expression)->catchBody;
}
// Throw
BINARYEN_API const char* BinaryenThrowGetEvent(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenThrowGetEvent(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  return static_cast<Throw*>(expression)->event.c_str();
}
BINARYEN_API BinaryenExpressionRef
BinaryenThrowGetOperand(BinaryenExpressionRef expr, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenThrowGetOperand(expressions[" << expressions[expr]
              << "], " << index << ");\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  assert(index < static_cast<Throw*>(expression)->operands.size());
  return static_cast<Throw*>(expression)->operands[index];
}
BINARYEN_API BinaryenIndex
BinaryenThrowGetNumOperands(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenThrowGetNumOperands(expressions["
              << expressions[expr] << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Throw>());
  return static_cast<Throw*>(expression)->operands.size();
}
// Rethrow
BINARYEN_API BinaryenExpressionRef
BinaryenRethrowGetExnref(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenRethrowGetExnref(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<Rethrow>());
  return static_cast<Rethrow*>(expression)->exnref;
}
// BrOnExn
BINARYEN_API const char* BinaryenBrOnExnGetEvent(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBrOnExnGetEvent(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->event.c_str();
}
BINARYEN_API const char* BinaryenBrOnExnGetName(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBrOnExnGetName(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->name.c_str();
}
BINARYEN_API BinaryenExpressionRef
BinaryenBrOnExnGetExnref(BinaryenExpressionRef expr) {
  if (tracing) {
    std::cout << "  BinaryenBrOnExnGetExnref(expressions[" << expressions[expr]
              << "]);\n";
  }

  auto* expression = (Expression*)expr;
  assert(expression->is<BrOnExn>());
  return static_cast<BrOnExn*>(expression)->exnref;
}

// Functions

BINARYEN_API BinaryenFunctionRef
BinaryenAddFunction(BinaryenModuleRef module,
                    const char* name,
                    BinaryenFunctionTypeRef type,
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
              << "] = BinaryenAddFunction(the_module, \"" << name
              << "\", functionTypes[" << functionTypes[type] << "], varTypes, "
              << numVarTypes << ", expressions[" << expressions[body]
              << "]);\n";
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
BINARYEN_API BinaryenFunctionRef BinaryenGetFunction(BinaryenModuleRef module,
                                                     const char* name) {
  if (tracing) {
    std::cout << "  BinaryenGetFunction(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  return wasm->getFunction(name);
}
BINARYEN_API void BinaryenRemoveFunction(BinaryenModuleRef module,
                                         const char* name) {
  if (tracing) {
    std::cout << "  BinaryenRemoveFunction(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeFunction(name);
}

// Globals

BINARYEN_API BinaryenGlobalRef BinaryenAddGlobal(BinaryenModuleRef module,
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
BINARYEN_API BinaryenGlobalRef BinaryenGetGlobal(BinaryenModuleRef module,
                                                 const char* name) {
  if (tracing) {
    std::cout << "  BinaryenGetGlobal(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  return wasm->getGlobal(name);
}
BINARYEN_API void BinaryenRemoveGlobal(BinaryenModuleRef module,
                                       const char* name) {
  if (tracing) {
    std::cout << "  BinaryenRemoveGlobal(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeGlobal(name);
}

// Events

BINARYEN_API BinaryenEventRef BinaryenAddEvent(BinaryenModuleRef module,
                                               const char* name,
                                               uint32_t attribute,
                                               BinaryenFunctionTypeRef type) {
  if (tracing) {
    std::cout << "  BinaryenAddEvent(the_module, \"" << name << "\", "
              << attribute << ", functionTypes[" << functionTypes[type]
              << "]);\n";
  }

  auto* wasm = (Module*)module;
  auto* ret = new Event();
  ret->name = name;
  ret->attribute = attribute;
  ret->type = ((FunctionType*)type)->name;
  ret->params = ((FunctionType*)type)->params;
  wasm->addEvent(ret);
  return ret;
}

BINARYEN_API BinaryenEventRef BinaryenGetEvent(BinaryenModuleRef module,
                                               const char* name) {
  if (tracing) {
    std::cout << "  BinaryenGetEvent(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  return wasm->getEvent(name);
}
BINARYEN_API void BinaryenRemoveEvent(BinaryenModuleRef module,
                                      const char* name) {
  if (tracing) {
    std::cout << "  BinaryenRemoveEvent(the_module, \"" << name << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeEvent(name);
}

// Imports

BINARYEN_API void
BinaryenAddFunctionImport(BinaryenModuleRef module,
                          const char* internalName,
                          const char* externalModuleName,
                          const char* externalBaseName,
                          BinaryenFunctionTypeRef functionType) {
  auto* wasm = (Module*)module;
  auto* ret = new Function();

  if (tracing) {
    std::cout << "  BinaryenAddFunctionImport(the_module, \"" << internalName
              << "\", \"" << externalModuleName << "\", \"" << externalBaseName
              << "\", functionTypes[" << functionTypes[functionType] << "]);\n";
  }

  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->type = ((FunctionType*)functionType)->name;
  FunctionTypeUtils::fillFunction(ret, (FunctionType*)functionType);
  wasm->addFunction(ret);
}
BINARYEN_API void BinaryenAddTableImport(BinaryenModuleRef module,
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
BINARYEN_API void BinaryenAddMemoryImport(BinaryenModuleRef module,
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
BINARYEN_API void BinaryenAddGlobalImport(BinaryenModuleRef module,
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
BINARYEN_API void BinaryenAddEventImport(BinaryenModuleRef module,
                                         const char* internalName,
                                         const char* externalModuleName,
                                         const char* externalBaseName,
                                         uint32_t attribute,
                                         BinaryenFunctionTypeRef eventType) {
  auto* wasm = (Module*)module;
  auto* ret = new Event();

  if (tracing) {
    std::cout << "  BinaryenAddEventImport(the_module, \"" << internalName
              << "\", \"" << externalModuleName << "\", \"" << externalBaseName
              << "\", " << attribute << ", functionTypes["
              << functionTypes[eventType] << "]);\n";
  }

  ret->name = internalName;
  ret->module = externalModuleName;
  ret->base = externalBaseName;
  ret->type = ((FunctionType*)eventType)->name;
  ret->params = ((FunctionType*)eventType)->params;
  wasm->addEvent(ret);
}

// Exports

WASM_DEPRECATED BinaryenExportRef BinaryenAddExport(BinaryenModuleRef module,
                                                    const char* internalName,
                                                    const char* externalName) {
  return BinaryenAddFunctionExport(module, internalName, externalName);
}
BINARYEN_API BinaryenExportRef
BinaryenAddFunctionExport(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExportRef
BinaryenAddTableExport(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExportRef
BinaryenAddMemoryExport(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExportRef
BinaryenAddGlobalExport(BinaryenModuleRef module,
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
BINARYEN_API BinaryenExportRef
BinaryenAddEventExport(BinaryenModuleRef module,
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
BINARYEN_API void BinaryenRemoveExport(BinaryenModuleRef module,
                                       const char* externalName) {
  if (tracing) {
    std::cout << "  BinaryenRemoveExport(the_module, \"" << externalName
              << "\");\n";
  }

  auto* wasm = (Module*)module;
  wasm->removeExport(externalName);
}

// Function table. One per module

BINARYEN_API void BinaryenSetFunctionTable(BinaryenModuleRef module,
                                           BinaryenIndex initial,
                                           BinaryenIndex maximum,
                                           const char** funcNames,
                                           BinaryenIndex numFuncNames) {
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
              << maximum << ", funcNames, " << numFuncNames << ");\n";
    std::cout << "  }\n";
  }

  auto* wasm = (Module*)module;
  Table::Segment segment(
    wasm->allocator.alloc<Const>()->set(Literal(int32_t(0))));
  for (BinaryenIndex i = 0; i < numFuncNames; i++) {
    segment.data.push_back(funcNames[i]);
  }
  wasm->table.initial = initial;
  wasm->table.max = maximum;
  wasm->table.exists = true;
  wasm->table.segments.push_back(segment);
}

// Memory. One per module

BINARYEN_API void BinaryenSetMemory(BinaryenModuleRef module,
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

// Start function. One per module

BINARYEN_API void BinaryenSetStart(BinaryenModuleRef module,
                                   BinaryenFunctionRef start) {
  if (tracing) {
    std::cout << "  BinaryenSetStart(the_module, functions[" << functions[start]
              << "]);\n";
  }

  auto* wasm = (Module*)module;
  wasm->addStart(((Function*)start)->name);
}

// Features

BINARYEN_API BinaryenFeatures
BinaryenModuleGetFeatures(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleGetFeatures(the_module);\n";
  }
  auto* wasm = static_cast<Module*>(module);
  return wasm->features.features;
}

BINARYEN_API void BinaryenModuleSetFeatures(BinaryenModuleRef module,
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

BINARYEN_API BinaryenModuleRef BinaryenModuleParse(const char* text) {
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

BINARYEN_API void BinaryenModulePrint(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModulePrint(the_module);\n";
  }

  WasmPrinter::printModule((Module*)module);
}

BINARYEN_API void BinaryenModulePrintAsmjs(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModulePrintAsmjs(the_module);\n";
  }

  Module* wasm = (Module*)module;
  Wasm2JSBuilder::Flags flags;
  Wasm2JSBuilder wasm2js(flags, globalPassOptions);
  Ref asmjs = wasm2js.processWasm(wasm);
  JSPrinter jser(true, true, asmjs);
  Output out("", Flags::Text, Flags::Release); // stdout
  Wasm2JSGlue glue(*wasm, out, flags, "asmFunc");
  glue.emitPre();
  jser.printAst();
  std::cout << jser.buffer << std::endl;
  glue.emitPost();
}

BINARYEN_API int BinaryenModuleValidate(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleValidate(the_module);\n";
  }

  Module* wasm = (Module*)module;
  return WasmValidator().validate(*wasm) ? 1 : 0;
}

BINARYEN_API void BinaryenModuleOptimize(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleOptimize(the_module);\n";
  }

  Module* wasm = (Module*)module;
  PassRunner passRunner(wasm);
  passRunner.options = globalPassOptions;
  passRunner.addDefaultOptimizationPasses();
  passRunner.run();
}

BINARYEN_API int BinaryenGetOptimizeLevel(void) {
  if (tracing) {
    std::cout << "  BinaryenGetOptimizeLevel();\n";
  }

  return globalPassOptions.optimizeLevel;
}

BINARYEN_API void BinaryenSetOptimizeLevel(int level) {
  if (tracing) {
    std::cout << "  BinaryenSetOptimizeLevel(" << level << ");\n";
  }

  globalPassOptions.optimizeLevel = level;
}

BINARYEN_API int BinaryenGetShrinkLevel(void) {
  if (tracing) {
    std::cout << "  BinaryenGetShrinkLevel();\n";
  }

  return globalPassOptions.shrinkLevel;
}

BINARYEN_API void BinaryenSetShrinkLevel(int level) {
  if (tracing) {
    std::cout << "  BinaryenSetShrinkLevel(" << level << ");\n";
  }

  globalPassOptions.shrinkLevel = level;
}

BINARYEN_API int BinaryenGetDebugInfo(void) {
  if (tracing) {
    std::cout << "  BinaryenGetDebugInfo();\n";
  }

  return globalPassOptions.debugInfo;
}

BINARYEN_API void BinaryenSetDebugInfo(int on) {
  if (tracing) {
    std::cout << "  BinaryenSetDebugInfo(" << on << ");\n";
  }

  globalPassOptions.debugInfo = on != 0;
}

BINARYEN_API void BinaryenModuleRunPasses(BinaryenModuleRef module,
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

BINARYEN_API void BinaryenModuleAutoDrop(BinaryenModuleRef module) {
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
  return {bytes, sourceMapBytes};
}

BINARYEN_API size_t BinaryenModuleWrite(BinaryenModuleRef module,
                                        char* output,
                                        size_t outputSize) {
  if (tracing) {
    std::cout << "  // BinaryenModuleWrite\n";
  }

  return writeModule((Module*)module, output, outputSize, nullptr, nullptr, 0)
    .outputBytes;
}

BINARYEN_API size_t BinaryenModuleWriteText(BinaryenModuleRef module,
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

BINARYEN_API BinaryenBufferSizes
BinaryenModuleWriteWithSourceMap(BinaryenModuleRef module,
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

BINARYEN_API BinaryenModuleAllocateAndWriteResult
BinaryenModuleAllocateAndWrite(BinaryenModuleRef module,
                               const char* sourceMapUrl) {
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
  return {binary, buffer.size(), sourceMap};
}

BINARYEN_API char*
BinaryenModuleAllocateAndWriteText(BinaryenModuleRef* module) {
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

BINARYEN_API BinaryenModuleRef BinaryenModuleRead(char* input,
                                                  size_t inputSize) {
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

BINARYEN_API void BinaryenModuleInterpret(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  BinaryenModuleInterpret(the_module);\n";
  }

  Module* wasm = (Module*)module;
  ShellExternalInterface interface;
  ModuleInstance instance(*wasm, &interface);
}

BINARYEN_API BinaryenIndex BinaryenModuleAddDebugInfoFileName(
  BinaryenModuleRef module, const char* filename) {
  if (tracing) {
    std::cout << "  BinaryenModuleAddDebugInfoFileName(the_module, \""
              << filename << "\");\n";
  }

  Module* wasm = (Module*)module;
  BinaryenIndex index = wasm->debugInfoFileNames.size();
  wasm->debugInfoFileNames.push_back(filename);
  return index;
}

BINARYEN_API const char*
BinaryenModuleGetDebugInfoFileName(BinaryenModuleRef module,
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
// ======== FunctionType Operations ========
//

BINARYEN_API const char*
BinaryenFunctionTypeGetName(BinaryenFunctionTypeRef ftype) {
  if (tracing) {
    std::cout << "  BinaryenFunctionTypeGetName(functionsTypes["
              << functions[ftype] << "]);\n";
  }

  return ((FunctionType*)ftype)->name.c_str();
}
BINARYEN_API BinaryenIndex
BinaryenFunctionTypeGetNumParams(BinaryenFunctionTypeRef ftype) {
  if (tracing) {
    std::cout << "  BinaryenFunctionTypeGetNumParams(functionsTypes["
              << functions[ftype] << "]);\n";
  }

  return ((FunctionType*)ftype)->params.size();
}
BINARYEN_API BinaryenType BinaryenFunctionTypeGetParam(
  BinaryenFunctionTypeRef ftype, BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenFunctionTypeGetParam(functionsTypes["
              << functions[ftype] << "], " << index << ");\n";
  }

  auto* ft = (FunctionType*)ftype;
  assert(index < ft->params.size());
  return ft->params[index];
}
BINARYEN_API BinaryenType
BinaryenFunctionTypeGetResult(BinaryenFunctionTypeRef ftype) {
  if (tracing) {
    std::cout << "  BinaryenFunctionTypeGetResult(functionsTypes["
              << functions[ftype] << "]);\n";
  }

  return ((FunctionType*)ftype)->result;
}

//
// ========== Function Operations ==========
//

BINARYEN_API const char* BinaryenFunctionGetName(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetName(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->name.c_str();
}
BINARYEN_API const char* BinaryenFunctionGetType(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetType(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->type.c_str();
}
BINARYEN_API BinaryenIndex
BinaryenFunctionGetNumParams(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetNumParams(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->params.size();
}
BINARYEN_API BinaryenType BinaryenFunctionGetParam(BinaryenFunctionRef func,
                                                   BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetParam(functions[" << functions[func]
              << "], " << index << ");\n";
  }

  auto* fn = (Function*)func;
  assert(index < fn->params.size());
  return fn->params[index];
}
BINARYEN_API BinaryenType BinaryenFunctionGetResult(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetResult(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->result;
}
BINARYEN_API BinaryenIndex
BinaryenFunctionGetNumVars(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetNumVars(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->vars.size();
}
BINARYEN_API BinaryenType BinaryenFunctionGetVar(BinaryenFunctionRef func,
                                                 BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetVar(functions[" << functions[func]
              << "], " << index << ");\n";
  }

  auto* fn = (Function*)func;
  assert(index < fn->vars.size());
  return fn->vars[index];
}
BINARYEN_API BinaryenExpressionRef
BinaryenFunctionGetBody(BinaryenFunctionRef func) {
  if (tracing) {
    std::cout << "  BinaryenFunctionGetBody(functions[" << functions[func]
              << "]);\n";
  }

  return ((Function*)func)->body;
}
BINARYEN_API void BinaryenFunctionOptimize(BinaryenFunctionRef func,
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
BINARYEN_API void BinaryenFunctionRunPasses(BinaryenFunctionRef func,
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
BINARYEN_API void BinaryenFunctionSetDebugLocation(BinaryenFunctionRef func,
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

BINARYEN_API const char* BinaryenGlobalGetName(BinaryenGlobalRef global) {
  if (tracing) {
    std::cout << "  BinaryenGlobalGetName(globals[" << globals[global]
              << "]);\n";
  }

  return ((Global*)global)->name.c_str();
}
BINARYEN_API BinaryenType BinaryenGlobalGetType(BinaryenGlobalRef global) {
  if (tracing) {
    std::cout << "  BinaryenGlobalGetType(globals[" << globals[global]
              << "]);\n";
  }

  return ((Global*)global)->type;
}
BINARYEN_API int BinaryenGlobalIsMutable(BinaryenGlobalRef global) {
  if (tracing) {
    std::cout << "  BinaryenGlobalIsMutable(globals[" << globals[global]
              << "]);\n";
  }

  return ((Global*)global)->mutable_;
}
BINARYEN_API BinaryenExpressionRef
BinaryenGlobalGetInitExpr(BinaryenGlobalRef global) {
  if (tracing) {
    std::cout << "  BinaryenGlobalGetInitExpr(globals[" << globals[global]
              << "]);\n";
  }

  return ((Global*)global)->init;
}

//
// =========== Event operations ===========
//

BINARYEN_API const char* BinaryenEventGetName(BinaryenEventRef event) {
  if (tracing) {
    std::cout << "  BinaryenEventGetName(events[" << events[event] << "]);\n";
  }

  return ((Event*)event)->name.c_str();
}
BINARYEN_API int BinaryenEventGetAttribute(BinaryenEventRef event) {
  if (tracing) {
    std::cout << "  BinaryenEventGetAttribute(events[" << events[event]
              << "]);\n";
  }

  return ((Event*)event)->attribute;
}
BINARYEN_API const char* BinaryenEventGetType(BinaryenEventRef event) {
  if (tracing) {
    std::cout << "  BinaryenEventGetType(events[" << events[event] << "]);\n";
  }

  return ((Event*)event)->type.c_str();
}
BINARYEN_API BinaryenIndex BinaryenEventGetNumParams(BinaryenEventRef event) {
  if (tracing) {
    std::cout << "  BinaryenEventGetNumParams(events[" << events[event]
              << "]);\n";
  }

  return ((Event*)event)->params.size();
}
BINARYEN_API BinaryenType BinaryenEventGetParam(BinaryenEventRef event,
                                                BinaryenIndex index) {
  if (tracing) {
    std::cout << "  BinaryenEventGetParam(events[" << events[event] << "], "
              << index << ");\n";
  }

  auto* fn = (Event*)event;
  assert(index < fn->params.size());
  return fn->params[index];
}

//
// =========== Import operations ===========
//

BINARYEN_API const char*
BinaryenFunctionImportGetModule(BinaryenFunctionRef import) {
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
BINARYEN_API const char*
BinaryenGlobalImportGetModule(BinaryenGlobalRef import) {
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
BINARYEN_API const char* BinaryenEventImportGetModule(BinaryenEventRef import) {
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
BINARYEN_API const char*
BinaryenFunctionImportGetBase(BinaryenFunctionRef import) {
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
BINARYEN_API const char* BinaryenGlobalImportGetBase(BinaryenGlobalRef import) {
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
BINARYEN_API const char* BinaryenEventImportGetBase(BinaryenEventRef import) {
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

BINARYEN_API BinaryenExternalKind
BinaryenExportGetKind(BinaryenExportRef export_) {
  if (tracing) {
    std::cout << "  BinaryenExportGetKind(exports[" << exports[export_]
              << "]);\n";
  }

  return BinaryenExternalKind(((Export*)export_)->kind);
}
BINARYEN_API const char* BinaryenExportGetName(BinaryenExportRef export_) {
  if (tracing) {
    std::cout << "  BinaryenExportGetName(exports[" << exports[export_]
              << "]);\n";
  }

  return ((Export*)export_)->name.c_str();
}
BINARYEN_API const char* BinaryenExportGetValue(BinaryenExportRef export_) {
  if (tracing) {
    std::cout << "  BinaryenExportGetValue(exports[" << exports[export_]
              << "]);\n";
  }

  return ((Export*)export_)->value.c_str();
}

//
// ========== CFG / Relooper ==========
//

BINARYEN_API RelooperRef RelooperCreate(BinaryenModuleRef module) {
  if (tracing) {
    std::cout << "  the_relooper = RelooperCreate(the_module);\n";
  }

  auto* wasm = (Module*)module;
  return RelooperRef(new CFG::Relooper(wasm));
}

BINARYEN_API RelooperBlockRef RelooperAddBlock(RelooperRef relooper,
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
  return RelooperRef(ret);
}

BINARYEN_API void RelooperAddBranch(RelooperBlockRef from,
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

BINARYEN_API RelooperBlockRef
RelooperAddBlockWithSwitch(RelooperRef relooper,
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
  return RelooperRef(ret);
}

BINARYEN_API void RelooperAddBranchForSwitch(RelooperBlockRef from,
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

BINARYEN_API BinaryenExpressionRef RelooperRenderAndDispose(
  RelooperRef relooper, RelooperBlockRef entry, BinaryenIndex labelHelper) {
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

BINARYEN_API void BinaryenSetAPITracing(int on) {
  tracing = on;

  if (tracing) {
    std::cout << "// beginning a Binaryen API trace\n"
                 "#include <math.h>\n"
                 "#include <map>\n"
                 "#include \"binaryen-c.h\"\n"
                 "int main() {\n"
                 "  std::map<size_t, BinaryenFunctionTypeRef> functionTypes;\n"
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
  }
}

//
// ========= Utilities =========
//

BINARYEN_API BinaryenFunctionTypeRef
BinaryenGetFunctionTypeBySignature(BinaryenModuleRef module,
                                   BinaryenType result,
                                   BinaryenType* paramTypes,
                                   BinaryenIndex numParams) {
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

BINARYEN_API void BinaryenSetColorsEnabled(int enabled) {
  Colors::setEnabled(enabled);
}

BINARYEN_API int BinaryenAreColorsEnabled() { return Colors::isEnabled(); }

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

#endif

} // extern "C"
