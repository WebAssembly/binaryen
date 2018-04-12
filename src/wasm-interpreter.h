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

#include "support/bits.h"
#include "support/safe_integer.h"
#include "wasm.h"
#include "wasm-traversal.h"


#ifdef WASM_INTERPRETER_DEBUG
#include "wasm-printing.h"
#endif


namespace wasm {

using namespace cashew;

// Utilities

extern Name WASM, RETURN_FLOW;

enum {
  maxCallDepth = 250
};

// Stuff that flows around during executing expressions: a literal, or a change in control flow.
class Flow {
public:
  Flow() {}
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
    o << "(flow " << (flow.breakTo.is() ? flow.breakTo.str : "-") << " : " << flow.value << ')';
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

#define NOTE_ENTER(x) Indenter _int_blah(x); { \
    Indenter::print(); \
    std::cout << "visit " << x << " : " << curr << "\n"; }
#define NOTE_ENTER_(x) Indenter _int_blah(x); { \
    Indenter::print(); \
    std::cout << "visit " << x << "\n"; }
#define NOTE_NAME(p0) { \
    Indenter::print(); \
    std::cout << "name " << '(' << Name(p0) << ")\n"; }
#define NOTE_EVAL1(p0) { \
    Indenter::print(); \
    std::cout << "eval " #p0 " (" << p0 << ")\n"; }
#define NOTE_EVAL2(p0, p1) { \
    Indenter::print(); \
    std::cout << "eval " #p0 " (" << p0 << "), " #p1 " (" << p1 << ")\n"; }
#else // WASM_INTERPRETER_DEBUG
#define NOTE_ENTER(x)
#define NOTE_ENTER_(x)
#define NOTE_NAME(p0)
#define NOTE_EVAL1(p0)
#define NOTE_EVAL2(p0, p1)
#endif // WASM_INTERPRETER_DEBUG

// Execute an expression
template<typename SubType>
class ExpressionRunner : public Visitor<SubType, Flow> {
public:
  Flow visit(Expression *curr) {
    auto ret = Visitor<SubType, Flow>::visit(curr);
    if (!ret.breaking() && (isConcreteType(curr->type) || isConcreteType(ret.value.type))) {
#if 1 // def WASM_INTERPRETER_DEBUG
      if (ret.value.type != curr->type) {
        std::cerr << "expected " << printType(curr->type) << ", seeing " << printType(ret.value.type) << " from\n" << curr << '\n';
      }
#endif
      assert(ret.value.type == curr->type);
    }
    return ret;
  }

