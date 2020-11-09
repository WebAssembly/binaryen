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

#include "ir/iteration.h"
#include "ir/load-utils.h"
#include "ir/utils.h"
#include "support/hash.h"
#include "support/small_vector.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

// Given a stack of expressions, checks if the topmost is used as a result.
// For example, if the parent is a block and the node is before the last
// position, it is not used.
bool ExpressionAnalyzer::isResultUsed(ExpressionStack& stack, Function* func) {
  for (int i = int(stack.size()) - 2; i >= 0; i--) {
    auto* curr = stack[i];
    auto* above = stack[i + 1];
    // only if and block can drop values (pre-drop expression was added) FIXME
    if (curr->is<Block>()) {
      auto* block = curr->cast<Block>();
      for (size_t j = 0; j < block->list.size() - 1; j++) {
        if (block->list[j] == above) {
          return false;
        }
      }
      assert(block->list.back() == above);
      // continue down
    } else if (curr->is<If>()) {
      auto* iff = curr->cast<If>();
      if (above == iff->condition) {
        return true;
      }
      if (!iff->ifFalse) {
        return false;
      }
      assert(above == iff->ifTrue || above == iff->ifFalse);
      // continue down
    } else {
      if (curr->is<Drop>()) {
        return false;
      }
      return true; // all other node types use the result
    }
  }
  // The value might be used, so it depends on if the function returns
  return func->sig.results != Type::none;
}

// Checks if a value is dropped.
bool ExpressionAnalyzer::isResultDropped(ExpressionStack& stack) {
  for (int i = int(stack.size()) - 2; i >= 0; i--) {
    auto* curr = stack[i];
    auto* above = stack[i + 1];
    if (curr->is<Block>()) {
      auto* block = curr->cast<Block>();
      for (size_t j = 0; j < block->list.size() - 1; j++) {
        if (block->list[j] == above) {
          return false;
        }
      }
      assert(block->list.back() == above);
      // continue down
    } else if (curr->is<If>()) {
      auto* iff = curr->cast<If>();
      if (above == iff->condition) {
        return false;
      }
      if (!iff->ifFalse) {
        return false;
      }
      assert(above == iff->ifTrue || above == iff->ifFalse);
      // continue down
    } else {
      if (curr->is<Drop>()) {
        return true; // dropped
      }
      return false; // all other node types use the result
    }
  }
  return false;
}

bool ExpressionAnalyzer::flexibleEqual(Expression* left,
                                       Expression* right,
                                       ExprComparer comparer) {
  struct Comparer {
    // for each name on the left, the corresponding name on the right
    std::map<Name, Name> rightNames;
    std::vector<Expression*> leftStack;
    std::vector<Expression*> rightStack;

    bool noteNames(Name left, Name right) {
      if (left.is() != right.is()) {
        return false;
      }
      if (left.is()) {
        assert(rightNames.find(left) == rightNames.end());
        rightNames[left] = right;
      }
      return true;
    }

    bool compare(Expression* left, Expression* right, ExprComparer comparer) {
      // The empty name is the same on both sides.
      rightNames[Name()] = Name();

      leftStack.push_back(left);
      rightStack.push_back(right);

      while (leftStack.size() > 0 && rightStack.size() > 0) {
        left = leftStack.back();
        leftStack.pop_back();
        right = rightStack.back();
        rightStack.pop_back();
        if (!left != !right) {
          return false;
        }
        if (!left) {
          continue;
        }
        // There are actual expressions to compare here. Start with the custom
        // comparer function that was provided.
        if (comparer(left, right)) {
          continue;
        }
        if (left->type != right->type) {
          return false;
        }
        // Do the actual comparison, updating the names and stacks accordingly.
        if (!compareNodes(left, right)) {
          return false;
        }
      }
      if (leftStack.size() > 0 || rightStack.size() > 0) {
        return false;
      }
      return true;
    }

    bool compareNodes(Expression* left, Expression* right) {
      if (left->_id != right->_id) {
        return false;
      }

#define DELEGATE_ID left->_id

// Create cast versions of it for later operations.
#define DELEGATE_START(id)                                                     \
  auto* castLeft = left->cast<id>();                                           \
  WASM_UNUSED(castLeft);                                                       \
  auto* castRight = right->cast<id>();                                         \
  WASM_UNUSED(castRight);

// Handle each type of field, comparing it appropriately.
#define DELEGATE_FIELD_CHILD(id, name)                                         \
  leftStack.push_back(castLeft->name);                                         \
  rightStack.push_back(castRight->name);

#define DELEGATE_FIELD_CHILD_VECTOR(id, name)                                  \
  if (castLeft->name.size() != castRight->name.size()) {                       \
    return false;                                                              \
  }                                                                            \
  for (auto* child : castLeft->name) {                                         \
    leftStack.push_back(child);                                                \
  }                                                                            \
  for (auto* child : castRight->name) {                                        \
    rightStack.push_back(child);                                               \
  }

#define COMPARE_FIELD(name)                                                    \
  if (castLeft->name != castRight->name) {                                     \
    return false;                                                              \
  }

#define DELEGATE_FIELD_INT(id, name) COMPARE_FIELD(name)
#define DELEGATE_FIELD_LITERAL(id, name) COMPARE_FIELD(name)
#define DELEGATE_FIELD_NAME(id, name) COMPARE_FIELD(name)
#define DELEGATE_FIELD_SIGNATURE(id, name) COMPARE_FIELD(name)
#define DELEGATE_FIELD_TYPE(id, name) COMPARE_FIELD(name)
#define DELEGATE_FIELD_ADDRESS(id, name) COMPARE_FIELD(name)

#define COMPARE_LIST(name)                                                     \
  if (castLeft->name.size() != castRight->name.size()) {                       \
    return false;                                                              \
  }                                                                            \
  for (Index i = 0; i < castLeft->name.size(); i++) {                          \
    if (castLeft->name[i] != castRight->name[i]) {                             \
      return false;                                                            \
    }                                                                          \
  }

#define DELEGATE_FIELD_INT_ARRAY(id, name) COMPARE_LIST(name)

#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name)                                \
  if (castLeft->name.is() != castRight->name.is()) {                           \
    return false;                                                              \
  }                                                                            \
  rightNames[castLeft->name] = castRight->name;

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name)                                \
  if (!compareNames(castLeft->name, castRight->name)) {                        \
    return false;                                                              \
  }

#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, name)                         \
  if (castLeft->name.size() != castRight->name.size()) {                       \
    return false;                                                              \
  }                                                                            \
  for (Index i = 0; i < castLeft->name.size(); i++) {                          \
    if (!compareNames(castLeft->name[i], castRight->name[i])) {                \
      return false;                                                            \
    }                                                                          \
  }

#include "wasm-delegations-fields.h"

      return true;
    }

    bool compareNames(Name left, Name right) {
      auto iter = rightNames.find(left);
      // If it's not found, that means it was defined out of the expression
      // being compared, in which case we can just treat it literally - it
      // must be exactly identical.
      if (iter != rightNames.end()) {
        left = iter->second;
      }
      return left == right;
    }
  };

  return Comparer().compare(left, right, comparer);
}

