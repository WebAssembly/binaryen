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
// wasm.h: WebAssembly representation and processing library, in one
//         header file.
//
// This represents WebAssembly in an AST format, with a focus on making
// it easy to not just inspect but also to process. For example, some
// things that this enables are:
//
//  * Pretty-printing: Implemented in this file (printing can help
//                     understand the data structures here).
//  * Interpreting: See wasm-interpreter.h.
//  * Optimizing: See asm2wasm.h, which performs some optimizations
//                after code generation.
//  * Validation: See wasm-validator.h.
//

//
// wasm.js internal WebAssembly representation design:
//
//  * Unify where possible. Where size isn't a concern, combine
//    classes, so binary ops and relational ops are joined. This
//    simplifies that AST and makes traversals easier.
//  * Optimize for size? This might justify separating if and if_else
//    (so that if doesn't have an always-empty else; also it avoids
//    a branch).
//

#ifndef wasm_wasm_h
#define wasm_wasm_h

#include <cassert>
#include <cmath>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <fstream>
#include <map>
#include <string>
#include <vector>

#include "compiler-support.h"
#include "emscripten-optimizer/simple_ast.h"
#include "mixed_arena.h"
#include "pretty_printing.h"

namespace wasm {

// We use a Name for all of the identifiers. These are IStrings, so they are
// all interned - comparisons etc are just pointer comparisons, so there is no
// perf loss. Having names everywhere makes using the AST much nicer.
// TODO: as an optimization, IString values < some threshold could be considered
//       numerical indices directly.

struct Name : public cashew::IString {
  Name() : cashew::IString() {}
  Name(const char *str) : cashew::IString(str, false) {}
  Name(cashew::IString str) : cashew::IString(str) {}
  Name(const std::string &str) : cashew::IString(str.c_str(), false) {}

  friend std::ostream& operator<<(std::ostream &o, Name name) {
    assert(name.str);
    return o << '$' << name.str; // reference interpreter requires we prefix all names
  }

  static Name fromInt(size_t i) {
    return cashew::IString(std::to_string(i).c_str(), false);
  }
};

// Types

enum WasmType {
  none,
  i32,
  i64,
  f32,
  f64
};

inline const char* printWasmType(WasmType type) {
  switch (type) {
    case WasmType::none: return "none";
    case WasmType::i32: return "i32";
    case WasmType::i64: return "i64";
    case WasmType::f32: return "f32";
    case WasmType::f64: return "f64";
    default: WASM_UNREACHABLE();
  }
}

inline unsigned getWasmTypeSize(WasmType type) {
  switch (type) {
    case WasmType::none: abort();
    case WasmType::i32: return 4;
    case WasmType::i64: return 8;
    case WasmType::f32: return 4;
    case WasmType::f64: return 8;
    default: WASM_UNREACHABLE();
  }
}

inline bool isWasmTypeFloat(WasmType type) {
  switch (type) {
    case f32:
    case f64: return true;
    default: return false;
  }
}

inline WasmType getWasmType(unsigned size, bool float_) {
  if (size < 4) return WasmType::i32;
  if (size == 4) return float_ ? WasmType::f32 : WasmType::i32;
  if (size == 8) return float_ ? WasmType::f64 : WasmType::i64;
  abort();
}

// Literals

struct Literal {
  WasmType type;
  union {
    int32_t i32;
    int64_t i64;
    float f32;
    double f64;
  };

  Literal() : type(WasmType::none), f64(0) {}
  Literal(int32_t  init) : type(WasmType::i32), i32(init) {}
  Literal(uint32_t init) : type(WasmType::i32), i32(init) {}
  Literal(int64_t  init) : type(WasmType::i64), i64(init) {}
  Literal(uint64_t init) : type(WasmType::i64), i64(init) {}
  Literal(float    init) : type(WasmType::f32), f32(init) {}
  Literal(double   init) : type(WasmType::f64), f64(init) {}

  int32_t geti32() { assert(type == WasmType::i32); return i32; }
  int64_t geti64() { assert(type == WasmType::i64); return i64; }
  float   getf32() { assert(type == WasmType::f32); return f32; }
  double  getf64() { assert(type == WasmType::f64); return f64; }

  int32_t reinterpreti32() { assert(type == WasmType::f32); return i32; }
  int64_t reinterpreti64() { assert(type == WasmType::f64); return i64; }
  float   reinterpretf32() { assert(type == WasmType::i32); return f32; }
  double  reinterpretf64() { assert(type == WasmType::i64); return f64; }

  int64_t getInteger() {
    switch (type) {
      case WasmType::i32: return i32;
      case WasmType::i64: return i64;
      default: abort();
    }
  }

  double getFloat() {
    switch (type) {
      case WasmType::f32: return f32;
      case WasmType::f64: return f64;
      default: abort();
    }
  }

  bool operator==(Literal& other) {
    if (type != other.type) return false;
    switch (type) {
      case WasmType::none: return true;
      case WasmType::i32: return i32 == other.i32;
      case WasmType::i64: return i64 == other.i64;
      // reinterpret floating-point, to avoid nan != nan
      case WasmType::f32: return reinterpreti32() == other.reinterpreti32();
      case WasmType::f64: return reinterpreti64() == other.reinterpreti64();
      default: abort();
    }
  }

