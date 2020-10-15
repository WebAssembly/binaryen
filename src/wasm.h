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
// wasm.h: Define Binaryen IR, a representation for WebAssembly, with
//         all core parts in one simple header file.
//
// For more overview, see README.md
//

#ifndef wasm_wasm_h
#define wasm_wasm_h

#include <algorithm>
#include <array>
#include <cassert>
#include <map>
#include <string>
#include <vector>

#include "literal.h"
#include "mixed_arena.h"
#include "support/name.h"
#include "wasm-features.h"
#include "wasm-type.h"

namespace wasm {

// An index in a wasm module
typedef uint32_t Index;

// An address in linear memory.
struct Address {
  typedef uint32_t address32_t;
  typedef uint64_t address64_t;
  address64_t addr;
  Address() : addr(0) {}
  Address(uint64_t a) : addr(a) {}
  Address& operator=(uint64_t a) {
    addr = a;
    return *this;
  }
  operator address64_t() const { return addr; }
  Address& operator++() {
    ++addr;
    return *this;
  }
};

enum class IRProfile { Normal, Poppy };

// Operators

enum UnaryOp {
  // int
  ClzInt32,
  ClzInt64,
  CtzInt32,
  CtzInt64,
  PopcntInt32,
  PopcntInt64,

  // float
  NegFloat32,
  NegFloat64,
  AbsFloat32,
  AbsFloat64,
  CeilFloat32,
  CeilFloat64,
  FloorFloat32,
  FloorFloat64,
  TruncFloat32,
  TruncFloat64,
  NearestFloat32,
  NearestFloat64,
  SqrtFloat32,
  SqrtFloat64,

  // relational
  EqZInt32,
  EqZInt64,

  // conversions
  // extend i32 to i64
  ExtendSInt32,
  ExtendUInt32,
  // i64 to i32
  WrapInt64,
  // float to int
  TruncSFloat32ToInt32,
  TruncSFloat32ToInt64,
  TruncUFloat32ToInt32,
  TruncUFloat32ToInt64,
  TruncSFloat64ToInt32,
  TruncSFloat64ToInt64,
  TruncUFloat64ToInt32,
  TruncUFloat64ToInt64,
  // reintepret bits to int
  ReinterpretFloat32,
  ReinterpretFloat64,
  // int to float
  ConvertSInt32ToFloat32,
  ConvertSInt32ToFloat64,
  ConvertUInt32ToFloat32,
  ConvertUInt32ToFloat64,
  ConvertSInt64ToFloat32,
  ConvertSInt64ToFloat64,
  ConvertUInt64ToFloat32,
  ConvertUInt64ToFloat64,
  // f32 to f64
  PromoteFloat32,
  // f64 to f32
  DemoteFloat64,
  // reinterpret bits to float
  ReinterpretInt32,
  ReinterpretInt64,

  // Extend signed subword-sized integer. This differs from e.g. ExtendSInt32
  // because the input integer is in an i64 value insetad of an i32 value.
  ExtendS8Int32,
  ExtendS16Int32,
  ExtendS8Int64,
  ExtendS16Int64,
  ExtendS32Int64,

  // Saturating float-to-int
  TruncSatSFloat32ToInt32,
  TruncSatUFloat32ToInt32,
  TruncSatSFloat64ToInt32,
  TruncSatUFloat64ToInt32,
  TruncSatSFloat32ToInt64,
  TruncSatUFloat32ToInt64,
  TruncSatSFloat64ToInt64,
  TruncSatUFloat64ToInt64,

  // SIMD splats
  SplatVecI8x16,
  SplatVecI16x8,
  SplatVecI32x4,
  SplatVecI64x2,
  SplatVecF32x4,
  SplatVecF64x2,

