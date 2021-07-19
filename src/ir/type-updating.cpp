/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include "type-updating.h"
#include "find_all.h"

namespace wasm {

namespace TypeUpdating {

bool canHandleAsLocal(Type type) {
  // Defaultable types are always ok. For non-nullable types, we can handle them
  // using defaultable ones + ref.as_non_nulls.
  return type.isDefaultable() || type.isRef();
}

void handleNonDefaultableLocals(Function* func, Module& wasm) {
  // Check if this is an issue.
  if (wasm.features.hasGCNNLocals()) {
    return;
  }
  bool hasNonNullable = false;
  for (auto type : func->vars) {
    if (type.isNonNullable()) {
      hasNonNullable = true;
      break;
    }
  }
  if (!hasNonNullable) {
    return;
  }

  // Rewrite the local.gets.
  Builder builder(wasm);
  for (auto** getp : FindAllPointers<LocalGet>(func->body).list) {
    auto* get = (*getp)->cast<LocalGet>();
    if (!func->isVar(get->index)) {
      // We do not need to process params, which can legally be non-nullable.
      continue;
    }
    auto type = func->getLocalType(get->index);
    if (type.isNonNullable()) {
      // The get should now return a nullable value, and a ref.as_non_null
      // fixes that up.
      get->type = Type(type.getHeapType(), Nullable);
      *getp = builder.makeRefAs(RefAsNonNull, get);
    }
  }

  // Update tees, whose type must match the local (if the wasm spec changes for
  // the type to be that of the value, then this can be removed).
  for (auto** setp : FindAllPointers<LocalSet>(func->body).list) {
    auto* set = (*setp)->cast<LocalSet>();
    if (!func->isVar(set->index)) {
      // We do not need to process params, which can legally be non-nullable.
      continue;
    }
    // Non-tees do not change, and unreachable tees can be ignored here as their
    // type is unreachable anyhow.
    if (!set->isTee() || set->type == Type::unreachable) {
      continue;
    }
    auto type = func->getLocalType(set->index);
    if (type.isNonNullable()) {
      set->type = Type(type.getHeapType(), Nullable);
      *setp = builder.makeRefAs(RefAsNonNull, set);
    }
  }

  // Rewrite the types of the function's vars (which we can do now, after we
  // are done using them to know which local.gets etc to fix).
  for (auto& type : func->vars) {
    if (type.isNonNullable()) {
      type = Type(type.getHeapType(), Nullable);
    }
  }
}

} // namespace TypeUpdating

} // namespace wasm
