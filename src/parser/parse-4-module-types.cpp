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

Result<> parseModuleTypes(ParseDeclsCtx& decls,
                          Lexer& input,
                          IndexMap& typeIndices,
                          std::vector<HeapType>& types,
                          std::unordered_map<Index, HeapType>& implicitTypes) {
  ParseModuleTypesCtx ctx(input,
                          decls.wasm,
                          types,
                          implicitTypes,
                          decls.implicitElemIndices,
                          typeIndices);
  CHECK_ERR(parseDefs(ctx, decls.funcDefs, func));
  CHECK_ERR(parseDefs(ctx, decls.tableDefs, table));
  CHECK_ERR(parseDefs(ctx, decls.memoryDefs, memory));
  CHECK_ERR(parseDefs(ctx, decls.globalDefs, global));
  CHECK_ERR(parseDefs(ctx, decls.elemDefs, elem));
  CHECK_ERR(parseDefs(ctx, decls.tagDefs, tag));
  return Ok{};
}

} // namespace wasm::WATParser
