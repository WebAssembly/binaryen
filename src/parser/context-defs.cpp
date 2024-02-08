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

#include "contexts.h"

namespace wasm::WATParser {

Result<typename ParseDefsCtx::TypeUseT>
ParseDefsCtx::makeTypeUse(Index pos,
                          std::optional<HeapTypeT> type,
                          ParamsT* params,
                          ResultsT* results) {
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
      return in.err(pos, "type does not match provided signature");
    }
  }

  if (type) {
    return *type;
  }

  auto it = implicitTypes.find(pos);
  assert(it != implicitTypes.end());
  return it->second;
}

Result<> ParseDefsCtx::addGlobal(Name,
                                 const std::vector<Name>&,
                                 ImportNames*,
                                 GlobalTypeT,
                                 std::optional<ExprT> exp,
                                 Index) {
  if (exp) {
    wasm.globals[index]->init = *exp;
  }
  return Ok{};
}

Result<> ParseDefsCtx::addImplicitElems(Type,
                                        std::vector<Expression*>&& elems) {
  auto& e = wasm.elementSegments[implicitElemIndices.at(index)];
  e->data = std::move(elems);
  return Ok{};
}

Result<> ParseDefsCtx::addElem(Name,
                               Name* table,
                               std::optional<Expression*> offset,
                               std::vector<Expression*>&& elems,
                               Index pos) {
  auto& e = wasm.elementSegments[index];
  if (offset) {
    e->offset = *offset;
    if (table) {
      e->table = *table;
    } else if (wasm.tables.size() > 0) {
      e->table = wasm.tables[0]->name;
    } else {
      return in.err(pos, "active element segment with no table");
    }
  } else {
    e->offset = nullptr;
    e->table = Name();
  }
  e->data = std::move(elems);
  return Ok{};
}

Result<> ParseDefsCtx::addData(
  Name, Name* mem, std::optional<ExprT> offset, DataStringT, Index pos) {
  auto& d = wasm.dataSegments[index];
  if (offset) {
    d->isPassive = false;
    d->offset = *offset;
    if (mem) {
      d->memory = *mem;
    } else if (wasm.memories.size() > 0) {
      d->memory = wasm.memories[0]->name;
    } else {
      return in.err(pos, "active data segment with no memory");
    }
  } else {
    d->isPassive = true;
  }
  return Ok{};
}

} // namespace wasm::WATParser
