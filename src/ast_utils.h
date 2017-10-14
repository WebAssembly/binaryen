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

#include "wasm.h"
#include "wasm-traversal.h"
#include "wasm-builder.h"
#include "pass.h"
#include "ast/branch-utils.h"

namespace wasm {

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

struct ExpressionAnalyzer {
  // Given a stack of expressions, checks if the topmost is used as a result.
  // For example, if the parent is a block and the node is before the last position,
  // it is not used.
  static bool isResultUsed(std::vector<Expression*> stack, Function* func);

  // Checks if a value is dropped.
  static bool isResultDropped(std::vector<Expression*> stack);

  // Checks if a break is a simple - no condition, no value, just a plain branching
  static bool isSimple(Break* curr) {
    return !curr->condition && !curr->value;
  }

  using ExprComparer = std::function<bool(Expression*, Expression*)>;
  static bool flexibleEqual(Expression* left, Expression* right, ExprComparer comparer);

  static bool equal(Expression* left, Expression* right) {
    auto comparer = [](Expression* left, Expression* right) {
      return false;
    };
    return flexibleEqual(left, right, comparer);
  }

  // hash an expression, ignoring superficial details like specific internal names
  static uint32_t hash(Expression* curr);
};

// Re-Finalizes all node types
// This removes "unnecessary' block/if/loop types, i.e., that are added
// specifically, as in
//  (block (result i32) (unreachable))
// vs
//  (block (unreachable))
// This converts to the latter form.
struct ReFinalize : public WalkerPass<PostWalker<ReFinalize>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new ReFinalize; }

  ReFinalize() { name = "refinalize"; }

  // block finalization is O(bad) if we do each block by itself, so do it in bulk,
  // tracking break value types so we just do a linear pass

  std::map<Name, WasmType> breakValues;

  void visitBlock(Block *curr) {
    if (curr->list.size() == 0) {
      curr->type = none;
      return;
    }
    // do this quickly, without any validation
    auto old = curr->type;
    // last element determines type
    curr->type = curr->list.back()->type;
    // if concrete, it doesn't matter if we have an unreachable child, and we
    // don't need to look at breaks
    if (isConcreteWasmType(curr->type)) return;
    // otherwise, we have no final fallthrough element to determine the type,
    // could be determined by breaks
    if (curr->name.is()) {
      auto iter = breakValues.find(curr->name);
      if (iter != breakValues.end()) {
        // there is a break to here
        auto type = iter->second;
        if (type == unreachable) {
          // all we have are breaks with values of type unreachable, and no
          // concrete fallthrough either. we must have had an existing type, then
          curr->type = old;
          assert(isConcreteWasmType(curr->type));
        } else {
          curr->type = type;
        }
        return;
      }
    }
    if (curr->type == unreachable) return;
    // type is none, but we might be unreachable
    if (curr->type == none) {
      for (auto* child : curr->list) {
        if (child->type == unreachable) {
          curr->type = unreachable;
          break;
        }
      }
    }
  }
  void visitIf(If *curr) { curr->finalize(); }
  void visitLoop(Loop *curr) { curr->finalize(); }
  void visitBreak(Break *curr) {
    curr->finalize();
    updateBreakValueType(curr->name, getValueType(curr->value));
  }
  void visitSwitch(Switch *curr) {
    curr->finalize();
    auto valueType = getValueType(curr->value);
    for (auto target : curr->targets) {
      updateBreakValueType(target, valueType);
    }
    updateBreakValueType(curr->default_, valueType);
  }
  void visitCall(Call *curr) { curr->finalize(); }
  void visitCallImport(CallImport *curr) { curr->finalize(); }
  void visitCallIndirect(CallIndirect *curr) { curr->finalize(); }
  void visitGetLocal(GetLocal *curr) { curr->finalize(); }
  void visitSetLocal(SetLocal *curr) { curr->finalize(); }
  void visitGetGlobal(GetGlobal *curr) { curr->finalize(); }
  void visitSetGlobal(SetGlobal *curr) { curr->finalize(); }
  void visitLoad(Load *curr) { curr->finalize(); }
  void visitStore(Store *curr) { curr->finalize(); }
  void visitAtomicRMW(AtomicRMW *curr) { curr->finalize(); }
  void visitAtomicCmpxchg(AtomicCmpxchg *curr) { curr->finalize(); }
  void visitConst(Const *curr) { curr->finalize(); }
  void visitUnary(Unary *curr) { curr->finalize(); }
  void visitBinary(Binary *curr) { curr->finalize(); }
  void visitSelect(Select *curr) { curr->finalize(); }
  void visitDrop(Drop *curr) { curr->finalize(); }
  void visitReturn(Return *curr) { curr->finalize(); }
  void visitHost(Host *curr) { curr->finalize(); }
  void visitNop(Nop *curr) { curr->finalize(); }
  void visitUnreachable(Unreachable *curr) { curr->finalize(); }

  void visitFunction(Function* curr) {
    // we may have changed the body from unreachable to none, which might be bad
    // if the function has a return value
    if (curr->result != none && curr->body->type == none) {
      Builder builder(*getModule());
      curr->body = builder.blockify(curr->body, builder.makeUnreachable());
    }
  }

  WasmType getValueType(Expression* value) {
    return value ? value->type : none;
  }

  void updateBreakValueType(Name name, WasmType type) {
    if (type != unreachable || breakValues.count(name) == 0) {
      breakValues[name] = type;
    }
  }
};

// Re-finalize a single node. This is slow, if you want to refinalize
// an entire ast, use ReFinalize
struct ReFinalizeNode : public Visitor<ReFinalizeNode> {
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

  // given a stack of nested expressions, update them all from child to parent
  static void updateStack(std::vector<Expression*>& expressionStack) {
    for (int i = int(expressionStack.size()) - 1; i >= 0; i--) {
      auto* curr = expressionStack[i];
      ReFinalizeNode().visit(curr);
    }
  }
};

// Adds drop() operations where necessary. This lets you not worry about adding drop when
// generating code.
// This also refinalizes before and after, as dropping can change types, and depends
// on types being cleaned up - no unnecessary block/if/loop types (see refinalize)
// TODO: optimize that, interleave them
struct AutoDrop : public WalkerPass<ExpressionStackWalker<AutoDrop>> {
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
    ReFinalizeNode::updateStack(expressionStack);
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
      assert(curr->type == none || curr->type == unreachable);
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

  void doWalkFunction(Function* curr) {
    ReFinalize().walkFunctionInModule(curr, getModule());
    walk(curr->body);
    if (curr->result == none && isConcreteWasmType(curr->body->type)) {
      curr->body = Builder(*getModule()).makeDrop(curr->body);
    }
    ReFinalize().walkFunctionInModule(curr, getModule());
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
