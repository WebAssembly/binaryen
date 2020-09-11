/*
 * Copyright 2018 WebAssembly Community Group participants
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

#ifndef wasm_ir_iteration_h
#define wasm_ir_iteration_h

#include "ir/properties.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

//
// Allows iteration over the children of the expression, in order of execution
// where relevant.
//
//  * This skips missing children, e.g. if an if has no else, it is represented
//    as having 2 children (and not 3 with the last a nullptr).
//
// In general, it is preferable not to use this class and to directly access
// the children (using e.g. iff->ifTrue etc.), as that is faster. However, in
// cases where speed does not matter, this can be convenient.
//
//   ChildIterator - Iterates over all children
//
//   ValueChildIterator - Iterates over all children that produce values used by
//                        this instruction. For example, includes If::condition
//                        but not If::ifTrue.
//
template<template<class, class> class Scanner> class AbstractChildIterator {
  using Self = AbstractChildIterator<Scanner>;
  struct Iterator {
    const Self& parent;
    Index index;

    Iterator(const Self& parent, Index index) : parent(parent), index(index) {}

    bool operator!=(const Iterator& other) const {
      return index != other.index || &parent != &(other.parent);
    }

    void operator++() { index++; }

    Expression* operator*() { return parent.children[index]; }
  };

public:
  SmallVector<Expression*, 4> children;

  AbstractChildIterator(Expression* parent) {
    struct Traverser : public PostWalker<Traverser> {
      Expression* parent;
      SmallVector<Expression*, 4>* children;

      // We need to scan subchildren exactly once - just the parent.
      bool scanned = false;

      static void scan(Traverser* self, Expression** currp) {
        if (!self->scanned) {
          self->scanned = true;
          Scanner<Traverser, UnifiedExpressionVisitor<Traverser>>::scan(self,
                                                                        currp);
        } else {
          // This is one of the children. Do not scan further, just note it.
          self->children->push_back(*currp);
        }
      }
    } traverser;
    traverser.parent = parent;
    traverser.children = &children;
    traverser.walk(parent);
  }

  Iterator begin() const { return Iterator(*this, 0); }
  Iterator end() const { return Iterator(*this, children.size()); }
};

template<class SubType, class Visitor>
struct ValueChildScanner : PostWalker<SubType, Visitor> {
  static void scan(SubType* self, Expression** currp) {
    auto* curr = *currp;
    if (Properties::isControlFlowStructure(curr)) {
      // If conditions are the only stack children of control flow structures
      if (auto* iff = curr->dynCast<If>()) {
        self->pushTask(SubType::scan, &iff->condition);
      }
    } else {
      // All children on non-control flow expressions are stack children
      PostWalker<SubType, Visitor>::scan(self, currp);
    }
  }
};

using ChildIterator = AbstractChildIterator<PostWalker>;
using ValueChildIterator = AbstractChildIterator<ValueChildScanner>;

// Returns true if the current expression contains a certain kind of expression,
// within the given depth of BFS. If depth is -1, this searches all children.
template<typename T> bool containsChild(Expression* parent, int depth = -1) {
  std::vector<Expression*> exprs;
  std::vector<Expression*> nextExprs;
  exprs.push_back(parent);
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
    if (depth > 0) {
      depth--;
    }
  }
  return false;
}

} // namespace wasm

#endif // wasm_ir_iteration_h
