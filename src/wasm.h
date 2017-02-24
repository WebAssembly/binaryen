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
//  * Interpreting: See wasm-interpreter.h.
//  * Optimizing: See asm2wasm.h, which performs some optimizations
//                after code generation.
//  * Validation: See wasm-validator.h.
//  * Pretty-printing: See Print.cpp.
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
#include "support/bits.h"
#include "support/name.h"
#include "support/utilities.h"

namespace wasm {

// An index in a wasm module
typedef uint32_t Index;

// An address in linear memory. For now only wasm32
struct Address {
  typedef uint32_t address_t;
  address_t addr;
  Address() : addr(0) {}
  Address(uint64_t a) : addr(static_cast<address_t>(a)) {
    assert(a <= std::numeric_limits<address_t>::max());
  }
  Address& operator=(uint64_t a) {
    assert(a <= std::numeric_limits<address_t>::max());
    addr = static_cast<address_t>(a);
    return *this;
  }
  operator address_t() const { return addr; }
  Address& operator++() { ++addr; return *this; }
};

// An offset into memory
typedef int32_t Offset;

// Types

enum WasmType {
  none,
  i32,
  i64,
  f32,
  f64,
  unreachable // none means no type, e.g. a block can have no return type. but
              // unreachable is different, as it can be "ignored" when doing
              // type checking across branches
};

const char* printWasmType(WasmType type);
unsigned getWasmTypeSize(WasmType type);
bool isWasmTypeFloat(WasmType type);
WasmType getWasmType(unsigned size, bool float_);
WasmType getReachableWasmType(WasmType a, WasmType b);
bool isConcreteWasmType(WasmType type);

// Literals

class Literal {
public:
  WasmType type;

private:
  // store only integers, whose bits are deterministic. floats
  // can have their signalling bit set, for example.
  union {
    int32_t i32;
    int64_t i64;
  };

  // The RHS of shl/shru/shrs must be masked by bitwidth.
  template <typename T>
  static T shiftMask(T val) {
    return val & (sizeof(T) * 8 - 1);
  }

 public:
  Literal() : type(WasmType::none), i64(0) {}
  explicit Literal(WasmType type) : type(type), i64(0) {}
  explicit Literal(int32_t  init) : type(WasmType::i32), i32(init) {}
  explicit Literal(uint32_t init) : type(WasmType::i32), i32(init) {}
  explicit Literal(int64_t  init) : type(WasmType::i64), i64(init) {}
  explicit Literal(uint64_t init) : type(WasmType::i64), i64(init) {}
  explicit Literal(float    init) : type(WasmType::f32), i32(bit_cast<int32_t>(init)) {}
  explicit Literal(double   init) : type(WasmType::f64), i64(bit_cast<int64_t>(init)) {}

  Literal castToF32();
  Literal castToF64();
  Literal castToI32();
  Literal castToI64();

  int32_t geti32() const { assert(type == WasmType::i32); return i32; }
  int64_t geti64() const { assert(type == WasmType::i64); return i64; }
  float   getf32() const { assert(type == WasmType::f32); return bit_cast<float>(i32); }
  double  getf64() const { assert(type == WasmType::f64); return bit_cast<double>(i64); }

  int32_t* geti32Ptr() { assert(type == WasmType::i32); return &i32; } // careful!

  int32_t reinterpreti32() const { assert(type == WasmType::f32); return i32; }
  int64_t reinterpreti64() const { assert(type == WasmType::f64); return i64; }
  float   reinterpretf32() const { assert(type == WasmType::i32); return bit_cast<float>(i32); }
  double  reinterpretf64() const { assert(type == WasmType::i64); return bit_cast<double>(i64); }

  int64_t getInteger();
  double getFloat();
  int64_t getBits();
  bool operator==(const Literal& other) const;
  bool operator!=(const Literal& other) const;

  static uint32_t NaNPayload(float f);
  static uint64_t NaNPayload(double f);
  static float setQuietNaN(float f);
  static double setQuietNaN(double f);

  static void printFloat(std::ostream &o, float f);
  static void printDouble(std::ostream& o, double d);

  friend std::ostream& operator<<(std::ostream& o, Literal literal);

