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

namespace wasm {

struct MergeBlocks : public WalkerPass<PostWalker<MergeBlocks, Visitor<MergeBlocks>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new MergeBlocks; }

  void visitBlock(Block *curr) {
    bool more = true;
    while (more) {
      more = false;
      for (size_t i = 0; i < curr->list.size(); i++) {
        Block* child = curr->list[i]->dynCast<Block>();
        if (!child) continue;
        if (child->name.is()) continue; // named blocks can have breaks to them (and certainly do, if we ran RemoveUnusedNames and RemoveUnusedBrs)
        ExpressionList merged(getModule()->allocator);
        for (size_t j = 0; j < i; j++) {
          merged.push_back(curr->list[j]);
        }
        for (auto item : child->list) {
          merged.push_back(item);
        }
        for (size_t j = i + 1; j < curr->list.size(); j++) {
          merged.push_back(curr->list[j]);
        }
        curr->list = merged;
        more = true;
        break;
      }
    }
  }

  Block* optimize(Expression* curr, Expression*& child, Block* outer = nullptr, Expression** dependency1 = nullptr, Expression** dependency2 = nullptr) {
    if (!child) return outer;
    if (dependency1 && *dependency1 && EffectAnalyzer(*dependency1).hasSideEffects()) return outer;
    if (dependency2 && *dependency2 && EffectAnalyzer(*dependency2).hasSideEffects()) return outer;
    if (auto* block = child->dynCast<Block>()) {
      if (!block->name.is() && block->list.size() >= 2) {
        child = block->list.back();
        if (outer == nullptr) {
          // reuse the block, move it out
          block->list.back() = curr;
          block->finalize(); // last block element was our input, and is now our output, which may differ TODO optimize
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
    optimize(curr, curr->condition, optimize(curr, curr->ifFalse, optimize(curr, curr->ifTrue), &curr->ifTrue), &curr->ifTrue, &curr->ifFalse);
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
      if (EffectAnalyzer(curr->operands[i]).hasSideEffects()) return;
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
    if (EffectAnalyzer(curr->target).hasSideEffects()) return;
    handleCall(curr, outer);
  }
};

Pass *createMergeBlocksPass() {
  return new MergeBlocks();
}

} // namespace wasm

