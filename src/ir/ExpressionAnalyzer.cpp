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
#include "ir/iteration.h"
#include "ir/load-utils.h"
#include "ir/utils.h"

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

//
// Allows visiting the immediate fields of the expression. This is
// useful for comparisons and hashing.
//
// The passed-in visitor object must implement:
//  * visitName    - a Name
//  * visitInt     - anything that has a short enumeration, including
//                   opcodes, # of bytes in a load, bools, etc. - must be
//                   guaranteed to fit in an int32 or less.
//  * visitLiteral - a Literal
//  * visitType    - a Type
//  * visitIndex   - an Index
//

static
template<typename T>
void visitImmediates(Expression* curr, T& visitor) {
  struct ImmediateVisitor : public OverriddenVisitor {
    T& visitor;

    ImmediateVisitor(Expression* curr, T& visitor) : visitor(visitor) {
      visit(curr);
    }

    ReturnType visitBlock(Block* curr) {
      visitor.visitName(curr->name);
    }
    ReturnType visitIf(If* curr) {
    }
    ReturnType visitLoop(Loop* curr) {
      visitor.visitName(curr->name);
    }
    ReturnType visitBreak(Break* curr) {
      visitor.visitName(curr->name);
    }
    ReturnType visitSwitch(Switch* curr) {
      for (auto target : curr->targets) {
        visitor.visitName(target);
      }
      visitor.visitName(curr->default_);
    }
    ReturnType visitCall(Call* curr) {
      visitor.visitName(curr->target);
    }
    ReturnType visitCallIndirect(CallIndirect* curr) {
      visitor.visitName(curr->fullType);
    }
    ReturnType visitGetLocal(GetLocal* curr) {
      visitor.visitIndex(curr->index);
    }
    ReturnType visitSetLocal(SetLocal* curr) {
      visitor.visitIndex(curr->index);
    }
    ReturnType visitGetGlobal(GetGlobal* curr) {
      visitor.visitName(curr->name);
    }
    ReturnType visitSetGlobal(SetGlobal* curr) {
      visitor.visitName(curr->name);
    }
    ReturnType visitLoad(Load* curr) {
      visitor.visitInt(curr->bytes);
      visitor.visitInt(curr->signed_);
      visitor.visitAddress(curr->offset);
      visitor.visitAddress(curr->align);
      visitor.visitEnum(curr->isAtomic);
    }
    ReturnType visitStore(Store* curr) {
      visitor.visitEnum(curr->bytes);
      visitor.visitEnum(curr->signed_);
      visitor.visitAddress(curr->offset);
      visitor.visitAddress(curr->align);
      visitor.visitEnum(curr->isAtomic);
      visitor.visitEnum(curr->valueType);
    }
    ReturnType visitAtomicRMW(AtomicRMW* curr) {
      visitor.visitEnum(curr->op);
      visitor.visitEnum(curr->bytes);
      visitor.visitAddress(curr->offset);
    }
    ReturnType visitAtomicCmpxchg(AtomicCmpxchg* curr) {
      visitor.visitEnum(curr->bytes);
      visitor.visitAddress(curr->offset);
    }
    ReturnType visitAtomicWait(AtomicWait* curr) {
      visitor.visitAddress(curr->offset);
      visitor.visitType(curr->expectedType);
    }
    ReturnType visitAtomicWake(AtomicWake* curr) {
      visitor.visitAddress(curr->offset);
    }
    ReturnType visitSIMDExtract(SIMDExtract* curr) {
      visitor.visitInt(curr->op);
      visitor.visitInt(curr->index);
    }
    ReturnType visitSIMDReplace(SIMDReplace* curr) {
      visitor.visitInt(curr->op);
      visitor.visitInt(curr->index);
    }
    ReturnType visitSIMDShuffle(SIMDShuffle* curr) {
      for (auto x : curr->mask) {
        visitor.visitInt(x);
      }
    }
    ReturnType visitSIMDBitselect(SIMDBitselect* curr) {
    }
    ReturnType visitSIMDShift(SIMDShift* curr) {
      visitor.visitInt(curr->op);
    }
    ReturnType visitMemoryInit(MemoryInit* curr) {
      visitor.visitIndex(curr->segment);
    }
    ReturnType visitDataDrop(DataDrop* curr) {
      visitor.visitIndex(curr->segment);
    }
    ReturnType visitMemoryCopy(MemoryCopy* curr) {
    }
    ReturnType visitMemoryFill(MemoryFill* curr) {
    }
    ReturnType visitConst(Const* curr) {
      visitor.visitLiteral(curr->value);
    }
    ReturnType visitUnary(Unary* curr) {
      visitor.visitInt(curr->op);
    }
    ReturnType visitBinary(Binary* curr) {
      visitor.visitInt(curr->op);
    }
    ReturnType visitSelect(Select* curr) {
    }
    ReturnType visitDrop(Drop* curr) {{
    }
    ReturnType visitReturn(Return* curr) {
    }
    ReturnType visitHost(Host* curr) {
      visitor.visitInt(curr->op);
      visitor.visitName(curr->nameOperand);
    }
    ReturnType visitNop(Nop* curr) {
    }
    ReturnType visitUnreachable(Unreachable* curr) {
    }
  } singleton(curr, visitor);
}

bool ExpressionAnalyzer::flexibleEqual(Expression* left, Expression* right, ExprComparer comparer) {
  std::vector<Name> nameStack;
  std::map<Name, std::vector<Name>> rightNames; // for each name on the left, the stack of names on the right (a stack, since names are scoped and can nest duplicatively
  Nop popNameMarker;
  std::vector<Expression*> leftStack;
  std::vector<Expression*> rightStack;

  struct ImmediateVisitor {
    std::vector<Name> names;
    std::vector<int32_t> ints;
    std::vector<Literal> literals;
    std::vector<Type> types;
    std::vector<Index> indexes;

    void visitName(Name curr) { names.push_back(curr); }
    void visitInt(int32_t curr) { ints.push_back(curr); }
    void visitLiteral(Literal curr) { literals.push_back(curr); }
    void visitType(Type curr) { types.push_back(curr); }
    void visitIndex(Index curr) { indexes.push_back(curr); }
  } leftImmediates, rightImmediates;

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
    // Compare immediate values
    visitImmediates(left, leftImmediates);
    visitImmediates(right, rightImmediates);
    if (leftImmediates != rightImmediates) return false;
    leftImmediates.clear();
    rightImmediates.clear();
    // Add child nodes
    Index counter = 0;
    for (auto* child : ChildIterator(left)) {
      leftStack.push_back(child);
      counter++;
    }
    for (auto* child : ChildIterator(right)) {
      rightStack.push_back(child);
      counter--;
    }
    if (counter != 0) return false;
  }
  if (leftStack.size() > 0 || rightStack.size() > 0) return false;
  return true;
}