  Flow visitBlock(Block *curr) {
    NOTE_ENTER("Block");
    // special-case Block, because Block nesting (in their first element) can be incredibly deep
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
  Flow visitIf(If *curr) {
    NOTE_ENTER("If");
    Flow flow = visit(curr->condition);
    if (flow.breaking()) return flow;
    NOTE_EVAL1(flow.value);
    if (flow.value.geti32()) {
      Flow flow = visit(curr->ifTrue);
      if (!flow.breaking() && !curr->ifFalse) flow.value = Literal(); // if_else returns a value, but if does not
      return flow;
    }
    if (curr->ifFalse) return visit(curr->ifFalse);
    return Flow();
  }
  Flow visitLoop(Loop *curr) {
    NOTE_ENTER("Loop");
    while (1) {
      Flow flow = visit(curr->body);
      if (flow.breaking()) {
        if (flow.breakTo == curr->name) continue; // lol
      }
      return flow; // loop does not loop automatically, only continue achieves that
    }
  }
  Flow visitBreak(Break *curr) {
    NOTE_ENTER("Break");
    bool condition = true;
    Flow flow;
    if (curr->value) {
      flow = visit(curr->value);
      if (flow.breaking()) return flow;
    }
    if (curr->condition) {
      Flow conditionFlow = visit(curr->condition);
      if (conditionFlow.breaking()) return conditionFlow;
      condition = conditionFlow.value.getInteger() != 0;
      if (!condition) return flow;
    }
    flow.breakTo = curr->name;
    return flow;
  }
  Flow visitSwitch(Switch *curr) {
    NOTE_ENTER("Switch");
    Flow flow;
    Literal value;
    if (curr->value) {
      flow = visit(curr->value);
      if (flow.breaking()) return flow;
      value = flow.value;
      NOTE_EVAL1(value);
    }
    flow = visit(curr->condition);
    if (flow.breaking()) return flow;
    int64_t index = flow.value.getInteger();
    Name target = curr->default_;
    if (index >= 0 && (size_t)index < curr->targets.size()) {
      target = curr->targets[(size_t)index];
    }
    flow.breakTo = target;
    flow.value = value;
    return flow;
  }

  Flow visitConst(Const *curr) {
    NOTE_ENTER("Const");
    NOTE_EVAL1(curr->value);
    return Flow(curr->value); // heh
  }
  Flow visitUnary(Unary *curr) {
    NOTE_ENTER("Unary");
    Flow flow = visit(curr->value);
    if (flow.breaking()) return flow;
    Literal value = flow.value;
    NOTE_EVAL1(value);
    if (value.type == i32) {
      switch (curr->op) {
        case ClzInt32:               return value.countLeadingZeroes();
        case CtzInt32:               return value.countTrailingZeroes();
        case PopcntInt32:            return value.popCount();
        case EqZInt32:               return Literal(int32_t(value == Literal(int32_t(0))));
        case ReinterpretInt32:       return value.castToF32();
        case ExtendSInt32:           return value.extendToSI64();
        case ExtendUInt32:           return value.extendToUI64();
        case ConvertUInt32ToFloat32: return value.convertUToF32();
        case ConvertUInt32ToFloat64: return value.convertUToF64();
        case ConvertSInt32ToFloat32: return value.convertSToF32();
        case ConvertSInt32ToFloat64: return value.convertSToF64();
        case ExtendS8Int32:          return Literal(int32_t(int8_t(value.geti32() & 0xFF)));
        case ExtendS16Int32:         return Literal(int32_t(int16_t(value.geti32() & 0xFFFF)));
        default: WASM_UNREACHABLE();
      }
    }
    if (value.type == i64) {
      switch (curr->op) {
        case ClzInt64:               return value.countLeadingZeroes();
        case CtzInt64:               return value.countTrailingZeroes();
        case PopcntInt64:            return value.popCount();
        case EqZInt64:               return Literal(int32_t(value == Literal(int64_t(0))));
        case WrapInt64:              return value.truncateToI32();
        case ReinterpretInt64:       return value.castToF64();
        case ConvertUInt64ToFloat32: return value.convertUToF32();
        case ConvertUInt64ToFloat64: return value.convertUToF64();
        case ConvertSInt64ToFloat32: return value.convertSToF32();
        case ConvertSInt64ToFloat64: return value.convertSToF64();
        case ExtendS8Int64:          return Literal(int64_t(int8_t(value.geti64() & 0xFF)));
        case ExtendS16Int64:         return Literal(int64_t(int16_t(value.geti64() & 0xFFFF)));
        case ExtendS32Int64:         return Literal(int64_t(int32_t(value.geti64() & 0xFFFFFFFF)));
        default: WASM_UNREACHABLE();
      }
    }
    if (value.type == f32) {
      switch (curr->op) {
        case NegFloat32:              return value.neg();
        case AbsFloat32:              return value.abs();
        case CeilFloat32:             return value.ceil();
        case FloorFloat32:            return value.floor();
        case TruncFloat32:            return value.trunc();
        case NearestFloat32:          return value.nearbyint();
        case SqrtFloat32:             return value.sqrt();
        case TruncSFloat32ToInt32:
        case TruncSFloat32ToInt64: return truncSFloat(curr, value);
        case TruncUFloat32ToInt32:
        case TruncUFloat32ToInt64: return truncUFloat(curr, value);
        case ReinterpretFloat32: return value.castToI32();
        case PromoteFloat32:   return value.extendToF64();
        default: WASM_UNREACHABLE();
      }
    }
    if (value.type == f64) {
      switch (curr->op) {
        case NegFloat64:              return value.neg();
        case AbsFloat64:              return value.abs();
        case CeilFloat64:             return value.ceil();
        case FloorFloat64:            return value.floor();
        case TruncFloat64:            return value.trunc();
        case NearestFloat64:          return value.nearbyint();
        case SqrtFloat64:             return value.sqrt();
        case TruncSFloat64ToInt32:
        case TruncSFloat64ToInt64: return truncSFloat(curr, value);
        case TruncUFloat64ToInt32:
        case TruncUFloat64ToInt64: return truncUFloat(curr, value);
        case ReinterpretFloat64: return value.castToI64();
        case DemoteFloat64: {
          double val = value.getFloat();
          if (std::isnan(val)) return Literal(float(val));
          if (std::isinf(val)) return Literal(float(val));
          // when close to the limit, but still truncatable to a valid value, do that
          // see https://github.com/WebAssembly/sexpr-wasm-prototype/blob/2d375e8d502327e814d62a08f22da9d9b6b675dc/src/wasm-interpreter.c#L247
          uint64_t bits = value.reinterpreti64();
          if (bits > 0x47efffffe0000000ULL && bits < 0x47effffff0000000ULL) return Literal(std::numeric_limits<float>::max());
          if (bits > 0xc7efffffe0000000ULL && bits < 0xc7effffff0000000ULL) return Literal(-std::numeric_limits<float>::max());
          // when we must convert to infinity, do that
          if (val < -std::numeric_limits<float>::max()) return Literal(-std::numeric_limits<float>::infinity());
          if (val > std::numeric_limits<float>::max()) return Literal(std::numeric_limits<float>::infinity());
          return value.truncateToF32();
        }
        default: WASM_UNREACHABLE();
      }
    }
    WASM_UNREACHABLE();
  }
  Flow visitBinary(Binary *curr) {
    NOTE_ENTER("Binary");
    Flow flow = visit(curr->left);
    if (flow.breaking()) return flow;
    Literal left = flow.value;
    flow = visit(curr->right);
    if (flow.breaking()) return flow;
    Literal right = flow.value;
    NOTE_EVAL2(left, right);
    assert(isConcreteType(curr->left->type) ? left.type == curr->left->type : true);
    assert(isConcreteType(curr->right->type) ? right.type == curr->right->type : true);
    if (left.type == i32) {
      switch (curr->op) {
        case AddInt32:      return left.add(right);
        case SubInt32:      return left.sub(right);
        case MulInt32:      return left.mul(right);
        case DivSInt32: {
          if (right.getInteger() == 0) trap("i32.div_s by 0");
          if (left.getInteger() == std::numeric_limits<int32_t>::min() && right.getInteger() == -1) trap("i32.div_s overflow"); // signed division overflow
          return left.divS(right);
        }
        case DivUInt32: {
          if (right.getInteger() == 0) trap("i32.div_u by 0");
          return left.divU(right);
        }
        case RemSInt32: {
          if (right.getInteger() == 0) trap("i32.rem_s by 0");
          if (left.getInteger() == std::numeric_limits<int32_t>::min() && right.getInteger() == -1) return Literal(int32_t(0));
          return left.remS(right);
        }
        case RemUInt32: {
          if (right.getInteger() == 0) trap("i32.rem_u by 0");
          return left.remU(right);
        }
        case AndInt32:  return left.and_(right);
        case OrInt32:   return left.or_(right);
        case XorInt32:  return left.xor_(right);
        case ShlInt32:  return left.shl(right.and_(Literal(int32_t(31))));
        case ShrUInt32: return left.shrU(right.and_(Literal(int32_t(31))));
        case ShrSInt32: return left.shrS(right.and_(Literal(int32_t(31))));
        case RotLInt32: return left.rotL(right);
        case RotRInt32: return left.rotR(right);
        case EqInt32:   return left.eq(right);
        case NeInt32:   return left.ne(right);
        case LtSInt32:  return left.ltS(right);
        case LtUInt32:  return left.ltU(right);
        case LeSInt32:  return left.leS(right);
        case LeUInt32:  return left.leU(right);
        case GtSInt32:  return left.gtS(right);
        case GtUInt32:  return left.gtU(right);
        case GeSInt32:  return left.geS(right);
        case GeUInt32:  return left.geU(right);
        default: WASM_UNREACHABLE();
      }
    } else if (left.type == i64) {
      switch (curr->op) {
        case AddInt64:      return left.add(right);
        case SubInt64:      return left.sub(right);
        case MulInt64:      return left.mul(right);
        case DivSInt64: {
          if (right.getInteger() == 0) trap("i64.div_s by 0");
          if (left.getInteger() == LLONG_MIN && right.getInteger() == -1LL) trap("i64.div_s overflow"); // signed division overflow
          return left.divS(right);
        }
        case DivUInt64: {
          if (right.getInteger() == 0) trap("i64.div_u by 0");
          return left.divU(right);
        }
        case RemSInt64: {
          if (right.getInteger() == 0) trap("i64.rem_s by 0");
          if (left.getInteger() == LLONG_MIN && right.getInteger() == -1LL) return Literal(int64_t(0));
          return left.remS(right);
        }
        case RemUInt64: {
          if (right.getInteger() == 0) trap("i64.rem_u by 0");
          return left.remU(right);
        }
        case AndInt64:  return left.and_(right);
        case OrInt64:   return left.or_(right);
        case XorInt64:  return left.xor_(right);
        case ShlInt64:  return left.shl(right.and_(Literal(int64_t(63))));
        case ShrUInt64: return left.shrU(right.and_(Literal(int64_t(63))));
        case ShrSInt64: return left.shrS(right.and_(Literal(int64_t(63))));
        case RotLInt64: return left.rotL(right);
        case RotRInt64: return left.rotR(right);
        case EqInt64:   return left.eq(right);
        case NeInt64:   return left.ne(right);
        case LtSInt64:  return left.ltS(right);
        case LtUInt64:  return left.ltU(right);
        case LeSInt64:  return left.leS(right);
        case LeUInt64:  return left.leU(right);
        case GtSInt64:  return left.gtS(right);
        case GtUInt64:  return left.gtU(right);
        case GeSInt64:  return left.geS(right);
        case GeUInt64:  return left.geU(right);
        default: WASM_UNREACHABLE();
      }
    } else if (left.type == f32 || left.type == f64) {
      switch (curr->op) {
        case AddFloat32:      case AddFloat64:      return left.add(right);
        case SubFloat32:      case SubFloat64:      return left.sub(right);
        case MulFloat32:      case MulFloat64:      return left.mul(right);
        case DivFloat32:      case DivFloat64:      return left.div(right);
        case CopySignFloat32: case CopySignFloat64: return left.copysign(right);
        case MinFloat32:      case MinFloat64:      return left.min(right);
        case MaxFloat32:      case MaxFloat64:      return left.max(right);
        case EqFloat32:       case EqFloat64:       return left.eq(right);
        case NeFloat32:       case NeFloat64:       return left.ne(right);
        case LtFloat32:       case LtFloat64:       return left.lt(right);
        case LeFloat32:       case LeFloat64:       return left.le(right);
        case GtFloat32:       case GtFloat64:       return left.gt(right);
        case GeFloat32:       case GeFloat64:       return left.ge(right);
        default: WASM_UNREACHABLE();
      }
    }
    WASM_UNREACHABLE();
  }
  Flow visitSelect(Select *curr) {
    NOTE_ENTER("Select");
    Flow ifTrue = visit(curr->ifTrue);
    if (ifTrue.breaking()) return ifTrue;
    Flow ifFalse = visit(curr->ifFalse);
    if (ifFalse.breaking()) return ifFalse;
    Flow condition = visit(curr->condition);
    if (condition.breaking()) return condition;
    NOTE_EVAL1(condition.value);
    return condition.value.geti32() ? ifTrue : ifFalse; // ;-)
  }
  Flow visitDrop(Drop *curr) {
    NOTE_ENTER("Drop");
    Flow value = visit(curr->value);
    if (value.breaking()) return value;
    return Flow();
  }
  Flow visitReturn(Return *curr) {
    NOTE_ENTER("Return");
    Flow flow;
    if (curr->value) {
      flow = visit(curr->value);
      if (flow.breaking()) return flow;
      NOTE_EVAL1(flow.value);
    }
    flow.breakTo = RETURN_FLOW;
    return flow;
  }
  Flow visitNop(Nop *curr) {
    NOTE_ENTER("Nop");
    return Flow();
  }
  Flow visitUnreachable(Unreachable *curr) {
    NOTE_ENTER("Unreachable");
    trap("unreachable");
    WASM_UNREACHABLE();
  }

  Literal truncSFloat(Unary* curr, Literal value) {
    double val = value.getFloat();
    if (std::isnan(val)) trap("truncSFloat of nan");
    if (curr->type == i32) {
      if (value.type == f32) {
        if (!isInRangeI32TruncS(value.reinterpreti32())) trap("i32.truncSFloat overflow");
      } else {
        if (!isInRangeI32TruncS(value.reinterpreti64())) trap("i32.truncSFloat overflow");
      }
      return Literal(int32_t(val));
    } else {
      if (value.type == f32) {
        if (!isInRangeI64TruncS(value.reinterpreti32())) trap("i64.truncSFloat overflow");
      } else {
        if (!isInRangeI64TruncS(value.reinterpreti64())) trap("i64.truncSFloat overflow");
      }
      return Literal(int64_t(val));
    }
  }

  Literal truncUFloat(Unary* curr, Literal value) {
    double val = value.getFloat();
    if (std::isnan(val)) trap("truncUFloat of nan");
    if (curr->type == i32) {
      if (value.type == f32) {
        if (!isInRangeI32TruncU(value.reinterpreti32())) trap("i32.truncUFloat overflow");
      } else {
        if (!isInRangeI32TruncU(value.reinterpreti64())) trap("i32.truncUFloat overflow");
      }
      return Literal(uint32_t(val));
    } else {
      if (value.type == f32) {
        if (!isInRangeI64TruncU(value.reinterpreti32())) trap("i64.truncUFloat overflow");
      } else {
        if (!isInRangeI64TruncU(value.reinterpreti64())) trap("i64.truncUFloat overflow");
      }
      return Literal(uint64_t(val));
    }
  }

  virtual void trap(const char* why) {
    WASM_UNREACHABLE();
  }
};

// Execute an constant expression in a global init or memory offset
template<typename GlobalManager>
class ConstantExpressionRunner : public ExpressionRunner<ConstantExpressionRunner<GlobalManager>> {
  GlobalManager& globals;
public:
  ConstantExpressionRunner(GlobalManager& globals) : globals(globals) {}

