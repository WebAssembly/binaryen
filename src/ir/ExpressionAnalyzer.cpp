/*
 * Copyright 2016 WebAssembly Community Group participants
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

#include "support/hash.h"
#include "ir/utils.h"
#include "ir/load-utils.h"

namespace wasm {
// Given a stack of expressions, checks if the topmost is used as a result.
// For example, if the parent is a block and the node is before the last position,
// it is not used.
bool ExpressionAnalyzer::isResultUsed(std::vector<Expression*> stack, Function* func) {
  for (int i = int(stack.size()) - 2; i >= 0; i--) {
    auto* curr = stack[i];
    auto* above = stack[i + 1];
    // only if and block can drop values (pre-drop expression was added) FIXME
    if (curr->is<Block>()) {
      auto* block = curr->cast<Block>();
      for (size_t j = 0; j < block->list.size() - 1; j++) {
        if (block->list[j] == above) return false;
      }
      assert(block->list.back() == above);
      // continue down
    } else if (curr->is<If>()) {
      auto* iff = curr->cast<If>();
      if (above == iff->condition) return true;
      if (!iff->ifFalse) return false;
      assert(above == iff->ifTrue || above == iff->ifFalse);
      // continue down
    } else {
      if (curr->is<Drop>()) return false;
      return true; // all other node types use the result
    }
  }
  // The value might be used, so it depends on if the function returns
  return func->result != none;
}

// Checks if a value is dropped.
bool ExpressionAnalyzer::isResultDropped(std::vector<Expression*> stack) {
  for (int i = int(stack.size()) - 2; i >= 0; i--) {
    auto* curr = stack[i];
    auto* above = stack[i + 1];
    if (curr->is<Block>()) {
      auto* block = curr->cast<Block>();
      for (size_t j = 0; j < block->list.size() - 1; j++) {
        if (block->list[j] == above) return false;
      }
      assert(block->list.back() == above);
      // continue down
    } else if (curr->is<If>()) {
      auto* iff = curr->cast<If>();
      if (above == iff->condition) return false;
      if (!iff->ifFalse) return false;
      assert(above == iff->ifTrue || above == iff->ifFalse);
      // continue down
    } else {
      if (curr->is<Drop>()) return true; // dropped
      return false; // all other node types use the result
    }
  }
  return false;
}


bool ExpressionAnalyzer::flexibleEqual(Expression* left, Expression* right, ExprComparer comparer) {
  std::vector<Name> nameStack;
  std::map<Name, std::vector<Name>> rightNames; // for each name on the left, the stack of names on the right (a stack, since names are scoped and can nest duplicatively
  Nop popNameMarker;
  std::vector<Expression*> leftStack;
  std::vector<Expression*> rightStack;

  auto noteNames = [&](Name left, Name right) {
    if (left.is() != right.is()) return false;
    if (left.is()) {
      nameStack.push_back(left);
      rightNames[left].push_back(right);
      leftStack.push_back(&popNameMarker);
      rightStack.push_back(&popNameMarker);
    }
    return true;
  };
  auto checkNames = [&](Name left, Name right) {
    auto iter = rightNames.find(left);
    if (iter == rightNames.end()) return left == right; // non-internal name
    return iter->second.back() == right;
  };
  auto popName = [&]() {
    auto left = nameStack.back();
    nameStack.pop_back();
    rightNames[left].pop_back();
  };

  leftStack.push_back(left);
  rightStack.push_back(right);

  while (leftStack.size() > 0 && rightStack.size() > 0) {
    left = leftStack.back();
    leftStack.pop_back();
    right = rightStack.back();
    rightStack.pop_back();
    if (!left != !right) return false;
    if (!left) continue;
    if (left == &popNameMarker) {
      popName();
      continue;
    }
    if (comparer(left, right)) continue; // comparison hook, before all the rest
    // continue with normal structural comparison
    if (left->_id != right->_id) return false;
    #define PUSH(clazz, what)                               \
      leftStack.push_back(left->cast<clazz>()->what);       \
      rightStack.push_back(right->cast<clazz>()->what);
    #define CHECK(clazz, what) \
      if (left->cast<clazz>()->what != right->cast<clazz>()->what) return false;
    switch (left->_id) {
      case Expression::Id::BlockId: {
        if (!noteNames(left->cast<Block>()->name, right->cast<Block>()->name)) return false;
        CHECK(Block, list.size());
        for (Index i = 0; i < left->cast<Block>()->list.size(); i++) {
          PUSH(Block, list[i]);
        }
        break;
      }
      case Expression::Id::IfId: {
        PUSH(If, condition);
        PUSH(If, ifTrue);
        PUSH(If, ifFalse);
        break;
      }
      case Expression::Id::LoopId: {
        if (!noteNames(left->cast<Loop>()->name, right->cast<Loop>()->name)) return false;
        PUSH(Loop, body);
        break;
      }
      case Expression::Id::BreakId: {
        if (!checkNames(left->cast<Break>()->name, right->cast<Break>()->name)) return false;
        PUSH(Break, condition);
        PUSH(Break, value);
        break;
      }
      case Expression::Id::SwitchId: {
        CHECK(Switch, targets.size());
        for (Index i = 0; i < left->cast<Switch>()->targets.size(); i++) {
          if (!checkNames(left->cast<Switch>()->targets[i], right->cast<Switch>()->targets[i])) return false;
        }
        if (!checkNames(left->cast<Switch>()->default_, right->cast<Switch>()->default_)) return false;
        PUSH(Switch, condition);
        PUSH(Switch, value);
        break;
      }
      case Expression::Id::CallId: {
        CHECK(Call, target);
        CHECK(Call, operands.size());
        for (Index i = 0; i < left->cast<Call>()->operands.size(); i++) {
          PUSH(Call, operands[i]);
        }
        break;
      }
      case Expression::Id::CallIndirectId: {
        PUSH(CallIndirect, target);
        CHECK(CallIndirect, fullType);
        CHECK(CallIndirect, operands.size());
        for (Index i = 0; i < left->cast<CallIndirect>()->operands.size(); i++) {
          PUSH(CallIndirect, operands[i]);
        }
        break;
      }
      case Expression::Id::GetLocalId: {
        CHECK(GetLocal, index);
        break;
      }
      case Expression::Id::SetLocalId: {
        CHECK(SetLocal, index);
        CHECK(SetLocal, type); // for tee/set
        PUSH(SetLocal, value);
        break;
      }
      case Expression::Id::GetGlobalId: {
        CHECK(GetGlobal, name);
        break;
      }
      case Expression::Id::SetGlobalId: {
        CHECK(SetGlobal, name);
        PUSH(SetGlobal, value);
        break;
      }
      case Expression::Id::LoadId: {
        CHECK(Load, bytes);
        if (LoadUtils::isSignRelevant(left->cast<Load>()) &&
            LoadUtils::isSignRelevant(right->cast<Load>())) {
          CHECK(Load, signed_);
        }
        CHECK(Load, offset);
        CHECK(Load, align);
        CHECK(Load, isAtomic);
        PUSH(Load, ptr);
        break;
      }
      case Expression::Id::StoreId: {
        CHECK(Store, bytes);
        CHECK(Store, offset);
        CHECK(Store, align);
        CHECK(Store, valueType);
        CHECK(Store, isAtomic);
        PUSH(Store, ptr);
        PUSH(Store, value);
        break;
      }
      case Expression::Id::AtomicCmpxchgId: {
        CHECK(AtomicCmpxchg, bytes);
        CHECK(AtomicCmpxchg, offset);
        PUSH(AtomicCmpxchg, ptr);
        PUSH(AtomicCmpxchg, expected);
        PUSH(AtomicCmpxchg, replacement);
        break;
      }
      case Expression::Id::AtomicRMWId: {
        CHECK(AtomicRMW, op);
        CHECK(AtomicRMW, bytes);
        CHECK(AtomicRMW, offset);
        PUSH(AtomicRMW, ptr);
        PUSH(AtomicRMW, value);
        break;
      }
      case Expression::Id::AtomicWaitId: {
        CHECK(AtomicWait, expectedType);
        PUSH(AtomicWait, ptr);
        PUSH(AtomicWait, expected);
        PUSH(AtomicWait, timeout);
        break;
      }
      case Expression::Id::AtomicWakeId: {
        PUSH(AtomicWake, ptr);
        PUSH(AtomicWake, wakeCount);
        break;
      }
      case Expression::Id::ConstId: {
        if (left->cast<Const>()->value != right->cast<Const>()->value) {
          return false;
        }
        break;
      }
      case Expression::Id::UnaryId: {
        CHECK(Unary, op);
        PUSH(Unary, value);
        break;
      }
      case Expression::Id::BinaryId: {
        CHECK(Binary, op);
        PUSH(Binary, left);
        PUSH(Binary, right);
        break;
      }
      case Expression::Id::SelectId: {
        PUSH(Select, ifTrue);
        PUSH(Select, ifFalse);
        PUSH(Select, condition);
        break;
      }
      case Expression::Id::DropId: {
        PUSH(Drop, value);
        break;
      }
      case Expression::Id::ReturnId: {
        PUSH(Return, value);
        break;
      }
      case Expression::Id::HostId: {
        CHECK(Host, op);
        CHECK(Host, nameOperand);
        CHECK(Host, operands.size());
        for (Index i = 0; i < left->cast<Host>()->operands.size(); i++) {
          PUSH(Host, operands[i]);
        }
        break;
      }
      case Expression::Id::NopId: {
        break;
      }
      case Expression::Id::UnreachableId: {
        break;
      }
      default: WASM_UNREACHABLE();
    }
    #undef CHECK
    #undef PUSH
  }
  if (leftStack.size() > 0 || rightStack.size() > 0) return false;
  return true;
}


// hash an expression, ignoring superficial details like specific internal names
HashType ExpressionAnalyzer::hash(Expression* curr) {
  HashType digest = 0;

  auto hash = [&digest](HashType hash) {
    digest = rehash(digest, hash);
  };
  auto hash64 = [&digest](uint64_t hash) {
    digest = rehash(rehash(digest, HashType(hash >> 32)), HashType(hash));
  };

  std::vector<Name> nameStack;
  Index internalCounter = 0;
  std::map<Name, std::vector<Index>> internalNames; // for each internal name, a vector if unique ids
  Nop popNameMarker;
  std::vector<Expression*> stack;

  auto noteName = [&](Name curr) {
    if (curr.is()) {
      nameStack.push_back(curr);
      internalNames[curr].push_back(internalCounter++);
      stack.push_back(&popNameMarker);
    }
    return true;
  };
  auto hashName = [&](Name curr) {
    auto iter = internalNames.find(curr);
    if (iter == internalNames.end()) hash64(uint64_t(curr.str));
    else hash(iter->second.back());
  };
  auto popName = [&]() {
    auto curr = nameStack.back();
    nameStack.pop_back();
    internalNames[curr].pop_back();
  };

  stack.push_back(curr);

  while (stack.size() > 0) {
    curr = stack.back();
    stack.pop_back();
    if (!curr) continue;
    if (curr == &popNameMarker) {
      popName();
      continue;
    }
    hash(curr->_id);
    // we often don't need to hash the type, as it is tied to other values
    // we are hashing anyhow, but there are exceptions: for example, a
    // get_local's type is determined by the function, so if we are
    // hashing only expression fragments, then two from different
    // functions may turn out the same even if the type differs. Likewise,
    // if we hash between modules, then we need to take int account
    // call_imports type, etc. The simplest thing is just to hash the
    // type for all of them.
    hash(curr->type);

    #define PUSH(clazz, what) \
      stack.push_back(curr->cast<clazz>()->what);
    #define HASH(clazz, what) \
      hash(curr->cast<clazz>()->what);
    #define HASH64(clazz, what) \
      hash64(curr->cast<clazz>()->what);
    #define HASH_NAME(clazz, what) \
      hash64(uint64_t(curr->cast<clazz>()->what.str));
    #define HASH_PTR(clazz, what) \
      hash64(uint64_t(curr->cast<clazz>()->what));
    switch (curr->_id) {
      case Expression::Id::BlockId: {
        noteName(curr->cast<Block>()->name);
        HASH(Block, list.size());
        for (Index i = 0; i < curr->cast<Block>()->list.size(); i++) {
          PUSH(Block, list[i]);
        }
        break;
      }
      case Expression::Id::IfId: {
        PUSH(If, condition);
        PUSH(If, ifTrue);
        PUSH(If, ifFalse);
        break;
      }
      case Expression::Id::LoopId: {
        noteName(curr->cast<Loop>()->name);
        PUSH(Loop, body);
        break;
      }
      case Expression::Id::BreakId: {
        hashName(curr->cast<Break>()->name);
        PUSH(Break, condition);
        PUSH(Break, value);
        break;
      }
      case Expression::Id::SwitchId: {
        HASH(Switch, targets.size());
        for (Index i = 0; i < curr->cast<Switch>()->targets.size(); i++) {
          hashName(curr->cast<Switch>()->targets[i]);
        }
        hashName(curr->cast<Switch>()->default_);
        PUSH(Switch, condition);
        PUSH(Switch, value);
        break;
      }
      case Expression::Id::CallId: {
        HASH_NAME(Call, target);
        HASH(Call, operands.size());
        for (Index i = 0; i < curr->cast<Call>()->operands.size(); i++) {
          PUSH(Call, operands[i]);
        }
        break;
      }
      case Expression::Id::CallIndirectId: {
        PUSH(CallIndirect, target);
        HASH_NAME(CallIndirect, fullType);
        HASH(CallIndirect, operands.size());
        for (Index i = 0; i < curr->cast<CallIndirect>()->operands.size(); i++) {
          PUSH(CallIndirect, operands[i]);
        }
        break;
      }
      case Expression::Id::GetLocalId: {
        HASH(GetLocal, index);
        break;
      }
      case Expression::Id::SetLocalId: {
        HASH(SetLocal, index);
        PUSH(SetLocal, value);
        break;
      }
      case Expression::Id::GetGlobalId: {
        HASH_NAME(GetGlobal, name);
        break;
      }
      case Expression::Id::SetGlobalId: {
        HASH_NAME(SetGlobal, name);
        PUSH(SetGlobal, value);
        break;
      }
      case Expression::Id::LoadId: {
        HASH(Load, bytes);
        if (LoadUtils::isSignRelevant(curr->cast<Load>())) {
          HASH(Load, signed_);
        }
        HASH(Load, offset);
        HASH(Load, align);
        HASH(Load, isAtomic);
        PUSH(Load, ptr);
        break;
      }
      case Expression::Id::StoreId: {
        HASH(Store, bytes);
        HASH(Store, offset);
        HASH(Store, align);
        HASH(Store, valueType);
        HASH(Store, isAtomic);
        PUSH(Store, ptr);
        PUSH(Store, value);
        break;
      }
      case Expression::Id::AtomicCmpxchgId: {
        HASH(AtomicCmpxchg, bytes);
        HASH(AtomicCmpxchg, offset);
        PUSH(AtomicCmpxchg, ptr);
        PUSH(AtomicCmpxchg, expected);
        PUSH(AtomicCmpxchg, replacement);
        break;
      }
      case Expression::Id::AtomicRMWId: {
        HASH(AtomicRMW, op);
        HASH(AtomicRMW, bytes);
        HASH(AtomicRMW, offset);
        PUSH(AtomicRMW, ptr);
        PUSH(AtomicRMW, value);
        break;
      }
      case Expression::Id::AtomicWaitId: {
        HASH(AtomicWait, offset);
        HASH(AtomicWait, expectedType);
        PUSH(AtomicWait, ptr);
        PUSH(AtomicWait, expected);
        PUSH(AtomicWait, timeout);
        break;
      }
      case Expression::Id::AtomicWakeId: {
        HASH(AtomicWake, offset);
        PUSH(AtomicWake, ptr);
        PUSH(AtomicWake, wakeCount);
        break;
      }
      case Expression::Id::ConstId: {
        auto* c = curr->cast<Const>();
        hash(c->type);
        auto bits = c->value.getBits();
        if (getTypeSize(c->type) == 4) {
          hash(HashType(bits));
        } else {
          hash64(bits);
        }
        break;
      }
      case Expression::Id::UnaryId: {
        HASH(Unary, op);
        PUSH(Unary, value);
        break;
      }
      case Expression::Id::BinaryId: {
        HASH(Binary, op);
        PUSH(Binary, left);
        PUSH(Binary, right);
        break;
      }
      case Expression::Id::SelectId: {
        PUSH(Select, ifTrue);
        PUSH(Select, ifFalse);
        PUSH(Select, condition);
        break;
      }
      case Expression::Id::DropId: {
        PUSH(Drop, value);
        break;
      }
      case Expression::Id::ReturnId: {
        PUSH(Return, value);
        break;
      }
      case Expression::Id::HostId: {
        HASH(Host, op);
        HASH_NAME(Host, nameOperand);
        HASH(Host, operands.size());
        for (Index i = 0; i < curr->cast<Host>()->operands.size(); i++) {
          PUSH(Host, operands[i]);
        }
        break;
      }
      case Expression::Id::NopId: {
        break;
      }
      case Expression::Id::UnreachableId: {
        break;
      }
      default: WASM_UNREACHABLE();
    }
    #undef HASH
    #undef PUSH
  }
  return digest;
}
} // namespace wasm
