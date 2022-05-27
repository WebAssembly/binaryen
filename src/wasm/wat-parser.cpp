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

using namespace std::string_view_literals;

namespace wasm::WATParser {

namespace {

// =======================
// Parser Input and Output
// =======================

// Wraps a lexer with a queue of lexed tokens to support peeking at upcoming
// tokens without entirely re-parsing them each time they are retrieved.
//
// TODO: We should only ever need lookahead of 1, and then only to check the
// keyword after an open paren. If we add SExprStart as its own token type, then
// we could just use a normal Lexer with no buffering.
struct BufferedLexer {
  Lexer lexer;

  // TODO: vector queue? Array literal of size 2?
  std::deque<Token> buffer;

  BufferedLexer(std::string_view input) : lexer(input) {}

  // Get the token `index` ahead of the current position without consuming
  // anything. The returned reference may be invalidated by any subsequent
  // `peek` or `take` operation.
  std::optional<Token> peek(size_t index = 0) {
    while (buffer.size() < index) {
      if (lexer == lexer.end()) {
        return {};
      }
      buffer.push_back(*lexer++);
    }
    if (index == buffer.size()) {
      return *lexer;
    }
    return buffer[index];
  }

  // Consume the next `n` tokens.
  void take(size_t n) {
    while (n > 0 && buffer.size()) {
      buffer.pop_front();
      --n;
    }
    while (n > 0 && lexer != lexer.end()) {
      ++lexer;
      --n;
    }
  }
};

// Wraps a lexer and provides utilities for consuming tokens.
struct ParseInput {
  BufferedLexer lexer;

  ParseInput(std::string_view in) : lexer(in) {}

  std::string_view next() { return lexer.lexer.next(); }

  // Take an open paren and expected keyword.
  bool takeSExprStart(std::string_view expected) {
    auto first = lexer.peek();
    if (!first || !first->isLParen()) {
      return false;
    }
    auto next = lexer.peek(1);
    if (auto next = lexer.peek(1)) {
      if (auto keyword = next->getKeyword()) {
        if (*keyword == expected) {
          lexer.take(2);
          return true;
        }
      }
    }
    return false;
  }

  bool takeLParen() {
    auto t = lexer.peek();
    if (!t || !t->isLParen()) {
      return false;
    }
    lexer.take(1);
    return true;
  }

  bool takeRParen() {
    auto t = lexer.peek();
    if (!t || !t->isRParen()) {
      return false;
    }
    lexer.take(1);
    return true;
  }

  std::optional<Name> takeID() {
    if (auto t = lexer.peek()) {
      if (auto id = t->getID()) {
        lexer.take(1);
        // See comment on takeName.
        return Name(std::string(*id));
      }
    }
    return {};
  }

  bool takeKeyword(std::string_view expected) {
    if (auto t = lexer.peek()) {
      if (auto keyword = t->getKeyword()) {
        if (*keyword == expected) {
          lexer.take(1);
          return true;
        }
      }
    }
    return false;
  }

  std::optional<uint64_t> takeU64() {
    if (auto t = lexer.peek()) {
      if (auto n = t->getU64()) {
        lexer.take(1);
        return n;
      }
    }
    return {};
  }

  std::optional<int64_t> takeS64() {
    if (auto t = lexer.peek()) {
      if (auto n = t->getS64()) {
        lexer.take(1);
        return n;
      }
    }
    return {};
  }

  std::optional<int64_t> takeI64() {
    if (auto t = lexer.peek()) {
      if (auto n = t->getI64()) {
        lexer.take(1);
        return n;
      }
    }
    return {};
  }

  std::optional<uint32_t> takeU32() {
    if (auto t = lexer.peek()) {
      if (auto n = t->getU32()) {
        lexer.take(1);
        return n;
      }
    }
    return {};
  }

  std::optional<int32_t> takeS32() {
    if (auto t = lexer.peek()) {
      if (auto n = t->getS32()) {
        lexer.take(1);
        return n;
      }
    }
    return {};
  }

  std::optional<int32_t> takeI32() {
    if (auto t = lexer.peek()) {
      if (auto n = t->getI32()) {
        lexer.take(1);
        return n;
      }
    }
    return {};
  }

  std::optional<double> takeF64() {
    if (auto t = lexer.peek()) {
      if (auto d = t->getF64()) {
        lexer.take(1);
        return d;
      }
    }
    return {};
  }

  std::optional<float> takeF32() {
    if (auto t = lexer.peek()) {
      if (auto f = t->getF32()) {
        lexer.take(1);
        return f;
      }
    }
    return {};
  }

