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

#include "table-utils.h"
#include "element-utils.h"
#include "find_all.h"
#include "module-utils.h"

namespace wasm::TableUtils {

std::set<Name> getFunctionsNeedingElemDeclare(Module& wasm) {
  // Without reference types there are no ref.funcs or elem declare.
  if (!wasm.features.hasReferenceTypes()) {
    return {};
  }

  // Find all the names in the tables.

  std::unordered_set<Name> tableNames;
  ElementUtils::iterAllElementFunctionNames(
    &wasm, [&](Name name) { tableNames.insert(name); });

  // Find all the names in ref.funcs.
  using Names = std::unordered_set<Name>;

  ModuleUtils::ParallelFunctionAnalysis<Names> analysis(
    wasm, [&](Function* func, Names& names) {
      if (func->imported()) {
        return;
      }
      for (auto* refFunc : FindAll<RefFunc>(func->body).list) {
        names.insert(refFunc->func);
      }
    });

  // Find the names that need to be declared.

  std::set<Name> ret;

  for (auto& kv : analysis.map) {
    auto& names = kv.second;
    for (auto name : names) {
      if (!tableNames.count(name)) {
        ret.insert(name);
      }
    }
  }

  return ret;
}

bool usesExpressions(ElementSegment* curr, Module* module) {
  // Binaryen IR always has ref.funcs for functions in tables for uniformity,
  // so that by itself does not indicate if expressions should be used when
  // emitting the table or not. But definitely anything that is not a ref.func
  // implies we are post-MVP and must use expressions.
  bool allElementsRefFunc =
    std::all_of(curr->data.begin(), curr->data.end(), [](Expression* entry) {
      return entry->is<RefFunc>();
    });

  // If the segment has a specialized (non-MVP) type, then it must use the
  // post-MVP form of using expressions.
  bool hasSpecializedType = curr->type != Type(HeapType::func, Nullable);

  return !allElementsRefFunc || hasSpecializedType;
}

} // namespace wasm::TableUtils