  // SIMD arithmetic
  NotVec128,
  AbsVecI8x16,
  NegVecI8x16,
  AnyTrueVecI8x16,
  AllTrueVecI8x16,
  BitmaskVecI8x16,
  AbsVecI16x8,
  NegVecI16x8,
  AnyTrueVecI16x8,
  AllTrueVecI16x8,
  BitmaskVecI16x8,
  AbsVecI32x4,
  NegVecI32x4,
  AnyTrueVecI32x4,
  AllTrueVecI32x4,
  BitmaskVecI32x4,
  NegVecI64x2,
  AnyTrueVecI64x2,
  AllTrueVecI64x2,
  AbsVecF32x4,
  NegVecF32x4,
  SqrtVecF32x4,
  CeilVecF32x4,
  FloorVecF32x4,
  TruncVecF32x4,
  NearestVecF32x4,
  AbsVecF64x2,
  NegVecF64x2,
  SqrtVecF64x2,
  CeilVecF64x2,
  FloorVecF64x2,
  TruncVecF64x2,
  NearestVecF64x2,

  // SIMD conversions
  TruncSatSVecF32x4ToVecI32x4,
  TruncSatUVecF32x4ToVecI32x4,
  TruncSatSVecF64x2ToVecI64x2,
  TruncSatUVecF64x2ToVecI64x2,
  ConvertSVecI32x4ToVecF32x4,
  ConvertUVecI32x4ToVecF32x4,
  ConvertSVecI64x2ToVecF64x2,
  ConvertUVecI64x2ToVecF64x2,
  WidenLowSVecI8x16ToVecI16x8,
  WidenHighSVecI8x16ToVecI16x8,
  WidenLowUVecI8x16ToVecI16x8,
  WidenHighUVecI8x16ToVecI16x8,
  WidenLowSVecI16x8ToVecI32x4,
  WidenHighSVecI16x8ToVecI32x4,
  WidenLowUVecI16x8ToVecI32x4,
  WidenHighUVecI16x8ToVecI32x4,

  InvalidUnary
};

enum BinaryOp {
  // int or float
  AddInt32,
  SubInt32,
  MulInt32,

  // int
  DivSInt32,
  DivUInt32,
  RemSInt32,
  RemUInt32,
  AndInt32,
  OrInt32,
  XorInt32,
  ShlInt32,
  ShrSInt32,
  ShrUInt32,
  RotLInt32,
  RotRInt32,

  // relational ops
  // int or float
  EqInt32,
  NeInt32,
  // int
  LtSInt32,
  LtUInt32,
  LeSInt32,
  LeUInt32,
  GtSInt32,
  GtUInt32,
  GeSInt32,
  GeUInt32,

  // int or float
  AddInt64,
  SubInt64,
  MulInt64,

  // int
  DivSInt64,
  DivUInt64,
  RemSInt64,
  RemUInt64,
  AndInt64,
  OrInt64,
  XorInt64,
  ShlInt64,
  ShrSInt64,
  ShrUInt64,
  RotLInt64,
  RotRInt64,

  // relational ops
  // int or float
  EqInt64,
  NeInt64,
  // int
  LtSInt64,
  LtUInt64,
  LeSInt64,
  LeUInt64,
  GtSInt64,
  GtUInt64,
  GeSInt64,
  GeUInt64,

  // int or float
  AddFloat32,
  SubFloat32,
  MulFloat32,

  // float
  DivFloat32,
  CopySignFloat32,
  MinFloat32,
  MaxFloat32,

  // relational ops
  // int or float
  EqFloat32,
  NeFloat32,
  // float
  LtFloat32,
  LeFloat32,
  GtFloat32,
  GeFloat32,

  // int or float
  AddFloat64,
  SubFloat64,
  MulFloat64,

  // float
  DivFloat64,
  CopySignFloat64,
  MinFloat64,
  MaxFloat64,

  // relational ops
  // int or float
  EqFloat64,
  NeFloat64,
  // float
  LtFloat64,
  LeFloat64,
  GtFloat64,
  GeFloat64,

