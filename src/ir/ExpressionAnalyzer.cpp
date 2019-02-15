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
#include "support/small_vector.h"
#include "wasm.h"
#include "wasm-traversal.h"
#include "ir/iteration.h"
#include "ir/load-utils.h"
#include "ir/utils.h"

namespace wasm {

// Given a stack of expressions, checks if the topmost is used as a result.
// For example, if the parent is a block and the node is before the last position,
// it is not used.
bool ExpressionAnalyzer::isResultUsed(ExpressionStack& stack, Function* func) {
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
bool ExpressionAnalyzer::isResultDropped(ExpressionStack& stack) {
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

//
// Allows visiting the immediate fields of the expression. This is
// useful for comparisons and hashing.
//
// The passed-in visitor object must implement:
//  * visitScopeName - a Name that represents a block or loop scope
//  * visitNonScopeName - a non-scope name
//  * visitInt - anything that has a short enumeration, including
//               opcodes, # of bytes in a load, bools, etc. - must be
//               guaranteed to fit in an int32 or less.
//  * visitLiteral - a Literal
//  * visitType - a Type
//  * visitIndex - an Index
//  * visitAddress - an Address
//

namespace {

template<typename T>
void visitImmediates(Expression* curr, T& visitor) {
  struct ImmediateVisitor : public OverriddenVisitor<ImmediateVisitor> {
    T& visitor;

    ImmediateVisitor(Expression* curr, T& visitor) : visitor(visitor) {
      this->visit(curr);
    }

    void visitBlock(Block* curr) {
      visitor.visitScopeName(curr->name);
    }
    void visitIf(If* curr) {
    }
    void visitLoop(Loop* curr) {
      visitor.visitScopeName(curr->name);
    }
    void visitBreak(Break* curr) {
      visitor.visitScopeName(curr->name);
    }
    void visitSwitch(Switch* curr) {
      for (auto target : curr->targets) {
        visitor.visitScopeName(target);
      }
      visitor.visitScopeName(curr->default_);
    }
    void visitCall(Call* curr) {
      visitor.visitNonScopeName(curr->target);
    }
    void visitCallIndirect(CallIndirect* curr) {
      visitor.visitNonScopeName(curr->fullType);
    }
    void visitGetLocal(GetLocal* curr) {
      visitor.visitIndex(curr->index);
    }
    void visitSetLocal(SetLocal* curr) {
      visitor.visitIndex(curr->index);
    }
    void visitGetGlobal(GetGlobal* curr) {
      visitor.visitNonScopeName(curr->name);
    }
    void visitSetGlobal(SetGlobal* curr) {
      visitor.visitNonScopeName(curr->name);
    }
    void visitLoad(Load* curr) {
      visitor.visitInt(curr->bytes);
      if (curr->type != unreachable && curr->bytes < getTypeSize(curr->type)) {
        visitor.visitInt(curr->signed_);
      }
      visitor.visitAddress(curr->offset);
      visitor.visitAddress(curr->align);
      visitor.visitInt(curr->isAtomic);
    }
    void visitStore(Store* curr) {
      visitor.visitInt(curr->bytes);
      visitor.visitAddress(curr->offset);
      visitor.visitAddress(curr->align);
      visitor.visitInt(curr->isAtomic);
      visitor.visitInt(curr->valueType);
    }
    void visitAtomicRMW(AtomicRMW* curr) {
      visitor.visitInt(curr->op);
      visitor.visitInt(curr->bytes);
      visitor.visitAddress(curr->offset);
    }
    void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
      visitor.visitInt(curr->bytes);
      visitor.visitAddress(curr->offset);
    }
    void visitAtomicWait(AtomicWait* curr) {
      visitor.visitAddress(curr->offset);
      visitor.visitType(curr->expectedType);
    }
    void visitAtomicWake(AtomicWake* curr) {
      visitor.visitAddress(curr->offset);
    }
    void visitSIMDExtract(SIMDExtract* curr) {
      visitor.visitInt(curr->op);
      visitor.visitInt(curr->index);
    }
    void visitSIMDReplace(SIMDReplace* curr) {
      visitor.visitInt(curr->op);
      visitor.visitInt(curr->index);
    }
    void visitSIMDShuffle(SIMDShuffle* curr) {
      for (auto x : curr->mask) {
        visitor.visitInt(x);
      }
    }
    void visitSIMDBitselect(SIMDBitselect* curr) {
    }
    void visitSIMDShift(SIMDShift* curr) {
      visitor.visitInt(curr->op);
    }
    void visitMemoryInit(MemoryInit* curr) {
      visitor.visitIndex(curr->segment);
    }
    void visitDataDrop(DataDrop* curr) {
      visitor.visitIndex(curr->segment);
    }
    void visitMemoryCopy(MemoryCopy* curr) {
    }
    void visitMemoryFill(MemoryFill* curr) {
    }
    void visitConst(Const* curr) {
      visitor.visitLiteral(curr->value);
    }
    void visitUnary(Unary* curr) {
      visitor.visitInt(curr->op);
    }
    void visitBinary(Binary* curr) {
      visitor.visitInt(curr->op);
    }
    void visitSelect(Select* curr) {
    }
    void visitDrop(Drop* curr) {
    }
    void visitReturn(Return* curr) {
    }
    void visitHost(Host* curr) {
      visitor.visitInt(curr->op);
      visitor.visitNonScopeName(curr->nameOperand);
    }
    void visitNop(Nop* curr) {
    }
    void visitUnreachable(Unreachable* curr) {
    }
  } singleton(curr, visitor);
}

} // namespace

bool ExpressionAnalyzer::flexibleEqual(Expression* left, Expression* right, ExprComparer comparer) {
  struct Comparer {
    std::map<Name, Name> rightNames; // for each name on the left, the corresponding name on the right
    std::vector<Expression*> leftStack;
    std::vector<Expression*> rightStack;

    struct Immediates {
      Comparer& parent;

      Immediates(Comparer& parent) : parent(parent) {}

      SmallVector<Name, 1> scopeNames;
      SmallVector<Name, 1> nonScopeNames;
      SmallVector<int32_t, 3> ints;
      SmallVector<Literal, 1> literals;
      SmallVector<Type, 1> types;
      SmallVector<Index, 1> indexes;
      SmallVector<Address, 2> addresses;

      void visitScopeName(Name curr) { scopeNames.push_back(curr); }
      void visitNonScopeName(Name curr) { nonScopeNames.push_back(curr); }
      void visitInt(int32_t curr) { ints.push_back(curr); }
      void visitLiteral(Literal curr) { literals.push_back(curr); }
      void visitType(Type curr) { types.push_back(curr); }
      void visitIndex(Index curr) { indexes.push_back(curr); }
      void visitAddress(Address curr) { addresses.push_back(curr); }

      // Comparison is by value, except for names, which must match.
      bool operator==(const Immediates& other) {
        if (scopeNames.size() != other.scopeNames.size()) return false;
        for (Index i = 0; i < scopeNames.size(); i++) {
          auto leftName = scopeNames[i];
          auto rightName = other.scopeNames[i];
          auto iter = parent.rightNames.find(leftName);
          // If it's not found, that means it was defined out of the expression being compared,
          // in which case we can just treat it literally - it must be exactly identical.
          if (iter != parent.rightNames.end()) {
            leftName = iter->second;
          }
          if (leftName != rightName) {
            return false;
          }
        }
        if (nonScopeNames != other.nonScopeNames) return false;
        if (ints != other.ints) return false;
        if (literals != other.literals) return false;
        if (types != other.types) return false;
        if (indexes != other.indexes) return false;
        if (addresses != other.addresses) return false;
        return true;
      }

      bool operator!=(const Immediates& other) {
        return !(*this == other);
      }

      void clear() {
        scopeNames.clear();
        nonScopeNames.clear();
        ints.clear();
        literals.clear();
        types.clear();
        indexes.clear();
        addresses.clear();
      }
    };

    bool noteNames(Name left, Name right) {
      if (left.is() != right.is()) return false;
      if (left.is()) {
        assert(rightNames.find(left) == rightNames.end());
        rightNames[left] = right;
      }
      return true;
    }

    bool compare(Expression* left, Expression* right, ExprComparer comparer) {
      Immediates leftImmediates(*this),
                 rightImmediates(*this);

      // The empty name is the same on both sides.
      rightNames[Name()] = Name();

      leftStack.push_back(left);
      rightStack.push_back(right);

      while (leftStack.size() > 0 && rightStack.size() > 0) {
        left = leftStack.back();
        leftStack.pop_back();
        right = rightStack.back();
        rightStack.pop_back();
        if (!left != !right) return false;
        if (!left) continue;
        if (comparer(left, right)) continue; // comparison hook, before all the rest
        // continue with normal structural comparison
        if (left->_id != right->_id) return false;
        // Blocks and loops introduce scoping.
        if (auto* block = left->dynCast<Block>()) {
          if (!noteNames(block->name, right->cast<Block>()->name)) return false;
        } else if (auto* loop = left->dynCast<Loop>()) {
          if (!noteNames(loop->name, right->cast<Loop>()->name)) return false;
        } else {
          // For all other nodes, compare their immediate values
          visitImmediates(left, leftImmediates);
          visitImmediates(right, rightImmediates);
          if (leftImmediates != rightImmediates) return false;
          leftImmediates.clear();
          rightImmediates.clear();
        }
        // Add child nodes.
        Index counter = 0;
        for (auto* child : ChildIterator(left)) {
          leftStack.push_back(child);
          counter++;
        }
        for (auto* child : ChildIterator(right)) {
          rightStack.push_back(child);
          counter--;
        }
        // The number of child nodes must match (e.g. return has an optional one).
        if (counter != 0) return false;
      }
      if (leftStack.size() > 0 || rightStack.size() > 0) return false;
      return true;
    }
  };

  return Comparer().compare(left, right, comparer);
}

// hash an expression, ignoring superficial details like specific internal names
HashType ExpressionAnalyzer::hash(Expression* curr) {
  struct Hasher {
    HashType digest = 0;

    Index internalCounter = 0;
    std::map<Name, Index> internalNames; // for each internal name, its unique id
    ExpressionStack stack;

    void noteScopeName(Name curr) {
      if (curr.is()) {
        internalNames[curr] = internalCounter++;
      }
    }

    Hasher(Expression* curr) {
      stack.push_back(curr);

      while (stack.size() > 0) {
        curr = stack.back();
        stack.pop_back();
        if (!curr) continue;
        hash(curr->_id);
        // we often don't need to hash the type, as it is tied to other values
        // we are hashing anyhow, but there are exceptions: for example, a
        // local.get's type is determined by the function, so if we are
        // hashing only expression fragments, then two from different
        // functions may turn out the same even if the type differs. Likewise,
        // if we hash between modules, then we need to take int account
        // call_imports type, etc. The simplest thing is just to hash the
        // type for all of them.
        hash(curr->type);
        // Blocks and loops introduce scoping.
        if (auto* block = curr->dynCast<Block>()) {
          noteScopeName(block->name);
        } else if (auto* loop = curr->dynCast<Loop>()) {
          noteScopeName(loop->name);
        } else {
          // For all other nodes, compare their immediate values
          visitImmediates(curr, *this);
        }
        // Hash children
        Index counter = 0;
        for (auto* child : ChildIterator(curr)) {
          stack.push_back(child);
          counter++;
        }
        // Sometimes children are optional, e.g. return, so we must hash
        // their number as well.
        hash(counter);
      }
    }

    void hash(HashType hash) {
      digest = rehash(digest, hash);
    }
    void hash64(uint64_t hash) {
      digest = rehash(rehash(digest, HashType(hash >> 32)), HashType(hash));
    }

    void visitScopeName(Name curr) {
      // Names are relative, we give the same hash for
      // (block $x (br $x))
      // (block $y (br $y))
      static_assert(sizeof(Index) == sizeof(int32_t), "wasm64 will need changes here");
      assert(internalNames.find(curr) != internalNames.end());
      return hash(internalNames[curr]);
    }
    void visitNonScopeName(Name curr) {
      return hash64(uint64_t(curr.str));
    }
    void visitInt(int32_t curr) {
      hash(curr);
    }
    void visitLiteral(Literal curr) {
      hash(std::hash<Literal>()(curr));
    }
    void visitType(Type curr) {
      hash(int32_t(curr));
    }
    void visitIndex(Index curr) {
      static_assert(sizeof(Index) == sizeof(int32_t), "wasm64 will need changes here");
      hash(int32_t(curr));
    }
    void visitAddress(Address curr) {
      static_assert(sizeof(Address) == sizeof(int32_t), "wasm64 will need changes here");
      hash(int32_t(curr));
    }
  };

  return Hasher(curr).digest;
}

} // namespace wasm