  Literal countLeadingZeroes() const;
  Literal countTrailingZeroes() const;
  Literal popCount() const;

  Literal extendToSI64() const;
  Literal extendToUI64() const;
  Literal extendToF64() const;
  Literal truncateToI32() const;
  Literal truncateToF32() const;

  Literal convertSToF32() const;
  Literal convertUToF32() const;
  Literal convertSToF64() const;
  Literal convertUToF64() const;

  Literal neg() const;
  Literal abs() const;
  Literal ceil() const;
  Literal floor() const;
  Literal trunc() const;
  Literal nearbyint() const;
  Literal sqrt() const;

  Literal add(const Literal& other) const;
  Literal sub(const Literal& other) const;
  Literal mul(const Literal& other) const;
  Literal div(const Literal& other) const;
  Literal divS(const Literal& other) const;
  Literal divU(const Literal& other) const;
  Literal remS(const Literal& other) const;
  Literal remU(const Literal& other) const;
  Literal and_(const Literal& other) const;
  Literal or_(const Literal& other) const;
  Literal xor_(const Literal& other) const;
  Literal shl(const Literal& other) const;
  Literal shrS(const Literal& other) const;
  Literal shrU(const Literal& other) const;
  Literal rotL(const Literal& other) const;
  Literal rotR(const Literal& other) const;

  Literal eq(const Literal& other) const;
  Literal ne(const Literal& other) const;
  Literal ltS(const Literal& other) const;
  Literal ltU(const Literal& other) const;
  Literal lt(const Literal& other) const;
  Literal leS(const Literal& other) const;
  Literal leU(const Literal& other) const;
  Literal le(const Literal& other) const;

  Literal gtS(const Literal& other) const;
  Literal gtU(const Literal& other) const;
  Literal gt(const Literal& other) const;
  Literal geS(const Literal& other) const;
  Literal geU(const Literal& other) const;
  Literal ge(const Literal& other) const;

  Literal min(const Literal& other) const;
  Literal max(const Literal& other) const;
  Literal copysign(const Literal& other) const;
};

// Operators

enum UnaryOp {
  ClzInt32, ClzInt64, CtzInt32, CtzInt64, PopcntInt32, PopcntInt64, // int
  NegFloat32, NegFloat64, AbsFloat32, AbsFloat64, CeilFloat32, CeilFloat64, FloorFloat32, FloorFloat64, TruncFloat32, TruncFloat64, NearestFloat32, NearestFloat64, SqrtFloat32, SqrtFloat64, // float
  // relational
  EqZInt32, EqZInt64,
  // conversions
  ExtendSInt32, ExtendUInt32, // extend i32 to i64
  WrapInt64, // i64 to i32
  TruncSFloat32ToInt32, TruncSFloat32ToInt64, TruncUFloat32ToInt32, TruncUFloat32ToInt64, TruncSFloat64ToInt32, TruncSFloat64ToInt64, TruncUFloat64ToInt32, TruncUFloat64ToInt64, // float to int
  ReinterpretFloat32, ReinterpretFloat64, // reintepret bits to int
  ConvertSInt32ToFloat32, ConvertSInt32ToFloat64, ConvertUInt32ToFloat32, ConvertUInt32ToFloat64, ConvertSInt64ToFloat32, ConvertSInt64ToFloat64, ConvertUInt64ToFloat32, ConvertUInt64ToFloat64, // int to float
  PromoteFloat32, // f32 to f64
  DemoteFloat64, // f64 to f32
  ReinterpretInt32, ReinterpretInt64, // reinterpret bits to float
};

enum BinaryOp {
  AddInt32, SubInt32, MulInt32, // int or float
  DivSInt32, DivUInt32, RemSInt32, RemUInt32, AndInt32, OrInt32, XorInt32, ShlInt32, ShrUInt32, ShrSInt32, RotLInt32, RotRInt32, // int
  // relational ops
  EqInt32, NeInt32, // int or float
  LtSInt32, LtUInt32, LeSInt32, LeUInt32, GtSInt32, GtUInt32, GeSInt32, GeUInt32, // int

