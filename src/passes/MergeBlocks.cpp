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
// We merge both entire blocks when possible, as well as loop tails, like
//  (block
//   (loop $child
//    (br_if $child (..)
//    (call $foo)
//   )
//  )
// Here we can move the call into the outer block. Doing so may let
// the inner block become a single expression, and usually outer
// blocks are larger anyhow. (This also helps readability.)
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
#include <wasm-builder.h>
#include <ir/branch-utils.h>
#include <ir/effects.h>
#include <ir/utils.h>

namespace wasm {

// Looks for reasons we can't remove the values from breaks to an origin
// For example, if there is a switch targeting us, we can't do it - we can't remove the value from other targets
struct ProblemFinder : public ControlFlowWalker<ProblemFinder> {
  Name origin;
  bool foundProblem = false;
  // count br_ifs, and dropped br_ifs. if they don't match, then a br_if flow value is used, and we can't drop it
  Index brIfs = 0;
  Index droppedBrIfs = 0;
  PassOptions& passOptions;

  ProblemFinder(PassOptions& passOptions) : passOptions(passOptions) {}

  void visitBreak(Break* curr) {
    if (curr->name == origin) {
      if (curr->condition) {
        brIfs++;
      }
      // if the value has side effects, we can't remove it
      if (EffectAnalyzer(passOptions, curr->value).hasSideEffects()) {
        foundProblem = true;
      }
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
      foundProblem = true;
      return;
    }
    for (auto& target : curr->targets) {
      if (target == origin) {
        foundProblem = true;
        return;
      }
    }
  }

  bool found() {
    assert(brIfs >= droppedBrIfs);
    return foundProblem || brIfs > droppedBrIfs;
  }
};

// Drops values from breaks to an origin.
// While doing so it can create new blocks, so optimize blocks as well.
struct BreakValueDropper : public ControlFlowWalker<BreakValueDropper> {
  Name origin;
  PassOptions& passOptions;

  BreakValueDropper(PassOptions& passOptions) : passOptions(passOptions) {}

  void visitBlock(Block* curr);

  void visitBreak(Break* curr) {
    if (curr->value && curr->name == origin) {
      Builder builder(*getModule());
      auto* value = curr->value;
      if (value->type == unreachable) {
        // the break isn't even reached
        replaceCurrent(value);
        return;
      }
      curr->value = nullptr;
      curr->finalize();
      replaceCurrent(builder.makeSequence(builder.makeDrop(value), curr));
    }
  }

