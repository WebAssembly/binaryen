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
// The second phase, not yet implemented, parses type definitions to construct
// the types used in the module. This has to be its own phase because we have no
// way to refer to a type before it has been built along with all the other
// types, unlike for other module elements that can be referred to by name
// before their definitions have been parsed.
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
// In the fifth and final phase, not yet implemented, parses the remaining
// contents of all module elements, including instructions.
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

// Phase 1: Parse definition spans for top-level module elements and determine
// their indices and names.
struct ParseDeclsCtx {
  // At this stage we only look at types to find implicit type definitions,
  // which are inserted directly in to the context. We cannot materialize or
  // validate any types because we don't know what types exist yet.
  using ValTypeT = Ok;
  using GlobalTypeT = Ok;

  // Declared module elements are inserted into the module, but their bodies are
  // not filled out until later parsing phases.
  Module& wasm;

  // The module element definitions we are parsing in this phase.
  std::vector<DefPos> globalDefs;

  // Counters used for generating names for module elements.
  int globalCounter = 0;

  // Used to verify that all imports come before all non-imports.
  bool hasNonImport = false;

  ParseDeclsCtx(Module& wasm) : wasm(wasm) {}
};

template<typename Ctx>
inline constexpr bool parsingDecls = std::is_same_v<Ctx, ParseDeclsCtx>;

// TODO: Phase 2: ParseTypeDefsCtx
// TODO: Phase 3: ParseImplicitTypeDefsCtx

// Phase 4: Parse and set the types of module elements.
struct ParseModuleTypesCtx {
  // In this phase we have constructed all the types, so we can materialize and
  // validate them when they are used.
  using ValTypeT = Type;
  using GlobalTypeT = GlobalType;

  Module& wasm;

  // The index of the current element in its index space.
  Index index = 0;

  ParseModuleTypesCtx(Module& wasm) : wasm(wasm) {}
};

template<typename Ctx>
inline constexpr bool parsingModuleTypes =
  std::is_same_v<Ctx, ParseModuleTypesCtx>;

// TODO: Phase 5: ParseDefsCtx

// ================
// Parser Functions
// ================

// Types
template<typename Ctx>
Result<typename Ctx::ValTypeT> valtype(Ctx&, ParseInput&);

// Modules
MaybeResult<ImportNames> inlineImport(ParseInput&);
Result<std::vector<Name>> inlineExports(ParseInput&);
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
template<typename Ctx>
Result<> parseDefs(Ctx& ctx,
                   std::string_view input,
                   const std::vector<DefPos>& defs,
                   MaybeResult<> (*parser)(Ctx&, ParseInput&));

// =====
// Types
// =====

// numtype ::= 'i32' => i32
//           | 'i64' => i64
//           | 'f32' => f32
//           | 'f64' => f64
// vectype ::= 'v128' => v128
// valtype ::= t:numtype => t
//           | t:vectype => t
//           | t:reftype => t
template<typename Ctx>
Result<typename Ctx::ValTypeT> valtype(Ctx& ctx, ParseInput& in) {
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
  } else {
    // TODO: reftype
    return in.err("expected valtype");
  }
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

// =======
// Modules
// =======

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
      CHECK_ERR(addExports(in, ctx.wasm, *g, *exports, ExternalKind::Global));
      ctx.globalDefs.push_back({name, pos});
    } else if constexpr (parsingModuleTypes<Ctx>) {
      auto& g = ctx.wasm.globals[ctx.index];
      g->mutable_ = type->mutability;
      g->type = type->type;
    }
    return Ok{};
  }

  return in.err("TODO: non-imported globals");
}

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
MaybeResult<> modulefield(ParseDeclsCtx& ctx, ParseInput& in) {
  if (auto t = in.peek(); !t || t->isRParen()) {
    return {};
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

  // TODO: Map names to indices.

  // TODO: Parse type definitions.

  // TODO: Parse implicit type definitions.

  // Parse module-level types.
  ParseModuleTypesCtx ctx(wasm);
  CHECK_ERR(parseDefs(ctx, input, decls.globalDefs, global));

  // TODO: Parse types of other module elements.

  // TODO: Parse definitions.

  return Ok{};
}

} // namespace wasm::WATParser