  Flow visitLoop(Loop* curr) { WASM_UNREACHABLE(); }
  Flow visitCall(Call* curr) { WASM_UNREACHABLE(); }
  Flow visitCallImport(CallImport* curr) { WASM_UNREACHABLE(); }
  Flow visitCallIndirect(CallIndirect* curr) { WASM_UNREACHABLE(); }
  Flow visitGetLocal(GetLocal *curr) { WASM_UNREACHABLE(); }
  Flow visitSetLocal(SetLocal *curr) { WASM_UNREACHABLE(); }
  Flow visitGetGlobal(GetGlobal *curr) {
    return Flow(globals[curr->name]);
  }
  Flow visitSetGlobal(SetGlobal *curr) { WASM_UNREACHABLE(); }
  Flow visitLoad(Load *curr) { WASM_UNREACHABLE(); }
  Flow visitStore(Store *curr) { WASM_UNREACHABLE(); }
  Flow visitHost(Host *curr) { WASM_UNREACHABLE(); }
};

//
// An instance of a WebAssembly module, which can execute it via AST interpretation.
//
// To embed this interpreter, you need to provide an ExternalInterface instance
// (see below) which provides the embedding-specific details, that is, how to
// connect to the embedding implementation.
//
// To call into the interpreter, use callExport.
//

template<typename GlobalManager, typename SubType>
class ModuleInstanceBase {
public:
  //
  // You need to implement one of these to create a concrete interpreter. The
  // ExternalInterface provides embedding-specific functionality like calling
  // an imported function or accessing memory.
  //
  struct ExternalInterface {
    virtual void init(Module& wasm, SubType& instance) {}
    virtual void importGlobals(GlobalManager& globals, Module& wasm) = 0;
    virtual Literal callImport(Import* import, LiteralList& arguments) = 0;
    virtual Literal callTable(Index index, LiteralList& arguments, Type result, SubType& instance) = 0;
    virtual void growMemory(Address oldSize, Address newSize) = 0;
    virtual void trap(const char* why) = 0;

