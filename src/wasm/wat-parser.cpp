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

  ParseInput(std::string_view in) : lexer(in) {}

  ParseInput(std::string_view in, size_t index) : lexer(in) {
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

  std::optional<uint64_t> takeU64() {
    if (auto t = peek()) {
      if (auto n = t->getU64()) {
        ++lexer;
        return n;
      }
    }
    return {};
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
    return {};
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

  std::optional<double> takeF64() {
    if (auto t = peek()) {
      if (auto d = t->getF64()) {
        ++lexer;
        return d;
      }
    }
    return {};
  }

  std::optional<float> takeF32() {
    if (auto t = peek()) {
      if (auto f = t->getF32()) {
        ++lexer;
        return f;
      }
    }
    return {};
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

  [[nodiscard]] Err err(std::string reason) {
    std::stringstream msg;
    msg << lexer.position(lexer.getIndex()) << ": error: " << reason;
    return Err{msg.str()};
  }
};

// =========
// Utilities
// =========

// The location and possible name of a module-level definition in the input.
struct DefPos {
  Name name;
  Index pos;
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

using IndexMap = std::unordered_map<Name, Index>;

void applyImportNames(Importable& item,
                      const std::optional<ImportNames>& names) {
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

Result<IndexMap> createIndexMap(std::string_view input,
                                const std::vector<DefPos>& defs) {
  IndexMap indices;
  for (Index i = 0; i < defs.size(); ++i) {
    if (defs[i].name.is()) {
      if (!indices.insert({defs[i].name, i}).second) {
        return ParseInput(input, defs[i].pos).err("duplicate element name");
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
                   std::string_view input,
                   const std::vector<DefPos>& defs,
                   MaybeResult<> (*parser)(Ctx&, ParseInput&)) {
  for (Index i = 0; i < defs.size(); ++i) {
    ctx.index = i;
    ParseInput in(input, defs[i].pos);
    auto parsed = parser(ctx, in);
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
  using ResultsT = Ok;
  using SignatureT = Ok;
  using StorageT = Ok;
  using FieldT = Ok;
  using FieldsT = Ok;
  using StructT = Ok;
  using ArrayT = Ok;
  using GlobalTypeT = Ok;
  using TypeUseT = Ok;
  using LocalsT = Ok;

  HeapTypeT makeFunc() { return Ok{}; }
  HeapTypeT makeAny() { return Ok{}; }
  HeapTypeT makeExtern() { return Ok{}; }
  HeapTypeT makeEq() { return Ok{}; }
  HeapTypeT makeI31() { return Ok{}; }
  HeapTypeT makeData() { return Ok{}; }

  TypeT makeI32() { return Ok{}; }
  TypeT makeI64() { return Ok{}; }
  TypeT makeF32() { return Ok{}; }
  TypeT makeF64() { return Ok{}; }
  TypeT makeV128() { return Ok{}; }

  TypeT makeRefType(HeapTypeT, Nullability) { return Ok{}; }

  ParamsT makeParams() { return Ok{}; }
  void appendParam(ParamsT&, Name, TypeT) {}

  ResultsT makeResults() { return Ok{}; }
  void appendResult(ResultsT&, TypeT) {}

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

  Result<Index> getTypeIndex(Name, ParseInput&) { return 1; }
  Result<HeapTypeT> getHeapTypeFromIdx(Index, ParseInput&) { return Ok{}; }
};

template<typename Ctx> struct TypeParserCtx {
  using IndexT = Index;
  using HeapTypeT = HeapType;
  using TypeT = Type;
  using ParamsT = std::vector<NameType>;
  using ResultsT = std::vector<Type>;
  using SignatureT = Signature;
  using StorageT = Field;
  using FieldT = Field;
  using FieldsT = std::pair<std::vector<Name>, std::vector<Field>>;
  using StructT = std::pair<std::vector<Name>, Struct>;
  using ArrayT = Array;
  using LocalsT = std::vector<NameType>;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;

  TypeParserCtx(const IndexMap& typeIndices) : typeIndices(typeIndices) {}

  Ctx& self() { return *static_cast<Ctx*>(this); }

  HeapTypeT makeFunc() { return HeapType::func; }
  HeapTypeT makeAny() { return HeapType::any; }
  HeapTypeT makeExtern() { return HeapType::ext; }
  HeapTypeT makeEq() { return HeapType::eq; }
  HeapTypeT makeI31() { return HeapType::i31; }
  HeapTypeT makeData() { return HeapType::data; }

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

  Result<Index> getTypeIndex(Name id, ParseInput& in) {
    auto it = typeIndices.find(id);
    if (it == typeIndices.end()) {
      return in.err("unknown type identifier");
    }
    return it->second;
  }
};

struct NullInstrParserCtx {
  using InstrT = Ok;
  using InstrsT = Ok;
  using ExprT = Ok;

  InstrsT makeInstrs() { return Ok{}; }
  void appendInstr(InstrsT&, InstrT) {}

  ExprT makeExpr(InstrsT) { return Ok{}; }

  InstrT makeUnreachable() { return Ok{}; }
  InstrT makeNop() { return Ok{}; }

  InstrT makeI32Const(uint32_t) { return Ok{}; }
  InstrT makeI64Const(uint64_t) { return Ok{}; }
  InstrT makeF32Const(float) { return Ok{}; }
  InstrT makeF64Const(double) { return Ok{}; }

  template<typename HeapTypeT> InstrT makeRefNull(HeapTypeT) { return {}; }
};

template<typename Ctx> struct InstrParserCtx : TypeParserCtx<Ctx> {
  using InstrT = Expression*;
  using InstrsT = std::vector<Expression*>;
  using ExprT = Expression*;

  Builder builder;

  InstrParserCtx(Module& wasm, const IndexMap& typeIndices)
    : TypeParserCtx<Ctx>(typeIndices), builder(wasm) {}

  InstrsT makeInstrs() { return {}; }
  void appendInstr(InstrsT& instrs, InstrT instr) { instrs.push_back(instr); }

  ExprT makeExpr(InstrsT& instrs) {
    switch (instrs.size()) {
      case 0:
        return builder.makeNop();
      case 1:
        return instrs.front();
      default:
        return builder.makeBlock(instrs);
    }
  }

  InstrT makeUnreachable() { return builder.makeUnreachable(); }
  InstrT makeNop() { return builder.makeNop(); }

  InstrT makeI32Const(uint32_t c) { return builder.makeConst(Literal(c)); }
  InstrT makeI64Const(uint64_t c) { return builder.makeConst(Literal(c)); }
  InstrT makeF32Const(float c) { return builder.makeConst(Literal(c)); }
  InstrT makeF64Const(double c) { return builder.makeConst(Literal(c)); }

  InstrT makeRefNull(typename TypeParserCtx<Ctx>::HeapTypeT type) {
    return builder.makeRefNull(type);
  }
};

// Phase 1: Parse definition spans for top-level module elements and determine
// their indices and names.
struct ParseDeclsCtx : NullTypeParserCtx, NullInstrParserCtx {
  // At this stage we only look at types to find implicit type definitions,
  // which are inserted directly in to the context. We cannot materialize or
  // validate any types because we don't know what types exist yet.

  // Declared module elements are inserted into the module, but their bodies are
  // not filled out until later parsing phases.
  Module& wasm;

  // The module element definitions we are parsing in this phase.
  std::vector<DefPos> typeDefs;
  std::vector<DefPos> subtypeDefs;
  std::vector<DefPos> funcDefs;
  std::vector<DefPos> globalDefs;

  // Positions of typeuses that might implicitly define new types.
  std::vector<Index> implicitTypeDefs;

  // Counters used for generating names for module elements.
  int globalCounter = 0;
  int funcCounter = 0;

  // Used to verify that all imports come before all non-imports.
  bool hasNonImport = false;

  ParseDeclsCtx(Module& wasm) : wasm(wasm) {}

  void addFuncType(SignatureT) {}
  void addStructType(StructT) {}
  void addArrayType(ArrayT) {}
  Result<> addSubtype(Index, ParseInput&) { return Ok{}; }
  void finishSubtype(Name name, Index pos) {
    subtypeDefs.push_back({name, pos});
  }
  size_t getRecGroupStartIndex() { return 0; }
  void addRecGroup(Index, size_t) {}
  void finishDeftype(Index pos) { typeDefs.push_back({{}, pos}); }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT> type,
                               ParamsT*,
                               ResultsT*,
                               ParseInput&) {
    if (!type) {
      implicitTypeDefs.push_back(pos);
    }
    return Ok{};
  }

  Result<Function*> addFuncDecl(ParseInput& in,
                                Name name,
                                std::optional<ImportNames> importNames) {
    auto f = std::make_unique<Function>();
    if (name.is()) {
      if (wasm.getFunctionOrNull(name)) {
        // TDOO: if the existing function is not explicitly named, fix its name
        // and continue.
        // TODO: Fix error location to point to name.
        return in.err("repeated function name");
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
                   Index pos,
                   ParseInput& in) {
    if (import && hasNonImport) {
      return in.err("import after non-import");
    }
    auto imp = import ? std::make_optional(*import) : std::nullopt;
    auto f = addFuncDecl(in, name, imp);
    CHECK_ERR(f);
    CHECK_ERR(addExports(in, wasm, *f, exports, ExternalKind::Function));
    funcDefs.push_back({name, pos});
    return Ok{};
  }

  Result<Global*> addGlobalDecl(ParseInput& in,
                                Name name,
                                std::optional<ImportNames> importNames) {
    auto g = std::make_unique<Global>();
    if (name.is()) {
      if (wasm.getGlobalOrNull(name)) {
        // TODO: if the existing global is not explicitly named, fix its name
        // and continue.
        // TODO: Fix error location to point to name.
        return in.err("repeated global name");
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
                     Index pos,
                     ParseInput& in) {
    if (import && hasNonImport) {
      return in.err("import after non-import");
    }
    auto imp = import ? std::make_optional(*import) : std::nullopt;
    auto g = addGlobalDecl(in, name, imp);
    CHECK_ERR(g);
    CHECK_ERR(addExports(in, wasm, *g, exports, ExternalKind::Global));
    globalDefs.push_back({name, pos});
    return Ok{};
  }
};

// Phase 2: Parse type definitions into a TypeBuilder.
struct ParseTypeDefsCtx : TypeParserCtx<ParseTypeDefsCtx> {
  // We update slots in this builder as we parse type definitions.
  TypeBuilder& builder;

  // Parse the names of types and fields as we go.
  std::vector<TypeNames> names;

  // The index of the subtype definition we are parsing.
  Index index = 0;

  ParseTypeDefsCtx(TypeBuilder& builder, const IndexMap& typeIndices)
    : TypeParserCtx<ParseTypeDefsCtx>(typeIndices), builder(builder),
      names(builder.size()) {}

  TypeT makeRefType(HeapTypeT ht, Nullability nullability) {
    return builder.getTempRefType(ht, nullability);
  }

  TypeT makeTupleType(const std::vector<Type> types) {
    return builder.getTempTupleType(types);
  }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx, ParseInput& in) {
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

  Result<> addSubtype(Index super, ParseInput& in) {
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

  // Types parsed so far.
  std::vector<HeapType>& types;

  // Map typeuse positions without an explicit type to the correct type.
  std::unordered_map<Index, HeapType>& implicitTypes;

  // Map signatures to the first defined heap type they match.
  std::unordered_map<Signature, HeapType> sigTypes;

  ParseImplicitTypeDefsCtx(std::vector<HeapType>& types,
                           std::unordered_map<Index, HeapType>& implicitTypes,
                           const IndexMap& typeIndices)
    : TypeParserCtx<ParseImplicitTypeDefsCtx>(typeIndices), types(types),
      implicitTypes(implicitTypes) {
    for (auto type : types) {
      if (type.isSignature() && type.getRecGroup().size() == 1) {
        sigTypes.insert({type.getSignature(), type});
      }
    }
  }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx, ParseInput& in) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT>,
                               ParamsT* params,
                               ResultsT* results,
                               ParseInput& in) {
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

  Module& wasm;

  const std::vector<HeapType>& types;
  const std::unordered_map<Index, HeapType>& implicitTypes;

  // The index of the current type.
  Index index = 0;

  ParseModuleTypesCtx(Module& wasm,
                      const std::vector<HeapType>& types,
                      const std::unordered_map<Index, HeapType>& implicitTypes,
                      const IndexMap& typeIndices)
    : TypeParserCtx<ParseModuleTypesCtx>(typeIndices), wasm(wasm), types(types),
      implicitTypes(implicitTypes) {}

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx, ParseInput& in) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT> type,
                               ParamsT* params,
                               ResultsT* results,
                               ParseInput& in) {
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

  GlobalTypeT makeGlobalType(Mutability mutability, TypeT type) {
    return {mutability, type};
  }

  Result<> addFunc(Name name,
                   const std::vector<Name>&,
                   ImportNames*,
                   TypeUseT type,
                   std::optional<LocalsT> locals,
                   std::optional<InstrsT>,
                   Index,
                   ParseInput&) {
    auto& f = wasm.functions[index];
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
    // TODO: local types and names.
    return Ok{};
  }

  Result<> addGlobal(Name,
                     const std::vector<Name>&,
                     ImportNames*,
                     GlobalTypeT type,
                     std::optional<ExprT>,
                     Index,
                     ParseInput&) {
    auto& g = wasm.globals[index];
    g->mutable_ = type.mutability;
    g->type = type.type;
    return Ok{};
  }
};

// Phase 5: Parse module element definitions, including instructions.
struct ParseDefsCtx : InstrParserCtx<ParseDefsCtx> {
  using GlobalTypeT = Ok;
  using TypeUseT = HeapType;

  using InstrT = Expression*;
  using InstrsT = std::vector<Expression*>;
  using ExprT = Expression*;

  Module& wasm;

  // A stack of stacks of fully-parsed instructions.
  std::vector<std::vector<Expression*>> instrStack;

  const std::vector<HeapType>& types;
  const std::unordered_map<Index, HeapType>& implicitTypes;

  // The index of the current module element.
  Index index = 0;

  ParseDefsCtx(Module& wasm,
               const std::vector<HeapType>& types,
               const std::unordered_map<Index, HeapType>& implicitTypes,
               const IndexMap& typeIndices)
    : InstrParserCtx<ParseDefsCtx>(wasm, typeIndices), wasm(wasm), types(types),
      implicitTypes(implicitTypes) {}

  GlobalTypeT makeGlobalType(Mutability, TypeT) { return Ok{}; }

  Result<HeapTypeT> getHeapTypeFromIdx(Index idx, ParseInput& in) {
    if (idx >= types.size()) {
      return in.err("type index out of bounds");
    }
    return types[idx];
  }

  Result<TypeUseT> makeTypeUse(Index pos,
                               std::optional<HeapTypeT> type,
                               ParamsT* params,
                               ResultsT* results,
                               ParseInput& in) {
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
        return in.err("type does not match provided signature");
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
                   Index,
                   ParseInput&) {
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
                     Index,
                     ParseInput&) {
    if (exp) {
      wasm.globals[index]->init = *exp;
    }
    return Ok{};
  }
};

// ================
// Parser Functions
// ================

// Types
template<typename Ctx>
Result<typename Ctx::HeapTypeT> heaptype(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::RefTypeT> reftype(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::TypeT> valtype(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::ParamsT> params(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::ResultsT> results(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::SignatureT> functype(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::FieldT> storagetype(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::FieldT> fieldtype(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::FieldsT> fields(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::StructT> structtype(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::ArrayT> arraytype(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::GlobalTypeT> globaltype(Ctx&, ParseInput&);

// Instructions
template<typename Ctx>
MaybeResult<typename Ctx::InstrT> instr(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::InstrsT> instrs(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::ExprT> expr(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::InstrT> makeUnreachable(Ctx&);
template<typename Ctx> Result<typename Ctx::InstrT> makeNop(Ctx&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeBinary(Ctx&, ParseInput&, BinaryOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeUnary(Ctx&, ParseInput&, UnaryOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeSelect(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::InstrT> makeDrop(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeMemorySize(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryGrow(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalGet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalTee(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalSet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeGlobalGet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeGlobalSet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeBlock(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeThenOrElse(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeConst(Ctx&, ParseInput&, Type type);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeLoad(Ctx&, ParseInput&, Type type, bool isAtomic);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStore(Ctx&, ParseInput&, Type type, bool isAtomic);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeAtomicRMWOrCmpxchg(Ctx&, ParseInput&, Type type);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeAtomicRMW(Ctx&, ParseInput&, Type type, uint8_t bytes, const char* extra);
template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicCmpxchg(
  Ctx&, ParseInput&, Type type, uint8_t bytes, const char* extra);
template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicWait(Ctx&, ParseInput&, Type type);
template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicNotify(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicFence(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDExtract(Ctx&, ParseInput&, SIMDExtractOp op, size_t lanes);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDReplace(Ctx&, ParseInput&, SIMDReplaceOp op, size_t lanes);
template<typename Ctx>
Result<typename Ctx::InstrT> makeSIMDShuffle(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDTernary(Ctx&, ParseInput&, SIMDTernaryOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeSIMDShift(Ctx&, ParseInput&, SIMDShiftOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeSIMDLoad(Ctx&, ParseInput&, SIMDLoadOp op);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDLoadStoreLane(Ctx&, ParseInput&, SIMDLoadStoreLaneOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryInit(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeDataDrop(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryCopy(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryFill(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::InstrT> makePush(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::InstrT> makePop(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::InstrT> makeIf(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeMaybeBlock(Ctx&, ParseInput&, size_t i, Type type);
template<typename Ctx> Result<typename Ctx::InstrT> makeLoop(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeCall(Ctx&, ParseInput&, bool isReturn);
template<typename Ctx>
Result<typename Ctx::InstrT> makeCallIndirect(Ctx&, ParseInput&, bool isReturn);
template<typename Ctx>
Result<typename Ctx::InstrT> makeBreak(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeBreakTable(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeReturn(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefNull(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefIs(Ctx&, ParseInput&, RefIsOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefFunc(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefEq(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeTableGet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeTableSet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeTableSize(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeTableGrow(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::InstrT> makeTry(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeTryOrCatchBody(Ctx&, ParseInput&, Type type, bool isTry);
template<typename Ctx>
Result<typename Ctx::InstrT> makeThrow(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRethrow(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeTupleMake(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeTupleExtract(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeCallRef(Ctx&, ParseInput&, bool isReturn);
template<typename Ctx>
Result<typename Ctx::InstrT> makeI31New(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeI31Get(Ctx&, ParseInput&, bool signed_);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefTest(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefTestStatic(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefCast(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefCastStatic(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefCastNopStatic(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeBrOn(Ctx&, ParseInput&, BrOnOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeBrOnStatic(Ctx&, ParseInput&, BrOnOp op);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStructNewStatic(Ctx&, ParseInput&, bool default_);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStructGet(Ctx&, ParseInput&, bool signed_ = false);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStructSet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeArrayNewStatic(Ctx&, ParseInput&, bool default_);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayInitStatic(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeArrayGet(Ctx&, ParseInput&, bool signed_ = false);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArraySet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayLen(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayCopy(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRefAs(Ctx&, ParseInput&, RefAsOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringNew(Ctx&, ParseInput&, StringNewOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringConst(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringMeasure(Ctx&, ParseInput&, StringMeasureOp op);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringEncode(Ctx&, ParseInput&, StringEncodeOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringConcat(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringEq(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringAs(Ctx&, ParseInput&, StringAsOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringWTF8Advance(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringWTF16Get(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringIterNext(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringIterMove(Ctx&, ParseInput&, StringIterMoveOp op);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringSliceWTF(Ctx&, ParseInput&, StringSliceWTFOp op);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStringSliceIter(Ctx&, ParseInput&);

// Modules
template<typename Ctx>
MaybeResult<Index> maybeTypeidx(Ctx& ctx, ParseInput& in);
template<typename Ctx>
Result<typename Ctx::HeapTypeT> typeidx(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::TypeUseT> typeuse(Ctx&, ParseInput&);
MaybeResult<ImportNames> inlineImport(ParseInput&);
Result<std::vector<Name>> inlineExports(ParseInput&);
template<typename Ctx> Result<> strtype(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::ModuleNameT> subtype(Ctx&, ParseInput&);
template<typename Ctx> MaybeResult<> deftype(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::LocalsT> locals(Ctx&, ParseInput&);
template<typename Ctx> MaybeResult<> func(Ctx&, ParseInput&);
template<typename Ctx> MaybeResult<> global(Ctx&, ParseInput&);
MaybeResult<> modulefield(ParseDeclsCtx&, ParseInput&);
Result<> module(ParseDeclsCtx&, ParseInput&);

// =====
// Types
// =====

// heaptype ::= x:typeidx => types[x]
//            | 'func'    => func
//            | 'extern'  => extern
template<typename Ctx>
Result<typename Ctx::HeapTypeT> heaptype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("func"sv)) {
    return ctx.makeFunc();
  }
  if (in.takeKeyword("any"sv)) {
    return ctx.makeAny();
  }
  if (in.takeKeyword("extern"sv)) {
    return ctx.makeExtern();
  }
  if (in.takeKeyword("eq"sv)) {
    return ctx.makeEq();
  }
  if (in.takeKeyword("i31"sv)) {
    return ctx.makeI31();
  }
  if (in.takeKeyword("data"sv)) {
    return ctx.makeData();
  }
  if (in.takeKeyword("array"sv)) {
    return in.err("array heap type not yet supported");
  }
  auto type = typeidx(ctx, in);
  CHECK_ERR(type);
  return *type;
}

// reftype ::= 'funcref'   => funcref
//           | 'externref' => externref
//           | 'anyref'    => anyref
//           | 'eqref'     => eqref
//           | 'i31ref'    => i31ref
//           | 'dataref'   => dataref
//           | 'arrayref'  => arrayref
//           | '(' ref null? t:heaptype ')' => ref null? t
template<typename Ctx>
MaybeResult<typename Ctx::TypeT> reftype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("funcref"sv)) {
    return ctx.makeRefType(ctx.makeFunc(), Nullable);
  }
  if (in.takeKeyword("externref"sv)) {
    return ctx.makeRefType(ctx.makeExtern(), Nullable);
  }
  if (in.takeKeyword("anyref"sv)) {
    return ctx.makeRefType(ctx.makeAny(), Nullable);
  }
  if (in.takeKeyword("eqref"sv)) {
    return ctx.makeRefType(ctx.makeEq(), Nullable);
  }
  if (in.takeKeyword("i31ref"sv)) {
    return ctx.makeRefType(ctx.makeI31(), Nullable);
  }
  if (in.takeKeyword("dataref"sv)) {
    return ctx.makeRefType(ctx.makeData(), Nullable);
  }
  if (in.takeKeyword("arrayref"sv)) {
    return in.err("arrayref not yet supported");
  }

  if (!in.takeSExprStart("ref"sv)) {
    return {};
  }

  auto nullability = in.takeKeyword("null"sv) ? Nullable : NonNullable;

  auto type = heaptype(ctx, in);
  CHECK_ERR(type);

  if (!in.takeRParen()) {
    return in.err("expected end of reftype");
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
template<typename Ctx>
Result<typename Ctx::TypeT> valtype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("i32"sv)) {
    return ctx.makeI32();
  } else if (in.takeKeyword("i64"sv)) {
    return ctx.makeI64();
  } else if (in.takeKeyword("f32"sv)) {
    return ctx.makeF32();
  } else if (in.takeKeyword("f64"sv)) {
    return ctx.makeF64();
  } else if (in.takeKeyword("v128"sv)) {
    return ctx.makeV128();
  } else if (auto type = reftype(ctx, in)) {
    CHECK_ERR(type);
    return *type;
  } else {
    return in.err("expected valtype");
  }
}

// param  ::= '(' 'param id? t:valtype ')' => [t]
//          | '(' 'param t*:valtype* ')' => [t*]
// params ::= param*
template<typename Ctx>
MaybeResult<typename Ctx::ParamsT> params(Ctx& ctx, ParseInput& in) {
  bool hasAny = false;
  auto res = ctx.makeParams();
  while (in.takeSExprStart("param"sv)) {
    hasAny = true;
    if (auto id = in.takeID()) {
      // Single named param
      auto type = valtype(ctx, in);
      CHECK_ERR(type);
      if (!in.takeRParen()) {
        return in.err("expected end of param");
      }
      ctx.appendParam(res, *id, *type);
    } else {
      // Repeated unnamed params
      while (!in.takeRParen()) {
        auto type = valtype(ctx, in);
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
template<typename Ctx>
MaybeResult<typename Ctx::ResultsT> results(Ctx& ctx, ParseInput& in) {
  bool hasAny = false;
  auto res = ctx.makeResults();
  while (in.takeSExprStart("result"sv)) {
    hasAny = true;
    while (!in.takeRParen()) {
      auto type = valtype(ctx, in);
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
MaybeResult<typename Ctx::SignatureT> functype(Ctx& ctx, ParseInput& in) {
  if (!in.takeSExprStart("func"sv)) {
    return {};
  }

  auto parsedParams = params(ctx, in);
  CHECK_ERR(parsedParams);

  auto parsedResults = results(ctx, in);
  CHECK_ERR(parsedResults);

  if (!in.takeRParen()) {
    return in.err("expected end of functype");
  }

  return ctx.makeFuncType(parsedParams.getPtr(), parsedResults.getPtr());
}

// storagetype ::= valtype | packedtype
// packedtype  ::= i8 | i16
template<typename Ctx>
Result<typename Ctx::FieldT> storagetype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("i8"sv)) {
    return ctx.makeI8();
  }
  if (in.takeKeyword("i16"sv)) {
    return ctx.makeI16();
  }
  auto type = valtype(ctx, in);
  CHECK_ERR(type);
  return ctx.makeStorageType(*type);
}

// fieldtype   ::= t:storagetype               => const t
//               | '(' 'mut' t:storagetype ')' => var t
template<typename Ctx>
Result<typename Ctx::FieldT> fieldtype(Ctx& ctx, ParseInput& in) {
  auto mutability = Immutable;
  if (in.takeSExprStart("mut"sv)) {
    mutability = Mutable;
  }

  auto field = storagetype(ctx, in);
  CHECK_ERR(field);

  if (mutability == Mutable) {
    if (!in.takeRParen()) {
      return in.err("expected end of field type");
    }
  }

  return ctx.makeFieldType(*field, mutability);
}

// field ::= '(' 'field' id t:fieldtype ')' => [(id, t)]
//         | '(' 'field' t*:fieldtype* ')'  => [(_, t*)*]
//         | fieldtype
template<typename Ctx>
Result<typename Ctx::FieldsT> fields(Ctx& ctx, ParseInput& in) {
  auto res = ctx.makeFields();
  while (true) {
    if (auto t = in.peek(); !t || t->isRParen()) {
      return res;
    }
    if (in.takeSExprStart("field")) {
      if (auto id = in.takeID()) {
        auto field = fieldtype(ctx, in);
        CHECK_ERR(field);
        if (!in.takeRParen()) {
          return in.err("expected end of field");
        }
        ctx.appendField(res, *id, *field);
      } else {
        while (!in.takeRParen()) {
          auto field = fieldtype(ctx, in);
          CHECK_ERR(field);
          ctx.appendField(res, {}, *field);
        }
      }
    } else {
      auto field = fieldtype(ctx, in);
      CHECK_ERR(field);
      ctx.appendField(res, {}, *field);
    }
  }
}

// structtype ::= '(' 'struct' field* ')'
template<typename Ctx>
MaybeResult<typename Ctx::StructT> structtype(Ctx& ctx, ParseInput& in) {
  if (!in.takeSExprStart("struct"sv)) {
    return {};
  }
  auto namedFields = fields(ctx, in);
  CHECK_ERR(namedFields);
  if (!in.takeRParen()) {
    return in.err("expected end of struct definition");
  }

  return ctx.makeStruct(*namedFields);
}

// arraytype ::= '(' 'array' field ')'
template<typename Ctx>
MaybeResult<typename Ctx::ArrayT> arraytype(Ctx& ctx, ParseInput& in) {
  if (!in.takeSExprStart("array"sv)) {
    return {};
  }
  auto namedFields = fields(ctx, in);
  CHECK_ERR(namedFields);
  if (!in.takeRParen()) {
    return in.err("expected end of array definition");
  }

  if (auto array = ctx.makeArray(*namedFields)) {
    return *array;
  }
  return in.err("expected exactly one field in array definition");
}

// globaltype ::= t:valtype               => const t
//              | '(' 'mut' t:valtype ')' => var t
template<typename Ctx>
Result<typename Ctx::GlobalTypeT> globaltype(Ctx& ctx, ParseInput& in) {
  auto mutability = Immutable;
  if (in.takeSExprStart("mut"sv)) {
    mutability = Mutable;
  }

  auto type = valtype(ctx, in);
  CHECK_ERR(type);

  if (mutability == Mutable && !in.takeRParen()) {
    return in.err("expected end of globaltype");
  }

  return ctx.makeGlobalType(mutability, *type);
}

// ============
// Instructions
// ============

template<typename Ctx>
MaybeResult<typename Ctx::InstrT> instr(Ctx& ctx, ParseInput& in) {
  auto keyword = in.takeKeyword();
  if (!keyword) {
    return {};
  }

  auto op = *keyword;

#define NEW_INSTRUCTION_PARSER
#define NEW_WAT_PARSER
#include <gen-s-parser.inc>
}

template<typename Ctx>
Result<typename Ctx::InstrsT> instrs(Ctx& ctx, ParseInput& in) {
  auto insts = ctx.makeInstrs();
  while (auto inst = instr(ctx, in)) {
    CHECK_ERR(inst);
    ctx.appendInstr(insts, *inst);
  }
  return insts;
}

template<typename Ctx>
Result<typename Ctx::ExprT> expr(Ctx& ctx, ParseInput& in) {
  auto insts = instrs(ctx, in);
  CHECK_ERR(insts);
  return ctx.makeExpr(*insts);
}

template<typename Ctx> Result<typename Ctx::InstrT> makeUnreachable(Ctx& ctx) {
  return ctx.makeUnreachable();
}

template<typename Ctx> Result<typename Ctx::InstrT> makeNop(Ctx& ctx) {
  return ctx.makeNop();
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBinary(Ctx& ctx, ParseInput& in, BinaryOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeUnary(Ctx& ctx, ParseInput& in, UnaryOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeSelect(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeDrop(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemorySize(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryGrow(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalGet(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalTee(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLocalSet(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeGlobalGet(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeGlobalSet(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBlock(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeThenOrElse(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeConst(Ctx& ctx, ParseInput& in, Type type) {
  assert(type.isBasic());
  switch (type.getBasic()) {
    case Type::i32:
      if (auto c = in.takeI32()) {
        return ctx.makeI32Const(*c);
      }
      return in.err("expected i32");
    case Type::i64:
      if (auto c = in.takeI64()) {
        return ctx.makeI64Const(*c);
      }
      return in.err("expected i64");
    case Type::f32:
      if (auto c = in.takeF32()) {
        return ctx.makeF32Const(*c);
      }
      return in.err("expected f32");
    case Type::f64:
      if (auto c = in.takeF64()) {
        return ctx.makeF64Const(*c);
      }
      return in.err("expected f64");
    case Type::v128:
      return in.err("unimplemented instruction");
    case Type::none:
    case Type::unreachable:
      break;
  }
  WASM_UNREACHABLE("unexpected type");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeLoad(Ctx& ctx, ParseInput& in, Type type, bool isAtomic) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStore(Ctx& ctx, ParseInput& in, Type type, bool isAtomic) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeAtomicRMWOrCmpxchg(Ctx& ctx, ParseInput& in, Type type) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicRMW(
  Ctx& ctx, ParseInput& in, Type type, uint8_t bytes, const char* extra) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicCmpxchg(
  Ctx& ctx, ParseInput& in, Type type, uint8_t bytes, const char* extra) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeAtomicWait(Ctx& ctx, ParseInput& in, Type type) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicNotify(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeAtomicFence(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDExtract(Ctx& ctx, ParseInput& in, SIMDExtractOp op, size_t lanes) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDReplace(Ctx& ctx, ParseInput& in, SIMDReplaceOp op, size_t lanes) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeSIMDShuffle(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDTernary(Ctx& ctx, ParseInput& in, SIMDTernaryOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDShift(Ctx& ctx, ParseInput& in, SIMDShiftOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDLoad(Ctx& ctx, ParseInput& in, SIMDLoadOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeSIMDLoadStoreLane(Ctx& ctx, ParseInput& in, SIMDLoadStoreLaneOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryInit(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeDataDrop(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryCopy(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeMemoryFill(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makePush(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makePop(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeIf(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeMaybeBlock(Ctx& ctx, ParseInput& in, size_t i, Type type) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeLoop(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeCall(Ctx& ctx, ParseInput& in, bool isReturn) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeCallIndirect(Ctx& ctx, ParseInput& in, bool isReturn) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBreak(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBreakTable(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeReturn(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefNull(Ctx& ctx, ParseInput& in) {
  auto t = heaptype(ctx, in);
  CHECK_ERR(t);
  return ctx.makeRefNull(*t);
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefIs(Ctx& ctx, ParseInput& in, RefIsOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefFunc(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefEq(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTableGet(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTableSet(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTableSize(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTableGrow(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTry(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeTryOrCatchBody(Ctx& ctx, ParseInput& in, Type type, bool isTry) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeThrow(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRethrow(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTupleMake(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeTupleExtract(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeCallRef(Ctx& ctx, ParseInput& in, bool isReturn) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeI31New(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeI31Get(Ctx& ctx, ParseInput& in, bool signed_) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefTest(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefTestStatic(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefCast(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefCastStatic(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefCastNopStatic(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeBrOn(Ctx& ctx, ParseInput& in, BrOnOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeBrOnStatic(Ctx& ctx, ParseInput& in, BrOnOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStructNewStatic(Ctx& ctx, ParseInput& in, bool default_) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStructGet(Ctx& ctx, ParseInput& in, bool signed_) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStructSet(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeArrayNewStatic(Ctx& ctx, ParseInput& in, bool default_) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayInitStatic(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeArrayGet(Ctx& ctx, ParseInput& in, bool signed_) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArraySet(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayLen(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayCopy(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRefAs(Ctx& ctx, ParseInput& in, RefAsOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringNew(Ctx& ctx, ParseInput& in, StringNewOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringConst(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringMeasure(Ctx& ctx, ParseInput& in, StringMeasureOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringEncode(Ctx& ctx, ParseInput& in, StringEncodeOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringConcat(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringEq(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringAs(Ctx& ctx, ParseInput& in, StringAsOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringWTF8Advance(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringWTF16Get(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringIterNext(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringIterMove(Ctx& ctx, ParseInput& in, StringIterMoveOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStringSliceWTF(Ctx& ctx, ParseInput& in, StringSliceWTFOp op) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeStringSliceIter(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

// =======
// Modules
// =======

// typeidx ::= x:u32 => x
//           | v:id  => x (if types[x] = v)
template<typename Ctx>
MaybeResult<Index> maybeTypeidx(Ctx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    return *x;
  }
  if (auto id = in.takeID()) {
    // TODO: Fix position to point to start of id, not next element.
    auto idx = ctx.getTypeIndex(*id, in);
    CHECK_ERR(idx);
    return *idx;
  }
  return {};
}

template<typename Ctx>
Result<typename Ctx::HeapTypeT> typeidx(Ctx& ctx, ParseInput& in) {
  if (auto idx = maybeTypeidx(ctx, in)) {
    CHECK_ERR(idx);
    return ctx.getHeapTypeFromIdx(*idx, in);
  }
  return in.err("expected type index or identifier");
}

// typeuse ::= '(' 'type' x:typeidx ')'                                => x, []
//                 (if typedefs[x] = [t1*] -> [t2*]
//           | '(' 'type' x:typeidx ')' ((t1,IDs):param)* (t2:result)* => x, IDs
//                 (if typedefs[x] = [t1*] -> [t2*])
//           | ((t1,IDs):param)* (t2:result)*                          => x, IDs
//                 (if x is minimum s.t. typedefs[x] = [t1*] -> [t2*])
template<typename Ctx>
Result<typename Ctx::TypeUseT> typeuse(Ctx& ctx, ParseInput& in) {
  auto pos = in.getPos();
  std::optional<typename Ctx::HeapTypeT> type;
  if (in.takeSExprStart("type"sv)) {
    auto x = typeidx(ctx, in);
    CHECK_ERR(x);

    if (!in.takeRParen()) {
      return in.err("expected end of type use");
    }

    type = *x;
  }

  auto namedParams = params(ctx, in);
  CHECK_ERR(namedParams);

  auto resultTypes = results(ctx, in);
  CHECK_ERR(resultTypes);

  // TODO: Use `pos` for error reporting rather than `in`.
  return ctx.makeTypeUse(
    pos, type, namedParams.getPtr(), resultTypes.getPtr(), in);
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
template<typename Ctx> Result<> strtype(Ctx& ctx, ParseInput& in) {
  if (auto type = functype(ctx, in)) {
    CHECK_ERR(type);
    ctx.addFuncType(*type);
    return Ok{};
  }
  if (auto type = structtype(ctx, in)) {
    CHECK_ERR(type);
    ctx.addStructType(*type);
    return Ok{};
  }
  if (auto type = arraytype(ctx, in)) {
    CHECK_ERR(type);
    ctx.addArrayType(*type);
    return Ok{};
  }
  return in.err("expected type description");
}

// subtype ::= '(' 'type' id? '(' 'sub' typeidx? strtype ')' ')'
//           | '(' 'type' id? strtype ')'
template<typename Ctx> MaybeResult<> subtype(Ctx& ctx, ParseInput& in) {
  auto pos = in.getPos();

  if (!in.takeSExprStart("type"sv)) {
    return {};
  }

  Name name;
  if (auto id = in.takeID()) {
    name = *id;
  }

  if (in.takeSExprStart("sub"sv)) {
    if (auto super = maybeTypeidx(ctx, in)) {
      CHECK_ERR(super);
      CHECK_ERR(ctx.addSubtype(*super, in));
    }

    CHECK_ERR(strtype(ctx, in));

    if (!in.takeRParen()) {
      return in.err("expected end of subtype definition");
    }
  } else {
    CHECK_ERR(strtype(ctx, in));
  }

  if (!in.takeRParen()) {
    return in.err("expected end of type definition");
  }

  ctx.finishSubtype(name, pos);
  return Ok{};
}

// deftype ::= '(' 'rec' subtype* ')'
//           | subtype
template<typename Ctx> MaybeResult<> deftype(Ctx& ctx, ParseInput& in) {
  auto pos = in.getPos();

  if (in.takeSExprStart("rec"sv)) {
    size_t startIndex = ctx.getRecGroupStartIndex();
    size_t groupLen = 0;
    while (auto type = subtype(ctx, in)) {
      CHECK_ERR(type);
      ++groupLen;
    }
    if (!in.takeRParen()) {
      return in.err("expected type definition or end of recursion group");
    }
    ctx.addRecGroup(startIndex, groupLen);
  } else if (auto type = subtype(ctx, in)) {
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
template<typename Ctx>
MaybeResult<typename Ctx::LocalsT> locals(Ctx& ctx, ParseInput& in) {
  bool hasAny = false;
  auto res = ctx.makeLocals();
  while (in.takeSExprStart("local"sv)) {
    hasAny = true;
    if (auto id = in.takeID()) {
      // Single named local
      auto type = valtype(ctx, in);
      CHECK_ERR(type);
      if (!in.takeRParen()) {
        return in.err("expected end of local");
      }
      ctx.appendLocal(res, *id, *type);
    } else {
      // Repeated unnamed locals
      while (!in.takeRParen()) {
        auto type = valtype(ctx, in);
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
//              '(' 'import' mode:name nm:name ')' typeuse ')'
template<typename Ctx> MaybeResult<> func(Ctx& ctx, ParseInput& in) {
  auto pos = in.getPos();
  if (!in.takeSExprStart("func"sv)) {
    return {};
  }

  Name name;
  if (auto id = in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(in);
  CHECK_ERR(exports);

  auto import = inlineImport(in);
  CHECK_ERR(import);

  auto type = typeuse(ctx, in);
  CHECK_ERR(type);

  std::optional<typename Ctx::LocalsT> localVars;
  if (!import) {
    if (auto l = locals(ctx, in)) {
      CHECK_ERR(l);
      localVars = *l;
    }
  }

  std::optional<typename Ctx::InstrsT> insts;
  if (!import) {
    auto i = instrs(ctx, in);
    CHECK_ERR(i);
    insts = *i;
  }

  if (!in.takeRParen()) {
    return in.err("expected end of function");
  }

  // TODO: Use `pos` instead of `in` for error position.
  CHECK_ERR(ctx.addFunc(
    name, *exports, import.getPtr(), *type, localVars, insts, pos, in));
  return Ok{};
}

// global ::= '(' 'global' id? ('(' 'export' name ')')* gt:globaltype e:expr ')'
//          | '(' 'global' id? ('(' 'export' name ')')*
//                '(' 'import' mod:name nm:name ')' gt:globaltype ')'
template<typename Ctx> MaybeResult<> global(Ctx& ctx, ParseInput& in) {
  auto pos = in.getPos();
  if (!in.takeSExprStart("global"sv)) {
    return {};
  }

  Name name;
  if (auto id = in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(in);
  CHECK_ERR(exports);

  auto import = inlineImport(in);
  CHECK_ERR(import);

  auto type = globaltype(ctx, in);
  CHECK_ERR(type);

  std::optional<typename Ctx::ExprT> exp;
  if (!import) {
    auto e = expr(ctx, in);
    CHECK_ERR(e);
    exp = *e;
  }

  if (!in.takeRParen()) {
    return in.err("expected end of global");
  }

  // TODO: Use `pos` instead of `in` for error position.
  CHECK_ERR(
    ctx.addGlobal(name, *exports, import.getPtr(), *type, exp, pos, in));
  return Ok{};
}

// modulefield ::= deftype
//               | import
//               | func
//               | table
//               | mem
//               | global
//               | export
//               | start
//               | elem
//               | data
MaybeResult<> modulefield(ParseDeclsCtx& ctx, ParseInput& in) {
  if (auto t = in.peek(); !t || t->isRParen()) {
    return {};
  }
  if (auto res = deftype(ctx, in)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = func(ctx, in)) {
    CHECK_ERR(res);
    return Ok{};
  }
  if (auto res = global(ctx, in)) {
    CHECK_ERR(res);
    return Ok{};
  }
  return in.err("unrecognized module field");
}

// module ::= '(' 'module' id? (m:modulefield)* ')'
//          | (m:modulefield)* eof
Result<> module(ParseDeclsCtx& ctx, ParseInput& in) {
  bool outer = in.takeSExprStart("module"sv);

  if (outer) {
    if (auto id = in.takeID()) {
      ctx.wasm.name = *id;
    }
  }

  while (auto field = modulefield(ctx, in)) {
    CHECK_ERR(field);
  }

  if (outer && !in.takeRParen()) {
    return in.err("expected end of module");
  }

  return Ok{};
}

} // anonymous namespace

Result<> parseModule(Module& wasm, std::string_view input) {
  // Parse module-level declarations.
  ParseDeclsCtx decls(wasm);
  {
    ParseInput in(input);
    CHECK_ERR(module(decls, in));
    if (!in.empty()) {
      return in.err("Unexpected tokens after module");
    }
  }

  auto typeIndices = createIndexMap(input, decls.subtypeDefs);
  CHECK_ERR(typeIndices);

  // Parse type definitions.
  std::vector<HeapType> types;
  {
    TypeBuilder builder(decls.subtypeDefs.size());
    ParseTypeDefsCtx ctx(builder, *typeIndices);
    for (auto& typeDef : decls.typeDefs) {
      ParseInput in(input, typeDef.pos);
      CHECK_ERR(deftype(ctx, in));
    }
    auto built = builder.build();
    if (auto* err = built.getError()) {
      std::stringstream msg;
      msg << "invalid type: " << err->reason;
      return ParseInput(input, decls.typeDefs[err->index].pos).err(msg.str());
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
    ParseImplicitTypeDefsCtx ctx(types, implicitTypes, *typeIndices);
    for (Index pos : decls.implicitTypeDefs) {
      ParseInput in(input, pos);
      CHECK_ERR(typeuse(ctx, in));
    }
  }

  {
    // Parse module-level types.
    ParseModuleTypesCtx ctx(wasm, types, implicitTypes, *typeIndices);
    CHECK_ERR(parseDefs(ctx, input, decls.globalDefs, global));
    CHECK_ERR(parseDefs(ctx, input, decls.funcDefs, func));
    // TODO: Parse types of other module elements.
  }
  {
    // Parse definitions.
    // TODO: Parallelize this.
    ParseDefsCtx ctx(wasm, types, implicitTypes, *typeIndices);
    CHECK_ERR(parseDefs(ctx, input, decls.globalDefs, global));
    CHECK_ERR(parseDefs(ctx, input, decls.funcDefs, func));
  }

  return Ok{};
}

} // namespace wasm::WATParser
