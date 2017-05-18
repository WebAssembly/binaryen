/*
 * Copyright 2015 WebAssembly Community Group participants
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
// Merges blocks to their parents.
//
// We also restructure blocks in order to enable such merging. For
// example,
//
//  (i32.store
//    (block
//      (call $foo)
//      (i32.load (i32.const 100))
//    )
//    (i32.const 0)
//  )
//
// can be transformed into
//
//  (block
//    (call $foo)
//    (i32.store
//      (block
//        (i32.load (i32.const 100))
//      )
//      (i32.const 0)
//    )
//  )
//
// after which the internal block can go away, and
// the new external block might be mergeable. This is always
// worth it if the internal block ends up with 1 item.
// For the second operand,
//
//  (i32.store
//    (i32.const 100)
//    (block
//      (call $foo)
//      (i32.load (i32.const 200))
//    )
//  )
//
// The order of operations requires that the first execute
// before. We can do the same operation, but only if the
// first has no side effects, or the code we are moving out
// has no side effects.
// If we can do this to both operands, we can generate a
// single outside block.
//

#include <wasm.h>
#include <pass.h>
#include <ast_utils.h>
#include <wasm-builder.h>

namespace wasm {

// Looks for reasons we can't remove the values from breaks to an origin
// For example, if there is a switch targeting us, we can't do it - we can't remove the value from other targets
struct ProblemFinder : public ControlFlowWalker<ProblemFinder> {
  Name origin;
  bool foundSwitch = false;
  // count br_ifs, and dropped br_ifs. if they don't match, then a br_if flow value is used, and we can't drop it
  Index brIfs = 0;
  Index droppedBrIfs = 0;

  void visitBreak(Break* curr) {
    if (curr->name == origin && curr->condition) {
      brIfs++;
    }
  }

  void visitDrop(Drop* curr) {
    if (auto* br = curr->value->dynCast<Break>()) {
      if (br->name == origin && br->condition) {
        droppedBrIfs++;
      }
    }
  }

  void visitSwitch(Switch* curr) {
    if (curr->default_ == origin) {
      foundSwitch = true;
      return;
    }
    for (auto& target : curr->targets) {
      if (target == origin) {
        foundSwitch = true;
        return;
      }
    }
  }

  bool found() {
    assert(brIfs >= droppedBrIfs);
    return foundSwitch || brIfs > droppedBrIfs;
  }
};

// Drops values from breaks to an origin.
// While doing so it can create new blocks, so optimize blocks as well.
struct BreakValueDropper : public ControlFlowWalker<BreakValueDropper> {
  Name origin;

  void visitBlock(Block* curr);

  void visitBreak(Break* curr) {
    if (curr->value && curr->name == origin) {
      Builder builder(*getModule());
      auto* value = curr->value;
      curr->value = nullptr;
      curr->finalize();
      replaceCurrent(builder.makeSequence(builder.makeDrop(value), curr));
    }
  }

  void visitDrop(Drop* curr) {
    // if we dropped a br_if whose value we removed, then we are now dropping a (block (drop value) (br_if)) with type none, which does not need a drop
    if (curr->value->type == none) {
      replaceCurrent(curr->value);
    }
  }
};

// core block optimizer routine
static void optimizeBlock(Block* curr, Module* module) {
  bool more = true;
  bool changed = false;
  while (more) {
    more = false;
    for (size_t i = 0; i < curr->list.size(); i++) {
      Block* child = curr->list[i]->dynCast<Block>();
      if (!child) {
        // if we have a child that is (drop (block ..)) then we can move the drop into the block, and remove br values. this allows more merging,
        auto* drop = curr->list[i]->dynCast<Drop>();
        if (drop) {
          child = drop->value->dynCast<Block>();
          if (child) {
            if (child->name.is()) {
              Expression* expression = child;
              // check if it's ok to remove the value from all breaks to us
              ProblemFinder finder;
              finder.origin = child->name;
              finder.walk(expression);
              if (finder.found()) {
                child = nullptr;
              } else {
                // fix up breaks
                BreakValueDropper fixer;
                fixer.origin = child->name;
                fixer.setModule(module);
                fixer.walk(expression);
              }
            }
            if (child) {
              // we can do it!
              // reuse the drop
              drop->value = child->list.back();
              drop->finalize();
              child->list.back() = drop;
              child->finalize();
              curr->list[i] = child;
              more = true;
              changed = true;
            }
          }
        }
      }
      if (!child) continue;
      if (child->name.is()) continue; // named blocks can have breaks to them (and certainly do, if we ran RemoveUnusedNames and RemoveUnusedBrs)
      ExpressionList merged(module->allocator);
      for (size_t j = 0; j < i; j++) {
        merged.push_back(curr->list[j]);
      }
      for (auto item : child->list) {
        merged.push_back(item);
      }
      for (size_t j = i + 1; j < curr->list.size(); j++) {
        merged.push_back(curr->list[j]);
      }
      curr->list.swap(merged);
      more = true;
      changed = true;
      break;
    }
  }
  if (changed) curr->finalize();
}

void BreakValueDropper::visitBlock(Block* curr) {
  optimizeBlock(curr, getModule());
}

struct MergeBlocks : public WalkerPass<PostWalker<MergeBlocks>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new MergeBlocks; }

  void visitBlock(Block *curr) {
    optimizeBlock(curr, getModule());
  }

  Block* optimize(Expression* curr, Expression*& child, Block* outer = nullptr, Expression** dependency1 = nullptr, Expression** dependency2 = nullptr) {
    if (!child) return outer;
    if ((dependency1 && *dependency1) || (dependency2 && *dependency2)) {
      // there are dependencies, things we must be reordered through. make sure no problems there
      EffectAnalyzer childEffects(getPassOptions(), child);
      if (dependency1 && *dependency1 && EffectAnalyzer(getPassOptions(), *dependency1).invalidates(childEffects)) return outer;
      if (dependency2 && *dependency2 && EffectAnalyzer(getPassOptions(), *dependency2).invalidates(childEffects)) return outer;
    }
    if (auto* block = child->dynCast<Block>()) {
      if (!block->name.is() && block->list.size() >= 2) {
        child = block->list.back();
        // we modified child (which is a reference to a pointer), which modifies curr, which might change its type
        // (e.g. (drop (block i32 .. (unreachable)))
        // the child was a block of i32, and is being replaced with an unreachable, so the
        // parent will likely need to be unreachable too
        auto oldType = curr->type;
        ReFinalize().walk(curr);
        if (outer == nullptr) {
          // reuse the block, move it out
          block->list.back() = curr;
          // we want the block outside to have the same type as curr had
          block->finalize(oldType);
          replaceCurrent(block);
          return block;
        } else {
          // append to an existing outer block
          assert(outer->list.back() == curr);
          outer->list.pop_back();
          for (Index i = 0; i < block->list.size() - 1; i++) {
            outer->list.push_back(block->list[i]);
          }
          outer->list.push_back(curr);
        }
      }
    }
    return outer;
  }

  void visitUnary(Unary* curr) {
    optimize(curr, curr->value);
  }
  void visitSetLocal(SetLocal* curr) {
    optimize(curr, curr->value);
  }
  void visitLoad(Load* curr) {
    optimize(curr, curr->ptr);
  }
  void visitReturn(Return* curr) {
    optimize(curr, curr->value);
  }

  void visitBinary(Binary* curr) {
    optimize(curr, curr->right, optimize(curr, curr->left), &curr->left);
  }
  void visitStore(Store* curr) {
    optimize(curr, curr->value, optimize(curr, curr->ptr), &curr->ptr);
  }

  void visitSelect(Select* curr) {
    Block* outer = nullptr;
    outer = optimize(curr, curr->ifTrue, outer);
    if (EffectAnalyzer(getPassOptions(), curr->ifTrue).hasSideEffects()) return;
    outer = optimize(curr, curr->ifFalse, outer);
    if (EffectAnalyzer(getPassOptions(), curr->ifFalse).hasSideEffects()) return;
            optimize(curr, curr->condition, outer);
  }

  void visitDrop(Drop* curr) {
    optimize(curr, curr->value);
  }

  void visitBreak(Break* curr) {
    optimize(curr, curr->condition, optimize(curr, curr->value), &curr->value);
  }
  void visitSwitch(Switch* curr) {
    optimize(curr, curr->condition, optimize(curr, curr->value), &curr->value);
  }

  template<typename T>
  void handleCall(T* curr, Block* outer = nullptr) {
    for (Index i = 0; i < curr->operands.size(); i++) {
      outer = optimize(curr, curr->operands[i], outer);
      if (EffectAnalyzer(getPassOptions(), curr->operands[i]).hasSideEffects()) return;
    }
  }

  void visitCall(Call* curr) {
    handleCall(curr);
  }

  void visitCallImport(CallImport* curr) {
    handleCall(curr);
  }

  void visitCallIndirect(CallIndirect* curr) {
    auto* outer = optimize(curr, curr->target);
    if (EffectAnalyzer(getPassOptions(), curr->target).hasSideEffects()) return;
    handleCall(curr, outer);
  }
};

Pass *createMergeBlocksPass() {
  return new MergeBlocks();
}

} // namespace wasm