// hash an expression, ignoring superficial details like specific internal names
HashType ExpressionAnalyzer::hash(Expression* curr) {
  struct Hasher {
    HashType digest = 0;

    void hash(HashType hash) {
      digest = rehash(digest, hash);
    }
    void hash64(uint64_t hash) {
      digest = rehash(rehash(digest, HashType(hash >> 32)), HashType(hash));
    }

    std::vector<Name> nameStack;
    Index internalCounter = 0;
    std::map<Name, std::vector<Index>> internalNames; // for each internal name, a vector if unique ids
    Nop popNameMarker;
    std::vector<Expression*> stack;

    void noteName(Name curr) {
      if (curr.is()) {
        nameStack.push_back(curr);
        internalNames[curr].push_back(internalCounter++);
        stack.push_back(&popNameMarker);
      }
    }
    void hashName(Name curr) {
      auto iter = internalNames.find(curr);
      if (iter == internalNames.end()) hash64(uint64_t(curr.str));
      else hash(iter->second.back());
    }
    void popName() {
      auto curr = nameStack.back();
      nameStack.pop_back();
      internalNames[curr].pop_back();
    };

    Hasher(Expression* curr) {
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
        // local.get's type is determined by the function, so if we are
        // hashing only expression fragments, then two from different
        // functions may turn out the same even if the type differs. Likewise,
        // if we hash between modules, then we need to take int account
        // call_imports type, etc. The simplest thing is just to hash the
        // type for all of them.
        hash(curr->type);
        // Hash immediates
        visitImmediates(curr, *this);
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

    void visitName(Name curr) { names.push_back(curr); }
    void visitInt(int32_t curr) { ints.push_back(curr); }
    void visitLiteral(Literal curr) { literals.push_back(curr); }
    void visitType(Type curr) { types.push_back(curr); }
    void visitIndex(Index curr) { indexes.push_back(curr); }
  };

  return Hasher(curr).digest;
}

} // namespace wasm
