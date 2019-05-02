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

#ifndef wasm_ir_utils_h
#define wasm_ir_utils_h

#include "ir/branch-utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

// Measure the size of an AST

struct Measurer
  : public PostWalker<Measurer, UnifiedExpressionVisitor<Measurer>> {
  Index size = 0;

  void visitExpression(Expression* curr) { size++; }

  static Index measure(Expression* tree) {
    Measurer measurer;
    measurer.walk(tree);
    return measurer.size;
  }
};

struct ExpressionAnalyzer {
  // Given a stack of expressions, checks if the topmost is used as a result.
  // For example, if the parent is a block and the node is before the last
  // position, it is not used.
  static bool isResultUsed(ExpressionStack& stack, Function* func);

  // Checks if a value is dropped.
  static bool isResultDropped(ExpressionStack& stack);

  // Checks if a break is a simple - no condition, no value, just a plain
  // branching
  static bool isSimple(Break* curr) { return !curr->condition && !curr->value; }

  using ExprComparer = std::function<bool(Expression*, Expression*)>;
  static bool
  flexibleEqual(Expression* left, Expression* right, ExprComparer comparer);

  // Compares two expressions for equivalence.
  static bool equal(Expression* left, Expression* right) {
    auto comparer = [](Expression* left, Expression* right) { return false; };
    return flexibleEqual(left, right, comparer);
  }

  // A shallow comparison, ignoring child nodes.
  static bool shallowEqual(Expression* left, Expression* right) {
    auto comparer = [left, right](Expression* currLeft, Expression* currRight) {
      if (currLeft == left && currRight == right) {
        // these are the ones we want to compare
        return false;
      }
      // otherwise, don't do the comparison, we don't care
      return true;
    };
    return flexibleEqual(left, right, comparer);
  }

  // hash an expression, ignoring superficial details like specific internal
  // names
  static HashType hash(Expression* curr);
};

// Re-Finalizes all node types. This can be run after code was modified in
// various ways that require propagating types around, and it does such an
// "incremental" update. This is done under the assumption that there is
// a valid assignment of types to apply.
// This removes "unnecessary' block/if/loop types, i.e., that are added
// specifically, as in
//  (block (result i32) (unreachable))
// vs
//  (block (unreachable))
// This converts to the latter form.
// This also removes un-taken branches that would be a problem for
// refinalization: if a block has been marked unreachable, and has
// branches to it with values of type unreachable, then we don't
// know the type for the block: it can't be none since the breaks
// exist, but the breaks don't declare the type, rather everything
// depends on the block. To avoid looking at the parent or something
// else, just remove such un-taken branches.
struct ReFinalize
  : public WalkerPass<PostWalker<ReFinalize, OverriddenVisitor<ReFinalize>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new ReFinalize; }

  ReFinalize() { name = "refinalize"; }

  // block finalization is O(bad) if we do each block by itself, so do it in
  // bulk, tracking break value types so we just do a linear pass

  std::map<Name, Type> breakValues;

  void visitBlock(Block* curr);
  void visitIf(If* curr);
  void visitLoop(Loop* curr);
  void visitBreak(Break* curr);
  void visitSwitch(Switch* curr);
  void visitCall(Call* curr);
  void visitCallIndirect(CallIndirect* curr);
  void visitGetLocal(GetLocal* curr);
  void visitSetLocal(SetLocal* curr);
  void visitGetGlobal(GetGlobal* curr);
  void visitSetGlobal(SetGlobal* curr);
  void visitLoad(Load* curr);
  void visitStore(Store* curr);
  void visitAtomicRMW(AtomicRMW* curr);
  void visitAtomicCmpxchg(AtomicCmpxchg* curr);
  void visitAtomicWait(AtomicWait* curr);
  void visitAtomicNotify(AtomicNotify* curr);
  void visitSIMDExtract(SIMDExtract* curr);
  void visitSIMDReplace(SIMDReplace* curr);
  void visitSIMDShuffle(SIMDShuffle* curr);
  void visitSIMDBitselect(SIMDBitselect* curr);
  void visitSIMDShift(SIMDShift* curr);
  void visitMemoryInit(MemoryInit* curr);
  void visitDataDrop(DataDrop* curr);
  void visitMemoryCopy(MemoryCopy* curr);
  void visitMemoryFill(MemoryFill* curr);
  void visitConst(Const* curr);
  void visitUnary(Unary* curr);
  void visitBinary(Binary* curr);
  void visitSelect(Select* curr);
  void visitDrop(Drop* curr);
  void visitReturn(Return* curr);
  void visitHost(Host* curr);
  void visitNop(Nop* curr);
  void visitUnreachable(Unreachable* curr);

  void visitFunction(Function* curr);

  void visitFunctionType(FunctionType* curr);
  void visitExport(Export* curr);
  void visitGlobal(Global* curr);
  void visitTable(Table* curr);
  void visitMemory(Memory* curr);
  void visitModule(Module* curr);

