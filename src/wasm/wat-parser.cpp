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
// The third phase, not yet implemented, further parses and constructs types
// implicitly defined by type uses in functions, blocks, and call_indirect
// instructions. These implicitly defined types may be referred to by index
// elsewhere.
//
// The fourth phase, not yet implemented, parses and sets the types of globals,
// functions, and other top-level module elements. These types need to be set
// before we parse instructions because they determine the types of instructions
// such as global.get and ref.func.
//
// The fifth and final phase parses the remaining contents of all module
// elements, including instructions.
//
// Each phase of parsing gets its own context type that is passed to the
// individual parsing functions. There is a parsing function for each element of
// the grammar given in the spec. Parsing functions are templatized so that they
// may be passed the appropriate context type and return the correct result type
// for each phase.

#define RETURN_OR_OK(val)                                                      \
  if constexpr (parsingDecls<Ctx>) {                                           \
    return Ok{};                                                               \
  } else {                                                                     \
    return val;                                                                \
  }

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

// ===================
// POD Utility Structs
// ===================

// The location and possible name of a module-level definition in the input.
struct DefPos {
  Name name;
  Index pos;
};

struct GlobalType {
  Mutability mutability;
  Type type;
};

struct ImportNames {
  Name mod;
  Name nm;
};

// ===============
// Parser Contexts
// ===============

using IndexMap = std::unordered_map<Name, Index>;

// Phase 1: Parse definition spans for top-level module elements and determine
// their indices and names.
struct ParseDeclsCtx {
  // At this stage we only look at types to find implicit type definitions,
  // which are inserted directly in to the context. We cannot materialize or
  // validate any types because we don't know what types exist yet.
  using IndexT = Ok;
  using HeapTypeT = Ok;
  using TypeT = Ok;
  using ParamsT = Ok;
  using ResultsT = Ok;
  using SignatureT = Ok;
  using FieldT = Ok;
  using FieldsT = Ok;
  using StructT = Ok;
  using ArrayT = Ok;
  using GlobalTypeT = Ok;

  using InstrT = Ok;
  using InstrsT = Ok;
  using ExprT = Ok;

  // Declared module elements are inserted into the module, but their bodies are
  // not filled out until later parsing phases.
  Module& wasm;

  // The module element definitions we are parsing in this phase.
  std::vector<DefPos> typeDefs;
  std::vector<DefPos> subtypeDefs;
  std::vector<DefPos> globalDefs;

  // Counters used for generating names for module elements.
  int globalCounter = 0;

  // Used to verify that all imports come before all non-imports.
  bool hasNonImport = false;

  ParseDeclsCtx(Module& wasm) : wasm(wasm) {}
};

template<typename Ctx>
inline constexpr bool parsingDecls = std::is_same_v<Ctx, ParseDeclsCtx>;

// Phase 2: Parse type definitions into a TypeBuilder.
struct ParseTypeDefsCtx {
  using IndexT = Index;
  using HeapTypeT = HeapType;
  using TypeT = Type;
  using ParamsT = std::vector<NameType>;
  using ResultsT = std::vector<Type>;
  using SignatureT = Signature;
  using FieldT = Field;
  using FieldsT = std::pair<std::vector<Name>, std::vector<Field>>;
  using StructT = std::pair<std::vector<Name>, Struct>;
  using ArrayT = Array;

  using InstrT = Ok;
  using InstrsT = Ok;
  using ExprT = Ok;

  // We update slots in this builder as we parse type definitions.
  TypeBuilder& builder;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;

  // Parse the names of types and fields as we go.
  std::vector<TypeNames> names;

  // The index of the subtype definition we are parsing.
  Index index = 0;

  ParseTypeDefsCtx(TypeBuilder& builder, const IndexMap& typeIndices)
    : builder(builder), typeIndices(typeIndices), names(builder.size()) {}
};

template<typename Ctx>
inline constexpr bool parsingTypeDefs = std::is_same_v<Ctx, ParseTypeDefsCtx>;