  AddInt64, SubInt64, MulInt64, // int or float
  DivSInt64, DivUInt64, RemSInt64, RemUInt64, AndInt64, OrInt64, XorInt64, ShlInt64, ShrUInt64, ShrSInt64, RotLInt64, RotRInt64, // int
  // relational ops
  EqInt64, NeInt64, // int or float
  LtSInt64, LtUInt64, LeSInt64, LeUInt64, GtSInt64, GtUInt64, GeSInt64, GeUInt64, // int

  AddFloat32, SubFloat32, MulFloat32, // int or float
  DivFloat32, CopySignFloat32, MinFloat32, MaxFloat32, // float
  // relational ops
  EqFloat32, NeFloat32, // int or float
  LtFloat32, LeFloat32, GtFloat32, GeFloat32, // float

  AddFloat64, SubFloat64, MulFloat64, // int or float
  DivFloat64, CopySignFloat64, MinFloat64, MaxFloat64, // float
  // relational ops
  EqFloat64, NeFloat64, // int or float
  LtFloat64, LeFloat64, GtFloat64, GeFloat64, // float
};

enum HostOp {
  PageSize, CurrentMemory, GrowMemory, HasFeature
};

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
// which is less compact but less ambiguous. See wasm-builder.h for a more
// friendly API for building nodes.
//
// Most nodes have no need of internal allocation, and when arena-allocated
// they drop the provided arena on the floor. You can create random instances
// of those that are not in an arena without issue. However, the nodes that
// have internal allocation will need an allocator provided to them in order
// to be constructed.

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
    GetGlobalId,
    SetGlobalId,
    LoadId,
    StoreId,
    ConstId,
    UnaryId,
    BinaryId,
    SelectId,
    DropId,
    ReturnId,
    HostId,
    NopId,
    UnreachableId,
    NumExpressionIds
  };
  Id _id;

  WasmType type; // the type of the expression: its *output*, not necessarily its input(s)

  Expression(Id id) : _id(id), type(none) {}

  void finalize() {}

  template<class T>
  bool is() {
    return int(_id) == int(T::SpecificId);
  }

  template<class T>
  T* dynCast() {
    return int(_id) == int(T::SpecificId) ? (T*)this : nullptr;
  }

  template<class T>
  T* cast() {
    assert(int(_id) == int(T::SpecificId));
    return (T*)this;
  }
};

const char* getExpressionName(Expression* curr);

typedef ArenaVector<Expression*> ExpressionList;

template<Expression::Id SID>
class SpecificExpression : public Expression {
public:
  enum {
    SpecificId = SID // compile-time access to the type for the class
  };

  SpecificExpression() : Expression(SID) {}
};

class Nop : public SpecificExpression<Expression::NopId> {
public:
  Nop() {}
  Nop(MixedArena& allocator) {}
};

class Block : public SpecificExpression<Expression::BlockId> {
public:
  Block(MixedArena& allocator) : list(allocator) {}

  Name name;
  ExpressionList list;

  // set the type given you know its type, which is the case when parsing
  // s-expression or binary, as explicit types are given. the only additional work
  // this does is to set the type to unreachable in the cases that is needed.
  void finalize(WasmType type_);

  // set the type purely based on its contents. this scans the block, so it is not fast
  void finalize();
};

class If : public SpecificExpression<Expression::IfId> {
public:
  If() : ifFalse(nullptr) {}
  If(MixedArena& allocator) : If() {}

  Expression* condition;
  Expression* ifTrue;
  Expression* ifFalse;

  // set the type given you know its type, which is the case when parsing
  // s-expression or binary, as explicit types are given. the only additional work
  // this does is to set the type to unreachable in the cases that is needed.
  void finalize(WasmType type_);

  // set the type purely based on its contents.
  void finalize();
};

class Loop : public SpecificExpression<Expression::LoopId> {
public:
  Loop() {}
  Loop(MixedArena& allocator) {}

  Name name;
  Expression* body;

  // set the type given you know its type, which is the case when parsing
  // s-expression or binary, as explicit types are given. the only additional work
  // this does is to set the type to unreachable in the cases that is needed.
  void finalize(WasmType type_);

  // set the type purely based on its contents.
  void finalize();
};

