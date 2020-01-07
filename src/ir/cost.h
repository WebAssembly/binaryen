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

#ifndef wasm_ir_cost_h
#define wasm_ir_cost_h

#include <wasm-traversal.h>
#include <wasm.h>

namespace wasm {

// Measure the execution cost of an AST. Very handwave-ey

struct CostAnalyzer : public Visitor<CostAnalyzer, Index> {
  CostAnalyzer(Expression* ast) { cost = visit(ast); }

  Index cost;

  Index maybeVisit(Expression* curr) { return curr ? visit(curr) : 0; }

  Index visitBlock(Block* curr) {
    Index ret = 0;
    for (auto* child : curr->list) {
      ret += visit(child);
    }
    return ret;
  }
  Index visitIf(If* curr) {
    return 1 + visit(curr->condition) +
           std::max(visit(curr->ifTrue), maybeVisit(curr->ifFalse));
  }
  Index visitLoop(Loop* curr) { return 5 * visit(curr->body); }
  Index visitBreak(Break* curr) {
    return 1 + maybeVisit(curr->value) + maybeVisit(curr->condition);
  }
  Index visitSwitch(Switch* curr) {
    return 2 + visit(curr->condition) + maybeVisit(curr->value);
  }
  Index visitCall(Call* curr) {
    // XXX this does not take into account if the call is to an import, which
    //     may be costlier in general
    Index ret = 4;
    for (auto* child : curr->operands) {
      ret += visit(child);
    }
    return ret;
  }
  Index visitCallIndirect(CallIndirect* curr) {
    Index ret = 6 + visit(curr->target);
    for (auto* child : curr->operands) {
      ret += visit(child);
    }
    return ret;
  }
  Index visitLocalGet(LocalGet* curr) { return 0; }
  Index visitLocalSet(LocalSet* curr) { return 1; }
  Index visitGlobalGet(GlobalGet* curr) { return 1; }
  Index visitGlobalSet(GlobalSet* curr) { return 2; }
  Index visitLoad(Load* curr) {
    return 1 + visit(curr->ptr) + 10 * curr->isAtomic;
  }
  Index visitStore(Store* curr) {
    return 2 + visit(curr->ptr) + visit(curr->value) + 10 * curr->isAtomic;
  }
  Index visitAtomicRMW(AtomicRMW* curr) { return 100; }
  Index visitAtomicCmpxchg(AtomicCmpxchg* curr) { return 100; }
  Index visitConst(Const* curr) { return 1; }
  Index visitUnary(Unary* curr) {
    Index ret = 0;
    switch (curr->op) {
      case ClzInt32:
      case CtzInt32:
      case PopcntInt32:
      case NegFloat32:
      case AbsFloat32:
      case CeilFloat32:
      case FloorFloat32:
      case TruncFloat32:
      case NearestFloat32:
      case ClzInt64:
      case CtzInt64:
      case PopcntInt64:
      case NegFloat64:
      case AbsFloat64:
      case CeilFloat64:
      case FloorFloat64:
      case TruncFloat64:
      case NearestFloat64:
      case EqZInt32:
      case EqZInt64:
      case ExtendSInt32:
      case ExtendUInt32:
      case WrapInt64:
      case PromoteFloat32:
      case DemoteFloat64:
      case TruncSFloat32ToInt32:
      case TruncUFloat32ToInt32:
      case TruncSFloat64ToInt32:
      case TruncUFloat64ToInt32:
      case ReinterpretFloat32:
      case TruncSFloat32ToInt64:
      case TruncUFloat32ToInt64:
      case TruncSFloat64ToInt64:
      case TruncUFloat64ToInt64:
      case ReinterpretFloat64:
      case ReinterpretInt32:
      case ConvertSInt32ToFloat32:
      case ConvertUInt32ToFloat32:
      case ConvertSInt64ToFloat32:
      case ConvertUInt64ToFloat32:
      case ReinterpretInt64:
      case ConvertSInt32ToFloat64:
      case ConvertUInt32ToFloat64:
      case ConvertSInt64ToFloat64:
      case ConvertUInt64ToFloat64:
      case ExtendS8Int32:
      case ExtendS16Int32:
      case ExtendS8Int64:
      case ExtendS16Int64:
      case ExtendS32Int64:
      case TruncSatSFloat32ToInt32:
      case TruncSatUFloat32ToInt32:
      case TruncSatSFloat64ToInt32:
      case TruncSatUFloat64ToInt32:
      case TruncSatSFloat32ToInt64:
      case TruncSatUFloat32ToInt64:
      case TruncSatSFloat64ToInt64:
      case TruncSatUFloat64ToInt64:
        ret = 1;
        break;
      case SqrtFloat32:
      case SqrtFloat64:
        ret = 2;
        break;
      case SplatVecI8x16:
      case SplatVecI16x8:
      case SplatVecI32x4:
      case SplatVecI64x2:
      case SplatVecF32x4:
      case SplatVecF64x2:
      case NotVec128:
      case NegVecI8x16:
      case AnyTrueVecI8x16:
      case AllTrueVecI8x16:
      case NegVecI16x8:
      case AnyTrueVecI16x8:
      case AllTrueVecI16x8:
      case NegVecI32x4:
      case AnyTrueVecI32x4:
      case AllTrueVecI32x4:
      case NegVecI64x2:
      case AnyTrueVecI64x2:
      case AllTrueVecI64x2:
      case AbsVecF32x4:
      case NegVecF32x4:
      case SqrtVecF32x4:
      case AbsVecF64x2:
      case NegVecF64x2:
      case SqrtVecF64x2:
      case TruncSatSVecF32x4ToVecI32x4:
      case TruncSatUVecF32x4ToVecI32x4:
      case TruncSatSVecF64x2ToVecI64x2:
      case TruncSatUVecF64x2ToVecI64x2:
      case ConvertSVecI32x4ToVecF32x4:
      case ConvertUVecI32x4ToVecF32x4:
      case ConvertSVecI64x2ToVecF64x2:
      case ConvertUVecI64x2ToVecF64x2:
      case WidenLowSVecI8x16ToVecI16x8:
      case WidenHighSVecI8x16ToVecI16x8:
      case WidenLowUVecI8x16ToVecI16x8:
      case WidenHighUVecI8x16ToVecI16x8:
      case WidenLowSVecI16x8ToVecI32x4:
      case WidenHighSVecI16x8ToVecI32x4:
      case WidenLowUVecI16x8ToVecI32x4:
      case WidenHighUVecI16x8ToVecI32x4:
        return 1;
      case InvalidUnary:
        WASM_UNREACHABLE("invalid unary op");
    }
    return ret + visit(curr->value);
  }
  Index visitBinary(Binary* curr) {
    Index ret = 0;
    switch (curr->op) {
      case AddInt32:
        ret = 1;
        break;
      case SubInt32:
        ret = 1;
        break;
      case MulInt32:
        ret = 2;
        break;
      case DivSInt32:
        ret = 3;
        break;
      case DivUInt32:
        ret = 3;
        break;
      case RemSInt32:
        ret = 3;
        break;
      case RemUInt32:
        ret = 3;
        break;
      case AndInt32:
        ret = 1;
        break;
      case OrInt32:
        ret = 1;
        break;
      case XorInt32:
        ret = 1;
        break;
      case ShlInt32:
        ret = 1;
        break;
      case ShrUInt32:
        ret = 1;
        break;
      case ShrSInt32:
        ret = 1;
        break;
      case RotLInt32:
        ret = 1;
        break;
      case RotRInt32:
        ret = 1;
        break;
      case AddInt64:
        ret = 1;
        break;
      case SubInt64:
        ret = 1;
        break;
      case MulInt64:
        ret = 2;
        break;
      case DivSInt64:
        ret = 3;
        break;
      case DivUInt64:
        ret = 3;
        break;
      case RemSInt64:
        ret = 3;
        break;
      case RemUInt64:
        ret = 3;
        break;
      case AndInt64:
        ret = 1;
        break;
      case OrInt64:
        ret = 1;
        break;
      case XorInt64:
        ret = 1;
        break;
      case ShlInt64:
        ret = 1;
        break;
      case ShrUInt64:
        ret = 1;
        break;
      case ShrSInt64:
        ret = 1;
        break;
      case RotLInt64:
        ret = 1;
        break;
      case RotRInt64:
        ret = 1;
        break;
      case AddFloat32:
        ret = 1;
        break;
      case SubFloat32:
        ret = 1;
        break;
      case MulFloat32:
        ret = 2;
        break;
      case DivFloat32:
        ret = 3;
        break;
      case CopySignFloat32:
        ret = 1;
        break;
      case MinFloat32:
        ret = 1;
        break;
      case MaxFloat32:
        ret = 1;
        break;
      case AddFloat64:
        ret = 1;
        break;
      case SubFloat64:
        ret = 1;
        break;
      case MulFloat64:
        ret = 2;
        break;
      case DivFloat64:
        ret = 3;
        break;
      case CopySignFloat64:
        ret = 1;
        break;
      case MinFloat64:
        ret = 1;
        break;
      case MaxFloat64:
        ret = 1;
        break;
      case LtUInt32:
        ret = 1;
        break;
      case LtSInt32:
        ret = 1;
        break;
      case LeUInt32:
        ret = 1;
        break;
      case LeSInt32:
        ret = 1;
        break;
      case GtUInt32:
        ret = 1;
        break;
      case GtSInt32:
        ret = 1;
        break;
      case GeUInt32:
        ret = 1;
        break;
      case GeSInt32:
        ret = 1;
        break;
      case LtUInt64:
        ret = 1;
        break;
      case LtSInt64:
        ret = 1;
        break;
      case LeUInt64:
        ret = 1;
        break;
      case LeSInt64:
        ret = 1;
        break;
      case GtUInt64:
        ret = 1;
        break;
      case GtSInt64:
        ret = 1;
        break;
      case GeUInt64:
        ret = 1;
        break;
      case GeSInt64:
        ret = 1;
        break;
      case LtFloat32:
        ret = 1;
        break;
      case GtFloat32:
        ret = 1;
        break;
      case LeFloat32:
        ret = 1;
        break;
      case GeFloat32:
        ret = 1;
        break;
      case LtFloat64:
        ret = 1;
        break;
      case GtFloat64:
        ret = 1;
        break;
      case LeFloat64:
        ret = 1;
        break;
      case GeFloat64:
        ret = 1;
        break;
      case EqInt32:
        ret = 1;
        break;
      case NeInt32:
        ret = 1;
        break;
      case EqInt64:
        ret = 1;
        break;
      case NeInt64:
        ret = 1;
        break;
      case EqFloat32:
        ret = 1;
        break;
      case NeFloat32:
        ret = 1;
        break;
      case EqFloat64:
        ret = 1;
        break;
      case NeFloat64:
        ret = 1;
        break;
      case EqVecI8x16:
        ret = 1;
        break;
      case NeVecI8x16:
        ret = 1;
        break;
      case LtSVecI8x16:
        ret = 1;
        break;
      case LtUVecI8x16:
        ret = 1;
        break;
      case LeSVecI8x16:
        ret = 1;
        break;
      case LeUVecI8x16:
        ret = 1;
        break;
      case GtSVecI8x16:
        ret = 1;
        break;
      case GtUVecI8x16:
        ret = 1;
        break;
      case GeSVecI8x16:
        ret = 1;
        break;
      case GeUVecI8x16:
        ret = 1;
        break;
      case EqVecI16x8:
        ret = 1;
        break;
      case NeVecI16x8:
        ret = 1;
        break;
      case LtSVecI16x8:
        ret = 1;
        break;
      case LtUVecI16x8:
        ret = 1;
        break;
      case LeSVecI16x8:
        ret = 1;
        break;
      case LeUVecI16x8:
        ret = 1;
        break;
      case GtSVecI16x8:
        ret = 1;
        break;
      case GtUVecI16x8:
        ret = 1;
        break;
      case GeSVecI16x8:
        ret = 1;
        break;
      case GeUVecI16x8:
        ret = 1;
        break;
      case EqVecI32x4:
        ret = 1;
        break;
      case NeVecI32x4:
        ret = 1;
        break;
      case LtSVecI32x4:
        ret = 1;
        break;
      case LtUVecI32x4:
        ret = 1;
        break;
      case LeSVecI32x4:
        ret = 1;
        break;
      case LeUVecI32x4:
        ret = 1;
        break;
      case GtSVecI32x4:
        ret = 1;
        break;
      case GtUVecI32x4:
        ret = 1;
        break;
      case GeSVecI32x4:
        ret = 1;
        break;
      case GeUVecI32x4:
        ret = 1;
        break;
      case EqVecF32x4:
        ret = 1;
        break;
      case NeVecF32x4:
        ret = 1;
        break;
      case LtVecF32x4:
        ret = 1;
        break;
      case LeVecF32x4:
        ret = 1;
        break;
      case GtVecF32x4:
        ret = 1;
        break;
      case GeVecF32x4:
        ret = 1;
        break;
      case EqVecF64x2:
        ret = 1;
        break;
      case NeVecF64x2:
        ret = 1;
        break;
      case LtVecF64x2:
        ret = 1;
        break;
      case LeVecF64x2:
        ret = 1;
        break;
      case GtVecF64x2:
        ret = 1;
        break;
      case GeVecF64x2:
        ret = 1;
        break;
      case AndVec128:
        ret = 1;
        break;
      case OrVec128:
        ret = 1;
        break;
      case XorVec128:
        ret = 1;
        break;
      case AndNotVec128:
        ret = 1;
        break;
      case AddVecI8x16:
        ret = 1;
        break;
      case AddSatSVecI8x16:
        ret = 1;
        break;
      case AddSatUVecI8x16:
        ret = 1;
        break;
      case SubVecI8x16:
        ret = 1;
        break;
      case SubSatSVecI8x16:
        ret = 1;
        break;
      case SubSatUVecI8x16:
        ret = 1;
        break;
      case MulVecI8x16:
        ret = 2;
        break;
      case MinSVecI8x16:
        ret = 1;
        break;
      case MinUVecI8x16:
        ret = 1;
        break;
      case MaxSVecI8x16:
        ret = 1;
        break;
      case MaxUVecI8x16:
        ret = 1;
        break;
      case AvgrUVecI8x16:
        ret = 1;
        break;
      case AddVecI16x8:
        ret = 1;
        break;
      case AddSatSVecI16x8:
        ret = 1;
        break;
      case AddSatUVecI16x8:
        ret = 1;
        break;
      case SubVecI16x8:
        ret = 1;
        break;
      case SubSatSVecI16x8:
        ret = 1;
        break;
      case SubSatUVecI16x8:
        ret = 1;
        break;
      case MulVecI16x8:
        ret = 2;
        break;
      case MinSVecI16x8:
        ret = 1;
        break;
      case MinUVecI16x8:
        ret = 1;
        break;
      case MaxSVecI16x8:
        ret = 1;
        break;
      case MaxUVecI16x8:
        ret = 1;
        break;
      case AvgrUVecI16x8:
        ret = 1;
        break;
      case AddVecI32x4:
        ret = 1;
        break;
      case SubVecI32x4:
        ret = 1;
        break;
      case MulVecI32x4:
        ret = 2;
        break;
      case MinSVecI32x4:
        ret = 1;
        break;
      case MinUVecI32x4:
        ret = 1;
        break;
      case MaxSVecI32x4:
        ret = 1;
        break;
      case MaxUVecI32x4:
        ret = 1;
        break;
      case DotSVecI16x8ToVecI32x4:
        ret = 1;
        break;
      case AddVecI64x2:
        ret = 1;
        break;
      case SubVecI64x2:
        ret = 1;
        break;
      case AddVecF32x4:
        ret = 1;
        break;
      case SubVecF32x4:
        ret = 1;
        break;
      case MulVecF32x4:
        ret = 2;
        break;
      case DivVecF32x4:
        ret = 3;
        break;
      case MinVecF32x4:
        ret = 1;
        break;
      case MaxVecF32x4:
        ret = 1;
        break;
      case AddVecF64x2:
        ret = 1;
        break;
      case SubVecF64x2:
        ret = 1;
        break;
      case MulVecF64x2:
        ret = 2;
        break;
      case DivVecF64x2:
        ret = 3;
        break;
      case MinVecF64x2:
        ret = 1;
        break;
      case MaxVecF64x2:
        ret = 1;
        break;
      case NarrowSVecI16x8ToVecI8x16:
        ret = 1;
        break;
      case NarrowUVecI16x8ToVecI8x16:
        ret = 1;
        break;
      case NarrowSVecI32x4ToVecI16x8:
        ret = 1;
        break;
      case NarrowUVecI32x4ToVecI16x8:
        ret = 1;
        break;
      case SwizzleVec8x16:
        ret = 1;
        break;
      case InvalidBinary:
        WASM_UNREACHABLE("invalid binary op");
    }
    return ret + visit(curr->left) + visit(curr->right);
  }
  Index visitSelect(Select* curr) {
    return 2 + visit(curr->condition) + visit(curr->ifTrue) +
           visit(curr->ifFalse);
  }
  Index visitDrop(Drop* curr) { return visit(curr->value); }
  Index visitReturn(Return* curr) { return maybeVisit(curr->value); }
  Index visitHost(Host* curr) { return 100; }
  Index visitNop(Nop* curr) { return 0; }
  Index visitUnreachable(Unreachable* curr) { return 0; }
};

} // namespace wasm

#endif // wasm_ir_cost_h