  // SIMD relational ops (return vectors)
  EqVecI8x16,
  NeVecI8x16,
  LtSVecI8x16,
  LtUVecI8x16,
  GtSVecI8x16,
  GtUVecI8x16,
  LeSVecI8x16,
  LeUVecI8x16,
  GeSVecI8x16,
  GeUVecI8x16,
  EqVecI16x8,
  NeVecI16x8,
  LtSVecI16x8,
  LtUVecI16x8,
  GtSVecI16x8,
  GtUVecI16x8,
  LeSVecI16x8,
  LeUVecI16x8,
  GeSVecI16x8,
  GeUVecI16x8,
  EqVecI32x4,
  NeVecI32x4,
  LtSVecI32x4,
  LtUVecI32x4,
  GtSVecI32x4,
  GtUVecI32x4,
  LeSVecI32x4,
  LeUVecI32x4,
  GeSVecI32x4,
  GeUVecI32x4,
  EqVecF32x4,
  NeVecF32x4,
  LtVecF32x4,
  GtVecF32x4,
  LeVecF32x4,
  GeVecF32x4,
  EqVecF64x2,
  NeVecF64x2,
  LtVecF64x2,
  GtVecF64x2,
  LeVecF64x2,
  GeVecF64x2,

  // SIMD arithmetic
  AndVec128,
  OrVec128,
  XorVec128,
  AndNotVec128,
  AddVecI8x16,
  AddSatSVecI8x16,
  AddSatUVecI8x16,
  SubVecI8x16,
  SubSatSVecI8x16,
  SubSatUVecI8x16,
  MulVecI8x16,
  MinSVecI8x16,
  MinUVecI8x16,
  MaxSVecI8x16,
  MaxUVecI8x16,
  AvgrUVecI8x16,
  AddVecI16x8,
  AddSatSVecI16x8,
  AddSatUVecI16x8,
  SubVecI16x8,
  SubSatSVecI16x8,
  SubSatUVecI16x8,
  MulVecI16x8,
  MinSVecI16x8,
  MinUVecI16x8,
  MaxSVecI16x8,
  MaxUVecI16x8,
  AvgrUVecI16x8,
  AddVecI32x4,
  SubVecI32x4,
  MulVecI32x4,
  MinSVecI32x4,
  MinUVecI32x4,
  MaxSVecI32x4,
  MaxUVecI32x4,
  DotSVecI16x8ToVecI32x4,
  AddVecI64x2,
  SubVecI64x2,
  MulVecI64x2,
  AddVecF32x4,
  SubVecF32x4,
  MulVecF32x4,
  DivVecF32x4,
  MinVecF32x4,
  MaxVecF32x4,
  PMinVecF32x4,
  PMaxVecF32x4,
  AddVecF64x2,
  SubVecF64x2,
  MulVecF64x2,
  DivVecF64x2,
  MinVecF64x2,
  MaxVecF64x2,
  PMinVecF64x2,
  PMaxVecF64x2,

  // SIMD Conversion
  NarrowSVecI16x8ToVecI8x16,
  NarrowUVecI16x8ToVecI8x16,
  NarrowSVecI32x4ToVecI16x8,
  NarrowUVecI32x4ToVecI16x8,

  // SIMD Swizzle
  SwizzleVec8x16,

