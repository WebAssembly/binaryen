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

void handleNonNullableLocals(Function* func, Module& wasm) {
  // Check if this is an issue.
  bool hasNonNullable = false;
  for (auto type : func->vars) {
    if (type.isRef() && !type.isNullable()) {
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
    auto type = func->getLocalType(get->index);
    if (type.isRef() && !type.isNullable()) {
      // The get should now return a nullable value, and a ref.as_non_null
      // fixes that up.
      get->type = Type(type.getHeapType(), Nullable);
      *getp = builder.makeRefAs(RefAsNonNull, get);
    }
  }

  // Rewrite the types of the function's vars (which we can do now, after we
  // are done using them to know which local.gets to fix).
  for (auto& type : func->vars) {
    if (type.isRef() && !type.isNullable()) {
      type = Type(type.getHeapType(), Nullable);
    }
  }
}

} // namespace TypeUpdating

} // namespace wasm