  static void printFloat(std::ostream &o, float f) {
    if (isnan(f)) {
      union {
        float ff;
        uint32_t ll;
      } u;
      u.ff = f;
      o << "nan:0x" << std::hex << u.ll << std::dec;
      return;
    }
    printDouble(o, f);
  }

  static void printDouble(std::ostream &o, double d) {
    if (d == 0 && std::signbit(d)) {
      o << "-0";
      return;
    }
    if (isnan(d)) {
      union {
        double dd;
        uint64_t ll;
      } u;
      u.dd = d;
      o << "nan:0x" << std::hex << u.ll << std::dec;
      return;
    }
    if (!std::isfinite(d)) {
      o << (d < 0 ? "-infinity" : "infinity");
      return;
    }
    const char *text = cashew::JSPrinter::numToString(d);
    // spec interpreter hates floats starting with '.'
    if (text[0] == '.') {
      o << '0';
    } else if (text[0] == '-' && text[1] == '.') {
      o << "-0";
      text++;
    }
    o << text;
  }

  friend std::ostream& operator<<(std::ostream &o, Literal literal) {
    o << '(';
    prepareMinorColor(o) << printWasmType(literal.type) << ".const ";
    switch (literal.type) {
      case none: o << "?"; break;
      case WasmType::i32: o << literal.i32; break;
      case WasmType::i64: o << literal.i64; break;
      case WasmType::f32: literal.printFloat(o, literal.f32); break;
      case WasmType::f64: literal.printDouble(o, literal.f64); break;
    }
    restoreNormalColor(o);
    return o << ')';
  }
};

// Operators

enum UnaryOp {
  Clz, Ctz, Popcnt, // int
  Neg, Abs, Ceil, Floor, Trunc, Nearest, Sqrt, // float
  // conversions
  ExtendSInt32, ExtendUInt32, WrapInt64, TruncSFloat32, TruncUFloat32, TruncSFloat64, TruncUFloat64, ReinterpretFloat, // int
  ConvertSInt32, ConvertUInt32, ConvertSInt64, ConvertUInt64, PromoteFloat32, DemoteFloat64, ReinterpretInt // float
};

enum BinaryOp {
  Add, Sub, Mul, // int or float
  DivS, DivU, RemS, RemU, And, Or, Xor, Shl, ShrU, ShrS, // int
  Div, CopySign, Min, Max, // float
  // relational ops
  Eq, Ne, // int or float
  LtS, LtU, LeS, LeU, GtS, GtU, GeS, GeU, // int
  Lt, Le, Gt, Ge // float
};

enum HostOp {
  PageSize, MemorySize, GrowMemory, HasFeature
};

#define assert_node(condition, node) \
  if (!(condition)) { \
    std::cerr << "node: " << (node) << std::endl; \
    assert(0 && #condition); \
  }

//
// Expressions
//
// Note that little is provided in terms of constructors for these. The rationale
// is that writing  new Something(a, b, c, d, e)  is not the clearest, and it would
// be better to write   new Something(name=a, leftOperand=b...  etc., but C++
// lacks named operands, so in asm2wasm etc. you will see things like
//   auto x = new Something();
//   x->name = a;
//   x->leftOperand = b;
//   ..
// which is less compact but less ambiguous. But hopefully we can do better,
// suggestions for API improvements here are welcome.
//

class Expression {
public:
  enum Id {
    InvalidId = 0,
    BlockId,
    IfId,
    LoopId,
    BreakId,
    SwitchId,
    CallId,
    CallImportId,
    CallIndirectId,
    GetLocalId,
    SetLocalId,
    LoadId,
    StoreId,
    ConstId,
    UnaryId,
    BinaryId,
    SelectId,
    HostId,
    NopId,
    UnreachableId
  };
  Id _id;

  WasmType type; // the type of the expression: its *output*, not necessarily its input(s)

  Expression() : _id(InvalidId), type(none) {}
  Expression(Id id) : _id(id), type(none) {}

  template<class T>
  bool is() {
    return _id == T()._id;
  }

  template<class T>
  T* dyn_cast() {
    return _id == T()._id ? (T*)this : nullptr;
  }

  template<class T>
  T* cast() {
    assert(_id == T()._id);
    return (T*)this;
  }

  inline std::ostream& print(std::ostream &o, unsigned indent); // avoid virtual here, for performance

  friend std::ostream& operator<<(std::ostream &o, Expression* expression) {
    return expression->print(o, 0);
  }

  static std::ostream& printFullLine(std::ostream &o, unsigned indent, Expression *expression) {
    doIndent(o, indent);
    expression->print(o, indent);
    return o << '\n';
  }
};

inline const char *getExpressionName(Expression *curr) {
  switch (curr->_id) {
    case Expression::Id::InvalidId: abort();
    case Expression::Id::BlockId: return "block";
    case Expression::Id::IfId: return "if";
    case Expression::Id::LoopId: return "loop";
    case Expression::Id::BreakId: return "break";
    case Expression::Id::SwitchId: return "switch";
    case Expression::Id::CallId: return "call";
    case Expression::Id::CallImportId: return "call_import";
    case Expression::Id::CallIndirectId: return "call_indirect";
    case Expression::Id::GetLocalId: return "get_local";
    case Expression::Id::SetLocalId: return "set_local";
    case Expression::Id::LoadId: return "load";
    case Expression::Id::StoreId: return "store";
    case Expression::Id::ConstId: return "const";
    case Expression::Id::UnaryId: return "unary";
    case Expression::Id::BinaryId: return "binary";
    case Expression::Id::SelectId: return "select";
    case Expression::Id::HostId: return "host";
    case Expression::Id::NopId: return "nop";
    case Expression::Id::UnreachableId: return "unreachable";
    default: WASM_UNREACHABLE();
  }
}

typedef std::vector<Expression*> ExpressionList; // TODO: optimize?

class Nop : public Expression {
public:
  Nop() : Expression(NopId) {}

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    return printMinorOpening(o, "nop") << ')';
  }
};

class Block : public Expression {
public:
  Block() : Expression(BlockId) {
    type = none; // blocks by default do not return, but if their last statement does, they might
  }

