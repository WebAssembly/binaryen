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

Result<> parseTypeDefs(
  ParseDeclsCtx& decls,
  Lexer& input,
  IndexMap& typeIndices,
  std::vector<HeapType>& types,
  std::unordered_map<HeapType, std::unordered_map<Name, Index>>& typeNames) {
  TypeBuilder builder(decls.typeDefs.size());
  ParseTypeDefsCtx ctx(input, builder, typeIndices);
  for (auto& recType : decls.recTypeDefs) {
    WithPosition with(ctx, recType.pos);
    CHECK_ERR(rectype(ctx));
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
      decls.wasm.typeNames.insert({types[i], names});
      auto& fieldIdxMap = typeNames[types[i]];
      for (auto [idx, name] : fieldNames) {
        fieldIdxMap.insert({name, idx});
      }
    }
  }
  return Ok{};
}

} // namespace wasm::WATParser
