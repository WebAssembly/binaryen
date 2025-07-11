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

namespace {

// List out instructions serially, so we can match them between the old and
// new copies.
//
// This is not that efficient, and in theory we could copy this in the
// caller context as the code is copied. However, we assume that most
// functions have no metadata, so this is faster in that common case.
struct Serializer : public PostWalker<Serializer, UnifiedExpressionVisitor<Serializer>> {
  Serializer(Expression* expr) { walk(expr); }

  std::vector<Expression*> list;

  void visitExpression(Expression* curr) { list.push_back(curr); }
};

} // anonymous namespace

void copyBetweenFunctions(Expression* origin,
                          Expression* copy,
                          Function* originFunc,
                          Function* copyFunc) {
  if (originFunc->debugLocations.empty() &&
      originFunc->codeAnnotations.empty()) {
    // Nothing to copy.
    return;
  }

  Serializer originList(origin);
  Serializer copyList(copy);

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

// Given two expressions to use as keys, see if they have identical values (or
// identically is absent from) in two maps.
template<typename T>
bool compare(Expression* a, Expression* b, const T& aMap, const T& bMap) {
  auto aIter = aMap.find(a);
  auto bIter = bMap.find(b);
  if (aIter == aMap.end() && bIter == bMap.end()) {
    return true;
  }
  if (aIter == aMap.end() || bIter == bMap.end()) {
    return false;
  }
  return aIter->second == bIter->second;
}

bool equal(Function* a, Function* b) {
  Serializer aList(a->body);
  Serializer bList(b->body);

  assert(aList.list.size() == bList.list.size());
  for (Index i = 0; i < aList.list.size(); i++) {
    if (!compare(aList[i].list, bList[i].list, a->debugLocations, b->debugLocations) ||
        !compare(aList[i].list, bList[i].list, a->codeAnnotations, b->codeAnnotations)) {
      return false;
    }
  }
}

} // namespace wasm::metadata
