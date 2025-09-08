/*
 * Copyright 2024 WebAssembly Community Group participants
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

#include "contexts.h"
#include "parsers.h"

#ifndef parser_wat_parser_internal_h
#define parser_wat_parser_internal_h

namespace wasm::WATParser {

Result<> parseDecls(ParseDeclsCtx& decls);

Result<> parseTypeDefs(
  ParseDeclsCtx& decls,
  Lexer& input,
  IndexMap& typeIndices,
  std::vector<HeapType>& types,
  std::unordered_map<HeapType, std::unordered_map<Name, Index>>& typeNames);

Result<>
parseImplicitTypeDefs(ParseDeclsCtx& decls,
                      Lexer& input,
                      IndexMap& typeIndices,
                      std::vector<HeapType>& types,
                      std::unordered_map<Index, HeapType>& implicitTypes);

Result<> parseModuleTypes(ParseDeclsCtx& decls,
                          Lexer& input,
                          IndexMap& typeIndices,
                          std::vector<HeapType>& types,
                          std::unordered_map<Index, HeapType>& implicitTypes);

Result<> parseDefinitions(
  ParseDeclsCtx& decls,
  Lexer& input,
  IndexMap& typeIndices,
  std::vector<HeapType>& types,
  std::unordered_map<Index, HeapType>& implicitTypes,
  std::unordered_map<HeapType, std::unordered_map<Name, Index>>& typeNames);

// RAII utility for temporarily changing the parsing position of a parsing
// context.
template<typename Ctx> struct WithPosition {
  Ctx& ctx;
  Index original;
  std::vector<Annotation> annotations;

  WithPosition(Ctx& ctx, Index pos)
    : ctx(ctx), original(ctx.in.getPos()),
      annotations(ctx.in.takeAnnotations()) {
    ctx.in.setPos(pos);
  }

  ~WithPosition() {
    ctx.in.setPos(original);
    ctx.in.setAnnotations(std::move(annotations));
  }
};

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

// Deduction guide to satisfy -Wctad-maybe-unsupported.
template<typename Ctx> WithPosition(Ctx& ctx, Index) -> WithPosition<Ctx>;

} // namespace wasm::WATParser

#endif // parser_wat_parser_internal_h
