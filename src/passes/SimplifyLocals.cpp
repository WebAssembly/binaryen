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
// This pass has options:
//
//   * Tee: allow teeing, i.e., sinking a local with more than one use,
//          and so after sinking we have a tee for the first use.
//   * Structure: create block and if return values, by merging the
//                internal set_locals into one on the outside,
//                that can itself then be sunk further.
//
// There is also an option to disallow nesting entirely, which disallows
// Tee and Structure from those 2 options, and also disallows any sinking
// operation that would create nesting. This keeps the IR flat while
// removing redundant locals.
//

#include <wasm.h>
#include <wasm-builder.h>
#include <wasm-traversal.h>
#include <pass.h>
#include <ir/branch-utils.h>
#include <ir/count.h>
#include <ir/effects.h>
#include "ir/equivalent_sets.h"
#include <ir/find_all.h>
#include <ir/manipulation.h>

namespace wasm {

// Main class

template<bool allowTee = true, bool allowStructure = true, bool allowNesting = true>
struct SimplifyLocals : public WalkerPass<LinearExecutionWalker<SimplifyLocals<allowTee, allowStructure, allowNesting>>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new SimplifyLocals<allowTee, allowStructure, allowNesting>(); }

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

  static void doNoteNonLinear(SimplifyLocals<allowTee, allowStructure, allowNesting>* self, Expression** currp) {
    // Main processing.
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
      auto targets = BranchUtils::getUniqueTargets(sw);
      for (auto target : targets) {
        self->unoptimizableBlocks.insert(target);
      }
      // TODO: we could use this info to stop gathering data on these blocks
    }
    self->sinkables.clear();
  }

  static void doNoteIfElseCondition(SimplifyLocals<allowTee, allowStructure, allowNesting>* self, Expression** currp) {
    // we processed the condition of this if-else, and now control flow branches
    // into either the true or the false sides
    assert((*currp)->cast<If>()->ifFalse);
    self->sinkables.clear();
  }

  static void doNoteIfElseTrue(SimplifyLocals<allowTee, allowStructure, allowNesting>* self, Expression** currp) {
    // we processed the ifTrue side of this if-else, save it on the stack
    assert((*currp)->cast<If>()->ifFalse);
    self->ifStack.push_back(std::move(self->sinkables));
  }

  static void doNoteIfElseFalse(SimplifyLocals<allowTee, allowStructure, allowNesting>* self, Expression** currp) {
    // we processed the ifFalse side of this if-else, we can now try to
    // mere with the ifTrue side and optimize a return value, if possible
    auto* iff = (*currp)->cast<If>();
    assert(iff->ifFalse);
    if (allowStructure) {
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

  void visitLoop(Loop* curr) {
    if (allowStructure) {
      if (canUseLoopReturnValue(curr)) {
        loops.push_back(this->getCurrentPointer());
      }
    }
  }

  void visitGetLocal(GetLocal *curr) {
    auto found = sinkables.find(curr->index);
    if (found != sinkables.end()) {
      auto* set = (*found->second.item)->template cast<SetLocal>(); // the set we may be sinking
      bool oneUse = firstCycle || getCounter.num[curr->index] == 1;
      auto* get = set->value->template dynCast<GetLocal>(); // the set's value may be a get (i.e., the set is a copy)
      // if nesting is not allowed, and this might cause nesting, check if the sink would cause such a thing
      if (!allowNesting) {
        // a get is always ok to sink
        if (!get) {
          assert(expressionStack.size() >= 2);
          assert(expressionStack[expressionStack.size() - 1] == curr);
          auto* parent = expressionStack[expressionStack.size() - 2];
          bool parentIsSet = parent->template is<SetLocal>();
          // if the parent of this get is a set, we can sink into the set's value,
          // it would not be nested.
          if (!parentIsSet) {
            return;
          }
        }
      }
      // we can optimize here
      if (!allowNesting && get && !oneUse) {
        // if we can't nest 's a copy with multiple uses, then we can't create
        // a tee, and we can't nop the origin, but we can at least switch to
        // the copied index, which may make the origin unneeded eventually.
        curr->index = get->index;
        anotherCycle = true;
        return;
      }
      // sink it, and nop the origin
      if (oneUse) {
        // with just one use, we can sink just the value
        this->replaceCurrent(set->value);
      } else {
        this->replaceCurrent(set);
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
      this->replaceCurrent(set);
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

  // a full expression stack is used when !allowNesting, so that we can check if
  // a sink would cause nesting
  std::vector<Expression*> expressionStack;

  static void visitPre(SimplifyLocals<allowTee, allowStructure, allowNesting>* self, Expression** currp) {
    Expression* curr = *currp;

    EffectAnalyzer effects(self->getPassOptions());
    if (effects.checkPre(curr)) {
      self->checkInvalidations(effects);
    }

    if (!allowNesting) {
      self->expressionStack.push_back(curr);
    }
  }

  static void visitPost(SimplifyLocals<allowTee, allowStructure, allowNesting>* self, Expression** currp) {
    // perform main SetLocal processing here, since we may be the result of
    // replaceCurrent, i.e., the visitor was not called.
    auto* set = (*currp)->dynCast<SetLocal>();

    if (set) {
      // if we see a set that was already potentially-sinkable, then the previous
      // store is dead, leave just the value
      auto found = self->sinkables.find(set->index);
      if (found != self->sinkables.end()) {
        auto* previous = (*found->second.item)->template cast<SetLocal>();
        assert(!previous->isTee());
        auto* previousValue = previous->value;
        Drop* drop = ExpressionManipulator::convert<SetLocal, Drop>(previous);
        drop->value = previousValue;
        drop->finalize();
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

    if (!allowNesting) {
      self->expressionStack.pop_back();
    }
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
  std::vector<Expression**> loops;

  void optimizeBlockReturn(Block* block) {
    if (!block->name.is() || unoptimizableBlocks.count(block->name) > 0) {
      return;
    }
    auto breaks = std::move(blockBreaks[block->name]);
    blockBreaks.erase(block->name);
    if (breaks.size() == 0) return; // block has no branches TODO we might optimize trivial stuff here too
    assert(!(*breaks[0].brp)->template cast<Break>()->value); // block does not already have a return value (if one break has one, they all do)
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
    // If one of our brs is a br_if, then we will give it a value. since
    // the value executes before the condition, it is dangerous if we are
    // moving code out of the condition,
    //  (br_if
    //   (block
    //    ..use $x..
    //    (set_local $x ..)
    //   )
    //  )
    // =>
    //  (br_if
    //   (tee_local $x ..) ;; this now affects the use!
    //   (block
    //    ..use $x..
    //   )
    //  )
    // so we must check for that.
    for (size_t j = 0; j < breaks.size(); j++) {
      // move break set_local's value to the break
      auto* breakSetLocalPointer = breaks[j].sinkables.at(sharedIndex).item;
      auto* brp = breaks[j].brp;
      auto* br = (*brp)->template cast<Break>();
      auto* set = (*breakSetLocalPointer)->template cast<SetLocal>();
      if (br->condition) {
        // TODO: optimize
        FindAll<SetLocal> findAll(br->condition);
        for (auto* otherSet : findAll.list) {
          if (otherSet == set) {
            // the set is indeed in the condition, so we can't just move it
            // but maybe there are no effects? see if, ignoring the set
            // itself, there is any risk
            Nop nop;
            *breakSetLocalPointer = &nop;
            EffectAnalyzer condition(this->getPassOptions(), br->condition);
            EffectAnalyzer value(this->getPassOptions(), set);
            *breakSetLocalPointer = set;
            if (condition.invalidates(value)) {
              // indeed, we can't do this, stop
              return;
            }
            break; // we found set in the list, can stop now
          }
        }
      }
    }
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
    auto* value = (*blockSetLocalPointer)->template cast<SetLocal>()->value;
    block->list[block->list.size() - 1] = value;
    block->type = value->type;
    ExpressionManipulator::nop(*blockSetLocalPointer);
    for (size_t j = 0; j < breaks.size(); j++) {
      // move break set_local's value to the break
      auto* breakSetLocalPointer = breaks[j].sinkables.at(sharedIndex).item;
      auto* brp = breaks[j].brp;
      auto* br = (*brp)->template cast<Break>();
      assert(!br->value);
      // if the break is conditional, then we must set the value here - if the break is not reached, we must still have the new value in the local
      auto* set = (*breakSetLocalPointer)->template cast<SetLocal>();
      if (br->condition) {
        br->value = set;
        set->setTee(true);
        *breakSetLocalPointer = this->getModule()->allocator.template alloc<Nop>();
        // in addition, as this is a conditional br that now has a value, it now returns a value, so it must be dropped
        br->finalize();
        *brp = Builder(*this->getModule()).makeDrop(br);
      } else {
        br->value = set->value;
        ExpressionManipulator::nop(set);
      }
    }
    // finally, create a set_local on the block itself
    auto* newSetLocal = Builder(*this->getModule()).makeSetLocal(sharedIndex, block);
    this->replaceCurrent(newSetLocal);
    sinkables.clear();
    anotherCycle = true;
  }

  // optimize set_locals from both sides of an if into a return value
  void optimizeIfReturn(If* iff, Expression** currp, Sinkables& ifTrue) {
    assert(iff->ifFalse);
    // if this if already has a result, or is unreachable code, we have
    // nothing to do
    if (iff->type != none) return;
    // We now have the sinkables from both sides of the if, and can look
    // for something to sink. That is either a shared index on both sides,
    // *or* if one side is unreachable, we can sink anything from the other,
    //   (if
    //     (..)
    //     (br $x)
    //     (set_local $y (..))
    //   )
    //    =>
    //   (set_local $y
    //     (if (result i32)
    //       (..)
    //       (br $x)
    //       (..)
    //     )
    //   )
    Sinkables& ifFalse = sinkables;
    Index goodIndex = -1;
    bool found = false;
    if (iff->ifTrue->type == unreachable) {
      assert(iff->ifFalse->type != unreachable); // since the if type is none
      if (!ifFalse.empty()) {
        goodIndex = ifFalse.begin()->first;
        found = true;
      }
    } else if (iff->ifFalse->type == unreachable) {
      assert(iff->ifTrue->type != unreachable); // since the if type is none
      if (!ifTrue.empty()) {
        goodIndex = ifTrue.begin()->first;
        found = true;
      }
    } else {
      // Look for a shared index.
      for (auto& sinkable : ifTrue) {
        Index index = sinkable.first;
        if (ifFalse.count(index) > 0) {
          goodIndex = index;
          found = true;
          break;
        }
      }
    }
    if (!found) return;
    // great, we can optimize!
    // ensure we have a place to write the return values for, if not, we
    // need another cycle
    auto* ifTrueBlock  = iff->ifTrue->dynCast<Block>();
    if (iff->ifTrue->type != unreachable) {
      if (!ifTrueBlock  || ifTrueBlock->list.size() == 0  || !ifTrueBlock->list.back()->is<Nop>()) {
        ifsToEnlarge.push_back(iff);
        return;
      }
    }
    auto* ifFalseBlock = iff->ifFalse->dynCast<Block>();
    if (iff->ifFalse->type != unreachable) {
      if (!ifFalseBlock  || ifFalseBlock->list.size() == 0  || !ifFalseBlock->list.back()->is<Nop>()) {
        ifsToEnlarge.push_back(iff);
        return;
      }
    }
    // all set, go
    if (iff->ifTrue->type != unreachable) {
      auto *ifTrueItem = ifTrue.at(goodIndex).item;
      ifTrueBlock->list[ifTrueBlock->list.size() - 1] = (*ifTrueItem)->template cast<SetLocal>()->value;
      ExpressionManipulator::nop(*ifTrueItem);
      ifTrueBlock->finalize();
      assert(ifTrueBlock->type != none);
    }
    if (iff->ifFalse->type != unreachable) {
      auto *ifFalseItem = ifFalse.at(goodIndex).item;
      ifFalseBlock->list[ifFalseBlock->list.size() - 1] = (*ifFalseItem)->template cast<SetLocal>()->value;
      ExpressionManipulator::nop(*ifFalseItem);
      ifFalseBlock->finalize();
      assert(ifFalseBlock->type != none);
    }
    iff->finalize(); // update type
    assert(iff->type != none);
    // finally, create a set_local on the iff itself
    auto* newSetLocal = Builder(*this->getModule()).makeSetLocal(goodIndex, iff);
    *currp = newSetLocal;
    anotherCycle = true;
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(SimplifyLocals<allowTee, allowStructure, allowNesting>* self, Expression** currp) {
    self->pushTask(visitPost, currp);

    auto* curr = *currp;

    if (curr->is<If>() && curr->cast<If>()->ifFalse) {
      // handle if-elses in a special manner, using the ifStack
      self->pushTask(SimplifyLocals<allowTee, allowStructure, allowNesting>::doNoteIfElseFalse, currp);
      self->pushTask(SimplifyLocals<allowTee, allowStructure, allowNesting>::scan, &curr->cast<If>()->ifFalse);
      self->pushTask(SimplifyLocals<allowTee, allowStructure, allowNesting>::doNoteIfElseTrue, currp);
      self->pushTask(SimplifyLocals<allowTee, allowStructure, allowNesting>::scan, &curr->cast<If>()->ifTrue);
      self->pushTask(SimplifyLocals<allowTee, allowStructure, allowNesting>::doNoteIfElseCondition, currp);
      self->pushTask(SimplifyLocals<allowTee, allowStructure, allowNesting>::scan, &curr->cast<If>()->condition);
    } else {
      WalkerPass<LinearExecutionWalker<SimplifyLocals<allowTee, allowStructure, allowNesting>>>::scan(self, currp);
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
      anotherCycle = runMainOptimizations(func);
      // After the special first cycle, definitely do another.
      if (firstCycle) {
        firstCycle = false;
        anotherCycle = true;
      }
      // If we are all done, run the final optimizations, which may suggest we
      // can do more work.
      if (!anotherCycle) {
        // Don't run multiple cycles of just the final optimizations - in
        // particular, get canonicalization is not guaranteed to converge.
        // Instead, if final opts help then see if they enable main
        // opts; continue only if they do. In other words, do not end up
        // doing final opts again and again when no main opts are being
        // enabled.
        if (runFinalOptimizations(func) && runMainOptimizations(func)) {
          anotherCycle = true;
        }
      }
    } while (anotherCycle);
  }

  bool runMainOptimizations(Function* func) {
    anotherCycle = false;
    WalkerPass<LinearExecutionWalker<SimplifyLocals<allowTee, allowStructure, allowNesting>>>::doWalkFunction(func);
    // enlarge blocks that were marked, for the next round
    if (blocksToEnlarge.size() > 0) {
      for (auto* block : blocksToEnlarge) {
        block->list.push_back(this->getModule()->allocator.template alloc<Nop>());
      }
      blocksToEnlarge.clear();
      anotherCycle = true;
    }
    // enlarge ifs that were marked, for the next round
    if (ifsToEnlarge.size() > 0) {
      for (auto* iff : ifsToEnlarge) {
        auto ifTrue = Builder(*this->getModule()).blockify(iff->ifTrue);
        iff->ifTrue = ifTrue;
        if (ifTrue->list.size() == 0 || !ifTrue->list.back()->template is<Nop>()) {
          ifTrue->list.push_back(this->getModule()->allocator.template alloc<Nop>());
        }
        auto ifFalse = Builder(*this->getModule()).blockify(iff->ifFalse);
        iff->ifFalse = ifFalse;
        if (ifFalse->list.size() == 0 || !ifFalse->list.back()->template is<Nop>()) {
          ifFalse->list.push_back(this->getModule()->allocator.template alloc<Nop>());
        }
      }
      ifsToEnlarge.clear();
      anotherCycle = true;
    }
    // handle loops. note that a lot happens in this pass, and we can't just modify
    // set_locals when we see a loop - it might be tracked - and we can't also just
    // assume our loop didn't move either (might be in a block now). So we do this
    // when all other work is done - as loop return values are rare, that is fine.
    if (!anotherCycle) {
      for (auto* currp : loops) {
        auto* curr = (*currp)->template cast<Loop>();
        assert(canUseLoopReturnValue(curr));
        auto* set = curr->body->template cast<SetLocal>();
        curr->body = set->value;
        set->value = curr;
        curr->finalize(curr->body->type);
        *currp = set;
        anotherCycle = true;
      }
    }
    loops.clear();
    // clean up
    sinkables.clear();
    blockBreaks.clear();
    unoptimizableBlocks.clear();
    return anotherCycle;
  }

  bool runFinalOptimizations(Function* func) {
    // Finally, after optimizing a function we can do some additional
    // optimization.
    getCounter.analyze(func);
    // Remove equivalent copies - assignment of
    // a local to another local that already contains that value. Note that
    // we do that at the very end, and only after structure, as removing
    // the copy here:
    //   (if
    //    (get_local $var$0)
    //    (set_local $var$0
    //     (get_local $var$0)
    //    )
    //    (set_local $var$0
    //     (i32.const 208)
    //    )
    //   )
    // will inhibit us creating an if return value.
    struct EquivalentOptimizer : public LinearExecutionWalker<EquivalentOptimizer> {
      std::vector<Index>* numGetLocals;
      bool removeEquivalentSets;
      Module* module;

      bool anotherCycle = false;

      // We track locals containing the same value.
      EquivalentSets equivalences;

      static void doNoteNonLinear(EquivalentOptimizer* self, Expression** currp) {
        // TODO do this across non-linear paths too, in coalesce-locals perhaps? (would inhibit structure
        //      opts here, though.
        self->equivalences.clear();
      }

      void visitSetLocal(SetLocal *curr) {
        // Remove trivial copies, even through a tee
        auto* value = curr->value;
        while (auto* subSet = value->dynCast<SetLocal>()) {
          value = subSet->value;
        }
        if (auto* get = value->dynCast<GetLocal>()) {
          if (equivalences.check(curr->index, get->index)) {
            // This is an unnecessary copy!
            if (removeEquivalentSets) {
              if (curr->isTee()) {
                this->replaceCurrent(curr->value);
              } else {
                this->replaceCurrent(Builder(*module).makeDrop(curr->value));
              }
              anotherCycle = true;
            }
          } else {
            // There is a new equivalence now.
            equivalences.reset(curr->index);
            equivalences.add(curr->index, get->index);
          }
        } else {
          // A new value is assigned here.
          equivalences.reset(curr->index);
        }
      }

      void visitGetLocal(GetLocal *curr) {
        // Canonicalize gets: if some are equivalent, then we can pick more
        // then one, and other passes may benefit from having more uniformity.
        if (auto* set = equivalences.getEquivalents(curr->index)) {
          // Pick the index with the most uses - maximizing the chance to
          // lower one's uses to zero.
          // Helper method that returns the # of gets *ignoring the current get*,
          // as we want to see what is best overall, treating this one as
          // to be decided upon.
          auto getNumGetsIgnoringCurr = [&](Index index) {
            auto ret = (*numGetLocals)[index];
            if (index == curr->index) {
              assert(ret >= 1);
              ret--;
            }
            return ret;
          };
          Index best = -1;
          for (auto index : *set) {
            if (best == Index(-1) ||
                getNumGetsIgnoringCurr(index) > getNumGetsIgnoringCurr(best)) {
              best = index;
            }
          }
          assert(best != Index(-1));
          // Due to ordering, the best index may be different from us but have
          // the same # of locals - make sure we actually improve.
          if (best != curr->index &&
              getNumGetsIgnoringCurr(best) > getNumGetsIgnoringCurr(curr->index)) {
            // Update the get counts.
            (*numGetLocals)[best]++;
            assert((*numGetLocals)[curr->index] >= 1);
            (*numGetLocals)[curr->index]--;
            // Make the change.
            curr->index = best;
            anotherCycle = true;
          }
        }
      }
    };

    EquivalentOptimizer eqOpter;
    eqOpter.module = this->getModule();
    eqOpter.numGetLocals = &getCounter.num;
    eqOpter.removeEquivalentSets = allowStructure;
    eqOpter.walkFunction(func);

    // We may have already had a local with no uses, or we may have just
    // gotten there thanks to the EquivalentOptimizer. If there are such
    // locals, remove all their sets.
    struct UneededSetRemover : public PostWalker<UneededSetRemover> {
      std::vector<Index>* numGetLocals;

      bool anotherCycle = false;

      void visitSetLocal(SetLocal *curr) {
        if ((*numGetLocals)[curr->index] == 0) {
          auto* value = curr->value;
          if (curr->isTee()) {
            this->replaceCurrent(value);
          } else {
            Drop* drop = ExpressionManipulator::convert<SetLocal, Drop>(curr);
            drop->value = value;
            drop->finalize();
          }
          anotherCycle = true;
        }
      }
    };

    UneededSetRemover setRemover;
    setRemover.numGetLocals = &getCounter.num;
    setRemover.walkFunction(func);

    return eqOpter.anotherCycle || setRemover.anotherCycle;
  }

  bool canUseLoopReturnValue(Loop* curr) {
    // Optimizing a loop return value is trivial: just see if it contains
    // a set_local, and pull that out.
    if (auto* set = curr->body->template dynCast<SetLocal>()) {
      if (isConcreteType(set->value->type)) {
        return true;
      }
    }
    return false;
  }
};

Pass *createSimplifyLocalsPass() {
  return new SimplifyLocals<true, true>();
}

Pass *createSimplifyLocalsNoTeePass() {
  return new SimplifyLocals<false, true>();
}

Pass *createSimplifyLocalsNoStructurePass() {
  return new SimplifyLocals<true, false>();
}

Pass *createSimplifyLocalsNoTeeNoStructurePass() {
  return new SimplifyLocals<false, false>();
}

Pass *createSimplifyLocalsNoNestingPass() {
  return new SimplifyLocals<false, false, false>();
}

} // namespace wasm
