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
// Formally, this pass flattens control flow in the precise sense of
// making the AST have these properties:
//
//  1. Control flow structures (block, loop, if) and control flow
//     operations (br, br_if, br_table, return, unreachable) may
//     only be block children, a loop body, or an if-true or if-false.
//     (I.e., they cannot be nested inside an i32.add, a drop, a
//     call, an if-condition, etc.)
//  2. Disallow block, loop, and if return values, i.e., do not use
//     control flow to pass around values.
//
// Note that we do still allow normal arbitrary nesting of expressions
// *without* control flow (i.e., this is not a reduction to 3-address
// code form). We also allow nesting of control flow, but just nested
// in other control flow, like an if in the true arm of an if, and
// so forth. What we achieve here is that when you see an expression,
// you know it has no control flow inside it, it will be fully
// executed.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>


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
    if (func->result != none) {
      // if the body had a fallthrough, receive it and return it
      auto iter = breakExprIndexes.find(func->body);
      if (iter != breakExprIndexes.end()) {
        func->body = builder->makeSequence(
          func->body,
          builder->makeReturn(
            builder->makeGetLocal(iter->second, func->result)
          )
        );
      }
    }
  }

  // returns the index to assign values to for a break target. allocates
  // the local if this is the first time we see it.
  // expr is used if this is a flowing value.
  Index getBreakTargetIndex(Name name, WasmType type, Expression* expr = nullptr, Index index = -1) {
    assert(isConcreteWasmType(type)); // we shouldn't get here if the value ins't actually set
    if (name.is()) {
      auto iter = breakNameIndexes.find(name);
      if (iter == breakNameIndexes.end()) {
        if (index == Index(-1)) {
          index = builder->addVar(getFunction(), type);
        }
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
        if (index == Index(-1)) {
          index = builder->addVar(getFunction(), type);
        }
        return breakExprIndexes[expr] = index;
      }
      return iter->second;
    }
  }

  // When we reach a fallthrough value, it has already been flattened, and its value
  // assigned to the proper local. Or, it may not have needed to be flattened,
  // and we can just assign to a local. This method simply returns the fallthrough
  // replacement code.
  Expression* getFallthroughReplacement(Expression* child, Index myIndex) {
    auto iter = breakExprIndexes.find(child);
    if (iter != breakExprIndexes.end()) {
      // it was flattened and saved to a local
      return builder->makeSequence(
        child, // which no longer flows a value, now it sets the child index
        builder->makeSetLocal(
          myIndex,
          builder->makeGetLocal(iter->second, getFunction()->getLocalType(iter->second))
        )
      );
    }
    // a simple expression
    if (child->type == unreachable) {
      // no need to even set the local
      return child;
    } else {
      assert(!ControlFlowChecker::is(child));
      return builder->makeSetLocal(
        myIndex,
        child
      );
    }
  }

  // flattening fallthroughs makes them have type none. this gets their true type
  WasmType getFallthroughType(Expression* child) {
    auto iter = breakExprIndexes.find(child);
    if (iter != breakExprIndexes.end()) {
      // it was flattened and saved to a local
      return getFunction()->getLocalType(iter->second);
    }
    assert(child->type != none);
    return child->type;
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
          block->list.push_back(builder->makeSetLocal(tempIndexes[i], child));
          *children[i] = builder->makeGetLocal(tempIndexes[i], type);
        } else if (type == none) {
          // a nested none can not happen normally, here it occurs after we flattened a nested
          // we can use the local it already assigned to. TODO: don't even allocate one here
          block->list.push_back(child);
          assert(parent.breakExprIndexes.count(child) > 0);
          auto index = parent.breakExprIndexes[child];
          *children[i] = builder->makeGetLocal(
            index,
            parent.getFunction()->getLocalType(index)
          );
        } else if (type == unreachable) {
          block->list.push_back(child);
          break; // no need to push any more
        } else {
          WASM_UNREACHABLE();
        }
      }
      if (!hasUnreachableChild) {
        // we reached the end, so we need to emit the expression itself
        // (which has been modified to replace children usages with get_locals)
        block->list.push_back(node);
      }
      block->finalize();
      // finally, we just created a new block, ending in node. If node is e.g.
      // i32.add, then our block would return a value. so we must convert
      // this new block to return a value through a local
      parent.visitBlock(block);
      // the block is now done
      parent.replaceCurrent(block);
      // if the node was potentially a flowthrough value, then it has an entry
      // in breakExprIndexes, and since we are replacing it with this block,
      // we must note it's index as the same, so it is found by the parent.
      if (parent.breakExprIndexes.find(node) != parent.breakExprIndexes.end()) {
        parent.breakExprIndexes[block] = parent.breakExprIndexes[node];
      }
    }
  };

  void visitBlock(Block* curr) {
    if (isConcreteWasmType(curr->type)) {
      curr->list.back() = getFallthroughReplacement(curr->list.back(), getBreakTargetIndex(curr->name, curr->type, curr));
      curr->finalize();
    }
  }
  void visitLoop(Loop* curr) {
    if (isConcreteWasmType(curr->type)) {
      curr->body = getFallthroughReplacement(curr->body, getBreakTargetIndex(Name(), curr->type, curr));
      curr->finalize();
    }
  }
  void visitIf(If* curr) {
    if (isConcreteWasmType(curr->type)) {
      auto targetIndex = getBreakTargetIndex(Name(), curr->type, curr);
      curr->ifTrue = getFallthroughReplacement(curr->ifTrue, targetIndex);
      curr->ifFalse = getFallthroughReplacement(curr->ifFalse, targetIndex);
      curr->finalize();
    }
    Splitter splitter(*this, curr);
    splitter.note(curr->condition);
  }
  void visitBreak(Break* curr) {
    Expression* processed = curr;
    // first of all, get rid of the value if there is one
    if (curr->value) {
      if (curr->value->type != unreachable) {
        auto type = getFallthroughType(curr->value);
        auto index = getBreakTargetIndex(curr->name, type);
        auto* value = getFallthroughReplacement(curr->value, index);
        curr->value = nullptr;
        curr->finalize();
        processed = builder->makeSequence(
          value,
          curr
        );
        replaceCurrent(processed);
        if (curr->condition) {
          // we already called getBreakTargetIndex for the value we send to our
          // break target if we break. as this is a br_if with a value, it also
          // flows out that value, so our parent needs to know how to receive it.
          // we note the already-existing index we prepared before, for that value.
          getBreakTargetIndex(Name(), type, processed, index);
        }
      } else {
        // we have a value, but it has unreachable type. we can just replace
        // ourselves with it, we won't reach a condition (if there is one) or the br
        // itself
        replaceCurrent(curr->value);
        return;
      }
    }
    Splitter splitter(*this, processed);
    splitter.note(curr->condition);
  }
  void visitSwitch(Switch* curr) {
    Expression* processed = curr;

    // first of all, get rid of the value if there is one
    if (curr->value) {
      if (curr->value->type != unreachable) {
        auto type = getFallthroughType(curr->value);
        // we must assign the value to *all* the targets
        auto temp = builder->addVar(getFunction(), type);
        auto* value = getFallthroughReplacement(curr->value, temp);
        curr->value = nullptr;
        auto* block = builder->makeBlock();
        block->list.push_back(value);
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
        replaceCurrent(block);
      } else {
        // we have a value, but it has unreachable type. we can just replace
        // ourselves with it, we won't reach a condition (if there is one) or the br
        // itself
        replaceCurrent(curr->value);
        return;
      }
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