  std::optional<std::string_view> takeString() {
    if (auto t = lexer.peek()) {
      if (auto s = t->getString()) {
        lexer.take(1);
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

  struct Position {
    const char* pos;
  };

  Position getPos() {
    if (auto t = lexer.peek()) {
      return {&t->span.front()};
    }
    return {&lexer.lexer.next().back()};
  }

  std::string_view getSpanSince(Position prev) {
    auto curr = getPos();
    return std::string_view(prev.pos, curr.pos - prev.pos);
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

struct DefinedTableType {
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

struct DefinedTypeUse {
  HeapType type;
  std::vector<IndexedName> ids;
};

struct ImportNames {
  Name mod;
  Name nm;
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
  using RefType = Ok;
  using ValType = Ok;
  using TypeIdx = Ok;
  using Params = Ok;
  using Results = Ok;
  using FuncType = Ok;
  using TableType = Ok;
  using GlobalType = Ok;
  using TypeUse = Ok;
  using Locals = Ok;

  using Instrs = Ok;
  using DataStr = Ok;

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
  using RefType = Type;
  using ValType = Type;
  using TypeIdx = HeapType;
  using Params = std::vector<NameType>;
  using Results = std::vector<Type>;
  using FuncType = Signature;

  // We update slots in this builder as we parse type definitions.
  TypeBuilder& builder;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;

  // The index we are currently parsing.
  size_t index;

  ParseTypesCtx(TypeBuilder& builder, const IndexMap& typeIndices, Index index)
    : builder(builder), typeIndices(typeIndices), index(index) {}

  std::optional<HeapType> getHeapType(Index index) {
    if (index >= builder.size()) {
      return {};
    }
    return builder[index];
  }
};

// A parsing context used while parsing type uses to find implicit type
// definitions.
struct ParseImplicitTypesCtx {
  using RefType = Type;
  using ValType = Type;
  using TypeIdx = HeapType;
  using Params = std::vector<NameType>;
  using Results = std::vector<Type>;
  using TypeUse = Signature;

  // Map heap type names to their indices.
  const IndexMap& typeIndices;
  const std::vector<HeapType>& types;

  ParseImplicitTypesCtx(const IndexMap& typeIndices,
                        const std::vector<HeapType>& types)
    : typeIndices(typeIndices), types(types) {}

  std::optional<HeapType> getHeapType(Index index) {
    if (index >= types.size()) {
      return {};
    }
    return types[index];
  }
};

// A parsing context used while parsing module elements besides types.
struct ParseDefsCtx {
  // In this phase we have constructed all the types, so we can materialize and
  // validate them when they are used.
  using RefType = Type;
  using ValType = Type;
  using TypeIdx = HeapType;
  using Params = std::vector<NameType>;
  using Results = std::vector<Type>;
  using FuncType = Signature;
  using TypeUse = DefinedTypeUse;
  using TableType = DefinedTableType;
  using GlobalType = DefinedGlobalType;
  using Locals = std::vector<NameType>;

  using Instrs = Expression*;
  using DataStr = std::vector<char>;

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

  std::optional<HeapType> getHeapType(Index index) {
    if (index >= types.size()) {
      return {};
    }
    return types[index];
  }
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
template<typename Ctx> Result<typename Ctx::Params> param(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::Results> result(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::FuncType> functype(Ctx&, ParseInput&);
Result<Limits> limits(ParseInput&);
Result<Limits> memtype(ParseInput&);
template<typename Ctx>
Result<typename Ctx::TableType> tabletype(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::GlobalType> globaltype(Ctx&, ParseInput&);

// Instructions
template<typename Ctx> Result<typename Ctx::Instrs> instrs(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::Instrs> expr(Ctx&, ParseInput&);

// Modules
template<typename Ctx> Result<typename Ctx::TypeIdx> typeidx(Ctx&, ParseInput&);
[[maybe_unused]] Result<Name> funcidx(ParseDefsCtx&, ParseInput&);
[[maybe_unused]] Result<Name> tableidx(ParseDefsCtx&, ParseInput&);
[[maybe_unused]] Result<Memory*> memidx(ParseDefsCtx&, ParseInput&);
[[maybe_unused]] Result<Name> globalidx(ParseDefsCtx&, ParseInput&);
[[maybe_unused]] Result<Name> elemidx(ParseDefsCtx&, ParseInput&);
[[maybe_unused]] Result<Name> dataidx(ParseDefsCtx&, ParseInput&);
[[maybe_unused]] Result<Index> localidx(FuncCtx&, ParseInput&);
[[maybe_unused]] Result<Name> labelidx(FuncCtx&, ParseInput&);
template<typename Ctx> Result<> type(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::TypeUse> typeuse(Ctx&, ParseInput&);
template<typename Ctx> Result<> import(Ctx&, ParseInput&);
template<typename Ctx> Result<typename Ctx::Locals> local(Ctx&, ParseInput&);
Result<ImportNames> inlineImport(ParseInput&);
Result<std::vector<Name>> inlineExports(ParseInput&);
template<typename Ctx> Result<> func(Ctx&, ParseInput&);
template<typename Ctx> Result<> table(Ctx&, ParseInput&);
template<typename Ctx>
Result<typename Ctx::DataStr> datastring(Ctx&, ParseInput&);
template<typename Ctx> Result<> table(Ctx&, ParseInput&);
template<typename Ctx> Result<> mem(Ctx&, ParseInput&);
template<typename Ctx> Result<> global(Ctx&, ParseInput&);
Result<> modulefield(ParseDeclsCtx&, ParseInput&);
Result<> module(ParseDeclsCtx&, ParseInput&);

// Utilities
void applyImportNames(Importable& item,
                      const std::optional<ImportNames>& names);
Result<> addExports(Module& wasm,
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
  if (auto type = typeidx(ctx, in)) {
    return *type;
  }
  return {};
}

// reftype ::= 'funcref' => funcref
//           | 'externref' => externref
//           | '(' ref null? heaptype ')'
template<typename Ctx>
Result<typename Ctx::RefType> reftype(Ctx& ctx, ParseInput& in) {
  if (in.takeKeyword("funcref"sv)) {
    RETURN_OR_OK(Type(HeapType::func, Nullable));
  }
  if (in.takeKeyword("externref"sv)) {
    RETURN_OR_OK(Type(HeapType::func, Nullable));
  }

  if (!in.takeSExprStart("ref"sv)) {
    return {};
  }

  auto nullability = in.takeKeyword("null"sv) ? Nullable : NonNullable;

  auto type = heaptype(ctx, in);
  if (!type) {
    return {};
  }

  if (!in.takeRParen()) {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    return Ok{};
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
  }
  if (in.takeKeyword("i64"sv)) {
    RETURN_OR_OK(Type::i64);
  }
  if (in.takeKeyword("f32"sv)) {
    RETURN_OR_OK(Type::f32);
  }
  if (in.takeKeyword("f64"sv)) {
    RETURN_OR_OK(Type::f64);
  }
  if (in.takeKeyword("v128"sv)) {
    RETURN_OR_OK(Type::v128);
  }
  if (auto type = reftype(ctx, in)) {
    return *type;
  }
  return {};
}

// param    ::= '(' 'param id? t:valtype ')' => [t]
//            | '(' 'param t*:valtype* ')' => [t*]
template<typename Ctx>
Result<typename Ctx::Params> param(Ctx& ctx, ParseInput& in) {
  if (!in.takeSExprStart("param"sv)) {
    return {};
  }

  // Single named param
  if (auto id = in.takeID()) {
    auto type = valtype(ctx, in);
    if (!type) {
      return {};
    }
    if (!in.takeRParen()) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else {
      return {{{*id, *type}}};
    }
  }

  // Repeated unnamed params
  std::vector<NameType> params;
  while (!in.takeRParen()) {
    auto type = valtype(ctx, in);
    if (!type) {
      return {};
    }
    if constexpr (parsingTypes<Ctx>) {
      params.push_back({Name(), *type});
    }
  }

  RETURN_OR_OK(params);
}

// result   ::= '(' 'result' t*:valtype ')' => [t*]
template<typename Ctx>
Result<typename Ctx::Results> result(Ctx& ctx, ParseInput& in) {
  if (!in.takeSExprStart("result"sv)) {
    return {};
  }

  std::vector<Type> results;
  while (!in.takeRParen()) {
    auto type = valtype(ctx, in);
    if (!type) {
      return {};
    }
    if constexpr (!parsingDecls<Ctx>) {
      results.push_back(*type);
    }
  }

  RETURN_OR_OK(results);
}

// functype ::= '(' 'func' t1*:vec(param) t2*:vec(result) ')' => [t1*] -> [t2*]
template<typename Ctx>
Result<typename Ctx::FuncType> functype(Ctx& ctx, ParseInput& in) {
  if (!in.takeSExprStart("func"sv)) {
    return {};
  }

  std::vector<Type> params, results;
  while (auto newParams = param(ctx, in)) {
    if constexpr (!parsingDecls<Ctx>) {
      for (auto& p : *newParams) {
        params.push_back(p.type);
      }
    }
  }

  while (auto newResults = result(ctx, in)) {
    if constexpr (!parsingDecls<Ctx>) {
      results.insert(results.end(), newResults->begin(), newResults->end());
    }
  }

  if (!in.takeRParen()) {
    return {};
  }

  RETURN_OR_OK(Signature(Type(params), Type(results)));
}

// limits ::= n:u32       => { min n, max _ }
//          | n:u32 m:u32 => { min n, max m }
Result<Limits> limits(ParseInput& in) {
  auto min = in.takeU32();
  if (!min) {
    return {};
  }

  return {{*min, in.takeU32()}};
}

// memtype ::= lim:limits => lim
Result<Limits> memtype(ParseInput& in) { return limits(in); }

// tabletype ::= lim:limits et:reftype => lim et
template<typename Ctx>
Result<typename Ctx::TableType> tabletype(Ctx& ctx, ParseInput& in) {
  auto lim = limits(in);
  if (!lim) {
    return {};
  }

  auto type = reftype(ctx, in);
  if (!type) {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    return Ok{};
  } else if constexpr (parsingDefs<Ctx>) {
    return {{*lim, *type}};
  }
}

// globaltype ::= t:valtype               => const t
//              | '(' 'mut' t:valtype ')' => var t
template<typename Ctx>
Result<typename Ctx::GlobalType> globaltype(Ctx& ctx, ParseInput& in) {
  // t:valtype
  if (auto type = valtype(ctx, in)) {
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else if constexpr (parsingDefs<Ctx>) {
      return {{Immutable, *type}};
    }
  }

  // '(' 'mut' t:valtype ')'
  if (!in.takeSExprStart("mut"sv)) {
    return {};
  }
  auto type = valtype(ctx, in);
  if (!type) {
    return {};
  }
  if (!in.takeRParen()) {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    return Ok{};
  } else if constexpr (parsingDefs<Ctx>) {
    return {{Mutable, *type}};
  }
}

// TODO
template<typename Ctx> Result<typename Ctx::Instrs> instrs(Ctx&, ParseInput&) {
  return {};
}

// expr ::= (in:instr)* => in* end
template<typename Ctx> Result<typename Ctx::Instrs> expr(Ctx&, ParseInput&) {
  // TODO
  return {};
}

// typeidx ::= x:u32 => x
//           | v:id  => x (if types[x] = v)
template<typename Ctx>
Result<typename Ctx::TypeIdx> typeidx(Ctx& ctx, ParseInput& in) {
  if constexpr (parsingDecls<Ctx>) {
    if (in.takeU32() || in.takeID()) {
      return Ok{};
    }
    return {};
  } else {
    Index index;
    if (auto x = in.takeU32()) {
      index = *x;
    } else if (auto id = in.takeID()) {
      auto it = ctx.typeIndices.find(*id);
      if (it == ctx.typeIndices.end()) {
        return {};
      }
      index = it->second;
    } else {
      return {};
    }
    if (auto type = ctx.getHeapType(index)) {
      return *type;
    }
    return {};
  }
}

// funcidx ::= x:u32 => x
//           | v:id  => x (if funcs[x] = v)
Result<Name> funcidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if (*x > ctx.wasm.functions.size()) {
      return {};
    }
    return ctx.wasm.functions[*x]->name;
  }
  if (auto id = in.takeID()) {
    if (auto func = ctx.wasm.getFunctionOrNull(*id)) {
      return func->name;
    }
    return {};
  }
  return {};
}

// tableidx ::= x:u32 => x
//            | v:id  => x (if tables[x] = v)
Result<Name> tableidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if (*x > ctx.wasm.tables.size()) {
      return {};
    }
    return ctx.wasm.tables[*x]->name;
  }
  if (auto id = in.takeID()) {
    if (auto table = ctx.wasm.getTableOrNull(*id)) {
      return table->name;
    }
    return {};
  }
  return {};
}

// memidx ::= x:u32 => x
//          | v:id  => x (if mems[x] = v)
Result<Memory*> memidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if (ctx.wasm.memory.exists && *x == 0) {
      return &ctx.wasm.memory;
    }
    return {};
  }
  if (auto id = in.takeID()) {
    if (ctx.wasm.memory.exists && ctx.wasm.memory.name == *id) {
      return &ctx.wasm.memory;
    }
    return {};
  }
  return {};
}

// globalidx ::= x:u32 => x
//             | v:id  => x (if globals[x] = v)
Result<Name> globalidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if (*x > ctx.wasm.globals.size()) {
      return {};
    }
    return ctx.wasm.globals[*x]->name;
  }
  if (auto id = in.takeID()) {
    if (auto global = ctx.wasm.getGlobalOrNull(*id)) {
      return global->name;
    }
    return {};
  }
  return {};
}

// elemidx ::= x:u32 => x
//           | v:id  => x (if elem[x] = v)
Result<Name> elemidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if (*x > ctx.wasm.elementSegments.size()) {
      return {};
    }
    return ctx.wasm.elementSegments[*x]->name;
  }
  if (auto id = in.takeID()) {
    if (auto elem = ctx.wasm.getElementSegmentOrNull(*id)) {
      return elem->name;
    }
    return {};
  }
  return {};
}

// dataidx ::= x:u32 => x
//           | v:id  => x (if data[x] = v)
Result<Name> dataidx(ParseDefsCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if (*x > ctx.wasm.memory.segments.size()) {
      return {};
    }
    return ctx.wasm.memory.segments[*x].name;
  }
  if (auto id = in.takeID()) {
    for (auto& seg : ctx.wasm.memory.segments) {
      if (seg.name == *id) {
        return seg.name;
      }
    }
    return {};
  }
  return {};
}

// localidx ::= x:u32 => x
//            | v:id  => x (if locals[x] = v)
Result<Index> localidx(FuncCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if (*x > ctx.func.getNumLocals()) {
      return {};
    }
    return *x;
  }
  if (auto id = in.takeID()) {
    auto it = ctx.func.localIndices.find(*id);
    if (it == ctx.func.localIndices.end()) {
      return {};
    }
    return it->second;
  }
  return {};
}

// labelidx ::= x:u32 => x
//            | v:id  => x (if labels[x] = v)
Result<Name> labelidx(FuncCtx& ctx, ParseInput& in) {
  if (auto x = in.takeU32()) {
    if (*x > ctx.labels.labelStack.size()) {
      return {};
    }
    return *(ctx.labels.labelStack.end() - *x);
  }
  if (auto id = in.takeID()) {
    auto it = ctx.labels.labelMappings.find(*id);
    if (it == ctx.labels.labelMappings.end()) {
      return {};
    }
    return it->second.back();
  }
  return {};
}

// type ::= '(' 'type' id? ft:functype ')' => ft
template<typename Ctx> Result<> type(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();

  if (!in.takeSExprStart("type"sv)) {
    return {};
  }

  Name name;
  if (auto id = in.takeID()) {
    name = *id;
  }

  auto type = functype(ctx, in);
  if (!type) {
    return {};
  }

  if (!in.takeRParen()) {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.explicitTypeDefs.push_back({name, in.getSpanSince(start)});
    return Ok{};
  } else if constexpr (parsingTypes<Ctx>) {
    ctx.builder[ctx.index] = *type;
    return Ok{};
  }
}

// typeuse ::= '(' 'type' x:typeidx ')'                                => x, []
//                 (if typedefs[x] = [t1*] -> [t2*]
//           | '(' 'type' x:typeidx ')' ((t1,IDs):param)* (t2:result)* => x, IDs
//                 (if typedefs[x] = [t1*] -> [t2*])
//           | ((t1,IDs):param)* (t2:result)*                          => x, IDs
//                 (if x is minimum s.t. typedefs[x] = [t1*] -> [t2*])
template<typename Ctx>
Result<typename Ctx::TypeUse> typeuse(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();
  std::optional<typename Ctx::TypeIdx> type;
  if (in.takeSExprStart("type"sv)) {
    auto x = typeidx(ctx, in);
    if (!x) {
      return {};
    }
    if (!in.takeRParen()) {
      return {};
    }
    type = *x;
  }

  bool hasSig = !type;
  std::vector<Type> params;
  std::vector<IndexedName> ids;
  Index index = 0;
  while (auto nametypes = param(ctx, in)) {
    hasSig = true;
    if constexpr (!parsingDecls<Ctx>) {
      for (auto& nametype : *nametypes) {
        if (nametype.name.is()) {
          ids.push_back({index, nametype.name});
        }
        params.push_back(nametype.type);
        ++index;
      }
    }
  }

  std::vector<Type> results;
  while (auto types = result(ctx, in)) {
    hasSig = true;
    if constexpr (!parsingDecls<Ctx>) {
      results.insert(results.end(), types->begin(), types->end());
    }
  }

  if constexpr (parsingDecls<Ctx>) {
    if (hasSig) {
      ctx.implicitTypeDefs.push_back(in.getSpanSince(start));
    }
    return Ok{};
  } else if constexpr (parsingImplicitTypes<Ctx>) {
    return Signature(Type(params), Type(results));
  } else if constexpr (parsingDefs<Ctx>) {
    Signature sig{Type(params), Type(results)};
    if (type) {
      if (!type->isSignature()) {
        return {};
      }
      if (hasSig) {
        if (type->getSignature() != sig) {
          return {};
        }
      }
      return {{*type, ids}};
    }
    return {{ctx.types[ctx.signatureIndices.at(sig)], ids}};
  }
}

// import      ::= '(' 'import' mod:name nm:name d:importdesc ')'
//                     => {module mod, name nm, desc d}
// importdesc  ::= '(' 'func' id? (x,IDs):typeuse ')' => func x
//               | '(' 'table' id? tt:tabletype ')'   => table tt
//               | '(' 'memory' id? mt:memtype ')'    => mem mt
//               | '(' 'global' id? gt:globaltype ')' => global gt
template<typename Ctx> Result<> import(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();

  if (!in.takeSExprStart("import"sv)) {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    if (ctx.hasNonImport) {
      return {};
    }
  }

  auto mod = in.takeName();
  if (!mod) {
    return {};
  }

  auto nm = in.takeName();
  if (!nm) {
    return {};
  }

  if (in.takeSExprStart("func"sv)) {
    [[maybe_unused]] auto id = in.takeID();
    auto type = typeuse(ctx, in);
    if (!type) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      // TODO: Insert import.
    } else {
      // TODO: Fill out import.
    }
  } else if (in.takeSExprStart("table"sv)) {
    [[maybe_unused]] auto id = in.takeID();
    auto type = tabletype(ctx, in);
    if (!type) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      // TODO: Insert import.
    } else {
      // TODO: Fill out import.
    }
  } else if (in.takeSExprStart("memory"sv)) {
    [[maybe_unused]] auto id = in.takeID();
    auto type = memtype(in);
    if (!type) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      // TODO: Insert import.
    } else {
      // TODO: Fill out import.
    }
  } else if (in.takeSExprStart("global"sv)) {
    [[maybe_unused]] auto id = in.takeID();
    auto type = globaltype(ctx, in);
    if (!type) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      // TODO: Insert import.
    } else {
      // TODO: Fill out import.
    }
  } else {
    return {};
  }

  if (!in.takeRParen()) {
    return {};
  }

  if (!in.takeRParen()) {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.importDefs.push_back({{}, in.getSpanSince(start)});
  }

  return Ok{};
}

