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
#include <wasm-printing.h>
#include <wasm-stack.h>
#include <wasm.h>

namespace wasm {

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

// Wrapper for printing signature names
struct SigName {
  Signature sig;
  SigName(Signature sig) : sig(sig) {}
};

std::ostream& operator<<(std::ostream& os, SigName sigName) {
  auto printType = [&](Type type) {
    if (type == Type::none) {
      os << "none";
    } else {
      const std::vector<Type>& types = type.expand();
      for (size_t i = 0; i < types.size(); ++i) {
        if (i != 0) {
          os << '_';
        }
        os << types[i];
      }
    }
  };

  os << '$';
  printType(sigName.sig.params);
  os << "_=>_";
  printType(sigName.sig.results);
  return os;
}

} // anonymous namespace

// Printing "unreachable" as a instruction prefix type is not valid in wasm text
// format. Print something else to make it pass.
static Type forceConcrete(Type type) { return type.isConcrete() ? type : i32; }

// Prints the internal contents of an expression: everything but
// the children.
struct PrintExpressionContents
  : public OverriddenVisitor<PrintExpressionContents> {
  Function* currFunction = nullptr;
  std::ostream& o;

  PrintExpressionContents(Function* currFunction, std::ostream& o)
    : currFunction(currFunction), o(o) {}

  void visitBlock(Block* curr) {
    printMedium(o, "block");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    if (curr->type.isConcrete()) {
      o << ' ' << ResultType(curr->type);
    }
  }
  void visitIf(If* curr) {
    printMedium(o, "if");
    if (curr->type.isConcrete()) {
      o << ' ' << ResultType(curr->type);
    }
  }
  void visitLoop(Loop* curr) {
    printMedium(o, "loop");
    if (curr->name.is()) {
      o << ' ';
      printName(curr->name, o);
    }
    if (curr->type.isConcrete()) {
      o << ' ' << ResultType(curr->type);
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
    o << SigName(curr->sig) << ')';
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
    if (curr->type != unreachable && curr->bytes < getTypeSize(curr->type)) {
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
    if (curr->bytes < 4 || (curr->valueType == i64 && curr->bytes < 8)) {
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
    if (type != unreachable && bytes != getTypeSize(type)) {
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
      case Add:
        o << "add";
        break;
      case Sub:
        o << "sub";
        break;
      case And:
        o << "and";
        break;
      case Or:
        o << "or";
        break;
      case Xor:
        o << "xor";
        break;
      case Xchg:
        o << "xchg";
        break;
    }
    if (curr->type != unreachable && curr->bytes != getTypeSize(curr->type)) {
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
    if (curr->type != unreachable && curr->bytes != getTypeSize(curr->type)) {
      o << "_u";
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicWait(AtomicWait* curr) {
    prepareColor(o);
    o << forceConcrete(curr->expectedType) << ".atomic.wait";
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
  }
  void visitAtomicNotify(AtomicNotify* curr) {
    printMedium(o, "atomic.notify");
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
    }
    restoreNormalColor(o);
    if (curr->offset) {
      o << " offset=" << curr->offset;
    }
    if (curr->align != curr->getMemBytes()) {
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
      case NegVecI8x16:
        o << "i8x16.neg";
        break;
      case AnyTrueVecI8x16:
        o << "i8x16.any_true";
        break;
      case AllTrueVecI8x16:
        o << "i8x16.all_true";
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
      case NegVecI32x4:
        o << "i32x4.neg";
        break;
      case AnyTrueVecI32x4:
        o << "i32x4.any_true";
        break;
      case AllTrueVecI32x4:
        o << "i32x4.all_true";
        break;
      case NegVecI64x2:
        o << "i64x2.neg";
        break;
      case AnyTrueVecI64x2:
        o << "i64x2.any_true";
        break;
      case AllTrueVecI64x2:
        o << "i64x2.all_true";
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
      case AbsVecF64x2:
        o << "f64x2.abs";
        break;
      case NegVecF64x2:
        o << "f64x2.neg";
        break;
      case SqrtVecF64x2:
        o << "f64x2.sqrt";
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
      case AddVecI64x2:
        o << "i64x2.add";
        break;
      case SubVecI64x2:
        o << "i64x2.sub";
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
  void visitSelect(Select* curr) { prepareColor(o) << "select"; }
  void visitDrop(Drop* curr) { printMedium(o, "drop"); }
  void visitReturn(Return* curr) { printMedium(o, "return"); }
  void visitHost(Host* curr) {
    switch (curr->op) {
      case MemorySize:
        printMedium(o, "memory.size");
        break;
      case MemoryGrow:
        printMedium(o, "memory.grow");
        break;
    }
  }
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
  void visitRethrow(Rethrow* curr) { printMedium(o, "rethrow"); }
  void visitBrOnExn(BrOnExn* curr) {
    printMedium(o, "br_on_exn ");
    printName(curr->name, o);
    o << " ";
    printName(curr->event, o);
  }
  void visitNop(Nop* curr) { printMinor(o, "nop"); }
  void visitUnreachable(Unreachable* curr) { printMinor(o, "unreachable"); }
  void visitPush(Push* curr) { prepareColor(o) << "push"; }
  void visitPop(Pop* curr) {
    prepareColor(o) << curr->type;
    o << ".pop";
    restoreNormalColor(o);
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
  bool printStackIR = false; // whether to print stack IR if it is present
                             // (if false, and Stack IR is there, we just
                             // note it exists)

  Module* currModule = nullptr;
  Function* currFunction = nullptr;
  Function::DebugLocation lastPrintedLocation;
  bool debugInfo;

  std::unordered_map<Name, Index> functionIndexes;

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
        auto iter = currFunction->binaryLocations.find(curr);
        if (iter != currFunction->binaryLocations.end()) {
          Colors::grey(o);
          o << ";; code offset: 0x" << iter->second << '\n';
          restoreNormalColor(o);
          doIndent(o, indent);
        }
      }
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

  void setPrintStackIR(bool printStackIR_) { printStackIR = printStackIR_; }

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
    !minify && doIndent(o, indent);
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
      PrintExpressionContents(currFunction, o).visit(curr);
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
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->condition);
    maybePrintImplicitBlock(curr->ifTrue, false);
    if (curr->ifFalse) {
      maybePrintImplicitBlock(curr->ifFalse, false);
    }
    decIndent();
    if (full) {
      o << " ;; end if";
    }
  }
  void visitLoop(Loop* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
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
    PrintExpressionContents(currFunction, o).visit(curr);
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
    PrintExpressionContents(currFunction, o).visit(curr);
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
    PrintExpressionContents(currFunction, o).visit(curr);
    printCallOperands(curr);
  }
  void visitCallIndirect(CallIndirect* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    for (auto operand : curr->operands) {
      printFullLine(operand);
    }
    printFullLine(curr->target);
    decIndent();
  }
  void visitLocalGet(LocalGet* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    o << ')';
  }
  void visitLocalSet(LocalSet* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitGlobalGet(GlobalGet* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    o << ')';
  }
  void visitGlobalSet(GlobalSet* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitLoad(Load* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->ptr);
    decIndent();
  }
  void visitStore(Store* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->value);
    decIndent();
  }
  void visitAtomicRMW(AtomicRMW* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->value);
    decIndent();
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->expected);
    printFullLine(curr->replacement);
    decIndent();
  }
  void visitAtomicWait(AtomicWait* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    restoreNormalColor(o);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->expected);
    printFullLine(curr->timeout);
    decIndent();
  }
  void visitAtomicNotify(AtomicNotify* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->ptr);
    printFullLine(curr->notifyCount);
    decIndent();
  }
  void visitAtomicFence(AtomicFence* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    o << ')';
  }
  void visitSIMDExtract(SIMDExtract* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->vec);
    decIndent();
  }
  void visitSIMDReplace(SIMDReplace* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->vec);
    printFullLine(curr->value);
    decIndent();
  }
  void visitSIMDShuffle(SIMDShuffle* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->left);
    printFullLine(curr->right);
    decIndent();
  }
  void visitSIMDTernary(SIMDTernary* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->a);
    printFullLine(curr->b);
    printFullLine(curr->c);
    decIndent();
  }
  void visitSIMDShift(SIMDShift* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->vec);
    printFullLine(curr->shift);
    decIndent();
  }
  void visitSIMDLoad(SIMDLoad* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->ptr);
    decIndent();
  }
  void visitMemoryInit(MemoryInit* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->dest);
    printFullLine(curr->offset);
    printFullLine(curr->size);
    decIndent();
  }
  void visitDataDrop(DataDrop* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    o << ')';
  }
  void visitMemoryCopy(MemoryCopy* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->dest);
    printFullLine(curr->source);
    printFullLine(curr->size);
    decIndent();
  }
  void visitMemoryFill(MemoryFill* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->dest);
    printFullLine(curr->value);
    printFullLine(curr->size);
    decIndent();
  }
  void visitConst(Const* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    o << ')';
  }
  void visitUnary(Unary* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitBinary(Binary* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->left);
    printFullLine(curr->right);
    decIndent();
  }
  void visitSelect(Select* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->ifTrue);
    printFullLine(curr->ifFalse);
    printFullLine(curr->condition);
    decIndent();
  }
  void visitDrop(Drop* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitReturn(Return* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    if (!curr->value) {
      // avoid a new line just for the parens
      o << ')';
      return;
    }
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitHost(Host* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    switch (curr->op) {
      case MemoryGrow: {
        incIndent();
        printFullLine(curr->operands[0]);
        decIndent();
        break;
      }
      case MemorySize: {
        o << ')';
      }
    }
  }
  // try-catch-end is written in the folded wat format as
  // (try
  //   ...
  //  (catch
  //    ...
  //  )
  // )
  // The parenthesis wrapping 'catch' is just a syntax and does not affect
  // nested depths of instructions within.
  void visitTry(Try* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    maybePrintImplicitBlock(curr->body, false);
    doIndent(o, indent);
    o << "(catch";
    incIndent();
    maybePrintImplicitBlock(curr->catchBody, true);
    decIndent();
    o << "\n";
    decIndent();
    if (full) {
      o << " ;; end try";
    }
  }
  void visitThrow(Throw* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    for (auto operand : curr->operands) {
      printFullLine(operand);
    }
    decIndent();
  }
  void visitRethrow(Rethrow* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->exnref);
    decIndent();
  }
  void visitBrOnExn(BrOnExn* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->exnref);
    decIndent();
  }
  void visitNop(Nop* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    o << ')';
  }
  void visitUnreachable(Unreachable* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    o << ')';
  }
  void visitPush(Push* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    incIndent();
    printFullLine(curr->value);
    decIndent();
  }
  void visitPop(Pop* curr) {
    o << '(';
    PrintExpressionContents(currFunction, o).visit(curr);
    o << ')';
  }
  // Module-level visitors
  void handleSignature(Signature curr, Name* funcName = nullptr) {
    o << "(func";
    if (funcName) {
      o << " $" << *funcName;
    }
    if (curr.params.size() > 0) {
      o << maybeSpace;
      o << ParamType(curr.params);
    }
    if (curr.results.size() > 0) {
      o << maybeSpace;
      o << ResultType(curr.results);
    }
    o << ")";
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
      o << "(mut " << curr->type << ')';
    } else {
      o << curr->type;
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
    handleSignature(curr->sig, &curr->name);
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
    if (currModule && !minify) {
      // emit the function index in a comment
      if (functionIndexes.empty()) {
        ModuleUtils::BinaryIndexes indexes(*currModule);
        functionIndexes = std::move(indexes.functionIndexes);
      }
      o << " (; " << functionIndexes[curr->name] << " ;)";
    }
    if (!printStackIR && curr->stackIR && !minify) {
      o << " (; has Stack IR ;)";
    }
    const std::vector<Type>& params = curr->sig.params.expand();
    if (params.size() > 0) {
      for (size_t i = 0; i < params.size(); i++) {
        o << maybeSpace;
        o << '(';
        printMinor(o, "param ");
        printLocal(i, currFunction, o);
        o << ' ' << params[i] << ')';
      }
    }
    if (curr->sig.results != Type::none) {
      o << maybeSpace;
      o << ResultType(curr->sig.results);
    }
    incIndent();
    for (size_t i = curr->getVarIndexBase(); i < curr->getNumLocals(); i++) {
      doIndent(o, indent);
      o << '(';
      printMinor(o, "local ");
      printLocal(i, currFunction, o) << ' ' << curr->getLocalType(i) << ')';
      o << maybeNewLine;
    }
    // Print the body.
    if (!printStackIR || !curr->stackIR) {
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
      WasmPrinter::printStackIR(curr->stackIR.get(), o, curr);
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
  void visitModule(Module* curr) {
    currModule = curr;
    o << '(';
    printMajor(o, "module");
    incIndent();
    std::vector<Signature> signatures;
    std::unordered_map<Signature, Index> indices;
    ModuleUtils::collectSignatures(*curr, signatures, indices);
    for (auto sig : signatures) {
      doIndent(o, indent);
      o << '(';
      printMedium(o, "type") << ' ';
      o << SigName(sig) << ' ';
      handleSignature(sig);
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
    for (auto& section : curr->userSections) {
      doIndent(o, indent);
      o << ";; custom section \"" << section.name << "\", size "
        << section.data.size();
      bool isPrintable = true;
      for (auto c : section.data) {
        if (!isprint(c)) {
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
    print.setPrintStackIR(true);
    print.visitModule(module);
  }
};

Pass* createPrintStackIRPass() { return new PrintStackIR(); }

// Print individual expressions

std::ostream& WasmPrinter::printModule(Module* module, std::ostream& o) {
  PassRunner runner(module);
  Printer(&o).run(&runner, module);
  return o;
}

std::ostream& WasmPrinter::printModule(Module* module) {
  return printModule(module, std::cout);
}

std::ostream& WasmPrinter::printExpression(Expression* expression,
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

std::ostream&
WasmPrinter::printStackInst(StackInst* inst, std::ostream& o, Function* func) {
  switch (inst->op) {
    case StackInst::Basic: {
      PrintExpressionContents(func, o).visit(inst->origin);
      break;
    }
    case StackInst::BlockBegin:
    case StackInst::IfBegin:
    case StackInst::LoopBegin: {
      o << getExpressionName(inst->origin);
      break;
    }
    case StackInst::BlockEnd:
    case StackInst::IfEnd:
    case StackInst::LoopEnd: {
      o << "end (" << inst->type << ')';
      break;
    }
    case StackInst::IfElse: {
      o << "else";
      break;
    }
    default:
      WASM_UNREACHABLE("unexpeted op");
  }
  return o;
}

std::ostream&
WasmPrinter::printStackIR(StackIR* ir, std::ostream& o, Function* func) {
  size_t indent = func ? 2 : 0;
  auto doIndent = [&indent, &o]() {
    for (size_t j = 0; j < indent; j++) {
      o << ' ';
    }
  };
  for (Index i = 0; i < (*ir).size(); i++) {
    auto* inst = (*ir)[i];
    if (!inst) {
      continue;
    }
    switch (inst->op) {
      case StackInst::Basic: {
        doIndent();
        PrintExpressionContents(func, o).visit(inst->origin);
        break;
      }
      case StackInst::BlockBegin:
      case StackInst::IfBegin:
      case StackInst::LoopBegin:
      case StackInst::TryBegin: {
        doIndent();
        PrintExpressionContents(func, o).visit(inst->origin);
        indent++;
        break;
      }
      case StackInst::BlockEnd:
      case StackInst::IfEnd:
      case StackInst::LoopEnd:
      case StackInst::TryEnd: {
        indent--;
        doIndent();
        o << "end";
        break;
      }
      case StackInst::IfElse: {
        indent--;
        doIndent();
        o << "else";
        indent++;
        break;
      }
      case StackInst::Catch: {
        indent--;
        doIndent();
        o << "catch";
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