class Break : public SpecificExpression<Expression::BreakId> {
public:
  Break() : value(nullptr), condition(nullptr) {}
  Break(MixedArena& allocator) : Break() {
    type = unreachable;
  }

  Name name;
  Expression* value;
  Expression* condition;

  void finalize() {
    if (condition) {
      if (value) {
        type = value->type;
      } else {
        type = none;
      }
    } else {
      type = unreachable;
    }
  }
};

class Switch : public SpecificExpression<Expression::SwitchId> {
public:
  Switch(MixedArena& allocator) : targets(allocator), condition(nullptr), value(nullptr) {
    type = unreachable;
  }

  ArenaVector<Name> targets;
  Name default_;
  Expression* condition;
  Expression* value;
};

class Call : public SpecificExpression<Expression::CallId> {
public:
  Call(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name target;
};

class CallImport : public SpecificExpression<Expression::CallImportId> {
public:
  CallImport(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name target;
};

class FunctionType {
public:
  Name name;
  WasmType result;
  std::vector<WasmType> params;

  FunctionType() : result(none) {}

  bool structuralComparison(FunctionType& b) {
    if (result != b.result) return false;
    if (params.size() != b.params.size()) return false;
    for (size_t i = 0; i < params.size(); i++) {
      if (params[i] != b.params[i]) return false;
    }
    return true;
  }

  bool operator==(FunctionType& b) {
    if (name != b.name) return false;
    return structuralComparison(b);
  }
  bool operator!=(FunctionType& b) {
    return !(*this == b);
  }
};

class CallIndirect : public SpecificExpression<Expression::CallIndirectId> {
public:
  CallIndirect(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name fullType;
  Expression* target;
};

class GetLocal : public SpecificExpression<Expression::GetLocalId> {
public:
  GetLocal() {}
  GetLocal(MixedArena& allocator) {}

  Index index;
};

class SetLocal : public SpecificExpression<Expression::SetLocalId> {
public:
  SetLocal() {}
  SetLocal(MixedArena& allocator) {}

  Index index;
  Expression* value;

  bool isTee() {
    return type != none;
  }

  void setTee(bool is) {
    if (is) type = value->type;
    else type = none;
  }
};

class GetGlobal : public SpecificExpression<Expression::GetGlobalId> {
public:
  GetGlobal() {}
  GetGlobal(MixedArena& allocator) {}

  Name name;
};

class SetGlobal : public SpecificExpression<Expression::SetGlobalId> {
public:
  SetGlobal() {}
  SetGlobal(MixedArena& allocator) {}

  Name name;
  Expression* value;
};

class Load : public SpecificExpression<Expression::LoadId> {
public:
  Load() {}
  Load(MixedArena& allocator) {}

  uint8_t bytes;
  bool signed_;
  Address offset;
  Address align;
  Expression* ptr;

  // type must be set during creation, cannot be inferred
};

class Store : public SpecificExpression<Expression::StoreId> {
public:
  Store() : valueType(none) {}
  Store(MixedArena& allocator) : Store() {}

  uint8_t bytes;
  Address offset;
  Address align;
  Expression* ptr;
  Expression* value;
  WasmType valueType; // the store never returns a value

  void finalize() {
    assert(valueType != none); // must be set
  }
};

class Const : public SpecificExpression<Expression::ConstId> {
public:
  Const() {}
  Const(MixedArena& allocator) {}

  Literal value;

  Const* set(Literal value_) {
    value = value_;
    type = value.type;
    return this;
  }
};

class Unary : public SpecificExpression<Expression::UnaryId> {
public:
  Unary() {}
  Unary(MixedArena& allocator) {}

  UnaryOp op;
  Expression* value;

  bool isRelational() { return op == EqZInt32 || op == EqZInt64; }