  InvalidBinary
};

enum AtomicRMWOp { Add, Sub, And, Or, Xor, Xchg };

enum SIMDExtractOp {
  ExtractLaneSVecI8x16,
  ExtractLaneUVecI8x16,
  ExtractLaneSVecI16x8,
  ExtractLaneUVecI16x8,
  ExtractLaneVecI32x4,
  ExtractLaneVecI64x2,
  ExtractLaneVecF32x4,
  ExtractLaneVecF64x2
};

enum SIMDReplaceOp {
  ReplaceLaneVecI8x16,
  ReplaceLaneVecI16x8,
  ReplaceLaneVecI32x4,
  ReplaceLaneVecI64x2,
  ReplaceLaneVecF32x4,
  ReplaceLaneVecF64x2
};

enum SIMDShiftOp {
  ShlVecI8x16,
  ShrSVecI8x16,
  ShrUVecI8x16,
  ShlVecI16x8,
  ShrSVecI16x8,
  ShrUVecI16x8,
  ShlVecI32x4,
  ShrSVecI32x4,
  ShrUVecI32x4,
  ShlVecI64x2,
  ShrSVecI64x2,
  ShrUVecI64x2
};

enum SIMDLoadOp {
  LoadSplatVec8x16,
  LoadSplatVec16x8,
  LoadSplatVec32x4,
  LoadSplatVec64x2,
  LoadExtSVec8x8ToVecI16x8,
  LoadExtUVec8x8ToVecI16x8,
  LoadExtSVec16x4ToVecI32x4,
  LoadExtUVec16x4ToVecI32x4,
  LoadExtSVec32x2ToVecI64x2,
  LoadExtUVec32x2ToVecI64x2,
  Load32Zero,
  Load64Zero
};

enum SIMDTernaryOp { Bitselect, QFMAF32x4, QFMSF32x4, QFMAF64x2, QFMSF64x2 };

//
// Expressions
//
// Note that little is provided in terms of constructors for these. The
// rationale is that writing  new Something(a, b, c, d, e)  is not the clearest,
// and it would be better to write   new Something(name=a, leftOperand=b...
// etc., but C++ lacks named operands, so in asm2wasm etc. you will see things
// like
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
    CallIndirectId,
    LocalGetId,
    LocalSetId,
    GlobalGetId,
    GlobalSetId,
    LoadId,
    StoreId,
    ConstId,
    UnaryId,
    BinaryId,
    SelectId,
    DropId,
    ReturnId,
    MemorySizeId,
    MemoryGrowId,
    NopId,
    UnreachableId,
    AtomicRMWId,
    AtomicCmpxchgId,
    AtomicWaitId,
    AtomicNotifyId,
    AtomicFenceId,
    SIMDExtractId,
    SIMDReplaceId,
    SIMDShuffleId,
    SIMDTernaryId,
    SIMDShiftId,
    SIMDLoadId,
    MemoryInitId,
    DataDropId,
    MemoryCopyId,
    MemoryFillId,
    PopId,
    RefNullId,
    RefIsNullId,
    RefFuncId,
    RefEqId,
    TryId,
    ThrowId,
    RethrowId,
    BrOnExnId,
    TupleMakeId,
    TupleExtractId,
    I31NewId,
    I31GetId,
    RefTestId,
    RefCastId,
    BrOnCastId,
    RttCanonId,
    RttSubId,
    StructNewId,
    StructGetId,
    StructSetId,
    ArrayNewId,
    ArrayGetId,
    ArraySetId,
    ArrayLenId,
    NumExpressionIds
  };
  Id _id;

  // the type of the expression: its *output*, not necessarily its input(s)
  Type type = Type::none;

  Expression(Id id) : _id(id) {}

  void finalize() {}

  template<class T> bool is() const {
    static_assert(std::is_base_of<Expression, T>::value,
                  "Expression is not a base of destination type T");
    return int(_id) == int(T::SpecificId);
  }

  template<class T> T* dynCast() {
    static_assert(std::is_base_of<Expression, T>::value,
                  "Expression is not a base of destination type T");
    return int(_id) == int(T::SpecificId) ? (T*)this : nullptr;
  }

  template<class T> const T* dynCast() const {
    static_assert(std::is_base_of<Expression, T>::value,
                  "Expression is not a base of destination type T");
    return int(_id) == int(T::SpecificId) ? (const T*)this : nullptr;
  }

  template<class T> T* cast() {
    static_assert(std::is_base_of<Expression, T>::value,
                  "Expression is not a base of destination type T");
    assert(int(_id) == int(T::SpecificId));
    return (T*)this;
  }

  template<class T> const T* cast() const {
    static_assert(std::is_base_of<Expression, T>::value,
                  "Expression is not a base of destination type T");
    assert(int(_id) == int(T::SpecificId));
    return (const T*)this;
  }

  // Print the expression to stderr. Meant for use while debugging.
  void dump();
};

const char* getExpressionName(Expression* curr);

Literal getLiteralFromConstExpression(Expression* curr);
Literals getLiteralsFromConstExpression(Expression* curr);

typedef ArenaVector<Expression*> ExpressionList;

template<Expression::Id SID> class SpecificExpression : public Expression {
public:
  enum {
    SpecificId = SID // compile-time access to the type for the class
  };

  SpecificExpression() : Expression(SID) {}
};

