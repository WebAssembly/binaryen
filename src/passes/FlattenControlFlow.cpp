/*
 * Copyright 2017 WebAssembly Community Group participants
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

//
// Flattens control flow, e.g.
//
//  (i32.add
//    (if (..condition..)
//      (..if true..)
//      (..if false..)
//    )
//    (i32.const 1)
//  )
// =>
//  (if (..condition..)
//    (set_local $temp
//      (..if true..)
//    )
//    (set_local $temp
//      (..if false..)
//    )
//  )
//  (i32.add
//    (get_local $temp)
//    (i32.const 1)
//  )
//
// The properties we work to achieve are
//  1. leave control flow structures and control flow operations
//     to only show up as a block element, if true or if false, loop
//     body, or function body, and nowhere else (i.e. not nested in an
//     i32.add, drop, etc., nor in an if condition)
//  2. avoid fallthrough values, i.e., do not use control flow to
//     pass values automatically, which means no block, loop and if
//     values (instead, use a local)
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>

                                                                              #include "wasm-printing.h"
      // TODO: when we add a set)_local, flatten inside it

namespace wasm {

// Looks for control flow changes and structures, excluding blocks (as we
// want to put all control flow on them)
struct ControlFlowChecker : public Visitor<ControlFlowChecker> {
  static bool is(Expression* node) {
    ControlFlowChecker finder;
    finder.visit(node);
    return finder.hasControlFlow;
  }

  bool hasControlFlow = false;

  void visitBreak(Break *curr) { hasControlFlow = true; }
  void visitSwitch(Switch *curr) { hasControlFlow = true; }
  void visitBlock(Block *curr) { hasControlFlow = true; }
  void visitLoop(Loop* curr) { hasControlFlow = true; }
  void visitIf(If* curr) { hasControlFlow = true; }
  void visitReturn(Return *curr) { hasControlFlow = true; }
  void visitUnreachable(Unreachable *curr) { hasControlFlow = true; }
};

struct FlattenControlFlow : public WalkerPass<PostWalker<FlattenControlFlow>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FlattenControlFlow; }

  std::unique_ptr<Builder> builder;
  // we get rid of block/if/loop values. this map tells us for
  // each break target what local index to use.
  // if this is a flowing value, there might not be a name assigned
  // (block ending, block with no name; or if value), so we use
  // the expr (and there will be exactly one set and get of it,
  // so we don't need a name)
  std::map<Name, Index> breakNameIndexes;
  std::map<Expression*, Index> breakExprIndexes;

  void doWalkFunction(Function* func) {
    builder = make_unique<Builder>(*getModule());
    walk(func->body);
  }

  // returns the index to assign values to for a break target. allocates
  // the local if this is the first time we see it.
  // expr is used if this is a flowing value.
  Index getBreakTargetIndex(Name name, WasmType type, Expression* expr = nullptr) {
    assert(type != unreachable); // we shouldn't get here if the value ins't actually set
    if (name.is()) {
      auto iter = breakNameIndexes.find(name);
      if (iter == breakNameIndexes.end()) {
        auto index = builder->addVar(getFunction(), type);
        breakNameIndexes[name] = index;
        if (expr) {
          breakExprIndexes[expr] = index;
        }
        return index;
      }
      if (expr) {
        breakExprIndexes[expr] = iter->second;
      }
      return iter->second;
    } else {
      assert(expr);
      auto iter = breakExprIndexes.find(expr);
      if (iter == breakExprIndexes.end()) {
        return breakExprIndexes[expr] = builder->addVar(getFunction(), type);
      }
      return iter->second;
    }
  }

  // When we reach a fallthrough value, it has already been flattened, and its value
  // assigned to the proper local. Or, it may not have needed to be flattened,
  // and we can just assign to a local. This method simply returns the fallthrough
  // replacement code.
  Expression* getFallthroughReplacement(Expression* child, Index myIndex, WasmType type) {
    auto iter = breakExprIndexes.find(child);
    if (iter != breakExprIndexes.end()) {
      // it was flattened and saved to a local
      return builder->makeSequence(
        child, // which no longer flows a value, now it sets the child index
        builder->makeSetLocal(
          myIndex,
          builder->makeGetLocal(iter->second, type)
        )
      );
    }
    // a simple expression
    return builder->makeSetLocal(
      myIndex,
      child
    );
  }

  // Splitter helper
  struct Splitter {
    Splitter(FlattenControlFlow& parent, Expression* node) : parent(parent), node(node) {}

    ~Splitter() {
      finish();
    }

    FlattenControlFlow& parent;
    Expression* node;

    std::vector<Expression**> children; // TODO: reuse in parent, avoiding mallocing on each node

    void note(Expression*& child) {
      // we accept nullptr inputs, for a non-existing child
      if (!child) return;
      children.push_back(&child);
    }

    Expression* replacement; // the final replacement for the current node
    bool stop = false; // if a child is unreachable, we can stop

    void finish() {
      if (children.empty()) return;
      // first, scan the list
      bool hasControlFlowChild = false;
      bool hasUnreachableChild = false;
      for (auto** childp : children) {
        // it's enough to look at the child, ignoring the contents, as the contents
        // have already been processed before we got here, so they must have been
        // flattened if necessary.
        auto* child = *childp;
        if (ControlFlowChecker::is(child)) {
          hasControlFlowChild = true;
        }
        if (child->type == unreachable) {
          hasUnreachableChild = true;
        }
      }
      if (!hasControlFlowChild) {
        // nothing to do here.
        assert(!hasUnreachableChild); // all of them should be executed
        return;
      }
      // we have at least one child we need to split out, so to preserve the order of operations,
      // split them all out
      Builder* builder = parent.builder.get();
      std::vector<Index> tempIndexes;
      for (auto** childp : children) {
        auto* child = *childp;
        if (isConcreteWasmType(child->type)) {
          tempIndexes.push_back(builder->addVar(parent.getFunction(), child->type));
        } else {
          tempIndexes.push_back(-1);
        }
      }
      // create a new replacement block
      auto* block = builder->makeBlock();
      for (Index i = 0; i < children.size(); i++) {
        auto* child = *children[i];
        auto type = child->type;
        if (isConcreteWasmType(type)) {
          // set the child to a local, and use it later
          block->list.push_back(child);
          *children[i] = builder->makeGetLocal(tempIndexes[i], type);
        } else {
          assert(type == unreachable); // can't be none, it's nested
          block->list.push_back(child); // note no need to flatten, we are not adding a set_local
          break; // no need to push any more
        }
      }
      if (!hasUnreachableChild) {
        // we reached the end, so we need to emit the expression itself
        // (which has been modified to replace children usages with get_locals)
        block->list.push_back(node);
      }
      block->finalize();
      parent.replaceCurrent(block);
    }
  };

  void visitBlock(Block* curr) {
    if (isConcreteWasmType(curr->type)) {
      curr->list.back() = getFallthroughReplacement(curr->list.back(), getBreakTargetIndex(curr->name, curr->type, curr), curr->type);
      curr->finalize(none);
    }
  }
  void visitLoop(Loop* curr) {
    if (isConcreteWasmType(curr->type)) {
      curr->body = getFallthroughReplacement(curr->body, getBreakTargetIndex(Name(), curr->type, curr), curr->type);
      curr->finalize(none);
    }
  }
  void visitIf(If* curr) {
    if (isConcreteWasmType(curr->type)) {
      auto targetIndex = getBreakTargetIndex(Name(), curr->type, curr);
      curr->ifTrue = getFallthroughReplacement(curr->ifTrue, targetIndex, curr->type);
      curr->ifFalse = getFallthroughReplacement(curr->ifFalse, targetIndex, curr->type);
      curr->finalize(none);
    }
    Splitter splitter(*this, curr);
    splitter.note(curr->condition);
  }
  void visitBreak(Break* curr) {
    Expression* processed = curr;
    // first of all, get rid of the value if there is one
    if (curr->value && curr->value->type != unreachable) {
      processed = builder->makeSequence(
        builder->makeSetLocal(
          getBreakTargetIndex(curr->name, curr->value->type),
          curr->value
        ),
        curr
      );
      if (curr->condition) {
        processed = builder->makeSequence(
          processed,
          builder->makeGetLocal(
            getBreakTargetIndex(curr->name, curr->value->type),
            curr->value->type
          )
        );
      }
      curr->value = nullptr;
      replaceCurrent(processed);
    }
    // TODO: force-split this if it's a br-if, we don't allow them
    Splitter splitter(*this, processed);
    splitter.note(curr->value);
    splitter.note(curr->condition);
  }
  void visitSwitch(Switch* curr) {
    Expression* processed = curr;
    // first of all, get rid of the value if there is one
    if (curr->value && curr->value->type != unreachable) {
      auto type = curr->value->type;
      // we must assign the value to *all* the targets
      auto temp = builder->addVar(getFunction(), type);
      auto* block = builder->makeBlock();
      block->list.push_back(builder->makeSetLocal(temp, curr->value));
      std::set<Name> names;
      for (auto target : curr->targets) {
        if (names.insert(target).second) {
          block->list.push_back(
            builder->makeSetLocal(
              getBreakTargetIndex(target, type),
              builder->makeGetLocal(temp, type)
            )
          );
        }
      }
      if (names.insert(curr->default_).second) {
        block->list.push_back(
          builder->makeSetLocal(
            getBreakTargetIndex(curr->default_, type),
            builder->makeGetLocal(temp, type)
          )
        );
      }
      block->list.push_back(curr);
      block->finalize();
      curr->value = nullptr;
      replaceCurrent(block);
    }
    Splitter splitter(*this, processed);
    splitter.note(curr->value);
    splitter.note(curr->condition);
  }
  void visitCall(Call* curr) {
    Splitter splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }
  void visitCallImport(CallImport* curr) {
    Splitter splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }
  void visitCallIndirect(CallIndirect* curr) {
    Splitter splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
    splitter.note(curr->target);
  }
  void visitSetLocal(SetLocal* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitSetGlobal(SetGlobal* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitLoad(Load* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->ptr);
  }
  void visitStore(Store* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->ptr);
    splitter.note(curr->value);
  }
  void visitUnary(Unary* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitBinary(Binary* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->left);
    splitter.note(curr->right);
  }
  void visitSelect(Select* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->ifTrue);
    splitter.note(curr->ifFalse);
    splitter.note(curr->condition);
  }
  void visitDrop(Drop* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitReturn(Return* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->value);
  }
  void visitHost(Host* curr) {
    Splitter splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }
};

Pass *createFlattenControlFlowPass() {
  return new FlattenControlFlow();
}

} // namespace wasm