// TODO: Phase 3: ParseImplicitTypeDefsCtx

// Phase 4: Parse and set the types of module elements.
struct ParseModuleTypesCtx {
  // In this phase we have constructed all the types, so we can materialize and
  // validate them when they are used.
  using IndexT = Index;
  using HeapTypeT = HeapType;
  using TypeT = Type;
  using ParamsT = std::vector<NameType>;
  using ResultsT = std::vector<Type>;
  using GlobalTypeT = GlobalType;

  using InstrT = Ok;
  using InstrsT = Ok;
  using ExprT = Ok;

  Module& wasm;

  const std::vector<HeapType>& types;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;

  // The index of the current type.
  Index index = 0;

  ParseModuleTypesCtx(Module& wasm,
                      const std::vector<HeapType>& types,
                      const IndexMap& typeIndices)
    : wasm(wasm), types(types), typeIndices(typeIndices) {}
};

template<typename Ctx>
inline constexpr bool parsingModuleTypes =
  std::is_same_v<Ctx, ParseModuleTypesCtx>;

// Phase 5: Parse module element definitions, including instructions.
struct ParseDefsCtx {
  using IndexT = Index;
  using TypeT = Type;
  using HeapTypeT = HeapType;
  // TODO: This could be Ok, but then we wouldn't be able to use RETURN_OR_OK.
  using GlobalTypeT = GlobalType;

  using InstrT = Expression*;
  using InstrsT = std::vector<Expression*>;
  using ExprT = Expression*;

  Module& wasm;

  Builder builder;

  const std::vector<HeapType>& types;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;

  // The index of the current module element.
  Index index = 0;

  ParseDefsCtx(Module& wasm,
               const std::vector<HeapType>& types,
               const IndexMap& typeIndices)
    : wasm(wasm), builder(wasm), types(types), typeIndices(typeIndices) {}
};