// local ::= '(' 'local' id t:valtype ')' => [(t, id)]
//         | '(' 'local' (t:valtype)* ')' => [t*]
template<typename Ctx>
Result<typename Ctx::Locals> local(Ctx& ctx, ParseInput& in) {
  if (!in.takeSExprStart("local"sv)) {
    return {};
  }

  if (auto id = in.takeID()) {
    auto type = valtype(ctx, in);
    if (!type) {
      return {};
    }
    if (!in.takeRParen()) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      return Ok{};
    } else if constexpr (parsingDefs<Ctx>) {
      return {{{*id, *type}}};
    }
  }

  std::vector<NameType> locals;
  while (!in.takeRParen()) {
    auto type = valtype(ctx, in);
    if (!type) {
      return {};
    }
    if constexpr (parsingDefs<Ctx>) {
      locals.push_back({Name(), *type});
    }
  }
  if constexpr (parsingDecls<Ctx>) {
    return Ok{};
  } else if constexpr (parsingDefs<Ctx>) {
    return locals;
  }
}

Result<ImportNames> inlineImport(ParseInput& in) {
  if (!in.takeSExprStart("import"sv)) {
    // TODO: Differentiate between absence and errors at call sites.
    return {};
  }
  auto mod = in.takeName();
  if (!mod) {
    return {};
  }
  auto nm = in.takeName();
  if (!nm) {
    return {};
  }
  if (!in.takeRParen()) {
    return {};
  }
  return {{*mod, *nm}};
}

