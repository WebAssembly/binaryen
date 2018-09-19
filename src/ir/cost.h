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

namespace wasm {

// Measure the execution cost of an AST. Very handwave-ey

struct CostAnalyzer : public Visitor<CostAnalyzer, Index> {
  CostAnalyzer(Expression *ast) {
    assert(ast);
    cost = visit(ast);
  }

  Index cost;

  Index maybeVisit(Expression* curr) {
    return curr ? visit(curr) : 0;
  }

  Index visitBlock(Block *curr) {
    Index ret = 0;
    for (auto* child : curr->list) ret += visit(child);
    return ret;
  }
  Index visitIf(If *curr) {
    return 1 + visit(curr->condition) + std::max(visit(curr->ifTrue), maybeVisit(curr->ifFalse));
  }
  Index visitLoop(Loop *curr) {
    return 5 * visit(curr->body);
  }
  Index visitBreak(Break *curr) {
    return 1 + maybeVisit(curr->value) + maybeVisit(curr->condition);
  }
  Index visitSwitch(Switch *curr) {
    return 2 + visit(curr->condition) + maybeVisit(curr->value);
  }
  Index visitCall(Call *curr) {
    // XXX this does not take into account if the call is to an import, which
    //     may be costlier in general
    Index ret = 4;
    for (auto* child : curr->operands) ret += visit(child);
    return ret;
  }
  Index visitCallIndirect(CallIndirect *curr) {
    Index ret = 6 + visit(curr->target);
    for (auto* child : curr->operands) ret += visit(child);
    return ret;
  }
  Index visitGetLocal(GetLocal *curr) {
    return 0;
  }
  Index visitSetLocal(SetLocal *curr) {
    return 1;
  }
  Index visitGetGlobal(GetGlobal *curr) {
    return 1;
  }
  Index visitSetGlobal(SetGlobal *curr) {
    return 2;
  }
  Index visitLoad(Load *curr) {
    return 1 + visit(curr->ptr) + 10 * curr->isAtomic;
  }
  Index visitStore(Store *curr) {
    return 2 + visit(curr->ptr) + visit(curr->value) + 10 * curr->isAtomic;
  }
  Index visitAtomicRMW(AtomicRMW *curr) {
    return 100;
  }
  Index visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    return 100;
  }
  Index visitConst(Const *curr) {
    return 1;
  }
  Index visitUnary(Unary *curr) {
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
      case ConvertUInt64ToFloat64: ret = 1; break;
      case SqrtFloat32:
      case SqrtFloat64: ret = 2; break;
      default: WASM_UNREACHABLE();
    }
    return ret + visit(curr->value);
  }
  Index visitBinary(Binary *curr) {
    Index ret = 0;
    switch (curr->op) {
      case AddInt32:        ret = 1; break;
      case SubInt32:        ret = 1; break;
      case MulInt32:        ret = 2; break;
      case DivSInt32:       ret = 3; break;
      case DivUInt32:       ret = 3; break;
      case RemSInt32:       ret = 3; break;
      case RemUInt32:       ret = 3; break;
      case AndInt32:        ret = 1; break;
      case OrInt32:         ret = 1; break;
      case XorInt32:        ret = 1; break;
      case ShlInt32:        ret = 1; break;
      case ShrUInt32:       ret = 1; break;
      case ShrSInt32:       ret = 1; break;
      case RotLInt32:       ret = 1; break;
      case RotRInt32:       ret = 1; break;
      case AddInt64:        ret = 1; break;
      case SubInt64:        ret = 1; break;
      case MulInt64:        ret = 2; break;
      case DivSInt64:       ret = 3; break;
      case DivUInt64:       ret = 3; break;
      case RemSInt64:       ret = 3; break;
      case RemUInt64:       ret = 3; break;
      case AndInt64:        ret = 1; break;
      case OrInt64:         ret = 1; break;
      case XorInt64:        ret = 1; break;
      case ShlInt64:        ret = 1; break;
      case ShrUInt64:       ret = 1; break;
      case ShrSInt64:       ret = 1; break;
      case RotLInt64:       ret = 1; break;
      case RotRInt64:       ret = 1; break;
      case AddFloat32:      ret = 1; break;
      case SubFloat32:      ret = 1; break;
      case MulFloat32:      ret = 2; break;
      case DivFloat32:      ret = 3; break;
      case CopySignFloat32: ret = 1; break;
      case MinFloat32:      ret = 1; break;
      case MaxFloat32:      ret = 1; break;
      case AddFloat64:      ret = 1; break;
      case SubFloat64:      ret = 1; break;
      case MulFloat64:      ret = 2; break;
      case DivFloat64:      ret = 3; break;
      case CopySignFloat64: ret = 1; break;
      case MinFloat64:      ret = 1; break;
      case MaxFloat64:      ret = 1; break;
      case LtUInt32:        ret = 1; break;
      case LtSInt32:        ret = 1; break;
      case LeUInt32:        ret = 1; break;
      case LeSInt32:        ret = 1; break;
      case GtUInt32:        ret = 1; break;
      case GtSInt32:        ret = 1; break;
      case GeUInt32:        ret = 1; break;
      case GeSInt32:        ret = 1; break;
      case LtUInt64:        ret = 1; break;
      case LtSInt64:        ret = 1; break;
      case LeUInt64:        ret = 1; break;
      case LeSInt64:        ret = 1; break;
      case GtUInt64:        ret = 1; break;
      case GtSInt64:        ret = 1; break;
      case GeUInt64:        ret = 1; break;
      case GeSInt64:        ret = 1; break;
      case LtFloat32:       ret = 1; break;
      case GtFloat32:       ret = 1; break;
      case LeFloat32:       ret = 1; break;
      case GeFloat32:       ret = 1; break;
      case LtFloat64:       ret = 1; break;
      case GtFloat64:       ret = 1; break;
      case LeFloat64:       ret = 1; break;
      case GeFloat64:       ret = 1; break;
      case EqInt32:         ret = 1; break;
      case NeInt32:         ret = 1; break;
      case EqInt64:         ret = 1; break;
      case NeInt64:         ret = 1; break;
      case EqFloat32:       ret = 1; break;
      case NeFloat32:       ret = 1; break;
      case EqFloat64:       ret = 1; break;
      case NeFloat64:       ret = 1; break;
      default: WASM_UNREACHABLE();
    }
    return ret + visit(curr->left) + visit(curr->right);
  }
  Index visitSelect(Select *curr) {
    return 2 + visit(curr->condition) + visit(curr->ifTrue) + visit(curr->ifFalse);
  }
  Index visitDrop(Drop *curr) {
    return visit(curr->value);
  }
  Index visitReturn(Return *curr) {
    return maybeVisit(curr->value);
  }
  Index visitHost(Host *curr) {
    return 100;
  }
  Index visitNop(Nop *curr) {
    return 0;
  }
  Index visitUnreachable(Unreachable *curr) {
    return 0;
  }
};

} // namespace wasm

#endif // wasm_ir_cost_h

