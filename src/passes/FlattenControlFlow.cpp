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
// This leaves control flow to only show up as a block element,
// and not nested inside other code. Blocks themselves are allowed
// only on other blocks, or as the body of a function, loop, or arm
// of an if. We disallow br_if entirely (as it returns a value, i.e.,
// inherently has nested control flow).
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
  void visitLoop(Loop* curr) { hasControlFlow = true; }
  void visitIf(If* curr) { hasControlFlow = true; }
  void visitReturn(Return *curr) { hasControlFlow = true; }
  void visitUnreachable(Unreachable *curr) { hasControlFlow = true; }
};

// Replaces breaks with a value to a target with assigns to a local
// then a break without a value
struct BreakValueUpdater : public PostWalker<BreakValueUpdater> {
  static void update(Expression* ast, Name name, Index index, Module* wasm) {
    BreakValueUpdater finder;
    finder.name = name;
    finder.index = index;
    finder.setModule(wasm);
    finder.walk(ast);
  }

  Name name;
  Index index;

  void visitBreak(Break *curr) {
    if (curr->name == name) {
      assert(!curr->condition); // br_ifs must already have been removed
      assert(curr->value);
      Builder builder(*getModule());
      replaceCurrent(
        builder.makeSequence(
          builder.makeSetLocal(index, curr->value),
          curr
        )
      );
      curr->value = nullptr;
    }
  }
};

struct FlattenControlFlow : public WalkerPass<PostWalker<FlattenControlFlow>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new FlattenControlFlow; }

  std::unique_ptr<Builder> builder;

  void doWalkFunction(Function* func) {
    builder = make_unique<Builder>(*getModule());
    // ensure the top level is a block
    func->body = builder->blockify(func->body);
    walk(func->body);
  }

  // Splitter helper
  struct Splitter {
    Splitter(FlattenControlFlow& parent, Expression* node) : parent(parent), node(node), replacement(curr) {}

    ~Splitter() {
      // finish up

    }

    FlattenControlFlow& parent;
    Expression* node;

    std::vector<Expression*> mustEmit; // all nodes we must emit, even if we don't emit node
    Expression* replacement; // the final replacement for the current node
    bool stop = false; // if a child is unreachable, we can stop

    // note a child. if it has control flow, we must split it out
    void note(Expression*& child) {
      // we accept nullptr inputs, for a non-existing child
      if (!child) return;
      // if a previous child was unreachable, stop
      if (stop) return;
      // it's enough to look at the child, ignoring the contents, as the contents
      // have already been processed before we got here, so they must have been
      // flattened if necessary.
      if (!ControlFlowChecker::is(child)) {
        // nothing to do here, no control flow to split out
        mustEmit.push_back(child);
        return;
      }
      // if the child has a concrete type, we need a temp var
      auto* builder = parent->builder;
      if (isConcreteWasmType(child->type)) {
          // the child node is control flow, a structure or a flow-causer. if
        // it has a concrete type, it must be a block, loop, if, or br_if with value
        auto temp = builder->addVar(getFunction(), child->type);
        Expression* pre = child; // we emit the child before curr
        if (auto* block = child->dynCast<Block>()) {
          // use the local to save the breaks and fallthrough value
          BreakValueUpdater::update(block, block->name, temp, parent->getModule());
          auto*& last = block->list.back();
          if (isConcreteWasmType(last->type)) {
            last = builder->makeSetLocal(temp, last);
          }
          block->finalize(none);
        } else if (auto* iff = child->dynCast<If>()) {
          // assign both sides to a local
          iff->ifTrue = builder->makeSetLocal(temp, iff->ifTrue);
          iff->ifFalse = builder->makeSetLocal(temp, iff->ifFalse);
          iff->finalize(none);
        } else if (auto* loop = child->dynCast<Loop>()) {
          // save the fallthrough
          loop->body = builder->makeSetLocal(temp, loop->body);
          loop->finalize(none);
        } else if (auto* brIf = child->dynCast<Break>()) {
          assert(brIf->condition);
          assert(brIf->value);
          // we disallow br_ifs entirely, so turn this into an if. but do
          // so using the proper order of operations
          pre = builder->makeSequence(
            builder->makeSetLocal(temp, brIf->value),
            builder->makeIf(
              brIf->condition,
              builder->makeBreak(brIf->name, builder->makeGetLocal(temp, child->type))
            )
          );
        } else {
          WASM_UNREACHABLE();
        }
        // replace the child in the parent (note *&) with a get_local
        child = builder->makeGetLocal(temp, child->type);
        mustEmit.push_back(pre);
        replacement = parent->replaceCurrent(builder->makeSequence(pre, replacement));
      } else {
        // as a non-concrete child expression, it must be unreachable (cannot be none)
        assert(child->type == unreachable);
        // we don't need to emit the parent, but must emit previous children
        auto* block = builder->makeBlock();
        for (auto* emit : mustEmit) {
          block->list.push_back(emit);
        }
        block->list.push_back(child);
        block->finalize();
        replacement = parent->replaceCurrent(block);
        stop = true;
      }
    }
  };

  void visitIf(If* curr) {
    Splitter splitter(*this, curr);
    splitter.note(curr->condition);
    curr->ifTrue = builder->blockify(curr->ifTrue);
    if (curr->ifFalse) {
      curr->ifFalse = builder->blockify(curr->ifFalse);
    }
  }
  void visitLoop(Loop* curr) {
    curr->body = builder->blockify(curr->body);
  }
  void visitBreak(Break* curr) {
    Splitter splitter(*this, curr);
    Splitter(*this, curr);
    splitter.note(curr->value);
    splitter.note(curr->condition);
  }
  void visitSwitch(Switch* curr) {
    Splitter(*this, curr);
    if (curr->value) {
      splitter.note(curr->value);
    }
    splitter.note(curr->condition);
  }
  void visitCall(Call* curr) {
    Splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }
  void visitCallImport(CallImport* curr) {
    Splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }
  void visitCallIndirect(CallIndirect* curr) {
    Splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
    splitter.note(curr->target);
  }
  void visitSetLocal(SetLocal* curr) {
    splitter.note(curr->value);
  }
  void visitSetGlobal(SetGlobal* curr) {
    splitter.note(curr->value);
  }
  void visitLoad(Load* curr) {
    splitter.note(curr->ptr);
  }
  void visitStore(Store* curr) {
    Splitter(*this, curr);
    splitter.note(curr->ptr);
    splitter.note(curr->value);
  }
  void visitUnary(Unary* curr) {
    splitter.note(curr->value);
  }
  void visitBinary(Binary* curr) {
    Splitter(*this, curr);
    splitter.note(curr->left);
    splitter.note(curr->right);
  }
  void visitSelect(Select* curr) {
    Splitter(*this, curr);
    splitter.note(curr->ifTrue);
    splitter.note(curr->ifFalse);
    splitter.note(curr->condition);
  }
  void visitDrop(Drop* curr) {
    splitter.note(curr->value);
  }
  void visitReturn(Return* curr) {
    splitter.note(curr->value);
  }
  void visitHost(Host* curr) {
    Splitter(*this, curr);
    for (auto*& operand : curr->operands) {
      splitter.note(operand);
    }
  }
};

Pass *createFlattenControlFlowPass() {
  return new FlattenControlFlow();
}

} // namespace wasm

