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
// Locals-related optimizations
//
// This "sinks" set_locals, pushing them to the next get_local where possible,
// and removing the set if there are no gets remaining (the latter is
// particularly useful in ssa mode, but not only).
//
// We also note where set_locals coalesce: if all breaks of a block set
// a specific local, we can use a block return value for it, in effect
// removing multiple set_locals and replacing them with one that the
// block returns to. Further optimization rounds then have the opportunity
// to remove that set_local as well. TODO: support partial traces; right
// now, whenever control flow splits, we invalidate everything.
//
// After this pass, some locals may be completely unused. reorder-locals
// can get rid of those (the operation is trivial there after it sorts by use
// frequency).
//
// This pass has two main options:
//
//   * Tee: allow teeing, i.e., sinking a local with more than one use,
//          and so after sinking we have a tee for the first use.
//   * Structure: create block and if return values, by merging the
//                internal set_locals into one on the outside,
//                that can itself then be sunk further.
//

#include <wasm.h>
#include <wasm-builder.h>
#include <wasm-traversal.h>
#include <pass.h>
#include <ast_utils.h>
#include <ast/count.h>
#include <ast/manipulation.h>

namespace wasm {

// Helper classes

struct SetLocalRemover : public PostWalker<SetLocalRemover> {
  std::vector<Index>* numGetLocals;

