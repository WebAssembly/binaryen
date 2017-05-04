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
// of an if.
//

#include <wasm.h>
#include <pass.h>
#include <wasm-builder.h>

namespace wasm {

// Looks for control flow changes and structures, excluding blocks (as we
// want to put all control flow on them)
struct ControlFlowFinder : public PostWalker<ControlFlowFinder> {
  static bool has(Expression *ast) {
    ControlFlowFinder finder;
    finder.walk(ast);
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
    if (!ControlFlowFinder::has(child)) {
      // nothing to do here, no control flow to split out
      return curr;
    }
    // if the child has a concrete type, we need a temp var
    Expression* pre = child;
    if (isConcreteWasmType(child->type)) {
      auto temp = builder->addVar(getFunction(), child->type);
      pre = builder->makeSetLocal(temp, child);
      child = builder->makeGetLocal(temp, child->type);
      return replaceCurrent(builder->makeSequence(pre, curr));
    } else {
      // as a child expression, it is either concrete or unreachable, cannot be none
      assert(child->type == unreachable);
      // since it is unreachable, we don't need the parent, but we do need
      // other siblings with side effects
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

