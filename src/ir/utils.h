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

  // Measure the number of expressions.
  static Index measure(Expression* tree) {
    Measurer measurer;
    measurer.walk(tree);
    return measurer.size;
  }

  // A rough estimate of average binary size per expression. The number here is
  // based on measurements on real-world (MVP) wasm files, on which observed
  // ratios were 2.2 - 2.8.
  static constexpr double BytesPerExpr = 2.5;
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

  // Returns true if the expression is handled by the hasher.
  using ExprHasher = std::function<bool(Expression*, size_t&)>;
  static bool nothingHasher(Expression*, size_t&) { return false; }

  static size_t flexibleHash(Expression* curr, ExprHasher hasher);

  // hash an expression, ignoring superficial details like specific internal
  // names
  static size_t hash(Expression* curr) {
    return flexibleHash(curr, nothingHasher);
  }

  // hash an expression, ignoring child nodes.
  static size_t shallowHash(Expression* curr);
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

  // Re-running finalize() does not change the types of locals, so validation is
  // preserved.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<ReFinalize>();
  }

  ReFinalize() { name = "refinalize"; }

  // block finalization is O(bad) if we do each block by itself, so do it in
  // bulk, tracking break value types so we just do a linear pass.
  std::unordered_map<Name, std::unordered_set<Type>> breakTypes;

#define DELEGATE(CLASS_TO_VISIT)                                               \
  void visit##CLASS_TO_VISIT(CLASS_TO_VISIT* curr);

#include "wasm-delegations.def"

  void visitExport(Export* curr);
  void visitGlobal(Global* curr);
  void visitTable(Table* curr);
  void visitElementSegment(ElementSegment* curr);
  void visitMemory(Memory* curr);
  void visitDataSegment(DataSegment* curr);
  void visitTag(Tag* curr);
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
#define DELEGATE(CLASS_TO_VISIT)                                               \
  void visit##CLASS_TO_VISIT(CLASS_TO_VISIT* curr) { curr->finalize(); }

#include "wasm-delegations.def"

  void visitExport(Export* curr) { WASM_UNREACHABLE("unimp"); }
  void visitGlobal(Global* curr) { WASM_UNREACHABLE("unimp"); }
  void visitTable(Table* curr) { WASM_UNREACHABLE("unimp"); }
  void visitElementSegment(ElementSegment* curr) { WASM_UNREACHABLE("unimp"); }
  void visitMemory(Memory* curr) { WASM_UNREACHABLE("unimp"); }
  void visitDataSegment(DataSegment* curr) { WASM_UNREACHABLE("unimp"); }
  void visitTag(Tag* curr) { WASM_UNREACHABLE("unimp"); }
  void visitModule(Module* curr) { WASM_UNREACHABLE("unimp"); }

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

  std::unique_ptr<Pass> create() override {
    return std::make_unique<AutoDrop>();
  }

  AutoDrop() { name = "autodrop"; }

  bool maybeDrop(Expression*& child) {
    bool acted = false;
    if (child->type.isConcrete()) {
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
      if (child->type.isConcrete()) {
        curr->list[i] = Builder(*getModule()).makeDrop(child);
      }
    }
    if (maybeDrop(curr->list.back())) {
      reFinalize();
      assert(curr->type == Type::none || curr->type == Type::unreachable);
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
      assert(curr->type == Type::none);
    }
  }

  void visitTry(Try* curr) {
    bool acted = false;
    if (maybeDrop(curr->body)) {
      acted = true;
    }
    for (auto* catchBody : curr->catchBodies) {
      if (maybeDrop(catchBody)) {
        acted = true;
      }
    }
    if (acted) {
      reFinalize();
      assert(curr->type == Type::none);
    }
  }

  void doWalkFunction(Function* curr) {
    ReFinalize().walkFunctionInModule(curr, getModule());
    walk(curr->body);
    if (curr->getResults() == Type::none && curr->body->type.isConcrete()) {
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
                         builder.makeConst(int64_t(32))));
  };

  static Expression* recreateI64(Builder& builder, Index low, Index high) {
    return recreateI64(builder,
                       builder.makeLocalGet(low, Type::i32),
                       builder.makeLocalGet(high, Type::i32));
  };

  static Expression* getI64High(Builder& builder, Index index) {
    return builder.makeUnary(
      WrapInt64,
      builder.makeBinary(ShrUInt64,
                         builder.makeLocalGet(index, Type::i64),
                         builder.makeConst(int64_t(32))));
  }

  static Expression* getI64Low(Builder& builder, Index index) {
    return builder.makeUnary(WrapInt64, builder.makeLocalGet(index, Type::i64));
  }
};

} // namespace wasm

#endif // wasm_ir_utils_h
