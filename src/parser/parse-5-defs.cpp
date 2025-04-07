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

#include "wat-parser-internal.h"

namespace wasm::WATParser {

Result<> parseDefinitions(
  ParseDeclsCtx& decls,
  Lexer& input,
  IndexMap& typeIndices,
  std::vector<HeapType>& types,
  std::unordered_map<Index, HeapType>& implicitTypes,
  std::unordered_map<HeapType, std::unordered_map<Name, Index>>& typeNames) {
  // Parse definitions.
  // TODO: Parallelize this.
  ParseDefsCtx ctx(input,
                   decls.wasm,
                   types,
                   implicitTypes,
                   typeNames,
                   decls.implicitElemIndices,
                   typeIndices);
  CHECK_ERR(parseDefs(ctx, decls.tableDefs, table));
  CHECK_ERR(parseDefs(ctx, decls.globalDefs, global));
  CHECK_ERR(parseDefs(ctx, decls.startDefs, start));
  CHECK_ERR(parseDefs(ctx, decls.elemDefs, elem));
  CHECK_ERR(parseDefs(ctx, decls.dataDefs, data));

  for (Index i = 0; i < decls.funcDefs.size(); ++i) {
    ctx.index = i;
    auto* f = decls.wasm.functions[i].get();
    WithPosition with(ctx, decls.funcDefs[i].pos);
    ctx.setSrcLoc(decls.funcDefs[i].annotations);
    if (!f->imported()) {
      CHECK_ERR(ctx.visitFunctionStart(f));
    }
    if (auto parsed = func(ctx)) {
      CHECK_ERR(parsed);
    } else {
      auto im = import_(ctx);
      assert(im);
      CHECK_ERR(im);
    }
    if (!f->imported()) {
      auto end = ctx.irBuilder.visitEnd();
      if (auto* err = end.getErr()) {
        return ctx.in.err(decls.funcDefs[i].pos, err->msg);
      }
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
  return Ok{};
}

Result<Literal> parseConst(Lexer& lexer) {
  Module wasm;
  ParseDefsCtx ctx(lexer, wasm, {}, {}, {}, {}, {});
  auto inst = foldedinstr(ctx);
  CHECK_ERR(inst);
  auto expr = ctx.irBuilder.build();
  if (auto* err = expr.getErr()) {
    return lexer.err(err->msg);
  }
  auto* e = *expr;
  if (!e->is<Const>() && !e->is<RefNull>() && !e->is<RefI31>()) {
    return lexer.err("expected constant");
  }
  lexer = ctx.in;
  return getLiteralFromConstExpression(e);
}

} // namespace wasm::WATParser
