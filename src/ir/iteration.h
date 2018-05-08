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

  ChildIterator(Expression* expr) {
    switch (expr->_id) {
      case Expression::Id::BlockId: {
        auto& list = expr->cast<Block>()->list;
        for (auto* child : list) {
          children.push_back(child);
        }
        break;
      }
      case Expression::Id::IfId: {
        auto* iff = expr->cast<If>();
        children.push_back(iff->condition);
        children.push_back(iff->ifTrue);
        if (iff->ifFalse) children.push_back(iff->ifFalse);
        break;
      }
      case Expression::Id::LoopId: {
        children.push_back(expr->cast<Loop>()->body);
        break;
      }
      case Expression::Id::BreakId: {
        auto* br = expr->cast<Break>();
        if (br->value) children.push_back(br->value);
        if (br->condition) children.push_back(br->condition);
        break;
      }
      case Expression::Id::SwitchId: {
        auto* br = expr->cast<Switch>();
        if (br->value) children.push_back(br->value);
        children.push_back(br->condition);
        break;
      }
      case Expression::Id::CallId: {
        auto& operands = expr->cast<Call>()->operands;
        for (auto* child : operands) {
          children.push_back(child);
        }
        break;
      }
      case Expression::Id::CallImportId: {
        auto& operands = expr->cast<CallImport>()->operands;
        for (auto* child : operands) {
          children.push_back(child);
        }
        break;
      }
      case Expression::Id::CallIndirectId: {
        auto* call = expr->cast<CallIndirect>();
        auto& operands = call->operands;
        for (auto* child : operands) {
          children.push_back(child);
        }
        children.push_back(call->target);
        break;
      }
      case Expression::Id::SetLocalId: {
        children.push_back(expr->cast<SetLocal>()->value);
        break;
      }
      case Expression::Id::SetGlobalId: {
        children.push_back(expr->cast<SetGlobal>()->value);
        break;
      }
      case Expression::Id::LoadId: {
        children.push_back(expr->cast<Load>()->ptr);
        break;
      }
      case Expression::Id::StoreId: {
        auto* store = expr->cast<Store>();
        children.push_back(store->ptr);
        children.push_back(store->value);
        break;
      }
      case Expression::Id::UnaryId: {
        children.push_back(expr->cast<Unary>()->value);
        break;
      }
      case Expression::Id::BinaryId: {
        auto* binary = expr->cast<Binary>();
        children.push_back(binary->left);
        children.push_back(binary->right);
        break;
      }
      case Expression::Id::SelectId: {
        auto* select = expr->cast<Select>();
        children.push_back(select->ifTrue);
        children.push_back(select->ifFalse);
        children.push_back(select->condition);
        break;
      }
      case Expression::Id::DropId: {
        children.push_back(expr->cast<Drop>()->value);
        break;
      }
      case Expression::Id::ReturnId: {
        auto* ret = expr->dynCast<Return>();
        if (ret->value) children.push_back(ret->value);
        break;
      }
      case Expression::Id::HostId: {
        auto& operands = expr->cast<Host>()->operands;
        for (auto* child : operands) {
          children.push_back(child);
        }
        break;
      }
      case Expression::Id::AtomicRMWId: {
        auto* atomic = expr->cast<AtomicRMW>();
        children.push_back(atomic->ptr);
        children.push_back(atomic->value);
        break;
      }
      case Expression::Id::AtomicCmpxchgId: {
        auto* atomic = expr->cast<AtomicCmpxchg>();
        children.push_back(atomic->ptr);
        children.push_back(atomic->expected);
        children.push_back(atomic->replacement);
        break;
      }
      case Expression::Id::AtomicWaitId: {
        auto* atomic = expr->cast<AtomicWait>();
        children.push_back(atomic->ptr);
        children.push_back(atomic->expected);
        children.push_back(atomic->timeout);
        break;
      }
      case Expression::Id::AtomicWakeId: {
        auto* atomic = expr->cast<AtomicWake>();
        children.push_back(atomic->ptr);
        children.push_back(atomic->wakeCount);
        break;
      }
      case Expression::Id::GetLocalId:
      case Expression::Id::GetGlobalId:
      case Expression::Id::ConstId:
      case Expression::Id::NopId:
      case Expression::Id::UnreachableId: {
        break; // no children
      }
      default: WASM_UNREACHABLE();
    }
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