Result<std::vector<Name>> inlineExports(ParseInput& in) {
  std::vector<Name> exports;
  while (in.takeSExprStart("export"sv)) {
    auto name = in.takeName();
    if (!name) {
      return {};
    }
    if (!in.takeRParen()) {
      return {};
    }
    exports.push_back(*name);
  }
  return exports;
}

// func  ::= '(' 'func' id? ('(' 'export' name ')')*
//               x:typeuse (t:local)* (in:instr)* ')'
//       ::= '(' 'func' id? ('(' 'export' name ')')*
//               '(' 'import' mod:name nm:name ')' x:typeuse ')'
template<typename Ctx> Result<> func(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();

  if (!in.takeSExprStart("func"sv)) {
    return {};
  }

  [[maybe_unused]] auto id = in.takeID();

  auto exports = inlineExports(in);
  if (!exports) {
    return {};
  }

  auto import = inlineImport(in);

  auto type = typeuse(ctx, in);
  if (!type) {
    return {};
  }

  if (import) {
    if (!in.takeRParen()) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      ctx.funcDefs.push_back({{}, in.getSpanSince(start)});
      // TODO: Insert import
      // TODO: Add exports
    } else if constexpr (parsingDefs<Ctx>) {
      // TODO: Set import type
    }
    return Ok{};
  }

  while (auto locs = local(ctx, in)) {
    // TODO: collect and install locals
  }

  auto body = instrs(ctx, in);
  if (!body) {
    return {};
  }

  if (!in.takeRParen()) {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.funcDefs.push_back({{}, in.getSpanSince(start)});
    // TODO: Insert function
    // TODO: Add exports
  } else if constexpr (parsingDefs<Ctx>) {
    // TODO: Set function type, params, locals, body
  }
  return Ok{};
}