template<typename Ctx>
inline constexpr bool parsingDefs = std::is_same_v<Ctx, ParseDefsCtx>;

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
Result<typename Ctx::InstrT> makeRttCanon(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRttSub(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeRttFreshSub(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStructNew(Ctx&, ParseInput&, bool default_);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStructNewStatic(Ctx&, ParseInput&, bool default_);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeStructGet(Ctx&, ParseInput&, bool signed_ = false);
template<typename Ctx>
Result<typename Ctx::InstrT> makeStructSet(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayNew(Ctx&, ParseInput&, bool default_);
template<typename Ctx>
Result<typename Ctx::InstrT>
makeArrayNewStatic(Ctx&, ParseInput&, bool default_);
template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayInit(Ctx&, ParseInput&);
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
Result<typename Ctx::InstrT> makeStringViewAccess(Ctx&, ParseInput&, StringViewAccessOp op);

// Modules
template<typename Ctx>
MaybeResult<typename Ctx::IndexT> maybeTypeidx(Ctx& ctx, ParseInput& in);
template<typename Ctx>
Result<typename Ctx::HeapTypeT> typeidx(Ctx&, ParseInput&);
MaybeResult<ImportNames> inlineImport(ParseInput&);
Result<std::vector<Name>> inlineExports(ParseInput&);
template<typename Ctx> Result<> strtype(Ctx&, ParseInput&);
template<typename Ctx>
MaybeResult<typename Ctx::ModuleNameT> subtype(Ctx&, ParseInput&);
template<typename Ctx> MaybeResult<> deftype(Ctx&, ParseInput&);
template<typename Ctx> MaybeResult<> global(Ctx&, ParseInput&);
MaybeResult<> modulefield(ParseDeclsCtx&, ParseInput&);
Result<> module(ParseDeclsCtx&, ParseInput&);

// Utilities
template<typename T>
void applyImportNames(Importable& item,
                      const std::optional<ImportNames>& names);
Result<> addExports(ParseInput& in,
                    Module& wasm,
                    const Named* item,
                    const std::vector<Name>& exports,
                    ExternalKind kind);
Result<Global*> addGlobalDecl(ParseDeclsCtx& ctx,
                              ParseInput& in,
                              Name name,
                              std::optional<ImportNames> importNames);
Result<IndexMap> createIndexMap(std::string_view input,
                                const std::vector<DefPos>& defs);
std::vector<Type> getUnnamedTypes(const std::vector<NameType>& named);
template<typename Ctx>
Result<> parseDefs(Ctx& ctx,
                   std::string_view input,
                   const std::vector<DefPos>& defs,
                   MaybeResult<> (*parser)(Ctx&, ParseInput&));

// =====
// Types
// =====

// heaptype ::= x:typeidx => types[x]
//            | 'func'    => func
//            | 'extern'  => extern
template<typename Ctx>
Result<typename Ctx::HeapTypeT> heaptype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("func"sv)) {
    RETURN_OR_OK(HeapType::func);
  }
  if (in.takeKeyword("any"sv)) {
    RETURN_OR_OK(HeapType::any);
  }
  if (in.takeKeyword("extern"sv)) {
    RETURN_OR_OK(HeapType::any);
  }
  if (in.takeKeyword("eq"sv)) {
    RETURN_OR_OK(HeapType::eq);
  }
  if (in.takeKeyword("i31"sv)) {
    RETURN_OR_OK(HeapType::i31);
  }
  if (in.takeKeyword("data"sv)) {
    RETURN_OR_OK(HeapType::data);
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
    RETURN_OR_OK(Type(HeapType::func, Nullable));
  }
  if (in.takeKeyword("externref"sv)) {
    RETURN_OR_OK(Type(HeapType::any, Nullable));
  }
  if (in.takeKeyword("anyref"sv)) {
    RETURN_OR_OK(Type(HeapType::any, Nullable));
  }
  if (in.takeKeyword("eqref"sv)) {
    RETURN_OR_OK(Type(HeapType::eq, Nullable));
  }
  if (in.takeKeyword("i31ref"sv)) {
    RETURN_OR_OK(Type(HeapType::i31, NonNullable));
  }
  if (in.takeKeyword("dataref"sv)) {
    RETURN_OR_OK(Type(HeapType::data, NonNullable));
  }
  if (in.takeKeyword("arrayref"sv)) {
    return in.err("arrayref not yet supported");
  }

  if (!in.takeSExprStart("ref"sv)) {
    return {};
  }

  [[maybe_unused]] auto nullability =
    in.takeKeyword("null"sv) ? Nullable : NonNullable;

  auto type = heaptype(ctx, in);
  CHECK_ERR(type);

  if (!in.takeRParen()) {
    return in.err("expected end of reftype");
  }

  if constexpr (parsingDecls<Ctx>) {
    return Ok{};
  } else if constexpr (parsingTypeDefs<Ctx>) {
    return ctx.builder.getTempRefType(*type, nullability);
  } else {
    return Type(*type, nullability);
  }
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
    RETURN_OR_OK(Type::i32);
  } else if (in.takeKeyword("i64"sv)) {
    RETURN_OR_OK(Type::i64);
  } else if (in.takeKeyword("f32"sv)) {
    RETURN_OR_OK(Type::f32);
  } else if (in.takeKeyword("f64"sv)) {
    RETURN_OR_OK(Type::f64);
  } else if (in.takeKeyword("v128"sv)) {
    RETURN_OR_OK(Type::v128);
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
  std::vector<NameType> res;
  while (in.takeSExprStart("param"sv)) {
    hasAny = true;
    if (auto id = in.takeID()) {
      // Single named param
      auto type = valtype(ctx, in);
      CHECK_ERR(type);

      if (!in.takeRParen()) {
        return in.err("expected end of param");
      }

      if constexpr (!parsingDecls<Ctx>) {
        res.push_back({*id, *type});
      }
    } else {
      // Repeated unnamed params
      while (!in.takeRParen()) {
        auto type = valtype(ctx, in);
        CHECK_ERR(type);

        if constexpr (!parsingDecls<Ctx>) {
          res.push_back({Name(), *type});
        }
      }
    }
  }

  if (hasAny) {
    RETURN_OR_OK(res);
  }
  return {};
}

// result  ::= '(' 'result' t*:valtype ')' => [t*]
// results ::= result*
template<typename Ctx>
MaybeResult<typename Ctx::ResultsT> results(Ctx& ctx, ParseInput& in) {
  bool hasAny = false;
  std::vector<Type> res;
  while (in.takeSExprStart("result"sv)) {
    hasAny = true;
    while (!in.takeRParen()) {
      auto type = valtype(ctx, in);
      CHECK_ERR(type);

      if constexpr (!parsingDecls<Ctx>) {
        res.push_back(*type);
      }
    }
  }

  if (hasAny) {
    RETURN_OR_OK(res);
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

  std::vector<Type> paramTypes, resultTypes;
  if constexpr (!parsingDecls<Ctx>) {
    if (parsedParams) {
      paramTypes = getUnnamedTypes(*parsedParams);
    }
    if (parsedResults) {
      resultTypes = *parsedResults;
    }
  }

  if constexpr (parsingTypeDefs<Ctx>) {
    return Signature(ctx.builder.getTempTupleType(paramTypes),
                     ctx.builder.getTempTupleType(resultTypes));
  } else {
    RETURN_OR_OK(Signature(Type(paramTypes), Type(resultTypes)));
  }
}

// storagetype ::= valtype | packedtype
// packedtype  ::= i8 | i16
template<typename Ctx>
Result<typename Ctx::FieldT> storagetype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("i8"sv)) {
    RETURN_OR_OK(Field(Field::i8, Immutable));
  }
  if (in.takeKeyword("i16"sv)) {
    RETURN_OR_OK(Field(Field::i16, Immutable));
  }
  auto type = valtype(ctx, in);
  CHECK_ERR(type);
  RETURN_OR_OK(Field(*type, Immutable));
}

// fieldtype   ::= t:storagetype               => const t
//               | '(' 'mut' t:storagetype ')' => var t
template<typename Ctx>
Result<typename Ctx::FieldT> fieldtype(Ctx& ctx, ParseInput& in) {
  if (in.takeSExprStart("mut"sv)) {
    auto field = storagetype(ctx, in);
    CHECK_ERR(field);
    if (!in.takeRParen()) {
      return in.err("expected end of field type");
    }
    if constexpr (parsingTypeDefs<Ctx>) {
      field->mutable_ = Mutable;
      return *field;
    } else {
      return Ok{};
    }
  }

  return storagetype(ctx, in);
}

// field ::= '(' 'field' id t:fieldtype ')' => [(id, t)]
//         | '(' 'field' t*:fieldtype* ')'  => [(_, t*)*]
//         | fieldtype
template<typename Ctx>
Result<typename Ctx::FieldsT> fields(Ctx& ctx, ParseInput& in) {
  std::vector<Name> names;
  std::vector<Field> fs;
  while (true) {
    if (auto t = in.peek(); !t || t->isRParen()) {
      RETURN_OR_OK(std::pair(std::move(names), std::move(fs)));
    }
    if (in.takeSExprStart("field")) {
      if (auto id = in.takeID()) {
        auto field = fieldtype(ctx, in);
        CHECK_ERR(field);
        if (!in.takeRParen()) {
          return in.err("expected end of field");
        }
        if constexpr (parsingTypeDefs<Ctx>) {
          names.push_back(*id);
          fs.push_back(*field);
        }
      } else {
        while (!in.takeRParen()) {
          auto field = fieldtype(ctx, in);
          CHECK_ERR(field);
          if constexpr (parsingTypeDefs<Ctx>) {
            names.push_back({});
            fs.push_back(*field);
          }
        }
      }
    } else {
      auto field = fieldtype(ctx, in);
      CHECK_ERR(field);
      if constexpr (parsingTypeDefs<Ctx>) {
        names.push_back({});
        fs.push_back(*field);
      }
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

  RETURN_OR_OK(
    std::pair(std::move(namedFields->first), std::move(namedFields->second)));
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

  if constexpr (parsingTypeDefs<Ctx>) {
    if (namedFields->first.size() != 1) {
      return in.err("expected exactly one field in array definition");
    }
  }

  RETURN_OR_OK({namedFields->second[0]});
}

// globaltype ::= t:valtype               => const t
//              | '(' 'mut' t:valtype ')' => var t
template<typename Ctx>
Result<typename Ctx::GlobalTypeT> globaltype(Ctx& ctx, ParseInput& in) {
  // '(' 'mut' t:valtype ')'
  if (in.takeSExprStart("mut"sv)) {
    auto type = valtype(ctx, in);
    CHECK_ERR(type);

    if (!in.takeRParen()) {
      return in.err("expected end of globaltype");
    }
    RETURN_OR_OK((GlobalType{Mutable, *type}));
  }

  // t:valtype
  auto type = valtype(ctx, in);
  CHECK_ERR(type);
  RETURN_OR_OK((GlobalType{Immutable, *type}));
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
  // TODO: Folded instructions.
  std::vector<Expression*> insts;
  while (auto inst = instr(ctx, in)) {
    CHECK_ERR(inst);
    if constexpr (parsingDefs<Ctx>) {
      insts.push_back(*inst);
    }
  }
  if constexpr (parsingDefs<Ctx>) {
    return insts;
  } else {
    return Ok{};
  }
}

template<typename Ctx>
Result<typename Ctx::ExprT> expr(Ctx& ctx, ParseInput& in) {
  auto insts = instrs(ctx, in);
  CHECK_ERR(insts);
  if constexpr (parsingDefs<Ctx>) {
    switch (insts->size()) {
      case 0:
        return ctx.builder.makeNop();
      case 1:
        return insts->front();
      default:
        return ctx.builder.makeBlock(*insts);
    }
  } else {
    return Ok{};
  }
}

template<typename Ctx> Result<typename Ctx::InstrT> makeUnreachable(Ctx& ctx) {
  if constexpr (parsingDefs<Ctx>) {
    return ctx.builder.makeUnreachable();
  } else {
    return Ok{};
  }
}

template<typename Ctx> Result<typename Ctx::InstrT> makeNop(Ctx& ctx) {
  if constexpr (parsingDefs<Ctx>) {
    return ctx.builder.makeNop();
  } else {
    return Ok{};
  }
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
        if constexpr (parsingDefs<Ctx>) {
          return ctx.builder.makeConst(Literal(*c));
        } else {
          return Ok{};
        }
      }
      return in.err("expected i32");
    case Type::i64:
      if (auto c = in.takeI64()) {
        if constexpr (parsingDefs<Ctx>) {
          return ctx.builder.makeConst(Literal(*c));
        } else {
          return Ok{};
        }
      }
      return in.err("expected i64");
    case Type::f32:
      if (auto f = in.takeF32()) {
        if constexpr (parsingDefs<Ctx>) {
          return ctx.builder.makeConst(Literal(*f));
        } else {
          return Ok{};
        }
      }
      return in.err("expected f32");
    case Type::f64:
      if (auto f = in.takeF64()) {
        if constexpr (parsingDefs<Ctx>) {
          return ctx.builder.makeConst(Literal(*f));
        } else {
          return Ok{};
        }
      }
      return in.err("expected f64");
    case Type::v128:
      return in.err("unimplemented instruction");
    case Type::none:
    case Type::unreachable:
    case Type::funcref:
    case Type::anyref:
    case Type::eqref:
    case Type::i31ref:
    case Type::dataref:
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
  if constexpr (parsingDefs<Ctx>) {
    return ctx.builder.makeRefNull(*t);
  } else {
    return Ok{};
  }
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
Result<typename Ctx::InstrT> makeRttCanon(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRttSub(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeRttFreshSub(Ctx& ctx, ParseInput& in) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeStructNew(Ctx& ctx, ParseInput& in, bool default_) {
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
makeArrayNew(Ctx& ctx, ParseInput& in, bool default_) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT>
makeArrayNewStatic(Ctx& ctx, ParseInput& in, bool default_) {
  return in.err("unimplemented instruction");
}

template<typename Ctx>
Result<typename Ctx::InstrT> makeArrayInit(Ctx& ctx, ParseInput& in) {
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
Result<typename Ctx::InstrT>
makeStringViewAccess(Ctx& ctx, ParseInput& in, StringViewAccessOp op) {
  return in.err("unimplemented instruction");
}

// =======
// Modules
// =======

// typeidx ::= x:u32 => x
//           | v:id  => x (if types[x] = v)
template<typename Ctx>
MaybeResult<typename Ctx::IndexT> maybeTypeidx(Ctx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    RETURN_OR_OK(*x);
  }
  if (auto id = in.takeID()) {
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else {
      auto it = ctx.typeIndices.find(*id);
      if (it == ctx.typeIndices.end()) {
        return in.err("unknown type identifier");
      }
      return it->second;
    }
  }
  return {};
}

template<typename Ctx>
Result<typename Ctx::HeapTypeT> typeidx(Ctx& ctx, ParseInput& in) {
  if (auto index = maybeTypeidx(ctx, in)) {
    CHECK_ERR(index);
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else if constexpr (parsingTypeDefs<Ctx>) {
      if (*index >= ctx.builder.size()) {
        return in.err("type index out of bounds");
      }
      return ctx.builder[*index];
    } else {
      if (*index >= ctx.types.size()) {
        return in.err("type index out of bounds");
      }
      return ctx.types[*index];
    }
  }
  return in.err("expected type index or identifier");
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
    if constexpr (parsingTypeDefs<Ctx>) {
      ctx.builder[ctx.index] = *type;
    }
    return Ok{};
  }
  if (auto type = structtype(ctx, in)) {
    CHECK_ERR(type);
    if constexpr (parsingTypeDefs<Ctx>) {
      auto& [fieldNames, str] = *type;
      ctx.builder[ctx.index] = str;
      for (Index i = 0; i < fieldNames.size(); ++i) {
        if (auto name = fieldNames[i]; name.is()) {
          ctx.names[ctx.index].fieldNames[i] = name;
        }
      }
    }
    return Ok{};
  }
  if (auto type = arraytype(ctx, in)) {
    CHECK_ERR(type);
    if constexpr (parsingTypeDefs<Ctx>) {
      ctx.builder[ctx.index] = *type;
    }
    return Ok{};
  }
  return in.err("expected type description");
}

// subtype ::= '(' 'type' id? '(' 'sub' typeidx? strtype ')' ')'
//           | '(' 'type' id? strtype ')'
template<typename Ctx> MaybeResult<> subtype(Ctx& ctx, ParseInput& in) {
  [[maybe_unused]] auto pos = in.getPos();

  if (!in.takeSExprStart("type"sv)) {
    return {};
  }

  Name name;
  if (auto id = in.takeID()) {
    name = *id;
    if constexpr (parsingTypeDefs<Ctx>) {
      ctx.names[ctx.index].name = name;
    }
  }

  if (in.takeSExprStart("sub"sv)) {
    if (auto super = maybeTypeidx(ctx, in)) {
      CHECK_ERR(super);
      if constexpr (parsingTypeDefs<Ctx>) {
        if (*super >= ctx.builder.size()) {
          return in.err("supertype index out of bounds");
        }
        ctx.builder[ctx.index].subTypeOf(ctx.builder[*super]);
      }
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

  if constexpr (parsingDecls<Ctx>) {
    ctx.subtypeDefs.push_back({name, pos});
  }
  if constexpr (parsingTypeDefs<Ctx>) {
    ++ctx.index;
  }

  return Ok{};
}

// deftype ::= '(' 'rec' subtype* ')'
//           | subtype
template<typename Ctx> MaybeResult<> deftype(Ctx& ctx, ParseInput& in) {
  [[maybe_unused]] auto pos = in.getPos();

  if (in.takeSExprStart("rec"sv)) {
    [[maybe_unused]] size_t startIndex = 0;
    if constexpr (parsingTypeDefs<Ctx>) {
      startIndex = ctx.index;
    }
    size_t groupLen = 0;
    while (auto type = subtype(ctx, in)) {
      CHECK_ERR(type);
      ++groupLen;
    }
    if (!in.takeRParen()) {
      return in.err("expected type definition or end of recursion group");
    }
    if constexpr (parsingTypeDefs<Ctx>) {
      ctx.builder.createRecGroup(startIndex, groupLen);
    }
  } else if (auto type = subtype(ctx, in)) {
    CHECK_ERR(type);
  } else {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.typeDefs.push_back({{}, pos});
  }

  return Ok{};
}

// global ::= '(' 'global' id? ('(' 'export' name ')')* gt:globaltype e:expr ')'
//          | '(' 'global' id? '(' 'import' mod:name nm:name ')'
//                gt:globaltype ')'
template<typename Ctx> MaybeResult<> global(Ctx& ctx, ParseInput& in) {
  [[maybe_unused]] auto pos = in.getPos();
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
    *exp = *e;
  }

  if (!in.takeRParen()) {
    return in.err("expected end of global");
  }

  if constexpr (parsingDecls<Ctx>) {
    if (ctx.hasNonImport) {
      return in.err("import after non-import");
    }
    auto imp = import ? std::make_optional(*import) : std::nullopt;
    auto g = addGlobalDecl(ctx, in, name, imp);
    CHECK_ERR(g);
    CHECK_ERR(addExports(in, ctx.wasm, *g, *exports, ExternalKind::Global));
    ctx.globalDefs.push_back({name, pos});
  } else if constexpr (parsingModuleTypes<Ctx>) {
    auto& g = ctx.wasm.globals[ctx.index];
    g->mutable_ = type->mutability;
    g->type = type->type;
  } else if constexpr (parsingDefs<Ctx>) {
    if (!import) {
      ctx.wasm.globals[ctx.index]->init = *exp;
    }
  }

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

// =========
// Utilities
// =========

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

Result<Global*> addGlobalDecl(ParseDeclsCtx& ctx,
                              ParseInput& in,
                              Name name,
                              std::optional<ImportNames> importNames) {
  auto g = std::make_unique<Global>();
  if (name.is()) {
    if (ctx.wasm.getGlobalOrNull(name)) {
      // TODO: if the existing global is not explicitly named, fix its name and
      // continue.
      // TODO: Fix error location to point to name.
      return in.err("repeated global name");
    }
    g->setExplicitName(name);
  } else {
    name =
      (importNames ? "gimport$" : "") + std::to_string(ctx.globalCounter++);
    name = Names::getValidGlobalName(ctx.wasm, name);
    g->name = name;
  }
  applyImportNames(*g, importNames);
  return ctx.wasm.addGlobal(std::move(g));
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

  // TODO: Parse implicit type definitions.

  {
    // Parse module-level types.
    ParseModuleTypesCtx ctx(wasm, types, *typeIndices);
    CHECK_ERR(parseDefs(ctx, input, decls.globalDefs, global));
    // TODO: Parse types of other module elements.
  }
  {
    // Parse definitions.
    // TODO: Parallelize this.
    ParseDefsCtx ctx(wasm, types, *typeIndices);
    CHECK_ERR(parseDefs(ctx, input, decls.globalDefs, global));
  }

  return Ok{};
}

} // namespace wasm::WATParser
