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
#include "wasm-builder.h"
#include "pass.h"

namespace wasm {

// Finds if there are breaks targeting a name. Note that since names are
// unique in our IR, we just need to look for the name, and do not need
// to analyze scoping.
struct BreakSeeker : public PostWalker<BreakSeeker, Visitor<BreakSeeker>> {
  Name target;
  Index found;
  WasmType valueType;

  BreakSeeker(Name target) : target(target), found(0) {}

  void noteFound(Expression* value) {
    found++;
    if (found == 1) valueType = unreachable;
    if (!value) valueType = none;
    else if (value->type != unreachable) valueType = value->type;
  }

  void visitBreak(Break *curr) {
    if (curr->name == target) noteFound(curr->value);
  }

  void visitSwitch(Switch *curr) {
    for (auto name : curr->targets) {
      if (name == target) noteFound(curr->value);
    }
    if (curr->default_ == target) noteFound(curr->value);
  }

  static bool has(Expression* tree, Name target) {
    if (!target.is()) return false;
    BreakSeeker breakSeeker(target);
    breakSeeker.walk(tree);
    return breakSeeker.found > 0;
  }

  static Index count(Expression* tree, Name target) {
    if (!target.is()) return 0;
    BreakSeeker breakSeeker(target);
    breakSeeker.walk(tree);
    return breakSeeker.found;
  }
};

// Look for side effects, including control flow
// TODO: optimize

struct EffectAnalyzer : public PostWalker<EffectAnalyzer, Visitor<EffectAnalyzer>> {
  EffectAnalyzer() {}
  EffectAnalyzer(Expression *ast) {
    analyze(ast);
  }

  void analyze(Expression *ast) {
    breakNames.clear();
    walk(ast);
    // if we are left with breaks, they are external
    if (breakNames.size() > 0) branches = true;
  }

  bool branches = false; // branches out of this expression
  bool calls = false;
  std::set<Index> localsRead;
  std::set<Index> localsWritten;
  std::set<Name> globalsRead;
  std::set<Name> globalsWritten;
  bool readsMemory = false;
  bool writesMemory = false;

  bool accessesLocal() { return localsRead.size() + localsWritten.size() > 0; }
  bool accessesGlobal() { return globalsRead.size() + globalsWritten.size() > 0; }
  bool accessesMemory() { return calls || readsMemory || writesMemory; }
  bool hasSideEffects() { return calls || localsWritten.size() > 0 || writesMemory || branches || globalsWritten.size() > 0; }
  bool hasAnything() { return branches || calls || accessesLocal() || readsMemory || writesMemory || accessesGlobal(); }

  // checks if these effects would invalidate another set (e.g., if we write, we invalidate someone that reads, they can't be moved past us)
  bool invalidates(EffectAnalyzer& other) {
    if (branches || other.branches
                 || ((writesMemory || calls) && other.accessesMemory())
                 || (accessesMemory() && (other.writesMemory || other.calls))) {
      return true;
    }
    for (auto local : localsWritten) {
      if (other.localsWritten.count(local) || other.localsRead.count(local)) {
        return true;
      }
    }
    for (auto local : localsRead) {
      if (other.localsWritten.count(local)) return true;
    }
    if ((accessesGlobal() && other.calls) || (other.accessesGlobal() && calls)) {
      return true;
    }
    for (auto global : globalsWritten) {
      if (other.globalsWritten.count(global) || other.globalsRead.count(global)) {
        return true;
      }
    }
    for (auto global : globalsRead) {
      if (other.globalsWritten.count(global)) return true;
    }
    return false;
  }

