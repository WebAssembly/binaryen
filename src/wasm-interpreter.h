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
#include <variant>

#include "ir/intrinsics.h"
#include "ir/module-utils.h"
#include "support/bits.h"
#include "support/safe_integer.h"
#include "support/stdckdint.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

#if __has_feature(leak_sanitizer) || __has_feature(address_sanitizer)
#include <sanitizer/lsan_interface.h>
#endif

namespace wasm {

struct WasmException {
  Name tag;
  Literals values;
};
std::ostream& operator<<(std::ostream& o, const WasmException& exn);

// Utilities

extern Name WASM, RETURN_FLOW, RETURN_CALL_FLOW, NONCONSTANT_FLOW;

// Stuff that flows around during executing expressions: a literal, or a change
// in control flow.
class Flow {
public:
  Flow() : values() {}
  Flow(Literal value) : values{value} { assert(value.type.isConcrete()); }
  Flow(Literals& values) : values(values) {}
  Flow(Literals&& values) : values(std::move(values)) {}
  Flow(Name breakTo) : values(), breakTo(breakTo) {}
  Flow(Name breakTo, Literal value) : values{value}, breakTo(breakTo) {}
  Flow(Name breakTo, Literals&& values)
    : values(std::move(values)), breakTo(breakTo) {}

  Literals values;
  Name breakTo; // if non-null, a break is going on

  // A helper function for the common case where there is only one value
  const Literal& getSingleValue() {
    assert(values.size() == 1);
    return values[0];
  }

  Type getType() { return values.getType(); }

  Expression* getConstExpression(Module& module) {
    assert(values.size() > 0);
    Builder builder(module);
    return builder.makeConstantExpression(values);
  }

  bool breaking() const { return breakTo.is(); }

  void clearIf(Name target) {
    if (breakTo == target) {
      breakTo = Name{};
    }
  }

  friend std::ostream& operator<<(std::ostream& o, const Flow& flow) {
    o << "(flow " << (flow.breakTo.is() ? flow.breakTo.str : "-") << " : {";
    for (size_t i = 0; i < flow.values.size(); ++i) {
      if (i > 0) {
        o << ", ";
      }
      o << flow.values[i];
    }
    o << "})";
    return o;
  }
};

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
  SubType* self() { return static_cast<SubType*>(this); }

protected:
  // Optional module context to search for globals and called functions. NULL if
  // we are not interested in any context.
  Module* module = nullptr;

  // Maximum depth before giving up.
  Index maxDepth;
  Index depth = 0;

  // Maximum iterations before giving up on a loop.
  Index maxLoopIterations;

  Flow generateArguments(const ExpressionList& operands, Literals& arguments) {
    NOTE_ENTER_("generateArguments");
    arguments.reserve(operands.size());
    for (auto expression : operands) {
      Flow flow = self()->visit(expression);
      if (flow.breaking()) {
        return flow;
      }
      NOTE_EVAL1(flow.values);
      arguments.push_back(flow.getSingleValue());
    }
    return Flow();
  }

  // This small function is mainly useful to put all GCData allocations in a
  // single place. We need that because LSan reports leaks on cycles in this
  // data, as we don't have a cycle collector. Those leaks are not a serious
  // problem as Binaryen is not really used in long-running tasks, so we ignore
  // this function in LSan.
  Literal makeGCData(const Literals& data, Type type) {
    auto allocation = std::make_shared<GCData>(type.getHeapType(), data);
#if __has_feature(leak_sanitizer) || __has_feature(address_sanitizer)
    // GC data with cycles will leak, since shared_ptrs do not handle cycles.
    // Binaryen is generally not used in long-running programs so we just ignore
    // such leaks for now.
    // TODO: Add a cycle collector?
    __lsan_ignore_object(allocation.get());
#endif
    return Literal(allocation, type.getHeapType());
  }

public:
  // Indicates no limit of maxDepth or maxLoopIterations.
  static const Index NO_LIMIT = 0;

  ExpressionRunner(Module* module = nullptr,
                   Index maxDepth = NO_LIMIT,
                   Index maxLoopIterations = NO_LIMIT)
    : module(module), maxDepth(maxDepth), maxLoopIterations(maxLoopIterations) {
  }
  virtual ~ExpressionRunner() = default;

  Flow visit(Expression* curr) {
    depth++;
    if (maxDepth != NO_LIMIT && depth > maxDepth) {
      hostLimit("interpreter recursion limit");
    }
    auto ret = OverriddenVisitor<SubType, Flow>::visit(curr);
    if (!ret.breaking()) {
      Type type = ret.getType();
      if (type.isConcrete() || curr->type.isConcrete()) {
#if 1 // def WASM_INTERPRETER_DEBUG
        if (!Type::isSubType(type, curr->type)) {
          std::cerr << "expected " << curr->type << ", seeing " << type
                    << " from\n"
                    << *curr << '\n';
        }
#endif
        assert(Type::isSubType(type, curr->type));
      }
    }
    depth--;
    return ret;
  }