#include "wasm-expressions.generated.h"

// Globals

struct Importable {
  Name name;

  // Explicit names are ones that we read from the input file and
  // will be written the name section in the output file.
  // Implicit names are names that binaryen generated for internal
  // use only and will not be written the name section.
  bool hasExplicitName = false;

  // If these are set, then this is an import, as module.base
  Name module, base;

  bool imported() { return module.is(); }

  void setName(Name name_, bool hasExplicitName_) {
    name = name_;
    hasExplicitName = hasExplicitName_;
  }

  void setExplicitName(Name name_) { setName(name_, true); }
};

class Function;

// Represents an offset into a wasm binary file. This is used for debug info.
// For now, assume this is 32 bits as that's the size limit of wasm files
// anyhow.
using BinaryLocation = uint32_t;

// Represents a mapping of wasm module elements to their location in the
// binary representation. This is used for general debugging info support.
// Offsets are relative to the beginning of the code section, as in DWARF.
struct BinaryLocations {
  struct Span {
    BinaryLocation start = 0, end = 0;
  };

  // Track the range of addresses an expressions appears at. This is the
  // contiguous range that all instructions have - control flow instructions
  // have additional opcodes later (like an end for a block or loop), see
  // just after this.
  std::unordered_map<Expression*, Span> expressions;

  // Track the extra delimiter positions that some instructions, in particular
  // control flow, have, like 'end' for loop and block. We keep these in a
  // separate map because they are rare and we optimize for the storage space
  // for the common type of instruction which just needs a Span. We implement
  // this as a simple struct with two elements (as two extra elements is the
  // maximum currently needed; due to 'catch' and 'end' for try-catch). The
  // second value may be 0, indicating it is not used.
  struct DelimiterLocations : public std::array<BinaryLocation, 2> {
    DelimiterLocations() {
      // Ensure zero-initialization.
      for (auto& item : *this) {
        item = 0;
      }
    }
  };

  enum DelimiterId {
    // All control flow structures have an end, so use index 0 for that.
    End = 0,
    // Use index 1 for all other current things.
    Else = 1,
    Catch = 1,
    Invalid = -1
  };
  std::unordered_map<Expression*, DelimiterLocations> delimiters;

  // DWARF debug info can refer to multiple interesting positions in a function.
  struct FunctionLocations {
    // The very start of the function, where the binary has a size LEB.
    BinaryLocation start = 0;
    // The area where we declare locals, which is right after the size LEB.
    BinaryLocation declarations = 0;
    // The end, which is one past the final "end" instruction byte.
    BinaryLocation end = 0;
  };

  std::unordered_map<Function*, FunctionLocations> functions;
};

// Forward declarations of Stack IR, as functions can contain it, see
// the stackIR property.
// Stack IR is a secondary IR to the main IR defined in this file (Binaryen
// IR). See wasm-stack.h.
class StackInst;

using StackIR = std::vector<StackInst*>;

class Function : public Importable {
public:
  Signature sig; // parameters and return value
  IRProfile profile = IRProfile::Normal;
  std::vector<Type> vars; // non-param locals

  // The body of the function
  Expression* body = nullptr;

  // If present, this stack IR was generated from the main Binaryen IR body,
  // and possibly optimized. If it is present when writing to wasm binary,
  // it will be emitted instead of the main Binaryen IR.
  //
  // Note that no special care is taken to synchronize the two IRs - if you
  // emit stack IR and then optimize the main IR, you need to recompute the
  // stack IR. The Pass system will throw away Stack IR if a pass is run
  // that declares it may modify Binaryen IR.
  std::unique_ptr<StackIR> stackIR;

  // local names. these are optional.
  std::map<Index, Name> localNames;
  std::map<Name, Index> localIndices;

