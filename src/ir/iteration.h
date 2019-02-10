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

#include "wasm.h"
#include "wasm-traversal.h"

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

class ChildIterator {
  struct Iterator {
    const ChildIterator& parent;
    Index index;

    Iterator(const ChildIterator& parent, Index index) : parent(parent), index(index) {}

    bool operator!=(const Iterator& other) const {
      return index != other.index || &parent != &(other.parent);
    }

    void operator++() {
      index++;
    }

    Expression* operator*() {
      return parent.children[index];
    }
  };

public:
  std::vector<Expression*> children;

  ChildIterator(Expression* parent) {
    struct Traverser : public PostWalker<Traverser> {
      Expression* parent;
      std::vector<Expression*>* children;

      // We need to scan subchildren exactly once - just the parent.
      bool scanned = false;

      static void scan(Traverser* self, Expression** currp) {
        if (!self->scanned) {
          self->scanned = true;
          PostWalker<Traverser, UnifiedExpressionVisitor<Traverser>>::scan(self, currp);
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

  Iterator begin() const {
    return Iterator(*this, 0);
  }
  Iterator end() const {
    return Iterator(*this, children.size());
  }
};

} // wasm

#endif // wasm_ir_iteration_h

