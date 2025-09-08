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
#include "shared-constants.h"
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
  return func->getResults() != Type::none;
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
  [[maybe_unused]] auto* castLeft = left->cast<id>();                          \
  [[maybe_unused]] auto* castRight = right->cast<id>();

// Handle each type of field, comparing it appropriately.
#define DELEGATE_FIELD_CHILD(id, field)                                        \
  leftStack.push_back(castLeft->field);                                        \
  rightStack.push_back(castRight->field);

#define DELEGATE_FIELD_CHILD_VECTOR(id, field)                                 \
  if (castLeft->field.size() != castRight->field.size()) {                     \
    return false;                                                              \
  }                                                                            \
  for (auto* child : castLeft->field) {                                        \
    leftStack.push_back(child);                                                \
  }                                                                            \
  for (auto* child : castRight->field) {                                       \
    rightStack.push_back(child);                                               \
  }

#define COMPARE_FIELD(field)                                                   \
  if (castLeft->field != castRight->field) {                                   \
    return false;                                                              \
  }

#define DELEGATE_FIELD_INT(id, field) COMPARE_FIELD(field)
#define DELEGATE_FIELD_LITERAL(id, field) COMPARE_FIELD(field)
#define DELEGATE_FIELD_NAME(id, field) COMPARE_FIELD(field)
#define DELEGATE_FIELD_TYPE(id, field) COMPARE_FIELD(field)
#define DELEGATE_FIELD_HEAPTYPE(id, field) COMPARE_FIELD(field)
#define DELEGATE_FIELD_ADDRESS(id, field) COMPARE_FIELD(field)

#define COMPARE_LIST(field)                                                    \
  if (castLeft->field.size() != castRight->field.size()) {                     \
    return false;                                                              \
  }                                                                            \
  for (Index i = 0; i < castLeft->field.size(); i++) {                         \
    if (castLeft->field[i] != castRight->field[i]) {                           \
      return false;                                                            \
    }                                                                          \
  }

#define DELEGATE_FIELD_INT_ARRAY(id, field) COMPARE_LIST(field)
#define DELEGATE_FIELD_INT_VECTOR(id, field) COMPARE_LIST(field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field) COMPARE_LIST(field)
#define DELEGATE_FIELD_TYPE_VECTOR(id, field) COMPARE_LIST(field)

#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)                               \
  if (castLeft->field.is() != castRight->field.is()) {                         \
    return false;                                                              \
  }                                                                            \
  rightNames[castLeft->field] = castRight->field;

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)                               \
  if (!compareNames(castLeft->field, castRight->field)) {                      \
    return false;                                                              \
  }

#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)                        \
  if (castLeft->field.size() != castRight->field.size()) {                     \
    return false;                                                              \
  }                                                                            \
  for (Index i = 0; i < castLeft->field.size(); i++) {                         \
    if (!compareNames(castLeft->field[i], castRight->field[i])) {              \
      return false;                                                            \
    }                                                                          \
  }

#include "wasm-delegations-fields.def"

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

namespace {

struct Hasher {
  bool visitChildren;

  size_t digest = wasm::hash(0);

  Index internalCounter = 0;
  // for each internal name, its unique id
  std::map<Name, Index> internalNames;
  ExpressionStack stack;

  Hasher(Expression* curr,
         bool visitChildren,
         ExpressionAnalyzer::ExprHasher custom)
    : visitChildren(visitChildren) {
    stack.push_back(curr);
    // DELEGATE_CALLER_TARGET is a fake target used to denote delegating to
    // the caller. Add it here to prevent the unknown name error.
    noteScopeName(DELEGATE_CALLER_TARGET);

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
      // If the custom hasher handled this expr, then we have nothing to do.
      if (custom(curr, digest)) {
        continue;
      }
      // Hash the contents of the expression normally.
      hashExpression(curr);
    }
  }

  void hashExpression(Expression* curr) {

#define DELEGATE_ID curr->_id

// Create cast versions of it for later operations.
#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();

// Handle each type of field, comparing it appropriately.
#define DELEGATE_GET_FIELD(id, field) cast->field

#define DELEGATE_FIELD_CHILD(id, field)                                        \
  if (visitChildren) {                                                         \
    stack.push_back(cast->field);                                              \
  }

#define HASH_FIELD(field) rehash(digest, cast->field);

#define DELEGATE_FIELD_INT(id, field) HASH_FIELD(field)
#define DELEGATE_FIELD_LITERAL(id, field) HASH_FIELD(field)

#define DELEGATE_FIELD_NAME(id, field) visitNonScopeName(cast->field);
#define DELEGATE_FIELD_TYPE(id, field) visitType(cast->field);
#define DELEGATE_FIELD_HEAPTYPE(id, field) visitHeapType(cast->field);
#define DELEGATE_FIELD_ADDRESS(id, field) visitAddress(cast->field);

// Note that we only note the scope name, but do not also visit it. That means
// that (block $x) and (block) get the same hash. In other words, we only change
// the hash based on uses of scope names, that is when there is a noticeable
// difference in break targets.
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field) noteScopeName(cast->field);

#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field) visitScopeName(cast->field);

#include "wasm-delegations-fields.def"
  }

  void noteScopeName(Name curr) {
    if (curr.is()) {
      internalNames[curr] = internalCounter++;
    }
  }
  void visitScopeName(Name curr) {
    // We consider 3 cases here, and prefix a hash value of 0, 1, or 2 to
    // maximally differentiate them.

    // Try's delegate target can be null.
    if (!curr.is()) {
      rehash(digest, 0);
      return;
    }
    // Names are relative, we give the same hash for
    //   (block $x (br $x))
    //   (block $y (br $y))
    // But if the name is not known to us, hash the absolute one.
    if (!internalNames.count(curr)) {
      rehash(digest, 1);
      // Perform the same hashing as a generic name.
      visitNonScopeName(curr);
      return;
    }
    rehash(digest, 2);
    rehash(digest, internalNames[curr]);
  }
  void visitNonScopeName(Name curr) { rehash(digest, curr); }
  void visitType(Type curr) { rehash(digest, curr.getID()); }
  void visitHeapType(HeapType curr) { rehash(digest, curr.getID()); }
  void visitAddress(Address curr) { rehash(digest, curr.addr); }
};

} // anonymous namespace

size_t ExpressionAnalyzer::flexibleHash(Expression* curr,
                                        ExpressionAnalyzer::ExprHasher custom) {
  return Hasher(curr, true, custom).digest;
}

size_t ExpressionAnalyzer::shallowHash(Expression* curr) {
  return Hasher(curr, false, ExpressionAnalyzer::nothingHasher).digest;
}

} // namespace wasm
