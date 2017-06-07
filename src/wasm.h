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

#include <algorithm>
#include <cassert>
#include <map>
#include <string>
#include <vector>

#include "literal.h"
#include "mixed_arena.h"
#include "support/name.h"
#include "wasm-type.h"

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

  void finalize();
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

  void finalize();
};

class Call : public SpecificExpression<Expression::CallId> {
public:
  Call(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name target;

  void finalize();
};

class CallImport : public SpecificExpression<Expression::CallImportId> {
public:
  CallImport(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name target;

  void finalize();
};

class FunctionType {
public:
  Name name;
  WasmType result;
  std::vector<WasmType> params;

  FunctionType() : result(none) {}

  bool structuralComparison(FunctionType& b);

  bool operator==(FunctionType& b);
  bool operator!=(FunctionType& b);
};

class CallIndirect : public SpecificExpression<Expression::CallIndirectId> {
public:
  CallIndirect(MixedArena& allocator) : operands(allocator) {}

  ExpressionList operands;
  Name fullType;
  Expression* target;

  void finalize();
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

  void finalize();

  Index index;
  Expression* value;

  bool isTee();
  void setTee(bool is);
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

  void finalize();
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

  void finalize();
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

  void finalize();
};

class Const : public SpecificExpression<Expression::ConstId> {
public:
  Const() {}
  Const(MixedArena& allocator) {}

  Literal value;

  Const* set(Literal value_);
};

class Unary : public SpecificExpression<Expression::UnaryId> {
public:
  Unary() {}
  Unary(MixedArena& allocator) {}

  UnaryOp op;
  Expression* value;

  bool isRelational();

  void finalize();
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

  bool isRelational();

  void finalize();
};

class Select : public SpecificExpression<Expression::SelectId> {
public:
  Select() {}
  Select(MixedArena& allocator) {}

  Expression* ifTrue;
  Expression* ifFalse;
  Expression* condition;

  void finalize();
};

class Drop : public SpecificExpression<Expression::DropId> {
public:
  Drop() {}
  Drop(MixedArena& allocator) {}

  Expression* value;

  void finalize();
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

  void finalize();
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

  struct DebugLocation {
    uint32_t fileIndex, lineNumber, columnNumber;
    bool operator==(const DebugLocation& other) const { return fileIndex == other.fileIndex && lineNumber == other.lineNumber && columnNumber == other.columnNumber; }
    bool operator!=(const DebugLocation& other) const { return !(*this == other); }
  };
  std::unordered_map<Expression*, DebugLocation> debugLocations;

  Function() : result(none) {}

  size_t getNumParams();
  size_t getNumVars();
  size_t getNumLocals();

  bool isParam(Index index);
  bool isVar(Index index);

  Name getLocalName(Index index);
  Index getLocalIndex(Name name);
  Index getVarIndexBase();
  WasmType getLocalType(Index index);

  Name getLocalNameOrDefault(Index index);

private:
  bool hasLocalName(Index index) const;
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
  static const Address::address_t kPageSize = 1;
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
  std::vector<std::string> debugInfoFileNames;

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

  FunctionType* getFunctionType(Name name);
  Import* getImport(Name name);
  Export* getExport(Name name);
  Function* getFunction(Name name);
  Global* getGlobal(Name name);

  FunctionType* getFunctionTypeOrNull(Name name);
  Import* getImportOrNull(Name name);
  Export* getExportOrNull(Name name);
  Function* getFunctionOrNull(Name name);
  Global* getGlobalOrNull(Name name);

  void addFunctionType(FunctionType* curr);
  void addImport(Import* curr);
  void addExport(Export* curr);
  void addFunction(Function* curr);
  void addGlobal(Global* curr);

  void addStart(const Name& s);

  void removeImport(Name name);
  void removeExport(Name name);
  // TODO: remove* for other elements

  void updateMaps();
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