  // Gets the module this runner is operating on.
  Module* getModule() { return module; }

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
    NOTE_EVAL1(flow.values);
    if (flow.getSingleValue().geti32()) {
      Flow flow = visit(curr->ifTrue);
      if (!flow.breaking() && !curr->ifFalse) {
        flow = Flow(); // if_else returns a value, but if does not
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
    Index loopCount = 0;
    while (1) {
      Flow flow = visit(curr->body);
      if (flow.breaking()) {
        if (flow.breakTo == curr->name) {
          if (maxLoopIterations != NO_LIMIT &&
              ++loopCount >= maxLoopIterations) {
            return Flow(NONCONSTANT_FLOW);
          }
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
      condition = conditionFlow.getSingleValue().getInteger() != 0;
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
    Literals values;
    if (curr->value) {
      flow = visit(curr->value);
      if (flow.breaking()) {
        return flow;
      }
      values = flow.values;
    }
    flow = visit(curr->condition);
    if (flow.breaking()) {
      return flow;
    }
    int64_t index = flow.getSingleValue().getInteger();
    Name target = curr->default_;
    if (index >= 0 && (size_t)index < curr->targets.size()) {
      target = curr->targets[(size_t)index];
    }
    flow.breakTo = target;
    flow.values = values;
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
    Literal value = flow.getSingleValue();
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
      case AnyTrueVec128:
        return value.anyTrueV128();
      case AbsVecI8x16:
        return value.absI8x16();
      case NegVecI8x16:
        return value.negI8x16();
      case AllTrueVecI8x16:
        return value.allTrueI8x16();
      case BitmaskVecI8x16:
        return value.bitmaskI8x16();
      case PopcntVecI8x16:
        return value.popcntI8x16();
      case AbsVecI16x8:
        return value.absI16x8();
      case NegVecI16x8:
        return value.negI16x8();
      case AllTrueVecI16x8:
        return value.allTrueI16x8();
      case BitmaskVecI16x8:
        return value.bitmaskI16x8();
      case AbsVecI32x4:
        return value.absI32x4();
      case NegVecI32x4:
        return value.negI32x4();
      case AllTrueVecI32x4:
        return value.allTrueI32x4();
      case BitmaskVecI32x4:
        return value.bitmaskI32x4();
      case AbsVecI64x2:
        return value.absI64x2();
      case NegVecI64x2:
        return value.negI64x2();
      case AllTrueVecI64x2:
        return value.allTrueI64x2();
      case BitmaskVecI64x2:
        return value.bitmaskI64x2();
      case AbsVecF32x4:
        return value.absF32x4();
      case NegVecF32x4:
        return value.negF32x4();
      case SqrtVecF32x4:
        return value.sqrtF32x4();
      case CeilVecF32x4:
        return value.ceilF32x4();
      case FloorVecF32x4:
        return value.floorF32x4();
      case TruncVecF32x4:
        return value.truncF32x4();
      case NearestVecF32x4:
        return value.nearestF32x4();
      case AbsVecF64x2:
        return value.absF64x2();
      case NegVecF64x2:
        return value.negF64x2();
      case SqrtVecF64x2:
        return value.sqrtF64x2();
      case CeilVecF64x2:
        return value.ceilF64x2();
      case FloorVecF64x2:
        return value.floorF64x2();
      case TruncVecF64x2:
        return value.truncF64x2();
      case NearestVecF64x2:
        return value.nearestF64x2();
      case ExtAddPairwiseSVecI8x16ToI16x8:
        return value.extAddPairwiseToSI16x8();
      case ExtAddPairwiseUVecI8x16ToI16x8:
        return value.extAddPairwiseToUI16x8();
      case ExtAddPairwiseSVecI16x8ToI32x4:
        return value.extAddPairwiseToSI32x4();
      case ExtAddPairwiseUVecI16x8ToI32x4:
        return value.extAddPairwiseToUI32x4();
      case TruncSatSVecF32x4ToVecI32x4:
      case RelaxedTruncSVecF32x4ToVecI32x4:
        return value.truncSatToSI32x4();
      case TruncSatUVecF32x4ToVecI32x4:
      case RelaxedTruncUVecF32x4ToVecI32x4:
        return value.truncSatToUI32x4();
      case ConvertSVecI32x4ToVecF32x4:
        return value.convertSToF32x4();
      case ConvertUVecI32x4ToVecF32x4:
        return value.convertUToF32x4();
      case ExtendLowSVecI8x16ToVecI16x8:
        return value.extendLowSToI16x8();
      case ExtendHighSVecI8x16ToVecI16x8:
        return value.extendHighSToI16x8();
      case ExtendLowUVecI8x16ToVecI16x8:
        return value.extendLowUToI16x8();
      case ExtendHighUVecI8x16ToVecI16x8:
        return value.extendHighUToI16x8();
      case ExtendLowSVecI16x8ToVecI32x4:
        return value.extendLowSToI32x4();
      case ExtendHighSVecI16x8ToVecI32x4:
        return value.extendHighSToI32x4();
      case ExtendLowUVecI16x8ToVecI32x4:
        return value.extendLowUToI32x4();
      case ExtendHighUVecI16x8ToVecI32x4:
        return value.extendHighUToI32x4();
      case ExtendLowSVecI32x4ToVecI64x2:
        return value.extendLowSToI64x2();
      case ExtendHighSVecI32x4ToVecI64x2:
        return value.extendHighSToI64x2();
      case ExtendLowUVecI32x4ToVecI64x2:
        return value.extendLowUToI64x2();
      case ExtendHighUVecI32x4ToVecI64x2:
        return value.extendHighUToI64x2();
      case ConvertLowSVecI32x4ToVecF64x2:
        return value.convertLowSToF64x2();
      case ConvertLowUVecI32x4ToVecF64x2:
        return value.convertLowUToF64x2();
      case TruncSatZeroSVecF64x2ToVecI32x4:
      case RelaxedTruncZeroSVecF64x2ToVecI32x4:
        return value.truncSatZeroSToI32x4();
      case TruncSatZeroUVecF64x2ToVecI32x4:
      case RelaxedTruncZeroUVecF64x2ToVecI32x4:
        return value.truncSatZeroUToI32x4();
      case DemoteZeroVecF64x2ToVecF32x4:
        return value.demoteZeroToF32x4();
      case PromoteLowVecF32x4ToVecF64x2:
        return value.promoteLowToF64x2();
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
    Literal left = flow.getSingleValue();
    flow = visit(curr->right);
    if (flow.breaking()) {
      return flow;
    }
    Literal right = flow.getSingleValue();
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
      case EqVecI64x2:
        return left.eqI64x2(right);
      case NeVecI64x2:
        return left.neI64x2(right);
      case LtSVecI64x2:
        return left.ltSI64x2(right);
      case GtSVecI64x2:
        return left.gtSI64x2(right);
      case LeSVecI64x2:
        return left.leSI64x2(right);
      case GeSVecI64x2:
        return left.geSI64x2(right);
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
      case MinSVecI8x16:
        return left.minSI8x16(right);
      case MinUVecI8x16:
        return left.minUI8x16(right);
      case MaxSVecI8x16:
        return left.maxSI8x16(right);
      case MaxUVecI8x16:
        return left.maxUI8x16(right);
      case AvgrUVecI8x16:
        return left.avgrUI8x16(right);
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
      case AvgrUVecI16x8:
        return left.avgrUI16x8(right);
      case Q15MulrSatSVecI16x8:
      case RelaxedQ15MulrSVecI16x8:
        return left.q15MulrSatSI16x8(right);
      case ExtMulLowSVecI16x8:
        return left.extMulLowSI16x8(right);
      case ExtMulHighSVecI16x8:
        return left.extMulHighSI16x8(right);
      case ExtMulLowUVecI16x8:
        return left.extMulLowUI16x8(right);
      case ExtMulHighUVecI16x8:
        return left.extMulHighUI16x8(right);
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
      case ExtMulLowSVecI32x4:
        return left.extMulLowSI32x4(right);
      case ExtMulHighSVecI32x4:
        return left.extMulHighSI32x4(right);
      case ExtMulLowUVecI32x4:
        return left.extMulLowUI32x4(right);
      case ExtMulHighUVecI32x4:
        return left.extMulHighUI32x4(right);
      case AddVecI64x2:
        return left.addI64x2(right);
      case SubVecI64x2:
        return left.subI64x2(right);
      case MulVecI64x2:
        return left.mulI64x2(right);
      case ExtMulLowSVecI64x2:
        return left.extMulLowSI64x2(right);
      case ExtMulHighSVecI64x2:
        return left.extMulHighSI64x2(right);
      case ExtMulLowUVecI64x2:
        return left.extMulLowUI64x2(right);
      case ExtMulHighUVecI64x2:
        return left.extMulHighUI64x2(right);

      case AddVecF32x4:
        return left.addF32x4(right);
      case SubVecF32x4:
        return left.subF32x4(right);
      case MulVecF32x4:
        return left.mulF32x4(right);
      case DivVecF32x4:
        return left.divF32x4(right);
      case MinVecF32x4:
      case RelaxedMinVecF32x4:
        return left.minF32x4(right);
      case MaxVecF32x4:
      case RelaxedMaxVecF32x4:
        return left.maxF32x4(right);
      case PMinVecF32x4:
        return left.pminF32x4(right);
      case PMaxVecF32x4:
        return left.pmaxF32x4(right);
      case AddVecF64x2:
        return left.addF64x2(right);
      case SubVecF64x2:
        return left.subF64x2(right);
      case MulVecF64x2:
        return left.mulF64x2(right);
      case DivVecF64x2:
        return left.divF64x2(right);
      case MinVecF64x2:
      case RelaxedMinVecF64x2:
        return left.minF64x2(right);
      case MaxVecF64x2:
      case RelaxedMaxVecF64x2:
        return left.maxF64x2(right);
      case PMinVecF64x2:
        return left.pminF64x2(right);
      case PMaxVecF64x2:
        return left.pmaxF64x2(right);

      case NarrowSVecI16x8ToVecI8x16:
        return left.narrowSToI8x16(right);
      case NarrowUVecI16x8ToVecI8x16:
        return left.narrowUToI8x16(right);
      case NarrowSVecI32x4ToVecI16x8:
        return left.narrowSToI16x8(right);
      case NarrowUVecI32x4ToVecI16x8:
        return left.narrowUToI16x8(right);

      case SwizzleVecI8x16:
      case RelaxedSwizzleVecI8x16:
        return left.swizzleI8x16(right);

      case DotI8x16I7x16SToVecI16x8:
        return left.dotSI8x16toI16x8(right);

      case InvalidBinary:
        WASM_UNREACHABLE("invalid binary op");
    }
    WASM_UNREACHABLE("invalid op");
  }
  Flow visitSIMDExtract(SIMDExtract* curr) {
    NOTE_ENTER("SIMDExtract");
    Flow flow = self()->visit(curr->vec);
    if (flow.breaking()) {
      return flow;
    }
    Literal vec = flow.getSingleValue();
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
    Flow flow = self()->visit(curr->vec);
    if (flow.breaking()) {
      return flow;
    }
    Literal vec = flow.getSingleValue();
    flow = self()->visit(curr->value);
    if (flow.breaking()) {
      return flow;
    }
    Literal value = flow.getSingleValue();
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
    Flow flow = self()->visit(curr->left);
    if (flow.breaking()) {
      return flow;
    }
    Literal left = flow.getSingleValue();
    flow = self()->visit(curr->right);
    if (flow.breaking()) {
      return flow;
    }
    Literal right = flow.getSingleValue();
    return left.shuffleV8x16(right, curr->mask);
  }
  Flow visitSIMDTernary(SIMDTernary* curr) {
    NOTE_ENTER("SIMDBitselect");
    Flow flow = self()->visit(curr->a);
    if (flow.breaking()) {
      return flow;
    }
    Literal a = flow.getSingleValue();
    flow = self()->visit(curr->b);
    if (flow.breaking()) {
      return flow;
    }
    Literal b = flow.getSingleValue();
    flow = self()->visit(curr->c);
    if (flow.breaking()) {
      return flow;
    }
    Literal c = flow.getSingleValue();
    switch (curr->op) {
      case Bitselect:
      case LaneselectI8x16:
      case LaneselectI16x8:
      case LaneselectI32x4:
      case LaneselectI64x2:
        return c.bitselectV128(a, b);

      case RelaxedFmaVecF32x4:
        return a.relaxedFmaF32x4(b, c);
      case RelaxedFmsVecF32x4:
        return a.relaxedFmsF32x4(b, c);
      case RelaxedFmaVecF64x2:
        return a.relaxedFmaF64x2(b, c);
      case RelaxedFmsVecF64x2:
        return a.relaxedFmsF64x2(b, c);
      default:
        // TODO: implement signselect and dot_add
        WASM_UNREACHABLE("not implemented");
    }
  }
  Flow visitSIMDShift(SIMDShift* curr) {
    NOTE_ENTER("SIMDShift");
    Flow flow = self()->visit(curr->vec);
    if (flow.breaking()) {
      return flow;
    }
    Literal vec = flow.getSingleValue();
    flow = self()->visit(curr->shift);
    if (flow.breaking()) {
      return flow;
    }
    Literal shift = flow.getSingleValue();
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
    NOTE_EVAL1(condition.getSingleValue());
    return condition.getSingleValue().geti32() ? ifTrue : ifFalse; // ;-)
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
      NOTE_EVAL1(flow.getSingleValue());
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
    if (curr->type == Type::i32) {
      if (value.type == Type::f32) {
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
      if (value.type == Type::f32) {
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
    if (curr->type == Type::i32) {
      if (value.type == Type::f32) {
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
      if (value.type == Type::f32) {
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
  Flow visitAtomicFence(AtomicFence* curr) {
    // Wasm currently supports only sequentially consistent atomics, in which
    // case atomic_fence can be lowered to nothing.
    NOTE_ENTER("AtomicFence");
    return Flow();
  }
  Flow visitTupleMake(TupleMake* curr) {
    NOTE_ENTER("tuple.make");
    Literals arguments;
    Flow flow = generateArguments(curr->operands, arguments);
    if (flow.breaking()) {
      return flow;
    }
    for (auto arg : arguments) {
      assert(arg.type.isConcrete());
      flow.values.push_back(arg);
    }
    return flow;
  }
  Flow visitTupleExtract(TupleExtract* curr) {
    NOTE_ENTER("tuple.extract");
    Flow flow = visit(curr->tuple);
    if (flow.breaking()) {
      return flow;
    }
    assert(flow.values.size() > curr->index);
    return Flow(flow.values[curr->index]);
  }
  Flow visitLocalGet(LocalGet* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitLocalSet(LocalSet* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitGlobalGet(GlobalGet* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitGlobalSet(GlobalSet* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitCall(Call* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitCallIndirect(CallIndirect* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitLoad(Load* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitStore(Store* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitMemorySize(MemorySize* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitMemoryGrow(MemoryGrow* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitMemoryInit(MemoryInit* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitDataDrop(DataDrop* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitMemoryCopy(MemoryCopy* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitMemoryFill(MemoryFill* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitAtomicRMW(AtomicRMW* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitAtomicCmpxchg(AtomicCmpxchg* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitAtomicWait(AtomicWait* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitAtomicNotify(AtomicNotify* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitSIMDLoad(SIMDLoad* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitSIMDLoadSplat(SIMDLoad* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitSIMDLoadExtend(SIMDLoad* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitSIMDLoadZero(SIMDLoad* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    WASM_UNREACHABLE("unimp");
  }
  Flow visitPop(Pop* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitCallRef(CallRef* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitRefNull(RefNull* curr) {
    NOTE_ENTER("RefNull");
    return Literal::makeNull(curr->type.getHeapType());
  }
  Flow visitRefIsNull(RefIsNull* curr) {
    NOTE_ENTER("RefIsNull");
    Flow flow = visit(curr->value);
    if (flow.breaking()) {
      return flow;
    }
    const auto& value = flow.getSingleValue();
    NOTE_EVAL1(value);
    return Literal(int32_t(value.isNull()));
  }
  Flow visitRefFunc(RefFunc* curr) {
    NOTE_ENTER("RefFunc");
    NOTE_NAME(curr->func);
    return Literal::makeFunc(curr->func, curr->type.getHeapType());
  }
  Flow visitRefEq(RefEq* curr) {
    NOTE_ENTER("RefEq");
    Flow flow = visit(curr->left);
    if (flow.breaking()) {
      return flow;
    }
    auto left = flow.getSingleValue();
    flow = visit(curr->right);
    if (flow.breaking()) {
      return flow;
    }
    auto right = flow.getSingleValue();
    NOTE_EVAL2(left, right);
    return Literal(int32_t(left == right));
  }
  Flow visitTableGet(TableGet* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitTableSet(TableSet* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitTableSize(TableSize* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitTableGrow(TableGrow* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitTableFill(TableFill* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitTableCopy(TableCopy* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitTry(Try* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitTryTable(TryTable* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitThrow(Throw* curr) {
    NOTE_ENTER("Throw");
    Literals arguments;
    Flow flow = generateArguments(curr->operands, arguments);
    if (flow.breaking()) {
      return flow;
    }
    NOTE_EVAL1(curr->tag);
    WasmException exn;
    exn.tag = curr->tag;
    for (auto item : arguments) {
      exn.values.push_back(item);
    }
    throwException(exn);
    WASM_UNREACHABLE("throw");
  }
  Flow visitRethrow(Rethrow* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitThrowRef(ThrowRef* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitRefI31(RefI31* curr) {
    NOTE_ENTER("RefI31");
    Flow flow = visit(curr->value);
    if (flow.breaking()) {
      return flow;
    }
    const auto& value = flow.getSingleValue();
    NOTE_EVAL1(value);
    return Literal::makeI31(value.geti32());
  }
  Flow visitI31Get(I31Get* curr) {
    NOTE_ENTER("I31Get");
    Flow flow = visit(curr->i31);
    if (flow.breaking()) {
      return flow;
    }
    const auto& value = flow.getSingleValue();
    NOTE_EVAL1(value);
    if (value.isNull()) {
      trap("null ref");
    }
    return Literal(value.geti31(curr->signed_));
  }

  // Helper for ref.test, ref.cast, and br_on_cast, which share almost all their
  // logic except for what they return.
  struct Cast {
    // The control flow that preempts the cast.
    struct Breaking : Flow {
      Breaking(Flow breaking) : Flow(breaking) {}
    };
    // The result of the successful cast.
    struct Success : Literal {
      Success(Literal result) : Literal(result) {}
    };
    // The input to a failed cast.
    struct Failure : Literal {
      Failure(Literal original) : Literal(original) {}
    };

    std::variant<Breaking, Success, Failure> state;

    template<class T> Cast(T state) : state(state) {}
    Flow* getBreaking() { return std::get_if<Breaking>(&state); }
    Literal* getSuccess() { return std::get_if<Success>(&state); }
    Literal* getFailure() { return std::get_if<Failure>(&state); }
  };

  template<typename T> Cast doCast(T* curr) {
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return typename Cast::Breaking{ref};
    }
    Literal val = ref.getSingleValue();
    Type castType = curr->getCastType();
    if (val.isNull()) {
      if (castType.isNullable()) {
        return typename Cast::Success{val};
      } else {
        return typename Cast::Failure{val};
      }
    }
    if (HeapType::isSubType(val.type.getHeapType(), castType.getHeapType())) {
      return typename Cast::Success{val};
    } else {
      return typename Cast::Failure{val};
    }
  }

  Flow visitRefTest(RefTest* curr) {
    NOTE_ENTER("RefTest");
    auto cast = doCast(curr);
    if (auto* breaking = cast.getBreaking()) {
      return *breaking;
    } else {
      return Literal(int32_t(bool(cast.getSuccess())));
    }
  }
  Flow visitRefCast(RefCast* curr) {
    NOTE_ENTER("RefCast");
    auto cast = doCast(curr);
    if (auto* breaking = cast.getBreaking()) {
      return *breaking;
    } else if (auto* result = cast.getSuccess()) {
      return *result;
    }
    assert(cast.getFailure());
    trap("cast error");
    WASM_UNREACHABLE("unreachable");
  }
  Flow visitBrOn(BrOn* curr) {
    NOTE_ENTER("BrOn");
    // BrOnCast* uses the casting infrastructure, so handle them first.
    if (curr->op == BrOnCast || curr->op == BrOnCastFail) {
      auto cast = doCast(curr);
      if (auto* breaking = cast.getBreaking()) {
        return *breaking;
      } else if (auto* original = cast.getFailure()) {
        if (curr->op == BrOnCast) {
          return *original;
        } else {
          return Flow(curr->name, *original);
        }
      } else {
        auto* result = cast.getSuccess();
        assert(result);
        if (curr->op == BrOnCast) {
          return Flow(curr->name, *result);
        } else {
          return *result;
        }
      }
    }
    // Otherwise we are just checking for null.
    Flow flow = visit(curr->ref);
    if (flow.breaking()) {
      return flow;
    }
    const auto& value = flow.getSingleValue();
    NOTE_EVAL1(value);
    if (curr->op == BrOnNull) {
      // BrOnNull does not propagate the value if it takes the branch.
      if (value.isNull()) {
        return Flow(curr->name);
      }
      // If the branch is not taken, we return the non-null value.
      return {value};
    } else {
      // BrOnNonNull does not return a value if it does not take the branch.
      if (value.isNull()) {
        return Flow();
      }
      // If the branch is taken, we send the non-null value.
      return Flow(curr->name, value);
    }
  }
  Flow visitStructNew(StructNew* curr) {
    NOTE_ENTER("StructNew");
    if (curr->type == Type::unreachable) {
      // We cannot proceed to compute the heap type, as there isn't one. Just
      // find why we are unreachable, and stop there.
      for (auto* operand : curr->operands) {
        auto value = self()->visit(operand);
        if (value.breaking()) {
          return value;
        }
      }
      WASM_UNREACHABLE("unreachable but no unreachable child");
    }
    auto heapType = curr->type.getHeapType();
    const auto& fields = heapType.getStruct().fields;
    Literals data(fields.size());
    for (Index i = 0; i < fields.size(); i++) {
      auto& field = fields[i];
      if (curr->isWithDefault()) {
        data[i] = Literal::makeZero(field.type);
      } else {
        auto value = self()->visit(curr->operands[i]);
        if (value.breaking()) {
          return value;
        }
        data[i] = truncateForPacking(value.getSingleValue(), field);
      }
    }
    return makeGCData(data, curr->type);
  }
  Flow visitStructGet(StructGet* curr) {
    NOTE_ENTER("StructGet");
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    auto data = ref.getSingleValue().getGCData();
    if (!data) {
      trap("null ref");
    }
    auto field = curr->ref->type.getHeapType().getStruct().fields[curr->index];
    return extendForPacking(data->values[curr->index], field, curr->signed_);
  }
  Flow visitStructSet(StructSet* curr) {
    NOTE_ENTER("StructSet");
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    Flow value = self()->visit(curr->value);
    if (value.breaking()) {
      return value;
    }
    auto data = ref.getSingleValue().getGCData();
    if (!data) {
      trap("null ref");
    }
    auto field = curr->ref->type.getHeapType().getStruct().fields[curr->index];
    data->values[curr->index] =
      truncateForPacking(value.getSingleValue(), field);
    return Flow();
  }

  // Arbitrary deterministic limit on size. If we need to allocate a Literals
  // vector that takes around 1-2GB of memory then we are likely to hit memory
  // limits on 32-bit machines, and in particular on wasm32 VMs that do not
  // have 4GB support, so give up there.
  static const Index ArrayLimit = (1 << 30) / sizeof(Literal);

  Flow visitArrayNew(ArrayNew* curr) {
    NOTE_ENTER("ArrayNew");
    Flow init;
    if (!curr->isWithDefault()) {
      init = self()->visit(curr->init);
      if (init.breaking()) {
        return init;
      }
    }
    auto size = self()->visit(curr->size);
    if (size.breaking()) {
      return size;
    }
    if (curr->type == Type::unreachable) {
      // We cannot proceed to compute the heap type, as there isn't one. Just
      // visit the unreachable child, and stop there.
      auto init = self()->visit(curr->init);
      assert(init.breaking());
      return init;
    }
    auto heapType = curr->type.getHeapType();
    const auto& element = heapType.getArray().element;
    Index num = size.getSingleValue().geti32();
    if (num >= ArrayLimit) {
      hostLimit("allocation failure");
    }
    Literals data(num);
    if (curr->isWithDefault()) {
      auto zero = Literal::makeZero(element.type);
      for (Index i = 0; i < num; i++) {
        data[i] = zero;
      }
    } else {
      auto field = curr->type.getHeapType().getArray().element;
      auto value = truncateForPacking(init.getSingleValue(), field);
      for (Index i = 0; i < num; i++) {
        data[i] = value;
      }
    }
    return makeGCData(data, curr->type);
  }
  Flow visitArrayNewData(ArrayNewData* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitArrayNewElem(ArrayNewElem* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitArrayNewFixed(ArrayNewFixed* curr) {
    NOTE_ENTER("ArrayNewFixed");
    Index num = curr->values.size();
    if (num >= ArrayLimit) {
      hostLimit("allocation failure");
    }
    if (curr->type == Type::unreachable) {
      // We cannot proceed to compute the heap type, as there isn't one. Just
      // find why we are unreachable, and stop there.
      for (auto* value : curr->values) {
        auto result = self()->visit(value);
        if (result.breaking()) {
          return result;
        }
      }
      WASM_UNREACHABLE("unreachable but no unreachable child");
    }
    auto heapType = curr->type.getHeapType();
    auto field = heapType.getArray().element;
    Literals data(num);
    for (Index i = 0; i < num; i++) {
      auto value = self()->visit(curr->values[i]);
      if (value.breaking()) {
        return value;
      }
      data[i] = truncateForPacking(value.getSingleValue(), field);
    }
    return makeGCData(data, curr->type);
  }
  Flow visitArrayGet(ArrayGet* curr) {
    NOTE_ENTER("ArrayGet");
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    Flow index = self()->visit(curr->index);
    if (index.breaking()) {
      return index;
    }
    auto data = ref.getSingleValue().getGCData();
    if (!data) {
      trap("null ref");
    }
    Index i = index.getSingleValue().geti32();
    if (i >= data->values.size()) {
      trap("array oob");
    }
    auto field = curr->ref->type.getHeapType().getArray().element;
    return extendForPacking(data->values[i], field, curr->signed_);
  }
  Flow visitArraySet(ArraySet* curr) {
    NOTE_ENTER("ArraySet");
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    Flow index = self()->visit(curr->index);
    if (index.breaking()) {
      return index;
    }
    Flow value = self()->visit(curr->value);
    if (value.breaking()) {
      return value;
    }
    auto data = ref.getSingleValue().getGCData();
    if (!data) {
      trap("null ref");
    }
    Index i = index.getSingleValue().geti32();
    if (i >= data->values.size()) {
      trap("array oob");
    }
    auto field = curr->ref->type.getHeapType().getArray().element;
    data->values[i] = truncateForPacking(value.getSingleValue(), field);
    return Flow();
  }
  Flow visitArrayLen(ArrayLen* curr) {
    NOTE_ENTER("ArrayLen");
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    auto data = ref.getSingleValue().getGCData();
    if (!data) {
      trap("null ref");
    }
    return Literal(int32_t(data->values.size()));
  }
  Flow visitArrayCopy(ArrayCopy* curr) {
    NOTE_ENTER("ArrayCopy");
    Flow destRef = self()->visit(curr->destRef);
    if (destRef.breaking()) {
      return destRef;
    }
    Flow destIndex = self()->visit(curr->destIndex);
    if (destIndex.breaking()) {
      return destIndex;
    }
    Flow srcRef = self()->visit(curr->srcRef);
    if (srcRef.breaking()) {
      return srcRef;
    }
    Flow srcIndex = self()->visit(curr->srcIndex);
    if (srcIndex.breaking()) {
      return srcIndex;
    }
    Flow length = self()->visit(curr->length);
    if (length.breaking()) {
      return length;
    }
    auto destData = destRef.getSingleValue().getGCData();
    if (!destData) {
      trap("null ref");
    }
    auto srcData = srcRef.getSingleValue().getGCData();
    if (!srcData) {
      trap("null ref");
    }
    size_t destVal = destIndex.getSingleValue().getUnsigned();
    size_t srcVal = srcIndex.getSingleValue().getUnsigned();
    size_t lengthVal = length.getSingleValue().getUnsigned();
    if (destVal + lengthVal > destData->values.size()) {
      trap("oob");
    }
    if (srcVal + lengthVal > srcData->values.size()) {
      trap("oob");
    }
    std::vector<Literal> copied;
    copied.resize(lengthVal);
    for (size_t i = 0; i < lengthVal; i++) {
      copied[i] = srcData->values[srcVal + i];
    }
    for (size_t i = 0; i < lengthVal; i++) {
      destData->values[destVal + i] = copied[i];
    }
    return Flow();
  }
  Flow visitArrayFill(ArrayFill* curr) {
    NOTE_ENTER("ArrayFill");
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    Flow index = self()->visit(curr->index);
    if (index.breaking()) {
      return index;
    }
    Flow value = self()->visit(curr->value);
    if (value.breaking()) {
      return value;
    }
    Flow size = self()->visit(curr->size);
    if (size.breaking()) {
      return size;
    }
    auto data = ref.getSingleValue().getGCData();
    if (!data) {
      trap("null ref");
    }
    size_t indexVal = index.getSingleValue().getUnsigned();
    Literal fillVal = value.getSingleValue();
    size_t sizeVal = size.getSingleValue().getUnsigned();

    auto field = curr->ref->type.getHeapType().getArray().element;
    fillVal = truncateForPacking(fillVal, field);

    size_t arraySize = data->values.size();
    if (indexVal > arraySize || sizeVal > arraySize ||
        indexVal + sizeVal > arraySize || indexVal + sizeVal < indexVal) {
      trap("out of bounds array access in array.fill");
    }
    for (size_t i = 0; i < sizeVal; ++i) {
      data->values[indexVal + i] = fillVal;
    }
    return {};
  }
  Flow visitArrayInitData(ArrayInitData* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitArrayInitElem(ArrayInitElem* curr) { WASM_UNREACHABLE("unimp"); }
  Flow visitRefAs(RefAs* curr) {
    NOTE_ENTER("RefAs");
    Flow flow = visit(curr->value);
    if (flow.breaking()) {
      return flow;
    }
    const auto& value = flow.getSingleValue();
    NOTE_EVAL1(value);
    switch (curr->op) {
      case RefAsNonNull:
        if (value.isNull()) {
          trap("null ref");
        }
        return value;
      case ExternInternalize:
        return value.internalize();
      case ExternExternalize:
        return value.externalize();
    }
    WASM_UNREACHABLE("unimplemented ref.as_*");
  }
  Flow visitStringNew(StringNew* curr) {
    Flow ptr = visit(curr->ptr);
    if (ptr.breaking()) {
      return ptr;
    }
    switch (curr->op) {
      case StringNewWTF16Array: {
        Flow start = visit(curr->start);
        if (start.breaking()) {
          return start;
        }
        Flow end = visit(curr->end);
        if (end.breaking()) {
          return end;
        }
        auto ptrData = ptr.getSingleValue().getGCData();
        if (!ptrData) {
          trap("null ref");
        }
        const auto& ptrDataValues = ptrData->values;
        size_t startVal = start.getSingleValue().getUnsigned();
        size_t endVal = end.getSingleValue().getUnsigned();
        if (startVal > ptrDataValues.size() || endVal > ptrDataValues.size() ||
            endVal < startVal) {
          trap("array oob");
        }
        Literals contents;
        if (endVal > startVal) {
          contents.reserve(endVal - startVal);
          for (size_t i = startVal; i < endVal; i++) {
            contents.push_back(ptrDataValues[i]);
          }
        }
        return makeGCData(contents, curr->type);
      }
      default:
        // TODO: others
        return Flow(NONCONSTANT_FLOW);
    }
  }
  Flow visitStringConst(StringConst* curr) { return Literal(curr->string.str); }

  Flow visitStringMeasure(StringMeasure* curr) {
    // For now we only support JS-style strings.
    if (curr->op != StringMeasureWTF16View) {
      return Flow(NONCONSTANT_FLOW);
    }

    Flow flow = visit(curr->ref);
    if (flow.breaking()) {
      return flow;
    }
    auto value = flow.getSingleValue();
    auto data = value.getGCData();
    if (!data) {
      trap("null ref");
    }

    return Literal(int32_t(data->values.size()));
  }
  Flow visitStringConcat(StringConcat* curr) {
    NOTE_ENTER("StringConcat");
    Flow flow = visit(curr->left);
    if (flow.breaking()) {
      return flow;
    }
    auto left = flow.getSingleValue();
    flow = visit(curr->right);
    if (flow.breaking()) {
      return flow;
    }
    auto right = flow.getSingleValue();
    NOTE_EVAL2(left, right);
    auto leftData = left.getGCData();
    auto rightData = right.getGCData();
    if (!leftData || !rightData) {
      trap("null ref");
    }

    Literals contents;
    contents.reserve(leftData->values.size() + rightData->values.size());
    for (Literal& l : leftData->values) {
      contents.push_back(l);
    }
    for (Literal& l : rightData->values) {
      contents.push_back(l);
    }

    return makeGCData(contents, curr->type);
  }
  Flow visitStringEncode(StringEncode* curr) {
    // For now we only support JS-style strings into arrays.
    if (curr->op != StringEncodeWTF16Array) {
      return Flow(NONCONSTANT_FLOW);
    }

    Flow ref = visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    // TODO: "WTF-16 position treatment", as in stringview_wtf16.slice?
    Flow ptr = visit(curr->ptr);
    if (ptr.breaking()) {
      return ptr;
    }
    Flow start = visit(curr->start);
    if (start.breaking()) {
      return start;
    }

    auto refData = ref.getSingleValue().getGCData();
    auto ptrData = ptr.getSingleValue().getGCData();
    if (!refData || !ptrData) {
      trap("null ref");
    }
    auto startVal = start.getSingleValue().getUnsigned();
    auto& refValues = refData->values;
    auto& ptrValues = ptrData->values;
    size_t end;
    if (std::ckd_add<size_t>(&end, startVal, refValues.size()) ||
        end > ptrValues.size()) {
      trap("oob");
    }

    for (Index i = 0; i < refValues.size(); i++) {
      ptrValues[startVal + i] = refValues[i];
    }

    return Literal(int32_t(refData->values.size()));
  }
  Flow visitStringEq(StringEq* curr) {
    NOTE_ENTER("StringEq");
    Flow flow = visit(curr->left);
    if (flow.breaking()) {
      return flow;
    }
    auto left = flow.getSingleValue();
    flow = visit(curr->right);
    if (flow.breaking()) {
      return flow;
    }
    auto right = flow.getSingleValue();
    NOTE_EVAL2(left, right);
    auto leftData = left.getGCData();
    auto rightData = right.getGCData();
    int32_t result;
    switch (curr->op) {
      case StringEqEqual: {
        // They are equal if both are null, or both are non-null and equal.
        result =
          (!leftData && !rightData) ||
          (leftData && rightData && leftData->values == rightData->values);
        break;
      }
      case StringEqCompare: {
        if (!leftData || !rightData) {
          trap("null ref");
        }
        auto& leftValues = leftData->values;
        auto& rightValues = rightData->values;
        Index i = 0;
        while (1) {
          if (i == leftValues.size() && i == rightValues.size()) {
            // We reached the end, and they are equal.
            result = 0;
            break;
          } else if (i == leftValues.size()) {
            // The left string is short.
            result = -1;
            break;
          } else if (i == rightValues.size()) {
            result = 1;
            break;
          }
          auto left = leftValues[i].getInteger();
          auto right = rightValues[i].getInteger();
          if (left < right) {
            // The left character is lower.
            result = -1;
            break;
          } else if (left > right) {
            result = 1;
            break;
          } else {
            // Look further.
            i++;
          }
        }
        break;
      }
      default: {
        WASM_UNREACHABLE("bad op");
      }
    }
    return Literal(result);
  }
  Flow visitStringAs(StringAs* curr) {
    // For now we only support JS-style strings.
    if (curr->op != StringAsWTF16) {
      return Flow(NONCONSTANT_FLOW);
    }

    Flow flow = visit(curr->ref);
    if (flow.breaking()) {
      return flow;
    }
    auto value = flow.getSingleValue();
    auto data = value.getGCData();
    if (!data) {
      trap("null ref");
    }

    // A JS-style string can be viewed simply as the underlying data. All we
    // need to do is fix up the type.
    return Literal(data, curr->type.getHeapType());
  }
  Flow visitStringWTF8Advance(StringWTF8Advance* curr) {
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitStringWTF16Get(StringWTF16Get* curr) {
    NOTE_ENTER("StringWTF16Get");
    Flow ref = visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    Flow pos = visit(curr->pos);
    if (pos.breaking()) {
      return pos;
    }
    auto refValue = ref.getSingleValue();
    auto data = refValue.getGCData();
    if (!data) {
      trap("null ref");
    }
    auto& values = data->values;
    Index i = pos.getSingleValue().geti32();
    if (i >= values.size()) {
      trap("string oob");
    }

    return Literal(values[i].geti32());
  }
  Flow visitStringIterNext(StringIterNext* curr) {
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitStringIterMove(StringIterMove* curr) {
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitStringSliceWTF(StringSliceWTF* curr) {
    // For now we only support JS-style strings.
    if (curr->op != StringSliceWTF16) {
      return Flow(NONCONSTANT_FLOW);
    }

    Flow ref = visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    Flow start = visit(curr->start);
    if (start.breaking()) {
      return start;
    }
    Flow end = visit(curr->end);
    if (end.breaking()) {
      return end;
    }

    auto refData = ref.getSingleValue().getGCData();
    if (!refData) {
      trap("null ref");
    }
    auto& refValues = refData->values;
    auto startVal = start.getSingleValue().getUnsigned();
    auto endVal = end.getSingleValue().getUnsigned();
    endVal = std::min<size_t>(endVal, refValues.size());

    Literals contents;
    if (endVal > startVal) {
      contents.reserve(endVal - startVal);
      for (size_t i = startVal; i < endVal; i++) {
        if (i < refValues.size()) {
          contents.push_back(refValues[i]);
        }
      }
    }
    return makeGCData(contents, curr->type);
  }
  Flow visitStringSliceIter(StringSliceIter* curr) {
    return Flow(NONCONSTANT_FLOW);
  }

  virtual void trap(const char* why) { WASM_UNREACHABLE("unimp"); }

  virtual void hostLimit(const char* why) { WASM_UNREACHABLE("unimp"); }

  virtual void throwException(const WasmException& exn) {
    WASM_UNREACHABLE("unimp");
  }

private:
  // Truncate the value if we need to. The storage is just a list of Literals,
  // so we can't just write the value like we would to a C struct field and
  // expect it to truncate for us. Instead, we truncate so the stored value is
  // proper for the type.
  Literal truncateForPacking(Literal value, const Field& field) {
    if (field.type == Type::i32) {
      int32_t c = value.geti32();
      if (field.packedType == Field::i8) {
        value = Literal(c & 0xff);
      } else if (field.packedType == Field::i16) {
        value = Literal(c & 0xffff);
      }
    }
    return value;
  }

  Literal extendForPacking(Literal value, const Field& field, bool signed_) {
    if (field.type == Type::i32) {
      int32_t c = value.geti32();
      if (field.packedType == Field::i8) {
        // The stored value should already be truncated.
        assert(c == (c & 0xff));
        if (signed_) {
          value = Literal((c << 24) >> 24);
        }
      } else if (field.packedType == Field::i16) {
        assert(c == (c & 0xffff));
        if (signed_) {
          value = Literal((c << 16) >> 16);
        }
      }
    }
    return value;
  }
};

// Execute a suspected constant expression (precompute and C-API).
template<typename SubType>
class ConstantExpressionRunner : public ExpressionRunner<SubType> {
public:
  enum FlagValues {
    // By default, just evaluate the expression, i.e. all we want to know is
    // whether it computes down to a concrete value, where it is not necessary
    // to preserve side effects like those of a `local.tee`.
    DEFAULT = 0,
    // Be very careful to preserve any side effects. For example, if we are
    // intending to replace the expression with a constant afterwards, even if
    // we can technically evaluate down to a constant, we still cannot replace
    // the expression if it also sets a local, which must be preserved in this
    // scenario so subsequent code keeps functioning.
    PRESERVE_SIDEEFFECTS = 1 << 0,
  };

  // Flags indicating special requirements, for example whether we are just
  // evaluating (default), also going to replace the expression afterwards or
  // executing in a function-parallel scenario. See FlagValues.
  using Flags = uint32_t;

  // Indicates no limit of maxDepth or maxLoopIterations.
  static const Index NO_LIMIT = 0;

protected:
  // Flags indicating special requirements. See FlagValues.
  Flags flags = FlagValues::DEFAULT;

  // Map remembering concrete local values set in the context of this flow.
  std::unordered_map<Index, Literals> localValues;
  // Map remembering concrete global values set in the context of this flow.
  std::unordered_map<Name, Literals> globalValues;

public:
  struct NonconstantException {
  }; // TODO: use a flow with a special name, as this is likely very slow

  ConstantExpressionRunner(Module* module,
                           Flags flags,
                           Index maxDepth,
                           Index maxLoopIterations)
    : ExpressionRunner<SubType>(module, maxDepth, maxLoopIterations),
      flags(flags) {}

  // Sets a known local value to use.
  void setLocalValue(Index index, Literals& values) {
    assert(values.isConcrete());
    localValues[index] = values;
  }

  // Sets a known global value to use.
  void setGlobalValue(Name name, Literals& values) {
    assert(values.isConcrete());
    globalValues[name] = values;
  }

  Flow visitLocalGet(LocalGet* curr) {
    NOTE_ENTER("LocalGet");
    NOTE_EVAL1(curr->index);
    // Check if a constant value has been set in the context of this runner.
    auto iter = localValues.find(curr->index);
    if (iter != localValues.end()) {
      return Flow(iter->second);
    }
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitLocalSet(LocalSet* curr) {
    NOTE_ENTER("LocalSet");
    NOTE_EVAL1(curr->index);
    if (!(flags & FlagValues::PRESERVE_SIDEEFFECTS)) {
      // If we are evaluating and not replacing the expression, remember the
      // constant value set, if any, and see if there is a value flowing through
      // a tee.
      auto setFlow = ExpressionRunner<SubType>::visit(curr->value);
      if (!setFlow.breaking()) {
        setLocalValue(curr->index, setFlow.values);
        if (curr->type.isConcrete()) {
          assert(curr->isTee());
          return setFlow;
        }
        return Flow();
      }
    }
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitGlobalGet(GlobalGet* curr) {
    NOTE_ENTER("GlobalGet");
    NOTE_NAME(curr->name);
    if (this->module != nullptr) {
      auto* global = this->module->getGlobal(curr->name);
      // Check if the global has an immutable value anyway
      if (!global->imported() && !global->mutable_) {
        return ExpressionRunner<SubType>::visit(global->init);
      }
    }
    // Check if a constant value has been set in the context of this runner.
    auto iter = globalValues.find(curr->name);
    if (iter != globalValues.end()) {
      return Flow(iter->second);
    }
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitGlobalSet(GlobalSet* curr) {
    NOTE_ENTER("GlobalSet");
    NOTE_NAME(curr->name);
    if (!(flags & FlagValues::PRESERVE_SIDEEFFECTS) &&
        this->module != nullptr) {
      // If we are evaluating and not replacing the expression, remember the
      // constant value set, if any, for subsequent gets.
      assert(this->module->getGlobal(curr->name)->mutable_);
      auto setFlow = ExpressionRunner<SubType>::visit(curr->value);
      if (!setFlow.breaking()) {
        setGlobalValue(curr->name, setFlow.values);
        return Flow();
      }
    }
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitCall(Call* curr) {
    NOTE_ENTER("Call");
    NOTE_NAME(curr->target);
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitCallIndirect(CallIndirect* curr) {
    NOTE_ENTER("CallIndirect");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitCallRef(CallRef* curr) {
    NOTE_ENTER("CallRef");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitTableGet(TableGet* curr) {
    NOTE_ENTER("TableGet");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitTableSet(TableSet* curr) {
    NOTE_ENTER("TableSet");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitTableSize(TableSize* curr) {
    NOTE_ENTER("TableSize");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitTableGrow(TableGrow* curr) {
    NOTE_ENTER("TableGrow");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitTableFill(TableFill* curr) {
    NOTE_ENTER("TableFill");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitTableCopy(TableCopy* curr) {
    NOTE_ENTER("TableCopy");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitLoad(Load* curr) {
    NOTE_ENTER("Load");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitStore(Store* curr) {
    NOTE_ENTER("Store");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitMemorySize(MemorySize* curr) {
    NOTE_ENTER("MemorySize");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitMemoryGrow(MemoryGrow* curr) {
    NOTE_ENTER("MemoryGrow");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitMemoryInit(MemoryInit* curr) {
    NOTE_ENTER("MemoryInit");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitDataDrop(DataDrop* curr) {
    NOTE_ENTER("DataDrop");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitMemoryCopy(MemoryCopy* curr) {
    NOTE_ENTER("MemoryCopy");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitMemoryFill(MemoryFill* curr) {
    NOTE_ENTER("MemoryFill");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitAtomicRMW(AtomicRMW* curr) {
    NOTE_ENTER("AtomicRMW");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    NOTE_ENTER("AtomicCmpxchg");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitAtomicWait(AtomicWait* curr) {
    NOTE_ENTER("AtomicWait");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitAtomicNotify(AtomicNotify* curr) {
    NOTE_ENTER("AtomicNotify");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitSIMDLoad(SIMDLoad* curr) {
    NOTE_ENTER("SIMDLoad");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitSIMDLoadSplat(SIMDLoad* curr) {
    NOTE_ENTER("SIMDLoadSplat");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitSIMDLoadExtend(SIMDLoad* curr) {
    NOTE_ENTER("SIMDLoadExtend");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    NOTE_ENTER("SIMDLoadStoreLane");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitArrayNewData(ArrayNewData* curr) {
    NOTE_ENTER("ArrayNewData");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitArrayNewElem(ArrayNewElem* curr) {
    NOTE_ENTER("ArrayNewElem");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitArrayCopy(ArrayCopy* curr) {
    NOTE_ENTER("ArrayCopy");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitArrayFill(ArrayFill* curr) {
    NOTE_ENTER("ArrayFill");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitArrayInitData(ArrayInitData* curr) {
    NOTE_ENTER("ArrayInitData");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitArrayInitElem(ArrayInitElem* curr) {
    NOTE_ENTER("ArrayInitElem");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitPop(Pop* curr) {
    NOTE_ENTER("Pop");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitTry(Try* curr) {
    NOTE_ENTER("Try");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitRethrow(Rethrow* curr) {
    NOTE_ENTER("Rethrow");
    return Flow(NONCONSTANT_FLOW);
  }
  Flow visitRefAs(RefAs* curr) {
    // TODO: Remove this once interpretation is implemented.
    if (curr->op == ExternInternalize || curr->op == ExternExternalize) {
      return Flow(NONCONSTANT_FLOW);
    }
    return ExpressionRunner<SubType>::visitRefAs(curr);
  }
  Flow visitContBind(ContBind* curr) { WASM_UNREACHABLE("unimplemented"); }
  Flow visitContNew(ContNew* curr) { WASM_UNREACHABLE("unimplemented"); }
  Flow visitResume(Resume* curr) { WASM_UNREACHABLE("unimplemented"); }
  Flow visitSuspend(Suspend* curr) { WASM_UNREACHABLE("unimplemented"); }

  void trap(const char* why) override { throw NonconstantException(); }

  void hostLimit(const char* why) override { throw NonconstantException(); }

  virtual void throwException(const WasmException& exn) override {
    throw NonconstantException();
  }
};

using GlobalValueSet = std::map<Name, Literals>;

//
// A runner for a module. Each runner contains the information to execute the
// module, such as the state of globals, and so forth, so it basically
// encapsulates an instantiation of the wasm, and implements all the interpreter
// instructions that use that info (like global.set etc.) that are not declared
// in ExpressionRunner, which just looks at a single instruction.
//
// To embed this interpreter, you need to provide an ExternalInterface instance
// (see below) which provides the embedding-specific details, that is, how to
// connect to the embedding implementation.
//
// To call into the interpreter, use callExport.
//

template<typename SubType>
class ModuleRunnerBase : public ExpressionRunner<SubType> {
public:
  //
  // You need to implement one of these to create a concrete interpreter. The
  // ExternalInterface provides embedding-specific functionality like calling
  // an imported function or accessing memory.
  //
  struct ExternalInterface {
    ExternalInterface(
      std::map<Name, std::shared_ptr<SubType>> linkedInstances = {}) {}
    virtual ~ExternalInterface() = default;
    virtual void init(Module& wasm, SubType& instance) {}
    virtual void importGlobals(GlobalValueSet& globals, Module& wasm) = 0;
    virtual Literals callImport(Function* import,
                                const Literals& arguments) = 0;
    virtual Literals callTable(Name tableName,
                               Index index,
                               HeapType sig,
                               Literals& arguments,
                               Type result,
                               SubType& instance) = 0;
    virtual bool growMemory(Name name, Address oldSize, Address newSize) = 0;
    virtual bool growTable(Name name,
                           const Literal& value,
                           Index oldSize,
                           Index newSize) = 0;
    virtual void trap(const char* why) = 0;
    virtual void hostLimit(const char* why) = 0;
    virtual void throwException(const WasmException& exn) = 0;

    // the default impls for load and store switch on the sizes. you can either
    // customize load/store, or the sub-functions which they call
    virtual Literal load(Load* load, Address addr, Name memory) {
      switch (load->type.getBasic()) {
        case Type::i32: {
          switch (load->bytes) {
            case 1:
              return load->signed_ ? Literal((int32_t)load8s(addr, memory))
                                   : Literal((int32_t)load8u(addr, memory));
            case 2:
              return load->signed_ ? Literal((int32_t)load16s(addr, memory))
                                   : Literal((int32_t)load16u(addr, memory));
            case 4:
              return Literal((int32_t)load32s(addr, memory));
            default:
              WASM_UNREACHABLE("invalid size");
          }
          break;
        }
        case Type::i64: {
          switch (load->bytes) {
            case 1:
              return load->signed_ ? Literal((int64_t)load8s(addr, memory))
                                   : Literal((int64_t)load8u(addr, memory));
            case 2:
              return load->signed_ ? Literal((int64_t)load16s(addr, memory))
                                   : Literal((int64_t)load16u(addr, memory));
            case 4:
              return load->signed_ ? Literal((int64_t)load32s(addr, memory))
                                   : Literal((int64_t)load32u(addr, memory));
            case 8:
              return Literal((int64_t)load64s(addr, memory));
            default:
              WASM_UNREACHABLE("invalid size");
          }
          break;
        }
        case Type::f32:
          return Literal(load32u(addr, memory)).castToF32();
        case Type::f64:
          return Literal(load64u(addr, memory)).castToF64();
        case Type::v128:
          return Literal(load128(addr, load->memory).data());
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
      WASM_UNREACHABLE("invalid type");
    }
    virtual void store(Store* store, Address addr, Literal value, Name memory) {
      switch (store->valueType.getBasic()) {
        case Type::i32: {
          switch (store->bytes) {
            case 1:
              store8(addr, value.geti32(), memory);
              break;
            case 2:
              store16(addr, value.geti32(), memory);
              break;
            case 4:
              store32(addr, value.geti32(), memory);
              break;
            default:
              WASM_UNREACHABLE("invalid store size");
          }
          break;
        }
        case Type::i64: {
          switch (store->bytes) {
            case 1:
              store8(addr, value.geti64(), memory);
              break;
            case 2:
              store16(addr, value.geti64(), memory);
              break;
            case 4:
              store32(addr, value.geti64(), memory);
              break;
            case 8:
              store64(addr, value.geti64(), memory);
              break;
            default:
              WASM_UNREACHABLE("invalid store size");
          }
          break;
        }
        // write floats carefully, ensuring all bits reach memory
        case Type::f32:
          store32(addr, value.reinterpreti32(), memory);
          break;
        case Type::f64:
          store64(addr, value.reinterpreti64(), memory);
          break;
        case Type::v128:
          store128(addr, value.getv128(), memory);
          break;
        case Type::none:
        case Type::unreachable:
          WASM_UNREACHABLE("unexpected type");
      }
    }

    virtual int8_t load8s(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual uint8_t load8u(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual int16_t load16s(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual uint16_t load16u(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual int32_t load32s(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual uint32_t load32u(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual int64_t load64s(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual uint64_t load64u(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual std::array<uint8_t, 16> load128(Address addr, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }

    virtual void store8(Address addr, int8_t value, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual void store16(Address addr, int16_t value, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual void store32(Address addr, int32_t value, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual void store64(Address addr, int64_t value, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }
    virtual void
    store128(Address addr, const std::array<uint8_t, 16>&, Name memoryName) {
      WASM_UNREACHABLE("unimp");
    }

    virtual Index tableSize(Name tableName) = 0;

    virtual void tableStore(Name tableName, Index index, const Literal& entry) {
      WASM_UNREACHABLE("unimp");
    }
    virtual Literal tableLoad(Name tableName, Index index) {
      WASM_UNREACHABLE("unimp");
    }
  };

  SubType* self() { return static_cast<SubType*>(this); }

  // TODO: this duplicates module in ExpressionRunner, and can be removed
  Module& wasm;

  // Values of globals
  GlobalValueSet globals;

  // Multivalue ABI support (see push/pop).
  std::vector<Literals> multiValues;

  ModuleRunnerBase(
    Module& wasm,
    ExternalInterface* externalInterface,
    std::map<Name, std::shared_ptr<SubType>> linkedInstances_ = {})
    : ExpressionRunner<SubType>(&wasm), wasm(wasm),
      externalInterface(externalInterface), linkedInstances(linkedInstances_) {
    // import globals from the outside
    externalInterface->importGlobals(globals, wasm);
    // generate internal (non-imported) globals
    ModuleUtils::iterDefinedGlobals(wasm, [&](Global* global) {
      globals[global->name] = self()->visit(global->init).values;
    });

    // initialize the rest of the external interface
    externalInterface->init(wasm, *self());

    initializeTableContents();
    initializeMemoryContents();

    // run start, if present
    if (wasm.start.is()) {
      Literals arguments;
      callFunction(wasm.start, arguments);
    }
  }

  // call an exported function
  Literals callExport(Name name, const Literals& arguments) {
    Export* export_ = wasm.getExportOrNull(name);
    if (!export_) {
      externalInterface->trap("callExport not found");
    }
    return callFunction(export_->value, arguments);
  }

  Literals callExport(Name name) { return callExport(name, Literals()); }

  // get an exported global
  Literals getExport(Name name) {
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
      ret += std::string("|: ") + functionStack[i].toString() + "\n";
    }
    ret += std::string("\\==\n");
    return ret;
  }

private:
  // Keep a record of call depth, to guard against excessive recursion.
  size_t callDepth = 0;

  // Function name stack. We maintain this explicitly to allow printing of
  // stack traces.
  std::vector<Name> functionStack;

  std::unordered_set<Name> droppedDataSegments;
  std::unordered_set<Name> droppedElementSegments;

  struct TableInterfaceInfo {
    // The external interface in which the table is defined.
    ExternalInterface* interface;
    // The name the table has in that interface.
    Name name;
  };

  TableInterfaceInfo getTableInterfaceInfo(Name name) {
    auto* table = wasm.getTable(name);
    if (table->imported()) {
      auto& importedInstance = linkedInstances.at(table->module);
      auto* tableExport = importedInstance->wasm.getExport(table->base);
      return TableInterfaceInfo{importedInstance->externalInterface,
                                tableExport->value};
    } else {
      return TableInterfaceInfo{externalInterface, name};
    }
  }

  void initializeTableContents() {
    for (auto& table : wasm.tables) {
      if (table->type.isNullable()) {
        // Initial with nulls in a nullable table.
        auto info = getTableInterfaceInfo(table->name);
        auto null = Literal::makeNull(table->type.getHeapType());
        for (Address i = 0; i < table->initial; i++) {
          info.interface->tableStore(info.name, i, null);
        }
      }
    }

    ModuleUtils::iterActiveElementSegments(wasm, [&](ElementSegment* segment) {
      Address offset =
        (uint32_t)self()->visit(segment->offset).getSingleValue().geti32();

      Table* table = wasm.getTable(segment->table);
      ExternalInterface* extInterface = externalInterface;
      Name tableName = segment->table;
      if (table->imported()) {
        auto inst = linkedInstances.at(table->module);
        extInterface = inst->externalInterface;
        tableName = inst->wasm.getExport(table->base)->value;
      }

      for (Index i = 0; i < segment->data.size(); ++i) {
        Flow ret = self()->visit(segment->data[i]);
        extInterface->tableStore(tableName, offset + i, ret.getSingleValue());
      }

      droppedElementSegments.insert(segment->name);
    });
  }

  struct MemoryInstanceInfo {
    // The ModuleRunner instance in which the memory is defined.
    SubType* instance;
    // The name the memory has in that interface.
    Name name;
  };

  MemoryInstanceInfo getMemoryInstanceInfo(Name name) {
    auto* memory = wasm.getMemory(name);
    MemoryInstanceInfo memoryInterfaceInfo;
    if (!memory->imported()) {
      return MemoryInstanceInfo{self(), name};
    }

    auto& importedInstance = linkedInstances.at(memory->module);
    auto* memoryExport = importedInstance->wasm.getExport(memory->base);
    return importedInstance->getMemoryInstanceInfo(memoryExport->value);
  }

  void initializeMemoryContents() {
    initializeMemorySizes();
    Const offset;
    offset.value = Literal(uint32_t(0));
    offset.finalize();

    // apply active memory segments
    for (size_t i = 0, e = wasm.dataSegments.size(); i < e; ++i) {
      auto& segment = wasm.dataSegments[i];
      if (segment->isPassive) {
        continue;
      }
      Const size;
      size.value = Literal(uint32_t(segment->data.size()));
      size.finalize();

      MemoryInit init;
      init.memory = segment->memory;
      init.segment = segment->name;
      init.dest = segment->offset;
      init.offset = &offset;
      init.size = &size;
      init.finalize();

      DataDrop drop;
      drop.segment = segment->name;
      drop.finalize();

      self()->visit(&init);
      self()->visit(&drop);
    }
  }

  // in pages, used to keep track of memorySize throughout the below memops
  std::unordered_map<Name, Address> memorySizes;

  void initializeMemorySizes() {
    for (auto& memory : wasm.memories) {
      memorySizes[memory->name] = memory->initial;
    }
  }

  Address getMemorySize(Name memory) {
    auto iter = memorySizes.find(memory);
    if (iter == memorySizes.end()) {
      externalInterface->trap("getMemorySize called on non-existing memory");
    }
    return iter->second;
  }

  void setMemorySize(Name memory, Address size) {
    auto iter = memorySizes.find(memory);
    if (iter == memorySizes.end()) {
      externalInterface->trap("setMemorySize called on non-existing memory");
    }
    memorySizes[memory] = size;
  }

public:
  class FunctionScope {
  public:
    std::vector<Literals> locals;
    Function* function;
    SubType& parent;

    FunctionScope* oldScope;

    FunctionScope(Function* function,
                  const Literals& arguments,
                  SubType& parent)
      : function(function), parent(parent) {
      oldScope = parent.scope;
      parent.scope = this;

      if (function->getParams().size() != arguments.size()) {
        std::cerr << "Function `" << function->name << "` expects "
                  << function->getParams().size() << " parameters, got "
                  << arguments.size() << " arguments." << std::endl;
        WASM_UNREACHABLE("invalid param count");
      }
      locals.resize(function->getNumLocals());
      Type params = function->getParams();
      for (size_t i = 0; i < function->getNumLocals(); i++) {
        if (i < arguments.size()) {
          if (!Type::isSubType(arguments[i].type, params[i])) {
            std::cerr << "Function `" << function->name << "` expects type "
                      << params[i] << " for parameter " << i << ", got "
                      << arguments[i].type << "." << std::endl;
            WASM_UNREACHABLE("invalid param count");
          }
          locals[i] = {arguments[i]};
        } else {
          assert(function->isVar(i));
          locals[i] = Literal::makeZeros(function->getLocalType(i));
        }
      }
    }

    ~FunctionScope() { parent.scope = oldScope; }

    // The current delegate target, if delegation of an exception is in
    // progress. If no delegation is in progress, this will be an empty Name.
    // This is on a function scope because it cannot "escape" to the outside,
    // that is, a delegate target is like a branch target, it operates within
    // a function.
    Name currDelegateTarget;
  };

private:
  // This is managed in an RAII manner by the FunctionScope class.
  FunctionScope* scope = nullptr;

  // Stack of <caught exception, caught catch's try label>
  SmallVector<std::pair<WasmException, Name>, 4> exceptionStack;

protected:
  // Returns a reference to the current value of a potentially imported global
  Literals& getGlobal(Name name) {
    auto* inst = self();
    auto* global = inst->wasm.getGlobal(name);
    while (global->imported()) {
      inst = inst->linkedInstances.at(global->module).get();
      Export* globalExport = inst->wasm.getExport(global->base);
      global = inst->wasm.getGlobal(globalExport->value);
    }

    return inst->globals[global->name];
  }

public:
  Flow visitCall(Call* curr) {
    NOTE_ENTER("Call");
    NOTE_NAME(curr->target);
    Name target = curr->target;
    Literals arguments;
    Flow flow = self()->generateArguments(curr->operands, arguments);
    if (flow.breaking()) {
      return flow;
    }
    auto* func = wasm.getFunction(curr->target);
    auto funcType = func->type;
    if (Intrinsics(*self()->getModule()).isCallWithoutEffects(func)) {
      // The call.without.effects intrinsic is a call to an import that actually
      // calls the given function reference that is the final argument.
      target = arguments.back().getFunc();
      funcType = arguments.back().type.getHeapType();
      arguments.pop_back();
    }

    if (curr->isReturn) {
      // Return calls are represented by their arguments followed by a reference
      // to the function to be called.
      arguments.push_back(Literal::makeFunc(target, funcType));
      return Flow(RETURN_CALL_FLOW, std::move(arguments));
    }

    Flow ret = callFunctionInternal(target, arguments);
#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "(returned to " << scope->function->name << ")\n";
#endif
    return ret;
  }

  Flow visitCallIndirect(CallIndirect* curr) {
    NOTE_ENTER("CallIndirect");
    Literals arguments;
    Flow flow = self()->generateArguments(curr->operands, arguments);
    if (flow.breaking()) {
      return flow;
    }
    Flow target = self()->visit(curr->target);
    if (target.breaking()) {
      return target;
    }

    Index index = target.getSingleValue().geti32();

    auto info = getTableInterfaceInfo(curr->table);

    if (curr->isReturn) {
      // Return calls are represented by their arguments followed by a reference
      // to the function to be called.
      auto funcref = info.interface->tableLoad(info.name, index);
      if (!Type::isSubType(funcref.type, Type(curr->heapType, NonNullable))) {
        trap("cast failure in call_indirect");
      }
      arguments.push_back(funcref);
      return Flow(RETURN_CALL_FLOW, std::move(arguments));
    }

    Flow ret = info.interface->callTable(
      info.name, index, curr->heapType, arguments, curr->type, *self());
#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "(returned to " << scope->function->name << ")\n";
#endif
    return ret;
  }

  Flow visitCallRef(CallRef* curr) {
    NOTE_ENTER("CallRef");
    Literals arguments;
    Flow flow = self()->generateArguments(curr->operands, arguments);
    if (flow.breaking()) {
      return flow;
    }
    Flow target = self()->visit(curr->target);
    if (target.breaking()) {
      return target;
    }
    auto targetRef = target.getSingleValue();
    if (targetRef.isNull()) {
      trap("null target in call_ref");
    }

    if (curr->isReturn) {
      // Return calls are represented by their arguments followed by a reference
      // to the function to be called.
      arguments.push_back(targetRef);
      return Flow(RETURN_CALL_FLOW, std::move(arguments));
    }

    Flow ret = callFunctionInternal(targetRef.getFunc(), arguments);
#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "(returned to " << scope->function->name << ")\n";
#endif
    return ret;
  }

  Flow visitTableGet(TableGet* curr) {
    NOTE_ENTER("TableGet");
    Flow index = self()->visit(curr->index);
    if (index.breaking()) {
      return index;
    }
    auto info = getTableInterfaceInfo(curr->table);
    return info.interface->tableLoad(info.name,
                                     index.getSingleValue().geti32());
  }
  Flow visitTableSet(TableSet* curr) {
    NOTE_ENTER("TableSet");
    Flow indexFlow = self()->visit(curr->index);
    if (indexFlow.breaking()) {
      return indexFlow;
    }
    Flow valueFlow = self()->visit(curr->value);
    if (valueFlow.breaking()) {
      return valueFlow;
    }
    auto info = getTableInterfaceInfo(curr->table);
    info.interface->tableStore(info.name,
                               indexFlow.getSingleValue().geti32(),
                               valueFlow.getSingleValue());
    return Flow();
  }

  Flow visitTableSize(TableSize* curr) {
    NOTE_ENTER("TableSize");
    auto info = getTableInterfaceInfo(curr->table);
    Index tableSize = info.interface->tableSize(curr->table);
    return Literal::makeFromInt32(tableSize, Type::i32);
  }

  Flow visitTableGrow(TableGrow* curr) {
    NOTE_ENTER("TableGrow");
    Flow valueFlow = self()->visit(curr->value);
    if (valueFlow.breaking()) {
      return valueFlow;
    }
    Flow deltaFlow = self()->visit(curr->delta);
    if (deltaFlow.breaking()) {
      return deltaFlow;
    }
    Name tableName = curr->table;
    auto info = getTableInterfaceInfo(tableName);

    Index tableSize = info.interface->tableSize(tableName);
    Flow ret = Literal::makeFromInt32(tableSize, Type::i32);
    Flow fail = Literal::makeFromInt32(-1, Type::i32);
    Index delta = deltaFlow.getSingleValue().geti32();

    if (tableSize >= uint32_t(-1) - delta) {
      return fail;
    }
    auto maxTableSize = self()->wasm.getTable(tableName)->max;
    if (uint64_t(tableSize) + uint64_t(delta) > uint64_t(maxTableSize)) {
      return fail;
    }
    Index newSize = tableSize + delta;
    if (!info.interface->growTable(
          tableName, valueFlow.getSingleValue(), tableSize, newSize)) {
      // We failed to grow the table in practice, even though it was valid
      // to try to do so.
      return fail;
    }
    return ret;
  }

  Flow visitTableFill(TableFill* curr) {
    NOTE_ENTER("TableFill");
    Flow destFlow = self()->visit(curr->dest);
    if (destFlow.breaking()) {
      return destFlow;
    }
    Flow valueFlow = self()->visit(curr->value);
    if (valueFlow.breaking()) {
      return valueFlow;
    }
    Flow sizeFlow = self()->visit(curr->size);
    if (sizeFlow.breaking()) {
      return sizeFlow;
    }
    Name tableName = curr->table;
    auto info = getTableInterfaceInfo(tableName);

    Index dest = destFlow.getSingleValue().geti32();
    Literal value = valueFlow.getSingleValue();
    Index size = sizeFlow.getSingleValue().geti32();

    Index tableSize = info.interface->tableSize(tableName);
    if (dest + size > tableSize) {
      trap("out of bounds table access");
    }

    for (Index i = 0; i < size; ++i) {
      info.interface->tableStore(info.name, dest + i, value);
    }
    return Flow();
  }

  Flow visitTableCopy(TableCopy* curr) {
    NOTE_ENTER("TableCopy");
    Flow dest = self()->visit(curr->dest);
    if (dest.breaking()) {
      return dest;
    }
    Flow source = self()->visit(curr->source);
    if (source.breaking()) {
      return source;
    }
    Flow size = self()->visit(curr->size);
    if (size.breaking()) {
      return size;
    }
    NOTE_EVAL1(dest);
    NOTE_EVAL1(source);
    NOTE_EVAL1(size);
    Address destVal(dest.getSingleValue().getUnsigned());
    Address sourceVal(source.getSingleValue().getUnsigned());
    Address sizeVal(size.getSingleValue().getUnsigned());

    auto destInfo = getTableInterfaceInfo(curr->destTable);
    auto sourceInfo = getTableInterfaceInfo(curr->sourceTable);
    auto destTableSize = destInfo.interface->tableSize(destInfo.name);
    auto sourceTableSize = sourceInfo.interface->tableSize(sourceInfo.name);
    if (sourceVal + sizeVal > sourceTableSize ||
        destVal + sizeVal > destTableSize ||
        // FIXME: better/cheaper way to detect wrapping?
        sourceVal + sizeVal < sourceVal || sourceVal + sizeVal < sizeVal ||
        destVal + sizeVal < destVal || destVal + sizeVal < sizeVal) {
      trap("out of bounds segment access in table.copy");
    }

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
      destInfo.interface->tableStore(
        destInfo.name,
        destVal + i,
        sourceInfo.interface->tableLoad(sourceInfo.name, sourceVal + i));
    }
    return {};
  }

  Flow visitLocalGet(LocalGet* curr) {
    NOTE_ENTER("LocalGet");
    auto index = curr->index;
    NOTE_EVAL1(index);
    NOTE_EVAL1(scope->locals[index]);
    return scope->locals[index];
  }
  Flow visitLocalSet(LocalSet* curr) {
    NOTE_ENTER("LocalSet");
    auto index = curr->index;
    Flow flow = self()->visit(curr->value);
    if (flow.breaking()) {
      return flow;
    }
    NOTE_EVAL1(index);
    NOTE_EVAL1(flow.getSingleValue());
    assert(curr->isTee() ? Type::isSubType(flow.getType(), curr->type) : true);
    scope->locals[index] = flow.values;
    return curr->isTee() ? flow : Flow();
  }

  Flow visitGlobalGet(GlobalGet* curr) {
    NOTE_ENTER("GlobalGet");
    auto name = curr->name;
    NOTE_EVAL1(name);
    return getGlobal(name);
  }
  Flow visitGlobalSet(GlobalSet* curr) {
    NOTE_ENTER("GlobalSet");
    auto name = curr->name;
    Flow flow = self()->visit(curr->value);
    if (flow.breaking()) {
      return flow;
    }
    NOTE_EVAL1(name);
    NOTE_EVAL1(flow.getSingleValue());

    getGlobal(name) = flow.values;
    return Flow();
  }

  Flow visitLoad(Load* curr) {
    NOTE_ENTER("Load");
    Flow flow = self()->visit(curr->ptr);
    if (flow.breaking()) {
      return flow;
    }
    NOTE_EVAL1(flow);
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    auto addr =
      info.instance->getFinalAddress(curr, flow.getSingleValue(), memorySize);
    if (curr->isAtomic) {
      info.instance->checkAtomicAddress(addr, curr->bytes, memorySize);
    }
    auto ret = info.instance->externalInterface->load(curr, addr, info.name);
    NOTE_EVAL1(addr);
    NOTE_EVAL1(ret);
    return ret;
  }
  Flow visitStore(Store* curr) {
    NOTE_ENTER("Store");
    Flow ptr = self()->visit(curr->ptr);
    if (ptr.breaking()) {
      return ptr;
    }
    Flow value = self()->visit(curr->value);
    if (value.breaking()) {
      return value;
    }
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    auto addr =
      info.instance->getFinalAddress(curr, ptr.getSingleValue(), memorySize);
    if (curr->isAtomic) {
      info.instance->checkAtomicAddress(addr, curr->bytes, memorySize);
    }
    NOTE_EVAL1(addr);
    NOTE_EVAL1(value);
    info.instance->externalInterface->store(
      curr, addr, value.getSingleValue(), info.name);
    return Flow();
  }

  Flow visitAtomicRMW(AtomicRMW* curr) {
    NOTE_ENTER("AtomicRMW");
    Flow ptr = self()->visit(curr->ptr);
    if (ptr.breaking()) {
      return ptr;
    }
    auto value = self()->visit(curr->value);
    if (value.breaking()) {
      return value;
    }
    NOTE_EVAL1(ptr);
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    auto addr =
      info.instance->getFinalAddress(curr, ptr.getSingleValue(), memorySize);
    NOTE_EVAL1(addr);
    NOTE_EVAL1(value);
    auto loaded = info.instance->doAtomicLoad(
      addr, curr->bytes, curr->type, info.name, memorySize);
    NOTE_EVAL1(loaded);
    auto computed = value.getSingleValue();
    switch (curr->op) {
      case RMWAdd:
        computed = loaded.add(computed);
        break;
      case RMWSub:
        computed = loaded.sub(computed);
        break;
      case RMWAnd:
        computed = loaded.and_(computed);
        break;
      case RMWOr:
        computed = loaded.or_(computed);
        break;
      case RMWXor:
        computed = loaded.xor_(computed);
        break;
      case RMWXchg:
        break;
    }
    info.instance->doAtomicStore(
      addr, curr->bytes, computed, info.name, memorySize);
    return loaded;
  }
  Flow visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    NOTE_ENTER("AtomicCmpxchg");
    Flow ptr = self()->visit(curr->ptr);
    if (ptr.breaking()) {
      return ptr;
    }
    NOTE_EVAL1(ptr);
    auto expected = self()->visit(curr->expected);
    if (expected.breaking()) {
      return expected;
    }
    auto replacement = self()->visit(curr->replacement);
    if (replacement.breaking()) {
      return replacement;
    }
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    auto addr =
      info.instance->getFinalAddress(curr, ptr.getSingleValue(), memorySize);
    expected = Flow(wrapToSmallerSize(expected.getSingleValue(), curr->bytes));
    NOTE_EVAL1(addr);
    NOTE_EVAL1(expected);
    NOTE_EVAL1(replacement);
    auto loaded = info.instance->doAtomicLoad(
      addr, curr->bytes, curr->type, info.name, memorySize);
    NOTE_EVAL1(loaded);
    if (loaded == expected.getSingleValue()) {
      info.instance->doAtomicStore(
        addr, curr->bytes, replacement.getSingleValue(), info.name, memorySize);
    }
    return loaded;
  }
  Flow visitAtomicWait(AtomicWait* curr) {
    NOTE_ENTER("AtomicWait");
    Flow ptr = self()->visit(curr->ptr);
    if (ptr.breaking()) {
      return ptr;
    }
    NOTE_EVAL1(ptr);
    auto expected = self()->visit(curr->expected);
    NOTE_EVAL1(expected);
    if (expected.breaking()) {
      return expected;
    }
    auto timeout = self()->visit(curr->timeout);
    NOTE_EVAL1(timeout);
    if (timeout.breaking()) {
      return timeout;
    }
    auto bytes = curr->expectedType.getByteSize();
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    auto addr = info.instance->getFinalAddress(
      curr, ptr.getSingleValue(), bytes, memorySize);
    auto loaded = info.instance->doAtomicLoad(
      addr, bytes, curr->expectedType, info.name, memorySize);
    NOTE_EVAL1(loaded);
    if (loaded != expected.getSingleValue()) {
      return Literal(int32_t(1)); // not equal
    }
    // TODO: Add threads support. For now, report a host limit here, as there
    //       are no other threads that can wake us up. Without such threads,
    //       we'd hang if there is no timeout, and even if there is a timeout
    //       then we can hang for a long time if it is in a loop. The only
    //       timeout value we allow here for now is 0.
    if (timeout.getSingleValue().getInteger() != 0) {
      hostLimit("threads support");
    }
    return Literal(int32_t(2)); // Timed out
  }
  Flow visitAtomicNotify(AtomicNotify* curr) {
    NOTE_ENTER("AtomicNotify");
    Flow ptr = self()->visit(curr->ptr);
    if (ptr.breaking()) {
      return ptr;
    }
    NOTE_EVAL1(ptr);
    auto count = self()->visit(curr->notifyCount);
    NOTE_EVAL1(count);
    if (count.breaking()) {
      return count;
    }
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    auto addr =
      info.instance->getFinalAddress(curr, ptr.getSingleValue(), 4, memorySize);
    // Just check TODO actual threads support
    info.instance->checkAtomicAddress(addr, 4, memorySize);
    return Literal(int32_t(0)); // none woken up
  }
  Flow visitSIMDLoad(SIMDLoad* curr) {
    NOTE_ENTER("SIMDLoad");
    switch (curr->op) {
      case Load8SplatVec128:
      case Load16SplatVec128:
      case Load32SplatVec128:
      case Load64SplatVec128:
        return visitSIMDLoadSplat(curr);
      case Load8x8SVec128:
      case Load8x8UVec128:
      case Load16x4SVec128:
      case Load16x4UVec128:
      case Load32x2SVec128:
      case Load32x2UVec128:
        return visitSIMDLoadExtend(curr);
      case Load32ZeroVec128:
      case Load64ZeroVec128:
        return visitSIMDLoadZero(curr);
    }
    WASM_UNREACHABLE("invalid op");
  }
  Flow visitSIMDLoadSplat(SIMDLoad* curr) {
    Load load;
    load.memory = curr->memory;
    load.type = Type::i32;
    load.bytes = curr->getMemBytes();
    load.signed_ = false;
    load.offset = curr->offset;
    load.align = curr->align;
    load.isAtomic = false;
    load.ptr = curr->ptr;
    Literal (Literal::*splat)() const = nullptr;
    switch (curr->op) {
      case Load8SplatVec128:
        splat = &Literal::splatI8x16;
        break;
      case Load16SplatVec128:
        splat = &Literal::splatI16x8;
        break;
      case Load32SplatVec128:
        splat = &Literal::splatI32x4;
        break;
      case Load64SplatVec128:
        load.type = Type::i64;
        splat = &Literal::splatI64x2;
        break;
      default:
        WASM_UNREACHABLE("invalid op");
    }
    load.finalize();
    Flow flow = self()->visit(&load);
    if (flow.breaking()) {
      return flow;
    }
    return (flow.getSingleValue().*splat)();
  }
  Flow visitSIMDLoadExtend(SIMDLoad* curr) {
    Flow flow = self()->visit(curr->ptr);
    if (flow.breaking()) {
      return flow;
    }
    NOTE_EVAL1(flow);
    Address src(uint32_t(flow.getSingleValue().geti32()));
    auto info = getMemoryInstanceInfo(curr->memory);
    auto loadLane = [&](Address addr) {
      switch (curr->op) {
        case Load8x8SVec128:
          return Literal(
            int32_t(info.instance->externalInterface->load8s(addr, info.name)));
        case Load8x8UVec128:
          return Literal(
            int32_t(info.instance->externalInterface->load8u(addr, info.name)));
        case Load16x4SVec128:
          return Literal(int32_t(
            info.instance->externalInterface->load16s(addr, info.name)));
        case Load16x4UVec128:
          return Literal(int32_t(
            info.instance->externalInterface->load16u(addr, info.name)));
        case Load32x2SVec128:
          return Literal(int64_t(
            info.instance->externalInterface->load32s(addr, info.name)));
        case Load32x2UVec128:
          return Literal(int64_t(
            info.instance->externalInterface->load32u(addr, info.name)));
        default:
          WASM_UNREACHABLE("unexpected op");
      }
      WASM_UNREACHABLE("invalid op");
    };
    auto memorySize = info.instance->getMemorySize(info.name);
    auto fillLanes = [&](auto lanes, size_t laneBytes) {
      for (auto& lane : lanes) {
        lane = loadLane(info.instance->getFinalAddress(
          curr, Literal(uint32_t(src)), laneBytes, memorySize));
        src = Address(uint32_t(src) + laneBytes);
      }
      return Literal(lanes);
    };
    switch (curr->op) {
      case Load8x8SVec128:
      case Load8x8UVec128: {
        std::array<Literal, 8> lanes;
        return fillLanes(lanes, 1);
      }
      case Load16x4SVec128:
      case Load16x4UVec128: {
        std::array<Literal, 4> lanes;
        return fillLanes(lanes, 2);
      }
      case Load32x2SVec128:
      case Load32x2UVec128: {
        std::array<Literal, 2> lanes;
        return fillLanes(lanes, 4);
      }
      default:
        WASM_UNREACHABLE("unexpected op");
    }
    WASM_UNREACHABLE("invalid op");
  }
  Flow visitSIMDLoadZero(SIMDLoad* curr) {
    Flow flow = self()->visit(curr->ptr);
    if (flow.breaking()) {
      return flow;
    }
    NOTE_EVAL1(flow);
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    Address src = info.instance->getFinalAddress(
      curr, flow.getSingleValue(), curr->getMemBytes(), memorySize);
    auto zero =
      Literal::makeZero(curr->op == Load32ZeroVec128 ? Type::i32 : Type::i64);
    if (curr->op == Load32ZeroVec128) {
      auto val =
        Literal(info.instance->externalInterface->load32u(src, info.name));
      return Literal(std::array<Literal, 4>{{val, zero, zero, zero}});
    } else {
      auto val =
        Literal(info.instance->externalInterface->load64u(src, info.name));
      return Literal(std::array<Literal, 2>{{val, zero}});
    }
  }
  Flow visitSIMDLoadStoreLane(SIMDLoadStoreLane* curr) {
    NOTE_ENTER("SIMDLoadStoreLane");
    Flow flow = self()->visit(curr->ptr);
    if (flow.breaking()) {
      return flow;
    }
    NOTE_EVAL1(flow);
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    Address addr = info.instance->getFinalAddress(
      curr, flow.getSingleValue(), curr->getMemBytes(), memorySize);
    flow = self()->visit(curr->vec);
    if (flow.breaking()) {
      return flow;
    }
    Literal vec = flow.getSingleValue();
    switch (curr->op) {
      case Load8LaneVec128:
      case Store8LaneVec128: {
        std::array<Literal, 16> lanes = vec.getLanesUI8x16();
        if (curr->isLoad()) {
          lanes[curr->index] =
            Literal(info.instance->externalInterface->load8u(addr, info.name));
          return Literal(lanes);
        } else {
          info.instance->externalInterface->store8(
            addr, lanes[curr->index].geti32(), info.name);
          return {};
        }
      }
      case Load16LaneVec128:
      case Store16LaneVec128: {
        std::array<Literal, 8> lanes = vec.getLanesUI16x8();
        if (curr->isLoad()) {
          lanes[curr->index] =
            Literal(info.instance->externalInterface->load16u(addr, info.name));
          return Literal(lanes);
        } else {
          info.instance->externalInterface->store16(
            addr, lanes[curr->index].geti32(), info.name);
          return {};
        }
      }
      case Load32LaneVec128:
      case Store32LaneVec128: {
        std::array<Literal, 4> lanes = vec.getLanesI32x4();
        if (curr->isLoad()) {
          lanes[curr->index] =
            Literal(info.instance->externalInterface->load32u(addr, info.name));
          return Literal(lanes);
        } else {
          info.instance->externalInterface->store32(
            addr, lanes[curr->index].geti32(), info.name);
          return {};
        }
      }
      case Store64LaneVec128:
      case Load64LaneVec128: {
        std::array<Literal, 2> lanes = vec.getLanesI64x2();
        if (curr->isLoad()) {
          lanes[curr->index] =
            Literal(info.instance->externalInterface->load64u(addr, info.name));
          return Literal(lanes);
        } else {
          info.instance->externalInterface->store64(
            addr, lanes[curr->index].geti64(), info.name);
          return {};
        }
      }
    }
    WASM_UNREACHABLE("unexpected op");
  }
  Flow visitMemorySize(MemorySize* curr) {
    NOTE_ENTER("MemorySize");
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    auto* memory = info.instance->wasm.getMemory(info.name);
    return Literal::makeFromInt64(memorySize, memory->indexType);
  }
  Flow visitMemoryGrow(MemoryGrow* curr) {
    NOTE_ENTER("MemoryGrow");
    Flow flow = self()->visit(curr->delta);
    if (flow.breaking()) {
      return flow;
    }
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    auto* memory = info.instance->wasm.getMemory(info.name);
    auto indexType = memory->indexType;
    auto fail = Literal::makeFromInt64(-1, memory->indexType);
    Flow ret = Literal::makeFromInt64(memorySize, indexType);
    uint64_t delta = flow.getSingleValue().getUnsigned();
    if (delta > uint32_t(-1) / Memory::kPageSize && indexType == Type::i32) {
      return fail;
    }
    if (memorySize >= uint32_t(-1) - delta && indexType == Type::i32) {
      return fail;
    }
    auto newSize = memorySize + delta;
    if (newSize > memory->max) {
      return fail;
    }
    if (!info.instance->externalInterface->growMemory(
          info.name,
          memorySize * Memory::kPageSize,
          newSize * Memory::kPageSize)) {
      // We failed to grow the memory in practice, even though it was valid
      // to try to do so.
      return fail;
    }
    memorySize = newSize;
    info.instance->setMemorySize(info.name, memorySize);
    return ret;
  }
  Flow visitMemoryInit(MemoryInit* curr) {
    NOTE_ENTER("MemoryInit");
    Flow dest = self()->visit(curr->dest);
    if (dest.breaking()) {
      return dest;
    }
    Flow offset = self()->visit(curr->offset);
    if (offset.breaking()) {
      return offset;
    }
    Flow size = self()->visit(curr->size);
    if (size.breaking()) {
      return size;
    }
    NOTE_EVAL1(dest);
    NOTE_EVAL1(offset);
    NOTE_EVAL1(size);

    auto* segment = wasm.getDataSegment(curr->segment);

    Address destVal(dest.getSingleValue().getUnsigned());
    Address offsetVal(uint32_t(offset.getSingleValue().geti32()));
    Address sizeVal(uint32_t(size.getSingleValue().geti32()));

    if (offsetVal + sizeVal > 0 && droppedDataSegments.count(curr->segment)) {
      trap("out of bounds segment access in memory.init");
    }
    if ((uint64_t)offsetVal + sizeVal > segment->data.size()) {
      trap("out of bounds segment access in memory.init");
    }
    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    if (destVal + sizeVal > memorySize * Memory::kPageSize) {
      trap("out of bounds memory access in memory.init");
    }
    for (size_t i = 0; i < sizeVal; ++i) {
      Literal addr(destVal + i);
      info.instance->externalInterface->store8(
        info.instance->getFinalAddressWithoutOffset(addr, 1, memorySize),
        segment->data[offsetVal + i],
        info.name);
    }
    return {};
  }
  Flow visitDataDrop(DataDrop* curr) {
    NOTE_ENTER("DataDrop");
    droppedDataSegments.insert(curr->segment);
    return {};
  }
  Flow visitMemoryCopy(MemoryCopy* curr) {
    NOTE_ENTER("MemoryCopy");
    Flow dest = self()->visit(curr->dest);
    if (dest.breaking()) {
      return dest;
    }
    Flow source = self()->visit(curr->source);
    if (source.breaking()) {
      return source;
    }
    Flow size = self()->visit(curr->size);
    if (size.breaking()) {
      return size;
    }
    NOTE_EVAL1(dest);
    NOTE_EVAL1(source);
    NOTE_EVAL1(size);
    Address destVal(dest.getSingleValue().getUnsigned());
    Address sourceVal(source.getSingleValue().getUnsigned());
    Address sizeVal(size.getSingleValue().getUnsigned());

    auto destInfo = getMemoryInstanceInfo(curr->destMemory);
    auto sourceInfo = getMemoryInstanceInfo(curr->sourceMemory);
    auto destMemorySize = destInfo.instance->getMemorySize(destInfo.name);
    auto sourceMemorySize = sourceInfo.instance->getMemorySize(sourceInfo.name);
    if (sourceVal + sizeVal > sourceMemorySize * Memory::kPageSize ||
        destVal + sizeVal > destMemorySize * Memory::kPageSize ||
        // FIXME: better/cheaper way to detect wrapping?
        sourceVal + sizeVal < sourceVal || sourceVal + sizeVal < sizeVal ||
        destVal + sizeVal < destVal || destVal + sizeVal < sizeVal) {
      trap("out of bounds segment access in memory.copy");
    }

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
      destInfo.instance->externalInterface->store8(
        destInfo.instance->getFinalAddressWithoutOffset(
          Literal(destVal + i), 1, destMemorySize),
        sourceInfo.instance->externalInterface->load8s(
          sourceInfo.instance->getFinalAddressWithoutOffset(
            Literal(sourceVal + i), 1, sourceMemorySize),
          sourceInfo.name),
        destInfo.name);
    }
    return {};
  }
  Flow visitMemoryFill(MemoryFill* curr) {
    NOTE_ENTER("MemoryFill");
    Flow dest = self()->visit(curr->dest);
    if (dest.breaking()) {
      return dest;
    }
    Flow value = self()->visit(curr->value);
    if (value.breaking()) {
      return value;
    }
    Flow size = self()->visit(curr->size);
    if (size.breaking()) {
      return size;
    }
    NOTE_EVAL1(dest);
    NOTE_EVAL1(value);
    NOTE_EVAL1(size);
    Address destVal(dest.getSingleValue().getUnsigned());
    Address sizeVal(size.getSingleValue().getUnsigned());

    auto info = getMemoryInstanceInfo(curr->memory);
    auto memorySize = info.instance->getMemorySize(info.name);
    // FIXME: cheaper wrapping detection?
    if (destVal > memorySize * Memory::kPageSize ||
        sizeVal > memorySize * Memory::kPageSize ||
        destVal + sizeVal > memorySize * Memory::kPageSize) {
      trap("out of bounds memory access in memory.fill");
    }
    uint8_t val(value.getSingleValue().geti32());
    for (size_t i = 0; i < sizeVal; ++i) {
      info.instance->externalInterface->store8(
        info.instance->getFinalAddressWithoutOffset(
          Literal(destVal + i), 1, memorySize),
        val,
        info.name);
    }
    return {};
  }
  Flow visitArrayNewData(ArrayNewData* curr) {
    NOTE_ENTER("ArrayNewData");
    auto offsetFlow = self()->visit(curr->offset);
    if (offsetFlow.breaking()) {
      return offsetFlow;
    }
    auto sizeFlow = self()->visit(curr->size);
    if (sizeFlow.breaking()) {
      return sizeFlow;
    }

    uint64_t offset = offsetFlow.getSingleValue().getUnsigned();
    uint64_t size = sizeFlow.getSingleValue().getUnsigned();

    auto heapType = curr->type.getHeapType();
    const auto& element = heapType.getArray().element;
    Literals contents;

    const auto& seg = *wasm.getDataSegment(curr->segment);
    auto elemBytes = element.getByteSize();
    auto end = offset + size * elemBytes;
    if ((size != 0ull && droppedDataSegments.count(curr->segment)) ||
        end > seg.data.size()) {
      trap("out of bounds segment access in array.new_data");
    }
    contents.reserve(size);
    for (Index i = offset; i < end; i += elemBytes) {
      auto addr = (void*)&seg.data[i];
      contents.push_back(Literal::makeFromMemory(addr, element));
    }
    return self()->makeGCData(contents, curr->type);
  }
  Flow visitArrayNewElem(ArrayNewElem* curr) {
    NOTE_ENTER("ArrayNewElem");
    auto offsetFlow = self()->visit(curr->offset);
    if (offsetFlow.breaking()) {
      return offsetFlow;
    }
    auto sizeFlow = self()->visit(curr->size);
    if (sizeFlow.breaking()) {
      return sizeFlow;
    }

    uint64_t offset = offsetFlow.getSingleValue().getUnsigned();
    uint64_t size = sizeFlow.getSingleValue().getUnsigned();

    Literals contents;

    const auto& seg = *wasm.getElementSegment(curr->segment);
    auto end = offset + size;
    if (end > seg.data.size()) {
      trap("out of bounds segment access in array.new_elem");
    }
    if (end > 0 && droppedElementSegments.count(curr->segment)) {
      trap("out of bounds segment access in array.new_elem");
    }
    contents.reserve(size);
    for (Index i = offset; i < end; ++i) {
      auto val = self()->visit(seg.data[i]).getSingleValue();
      contents.push_back(val);
    }
    return self()->makeGCData(contents, curr->type);
  }
  Flow visitArrayInitData(ArrayInitData* curr) {
    NOTE_ENTER("ArrayInit");
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    Flow index = self()->visit(curr->index);
    if (index.breaking()) {
      return index;
    }
    Flow offset = self()->visit(curr->offset);
    if (offset.breaking()) {
      return offset;
    }
    Flow size = self()->visit(curr->size);
    if (size.breaking()) {
      return size;
    }
    auto data = ref.getSingleValue().getGCData();
    if (!data) {
      trap("null ref");
    }
    size_t indexVal = index.getSingleValue().getUnsigned();
    size_t offsetVal = offset.getSingleValue().getUnsigned();
    size_t sizeVal = size.getSingleValue().getUnsigned();

    size_t arraySize = data->values.size();
    if ((uint64_t)indexVal + sizeVal > arraySize) {
      trap("out of bounds array access in array.init");
    }

    Module& wasm = *self()->getModule();

    auto* seg = wasm.getDataSegment(curr->segment);
    auto elem = curr->ref->type.getHeapType().getArray().element;
    size_t elemSize = elem.getByteSize();
    uint64_t readSize = (uint64_t)sizeVal * elemSize;
    if (offsetVal + readSize > seg->data.size()) {
      trap("out of bounds segment access in array.init_data");
    }
    if (offsetVal + sizeVal > 0 && droppedDataSegments.count(curr->segment)) {
      trap("out of bounds segment access in array.init_data");
    }
    for (size_t i = 0; i < sizeVal; i++) {
      void* addr = (void*)&seg->data[offsetVal + i * elemSize];
      data->values[indexVal + i] = Literal::makeFromMemory(addr, elem);
    }
    return {};
  }
  Flow visitArrayInitElem(ArrayInitElem* curr) {
    NOTE_ENTER("ArrayInit");
    Flow ref = self()->visit(curr->ref);
    if (ref.breaking()) {
      return ref;
    }
    Flow index = self()->visit(curr->index);
    if (index.breaking()) {
      return index;
    }
    Flow offset = self()->visit(curr->offset);
    if (offset.breaking()) {
      return offset;
    }
    Flow size = self()->visit(curr->size);
    if (size.breaking()) {
      return size;
    }
    auto data = ref.getSingleValue().getGCData();
    if (!data) {
      trap("null ref");
    }
    size_t indexVal = index.getSingleValue().getUnsigned();
    size_t offsetVal = offset.getSingleValue().getUnsigned();
    size_t sizeVal = size.getSingleValue().getUnsigned();

    size_t arraySize = data->values.size();
    if ((uint64_t)indexVal + sizeVal > arraySize) {
      trap("out of bounds array access in array.init");
    }

    Module& wasm = *self()->getModule();

    auto* seg = wasm.getElementSegment(curr->segment);
    auto max = (uint64_t)offsetVal + sizeVal;
    if (max > seg->data.size()) {
      trap("out of bounds segment access in array.init_elem");
    }
    if (max > 0 && droppedElementSegments.count(curr->segment)) {
      trap("out of bounds segment access in array.init_elem");
    }
    for (size_t i = 0; i < sizeVal; i++) {
      // TODO: This is not correct because it does not preserve the identity
      // of references in the table! ArrayNew suffers the same problem.
      // Fixing it will require changing how we represent segments, at least
      // in the interpreter.
      data->values[indexVal + i] = self()->visit(seg->data[i]).getSingleValue();
    }
    return {};
  }
  Flow visitTry(Try* curr) {
    NOTE_ENTER("Try");
    try {
      return self()->visit(curr->body);
    } catch (const WasmException& e) {
      // If delegation is in progress and the current try is not the target of
      // the delegation, don't handle it and just rethrow.
      if (scope->currDelegateTarget.is()) {
        if (scope->currDelegateTarget == curr->name) {
          scope->currDelegateTarget = Name{};
        } else {
          throw;
        }
      }

      auto processCatchBody = [&](Expression* catchBody) {
        // Push the current exception onto the exceptionStack in case
        // 'rethrow's use it
        exceptionStack.push_back(std::make_pair(e, curr->name));
        // We need to pop exceptionStack in either case: when the catch body
        // exits normally or when a new exception is thrown
        Flow ret;
        try {
          ret = self()->visit(catchBody);
        } catch (const WasmException&) {
          exceptionStack.pop_back();
          throw;
        }
        exceptionStack.pop_back();
        return ret;
      };

      for (size_t i = 0; i < curr->catchTags.size(); i++) {
        if (curr->catchTags[i] == e.tag) {
          multiValues.push_back(e.values);
          return processCatchBody(curr->catchBodies[i]);
        }
      }
      if (curr->hasCatchAll()) {
        return processCatchBody(curr->catchBodies.back());
      }
      if (curr->isDelegate()) {
        scope->currDelegateTarget = curr->delegateTarget;
      }
      // This exception is not caught by this try-catch. Rethrow it.
      throw;
    }
  }
  Flow visitRethrow(Rethrow* curr) {
    for (int i = exceptionStack.size() - 1; i >= 0; i--) {
      if (exceptionStack[i].second == curr->target) {
        throwException(exceptionStack[i].first);
      }
    }
    WASM_UNREACHABLE("rethrow");
  }
  Flow visitPop(Pop* curr) {
    NOTE_ENTER("Pop");
    assert(!multiValues.empty());
    auto ret = multiValues.back();
    assert(Type::isSubType(ret.getType(), curr->type));
    multiValues.pop_back();
    return ret;
  }
  Flow visitContBind(ContBind* curr) { return Flow(NONCONSTANT_FLOW); }
  Flow visitContNew(ContNew* curr) { return Flow(NONCONSTANT_FLOW); }
  Flow visitResume(Resume* curr) { return Flow(NONCONSTANT_FLOW); }
  Flow visitSuspend(Suspend* curr) { return Flow(NONCONSTANT_FLOW); }

  void trap(const char* why) override { externalInterface->trap(why); }

  void hostLimit(const char* why) override {
    externalInterface->hostLimit(why);
  }

  void throwException(const WasmException& exn) override {
    externalInterface->throwException(exn);
  }

  // Given a value, wrap it to a smaller given number of bytes.
  Literal wrapToSmallerSize(Literal value, Index bytes) {
    if (value.type == Type::i32) {
      switch (bytes) {
        case 1: {
          return value.and_(Literal(uint32_t(0xff)));
        }
        case 2: {
          return value.and_(Literal(uint32_t(0xffff)));
        }
        case 4: {
          break;
        }
        default:
          WASM_UNREACHABLE("unexpected bytes");
      }
    } else {
      assert(value.type == Type::i64);
      switch (bytes) {
        case 1: {
          return value.and_(Literal(uint64_t(0xff)));
        }
        case 2: {
          return value.and_(Literal(uint64_t(0xffff)));
        }
        case 4: {
          return value.and_(Literal(uint64_t(0xffffffffUL)));
        }
        case 8: {
          break;
        }
        default:
          WASM_UNREACHABLE("unexpected bytes");
      }
    }
    return value;
  }

  // Call a function, starting an invocation.
  Literals callFunction(Name name, const Literals& arguments) {
    // If the last call ended in a jump up the stack, it might have left stuff
    // for us to clean up here
    callDepth = 0;
    functionStack.clear();
    return callFunctionInternal(name, arguments);
  }

  // Internal function call. Must be public so that callTable implementations
  // can use it (refactor?)
  Literals callFunctionInternal(Name name, Literals arguments) {
    if (callDepth > maxDepth) {
      externalInterface->trap("stack limit");
    }

    Flow flow;
    std::optional<Type> resultType;

    // We may have to call multiple functions in the event of return calls.
    while (true) {
      Function* function = wasm.getFunction(name);
      assert(function);

      // Return calls can only make the result type more precise.
      if (resultType) {
        assert(Type::isSubType(function->getResults(), *resultType));
      }
      resultType = function->getResults();

      if (function->imported()) {
        // TODO: Allow imported functions to tail call as well.
        return externalInterface->callImport(function, arguments);
      }

      auto previousCallDepth = callDepth;
      callDepth++;
      auto previousFunctionStackSize = functionStack.size();
      functionStack.push_back(name);

      FunctionScope scope(function, arguments, *self());

#ifdef WASM_INTERPRETER_DEBUG
      std::cout << "entering " << function->name << "\n  with arguments:\n";
      for (unsigned i = 0; i < arguments.size(); ++i) {
        std::cout << "    $" << i << ": " << arguments[i] << '\n';
      }
#endif

      flow = self()->visit(function->body);

      // may decrease more than one, if we jumped up the stack
      callDepth = previousCallDepth;
      // if we jumped up the stack, we also need to pop higher frames
      // TODO can FunctionScope handle this automatically?
      while (functionStack.size() > previousFunctionStackSize) {
        functionStack.pop_back();
      }
#ifdef WASM_INTERPRETER_DEBUG
      std::cout << "exiting " << function->name << " with " << flow.values
                << '\n';
#endif

      if (flow.breakTo != RETURN_CALL_FLOW) {
        break;
      }

      // There was a return call, so we need to call the next function before
      // returning to the caller. The flow carries the function arguments and a
      // function reference.
      name = flow.values.back().getFunc();
      flow.values.pop_back();
      arguments = flow.values;
    }

    // cannot still be breaking, it means we missed our stop
    assert(!flow.breaking() || flow.breakTo == RETURN_FLOW);
    auto type = flow.getType();
    if (!Type::isSubType(type, *resultType)) {
      std::cerr << "calling " << name << " resulted in " << type
                << " but the function type is " << *resultType << '\n';
      WASM_UNREACHABLE("unexpected result type");
    }

    return flow.values;
  }

  // The maximum call stack depth to evaluate into.
  static const Index maxDepth = 250;

protected:
  void trapIfGt(uint64_t lhs, uint64_t rhs, const char* msg) {
    if (lhs > rhs) {
      std::stringstream ss;
      ss << msg << ": " << lhs << " > " << rhs;
      externalInterface->trap(ss.str().c_str());
    }
  }

  template<class LS>
  Address
  getFinalAddress(LS* curr, Literal ptr, Index bytes, Address memorySize) {
    Address memorySizeBytes = memorySize * Memory::kPageSize;
    uint64_t addr = ptr.type == Type::i32 ? ptr.geti32() : ptr.geti64();
    trapIfGt(curr->offset, memorySizeBytes, "offset > memory");
    trapIfGt(addr, memorySizeBytes - curr->offset, "final > memory");
    addr += curr->offset;
    trapIfGt(bytes, memorySizeBytes, "bytes > memory");
    checkLoadAddress(addr, bytes, memorySize);
    return addr;
  }

  template<class LS>
  Address getFinalAddress(LS* curr, Literal ptr, Address memorySize) {
    return getFinalAddress(curr, ptr, curr->bytes, memorySize);
  }

  Address
  getFinalAddressWithoutOffset(Literal ptr, Index bytes, Address memorySize) {
    uint64_t addr = ptr.type == Type::i32 ? ptr.geti32() : ptr.geti64();
    checkLoadAddress(addr, bytes, memorySize);
    return addr;
  }

  void checkLoadAddress(Address addr, Index bytes, Address memorySize) {
    Address memorySizeBytes = memorySize * Memory::kPageSize;
    trapIfGt(addr, memorySizeBytes - bytes, "highest > memory");
  }

  void checkAtomicAddress(Address addr, Index bytes, Address memorySize) {
    checkLoadAddress(addr, bytes, memorySize);
    // Unaligned atomics trap.
    if (bytes > 1) {
      if (addr & (bytes - 1)) {
        externalInterface->trap("unaligned atomic operation");
      }
    }
  }

  Literal doAtomicLoad(
    Address addr, Index bytes, Type type, Name memoryName, Address memorySize) {
    checkAtomicAddress(addr, bytes, memorySize);
    Const ptr;
    ptr.value = Literal(int32_t(addr));
    ptr.type = Type::i32;
    Load load;
    load.bytes = bytes;
    // When an atomic loads a partial number of bytes for the type, it is
    // always an unsigned extension.
    load.signed_ = false;
    load.align = bytes;
    load.isAtomic = true; // understatement
    load.ptr = &ptr;
    load.type = type;
    load.memory = memoryName;
    return externalInterface->load(&load, addr, memoryName);
  }

  void doAtomicStore(Address addr,
                     Index bytes,
                     Literal toStore,
                     Name memoryName,
                     Address memorySize) {
    checkAtomicAddress(addr, bytes, memorySize);
    Const ptr;
    ptr.value = Literal(int32_t(addr));
    ptr.type = Type::i32;
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
    store.memory = memoryName;
    return externalInterface->store(&store, addr, toStore, memoryName);
  }

  ExternalInterface* externalInterface;
  std::map<Name, std::shared_ptr<SubType>> linkedInstances;
};

class ModuleRunner : public ModuleRunnerBase<ModuleRunner> {
public:
  ModuleRunner(
    Module& wasm,
    ExternalInterface* externalInterface,
    std::map<Name, std::shared_ptr<ModuleRunner>> linkedInstances = {})
    : ModuleRunnerBase(wasm, externalInterface, linkedInstances) {}
};

} // namespace wasm

#endif // wasm_wasm_interpreter_h
