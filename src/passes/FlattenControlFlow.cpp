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

  // splits out a child expression, replacing the current expression with
  // (child, curr) and using a temp variable as necessary
  // returns the new expression after replaceCurrent()ing with it, or nullptr
  // if the child has type unreachable, which means we can stop here, and can
  // get rid of the parent (together with other siblings that are evaluated
  // after us)
  Expression* maybeSplitOut(Expression* curr, Expression*& child) {
    if (!child) return curr;
    // it's enough to look at the child, ignoring the contents, as the contents
    // have already been processed before we got here, so they must have been
    // flattened if necessary.
    if (!ControlFlowChecker::is(child)) {
      // nothing to do here, no control flow to split out
      return curr;
    }
    // if the child has a concrete type, we need a temp var
    Expression* pre = child;
    if (isConcreteWasmType(child->type)) {
      // the child node is control flow, a structure or a flow-causer. if
      // it has a concrete type, it must be a block, loop, if, or br_if with value
      auto temp = builder->addVar(getFunction(), child->type);
      if (auto* block = child->dynCast<Block>()) {
        // use the local to save the breaks and fallthrough value
        BreakValueUpdater::update(block, block->name, temp, getModule());
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
      return replaceCurrent(builder->makeSequence(pre, curr));
    } else {
      // as a child expression, it is either concrete or unreachable, cannot be none
      assert(child->type == unreachable);
      replaceCurrent(pre);
      return nullptr;
    }
  }

  void visitIf(If* curr) {
    maybeSplitOut(curr, curr->condition);
    curr->ifTrue = builder->blockify(curr->ifTrue);
    if (curr->ifFalse) {
      curr->ifFalse = builder->blockify(curr->ifFalse);
    }
  }
  void visitLoop(Loop* curr) {
    curr->body = builder->blockify(curr->body);
  }
  void visitBreak(Break* curr) {
    Expression* chain = curr;
    chain = maybeSplitOut(chain, curr->value);
    if (!chain) return;
    chain = maybeSplitOut(chain, curr->condition);
    if (!chain) return;
  }
  void visitSwitch(Switch* curr) {
    Expression* chain = curr;
    if (curr->value) {
      chain = maybeSplitOut(chain, curr->value);
      if (!chain) return;
    }
    maybeSplitOut(chain, curr->condition);
  }
  void visitCall(Call* curr) {
    Expression* chain = curr;
    for (auto*& operand : curr->operands) {
      chain = maybeSplitOut(chain, operand);
      if (!chain) return;
    }
  }
  void visitCallImport(CallImport* curr) {
    Expression* chain = curr;
    for (auto*& operand : curr->operands) {
      chain = maybeSplitOut(chain, operand);
      if (!chain) return;
    }
  }
  void visitCallIndirect(CallIndirect* curr) {
    Expression* chain = curr;
    for (auto*& operand : curr->operands) {
      chain = maybeSplitOut(chain, operand);
      if (!chain) return;
    }
    maybeSplitOut(chain, curr->target);
  }
  void visitSetLocal(SetLocal* curr) {
    maybeSplitOut(curr, curr->value);
  }
  void visitSetGlobal(SetGlobal* curr) {
    maybeSplitOut(curr, curr->value);
  }
  void visitLoad(Load* curr) {
    maybeSplitOut(curr, curr->ptr);
  }
  void visitStore(Store* curr) {
    Expression* chain = curr;
    chain = maybeSplitOut(chain, curr->ptr);
    if (!chain) return;
    maybeSplitOut(chain, curr->value);
  }
  void visitUnary(Unary* curr) {
    maybeSplitOut(curr, curr->value);
  }
  void visitBinary(Binary* curr) {
    Expression* chain = curr;
    chain = maybeSplitOut(chain, curr->left);
    if (!chain) return;
    maybeSplitOut(chain, curr->right);
  }
  void visitSelect(Select* curr) {
    Expression* chain = curr;
    chain = maybeSplitOut(chain, curr->ifTrue);
    if (!chain) return;
    chain = maybeSplitOut(chain, curr->ifFalse);
    if (!chain) return;
    maybeSplitOut(chain, curr->condition);
  }
  void visitDrop(Drop* curr) {
    maybeSplitOut(curr, curr->value);
  }
  void visitReturn(Return* curr) {
    maybeSplitOut(curr, curr->value);
  }
  void visitHost(Host* curr) {
    Expression* chain = curr;
    for (auto*& operand : curr->operands) {
      chain = maybeSplitOut(chain, operand);
      if (!chain) return;
    }
  }
};

Pass *createFlattenControlFlowPass() {
  return new FlattenControlFlow();
}

} // namespace wasm

