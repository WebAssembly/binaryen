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

#include "ir/metadata.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm::metadata {

void copyBetweenFunctions(Expression* origin,
                          Expression* copy,
                          Function* originFunc,
                          Function* copyFunc) {
  if (originFunc->debugLocations.empty() &&
      originFunc->codeAnnotations.empty()) {
    // Nothing to copy.
    return;
  }

  // List out instructions serially, so we can match them between the old and
  // new copies.
  //
  // This is not that efficient, and in theory we could copy this in the
  // caller context as the code is copied. However, we assume that most
  // functions have no metadata, so this is faster in that common case.
  struct Lister : public PostWalker<Lister, UnifiedExpressionVisitor<Lister>> {
    std::vector<Expression*> list;
    void visitExpression(Expression* curr) { list.push_back(curr); }
  };

  Lister originList;
  originList.walk(origin);
  Lister copyList;
  copyList.walk(copy);

  auto& originDebug = originFunc->debugLocations;
  auto& copyDebug = copyFunc->debugLocations;

  auto& originAnnotations = originFunc->codeAnnotations;
  auto& copyAnnotations = copyFunc->codeAnnotations;

  assert(originList.list.size() == copyList.list.size());
  for (Index i = 0; i < originList.list.size(); i++) {
    {
      auto iter = originDebug.find(originList.list[i]);
      if (iter != originDebug.end()) {
        copyDebug[copyList.list[i]] = iter->second;
      }
    }

    {
      auto iter = originAnnotations.find(originList.list[i]);
      if (iter != originAnnotations.end()) {
        copyAnnotations[copyList.list[i]] = iter->second;
      }
    }
  }
}

} // namespace wasm::metadata
