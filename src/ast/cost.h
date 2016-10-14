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

#ifndef wasm_ast_cost_h
#define wasm_ast_cost_h

namespace wasm {

// Measure the cost of an AST. Very handwave-ey

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
    Index ret = 4;
    for (auto* child : curr->operands) ret += visit(child);
    return ret;
  }
  Index visitCallImport(CallImport *curr) {
    Index ret = 15;
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
    return 1;
  }
  Index visitStore(Store *curr) {
    return 2;
  }
  Index visitConst(Const *curr) {
    return 1;
  }
  Index visitUnary(Unary *curr) {
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
      case ConvertUInt64ToFloat64: return 1;
      case SqrtFloat32:
      case SqrtFloat64: return 2;
      default: WASM_UNREACHABLE();
    }
  }
  Index visitBinary(Binary *curr) {
    switch (curr->op) {
      case AddInt32:        return 1;
      case SubInt32:        return 1;
      case MulInt32:        return 2;
      case DivSInt32:       return 3;
      case DivUInt32:       return 3;
      case RemSInt32:       return 3;
      case RemUInt32:       return 3;
      case AndInt32:        return 1;
      case OrInt32:         return 1;
      case XorInt32:        return 1;
      case ShlInt32:        return 1;
      case ShrUInt32:       return 1;
      case ShrSInt32:       return 1;
      case RotLInt32:       return 1;
      case RotRInt32:       return 1;
      case AddInt64:        return 1;
      case SubInt64:        return 1;
      case MulInt64:        return 2;
      case DivSInt64:       return 3;
      case DivUInt64:       return 3;
      case RemSInt64:       return 3;
      case RemUInt64:       return 3;
      case AndInt64:        return 1;
      case OrInt64:         return 1;
      case XorInt64:        return 1;
      case ShlInt64:        return 1;
      case ShrUInt64:       return 1;
      case ShrSInt64:       return 1;
      case RotLInt64:       return 1;
      case RotRInt64:       return 1;
      case AddFloat32:      return 1;
      case SubFloat32:      return 1;
      case MulFloat32:      return 2;
      case DivFloat32:      return 3;
      case CopySignFloat32: return 1;
      case MinFloat32:      return 1;
      case MaxFloat32:      return 1;
      case AddFloat64:      return 1;
      case SubFloat64:      return 1;
      case MulFloat64:      return 2;
      case DivFloat64:      return 3;
      case CopySignFloat64: return 1;
      case MinFloat64:      return 1;
      case MaxFloat64:      return 1;
      case LtUInt32:        return 1;
      case LtSInt32:        return 1;
      case LeUInt32:        return 1;
      case LeSInt32:        return 1;
      case GtUInt32:        return 1;
      case GtSInt32:        return 1;
      case GeUInt32:        return 1;
      case GeSInt32:        return 1;
      case LtUInt64:        return 1;
      case LtSInt64:        return 1;
      case LeUInt64:        return 1;
      case LeSInt64:        return 1;
      case GtUInt64:        return 1;
      case GtSInt64:        return 1;
      case GeUInt64:        return 1;
      case GeSInt64:        return 1;
      case LtFloat32:       return 1;
      case GtFloat32:       return 1;
      case LeFloat32:       return 1;
      case GeFloat32:       return 1;
      case LtFloat64:       return 1;
      case GtFloat64:       return 1;
      case LeFloat64:       return 1;
      case GeFloat64:       return 1;
      case EqInt32:         return 1;
      case NeInt32:         return 1;
      case EqInt64:         return 1;
      case NeInt64:         return 1;
      case EqFloat32:       return 1;
      case NeFloat32:       return 1;
      case EqFloat64:       return 1;
      case NeFloat64:       return 1;
      default: WASM_UNREACHABLE();
    }
  }
  Index visitSelect(Select *curr) {
    return visit(curr->condition) + visit(curr->ifTrue) + visit(curr->ifFalse);
  }
  Index visitDrop(Drop *curr) {
    return 0;
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

#endif // wasm_ast_cost_h