// table ::= '(' 'table' id? ('(' 'export' name ')')* tt:tabletype ')'
//         | '(' 'table' id? ('(' 'export' name ')')* reftype
//               '(' 'elem' (e:elemexpr)* ')' ')'
//         | '(' 'table' id? ('(' 'export' name ')')* reftype
//               '(' 'elem' (f:funcidx)* ')' ')'
//         | '(' 'table' id? ('(' 'export' name ')')*
//               '(' 'import' mod:name nm:name ')' tt:tabletype ')'
template<typename Ctx> Result<> table(Ctx& ctx, ParseInput& in) {
  // if (!in.takeSExprStart("table"sv)) {
  //   return {};
  // }

  // auto id = in.takeID();

  // auto exports = inlineExports(in);
  // if (!exports) {
  //   return {};
  // }

  // TODO
  return {};
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
  if constexpr (parsingDecls<Ctx>) {
    return Ok{};
  } else if constexpr (parsingDefs<Ctx>) {
    return data;
  }
}

// mem ::= '(' 'memory' id? ('(' 'export' name ')')* mt:memtype ')'
//       | '(' 'memory' id? ('(' 'export' name ')')*
//             '(' 'data' b:datastring ')' ')'
//       | '(' 'memory' id? ('(' 'export' name ')')*
//             '(' 'import' mod:name nm:name ')' mt:memtype ')'
template<typename Ctx> Result<> mem(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();
  if (!in.takeSExprStart("memory"sv)) {
    return {};
  }

  [[maybe_unused]] auto id = in.takeID();

  auto exports = inlineExports(in);
  if (!exports) {
    return {};
  }

  auto import = inlineImport(in);

  auto type = memtype(in);

  if (import) {
    if (!type) {
      return {};
    }
    if (!in.takeRParen()) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      ctx.memDefs.push_back({{}, in.getSpanSince(start)});
      // TODO: Insert import
      // TODO: Add exports
    } else if constexpr (parsingDefs<Ctx>) {
      // TODO: Set import type
    }
    return Ok{};
  }

  if (type) {
    if (!in.takeRParen()) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      ctx.memDefs.push_back({{}, in.getSpanSince(start)});
      // TODO: Insert mem
    }
  } else {
    if (!in.takeSExprStart("data"sv)) {
      return {};
    }
    [[maybe_unused]] auto data = datastring(ctx, in);
    if (!in.takeRParen()) {
      return {};
    }
    if (!in.takeRParen()) {
      return {};
    }
    if constexpr (parsingDecls<Ctx>) {
      ctx.memDefs.push_back({{}, in.getSpanSince(start)});
      // TODO: Insert mem
      // TODO: Add exports;
    } else if constexpr (parsingDefs<Ctx>) {
      // TODO: Add data
    }
  }
  return Ok{};
}