  void finalize() {
    switch (op) {
      case ClzInt32:
      case CtzInt32:
      case PopcntInt32:
      case NegFloat32:
      case AbsFloat32:
      case CeilFloat32:
      case FloorFloat32:
      case TruncFloat32:
      case NearestFloat32:
      case SqrtFloat32:
      case ClzInt64:
      case CtzInt64:
      case PopcntInt64:
      case NegFloat64:
      case AbsFloat64:
      case CeilFloat64:
      case FloorFloat64:
      case TruncFloat64:
      case NearestFloat64:
      case SqrtFloat64: type = value->type; break;
      case EqZInt32:
      case EqZInt64: type = i32; break;
      case ExtendSInt32: case ExtendUInt32: type = i64; break;
      case WrapInt64: type = i32; break;
      case PromoteFloat32: type = f64; break;
      case DemoteFloat64: type = f32; break;
      case TruncSFloat32ToInt32:
      case TruncUFloat32ToInt32:
      case TruncSFloat64ToInt32:
      case TruncUFloat64ToInt32:
      case ReinterpretFloat32: type = i32; break;
      case TruncSFloat32ToInt64:
      case TruncUFloat32ToInt64:
      case TruncSFloat64ToInt64:
      case TruncUFloat64ToInt64:
      case ReinterpretFloat64: type = i64; break;
      case ReinterpretInt32:
      case ConvertSInt32ToFloat32:
      case ConvertUInt32ToFloat32:
      case ConvertSInt64ToFloat32:
      case ConvertUInt64ToFloat32: type = f32; break;
      case ReinterpretInt64:
      case ConvertSInt32ToFloat64:
      case ConvertUInt32ToFloat64:
      case ConvertSInt64ToFloat64:
      case ConvertUInt64ToFloat64: type = f64; break;
      default: std::cerr << "waka " << op << '\n'; WASM_UNREACHABLE();
    }
  }
};

class Binary : public SpecificExpression<Expression::BinaryId> {
public:
  Binary() {}
  Binary(MixedArena& allocator) {}

  BinaryOp op;
  Expression* left;
  Expression* right;

  // the type is always the type of the operands,
  // except for relationals

  bool isRelational() {
    switch (op) {
      case EqFloat64:
      case NeFloat64:
      case LtFloat64:
      case LeFloat64:
      case GtFloat64:
      case GeFloat64:
      case EqInt32:
      case NeInt32:
      case LtSInt32:
      case LtUInt32:
      case LeSInt32:
      case LeUInt32:
      case GtSInt32:
      case GtUInt32:
      case GeSInt32:
      case GeUInt32:
      case EqInt64:
      case NeInt64:
      case LtSInt64:
      case LtUInt64:
      case LeSInt64:
      case LeUInt64:
      case GtSInt64:
      case GtUInt64:
      case GeSInt64:
      case GeUInt64:
      case EqFloat32:
      case NeFloat32:
      case LtFloat32:
      case LeFloat32:
      case GtFloat32:
      case GeFloat32: return true;
      default: return false;
    }
  }

  void finalize() {
    assert(left && right);
    if (isRelational()) {
      type = i32;
    } else {
      type = getReachableWasmType(left->type, right->type);
    }
  }
};

class Select : public SpecificExpression<Expression::SelectId> {
public:
  Select() {}
  Select(MixedArena& allocator) {}

  Expression* ifTrue;
  Expression* ifFalse;
  Expression* condition;

  void finalize() {
    assert(ifTrue && ifFalse);
    type = getReachableWasmType(ifTrue->type, ifFalse->type);
  }
};

class Drop : public SpecificExpression<Expression::DropId> {
public:
  Drop() {}
  Drop(MixedArena& allocator) {}

  Expression* value;
};

class Return : public SpecificExpression<Expression::ReturnId> {
public:
  Return() : value(nullptr) {
    type = unreachable;
  }
  Return(MixedArena& allocator) : Return() {}

  Expression* value;
};

class Host : public SpecificExpression<Expression::HostId> {
public:
  Host(MixedArena& allocator) : operands(allocator) {}

  HostOp op;
  Name nameOperand;
  ExpressionList operands;

  void finalize() {
    switch (op) {
      case PageSize: case CurrentMemory: case HasFeature: {
        type = i32;
        break;
      }
      case GrowMemory: {
        type = i32;
        break;
      }
      default: abort();
    }
  }
};

class Unreachable : public SpecificExpression<Expression::UnreachableId> {
public:
  Unreachable() {
    type = unreachable;
  }
  Unreachable(MixedArena& allocator) : Unreachable() {}
};

// Globals

class Function {
public:
  Name name;
  WasmType result;
  std::vector<WasmType> params; // function locals are
  std::vector<WasmType> vars;   // params plus vars
  Name type; // if null, it is implicit in params and result
  Expression* body;

