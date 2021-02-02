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

//
// Print out text in s-expression format
//

#include <ir/module-utils.h>
#include <pass.h>
#include <pretty_printing.h>
#include <wasm-stack.h>
#include <wasm.h>

namespace wasm {

static std::ostream& printExpression(Expression* expression,
                                     std::ostream& o,
                                     bool minify = false,
                                     bool full = false);

static std::ostream&
printStackInst(StackInst* inst, std::ostream& o, Function* func = nullptr);

static std::ostream&
printStackIR(StackIR* ir, std::ostream& o, Function* func = nullptr);

namespace {

bool isFullForced() {
  if (getenv("BINARYEN_PRINT_FULL")) {
    return std::stoi(getenv("BINARYEN_PRINT_FULL")) != 0;
  }
  return false;
}

std::ostream& printName(Name name, std::ostream& o) {
  // we need to quote names if they have tricky chars
  if (!name.str || !strpbrk(name.str, "()")) {
    o << '$' << name.str;
  } else {
    o << "\"$" << name.str << '"';
  }
  return o;
}

static std::ostream& printLocal(Index index, Function* func, std::ostream& o) {
  Name name;
  if (func) {
    name = func->getLocalNameOrDefault(index);
  }
  if (!name) {
    name = Name::fromInt(index);
  }
  return printName(name, o);
}

static void
printHeapTypeName(std::ostream& os, HeapType type, bool first = true);

// Prints the name of a type. This output is guaranteed to not contain spaces.
static void printTypeName(std::ostream& os, Type type) {
  if (type.isBasic()) {
    os << type;
    return;
  }
  if (type.isRtt()) {
    auto rtt = type.getRtt();
    os << "rtt_";
    if (rtt.hasDepth()) {
      os << rtt.depth << '_';
    }
    printHeapTypeName(os, rtt.heapType);
    return;
  }
  if (type.isTuple()) {
    auto sep = "";
    for (auto t : type) {
      os << sep;
      sep = "_";
      printTypeName(os, t);
    }
    return;
  }
  if (type.isRef()) {
    os << "ref";
    if (type.isNullable()) {
      os << "?";
    }
    os << "|";
    printHeapTypeName(os, type.getHeapType(), false);
    os << "|";
    return;
  }
  WASM_UNREACHABLE("unsupported print type");
}

static void printFieldName(std::ostream& os, const Field& field) {
  if (field.mutable_) {
    os << "mut:";
  }
  if (field.type == Type::i32 && field.packedType != Field::not_packed) {
    if (field.packedType == Field::i8) {
      os << "i8";
    } else if (field.packedType == Field::i16) {
      os << "i16";
    } else {
      WASM_UNREACHABLE("invalid packed type");
    }
  } else {
    printTypeName(os, field.type);
  }
}

// Prints the name of a heap type. As with printTypeName, this output is
// guaranteed to not contain spaces.
static void printHeapTypeName(std::ostream& os, HeapType type, bool first) {
  if (type.isBasic()) {
    os << type;
    return;
  }
  if (first) {
    os << '$';
  }
  if (type.isSignature()) {
    auto sig = type.getSignature();
    printTypeName(os, sig.params);
    if (first) {
      os << "_=>_";
    } else {
      os << "_->_";
    }
    printTypeName(os, sig.results);
  } else if (type.isStruct()) {
    auto struct_ = type.getStruct();
    os << "{";
    auto sep = "";
    for (auto& field : struct_.fields) {
      os << sep;
      sep = "_";
      printFieldName(os, field);
    }
    os << "}";
  } else if (type.isArray()) {
    os << "[";
    printFieldName(os, type.getArray().element);
    os << "]";
  } else {
    os << type;
  }
}

// Unlike the default format, tuple types in s-expressions should not have
// commas.
struct SExprType {
  Type type;
  SExprType(Type type) : type(type){};
};

static std::ostream& operator<<(std::ostream& o, const SExprType& sType) {
  Type type = sType.type;
  if (type.isTuple()) {
    o << '(';
    auto sep = "";
    for (const auto& t : type) {
      o << sep << t;
      sep = " ";
    }
    o << ')';
  } else if (type.isRtt()) {
    auto rtt = type.getRtt();
    o << "(rtt ";
    if (rtt.hasDepth()) {
      o << rtt.depth << ' ';
    }
    printHeapTypeName(o, rtt.heapType);
    o << ')';
  } else if (type.isRef() && !type.isBasic()) {
    o << "(ref ";
    if (type.isNullable()) {
      o << "null ";
    }
    printHeapTypeName(o, type.getHeapType());
    o << ')';
  } else {
    printTypeName(o, sType.type);
  }
  return o;
}

// TODO: try to simplify or even remove this, as we may be able to do the same
//       things with SExprType
struct ResultTypeName {
  Type type;
  ResultTypeName(Type type) : type(type) {}
};

std::ostream& operator<<(std::ostream& os, ResultTypeName typeName) {
  auto type = typeName.type;
  os << "(result ";
  if (type.isTuple()) {
    // Tuple types are not printed in parens, we can just emit them one after
    // the other in the same list as the "result".
    auto sep = "";
    for (auto t : type) {
      os << sep;
      sep = " ";
      os << SExprType(t);
    }
  } else {
    os << SExprType(type);
  }
  os << ')';
  return os;
}

} // anonymous namespace

// Printing "unreachable" as a instruction prefix type is not valid in wasm text
// format. Print something else to make it pass.
static Type forceConcrete(Type type) {
  return type.isConcrete() ? type : Type::i32;
}

// Prints the internal contents of an expression: everything but
// the children.
struct PrintExpressionContents
  : public OverriddenVisitor<PrintExpressionContents> {
  Function* currFunction = nullptr;
  std::ostream& o;
  FeatureSet features;

  PrintExpressionContents(Function* currFunction,
                          FeatureSet features,
                          std::ostream& o)
    : currFunction(currFunction), o(o), features(features) {}

  PrintExpressionContents(Function* currFunction, std::ostream& o)
    : currFunction(currFunction), o(o), features(FeatureSet::All) {}

  void visitBlock(Block* curr) {
    printMedium(o, "block");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    if (curr->type.isConcrete()) {
      o << ' ' << ResultTypeName(curr->type);
    }
  }
  void visitIf(If* curr) {
    printMedium(o, "if");
    if (curr->type.isConcrete()) {
      o << ' ' << ResultTypeName(curr->type);
    }
  }
  void visitLoop(Loop* curr) {
    printMedium(o, "loop");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    if (curr->type.isConcrete()) {
      o << ' ' << ResultTypeName(curr->type);
    }
  }
  void visitBreak(Break* curr) {
    if (curr->condition) {
      printMedium(o, "br_if ");
    } else {
      printMedium(o, "br ");
    }
    printName(curr->name, o);
  }
  void visitSwitch(Switch* curr) {
    printMedium(o, "br_table");
    for (auto& t : curr->targets) {
      o << ' ';
      printName(t, o);
    }
    o << ' ';
    printName(curr->default_, o);
  }
  void visitCall(Call* curr) {
    if (curr->isReturn) {
      printMedium(o, "return_call ");
    } else {
      printMedium(o, "call ");
    }
    printName(curr->target, o);
  }
  void visitCallIndirect(CallIndirect* curr) {
    if (curr->isReturn) {
      printMedium(o, "return_call_indirect (type ");
    } else {
      printMedium(o, "call_indirect (type ");
    }
    printHeapTypeName(o, curr->sig);
    o << ')';
  }
  void visitLocalGet(LocalGet* curr) {
    printMedium(o, "local.get ");
    printLocal(curr->index, currFunction, o);
  }
  void visitLocalSet(LocalSet* curr) {
    if (curr->isTee()) {
      printMedium(o, "local.tee ");
    } else {
      printMedium(o, "local.set ");
    }
    printLocal(curr->index, currFunction, o);
  }
  void visitGlobalGet(GlobalGet* curr) {
    printMedium(o, "global.get ");
    printName(curr->name, o);
  }
  void visitGlobalSet(GlobalSet* curr) {
    printMedium(o, "global.set ");
    printName(curr->name, o);
  }
  void visitLoad(Load* curr) {
    prepareColor(o) << forceConcrete(curr->type);
    if (curr->isAtomic) {
      o << ".atomic";
    }
    o << ".load";
    if (curr->type != Type::unreachable &&
        curr->bytes < curr->type.getByteSize()) {
      if (curr->bytes == 1) {
        o << '8';
      } else if (curr->bytes == 2) {
        o << "16";
      } else if (curr->bytes == 4) {
        o << "32";
      } else {
        abort();
      }
      o << (curr->signed_ ? "_s" : "_u");
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->bytes) {
      o << " align=" << curr->align;
    }
  }
  void visitStore(Store* curr) {
    prepareColor(o) << forceConcrete(curr->valueType);
    if (curr->isAtomic) {
      o << ".atomic";
    }
    o << ".store";
    if (curr->bytes < 4 || (curr->valueType == Type::i64 && curr->bytes < 8)) {
      if (curr->bytes == 1) {
        o << '8';
      } else if (curr->bytes == 2) {
        o << "16";
      } else if (curr->bytes == 4) {
        o << "32";
      } else {
        abort();
      }
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->bytes) {
      o << " align=" << curr->align;
    }
  }
  static void printRMWSize(std::ostream& o, Type type, uint8_t bytes) {
    prepareColor(o) << forceConcrete(type) << ".atomic.rmw";
    if (type != Type::unreachable && bytes != type.getByteSize()) {
      if (bytes == 1) {
        o << '8';
      } else if (bytes == 2) {
        o << "16";
      } else if (bytes == 4) {
        o << "32";
      } else {
        WASM_UNREACHABLE("invalid RMW byte length");
      }
    }
    o << '.';
  }
  void visitAtomicRMW(AtomicRMW* curr) {
    prepareColor(o);
    printRMWSize(o, curr->type, curr->bytes);
    switch (curr->op) {
      case RMWAdd:
        o << "add";
        break;
      case RMWSub:
        o << "sub";
        break;
      case RMWAnd:
        o << "and";
        break;
      case RMWOr:
        o << "or";
        break;
      case RMWXor:
        o << "xor";
        break;
      case RMWXchg:
        o << "xchg";
        break;
    }
    if (curr->type != Type::unreachable &&
        curr->bytes != curr->type.getByteSize()) {
      o << "_u";
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    prepareColor(o);
    printRMWSize(o, curr->type, curr->bytes);
    o << "cmpxchg";
    if (curr->type != Type::unreachable &&
        curr->bytes != curr->type.getByteSize()) {
      o << "_u";
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicWait(AtomicWait* curr) {
    prepareColor(o);
    Type type = forceConcrete(curr->expectedType);
    assert(type == Type::i32 || type == Type::i64);
    o << "memory.atomic.wait" << (type == Type::i32 ? "32" : "64");
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicNotify(AtomicNotify* curr) {
    printMedium(o, "memory.atomic.notify");
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicFence(AtomicFence* curr) { printMedium(o, "atomic.fence"); }
  void visitSIMDExtract(SIMDExtract* curr) {
    prepareColor(o);
    switch (curr->op) {
      case ExtractLaneSVecI8x16:
        o << "i8x16.extract_lane_s";
        break;
      case ExtractLaneUVecI8x16:
        o << "i8x16.extract_lane_u";
        break;
      case ExtractLaneSVecI16x8:
        o << "i16x8.extract_lane_s";
        break;
      case ExtractLaneUVecI16x8:
        o << "i16x8.extract_lane_u";
        break;
      case ExtractLaneVecI32x4:
        o << "i32x4.extract_lane";
        break;
      case ExtractLaneVecI64x2:
        o << "i64x2.extract_lane";
        break;
      case ExtractLaneVecF32x4:
        o << "f32x4.extract_lane";
        break;
      case ExtractLaneVecF64x2:
        o << "f64x2.extract_lane";
        break;
    }
    o << " " << int(curr->index);
  }
  void visitSIMDReplace(SIMDReplace* curr) {
    prepareColor(o);
    switch (curr->op) {
      case ReplaceLaneVecI8x16:
        o << "i8x16.replace_lane";
        break;
      case ReplaceLaneVecI16x8:
        o << "i16x8.replace_lane";
        break;
      case ReplaceLaneVecI32x4:
        o << "i32x4.replace_lane";
        break;
      case ReplaceLaneVecI64x2:
        o << "i64x2.replace_lane";
        break;
      case ReplaceLaneVecF32x4:
        o << "f32x4.replace_lane";
        break;
      case ReplaceLaneVecF64x2:
        o << "f64x2.replace_lane";
        break;
    }
    o << " " << int(curr->index);
  }
  void visitSIMDShuffle(SIMDShuffle* curr) {
    prepareColor(o);
    o << "v8x16.shuffle";
    for (uint8_t mask_index : curr->mask) {
      o << " " << std::to_string(mask_index);
    }
  }
  void visitSIMDTernary(SIMDTernary* curr) {
    prepareColor(o);
    switch (curr->op) {
      case Bitselect:
        o << "v128.bitselect";
        break;
      case QFMAF32x4:
        o << "f32x4.qfma";
        break;
      case QFMSF32x4:
        o << "f32x4.qfms";
        break;
      case QFMAF64x2:
        o << "f64x2.qfma";
        break;
      case QFMSF64x2:
        o << "f64x2.qfms";
        break;
      case SignSelectVec8x16:
        o << "v8x16.signselect";
        break;
      case SignSelectVec16x8:
        o << "v16x8.signselect";
        break;
      case SignSelectVec32x4:
        o << "v32x4.signselect";
        break;
      case SignSelectVec64x2:
        o << "v64x2.signselect";
        break;
    }
  }
  void visitSIMDShift(SIMDShift* curr) {
    prepareColor(o);
    switch (curr->op) {
      case ShlVecI8x16:
        o << "i8x16.shl";
        break;
      case ShrSVecI8x16:
        o << "i8x16.shr_s";
        break;
      case ShrUVecI8x16:
        o << "i8x16.shr_u";
        break;
      case ShlVecI16x8:
        o << "i16x8.shl";
        break;
      case ShrSVecI16x8:
        o << "i16x8.shr_s";
        break;
      case ShrUVecI16x8:
        o << "i16x8.shr_u";
        break;
      case ShlVecI32x4:
        o << "i32x4.shl";
        break;
      case ShrSVecI32x4:
        o << "i32x4.shr_s";
        break;
      case ShrUVecI32x4:
        o << "i32x4.shr_u";
        break;
      case ShlVecI64x2:
        o << "i64x2.shl";
        break;
      case ShrSVecI64x2:
        o << "i64x2.shr_s";
        break;
      case ShrUVecI64x2:
        o << "i64x2.shr_u";
        break;
    }
  }
  void visitSIMDLoad(SIMDLoad* curr) {
    prepareColor(o);
    switch (curr->op) {
      case LoadSplatVec8x16:
        o << "v8x16.load_splat";
        break;
      case LoadSplatVec16x8:
        o << "v16x8.load_splat";
        break;
      case LoadSplatVec32x4:
        o << "v32x4.load_splat";
        break;
      case LoadSplatVec64x2:
        o << "v64x2.load_splat";
        break;
      case LoadExtSVec8x8ToVecI16x8:
        o << "i16x8.load8x8_s";
        break;
      case LoadExtUVec8x8ToVecI16x8:
        o << "i16x8.load8x8_u";
        break;
      case LoadExtSVec16x4ToVecI32x4:
        o << "i32x4.load16x4_s";
        break;
      case LoadExtUVec16x4ToVecI32x4:
        o << "i32x4.load16x4_u";
        break;
      case LoadExtSVec32x2ToVecI64x2:
        o << "i64x2.load32x2_s";
        break;
      case LoadExtUVec32x2ToVecI64x2:
        o << "i64x2.load32x2_u";
        break;
      case Load32Zero:
        o << "v128.load32_zero";
        break;
      case Load64Zero:
        o << "v128.load64_zero";
        break;
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->getMemBytes()) {
      o << " align=" << curr->align;
    }
  }
  void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    prepareColor(o);
    switch (curr->op) {
      case LoadLaneVec8x16:
        o << "v128.load8_lane";
        break;
      case LoadLaneVec16x8:
        o << "v128.load16_lane";
        break;
      case LoadLaneVec32x4:
        o << "v128.load32_lane";
        break;
      case LoadLaneVec64x2:
        o << "v128.load64_lane";
        break;
      case StoreLaneVec8x16:
        o << "v128.store8_lane";
        break;
      case StoreLaneVec16x8:
        o << "v128.store16_lane";
        break;
      case StoreLaneVec32x4:
        o << "v128.store32_lane";
        break;
      case StoreLaneVec64x2:
        o << "v128.store64_lane";
        break;
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->getMemBytes()) {
      o << " align=" << curr->align;
    }
    o << " " << int(curr->index);
  }
  void visitSIMDWiden(SIMDWiden* curr) {
    prepareColor(o);
    switch (curr->op) {
      case WidenSVecI8x16ToVecI32x4:
        o << "i32x4.widen_i8x16_s ";
        break;
      case WidenUVecI8x16ToVecI32x4:
        o << "i32x4.widen_i8x16_u ";
        break;
    }
    restoreNormalColor(o);
    o << int(curr->index);
  }
  void visitPrefetch(Prefetch* curr) {
    prepareColor(o);
    switch (curr->op) {
      case PrefetchTemporal:
        o << "prefetch.t";
        break;
      case PrefetchNontemporal:
        o << "prefetch.nt";
        break;
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != 1) {
      o << " align=" << curr->align;
    }
  }
  void visitMemoryInit(MemoryInit* curr) {
    prepareColor(o);
    o << "memory.init " << curr->segment;
  }
  void visitDataDrop(DataDrop* curr) {
    prepareColor(o);
    o << "data.drop " << curr->segment;
  }
  void visitMemoryCopy(MemoryCopy* curr) {
    prepareColor(o);
    o << "memory.copy";
  }
  void visitMemoryFill(MemoryFill* curr) {
    prepareColor(o);
    o << "memory.fill";
  }
  void visitConst(Const* curr) {
    o << curr->value.type << ".const " << curr->value;
  }
  void visitUnary(Unary* curr) {
    prepareColor(o);
    switch (curr->op) {
      case ClzInt32:
        o << "i32.clz";
        break;
      case CtzInt32:
        o << "i32.ctz";
        break;
      case PopcntInt32:
        o << "i32.popcnt";
        break;
      case EqZInt32:
        o << "i32.eqz";
        break;
      case ClzInt64:
        o << "i64.clz";
        break;
      case CtzInt64:
        o << "i64.ctz";
        break;
      case PopcntInt64:
        o << "i64.popcnt";
        break;
      case EqZInt64:
        o << "i64.eqz";
        break;
      case NegFloat32:
        o << "f32.neg";
        break;
      case AbsFloat32:
        o << "f32.abs";
        break;
      case CeilFloat32:
        o << "f32.ceil";
        break;
      case FloorFloat32:
        o << "f32.floor";
        break;
      case TruncFloat32:
        o << "f32.trunc";
        break;
      case NearestFloat32:
        o << "f32.nearest";
        break;
      case SqrtFloat32:
        o << "f32.sqrt";
        break;
      case NegFloat64:
        o << "f64.neg";
        break;
      case AbsFloat64:
        o << "f64.abs";
        break;
      case CeilFloat64:
        o << "f64.ceil";
        break;
      case FloorFloat64:
        o << "f64.floor";
        break;
      case TruncFloat64:
        o << "f64.trunc";
        break;
      case NearestFloat64:
        o << "f64.nearest";
        break;
      case SqrtFloat64:
        o << "f64.sqrt";
        break;
      case ExtendSInt32:
        o << "i64.extend_i32_s";
        break;
      case ExtendUInt32:
        o << "i64.extend_i32_u";
        break;
      case WrapInt64:
        o << "i32.wrap_i64";
        break;
      case TruncSFloat32ToInt32:
        o << "i32.trunc_f32_s";
        break;
      case TruncSFloat32ToInt64:
        o << "i64.trunc_f32_s";
        break;
      case TruncUFloat32ToInt32:
        o << "i32.trunc_f32_u";
        break;
      case TruncUFloat32ToInt64:
        o << "i64.trunc_f32_u";
        break;
      case TruncSFloat64ToInt32:
        o << "i32.trunc_f64_s";
        break;
      case TruncSFloat64ToInt64:
        o << "i64.trunc_f64_s";
        break;
      case TruncUFloat64ToInt32:
        o << "i32.trunc_f64_u";
        break;
      case TruncUFloat64ToInt64:
        o << "i64.trunc_f64_u";
        break;
      case ReinterpretFloat32:
        o << "i32.reinterpret_f32";
        break;
      case ReinterpretFloat64:
        o << "i64.reinterpret_f64";
        break;
      case ConvertUInt32ToFloat32:
        o << "f32.convert_i32_u";
        break;
      case ConvertUInt32ToFloat64:
        o << "f64.convert_i32_u";
        break;
      case ConvertSInt32ToFloat32:
        o << "f32.convert_i32_s";
        break;
      case ConvertSInt32ToFloat64:
        o << "f64.convert_i32_s";
        break;
      case ConvertUInt64ToFloat32:
        o << "f32.convert_i64_u";
        break;
      case ConvertUInt64ToFloat64:
        o << "f64.convert_i64_u";
        break;
      case ConvertSInt64ToFloat32:
        o << "f32.convert_i64_s";
        break;
      case ConvertSInt64ToFloat64:
        o << "f64.convert_i64_s";
        break;
      case PromoteFloat32:
        o << "f64.promote_f32";
        break;
      case DemoteFloat64:
        o << "f32.demote_f64";
        break;
      case ReinterpretInt32:
        o << "f32.reinterpret_i32";
        break;
      case ReinterpretInt64:
        o << "f64.reinterpret_i64";
        break;
      case ExtendS8Int32:
        o << "i32.extend8_s";
        break;
      case ExtendS16Int32:
        o << "i32.extend16_s";
        break;
      case ExtendS8Int64:
        o << "i64.extend8_s";
        break;
      case ExtendS16Int64:
        o << "i64.extend16_s";
        break;
      case ExtendS32Int64:
        o << "i64.extend32_s";
        break;
      case TruncSatSFloat32ToInt32:
        o << "i32.trunc_sat_f32_s";
        break;
      case TruncSatUFloat32ToInt32:
        o << "i32.trunc_sat_f32_u";
        break;
      case TruncSatSFloat64ToInt32:
        o << "i32.trunc_sat_f64_s";
        break;
      case TruncSatUFloat64ToInt32:
        o << "i32.trunc_sat_f64_u";
        break;
      case TruncSatSFloat32ToInt64:
        o << "i64.trunc_sat_f32_s";
        break;
      case TruncSatUFloat32ToInt64:
        o << "i64.trunc_sat_f32_u";
        break;
      case TruncSatSFloat64ToInt64:
        o << "i64.trunc_sat_f64_s";
        break;
      case TruncSatUFloat64ToInt64:
        o << "i64.trunc_sat_f64_u";
        break;
      case SplatVecI8x16:
        o << "i8x16.splat";
        break;
      case SplatVecI16x8:
        o << "i16x8.splat";
        break;
      case SplatVecI32x4:
        o << "i32x4.splat";
        break;
      case SplatVecI64x2:
        o << "i64x2.splat";
        break;
      case SplatVecF32x4:
        o << "f32x4.splat";
        break;
      case SplatVecF64x2:
        o << "f64x2.splat";
        break;
      case NotVec128:
        o << "v128.not";
        break;
      case AbsVecI8x16:
        o << "i8x16.abs";
        break;
      case NegVecI8x16:
        o << "i8x16.neg";
        break;
      case AnyTrueVecI8x16:
        o << "i8x16.any_true";
        break;
      case AllTrueVecI8x16:
        o << "i8x16.all_true";
        break;
      case BitmaskVecI8x16:
        o << "i8x16.bitmask";
        break;
      case PopcntVecI8x16:
        o << "i8x16.popcnt";
        break;
      case AbsVecI16x8:
        o << "i16x8.abs";
        break;
      case NegVecI16x8:
        o << "i16x8.neg";
        break;
      case AnyTrueVecI16x8:
        o << "i16x8.any_true";
        break;
      case AllTrueVecI16x8:
        o << "i16x8.all_true";
        break;
      case BitmaskVecI16x8:
        o << "i16x8.bitmask";
        break;
      case AbsVecI32x4:
        o << "i32x4.abs";
        break;
      case NegVecI32x4:
        o << "i32x4.neg";
        break;
      case AnyTrueVecI32x4:
        o << "i32x4.any_true";
        break;
      case AllTrueVecI32x4:
        o << "i32x4.all_true";
        break;
      case BitmaskVecI32x4:
        o << "i32x4.bitmask";
        break;
      case NegVecI64x2:
        o << "i64x2.neg";
        break;
      case BitmaskVecI64x2:
        o << "i64x2.bitmask";
        break;
      case AbsVecF32x4:
        o << "f32x4.abs";
        break;
      case NegVecF32x4:
        o << "f32x4.neg";
        break;
      case SqrtVecF32x4:
        o << "f32x4.sqrt";
        break;
      case CeilVecF32x4:
        o << "f32x4.ceil";
        break;
      case FloorVecF32x4:
        o << "f32x4.floor";
        break;
      case TruncVecF32x4:
        o << "f32x4.trunc";
        break;
      case NearestVecF32x4:
        o << "f32x4.nearest";
        break;
      case AbsVecF64x2:
        o << "f64x2.abs";
        break;
      case NegVecF64x2:
        o << "f64x2.neg";
        break;
      case SqrtVecF64x2:
        o << "f64x2.sqrt";
        break;
      case CeilVecF64x2:
        o << "f64x2.ceil";
        break;
      case FloorVecF64x2:
        o << "f64x2.floor";
        break;
      case TruncVecF64x2:
        o << "f64x2.trunc";
        break;
      case NearestVecF64x2:
        o << "f64x2.nearest";
        break;
      case ExtAddPairwiseSVecI8x16ToI16x8:
        o << "i16x8.extadd_pairwise_i8x16_s";
        break;
      case ExtAddPairwiseUVecI8x16ToI16x8:
        o << "i16x8.extadd_pairwise_i8x16_u";
        break;
      case ExtAddPairwiseSVecI16x8ToI32x4:
        o << "i32x4.extadd_pairwise_i16x8_s";
        break;
      case ExtAddPairwiseUVecI16x8ToI32x4:
        o << "i32x4.extadd_pairwise_i16x8_u";
        break;
      case TruncSatSVecF32x4ToVecI32x4:
        o << "i32x4.trunc_sat_f32x4_s";
        break;
      case TruncSatUVecF32x4ToVecI32x4:
        o << "i32x4.trunc_sat_f32x4_u";
        break;
      case TruncSatSVecF64x2ToVecI64x2:
        o << "i64x2.trunc_sat_f64x2_s";
        break;
      case TruncSatUVecF64x2ToVecI64x2:
        o << "i64x2.trunc_sat_f64x2_u";
        break;
      case ConvertSVecI32x4ToVecF32x4:
        o << "f32x4.convert_i32x4_s";
        break;
      case ConvertUVecI32x4ToVecF32x4:
        o << "f32x4.convert_i32x4_u";
        break;
      case ConvertSVecI64x2ToVecF64x2:
        o << "f64x2.convert_i64x2_s";
        break;
      case ConvertUVecI64x2ToVecF64x2:
        o << "f64x2.convert_i64x2_u";
        break;
      case WidenLowSVecI8x16ToVecI16x8:
        o << "i16x8.widen_low_i8x16_s";
        break;
      case WidenHighSVecI8x16ToVecI16x8:
        o << "i16x8.widen_high_i8x16_s";
        break;
      case WidenLowUVecI8x16ToVecI16x8:
        o << "i16x8.widen_low_i8x16_u";
        break;
      case WidenHighUVecI8x16ToVecI16x8:
        o << "i16x8.widen_high_i8x16_u";
        break;
      case WidenLowSVecI16x8ToVecI32x4:
        o << "i32x4.widen_low_i16x8_s";
        break;
      case WidenHighSVecI16x8ToVecI32x4:
        o << "i32x4.widen_high_i16x8_s";
        break;
      case WidenLowUVecI16x8ToVecI32x4:
        o << "i32x4.widen_low_i16x8_u";
        break;
      case WidenHighUVecI16x8ToVecI32x4:
        o << "i32x4.widen_high_i16x8_u";
        break;
      case WidenLowSVecI32x4ToVecI64x2:
        o << "i64x2.widen_low_i32x4_s";
        break;
      case WidenHighSVecI32x4ToVecI64x2:
        o << "i64x2.widen_high_i32x4_s";
        break;
      case WidenLowUVecI32x4ToVecI64x2:
        o << "i64x2.widen_low_i32x4_u";
        break;
      case WidenHighUVecI32x4ToVecI64x2:
        o << "i64x2.widen_high_i32x4_u";
        break;
      case ConvertLowSVecI32x4ToVecF64x2:
        o << "f64x2.convert_low_i32x4_s";
        break;
      case ConvertLowUVecI32x4ToVecF64x2:
        o << "f64x2.convert_low_i32x4_u";
        break;
      case TruncSatZeroSVecF64x2ToVecI32x4:
        o << "i32x4.trunc_sat_f64x2_zero_s";
        break;
      case TruncSatZeroUVecF64x2ToVecI32x4:
        o << "i32x4.trunc_sat_f64x2_zero_u";
        break;
      case DemoteZeroVecF64x2ToVecF32x4:
        o << "f32x4.demote_f64x2_zero";
        break;
      case PromoteLowVecF32x4ToVecF64x2:
        o << "f64x2.promote_low_f32x4";
        break;
      case InvalidUnary:
        WASM_UNREACHABLE("unvalid unary operator");
    }
  }
  void visitBinary(Binary* curr) {
    prepareColor(o);
    switch (curr->op) {
      case AddInt32:
        o << "i32.add";
        break;
      case SubInt32:
        o << "i32.sub";
        break;
      case MulInt32:
        o << "i32.mul";
        break;
      case DivSInt32:
        o << "i32.div_s";
        break;
      case DivUInt32:
        o << "i32.div_u";
        break;
      case RemSInt32:
        o << "i32.rem_s";
        break;
      case RemUInt32:
        o << "i32.rem_u";
        break;
      case AndInt32:
        o << "i32.and";
        break;
      case OrInt32:
        o << "i32.or";
        break;
      case XorInt32:
        o << "i32.xor";
        break;
      case ShlInt32:
        o << "i32.shl";
        break;
      case ShrUInt32:
        o << "i32.shr_u";
        break;
      case ShrSInt32:
        o << "i32.shr_s";
        break;
      case RotLInt32:
        o << "i32.rotl";
        break;
      case RotRInt32:
        o << "i32.rotr";
        break;
      case EqInt32:
        o << "i32.eq";
        break;
      case NeInt32:
        o << "i32.ne";
        break;
      case LtSInt32:
        o << "i32.lt_s";
        break;
      case LtUInt32:
        o << "i32.lt_u";
        break;
      case LeSInt32:
        o << "i32.le_s";
        break;
      case LeUInt32:
        o << "i32.le_u";
        break;
      case GtSInt32:
        o << "i32.gt_s";
        break;
      case GtUInt32:
        o << "i32.gt_u";
        break;
      case GeSInt32:
        o << "i32.ge_s";
        break;
      case GeUInt32:
        o << "i32.ge_u";
        break;

      case AddInt64:
        o << "i64.add";
        break;
      case SubInt64:
        o << "i64.sub";
        break;
      case MulInt64:
        o << "i64.mul";
        break;
      case DivSInt64:
        o << "i64.div_s";
        break;
      case DivUInt64:
        o << "i64.div_u";
        break;
      case RemSInt64:
        o << "i64.rem_s";
        break;
      case RemUInt64:
        o << "i64.rem_u";
        break;
      case AndInt64:
        o << "i64.and";
        break;
      case OrInt64:
        o << "i64.or";
        break;
      case XorInt64:
        o << "i64.xor";
        break;
      case ShlInt64:
        o << "i64.shl";
        break;
      case ShrUInt64:
        o << "i64.shr_u";
        break;
      case ShrSInt64:
        o << "i64.shr_s";
        break;
      case RotLInt64:
        o << "i64.rotl";
        break;
      case RotRInt64:
        o << "i64.rotr";
        break;
      case EqInt64:
        o << "i64.eq";
        break;
      case NeInt64:
        o << "i64.ne";
        break;
      case LtSInt64:
        o << "i64.lt_s";
        break;
      case LtUInt64:
        o << "i64.lt_u";
        break;
      case LeSInt64:
        o << "i64.le_s";
        break;
      case LeUInt64:
        o << "i64.le_u";
        break;
      case GtSInt64:
        o << "i64.gt_s";
        break;
      case GtUInt64:
        o << "i64.gt_u";
        break;
      case GeSInt64:
        o << "i64.ge_s";
        break;
      case GeUInt64:
        o << "i64.ge_u";
        break;

      case AddFloat32:
        o << "f32.add";
        break;
      case SubFloat32:
        o << "f32.sub";
        break;
      case MulFloat32:
        o << "f32.mul";
        break;
      case DivFloat32:
        o << "f32.div";
        break;
      case CopySignFloat32:
        o << "f32.copysign";
        break;
      case MinFloat32:
        o << "f32.min";
        break;
      case MaxFloat32:
        o << "f32.max";
        break;
      case EqFloat32:
        o << "f32.eq";
        break;
      case NeFloat32:
        o << "f32.ne";
        break;
      case LtFloat32:
        o << "f32.lt";
        break;
      case LeFloat32:
        o << "f32.le";
        break;
      case GtFloat32:
        o << "f32.gt";
        break;
      case GeFloat32:
        o << "f32.ge";
        break;

      case AddFloat64:
        o << "f64.add";
        break;
      case SubFloat64:
        o << "f64.sub";
        break;
      case MulFloat64:
        o << "f64.mul";
        break;
      case DivFloat64:
        o << "f64.div";
        break;
      case CopySignFloat64:
        o << "f64.copysign";
        break;
      case MinFloat64:
        o << "f64.min";
        break;
      case MaxFloat64:
        o << "f64.max";
        break;
      case EqFloat64:
        o << "f64.eq";
        break;
      case NeFloat64:
        o << "f64.ne";
        break;
      case LtFloat64:
        o << "f64.lt";
        break;
      case LeFloat64:
        o << "f64.le";
        break;
      case GtFloat64:
        o << "f64.gt";
        break;
      case GeFloat64:
        o << "f64.ge";
        break;

      case EqVecI8x16:
        o << "i8x16.eq";
        break;
      case NeVecI8x16:
        o << "i8x16.ne";
        break;
      case LtSVecI8x16:
        o << "i8x16.lt_s";
        break;
      case LtUVecI8x16:
        o << "i8x16.lt_u";
        break;
      case GtSVecI8x16:
        o << "i8x16.gt_s";
        break;
      case GtUVecI8x16:
        o << "i8x16.gt_u";
        break;
      case LeSVecI8x16:
        o << "i8x16.le_s";
        break;
      case LeUVecI8x16:
        o << "i8x16.le_u";
        break;
      case GeSVecI8x16:
        o << "i8x16.ge_s";
        break;
      case GeUVecI8x16:
        o << "i8x16.ge_u";
        break;
      case EqVecI16x8:
        o << "i16x8.eq";
        break;
      case NeVecI16x8:
        o << "i16x8.ne";
        break;
      case LtSVecI16x8:
        o << "i16x8.lt_s";
        break;
      case LtUVecI16x8:
        o << "i16x8.lt_u";
        break;
      case GtSVecI16x8:
        o << "i16x8.gt_s";
        break;
      case GtUVecI16x8:
        o << "i16x8.gt_u";
        break;
      case LeSVecI16x8:
        o << "i16x8.le_s";
        break;
      case LeUVecI16x8:
        o << "i16x8.le_u";
        break;
      case GeSVecI16x8:
        o << "i16x8.ge_s";
        break;
      case GeUVecI16x8:
        o << "i16x8.ge_u";
        break;
      case EqVecI32x4:
        o << "i32x4.eq";
        break;
      case NeVecI32x4:
        o << "i32x4.ne";
        break;
      case LtSVecI32x4:
        o << "i32x4.lt_s";
        break;
      case LtUVecI32x4:
        o << "i32x4.lt_u";
        break;
      case GtSVecI32x4:
        o << "i32x4.gt_s";
        break;
      case GtUVecI32x4:
        o << "i32x4.gt_u";
        break;
      case LeSVecI32x4:
        o << "i32x4.le_s";
        break;
      case LeUVecI32x4:
        o << "i32x4.le_u";
        break;
      case GeSVecI32x4:
        o << "i32x4.ge_s";
        break;
      case GeUVecI32x4:
        o << "i32x4.ge_u";
        break;
      case EqVecI64x2:
        o << "i64x2.eq";
        break;
      case EqVecF32x4:
        o << "f32x4.eq";
        break;
      case NeVecF32x4:
        o << "f32x4.ne";
        break;
      case LtVecF32x4:
        o << "f32x4.lt";
        break;
      case GtVecF32x4:
        o << "f32x4.gt";
        break;
      case LeVecF32x4:
        o << "f32x4.le";
        break;
      case GeVecF32x4:
        o << "f32x4.ge";
        break;
      case EqVecF64x2:
        o << "f64x2.eq";
        break;
      case NeVecF64x2:
        o << "f64x2.ne";
        break;
      case LtVecF64x2:
        o << "f64x2.lt";
        break;
      case GtVecF64x2:
        o << "f64x2.gt";
        break;
      case LeVecF64x2:
        o << "f64x2.le";
        break;
      case GeVecF64x2:
        o << "f64x2.ge";
        break;

      case AndVec128:
        o << "v128.and";
        break;
      case OrVec128:
        o << "v128.or";
        break;
      case XorVec128:
        o << "v128.xor";
        break;
      case AndNotVec128:
        o << "v128.andnot";
        break;

      case AddVecI8x16:
        o << "i8x16.add";
        break;
      case AddSatSVecI8x16:
        o << "i8x16.add_saturate_s";
        break;
      case AddSatUVecI8x16:
        o << "i8x16.add_saturate_u";
        break;
      case SubVecI8x16:
        o << "i8x16.sub";
        break;
      case SubSatSVecI8x16:
        o << "i8x16.sub_saturate_s";
        break;
      case SubSatUVecI8x16:
        o << "i8x16.sub_saturate_u";
        break;
      case MulVecI8x16:
        o << "i8x16.mul";
        break;
      case MinSVecI8x16:
        o << "i8x16.min_s";
        break;
      case MinUVecI8x16:
        o << "i8x16.min_u";
        break;
      case MaxSVecI8x16:
        o << "i8x16.max_s";
        break;
      case MaxUVecI8x16:
        o << "i8x16.max_u";
        break;
      case AvgrUVecI8x16:
        o << "i8x16.avgr_u";
        break;
      case AddVecI16x8:
        o << "i16x8.add";
        break;
      case AddSatSVecI16x8:
        o << "i16x8.add_saturate_s";
        break;
      case AddSatUVecI16x8:
        o << "i16x8.add_saturate_u";
        break;
      case SubVecI16x8:
        o << "i16x8.sub";
        break;
      case SubSatSVecI16x8:
        o << "i16x8.sub_saturate_s";
        break;
      case SubSatUVecI16x8:
        o << "i16x8.sub_saturate_u";
        break;
      case MulVecI16x8:
        o << "i16x8.mul";
        break;
      case MinSVecI16x8:
        o << "i16x8.min_s";
        break;
      case MinUVecI16x8:
        o << "i16x8.min_u";
        break;
      case MaxSVecI16x8:
        o << "i16x8.max_s";
        break;
      case MaxUVecI16x8:
        o << "i16x8.max_u";
        break;
      case AvgrUVecI16x8:
        o << "i16x8.avgr_u";
        break;
      case Q15MulrSatSVecI16x8:
        o << "i16x8.q15mulr_sat_s";
        break;
      case ExtMulLowSVecI16x8:
        o << "i16x8.extmul_low_i8x16_s";
        break;
      case ExtMulHighSVecI16x8:
        o << "i16x8.extmul_high_i8x16_s";
        break;
      case ExtMulLowUVecI16x8:
        o << "i16x8.extmul_low_i8x16_u";
        break;
      case ExtMulHighUVecI16x8:
        o << "i16x8.extmul_high_i8x16_u";
        break;

      case AddVecI32x4:
        o << "i32x4.add";
        break;
      case SubVecI32x4:
        o << "i32x4.sub";
        break;
      case MulVecI32x4:
        o << "i32x4.mul";
        break;
      case MinSVecI32x4:
        o << "i32x4.min_s";
        break;
      case MinUVecI32x4:
        o << "i32x4.min_u";
        break;
      case MaxSVecI32x4:
        o << "i32x4.max_s";
        break;
      case MaxUVecI32x4:
        o << "i32x4.max_u";
        break;
      case DotSVecI16x8ToVecI32x4:
        o << "i32x4.dot_i16x8_s";
        break;
      case ExtMulLowSVecI32x4:
        o << "i32x4.extmul_low_i16x8_s";
        break;
      case ExtMulHighSVecI32x4:
        o << "i32x4.extmul_high_i16x8_s";
        break;
      case ExtMulLowUVecI32x4:
        o << "i32x4.extmul_low_i16x8_u";
        break;
      case ExtMulHighUVecI32x4:
        o << "i32x4.extmul_high_i16x8_u";
        break;

      case AddVecI64x2:
        o << "i64x2.add";
        break;
      case SubVecI64x2:
        o << "i64x2.sub";
        break;
      case MulVecI64x2:
        o << "i64x2.mul";
        break;
      case ExtMulLowSVecI64x2:
        o << "i64x2.extmul_low_i32x4_s";
        break;
      case ExtMulHighSVecI64x2:
        o << "i64x2.extmul_high_i32x4_s";
        break;
      case ExtMulLowUVecI64x2:
        o << "i64x2.extmul_low_i32x4_u";
        break;
      case ExtMulHighUVecI64x2:
        o << "i64x2.extmul_high_i32x4_u";
        break;

      case AddVecF32x4:
        o << "f32x4.add";
        break;
      case SubVecF32x4:
        o << "f32x4.sub";
        break;
      case MulVecF32x4:
        o << "f32x4.mul";
        break;
      case DivVecF32x4:
        o << "f32x4.div";
        break;
      case MinVecF32x4:
        o << "f32x4.min";
        break;
      case MaxVecF32x4:
        o << "f32x4.max";
        break;
      case PMinVecF32x4:
        o << "f32x4.pmin";
        break;
      case PMaxVecF32x4:
        o << "f32x4.pmax";
        break;
      case AddVecF64x2:
        o << "f64x2.add";
        break;
      case SubVecF64x2:
        o << "f64x2.sub";
        break;
      case MulVecF64x2:
        o << "f64x2.mul";
        break;
      case DivVecF64x2:
        o << "f64x2.div";
        break;
      case MinVecF64x2:
        o << "f64x2.min";
        break;
      case MaxVecF64x2:
        o << "f64x2.max";
        break;
      case PMinVecF64x2:
        o << "f64x2.pmin";
        break;
      case PMaxVecF64x2:
        o << "f64x2.pmax";
        break;

      case NarrowSVecI16x8ToVecI8x16:
        o << "i8x16.narrow_i16x8_s";
        break;
      case NarrowUVecI16x8ToVecI8x16:
        o << "i8x16.narrow_i16x8_u";
        break;
      case NarrowSVecI32x4ToVecI16x8:
        o << "i16x8.narrow_i32x4_s";
        break;
      case NarrowUVecI32x4ToVecI16x8:
        o << "i16x8.narrow_i32x4_u";
        break;

      case SwizzleVec8x16:
        o << "v8x16.swizzle";
        break;

      case InvalidBinary:
        WASM_UNREACHABLE("unvalid binary operator");
    }
    restoreNormalColor(o);
  }
  void visitSelect(Select* curr) {
    prepareColor(o) << "select";
    if (curr->type.isRef()) {
      o << ' ' << ResultTypeName(curr->type);
    }
  }
  void visitDrop(Drop* curr) { printMedium(o, "drop"); }
  void visitReturn(Return* curr) { printMedium(o, "return"); }
  void visitMemorySize(MemorySize* curr) { printMedium(o, "memory.size"); }
  void visitMemoryGrow(MemoryGrow* curr) { printMedium(o, "memory.grow"); }
  void visitRefNull(RefNull* curr) {
    printMedium(o, "ref.null ");
    printHeapTypeName(o, curr->type.getHeapType());
  }
  void visitRefIs(RefIs* curr) {
    switch (curr->op) {
      case RefIsNull:
        printMedium(o, "ref.is_null");
        break;
      case RefIsFunc:
        printMedium(o, "ref.is_func");
        break;
      case RefIsData:
        printMedium(o, "ref.is_data");
        break;
      case RefIsI31:
        printMedium(o, "ref.is_i31");
        break;
      default:
        WASM_UNREACHABLE("unimplemented ref.is_*");
    }
  }
  void visitRefFunc(RefFunc* curr) {
    printMedium(o, "ref.func ");
    printName(curr->func, o);
  }
  void visitRefEq(RefEq* curr) { printMedium(o, "ref.eq"); }
  void visitTry(Try* curr) {
    printMedium(o, "try");
    if (curr->type.isConcrete()) {
      o << ' ' << ResultType(curr->type);
    }
  }
  void visitThrow(Throw* curr) {
    printMedium(o, "throw ");
    printName(curr->event, o);
  }
  void visitRethrow(Rethrow* curr) {
    printMedium(o, "rethrow ");
    o << curr->depth;
  }
  void visitNop(Nop* curr) { printMinor(o, "nop"); }
  void visitUnreachable(Unreachable* curr) { printMinor(o, "unreachable"); }
  void visitPop(Pop* curr) {
    prepareColor(o) << "pop";
    for (auto type : curr->type) {
      assert(type.isBasic() && "TODO: print and parse compound types");
      o << " " << type;
    }
    restoreNormalColor(o);
  }
  void visitTupleMake(TupleMake* curr) { printMedium(o, "tuple.make"); }
  void visitTupleExtract(TupleExtract* curr) {
    printMedium(o, "tuple.extract ");
    o << curr->index;
  }
  void visitI31New(I31New* curr) { printMedium(o, "i31.new"); }
  void visitI31Get(I31Get* curr) {
    printMedium(o, curr->signed_ ? "i31.get_s" : "i31.get_u");
  }
  void visitCallRef(CallRef* curr) {
    if (curr->isReturn) {
      printMedium(o, "return_call_ref");
    } else {
      printMedium(o, "call_ref");
    }
  }
  void visitRefTest(RefTest* curr) {
    printMedium(o, "ref.test ");
    printHeapTypeName(o, curr->getCastType().getHeapType());
  }
  void visitRefCast(RefCast* curr) {
    printMedium(o, "ref.cast ");
    printHeapTypeName(o, curr->getCastType().getHeapType());
  }
  void visitBrOn(BrOn* curr) {
    switch (curr->op) {
      case BrOnNull:
        printMedium(o, "br_on_null ");
        break;
      case BrOnCast:
        printMedium(o, "br_on_cast ");
        break;
      case BrOnFunc:
        printMedium(o, "br_on_func ");
        break;
      case BrOnData:
        printMedium(o, "br_on_data ");
        break;
      case BrOnI31:
        printMedium(o, "br_on_i31 ");
        break;
      default:
        WASM_UNREACHABLE("invalid ref.is_*");
    }
    printName(curr->name, o);
  }
  void visitRttCanon(RttCanon* curr) {
    printMedium(o, "rtt.canon ");
    printHeapTypeName(o, curr->type.getRtt().heapType);
  }
  void visitRttSub(RttSub* curr) {
    printMedium(o, "rtt.sub ");
    printHeapTypeName(o, curr->type.getRtt().heapType);
  }
  void visitStructNew(StructNew* curr) {
    printMedium(o, "struct.new_");
    if (curr->isWithDefault()) {
      o << "default_";
    }
    o << "with_rtt ";
    printHeapTypeName(o, curr->rtt->type.getHeapType());
  }
  void visitStructGet(StructGet* curr) {
    const auto& field =
      curr->ref->type.getHeapType().getStruct().fields[curr->index];
    if (field.type == Type::i32 && field.packedType != Field::not_packed) {
      if (curr->signed_) {
        printMedium(o, "struct.get_s ");
      } else {
        printMedium(o, "struct.get_u ");
      }
    } else {
      printMedium(o, "struct.get ");
    }
    printHeapTypeName(o, curr->ref->type.getHeapType());
    o << ' ';
    o << curr->index;
  }
  void visitStructSet(StructSet* curr) {
    printMedium(o, "struct.set ");
    printHeapTypeName(o, curr->ref->type.getHeapType());
    o << ' ';
    o << curr->index;
  }
  void visitArrayNew(ArrayNew* curr) {
    printMedium(o, "array.new_");
    if (curr->isWithDefault()) {
      o << "default_";
    }
    o << "with_rtt ";
    printHeapTypeName(o, curr->rtt->type.getHeapType());
  }
  void visitArrayGet(ArrayGet* curr) {
    const auto& element = curr->ref->type.getHeapType().getArray().element;
    if (element.type == Type::i32 && element.packedType != Field::not_packed) {
      if (curr->signed_) {
        printMedium(o, "array.get_s ");
      } else {
        printMedium(o, "array.get_u ");
      }
    } else {
      printMedium(o, "array.get ");
    }
    printHeapTypeName(o, curr->ref->type.getHeapType());
  }
  void visitArraySet(ArraySet* curr) {
    printMedium(o, "array.set ");
    printHeapTypeName(o, curr->ref->type.getHeapType());
  }
  void visitArrayLen(ArrayLen* curr) {
    printMedium(o, "array.len ");
    printHeapTypeName(o, curr->ref->type.getHeapType());
  }
  void visitRefAs(RefAs* curr) {
    switch (curr->op) {
      case RefAsNonNull:
        printMedium(o, "ref.as_non_null");
        break;
      case RefAsFunc:
        printMedium(o, "ref.as_func");
        break;
      case RefAsData:
        printMedium(o, "ref.as_data");
        break;
      case RefAsI31:
        printMedium(o, "ref.as_i31");
        break;
      default:
        WASM_UNREACHABLE("invalid ref.is_*");
    }
  }
};

// Prints an expression in s-expr format, including both the
// internal contents and the nested children.
struct PrintSExpression : public OverriddenVisitor<PrintSExpression> {
  std::ostream& o;
  unsigned indent = 0;

  bool minify;
  const char* maybeSpace;
  const char* maybeNewLine;

  bool full = false; // whether to not elide nodes in output when possible
                     // (like implicit blocks) and to emit types
  bool stackIR = false; // whether to print stack IR if it is present
                        // (if false, and Stack IR is there, we just
                        // note it exists)

  Module* currModule = nullptr;
  Function* currFunction = nullptr;
  Function::DebugLocation lastPrintedLocation;
  bool debugInfo;

  PrintSExpression(std::ostream& o) : o(o) {
    setMinify(false);
    if (!full) {
      full = isFullForced();
    }
  }

  void printDebugLocation(const Function::DebugLocation& location) {
    if (lastPrintedLocation == location) {
      return;
    }
    lastPrintedLocation = location;
    auto fileName = currModule->debugInfoFileNames[location.fileIndex];
    o << ";;@ " << fileName << ":" << location.lineNumber << ":"
      << location.columnNumber << '\n';
    doIndent(o, indent);
  }

  void printDebugLocation(Expression* curr) {
    if (currFunction) {
      // show an annotation, if there is one
      auto& debugLocations = currFunction->debugLocations;
      auto iter = debugLocations.find(curr);
      if (iter != debugLocations.end()) {
        printDebugLocation(iter->second);
      }
      // show a binary position, if there is one
      if (debugInfo) {
        auto iter = currFunction->expressionLocations.find(curr);
        if (iter != currFunction->expressionLocations.end()) {
          Colors::grey(o);
          o << ";; code offset: 0x" << std::hex << iter->second.start
            << std::dec << '\n';
          restoreNormalColor(o);
          doIndent(o, indent);
        }
      }
    }
  }

  // Prints debug info for a delimiter in an expression.
  void printDebugDelimiterLocation(Expression* curr, Index i) {
    if (currFunction && debugInfo) {
      auto iter = currFunction->delimiterLocations.find(curr);
      if (iter != currFunction->delimiterLocations.end()) {
        auto& locations = iter->second;
        Colors::grey(o);
        o << ";; code offset: 0x" << std::hex << locations[i] << std::dec
          << '\n';
        restoreNormalColor(o);
        doIndent(o, indent);
      }
    }
  }

  void printExpressionContents(Expression* curr) {
    if (currModule) {
      PrintExpressionContents(currFunction, currModule->features, o)
        .visit(curr);
    } else {
      PrintExpressionContents(currFunction, o).visit(curr);
    }
  }

  void visit(Expression* curr) {
    printDebugLocation(curr);
    OverriddenVisitor<PrintSExpression>::visit(curr);
  }

  void setMinify(bool minify_) {
    minify = minify_;
    maybeSpace = minify ? "" : " ";
    maybeNewLine = minify ? "" : "\n";
  }

  void setFull(bool full_) { full = full_; }

  void setStackIR(bool stackIR_) { stackIR = stackIR_; }

  void setDebugInfo(bool debugInfo_) { debugInfo = debugInfo_; }

  void incIndent() {
    if (minify) {
      return;
    }
    o << '\n';
    indent++;
  }
  void decIndent() {
    if (!minify) {
      assert(indent > 0);
      indent--;
      doIndent(o, indent);
    }
    o << ')';
  }
  void printFullLine(Expression* expression) {
    if (!minify) {
      doIndent(o, indent);
    }
    if (full) {
      o << "[" << expression->type << "] ";
    }
    visit(expression);
    o << maybeNewLine;
  }

  // loop, if, and try can contain implicit blocks. But they are not needed to
  // be printed in some cases.
  void maybePrintImplicitBlock(Expression* curr, bool allowMultipleInsts) {
    auto block = curr->dynCast<Block>();
    if (!full && block && block->name.isNull() &&
        (allowMultipleInsts || block->list.size() == 1)) {
      for (auto expression : block->list) {
        printFullLine(expression);
      }
    } else {
      printFullLine(curr);
    }
  }

  void visitBlock(Block* curr) {
    // special-case Block, because Block nesting (in their first element) can be
    // incredibly deep
    std::vector<Block*> stack;
    while (1) {
      if (stack.size() > 0) {
        doIndent(o, indent);
        printDebugLocation(curr);
      }
      stack.push_back(curr);
      if (full) {
        o << "[" << curr->type << "] ";
      }
      o << '(';
      printExpressionContents(curr);
      incIndent();
      if (curr->list.size() > 0 && curr->list[0]->is<Block>()) {
        // recurse into the first element
        curr = curr->list[0]->cast<Block>();
        continue;
      } else {
        break; // that's all we can recurse, start to unwind
      }
    }
    auto* top = stack.back();
    while (stack.size() > 0) {
      curr = stack.back();
      stack.pop_back();
      auto& list = curr->list;
      for (size_t i = 0; i < list.size(); i++) {
        if (curr != top && i == 0) {
          // one of the block recursions we already handled
          decIndent();
          if (full) {
            o << " ;; end block";
            auto* child = list[0]->cast<Block>();
            if (child->name.is()) {
              o << ' ' << child->name;
            }
          }
          o << '\n';
          continue;
        }
        printFullLine(list[i]);
      }
    }
    decIndent();
    if (full) {
      o << " ;; end block";
      if (curr->name.is()) {
        o << ' ' << curr->name;
      }
    }
  }
  void visitIf(If* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->condition);
    maybePrintImplicitBlock(curr->ifTrue, false);
    if (curr->ifFalse) {
      // Note: debug info here is not used as LLVM does not emit ifs, and since
      // LLVM is the main source of DWARF, effectively we never encounter ifs
      // with DWARF.
      printDebugDelimiterLocation(curr, BinaryLocations::Else);
      maybePrintImplicitBlock(curr->ifFalse, false);
    }
    decIndent();
    if (full) {
      o << " ;; end if";
    }
  }
  void visitLoop(Loop* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    maybePrintImplicitBlock(curr->body, true);
    decIndent();
    if (full) {
      o << " ;; end loop";
      if (curr->name.is()) {
        o << ' ' << curr->name;
      }
    }
  }
  void visitBreak(Break* curr) {
    o << '(';
    printExpressionContents(curr);
    if (curr->condition) {
      incIndent();
    } else {
      if (!curr->value || curr->value->is<Nop>()) {
        // avoid a new line just for the parens
        o << ')';
        return;
      }
      incIndent();
    }
    if (curr->value && !curr->value->is<Nop>()) {
      printFullLine(curr->value);
    }
    if (curr->condition) {
      printFullLine(curr->condition);
    }
    decIndent();
  }
  void visitSwitch(Switch* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    if (curr->value && !curr->value->is<Nop>()) {
      printFullLine(curr->value);
    }
    printFullLine(curr->condition);
    decIndent();
  }

  template<typename CallBase> void printCallOperands(CallBase* curr) {
    if (curr->operands.size() > 0) {
      incIndent();
      for (auto operand : curr->operands) {
        printFullLine(operand);
      }
      decIndent();
    } else {
      o << ')';
    }
  }

  void visitCall(Call* curr) {
    o << '(';
    printExpressionContents(curr);
    printCallOperands(curr);
  }
  void visitCallIndirect(CallIndirect* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    for (auto operand : curr->operands) {
      printFullLine(operand);
    }
    printFullLine(curr->target);
    decIndent();
  }
  void visitLocalGet(LocalGet* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitLocalSet(LocalSet* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitGlobalGet(GlobalGet* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitGlobalSet(GlobalSet* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitLoad(Load* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ptr);
    decIndent();
  }
  void visitStore(Store* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->value);
    decIndent();
  }
  void visitAtomicRMW(AtomicRMW* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->value);
    decIndent();
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->expected);
    printFullLine(curr->replacement);
    decIndent();
  }
  void visitAtomicWait(AtomicWait* curr) {
    o << '(';
    printExpressionContents(curr);
    restoreNormalColor(o);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->expected);
    printFullLine(curr->timeout);
    decIndent();
  }
  void visitAtomicNotify(AtomicNotify* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->notifyCount);
    decIndent();
  }
  void visitAtomicFence(AtomicFence* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitSIMDExtract(SIMDExtract* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->vec);
    decIndent();
  }
  void visitSIMDReplace(SIMDReplace* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->vec);
    printFullLine(curr->value);
    decIndent();
  }
  void visitSIMDShuffle(SIMDShuffle* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->left);
    printFullLine(curr->right);
    decIndent();
  }
  void visitSIMDTernary(SIMDTernary* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->a);
    printFullLine(curr->b);
    printFullLine(curr->c);
    decIndent();
  }
  void visitSIMDShift(SIMDShift* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->vec);
    printFullLine(curr->shift);
    decIndent();
  }
  void visitSIMDLoad(SIMDLoad* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ptr);
    decIndent();
  }
  void visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->vec);
    decIndent();
  }
  void visitSIMDWiden(SIMDWiden* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->vec);
    decIndent();
  }
  void visitPrefetch(Prefetch* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ptr);
    decIndent();
  }
  void visitMemoryInit(MemoryInit* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->dest);
    printFullLine(curr->offset);
    printFullLine(curr->size);
    decIndent();
  }
  void visitDataDrop(DataDrop* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitMemoryCopy(MemoryCopy* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->dest);
    printFullLine(curr->source);
    printFullLine(curr->size);
    decIndent();
  }
  void visitMemoryFill(MemoryFill* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->dest);
    printFullLine(curr->value);
    printFullLine(curr->size);
    decIndent();
  }
  void visitConst(Const* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitUnary(Unary* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitBinary(Binary* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->left);
    printFullLine(curr->right);
    decIndent();
  }
  void visitSelect(Select* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ifTrue);
    printFullLine(curr->ifFalse);
    printFullLine(curr->condition);
    decIndent();
  }
  void visitDrop(Drop* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitReturn(Return* curr) {
    o << '(';
    printExpressionContents(curr);
    if (!curr->value) {
      // avoid a new line just for the parens
      o << ')';
      return;
    }
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitMemorySize(MemorySize* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitMemoryGrow(MemoryGrow* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->delta);
    decIndent();
  }
  void visitRefNull(RefNull* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitRefIs(RefIs* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitRefFunc(RefFunc* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitRefEq(RefEq* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->left);
    printFullLine(curr->right);
    decIndent();
  }
  // try-catch-end is written in the folded wat format as
  // (try
  //  (do
  //   ...
  //  )
  //  (catch
  //   ...
  //  )
  // )
  // The parenthesis wrapping 'catch' is just a syntax and does not affect
  // nested depths of instructions within.
  void visitTry(Try* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    doIndent(o, indent);
    o << '(';
    printMedium(o, "do");
    incIndent();
    maybePrintImplicitBlock(curr->body, true);
    decIndent();
    o << "\n";
    for (size_t i = 0; i < curr->catchEvents.size(); i++) {
      doIndent(o, indent);
      printDebugDelimiterLocation(curr, i);
      o << '(';
      printMedium(o, "catch ");
      printName(curr->catchEvents[i], o);
      incIndent();
      maybePrintImplicitBlock(curr->catchBodies[i], true);
      decIndent();
      o << "\n";
    }
    if (curr->hasCatchAll()) {
      doIndent(o, indent);
      printDebugDelimiterLocation(curr, curr->catchEvents.size());
      o << "(catch_all";
      incIndent();
      maybePrintImplicitBlock(curr->catchBodies.back(), true);
      decIndent();
      o << "\n";
    }
    decIndent();
    if (full) {
      o << " ;; end try";
    }
  }
  void visitThrow(Throw* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    for (auto operand : curr->operands) {
      printFullLine(operand);
    }
    decIndent();
  }
  void visitRethrow(Rethrow* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitNop(Nop* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitUnreachable(Unreachable* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitPop(Pop* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitTupleMake(TupleMake* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    for (auto operand : curr->operands) {
      printFullLine(operand);
    }
    decIndent();
  }
  void visitTupleExtract(TupleExtract* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->tuple);
    decIndent();
  }
  void visitI31New(I31New* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitI31Get(I31Get* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->i31);
    decIndent();
  }
  void visitCallRef(CallRef* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    for (auto operand : curr->operands) {
      printFullLine(operand);
    }
    printFullLine(curr->target);
    decIndent();
  }
  void visitRefTest(RefTest* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ref);
    printFullLine(curr->rtt);
    decIndent();
  }
  void visitRefCast(RefCast* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ref);
    printFullLine(curr->rtt);
    decIndent();
  }
  void visitBrOn(BrOn* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ref);
    if (curr->rtt) {
      printFullLine(curr->rtt);
    }
    decIndent();
  }
  void visitRttCanon(RttCanon* curr) {
    o << '(';
    printExpressionContents(curr);
    o << ')';
  }
  void visitRttSub(RttSub* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->parent);
    decIndent();
  }
  void visitStructNew(StructNew* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->rtt);
    for (auto& operand : curr->operands) {
      printFullLine(operand);
    }
    decIndent();
  }
  void visitStructGet(StructGet* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ref);
    decIndent();
  }
  void visitStructSet(StructSet* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ref);
    printFullLine(curr->value);
    decIndent();
  }
  void visitArrayNew(ArrayNew* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->rtt);
    printFullLine(curr->size);
    if (curr->init) {
      printFullLine(curr->init);
    }
    decIndent();
  }
  void visitArrayGet(ArrayGet* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ref);
    printFullLine(curr->index);
    decIndent();
  }
  void visitArraySet(ArraySet* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ref);
    printFullLine(curr->index);
    printFullLine(curr->value);
    decIndent();
  }
  void visitArrayLen(ArrayLen* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->ref);
    decIndent();
  }
  void visitRefAs(RefAs* curr) {
    o << '(';
    printExpressionContents(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  // Module-level visitors
  void handleSignature(Signature curr, Name name = Name()) {
    o << "(func";
    if (name.is()) {
      o << " $" << name;
    }
    if (curr.params.size() > 0) {
      o << maybeSpace;
      o << "(param ";
      auto sep = "";
      for (auto type : curr.params) {
        o << sep << SExprType(type);
        sep = " ";
      }
      o << ')';
    }
    if (curr.results.size() > 0) {
      o << maybeSpace;
      o << "(result ";
      auto sep = "";
      for (auto type : curr.results) {
        o << sep << SExprType(type);
        sep = " ";
      }
      o << ')';
    }
    o << ")";
  }
  void handleFieldBody(const Field& field) {
    if (field.mutable_) {
      o << "(mut ";
    }
    if (field.type == Type::i32 && field.packedType != Field::not_packed) {
      if (field.packedType == Field::i8) {
        o << "i8";
      } else if (field.packedType == Field::i16) {
        o << "i16";
      } else {
        WASM_UNREACHABLE("invalid packed type");
      }
    } else {
      o << SExprType(field.type);
    }
    if (field.mutable_) {
      o << ')';
    }
  }
  void handleArray(const Array& curr) {
    o << "(array ";
    handleFieldBody(curr.element);
    o << ')';
  }
  void handleStruct(const Struct& curr) {
    o << "(struct ";
    auto sep = "";
    for (auto field : curr.fields) {
      o << sep << "(field ";
      handleFieldBody(field);
      o << ')';
      sep = " ";
    }
    o << ')';
  }
  void handleHeapType(HeapType type) {
    if (type.isSignature()) {
      handleSignature(type.getSignature());
    } else if (type.isArray()) {
      handleArray(type.getArray());
    } else if (type.isStruct()) {
      handleStruct(type.getStruct());
    } else {
      o << type;
    }
  }
  void visitExport(Export* curr) {
    o << '(';
    printMedium(o, "export ");
    printText(o, curr->name.str) << " (";
    switch (curr->kind) {
      case ExternalKind::Function:
        o << "func";
        break;
      case ExternalKind::Table:
        o << "table";
        break;
      case ExternalKind::Memory:
        o << "memory";
        break;
      case ExternalKind::Global:
        o << "global";
        break;
      case ExternalKind::Event:
        o << "event";
        break;
      case ExternalKind::Invalid:
        WASM_UNREACHABLE("invalid ExternalKind");
    }
    o << ' ';
    printName(curr->value, o) << "))";
  }
  void emitImportHeader(Importable* curr) {
    printMedium(o, "import ");
    printText(o, curr->module.str) << ' ';
    printText(o, curr->base.str) << ' ';
  }
  void visitGlobal(Global* curr) {
    if (curr->imported()) {
      visitImportedGlobal(curr);
    } else {
      visitDefinedGlobal(curr);
    }
  }
  void emitGlobalType(Global* curr) {
    if (curr->mutable_) {
      o << "(mut " << SExprType(curr->type) << ')';
    } else {
      o << SExprType(curr->type);
    }
  }
  void visitImportedGlobal(Global* curr) {
    doIndent(o, indent);
    o << '(';
    emitImportHeader(curr);
    o << "(global ";
    printName(curr->name, o) << ' ';
    emitGlobalType(curr);
    o << "))" << maybeNewLine;
  }
  void visitDefinedGlobal(Global* curr) {
    doIndent(o, indent);
    o << '(';
    printMedium(o, "global ");
    printName(curr->name, o) << ' ';
    emitGlobalType(curr);
    o << ' ';
    visit(curr->init);
    o << ')';
    o << maybeNewLine;
  }
  void visitFunction(Function* curr) {
    if (curr->imported()) {
      visitImportedFunction(curr);
    } else {
      visitDefinedFunction(curr);
    }
  }
  void visitImportedFunction(Function* curr) {
    doIndent(o, indent);
    currFunction = curr;
    lastPrintedLocation = {0, 0, 0};
    o << '(';
    emitImportHeader(curr);
    handleSignature(curr->sig, curr->name);
    o << ')';
    o << maybeNewLine;
  }
  void visitDefinedFunction(Function* curr) {
    doIndent(o, indent);
    currFunction = curr;
    lastPrintedLocation = {0, 0, 0};
    if (currFunction->prologLocation.size()) {
      printDebugLocation(*currFunction->prologLocation.begin());
    }
    o << '(';
    printMajor(o, "func ");
    printName(curr->name, o);
    if (!stackIR && curr->stackIR && !minify) {
      o << " (; has Stack IR ;)";
    }
    if (curr->sig.params.size() > 0) {
      Index i = 0;
      for (const auto& param : curr->sig.params) {
        o << maybeSpace;
        o << '(';
        printMinor(o, "param ");
        printLocal(i, currFunction, o);
        o << ' ' << SExprType(param) << ')';
        ++i;
      }
    }
    if (curr->sig.results != Type::none) {
      o << maybeSpace;
      o << ResultTypeName(curr->sig.results);
    }
    incIndent();
    for (size_t i = curr->getVarIndexBase(); i < curr->getNumLocals(); i++) {
      doIndent(o, indent);
      o << '(';
      printMinor(o, "local ");
      printLocal(i, currFunction, o)
        << ' ' << SExprType(curr->getLocalType(i)) << ')';
      o << maybeNewLine;
    }
    // Print the body.
    if (!stackIR || !curr->stackIR) {
      // It is ok to emit a block here, as a function can directly contain a
      // list, even if our ast avoids that for simplicity. We can just do that
      // optimization here..
      if (!full && curr->body->is<Block>() &&
          curr->body->cast<Block>()->name.isNull()) {
        Block* block = curr->body->cast<Block>();
        for (auto item : block->list) {
          printFullLine(item);
        }
      } else {
        printFullLine(curr->body);
      }
    } else {
      // Print the stack IR.
      printStackIR(curr->stackIR.get(), o, curr);
    }
    if (currFunction->epilogLocation.size() &&
        lastPrintedLocation != *currFunction->epilogLocation.begin()) {
      // Print last debug location: mix of decIndent and printDebugLocation
      // logic.
      doIndent(o, indent);
      if (!minify) {
        indent--;
      }
      printDebugLocation(*currFunction->epilogLocation.begin());
      o << ')';
    } else {
      decIndent();
    }
    o << maybeNewLine;
  }
  void visitEvent(Event* curr) {
    if (curr->imported()) {
      visitImportedEvent(curr);
    } else {
      visitDefinedEvent(curr);
    }
  }
  void visitImportedEvent(Event* curr) {
    doIndent(o, indent);
    o << '(';
    emitImportHeader(curr);
    o << "(event ";
    printName(curr->name, o);
    o << maybeSpace << "(attr " << curr->attribute << ')' << maybeSpace;
    o << ParamType(curr->sig.params);
    o << "))";
    o << maybeNewLine;
  }
  void visitDefinedEvent(Event* curr) {
    doIndent(o, indent);
    o << '(';
    printMedium(o, "event ");
    printName(curr->name, o);
    o << maybeSpace << "(attr " << curr->attribute << ')' << maybeSpace;
    o << ParamType(curr->sig.params);
    o << ")" << maybeNewLine;
  }
  void printTableHeader(Table* curr) {
    o << '(';
    printMedium(o, "table") << ' ';
    printName(curr->name, o) << ' ';
    o << curr->initial;
    if (curr->hasMax()) {
      o << ' ' << curr->max;
    }
    o << " funcref)";
  }
  void visitTable(Table* curr) {
    if (!curr->exists) {
      return;
    }
    if (curr->imported()) {
      doIndent(o, indent);
      o << '(';
      emitImportHeader(curr);
      printTableHeader(&currModule->table);
      o << ')' << maybeNewLine;
    } else {
      doIndent(o, indent);
      printTableHeader(curr);
      o << maybeNewLine;
    }
    for (auto& segment : curr->segments) {
      // Don't print empty segments
      if (segment.data.empty()) {
        continue;
      }
      doIndent(o, indent);
      o << '(';
      printMajor(o, "elem ");
      visit(segment.offset);
      for (auto name : segment.data) {
        o << ' ';
        printName(name, o);
      }
      o << ')' << maybeNewLine;
    }
  }
  void printMemoryHeader(Memory* curr) {
    o << '(';
    printMedium(o, "memory") << ' ';
    printName(curr->name, o) << ' ';
    if (curr->shared) {
      o << '(';
      printMedium(o, "shared ");
    }
    if (curr->is64()) {
      o << "i64 ";
    }
    o << curr->initial;
    if (curr->hasMax()) {
      o << ' ' << curr->max;
    }
    if (curr->shared) {
      o << ")";
    }
    o << ")";
  }
  void visitMemory(Memory* curr) {
    if (!curr->exists) {
      return;
    }
    if (curr->imported()) {
      doIndent(o, indent);
      o << '(';
      emitImportHeader(curr);
      printMemoryHeader(&currModule->memory);
      o << ')' << maybeNewLine;
    } else {
      doIndent(o, indent);
      printMemoryHeader(curr);
      o << '\n';
    }
    for (auto segment : curr->segments) {
      doIndent(o, indent);
      o << '(';
      printMajor(o, "data ");
      if (segment.name.is()) {
        printName(segment.name, o);
        o << ' ';
      }
      if (segment.isPassive) {
        printMedium(o, "passive");
      } else {
        visit(segment.offset);
      }
      o << " \"";
      for (size_t i = 0; i < segment.data.size(); i++) {
        unsigned char c = segment.data[i];
        switch (c) {
          case '\n':
            o << "\\n";
            break;
          case '\r':
            o << "\\0d";
            break;
          case '\t':
            o << "\\t";
            break;
          case '\f':
            o << "\\0c";
            break;
          case '\b':
            o << "\\08";
            break;
          case '\\':
            o << "\\\\";
            break;
          case '"':
            o << "\\\"";
            break;
          case '\'':
            o << "\\'";
            break;
          default: {
            if (c >= 32 && c < 127) {
              o << c;
            } else {
              o << std::hex << '\\' << (c / 16) << (c % 16) << std::dec;
            }
          }
        }
      }
      o << "\")" << maybeNewLine;
    }
  }
  void printDylinkSection(const std::unique_ptr<DylinkSection>& dylinkSection) {
    doIndent(o, indent) << ";; dylink section\n";
    doIndent(o, indent) << ";;   memorysize: " << dylinkSection->memorySize
                        << '\n';
    doIndent(o, indent) << ";;   memoryalignment: "
                        << dylinkSection->memoryAlignment << '\n';
    doIndent(o, indent) << ";;   tablesize: " << dylinkSection->tableSize
                        << '\n';
    doIndent(o, indent) << ";;   tablealignment: "
                        << dylinkSection->tableAlignment << '\n';
    for (auto& neededDynlib : dylinkSection->neededDynlibs) {
      doIndent(o, indent) << ";;   needed dynlib: " << neededDynlib << '\n';
    }
  }
  void visitModule(Module* curr) {
    currModule = curr;
    o << '(';
    printMajor(o, "module");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    incIndent();
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> indices;
    ModuleUtils::collectHeapTypes(*curr, types, indices);
    for (auto type : types) {
      doIndent(o, indent);
      o << '(';
      printMedium(o, "type") << ' ';
      printHeapTypeName(o, type);
      o << ' ';
      handleHeapType(type);
      o << ")" << maybeNewLine;
    }
    ModuleUtils::iterImportedMemories(
      *curr, [&](Memory* memory) { visitMemory(memory); });
    ModuleUtils::iterImportedTables(*curr,
                                    [&](Table* table) { visitTable(table); });
    ModuleUtils::iterImportedGlobals(
      *curr, [&](Global* global) { visitGlobal(global); });
    ModuleUtils::iterImportedFunctions(
      *curr, [&](Function* func) { visitFunction(func); });
    ModuleUtils::iterImportedEvents(*curr,
                                    [&](Event* event) { visitEvent(event); });
    ModuleUtils::iterDefinedMemories(
      *curr, [&](Memory* memory) { visitMemory(memory); });
    ModuleUtils::iterDefinedTables(*curr,
                                   [&](Table* table) { visitTable(table); });
    ModuleUtils::iterDefinedGlobals(
      *curr, [&](Global* global) { visitGlobal(global); });
    ModuleUtils::iterDefinedEvents(*curr,
                                   [&](Event* event) { visitEvent(event); });
    for (auto& child : curr->exports) {
      doIndent(o, indent);
      visitExport(child.get());
      o << maybeNewLine;
    }
    if (curr->start.is()) {
      doIndent(o, indent);
      o << '(';
      printMedium(o, "start") << ' ';
      printName(curr->start, o) << ')';
      o << maybeNewLine;
    }
    ModuleUtils::iterDefinedFunctions(
      *curr, [&](Function* func) { visitFunction(func); });
    if (curr->dylinkSection) {
      printDylinkSection(curr->dylinkSection);
    }
    for (auto& section : curr->userSections) {
      doIndent(o, indent);
      o << ";; custom section \"" << section.name << "\", size "
        << section.data.size();
      bool isPrintable = true;
      for (auto c : section.data) {
        if (!isprint(static_cast<unsigned char>(c))) {
          isPrintable = false;
          break;
        }
      }
      if (isPrintable) {
        o << ", contents: ";
        // std::quoted is not available in all the supported compilers yet.
        o << '"';
        for (auto c : section.data) {
          if (c == '\\' || c == '"') {
            o << '\\';
          }
          o << c;
        }
        o << '"';
      }
      o << maybeNewLine;
    }
    decIndent();
    o << maybeNewLine;
    currModule = nullptr;
  }
};

// Prints out a module
class Printer : public Pass {
protected:
  std::ostream& o;

public:
  Printer() : o(std::cout) {}
  Printer(std::ostream* o) : o(*o) {}

  bool modifiesBinaryenIR() override { return false; }

  void run(PassRunner* runner, Module* module) override {
    PrintSExpression print(o);
    print.setDebugInfo(runner->options.debugInfo);
    print.visitModule(module);
  }
};

Pass* createPrinterPass() { return new Printer(); }

// Prints out a minified module

class MinifiedPrinter : public Printer {
public:
  MinifiedPrinter() = default;
  MinifiedPrinter(std::ostream* o) : Printer(o) {}

  void run(PassRunner* runner, Module* module) override {
    PrintSExpression print(o);
    print.setMinify(true);
    print.setDebugInfo(runner->options.debugInfo);
    print.visitModule(module);
  }
};

Pass* createMinifiedPrinterPass() { return new MinifiedPrinter(); }

// Prints out a module withough elision, i.e., the full ast

class FullPrinter : public Printer {
public:
  FullPrinter() = default;
  FullPrinter(std::ostream* o) : Printer(o) {}

  void run(PassRunner* runner, Module* module) override {
    PrintSExpression print(o);
    print.setFull(true);
    print.setDebugInfo(runner->options.debugInfo);
    print.visitModule(module);
  }
};

Pass* createFullPrinterPass() { return new FullPrinter(); }

// Print Stack IR (if present)

class PrintStackIR : public Printer {
public:
  PrintStackIR() = default;
  PrintStackIR(std::ostream* o) : Printer(o) {}

  void run(PassRunner* runner, Module* module) override {
    PrintSExpression print(o);
    print.setDebugInfo(runner->options.debugInfo);
    print.setStackIR(true);
    print.visitModule(module);
  }
};

Pass* createPrintStackIRPass() { return new PrintStackIR(); }

static std::ostream& printExpression(Expression* expression,
                                     std::ostream& o,
                                     bool minify,
                                     bool full) {
  if (!expression) {
    o << "(null expression)";
    return o;
  }
  PrintSExpression print(o);
  print.setMinify(minify);
  if (full || isFullForced()) {
    print.setFull(true);
    o << "[" << expression->type << "] ";
  }
  print.visit(expression);
  return o;
}

static std::ostream&
printStackInst(StackInst* inst, std::ostream& o, Function* func) {
  switch (inst->op) {
    case StackInst::Basic:
    case StackInst::BlockBegin:
    case StackInst::IfBegin:
    case StackInst::LoopBegin:
    case StackInst::TryBegin: {
      PrintExpressionContents(func, o).visit(inst->origin);
      break;
    }
    case StackInst::BlockEnd:
    case StackInst::IfEnd:
    case StackInst::LoopEnd:
    case StackInst::TryEnd: {
      printMedium(o, "end");
      o << " ;; type: ";
      printTypeName(o, inst->type);
      break;
    }
    case StackInst::IfElse: {
      printMedium(o, "else");
      break;
    }
    case StackInst::Catch: {
      // Because StackInst does not have info on which catch within a try this
      // is, we can't print the event name.
      printMedium(o, "catch");
      break;
    }
    case StackInst::CatchAll: {
      printMedium(o, "catch_all");
      break;
    }
    default:
      WASM_UNREACHABLE("unexpeted op");
  }
  return o;
}

static std::ostream&
printStackIR(StackIR* ir, std::ostream& o, Function* func) {
  size_t indent = func ? 2 : 0;
  auto doIndent = [&indent, &o]() {
    for (size_t j = 0; j < indent; j++) {
      o << ' ';
    }
  };

  // Stack to track indices of catches within a try
  SmallVector<Index, 4> catchIndexStack;
  for (Index i = 0; i < (*ir).size(); i++) {
    auto* inst = (*ir)[i];
    if (!inst) {
      continue;
    }
    switch (inst->op) {
      case StackInst::Basic: {
        doIndent();
        // Pop is a pseudo instruction and should not be printed in the stack IR
        // format to make it valid wat form.
        if (inst->origin->is<Pop>()) {
          break;
        }
        PrintExpressionContents(func, o).visit(inst->origin);
        break;
      }
      case StackInst::TryBegin:
        catchIndexStack.push_back(0);
        // fallthrough
      case StackInst::BlockBegin:
      case StackInst::IfBegin:
      case StackInst::LoopBegin: {
        doIndent();
        PrintExpressionContents(func, o).visit(inst->origin);
        indent++;
        break;
      }
      case StackInst::TryEnd:
        catchIndexStack.pop_back();
        // fallthrough
      case StackInst::BlockEnd:
      case StackInst::IfEnd:
      case StackInst::LoopEnd: {
        indent--;
        doIndent();
        printMedium(o, "end");
        break;
      }
      case StackInst::IfElse: {
        indent--;
        doIndent();
        printMedium(o, "else");
        indent++;
        break;
      }
      case StackInst::Catch: {
        indent--;
        doIndent();
        printMedium(o, "catch ");
        Try* curr = inst->origin->cast<Try>();
        printName(curr->catchEvents[catchIndexStack.back()++], o);
        indent++;
        break;
      }
      case StackInst::CatchAll: {
        indent--;
        doIndent();
        printMedium(o, "catch_all");
        indent++;
        break;
      }
      default:
        WASM_UNREACHABLE("unexpeted op");
    }
    std::cout << '\n';
  }
  return o;
}

} // namespace wasm

namespace std {

std::ostream& operator<<(std::ostream& o, wasm::Module& module) {
  wasm::PassRunner runner(&module);
  wasm::Printer(&o).run(&runner, &module);
  return o;
}

std::ostream& operator<<(std::ostream& o, wasm::Expression& expression) {
  return wasm::printExpression(&expression, o);
}

std::ostream& operator<<(std::ostream& o, wasm::Expression* expression) {
  return wasm::printExpression(expression, o);
}

std::ostream& operator<<(std::ostream& o, wasm::StackInst& inst) {
  return wasm::printStackInst(&inst, o);
}

std::ostream& operator<<(std::ostream& o, wasm::StackIR& ir) {
  return wasm::printStackIR(&ir, o);
}

} // namespace std