private:
  void updateBreakValueType(Name name, Type type);

  // Replace an untaken branch/switch with an unreachable value.
  // A condition may also exist and may or may not be unreachable.
  void replaceUntaken(Expression* value, Expression* condition);
};

// Re-finalize a single node. This is slow, if you want to refinalize
// an entire ast, use ReFinalize
struct ReFinalizeNode : public OverriddenVisitor<ReFinalizeNode> {
  void visitBlock(Block* curr) { curr->finalize(); }
  void visitIf(If* curr) { curr->finalize(); }
  void visitLoop(Loop* curr) { curr->finalize(); }
  void visitBreak(Break* curr) { curr->finalize(); }
  void visitSwitch(Switch* curr) { curr->finalize(); }
  void visitCall(Call* curr) { curr->finalize(); }
  void visitCallIndirect(CallIndirect* curr) { curr->finalize(); }
  void visitGetLocal(GetLocal* curr) { curr->finalize(); }
  void visitSetLocal(SetLocal* curr) { curr->finalize(); }
  void visitGetGlobal(GetGlobal* curr) { curr->finalize(); }
  void visitSetGlobal(SetGlobal* curr) { curr->finalize(); }
  void visitLoad(Load* curr) { curr->finalize(); }
  void visitStore(Store* curr) { curr->finalize(); }
  void visitAtomicRMW(AtomicRMW* curr) { curr->finalize(); }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) { curr->finalize(); }
  void visitAtomicWait(AtomicWait* curr) { curr->finalize(); }
  void visitAtomicNotify(AtomicNotify* curr) { curr->finalize(); }
  void visitSIMDExtract(SIMDExtract* curr) { curr->finalize(); }
  void visitSIMDReplace(SIMDReplace* curr) { curr->finalize(); }
  void visitSIMDShuffle(SIMDShuffle* curr) { curr->finalize(); }
  void visitSIMDBitselect(SIMDBitselect* curr) { curr->finalize(); }
  void visitSIMDShift(SIMDShift* curr) { curr->finalize(); }
  void visitMemoryInit(MemoryInit* curr) { curr->finalize(); }
  void visitDataDrop(DataDrop* curr) { curr->finalize(); }
  void visitMemoryCopy(MemoryCopy* curr) { curr->finalize(); }
  void visitMemoryFill(MemoryFill* curr) { curr->finalize(); }
  void visitConst(Const* curr) { curr->finalize(); }
  void visitUnary(Unary* curr) { curr->finalize(); }
  void visitBinary(Binary* curr) { curr->finalize(); }
  void visitSelect(Select* curr) { curr->finalize(); }
  void visitDrop(Drop* curr) { curr->finalize(); }
  void visitReturn(Return* curr) { curr->finalize(); }
  void visitHost(Host* curr) { curr->finalize(); }
  void visitNop(Nop* curr) { curr->finalize(); }
  void visitUnreachable(Unreachable* curr) { curr->finalize(); }

  void visitFunctionType(FunctionType* curr) { WASM_UNREACHABLE(); }
  void visitExport(Export* curr) { WASM_UNREACHABLE(); }
  void visitGlobal(Global* curr) { WASM_UNREACHABLE(); }
  void visitTable(Table* curr) { WASM_UNREACHABLE(); }
  void visitMemory(Memory* curr) { WASM_UNREACHABLE(); }
  void visitModule(Module* curr) { WASM_UNREACHABLE(); }

  // given a stack of nested expressions, update them all from child to parent
  static void updateStack(ExpressionStack& expressionStack) {
    for (int i = int(expressionStack.size()) - 1; i >= 0; i--) {
      auto* curr = expressionStack[i];
      ReFinalizeNode().visit(curr);
    }
  }
};