  // Source maps debugging info: map expression nodes to their file, line, col.
  struct DebugLocation {
    BinaryLocation fileIndex, lineNumber, columnNumber;
    bool operator==(const DebugLocation& other) const {
      return fileIndex == other.fileIndex && lineNumber == other.lineNumber &&
             columnNumber == other.columnNumber;
    }
    bool operator!=(const DebugLocation& other) const {
      return !(*this == other);
    }
    bool operator<(const DebugLocation& other) const {
      return fileIndex != other.fileIndex
               ? fileIndex < other.fileIndex
               : lineNumber != other.lineNumber
                   ? lineNumber < other.lineNumber
                   : columnNumber < other.columnNumber;
    }
  };
  std::unordered_map<Expression*, DebugLocation> debugLocations;
  std::set<DebugLocation> prologLocation;
  std::set<DebugLocation> epilogLocation;

  // General debugging info support: track instructions and the function itself.
  std::unordered_map<Expression*, BinaryLocations::Span> expressionLocations;
  std::unordered_map<Expression*, BinaryLocations::DelimiterLocations>
    delimiterLocations;
  BinaryLocations::FunctionLocations funcLocation;

  size_t getNumParams();
  size_t getNumVars();
  size_t getNumLocals();

  bool isParam(Index index);
  bool isVar(Index index);

  Name getLocalName(Index index);
  Index getLocalIndex(Name name);
  Index getVarIndexBase();
  Type getLocalType(Index index);

  Name getLocalNameOrDefault(Index index);
  Name getLocalNameOrGeneric(Index index);

  bool hasLocalName(Index index) const;
  void setLocalName(Index index, Name name);

  void clearNames();
  void clearDebugInfo();
};

// The kind of an import or export.
enum class ExternalKind {
  Function = 0,
  Table = 1,
  Memory = 2,
  Global = 3,
  Event = 4,
  Invalid = -1
};

class Export {
public:
  // exported name - note that this is the key, as the internal name is
  // non-unique (can have multiple exports for an internal, also over kinds)
  Name name;
  Name value; // internal name
  ExternalKind kind;
};

class Table : public Importable {
public:
  static const Address::address32_t kPageSize = 1;
  static const Index kUnlimitedSize = Index(-1);
  // In wasm32/64, the maximum table size is limited by a 32-bit pointer: 4GB
  static const Index kMaxSize = Index(-1);

  struct Segment {
    Expression* offset;
    std::vector<Name> data;
    Segment() = default;
    Segment(Expression* offset) : offset(offset) {}
    Segment(Expression* offset, std::vector<Name>& init) : offset(offset) {
      data.swap(init);
    }
  };

  // Currently the wasm object always 'has' one Table. It 'exists' if it has
  // been defined or imported. The table can exist but be empty and have no
  // defined initial or max size.
  bool exists = false;
  Address initial = 0;
  Address max = kMaxSize;
  std::vector<Segment> segments;

  Table() { name = Name::fromInt(0); }
  bool hasMax() { return max != kUnlimitedSize; }
  void clear() {
    exists = false;
    name = "";
    initial = 0;
    max = kMaxSize;
    segments.clear();
  }
};

class Memory : public Importable {
public:
  static const Address::address32_t kPageSize = 64 * 1024;
  static const Address::address64_t kUnlimitedSize = Address::address64_t(-1);
  // In wasm32, the maximum memory size is limited by a 32-bit pointer: 4GB
  static const Address::address32_t kMaxSize32 =
    (uint64_t(4) * 1024 * 1024 * 1024) / kPageSize;

  struct Segment {
    bool isPassive = false;
    Expression* offset = nullptr;
    std::vector<char> data; // TODO: optimize
    Segment() = default;
    Segment(Expression* offset) : offset(offset) {}
    Segment(Expression* offset, const char* init, Address size)
      : offset(offset) {
      data.resize(size);
      std::copy_n(init, size, data.begin());
    }
    Segment(Expression* offset, std::vector<char>& init) : offset(offset) {
      data.swap(init);
    }
    Segment(bool isPassive, Expression* offset, const char* init, Address size)
      : isPassive(isPassive), offset(offset) {
      data.resize(size);
      std::copy_n(init, size, data.begin());
    }
  };

  bool exists = false;
  Address initial = 0; // sizes are in pages
  Address max = kMaxSize32;
  std::vector<Segment> segments;

  // See comment in Table.
  bool shared = false;
  Type indexType = Type::i32;