    // the default impls for load and store switch on the sizes. you can either
    // customize load/store, or the sub-functions which they call
    virtual Literal load(Load* load, Address addr) {
      switch (load->type) {
        case i32: {
          switch (load->bytes) {
            case 1: return load->signed_ ? Literal((int32_t)load8s(addr)) : Literal((int32_t)load8u(addr));
            case 2: return load->signed_ ? Literal((int32_t)load16s(addr)) : Literal((int32_t)load16u(addr));
            case 4: return Literal((int32_t)load32s(addr));
            default: WASM_UNREACHABLE();
          }
          break;
        }
        case i64: {
          switch (load->bytes) {
            case 1: return load->signed_ ? Literal((int64_t)load8s(addr)) : Literal((int64_t)load8u(addr));
            case 2: return load->signed_ ? Literal((int64_t)load16s(addr)) : Literal((int64_t)load16u(addr));
            case 4: return load->signed_ ? Literal((int64_t)load32s(addr)) : Literal((int64_t)load32u(addr));
            case 8: return Literal((int64_t)load64s(addr));
            default: WASM_UNREACHABLE();
          }
          break;
        }
        case f32: return Literal(load32u(addr)).castToF32();
        case f64: return Literal(load64u(addr)).castToF64();
        default: WASM_UNREACHABLE();
      }
    }
    virtual void store(Store* store, Address addr, Literal value) {
      switch (store->valueType) {
        case i32: {
          switch (store->bytes) {
            case 1: store8(addr, value.geti32()); break;
            case 2: store16(addr, value.geti32()); break;
            case 4: store32(addr, value.geti32()); break;
            default: WASM_UNREACHABLE();
          }
          break;
        }
        case i64: {
          switch (store->bytes) {
            case 1: store8(addr, value.geti64()); break;
            case 2: store16(addr, value.geti64()); break;
            case 4: store32(addr, value.geti64()); break;
            case 8: store64(addr, value.geti64()); break;
            default: WASM_UNREACHABLE();
          }
          break;
        }
        // write floats carefully, ensuring all bits reach memory
        case f32: store32(addr, value.reinterpreti32()); break;
        case f64: store64(addr, value.reinterpreti64()); break;
        default: WASM_UNREACHABLE();
      }
    }