  Name name;
  ExpressionList list;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    printOpening(o, "block");
    if (name.is()) {
      o << ' ' << name;
    }
    incIndent(o, indent);
    for (auto expression : list) {
      printFullLine(o, indent, expression);
    }
    return decIndent(o, indent);
  }
};

class If : public Expression {
public:
  If() : Expression(IfId), ifFalse(nullptr) {
    type = none; // by default none; if-else can have one, though
  }

  Expression *condition, *ifTrue, *ifFalse;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    printOpening(o, ifFalse ? "if_else" : "if");
    incIndent(o, indent);
    printFullLine(o, indent, condition);
    printFullLine(o, indent, ifTrue);
    if (ifFalse) printFullLine(o, indent, ifFalse);
    return decIndent(o, indent);
  }
};

class Loop : public Expression {
public:
  Loop() : Expression(LoopId) {}

  Name out, in;
  Expression *body;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    printOpening(o, "loop");
    if (out.is()) {
      o << ' ' << out;
      assert(in.is()); // if just one is printed, it must be the in
    }
    if (in.is()) {
      o << ' ' << in;
    }
    incIndent(o, indent);
    auto block = body->dyn_cast<Block>();
    if (block && block->name.isNull()) {
      // wasm spec has loops containing children directly, while our ast
      // has a single child for simplicity. print out the optimal form.
      for (auto expression : block->list) {
        printFullLine(o, indent, expression);
      }
    } else {
      printFullLine(o, indent, body);
    }
    return decIndent(o, indent);
  }
};

class Break : public Expression {
public:
  Break() : Expression(BreakId), condition(nullptr), value(nullptr) {}

  Expression *condition;
  Name name;
  Expression *value;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    if (condition) {
      printOpening(o, "br_if");
      incIndent(o, indent);
      printFullLine(o, indent, condition);
      doIndent(o, indent) << name << '\n';
    } else {
      printOpening(o, "br ") << name;
      if (!value || value->is<Nop>()) {
        // avoid a new line just for the parens
        o << ")";
        return o;
      }
      incIndent(o, indent);
    }
    if (value && !value->is<Nop>()) printFullLine(o, indent, value);
    return decIndent(o, indent);
  }
};

class Switch : public Expression {
public:
  Switch() : Expression(SwitchId) {}

  struct Case {
    Name name;
    Expression *body;
    Case() {}
    Case(Name name, Expression *body) : name(name), body(body) {}
  };

  Name name;
  Expression *value;
  std::vector<Name> targets;
  Name default_;
  std::vector<Case> cases;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    printOpening(o, "tableswitch ");
    if (name.is()) o << name;
    incIndent(o, indent);
    printFullLine(o, indent, value);
    doIndent(o, indent) << "(table";
    std::set<Name> caseNames;
    for (auto& c : cases) {
      caseNames.insert(c.name);
    }
    for (auto& t : targets) {
      o << " (" << (caseNames.count(t) == 0 ? "br" : "case") << " " << (t.is() ? t : default_) << ")";
    }
    o << ")";
    if (default_.is()) o << " (" << (caseNames.count(default_) == 0 ? "br" : "case") << " " << default_ << ")";
    o << "\n";
    for (auto& c : cases) {
      doIndent(o, indent);
      printMinorOpening(o, "case ") << c.name;
      incIndent(o, indent);
      printFullLine(o, indent, c.body);
      decIndent(o, indent) << '\n';
    }
    return decIndent(o, indent);
  }

};

class CallBase : public Expression {
public:
  CallBase(Id which) : Expression(which) {}

  ExpressionList operands;
};

class Call : public CallBase {
public:
  Call() : CallBase(CallId) {}

  Name target;

  std::ostream& printBody(std::ostream &o, unsigned indent) {
    o << target;
    if (operands.size() > 0) {
      incIndent(o, indent);
      for (auto operand : operands) {
        printFullLine(o, indent, operand);
      }
      decIndent(o, indent);
    } else {
      o << ')';
    }
    return o;
  }

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    printOpening(o, "call ");
    return printBody(o, indent);
  }
};

class CallImport : public Call {
public:
  CallImport() {
    _id = CallImportId;
  }

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    printOpening(o, "call_import ");
    return printBody(o, indent);
  }
};

class FunctionType {
public:
  Name name;
  WasmType result;
  std::vector<WasmType> params;

  FunctionType() : result(none) {}

  std::ostream& print(std::ostream &o, unsigned indent, bool full=false) {
    if (full) {
      printOpening(o, "type") << ' ' << name << " (func";
    }
    if (params.size() > 0) {
      o << ' ';
      printMinorOpening(o, "param");
      for (auto& param : params) {
        o << ' ' << printWasmType(param);
      }
      o << ')';
    }
    if (result != none) {
      o << ' ';
      printMinorOpening(o, "result ") << printWasmType(result) << ')';
    }
    if (full) {
      o << "))";;
    }
    return o;
  }

