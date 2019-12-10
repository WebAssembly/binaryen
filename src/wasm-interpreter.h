/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Simple WebAssembly interpreter. This operates directly on the AST,
// for simplicity and clarity. A goal is for it to be possible for
// people to read this code and understand WebAssembly semantics.
//

#ifndef wasm_wasm_interpreter_h
#define wasm_wasm_interpreter_h

#include <cmath>
#include <limits.h>
#include <sstream>

#include "ir/module-utils.h"
#include "support/bits.h"
#include "support/safe_integer.h"
#include "wasm-traversal.h"
#include "wasm.h"

#ifdef WASM_INTERPRETER_DEBUG
#include "wasm-printing.h"
#endif

namespace wasm {

using namespace cashew;

// Utilities

extern Name WASM, RETURN_FLOW;

// Stuff that flows around during executing expressions: a literal, or a change
// in control flow.
class Flow {
public:
  Flow() = default;
  Flow(Literal value) : value(value) {}
  Flow(Name breakTo) : breakTo(breakTo) {}

  Literal value;
  Name breakTo; // if non-null, a break is going on

  bool breaking() { return breakTo.is(); }

  void clearIf(Name target) {
    if (breakTo == target) {
      breakTo.clear();
    }
  }

  friend std::ostream& operator<<(std::ostream& o, Flow& flow) {
    o << "(flow " << (flow.breakTo.is() ? flow.breakTo.str : "-") << " : "
      << flow.value << ')';
    return o;
  }
};

// A list of literals, for function calls
typedef std::vector<Literal> LiteralList;

// Debugging helpers
#ifdef WASM_INTERPRETER_DEBUG
class Indenter {
  static int indentLevel;

  const char* entryName;

public:
  Indenter(const char* entry);
  ~Indenter();

  static void print();
};

#define NOTE_ENTER(x)                                                          \
  Indenter _int_blah(x);                                                       \
  {                                                                            \
    Indenter::print();                                                         \
    std::cout << "visit " << x << " : " << curr << "\n";                       \
  }
#define NOTE_ENTER_(x)                                                         \
  Indenter _int_blah(x);                                                       \
  {                                                                            \
    Indenter::print();                                                         \
    std::cout << "visit " << x << "\n";                                        \
  }
#define NOTE_NAME(p0)                                                          \
  {                                                                            \
    Indenter::print();                                                         \
    std::cout << "name " << '(' << Name(p0) << ")\n";                          \
  }
#define NOTE_EVAL1(p0)                                                         \
  {                                                                            \
    Indenter::print();                                                         \
    std::cout << "eval " #p0 " (" << p0 << ")\n";                              \
  }
#define NOTE_EVAL2(p0, p1)                                                     \
  {                                                                            \
    Indenter::print();                                                         \
    std::cout << "eval " #p0 " (" << p0 << "), " #p1 " (" << p1 << ")\n";      \
  }
#else // WASM_INTERPRETER_DEBUG
#define NOTE_ENTER(x)
#define NOTE_ENTER_(x)
#define NOTE_NAME(p0)
#define NOTE_EVAL1(p0)
#define NOTE_EVAL2(p0, p1)
#endif // WASM_INTERPRETER_DEBUG

// Execute an expression
template<typename SubType>
class ExpressionRunner : public OverriddenVisitor<SubType, Flow> {
protected:
  Index maxDepth;

  Index depth = 0;

public:
  ExpressionRunner(Index maxDepth) : maxDepth(maxDepth) {}

  Flow visit(Expression* curr) {
    depth++;
    if (depth > maxDepth) {
      trap("interpreter recursion limit");
    }
    auto ret = OverriddenVisitor<SubType, Flow>::visit(curr);
    if (!ret.breaking() &&
        (curr->type.isConcrete() || ret.value.type.isConcrete())) {
#if 1 // def WASM_INTERPRETER_DEBUG
      if (ret.value.type != curr->type) {
        std::cerr << "expected " << curr->type << ", seeing " << ret.value.type
                  << " from\n"
                  << curr << '\n';
      }
#endif
      assert(ret.value.type == curr->type);
    }
    depth--;
    return ret;
  }

  Flow visitBlock(Block* curr) {
    NOTE_ENTER("Block");
    // special-case Block, because Block nesting (in their first element) can be
    // incredibly deep
    std::vector<Block*> stack;
    stack.push_back(curr);
    while (curr->list.size() > 0 && curr->list[0]->is<Block>()) {
      curr = curr->list[0]->cast<Block>();
      stack.push_back(curr);
    }
    Flow flow;
    auto* top = stack.back();
    while (stack.size() > 0) {
      curr = stack.back();
      stack.pop_back();
      if (flow.breaking()) {
        flow.clearIf(curr->name);
        continue;
      }
      auto& list = curr->list;
      for (size_t i = 0; i < list.size(); i++) {
        if (curr != top && i == 0) {
          // one of the block recursions we already handled
          continue;
        }
        flow = visit(list[i]);
        if (flow.breaking()) {
          flow.clearIf(curr->name);
          break;
        }
      }
    }
    return flow;
  }
  Flow visitIf(If* curr) {
    NOTE_ENTER("If");
    Flow flow = visit(curr->condition);
    if (flow.breaking()) {
      return flow;
    }
    NOTE_EVAL1(flow.value);
    if (flow.value.geti32()) {
      Flow flow = visit(curr->ifTrue);
      if (!flow.breaking() && !curr->ifFalse) {
        flow.value = Literal(); // if_else returns a value, but if does not
      }
      return flow;
    }
    if (curr->ifFalse) {
      return visit(curr->ifFalse);
    }
    return Flow();
  }
  Flow visitLoop(Loop* curr) {
    NOTE_ENTER("Loop");
    while (1) {
      Flow flow = visit(curr->body);
      if (flow.breaking()) {
        if (flow.breakTo == curr->name) {
          continue; // lol
        }
      }
      // loop does not loop automatically, only continue achieves that
      return flow;
    }
  }
  Flow visitBreak(Break* curr) {
    NOTE_ENTER("Break");
    bool condition = true;
    Flow flow;
    if (curr->value) {
      flow = visit(curr->value);
      if (flow.breaking()) {
        return flow;
      }
    }
    if (curr->condition) {
      Flow conditionFlow = visit(curr->condition);
      if (conditionFlow.breaking()) {
        return conditionFlow;
      }
      condition = conditionFlow.value.getInteger() != 0;
      if (!condition) {
        return flow;
      }
    }
    flow.breakTo = curr->name;
    return flow;
  }
  Flow visitSwitch(Switch* curr) {
    NOTE_ENTER("Switch");
    Flow flow;
    Literal value;
    if (curr->value) {
      flow = visit(curr->value);
      if (flow.breaking()) {
        return flow;
      }
      value = flow.value;
      NOTE_EVAL1(value);
    }
    flow = visit(curr->condition);
    if (flow.breaking()) {
      return flow;
    }
    int64_t index = flow.value.getInteger();
    Name target = curr->default_;
    if (index >= 0 && (size_t)index < curr->targets.size()) {
      target = curr->targets[(size_t)index];
    }
    flow.breakTo = target;
    flow.value = value;
    return flow;
  }

  Flow visitConst(Const* curr) {
    NOTE_ENTER("Const");
    NOTE_EVAL1(curr->value);
    return Flow(curr->value); // heh
  }

  // Unary and Binary nodes, the core math computations. We mostly just
  // delegate to the Literal::* methods, except we handle traps here.