    virtual int8_t load8s(Address addr) { WASM_UNREACHABLE(); }
    virtual uint8_t load8u(Address addr) { WASM_UNREACHABLE(); }
    virtual int16_t load16s(Address addr) { WASM_UNREACHABLE(); }
    virtual uint16_t load16u(Address addr) { WASM_UNREACHABLE(); }
    virtual int32_t load32s(Address addr) { WASM_UNREACHABLE(); }
    virtual uint32_t load32u(Address addr) { WASM_UNREACHABLE(); }
    virtual int64_t load64s(Address addr) { WASM_UNREACHABLE(); }
    virtual uint64_t load64u(Address addr) { WASM_UNREACHABLE(); }

    virtual void store8(Address addr, int8_t value) { WASM_UNREACHABLE(); }
    virtual void store16(Address addr, int16_t value) { WASM_UNREACHABLE(); }
    virtual void store32(Address addr, int32_t value) { WASM_UNREACHABLE(); }
    virtual void store64(Address addr, int64_t value) { WASM_UNREACHABLE(); }
  };

  SubType* self() {
    return static_cast<SubType*>(this);
  }

  Module& wasm;

  // Values of globals
  GlobalManager globals;

  ModuleInstanceBase(Module& wasm, ExternalInterface* externalInterface) : wasm(wasm), externalInterface(externalInterface) {
    // import globals from the outside
    externalInterface->importGlobals(globals, wasm);
    // prepare memory
    memorySize = wasm.memory.initial;
    // generate internal (non-imported) globals
    for (auto& global : wasm.globals) {
      globals[global->name] = ConstantExpressionRunner<GlobalManager>(globals).visit(global->init).value;
    }
    // initialize the rest of the external interface
    externalInterface->init(wasm, *self());
    // run start, if present
    if (wasm.start.is()) {
      LiteralList arguments;
      callFunction(wasm.start, arguments);
    }
  }