  bool operator==(FunctionType& b) {
    if (name != b.name) return false; // XXX
    if (result != b.result) return false;
    if (params.size() != b.params.size()) return false;
    for (size_t i = 0; i < params.size(); i++) {
      if (params[i] != b.params[i]) return false;
    }
    return true;
  }
  bool operator!=(FunctionType& b) {
    return !(*this == b);
  }
};

class CallIndirect : public CallBase {
public:
  CallIndirect() : CallBase(CallIndirectId) {}

  FunctionType *fullType;
  Expression *target;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    printOpening(o, "call_indirect ") << fullType->name;
    incIndent(o, indent);
    printFullLine(o, indent, target);
    for (auto operand : operands) {
      printFullLine(o, indent, operand);
    }
    return decIndent(o, indent);
  }
};

class GetLocal : public Expression {
public:
  GetLocal() : Expression(GetLocalId) {}

  Name name;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    return printOpening(o, "get_local ") << name << ')';
  }
};

class SetLocal : public Expression {
public:
  SetLocal() : Expression(SetLocalId) {}

  Name name;
  Expression *value;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    printOpening(o, "set_local ") << name;
    incIndent(o, indent);
    printFullLine(o, indent, value);
    return decIndent(o, indent);
  }
};

class Load : public Expression {
public:
  Load() : Expression(LoadId) {}

  uint32_t bytes;
  bool signed_;
  uint32_t offset;
  uint32_t align;
  Expression *ptr;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    o << '(';
    prepareColor(o) << printWasmType(type) << ".load";
    if (bytes < 4) {
      if (bytes == 1) {
        o << '8';
      } else if (bytes == 2) {
        o << "16";
      } else {
        abort();
      }
      o << (signed_ ? "_s" : "_u");
    }
    restoreNormalColor(o);
    if (offset) {
      o << " offset=" << offset;
    }
    if (align) {
      o << " align=" << align;
    }
    incIndent(o, indent);
    printFullLine(o, indent, ptr);
    return decIndent(o, indent);
  }
};

class Store : public Expression {
public:
  Store() : Expression(StoreId) {}

  unsigned bytes;
  uint32_t offset;
  unsigned align;
  Expression *ptr, *value;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    o << '(';
    prepareColor(o) << printWasmType(type) << ".store";
    if (bytes < 4) {
      if (bytes == 1) {
        o << '8';
      } else if (bytes == 2) {
        o << "16";
      } else {
        abort();
      }
    }
    restoreNormalColor(o);
    if (offset) {
      o << " offset=" << offset;
    }
    if (align) {
      o << " align=" << align;
    }
    incIndent(o, indent);
    printFullLine(o, indent, ptr);
    printFullLine(o, indent, value);
    return decIndent(o, indent);
  }
};

class Const : public Expression {
public:
  Const() : Expression(ConstId) {}

  Literal value;

  Const* set(Literal value_) {
    value = value_;
    type = value.type;
    return this;
  }

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    return o << value;
  }
};

class Unary : public Expression {
public:
  Unary() : Expression(UnaryId) {}

  UnaryOp op;
  Expression *value;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    o << '(';
    prepareColor(o) << printWasmType(type) << '.';
    switch (op) {
      case Clz:              o << "clz";     break;
      case Ctz:              o << "ctz";     break;
      case Popcnt:           o << "popcnt";  break;
      case Neg:              o << "neg";     break;
      case Abs:              o << "abs";     break;
      case Ceil:             o << "ceil";    break;
      case Floor:            o << "floor";   break;
      case Trunc:            o << "trunc";   break;
      case Nearest:          o << "nearest"; break;
      case Sqrt:             o << "sqrt";    break;
      case ExtendSInt32:     o << "extend_s/i32"; break;
      case ExtendUInt32:     o << "extend_u/i32"; break;
      case WrapInt64:        o << "wrap/i64"; break;
      case TruncSFloat32:    o << "trunc_s/f32"; break;
      case TruncUFloat32:    o << "trunc_u/f32"; break;
      case TruncSFloat64:    o << "trunc_s/f64"; break;
      case TruncUFloat64:    o << "trunc_u/f64"; break;
      case ReinterpretFloat: o << "reinterpret/" << (type == i64 ? "f64" : "f32"); break;
      case ConvertUInt32:    o << "convert_u/i32"; break;
      case ConvertSInt32:    o << "convert_s/i32"; break;
      case ConvertUInt64:    o << "convert_u/i64"; break;
      case ConvertSInt64:    o << "convert_s/i64"; break;
      case PromoteFloat32:   o << "promote/f32"; break;
      case DemoteFloat64:    o << "demote/f64"; break;
      case ReinterpretInt:   o << "reinterpret/" << (type == f64 ? "i64" : "i32"); break;
      default: abort();
    }
    incIndent(o, indent);
    printFullLine(o, indent, value);
    return decIndent(o, indent);
  }
};

class Binary : public Expression {
public:
  Binary() : Expression(BinaryId) {}

