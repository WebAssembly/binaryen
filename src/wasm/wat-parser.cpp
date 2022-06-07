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

#include <deque>

#include "ir/names.h"
#include "parsing.h"
#include "support/name.h"
#include "wasm-builder.h"
#include "wasm-type.h"
#include "wasm.h"
#include "wat-lexer.h"
#include "wat-parser.h"

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
// The third and final phase parses the definitions of all other module
// elements.
//
// Each phase of parsing gets its own context type that is passed to the
// individual parsing functions. There is a parsing function for each element of
// the grammar given in the spec. Parsing functions for elements that need to be
// parsed in more than one of the parsing phases are templatized so that they
// may be passed the appropriate context type for each phase. Some parsing
// functions return different result types depending on the phase as well.

#define RETURN_OR_OK(val)                                                      \
  if constexpr (parsingDecls<Ctx>) {                                           \
    return Ok{};                                                               \
  } else {                                                                     \
    return val;                                                                \
  }

#define RETURN_OR_TRUE(val)                                                    \
  if constexpr (parsingDecls<Ctx>) {                                           \
    return true;                                                               \
  } else {                                                                     \
    return val;                                                                \
  }

#define RETURN_NONE()                                                          \
  if constexpr (parsingDecls<Ctx>) {                                           \
    return false;                                                              \
  } else {                                                                     \
    return {std::nullopt};                                                     \
  }