// hash an expression, ignoring superficial details like specific internal names
size_t ExpressionAnalyzer::hash(Expression* curr) {
  struct Hasher : Visitor<Hasher> {
    size_t digest = wasm::hash(0);

    Index internalCounter = 0;
    // for each internal name, its unique id
    std::map<Name, Index> internalNames;
    ExpressionStack stack;

    Hasher(Expression* curr) {
      static_assert(sizeof(Index) == sizeof(uint32_t),
                    "wasm64 will need changes here");

      stack.push_back(curr);

      while (stack.size() > 0) {
        curr = stack.back();
        stack.pop_back();
        if (!curr) {
          // This was an optional child that was not present. Hash a 0 to
          // represent that.
          rehash(digest, 0);
          continue;
        }
        rehash(digest, curr->_id);
        // we often don't need to hash the type, as it is tied to other values
        // we are hashing anyhow, but there are exceptions: for example, a
        // local.get's type is determined by the function, so if we are
        // hashing only expression fragments, then two from different
        // functions may turn out the same even if the type differs. Likewise,
        // if we hash between modules, then we need to take int account
        // call_imports type, etc. The simplest thing is just to hash the
        // type for all of them.
        rehash(digest, curr->type.getID());
        // Hash the contents of the expression.
        hashExpression(curr);
      }
    }

    void hashExpression(Expression* curr) {

#define DELEGATE_ID curr->_id

// Create cast versions of it for later operations.
#define DELEGATE_START(id)                                                     \
  auto* cast = curr->cast<id>();                                               \
  WASM_UNUSED(cast);

// Handle each type of field, comparing it appropriately.
#define DELEGATE_GET_FIELD(id, name) cast->name

#define DELEGATE_FIELD_CHILD(id, name) stack.push_back(cast->name);

#define HASH_FIELD(name) rehash(digest, cast->name);

#define DELEGATE_FIELD_INT(id, name) HASH_FIELD(name)
#define DELEGATE_FIELD_LITERAL(id, name) HASH_FIELD(name)
#define DELEGATE_FIELD_SIGNATURE(id, name) HASH_FIELD(name)

#define DELEGATE_FIELD_NAME(id, name) visitNonScopeName(cast->name)
#define DELEGATE_FIELD_TYPE(id, name) visitType(cast->name);
#define DELEGATE_FIELD_ADDRESS(id, name) visitAddress(cast->name);

#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, name) noteScopeName(cast->name);

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, name) visitScopeName(cast->name);

#include "wasm-delegations-fields.h"
    }

    void noteScopeName(Name curr) {
      if (curr.is()) {
        internalNames[curr] = internalCounter++;
      }
    }
    void visitScopeName(Name curr) {
      // Names are relative, we give the same hash for
      // (block $x (br $x))
      // (block $y (br $y))
      static_assert(sizeof(Index) == sizeof(int32_t),
                    "wasm64 will need changes here");
      assert(internalNames.find(curr) != internalNames.end());
      rehash(digest, internalNames[curr]);
    }
    void visitNonScopeName(Name curr) { rehash(digest, uint64_t(curr.str)); }
    void visitType(Type curr) { rehash(digest, curr.getID()); }
    void visitAddress(Address curr) { rehash(digest, curr.addr); }
  };

  return Hasher(curr).digest;
}

} // namespace wasm
