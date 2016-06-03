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

#ifndef wasm_ast_utils_h
#define wasm_ast_utils_h

#include "support/hash.h"
#include "wasm.h"
#include "wasm-traversal.h"

namespace wasm {

struct BreakSeeker : public PostWalker<BreakSeeker, Visitor<BreakSeeker>> {
  Name target; // look for this one XXX looking by name may fall prey to duplicate names
  size_t found;

  BreakSeeker(Name target) : target(target), found(false) {}

  void visitBreak(Break *curr) {
    if (curr->name == target) found++;
  }

  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      if (name == target) found++;
    }
    if (curr->default_ == target) found++;
  }

  static bool has(Expression* tree, Name target) {
    BreakSeeker breakSeeker(target);
    breakSeeker.walk(tree);
    return breakSeeker.found > 0;
  }
};

// Finds all functions that are reachable via direct calls.

struct DirectCallGraphAnalyzer : public PostWalker<DirectCallGraphAnalyzer, Visitor<DirectCallGraphAnalyzer>> {
  Module *module;
  std::vector<Function*> queue;
  std::unordered_set<Function*> reachable;

  DirectCallGraphAnalyzer(Module* module, const std::vector<Function*>& root) : module(module) {
    for (auto* curr : root) {
      queue.push_back(curr);
    }
    while (queue.size()) {
      auto* curr = queue.back();
      queue.pop_back();
      if (reachable.count(curr) == 0) {
        reachable.insert(curr);
        walk(curr->body);
      }
    }
  }
  void visitCall(Call *curr) {
    auto* target = module->getFunction(curr->target);
    if (reachable.count(target) == 0) {
      queue.push_back(target);
    }
  }
};

// Look for side effects, including control flow
// TODO: optimize

struct EffectAnalyzer : public PostWalker<EffectAnalyzer, Visitor<EffectAnalyzer>> {
  EffectAnalyzer() {}
  EffectAnalyzer(Expression *ast) {
    walk(ast);
    // if we are left with breaks, they are external
    if (breakNames.size() > 0) branches = true;
  }

  bool branches = false; // branches out of this expression
  bool calls = false;
  std::set<Index> localsRead;
  std::set<Index> localsWritten;
  bool readsMemory = false;
  bool writesMemory = false;

  bool accessesLocal() { return localsRead.size() + localsWritten.size() > 0; }
  bool accessesMemory() { return calls || readsMemory || writesMemory; }
  bool hasSideEffects() { return calls || localsWritten.size() > 0 || writesMemory || branches; }
  bool hasAnything() { return branches || calls || accessesLocal() || readsMemory || writesMemory; }

  // checks if these effects would invalidate another set (e.g., if we write, we invalidate someone that reads, they can't be moved past us)
  bool invalidates(EffectAnalyzer& other) {
    if (branches || other.branches
                 || ((writesMemory || calls) && other.accessesMemory())
                 || (accessesMemory() && (other.writesMemory || other.calls))) {
      return true;
    }
    assert(localsWritten.size() + localsRead.size() <= 1); // the code below is fast on that case, of one element vs many
    for (auto local : localsWritten) {
      if (other.localsWritten.count(local) || other.localsRead.count(local)) {
        return true;
      }
    }
    for (auto local : localsRead) {
      if (other.localsWritten.count(local)) return true;
    }
    return false;
  }

  // the checks above happen after the node's children were processed, in the order of execution
  // we must also check for control flow that happens before the children, i.e., loops
  bool checkPre(Expression* curr) {
    if (curr->is<Loop>()) {
      branches = true;
      return true;
    }
    return false;
  }

  bool checkPost(Expression* curr) {
    visit(curr);
    return hasAnything();
  }

  std::set<Name> breakNames;

  void visitBreak(Break *curr) {
    breakNames.insert(curr->name);
  }
  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      breakNames.insert(name);
    }
    breakNames.insert(curr->default_);
  }
  void visitBlock(Block* curr) {
    if (curr->name.is()) breakNames.erase(curr->name); // these were internal breaks
  }
  void visitLoop(Loop* curr) {
    if (curr->in.is()) breakNames.erase(curr->in); // these were internal breaks
    if (curr->out.is()) breakNames.erase(curr->out); // these were internal breaks
  }

  void visitCall(Call *curr) { calls = true; }
  void visitCallImport(CallImport *curr) { calls = true; }
  void visitCallIndirect(CallIndirect *curr) { calls = true; }
  void visitGetLocal(GetLocal *curr) {
    localsRead.insert(curr->index);
  }
  void visitSetLocal(SetLocal *curr) {
    localsWritten.insert(curr->index);
  }
  void visitLoad(Load *curr) { readsMemory = true; }
  void visitStore(Store *curr) { writesMemory = true; }
  void visitReturn(Return *curr) { branches = true; }
  void visitHost(Host *curr) { calls = true; }
  void visitUnreachable(Unreachable *curr) { branches = true; }
};