Result<Global*> addGlobalDecl(ParseDeclsCtx& ctx,
                              Name name,
                              std::optional<ImportNames> importNames) {
  auto g = std::make_unique<Global>();
  if (name.is()) {
    if (ctx.wasm.getGlobalOrNull(name)) {
      // TDOO: if the existing global is not explicitly named, fix its name and
      // continue.
      return {};
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
template<typename Ctx> Result<> global(Ctx& ctx, ParseInput& in) {
  auto start = in.getPos();
  if (!in.takeSExprStart("global"sv)) {
    return {};
  }

  Name name;
  if (auto id = in.takeID()) {
    name = *id;
  }

  auto exports = inlineExports(in);
  if (!exports) {
    return {};
  }

  auto import = inlineImport(in);

  auto gtype = globaltype(ctx, in);
  if (!gtype) {
    return {};
  }

  if (import) {
    if (!in.takeRParen()) {
      return {};
    }

    if constexpr (parsingDecls<Ctx>) {
      if (ctx.hasNonImport) {
        return {};
      }
      auto g = addGlobalDecl(ctx, name, *import);
      if (!g) {
        return {};
      }
      if (!addExports(ctx.wasm, *g, *exports, ExternalKind::Global)) {
        return {};
      }
      ctx.globalDefs.push_back({name, in.getSpanSince(start)});
    } else {
      finishGlobalDef(*ctx.wasm.globals[ctx.index], *gtype, nullptr);
    }
    return Ok{};
  }

  auto exp = expr(ctx, in);
  if (!exp) {
    return {};
  }

  if (!in.takeRParen()) {
    return {};
  }

  if constexpr (parsingDecls<Ctx>) {
    ctx.hasNonImport = true;
    if (!addGlobalDecl(ctx, name, {})) {
      return {};
    }
    ctx.globalDefs.push_back({name, in.getSpanSince(start)});
  } else {
    finishGlobalDef(*ctx.wasm.globals[ctx.index], *gtype, *exp);
  }
  return Ok{};
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
Result<> modulefield(ParseDeclsCtx& ctx, ParseInput& in) {
  if (type(ctx, in)) {
    return Ok{};
  }
  if (import(ctx, in)) {
    return Ok{};
  }
  if (func(ctx, in)) {
    return Ok{};
  }
  if (table(ctx, in)) {
    return Ok{};
  }
  if (mem(ctx, in)) {
    return Ok{};
  }
  if (global(ctx, in)) {
    return Ok{};
  }
  // if (export(ctx, in)) {
  //   return Ok{};
  // }
  // if (start(ctx, in)) {
  //   return Ok{};
  // }
  // if (elem(ctx, in)) {
  //   return Ok{};
  // }
  // if (data(ctx, in)) {
  //   return Ok{};
  // }
  return {};
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

  while (modulefield(ctx, in)) {
  }

  if (outer && !in.takeRParen()) {
    return {};
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

Result<> addExports(Module& wasm,
                    const Named* item,
                    const std::vector<Name>& exports,
                    ExternalKind kind) {
  for (auto name : exports) {
    if (wasm.getExportOrNull(name)) {
      return {};
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
        return {};
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
    if (!module(decls, in)) {
      return {};
    }
    if (!in.next().empty()) {
      return {};
    }
  }

  auto typeIndices = createIndexMap(decls.explicitTypeDefs);
  if (!typeIndices) {
    return {};
  }

  // Parse type definitions.
  std::vector<HeapType> types;
  std::unordered_map<Signature, Index> signatureIndices;
  {
    TypeBuilder builder(decls.explicitTypeDefs.size());
    for (Index i = 0; i < decls.explicitTypeDefs.size(); ++i) {
      ParseTypesCtx ctx(builder, *typeIndices, i);
      ParseInput in(decls.explicitTypeDefs[i].span);
      if (!type(ctx, in)) {
        return {};
      }
      if (HeapType t = builder[i]; t.isSignature()) {
        signatureIndices.insert({t.getSignature(), i});
      }
    }
    auto built = builder.build();
    if (!built) {
      return {};
    }
    types = *built;
    // Now that we have built the explicit types, parse type uses that might
    // implicitly define new signatures and add any signature we have not
    // already seen to the list of types.
    for (auto& span : decls.implicitTypeDefs) {
      ParseImplicitTypesCtx ctx(*typeIndices, types);
      ParseInput in(span);
      auto sig = typeuse(ctx, in);
      if (!sig) {
        return {};
      }
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
  if (!funcIndices) {
    return {};
  }
  auto memIndices = createIndexMap(decls.memDefs);
  if (!memIndices) {
    return {};
  }
  auto tableIndices = createIndexMap(decls.tableDefs);
  if (!tableIndices) {
    return {};
  }
  auto globalIndices = createIndexMap(decls.globalDefs);
  if (!globalIndices) {
    return {};
  }
  auto elemIndices = createIndexMap(decls.elemDefs);
  if (!elemIndices) {
    return {};
  }
  auto dataIndices = createIndexMap(decls.dataDefs);
  if (!dataIndices) {
    return {};
  }

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
    [&](auto& defs, Result<> (*parse)(ParseDefsCtx&, ParseInput&)) -> Result<> {
    for (Index i = 0; i < defs.size(); ++i) {
      ctx.index = i;
      ParseInput in(defs[i].span);
      if (!parse(ctx, in)) {
        return {};
      }
    }
    return Ok{};
  };

  if (!parseDefs(decls.importDefs, import)) {
    return {};
  }
  if (!parseDefs(decls.funcDefs, func)) {
    return {};
  }
  if (!parseDefs(decls.memDefs, mem)) {
    return {};
  }
  if (!parseDefs(decls.tableDefs, table)) {
    return {};
  }
  if (!parseDefs(decls.globalDefs, global)) {
    return {};
  }
  // if (!parseDefs(decls.elemDefs, elem)) {
  //   return {};
  // }
  // if (!parseDefs(decls.dataDefs, data)) {
  //   return {};
  // }

  return Ok{};
}

} // namespace wasm::WATParser