  Flow visitUnary(Unary* curr) {
    NOTE_ENTER("Unary");
    Flow flow = visit(curr->value);
    if (flow.breaking()) {
      return flow;
    }
    Literal value = flow.value;
    NOTE_EVAL1(value);
    switch (curr->op) {
      case ClzInt32:
      case ClzInt64:
        return value.countLeadingZeroes();
      case CtzInt32:
      case CtzInt64:
        return value.countTrailingZeroes();
      case PopcntInt32:
      case PopcntInt64:
        return value.popCount();
      case EqZInt32:
      case EqZInt64:
        return value.eqz();
      case ReinterpretInt32:
        return value.castToF32();
      case ReinterpretInt64:
        return value.castToF64();
      case ExtendSInt32:
        return value.extendToSI64();
      case ExtendUInt32:
        return value.extendToUI64();
      case WrapInt64:
        return value.wrapToI32();
      case ConvertUInt32ToFloat32:
      case ConvertUInt64ToFloat32:
        return value.convertUIToF32();
      case ConvertUInt32ToFloat64:
      case ConvertUInt64ToFloat64:
        return value.convertUIToF64();
      case ConvertSInt32ToFloat32:
      case ConvertSInt64ToFloat32:
        return value.convertSIToF32();
      case ConvertSInt32ToFloat64:
      case ConvertSInt64ToFloat64:
        return value.convertSIToF64();
      case ExtendS8Int32:
      case ExtendS8Int64:
        return value.extendS8();
      case ExtendS16Int32:
      case ExtendS16Int64:
        return value.extendS16();
      case ExtendS32Int64:
        return value.extendS32();

      case NegFloat32:
      case NegFloat64:
        return value.neg();
      case AbsFloat32:
      case AbsFloat64:
        return value.abs();
      case CeilFloat32:
      case CeilFloat64:
        return value.ceil();
      case FloorFloat32:
      case FloorFloat64:
        return value.floor();
      case TruncFloat32:
      case TruncFloat64:
        return value.trunc();
      case NearestFloat32:
      case NearestFloat64:
        return value.nearbyint();
      case SqrtFloat32:
      case SqrtFloat64:
        return value.sqrt();
      case TruncSFloat32ToInt32:
      case TruncSFloat64ToInt32:
      case TruncSFloat32ToInt64:
      case TruncSFloat64ToInt64:
        return truncSFloat(curr, value);
      case TruncUFloat32ToInt32:
      case TruncUFloat64ToInt32:
      case TruncUFloat32ToInt64:
      case TruncUFloat64ToInt64:
        return truncUFloat(curr, value);
      case TruncSatSFloat32ToInt32:
      case TruncSatSFloat64ToInt32:
        return value.truncSatToSI32();
      case TruncSatSFloat32ToInt64:
      case TruncSatSFloat64ToInt64:
        return value.truncSatToSI64();
      case TruncSatUFloat32ToInt32:
      case TruncSatUFloat64ToInt32:
        return value.truncSatToUI32();
      case TruncSatUFloat32ToInt64:
      case TruncSatUFloat64ToInt64:
        return value.truncSatToUI64();
      case ReinterpretFloat32:
        return value.castToI32();
      case PromoteFloat32:
        return value.extendToF64();
      case ReinterpretFloat64:
        return value.castToI64();
      case DemoteFloat64:
        return value.demote();
      case SplatVecI8x16:
        return value.splatI8x16();
      case SplatVecI16x8:
        return value.splatI16x8();
      case SplatVecI32x4:
        return value.splatI32x4();
      case SplatVecI64x2:
        return value.splatI64x2();
      case SplatVecF32x4:
        return value.splatF32x4();
      case SplatVecF64x2:
        return value.splatF64x2();
      case NotVec128:
        return value.notV128();
      case NegVecI8x16:
        return value.negI8x16();
      case AnyTrueVecI8x16:
        return value.anyTrueI8x16();
      case AllTrueVecI8x16:
        return value.allTrueI8x16();
      case NegVecI16x8:
        return value.negI16x8();
      case AnyTrueVecI16x8:
        return value.anyTrueI16x8();
      case AllTrueVecI16x8:
        return value.allTrueI16x8();
      case NegVecI32x4:
        return value.negI32x4();
      case AnyTrueVecI32x4:
        return value.anyTrueI32x4();
      case AllTrueVecI32x4:
        return value.allTrueI32x4();
      case NegVecI64x2:
        return value.negI64x2();
      case AnyTrueVecI64x2:
        return value.anyTrueI64x2();
      case AllTrueVecI64x2:
        return value.allTrueI64x2();
      case AbsVecF32x4:
        return value.absF32x4();
      case NegVecF32x4:
        return value.negF32x4();
      case SqrtVecF32x4:
        return value.sqrtF32x4();
      case AbsVecF64x2:
        return value.absF64x2();
      case NegVecF64x2:
        return value.negF64x2();
      case SqrtVecF64x2:
        return value.sqrtF64x2();
      case TruncSatSVecF32x4ToVecI32x4:
        return value.truncSatToSI32x4();
      case TruncSatUVecF32x4ToVecI32x4:
        return value.truncSatToUI32x4();
      case TruncSatSVecF64x2ToVecI64x2:
        return value.truncSatToSI64x2();
      case TruncSatUVecF64x2ToVecI64x2:
        return value.truncSatToUI64x2();
      case ConvertSVecI32x4ToVecF32x4:
        return value.convertSToF32x4();
      case ConvertUVecI32x4ToVecF32x4:
        return value.convertUToF32x4();
      case ConvertSVecI64x2ToVecF64x2:
        return value.convertSToF64x2();
      case ConvertUVecI64x2ToVecF64x2:
        return value.convertUToF64x2();
      case WidenLowSVecI8x16ToVecI16x8:
        return value.widenLowSToVecI16x8();
      case WidenHighSVecI8x16ToVecI16x8:
        return value.widenHighSToVecI16x8();
      case WidenLowUVecI8x16ToVecI16x8:
        return value.widenLowUToVecI16x8();
      case WidenHighUVecI8x16ToVecI16x8:
        return value.widenHighUToVecI16x8();
      case WidenLowSVecI16x8ToVecI32x4:
        return value.widenLowSToVecI32x4();
      case WidenHighSVecI16x8ToVecI32x4:
        return value.widenHighSToVecI32x4();
      case WidenLowUVecI16x8ToVecI32x4:
        return value.widenLowUToVecI32x4();
      case WidenHighUVecI16x8ToVecI32x4:
        return value.widenHighUToVecI32x4();
      case InvalidUnary:
        WASM_UNREACHABLE("invalid unary op");
    }
    WASM_UNREACHABLE("invalid op");
  }
  Flow visitBinary(Binary* curr) {
    NOTE_ENTER("Binary");
    Flow flow = visit(curr->left);
    if (flow.breaking()) {
      return flow;
    }
    Literal left = flow.value;
    flow = visit(curr->right);
    if (flow.breaking()) {
      return flow;
    }
    Literal right = flow.value;
    NOTE_EVAL2(left, right);
    assert(curr->left->type.isConcrete() ? left.type == curr->left->type
                                         : true);
    assert(curr->right->type.isConcrete() ? right.type == curr->right->type
                                          : true);
    switch (curr->op) {
      case AddInt32:
      case AddInt64:
      case AddFloat32:
      case AddFloat64:
        return left.add(right);
      case SubInt32:
      case SubInt64:
      case SubFloat32:
      case SubFloat64:
        return left.sub(right);
      case MulInt32:
      case MulInt64:
      case MulFloat32:
      case MulFloat64:
        return left.mul(right);
      case DivSInt32: {
        if (right.getInteger() == 0) {
          trap("i32.div_s by 0");
        }
        if (left.getInteger() == std::numeric_limits<int32_t>::min() &&
            right.getInteger() == -1) {
          trap("i32.div_s overflow"); // signed division overflow
        }
        return left.divS(right);
      }
      case DivUInt32: {
        if (right.getInteger() == 0) {
          trap("i32.div_u by 0");
        }
        return left.divU(right);
      }
      case RemSInt32: {
        if (right.getInteger() == 0) {
          trap("i32.rem_s by 0");
        }
        if (left.getInteger() == std::numeric_limits<int32_t>::min() &&
            right.getInteger() == -1) {
          return Literal(int32_t(0));
        }
        return left.remS(right);
      }
      case RemUInt32: {
        if (right.getInteger() == 0) {
          trap("i32.rem_u by 0");
        }
        return left.remU(right);
      }
      case DivSInt64: {
        if (right.getInteger() == 0) {
          trap("i64.div_s by 0");
        }
        if (left.getInteger() == LLONG_MIN && right.getInteger() == -1LL) {
          trap("i64.div_s overflow"); // signed division overflow
        }
        return left.divS(right);
      }
      case DivUInt64: {
        if (right.getInteger() == 0) {
          trap("i64.div_u by 0");
        }
        return left.divU(right);
      }
      case RemSInt64: {
        if (right.getInteger() == 0) {
          trap("i64.rem_s by 0");
        }
        if (left.getInteger() == LLONG_MIN && right.getInteger() == -1LL) {
          return Literal(int64_t(0));
        }
        return left.remS(right);
      }
      case RemUInt64: {
        if (right.getInteger() == 0) {
          trap("i64.rem_u by 0");
        }
        return left.remU(right);
      }
      case DivFloat32:
      case DivFloat64:
        return left.div(right);
      case AndInt32:
      case AndInt64:
        return left.and_(right);
      case OrInt32:
      case OrInt64:
        return left.or_(right);
      case XorInt32:
      case XorInt64:
        return left.xor_(right);
      case ShlInt32:
      case ShlInt64:
        return left.shl(right);
      case ShrUInt32:
      case ShrUInt64:
        return left.shrU(right);
      case ShrSInt32:
      case ShrSInt64:
        return left.shrS(right);
      case RotLInt32:
      case RotLInt64:
        return left.rotL(right);
      case RotRInt32:
      case RotRInt64:
        return left.rotR(right);

      case EqInt32:
      case EqInt64:
      case EqFloat32:
      case EqFloat64:
        return left.eq(right);
      case NeInt32:
      case NeInt64:
      case NeFloat32:
      case NeFloat64:
        return left.ne(right);
      case LtSInt32:
      case LtSInt64:
        return left.ltS(right);
      case LtUInt32:
      case LtUInt64:
        return left.ltU(right);
      case LeSInt32:
      case LeSInt64:
        return left.leS(right);
      case LeUInt32:
      case LeUInt64:
        return left.leU(right);
      case GtSInt32:
      case GtSInt64:
        return left.gtS(right);
      case GtUInt32:
      case GtUInt64:
        return left.gtU(right);
      case GeSInt32:
      case GeSInt64:
        return left.geS(right);
      case GeUInt32:
      case GeUInt64:
        return left.geU(right);
      case LtFloat32:
      case LtFloat64:
        return left.lt(right);
      case LeFloat32:
      case LeFloat64:
        return left.le(right);
      case GtFloat32:
      case GtFloat64:
        return left.gt(right);
      case GeFloat32:
      case GeFloat64:
        return left.ge(right);

      case CopySignFloat32:
      case CopySignFloat64:
        return left.copysign(right);
      case MinFloat32:
      case MinFloat64:
        return left.min(right);
      case MaxFloat32:
      case MaxFloat64:
        return left.max(right);

      case EqVecI8x16:
        return left.eqI8x16(right);
      case NeVecI8x16:
        return left.neI8x16(right);
      case LtSVecI8x16:
        return left.ltSI8x16(right);
      case LtUVecI8x16:
        return left.ltUI8x16(right);
      case GtSVecI8x16:
        return left.gtSI8x16(right);
      case GtUVecI8x16:
        return left.gtUI8x16(right);
      case LeSVecI8x16:
        return left.leSI8x16(right);
      case LeUVecI8x16:
        return left.leUI8x16(right);
      case GeSVecI8x16:
        return left.geSI8x16(right);
      case GeUVecI8x16:
        return left.geUI8x16(right);
      case EqVecI16x8:
        return left.eqI16x8(right);
      case NeVecI16x8:
        return left.neI16x8(right);
      case LtSVecI16x8:
        return left.ltSI16x8(right);
      case LtUVecI16x8:
        return left.ltUI16x8(right);
      case GtSVecI16x8:
        return left.gtSI16x8(right);
      case GtUVecI16x8:
        return left.gtUI16x8(right);
      case LeSVecI16x8:
        return left.leSI16x8(right);
      case LeUVecI16x8:
        return left.leUI16x8(right);
      case GeSVecI16x8:
        return left.geSI16x8(right);
      case GeUVecI16x8:
        return left.geUI16x8(right);
      case EqVecI32x4:
        return left.eqI32x4(right);
      case NeVecI32x4:
        return left.neI32x4(right);
      case LtSVecI32x4:
        return left.ltSI32x4(right);
      case LtUVecI32x4:
        return left.ltUI32x4(right);
      case GtSVecI32x4:
        return left.gtSI32x4(right);
      case GtUVecI32x4:
        return left.gtUI32x4(right);
      case LeSVecI32x4:
        return left.leSI32x4(right);
      case LeUVecI32x4:
        return left.leUI32x4(right);
      case GeSVecI32x4:
        return left.geSI32x4(right);
      case GeUVecI32x4:
        return left.geUI32x4(right);
      case EqVecF32x4:
        return left.eqF32x4(right);
      case NeVecF32x4:
        return left.neF32x4(right);
      case LtVecF32x4:
        return left.ltF32x4(right);
      case GtVecF32x4:
        return left.gtF32x4(right);
      case LeVecF32x4:
        return left.leF32x4(right);
      case GeVecF32x4:
        return left.geF32x4(right);
      case EqVecF64x2:
        return left.eqF64x2(right);
      case NeVecF64x2:
        return left.neF64x2(right);
      case LtVecF64x2:
        return left.ltF64x2(right);
      case GtVecF64x2:
        return left.gtF64x2(right);
      case LeVecF64x2:
        return left.leF64x2(right);
      case GeVecF64x2:
        return left.geF64x2(right);

      case AndVec128:
        return left.andV128(right);
      case OrVec128:
        return left.orV128(right);
      case XorVec128:
        return left.xorV128(right);
      case AndNotVec128:
        return left.andV128(right.notV128());

      case AddVecI8x16:
        return left.addI8x16(right);
      case AddSatSVecI8x16:
        return left.addSaturateSI8x16(right);
      case AddSatUVecI8x16:
        return left.addSaturateUI8x16(right);
      case SubVecI8x16:
        return left.subI8x16(right);
      case SubSatSVecI8x16:
        return left.subSaturateSI8x16(right);
      case SubSatUVecI8x16:
        return left.subSaturateUI8x16(right);
      case MulVecI8x16:
        return left.mulI8x16(right);
      case MinSVecI8x16:
        return left.minSI8x16(right);
      case MinUVecI8x16:
        return left.minUI8x16(right);
      case MaxSVecI8x16:
        return left.maxSI8x16(right);
      case MaxUVecI8x16:
        return left.maxUI8x16(right);
      case AddVecI16x8:
        return left.addI16x8(right);
      case AddSatSVecI16x8:
        return left.addSaturateSI16x8(right);
      case AddSatUVecI16x8:
        return left.addSaturateUI16x8(right);
      case SubVecI16x8:
        return left.subI16x8(right);
      case SubSatSVecI16x8:
        return left.subSaturateSI16x8(right);
      case SubSatUVecI16x8:
        return left.subSaturateUI16x8(right);
      case MulVecI16x8:
        return left.mulI16x8(right);
      case MinSVecI16x8:
        return left.minSI16x8(right);
      case MinUVecI16x8:
        return left.minUI16x8(right);
      case MaxSVecI16x8:
        return left.maxSI16x8(right);
      case MaxUVecI16x8:
        return left.maxUI16x8(right);
      case AddVecI32x4:
        return left.addI32x4(right);
      case SubVecI32x4:
        return left.subI32x4(right);
      case MulVecI32x4:
        return left.mulI32x4(right);
      case MinSVecI32x4:
        return left.minSI32x4(right);
      case MinUVecI32x4:
        return left.minUI32x4(right);
      case MaxSVecI32x4:
        return left.maxSI32x4(right);
      case MaxUVecI32x4:
        return left.maxUI32x4(right);
      case DotSVecI16x8ToVecI32x4:
        return left.dotSI16x8toI32x4(right);
      case AddVecI64x2:
        return left.addI64x2(right);
      case SubVecI64x2:
        return left.subI64x2(right);

      case AddVecF32x4:
        return left.addF32x4(right);
      case SubVecF32x4:
        return left.subF32x4(right);
      case MulVecF32x4:
        return left.mulF32x4(right);
      case DivVecF32x4:
        return left.divF32x4(right);
      case MinVecF32x4:
        return left.minF32x4(right);
      case MaxVecF32x4:
        return left.maxF32x4(right);
      case AddVecF64x2:
        return left.addF64x2(right);
      case SubVecF64x2:
        return left.subF64x2(right);
      case MulVecF64x2:
        return left.mulF64x2(right);
      case DivVecF64x2:
        return left.divF64x2(right);
      case MinVecF64x2:
        return left.minF64x2(right);
      case MaxVecF64x2:
        return left.maxF64x2(right);

      case NarrowSVecI16x8ToVecI8x16:
        return left.narrowSToVecI8x16(right);
      case NarrowUVecI16x8ToVecI8x16:
        return left.narrowUToVecI8x16(right);
      case NarrowSVecI32x4ToVecI16x8:
        return left.narrowSToVecI16x8(right);
      case NarrowUVecI32x4ToVecI16x8:
        return left.narrowUToVecI16x8(right);

      case SwizzleVec8x16:
        return left.swizzleVec8x16(right);

      case InvalidBinary:
        WASM_UNREACHABLE("invalid binary op");
    }
    WASM_UNREACHABLE("invalid op");
  }
  Flow visitSIMDExtract(SIMDExtract* curr) {
    NOTE_ENTER("SIMDExtract");
    Flow flow = this->visit(curr->vec);
    if (flow.breaking()) {
      return flow;
    }
    Literal vec = flow.value;
    switch (curr->op) {
      case ExtractLaneSVecI8x16:
        return vec.extractLaneSI8x16(curr->index);
      case ExtractLaneUVecI8x16:
        return vec.extractLaneUI8x16(curr->index);
      case ExtractLaneSVecI16x8:
        return vec.extractLaneSI16x8(curr->index);
      case ExtractLaneUVecI16x8:
        return vec.extractLaneUI16x8(curr->index);
      case ExtractLaneVecI32x4:
        return vec.extractLaneI32x4(curr->index);
      case ExtractLaneVecI64x2:
        return vec.extractLaneI64x2(curr->index);
      case ExtractLaneVecF32x4:
        return vec.extractLaneF32x4(curr->index);
      case ExtractLaneVecF64x2:
        return vec.extractLaneF64x2(curr->index);
    }
    WASM_UNREACHABLE("invalid op");
  }
  Flow visitSIMDReplace(SIMDReplace* curr) {
    NOTE_ENTER("SIMDReplace");
    Flow flow = this->visit(curr->vec);
    if (flow.breaking()) {
      return flow;
    }
    Literal vec = flow.value;
    flow = this->visit(curr->value);
    if (flow.breaking()) {
      return flow;
    }
    Literal value = flow.value;
    switch (curr->op) {
      case ReplaceLaneVecI8x16:
        return vec.replaceLaneI8x16(value, curr->index);
      case ReplaceLaneVecI16x8:
        return vec.replaceLaneI16x8(value, curr->index);
      case ReplaceLaneVecI32x4:
        return vec.replaceLaneI32x4(value, curr->index);
      case ReplaceLaneVecI64x2:
        return vec.replaceLaneI64x2(value, curr->index);
      case ReplaceLaneVecF32x4:
        return vec.replaceLaneF32x4(value, curr->index);
      case ReplaceLaneVecF64x2:
        return vec.replaceLaneF64x2(value, curr->index);
    }
    WASM_UNREACHABLE("invalid op");
  }
  Flow visitSIMDShuffle(SIMDShuffle* curr) {
    NOTE_ENTER("SIMDShuffle");
    Flow flow = this->visit(curr->left);
    if (flow.breaking()) {
      return flow;
    }
    Literal left = flow.value;
    flow = this->visit(curr->right);
    if (flow.breaking()) {
      return flow;
    }
    Literal right = flow.value;
    return left.shuffleV8x16(right, curr->mask);
  }
  Flow visitSIMDTernary(SIMDTernary* curr) {
    NOTE_ENTER("SIMDBitselect");
    Flow flow = this->visit(curr->a);
    if (flow.breaking()) {
      return flow;
    }
    Literal a = flow.value;
    flow = this->visit(curr->b);
    if (flow.breaking()) {
      return flow;
    }
    Literal b = flow.value;
    flow = this->visit(curr->c);
    if (flow.breaking()) {
      return flow;
    }
    Literal c = flow.value;
    switch (curr->op) {
      case Bitselect:
        return c.bitselectV128(a, b);
      default:
        // TODO: implement qfma/qfms
        WASM_UNREACHABLE("not implemented");
    }
  }
  Flow visitSIMDShift(SIMDShift* curr) {
    NOTE_ENTER("SIMDShift");
    Flow flow = this->visit(curr->vec);
    if (flow.breaking()) {
      return flow;
    }
    Literal vec = flow.value;
    flow = this->visit(curr->shift);
    if (flow.breaking()) {
      return flow;
    }
    Literal shift = flow.value;
    switch (curr->op) {
      case ShlVecI8x16:
        return vec.shlI8x16(shift);
      case ShrSVecI8x16:
        return vec.shrSI8x16(shift);
      case ShrUVecI8x16:
        return vec.shrUI8x16(shift);
      case ShlVecI16x8:
        return vec.shlI16x8(shift);
      case ShrSVecI16x8:
        return vec.shrSI16x8(shift);
      case ShrUVecI16x8:
        return vec.shrUI16x8(shift);
      case ShlVecI32x4:
        return vec.shlI32x4(shift);
      case ShrSVecI32x4:
        return vec.shrSI32x4(shift);
      case ShrUVecI32x4:
        return vec.shrUI32x4(shift);
      case ShlVecI64x2:
        return vec.shlI64x2(shift);
      case ShrSVecI64x2:
        return vec.shrSI64x2(shift);
      case ShrUVecI64x2:
        return vec.shrUI64x2(shift);
    }
    WASM_UNREACHABLE("invalid op");
  }
  Flow visitSelect(Select* curr) {
    NOTE_ENTER("Select");
    Flow ifTrue = visit(curr->ifTrue);
    if (ifTrue.breaking()) {
      return ifTrue;
    }
    Flow ifFalse = visit(curr->ifFalse);
    if (ifFalse.breaking()) {
      return ifFalse;
    }
    Flow condition = visit(curr->condition);
    if (condition.breaking()) {
      return condition;
    }
    NOTE_EVAL1(condition.value);
    return condition.value.geti32() ? ifTrue : ifFalse; // ;-)
  }
  Flow visitDrop(Drop* curr) {
    NOTE_ENTER("Drop");
    Flow value = visit(curr->value);
    if (value.breaking()) {
      return value;
    }
    return Flow();
  }
  Flow visitReturn(Return* curr) {
    NOTE_ENTER("Return");
    Flow flow;
    if (curr->value) {
      flow = visit(curr->value);
      if (flow.breaking()) {
        return flow;
      }
      NOTE_EVAL1(flow.value);
    }
    flow.breakTo = RETURN_FLOW;
    return flow;
  }
  Flow visitNop(Nop* curr) {
    NOTE_ENTER("Nop");
    return Flow();
  }
  Flow visitUnreachable(Unreachable* curr) {
    NOTE_ENTER("Unreachable");
    trap("unreachable");
    WASM_UNREACHABLE("unreachable");
  }

