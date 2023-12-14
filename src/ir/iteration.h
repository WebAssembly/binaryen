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
#include "wasm.h"

namespace wasm {

//
// Allows iteration over the children of the expression, in order of execution
// where relevant.
//
//  * This skips missing children, e.g. if an if has no else, it is represented
//    as having 2 children (and not 3 with the last a nullptr).
//
// In general, it is preferable not to use this class and to directly access the
// children (using e.g. iff->ifTrue etc.), as that is faster. However, in cases
// where speed does not matter, this can be convenient. TODO: reimplement these
// to avoid materializing all the chilren at once.
//
//   ChildIterator - Iterates over all children
//
//   ValueChildIterator - Iterates over all children that produce values used by
//                        this instruction. For example, includes If::condition
//                        but not If::ifTrue.
//
template<class Specific> class AbstractChildIterator {
  using Self = AbstractChildIterator<Specific>;

  struct Iterator {
    using difference_type = std::ptrdiff_t;
    using value_type = Expression*;
    using pointer = Expression**;
    using reference = Expression*&;
    using iterator_category = std::forward_iterator_tag;

    const Self* parent;
    Index index;

    Iterator(const Self* parent, Index index) : parent(parent), index(index) {}

    bool operator!=(const Iterator& other) const {
      return index != other.index || parent != other.parent;
    }

    bool operator==(const Iterator& other) const { return !(*this != other); }

    void operator++() { index++; }

    Expression*& operator*() {
      return *parent->children[parent->mapIndex(index)];
    }
  };

  friend struct Iterator;

  Index mapIndex(Index index) const {
    assert(index < children.size());

    // The vector of children is in reverse order, as that is how
    // wasm-delegations-fields works. To get the order of execution, reverse
    // things.
    return children.size() - 1 - index;
  }

public:
  // The vector of children in the order emitted by wasm-delegations-fields
  // (which is in reverse execution order).
  // TODO: rename this "reverseChildren"?
  SmallVector<Expression**, 4> children;

  AbstractChildIterator(Expression* parent) {
    auto* self = (Specific*)this;

#define DELEGATE_ID parent->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = parent->cast<id>();

#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_CHILD(id, field) self->addChild(parent, &cast->field);

#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)                               \
  if (cast->field) {                                                           \
    self->addChild(parent, &cast->field);                                      \
  }

#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_HEAPTYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)

#include "wasm-delegations-fields.def"
  }

  Iterator begin() const { return Iterator(this, 0); }
  Iterator end() const { return Iterator(this, children.size()); }

  void addChild(Expression* parent, Expression** child) {
    children.push_back(child);
  }

  // API for accessing children in random order.
  Expression*& getChild(Index index) { return *children[mapIndex(index)]; }

  Index getNumChildren() { return children.size(); }
};

class ChildIterator : public AbstractChildIterator<ChildIterator> {
public:
  ChildIterator(Expression* parent)
    : AbstractChildIterator<ChildIterator>(parent) {}
};

class ValueChildIterator : public AbstractChildIterator<ValueChildIterator> {
public:
  ValueChildIterator(Expression* parent)
    : AbstractChildIterator<ValueChildIterator>(parent) {}

  void addChild(Expression* parent, Expression** child) {
    if (Properties::isControlFlowStructure(parent)) {
      // If conditions are the only value children of control flow structures
      if (auto* iff = parent->dynCast<If>()) {
        if (child == &iff->condition) {
          children.push_back(child);
        }
      }
    } else {
      // All children on non-control flow expressions are value children
      children.push_back(child);
    }
  }
};

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