  // local names. these are optional.
  std::vector<Name> localNames;
  std::map<Name, Index> localIndices;

  // node annotations, printed alongside the node in the text format
  std::unordered_map<Expression*, std::string> annotations;

  Function() : result(none) {}

  size_t getNumParams() {
    return params.size();
  }
  size_t getNumVars() {
    return vars.size();
  }
  size_t getNumLocals() {
    return params.size() + vars.size();
  }

  bool isParam(Index index) {
    return index < params.size();
  }
  bool isVar(Index index) {
    return index >= params.size();
  }

  Name getLocalName(Index index) {
    assert(index < localNames.size() && localNames[index].is());
    return localNames[index];
  }
  Name tryLocalName(Index index) {
    if (index < localNames.size() && localNames[index].is()) {
      return localNames[index];
    }
    // this is an unnamed local
    return Name();
  }
  Index getLocalIndex(Name name) {
    assert(localIndices.count(name) > 0);
    return localIndices[name];
  }
  Index getVarIndexBase() {
    return params.size();
  }
  WasmType getLocalType(Index index) {
    if (isParam(index)) {
      return params[index];
    } else if (isVar(index)) {
      return vars[index - getVarIndexBase()];
    } else {
      WASM_UNREACHABLE();
    }
  }
};

enum class ExternalKind {
  Function = 0,
  Table = 1,
  Memory = 2,
  Global = 3
};

class Import {
public:
  Import() : globalType(none) {}

  Name name, module, base; // name = module.base
  ExternalKind kind;
  Name functionType; // for Function imports
  WasmType globalType; // for Global imports
};

class Export {
public:
  Name name;  // exported name - note that this is the key, as the internal name is non-unique (can have multiple exports for an internal, also over kinds)
  Name value; // internal name
  ExternalKind kind;
};

class Table {
public:
  static const Index kMaxSize = Index(-1);

  struct Segment {
    Expression* offset;
    std::vector<Name> data;
    Segment() {}
    Segment(Expression* offset) : offset(offset) {
    }
    Segment(Expression* offset, std::vector<Name>& init) : offset(offset) {
      data.swap(init);
    }
  };

  // Currently the wasm object always 'has' one Table. It 'exists' if it has been defined or imported.
  // The table can exist but be empty and have no defined initial or max size.
  bool exists;
  bool imported;
  Name name;
  Address initial, max;
  std::vector<Segment> segments;

  Table() : exists(false), imported(false), initial(0), max(kMaxSize) {
    name = Name::fromInt(0);
  }
};

class Memory {
public:
  static const Address::address_t kPageSize = 64 * 1024;
  static const Address::address_t kMaxSize = ~Address::address_t(0) / kPageSize;
  static const Address::address_t kPageMask = ~(kPageSize - 1);

  struct Segment {
    Expression* offset;
    std::vector<char> data; // TODO: optimize
    Segment() {}
    Segment(Expression* offset, const char* init, Address size) : offset(offset) {
      data.resize(size);
      std::copy_n(init, size, data.begin());
    }
    Segment(Expression* offset, std::vector<char>& init) : offset(offset) {
      data.swap(init);
    }
  };

  Name name;
  Address initial, max; // sizes are in pages
  std::vector<Segment> segments;

  // See comment in Table.
  bool exists;
  bool imported;

  Memory() : initial(0), max(kMaxSize), exists(false), imported(false) {
    name = Name::fromInt(0);
  }
};

class Global {
public:
  Name name;
  WasmType type;
  Expression* init;
  bool mutable_;
};

// "Opaque" data, not part of the core wasm spec, that is held in binaries.
// May be parsed/handled by utility code elsewhere, but not in wasm.h
class UserSection {
public:
  std::string name;
  std::vector<char> data;
};

class Module {
public:
  // wasm contents (generally you shouldn't access these from outside, except maybe for iterating; use add*() and the get() functions)
  std::vector<std::unique_ptr<FunctionType>> functionTypes;
  std::vector<std::unique_ptr<Import>> imports;
  std::vector<std::unique_ptr<Export>> exports;
  std::vector<std::unique_ptr<Function>> functions;
  std::vector<std::unique_ptr<Global>> globals;