  BinaryOp op;
  Expression *left, *right;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    o << '(';
    prepareColor(o) << printWasmType(isRelational() ? left->type : type) << '.';
    switch (op) {
      case Add:      o << "add";      break;
      case Sub:      o << "sub";      break;
      case Mul:      o << "mul";      break;
      case DivS:     o << "div_s";    break;
      case DivU:     o << "div_u";    break;
      case RemS:     o << "rem_s";    break;
      case RemU:     o << "rem_u";    break;
      case And:      o << "and";      break;
      case Or:       o << "or";       break;
      case Xor:      o << "xor";      break;
      case Shl:      o << "shl";      break;
      case ShrU:     o << "shr_u";    break;
      case ShrS:     o << "shr_s";    break;
      case Div:      o << "div";      break;
      case CopySign: o << "copysign"; break;
      case Min:      o << "min";      break;
      case Max:      o << "max";      break;
      case Eq:       o << "eq";       break;
      case Ne:       o << "ne";       break;
      case LtS:      o << "lt_s";     break;
      case LtU:      o << "lt_u";     break;
      case LeS:      o << "le_s";     break;
      case LeU:      o << "le_u";     break;
      case GtS:      o << "gt_s";     break;
      case GtU:      o << "gt_u";     break;
      case GeS:      o << "ge_s";     break;
      case GeU:      o << "ge_u";     break;
      case Lt:       o << "lt";       break;
      case Le:       o << "le";       break;
      case Gt:       o << "gt";       break;
      case Ge:       o << "ge";       break;
      default:       abort();
    }
    restoreNormalColor(o);
    incIndent(o, indent);
    printFullLine(o, indent, left);
    printFullLine(o, indent, right);
    return decIndent(o, indent);
  }

  // the type is always the type of the operands,
  // except for relationals

  bool isRelational() { return op >= Eq; }

  void finalize() {
    if (isRelational()) {
      type = i32;
    } else {
      assert_node(left->type == right->type, this);
      type = left->type;
    }
  }
};

class Select : public Expression {
public:
  Select() : Expression(SelectId) {}

  Expression *condition, *ifTrue, *ifFalse;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    o << '(';
    prepareColor(o) << printWasmType(type) << ".select";
    incIndent(o, indent);
    printFullLine(o, indent, condition);
    printFullLine(o, indent, ifTrue);
    printFullLine(o, indent, ifFalse);
    return decIndent(o, indent);
  }

  void finalize() {
    type = ifTrue->type;
    if (type == none) type = ifFalse->type; // ifTrue might be unreachable
  }
};

class Host : public Expression {
public:
  Host() : Expression(HostId) {}

  HostOp op;
  Name nameOperand;
  ExpressionList operands;

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    switch (op) {
      case PageSize: printOpening(o, "pagesize") << ')'; break;
      case MemorySize: printOpening(o, "memory_size") << ')'; break;
      case GrowMemory: {
        printOpening(o, "grow_memory");
        incIndent(o, indent);
        printFullLine(o, indent, operands[0]);
        decIndent(o, indent);
        break;
      }
      case HasFeature: printOpening(o, "hasfeature ") << nameOperand << ')'; break;
      default: abort();
    }
    return o;
  }

  void finalize() {
    switch (op) {
      case PageSize: case MemorySize: case HasFeature: {
        type = i32;
        break;
      }
      case GrowMemory: {
        type = none;
        break;
      }
      default: abort();
    }
  }
};

class Unreachable : public Expression {
public:
  Unreachable() : Expression(UnreachableId) {}

  std::ostream& doPrint(std::ostream &o, unsigned indent) {
    return printMinorOpening(o, "unreachable") << ')';
  }
};

// Globals

struct NameType {
  Name name;
  WasmType type;
  NameType() : name(nullptr), type(none) {}
  NameType(Name name, WasmType type) : name(name), type(type) {}
};

class Function {
public:
  Name name;
  WasmType result;
  std::vector<NameType> params;
  std::vector<NameType> locals;
  Name type; // if null, it is implicit in params and result
  Expression *body;

  Function() : result(none) {}

  std::ostream& print(std::ostream &o, unsigned indent) {
    printOpening(o, "func ", true) << name;
    if (params.size() > 0) {
      for (auto& param : params) {
        o << ' ';
        printMinorOpening(o, "param ") << param.name << ' ' << printWasmType(param.type) << ")";
      }
    }
    if (result != none) {
      o << ' ';
      printMinorOpening(o, "result ") << printWasmType(result) << ")";
    }
    incIndent(o, indent);
    for (auto& local : locals) {
      doIndent(o, indent);
      printMinorOpening(o, "local ") << local.name << ' ' << printWasmType(local.type) << ")\n";
    }
    // It is ok to emit a block here, as a function can directly contain a list, even if our
    // ast avoids that for simplicity. We can just do that optimization here..
    if (body->is<Block>() && body->cast<Block>()->name.isNull()) {
      Block* block = body->cast<Block>();
      for (auto item : block->list) {
        Expression::printFullLine(o, indent, item);
      }
    } else {
      Expression::printFullLine(o, indent, body);
    }
    return decIndent(o, indent);
  }
};

class Import {
public:
  Name name, module, base; // name = module.base
  FunctionType* type;

  Import() : type(nullptr) {}

  std::ostream& print(std::ostream &o, unsigned indent) {
    printOpening(o, "import ") << name << ' ';
    printText(o, module.str) << ' ';
    printText(o, base.str);
    if (type) type->print(o, indent);
    return o << ')';
  }
};

class Export {
public:
  Name name;
  Name value;

  std::ostream& print(std::ostream &o, unsigned indent) {
    printOpening(o, "export ");
    return printText(o, name.str) << ' ' << value << ')';
  }
};