// Adds drop() operations where necessary. This lets you not worry about adding
// drop when generating code. This also refinalizes before and after, as
// dropping can change types, and depends on types being cleaned up - no
// unnecessary block/if/loop types (see refinalize)
// TODO: optimize that, interleave them
struct AutoDrop : public WalkerPass<ExpressionStackWalker<AutoDrop>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new AutoDrop; }

  AutoDrop() { name = "autodrop"; }

  bool maybeDrop(Expression*& child) {
    bool acted = false;
    if (isConcreteType(child->type)) {
      expressionStack.push_back(child);
      if (!ExpressionAnalyzer::isResultUsed(expressionStack, getFunction()) &&
          !ExpressionAnalyzer::isResultDropped(expressionStack)) {
        child = Builder(*getModule()).makeDrop(child);
        acted = true;
      }
      expressionStack.pop_back();
    }
    return acted;
  }

  void reFinalize() { ReFinalizeNode::updateStack(expressionStack); }

  void visitBlock(Block* curr) {
    if (curr->list.size() == 0) {
      return;
    }
    for (Index i = 0; i < curr->list.size() - 1; i++) {
      auto* child = curr->list[i];
      if (isConcreteType(child->type)) {
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
    if (maybeDrop(curr->ifTrue)) {
      acted = true;
    }
    if (curr->ifFalse) {
      if (maybeDrop(curr->ifFalse)) {
        acted = true;
      }
    }
    if (acted) {
      reFinalize();
      assert(curr->type == none);
    }
  }

  void doWalkFunction(Function* curr) {
    ReFinalize().walkFunctionInModule(curr, getModule());
    walk(curr->body);
    if (curr->result == none && isConcreteType(curr->body->type)) {
      curr->body = Builder(*getModule()).makeDrop(curr->body);
    }
    ReFinalize().walkFunctionInModule(curr, getModule());
  }
};

struct I64Utilities {
  static Expression*
  recreateI64(Builder& builder, Expression* low, Expression* high) {
    return builder.makeBinary(
      OrInt64,
      builder.makeUnary(ExtendUInt32, low),
      builder.makeBinary(ShlInt64,
                         builder.makeUnary(ExtendUInt32, high),
                         builder.makeConst(Literal(int64_t(32)))));
  };

  static Expression* recreateI64(Builder& builder, Index low, Index high) {
    return recreateI64(
      builder, builder.makeGetLocal(low, i32), builder.makeGetLocal(high, i32));
  };

  static Expression* getI64High(Builder& builder, Index index) {
    return builder.makeUnary(
      WrapInt64,
      builder.makeBinary(ShrUInt64,
                         builder.makeGetLocal(index, i64),
                         builder.makeConst(Literal(int64_t(32)))));
  }

  static Expression* getI64Low(Builder& builder, Index index) {
    return builder.makeUnary(WrapInt64, builder.makeGetLocal(index, i64));
  }
};

} // namespace wasm

#endif // wasm_ir_utils_h