  Literal truncSFloat(Unary* curr, Literal value) {
    double val = value.getFloat();
    if (std::isnan(val)) {
      trap("truncSFloat of nan");
    }
    if (curr->type == i32) {
      if (value.type == f32) {
        if (!isInRangeI32TruncS(value.reinterpreti32())) {
          trap("i32.truncSFloat overflow");
        }
      } else {
        if (!isInRangeI32TruncS(value.reinterpreti64())) {
          trap("i32.truncSFloat overflow");
        }
      }
      return Literal(int32_t(val));
    } else {
      if (value.type == f32) {
        if (!isInRangeI64TruncS(value.reinterpreti32())) {
          trap("i64.truncSFloat overflow");
        }
      } else {
        if (!isInRangeI64TruncS(value.reinterpreti64())) {
          trap("i64.truncSFloat overflow");
        }
      }
      return Literal(int64_t(val));
    }
  }

  Literal truncUFloat(Unary* curr, Literal value) {
    double val = value.getFloat();
    if (std::isnan(val)) {
      trap("truncUFloat of nan");
    }
    if (curr->type == i32) {
      if (value.type == f32) {
        if (!isInRangeI32TruncU(value.reinterpreti32())) {
          trap("i32.truncUFloat overflow");
        }
      } else {
        if (!isInRangeI32TruncU(value.reinterpreti64())) {
          trap("i32.truncUFloat overflow");
        }
      }
      return Literal(uint32_t(val));
    } else {
      if (value.type == f32) {
        if (!isInRangeI64TruncU(value.reinterpreti32())) {
          trap("i64.truncUFloat overflow");
        }
      } else {
        if (!isInRangeI64TruncU(value.reinterpreti64())) {
          trap("i64.truncUFloat overflow");
        }
      }
      return Literal(uint64_t(val));
    }
  }
  Flow visitAtomicFence(AtomicFence*) {
    // Wasm currently supports only sequentially consistent atomics, in which
    // case atomic_fence can be lowered to nothing.
    NOTE_ENTER("AtomicFence");
    return Flow();
  }

