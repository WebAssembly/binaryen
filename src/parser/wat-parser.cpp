/*
 * Copyright 2023 WebAssembly Community Group participants
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
#include "contexts.h"
#include "ir/names.h"
#include "lexer.h"
#include "parsers.h"
#include "wasm-type.h"
#include "wasm.h"

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

namespace wasm::WATParser {

namespace {

Result<IndexMap> createIndexMap(Lexer& in, const std::vector<DefPos>& defs) {
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

template<typename Ctx>
Result<> parseDefs(Ctx& ctx,
                   const std::vector<DefPos>& defs,
                   MaybeResult<> (*parser)(Ctx&)) {
  for (auto& def : defs) {
    ctx.index = def.index;
    WithPosition with(ctx, def.pos);
    if (auto parsed = parser(ctx)) {
      CHECK_ERR(parsed);
    } else {
      auto im = import_(ctx);
      assert(im);
      CHECK_ERR(im);
    }
  }
  return Ok{};
}

// ================
// Parser Functions
// ================

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
  std::unordered_map<HeapType, std::unordered_map<Name, Index>> typeNames;
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
    // Record type names on the module and in typeNames.
    for (size_t i = 0; i < types.size(); ++i) {
      auto& names = ctx.names[i];
      auto& fieldNames = names.fieldNames;
      if (names.name.is() || fieldNames.size()) {
        wasm.typeNames.insert({types[i], names});
        auto& fieldIdxMap = typeNames[types[i]];
        for (auto [idx, name] : fieldNames) {
          fieldIdxMap.insert({name, idx});
        }
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
    ParseModuleTypesCtx ctx(input,
                            wasm,
                            types,
                            implicitTypes,
                            decls.implicitElemIndices,
                            *typeIndices);
    CHECK_ERR(parseDefs(ctx, decls.funcDefs, func));
    CHECK_ERR(parseDefs(ctx, decls.tableDefs, table));
    CHECK_ERR(parseDefs(ctx, decls.memoryDefs, memory));
    CHECK_ERR(parseDefs(ctx, decls.globalDefs, global));
    CHECK_ERR(parseDefs(ctx, decls.elemDefs, elem));
    CHECK_ERR(parseDefs(ctx, decls.tagDefs, tag));
  }
  {
    // Parse definitions.
    // TODO: Parallelize this.
    ParseDefsCtx ctx(input,
                     wasm,
                     types,
                     implicitTypes,
                     typeNames,
                     decls.implicitElemIndices,
                     *typeIndices);
    CHECK_ERR(parseDefs(ctx, decls.tableDefs, table));
    CHECK_ERR(parseDefs(ctx, decls.globalDefs, global));
    CHECK_ERR(parseDefs(ctx, decls.startDefs, start));
    CHECK_ERR(parseDefs(ctx, decls.elemDefs, elem));
    CHECK_ERR(parseDefs(ctx, decls.dataDefs, data));

    for (Index i = 0; i < decls.funcDefs.size(); ++i) {
      ctx.index = i;
      auto* f = wasm.functions[i].get();
      if (!f->imported()) {
        CHECK_ERR(ctx.visitFunctionStart(f));
      }
      WithPosition with(ctx, decls.funcDefs[i].pos);
      if (auto parsed = func(ctx)) {
        CHECK_ERR(parsed);
      } else {
        auto im = import_(ctx);
        assert(im);
        CHECK_ERR(im);
      }
      if (!f->imported()) {
        CHECK_ERR(ctx.irBuilder.visitEnd());
      }
    }

    // Parse exports.
    // TODO: It would be more technically correct to interleave these properly
    // with the implicit inline exports in other module field definitions.
    for (auto pos : decls.exportDefs) {
      WithPosition with(ctx, pos);
      auto parsed = export_(ctx);
      CHECK_ERR(parsed);
      assert(parsed);
    }
  }

  return Ok{};
}

} // namespace wasm::WATParser