  Table table;
  Memory memory;
  Name start;

  std::vector<UserSection> userSections;

  MixedArena allocator;

private:
  // TODO: add a build option where Names are just indices, and then these methods are not needed
  std::map<Name, FunctionType*> functionTypesMap;
  std::map<Name, Import*> importsMap;
  std::map<Name, Export*> exportsMap; // exports map is by the *exported* name, which is unique
  std::map<Name, Function*> functionsMap;
  std::map<Name, Global*> globalsMap;

public:
  Module() {};

  FunctionType* getFunctionType(Name name) { assert(functionTypesMap.count(name)); return functionTypesMap[name]; }
  Import* getImport(Name name) { assert(importsMap.count(name)); return importsMap[name]; }
  Export* getExport(Name name) { assert(exportsMap.count(name)); return exportsMap[name]; }
  Function* getFunction(Name name) { assert(functionsMap.count(name)); return functionsMap[name]; }
  Global* getGlobal(Name name) { assert(globalsMap.count(name)); return globalsMap[name]; }

  FunctionType* checkFunctionType(Name name) { if (!functionTypesMap.count(name)) return nullptr; return functionTypesMap[name]; }
  Import* checkImport(Name name) { if (!importsMap.count(name)) return nullptr; return importsMap[name]; }
  Export* checkExport(Name name) { if (!exportsMap.count(name)) return nullptr; return exportsMap[name]; }
  Function* checkFunction(Name name) { if (!functionsMap.count(name)) return nullptr; return functionsMap[name]; }
  Global* checkGlobal(Name name) { if (!globalsMap.count(name)) return nullptr; return globalsMap[name]; }

  void addFunctionType(FunctionType* curr) {
    assert(curr->name.is());
    functionTypes.push_back(std::unique_ptr<FunctionType>(curr));
    assert(functionTypesMap.find(curr->name) == functionTypesMap.end());
    functionTypesMap[curr->name] = curr;
  }
  void addImport(Import* curr) {
    assert(curr->name.is());
    imports.push_back(std::unique_ptr<Import>(curr));
    assert(importsMap.find(curr->name) == importsMap.end());
    importsMap[curr->name] = curr;
  }
  void addExport(Export* curr) {
    assert(curr->name.is());
    exports.push_back(std::unique_ptr<Export>(curr));
    assert(exportsMap.find(curr->name) == exportsMap.end());
    exportsMap[curr->name] = curr;
  }
  void addFunction(Function* curr) {
    assert(curr->name.is());
    functions.push_back(std::unique_ptr<Function>(curr));
    assert(functionsMap.find(curr->name) == functionsMap.end());
    functionsMap[curr->name] = curr;
  }
  void addGlobal(Global* curr) {
    assert(curr->name.is());
    globals.push_back(std::unique_ptr<Global>(curr));
    assert(globalsMap.find(curr->name) == globalsMap.end());
    globalsMap[curr->name] = curr;
  }

  void addStart(const Name& s) {
    start = s;
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
  // TODO: remove* for other elements

  void updateMaps() {
    functionsMap.clear();
    for (auto& curr : functions) {
      functionsMap[curr->name] = curr.get();
    }
    functionTypesMap.clear();
    for (auto& curr : functionTypes) {
      functionTypesMap[curr->name] = curr.get();
    }
    importsMap.clear();
    for (auto& curr : imports) {
      importsMap[curr->name] = curr.get();
    }
    exportsMap.clear();
    for (auto& curr : exports) {
      exportsMap[curr->name] = curr.get();
    }
    globalsMap.clear();
    for (auto& curr : globals) {
      globalsMap[curr->name] = curr.get();
    }
  }
};

} // namespace wasm

namespace std {
template<> struct hash<wasm::Address> {
  size_t operator()(const wasm::Address a) const {
    return std::hash<wasm::Address::address_t>()(a.addr);
  }
};
}

#endif // wasm_wasm_h