  void visitDrop(Drop* curr) {
    // if we dropped a br_if whose value we removed, then we are now dropping a (block (drop value) (br_if)) with type none, which does not need a drop
    // likewise, unreachable does not need to be dropped, so we just leave drops of concrete values
    if (!isConcreteType(curr->value->type)) {
      replaceCurrent(curr->value);
    }
  }
};

static bool hasUnreachableChild(Block* block) {
  for (auto* test : block->list) {
    if (test->type == unreachable) {
      return true;
    }
  }
  return false;
}

// Checks for code after an unreachable element.
static bool hasDeadCode(Block* block) {
  auto& list = block->list;
  auto size = list.size();
  for (size_t i = 1; i < size; i++) {
    if (list[i - 1]->type == unreachable) {
      return true;
    }
  }
  return false;
}

// core block optimizer routine
static void optimizeBlock(Block* curr, Module* module, PassOptions& passOptions) {
  auto& list = curr->list;
  // Main merging loop.
  bool more = true;
  bool changed = false;
  while (more) {
    more = false;
    for (size_t i = 0; i < list.size(); i++) {
      auto* child = list[i];
      // The child block, if there is one.
      Block* childBlock = child->dynCast<Block>();
      // If we are merging an inner block of a loop, then we must not
      // merge things before and including the name of the loop, moving
      // those out would break things.
      Loop* loop = nullptr;
      // To to handle a non-block child.
      if (!childBlock) {
        // if we have a child that is (drop (block ..)) then we can move the drop into the block, and remove br values. this allows more merging,
        if (auto* drop = list[i]->dynCast<Drop>()) {
          childBlock = drop->value->dynCast<Block>();
          if (childBlock) {
            if (hasUnreachableChild(childBlock)) {
              // don't move around unreachable code, as it can change types
              // dce should have been run anyhow
              continue;
            }
            if (childBlock->name.is()) {
              Expression* expression = childBlock;
              // check if it's ok to remove the value from all breaks to us
              ProblemFinder finder(passOptions);
              finder.origin = childBlock->name;
              finder.walk(expression);
              if (finder.found()) {
                childBlock = nullptr;
              } else {
                // fix up breaks
                BreakValueDropper fixer(passOptions);
                fixer.origin = childBlock->name;
                fixer.setModule(module);
                fixer.walk(expression);
              }
            }
            if (childBlock) {
              // we can do it!
              // reuse the drop, if we still need it
              auto* last = childBlock->list.back();
              if (isConcreteType(last->type)) {
                drop->value = last;
                drop->finalize();
                childBlock->list.back() = drop;
              }
              childBlock->finalize();
              child = list[i] = childBlock;
              more = true;
              changed = true;
            }
          }
        } else if ((loop = list[i]->dynCast<Loop>())) {
          // We can merge a loop's "tail" - if the body is a block and has
          // instructions at the end that do not branch back.
          childBlock = loop->body->dynCast<Block>();
          // TODO: handle (loop (loop - the bodies of loops may not be blocks
        }
      }
      // If no block, we can't do anything.
      if (!childBlock) continue;
      auto& childList = childBlock->list;
      auto childSize = childList.size();
      if (childSize == 0) continue;
      // If the child has items after an unreachable, ignore it - dce should have
      // been run, and we prefer to not handle the complexity here.
      if (hasDeadCode(childBlock)) continue;
      // In some cases we can remove only the head or the tail of the block,
      // and must keep some things in the child block.
      Index keepStart = childSize;
      Index keepEnd = 0;
      // For a block with a name, we may only be able to remove a head, up
      // to the first item that branches to the block.
      if (childBlock->name.is()) {
        // If it has a concrete value, then breaks may be sending it a value,
        // and we'd need to handle that. TODO
        if (isConcreteType(childBlock->type)) {
          continue;
        }
        auto childName = childBlock->name;
        for (size_t j = 0; j < childSize; j++) {
          auto* item = childList[j];
          if (BranchUtils::BranchSeeker::hasNamed(item, childName)) {
            // We can't remove this from the child.
            keepStart = j;
            keepEnd = childSize;
            break;
          }
        }
      }
      // For a loop, we may only be able to remove a tail
      if (loop) {
        auto childName = loop->name;
        for (auto j = int(childSize - 1); j >= 0; j--) {
          auto* item = childList[j];
          if (BranchUtils::BranchSeeker::hasNamed(item, childName)) {
            // We can't remove this from the child.
            keepStart = 0;
            keepEnd = std::max(Index(j + 1), keepEnd);
            break;
          }
        }
        // If we can only do part of the block, and if the block has a flowing value, we
        // would need special handling for that - not worth it, probably TODO
        // FIXME is this not handled by the drop later down?
        if (keepEnd < childSize && isConcreteType(childList.back()->type)) {
          continue;
        }
      }
      // Maybe there's nothing to do, if we must keep it all in the
      // child anyhow.
      if (keepStart == 0 && keepEnd == childSize) continue;
      // There is something to do!
      bool keepingPart = keepStart < keepEnd;
      // Create a new merged list, and fill in the code before the
      // child block we are merging in. TODO better efficiency
      ExpressionList merged(module->allocator);
      for (size_t j = 0; j < i; j++) {
        merged.push_back(list[j]);
      }
      // Add the head of the block - the things at the start we do
      // not need to keep.
      for (Index j = 0; j < keepStart; j++) {
        merged.push_back(childList[j]);
      }
      // If we can't merge it all, keep and filter the child.
      if (keepingPart) {
        merged.push_back(child);
        // Filter the child.
        ExpressionList filtered(module->allocator);
        for (Index j = keepStart; j < keepEnd; j++) {
          filtered.push_back(childList[j]);
        }
        // Add the tail of the block - the things at the end we do
        // not need to keep.
        for (Index j = keepEnd; j < childSize; j++) {
          merged.push_back(childList[j]);
        }
        // Update the child.
        childList.swap(filtered);
        // We may have removed unreachable items.
        childBlock->finalize();
        if (loop) {
          loop->finalize();
        }
      }
      // Add the rest of the parent block after the child.
      for (size_t j = i + 1; j < list.size(); j++) {
        merged.push_back(list[j]);
      }
      // if we merged a concrete element in the middle, drop it
      if (!merged.empty()) {
        auto* last = merged.back();
        for (auto*& item : merged) {
          if (item != last && isConcreteType(item->type)) {
            Builder builder(*module);
            item = builder.makeDrop(item);
          }
        }
      }
      list.swap(merged);
      more = true;
      changed = true;
      break;
    }
  }
  if (changed) {
    curr->finalize(curr->type);
  }
}

void BreakValueDropper::visitBlock(Block* curr) {
  optimizeBlock(curr, getModule(), passOptions);
}

struct MergeBlocks : public WalkerPass<PostWalker<MergeBlocks>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new MergeBlocks; }

  void visitBlock(Block *curr) {
    optimizeBlock(curr, getModule(), getPassOptions());
  }

  // given
  // (curr
  //  (block=child
  //   (..more..)
  //   (back)
  //  )
  //  (..other..children..)
  // )
  // if child is a block, we can move this around to
  // (block
  //  (..more..)
  //  (curr
  //   (back)
  //   (..other..children..)
  //  )
  // )
  // at which point the block is on the outside and potentially mergeable with an outer block
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
        // if we move around unreachable code, type changes could occur. avoid that, as
        // anyhow it means we should have run dce before getting here
        if (curr->type == none && hasUnreachableChild(block)) {
          // moving the block to the outside would replace a none with an unreachable
          return outer;
        }
        auto* back = block->list.back();
        if (back->type == unreachable) {
          // curr is not reachable, dce could remove it; don't try anything fancy
          // here
          return outer;
        }
        // we are going to replace the block with the final element, so they should
        // be identically typed
        if (block->type != back->type) {
          return outer;
        }
        child = back;
        if (outer == nullptr) {
          // reuse the block, move it out
          block->list.back() = curr;
          // we want the block outside to have the same type as curr had
          block->finalize(curr->type);
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
  void visitAtomicRMW(AtomicRMW* curr) {
    optimize(curr, curr->value, optimize(curr, curr->ptr), &curr->ptr);
  }
  void optimizeTernary(Expression* curr,
		       Expression*& first, Expression*& second, Expression*& third) {
    // TODO: for now, just stop when we see any side effect. instead, we could
    //       check effects carefully for reordering
    Block* outer = nullptr;
    if (EffectAnalyzer(getPassOptions(), first).hasSideEffects()) return;
    outer = optimize(curr, first, outer);
    if (EffectAnalyzer(getPassOptions(), second).hasSideEffects()) return;
    outer = optimize(curr, second, outer);
    if (EffectAnalyzer(getPassOptions(), third).hasSideEffects()) return;
    optimize(curr, third, outer);
  }
  void visitAtomicCmpxchg(AtomicCmpxchg* curr) {
    optimizeTernary(curr, curr->ptr, curr->expected, curr->replacement);
  }

  void visitSelect(Select* curr) {
    optimizeTernary(curr, curr->ifTrue, curr->ifFalse, curr->condition);
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
  void handleCall(T* curr) {
    Block* outer = nullptr;
    for (Index i = 0; i < curr->operands.size(); i++) {
      if (EffectAnalyzer(getPassOptions(), curr->operands[i]).hasSideEffects()) return;
      outer = optimize(curr, curr->operands[i], outer);
    }
    return;
  }

  void visitCall(Call* curr) {
    handleCall(curr);
  }

  void visitCallIndirect(CallIndirect* curr) {
    Block* outer = nullptr;
    for (Index i = 0; i < curr->operands.size(); i++) {
      if (EffectAnalyzer(getPassOptions(), curr->operands[i]).hasSideEffects()) return;
      outer = optimize(curr, curr->operands[i], outer);
    }
    if (EffectAnalyzer(getPassOptions(), curr->target).hasSideEffects()) return;
    optimize(curr, curr->target, outer);
  }
};

Pass *createMergeBlocksPass() {
  return new MergeBlocks();
}

} // namespace wasm