  void visitSetLocal(SetLocal *curr) {
    if ((*numGetLocals)[curr->index] == 0) {
      auto* value = curr->value;
      if (curr->isTee()) {
        replaceCurrent(value);
      } else {
        Drop* drop = ExpressionManipulator::convert<SetLocal, Drop>(curr);
        drop->value = value;
      }
    }
  }
};

// Main class

struct SimplifyLocals : public WalkerPass<LinearExecutionWalker<SimplifyLocals>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SimplifyLocals(allowTee, allowStructure); }

  bool allowTee, allowStructure;

  SimplifyLocals(bool allowTee, bool allowStructure) : allowTee(allowTee), allowStructure(allowStructure) {}

  // information for a set_local we can sink
  struct SinkableInfo {
    Expression** item;
    EffectAnalyzer effects;

    SinkableInfo(Expression** item, PassOptions& passOptions) : item(item), effects(passOptions, *item) {}
  };

  // a list of sinkables in a linear execution trace
  typedef std::map<Index, SinkableInfo> Sinkables;

  // locals in current linear execution trace, which we try to sink
  Sinkables sinkables;

  // Information about an exit from a block: the break, and the
  // sinkables. For the final exit from a block (falling off)
  // exitter is null.
  struct BlockBreak {
    Expression** brp;
    Sinkables sinkables;
  };

  // a list of all sinkable traces that exit a block. the last
  // is falling off the end, others are branches. this is used for
  // block returns
  std::map<Name, std::vector<BlockBreak>> blockBreaks;

  // blocks that we can't produce a block return value for them.
  // (switch target, or some other reason)
  std::set<Name> unoptimizableBlocks;

  // A stack of sinkables from the current traversal state. When
  // execution reaches an if-else, it splits, and can then
  // be merged on return.
  std::vector<Sinkables> ifStack;

  // whether we need to run an additional cycle
  bool anotherCycle;

  // whether this is the first cycle, in which we always disallow teeing
  bool firstCycle;

  // local => # of get_locals for it
  GetLocalCounter getCounter;

  static void doNoteNonLinear(SimplifyLocals* self, Expression** currp) {
    auto* curr = *currp;
    if (curr->is<Break>()) {
      auto* br = curr->cast<Break>();
      if (br->value) {
        // value means the block already has a return value
        self->unoptimizableBlocks.insert(br->name);
      } else {
        self->blockBreaks[br->name].push_back({ currp, std::move(self->sinkables) });
      }
    } else if (curr->is<Block>()) {
      return; // handled in visitBlock
    } else if (curr->is<If>()) {
      assert(!curr->cast<If>()->ifFalse); // if-elses are handled by doNoteIfElse* methods
    } else if (curr->is<Switch>()) {
      auto* sw = curr->cast<Switch>();
      for (auto target : sw->targets) {
        self->unoptimizableBlocks.insert(target);
      }
      self->unoptimizableBlocks.insert(sw->default_);
      // TODO: we could use this info to stop gathering data on these blocks
    }
    self->sinkables.clear();
  }

  static void doNoteIfElseCondition(SimplifyLocals* self, Expression** currp) {
    // we processed the condition of this if-else, and now control flow branches
    // into either the true or the false sides
    assert((*currp)->cast<If>()->ifFalse);
    self->sinkables.clear();
  }

  static void doNoteIfElseTrue(SimplifyLocals* self, Expression** currp) {
    // we processed the ifTrue side of this if-else, save it on the stack
    assert((*currp)->cast<If>()->ifFalse);
    self->ifStack.push_back(std::move(self->sinkables));
  }

  static void doNoteIfElseFalse(SimplifyLocals* self, Expression** currp) {
    // we processed the ifFalse side of this if-else, we can now try to
    // mere with the ifTrue side and optimize a return value, if possible
    auto* iff = (*currp)->cast<If>();
    assert(iff->ifFalse);
    if (self->allowStructure) {
      self->optimizeIfReturn(iff, currp, self->ifStack.back());
    }
    self->ifStack.pop_back();
    self->sinkables.clear();
  }

  void visitBlock(Block* curr) {
    bool hasBreaks = curr->name.is() && blockBreaks[curr->name].size() > 0;

    if (allowStructure) {
      optimizeBlockReturn(curr); // can modify blockBreaks
    }

    // post-block cleanups
    if (curr->name.is()) {
      if (unoptimizableBlocks.count(curr->name)) {
        sinkables.clear();
        unoptimizableBlocks.erase(curr->name);
      }

      if (hasBreaks) {
        // more than one path to here, so nonlinear
        sinkables.clear();
        blockBreaks.erase(curr->name);
      }
    }
  }

  void visitGetLocal(GetLocal *curr) {
    auto found = sinkables.find(curr->index);
    if (found != sinkables.end()) {
      // sink it, and nop the origin
      auto* set = (*found->second.item)->cast<SetLocal>();
      if (firstCycle || getCounter.num[curr->index] == 1) {
        replaceCurrent(set->value);
      } else {
        replaceCurrent(set);
        assert(!set->isTee());
        set->setTee(true);
      }
      // reuse the getlocal that is dying
      *found->second.item = curr;
      ExpressionManipulator::nop(curr);
      sinkables.erase(found);
      anotherCycle = true;
    }
  }

  void visitDrop(Drop* curr) {
    // collapse drop-tee into set, which can occur if a get was sunk into a tee
    auto* set = curr->value->dynCast<SetLocal>();
    if (set) {
      assert(set->isTee());
      set->setTee(false);
      replaceCurrent(set);
    }
  }

  void checkInvalidations(EffectAnalyzer& effects) {
    // TODO: this is O(bad)
    std::vector<Index> invalidated;
    for (auto& sinkable : sinkables) {
      if (effects.invalidates(sinkable.second.effects)) {
        invalidated.push_back(sinkable.first);
      }
    }
    for (auto index : invalidated) {
      sinkables.erase(index);
    }
  }

  std::vector<Expression*> expressionStack;

  static void visitPre(SimplifyLocals* self, Expression** currp) {
    Expression* curr = *currp;

    EffectAnalyzer effects(self->getPassOptions());
    if (effects.checkPre(curr)) {
      self->checkInvalidations(effects);
    }

    self->expressionStack.push_back(curr);
  }

  static void visitPost(SimplifyLocals* self, Expression** currp) {
    // perform main SetLocal processing here, since we may be the result of
    // replaceCurrent, i.e., the visitor was not called.
    auto* set = (*currp)->dynCast<SetLocal>();

    if (set) {
      // if we see a set that was already potentially-sinkable, then the previous
      // store is dead, leave just the value
      auto found = self->sinkables.find(set->index);
      if (found != self->sinkables.end()) {
        auto* previous = (*found->second.item)->cast<SetLocal>();
        assert(!previous->isTee());
        auto* previousValue = previous->value;
        Drop* drop = ExpressionManipulator::convert<SetLocal, Drop>(previous);
        drop->value = previousValue;
        self->sinkables.erase(found);
        self->anotherCycle = true;
      }
    }

    EffectAnalyzer effects(self->getPassOptions());
    if (effects.checkPost(*currp)) {
      self->checkInvalidations(effects);
    }

    if (set && self->canSink(set)) {
      Index index = set->index;
      assert(self->sinkables.count(index) == 0);
      self->sinkables.emplace(std::make_pair(index, SinkableInfo(currp, self->getPassOptions())));
    }

    self->expressionStack.pop_back();
  }

  bool canSink(SetLocal* set) {
    // we can never move a tee
    if (set->isTee()) return false;
    // if in the first cycle, or not allowing tees, then we cannot sink if >1 use as that would make a tee
    if ((firstCycle || !allowTee) && getCounter.num[set->index] > 1) return false;
    return true;
  }

  std::vector<Block*> blocksToEnlarge;
  std::vector<If*> ifsToEnlarge;

  void optimizeBlockReturn(Block* block) {
    if (!block->name.is() || unoptimizableBlocks.count(block->name) > 0) {
      return;
    }
    auto breaks = std::move(blockBreaks[block->name]);
    blockBreaks.erase(block->name);
    if (breaks.size() == 0) return; // block has no branches TODO we might optimize trivial stuff here too
    assert(!(*breaks[0].brp)->cast<Break>()->value); // block does not already have a return value (if one break has one, they all do)
    // look for a set_local that is present in them all
    bool found = false;
    Index sharedIndex = -1;
    for (auto& sinkable : sinkables) {
      Index index = sinkable.first;
      bool inAll = true;
      for (size_t j = 0; j < breaks.size(); j++) {
        if (breaks[j].sinkables.count(index) == 0) {
          inAll = false;
          break;
        }
      }
      if (inAll) {
        sharedIndex = index;
        found = true;
        break;
      }
    }
    if (!found) return;
    // Great, this local is set in them all, we can optimize!
    if (block->list.size() == 0 || !block->list.back()->is<Nop>()) {
      // We can't do this here, since we can't push to the block -
      // it would invalidate sinkable pointers. So we queue a request
      // to grow the block at the end of the turn, we'll get this next
      // cycle.
      blocksToEnlarge.push_back(block);
      return;
    }
    // move block set_local's value to the end, in return position, and nop the set
    auto* blockSetLocalPointer = sinkables.at(sharedIndex).item;
    auto* value = (*blockSetLocalPointer)->cast<SetLocal>()->value;
    block->list[block->list.size() - 1] = value;
    block->type = value->type;
    ExpressionManipulator::nop(*blockSetLocalPointer);
    for (size_t j = 0; j < breaks.size(); j++) {
      // move break set_local's value to the break
      auto* breakSetLocalPointer = breaks[j].sinkables.at(sharedIndex).item;
      auto* brp = breaks[j].brp;
      auto* br = (*brp)->cast<Break>();
      assert(!br->value);
      // if the break is conditional, then we must set the value here - if the break is not taken, we must still have the new value in the local
      auto* set = (*breakSetLocalPointer)->cast<SetLocal>();
      if (br->condition) {
        br->value = set;
        set->setTee(true);
        *breakSetLocalPointer = getModule()->allocator.alloc<Nop>();
        // in addition, as this is a conditional br that now has a value, it now returns a value, so it must be dropped
        br->finalize();
        *brp = Builder(*getModule()).makeDrop(br);
      } else {
        br->value = set->value;
        ExpressionManipulator::nop(set);
      }
    }
    // finally, create a set_local on the block itself
    auto* newSetLocal = Builder(*getModule()).makeSetLocal(sharedIndex, block);
    replaceCurrent(newSetLocal);
    sinkables.clear();
    anotherCycle = true;
  }

  // optimize set_locals from both sides of an if into a return value
  void optimizeIfReturn(If* iff, Expression** currp, Sinkables& ifTrue) {
    assert(iff->ifFalse);
    // if this if already has a result, we can't do anything
    if (isConcreteWasmType(iff->type)) return;
    // We now have the sinkables from both sides of the if.
    Sinkables& ifFalse = sinkables;
    Index sharedIndex = -1;
    bool found = false;
    for (auto& sinkable : ifTrue) {
      Index index = sinkable.first;
      if (ifFalse.count(index) > 0) {
        sharedIndex = index;
        found = true;
        break;
      }
    }
    if (!found) return;
    // great, we can optimize!
    // ensure we have a place to write the return values for, if not, we
    // need another cycle
    auto* ifTrueBlock  = iff->ifTrue->dynCast<Block>();
    auto* ifFalseBlock = iff->ifFalse->dynCast<Block>();
    if (!ifTrueBlock  || ifTrueBlock->list.size() == 0  || !ifTrueBlock->list.back()->is<Nop>() ||
        !ifFalseBlock || ifFalseBlock->list.size() == 0 || !ifFalseBlock->list.back()->is<Nop>()) {
      ifsToEnlarge.push_back(iff);
      return;
    }
    // all set, go
    auto *ifTrueItem = ifTrue.at(sharedIndex).item;
    ifTrueBlock->list[ifTrueBlock->list.size() - 1] = (*ifTrueItem)->cast<SetLocal>()->value;
    ExpressionManipulator::nop(*ifTrueItem);
    ifTrueBlock->finalize();
    assert(ifTrueBlock->type != none);
    auto *ifFalseItem = ifFalse.at(sharedIndex).item;
    ifFalseBlock->list[ifFalseBlock->list.size() - 1] = (*ifFalseItem)->cast<SetLocal>()->value;
    ExpressionManipulator::nop(*ifFalseItem);
    ifFalseBlock->finalize();
    assert(ifTrueBlock->type != none);
    iff->finalize(); // update type
    assert(iff->type != none);
    // finally, create a set_local on the iff itself
    auto* newSetLocal = Builder(*getModule()).makeSetLocal(sharedIndex, iff);
    *currp = newSetLocal;
    anotherCycle = true;
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(SimplifyLocals* self, Expression** currp) {
    self->pushTask(visitPost, currp);

    auto* curr = *currp;

    if (curr->is<If>() && curr->cast<If>()->ifFalse) {
      // handle if-elses in a special manner, using the ifStack
      self->pushTask(SimplifyLocals::doNoteIfElseFalse, currp);
      self->pushTask(SimplifyLocals::scan, &curr->cast<If>()->ifFalse);
      self->pushTask(SimplifyLocals::doNoteIfElseTrue, currp);
      self->pushTask(SimplifyLocals::scan, &curr->cast<If>()->ifTrue);
      self->pushTask(SimplifyLocals::doNoteIfElseCondition, currp);
      self->pushTask(SimplifyLocals::scan, &curr->cast<If>()->condition);
    } else {
      WalkerPass<LinearExecutionWalker<SimplifyLocals>>::scan(self, currp);
    }

    self->pushTask(visitPre, currp);
  }

  void doWalkFunction(Function* func) {
    // scan get_locals
    getCounter.analyze(func);
    // multiple passes may be required per function, consider this:
    //    x = load
    //    y = store
    //    c(x, y)
    // the load cannot cross the store, but y can be sunk, after which so can x.
    //
    // we start with a cycle focusing on single-use locals, which are easy to
    // sink (we don't need to put a set), and a good match for common compiler
    // output patterns. further cycles do fully general sinking.
    firstCycle = true;
    do {
      anotherCycle = false;
      // main operation
      WalkerPass<LinearExecutionWalker<SimplifyLocals>>::doWalkFunction(func);
      // enlarge blocks that were marked, for the next round
      if (blocksToEnlarge.size() > 0) {
        for (auto* block : blocksToEnlarge) {
          block->list.push_back(getModule()->allocator.alloc<Nop>());
        }
        blocksToEnlarge.clear();
        anotherCycle = true;
      }
      // enlarge ifs that were marked, for the next round
      if (ifsToEnlarge.size() > 0) {
        for (auto* iff : ifsToEnlarge) {
          auto ifTrue = Builder(*getModule()).blockify(iff->ifTrue);
          iff->ifTrue = ifTrue;
          if (ifTrue->list.size() == 0 || !ifTrue->list.back()->is<Nop>()) {
            ifTrue->list.push_back(getModule()->allocator.alloc<Nop>());
          }
          auto ifFalse = Builder(*getModule()).blockify(iff->ifFalse);
          iff->ifFalse = ifFalse;
          if (ifFalse->list.size() == 0 || !ifFalse->list.back()->is<Nop>()) {
            ifFalse->list.push_back(getModule()->allocator.alloc<Nop>());
          }
        }
        ifsToEnlarge.clear();
        anotherCycle = true;
      }
      // clean up
      sinkables.clear();
      blockBreaks.clear();
      unoptimizableBlocks.clear();
      if (firstCycle) {
        firstCycle = false;
        anotherCycle = true;
      }
    } while (anotherCycle);
    // Finally, after optimizing a function, we can see if we have set_locals
    // for a local with no remaining gets, in which case, we can
    // remove the set.
    // First, recount get_locals
    getCounter.analyze(func);
    // Second, remove unneeded sets
    SetLocalRemover remover;
    remover.numGetLocals = &getCounter.num;
    remover.walkFunction(func);
  }
};

Pass *createSimplifyLocalsPass() {
  return new SimplifyLocals(true, true);
}

Pass *createSimplifyLocalsNoTeePass() {
  return new SimplifyLocals(false, true);
}

Pass *createSimplifyLocalsNoStructurePass() {
  return new SimplifyLocals(true, false);
}

Pass *createSimplifyLocalsNoTeeNoStructurePass() {
  return new SimplifyLocals(false, false);
}

} // namespace wasm