  Memory() { name = Name::fromInt(0); }
  bool hasMax() { return max != kUnlimitedSize; }
  bool is64() { return indexType == Type::i64; }
  void clear() {
    exists = false;
    name = "";
    initial = 0;
    max = kMaxSize32;
    segments.clear();
    shared = false;
    indexType = Type::i32;
  }
};

class Global : public Importable {
public:
  Type type;
  Expression* init = nullptr;
  bool mutable_ = false;
};

// Kinds of event attributes.
enum WasmEventAttribute : unsigned { WASM_EVENT_ATTRIBUTE_EXCEPTION = 0x0 };

class Event : public Importable {
public:
  // Kind of event. Currently only WASM_EVENT_ATTRIBUTE_EXCEPTION is possible.
  uint32_t attribute = WASM_EVENT_ATTRIBUTE_EXCEPTION;
  Signature sig;
};

// "Opaque" data, not part of the core wasm spec, that is held in binaries.
// May be parsed/handled by utility code elsewhere, but not in wasm.h
class UserSection {
public:
  std::string name;
  std::vector<char> data;
};

// The optional "dylink" section is used in dynamic linking.
class DylinkSection {
public:
  Index memorySize, memoryAlignment, tableSize, tableAlignment;
  std::vector<Name> neededDynlibs;
};

class Module {
public:
  // wasm contents (generally you shouldn't access these from outside, except
  // maybe for iterating; use add*() and the get() functions)
  std::vector<std::unique_ptr<Export>> exports;
  std::vector<std::unique_ptr<Function>> functions;
  std::vector<std::unique_ptr<Global>> globals;
  std::vector<std::unique_ptr<Event>> events;

  Table table;
  Memory memory;
  Name start;

  std::vector<UserSection> userSections;

  // Optional user section IR representation.
  std::unique_ptr<DylinkSection> dylinkSection;

  // Source maps debug info.
  std::vector<std::string> debugInfoFileNames;

  // `features` are the features allowed to be used in this module and should be
  // respected regardless of the value of`hasFeaturesSection`.
  // `hasFeaturesSection` means we read a features section and will emit one
  // too.
  FeatureSet features = FeatureSet::MVP;
  bool hasFeaturesSection = false;

  // Module name, if specified. Serves a documentary role only.
  Name name;

  MixedArena allocator;

private:
  // TODO: add a build option where Names are just indices, and then these
  // methods are not needed
  // exports map is by the *exported* name, which is unique
  std::map<Name, Export*> exportsMap;
  std::map<Name, Function*> functionsMap;
  std::map<Name, Global*> globalsMap;
  std::map<Name, Event*> eventsMap;

public:
  Module() = default;

  Export* getExport(Name name);
  Function* getFunction(Name name);
  Global* getGlobal(Name name);
  Event* getEvent(Name name);

  Export* getExportOrNull(Name name);
  Function* getFunctionOrNull(Name name);
  Global* getGlobalOrNull(Name name);
  Event* getEventOrNull(Name name);

  Export* addExport(Export* curr);
  Function* addFunction(Function* curr);
  Global* addGlobal(Global* curr);
  Event* addEvent(Event* curr);

  Export* addExport(std::unique_ptr<Export> curr);
  Function* addFunction(std::unique_ptr<Function> curr);
  Global* addGlobal(std::unique_ptr<Global> curr);
  Event* addEvent(std::unique_ptr<Event> curr);

  void addStart(const Name& s);

  void removeExport(Name name);
  void removeFunction(Name name);
  void removeGlobal(Name name);
  void removeEvent(Name name);

  void removeExports(std::function<bool(Export*)> pred);
  void removeFunctions(std::function<bool(Function*)> pred);
  void removeGlobals(std::function<bool(Global*)> pred);
  void removeEvents(std::function<bool(Event*)> pred);

  void updateMaps();

  void clearDebugInfo();
};

} // namespace wasm

namespace std {
template<> struct hash<wasm::Address> {
  size_t operator()(const wasm::Address a) const {
    return std::hash<wasm::Address::address64_t>()(a.addr);
  }
};
} // namespace std

#endif // wasm_wasm_h