  void mergeIn(EffectAnalyzer& other) {
    branches = branches || other.branches;
    calls = calls || other.calls;
    readsMemory = readsMemory || other.readsMemory;
    writesMemory = writesMemory || other.writesMemory;
    for (auto i : other.localsRead) localsRead.insert(i);
    for (auto i : other.localsWritten) localsWritten.insert(i);
    for (auto i : other.globalsRead) globalsRead.insert(i);
    for (auto i : other.globalsWritten) globalsWritten.insert(i);
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
    if (curr->is<Loop>()) {
      branches = true;
    }
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
    if (curr->name.is()) breakNames.erase(curr->name); // these were internal breaks
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
  void visitGetGlobal(GetGlobal *curr) {
    globalsRead.insert(curr->name);
  }
  void visitSetGlobal(SetGlobal *curr) {
    globalsWritten.insert(curr->name);
  }
  void visitLoad(Load *curr) { readsMemory = true; }
  void visitStore(Store *curr) { writesMemory = true; }
  void visitReturn(Return *curr) { branches = true; }
  void visitHost(Host *curr) { calls = true; }
  void visitUnreachable(Unreachable *curr) { branches = true; }
};

// Measure the size of an AST

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

  template<typename T>
  static Expression* flexibleCopy(Expression* original, Module& wasm, T& custom) {
    struct Copier : public Visitor<Copier, Expression*> {
      Module& wasm;
      T& custom;

      Builder builder;

      Copier(Module& wasm, T& custom) : wasm(wasm), custom(custom), builder(wasm) {}

      Expression* copy(Expression* curr) {
        if (!curr) return nullptr;
        auto* ret = custom.copy(curr);
        if (ret) return ret;
        return Visitor<Copier, Expression*>::visit(curr);
      }

      Expression* visitBlock(Block *curr) {
        auto* ret = builder.makeBlock();
        for (Index i = 0; i < curr->list.size(); i++) {
          ret->list.push_back(copy(curr->list[i]));
        }
        ret->name = curr->name;
        ret->finalize(curr->type);
        return ret;
      }
      Expression* visitIf(If *curr) {
        return builder.makeIf(copy(curr->condition), copy(curr->ifTrue), copy(curr->ifFalse));
      }
      Expression* visitLoop(Loop *curr) {
        return builder.makeLoop(curr->name, copy(curr->body));
      }
      Expression* visitBreak(Break *curr) {
        return builder.makeBreak(curr->name, copy(curr->value), copy(curr->condition));
      }
      Expression* visitSwitch(Switch *curr) {
        return builder.makeSwitch(curr->targets, curr->default_, copy(curr->condition), copy(curr->value));
      }
      Expression* visitCall(Call *curr) {
        auto* ret = builder.makeCall(curr->target, {}, curr->type);
        for (Index i = 0; i < curr->operands.size(); i++) {
          ret->operands.push_back(copy(curr->operands[i]));
        }
        return ret;
      }
      Expression* visitCallImport(CallImport *curr) {
        auto* ret = builder.makeCallImport(curr->target, {}, curr->type);
        for (Index i = 0; i < curr->operands.size(); i++) {
          ret->operands.push_back(copy(curr->operands[i]));
        }
        return ret;
      }
      Expression* visitCallIndirect(CallIndirect *curr) {
        auto* ret = builder.makeCallIndirect(curr->fullType, curr->target, {}, curr->type);
        for (Index i = 0; i < curr->operands.size(); i++) {
          ret->operands.push_back(copy(curr->operands[i]));
        }
        return ret;
      }
      Expression* visitGetLocal(GetLocal *curr) {
        return builder.makeGetLocal(curr->index, curr->type);
      }
      Expression* visitSetLocal(SetLocal *curr) {
        if (curr->isTee()) {
          return builder.makeTeeLocal(curr->index, copy(curr->value));
        } else {
          return builder.makeSetLocal(curr->index, copy(curr->value));
        }
      }
      Expression* visitGetGlobal(GetGlobal *curr) {
        return builder.makeGetGlobal(curr->name, curr->type);
      }
      Expression* visitSetGlobal(SetGlobal *curr) {
        return builder.makeSetGlobal(curr->name, copy(curr->value));
      }
      Expression* visitLoad(Load *curr) {
        return builder.makeLoad(curr->bytes, curr->signed_, curr->offset, curr->align, copy(curr->ptr), curr->type);
      }
      Expression* visitStore(Store *curr) {
        return builder.makeStore(curr->bytes, curr->offset, curr->align, copy(curr->ptr), copy(curr->value), curr->valueType);
      }
      Expression* visitConst(Const *curr) {
        return builder.makeConst(curr->value);
      }
      Expression* visitUnary(Unary *curr) {
        return builder.makeUnary(curr->op, copy(curr->value));
      }
      Expression* visitBinary(Binary *curr) {
        return builder.makeBinary(curr->op, copy(curr->left), copy(curr->right));
      }
      Expression* visitSelect(Select *curr) {
        return builder.makeSelect(copy(curr->condition), copy(curr->ifTrue), copy(curr->ifFalse));
      }
      Expression* visitDrop(Drop *curr) {
        return builder.makeDrop(copy(curr->value));
      }
      Expression* visitReturn(Return *curr) {
        return builder.makeReturn(copy(curr->value));
      }
      Expression* visitHost(Host *curr) {
        assert(curr->operands.size() == 0);
        return builder.makeHost(curr->op, curr->nameOperand, {});
      }
      Expression* visitNop(Nop *curr) {
        return builder.makeNop();
      }
      Expression* visitUnreachable(Unreachable *curr) {
        return builder.makeUnreachable();
      }
    };

    Copier copier(wasm, custom);
    return copier.copy(original);
  }