  // call an exported function
  Literal callExport(Name name, LiteralList& arguments) {
    Export *export_ = wasm.getExportOrNull(name);
    if (!export_) externalInterface->trap("callExport not found");
    return callFunction(export_->value, arguments);
  }

  Literal callExport(Name name) {
    LiteralList arguments;
    return callExport(name, arguments);
  }

  // get an exported global
  Literal getExport(Name name) {
    Export *export_ = wasm.getExportOrNull(name);
    if (!export_) externalInterface->trap("getExport external not found");
    Name internalName = export_->value;
    auto iter = globals.find(internalName);
    if (iter == globals.end()) externalInterface->trap("getExport internal not found");
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

public:
  // Call a function, starting an invocation.
  Literal callFunction(Name name, LiteralList& arguments) {
    // if the last call ended in a jump up the stack, it might have left stuff for us to clean up here
    callDepth = 0;
    functionStack.clear();
    return callFunctionInternal(name, arguments);
  }

  // Internal function call. Must be public so that callTable implementations can use it (refactor?)
  Literal callFunctionInternal(Name name, LiteralList& arguments) {

    class FunctionScope {
     public:
      std::vector<Literal> locals;
      Function* function;

      FunctionScope(Function* function, LiteralList& arguments)
          : function(function) {
        if (function->params.size() != arguments.size()) {
          std::cerr << "Function `" << function->name << "` expects "
                    << function->params.size() << " parameters, got "
                    << arguments.size() << " arguments." << std::endl;
          WASM_UNREACHABLE();
        }
        locals.resize(function->getNumLocals());
        for (size_t i = 0; i < function->getNumLocals(); i++) {
          if (i < arguments.size()) {
            assert(function->isParam(i));
            if (function->params[i] != arguments[i].type) {
              std::cerr << "Function `" << function->name << "` expects type "
                        << printType(function->params[i])
                        << " for parameter " << i << ", got "
                        << printType(arguments[i].type) << "." << std::endl;
              WASM_UNREACHABLE();
            }
            locals[i] = arguments[i];
          } else {
            assert(function->isVar(i));
            locals[i].type = function->getLocalType(i);
          }
        }
      }
    };

    // Executes expressions with concrete runtime info, the function and module at runtime
    class RuntimeExpressionRunner : public ExpressionRunner<RuntimeExpressionRunner> {
      ModuleInstanceBase& instance;
      FunctionScope& scope;

    public:
      RuntimeExpressionRunner(ModuleInstanceBase& instance, FunctionScope& scope) : instance(instance), scope(scope) {}

      Flow generateArguments(const ExpressionList& operands, LiteralList& arguments) {
        NOTE_ENTER_("generateArguments");
        arguments.reserve(operands.size());
        for (auto expression : operands) {
          Flow flow = this->visit(expression);
          if (flow.breaking()) return flow;
          NOTE_EVAL1(flow.value);
          arguments.push_back(flow.value);
        }
        return Flow();
      }

      Flow visitCall(Call *curr) {
        NOTE_ENTER("Call");
        NOTE_NAME(curr->target);
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        Flow ret = instance.callFunctionInternal(curr->target, arguments);
#ifdef WASM_INTERPRETER_DEBUG
        std::cout << "(returned to " << scope.function->name << ")\n";
#endif
        return ret;
      }
      Flow visitCallImport(CallImport *curr) {
        NOTE_ENTER("CallImport");
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        return instance.externalInterface->callImport(instance.wasm.getImport(curr->target), arguments);
      }
      Flow visitCallIndirect(CallIndirect *curr) {
        NOTE_ENTER("CallIndirect");
        LiteralList arguments;
        Flow flow = generateArguments(curr->operands, arguments);
        if (flow.breaking()) return flow;
        Flow target = this->visit(curr->target);
        if (target.breaking()) return target;
        Index index = target.value.geti32();
        return instance.externalInterface->callTable(index, arguments, curr->type, *instance.self());
      }

      Flow visitGetLocal(GetLocal *curr) {
        NOTE_ENTER("GetLocal");
        auto index = curr->index;
        NOTE_EVAL1(index);
        NOTE_EVAL1(scope.locals[index]);
        return scope.locals[index];
      }
      Flow visitSetLocal(SetLocal *curr) {
        NOTE_ENTER("SetLocal");
        auto index = curr->index;
        Flow flow = this->visit(curr->value);
        if (flow.breaking()) return flow;
        NOTE_EVAL1(index);
        NOTE_EVAL1(flow.value);
        assert(curr->isTee() ? flow.value.type == curr->type : true);
        scope.locals[index] = flow.value;
        return curr->isTee() ? flow : Flow();
      }

      Flow visitGetGlobal(GetGlobal *curr) {
        NOTE_ENTER("GetGlobal");
        auto name = curr->name;
        NOTE_EVAL1(name);
        assert(instance.globals.find(name) != instance.globals.end());
        NOTE_EVAL1(instance.globals[name]);
        return instance.globals[name];
      }
      Flow visitSetGlobal(SetGlobal *curr) {
        NOTE_ENTER("SetGlobal");
        auto name = curr->name;
        Flow flow = this->visit(curr->value);
        if (flow.breaking()) return flow;
        NOTE_EVAL1(name);
        NOTE_EVAL1(flow.value);
        instance.globals[name] = flow.value;
        return Flow();
      }

      Flow visitLoad(Load *curr) {
        NOTE_ENTER("Load");
        Flow flow = this->visit(curr->ptr);
        if (flow.breaking()) return flow;
        NOTE_EVAL1(flow);
        auto addr = instance.getFinalAddress(curr, flow.value);
        auto ret = instance.externalInterface->load(curr, addr);
        NOTE_EVAL1(addr);
        NOTE_EVAL1(ret);
        return ret;
      }
      Flow visitStore(Store *curr) {
        NOTE_ENTER("Store");
        Flow ptr = this->visit(curr->ptr);
        if (ptr.breaking()) return ptr;
        Flow value = this->visit(curr->value);
        if (value.breaking()) return value;
        auto addr = instance.getFinalAddress(curr, ptr.value);
        NOTE_EVAL1(addr);
        NOTE_EVAL1(value);
        instance.externalInterface->store(curr, addr, value.value);
        return Flow();
      }

      Flow visitAtomicRMW(AtomicRMW *curr) {
        NOTE_ENTER("AtomicRMW");
        Flow ptr = this->visit(curr->ptr);
        if (ptr.breaking()) return ptr;
        auto value = this->visit(curr->value);
        if (value.breaking()) return value;
        NOTE_EVAL1(ptr);
        auto addr = instance.getFinalAddress(curr, ptr.value);
        NOTE_EVAL1(addr);
        NOTE_EVAL1(value);
        auto loaded = instance.doAtomicLoad(addr, curr->bytes, curr->type);
        NOTE_EVAL1(loaded);
        auto computed = value.value;
        switch (curr->op) {
          case Add:  computed = computed.add(value.value); break;
          case Sub:  computed = computed.sub(value.value); break;
          case And:  computed = computed.and_(value.value); break;
          case Or:   computed = computed.or_(value.value);  break;
          case Xor:  computed = computed.xor_(value.value); break;
          case Xchg: computed = value.value;               break;
          default: WASM_UNREACHABLE();
        }
        instance.doAtomicStore(addr, curr->bytes, computed);
        return loaded;
      }
      Flow visitAtomicCmpxchg(AtomicCmpxchg *curr) {
        NOTE_ENTER("AtomicCmpxchg");
        Flow ptr = this->visit(curr->ptr);
        if (ptr.breaking()) return ptr;
        NOTE_EVAL1(ptr);
        auto expected = this->visit(curr->expected);
        if (expected.breaking()) return expected;
        auto replacement = this->visit(curr->replacement);
        if (replacement.breaking()) return replacement;
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
      Flow visitAtomicWait(AtomicWait *curr) {
        NOTE_ENTER("AtomicWait");
        Flow ptr = this->visit(curr->ptr);
        if (ptr.breaking()) return ptr;
        NOTE_EVAL1(ptr);
        auto expected = this->visit(curr->expected);
        NOTE_EVAL1(expected);
        if (expected.breaking()) return expected;
        auto timeout = this->visit(curr->timeout);
        NOTE_EVAL1(timeout);
        if (timeout.breaking()) return timeout;
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
      Flow visitAtomicWake(AtomicWake *curr) {
        NOTE_ENTER("AtomicWake");
        Flow ptr = this->visit(curr->ptr);
        if (ptr.breaking()) return ptr;
        NOTE_EVAL1(ptr);
        auto count = this->visit(curr->wakeCount);
        NOTE_EVAL1(count);
        if (count.breaking()) return count;
        // TODO: add threads support!
        return Literal(int32_t(0)); // none woken up
      }

      Flow visitHost(Host *curr) {
        NOTE_ENTER("Host");
        switch (curr->op) {
          case PageSize:   return Literal((int32_t)Memory::kPageSize);
          case CurrentMemory: return Literal(int32_t(instance.memorySize));
          case GrowMemory: {
            auto fail = Literal(int32_t(-1));
            Flow flow = this->visit(curr->operands[0]);
            if (flow.breaking()) return flow;
            int32_t ret = instance.memorySize;
            uint32_t delta = flow.value.geti32();
            if (delta > uint32_t(-1) /Memory::kPageSize) return fail;
            if (instance.memorySize >= uint32_t(-1) - delta) return fail;
            uint32_t newSize = instance.memorySize + delta;
            if (newSize > instance.wasm.memory.max) return fail;
            instance.externalInterface->growMemory(instance.memorySize * Memory::kPageSize, newSize * Memory::kPageSize);
            instance.memorySize = newSize;
            return Literal(int32_t(ret));
          }
          case HasFeature: {
            Name id = curr->nameOperand;
            if (id == WASM) return Literal(1);
            return Literal((int32_t)0);
          }
          default: WASM_UNREACHABLE();
        }
      }

      void trap(const char* why) override {
        instance.externalInterface->trap(why);
      }
    };

    if (callDepth > maxCallDepth) externalInterface->trap("stack limit");
    auto previousCallDepth = callDepth;
    callDepth++;
    auto previousFunctionStackSize = functionStack.size();
    functionStack.push_back(name);

    Function *function = wasm.getFunction(name);
    assert(function);
    FunctionScope scope(function, arguments);

#ifdef WASM_INTERPRETER_DEBUG
    std::cout << "entering " << function->name
              << "\n  with arguments:\n";
    for (unsigned i = 0; i < arguments.size(); ++i) {
      std::cout << "    $" << i << ": " << arguments[i] << '\n';
    }
#endif

    Flow flow = RuntimeExpressionRunner(*this, scope).visit(function->body);
    assert(!flow.breaking() || flow.breakTo == RETURN_FLOW); // cannot still be breaking, it means we missed our stop
    Literal ret = flow.value;
    if (function->result != ret.type) {
      std::cerr << "calling " << function->name << " resulted in " << ret << " but the function type is " << function->result << '\n';
      WASM_UNREACHABLE();
    }
    callDepth = previousCallDepth; // may decrease more than one, if we jumped up the stack
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

  void trapIfGt(uint64_t lhs, uint64_t rhs, const char* msg) {
    if (lhs > rhs) {
      std::stringstream ss;
      ss << msg << ": " << lhs << " > " << rhs;
      externalInterface->trap(ss.str().c_str());
    }
  }

  template <class LS>
  Address getFinalAddress(LS* curr, Literal ptr) {
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
typedef std::map<Name, Literal> TrivialGlobalManager;
class ModuleInstance : public ModuleInstanceBase<TrivialGlobalManager, ModuleInstance> {
public:
  ModuleInstance(Module& wasm, ExternalInterface* externalInterface) : ModuleInstanceBase(wasm, externalInterface) {}
};

} // namespace wasm

#endif // wasm_wasm_interpreter_h