// Meausure the size of an AST
struct Measurer : public PostWalker<Measurer, UnifiedExpressionVisitor<Measurer>> {
  Index size = 0;

  void visitExpression(Expression* curr) {
    size++;
  }

  static Index measure(Expression* tree) {
    Measurer measurer;
    measurer.walk(tree);
    return measurer.size;
  }
};

// Manipulate expressions

struct ExpressionManipulator {
  // Re-use a node's memory. This helps avoid allocation when optimizing.
  template<typename InputType, typename OutputType>
  static OutputType* convert(InputType *input) {
    static_assert(sizeof(OutputType) <= sizeof(InputType),
                  "Can only convert to a smaller size Expression node");
    input->~InputType(); // arena-allocaed, so no destructor, but avoid UB.
    OutputType* output = (OutputType*)(input);
    new (output) OutputType;
    return output;
  }

  // Convenience method for nop, which is a common conversion
  template<typename InputType>
  static void nop(InputType* target) {
    convert<InputType, Nop>(target);
  }

  // Convert a node that allocates
  template<typename InputType, typename OutputType>
  static OutputType* convert(InputType *input, MixedArena& allocator) {
    assert(sizeof(OutputType) <= sizeof(InputType));
    input->~InputType(); // arena-allocaed, so no destructor, but avoid UB.
    OutputType* output = (OutputType*)(input);
    new (output) OutputType(allocator);
    return output;
  }
};

struct ExpressionAnalyzer {
  // Given a stack of expressions, checks if the topmost is used as a result.
  // For example, if the parent is a block and the node is before the last position,
  // it is not used.
  static bool isResultUsed(std::vector<Expression*> stack, Function* func) {
    for (int i = int(stack.size()) - 2; i >= 0; i--) {
      auto* curr = stack[i];
      auto* above = stack[i + 1];
      // only if and block can drop values
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
        return true; // all other node types use the result
      }
    }
    // The value might be used, so it depends on if the function returns
    return func->result != none;
  }

  static bool equal(Expression* left, Expression* right) {
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
      if (left->_id != right->_id) return false;
      #define PUSH(clazz, what) \
        leftStack.push_back(left->cast<clazz>()->what); \
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
          if (!noteNames(left->cast<Loop>()->out, right->cast<Loop>()->out)) return false;
          if (!noteNames(left->cast<Loop>()->in, right->cast<Loop>()->in)) return false;
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
        case Expression::Id::CallImportId: {
          CHECK(CallImport, target);
          CHECK(CallImport, operands.size());
          for (Index i = 0; i < left->cast<CallImport>()->operands.size(); i++) {
            PUSH(CallImport, operands[i]);
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
          PUSH(SetLocal, value);
          break;
        }
        case Expression::Id::LoadId: {
          CHECK(Load, bytes);
          CHECK(Load, signed_);
          CHECK(Load, offset);
          CHECK(Load, align);
          PUSH(Load, ptr);
          break;
        }
        case Expression::Id::StoreId: {
          CHECK(Store, bytes);
          CHECK(Store, offset);
          CHECK(Store, align);
          PUSH(Store, ptr);
          PUSH(Store, value);
          break;
        }
        case Expression::Id::ConstId: {
          CHECK(Const, value);
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
  static uint32_t hash(Expression* curr) {
    uint32_t digest = 0;

    auto hash = [&digest](uint32_t hash) {
      digest = rehash(digest, hash);
    };
    auto hash64 = [&digest](uint64_t hash) {
      digest = rehash(rehash(digest, hash >> 32), uint32_t(hash));
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
          noteName(curr->cast<Loop>()->out);
          noteName(curr->cast<Loop>()->in);
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
        case Expression::Id::CallImportId: {
          HASH_NAME(CallImport, target);
          HASH(CallImport, operands.size());
          for (Index i = 0; i < curr->cast<CallImport>()->operands.size(); i++) {
            PUSH(CallImport, operands[i]);
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
        case Expression::Id::LoadId: {
          HASH(Load, bytes);
          HASH(Load, signed_);
          HASH(Load, offset);
          HASH(Load, align);
          PUSH(Load, ptr);
          break;
        }
        case Expression::Id::StoreId: {
          HASH(Store, bytes);
          HASH(Store, offset);
          HASH(Store, align);
          PUSH(Store, ptr);
          PUSH(Store, value);
          break;
        }
        case Expression::Id::ConstId: {
          HASH(Const, value.type);
          HASH64(Const, value.getBits());
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
};

} // namespace wasm

#endif // wasm_ast_utils_h