  static Expression* copy(Expression* original, Module& wasm) {
    struct Copier {
      Expression* copy(Expression* curr) {
        return nullptr;
      }
    } copier;
    return flexibleCopy(original, wasm, copier);
  }

  // Splice an item into the middle of a block's list
  static void spliceIntoBlock(Block* block, Index index, Expression* add) {
    auto& list = block->list;
    if (index == list.size()) {
      list.push_back(add); // simple append
    } else {
      // we need to make room
      list.push_back(nullptr);
      for (Index i = list.size() - 1; i > index; i--) {
        list[i] = list[i - 1];
      }
      list[index] = add;
    }
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
  static bool isResultDropped(std::vector<Expression*> stack) {
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

  // Checks if a break is a simple - no condition, no value, just a plain branching
  static bool isSimple(Break* curr) {
    return !curr->condition && !curr->value;
  }

  // Checks if an expression does not flow out in an obvious way.
  // We return true if it cannot flow out. If it can flow out, we
  // might still return true, as the analysis here is simple and fast.
  static bool obviouslyDoesNotFlowOut(Expression* curr) {
    if (auto* br = curr->dynCast<Break>()) {
      if (!br->condition) return true;
    } else if (auto* block = curr->dynCast<Block>()) {
      if (block->list.size() > 0 && obviouslyDoesNotFlowOut(block->list.back()) && !BreakSeeker::has(block, block->name)) return true;
    }
    return false;
  }

  template<typename T>
  static bool flexibleEqual(Expression* left, Expression* right, T& comparer) {
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
      if (comparer.compare(left, right)) continue; // comparison hook, before all the rest
      // continue with normal structural comparison
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
          CHECK(Store, valueType);
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

  static bool equal(Expression* left, Expression* right) {
    struct Comparer {
      bool compare(Expression* left, Expression* right) {
        return false;
      }
    } comparer;
    return flexibleEqual(left, right, comparer);
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
          HASH(Store, valueType);
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
};

// Finalizes a node

struct ReFinalize : public WalkerPass<PostWalker<ReFinalize, Visitor<ReFinalize>>> {
  ReFinalize() { name = "refinalize"; }

  void visitBlock(Block *curr) { curr->finalize(); }
  void visitIf(If *curr) { curr->finalize(); }
  void visitLoop(Loop *curr) { curr->finalize(); }
  void visitBreak(Break *curr) { curr->finalize(); }
  void visitSwitch(Switch *curr) { curr->finalize(); }
  void visitCall(Call *curr) { curr->finalize(); }
  void visitCallImport(CallImport *curr) { curr->finalize(); }
  void visitCallIndirect(CallIndirect *curr) { curr->finalize(); }
  void visitGetLocal(GetLocal *curr) { curr->finalize(); }
  void visitSetLocal(SetLocal *curr) { curr->finalize(); }
  void visitGetGlobal(GetGlobal *curr) { curr->finalize(); }
  void visitSetGlobal(SetGlobal *curr) { curr->finalize(); }
  void visitLoad(Load *curr) { curr->finalize(); }
  void visitStore(Store *curr) { curr->finalize(); }
  void visitConst(Const *curr) { curr->finalize(); }
  void visitUnary(Unary *curr) { curr->finalize(); }
  void visitBinary(Binary *curr) { curr->finalize(); }
  void visitSelect(Select *curr) { curr->finalize(); }
  void visitDrop(Drop *curr) { curr->finalize(); }
  void visitReturn(Return *curr) { curr->finalize(); }
  void visitHost(Host *curr) { curr->finalize(); }
  void visitNop(Nop *curr) { curr->finalize(); }
  void visitUnreachable(Unreachable *curr) { curr->finalize(); }
};

// Adds drop() operations where necessary. This lets you not worry about adding drop when
// generating code.
struct AutoDrop : public WalkerPass<ExpressionStackWalker<AutoDrop, Visitor<AutoDrop>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new AutoDrop; }

  AutoDrop() { name = "autodrop"; }

  bool maybeDrop(Expression*& child) {
    bool acted = false;
    if (isConcreteWasmType(child->type)) {
      expressionStack.push_back(child);
      if (!ExpressionAnalyzer::isResultUsed(expressionStack, getFunction()) && !ExpressionAnalyzer::isResultDropped(expressionStack)) {
        child = Builder(*getModule()).makeDrop(child);
        acted = true;
      }
      expressionStack.pop_back();
    }
    return acted;
  }

  void reFinalize() {
    for (int i = int(expressionStack.size()) - 1; i >= 0; i--) {
      auto* curr = expressionStack[i];
      ReFinalize().visit(curr);
    }
  }

  void visitBlock(Block* curr) {
    if (curr->list.size() == 0) return;
    for (Index i = 0; i < curr->list.size() - 1; i++) {
      auto* child = curr->list[i];
      if (isConcreteWasmType(child->type)) {
        curr->list[i] = Builder(*getModule()).makeDrop(child);
      }
    }
    if (maybeDrop(curr->list.back())) {
      reFinalize();
      assert(curr->type == none);
    }
  }

  void visitIf(If* curr) {
    bool acted = false;
    if (maybeDrop(curr->ifTrue)) acted = true;
    if (curr->ifFalse) {
      if (maybeDrop(curr->ifFalse)) acted = true;
    }
    if (acted) {
      reFinalize();
      assert(curr->type == none);
    }
  }

  void visitFunction(Function* curr) {
    if (curr->result == none && isConcreteWasmType(curr->body->type)) {
      curr->body = Builder(*getModule()).makeDrop(curr->body);
    }
  }
};

struct I64Utilities {
  static Expression* recreateI64(Builder& builder, Expression* low, Expression* high) {
    return
      builder.makeBinary(
        OrInt64,
        builder.makeUnary(
          ExtendUInt32,
          low
        ),
        builder.makeBinary(
          ShlInt64,
          builder.makeUnary(
            ExtendUInt32,
            high
          ),
          builder.makeConst(Literal(int64_t(32)))
        )
      )
    ;
  };

  static Expression* recreateI64(Builder& builder, Index low, Index high) {
    return recreateI64(builder, builder.makeGetLocal(low, i32), builder.makeGetLocal(high, i32));
  };

  static Expression* getI64High(Builder& builder, Index index) {
    return
      builder.makeUnary(
        WrapInt64,
        builder.makeBinary(
          ShrUInt64,
          builder.makeGetLocal(index, i64),
          builder.makeConst(Literal(int64_t(32)))
        )
      )
    ;
  }

  static Expression* getI64Low(Builder& builder, Index index) {
    return
      builder.makeUnary(
        WrapInt64,
        builder.makeGetLocal(index, i64)
      )
    ;
  }
};

} // namespace wasm

#endif // wasm_ast_utils_h