#define CHECK_ERR(val)                                                         \
  if (auto err = val.getErr()) {                                               \
    return *err;                                                               \
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

  bool empty() { return lexer == lexer.end(); }

  std::optional<Token> peek() {
    if (lexer != lexer.end()) {
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

  struct Position {
    const char* pos;
  };

  Position getPos() {
    if (auto t = peek()) {
      return {&t->span.front()};
    }
    return {&lexer.next().back()};
  }

  std::string_view getSpanSince(Position prev) {
    auto curr = getPos();
    return std::string_view(prev.pos, curr.pos - prev.pos);
  }

  [[nodiscard]] Err err(std::string reason) {
    std::stringstream msg;
    if (auto t = peek()) {
      msg << lexer.position(*t);
    } else {
      msg << lexer.position(lexer.next());
    }
    msg << ": error: " << reason;
    return Err{msg.str()};
  }
};

// ===================
// POD Utility Structs
// ===================

// The input span containing the definition for a module element and the
// element's name, if it exists.
struct DefSpan {
  Name name;
  std::string_view span;
};

struct Limits {
  uint32_t min;
  std::optional<uint32_t> max;
};

struct TableType {
  Limits limits;
  Type type;
};

struct DefinedGlobalType {
  Mutability mutability;
  Type type;
};

struct IndexedName {
  Index index;
  Name name;
};

struct ImportNames {
  Name mod;
  Name nm;
};

struct TypeUse {
  HeapType type;
  std::vector<NameType> ids;
};

// ===============
// Parser Contexts
// ===============

using IndexMap = std::unordered_map<Name, Index>;

// A parsing context used while parsing top-level declarations for a module.
struct ParseDeclsCtx {
  // At this stage we only look at types to find implicit type definitions,
  // which are inserted directly in to the context. We cannot materialize or
  // validate any types because we don't know what types exist yet.
  using RefType = bool;
  using ValType = Ok;
  using Params = bool;
  using Results = bool;
  using FuncType = bool;
  using TableTypeT = Ok;
  using GlobalType = Ok;
  using TypeUseT = Ok;
  using Locals = bool;

  using Instrs = Ok;
  using DataStr = Ok;

  using TypeIdx = Ok;
  using FuncIdx = Ok;
  using TableIdx = Ok;
  using MemIdx = Ok;
  using GlobalIdx = Ok;
  using ElemIdx = Ok;
  using DataIdx = Ok;
  using LocalIdx = Ok;
  using LabelIdx = Ok;

  // Declared module elements are inserted into the module, but their bodies are
  // not filled out until later parsing phases.
  Module& wasm;

  // The module element definitions we are parsing in this phase.
  std::vector<DefSpan> explicitTypeDefs;
  std::vector<DefSpan> importDefs;
  std::vector<DefSpan> funcDefs;
  std::vector<DefSpan> memDefs;
  std::vector<DefSpan> tableDefs;
  std::vector<DefSpan> globalDefs;
  std::vector<DefSpan> elemDefs;
  std::vector<DefSpan> dataDefs;

  // Type possibly defined implicitly via typeuses. Those that do not end up
  // matching an explicit type definition are appended to the type index space
  // in order of appearance.
  std::vector<std::string_view> implicitTypeDefs;

  // Counters used for generating names for module elements.
  int globalCounter = 0;

  // Used to verify that all imports come before all non-imports.
  bool hasNonImport = false;

  ParseDeclsCtx(Module& wasm) : wasm(wasm) {}
};

// A parsing context used while parsing explicit type definitions.
struct ParseTypesCtx {
  using RefType = std::optional<Type>;
  using ValType = Type;
  using Params = std::optional<std::vector<NameType>>;
  using Results = std::optional<std::vector<Type>>;
  using FuncType = std::optional<Signature>;
  using TypeIdx = HeapType;

  // We update slots in this builder as we parse type definitions.
  TypeBuilder& builder;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;

  // The index we are currently parsing.
  size_t index;

  ParseTypesCtx(TypeBuilder& builder, const IndexMap& typeIndices, Index index)
    : builder(builder), typeIndices(typeIndices), index(index) {}
};

// A parsing context used while parsing type uses to find implicit type
// definitions.
struct ParseImplicitTypesCtx {
  using RefType = std::optional<Type>;
  using ValType = Type;
  using Params = std::optional<std::vector<NameType>>;
  using Results = std::optional<std::vector<Type>>;
  using TypeUseT = Signature;
  using TypeIdx = HeapType;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;
  const std::vector<HeapType>& types;

  ParseImplicitTypesCtx(const IndexMap& typeIndices,
                        const std::vector<HeapType>& types)
    : typeIndices(typeIndices), types(types) {}
};

// A parsing context used while parsing module elements besides types.
struct ParseDefsCtx {
  // In this phase we have constructed all the types, so we can materialize and
  // validate them when they are used.
  using RefType = std::optional<Type>;
  using ValType = Type;
  using Params = std::optional<std::vector<NameType>>;
  using Results = std::optional<std::vector<Type>>;
  using FuncType = std::optional<Signature>;
  using TypeUseT = TypeUse;
  using TableTypeT = TableType;
  using GlobalType = DefinedGlobalType;
  using Locals = std::optional<std::vector<NameType>>;

  using Instrs = Expression*;
  using DataStr = std::vector<char>;

  using TypeIdx = HeapType;
  using FuncIdx = Name;
  using TableIdx = Name;
  using MemIdx = Name;
  using GlobalIdx = Name;
  using ElemIdx = Name;
  using DataIdx = Name;
  using LocalIdx = Index;
  using LabelIdx = Name;

  Module& wasm;

  // The index of the current element in its index space.
  Index index;

  // Map heap type names to their indices.
  const std::vector<HeapType>& types;

  // Map signatures to their first corresponding type indices.
  const std::unordered_map<Signature, Index>& signatureIndices;

  // Map names to indices for each index space.
  const IndexMap& typeIndices;
  const IndexMap& funcIndices;
  const IndexMap& memIndices;
  const IndexMap& tableIndices;
  const IndexMap& globalIndices;
  const IndexMap& elemIndices;
  const IndexMap& dataIndices;

  ParseDefsCtx(Module& wasm,
               Index index,
               const std::vector<HeapType>& types,
               const std::unordered_map<Signature, Index>& signatureIndices,
               const IndexMap& typeIndices,
               const IndexMap& funcIndices,
               const IndexMap& memIndices,
               const IndexMap& tableIndices,
               const IndexMap& globalIndices,
               const IndexMap& elemIndices,
               const IndexMap& dataIndices)
    : wasm(wasm), index(index), types(types),
      signatureIndices(signatureIndices), typeIndices(typeIndices),
      funcIndices(funcIndices), memIndices(memIndices),
      tableIndices(tableIndices), globalIndices(globalIndices),
      elemIndices(elemIndices), dataIndices(dataIndices) {}
};

template<typename Ctx>
inline constexpr bool parsingDecls = std::is_same_v<Ctx, ParseDeclsCtx>;

template<typename Ctx>
inline constexpr bool parsingTypes = std::is_same_v<Ctx, ParseTypesCtx>;

template<typename Ctx>
inline constexpr bool parsingImplicitTypes =
  std::is_same_v<Ctx, ParseImplicitTypesCtx>;

template<typename Ctx>
inline constexpr bool parsingDefs = std::is_same_v<Ctx, ParseDefsCtx>;

struct FuncCtx {
  Function& func;
  UniqueNameMapper labels;
};

// ================
// Parser Functions
// ================

// Types
template<typename Ctx>
Result<typename Ctx::TypeIdx> heaptype(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::RefType> reftype(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::ValType> valtype(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::Params> params(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::Results> results(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::FuncType> functype(Ctx&, ParseInput&);
Result<Limits> limits(ParseInput&);
Result<Limits> memtype(ParseInput&);
template<typename Ctx>
Result<typename Ctx::TableTypeT> tabletype(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::GlobalType> globaltype(Ctx&, ParseInput&);

// Instructions
template<typename Ctx> Result<typename Ctx::Instrs> instrs(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::Instrs> expr(Ctx&, ParseInput&);

// Modules
template<typename Ctx> Result<typename Ctx::TypeIdx> typeidx(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::FuncIdx> funcidx(ParseDefsCtx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::TableIdx> tableidx(ParseDefsCtx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::MemIdx> memidx(ParseDefsCtx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::GlobalIdx> globalidx(ParseDefsCtx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::ElemIdx> elemidx(ParseDefsCtx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::DataIdx> dataidx(ParseDefsCtx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::LocalIdx> localidx(FuncCtx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::LabelIdx> labelidx(FuncCtx&, ParseInput&);
template<typename Ctx> Result<bool> type(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::TypeUseT> typeuse(Ctx&, ParseInput&);
template<typename Ctx> Result<bool> import(Ctx&, ParseInput&);
// TODO: parse *all* locals, also params and results
template<typename Ctx> Result<typename Ctx::Locals> local(Ctx&, ParseInput&);
Result<std::optional<ImportNames>> inlineImport(ParseInput&);
Result<std::vector<Name>> inlineExports(ParseInput&);
template<typename Ctx> Result<bool> func(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::DataStr> datastring(Ctx&, ParseInput&);
template<typename Ctx> Result<bool> table(Ctx&, ParseInput&);
template<typename Ctx> Result<bool> mem(Ctx&, ParseInput&);
template<typename Ctx> Result<bool> global(Ctx&, ParseInput&);
Result<bool> modulefield(ParseDeclsCtx&, ParseInput&);
Result<> module(ParseDeclsCtx&, ParseInput&);

// Utilities
void applyImportNames(Importable& item,
                      const std::optional<ImportNames>& names);
Result<> addExports(ParseInput& in,
                    Module& wasm,
                    const Named* item,
                    const std::vector<Name>& exports,
                    ExternalKind kind);
Result<IndexMap> createIndexMap(const std::vector<DefSpan>& defs);

// heaptype ::= x:typeidx => types[x]
//            | 'func'    => func
//            | 'extern'  => extern
template<typename Ctx>
Result<typename Ctx::TypeIdx> heaptype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("func"sv)) {
    RETURN_OR_OK(HeapType::func);
  }
  if (in.takeKeyword("extern"sv)) {
    RETURN_OR_OK(HeapType::any);
  }
  auto type = typeidx(ctx, in);
  CHECK_ERR(type);
  return *type;
}

// reftype ::= 'funcref' => funcref
//           | 'externref' => externref
//           | '(' ref null? heaptype ')'
template<typename Ctx>
Result<typename Ctx::RefType> reftype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("funcref"sv)) {
    RETURN_OR_TRUE(Type(HeapType::func, Nullable));
  }
  if (in.takeKeyword("externref"sv)) {
    RETURN_OR_TRUE(Type(HeapType::func, Nullable));
  }

  if (!in.takeSExprStart("ref"sv)) {
    RETURN_NONE();
  }

  auto nullability = in.takeKeyword("null"sv) ? Nullable : NonNullable;

  auto type = heaptype(ctx, in);
  CHECK_ERR(type);

  if (!in.takeRParen()) {
    return in.err("expected end of reftype");
  }

  if constexpr (parsingDecls<Ctx>) {
    return true;
  } else if constexpr (parsingTypes<Ctx>) {
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
Result<typename Ctx::ValType> valtype(Ctx& ctx, ParseInput& in) {
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
    RETURN_OR_OK(**type);
  } else {
    return in.err("expected valtype");
  }
}

// param  ::= '(' 'param id? t:valtype ')' => [t]
//          | '(' 'param t*:valtype* ')' => [t*]
// params ::= param*
template<typename Ctx>
Result<typename Ctx::Params> params(Ctx& ctx, ParseInput& in) {
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

  if constexpr (parsingDecls<Ctx>) {
    return hasAny;
  } else {
    if (hasAny) {
      return {res};
    }
    return std::nullopt;
  }
}

// result  ::= '(' 'result' t*:valtype ')' => [t*]
// results ::= result*
template<typename Ctx>
Result<typename Ctx::Results> results(Ctx& ctx, ParseInput& in) {
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

  if constexpr (parsingDecls<Ctx>) {
    return hasAny;
  } else {
    if (hasAny) {
      return {res};
    }
    return std::nullopt;
  }
}

// functype ::= '(' 'func' t1*:vec(param) t2*:vec(result) ')' => [t1*] -> [t2*]
template<typename Ctx>
Result<typename Ctx::FuncType> functype(Ctx& ctx, ParseInput& in) {
  if (!in.takeSExprStart("func"sv)) {
    if constexpr (parsingDecls<Ctx>) {
      return false;
    } else {
      return std::nullopt;
    }
  }

  auto namedParams = params(ctx, in);
  CHECK_ERR(namedParams);

  auto resultTypes = results(ctx, in);
  CHECK_ERR(resultTypes);

  if (!in.takeRParen()) {
    return in.err("expected end of functype");
  }

  std::vector<Type> paramTypes;
  if constexpr (!parsingDecls<Ctx>) {
    if (*namedParams) {
      paramTypes.reserve((*namedParams)->size());
      for (auto& param : **namedParams) {
        paramTypes.push_back(param.type);
      }
    }
    if (!resultTypes) {
      resultTypes = std::vector<Type>();
    }
  }

  if constexpr (parsingDecls<Ctx>) {
    return true;
  } else {
    return Signature(Type(paramTypes), Type(**resultTypes));
  }
}

// limits ::= n:u32       => { min n, max _ }
//          | n:u32 m:u32 => { min n, max m }
Result<Limits> limits(ParseInput& in) {
  auto min = in.takeU32();
  if (!min) {
    return in.err("expected limits minimum");
  }
  return {{*min, in.takeU32()}};
}

// memtype ::= lim:limits => lim
Result<Limits> memtype(ParseInput& in) { return limits(in); }

// tabletype ::= lim:limits et:reftype => lim et
template<typename Ctx>
Result<typename Ctx::TableTypeT> tabletype(Ctx& ctx, ParseInput& in) {
  auto lim = limits(in);
  CHECK_ERR(lim);
  auto type = reftype(ctx, in);
  CHECK_ERR(type);
  if (!type) {
    return in.err("expected reftype");
  }
  RETURN_OR_OK((TableType{*lim, **type}));
}

// globaltype ::= t:valtype               => const t
//              | '(' 'mut' t:valtype ')' => var t
template<typename Ctx>
Result<typename Ctx::GlobalType> globaltype(Ctx& ctx, ParseInput& in) {
  // t:valtype
  auto type = valtype(ctx, in);
  if (type.ok()) {
    RETURN_OR_OK((DefinedGlobalType{Immutable, *type}));
  }

  // '(' 'mut' t:valtype ')'
  if (!in.takeSExprStart("mut"sv)) {
    return *type.getErr();
  }
  auto mutType = valtype(ctx, in);
  CHECK_ERR(mutType);

  if (!in.takeRParen()) {
    return in.err("expected end of globaltype");
  }

  RETURN_OR_OK((DefinedGlobalType{Mutable, *mutType}));
}

// TODO
template<typename Ctx>
Result<typename Ctx::Instrs> instrs(Ctx& ctx, ParseInput& in) {
  return in.err("TODO: instrs");
}

// expr ::= (in:instr)* => in* end
template<typename Ctx>
Result<typename Ctx::Instrs> expr(Ctx& ctx, ParseInput& in) {
  // TODO
  return instrs(ctx, in);
}

// typeidx ::= x:u32 => x
//           | v:id  => x (if types[x] = v)
template<typename Ctx>
Result<typename Ctx::TypeIdx> typeidx(Ctx& ctx, ParseInput& in) {
  Index index;
  if (auto x = in.takeU32()) {
    index = *x;
  } else if (auto id = in.takeID()) {
    if constexpr (!parsingDecls<Ctx>) {
      auto it = ctx.typeIndices.find(*id);
      if (it == ctx.typeIndices.end()) {
        return in.err("unknown type identifier");
      }
      index = it->second;
    }
  } else {
    return in.err("expected type index or identifier");
  }

  if constexpr (parsingDecls<Ctx>) {
    return Ok{};
  } else if constexpr (parsingTypes<Ctx>) {
    if (index >= ctx.builder.size()) {
      return in.err("type index out of bounds");
    }
    return ctx.builder[index];
  } else {
    if (index >= ctx.types.size()) {
      return in.err("type index out of bounds");
    }
    return ctx.types[index];
  }
}

template<typename Elems>
Result<Name> getModuleElementByIdx(ParseInput& in,
                                   const Elems& elements,
                                   Index i,
                                   std::string kind) {
  if (i < elements.size()) {
    return elements[i];
  }
  return in.err(kind + " index out of bounds");
}

template<typename Elems>
Result<Name> getModuleElementByID(ParseInput& in,
                                  const Elems& elements,
                                  const IndexMap& indices,
                                  Name id,
                                  std::string kind) {
  if (auto it = indices.find(id); it != indices.end()) {
    return elements[it->second]->name;
  }
  return in.err("unknown " + kind + " identifier");
}

// funcidx ::= x:u32 => x
//           | v:id  => x (if funcs[x] = v)
template<typename Ctx>
Result<typename Ctx::FuncIdx> funcidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto i = in.takeU32()) {
    RETURN_OR_OK(getModuleElementByIdx(in, ctx.wasm.functions, *i, "function"));
  }
  if (auto id = in.takeID()) {
    RETURN_OR_OK(getModuleElementByID(
      in, ctx.wasm.functions, ctx.funcIndices, *id, "function"));
  }
  return in.err("expected function index or identifier");
}

// tableidx ::= x:u32 => x
//            | v:id  => x (if tables[x] = v)
template<typename Ctx>
Result<typename Ctx::TableIdx> tableidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto i = in.takeU32()) {
    RETURN_OR_OK(getModuleElementByIdx(in, ctx.wasm.tables, *i, "table"));
  }
  if (auto id = in.takeID()) {
    RETURN_OR_OK(getModuleElementByID(
      in, ctx.wasm.tables, ctx.tableIndices, *id, "table"));
  }
  return in.err("expected table index or identifier");
}

// memidx ::= x:u32 => x
//          | v:id  => x (if mems[x] = v)
template<typename Ctx>
Result<typename Ctx::MemIdx> memidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else {
      if (ctx.wasm.memory.exists && *x == 0) {
        return &ctx.wasm.memory;
      }
      return in.err("memory index out of bounds");
    }
  }

  if (auto id = in.takeID()) {
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else {
      if (ctx.wasm.memory.exists && ctx.wasm.memory.name == *id) {
        return &ctx.wasm.memory;
      }
      return in.err("unknown memory identifier");
    }
  }

  return in.err("expected memory index or identifier");
}

// globalidx ::= x:u32 => x
//             | v:id  => x (if globals[x] = v)
template<typename Ctx>
Result<typename Ctx::GlobalIdx> globalidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto i = in.takeU32()) {
    RETURN_OR_OK(getModuleElementByIdx(in, ctx.wasm.globals, *i, "global"));
  }
  if (auto id = in.takeID()) {
    RETURN_OR_OK(getModuleElementByID(
      in, ctx.wasm.globals, ctx.globalIndices, *id, "global"));
  }
  return in.err("expected global index or identifier");
}

// elemidx ::= x:u32 => x
//           | v:id  => x (if elem[x] = v)
template<typename Ctx>
Result<typename Ctx::ElemIdx> elemidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto i = in.takeU32()) {
    RETURN_OR_OK(
      getModuleElementByIdx(in, ctx.wasm.elementSegments, *i, "elem segment"));
  }

  if (auto id = in.takeID()) {
    RETURN_OR_OK(getModuleElementByID(
      in, ctx.wasm.elementSegments, ctx.elemIndices, *id, "elem segment"));
  }
  return in.err("expected elem segment index or identifier");
}

// dataidx ::= x:u32 => x
//           | v:id  => x (if data[x] = v)
template<typename Ctx>
Result<typename Ctx::DataIdx> dataidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto i = in.takeU32()) {
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else {
      if (*i < ctx.wasm.memory.segments.size()) {
        return *i;
      }
      return in.err("data segment index out of bounds");
    }
  }

  if (auto id = in.takeID()) {
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else {
      if (auto it = ctx.dataIndices.find(*id); it != ctx.dataIndices.end()) {
        return it->second;
      }
      return in.err("unknown data segment identifier");
    }
  }

  return in.err("expected data segment index or identifier");
}

// localidx ::= x:u32 => x
//            | v:id  => x (if locals[x] = v)
template<typename Ctx>
Result<typename Ctx::LocalIdx> localidx(FuncCtx& ctx, ParseInput& in) {
  return in.err("TODO: localidx");
}

// labelidx ::= x:u32 => x
//            | v:id  => x (if labels[x] = v)
template<typename Ctx>
Result<typename Ctx::LabelIdx> labelidx(FuncCtx& ctx, ParseInput& in) {
  return in.err("TODO: labelidx");
}

// type ::= '(' 'type' id? ft:functype ')' => ft
template<typename Ctx> Result<bool> type(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();

  if (!in.takeSExprStart("type"sv)) {
    return false;
  }

  Name name;
  if (auto id = in.takeID()) {
    name = *id;
  }

  if (auto type = functype(ctx, in)) {
    CHECK_ERR(type);
    if constexpr (parsingTypes<Ctx>) {
      ctx.builder[ctx.index] = **type;
    }
  } else {
    return in.err("expected type description");
  }

  if (!in.takeRParen()) {
    return in.err("expected end of type definition");
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.explicitTypeDefs.push_back({name, in.getSpanSince(start)});
  }
  return true;
}

// typeuse ::= '(' 'type' x:typeidx ')'                                => x, []
//                 (if typedefs[x] = [t1*] -> [t2*]
//           | '(' 'type' x:typeidx ')' ((t1,IDs):param)* (t2:result)* => x, IDs
//                 (if typedefs[x] = [t1*] -> [t2*])
//           | ((t1,IDs):param)* (t2:result)*                          => x, IDs
//                 (if x is minimum s.t. typedefs[x] = [t1*] -> [t2*])
template<typename Ctx>
Result<typename Ctx::TypeUseT> typeuse(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();
  std::optional<typename Ctx::TypeIdx> type;
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

  bool hasSig = !type || namedParams || resultTypes;

  if constexpr (parsingDecls<Ctx>) {
    if (hasSig) {
      ctx.implicitTypeDefs.push_back(in.getSpanSince(start));
    }
    return Ok{};
  } else {
    std::vector<Type> paramTypes;
    if (namedParams) {
      paramTypes.reserve((*namedParams)->size());
      for (auto& param : **namedParams) {
        paramTypes.push_back(param.type);
      }
    }
    if (!resultTypes) {
      resultTypes = std::vector<Type>{};
    }
    Signature sig{Type(paramTypes), Type(**resultTypes)};
    if constexpr (parsingImplicitTypes<Ctx>) {
      return sig;
    } else if constexpr (parsingDefs<Ctx>) {
      if (!*namedParams) {
        *namedParams = std::vector<NameType>{};
      }
      if (type) {
        if (!type->isSignature()) {
          // TODO: Fix error position to be `start`
          return in.err("type is not a signature");
        }
        if (hasSig) {
          if (type->getSignature() != sig) {
            // TODO: Fix error position to be `start`
            return in.err("type does not match signature");
          }
        }
        return {{*type, **namedParams}};
      }
      return {{ctx.types[ctx.signatureIndices.at(sig)], **namedParams}};
    }
  }
}

// import      ::= '(' 'import' mod:name nm:name d:importdesc ')'
//                     => {module mod, name nm, desc d}
// importdesc  ::= '(' 'func' id? (x,IDs):typeuse ')' => func x
//               | '(' 'table' id? tt:tabletype ')'   => table tt
//               | '(' 'memory' id? mt:memtype ')'    => mem mt
//               | '(' 'global' id? gt:globaltype ')' => global gt
template<typename Ctx> Result<bool> import(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();

  if (!in.takeSExprStart("import"sv)) {
    return false;
  }

  if constexpr (parsingDecls<Ctx>) {
    if (ctx.hasNonImport) {
      return in.err("import after non-import");
    }
  }

  auto mod = in.takeName();
  if (!mod) {
    return in.err("expected import module");
  }

  auto nm = in.takeName();
  if (!nm) {
    return in.err("expected import name");
  }

  if (in.takeSExprStart("func"sv)) {
    [[maybe_unused]] auto id = in.takeID();
    auto type = typeuse(ctx, in);
    CHECK_ERR(type);

    if constexpr (parsingDecls<Ctx>) {
      // TODO: Insert import.
    } else {
      // TODO: Fill out import.
    }
  } else if (in.takeSExprStart("table"sv)) {
    [[maybe_unused]] auto id = in.takeID();
    auto type = tabletype(ctx, in);
    CHECK_ERR(type);

    if constexpr (parsingDecls<Ctx>) {
      // TODO: Insert import.
    } else {
      // TODO: Fill out import.
    }
  } else if (in.takeSExprStart("memory"sv)) {
    [[maybe_unused]] auto id = in.takeID();
    auto type = memtype(in);
    CHECK_ERR(type);

    if constexpr (parsingDecls<Ctx>) {
      // TODO: Insert import.
    } else {
      // TODO: Fill out import.
    }
  } else if (in.takeSExprStart("global"sv)) {
    [[maybe_unused]] auto id = in.takeID();
    auto type = globaltype(ctx, in);
    CHECK_ERR(type);

    if constexpr (parsingDecls<Ctx>) {
      // TODO: Insert import.
    } else {
      // TODO: Fill out import.
    }
  } else {
    return in.err("expected import description");
  }

  if (!in.takeRParen()) {
    return in.err("expected end of import description");
  }

  if (!in.takeRParen()) {
    return in.err("expected end of import");
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.importDefs.push_back({{}, in.getSpanSince(start)});
  }

  return true;
}

// local ::= '(' 'local' id t:valtype ')' => [(t, id)]
//         | '(' 'local' (t:valtype)* ')' => [t*]
template<typename Ctx>
Result<typename Ctx::Locals> local(Ctx& ctx, ParseInput& in) {
  return in.err("TODO: local");
}

Result<std::optional<ImportNames>> inlineImport(ParseInput& in) {
  if (!in.takeSExprStart("import"sv)) {
    return std::nullopt;
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
  return {{{*mod, *nm}}};
}

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

// func  ::= '(' 'func' id? ('(' 'export' name ')')*
//               x:typeuse (t:local)* (in:instr)* ')'
//       ::= '(' 'func' id? ('(' 'export' name ')')*
//               '(' 'import' mod:name nm:name ')' x:typeuse ')'
template<typename Ctx> Result<bool> func(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();

  if (!in.takeSExprStart("func"sv)) {
    return false;
  }

  [[maybe_unused]] auto id = in.takeID();

  auto exports = inlineExports(in);
  CHECK_ERR(exports);

  auto import = inlineImport(in);
  CHECK_ERR(import);

  auto type = typeuse(ctx, in);
  CHECK_ERR(type);

  if (import) {
    if (!in.takeRParen()) {
      return in.err("expected end of function");
    }
    if constexpr (parsingDecls<Ctx>) {
      ctx.funcDefs.push_back({{}, in.getSpanSince(start)});
      // TODO: Insert import
      // TODO: Add exports
    } else if constexpr (parsingDefs<Ctx>) {
      // TODO: Set import type
    }
    return true;
  }

  while (auto locs = local(ctx, in)) {
    CHECK_ERR(locs);
    // TODO: collect and install locals
  }

  auto body = instrs(ctx, in);
  CHECK_ERR(body);

  if (!in.takeRParen()) {
    return in.err("expected end of function");
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.funcDefs.push_back({{}, in.getSpanSince(start)});
    // TODO: Insert function
    // TODO: Add exports
  } else if constexpr (parsingDefs<Ctx>) {
    // TODO: Set function type, params, locals, body
  }
  return true;
}

// table ::= '(' 'table' id? ('(' 'export' name ')')* tt:tabletype ')'
//         | '(' 'table' id? ('(' 'export' name ')')* reftype
//               '(' 'elem' (e:elemexpr)* ')' ')'
//         | '(' 'table' id? ('(' 'export' name ')')* reftype
//               '(' 'elem' (f:funcidx)* ')' ')'
//         | '(' 'table' id? ('(' 'export' name ')')*
//               '(' 'import' mod:name nm:name ')' tt:tabletype ')'
template<typename Ctx> Result<bool> table(Ctx& ctx, ParseInput& in) {
  // TODO
  return false;
}

// datastring ::= (b:string)* => concat(b*)
template<typename Ctx>
Result<typename Ctx::DataStr> datastring(Ctx& ctx, ParseInput& in) {
  std::vector<char> data;
  while (auto str = in.takeString()) {
    if constexpr (parsingDefs<Ctx>) {
      data.insert(data.end(), str->begin(), str->end());
    }
  }
  RETURN_OR_OK(data);
}

// mem ::= '(' 'memory' id? ('(' 'export' name ')')* mt:memtype ')'
//       | '(' 'memory' id? ('(' 'export' name ')')*
//             '(' 'data' b:datastring ')' ')'
//       | '(' 'memory' id? ('(' 'export' name ')')*
//             '(' 'import' mod:name nm:name ')' mt:memtype ')'
template<typename Ctx> Result<bool> mem(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();
  if (!in.takeSExprStart("memory"sv)) {
    return false;
  }

  [[maybe_unused]] auto id = in.takeID();

  auto exports = inlineExports(in);
  CHECK_ERR(exports);

  auto import = inlineImport(in);
  CHECK_ERR(import);

  if (!import && in.takeSExprStart("data"sv)) {
    [[maybe_unused]] auto data = datastring(ctx, in);
    if (!in.takeRParen()) {
      return in.err("expected end of data");
    }
    if (!in.takeRParen()) {
      return in.err("expected end of memory");
    }
    if constexpr (parsingDecls<Ctx>) {
      ctx.memDefs.push_back({{}, in.getSpanSince(start)});
      // TODO: Insert mem
      // TODO: Add exports
    } else if constexpr (parsingDefs<Ctx>) {
      // TODO: Add data
    }
  }

  auto type = memtype(in);
  CHECK_ERR(type);

  if (!in.takeRParen()) {
    return in.err("expected end of memory");
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.memDefs.push_back({{}, in.getSpanSince(start)});
    // TODO: Insert possibly-imported memory
    // TODO: Add exports
  }

  return true;
}

Result<Global*> addGlobalDecl(ParseDeclsCtx& ctx,
                              ParseInput& in,
                              Name name,
                              std::optional<ImportNames> importNames) {
  auto g = std::make_unique<Global>();
  if (name.is()) {
    if (ctx.wasm.getGlobalOrNull(name)) {
      // TDOO: if the existing global is not explicitly named, fix its name and
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

void finishGlobalDef(Global& g, DefinedGlobalType gtype, Expression* init) {
  g.type = gtype.type;
  g.init = init;
  g.mutable_ = gtype.mutability;
}

// global ::= '(' 'global' id? ('(' 'export' name ')')* gt:globaltype e:expr ')'
//          | '(' 'global' id? '(' 'import' mod:name nm:name ')'
//                gt:globaltype ')'
template<typename Ctx> Result<bool> global(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();
  if (!in.takeSExprStart("global"sv)) {
    return false;
  }

  Name name;
  if (auto id = in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(in);
  CHECK_ERR(exports);

  auto import = inlineImport(in);
  CHECK_ERR(import);

  auto gtype = globaltype(ctx, in);
  CHECK_ERR(gtype);

  if (import) {
    if (!in.takeRParen()) {
      return in.err("expected end of global");
    }

    if constexpr (parsingDecls<Ctx>) {
      if (ctx.hasNonImport) {
        return in.err("import after non-import");
      }
      auto g = addGlobalDecl(ctx, in, name, *import);
      CHECK_ERR(g);

      auto added = addExports(in, ctx.wasm, *g, *exports, ExternalKind::Global);
      CHECK_ERR(added);

      ctx.globalDefs.push_back({name, in.getSpanSince(start)});
    } else {
      finishGlobalDef(*ctx.wasm.globals[ctx.index], *gtype, nullptr);
    }
    return true;
  }

  auto exp = expr(ctx, in);
  CHECK_ERR(exp);

  if (!in.takeRParen()) {
    return in.err("expected end of global");
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.hasNonImport = true;
    auto g = addGlobalDecl(ctx, in, name, {});
    CHECK_ERR(g);
    ctx.globalDefs.push_back({name, in.getSpanSince(start)});
  } else {
    finishGlobalDef(*ctx.wasm.globals[ctx.index], *gtype, *exp);
  }
  return true;
}

// export     ::= '(' 'export' nm:name d:exportdesc ')'
// exportdesc ::= '(' 'func' x:funcidx ')'
//              | '(' 'table' x:tableidx ')'
//              | '(' 'memory' x:memidx ')'
//              | '(' 'global' x:gobalidx ')'

// start ::= '(' 'start' x:funcidx ')'

// elem ::= '(' 'elem' id? (et,y*):elemlist ')'
//        | '(' 'elem' id? x:tableuse '(' 'offset'? e:expr ')'
//              (et,y*):elemlist ')'
//        | '(' 'elem' id? 'declare' (et,y*):elemlist ')'
// elemlist ::= t:reftype (y:elemexpr)*
// elemexpr ::= '(' 'item' e:expr ')'
//            | '(' e:expr ')'
// tableuse ::= '(' 'table' x:tableidx ')'

// data ::= '(' 'data' id? b:datastring ')'
//        | '(' 'data' id? x:memuse '(' 'offset'? expr ')' b:datastring ')'
// memuse ::= ('(' 'memory' x:memidx ')')?

// modulefield ::= type
//               | import
//               | func
//               | table
//               | mem
//               | global
//               | export
//               | start
//               | elem
//               | data
Result<bool> modulefield(ParseDeclsCtx& ctx, ParseInput& in) {
  if (auto t = in.peek(); !t || t->isRParen()) {
    return false;
  }
  if (auto res = type(ctx, in)) {
    CHECK_ERR(res);
    return true;
  }
  if (auto res = import(ctx, in)) {
    CHECK_ERR(res);
    return true;
  }
  if (auto res = func(ctx, in)) {
    CHECK_ERR(res);
    return true;
  }
  if (auto res = table(ctx, in)) {
    CHECK_ERR(res);
    return true;
  }
  if (auto res = mem(ctx, in)) {
    CHECK_ERR(res);
    return true;
  }
  if (auto res = global(ctx, in)) {
    CHECK_ERR(res);
    return true;
  }
  // if (auto res = export(ctx, in)) {
  //   CHECK_ERR(res);
  //   return true;
  // }
  // if (auto res = start(ctx, in)) {
  //   CHECK_ERR(res);
  //   return true;
  // }
  // if (auto res = elem(ctx, in)) {
  //   CHECK_ERR(res);
  //   return true;
  // }
  // if (auto res = data(ctx, in)) {
  //   CHECK_ERR(res);
  //   return true;
  // }
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

Result<IndexMap> createIndexMap(const std::vector<DefSpan>& defs) {
  IndexMap indices;
  for (Index i = 0; i < defs.size(); ++i) {
    if (defs[i].name.is()) {
      bool inserted = indices.insert({defs[i].name, i}).second;
      if (!inserted) {
        // TODO: improve this message.
        return Err{"error: duplicate element"};
      }
    }
  }
  return indices;
}

} // anonymous namespace

Result<> parseModule(Module& wasm, std::string_view input) {
  // Parse module-level declarations and implicit type definitions.
  ParseDeclsCtx decls(wasm);
  {
    ParseInput in(input);
    CHECK_ERR(module(decls, in));
    if (!in.empty()) {
      return in.err("Unexpected tokens after module");
    }
  }

  auto typeIndices = createIndexMap(decls.explicitTypeDefs);
  CHECK_ERR(typeIndices);

  // Parse type definitions.
  std::vector<HeapType> types;
  std::unordered_map<Signature, Index> signatureIndices;
  {
    TypeBuilder builder(decls.explicitTypeDefs.size());
    for (Index i = 0; i < decls.explicitTypeDefs.size(); ++i) {
      ParseTypesCtx ctx(builder, *typeIndices, i);
      ParseInput in(decls.explicitTypeDefs[i].span);
      auto def = type(ctx, in);
      CHECK_ERR(def);
      if (HeapType t = builder[i]; t.isSignature()) {
        signatureIndices.insert({t.getSignature(), i});
      }
    }
    auto built = builder.build();
    if (!built) {
      // TODO: Improve this message.
      return Err{"error: could not build types"};
    }
    types = *built;
    // Now that we have built the explicit types, parse type uses that might
    // implicitly define new signatures and add any signature we have not
    // already seen to the list of types.
    for (auto& span : decls.implicitTypeDefs) {
      ParseImplicitTypesCtx ctx(*typeIndices, types);
      ParseInput in(span);
      auto sig = typeuse(ctx, in);
      CHECK_ERR(sig);

      if (signatureIndices.insert({*sig, types.size()}).second) {
        types.push_back(HeapType(*sig));
      }
    }
    // Install the type names on the module.
    for (auto& [name, idx] : *typeIndices) {
      // TODO: Struct field names.
      wasm.typeNames.insert({types[idx], {name, {}}});
    }
  }

  // Map names to indices for each index space.
  auto funcIndices = createIndexMap(decls.funcDefs);
  CHECK_ERR(funcIndices);

  auto memIndices = createIndexMap(decls.memDefs);
  CHECK_ERR(memIndices);

  auto tableIndices = createIndexMap(decls.tableDefs);
  CHECK_ERR(tableIndices);

  auto globalIndices = createIndexMap(decls.globalDefs);
  CHECK_ERR(globalIndices);

  auto elemIndices = createIndexMap(decls.elemDefs);
  CHECK_ERR(elemIndices);

  auto dataIndices = createIndexMap(decls.dataDefs);
  CHECK_ERR(dataIndices);

  // Parse definitions
  // TODO: Parallelize these! To do so, we would have to parse and install
  // global and function types before doing the function bodies in parallel.
  ParseDefsCtx ctx(wasm,
                   0,
                   types,
                   signatureIndices,
                   *typeIndices,
                   *funcIndices,
                   *memIndices,
                   *tableIndices,
                   *globalIndices,
                   *elemIndices,
                   *dataIndices);

  auto parseDefs =
    [&](auto& defs,
        Result<bool> (*parse)(ParseDefsCtx&, ParseInput&)) -> Result<> {
    for (Index i = 0; i < defs.size(); ++i) {
      ctx.index = i;
      ParseInput in(defs[i].span);
      auto parsed = parse(ctx, in);
      CHECK_ERR(parsed);
    }
    return Ok{};
  };

  auto imports = parseDefs(decls.importDefs, import);
  CHECK_ERR(imports);

  auto funcs = parseDefs(decls.funcDefs, func);
  CHECK_ERR(funcs);

  auto mems = parseDefs(decls.memDefs, mem);
  CHECK_ERR(mems);

  auto tables = parseDefs(decls.tableDefs, table);
  CHECK_ERR(tables);

  auto globals = parseDefs(decls.globalDefs, global);
  CHECK_ERR(globals);

  // auto elems = parseDefs(decls.elemDefs, elem);
  // CHECK_ERR(elems);

  // auto datas = parseDefs(decls.dataDefs, data);
  // CHECK_ERR(datas);

  return Ok{};
}

} // namespace wasm::WATParser
