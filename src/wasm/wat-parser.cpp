/*
 * Copyright 2022 WebAssembly Community Group participants
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

#include "wat-parser.h"
#include "ir/names.h"
#include "support/name.h"
#include "wasm-builder.h"
#include "wasm-type.h"
#include "wasm.h"
#include "wat-lexer.h"

// The WebAssembly text format is recursive in the sense that elements may be
// referred to before they are declared. Furthermore, elements may be referred
// to by index or by name. As a result, we need to parse text modules in
// multiple phases.
//
// In the first phase, we find all of the module element declarations and
// record, but do not interpret, the input spans of their corresponding
// definitions. This phase establishes the indices and names of each module
// element so that subsequent phases can look them up.
//
// The second phase parses type definitions to construct the types used in the
// module. This has to be its own phase because we have no way to refer to a
// type before it has been built along with all the other types, unlike for
// other module elements that can be referred to by name before their
// definitions have been parsed.
//
// The third phase further parses and constructs types implicitly defined by
// type uses in functions, blocks, and call_indirect instructions. These
// implicitly defined types may be referred to by index elsewhere.
//
// The fourth phase parses and sets the types of globals, functions, and other
// top-level module elements. These types need to be set before we parse
// instructions because they determine the types of instructions such as
// global.get and ref.func.
//
// The fifth and final phase parses the remaining contents of all module
// elements, including instructions.
//
// Each phase of parsing gets its own context type that is passed to the
// individual parsing functions. There is a parsing function for each element of
// the grammar given in the spec. Parsing functions are templatized so that they
// may be passed the appropriate context type and return the correct result type
// for each phase.

#define CHECK_ERR(val)                                                         \
  if (auto _val = (val); auto err = _val.getErr()) {                           \
    return Err{*err};                                                          \
  }

using namespace std::string_view_literals;

namespace wasm::WATParser {

namespace {

// ============
// Parser Input
// ============

// Wraps a lexer and provides utilities for consuming tokens.
struct ParseInput {
  Lexer lexer;

  explicit ParseInput(std::string_view in) : lexer(in) {}

  ParseInput(std::string_view in, size_t index) : lexer(in) {
    lexer.setIndex(index);
  }

  ParseInput(const ParseInput& other, size_t index) : lexer(other.lexer) {
    lexer.setIndex(index);
  }

  bool empty() { return lexer.empty(); }

  std::optional<Token> peek() {
    if (!empty()) {
      return *lexer;
    }
    return {};
  }

  bool takeLParen() {
    auto t = peek();
    if (!t || !t->isLParen()) {
      return false;
    }
    ++lexer;
    return true;
  }

  bool takeRParen() {
    auto t = peek();
    if (!t || !t->isRParen()) {
      return false;
    }
    ++lexer;
    return true;
  }

  bool takeUntilParen() {
    while (true) {
      auto t = peek();
      if (!t) {
        return false;
      }
      if (t->isLParen() || t->isRParen()) {
        return true;
      }
      ++lexer;
    }
  }

  std::optional<Name> takeID() {
    if (auto t = peek()) {
      if (auto id = t->getID()) {
        ++lexer;
        // See comment on takeName.
        return Name(std::string(*id));
      }
    }
    return {};
  }

  std::optional<std::string_view> takeKeyword() {
    if (auto t = peek()) {
      if (auto keyword = t->getKeyword()) {
        ++lexer;
        return *keyword;
      }
    }
    return {};
  }

  bool takeKeyword(std::string_view expected) {
    if (auto t = peek()) {
      if (auto keyword = t->getKeyword()) {
        if (*keyword == expected) {
          ++lexer;
          return true;
        }
      }
    }
    return false;
  }

  std::optional<uint64_t> takeOffset() {
    if (auto t = peek()) {
      if (auto keyword = t->getKeyword()) {
        if (keyword->substr(0, 7) != "offset="sv) {
          return {};
        }
        Lexer subLexer(keyword->substr(7));
        if (subLexer == subLexer.end()) {
          return {};
        }
        if (auto o = subLexer->getU64()) {
          ++subLexer;
          if (subLexer == subLexer.end()) {
            ++lexer;
            return o;
          }
        }
      }
    }
    return std::nullopt;
  }

  std::optional<uint32_t> takeAlign() {
    if (auto t = peek()) {
      if (auto keyword = t->getKeyword()) {
        if (keyword->substr(0, 6) != "align="sv) {
          return {};
        }
        Lexer subLexer(keyword->substr(6));
        if (subLexer == subLexer.end()) {
          return {};
        }
        if (auto a = subLexer->getU32()) {
          ++subLexer;
          if (subLexer == subLexer.end()) {
            ++lexer;
            return a;
          }
        }
      }
    }
    return {};
  }

  std::optional<uint64_t> takeU64() {
    if (auto t = peek()) {
      if (auto n = t->getU64()) {
        ++lexer;
        return n;
      }
    }
    return std::nullopt;
  }

  std::optional<int64_t> takeS64() {
    if (auto t = peek()) {
      if (auto n = t->getS64()) {
        ++lexer;
        return n;
      }
    }
    return {};
  }

  std::optional<int64_t> takeI64() {
    if (auto t = peek()) {
      if (auto n = t->getI64()) {
        ++lexer;
        return n;
      }
    }
    return {};
  }

  std::optional<uint32_t> takeU32() {
    if (auto t = peek()) {
      if (auto n = t->getU32()) {
        ++lexer;
        return n;
      }
    }
    return std::nullopt;
  }

  std::optional<int32_t> takeS32() {
    if (auto t = peek()) {
      if (auto n = t->getS32()) {
        ++lexer;
        return n;
      }
    }
    return {};
  }

  std::optional<int32_t> takeI32() {
    if (auto t = peek()) {
      if (auto n = t->getI32()) {
        ++lexer;
        return n;
      }
    }
    return {};
  }

  std::optional<uint8_t> takeU8() {
    if (auto t = peek()) {
      if (auto n = t->getU32()) {
        if (n <= std::numeric_limits<uint8_t>::max()) {
          ++lexer;
          return uint8_t(*n);
        }
      }
    }
    return {};
  }

  std::optional<double> takeF64() {
    if (auto t = peek()) {
      if (auto d = t->getF64()) {
        ++lexer;
        return d;
      }
    }
    return std::nullopt;
  }

  std::optional<float> takeF32() {
    if (auto t = peek()) {
      if (auto f = t->getF32()) {
        ++lexer;
        return f;
      }
    }
    return std::nullopt;
  }

  std::optional<std::string_view> takeString() {
    if (auto t = peek()) {
      if (auto s = t->getString()) {
        ++lexer;
        return s;
      }
    }
    return {};
  }

  std::optional<Name> takeName() {
    // TODO: Move this to lexer and validate UTF.
    if (auto str = takeString()) {
      // Copy to a std::string to make sure we have a null terminator, otherwise
      // the `Name` constructor won't work correctly.
      // TODO: Update `Name` to use string_view instead of char* and/or to take
      // rvalue strings to avoid this extra copy.
      return Name(std::string(*str));
    }
    return {};
  }

  bool takeSExprStart(std::string_view expected) {
    auto original = lexer;
    if (takeLParen() && takeKeyword(expected)) {
      return true;
    }
    lexer = original;
    return false;
  }

  Index getPos() {
    if (auto t = peek()) {
      return lexer.getIndex() - t->span.size();
    }
    return lexer.getIndex();
  }

  [[nodiscard]] Err err(Index pos, std::string reason) {
    std::stringstream msg;
    msg << lexer.position(pos) << ": error: " << reason;
    return Err{msg.str()};
  }

  [[nodiscard]] Err err(std::string reason) { return err(getPos(), reason); }
};

// =========
// Utilities
// =========

// The location, possible name, and index in the respective module index space
// of a module-level definition in the input.
struct DefPos {
  Name name;
  Index pos;
  Index index;
};

struct GlobalType {
  Mutability mutability;
  Type type;
};

// A signature type and parameter names (possibly empty), used for parsing
// function types.
struct TypeUse {
  HeapType type;
  std::vector<Name> names;
};

struct ImportNames {
  Name mod;
  Name nm;
};

struct Limits {
  uint64_t initial;
  uint64_t max;
};

struct MemType {
  Type type;
  Limits limits;
  bool shared;
};

struct Memarg {
  uint64_t offset;
  uint32_t align;
};

// RAII utility for temporarily changing the parsing position of a parsing
// context.
template<typename Ctx> struct WithPosition {
  Ctx& ctx;
  Index original;

  WithPosition(Ctx& ctx, Index pos) : ctx(ctx), original(ctx.in.getPos()) {
    ctx.in.lexer.setIndex(pos);
  }

  ~WithPosition() { ctx.in.lexer.setIndex(original); }
};

// Deduction guide to satisfy -Wctad-maybe-unsupported.
template<typename Ctx> WithPosition(Ctx& ctx, Index) -> WithPosition<Ctx>;

using IndexMap = std::unordered_map<Name, Index>;

void applyImportNames(Importable& item, ImportNames* names) {
  if (names) {
    item.module = names->mod;
    item.base = names->nm;
  }
}

Result<> addExports(ParseInput& in,
                    Module& wasm,
                    const Named* item,
                    const std::vector<Name>& exports,
                    ExternalKind kind) {
  for (auto name : exports) {
    if (wasm.getExportOrNull(name)) {
      // TODO: Fix error location
      return in.err("repeated export name");
    }
    wasm.addExport(Builder(wasm).makeExport(name, item->name, kind));
  }
  return Ok{};
}

Result<IndexMap> createIndexMap(ParseInput& in,
                                const std::vector<DefPos>& defs) {
  IndexMap indices;
  for (auto& def : defs) {
    if (def.name.is()) {
      if (!indices.insert({def.name, def.index}).second) {
        return in.err(def.pos, "duplicate element name");
      }
    }
  }
  return indices;
}

std::vector<Type> getUnnamedTypes(const std::vector<NameType>& named) {
  std::vector<Type> types;
  types.reserve(named.size());
  for (auto& t : named) {
    types.push_back(t.type);
  }
  return types;
}

template<typename Ctx>
Result<> parseDefs(Ctx& ctx,
                   const std::vector<DefPos>& defs,
                   MaybeResult<> (*parser)(Ctx&)) {
  for (auto& def : defs) {
    ctx.index = def.index;
    WithPosition with(ctx, def.pos);
    auto parsed = parser(ctx);
    CHECK_ERR(parsed);
    assert(parsed);
  }
  return Ok{};
}

// ===============
// Parser Contexts
// ===============

struct NullTypeParserCtx {
  using IndexT = Ok;
  using HeapTypeT = Ok;
  using TypeT = Ok;
  using ParamsT = Ok;
  using ResultsT = size_t;
  using BlockTypeT = Ok;
  using SignatureT = Ok;
  using StorageT = Ok;
  using FieldT = Ok;
  using FieldsT = Ok;
  using StructT = Ok;
  using ArrayT = Ok;
  using LimitsT = Ok;
  using MemTypeT = Ok;
  using GlobalTypeT = Ok;
  using TypeUseT = Ok;
  using LocalsT = Ok;
  using DataStringT = Ok;

  HeapTypeT makeFunc() { return Ok{}; }
  HeapTypeT makeAny() { return Ok{}; }
  HeapTypeT makeExtern() { return Ok{}; }
  HeapTypeT makeEq() { return Ok{}; }
  HeapTypeT makeI31() { return Ok{}; }
  HeapTypeT makeStructType() { return Ok{}; }
  HeapTypeT makeArrayType() { return Ok{}; }

  TypeT makeI32() { return Ok{}; }
  TypeT makeI64() { return Ok{}; }
  TypeT makeF32() { return Ok{}; }
  TypeT makeF64() { return Ok{}; }
  TypeT makeV128() { return Ok{}; }

  TypeT makeRefType(HeapTypeT, Nullability) { return Ok{}; }

  ParamsT makeParams() { return Ok{}; }
  void appendParam(ParamsT&, Name, TypeT) {}

  // We have to count results because whether or not a block introduces a
  // typeuse that may implicitly define a type depends on how many results it
  // has.
  size_t makeResults() { return 0; }
  void appendResult(size_t& results, TypeT) { ++results; }
  size_t getResultsSize(size_t results) { return results; }

  SignatureT makeFuncType(ParamsT*, ResultsT*) { return Ok{}; }

  StorageT makeI8() { return Ok{}; }
  StorageT makeI16() { return Ok{}; }
  StorageT makeStorageType(TypeT) { return Ok{}; }

  FieldT makeFieldType(StorageT, Mutability) { return Ok{}; }

  FieldsT makeFields() { return Ok{}; }
  void appendField(FieldsT&, Name, FieldT) {}

  StructT makeStruct(FieldsT&) { return Ok{}; }

  std::optional<ArrayT> makeArray(FieldsT&) { return Ok{}; }

  GlobalTypeT makeGlobalType(Mutability, TypeT) { return Ok{}; }

  LocalsT makeLocals() { return Ok{}; }
  void appendLocal(LocalsT&, Name, TypeT) {}

  Result<Index> getTypeIndex(Name) { return 1; }
  Result<HeapTypeT> getHeapTypeFromIdx(Index) { return Ok{}; }

  DataStringT makeDataString() { return Ok{}; }
  void appendDataString(DataStringT&, std::string_view) {}

  MemTypeT makeMemType(Type, LimitsT, bool) { return Ok{}; }

  BlockTypeT getBlockTypeFromResult(size_t results) { return Ok{}; }

  Result<> getBlockTypeFromTypeUse(Index, TypeUseT) { return Ok{}; }
};

template<typename Ctx> struct TypeParserCtx {
  using IndexT = Index;
  using HeapTypeT = HeapType;
  using TypeT = Type;
  using ParamsT = std::vector<NameType>;
  using ResultsT = std::vector<Type>;
  using BlockTypeT = HeapType;
  using SignatureT = Signature;
  using StorageT = Field;
  using FieldT = Field;
  using FieldsT = std::pair<std::vector<Name>, std::vector<Field>>;
  using StructT = std::pair<std::vector<Name>, Struct>;
  using ArrayT = Array;
  using LimitsT = Ok;
  using MemTypeT = Ok;
  using LocalsT = std::vector<NameType>;
  using DataStringT = Ok;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;

  TypeParserCtx(const IndexMap& typeIndices) : typeIndices(typeIndices) {}

  Ctx& self() { return *static_cast<Ctx*>(this); }

  HeapTypeT makeFunc() { return HeapType::func; }
  HeapTypeT makeAny() { return HeapType::any; }
  HeapTypeT makeExtern() { return HeapType::ext; }
  HeapTypeT makeEq() { return HeapType::eq; }
  HeapTypeT makeI31() { return HeapType::i31; }
  HeapTypeT makeStructType() { return HeapType::struct_; }
  HeapTypeT makeArrayType() { return HeapType::array; }

  TypeT makeI32() { return Type::i32; }
  TypeT makeI64() { return Type::i64; }
  TypeT makeF32() { return Type::f32; }
  TypeT makeF64() { return Type::f64; }
  TypeT makeV128() { return Type::v128; }

  TypeT makeRefType(HeapTypeT ht, Nullability nullability) {
    return Type(ht, nullability);
  }

  TypeT makeTupleType(const std::vector<Type> types) { return Tuple(types); }

  ParamsT makeParams() { return {}; }
  void appendParam(ParamsT& params, Name id, TypeT type) {
    params.push_back({id, type});
  }

  ResultsT makeResults() { return {}; }
  void appendResult(ResultsT& results, TypeT type) { results.push_back(type); }
  size_t getResultsSize(const ResultsT& results) { return results.size(); }

  SignatureT makeFuncType(ParamsT* params, ResultsT* results) {
    std::vector<Type> empty;
    const auto& paramTypes = params ? getUnnamedTypes(*params) : empty;
    const auto& resultTypes = results ? *results : empty;
    return Signature(self().makeTupleType(paramTypes),
                     self().makeTupleType(resultTypes));
  }

  StorageT makeI8() { return Field(Field::i8, Immutable); }
  StorageT makeI16() { return Field(Field::i16, Immutable); }
  StorageT makeStorageType(TypeT type) { return Field(type, Immutable); }

  FieldT makeFieldType(FieldT field, Mutability mutability) {
    if (field.packedType == Field::not_packed) {
      return Field(field.type, mutability);
    }
    return Field(field.packedType, mutability);
  }

  FieldsT makeFields() { return {}; }
  void appendField(FieldsT& fields, Name name, FieldT field) {
    fields.first.push_back(name);
    fields.second.push_back(field);
  }

  StructT makeStruct(FieldsT& fields) {
    return {std::move(fields.first), Struct(std::move(fields.second))};
  }

  std::optional<ArrayT> makeArray(FieldsT& fields) {
    if (fields.second.size() == 1) {
      return Array(fields.second[0]);
    }
    return {};
  }

  LocalsT makeLocals() { return {}; }
  void appendLocal(LocalsT& locals, Name id, TypeT type) {
    locals.push_back({id, type});
  }

  Result<Index> getTypeIndex(Name id) {
    auto it = typeIndices.find(id);
    if (it == typeIndices.end()) {
      return self().in.err("unknown type identifier");
    }
    return it->second;
  }

  DataStringT makeDataString() { return Ok{}; }
  void appendDataString(DataStringT&, std::string_view) {}

  LimitsT makeLimits(uint64_t, std::optional<uint64_t>) { return Ok{}; }
  LimitsT getLimitsFromData(DataStringT) { return Ok{}; }

  MemTypeT makeMemType(Type, LimitsT, bool) { return Ok{}; }

  HeapType getBlockTypeFromResult(const std::vector<Type> results) {
    assert(results.size() == 1);
    return HeapType(Signature(Type::none, results[0]));
  }
};

struct NullInstrParserCtx {
  using InstrT = Ok;
  using InstrsT = Ok;
  using ExprT = Ok;

  using FieldIdxT = Ok;
  using LocalIdxT = Ok;
  using GlobalIdxT = Ok;
  using MemoryIdxT = Ok;
  using DataIdxT = Ok;

  using MemargT = Ok;

  InstrsT makeInstrs() { return Ok{}; }
  void appendInstr(InstrsT&, InstrT) {}
  InstrsT finishInstrs(InstrsT&) { return Ok{}; }

  ExprT makeExpr(InstrsT) { return Ok{}; }
  ExprT instrToExpr(InstrT) { return Ok{}; }

  template<typename HeapTypeT> FieldIdxT getFieldFromIdx(HeapTypeT, uint32_t) {
    return Ok{};
  }
  template<typename HeapTypeT> FieldIdxT getFieldFromName(HeapTypeT, Name) {
    return Ok{};
  }
  LocalIdxT getLocalFromIdx(uint32_t) { return Ok{}; }
  LocalIdxT getLocalFromName(Name) { return Ok{}; }
  GlobalIdxT getGlobalFromIdx(uint32_t) { return Ok{}; }
  GlobalIdxT getGlobalFromName(Name) { return Ok{}; }
  MemoryIdxT getMemoryFromIdx(uint32_t) { return Ok{}; }
  MemoryIdxT getMemoryFromName(Name) { return Ok{}; }
  DataIdxT getDataFromIdx(uint32_t) { return Ok{}; }
  DataIdxT getDataFromName(Name) { return Ok{}; }

  MemargT getMemarg(uint64_t, uint32_t) { return Ok{}; }

  template<typename BlockTypeT>
  InstrT makeBlock(Index, std::optional<Name>, BlockTypeT, InstrsT) {
    return Ok{};
  }
  InstrT makeUnreachable(Index) { return Ok{}; }
  InstrT makeNop(Index) { return Ok{}; }
  InstrT makeBinary(Index, BinaryOp) { return Ok{}; }
  InstrT makeUnary(Index, UnaryOp) { return Ok{}; }
  template<typename ResultsT> InstrT makeSelect(Index, ResultsT*) {
    return Ok{};
  }
  InstrT makeDrop(Index) { return Ok{}; }
  InstrT makeMemorySize(Index, MemoryIdxT*) { return Ok{}; }
  InstrT makeMemoryGrow(Index, MemoryIdxT*) { return Ok{}; }
  InstrT makeLocalGet(Index, LocalIdxT) { return Ok{}; }
  InstrT makeLocalTee(Index, LocalIdxT) { return Ok{}; }
  InstrT makeLocalSet(Index, LocalIdxT) { return Ok{}; }
  InstrT makeGlobalGet(Index, GlobalIdxT) { return Ok{}; }
  InstrT makeGlobalSet(Index, GlobalIdxT) { return Ok{}; }

  InstrT makeI32Const(Index, uint32_t) { return Ok{}; }
  InstrT makeI64Const(Index, uint64_t) { return Ok{}; }
  InstrT makeF32Const(Index, float) { return Ok{}; }
  InstrT makeF64Const(Index, double) { return Ok{}; }
  InstrT makeLoad(Index, Type, bool, int, bool, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  InstrT makeStore(Index, Type, int, bool, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  InstrT makeAtomicRMW(Index, AtomicRMWOp, Type, int, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  InstrT makeAtomicCmpxchg(Index, Type, int, MemoryIdxT*, MemargT) {
    return Ok{};
  }
  InstrT makeAtomicWait(Index, Type, MemoryIdxT*, MemargT) { return Ok{}; }
  InstrT makeAtomicNotify(Index, MemoryIdxT*, MemargT) { return Ok{}; }
  InstrT makeAtomicFence(Index) { return Ok{}; }
  InstrT makeSIMDExtract(Index, SIMDExtractOp, uint8_t) { return Ok{}; }
  InstrT makeSIMDReplace(Index, SIMDReplaceOp, uint8_t) { return Ok{}; }
  InstrT makeSIMDShuffle(Index, const std::array<uint8_t, 16>&) { return Ok{}; }
  InstrT makeSIMDTernary(Index, SIMDTernaryOp) { return Ok{}; }
  InstrT makeSIMDShift(Index, SIMDShiftOp) { return Ok{}; }
  InstrT makeSIMDLoad(Index, SIMDLoadOp, MemoryIdxT*, MemargT) { return Ok{}; }
  InstrT makeSIMDLoadStoreLane(
    Index, SIMDLoadStoreLaneOp, MemoryIdxT*, MemargT, uint8_t) {
    return Ok{};
  }
  InstrT makeMemoryInit(Index, MemoryIdxT*, DataIdxT) { return Ok{}; }
  InstrT makeDataDrop(Index, DataIdxT) { return Ok{}; }

  InstrT makeMemoryCopy(Index, MemoryIdxT*, MemoryIdxT*) { return Ok{}; }
  InstrT makeMemoryFill(Index, MemoryIdxT*) { return Ok{}; }

  InstrT makeReturn(Index) { return Ok{}; }
  template<typename HeapTypeT> InstrT makeRefNull(Index, HeapTypeT) {
    return Ok{};
  }
  InstrT makeRefIsNull(Index) { return Ok{}; }

  InstrT makeRefEq(Index) { return Ok{}; }

  InstrT makeI31New(Index) { return Ok{}; }
  InstrT makeI31Get(Index, bool) { return Ok{}; }

  template<typename HeapTypeT> InstrT makeStructNew(Index, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT> InstrT makeStructNewDefault(Index, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT>
  InstrT makeStructGet(Index, HeapTypeT, FieldIdxT, bool) {
    return Ok{};
  }
  template<typename HeapTypeT>
  InstrT makeStructSet(Index, HeapTypeT, FieldIdxT) {
    return Ok{};
  }
  template<typename HeapTypeT> InstrT makeArrayNew(Index, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT> InstrT makeArrayNewDefault(Index, HeapTypeT) {
    return Ok{};
  }
  template<typename HeapTypeT>
  InstrT makeArrayNewData(Index, HeapTypeT, DataIdxT) {
    return Ok{};
  }
  template<typename HeapTypeT> InstrT makeArrayGet(Index, HeapTypeT, bool) {
    return Ok{};
  }
  template<typename HeapTypeT> InstrT makeArraySet(Index, HeapTypeT) {
    return Ok{};
  }
  InstrT makeArrayLen(Index) { return Ok{}; }
  template<typename HeapTypeT>
  InstrT makeArrayCopy(Index, HeapTypeT, HeapTypeT) {
    return Ok{};
  }
};

// Phase 1: Parse definition spans for top-level module elements and determine
// their indices and names.
struct ParseDeclsCtx : NullTypeParserCtx, NullInstrParserCtx {
  using DataStringT = std::vector<char>;
  using LimitsT = Limits;
  using MemTypeT = MemType;

  ParseInput in;

  // At this stage we only look at types to find implicit type definitions,
  // which are inserted directly into the context. We cannot materialize or
  // validate any types because we don't know what types exist yet.
  //
  // Declared module elements are inserted into the module, but their bodies are
  // not filled out until later parsing phases.
  Module& wasm;

  // The module element definitions we are parsing in this phase.
  std::vector<DefPos> typeDefs;
  std::vector<DefPos> subtypeDefs;
  std::vector<DefPos> funcDefs;
  std::vector<DefPos> memoryDefs;
  std::vector<DefPos> globalDefs;
  std::vector<DefPos> dataDefs;

  // Positions of typeuses that might implicitly define new types.
  std::vector<Index> implicitTypeDefs;

  // Counters used for generating names for module elements.
  int funcCounter = 0;
  int memoryCounter = 0;
  int globalCounter = 0;
  int dataCounter = 0;

  // Used to verify that all imports come before all non-imports.
  bool hasNonImport = false;

  ParseDeclsCtx(std::string_view in, Module& wasm) : in(in), wasm(wasm) {}

  void addFuncType(SignatureT) {}
  void addStructType(StructT) {}
  void addArrayType(ArrayT) {}
  Result<> addSubtype(Index) { return Ok{}; }
  void finishSubtype(Name name, Index pos) {
    subtypeDefs.push_back({name, pos, Index(subtypeDefs.size())});
  }
  size_t getRecGroupStartIndex() { return 0; }
  void addRecGroup(Index, size_t) {}
  void finishDeftype(Index pos) {
    typeDefs.push_back({{}, pos, Index(typeDefs.size())});
  }

  std::vector<char> makeDataString() { return {}; }
  void appendDataString(std::vector<char>& data, std::string_view str) {
    data.insert(data.end(), str.begin(), str.end());
  }

  Limits makeLimits(uint64_t n, std::optional<uint64_t> m) {
    return m ? Limits{n, *m} : Limits{n, Memory::kUnlimitedSize};
  }
  Limits getLimitsFromData(const std::vector<char>& data) {
    uint64_t size = (data.size() + Memory::kPageSize - 1) / Memory::kPageSize;
    return {size, size};
  }

  MemType makeMemType(Type type, Limits limits, bool shared) {
    return {type, limits, shared};
  }

  Result<TypeUseT>
  makeTypeUse(Index pos, std::optional<HeapTypeT> type, ParamsT*, ResultsT*) {
    if (!type) {
      implicitTypeDefs.push_back(pos);
    }
    return Ok{};
  }

  Result<Function*>
  addFuncDecl(Index pos, Name name, ImportNames* importNames) {
    auto f = std::make_unique<Function>();
    if (name.is()) {
      if (wasm.getFunctionOrNull(name)) {
        // TDOO: if the existing function is not explicitly named, fix its name
        // and continue.
        return in.err(pos, "repeated function name");
      }
      f->setExplicitName(name);
    } else {
      name = (importNames ? "fimport$" : "") + std::to_string(funcCounter++);
      name = Names::getValidFunctionName(wasm, name);
      f->name = name;
    }
    applyImportNames(*f, importNames);
    return wasm.addFunction(std::move(f));
  }

  Result<> addFunc(Name name,
                   const std::vector<Name>& exports,
                   ImportNames* import,
                   TypeUseT type,
                   std::optional<LocalsT>,
                   std::optional<InstrsT>,
                   Index pos) {
    if (import && hasNonImport) {
      return in.err(pos, "import after non-import");
    }
    auto f = addFuncDecl(pos, name, import);
    CHECK_ERR(f);
    CHECK_ERR(addExports(in, wasm, *f, exports, ExternalKind::Function));
    funcDefs.push_back({name, pos, Index(funcDefs.size())});
    return Ok{};
  }

  Result<Memory*>
  addMemoryDecl(Index pos, Name name, ImportNames* importNames, MemType type) {
    auto m = std::make_unique<Memory>();
    m->indexType = type.type;
    m->initial = type.limits.initial;
    m->max = type.limits.max;
    m->shared = type.shared;
    if (name) {
      // TODO: if the existing memory is not explicitly named, fix its name
      // and continue.
      if (wasm.getMemoryOrNull(name)) {
        return in.err(pos, "repeated memory name");
      }
      m->setExplicitName(name);
    } else {
      name = (importNames ? "mimport$" : "") + std::to_string(memoryCounter++);
      name = Names::getValidMemoryName(wasm, name);
      m->name = name;
    }
    applyImportNames(*m, importNames);
    return wasm.addMemory(std::move(m));
  }

  Result<> addMemory(Name name,
                     const std::vector<Name>& exports,
                     ImportNames* import,
                     MemType type,
                     Index pos) {
    if (import && hasNonImport) {
      return in.err(pos, "import after non-import");
    }
    auto m = addMemoryDecl(pos, name, import, type);
    CHECK_ERR(m);
    CHECK_ERR(addExports(in, wasm, *m, exports, ExternalKind::Memory));
    memoryDefs.push_back({name, pos, Index(memoryDefs.size())});
    return Ok{};
  }

  Result<> addImplicitData(DataStringT&& data) {
    auto& mem = *wasm.memories.back();
    auto d = std::make_unique<DataSegment>();
    d->memory = mem.name;
    d->isPassive = false;
    d->offset = Builder(wasm).makeConstPtr(0, mem.indexType);
    d->data = std::move(data);
    d->name = Names::getValidDataSegmentName(wasm, "implicit-data");
    wasm.addDataSegment(std::move(d));
    return Ok{};
  }

  Result<Global*>
  addGlobalDecl(Index pos, Name name, ImportNames* importNames) {
    auto g = std::make_unique<Global>();
    if (name) {
      if (wasm.getGlobalOrNull(name)) {
        // TODO: if the existing global is not explicitly named, fix its name
        // and continue.
        return in.err(pos, "repeated global name");
      }
      g->setExplicitName(name);
    } else {
      name = (importNames ? "gimport$" : "") + std::to_string(globalCounter++);
      name = Names::getValidGlobalName(wasm, name);
      g->name = name;
    }
    applyImportNames(*g, importNames);
    return wasm.addGlobal(std::move(g));
  }

  Result<> addGlobal(Name name,
                     const std::vector<Name>& exports,
                     ImportNames* import,
                     GlobalTypeT,
                     std::optional<ExprT>,
                     Index pos) {
    if (import && hasNonImport) {
      return in.err(pos, "import after non-import");
    }
    auto g = addGlobalDecl(pos, name, import);
    CHECK_ERR(g);
    CHECK_ERR(addExports(in, wasm, *g, exports, ExternalKind::Global));
    globalDefs.push_back({name, pos, Index(globalDefs.size())});
    return Ok{};
  }

  Result<> addData(Name name,
                   MemoryIdxT*,
                   std::optional<ExprT>,
                   std::vector<char>&& data,
                   Index pos) {
    auto d = std::make_unique<DataSegment>();
    if (name) {
      if (wasm.getDataSegmentOrNull(name)) {
        // TODO: if the existing segment is not explicitly named, fix its name
        // and continue.
        return in.err(pos, "repeated data segment name");
      }
      d->setExplicitName(name);
    } else {
      name = std::to_string(dataCounter++);
      name = Names::getValidDataSegmentName(wasm, name);
      d->name = name;
    }
    d->data = std::move(data);
    dataDefs.push_back({name, pos, Index(wasm.dataSegments.size())});
    wasm.addDataSegment(std::move(d));
    return Ok{};
  }
};

// Phase 2: Parse type definitions into a TypeBuilder.
struct ParseTypeDefsCtx : TypeParserCtx<ParseTypeDefsCtx> {
  ParseInput in;

  // We update slots in this builder as we parse type definitions.
  TypeBuilder& builder;

  // Parse the names of types and fields as we go.
  std::vector<TypeNames> names;

  // The index of the subtype definition we are parsing.
  Index index = 0;

  ParseTypeDefsCtx(std::string_view in,
                   TypeBuilder& builder,
                   const IndexMap& typeIndices)
    : TypeParserCtx<ParseTypeDefsCtx>(typeIndices), in(in), builder(builder),
      names(builder.size()) {}

  TypeT makeRefType(HeapTypeT ht, Nullability nullability) {
    return builder.getTempRefType(ht, nullability);
  }

  TypeT makeTupleType(const std::vector<Type> types) {
    return builder.getTempTupleType(types);
  }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx) {
    if (idx >= builder.size()) {
      return in.err("type index out of bounds");
    }
    return builder[idx];
  }

  void addFuncType(SignatureT& type) { builder[index] = type; }

  void addStructType(StructT& type) {
    auto& [fieldNames, str] = type;
    builder[index] = str;
    for (Index i = 0; i < fieldNames.size(); ++i) {
      if (auto name = fieldNames[i]; name.is()) {
        names[index].fieldNames[i] = name;
      }
    }
  }

  void addArrayType(ArrayT& type) { builder[index] = type; }

  Result<> addSubtype(Index super) {
    if (super >= builder.size()) {
      return in.err("supertype index out of bounds");
    }
    builder[index].subTypeOf(builder[super]);
    return Ok{};
  }

  void finishSubtype(Name name, Index pos) { names[index++].name = name; }

  size_t getRecGroupStartIndex() { return index; }

  void addRecGroup(Index start, size_t len) {
    builder.createRecGroup(start, len);
  }

  void finishDeftype(Index) {}
};

// Phase 3: Parse type uses to find implicitly defined types.
struct ParseImplicitTypeDefsCtx : TypeParserCtx<ParseImplicitTypeDefsCtx> {
  using TypeUseT = Ok;

  ParseInput in;

  // Types parsed so far.
  std::vector<HeapType>& types;

  // Map typeuse positions without an explicit type to the correct type.
  std::unordered_map<Index, HeapType>& implicitTypes;

  // Map signatures to the first defined heap type they match.
  std::unordered_map<Signature, HeapType> sigTypes;

  ParseImplicitTypeDefsCtx(std::string_view in,
                           std::vector<HeapType>& types,
                           std::unordered_map<Index, HeapType>& implicitTypes,
                           const IndexMap& typeIndices)
    : TypeParserCtx<ParseImplicitTypeDefsCtx>(typeIndices), in(in),
      types(types), implicitTypes(implicitTypes) {
    for (auto type : types) {
      if (type.isSignature() && type.getRecGroup().size() == 1) {
        sigTypes.insert({type.getSignature(), type});
      }
    }
  }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT>,
                               ParamsT* params,
                               ResultsT* results) {
    std::vector<Type> paramTypes;
    if (params) {
      paramTypes = getUnnamedTypes(*params);
    }

    std::vector<Type> resultTypes;
    if (results) {
      resultTypes = *results;
    }

    auto sig = Signature(Type(paramTypes), Type(resultTypes));
    auto [it, inserted] = sigTypes.insert({sig, HeapType::func});
    if (inserted) {
      auto type = HeapType(sig);
      it->second = type;
      types.push_back(type);
    }
    implicitTypes.insert({pos, it->second});

    return Ok{};
  }
};

// Phase 4: Parse and set the types of module elements.
struct ParseModuleTypesCtx : TypeParserCtx<ParseModuleTypesCtx>,
                             NullInstrParserCtx {
  // In this phase we have constructed all the types, so we can materialize and
  // validate them when they are used.

  using GlobalTypeT = GlobalType;
  using TypeUseT = TypeUse;

  ParseInput in;

  Module& wasm;

  const std::vector<HeapType>& types;
  const std::unordered_map<Index, HeapType>& implicitTypes;

  // The index of the current type.
  Index index = 0;

  ParseModuleTypesCtx(std::string_view in,
                      Module& wasm,
                      const std::vector<HeapType>& types,
                      const std::unordered_map<Index, HeapType>& implicitTypes,
                      const IndexMap& typeIndices)
    : TypeParserCtx<ParseModuleTypesCtx>(typeIndices), in(in), wasm(wasm),
      types(types), implicitTypes(implicitTypes) {}

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT> type,
                               ParamsT* params,
                               ResultsT* results) {
    std::vector<Name> ids;
    if (params) {
      ids.reserve(params->size());
      for (auto& p : *params) {
        ids.push_back(p.name);
      }
    }

    if (type) {
      return TypeUse{*type, ids};
    }

    auto it = implicitTypes.find(pos);
    assert(it != implicitTypes.end());

    return TypeUse{it->second, ids};
  }

  Result<HeapType> getBlockTypeFromTypeUse(Index pos, TypeUse use) {
    assert(use.type.isSignature());
    if (use.type.getSignature().params != Type::none) {
      return in.err(pos, "block parameters not yet supported");
    }
    // TODO: Once we support block parameters, return an error here if any of
    // them are named.
    return use.type;
  }

  GlobalTypeT makeGlobalType(Mutability mutability, TypeT type) {
    return {mutability, type};
  }

  Result<> addFunc(Name name,
                   const std::vector<Name>&,
                   ImportNames*,
                   TypeUse type,
                   std::optional<LocalsT> locals,
                   std::optional<InstrsT>,
                   Index pos) {
    auto& f = wasm.functions[index];
    if (!type.type.isSignature()) {
      return in.err(pos, "expected signature type");
    }
    f->type = type.type;
    for (Index i = 0; i < type.names.size(); ++i) {
      if (type.names[i].is()) {
        f->setLocalName(i, type.names[i]);
      }
    }
    if (locals) {
      for (auto& l : *locals) {
        Builder::addVar(f.get(), l.name, l.type);
      }
    }
    return Ok{};
  }

  Result<>
  addMemory(Name, const std::vector<Name>&, ImportNames*, MemTypeT, Index) {
    return Ok{};
  }

  Result<> addImplicitData(DataStringT&& data) { return Ok{}; }

  Result<> addGlobal(Name,
                     const std::vector<Name>&,
                     ImportNames*,
                     GlobalType type,
                     std::optional<ExprT>,
                     Index) {
    auto& g = wasm.globals[index];
    g->mutable_ = type.mutability;
    g->type = type.type;
    return Ok{};
  }
};

// Phase 5: Parse module element definitions, including instructions.
struct ParseDefsCtx : TypeParserCtx<ParseDefsCtx> {
  using GlobalTypeT = Ok;
  using TypeUseT = HeapType;

  // Keep track of instructions internally rather than letting the general
  // parser collect them.
  using InstrT = Ok;
  using InstrsT = std::vector<Expression*>;
  using ExprT = Expression*;

  using FieldIdxT = Index;
  using LocalIdxT = Index;
  using GlobalIdxT = Name;
  using MemoryIdxT = Name;
  using DataIdxT = uint32_t;

  using MemargT = Memarg;

  ParseInput in;

  Module& wasm;
  Builder builder;

  const std::vector<HeapType>& types;
  const std::unordered_map<Index, HeapType>& implicitTypes;

  // The index of the current module element.
  Index index = 0;

  // The current function being parsed, used to create scratch locals, type
  // local.get, etc.
  Function* func = nullptr;

  // The context for a single block scope, including the instructions parsed
  // inside that scope so far and the ultimate result type we expect this block
  // to have.
  struct BlockCtx {
    std::vector<Expression*> exprStack;
    Type type;
  };

  // The stack of block contexts currently being parsed.
  std::vector<BlockCtx> scopeStack;

  // Whether we have seen an unreachable instruction and are in
  // stack-polymorphic unreachable mode.
  bool unreachable = false;

  ParseDefsCtx(std::string_view in,
               Module& wasm,
               const std::vector<HeapType>& types,
               const std::unordered_map<Index, HeapType>& implicitTypes,
               const IndexMap& typeIndices)
    : TypeParserCtx(typeIndices), in(in), wasm(wasm), builder(wasm),
      types(types), implicitTypes(implicitTypes) {}

  std::vector<Expression*>& getExprStack() {
    if (scopeStack.empty()) {
      // We are not in a function, so push a dummy scope.
      scopeStack.push_back({{}, Type::none});
    }
    return scopeStack.back().exprStack;
  }

  void pushScope(Type type) { scopeStack.push_back({{}, type}); }

  Type getResultType() {
    assert(!scopeStack.empty());
    return scopeStack.back().type;
  }

  Result<> push(Index pos, Expression* expr) {
    auto& exprStack = getExprStack();
    if (expr->type == Type::unreachable) {
      // We want to avoid popping back past this most recent unreachable
      // instruction. Drop all prior instructions so they won't be consumed by
      // later instructions but will still be emitted for their side effects, if
      // any.
      for (auto& expr : exprStack) {
        expr = builder.dropIfConcretelyTyped(expr);
      }
      unreachable = true;
      exprStack.push_back(expr);
    } else if (expr->type.isTuple()) {
      auto scratchIdx = addScratchLocal(pos, expr->type);
      CHECK_ERR(scratchIdx);
      CHECK_ERR(push(pos, builder.makeLocalSet(*scratchIdx, expr)));
      for (Index i = 0; i < expr->type.size(); ++i) {
        CHECK_ERR(push(pos,
                       builder.makeTupleExtract(
                         builder.makeLocalGet(*scratchIdx, expr->type), i)));
      }
    } else {
      exprStack.push_back(expr);
    }
    return Ok{};
  }

  Result<Expression*> pop(Index pos) {
    auto& exprStack = getExprStack();

    // Find the suffix of expressions that do not produce values.
    auto firstNone = exprStack.size();
    for (; firstNone > 0; --firstNone) {
      auto* expr = exprStack[firstNone - 1];
      if (expr->type != Type::none) {
        break;
      }
    }

    if (firstNone == 0) {
      // There are no expressions that produce values.
      if (unreachable) {
        return builder.makeUnreachable();
      }
      return in.err(pos, "popping from empty stack");
    }

    if (firstNone == exprStack.size()) {
      // The last expression produced a value.
      auto expr = exprStack.back();
      exprStack.pop_back();
      return expr;
    }

    // We need to assemble a block of expressions that returns the value of the
    // first one using a scratch local (unless it's unreachable, in which case
    // we can throw the following expressions away).
    auto* expr = exprStack[firstNone - 1];
    if (expr->type == Type::unreachable) {
      exprStack.resize(firstNone - 1);
      return expr;
    }
    auto scratchIdx = addScratchLocal(pos, expr->type);
    CHECK_ERR(scratchIdx);
    std::vector<Expression*> exprs;
    exprs.reserve(exprStack.size() - firstNone + 2);
    exprs.push_back(builder.makeLocalSet(*scratchIdx, expr));
    exprs.insert(exprs.end(), exprStack.begin() + firstNone, exprStack.end());
    exprs.push_back(builder.makeLocalGet(*scratchIdx, expr->type));

    exprStack.resize(firstNone - 1);
    return builder.makeBlock(exprs, expr->type);
  }

  HeapType getBlockTypeFromResult(const std::vector<Type> results) {
    assert(results.size() == 1);
    pushScope(results[0]);
    return HeapType(Signature(Type::none, results[0]));
  }

  Result<HeapType> getBlockTypeFromTypeUse(Index pos, HeapType type) {
    pushScope(type.getSignature().results);
    return type;
  }

  Ok makeInstrs() { return Ok{}; }

  void appendInstr(Ok&, InstrT instr) {}

  Result<InstrsT> finishInstrs(Ok&) {
    auto& exprStack = getExprStack();
    auto type = getResultType();

    // We have finished parsing a sequence of instructions. Fix up the parsed
    // instructions and reset the context for the next sequence.
    if (type.isTuple()) {
      std::vector<Expression*> elems(type.size());
      bool hadUnreachableElem = false;
      for (size_t i = 0; i < elems.size(); ++i) {
        auto elem = pop(self().in.getPos());
        CHECK_ERR(elem);
        elems[elems.size() - 1 - i] = *elem;
        if ((*elem)->type == Type::unreachable) {
          // We don't want to pop back past an unreachable here. Push the
          // unreachable back and throw away any post-unreachable values we have
          // popped.
          exprStack.push_back(*elem);
          hadUnreachableElem = true;
          break;
        }
      }
      if (!hadUnreachableElem) {
        exprStack.push_back(builder.makeTupleMake(std::move(elems)));
      }
    } else if (type != Type::none) {
      // Ensure the last expression produces the value.
      auto expr = pop(self().in.getPos());
      CHECK_ERR(expr);
      exprStack.push_back(*expr);
    }
    unreachable = false;
    auto ret = std::move(exprStack);
    scopeStack.pop_back();
    return ret;
  }

  Expression* instrToExpr(Ok&) {
    auto& exprStack = getExprStack();
    assert(scopeStack.size() == 1);
    assert(exprStack.size() == 1);

    auto e = exprStack.back();
    exprStack.clear();
    unreachable = false;
    return e;
  }

  GlobalTypeT makeGlobalType(Mutability, TypeT) { return Ok{}; }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<Index> getFieldFromIdx(HeapType type, uint32_t idx) {
    if (!type.isStruct()) {
      return in.err("expected struct type");
    }
    if (idx >= type.getStruct().fields.size()) {
      return in.err("struct index out of bounds");
    }
    return idx;
  }

  Result<Index> getFieldFromName(HeapType type, Name name) {
    // TODO: Field names
    return in.err("symbolic field names note yet supported");
  }

  Result<Index> getLocalFromIdx(uint32_t idx) {
    if (!func) {
      return in.err("cannot access locals outside of a function");
    }
    if (idx >= func->getNumLocals()) {
      return in.err("local index out of bounds");
    }
    return idx;
  }

  Result<Index> getLocalFromName(Name name) {
    if (!func) {
      return in.err("cannot access locals outside of a function");
    }
    if (!func->hasLocalIndex(name)) {
      return in.err("local $" + name.toString() + " does not exist");
    }
    return func->getLocalIndex(name);
  }

  Result<Name> getGlobalFromIdx(uint32_t idx) {
    if (idx >= wasm.globals.size()) {
      return in.err("global index out of bounds");
    }
    return wasm.globals[idx]->name;
  }

  Result<Name> getGlobalFromName(Name name) {
    if (!wasm.getGlobalOrNull(name)) {
      return in.err("global $" + name.toString() + " does not exist");
    }
    return name;
  }

  Result<Name> getMemoryFromIdx(uint32_t idx) {
    if (idx >= wasm.memories.size()) {
      return in.err("memory index out of bounds");
    }
    return wasm.memories[idx]->name;
  }

  Result<Name> getMemoryFromName(Name name) {
    if (!wasm.getMemoryOrNull(name)) {
      return in.err("memory $" + name.toString() + " does not exist");
    }
    return name;
  }

  Result<uint32_t> getDataFromIdx(uint32_t idx) {
    if (idx >= wasm.dataSegments.size()) {
      return in.err("data index out of bounds");
    }
    return idx;
  }

  Result<uint32_t> getDataFromName(Name name) {
    for (uint32_t i = 0; i < wasm.dataSegments.size(); ++i) {
      if (wasm.dataSegments[i]->name == name) {
        return i;
      }
    }
    return in.err("data $" + name.toString() + " does not exist");
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT> type,
                               ParamsT* params,
                               ResultsT* results) {
    if (type && (params || results)) {
      std::vector<Type> paramTypes;
      if (params) {
        paramTypes = getUnnamedTypes(*params);
      }

      std::vector<Type> resultTypes;
      if (results) {
        resultTypes = *results;
      }

      auto sig = Signature(Type(paramTypes), Type(resultTypes));

      if (!type->isSignature() || type->getSignature() != sig) {
        return in.err(pos, "type does not match provided signature");
      }
    }

    if (type) {
      return *type;
    }

    auto it = implicitTypes.find(pos);
    assert(it != implicitTypes.end());
    return it->second;
  }

  Result<> addFunc(Name,
                   const std::vector<Name>&,
                   ImportNames*,
                   TypeUseT,
                   std::optional<LocalsT>,
                   std::optional<InstrsT> insts,
                   Index) {
    Expression* body;
    if (insts) {
      switch (insts->size()) {
        case 0:
          body = builder.makeNop();
          break;
        case 1:
          body = insts->back();
          break;
        default:
          body = builder.makeBlock(*insts, wasm.functions[index]->getResults());
          break;
      }
    } else {
      body = builder.makeNop();
    }
    wasm.functions[index]->body = body;
    return Ok{};
  }

  Result<> addGlobal(Name,
                     const std::vector<Name>&,
                     ImportNames*,
                     GlobalTypeT,
                     std::optional<ExprT> exp,
                     Index) {
    if (exp) {
      wasm.globals[index]->init = *exp;
    }
    return Ok{};
  }

  Result<> addData(
    Name, Name* mem, std::optional<ExprT> offset, DataStringT, Index pos) {
    auto& d = wasm.dataSegments[index];
    if (offset) {
      d->isPassive = false;
      d->offset = *offset;
      if (mem) {
        d->memory = *mem;
      } else if (wasm.memories.size() > 0) {
        d->memory = wasm.memories[0]->name;
      } else {
        return in.err(pos, "active segment with no memory");
      }
    } else {
      d->isPassive = true;
    }
    return Ok{};
  }

  Result<Index> addScratchLocal(Index pos, Type type) {
    if (!func) {
      return in.err(pos,
                    "scratch local required, but there is no function context");
    }
    Name name = Names::getValidLocalName(*func, "scratch");
    return Builder::addVar(func, name, type);
  }

  Expression* makeExpr(InstrsT& instrs) {
    switch (instrs.size()) {
      case 0:
        return builder.makeNop();
      case 1:
        return instrs.front();
      default:
        return builder.makeBlock(instrs);
    }
  }

  Memarg getMemarg(uint64_t offset, uint32_t align) { return {offset, align}; }

  Result<> validateTypeAnnotation(Index pos, HeapType type, Expression* child) {
    if (child->type == Type::unreachable) {
      return Ok{};
    }
    if (!child->type.isRef() ||
        !HeapType::isSubType(child->type.getHeapType(), type)) {
      return in.err(pos, "invalid reference type on stack");
    }
    return Ok{};
  }

  Result<Name> getMemory(Index pos, Name* mem) {
    if (mem) {
      return *mem;
    }
    if (wasm.memories.empty()) {
      return in.err(pos, "memory required, but there is no memory");
    }
    return wasm.memories[0]->name;
  }

  Result<> makeBlock(Index pos,
                     std::optional<Name> label,
                     HeapType type,
                     const std::vector<Expression*>& instrs) {
    // TODO: validate labels?
    // TODO: Move error on input types to here?
    auto results = type.getSignature().results;
    if (label) {
      return push(pos, builder.makeBlock(*label, instrs, results));
    } else {
      return push(pos, builder.makeBlock(instrs, results));
    }
  }

  Result<> makeUnreachable(Index pos) {
    return push(pos, builder.makeUnreachable());
  }

  Result<> makeNop(Index pos) { return push(pos, builder.makeNop()); }

  Result<> makeBinary(Index pos, BinaryOp op) {
    auto rhs = pop(pos);
    CHECK_ERR(rhs);
    auto lhs = pop(pos);
    CHECK_ERR(lhs);
    return push(pos, builder.makeBinary(op, *lhs, *rhs));
  }

  Result<> makeUnary(Index pos, UnaryOp op) {
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeUnary(op, *val));
  }

  Result<> makeSelect(Index pos, std::vector<Type>* res) {
    if (res && res->size() > 1) {
      return in.err(pos, "select may not have more than one result type");
    }
    auto cond = pop(pos);
    CHECK_ERR(cond);
    auto ifFalse = pop(pos);
    CHECK_ERR(ifFalse);
    auto ifTrue = pop(pos);
    CHECK_ERR(ifTrue);
    auto select = builder.makeSelect(*cond, *ifTrue, *ifFalse);
    if (res && !res->empty() && !Type::isSubType(select->type, res->front())) {
      return in.err(pos, "select type annotation is incorrect");
    }
    return push(pos, builder.makeSelect(*cond, *ifTrue, *ifFalse));
  }

  Result<> makeDrop(Index pos) {
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeDrop(*val));
  }

  Result<> makeMemorySize(Index pos, Name* mem) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    return push(pos, builder.makeMemorySize(*m));
  }

  Result<> makeMemoryGrow(Index pos, Name* mem) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeMemoryGrow(*val, *m));
  }

  Result<> makeLocalGet(Index pos, Index local) {
    if (!func) {
      return in.err(pos, "local.get must be inside a function");
    }
    assert(local < func->getNumLocals());
    return push(pos, builder.makeLocalGet(local, func->getLocalType(local)));
  }

  Result<> makeLocalTee(Index pos, Index local) {
    if (!func) {
      return in.err(pos, "local.tee must be inside a function");
    }
    assert(local < func->getNumLocals());
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos,
                builder.makeLocalTee(local, *val, func->getLocalType(local)));
  }

  Result<> makeLocalSet(Index pos, Index local) {
    if (!func) {
      return in.err(pos, "local.set must be inside a function");
    }
    assert(local < func->getNumLocals());
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeLocalSet(local, *val));
  }

  Result<> makeGlobalGet(Index pos, Name global) {
    assert(wasm.getGlobalOrNull(global));
    auto type = wasm.getGlobal(global)->type;
    return push(pos, builder.makeGlobalGet(global, type));
  }

  Result<> makeGlobalSet(Index pos, Name global) {
    assert(wasm.getGlobalOrNull(global));
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeGlobalSet(global, *val));
  }

  Result<> makeI32Const(Index pos, uint32_t c) {
    return push(pos, builder.makeConst(Literal(c)));
  }

  Result<> makeI64Const(Index pos, uint64_t c) {
    return push(pos, builder.makeConst(Literal(c)));
  }

  Result<> makeF32Const(Index pos, float c) {
    return push(pos, builder.makeConst(Literal(c)));
  }

  Result<> makeF64Const(Index pos, double c) {
    return push(pos, builder.makeConst(Literal(c)));
  }

  Result<> makeLoad(Index pos,
                    Type type,
                    bool signed_,
                    int bytes,
                    bool isAtomic,
                    Name* mem,
                    Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto ptr = pop(pos);
    CHECK_ERR(ptr);
    if (isAtomic) {
      return push(pos,
                  builder.makeAtomicLoad(bytes, memarg.offset, *ptr, type, *m));
    }
    return push(pos,
                builder.makeLoad(
                  bytes, signed_, memarg.offset, memarg.align, *ptr, type, *m));
  }

  Result<> makeStore(
    Index pos, Type type, int bytes, bool isAtomic, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto val = pop(pos);
    CHECK_ERR(val);
    auto ptr = pop(pos);
    CHECK_ERR(ptr);
    if (isAtomic) {
      return push(
        pos,
        builder.makeAtomicStore(bytes, memarg.offset, *ptr, *val, type, *m));
    }
    return push(pos,
                builder.makeStore(
                  bytes, memarg.offset, memarg.align, *ptr, *val, type, *m));
  }

  Result<> makeAtomicRMW(
    Index pos, AtomicRMWOp op, Type type, int bytes, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto val = pop(pos);
    CHECK_ERR(val);
    auto ptr = pop(pos);
    CHECK_ERR(ptr);
    return push(
      pos,
      builder.makeAtomicRMW(op, bytes, memarg.offset, *ptr, *val, type, *m));
  }

  Result<>
  makeAtomicCmpxchg(Index pos, Type type, int bytes, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto replacement = pop(pos);
    CHECK_ERR(replacement);
    auto expected = pop(pos);
    CHECK_ERR(expected);
    auto ptr = pop(pos);
    CHECK_ERR(ptr);
    return push(
      pos,
      builder.makeAtomicCmpxchg(
        bytes, memarg.offset, *ptr, *expected, *replacement, type, *m));
  }

  Result<> makeAtomicWait(Index pos, Type type, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto timeout = pop(pos);
    CHECK_ERR(timeout);
    auto expected = pop(pos);
    CHECK_ERR(expected);
    auto ptr = pop(pos);
    CHECK_ERR(ptr);
    return push(pos,
                builder.makeAtomicWait(
                  *ptr, *expected, *timeout, type, memarg.offset, *m));
  }

  Result<> makeAtomicNotify(Index pos, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto count = pop(pos);
    CHECK_ERR(count);
    auto ptr = pop(pos);
    CHECK_ERR(ptr);
    return push(pos, builder.makeAtomicNotify(*ptr, *count, memarg.offset, *m));
  }

  Result<> makeAtomicFence(Index pos) {
    return push(pos, builder.makeAtomicFence());
  }

  Result<> makeSIMDExtract(Index pos, SIMDExtractOp op, uint8_t lane) {
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeSIMDExtract(op, *val, lane));
  }

  Result<> makeSIMDReplace(Index pos, SIMDReplaceOp op, uint8_t lane) {
    auto val = pop(pos);
    CHECK_ERR(val);
    auto vec = pop(pos);
    CHECK_ERR(vec);
    return push(pos, builder.makeSIMDReplace(op, *vec, lane, *val));
  }

  Result<> makeSIMDShuffle(Index pos, const std::array<uint8_t, 16>& lanes) {
    auto rhs = pop(pos);
    CHECK_ERR(rhs);
    auto lhs = pop(pos);
    CHECK_ERR(lhs);
    return push(pos, builder.makeSIMDShuffle(*lhs, *rhs, lanes));
  }

  Result<> makeSIMDTernary(Index pos, SIMDTernaryOp op) {
    auto c = pop(pos);
    CHECK_ERR(c);
    auto b = pop(pos);
    CHECK_ERR(b);
    auto a = pop(pos);
    CHECK_ERR(a);
    return push(pos, builder.makeSIMDTernary(op, *a, *b, *c));
  }

  Result<> makeSIMDShift(Index pos, SIMDShiftOp op) {
    auto shift = pop(pos);
    CHECK_ERR(shift);
    auto vec = pop(pos);
    CHECK_ERR(vec);
    return push(pos, builder.makeSIMDShift(op, *vec, *shift));
  }

  Result<> makeSIMDLoad(Index pos, SIMDLoadOp op, Name* mem, Memarg memarg) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto ptr = pop(pos);
    CHECK_ERR(ptr);
    return push(
      pos, builder.makeSIMDLoad(op, memarg.offset, memarg.align, *ptr, *m));
  }

  Result<> makeSIMDLoadStoreLane(
    Index pos, SIMDLoadStoreLaneOp op, Name* mem, Memarg memarg, uint8_t lane) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto vec = pop(pos);
    CHECK_ERR(vec);
    auto ptr = pop(pos);
    CHECK_ERR(ptr);
    return push(pos,
                builder.makeSIMDLoadStoreLane(
                  op, memarg.offset, memarg.align, lane, *ptr, *vec, *m));
  }

  Result<> makeMemoryInit(Index pos, Name* mem, uint32_t data) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto size = pop(pos);
    CHECK_ERR(size);
    auto offset = pop(pos);
    CHECK_ERR(offset);
    auto dest = pop(pos);
    CHECK_ERR(dest);
    return push(pos, builder.makeMemoryInit(data, *dest, *offset, *size, *m));
  }

  Result<> makeDataDrop(Index pos, uint32_t data) {
    return push(pos, builder.makeDataDrop(data));
  }

  Result<> makeMemoryCopy(Index pos, Name* destMem, Name* srcMem) {
    auto destMemory = getMemory(pos, destMem);
    CHECK_ERR(destMemory);
    auto srcMemory = getMemory(pos, srcMem);
    CHECK_ERR(srcMemory);
    auto size = pop(pos);
    CHECK_ERR(size);
    auto src = pop(pos);
    CHECK_ERR(src);
    auto dest = pop(pos);
    CHECK_ERR(dest);
    return push(
      pos, builder.makeMemoryCopy(*dest, *src, *size, *destMemory, *srcMemory));
  }

  Result<> makeMemoryFill(Index pos, Name* mem) {
    auto m = getMemory(pos, mem);
    CHECK_ERR(m);
    auto size = pop(pos);
    CHECK_ERR(size);
    auto val = pop(pos);
    CHECK_ERR(val);
    auto dest = pop(pos);
    CHECK_ERR(dest);
    return push(pos, builder.makeMemoryFill(*dest, *val, *size, *m));
  }

  Result<> makeReturn(Index pos) {
    if (!func) {
      return in.err("cannot return outside of a function");
    }
    size_t n = func->getResults().size();
    if (n == 0) {
      return push(pos, builder.makeReturn());
    }
    if (n == 1) {
      auto val = pop(pos);
      CHECK_ERR(val);
      return push(pos, builder.makeReturn(*val));
    }
    std::vector<Expression*> vals(n);
    for (size_t i = 0; i < n; ++i) {
      auto val = pop(pos);
      CHECK_ERR(val);
      vals[n - i - 1] = *val;
    }
    return push(pos, builder.makeReturn(builder.makeTupleMake(vals)));
  }

  Result<> makeRefNull(Index pos, HeapType type) {
    return push(pos, builder.makeRefNull(type));
  }

  Result<> makeRefIsNull(Index pos) {
    auto ref = pop(pos);
    CHECK_ERR(ref);
    return push(pos, builder.makeRefIsNull(*ref));
  }

  Result<> makeRefEq(Index pos) {
    auto rhs = pop(pos);
    CHECK_ERR(rhs);
    auto lhs = pop(pos);
    CHECK_ERR(lhs);
    return push(pos, builder.makeRefEq(*lhs, *rhs));
  }

  Result<> makeI31New(Index pos) {
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeI31New(*val));
  }

  Result<> makeI31Get(Index pos, bool signed_) {
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeI31Get(*val, signed_));
  }

  Result<> makeStructNew(Index pos, HeapType type) {
    if (!type.isStruct()) {
      return in.err(pos, "expected struct type annotation");
    }
    size_t numOps = type.getStruct().fields.size();
    std::vector<Expression*> ops(numOps);
    for (size_t i = 0; i < numOps; ++i) {
      auto op = pop(pos);
      CHECK_ERR(op);
      ops[numOps - i - 1] = *op;
    }
    return push(pos, builder.makeStructNew(type, ops));
  }

  Result<> makeStructNewDefault(Index pos, HeapType type) {
    return push(pos, builder.makeStructNew(type, std::array<Expression*, 0>{}));
  }

  Result<> makeStructGet(Index pos, HeapType type, Index field, bool signed_) {
    if (!type.isStruct()) {
      return in.err(pos, "expected struct type annotation");
    }
    const auto& fields = type.getStruct().fields;
    if (field >= fields.size()) {
      return in.err(pos, "struct field index out of bounds");
    }
    auto fieldType = fields[field].type;
    auto ref = pop(pos);
    CHECK_ERR(ref);
    CHECK_ERR(validateTypeAnnotation(pos, type, *ref));
    return push(pos, builder.makeStructGet(field, *ref, fieldType, signed_));
  }

  Result<> makeStructSet(Index pos, HeapType type, Index field) {
    if (!type.isStruct()) {
      return in.err(pos, "expected struct type annotation");
    }
    if (field >= type.getStruct().fields.size()) {
      return in.err(pos, "struct field index out of bounds");
    }
    auto val = pop(pos);
    CHECK_ERR(val);
    auto ref = pop(pos);
    CHECK_ERR(ref);
    CHECK_ERR(validateTypeAnnotation(pos, type, *ref));
    return push(pos, builder.makeStructSet(field, *ref, *val));
  }

  Result<> makeArrayNew(Index pos, HeapType type) {
    if (!type.isArray()) {
      return in.err(pos, "expected array type annotation");
    }
    auto size = pop(pos);
    CHECK_ERR(size);
    auto val = pop(pos);
    CHECK_ERR(val);
    return push(pos, builder.makeArrayNew(type, *size, *val));
  }

  Result<> makeArrayNewDefault(Index pos, HeapType type) {
    if (!type.isArray()) {
      return in.err(pos, "expected array type annotation");
    }
    auto size = pop(pos);
    CHECK_ERR(size);
    return push(pos, builder.makeArrayNew(type, *size));
  }

  Result<> makeArrayNewData(Index pos, HeapType type, uint32_t data) {
    if (!type.isArray()) {
      return in.err(pos, "expected array type annotation");
    }
    auto size = pop(pos);
    CHECK_ERR(size);
    auto offset = pop(pos);
    CHECK_ERR(offset);
    return push(pos,
                builder.makeArrayNewSeg(NewData, type, data, *offset, *size));
  }

  Result<> makeArrayGet(Index pos, HeapType type, bool signed_) {
    if (!type.isArray()) {
      return in.err(pos, "expected array type annotation");
    }
    auto elemType = type.getArray().element.type;
    auto index = pop(pos);
    CHECK_ERR(index);
    auto ref = pop(pos);
    CHECK_ERR(ref);
    CHECK_ERR(validateTypeAnnotation(pos, type, *ref));
    return push(pos, builder.makeArrayGet(*ref, *index, elemType, signed_));
  }

  Result<> makeArraySet(Index pos, HeapType type) {
    if (!type.isArray()) {
      return in.err(pos, "expected array type annotation");
    }
    auto val = pop(pos);
    CHECK_ERR(val);
    auto index = pop(pos);
    CHECK_ERR(index);
    auto ref = pop(pos);
    CHECK_ERR(ref);
    CHECK_ERR(validateTypeAnnotation(pos, type, *ref));
    return push(pos, builder.makeArraySet(*ref, *index, *val));
  }

  Result<> makeArrayLen(Index pos) {
    auto ref = pop(pos);
    CHECK_ERR(ref);
    return push(pos, builder.makeArrayLen(*ref));
  }

  Result<> makeArrayCopy(Index pos, HeapType destType, HeapType srcType) {
    if (!destType.isArray()) {
      return in.err(pos, "expected array destination type annotation");
    }
    if (!srcType.isArray()) {
      return in.err(pos, "expected array source type annotation");
    }
    auto len = pop(pos);
    CHECK_ERR(len);
    auto srcIdx = pop(pos);
    CHECK_ERR(srcIdx);
    auto srcRef = pop(pos);
    CHECK_ERR(srcRef);
    auto destIdx = pop(pos);
    CHECK_ERR(destIdx);
    auto destRef = pop(pos);
    CHECK_ERR(destRef);
    CHECK_ERR(validateTypeAnnotation(pos, srcType, *srcRef));
    CHECK_ERR(validateTypeAnnotation(pos, destType, *destRef));
    return push(
      pos, builder.makeArrayCopy(*destRef, *destIdx, *srcRef, *srcIdx, *len));
  }
};

// ================
// Parser Functions
// ================

// Types
template<typename Ctx> Result<typename Ctx::HeapTypeT> heaptype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::RefTypeT> reftype(Ctx&);
template<typename Ctx> Result<typename Ctx::TypeT> valtype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::ParamsT> params(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::ResultsT> results(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::SignatureT> functype(Ctx&);
template<typename Ctx> Result<typename Ctx::FieldT> storagetype(Ctx&);
template<typename Ctx> Result<typename Ctx::FieldT> fieldtype(Ctx&);
template<typename Ctx> Result<typename Ctx::FieldsT> fields(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::StructT> structtype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::ArrayT> arraytype(Ctx&);
template<typename Ctx> Result<typename Ctx::LimitsT> limits32(Ctx&);
template<typename Ctx> Result<typename Ctx::LimitsT> limits64(Ctx&);
template<typename Ctx> Result<typename Ctx::MemTypeT> memtype(Ctx&);
template<typename Ctx> Result<typename Ctx::GlobalTypeT> globaltype(Ctx&);

// Instructions
template<typename Ctx> MaybeResult<typename Ctx::InstrT> foldedBlockinstr(Ctx&);
template<typename Ctx>
MaybeResult<typename Ctx::InstrT> unfoldedBlockinstr(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::InstrT> blockinstr(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::InstrT> plaininstr(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::InstrT> instr(Ctx&);
template<typename Ctx> Result<typename Ctx::InstrsT> instrs(Ctx&);
template<typename Ctx> Result<typename Ctx::ExprT> expr(Ctx&);
template<typename Ctx> Result<typename Ctx::MemargT> memarg(Ctx&, uint32_t);
template<typename Ctx> Result<typename Ctx::BlockTypeT> blocktype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::InstrT> block(Ctx&, bool);
template<typename Ctx>
Result<typename Ctx::InstrT> makeUnreachable(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeNop(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeBinary(Ctx&, Index, BinaryOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeUnary(Ctx&, Index, UnaryOp op);
template<typename Ctx> Result<typename Ctx::InstrT> makeSelect(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeDrop(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeMemorySize(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeMemoryGrow(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeLocalGet(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeLocalTee(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeLocalSet(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeGlobalGet(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeGlobalSet(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeBlock(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeThenOrElse(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeConst(Ctx&, Index, Type type);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeLoad(Ctx&, Index, Type type, bool signed_, int bytes, bool isAtomic);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStore(Ctx&, Index, Type type, int bytes, bool isAtomic);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeAtomicRMW(Ctx&, Index, AtomicRMWOp op, Type type, uint8_t bytes);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeAtomicCmpxchg(Ctx&, Index, Type type, uint8_t bytes);
template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicWait(Ctx&, Index, Type type);
template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicNotify(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicFence(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDExtract(Ctx&, Index, SIMDExtractOp op, size_t lanes);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDReplace(Ctx&, Index, SIMDReplaceOp op, size_t lanes);
template<typename Ctx>
Result<typename Ctx::InstrT> makeSIMDShuffle(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeSIMDTernary(Ctx&, Index, SIMDTernaryOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeSIMDShift(Ctx&, Index, SIMDShiftOp op);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDLoad(Ctx&, Index, SIMDLoadOp op, int bytes);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDLoadStoreLane(Ctx&, Index, SIMDLoadStoreLaneOp op, int bytes);
template<typename Ctx> Result<typename Ctx::InstrT> makeMemoryInit(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeDataDrop(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeMemoryCopy(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeMemoryFill(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makePop(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeIf(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeMaybeBlock(Ctx&, Index, size_t i, Type type);
template<typename Ctx> Result<typename Ctx::InstrT> makeLoop(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeCall(Ctx&, Index, bool isReturn);
template<typename Ctx>
Result<typename Ctx::InstrT> makeCallIndirect(Ctx&, Index, bool isReturn);
template<typename Ctx> Result<typename Ctx::InstrT> makeBreak(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeBreakTable(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeReturn(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeRefNull(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeRefIsNull(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeRefFunc(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeRefEq(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeTableGet(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeTableSet(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeTableSize(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeTableGrow(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeTry(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeTryOrCatchBody(Ctx&, Index, Type type, bool isTry);
template<typename Ctx> Result<typename Ctx::InstrT> makeThrow(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeRethrow(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeTupleMake(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeTupleExtract(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeCallRef(Ctx&, Index, bool isReturn);
template<typename Ctx> Result<typename Ctx::InstrT> makeI31New(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeI31Get(Ctx&, Index, bool signed_);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeRefTest(Ctx&, Index, std::optional<Type> castType = std::nullopt);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeRefCast(Ctx&, Index, std::optional<Type> castType = std::nullopt);
template<typename Ctx> Result<typename Ctx::InstrT> makeRefCastNop(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeBrOnNull(Ctx&, Index, bool onFail = false);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeBrOnCast(Ctx&, Index, std::optional<Type>, bool onFail = false);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStructNew(Ctx&, Index, bool default_);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStructGet(Ctx&, Index, bool signed_ = false);
template<typename Ctx> Result<typename Ctx::InstrT> makeStructSet(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayNew(Ctx&, Index, bool default_);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayNewSeg(Ctx&, Index, ArrayNewSegOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayInitStatic(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayGet(Ctx&, Index, bool signed_ = false);
template<typename Ctx> Result<typename Ctx::InstrT> makeArraySet(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeArrayLen(Ctx&, Index);
template<typename Ctx> Result<typename Ctx::InstrT> makeArrayCopy(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefAs(Ctx&, Index, RefAsOp op);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringNew(Ctx&, Index, StringNewOp op, bool try_);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringConst(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringMeasure(Ctx&, Index, StringMeasureOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringEncode(Ctx&, Index, StringEncodeOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringConcat(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringEq(Ctx&, Index, StringEqOp);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringAs(Ctx&, Index, StringAsOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringWTF8Advance(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringWTF16Get(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringIterNext(Ctx&, Index);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringIterMove(Ctx&, Index, StringIterMoveOp op);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringSliceWTF(Ctx&, Index, StringSliceWTFOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringSliceIter(Ctx&, Index);

// Modules
template<typename Ctx> MaybeResult<Index> maybeTypeidx(Ctx& ctx);
template<typename Ctx> Result<typename Ctx::HeapTypeT> typeidx(Ctx&);
template<typename Ctx>
Result<typename Ctx::FieldIdxT> fieldidx(Ctx&, typename Ctx::HeapTypeT);
template<typename Ctx> MaybeResult<typename Ctx::MemoryIdxT> maybeMemidx(Ctx&);
template<typename Ctx> Result<typename Ctx::MemoryIdxT> memidx(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::MemoryIdxT> maybeMemuse(Ctx&);
template<typename Ctx> Result<typename Ctx::GlobalIdxT> globalidx(Ctx&);
template<typename Ctx> Result<typename Ctx::LocalIdxT> localidx(Ctx&);
template<typename Ctx> Result<typename Ctx::TypeUseT> typeuse(Ctx&);
MaybeResult<ImportNames> inlineImport(ParseInput&);
Result<std::vector<Name>> inlineExports(ParseInput&);
template<typename Ctx> Result<> strtype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::ModuleNameT> subtype(Ctx&);
template<typename Ctx> MaybeResult<> deftype(Ctx&);
template<typename Ctx> MaybeResult<typename Ctx::LocalsT> locals(Ctx&);
template<typename Ctx> MaybeResult<> func(Ctx&);
template<typename Ctx> MaybeResult<> memory(Ctx&);
template<typename Ctx> MaybeResult<> global(Ctx&);
template<typename Ctx> Result<typename Ctx::DataStringT> datastring(Ctx&);
template<typename Ctx> MaybeResult<> data(Ctx&);
MaybeResult<> modulefield(ParseDeclsCtx&);
Result<> module(ParseDeclsCtx&);

// =====
// Types
// =====

// heaptype ::= x:typeidx => types[x]
//            | 'func'    => func
//            | 'extern'  => extern
template<typename Ctx> Result<typename Ctx::HeapTypeT> heaptype(Ctx& ctx) {
  if (ctx.in.takeKeyword("func"sv)) {
    return ctx.makeFunc();
  }
  if (ctx.in.takeKeyword("any"sv)) {
    return ctx.makeAny();
  }
  if (ctx.in.takeKeyword("extern"sv)) {
    return ctx.makeExtern();
  }
  if (ctx.in.takeKeyword("eq"sv)) {
    return ctx.makeEq();
  }
  if (ctx.in.takeKeyword("i31"sv)) {
    return ctx.makeI31();
  }
  if (ctx.in.takeKeyword("struct"sv)) {
    return ctx.makeStructType();
  }
  if (ctx.in.takeKeyword("array"sv)) {
    return ctx.makeArrayType();
  }
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  return *type;
}

// reftype ::= 'funcref'   => funcref
//           | 'externref' => externref
//           | 'anyref'    => anyref
//           | 'eqref'     => eqref
//           | 'i31ref'    => i31ref
//           | 'structref' => structref
//           | 'arrayref'  => arrayref
//           | '(' ref null? t:heaptype ')' => ref null? t
template<typename Ctx> MaybeResult<typename Ctx::TypeT> reftype(Ctx& ctx) {
  if (ctx.in.takeKeyword("funcref"sv)) {
    return ctx.makeRefType(ctx.makeFunc(), Nullable);
  }
  if (ctx.in.takeKeyword("externref"sv)) {
    return ctx.makeRefType(ctx.makeExtern(), Nullable);
  }
  if (ctx.in.takeKeyword("anyref"sv)) {
    return ctx.makeRefType(ctx.makeAny(), Nullable);
  }
  if (ctx.in.takeKeyword("eqref"sv)) {
    return ctx.makeRefType(ctx.makeEq(), Nullable);
  }
  if (ctx.in.takeKeyword("i31ref"sv)) {
    return ctx.makeRefType(ctx.makeI31(), Nullable);
  }
  if (ctx.in.takeKeyword("structref"sv)) {
    return ctx.makeRefType(ctx.makeStructType(), Nullable);
  }
  if (ctx.in.takeKeyword("arrayref"sv)) {
    return ctx.in.err("arrayref not yet supported");
  }

  if (!ctx.in.takeSExprStart("ref"sv)) {
    return {};
  }

  auto nullability = ctx.in.takeKeyword("null"sv) ? Nullable : NonNullable;

  auto type = heaptype(ctx);
  CHECK_ERR(type);

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of reftype");
  }

  return ctx.makeRefType(*type, nullability);
}

// numtype ::= 'i32' => i32
//           | 'i64' => i64
//           | 'f32' => f32
//           | 'f64' => f64
// vectype ::= 'v128' => v128
// valtype ::= t:numtype => t
//           | t:vectype => t
//           | t:reftype => t
template<typename Ctx> Result<typename Ctx::TypeT> valtype(Ctx& ctx) {
  if (ctx.in.takeKeyword("i32"sv)) {
    return ctx.makeI32();
  } else if (ctx.in.takeKeyword("i64"sv)) {
    return ctx.makeI64();
  } else if (ctx.in.takeKeyword("f32"sv)) {
    return ctx.makeF32();
  } else if (ctx.in.takeKeyword("f64"sv)) {
    return ctx.makeF64();
  } else if (ctx.in.takeKeyword("v128"sv)) {
    return ctx.makeV128();
  } else if (auto type = reftype(ctx)) {
    CHECK_ERR(type);
    return *type;
  } else {
    return ctx.in.err("expected valtype");
  }
}

// param  ::= '(' 'param id? t:valtype ')' => [t]
//          | '(' 'param t*:valtype* ')' => [t*]
// params ::= param*
template<typename Ctx> MaybeResult<typename Ctx::ParamsT> params(Ctx& ctx) {
  bool hasAny = false;
  auto res = ctx.makeParams();
  while (ctx.in.takeSExprStart("param"sv)) {
    hasAny = true;
    if (auto id = ctx.in.takeID()) {
      // Single named param
      auto type = valtype(ctx);
      CHECK_ERR(type);
      if (!ctx.in.takeRParen()) {
        return ctx.in.err("expected end of param");
      }
      ctx.appendParam(res, *id, *type);
    } else {
      // Repeated unnamed params
      while (!ctx.in.takeRParen()) {
        auto type = valtype(ctx);
        CHECK_ERR(type);
        ctx.appendParam(res, {}, *type);
      }
    }
  }
  if (hasAny) {
    return res;
  }
  return {};
}

// result  ::= '(' 'result' t*:valtype ')' => [t*]
// results ::= result*
template<typename Ctx> MaybeResult<typename Ctx::ResultsT> results(Ctx& ctx) {
  bool hasAny = false;
  auto res = ctx.makeResults();
  while (ctx.in.takeSExprStart("result"sv)) {
    hasAny = true;
    while (!ctx.in.takeRParen()) {
      auto type = valtype(ctx);
      CHECK_ERR(type);
      ctx.appendResult(res, *type);
    }
  }
  if (hasAny) {
    return res;
  }
  return {};
}

// functype ::= '(' 'func' t1*:vec(param) t2*:vec(result) ')' => [t1*] -> [t2*]
template<typename Ctx>
MaybeResult<typename Ctx::SignatureT> functype(Ctx& ctx) {
  if (!ctx.in.takeSExprStart("func"sv)) {
    return {};
  }

  auto parsedParams = params(ctx);
  CHECK_ERR(parsedParams);

  auto parsedResults = results(ctx);
  CHECK_ERR(parsedResults);

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of functype");
  }

  return ctx.makeFuncType(parsedParams.getPtr(), parsedResults.getPtr());
}

// storagetype ::= valtype | packedtype
// packedtype  ::= i8 | i16
template<typename Ctx> Result<typename Ctx::FieldT> storagetype(Ctx& ctx) {
  if (ctx.in.takeKeyword("i8"sv)) {
    return ctx.makeI8();
  }
  if (ctx.in.takeKeyword("i16"sv)) {
    return ctx.makeI16();
  }
  auto type = valtype(ctx);
  CHECK_ERR(type);
  return ctx.makeStorageType(*type);
}

// fieldtype   ::= t:storagetype               => const t
//               | '(' 'mut' t:storagetype ')' => var t
template<typename Ctx> Result<typename Ctx::FieldT> fieldtype(Ctx& ctx) {
  auto mutability = Immutable;
  if (ctx.in.takeSExprStart("mut"sv)) {
    mutability = Mutable;
  }

  auto field = storagetype(ctx);
  CHECK_ERR(field);

  if (mutability == Mutable) {
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of field type");
    }
  }

  return ctx.makeFieldType(*field, mutability);
}

// field ::= '(' 'field' id t:fieldtype ')' => [(id, t)]
//         | '(' 'field' t*:fieldtype* ')'  => [(_, t*)*]
//         | fieldtype
template<typename Ctx> Result<typename Ctx::FieldsT> fields(Ctx& ctx) {
  auto res = ctx.makeFields();
  while (true) {
    if (auto t = ctx.in.peek(); !t || t->isRParen()) {
      return res;
    }
    if (ctx.in.takeSExprStart("field")) {
      if (auto id = ctx.in.takeID()) {
        auto field = fieldtype(ctx);
        CHECK_ERR(field);
        if (!ctx.in.takeRParen()) {
          return ctx.in.err("expected end of field");
        }
        ctx.appendField(res, *id, *field);
      } else {
        while (!ctx.in.takeRParen()) {
          auto field = fieldtype(ctx);
          CHECK_ERR(field);
          ctx.appendField(res, {}, *field);
        }
      }
    } else {
      auto field = fieldtype(ctx);
      CHECK_ERR(field);
      ctx.appendField(res, {}, *field);
    }
  }
}

// structtype ::= '(' 'struct' field* ')'
template<typename Ctx> MaybeResult<typename Ctx::StructT> structtype(Ctx& ctx) {
  if (!ctx.in.takeSExprStart("struct"sv)) {
    return {};
  }
  auto namedFields = fields(ctx);
  CHECK_ERR(namedFields);
  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of struct definition");
  }

  return ctx.makeStruct(*namedFields);
}

// arraytype ::= '(' 'array' field ')'
template<typename Ctx> MaybeResult<typename Ctx::ArrayT> arraytype(Ctx& ctx) {
  if (!ctx.in.takeSExprStart("array"sv)) {
    return {};
  }
  auto namedFields = fields(ctx);
  CHECK_ERR(namedFields);
  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of array definition");
  }

  if (auto array = ctx.makeArray(*namedFields)) {
    return *array;
  }
  return ctx.in.err("expected exactly one field in array definition");
}

// limits32 ::= n:u32 m:u32?
template<typename Ctx> Result<typename Ctx::LimitsT> limits32(Ctx& ctx) {
  auto n = ctx.in.takeU32();
  if (!n) {
    return ctx.in.err("expected initial size");
  }
  std::optional<uint64_t> m = ctx.in.takeU32();
  return ctx.makeLimits(uint64_t(*n), m);
}

// limits64 ::= n:u64 m:u64?
template<typename Ctx> Result<typename Ctx::LimitsT> limits64(Ctx& ctx) {
  auto n = ctx.in.takeU64();
  if (!n) {
    return ctx.in.err("expected initial size");
  }
  std::optional<uint64_t> m = ctx.in.takeU64();
  return ctx.makeLimits(uint64_t(*n), m);
}

// memtype ::= (limits32 | 'i32' limits32 | 'i64' limit64) shared?
template<typename Ctx> Result<typename Ctx::MemTypeT> memtype(Ctx& ctx) {
  auto type = Type::i32;
  if (ctx.in.takeKeyword("i64"sv)) {
    type = Type::i64;
  } else {
    ctx.in.takeKeyword("i32"sv);
  }
  auto limits = type == Type::i32 ? limits32(ctx) : limits64(ctx);
  CHECK_ERR(limits);
  bool shared = false;
  if (ctx.in.takeKeyword("shared"sv)) {
    shared = true;
  }
  return ctx.makeMemType(type, *limits, shared);
}

// globaltype ::= t:valtype               => const t
//              | '(' 'mut' t:valtype ')' => var t
template<typename Ctx> Result<typename Ctx::GlobalTypeT> globaltype(Ctx& ctx) {
  auto mutability = Immutable;
  if (ctx.in.takeSExprStart("mut"sv)) {
    mutability = Mutable;
  }

  auto type = valtype(ctx);
  CHECK_ERR(type);

  if (mutability == Mutable && !ctx.in.takeRParen()) {
    return ctx.in.err("expected end of globaltype");
  }

  return ctx.makeGlobalType(mutability, *type);
}

// ============
// Instructions
// ============

// blockinstr ::= block | loop | if-else | try-catch
template<typename Ctx>
MaybeResult<typename Ctx::InstrT> foldedBlockinstr(Ctx& ctx) {
  if (auto i = block(ctx, true)) {
    return i;
  }
  // TODO: Other block instructions
  return {};
}

template<typename Ctx>
MaybeResult<typename Ctx::InstrT> unfoldedBlockinstr(Ctx& ctx) {
  if (auto i = block(ctx, false)) {
    return i;
  }
  // TODO: Other block instructions
  return {};
}

template<typename Ctx> MaybeResult<typename Ctx::InstrT> blockinstr(Ctx& ctx) {
  if (auto i = foldedBlockinstr(ctx)) {
    return i;
  }
  if (auto i = unfoldedBlockinstr(ctx)) {
    return i;
  }
  return {};
}

// plaininstr ::= ... all plain instructions ...
template<typename Ctx> MaybeResult<typename Ctx::InstrT> plaininstr(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  auto keyword = ctx.in.takeKeyword();
  if (!keyword) {
    return {};
  }

#define NEW_INSTRUCTION_PARSER
#define NEW_WAT_PARSER
#include <gen-s-parser.inc>
}

// instr ::= plaininstr | blockinstr
template<typename Ctx> MaybeResult<typename Ctx::InstrT> instr(Ctx& ctx) {
  // Check for valid strings that are not instructions.
  if (auto tok = ctx.in.peek()) {
    if (auto keyword = tok->getKeyword()) {
      if (keyword == "end"sv) {
        return {};
      }
    }
  }
  if (auto i = blockinstr(ctx)) {
    return i;
  }
  if (auto i = plaininstr(ctx)) {
    return i;
  }
  // TODO: Handle folded plain instructions as well.
  return {};
}

template<typename Ctx> Result<typename Ctx::InstrsT> instrs(Ctx& ctx) {
  auto insts = ctx.makeInstrs();

  while (true) {
    if (auto blockinst = foldedBlockinstr(ctx)) {
      CHECK_ERR(blockinst);
      ctx.appendInstr(insts, *blockinst);
      continue;
    }
    // Parse an arbitrary number of folded instructions.
    if (ctx.in.takeLParen()) {
      // A stack of (start, end) position pairs defining the positions of
      // instructions that need to be parsed after their folded children.
      std::vector<std::pair<Index, std::optional<Index>>> foldedInstrs;

      // Begin a folded instruction. Push its start position and a placeholder
      // end position.
      foldedInstrs.push_back({ctx.in.getPos(), {}});
      while (!foldedInstrs.empty()) {
        // Consume everything up to the next paren. This span will be parsed as
        // an instruction later after its folded children have been parsed.
        if (!ctx.in.takeUntilParen()) {
          return ctx.in.err(foldedInstrs.back().first,
                            "unterminated folded instruction");
        }

        if (!foldedInstrs.back().second) {
          // The folded instruction we just started should end here.
          foldedInstrs.back().second = ctx.in.getPos();
        }

        // We have either the start of a new folded child or the end of the last
        // one.
        if (auto blockinst = foldedBlockinstr(ctx)) {
          CHECK_ERR(blockinst);
          ctx.appendInstr(insts, *blockinst);
        } else if (ctx.in.takeLParen()) {
          foldedInstrs.push_back({ctx.in.getPos(), {}});
        } else if (ctx.in.takeRParen()) {
          auto [start, end] = foldedInstrs.back();
          assert(end && "Should have found end of instruction");
          foldedInstrs.pop_back();

          WithPosition with(ctx, start);
          if (auto inst = plaininstr(ctx)) {
            CHECK_ERR(inst);
            ctx.appendInstr(insts, *inst);
          } else {
            return ctx.in.err(start, "expected folded instruction");
          }

          if (ctx.in.getPos() != *end) {
            return ctx.in.err("expected end of instruction");
          }
        } else {
          WASM_UNREACHABLE("expected paren");
        }
      }
      continue;
    }

    // A non-folded instruction.
    if (auto inst = instr(ctx)) {
      CHECK_ERR(inst);
      ctx.appendInstr(insts, *inst);
    } else {
      break;
    }
  }

  return ctx.finishInstrs(insts);
}

template<typename Ctx> Result<typename Ctx::ExprT> expr(Ctx& ctx) {
  auto insts = instrs(ctx);
  CHECK_ERR(insts);
  return ctx.makeExpr(*insts);
}

// memarg_n ::= o:offset a:align_n
// offset   ::= 'offset='o:u64 => o | _ => 0
// align_n  ::= 'align='a:u32 => a | _ => n
template<typename Ctx>
Result<typename Ctx::MemargT> memarg(Ctx& ctx, uint32_t n) {
  uint64_t offset = 0;
  uint32_t align = n;
  if (auto o = ctx.in.takeOffset()) {
    offset = *o;
  }
  if (auto a = ctx.in.takeAlign()) {
    align = *a;
  }
  return ctx.getMemarg(offset, align);
}

// blocktype ::= (t:result)? => t? | x,I:typeuse => x if I = {}
template<typename Ctx> Result<typename Ctx::BlockTypeT> blocktype(Ctx& ctx) {
  auto pos = ctx.in.getPos();

  if (auto res = results(ctx)) {
    CHECK_ERR(res);
    if (ctx.getResultsSize(*res) == 1) {
      return ctx.getBlockTypeFromResult(*res);
    }
  }

  // We either had no results or multiple results. Reset and parse again as a
  // type use.
  ctx.in.lexer.setIndex(pos);
  auto use = typeuse(ctx);
  CHECK_ERR(use);

  auto type = ctx.getBlockTypeFromTypeUse(pos, *use);
  CHECK_ERR(type);
  return *type;
}

// block ::= 'block' label blocktype instr* 'end' id?   if id = {} or id = label
//         | '(' 'block' label blocktype instr* ')'
template<typename Ctx>
MaybeResult<typename Ctx::InstrT> block(Ctx& ctx, bool folded) {
  auto pos = ctx.in.getPos();

  if (folded) {
    if (!ctx.in.takeSExprStart("block"sv)) {
      return {};
    }
  } else {
    if (!ctx.in.takeKeyword("block"sv)) {
      return {};
    }
  }

  auto label = ctx.in.takeID();

  auto type = blocktype(ctx);
  CHECK_ERR(type);

  auto insts = instrs(ctx);
  CHECK_ERR(insts);

  if (folded) {
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected ')' at end of block");
    }
  } else {
    if (!ctx.in.takeKeyword("end"sv)) {
      return ctx.in.err("expected 'end' at end of block");
    }
    auto id = ctx.in.takeID();
    if (id && id != label) {
      return ctx.in.err("end label does not match block label");
    }
  }

  return ctx.makeBlock(pos, label, *type, std::move(*insts));
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeUnreachable(Ctx& ctx, Index pos) {
  return ctx.makeUnreachable(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeNop(Ctx& ctx, Index pos) {
  return ctx.makeNop(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBinary(Ctx& ctx, Index pos, BinaryOp op) {
  return ctx.makeBinary(pos, op);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeUnary(Ctx& ctx, Index pos, UnaryOp op) {
  return ctx.makeUnary(pos, op);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeSelect(Ctx& ctx, Index pos) {
  auto res = results(ctx);
  CHECK_ERR(res);
  return ctx.makeSelect(pos, res.getPtr());
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeDrop(Ctx& ctx, Index pos) {
  return ctx.makeDrop(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemorySize(Ctx& ctx, Index pos) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  return ctx.makeMemorySize(pos, mem.getPtr());
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryGrow(Ctx& ctx, Index pos) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  return ctx.makeMemoryGrow(pos, mem.getPtr());
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalGet(Ctx& ctx, Index pos) {
  auto local = localidx(ctx);
  CHECK_ERR(local);
  return ctx.makeLocalGet(pos, *local);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalTee(Ctx& ctx, Index pos) {
  auto local = localidx(ctx);
  CHECK_ERR(local);
  return ctx.makeLocalTee(pos, *local);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalSet(Ctx& ctx, Index pos) {
  auto local = localidx(ctx);
  CHECK_ERR(local);
  return ctx.makeLocalSet(pos, *local);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeGlobalGet(Ctx& ctx, Index pos) {
  auto global = globalidx(ctx);
  CHECK_ERR(global);
  return ctx.makeGlobalGet(pos, *global);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeGlobalSet(Ctx& ctx, Index pos) {
  auto global = globalidx(ctx);
  CHECK_ERR(global);
  return ctx.makeGlobalSet(pos, *global);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBlock(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeThenOrElse(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeConst(Ctx& ctx, Index pos, Type type) {
  assert(type.isBasic());
  switch (type.getBasic()) {
    case Type::i32:
      if (auto c = ctx.in.takeI32()) {
        return ctx.makeI32Const(pos, *c);
      }
      return ctx.in.err("expected i32");
    case Type::i64:
      if (auto c = ctx.in.takeI64()) {
        return ctx.makeI64Const(pos, *c);
      }
      return ctx.in.err("expected i64");
    case Type::f32:
      if (auto c = ctx.in.takeF32()) {
        return ctx.makeF32Const(pos, *c);
      }
      return ctx.in.err("expected f32");
    case Type::f64:
      if (auto c = ctx.in.takeF64()) {
        return ctx.makeF64Const(pos, *c);
      }
      return ctx.in.err("expected f64");
    case Type::v128:
      return ctx.in.err("unimplemented instruction");
    case Type::none:
    case Type::unreachable:
      break;
  }
  WASM_UNREACHABLE("unexpected type");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLoad(
  Ctx& ctx, Index pos, Type type, bool signed_, int bytes, bool isAtomic) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeLoad(pos, type, signed_, bytes, isAtomic, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStore(Ctx& ctx, Index pos, Type type, int bytes, bool isAtomic) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeStore(pos, type, bytes, isAtomic, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeAtomicRMW(Ctx& ctx, Index pos, AtomicRMWOp op, Type type, uint8_t bytes) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeAtomicRMW(pos, op, type, bytes, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeAtomicCmpxchg(Ctx& ctx, Index pos, Type type, uint8_t bytes) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeAtomicCmpxchg(pos, type, bytes, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicWait(Ctx& ctx, Index pos, Type type) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, type == Type::i32 ? 4 : 8);
  CHECK_ERR(arg);
  return ctx.makeAtomicWait(pos, type, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicNotify(Ctx& ctx, Index pos) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, 4);
  CHECK_ERR(arg);
  return ctx.makeAtomicNotify(pos, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicFence(Ctx& ctx, Index pos) {
  return ctx.makeAtomicFence(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDExtract(Ctx& ctx, Index pos, SIMDExtractOp op, size_t) {
  auto lane = ctx.in.takeU8();
  if (!lane) {
    return ctx.in.err("expected lane index");
  }
  return ctx.makeSIMDExtract(pos, op, *lane);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDReplace(Ctx& ctx, Index pos, SIMDReplaceOp op, size_t lanes) {
  auto lane = ctx.in.takeU8();
  if (!lane) {
    return ctx.in.err("expected lane index");
  }
  return ctx.makeSIMDReplace(pos, op, *lane);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeSIMDShuffle(Ctx& ctx, Index pos) {
  std::array<uint8_t, 16> lanes;
  for (int i = 0; i < 16; ++i) {
    auto lane = ctx.in.takeU8();
    if (!lane) {
      return ctx.in.err("expected lane index");
    }
    lanes[i] = *lane;
  }
  return ctx.makeSIMDShuffle(pos, lanes);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDTernary(Ctx& ctx, Index pos, SIMDTernaryOp op) {
  return ctx.makeSIMDTernary(pos, op);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDShift(Ctx& ctx, Index pos, SIMDShiftOp op) {
  return ctx.makeSIMDShift(pos, op);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDLoad(Ctx& ctx, Index pos, SIMDLoadOp op, int bytes) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  return ctx.makeSIMDLoad(pos, op, mem.getPtr(), *arg);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDLoadStoreLane(Ctx& ctx, Index pos, SIMDLoadStoreLaneOp op, int bytes) {
  auto reset = ctx.in.getPos();

  auto retry = [&]() -> Result<typename Ctx::InstrT> {
    // We failed to parse. Maybe the lane index was accidentally parsed as the
    // optional memory index. Try again without parsing a memory index.
    WithPosition with(ctx, reset);
    auto arg = memarg(ctx, bytes);
    CHECK_ERR(arg);
    auto lane = ctx.in.takeU8();
    if (!lane) {
      return ctx.in.err("expected lane index");
    }
    return ctx.makeSIMDLoadStoreLane(pos, op, nullptr, *arg, *lane);
  };

  auto mem = maybeMemidx(ctx);
  if (mem.getErr()) {
    return retry();
  }
  auto arg = memarg(ctx, bytes);
  CHECK_ERR(arg);
  auto lane = ctx.in.takeU8();
  if (!lane) {
    return retry();
  }
  return ctx.makeSIMDLoadStoreLane(pos, op, mem.getPtr(), *arg, *lane);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryInit(Ctx& ctx, Index pos) {
  auto reset = ctx.in.getPos();

  auto retry = [&]() -> Result<typename Ctx::InstrT> {
    // We failed to parse. Maybe the data index was accidentally parsed as the
    // optional memory index. Try again without parsing a memory index.
    WithPosition with(ctx, reset);
    auto data = dataidx(ctx);
    CHECK_ERR(data);
    return ctx.makeMemoryInit(pos, nullptr, *data);
  };

  auto mem = maybeMemidx(ctx);
  if (mem.getErr()) {
    return retry();
  }
  auto data = dataidx(ctx);
  if (data.getErr()) {
    return retry();
  }
  return ctx.makeMemoryInit(pos, mem.getPtr(), *data);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeDataDrop(Ctx& ctx, Index pos) {
  auto data = dataidx(ctx);
  CHECK_ERR(data);
  return ctx.makeDataDrop(pos, *data);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryCopy(Ctx& ctx, Index pos) {
  auto destMem = maybeMemidx(ctx);
  CHECK_ERR(destMem);
  std::optional<typename Ctx::MemoryIdxT> srcMem = std::nullopt;
  if (destMem) {
    auto mem = memidx(ctx);
    CHECK_ERR(mem);
    srcMem = *mem;
  }
  return ctx.makeMemoryCopy(pos, destMem.getPtr(), srcMem ? &*srcMem : nullptr);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryFill(Ctx& ctx, Index pos) {
  auto mem = maybeMemidx(ctx);
  CHECK_ERR(mem);
  return ctx.makeMemoryFill(pos, mem.getPtr());
}

template<typename Ctx>
Result<typename Ctx::InstrT> makePop(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeIf(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeMaybeBlock(Ctx& ctx, Index pos, size_t i, Type type) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLoop(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeCall(Ctx& ctx, Index pos, bool isReturn) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeCallIndirect(Ctx& ctx, Index pos, bool isReturn) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBreak(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBreakTable(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeReturn(Ctx& ctx, Index pos) {
  return ctx.makeReturn(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefNull(Ctx& ctx, Index pos) {
  auto t = heaptype(ctx);
  CHECK_ERR(t);
  return ctx.makeRefNull(pos, *t);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefIsNull(Ctx& ctx, Index pos) {
  return ctx.makeRefIsNull(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefFunc(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefEq(Ctx& ctx, Index pos) {
  return ctx.makeRefEq(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTableGet(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTableSet(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTableSize(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTableGrow(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTry(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeTryOrCatchBody(Ctx& ctx, Index pos, Type type, bool isTry) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeThrow(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRethrow(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTupleMake(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTupleExtract(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeCallRef(Ctx& ctx, Index pos, bool isReturn) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeI31New(Ctx& ctx, Index pos) {
  return ctx.makeI31New(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeI31Get(Ctx& ctx, Index pos, bool signed_) {
  return ctx.makeI31Get(pos, signed_);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeRefTest(Ctx& ctx, Index pos, std::optional<Type> castType) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeRefCast(Ctx& ctx, Index pos, std::optional<Type> castType) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefCastNop(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBrOnNull(Ctx& ctx, Index pos, bool onFail) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeBrOnCast(Ctx& ctx, Index pos, std::optional<Type> castType, bool onFail) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStructNew(Ctx& ctx, Index pos, bool default_) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  if (default_) {
    return ctx.makeStructNewDefault(pos, *type);
  }
  return ctx.makeStructNew(pos, *type);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStructGet(Ctx& ctx, Index pos, bool signed_) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  auto field = fieldidx(ctx, *type);
  CHECK_ERR(field);
  return ctx.makeStructGet(pos, *type, *field, signed_);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStructSet(Ctx& ctx, Index pos) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  auto field = fieldidx(ctx, *type);
  CHECK_ERR(field);
  return ctx.makeStructSet(pos, *type, *field);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayNew(Ctx& ctx, Index pos, bool default_) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  if (default_) {
    return ctx.makeArrayNewDefault(pos, *type);
  }
  return ctx.makeArrayNew(pos, *type);
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeArrayNewSeg(Ctx& ctx, Index pos, ArrayNewSegOp op) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  switch (op) {
    case NewData: {
      auto data = dataidx(ctx);
      CHECK_ERR(data);
      return ctx.makeArrayNewData(pos, *type, *data);
    }
    case NewElem:
      return ctx.in.err("unimplemented instruction");
  }
  WASM_UNREACHABLE("unexpected op");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayInitStatic(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayGet(Ctx& ctx, Index pos, bool signed_) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  return ctx.makeArrayGet(pos, *type, signed_);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArraySet(Ctx& ctx, Index pos) {
  auto type = typeidx(ctx);
  CHECK_ERR(type);
  return ctx.makeArraySet(pos, *type);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayLen(Ctx& ctx, Index pos) {
  return ctx.makeArrayLen(pos);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayCopy(Ctx& ctx, Index pos) {
  auto destType = typeidx(ctx);
  CHECK_ERR(destType);
  auto srcType = typeidx(ctx);
  CHECK_ERR(srcType);
  return ctx.makeArrayCopy(pos, *destType, *srcType);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefAs(Ctx& ctx, Index pos, RefAsOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringNew(Ctx& ctx, Index pos, StringNewOp op, bool try_) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringConst(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringMeasure(Ctx& ctx, Index pos, StringMeasureOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringEncode(Ctx& ctx, Index pos, StringEncodeOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringConcat(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringEq(Ctx& ctx, Index pos, StringEqOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringAs(Ctx& ctx, Index pos, StringAsOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringWTF8Advance(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringWTF16Get(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringIterNext(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringIterMove(Ctx& ctx, Index pos, StringIterMoveOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringSliceWTF(Ctx& ctx, Index pos, StringSliceWTFOp op) {
  return ctx.in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringSliceIter(Ctx& ctx, Index pos) {
  return ctx.in.err("unimplemented instruction");
}

// =======
// Modules
// =======

// typeidx ::= x:u32 => x
//           | v:id  => x (if types[x] = v)
template<typename Ctx> MaybeResult<Index> maybeTypeidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return *x;
  }
  if (auto id = ctx.in.takeID()) {
    // TODO: Fix position to point to start of id, not next element.
    auto idx = ctx.getTypeIndex(*id);
    CHECK_ERR(idx);
    return *idx;
  }
  return {};
}

template<typename Ctx> Result<typename Ctx::HeapTypeT> typeidx(Ctx& ctx) {
  if (auto idx = maybeTypeidx(ctx)) {
    CHECK_ERR(idx);
    return ctx.getHeapTypeFromIdx(*idx);
  }
  return ctx.in.err("expected type index or identifier");
}

// fieldidx_t ::= x:u32 => x
//              | v:id  => x (if t.fields[x] = v)
template<typename Ctx>
Result<typename Ctx::FieldIdxT> fieldidx(Ctx& ctx,
                                         typename Ctx::HeapTypeT type) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getFieldFromIdx(type, *x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getFieldFromName(type, *id);
  }
  return ctx.in.err("expected field index or identifier");
}

// memidx ::= x:u32 => x
//          | v:id  => x (if memories[x] = v)
template<typename Ctx>
MaybeResult<typename Ctx::MemoryIdxT> maybeMemidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getMemoryFromIdx(*x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getMemoryFromName(*id);
  }
  return {};
}

template<typename Ctx> Result<typename Ctx::MemoryIdxT> memidx(Ctx& ctx) {
  if (auto idx = maybeMemidx(ctx)) {
    CHECK_ERR(idx);
    return *idx;
  }
  return ctx.in.err("expected memory index or identifier");
}

// memuse ::= '(' 'memory' x:memidx ')' => x
template<typename Ctx>
MaybeResult<typename Ctx::MemoryIdxT> maybeMemuse(Ctx& ctx) {
  if (!ctx.in.takeSExprStart("memory"sv)) {
    return {};
  }
  auto idx = memidx(ctx);
  CHECK_ERR(idx);
  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of memory use");
  }
  return *idx;
}

// globalidx ::= x:u32 => x
//             | v:id  => x (if globals[x] = v)
template<typename Ctx> Result<typename Ctx::GlobalIdxT> globalidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getGlobalFromIdx(*x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getGlobalFromName(*id);
  }
  return ctx.in.err("expected global index or identifier");
}

// dataidx ::= x:u32 => x
//           | v:id => x (if data[x] = v)
template<typename Ctx> Result<typename Ctx::DataIdxT> dataidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getDataFromIdx(*x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getDataFromName(*id);
  }
  return ctx.in.err("expected data index or identifier");
}

// localidx ::= x:u32 => x
//            | v:id  => x (if locals[x] = v)
template<typename Ctx> Result<typename Ctx::LocalIdxT> localidx(Ctx& ctx) {
  if (auto x = ctx.in.takeU32()) {
    return ctx.getLocalFromIdx(*x);
  }
  if (auto id = ctx.in.takeID()) {
    return ctx.getLocalFromName(*id);
  }
  return ctx.in.err("expected local index or identifier");
}

// typeuse ::= '(' 'type' x:typeidx ')'                                => x, []
//                 (if typedefs[x] = [t1*] -> [t2*]
//           | '(' 'type' x:typeidx ')' ((t1,IDs):param)* (t2:result)* => x, IDs
//                 (if typedefs[x] = [t1*] -> [t2*])
//           | ((t1,IDs):param)* (t2:result)*                          => x, IDs
//                 (if x is minimum s.t. typedefs[x] = [t1*] -> [t2*])
template<typename Ctx> Result<typename Ctx::TypeUseT> typeuse(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  std::optional<typename Ctx::HeapTypeT> type;
  if (ctx.in.takeSExprStart("type"sv)) {
    auto x = typeidx(ctx);
    CHECK_ERR(x);

    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of type use");
    }

    type = *x;
  }

  auto namedParams = params(ctx);
  CHECK_ERR(namedParams);

  auto resultTypes = results(ctx);
  CHECK_ERR(resultTypes);

  return ctx.makeTypeUse(pos, type, namedParams.getPtr(), resultTypes.getPtr());
}

// ('(' 'import' mod:name nm:name ')')?
MaybeResult<ImportNames> inlineImport(ParseInput& in) {
  if (!in.takeSExprStart("import"sv)) {
    return {};
  }
  auto mod = in.takeName();
  if (!mod) {
    return in.err("expected import module");
  }
  auto nm = in.takeName();
  if (!nm) {
    return in.err("expected import name");
  }
  if (!in.takeRParen()) {
    return in.err("expected end of import");
  }
  // TODO: Return Ok when parsing Decls.
  return {{*mod, *nm}};
}

// ('(' 'export' name ')')*
Result<std::vector<Name>> inlineExports(ParseInput& in) {
  std::vector<Name> exports;
  while (in.takeSExprStart("export"sv)) {
    auto name = in.takeName();
    if (!name) {
      return in.err("expected export name");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of import");
    }
    exports.push_back(*name);
  }
  return exports;
}

// strtype ::= ft:functype   => ft
//           | st:structtype => st
//           | at:arraytype  => at
template<typename Ctx> Result<> strtype(Ctx& ctx) {
  if (auto type = functype(ctx)) {
    CHECK_ERR(type);
    ctx.addFuncType(*type);
    return Ok{};
  }
  if (auto type = structtype(ctx)) {
    CHECK_ERR(type);
    ctx.addStructType(*type);
    return Ok{};
  }
  if (auto type = arraytype(ctx)) {
    CHECK_ERR(type);
    ctx.addArrayType(*type);
    return Ok{};
  }
  return ctx.in.err("expected type description");
}

// subtype ::= '(' 'type' id? '(' 'sub' typeidx? strtype ')' ')'
//           | '(' 'type' id? strtype ')'
template<typename Ctx> MaybeResult<> subtype(Ctx& ctx) {
  auto pos = ctx.in.getPos();

  if (!ctx.in.takeSExprStart("type"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  if (ctx.in.takeSExprStart("sub"sv)) {
    if (auto super = maybeTypeidx(ctx)) {
      CHECK_ERR(super);
      CHECK_ERR(ctx.addSubtype(*super));
    }

    CHECK_ERR(strtype(ctx));

    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of subtype definition");
    }
  } else {
    CHECK_ERR(strtype(ctx));
  }

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of type definition");
  }

  ctx.finishSubtype(name, pos);
  return Ok{};
}

// deftype ::= '(' 'rec' subtype* ')'
//           | subtype
template<typename Ctx> MaybeResult<> deftype(Ctx& ctx) {
  auto pos = ctx.in.getPos();

  if (ctx.in.takeSExprStart("rec"sv)) {
    size_t startIndex = ctx.getRecGroupStartIndex();
    size_t groupLen = 0;
    while (auto type = subtype(ctx)) {
      CHECK_ERR(type);
      ++groupLen;
    }
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected type definition or end of recursion group");
    }
    ctx.addRecGroup(startIndex, groupLen);
  } else if (auto type = subtype(ctx)) {
    CHECK_ERR(type);
  } else {
    return {};
  }

  ctx.finishDeftype(pos);
  return Ok{};
}

// local  ::= '(' 'local id? t:valtype ')' => [t]
//          | '(' 'local t*:valtype* ')' => [t*]
// locals ::= local*
template<typename Ctx> MaybeResult<typename Ctx::LocalsT> locals(Ctx& ctx) {
  bool hasAny = false;
  auto res = ctx.makeLocals();
  while (ctx.in.takeSExprStart("local"sv)) {
    hasAny = true;
    if (auto id = ctx.in.takeID()) {
      // Single named local
      auto type = valtype(ctx);
      CHECK_ERR(type);
      if (!ctx.in.takeRParen()) {
        return ctx.in.err("expected end of local");
      }
      ctx.appendLocal(res, *id, *type);
    } else {
      // Repeated unnamed locals
      while (!ctx.in.takeRParen()) {
        auto type = valtype(ctx);
        CHECK_ERR(type);
        ctx.appendLocal(res, {}, *type);
      }
    }
  }
  if (hasAny) {
    return res;
  }
  return {};
}

// func ::= '(' 'func' id? ('(' 'export' name ')')*
//              x,I:typeuse t*:vec(local) (in:instr)* ')'
//        | '(' 'func' id? ('(' 'export' name ')')*
//              '(' 'import' mod:name nm:name ')' typeuse ')'
template<typename Ctx> MaybeResult<> func(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  if (!ctx.in.takeSExprStart("func"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(ctx.in);
  CHECK_ERR(exports);

  auto import = inlineImport(ctx.in);
  CHECK_ERR(import);

  auto type = typeuse(ctx);
  CHECK_ERR(type);

  std::optional<typename Ctx::LocalsT> localVars;
  if (!import) {
    if (auto l = locals(ctx)) {
      CHECK_ERR(l);
      localVars = *l;
    }
  }

  std::optional<typename Ctx::InstrsT> insts;
  if (!import) {
    auto i = instrs(ctx);
    CHECK_ERR(i);
    insts = *i;
  }

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of function");
  }

  CHECK_ERR(
    ctx.addFunc(name, *exports, import.getPtr(), *type, localVars, insts, pos));
  return Ok{};
}

// mem ::= '(' 'memory' id? ('(' 'export' name ')')*
//             ('(' 'data' b:datastring ')' | memtype) ')'
//       | '(' 'memory' id? ('(' 'export' name ')')*
//             '(' 'import' mod:name nm:name ')' memtype ')'
template<typename Ctx> MaybeResult<> memory(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  if (!ctx.in.takeSExprStart("memory"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(ctx.in);
  CHECK_ERR(exports);

  auto import = inlineImport(ctx.in);
  CHECK_ERR(import);

  std::optional<typename Ctx::MemTypeT> mtype;
  std::optional<typename Ctx::DataStringT> data;
  if (ctx.in.takeSExprStart("data"sv)) {
    if (import) {
      return ctx.in.err("imported memories cannot have inline data");
    }
    auto datastr = datastring(ctx);
    CHECK_ERR(datastr);
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of inline data");
    }
    mtype = ctx.makeMemType(Type::i32, ctx.getLimitsFromData(*datastr), false);
    data = *datastr;
  } else {
    auto type = memtype(ctx);
    CHECK_ERR(type);
    mtype = *type;
  }

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of memory declaration");
  }

  CHECK_ERR(ctx.addMemory(name, *exports, import.getPtr(), *mtype, pos));

  if (data) {
    CHECK_ERR(ctx.addImplicitData(std::move(*data)));
  }

  return Ok{};
}

// global ::= '(' 'global' id? ('(' 'export' name ')')* gt:globaltype e:expr ')'
//          | '(' 'global' id? ('(' 'export' name ')')*
//                '(' 'import' mod:name nm:name ')' gt:globaltype ')'
template<typename Ctx> MaybeResult<> global(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  if (!ctx.in.takeSExprStart("global"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(ctx.in);
  CHECK_ERR(exports);

  auto import = inlineImport(ctx.in);
  CHECK_ERR(import);

  auto type = globaltype(ctx);
  CHECK_ERR(type);

  std::optional<typename Ctx::ExprT> exp;
  if (!import) {
    auto e = expr(ctx);
    CHECK_ERR(e);
    exp = *e;
  }

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of global");
  }

  CHECK_ERR(ctx.addGlobal(name, *exports, import.getPtr(), *type, exp, pos));
  return Ok{};
}

// datastring ::= (b:string)* => concat(b*)
template<typename Ctx> Result<typename Ctx::DataStringT> datastring(Ctx& ctx) {
  auto data = ctx.makeDataString();
  while (auto str = ctx.in.takeString()) {
    ctx.appendDataString(data, *str);
  }
  return data;
}

// data ::= '(' 'data' id? b*:datastring ')' => {init b*, mode passive}
//        | '(' 'data' id? x:memuse? ('(' 'offset' e:expr ')' | e:instr)
//               b*:datastring ')
//             => {init b*, mode active {memory x, offset e}}
template<typename Ctx> MaybeResult<> data(Ctx& ctx) {
  auto pos = ctx.in.getPos();
  if (!ctx.in.takeSExprStart("data"sv)) {
    return {};
  }

  Name name;
  if (auto id = ctx.in.takeID()) {
    name = *id;
  }

  auto mem = maybeMemuse(ctx);
  CHECK_ERR(mem);

  std::optional<typename Ctx::ExprT> offset;
  if (ctx.in.takeSExprStart("offset"sv)) {
    auto e = expr(ctx);
    CHECK_ERR(e);
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of offset expression");
    }
    offset = *e;
  } else if (ctx.in.takeLParen()) {
    auto inst = instr(ctx);
    CHECK_ERR(inst);
    offset = ctx.instrToExpr(*inst);
    if (!ctx.in.takeRParen()) {
      return ctx.in.err("expected end of offset instruction");
    }
  }

  if (mem && !offset) {
    return ctx.in.err("expected offset for active segment");
  }

  auto str = datastring(ctx);
  CHECK_ERR(str);

  if (!ctx.in.takeRParen()) {
    return ctx.in.err("expected end of data segment");
  }

  CHECK_ERR(ctx.addData(name, mem.getPtr(), offset, std::move(*str), pos));

  return Ok{};
}

// modulefield ::= deftype
//               | import
//               | func
//               | table
//               | memory
//               | global
//               | export
//               | start
//               | elem
//               | data
MaybeResult<> modulefield(ParseDeclsCtx& ctx) {
  if (auto t = ctx.in.peek(); !t || t->isRParen()) {
    return {};
  }
  if (auto res = deftype(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = func(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = memory(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = global(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = data(ctx)) {
    CHECK_ERR(res);
    return Ok{};
  }
  return ctx.in.err("unrecognized module field");
}

// module ::= '(' 'module' id? (m:modulefield)* ')'
//          | (m:modulefield)* eof
Result<> module(ParseDeclsCtx& ctx) {
  bool outer = ctx.in.takeSExprStart("module"sv);

  if (outer) {
    if (auto id = ctx.in.takeID()) {
      ctx.wasm.name = *id;
    }
  }

  while (auto field = modulefield(ctx)) {
    CHECK_ERR(field);
  }

  if (outer && !ctx.in.takeRParen()) {
    return ctx.in.err("expected end of module");
  }

  return Ok{};
}

} // anonymous namespace

Result<> parseModule(Module& wasm, std::string_view input) {
  // Parse module-level declarations.
  ParseDeclsCtx decls(input, wasm);
  CHECK_ERR(module(decls));
  if (!decls.in.empty()) {
    return decls.in.err("Unexpected tokens after module");
  }

  auto typeIndices = createIndexMap(decls.in, decls.subtypeDefs);
  CHECK_ERR(typeIndices);

  // Parse type definitions.
  std::vector<HeapType> types;
  {
    TypeBuilder builder(decls.subtypeDefs.size());
    ParseTypeDefsCtx ctx(input, builder, *typeIndices);
    for (auto& typeDef : decls.typeDefs) {
      WithPosition with(ctx, typeDef.pos);
      CHECK_ERR(deftype(ctx));
    }
    auto built = builder.build();
    if (auto* err = built.getError()) {
      std::stringstream msg;
      msg << "invalid type: " << err->reason;
      return ctx.in.err(decls.typeDefs[err->index].pos, msg.str());
    }
    types = *built;
    // Record type names on the module.
    for (size_t i = 0; i < types.size(); ++i) {
      auto& names = ctx.names[i];
      if (names.name.is() || names.fieldNames.size()) {
        wasm.typeNames.insert({types[i], names});
      }
    }
  }

  // Parse implicit type definitions and map typeuses without explicit types to
  // the correct types.
  std::unordered_map<Index, HeapType> implicitTypes;
  {
    ParseImplicitTypeDefsCtx ctx(input, types, implicitTypes, *typeIndices);
    for (Index pos : decls.implicitTypeDefs) {
      WithPosition with(ctx, pos);
      CHECK_ERR(typeuse(ctx));
    }
  }

  {
    // Parse module-level types.
    ParseModuleTypesCtx ctx(input, wasm, types, implicitTypes, *typeIndices);
    CHECK_ERR(parseDefs(ctx, decls.funcDefs, func));
    CHECK_ERR(parseDefs(ctx, decls.memoryDefs, memory));
    CHECK_ERR(parseDefs(ctx, decls.globalDefs, global));
    // TODO: Parse types of other module elements.
  }
  {
    // Parse definitions.
    // TODO: Parallelize this.
    ParseDefsCtx ctx(input, wasm, types, implicitTypes, *typeIndices);
    CHECK_ERR(parseDefs(ctx, decls.globalDefs, global));
    CHECK_ERR(parseDefs(ctx, decls.dataDefs, data));

    for (Index i = 0; i < decls.funcDefs.size(); ++i) {
      ctx.index = i;
      ctx.func = wasm.functions[i].get();
      ctx.pushScope(ctx.func->getResults());
      WithPosition with(ctx, decls.funcDefs[i].pos);
      auto parsed = func(ctx);
      CHECK_ERR(parsed);
      assert(parsed);
    }
  }

  return Ok{};
}

} // namespace wasm::WATParser