  Flow visitCall(Call*) { WASM_UNREACHABLE("unimp"); }
  Flow visitCallIndirect(CallIndirect*) { WASM_UNREACHABLE("unimp"); }
  Flow visitLocalGet(LocalGet*) { WASM_UNREACHABLE("unimp"); }
  Flow visitLocalSet(LocalSet*) { WASM_UNREACHABLE("unimp"); }
  Flow visitGlobalSet(GlobalSet*) { WASM_UNREACHABLE("unimp"); }
  Flow visitLoad(Load* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitStore(Store* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitHost(Host* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitMemoryInit(MemoryInit* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitDataDrop(DataDrop* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitMemoryCopy(MemoryCopy* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitMemoryFill(MemoryFill* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitAtomicRMW(AtomicRMW*) { WASM_UNREACHABLE("unimp"); }
  Flow visitAtomicCmpxchg(AtomicCmpxchg*) { WASM_UNREACHABLE("unimp"); }
  Flow visitAtomicWait(AtomicWait*) { WASM_UNREACHABLE("unimp"); }
  Flow visitAtomicNotify(AtomicNotify*) { WASM_UNREACHABLE("unimp"); }
  Flow visitSIMDLoad(SIMDLoad*) { WASM_UNREACHABLE("unimp"); }
  Flow visitSIMDLoadSplat(SIMDLoad*) { WASM_UNREACHABLE("unimp"); }
  Flow visitSIMDLoadExtend(SIMDLoad*) { WASM_UNREACHABLE("unimp"); }
  Flow visitPush(Push*) { WASM_UNREACHABLE("unimp"); }
  Flow visitPop(Pop*) { WASM_UNREACHABLE("unimp"); }
  Flow visitTry(Try*) { WASM_UNREACHABLE("unimp"); }
  Flow visitThrow(Throw*) { WASM_UNREACHABLE("unimp"); }
  Flow visitRethrow(Rethrow*) { WASM_UNREACHABLE("unimp"); }
  Flow visitBrOnExn(BrOnExn*) { WASM_UNREACHABLE("unimp"); }

  virtual void trap(const char* why) { WASM_UNREACHABLE("unimp"); }
};

// Execute an constant expression in a global init or memory offset.
template<typename GlobalManager>
class ConstantExpressionRunner
  : public ExpressionRunner<ConstantExpressionRunner<GlobalManager>> {
  GlobalManager& globals;

public:
  ConstantExpressionRunner(GlobalManager& globals, Index maxDepth)
    : ExpressionRunner<ConstantExpressionRunner<GlobalManager>>(maxDepth),
      globals(globals) {}

  Flow visitGlobalGet(GlobalGet* curr) { return Flow(globals[curr->name]); }
};

//
// An instance of a WebAssembly module, which can execute it via AST
// interpretation.
//
// To embed this interpreter, you need to provide an ExternalInterface instance
// (see below) which provides the embedding-specific details, that is, how to
// connect to the embedding implementation.
//
// To call into the interpreter, use callExport.
//

template<typename GlobalManager, typename SubType> class ModuleInstanceBase {
public:
  //
  // You need to implement one of these to create a concrete interpreter. The
  // ExternalInterface provides embedding-specific functionality like calling
  // an imported function or accessing memory.
  //
  struct ExternalInterface {
    virtual void init(Module& wasm, SubType& instance) {}
    virtual void importGlobals(GlobalManager& globals, Module& wasm) = 0;
    virtual Literal callImport(Function* import, LiteralList& arguments) = 0;
    virtual Literal callTable(Index index,
                              LiteralList& arguments,
                              Type result,
                              SubType& instance) = 0;
    virtual void growMemory(Address oldSize, Address newSize) = 0;
    virtual void trap(const char* why) = 0;

    // the default impls for load and store switch on the sizes. you can either
    // customize load/store, or the sub-functions which they call
    virtual Literal load(Load* load, Address addr) {
      switch (load->type) {
        case i32: {
          switch (load->bytes) {
            case 1:
              return load->signed_ ? Literal((int32_t)load8s(addr))
                                   : Literal((int32_t)load8u(addr));
            case 2:
              return load->signed_ ? Literal((int32_t)load16s(addr))
                                   : Literal((int32_t)load16u(addr));
            case 4:
              return Literal((int32_t)load32s(addr));
            default:
              WASM_UNREACHABLE("invalid size");
          }
          break;
        }
        case i64: {
          switch (load->bytes) {
            case 1:
              return load->signed_ ? Literal((int64_t)load8s(addr))
                                   : Literal((int64_t)load8u(addr));
            case 2:
              return load->signed_ ? Literal((int64_t)load16s(addr))
                                   : Literal((int64_t)load16u(addr));
            case 4:
              return load->signed_ ? Literal((int64_t)load32s(addr))
                                   : Literal((int64_t)load32u(addr));
            case 8:
              return Literal((int64_t)load64s(addr));
            default:
              WASM_UNREACHABLE("invalid size");
          }
          break;
        }
        case f32:
          return Literal(load32u(addr)).castToF32();
        case f64:
          return Literal(load64u(addr)).castToF64();
        case v128:
          return Literal(load128(addr).data());
        case anyref: // anyref cannot be loaded from memory
        case exnref: // exnref cannot be loaded from memory
        case none:
        case unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
      WASM_UNREACHABLE("invalid type");
    }
    virtual void store(Store* store, Address addr, Literal value) {
      switch (store->valueType) {
        case i32: {
          switch (store->bytes) {
            case 1:
              store8(addr, value.geti32());
              break;
            case 2:
              store16(addr, value.geti32());
              break;
            case 4:
              store32(addr, value.geti32());
              break;
            default:
              WASM_UNREACHABLE("invalid store size");
          }
          break;
        }
        case i64: {
          switch (store->bytes) {
            case 1:
              store8(addr, value.geti64());
              break;
            case 2:
              store16(addr, value.geti64());
              break;
            case 4:
              store32(addr, value.geti64());
              break;
            case 8:
              store64(addr, value.geti64());
              break;
            default:
              WASM_UNREACHABLE("invalid store size");
          }
          break;
        }
        // write floats carefully, ensuring all bits reach memory
        case f32:
          store32(addr, value.reinterpreti32());
          break;
        case f64:
          store64(addr, value.reinterpreti64());
          break;
        case v128:
          store128(addr, value.getv128());
          break;
        case anyref: // anyref cannot be stored from memory
        case exnref: // exnref cannot be stored in memory
        case none:
        case unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
    }

    virtual int8_t load8s(Address addr) { WASM_UNREACHABLE("unimp"); }
    virtual uint8_t load8u(Address addr) { WASM_UNREACHABLE("unimp"); }
    virtual int16_t load16s(Address addr) { WASM_UNREACHABLE("unimp"); }
    virtual uint16_t load16u(Address addr) { WASM_UNREACHABLE("unimp"); }
    virtual int32_t load32s(Address addr) { WASM_UNREACHABLE("unimp"); }
    virtual uint32_t load32u(Address addr) { WASM_UNREACHABLE("unimp"); }
    virtual int64_t load64s(Address addr) { WASM_UNREACHABLE("unimp"); }
    virtual uint64_t load64u(Address addr) { WASM_UNREACHABLE("unimp"); }
    virtual std::array<uint8_t, 16> load128(Address addr) {
      WASM_UNREACHABLE("unimp");
    }

    virtual void store8(Address addr, int8_t value) {
      WASM_UNREACHABLE("unimp");
    }
    virtual void store16(Address addr, int16_t value) {
      WASM_UNREACHABLE("unimp");
    }
    virtual void store32(Address addr, int32_t value) {
      WASM_UNREACHABLE("unimp");
    }
    virtual void store64(Address addr, int64_t value) {
      WASM_UNREACHABLE("unimp");
    }
    virtual void store128(Address addr, const std::array<uint8_t, 16>&) {
      WASM_UNREACHABLE("unimp");
    }

    virtual void tableStore(Address addr, Name entry) {
      WASM_UNREACHABLE("unimp");
    }
  };

  SubType* self() { return static_cast<SubType*>(this); }

  Module& wasm;

  // Values of globals
  GlobalManager globals;

  // Multivalue ABI support (see push/pop).
  std::vector<Literal> multiValues;

  ModuleInstanceBase(Module& wasm, ExternalInterface* externalInterface)
    : wasm(wasm), externalInterface(externalInterface) {
    // import globals from the outside
    externalInterface->importGlobals(globals, wasm);
    // prepare memory
    memorySize = wasm.memory.initial;
    // generate internal (non-imported) globals
    ModuleUtils::iterDefinedGlobals(wasm, [&](Global* global) {
      globals[global->name] =
        ConstantExpressionRunner<GlobalManager>(globals, maxDepth)
          .visit(global->init)
          .value;
    });

    // initialize the rest of the external interface
    externalInterface->init(wasm, *self());

    initializeTableContents();
    initializeMemoryContents();

    // run start, if present
    if (wasm.start.is()) {
      LiteralList arguments;
      callFunction(wasm.start, arguments);
    }
  }

  // call an exported function
  Literal callExport(Name name, const LiteralList& arguments) {
    Export* export_ = wasm.getExportOrNull(name);
    if (!export_) {
      externalInterface->trap("callExport not found");
    }
    return callFunction(export_->value, arguments);
  }

  Literal callExport(Name name) { return callExport(name, LiteralList()); }

  // get an exported global
  Literal getExport(Name name) {
    Export* export_ = wasm.getExportOrNull(name);
    if (!export_) {
      externalInterface->trap("getExport external not found");
    }
    Name internalName = export_->value;
    auto iter = globals.find(internalName);
    if (iter == globals.end()) {
      externalInterface->trap("getExport internal not found");
    }
    return iter->second;
  }

  std::string printFunctionStack() {
    std::string ret = "/== (binaryen interpreter stack trace)\n";
    for (int i = int(functionStack.size()) - 1; i >= 0; i--) {
      ret += std::string("|: ") + functionStack[i].str + "\n";
    }
    ret += std::string("\\==\n");
    return ret;
  }

private:
  // Keep a record of call depth, to guard against excessive recursion.
  size_t callDepth;

  // Function name stack. We maintain this explicitly to allow printing of
  // stack traces.
  std::vector<Name> functionStack;

  std::unordered_set<size_t> droppedSegments;

  void initializeTableContents() {
    for (auto& segment : wasm.table.segments) {
      Address offset =
        (uint32_t)ConstantExpressionRunner<GlobalManager>(globals, maxDepth)
          .visit(segment.offset)
          .value.geti32();
      if (offset + segment.data.size() > wasm.table.initial) {
        externalInterface->trap("invalid offset when initializing table");
      }
      for (size_t i = 0; i != segment.data.size(); ++i) {
        externalInterface->tableStore(offset + i, segment.data[i]);
      }
    }
  }

  void initializeMemoryContents() {
    Const offset;
    offset.value = Literal(uint32_t(0));
    offset.finalize();

    // apply active memory segments
    for (size_t i = 0, e = wasm.memory.segments.size(); i < e; ++i) {
      Memory::Segment& segment = wasm.memory.segments[i];
      if (segment.isPassive) {
        continue;
      }

      Const size;
      size.value = Literal(uint32_t(segment.data.size()));
      size.finalize();

      MemoryInit init;
      init.segment = i;
      init.dest = segment.offset;
      init.offset = &offset;
      init.size = &size;
      init.finalize();

      DataDrop drop;
      drop.segment = i;
      drop.finalize();

      // we don't actually have a function, but we need one in order to visit
      // the memory.init and data.drop instructions.
      Function dummyFunc;
      FunctionScope dummyScope(&dummyFunc, {});
      RuntimeExpressionRunner runner(*this, dummyScope, maxDepth);
      runner.visit(&init);
      runner.visit(&drop);
    }
  }

  class FunctionScope {
  public:
    std::vector<Literal> locals;
    Function* function;

    FunctionScope(Function* function, const LiteralList& arguments)
      : function(function) {
      if (function->sig.params.size() != arguments.size()) {
        std::cerr << "Function `" << function->name << "` expects "
                  << function->sig.params.size() << " parameters, got "
                  << arguments.size() << " arguments." << std::endl;
        WASM_UNREACHABLE("invalid param count");
      }
      locals.resize(function->getNumLocals());
      const std::vector<Type>& params = function->sig.params.expand();
      for (size_t i = 0; i < function->getNumLocals(); i++) {
        if (i < arguments.size()) {
          assert(i < params.size());
          if (params[i] != arguments[i].type) {
            std::cerr << "Function `" << function->name << "` expects type "
                      << params[i] << " for parameter " << i << ", got "
                      << arguments[i].type << "." << std::endl;
            WASM_UNREACHABLE("invalid param count");
          }
          locals[i] = arguments[i];
        } else {
          assert(function->isVar(i));
          locals[i].type = function->getLocalType(i);
        }
      }
    }
  };

  // Executes expressions with concrete runtime info, the function and module at
  // runtime
  class RuntimeExpressionRunner
    : public ExpressionRunner<RuntimeExpressionRunner> {
    ModuleInstanceBase& instance;
    FunctionScope& scope;

  public:
    RuntimeExpressionRunner(ModuleInstanceBase& instance,
                            FunctionScope& scope,
                            Index maxDepth)
      : ExpressionRunner<RuntimeExpressionRunner>(maxDepth), instance(instance),
        scope(scope) {}

    Flow generateArguments(const ExpressionList& operands,
                           LiteralList& arguments) {
      NOTE_ENTER_("generateArguments");
      arguments.reserve(operands.size());
      for (auto expression : operands) {
        Flow flow = this->visit(expression);
        if (flow.breaking()) {
          return flow;
        }
        NOTE_EVAL1(flow.value);
        arguments.push_back(flow.value);
      }
      return Flow();
    }

    Flow visitCall(Call* curr) {
      NOTE_ENTER("Call");
      NOTE_NAME(curr->target);
      LiteralList arguments;
      Flow flow = generateArguments(curr->operands, arguments);
      if (flow.breaking()) {
        return flow;
      }
      auto* func = instance.wasm.getFunction(curr->target);
      Flow ret;
      if (func->imported()) {
        ret = instance.externalInterface->callImport(func, arguments);
      } else {
        ret = instance.callFunctionInternal(curr->target, arguments);
      }
#ifdef WASM_INTERPRETER_DEBUG
      std::cout << "(returned to " << scope.function->name << ")\n";
#endif
      // TODO: make this a proper tail call (return first)
      if (curr->isReturn) {
        Const c;
        c.value = ret.value;
        c.finalize();
        Return return_;
        return_.value = &c;
        return this->visit(&return_);
      }
      return ret;
    }
    Flow visitCallIndirect(CallIndirect* curr) {
      NOTE_ENTER("CallIndirect");
      LiteralList arguments;
      Flow flow = generateArguments(curr->operands, arguments);
      if (flow.breaking()) {
        return flow;
      }
      Flow target = this->visit(curr->target);
      if (target.breaking()) {
        return target;
      }
      Index index = target.value.geti32();
      Type type = curr->isReturn ? scope.function->sig.results : curr->type;
      Flow ret = instance.externalInterface->callTable(
        index, arguments, type, *instance.self());
      // TODO: make this a proper tail call (return first)
      if (curr->isReturn) {
        Const c;
        c.value = ret.value;
        c.finalize();
        Return return_;
        return_.value = &c;
        return this->visit(&return_);
      }
      return ret;
    }

    Flow visitLocalGet(LocalGet* curr) {
      NOTE_ENTER("LocalGet");
      auto index = curr->index;
      NOTE_EVAL1(index);
      NOTE_EVAL1(scope.locals[index]);
      return scope.locals[index];
    }
    Flow visitLocalSet(LocalSet* curr) {
      NOTE_ENTER("LocalSet");
      auto index = curr->index;
      Flow flow = this->visit(curr->value);
      if (flow.breaking()) {
        return flow;
      }
      NOTE_EVAL1(index);
      NOTE_EVAL1(flow.value);
      assert(curr->isTee() ? flow.value.type == curr->type : true);
      scope.locals[index] = flow.value;
      return curr->isTee() ? flow : Flow();
    }

    Flow visitGlobalGet(GlobalGet* curr) {
      NOTE_ENTER("GlobalGet");
      auto name = curr->name;
      NOTE_EVAL1(name);
      assert(instance.globals.find(name) != instance.globals.end());
      NOTE_EVAL1(instance.globals[name]);
      return instance.globals[name];
    }
    Flow visitGlobalSet(GlobalSet* curr) {
      NOTE_ENTER("GlobalSet");
      auto name = curr->name;
      Flow flow = this->visit(curr->value);
      if (flow.breaking()) {
        return flow;
      }
      NOTE_EVAL1(name);
      NOTE_EVAL1(flow.value);
      instance.globals[name] = flow.value;
      return Flow();
    }

    Flow visitLoad(Load* curr) {
      NOTE_ENTER("Load");
      Flow flow = this->visit(curr->ptr);
      if (flow.breaking()) {
        return flow;
      }
      NOTE_EVAL1(flow);
      auto addr = instance.getFinalAddress(curr, flow.value);
      auto ret = instance.externalInterface->load(curr, addr);
      NOTE_EVAL1(addr);
      NOTE_EVAL1(ret);
      return ret;
    }
    Flow visitStore(Store* curr) {
      NOTE_ENTER("Store");
      Flow ptr = this->visit(curr->ptr);
      if (ptr.breaking()) {
        return ptr;
      }
      Flow value = this->visit(curr->value);
      if (value.breaking()) {
        return value;
      }
      auto addr = instance.getFinalAddress(curr, ptr.value);
      NOTE_EVAL1(addr);
      NOTE_EVAL1(value);
      instance.externalInterface->store(curr, addr, value.value);
      return Flow();
    }

    Flow visitAtomicRMW(AtomicRMW* curr) {
      NOTE_ENTER("AtomicRMW");
      Flow ptr = this->visit(curr->ptr);
      if (ptr.breaking()) {
        return ptr;
      }
      auto value = this->visit(curr->value);
      if (value.breaking()) {
        return value;
      }
      NOTE_EVAL1(ptr);
      auto addr = instance.getFinalAddress(curr, ptr.value);
      NOTE_EVAL1(addr);
      NOTE_EVAL1(value);
      auto loaded = instance.doAtomicLoad(addr, curr->bytes, curr->type);
      NOTE_EVAL1(loaded);
      auto computed = value.value;
      switch (curr->op) {
        case Add:
          computed = computed.add(value.value);
          break;
        case Sub:
          computed = computed.sub(value.value);
          break;
        case And:
          computed = computed.and_(value.value);
          break;
        case Or:
          computed = computed.or_(value.value);
          break;
        case Xor:
          computed = computed.xor_(value.value);
          break;
        case Xchg:
          computed = value.value;
          break;
      }
      instance.doAtomicStore(addr, curr->bytes, computed);
      return loaded;
    }
    Flow visitAtomicCmpxchg(AtomicCmpxchg* curr) {
      NOTE_ENTER("AtomicCmpxchg");
      Flow ptr = this->visit(curr->ptr);
      if (ptr.breaking()) {
        return ptr;
      }
      NOTE_EVAL1(ptr);
      auto expected = this->visit(curr->expected);
      if (expected.breaking()) {
        return expected;
      }
      auto replacement = this->visit(curr->replacement);
      if (replacement.breaking()) {
        return replacement;
      }
      auto addr = instance.getFinalAddress(curr, ptr.value);
      NOTE_EVAL1(addr);
      NOTE_EVAL1(expected);
      NOTE_EVAL1(replacement);
      auto loaded = instance.doAtomicLoad(addr, curr->bytes, curr->type);
      NOTE_EVAL1(loaded);
      if (loaded == expected.value) {
        instance.doAtomicStore(addr, curr->bytes, replacement.value);
      }
      return loaded;
    }
    Flow visitAtomicWait(AtomicWait* curr) {
      NOTE_ENTER("AtomicWait");
      Flow ptr = this->visit(curr->ptr);
      if (ptr.breaking()) {
        return ptr;
      }
      NOTE_EVAL1(ptr);
      auto expected = this->visit(curr->expected);
      NOTE_EVAL1(expected);
      if (expected.breaking()) {
        return expected;
      }
      auto timeout = this->visit(curr->timeout);
      NOTE_EVAL1(timeout);
      if (timeout.breaking()) {
        return timeout;
      }
      auto bytes = getTypeSize(curr->expectedType);
      auto addr = instance.getFinalAddress(ptr.value, bytes);
      auto loaded = instance.doAtomicLoad(addr, bytes, curr->expectedType);
      NOTE_EVAL1(loaded);
      if (loaded != expected.value) {
        return Literal(int32_t(1)); // not equal
      }
      // TODO: add threads support!
      //       for now, just assume we are woken up
      return Literal(int32_t(0)); // woken up
    }
    Flow visitAtomicNotify(AtomicNotify* curr) {
      NOTE_ENTER("AtomicNotify");
      Flow ptr = this->visit(curr->ptr);
      if (ptr.breaking()) {
        return ptr;
      }
      NOTE_EVAL1(ptr);
      auto count = this->visit(curr->notifyCount);
      NOTE_EVAL1(count);
      if (count.breaking()) {
        return count;
      }
      // TODO: add threads support!
      return Literal(int32_t(0)); // none woken up
    }
    Flow visitSIMDLoad(SIMDLoad* curr) {
      NOTE_ENTER("SIMDLoad");
      switch (curr->op) {
        case LoadSplatVec8x16:
        case LoadSplatVec16x8:
        case LoadSplatVec32x4:
        case LoadSplatVec64x2:
          return visitSIMDLoadSplat(curr);
        case LoadExtSVec8x8ToVecI16x8:
        case LoadExtUVec8x8ToVecI16x8:
        case LoadExtSVec16x4ToVecI32x4:
        case LoadExtUVec16x4ToVecI32x4:
        case LoadExtSVec32x2ToVecI64x2:
        case LoadExtUVec32x2ToVecI64x2:
          return visitSIMDLoadExtend(curr);
      }
      WASM_UNREACHABLE("invalid op");
    }
    Flow visitSIMDLoadSplat(SIMDLoad* curr) {
      Load load;
      load.type = i32;
      load.bytes = curr->getMemBytes();
      load.signed_ = false;
      load.offset = curr->offset;
      load.align = curr->align;
      load.isAtomic = false;
      load.ptr = curr->ptr;
      Literal (Literal::*splat)() const = nullptr;
      switch (curr->op) {
        case LoadSplatVec8x16:
          splat = &Literal::splatI8x16;
          break;
        case LoadSplatVec16x8:
          splat = &Literal::splatI16x8;
          break;
        case LoadSplatVec32x4:
          splat = &Literal::splatI32x4;
          break;
        case LoadSplatVec64x2:
          load.type = i64;
          splat = &Literal::splatI64x2;
          break;
        default:
          WASM_UNREACHABLE("invalid op");
      }
      load.finalize();
      Flow flow = this->visit(&load);
      if (flow.breaking()) {
        return flow;
      }
      return (flow.value.*splat)();
    }
    Flow visitSIMDLoadExtend(SIMDLoad* curr) {
      Flow flow = this->visit(curr->ptr);
      if (flow.breaking()) {
        return flow;
      }
      NOTE_EVAL1(flow);
      Address src(uint32_t(flow.value.geti32()));
      auto loadLane = [&](Address addr) {
        switch (curr->op) {
          case LoadExtSVec8x8ToVecI16x8:
            return Literal(int32_t(instance.externalInterface->load8s(addr)));
          case LoadExtUVec8x8ToVecI16x8:
            return Literal(int32_t(instance.externalInterface->load8u(addr)));
          case LoadExtSVec16x4ToVecI32x4:
            return Literal(int32_t(instance.externalInterface->load16s(addr)));
          case LoadExtUVec16x4ToVecI32x4:
            return Literal(int32_t(instance.externalInterface->load16u(addr)));
          case LoadExtSVec32x2ToVecI64x2:
            return Literal(int64_t(instance.externalInterface->load32s(addr)));
          case LoadExtUVec32x2ToVecI64x2:
            return Literal(int64_t(instance.externalInterface->load32u(addr)));
          default:
            WASM_UNREACHABLE("unexpected op");
        }
        WASM_UNREACHABLE("invalid op");
      };
      auto fillLanes = [&](auto lanes, size_t laneBytes) {
        for (auto& lane : lanes) {
          lane = loadLane(
            instance.getFinalAddress(Literal(uint32_t(src)), laneBytes));
          src = Address(uint32_t(src) + laneBytes);
        }
        return Literal(lanes);
      };
      switch (curr->op) {
        case LoadExtSVec8x8ToVecI16x8:
        case LoadExtUVec8x8ToVecI16x8: {
          std::array<Literal, 8> lanes;
          return fillLanes(lanes, 1);
        }
        case LoadExtSVec16x4ToVecI32x4:
        case LoadExtUVec16x4ToVecI32x4: {
          std::array<Literal, 4> lanes;
          return fillLanes(lanes, 2);
        }
        case LoadExtSVec32x2ToVecI64x2:
        case LoadExtUVec32x2ToVecI64x2: {
          std::array<Literal, 2> lanes;
          return fillLanes(lanes, 4);
        }
        default:
          WASM_UNREACHABLE("unexpected op");
      }
      WASM_UNREACHABLE("invalid op");
    }
    Flow visitHost(Host* curr) {
      NOTE_ENTER("Host");
      switch (curr->op) {
        case MemorySize:
          return Literal(int32_t(instance.memorySize));
        case MemoryGrow: {
          auto fail = Literal(int32_t(-1));
          Flow flow = this->visit(curr->operands[0]);
          if (flow.breaking()) {
            return flow;
          }
          int32_t ret = instance.memorySize;
          uint32_t delta = flow.value.geti32();
          if (delta > uint32_t(-1) / Memory::kPageSize) {
            return fail;
          }
          if (instance.memorySize >= uint32_t(-1) - delta) {
            return fail;
          }
          uint32_t newSize = instance.memorySize + delta;
          if (newSize > instance.wasm.memory.max) {
            return fail;
          }
          instance.externalInterface->growMemory(instance.memorySize *
                                                   Memory::kPageSize,
                                                 newSize * Memory::kPageSize);
          instance.memorySize = newSize;
          return Literal(int32_t(ret));
        }
      }
      WASM_UNREACHABLE("invalid op");
    }
    Flow visitMemoryInit(MemoryInit* curr) {
      NOTE_ENTER("MemoryInit");
      Flow dest = this->visit(curr->dest);
      if (dest.breaking()) {
        return dest;
      }
      Flow offset = this->visit(curr->offset);
      if (offset.breaking()) {
        return offset;
      }
      Flow size = this->visit(curr->size);
      if (size.breaking()) {
        return size;
      }
      NOTE_EVAL1(dest);
      NOTE_EVAL1(offset);
      NOTE_EVAL1(size);

      assert(curr->segment < instance.wasm.memory.segments.size());
      Memory::Segment& segment = instance.wasm.memory.segments[curr->segment];

      if (instance.droppedSegments.count(curr->segment)) {
        trap("memory.init of dropped segment");
      }

      Address destVal(uint32_t(dest.value.geti32()));
      Address offsetVal(uint32_t(offset.value.geti32()));
      Address sizeVal(uint32_t(size.value.geti32()));

      for (size_t i = 0; i < sizeVal; ++i) {
        if (offsetVal + i >= segment.data.size()) {
          trap("out of bounds segment access in memory.init");
        }
        Literal addr(uint32_t(destVal + i));
        instance.externalInterface->store8(instance.getFinalAddress(addr, 1),
                                           segment.data[offsetVal + i]);
      }
      return {};
    }
    Flow visitDataDrop(DataDrop* curr) {
      NOTE_ENTER("DataDrop");
      if (instance.droppedSegments.count(curr->segment)) {
        trap("data.drop of dropped segment");
      }
      instance.droppedSegments.insert(curr->segment);
      return {};
    }
    Flow visitMemoryCopy(MemoryCopy* curr) {
      NOTE_ENTER("MemoryCopy");
      Flow dest = this->visit(curr->dest);
      if (dest.breaking()) {
        return dest;
      }
      Flow source = this->visit(curr->source);
      if (source.breaking()) {
        return source;
      }
      Flow size = this->visit(curr->size);
      if (size.breaking()) {
        return size;
      }
      NOTE_EVAL1(dest);
      NOTE_EVAL1(source);
      NOTE_EVAL1(size);
      Address destVal(uint32_t(dest.value.geti32()));
      Address sourceVal(uint32_t(source.value.geti32()));
      Address sizeVal(uint32_t(size.value.geti32()));

      int64_t start = 0;
      int64_t end = sizeVal;
      int step = 1;
      // Reverse direction if source is below dest
      if (sourceVal < destVal) {
        start = int64_t(sizeVal) - 1;
        end = -1;
        step = -1;
      }
      for (int64_t i = start; i != end; i += step) {
        if (i + destVal >= std::numeric_limits<uint32_t>::max()) {
          trap("Out of bounds memory access");
        }
        instance.externalInterface->store8(
          instance.getFinalAddress(Literal(uint32_t(destVal + i)), 1),
          instance.externalInterface->load8s(
            instance.getFinalAddress(Literal(uint32_t(sourceVal + i)), 1)));
      }
      return {};
    }
    Flow visitMemoryFill(MemoryFill* curr) {
      NOTE_ENTER("MemoryFill");
      Flow dest = this->visit(curr->dest);
      if (dest.breaking()) {
        return dest;
      }
      Flow value = this->visit(curr->value);
      if (value.breaking()) {
        return value;
      }
      Flow size = this->visit(curr->size);
      if (size.breaking()) {
        return size;
      }
      NOTE_EVAL1(dest);
      NOTE_EVAL1(value);
      NOTE_EVAL1(size);
      Address destVal(uint32_t(dest.value.geti32()));
      Address sizeVal(uint32_t(size.value.geti32()));

      uint8_t val(value.value.geti32());
      for (size_t i = 0; i < sizeVal; ++i) {
        instance.externalInterface->store8(
          instance.getFinalAddress(Literal(uint32_t(destVal + i)), 1), val);
      }
      return {};
    }
    Flow visitPush(Push* curr) {
      NOTE_ENTER("Push");
      Flow value = this->visit(curr->value);
      if (value.breaking()) {
        return value;
      }
      instance.multiValues.push_back(value.value);
      return Flow();
    }
    Flow visitPop(Pop* curr) {
      NOTE_ENTER("Pop");
      assert(!instance.multiValues.empty());
      auto ret = instance.multiValues.back();
      instance.multiValues.pop_back();
      return ret;
    }

    void trap(const char* why) override {
      instance.externalInterface->trap(why);
    }
  };

public:
  // Call a function, starting an invocation.
  Literal callFunction(Name name, const LiteralList& arguments) {
    // if the last call ended in a jump up the stack, it might have left stuff
    // for us to clean up here
    callDepth = 0;
    functionStack.clear();
    return callFunctionInternal(name, arguments);
  }

  // Internal function call. Must be public so that callTable implementations
  // can use it (refactor?)
  Literal callFunctionInternal(Name name, const LiteralList& arguments) {
    if (callDepth > maxDepth) {
      externalInterface->trap("stack limit");
    }
    auto previousCallDepth = callDepth;
    callDepth++;
    auto previousFunctionStackSize = functionStack.size();
    functionStack.push_back(name);

    Function* function = wasm.getFunction(name);
    assert(function);
    FunctionScope scope(function, arguments);

#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "entering " << function->name << "\n  with arguments:\n";
    for (unsigned i = 0; i < arguments.size(); ++i) {
      std::cout << "    $" << i << ": " << arguments[i] << '\n';
    }
#endif

    Flow flow =
      RuntimeExpressionRunner(*this, scope, maxDepth).visit(function->body);
    // cannot still be breaking, it means we missed our stop
    assert(!flow.breaking() || flow.breakTo == RETURN_FLOW);
    Literal ret = flow.value;
    if (function->sig.results != ret.type) {
      std::cerr << "calling " << function->name << " resulted in " << ret
                << " but the function type is " << function->sig.results
                << '\n';
      WASM_UNREACHABLE("unexpect result type");
    }
    // may decrease more than one, if we jumped up the stack
    callDepth = previousCallDepth;
    // if we jumped up the stack, we also need to pop higher frames
    while (functionStack.size() > previousFunctionStackSize) {
      functionStack.pop_back();
    }
#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "exiting " << function->name << " with " << ret << '\n';
#endif
    return ret;
  }

protected:
  Address memorySize; // in pages

  static const Index maxDepth = 250;

  void trapIfGt(uint64_t lhs, uint64_t rhs, const char* msg) {
    if (lhs > rhs) {
      std::stringstream ss;
      ss << msg << ": " << lhs << " > " << rhs;
      externalInterface->trap(ss.str().c_str());
    }
  }

  template<class LS> Address getFinalAddress(LS* curr, Literal ptr) {
    Address memorySizeBytes = memorySize * Memory::kPageSize;
    uint64_t addr = ptr.type == i32 ? ptr.geti32() : ptr.geti64();
    trapIfGt(curr->offset, memorySizeBytes, "offset > memory");
    trapIfGt(addr, memorySizeBytes - curr->offset, "final > memory");
    addr += curr->offset;
    trapIfGt(curr->bytes, memorySizeBytes, "bytes > memory");
    checkLoadAddress(addr, curr->bytes);
    return addr;
  }

  Address getFinalAddress(Literal ptr, Index bytes) {
    Address memorySizeBytes = memorySize * Memory::kPageSize;
    uint64_t addr = ptr.type == i32 ? ptr.geti32() : ptr.geti64();
    trapIfGt(addr, memorySizeBytes - bytes, "highest > memory");
    return addr;
  }

  void checkLoadAddress(Address addr, Index bytes) {
    Address memorySizeBytes = memorySize * Memory::kPageSize;
    trapIfGt(addr, memorySizeBytes - bytes, "highest > memory");
  }

  Literal doAtomicLoad(Address addr, Index bytes, Type type) {
    checkLoadAddress(addr, bytes);
    Const ptr;
    ptr.value = Literal(int32_t(addr));
    ptr.type = i32;
    Load load;
    load.bytes = bytes;
    load.signed_ = true;
    load.align = bytes;
    load.isAtomic = true; // understatement
    load.ptr = &ptr;
    load.type = type;
    return externalInterface->load(&load, addr);
  }

  void doAtomicStore(Address addr, Index bytes, Literal toStore) {
    Const ptr;
    ptr.value = Literal(int32_t(addr));
    ptr.type = i32;
    Const value;
    value.value = toStore;
    value.type = toStore.type;
    Store store;
    store.bytes = bytes;
    store.align = bytes;
    store.isAtomic = true; // understatement
    store.ptr = &ptr;
    store.value = &value;
    store.valueType = value.type;
    return externalInterface->store(&store, addr, toStore);
  }

  ExternalInterface* externalInterface;
};

// The default ModuleInstance uses a trivial global manager
using TrivialGlobalManager = std::map<Name, Literal>;
class ModuleInstance
  : public ModuleInstanceBase<TrivialGlobalManager, ModuleInstance> {
public:
  ModuleInstance(Module& wasm, ExternalInterface* externalInterface)
    : ModuleInstanceBase(wasm, externalInterface) {}
};

} // namespace wasm

#endif // wasm_wasm_interpreter_h
