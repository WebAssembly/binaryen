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
struct Serializer
  : public PostWalker<Serializer, UnifiedExpressionVisitor<Serializer>> {
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

#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wmaybe-uninitialized"

// Given two expressions to use as keys, see if they have identical values (or
// are both absent) in two maps.
template<typename T, typename V>
bool compare(Expression* a,
             Expression* b,
             const T& aMap,
             const T& bMap,
             const V defaultValue) {
  auto aIter = aMap.find(a);
  auto aItem = aIter != aMap.end() ? aIter->second : defaultValue;
  auto bIter = bMap.find(b);
  auto bItem = bIter != bMap.end() ? bIter->second : defaultValue;
  return aItem == bItem;
}

bool equal(Function* a, Function* b) {
  if (a->imported() && b->imported()) {
    // No code metadata, and we don't yet store function-level metadata.
    return true;
  }
  if (a->imported() || b->imported()) {
    // See comment on declaration, we consider such a difference as making them
    // unequal.
    return false;
  }

  // TODO: We do not consider debug locations here. This is often what is
  //       desired in optimized builds (e.g. if we are trying to fold two
  //       pieces of code together, that benefit outweighs slightly inaccurate
  //       debug info). If we find that non-optimizer locations call this in
  //       ways that lead to degraded debug info, we could add an option to
  //       control it.

  if (a->codeAnnotations.empty() && b->codeAnnotations.empty()) {
    // Nothing to compare; no differences.
    return true;
  }

  Serializer aList(a->body);
  Serializer bList(b->body);

  if (aList.list.size() != bList.list.size()) {
    return false;
  }

  assert(aList.list.size() == bList.list.size());
  for (Index i = 0; i < aList.list.size(); i++) {
    if (!compare(aList.list[i],
                 bList.list[i],
                 a->codeAnnotations,
                 b->codeAnnotations,
                 Function::CodeAnnotation())) {
      return false;
    }
  }

  return true;
}

#pragma GCC diagnostic pop

} // namespace wasm::metadata
