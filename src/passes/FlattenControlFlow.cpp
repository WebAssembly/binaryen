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

                                                                              #include "wasm-printing.h"

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

// Replaces breaks with a value to a target with assigns to a local
// then a break without a value
struct BreakValueUpdater : public PostWalker<BreakValueUpdater> {
  static void update(Expression* ast, Name name, Index index, Module* wasm, Function* func) {
    BreakValueUpdater finder;
    finder.name = name;
    finder.index = index;
    finder.setModule(wasm);
    finder.setFunction(func);
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
  void visitSwitch(Switch *curr) {
    if (!curr->value) return;
    bool relevant = false;
    for (auto target : curr->targets) {
      if (target == name) {
        relevant = true;
        break;
      }
    }
    if (curr->default_ == name) {
      relevant = true;
    }
    if (!relevant) return;
    assert(isConcreteWasmType(curr->value->type)); // we have already seen and flattened this
    assert(isConcreteWasmType(curr->condition->type)); // we have already seen and flattened this
    // the switch may target other blocks as well, and we should not alter their value
    Builder builder(*getModule());
    auto* block = builder.makeBlock();
    // write out value and condition to temps, so we can use them more than once
    auto tempValue = Builder::addVar(getFunction(), curr->value->type),
         tempCondition = Builder::addVar(getFunction(), i32);
    block->list.push_back(builder.makeSetLocal(tempValue, curr->value));
    block->list.push_back(builder.makeSetLocal(tempCondition, curr->condition));
    curr->value = builder.makeGetLocal(tempValue, curr->value->type);
    curr->condition = builder.makeGetLocal(tempCondition, i32);
    // make a "gating" switch, and decides whether we are going to our location (and should alter the value) or not (and should not)
    static int counter = 0;
    std::string base = std::string("flatten-control-flow$") + std::to_string(counter++) + "$";
    Name ours = Name((base + "ours").c_str()),
         others = Name((base + "others").c_str()),
         fake = Name((base + "fake").c_str());
    std::vector<Name> targets;
    // for the gate, go to ours or others
    for (auto target : curr->targets) {
      targets.push_back(target == name ? ours : others);
    }
    auto* gate = builder.makeSwitch(
      targets,
      curr->default_ == name ? ours : others,
      builder.makeGetLocal(tempCondition, i32)
    );
    // for the switch if it isn't ours, replace our name with a safe place to break to - it will not be reached
    targets.clear();
    for (auto target : curr->targets) {
      targets.push_back(target == name ? fake : target);
    }
    auto* fakeBlock = builder.makeBlock(
      fake,
      builder.makeSequence(
        builder.makeBlock(
          others,
          builder.makeSequence(
            builder.makeBlock(
              ours,
              gate
            ),
            // it is ours, so break to it, setting the value
            builder.makeSequence(
              builder.makeSetLocal(
                index,
                builder.makeGetLocal(
                  tempValue,
                  curr->value->type
                )
              ),
              builder.makeBreak(name)
            )
          )
        ),
        // it is not ours, so br_table on the others normally
        builder.makeSwitch(
          targets,
          curr->default_ == name ? fake : curr->default_,
          builder.makeGetLocal(tempCondition, i32),
          builder.makeGetLocal(tempValue, curr->value->type)
        )
      )
    );
    // the "fake" block has a value, so we can fake br to it with our value
    fakeBlock->type = i32;
    block->list.push_back(
      builder.makeDrop(
        fakeBlock
      )
    );
    block->finalize();
    replaceCurrent(block);
  }
};

struct FlattenControlFlow : public WalkerPass<PostWalker<FlattenControlFlow>> {
  // NB: *not* parallel, as we create labels for new blocks for switch reduction TODO optimize

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
    Splitter(FlattenControlFlow& parent, Expression* node) : parent(parent), node(node) {}

    ~Splitter() {
      finish();
    }

    FlattenControlFlow& parent;
    Expression* node;

    std::vector<Expression**> children;

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
          block->list.push_back(flattenChild(child, tempIndexes[i]));
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

    // this is a child expression which is being moved to early in the block, before
    // the main node. We need to set the child value to a temporary local. If the
    // child is control flow, then we must flatten it out, assigning to the local
    // in the proper way
    Expression* flattenChild(Expression* child, Index tempIndex) {
      assert(isConcreteWasmType(child->type));
      Builder* builder = parent.builder.get();
      if (auto* block = child->dynCast<Block>()) {
        // use the local to save the breaks and fallthrough value
        BreakValueUpdater::update(block, block->name, tempIndex, parent.getModule(), parent.getFunction());
        auto*& last = block->list.back();
        if (isConcreteWasmType(last->type)) {
          last = builder->makeSetLocal(tempIndex, last);
        }
        block->finalize();
        return block;
      } else if (auto* iff = child->dynCast<If>()) {
        // assign both sides to a local
        iff->ifTrue = builder->makeSetLocal(tempIndex, iff->ifTrue);
        iff->ifFalse = builder->makeSetLocal(tempIndex, iff->ifFalse);
        iff->finalize(none);
        return iff;
      } else if (auto* loop = child->dynCast<Loop>()) {
        // save the fallthrough
        loop->body = builder->makeSetLocal(tempIndex, loop->body);
        loop->finalize(none);
        return loop;
      } else if (auto* brIf = child->dynCast<Break>()) {
        assert(brIf->condition);
        assert(brIf->value);
        // we disallow br_ifs entirely, so turn this into an if. but do
        // so using the proper order of operations
        return builder->makeSequence(
          builder->makeSetLocal(tempIndex, brIf->value),
          builder->makeIf(
            brIf->condition,
            builder->makeBreak(brIf->name, builder->makeGetLocal(tempIndex, child->type))
          )
        );
      } else {
        // safe to just emit a set of the child
        return builder->makeSetLocal(tempIndex, child);
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
    splitter.note(curr->value);
    splitter.note(curr->condition);
  }
  void visitSwitch(Switch* curr) {
    Splitter splitter(*this, curr);
    if (curr->value) {
      splitter.note(curr->value);
    }
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

