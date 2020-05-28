/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_ir_find_all_h
#define wasm_ir_find_all_h

#include "ir/iteration.h"
#include <wasm-traversal.h>

namespace wasm {

// Find all instances of a certain node type

template<typename T> struct FindAll {
  std::vector<T*> list;

  FindAll(Expression* ast) {
    struct Finder
      : public PostWalker<Finder, UnifiedExpressionVisitor<Finder>> {
      std::vector<T*>* list;
      void visitExpression(Expression* curr) {
        if (curr->is<T>()) {
          (*list).push_back(curr->cast<T>());
        }
      }
    };
    Finder finder;
    finder.list = &list;
    finder.walk(ast);
  }
};

// Find all pointers to instances of a certain node type

struct PointerFinder
  : public PostWalker<PointerFinder, UnifiedExpressionVisitor<PointerFinder>> {
  Expression::Id id;
  std::vector<Expression**>* list;
  void visitExpression(Expression* curr) {
    if (curr->_id == id) {
      (*list).push_back(getCurrentPointer());
    }
  }
};

template<typename T> struct FindAllPointers {
  std::vector<Expression**> list;

  // Note that a pointer may be to the function->body itself, so we must
  // take \ast by reference.
  FindAllPointers(Expression*& ast) {
    PointerFinder finder;
    finder.id = (Expression::Id)T::SpecificId;
    finder.list = &list;
    finder.walk(ast);
  }
};

// Returns true if the current expression contains a certain kind of expression,
// within the given depth of BFS.
template<typename T> bool contains(Expression* curr, int depth) {
  std::vector<Expression*> exprs;
  std::vector<Expression*> nextExprs;
  if (curr->is<T>()) {
    return true;
  }
  exprs.push_back(curr);
  while (!exprs.empty() && depth > 0) {
    for (auto* expr : exprs) {
      for (auto* child : ChildIterator(expr)) {
        if (child->is<T>()) {
          return true;
        }
        nextExprs.push_back(child);
      }
    }
    exprs.swap(nextExprs);
    nextExprs.clear();
    depth--;
  }
  return false;
}

} // namespace wasm

#endif // wasm_ir_find_all_h