class Table {
public:
  std::vector<Name> names;

  std::ostream& print(std::ostream &o, unsigned indent) {
    printOpening(o, "table");
    for (auto name : names) {
      o << ' ' << name;
    }
    return o << ')';
  }
};

class Memory {
public:
  struct Segment {
    size_t offset;
    const char* data;
    size_t size;
    Segment() {}
    Segment(size_t offset, const char *data, size_t size) : offset(offset), data(data), size(size) {}
  };

  size_t initial, max;
  std::vector<Segment> segments;

  Memory() : initial(0), max((uint32_t)-1) {}
};

class Module {
public:
  // internal wasm contents (don't access these from outside; use add*() and the *Map objects)
  std::vector<FunctionType*> functionTypes;
  std::vector<Import*> imports;
  std::vector<Export*> exports;
  std::vector<Function*> functions;

  // publicly-accessible content
  std::map<Name, FunctionType*> functionTypesMap;
  std::map<Name, Import*> importsMap;
  std::map<Name, Export*> exportsMap;
  std::map<Name, Function*> functionsMap;
  Table table;
  Memory memory;

  Module() : functionTypeIndex(0), importIndex(0), exportIndex(0), functionIndex(0) {}

  void addFunctionType(FunctionType* curr) {
    Name numericName = Name::fromInt(functionTypeIndex);
    if (curr->name.isNull()) {
      curr->name = numericName;
    }
    functionTypes.push_back(curr);
    functionTypesMap[curr->name] = curr;
    functionTypesMap[numericName] = curr;
    functionTypeIndex++;
  }
  void addImport(Import* curr) {
    Name numericName = Name::fromInt(importIndex);
    if (curr->name.isNull()) {
      curr->name = numericName;
    }
    imports.push_back(curr);
    importsMap[curr->name] = curr;
    importsMap[numericName] = curr;
    importIndex++;
  }
  void addExport(Export* curr) {
    Name numericName = Name::fromInt(exportIndex);
    if (curr->name.isNull()) {
      curr->name = numericName;
    }
    exports.push_back(curr);
    exportsMap[curr->name] = curr;
    exportsMap[numericName] = curr;
    exportIndex++;
  }
  void addFunction(Function* curr) {
    Name numericName = Name::fromInt(functionIndex);
    if (curr->name.isNull()) {
      curr->name = numericName;
    }
    functions.push_back(curr);
    functionsMap[curr->name] = curr;
    functionsMap[numericName] = curr;
    functionIndex++;
  }

  void removeImport(Name name) {
    for (size_t i = 0; i < imports.size(); i++) {
      if (imports[i]->name == name) {
        imports.erase(imports.begin() + i);
        break;
      }
    }
    importsMap.erase(name);
  }

  friend std::ostream& operator<<(std::ostream &o, Module module) {
    unsigned indent = 0;
    printOpening(o, "module", true);
    incIndent(o, indent);
    doIndent(o, indent);
    printOpening(o, "memory") << " " << module.memory.initial;
    if (module.memory.max) o << " " << module.memory.max;
    for (auto segment : module.memory.segments) {
      o << " (segment " << segment.offset << " \"";
      for (size_t i = 0; i < segment.size; i++) {
        unsigned char c = segment.data[i];
        switch (c) {
          case '\n': o << "\\n"; break;
          case '\r': o << "\\0d"; break;
          case '\t': o << "\\t"; break;
          case '\f': o << "\\0c"; break;
          case '\b': o << "\\08"; break;
          case '\\': o << "\\\\"; break;
          case '"' : o << "\\\""; break;
          case '\'' : o << "\\'"; break;
          default: {
            if (c >= 32 && c < 127) {
              o << c;
            } else {
              o << std::hex << '\\' << (c/16) << (c%16) << std::dec;
            }
          }
        }
      }
      o << "\")";
    }
    o << ")\n";
    for (auto& curr : module.functionTypes) {
      doIndent(o, indent);
      curr->print(o, indent, true);
      o << '\n';
    }
    for (auto& curr : module.imports) {
      doIndent(o, indent);
      curr->print(o, indent);
      o << '\n';
    }
    for (auto& curr : module.exports) {
      doIndent(o, indent);
      curr->print(o, indent);
      o << '\n';
    }
    if (module.table.names.size() > 0) {
      doIndent(o, indent);
      module.table.print(o, indent);
      o << '\n';
    }
    for (auto& curr : module.functions) {
      doIndent(o, indent);
      curr->print(o, indent);
      o << '\n';
    }
    decIndent(o, indent);
    return o << '\n';
  }

private:
  size_t functionTypeIndex, importIndex, exportIndex, functionIndex;
};

class AllocatingModule : public Module {
 public:
  MixedArena allocator;
};

//
// WebAssembly AST visitor. Useful for anything that wants to do something
// different for each AST node type, like printing, interpreting, etc.
//
// This class is specifically designed as a template to avoid virtual function
// call overhead. To write a visitor, derive from this class as follows:
//
//   struct MyVisitor : public WasmVisitor<MyVisitor> { .. }
//

