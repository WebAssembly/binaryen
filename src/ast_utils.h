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

// Finds if there are breaks targeting a name. Note that since names are
// unique in our IR, we just need to look for the name, and do not need
// to analyze scoping.
struct BreakSeeker : public PostWalker<BreakSeeker> {
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
    // ignore an unreachable break
    if (curr->condition && curr->condition->type == unreachable) return;
    if (curr->value && curr->value->type == unreachable) return;
    // check the break
    if (curr->name == target) noteFound(curr->value);
  }

  void visitSwitch(Switch *curr) {
    // ignore an unreachable switch
    if (curr->condition->type == unreachable) return;
    if (curr->value && curr->value->type == unreachable) return;
    // check the switch
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

struct EffectAnalyzer : public PostWalker<EffectAnalyzer> {
  EffectAnalyzer(PassOptions& passOptions, Expression *ast = nullptr) {
    ignoreImplicitTraps = passOptions.ignoreImplicitTraps;
    debugInfo = passOptions.debugInfo;
    if (ast) analyze(ast);
  }

  bool ignoreImplicitTraps;
  bool debugInfo;

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
  bool implicitTrap = false; // a load or div/rem, which may trap. we ignore trap
                             // differences, so it is ok to reorder these, and we
                             // also allow reordering them with other effects
                             // (so a trap may occur later or earlier, if it is
                             // going to occur anyhow), but we can't remove them,
                             // they count as side effects

  bool accessesLocal() { return localsRead.size() + localsWritten.size() > 0; }
  bool accessesGlobal() { return globalsRead.size() + globalsWritten.size() > 0; }
  bool accessesMemory() { return calls || readsMemory || writesMemory; }
  bool hasSideEffects() { return calls || localsWritten.size() > 0 || writesMemory || branches || globalsWritten.size() > 0 || implicitTrap; }
  bool hasAnything() { return branches || calls || accessesLocal() || readsMemory || writesMemory || accessesGlobal() || implicitTrap; }

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
    // we are ok to reorder implicit traps, but not conditionalize them
    if ((implicitTrap && other.branches) || (other.implicitTrap && branches)) {
      return true;
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
  void visitCallImport(CallImport *curr) {
    calls = true;
    if (debugInfo) {
      // debugInfo call imports must be preserved very strongly, do not
      // move code around them
      branches = true; // !
    }
  }
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
  void visitLoad(Load *curr) {
    readsMemory = true;
    if (!ignoreImplicitTraps) implicitTrap = true;
  }
  void visitStore(Store *curr) {
    writesMemory = true;
    if (!ignoreImplicitTraps) implicitTrap = true;
  }
  void visitUnary(Unary *curr) {
    if (!ignoreImplicitTraps) {
      switch (curr->op) {
        case TruncSFloat32ToInt32:
        case TruncSFloat32ToInt64:
        case TruncUFloat32ToInt32:
        case TruncUFloat32ToInt64:
        case TruncSFloat64ToInt32:
        case TruncSFloat64ToInt64:
        case TruncUFloat64ToInt32:
        case TruncUFloat64ToInt64: {
          implicitTrap = true;
        }
        default: {}
      }
    }
  }
  void visitBinary(Binary *curr) {
    if (!ignoreImplicitTraps) {
      switch (curr->op) {
        case DivSInt32:
        case DivUInt32:
        case RemSInt32:
        case RemUInt32:
        case DivSInt64:
        case DivUInt64:
        case RemSInt64:
        case RemUInt64: {
          implicitTrap = true;
        }
        default: {}
      }
    }
  }
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
//  (block i32 (unreachable))
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
    // do this quickly, without any validation
    if (curr->name.is()) {
      auto iter = breakValues.find(curr->name);
      if (iter != breakValues.end()) {
        // there is a break to here
        curr->type = iter->second;
        return;
      }
    }
    // nothing branches here
    if (curr->list.size() > 0) {
      // if we have an unreachable child, we are unreachable
      // (we don't need to recurse into children, they can't
      // break to us)
      for (auto* child : curr->list) {
        if (child->type == unreachable) {
          curr->type = unreachable;
          return;
        }
      }
      // children are reachable, so last element determines type
      curr->type = curr->list.back()->type;
    } else {
      curr->type = none;
    }
  }
  void visitIf(If *curr) { curr->finalize(); }
  void visitLoop(Loop *curr) { curr->finalize(); }
  void visitBreak(Break *curr) {
    curr->finalize();
    if (BranchUtils::isBranchTaken(curr)) {
      breakValues[curr->name] = getValueType(curr->value);
    }
  }
  void visitSwitch(Switch *curr) {
    curr->finalize();
    if (BranchUtils::isBranchTaken(curr)) {
      auto valueType = getValueType(curr->value);
      for (auto target : curr->targets) {
        breakValues[target] = valueType;
      }
      breakValues[curr->default_] = valueType;
    }
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
  void visitConst(Const *curr) { curr->finalize(); }
  void visitUnary(Unary *curr) { curr->finalize(); }
  void visitBinary(Binary *curr) { curr->finalize(); }
  void visitSelect(Select *curr) { curr->finalize(); }
  void visitDrop(Drop *curr) { curr->finalize(); }
  void visitReturn(Return *curr) { curr->finalize(); }
  void visitHost(Host *curr) { curr->finalize(); }
  void visitNop(Nop *curr) { curr->finalize(); }
  void visitUnreachable(Unreachable *curr) { curr->finalize(); }

  WasmType getValueType(Expression* value) {
    return value && value->type != unreachable ? value->type : none;
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
