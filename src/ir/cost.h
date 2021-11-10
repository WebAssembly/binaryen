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

using CostType = uint32_t;

struct CostAnalyzer : public OverriddenVisitor<CostAnalyzer, CostType> {
  CostAnalyzer(Expression* ast) { cost = visit(ast); }

  CostType cost;

  CostType maybeVisit(Expression* curr) { return curr ? visit(curr) : 0; }

  CostType visitBlock(Block* curr) {
    CostType ret = 0;
    for (auto* child : curr->list) {
      ret += visit(child);
    }
    return ret;
  }
  CostType visitIf(If* curr) {
    return 1 + visit(curr->condition) +
           std::max(visit(curr->ifTrue), maybeVisit(curr->ifFalse));
  }
  CostType visitLoop(Loop* curr) { return 5 * visit(curr->body); }
  CostType visitBreak(Break* curr) {
    return 1 + maybeVisit(curr->value) + maybeVisit(curr->condition);
  }
  CostType visitSwitch(Switch* curr) {
    return 2 + visit(curr->condition) + maybeVisit(curr->value);
  }
  CostType visitCall(Call* curr) {
    // XXX this does not take into account if the call is to an import, which
    //     may be costlier in general
    CostType ret = 4;
    for (auto* child : curr->operands) {
      ret += visit(child);
    }
    return ret;
  }
  CostType visitCallIndirect(CallIndirect* curr) {
    CostType ret = 6 + visit(curr->target);
    for (auto* child : curr->operands) {
      ret += visit(child);
    }
    return ret;
  }
  CostType visitCallRef(CallRef* curr) {
    CostType ret = 5 + visit(curr->target);
    for (auto* child : curr->operands) {
      ret += visit(child);
    }
    return ret;
  }
  CostType visitLocalGet(LocalGet* curr) { return 0; }
  CostType visitLocalSet(LocalSet* curr) { return 1 + visit(curr->value); }
  CostType visitGlobalGet(GlobalGet* curr) { return 1; }
  CostType visitGlobalSet(GlobalSet* curr) { return 2 + visit(curr->value); }
  CostType visitLoad(Load* curr) {
    return 1 + visit(curr->ptr) + 10 * curr->isAtomic;
  }
  CostType visitStore(Store* curr) {
    return 2 + visit(curr->ptr) + visit(curr->value) + 10 * curr->isAtomic;
  }
  CostType visitAtomicRMW(AtomicRMW* curr) {
    return 100 + visit(curr->ptr) + visit(curr->value);
  }
  CostType visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    return 100 + visit(curr->ptr) + visit(curr->expected) +
           visit(curr->replacement);
  }
  CostType visitAtomicWait(AtomicWait* curr) {
    return 100 + visit(curr->ptr) + visit(curr->expected) +
           visit(curr->timeout);
  }
  CostType visitAtomicNotify(AtomicNotify* curr) {
    return 100 + visit(curr->ptr) + visit(curr->notifyCount);
  }
  CostType visitAtomicFence(AtomicFence* curr) { return 100; }
  CostType visitConst(Const* curr) { return 1; }
  CostType visitUnary(Unary* curr) {
    CostType ret = 0;
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
      case AnyTrueVec128:
      case AbsVecI8x16:
      case NegVecI8x16:
      case AllTrueVecI8x16:
      case BitmaskVecI8x16:
      case PopcntVecI8x16:
      case AbsVecI16x8:
      case NegVecI16x8:
      case AllTrueVecI16x8:
      case BitmaskVecI16x8:
      case AbsVecI32x4:
      case NegVecI32x4:
      case AllTrueVecI32x4:
      case BitmaskVecI32x4:
      case AbsVecI64x2:
      case NegVecI64x2:
      case AllTrueVecI64x2:
      case BitmaskVecI64x2:
      case AbsVecF32x4:
      case NegVecF32x4:
      case SqrtVecF32x4:
      case CeilVecF32x4:
      case FloorVecF32x4:
      case TruncVecF32x4:
      case NearestVecF32x4:
      case AbsVecF64x2:
      case NegVecF64x2:
      case SqrtVecF64x2:
      case CeilVecF64x2:
      case FloorVecF64x2:
      case TruncVecF64x2:
      case NearestVecF64x2:
      case ExtAddPairwiseSVecI8x16ToI16x8:
      case ExtAddPairwiseUVecI8x16ToI16x8:
      case ExtAddPairwiseSVecI16x8ToI32x4:
      case ExtAddPairwiseUVecI16x8ToI32x4:
      case TruncSatSVecF32x4ToVecI32x4:
      case TruncSatUVecF32x4ToVecI32x4:
      case ConvertSVecI32x4ToVecF32x4:
      case ConvertUVecI32x4ToVecF32x4:
      case ExtendLowSVecI8x16ToVecI16x8:
      case ExtendHighSVecI8x16ToVecI16x8:
      case ExtendLowUVecI8x16ToVecI16x8:
      case ExtendHighUVecI8x16ToVecI16x8:
      case ExtendLowSVecI16x8ToVecI32x4:
      case ExtendHighSVecI16x8ToVecI32x4:
      case ExtendLowUVecI16x8ToVecI32x4:
      case ExtendHighUVecI16x8ToVecI32x4:
      case ExtendLowSVecI32x4ToVecI64x2:
      case ExtendHighSVecI32x4ToVecI64x2:
      case ExtendLowUVecI32x4ToVecI64x2:
      case ExtendHighUVecI32x4ToVecI64x2:
      case ConvertLowSVecI32x4ToVecF64x2:
      case ConvertLowUVecI32x4ToVecF64x2:
      case TruncSatZeroSVecF64x2ToVecI32x4:
      case TruncSatZeroUVecF64x2ToVecI32x4:
      case DemoteZeroVecF64x2ToVecF32x4:
      case PromoteLowVecF32x4ToVecF64x2:
      case RelaxedTruncSVecF32x4ToVecI32x4:
      case RelaxedTruncUVecF32x4ToVecI32x4:
      case RelaxedTruncZeroSVecF64x2ToVecI32x4:
      case RelaxedTruncZeroUVecF64x2ToVecI32x4:
        ret = 1;
        break;
      case InvalidUnary:
        WASM_UNREACHABLE("invalid unary op");
    }
    return ret + visit(curr->value);
  }
  CostType visitBinary(Binary* curr) {
    CostType ret = 0;
    switch (curr->op) {
      case AddInt32:
      case SubInt32:
        ret = 1;
        break;
      case MulInt32:
        ret = 2;
        break;
      case DivSInt32:
      case DivUInt32:
      case RemSInt32:
      case RemUInt32:
        ret = curr->right->is<Const>() ? 2 : 3;
        break;
      case AndInt32:
      case OrInt32:
      case XorInt32:
      case ShlInt32:
      case ShrUInt32:
      case ShrSInt32:
      case RotLInt32:
      case RotRInt32:
      case AddInt64:
      case SubInt64:
        ret = 1;
        break;
      case MulInt64:
        ret = 2;
        break;
      case DivSInt64:
      case DivUInt64:
      case RemSInt64:
      case RemUInt64:
        ret = curr->right->is<Const>() ? 3 : 4;
        break;
      case AndInt64:
      case OrInt64:
      case XorInt64:
        ret = 1;
        break;
      case ShlInt64:
      case ShrUInt64:
      case ShrSInt64:
      case RotLInt64:
      case RotRInt64:
      case AddFloat32:
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
      case MinFloat32:
      case MaxFloat32:
      case AddFloat64:
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
      case MinFloat64:
      case MaxFloat64:
      case EqInt32:
      case NeInt32:
      case LtUInt32:
      case LtSInt32:
      case LeUInt32:
      case LeSInt32:
      case GtUInt32:
      case GtSInt32:
      case GeUInt32:
      case GeSInt32:
      case EqInt64:
      case NeInt64:
      case LtUInt64:
      case LtSInt64:
      case LeUInt64:
      case LeSInt64:
      case GtUInt64:
      case GtSInt64:
      case GeUInt64:
      case GeSInt64:
      case EqFloat32:
      case NeFloat32:
      case LtFloat32:
      case GtFloat32:
      case LeFloat32:
      case GeFloat32:
      case EqFloat64:
      case NeFloat64:
      case LtFloat64:
      case GtFloat64:
      case LeFloat64:
      case GeFloat64:
      case EqVecI8x16:
      case NeVecI8x16:
      case LtSVecI8x16:
      case LtUVecI8x16:
      case LeSVecI8x16:
      case LeUVecI8x16:
      case GtSVecI8x16:
      case GtUVecI8x16:
      case GeSVecI8x16:
      case GeUVecI8x16:
      case EqVecI16x8:
      case NeVecI16x8:
      case LtSVecI16x8:
      case LtUVecI16x8:
      case LeSVecI16x8:
      case LeUVecI16x8:
      case GtSVecI16x8:
      case GtUVecI16x8:
      case GeSVecI16x8:
      case GeUVecI16x8:
      case EqVecI32x4:
      case NeVecI32x4:
      case LtSVecI32x4:
      case LtUVecI32x4:
      case LeSVecI32x4:
      case LeUVecI32x4:
      case GtSVecI32x4:
      case GtUVecI32x4:
      case GeSVecI32x4:
      case GeUVecI32x4:
      case EqVecI64x2:
      case NeVecI64x2:
      case LtSVecI64x2:
      case LeSVecI64x2:
      case GtSVecI64x2:
      case GeSVecI64x2:
      case EqVecF32x4:
      case NeVecF32x4:
      case LtVecF32x4:
      case LeVecF32x4:
      case GtVecF32x4:
      case GeVecF32x4:
      case EqVecF64x2:
      case NeVecF64x2:
      case LtVecF64x2:
      case LeVecF64x2:
      case GtVecF64x2:
      case GeVecF64x2:
      case AndVec128:
      case OrVec128:
      case XorVec128:
      case AndNotVec128:
      case AddVecI8x16:
      case AddSatSVecI8x16:
      case AddSatUVecI8x16:
      case SubVecI8x16:
      case SubSatSVecI8x16:
      case SubSatUVecI8x16:
      case MinSVecI8x16:
      case MinUVecI8x16:
      case MaxSVecI8x16:
      case MaxUVecI8x16:
      case AvgrUVecI8x16:
      case AddVecI16x8:
      case AddSatSVecI16x8:
      case AddSatUVecI16x8:
      case SubVecI16x8:
      case SubSatSVecI16x8:
      case SubSatUVecI16x8:
        ret = 1;
        break;
      case MulVecI16x8:
        ret = 2;
        break;
      case MinSVecI16x8:
      case MinUVecI16x8:
      case MaxSVecI16x8:
      case MaxUVecI16x8:
      case AvgrUVecI16x8:
      case Q15MulrSatSVecI16x8:
      case ExtMulLowSVecI16x8:
      case ExtMulHighSVecI16x8:
      case ExtMulLowUVecI16x8:
      case ExtMulHighUVecI16x8:
      case AddVecI32x4:
      case SubVecI32x4:
        ret = 1;
        break;
      case MulVecI32x4:
        ret = 2;
        break;
      case MinSVecI32x4:
      case MinUVecI32x4:
      case MaxSVecI32x4:
      case MaxUVecI32x4:
      case DotSVecI16x8ToVecI32x4:
      case ExtMulLowSVecI32x4:
      case ExtMulHighSVecI32x4:
      case ExtMulLowUVecI32x4:
      case ExtMulHighUVecI32x4:
      case AddVecI64x2:
      case SubVecI64x2:
      case MulVecI64x2:
      case ExtMulLowSVecI64x2:
      case ExtMulHighSVecI64x2:
      case ExtMulLowUVecI64x2:
      case ExtMulHighUVecI64x2:
      case AddVecF32x4:
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
      case MaxVecF32x4:
      case PMinVecF32x4:
      case PMaxVecF32x4:
      case RelaxedMinVecF32x4:
      case RelaxedMaxVecF32x4:
      case AddVecF64x2:
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
      case MaxVecF64x2:
      case PMinVecF64x2:
      case PMaxVecF64x2:
      case RelaxedMinVecF64x2:
      case RelaxedMaxVecF64x2:
      case NarrowSVecI16x8ToVecI8x16:
      case NarrowUVecI16x8ToVecI8x16:
      case NarrowSVecI32x4ToVecI16x8:
      case NarrowUVecI32x4ToVecI16x8:
      case SwizzleVec8x16:
      case RelaxedSwizzleVec8x16:
        ret = 1;
        break;
      case InvalidBinary:
        WASM_UNREACHABLE("invalid binary op");
    }
    return ret + visit(curr->left) + visit(curr->right);
  }
  CostType visitSelect(Select* curr) {
    return 1 + visit(curr->condition) + visit(curr->ifTrue) +
           visit(curr->ifFalse);
  }
  CostType visitDrop(Drop* curr) { return visit(curr->value); }
  CostType visitReturn(Return* curr) { return maybeVisit(curr->value); }
  CostType visitMemorySize(MemorySize* curr) { return 1; }
  CostType visitMemoryGrow(MemoryGrow* curr) {
    return 100 + visit(curr->delta);
  }
  CostType visitMemoryInit(MemoryInit* curr) {
    return 6 + visit(curr->dest) + visit(curr->offset) + visit(curr->size);
  }
  CostType visitMemoryCopy(MemoryCopy* curr) {
    // TODO when the size is a constant, estimate the time based on that
    return 6 + visit(curr->dest) + visit(curr->source) + visit(curr->size);
  }
  CostType visitMemoryFill(MemoryFill* curr) {
    return 6 + visit(curr->dest) + visit(curr->value) + visit(curr->size);
  }
  CostType visitSIMDLoad(SIMDLoad* curr) { return 1 + visit(curr->ptr); }
  CostType visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    return 1 + CostType(curr->isStore()) + visit(curr->ptr) + visit(curr->vec);
  }
  CostType visitSIMDReplace(SIMDReplace* curr) {
    return 2 + visit(curr->vec) + visit(curr->value);
  }
  CostType visitSIMDExtract(SIMDExtract* curr) { return 1 + visit(curr->vec); }
  CostType visitSIMDTernary(SIMDTernary* curr) {
    CostType ret = 0;
    switch (curr->op) {
      case Bitselect:
      case LaneselectI8x16:
      case LaneselectI16x8:
      case LaneselectI32x4:
      case LaneselectI64x2:
      case RelaxedFmaVecF32x4:
      case RelaxedFmsVecF32x4:
      case RelaxedFmaVecF64x2:
      case RelaxedFmsVecF64x2:
        ret = 1;
        break;
    }
    return ret + visit(curr->a) + visit(curr->b) + visit(curr->c);
  }
  CostType visitSIMDShift(SIMDShift* curr) {
    return 1 + visit(curr->vec) + visit(curr->shift);
  }
  CostType visitSIMDShuffle(SIMDShuffle* curr) {
    return 1 + visit(curr->left) + visit(curr->right);
  }
  CostType visitRefNull(RefNull* curr) { return 1; }
  CostType visitRefIs(RefIs* curr) { return 1 + visit(curr->value); }
  CostType visitRefFunc(RefFunc* curr) { return 1; }
  CostType visitRefEq(RefEq* curr) {
    return 1 + visit(curr->left) + visit(curr->right);
  }
  CostType visitTableGet(TableGet* curr) { return 1 + visit(curr->index); }
  CostType visitTableSet(TableSet* curr) {
    return 2 + visit(curr->index) + visit(curr->value);
  }
  CostType visitTableSize(TableSize* curr) { return 1; }
  CostType visitTableGrow(TableGrow* curr) {
    return 100 + visit(curr->value) + visit(curr->delta);
  }
  CostType visitTry(Try* curr) {
    // We assume no exception will be thrown in most cases
    return visit(curr->body);
  }
  CostType visitThrow(Throw* curr) {
    CostType ret = 100;
    for (auto* child : curr->operands) {
      ret += visit(child);
    }
    return ret;
  }
  CostType visitRethrow(Rethrow* curr) { return 100; }
  CostType visitTupleMake(TupleMake* curr) {
    CostType ret = 0;
    for (auto* child : curr->operands) {
      ret += visit(child);
    }
    return ret;
  }
  CostType visitTupleExtract(TupleExtract* curr) { return visit(curr->tuple); }
  CostType visitPop(Pop* curr) { return 0; }
  CostType visitNop(Nop* curr) { return 0; }
  CostType visitUnreachable(Unreachable* curr) { return 0; }
  CostType visitDataDrop(DataDrop* curr) { return 5; }
  CostType visitI31New(I31New* curr) { return 3 + visit(curr->value); }
  CostType visitI31Get(I31Get* curr) { return 2 + visit(curr->i31); }
  CostType visitRefTest(RefTest* curr) {
    return 2 + nullCheckCost(curr->ref) + visit(curr->ref) +
           maybeVisit(curr->rtt);
  }
  CostType visitRefCast(RefCast* curr) {
    return 2 + nullCheckCost(curr->ref) + visit(curr->ref) +
           maybeVisit(curr->rtt);
  }
  CostType visitBrOn(BrOn* curr) {
    // BrOnCast has more work to do with the rtt, so add a little there.
    CostType base = curr->op == BrOnCast ? 3 : 2;
    return base + nullCheckCost(curr->ref) + maybeVisit(curr->ref) +
           maybeVisit(curr->rtt);
  }
  CostType visitRttCanon(RttCanon* curr) {
    // TODO: investigate actual RTT costs in VMs
    return 1;
  }
  CostType visitRttSub(RttSub* curr) {
    // TODO: investigate actual RTT costs in VMs
    return 2 + visit(curr->parent);
  }
  CostType visitStructNew(StructNew* curr) {
    // While allocation itself is almost free with generational GC, there is
    // at least some baseline cost, plus writing the fields. (If we use default
    // values for the fields, then it is possible they are all 0 and if so, we
    // can get that almost for free as well, so don't add anything there.)
    CostType ret = 4 + maybeVisit(curr->rtt) + curr->operands.size();
    for (auto* child : curr->operands) {
      ret += visit(child);
    }
    return ret;
  }
  CostType visitStructGet(StructGet* curr) {
    return 1 + nullCheckCost(curr->ref) + visit(curr->ref);
  }
  CostType visitStructSet(StructSet* curr) {
    return 2 + nullCheckCost(curr->ref) + visit(curr->ref) + visit(curr->value);
  }
  CostType visitArrayNew(ArrayNew* curr) {
    return 4 + maybeVisit(curr->rtt) + visit(curr->size) +
           maybeVisit(curr->init);
  }
  CostType visitArrayInit(ArrayInit* curr) {
    CostType ret = 4 + maybeVisit(curr->rtt);
    for (auto* child : curr->values) {
      ret += visit(child);
    }
    return ret;
  }
  CostType visitArrayGet(ArrayGet* curr) {
    return 1 + nullCheckCost(curr->ref) + visit(curr->ref) + visit(curr->index);
  }
  CostType visitArraySet(ArraySet* curr) {
    return 2 + nullCheckCost(curr->ref) + visit(curr->ref) +
           visit(curr->index) + visit(curr->value);
  }
  CostType visitArrayLen(ArrayLen* curr) {
    return 1 + nullCheckCost(curr->ref) + visit(curr->ref);
  }
  CostType visitArrayCopy(ArrayCopy* curr) {
    // Similar to MemoryCopy.
    return 6 + visit(curr->destRef) + visit(curr->destIndex) +
           visit(curr->srcRef) + visit(curr->srcIndex) + visit(curr->length);
  }
  CostType visitRefAs(RefAs* curr) { return 1 + visit(curr->value); }

private:
  CostType nullCheckCost(Expression* ref) {
    // A nullable type requires a bounds check in most VMs.
    return ref->type.isNullable();
  }
};

} // namespace wasm

#endif // wasm_ir_cost_h