template<typename SubType, typename ReturnType>
struct WasmVisitor {
  virtual ~WasmVisitor() {}
  // should be pure virtual, but https://gcc.gnu.org/bugzilla/show_bug.cgi?id=51048
  // Expression visitors
  ReturnType visitBlock(Block *curr) { abort(); }
  ReturnType visitIf(If *curr) { abort(); }
  ReturnType visitLoop(Loop *curr) { abort(); }
  ReturnType visitBreak(Break *curr) { abort(); }
  ReturnType visitSwitch(Switch *curr) { abort(); }
  ReturnType visitCall(Call *curr) { abort(); }
  ReturnType visitCallImport(CallImport *curr) { abort(); }
  ReturnType visitCallIndirect(CallIndirect *curr) { abort(); }
  ReturnType visitGetLocal(GetLocal *curr) { abort(); }
  ReturnType visitSetLocal(SetLocal *curr) { abort(); }
  ReturnType visitLoad(Load *curr) { abort(); }
  ReturnType visitStore(Store *curr) { abort(); }
  ReturnType visitConst(Const *curr) { abort(); }
  ReturnType visitUnary(Unary *curr) { abort(); }
  ReturnType visitBinary(Binary *curr) { abort(); }
  ReturnType visitSelect(Select *curr) { abort(); }
  ReturnType visitHost(Host *curr) { abort(); }
  ReturnType visitNop(Nop *curr) { abort(); }
  ReturnType visitUnreachable(Unreachable *curr) { abort(); }
  // Module-level visitors
  ReturnType visitFunctionType(FunctionType *curr) { abort(); }
  ReturnType visitImport(Import *curr) { abort(); }
  ReturnType visitExport(Export *curr) { abort(); }
  ReturnType visitFunction(Function *curr) { abort(); }
  ReturnType visitTable(Table *curr) { abort(); }
  ReturnType visitMemory(Memory *curr) { abort(); }
  ReturnType visitModule(Module *curr) { abort(); }

#define DELEGATE(CLASS_TO_VISIT) \
  return static_cast<SubType*>(this)-> \
      visit##CLASS_TO_VISIT(static_cast<CLASS_TO_VISIT*>(curr))

  ReturnType visit(Expression *curr) {
    assert(curr);
    switch (curr->_id) {
      case Expression::Id::InvalidId: abort();
      case Expression::Id::BlockId: DELEGATE(Block);
      case Expression::Id::IfId: DELEGATE(If);
      case Expression::Id::LoopId: DELEGATE(Loop);
      case Expression::Id::BreakId: DELEGATE(Break);
      case Expression::Id::SwitchId: DELEGATE(Switch);
      case Expression::Id::CallId: DELEGATE(Call);
      case Expression::Id::CallImportId: DELEGATE(CallImport);
      case Expression::Id::CallIndirectId: DELEGATE(CallIndirect);
      case Expression::Id::GetLocalId: DELEGATE(GetLocal);
      case Expression::Id::SetLocalId: DELEGATE(SetLocal);
      case Expression::Id::LoadId: DELEGATE(Load);
      case Expression::Id::StoreId: DELEGATE(Store);
      case Expression::Id::ConstId: DELEGATE(Const);
      case Expression::Id::UnaryId: DELEGATE(Unary);
      case Expression::Id::BinaryId: DELEGATE(Binary);
      case Expression::Id::SelectId: DELEGATE(Select);
      case Expression::Id::HostId: DELEGATE(Host);
      case Expression::Id::NopId: DELEGATE(Nop);
      case Expression::Id::UnreachableId: DELEGATE(Unreachable);
      default: WASM_UNREACHABLE();
    }
  }
};

std::ostream& Expression::print(std::ostream &o, unsigned indent) {
  struct ExpressionPrinter : public WasmVisitor<ExpressionPrinter, void> {
    std::ostream &o;
    unsigned indent;

    ExpressionPrinter(std::ostream &o, unsigned indent) : o(o), indent(indent) {}

    void visitBlock(Block *curr) { curr->doPrint(o, indent); }
    void visitIf(If *curr) { curr->doPrint(o, indent); }
    void visitLoop(Loop *curr) { curr->doPrint(o, indent); }
    void visitBreak(Break *curr) { curr->doPrint(o, indent); }
    void visitSwitch(Switch *curr) { curr->doPrint(o, indent); }
    void visitCall(Call *curr) { curr->doPrint(o, indent); }
    void visitCallImport(CallImport *curr) { curr->doPrint(o, indent); }
    void visitCallIndirect(CallIndirect *curr) { curr->doPrint(o, indent); }
    void visitGetLocal(GetLocal *curr) { curr->doPrint(o, indent); }
    void visitSetLocal(SetLocal *curr) { curr->doPrint(o, indent); }
    void visitLoad(Load *curr) { curr->doPrint(o, indent); }
    void visitStore(Store *curr) { curr->doPrint(o, indent); }
    void visitConst(Const *curr) { curr->doPrint(o, indent); }
    void visitUnary(Unary *curr) { curr->doPrint(o, indent); }
    void visitBinary(Binary *curr) { curr->doPrint(o, indent); }
    void visitSelect(Select *curr) { curr->doPrint(o, indent); }
    void visitHost(Host *curr) { curr->doPrint(o, indent); }
    void visitNop(Nop *curr) { curr->doPrint(o, indent); }
    void visitUnreachable(Unreachable *curr) { curr->doPrint(o, indent); }
  };

  ExpressionPrinter(o, indent).visit(this);

  return o;
}

//
// Base class for all WasmWalkers
//
template<typename SubType, typename ReturnType = void>
struct WasmWalkerBase : public WasmVisitor<SubType, ReturnType> {
  virtual void walk(Expression*& curr) { abort(); }
  virtual void startWalk(Function *func) { abort(); }
  virtual void startWalk(Module *module) { abort(); }
};

template<typename ParentType>
struct ChildWalker : public WasmWalkerBase<ChildWalker<ParentType>> {
  ParentType& parent;

  ChildWalker(ParentType& parent) : parent(parent) {}

  void visitBlock(Block *curr) {
    ExpressionList& list = curr->list;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitIf(If *curr) {
    parent.walk(curr->condition);
    parent.walk(curr->ifTrue);
    parent.walk(curr->ifFalse);
  }
  void visitLoop(Loop *curr) {
    parent.walk(curr->body);
  }
  void visitBreak(Break *curr) {
    parent.walk(curr->condition);
    parent.walk(curr->value);
  }
  void visitSwitch(Switch *curr) {
    parent.walk(curr->value);
    for (auto& case_ : curr->cases) {
      parent.walk(case_.body);
    }
  }
  void visitCall(Call *curr) {
    ExpressionList& list = curr->operands;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitCallImport(CallImport *curr) {
    ExpressionList& list = curr->operands;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitCallIndirect(CallIndirect *curr) {
    parent.walk(curr->target);
    ExpressionList& list = curr->operands;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitGetLocal(GetLocal *curr) {}
  void visitSetLocal(SetLocal *curr) {
    parent.walk(curr->value);
  }
  void visitLoad(Load *curr) {
    parent.walk(curr->ptr);
  }
  void visitStore(Store *curr) {
    parent.walk(curr->ptr);
    parent.walk(curr->value);
  }
  void visitConst(Const *curr) {}
  void visitUnary(Unary *curr) {
    parent.walk(curr->value);
  }
  void visitBinary(Binary *curr) {
    parent.walk(curr->left);
    parent.walk(curr->right);
  }
  void visitSelect(Select *curr) {
    parent.walk(curr->condition);
    parent.walk(curr->ifTrue);
    parent.walk(curr->ifFalse);
  }
  void visitHost(Host *curr) {
    ExpressionList& list = curr->operands;
    for (size_t z = 0; z < list.size(); z++) {
      parent.walk(list[z]);
    }
  }
  void visitNop(Nop *curr) {}
  void visitUnreachable(Unreachable *curr) {}
};

//
// Simple WebAssembly children-first walking (i.e., post-order, if you look
// at the children as subtrees of the current node), with the ability to replace
// the current expression node. Useful for writing optimization passes.
//

template<typename SubType, typename ReturnType = void>
struct WasmWalker : public WasmWalkerBase<SubType, ReturnType> {
  Expression* replace;

  WasmWalker() : replace(nullptr) {}

  // the visit* methods can call this to replace the current node
  void replaceCurrent(Expression *expression) {
    replace = expression;
  }

  // By default, do nothing
  ReturnType visitBlock(Block *curr) {}
  ReturnType visitIf(If *curr) {}
  ReturnType visitLoop(Loop *curr) {}
  ReturnType visitBreak(Break *curr) {}
  ReturnType visitSwitch(Switch *curr) {}
  ReturnType visitCall(Call *curr) {}
  ReturnType visitCallImport(CallImport *curr) {}
  ReturnType visitCallIndirect(CallIndirect *curr) {}
  ReturnType visitGetLocal(GetLocal *curr) {}
  ReturnType visitSetLocal(SetLocal *curr) {}
  ReturnType visitLoad(Load *curr) {}
  ReturnType visitStore(Store *curr) {}
  ReturnType visitConst(Const *curr) {}
  ReturnType visitUnary(Unary *curr) {}
  ReturnType visitBinary(Binary *curr) {}
  ReturnType visitSelect(Select *curr) {}
  ReturnType visitHost(Host *curr) {}
  ReturnType visitNop(Nop *curr) {}
  ReturnType visitUnreachable(Unreachable *curr) {}

  ReturnType visitFunctionType(FunctionType *curr) {}
  ReturnType visitImport(Import *curr) {}
  ReturnType visitExport(Export *curr) {}
  ReturnType visitFunction(Function *curr) {}
  ReturnType visitTable(Table *curr) {}
  ReturnType visitMemory(Memory *curr) {}
  ReturnType visitModule(Module *curr) {}

  // children-first
  void walk(Expression*& curr) override {
    if (!curr) return;

    ChildWalker<WasmWalker<SubType, ReturnType>>(*this).visit(curr);

    this->visit(curr);

    if (replace) {
      curr = replace;
      replace = nullptr;
    }
  }

  void startWalk(Function *func) override {
    walk(func->body);
  }

  void startWalk(Module *module) override {
    // Dispatch statically through the SubType.
    SubType* self = static_cast<SubType*>(this);
    for (auto curr : module->functionTypes) {
      self->visitFunctionType(curr);
      assert(!replace);
    }
    for (auto curr : module->imports) {
      self->visitImport(curr);
      assert(!replace);
    }
    for (auto curr : module->exports) {
      self->visitExport(curr);
      assert(!replace);
    }
    for (auto curr : module->functions) {
      startWalk(curr);
      self->visitFunction(curr);
      assert(!replace);
    }
    self->visitTable(&module->table);
    assert(!replace);
    self->visitMemory(&module->memory);
    assert(!replace);
    self->visitModule(module);
    assert(!replace);
  }
};

} // namespace wasm

#endif // wasm_wasm_h
