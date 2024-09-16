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
// This "sinks" local.sets, pushing them to the next local.get where possible,
// and removing the set if there are no gets remaining (the latter is
// particularly useful in ssa mode, but not only).
//
// We also note where local.sets coalesce: if all breaks of a block set
// a specific local, we can use a block return value for it, in effect
// removing multiple local.sets and replacing them with one that the
// block returns to. Further optimization rounds then have the opportunity
// to remove that local.set as well. TODO: support partial traces; right
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
//                internal local.sets into one on the outside,
//                that can itself then be sunk further.
//
// There is also an option to disallow nesting entirely, which disallows
// Tee and Structure from those 2 options, and also disallows any sinking
// operation that would create nesting. This keeps the IR flat while
// removing redundant locals.
//

#include "ir/equivalent_sets.h"
#include <ir/branch-utils.h>
#include <ir/effects.h>
#include <ir/find_all.h>
#include <ir/linear-execution.h>
#include <ir/local-utils.h>
#include <ir/manipulation.h>
#include <ir/utils.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm-traversal.h>
#include <wasm.h>

namespace wasm {

// Main class

template<bool allowTee = true,
         bool allowStructure = true,
         bool allowNesting = true>
struct SimplifyLocals
  : public WalkerPass<LinearExecutionWalker<
      SimplifyLocals<allowTee, allowStructure, allowNesting>>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<
      SimplifyLocals<allowTee, allowStructure, allowNesting>>();
  }

  // information for a local.set we can sink
  struct SinkableInfo {
    Expression** item;
    EffectAnalyzer effects;

    SinkableInfo(Expression** item, PassOptions& passOptions, Module& module)
      : item(item), effects(passOptions, module, *item) {}
  };

  // a list of sinkables in a linear execution trace
  using Sinkables = std::map<Index, SinkableInfo>;

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

  // local => # of local.gets for it
  LocalGetCounter getCounter;

  // In rare cases we make a change to a type that requires a refinalize.
  bool refinalize = false;

  static void
  doNoteNonLinear(SimplifyLocals<allowTee, allowStructure, allowNesting>* self,
                  Expression** currp) {
    // Main processing.
    auto* curr = *currp;
    if (auto* br = curr->dynCast<Break>()) {
      if (br->value) {
        // value means the block already has a return value
        self->unoptimizableBlocks.insert(br->name);
      } else {
        self->blockBreaks[br->name].push_back(
          {currp, std::move(self->sinkables)});
      }
    } else if (curr->is<Block>()) {
      return; // handled in visitBlock
    } else if (curr->is<If>()) {
      assert(!curr->cast<If>()
                ->ifFalse); // if-elses are handled by doNoteIf* methods
    } else {
      // Not one of the recognized instructions, so do not optimize here: mark
      // all the targets as unoptimizable.
      // TODO optimize BrOn, Switch, etc.
      auto targets = BranchUtils::getUniqueTargets(curr);
      for (auto target : targets) {
        self->unoptimizableBlocks.insert(target);
      }
      // TODO: we could use this info to stop gathering data on these blocks
    }
    self->sinkables.clear();
  }

  static void doNoteIfCondition(
    SimplifyLocals<allowTee, allowStructure, allowNesting>* self,
    Expression** currp) {
    // we processed the condition of this if-else, and now control flow branches
    // into either the true or the false sides
    self->sinkables.clear();
  }

  static void
  doNoteIfTrue(SimplifyLocals<allowTee, allowStructure, allowNesting>* self,
               Expression** currp) {
    auto* iff = (*currp)->cast<If>();
    if (iff->ifFalse) {
      // We processed the ifTrue side of this if-else, save it on the stack.
      self->ifStack.push_back(std::move(self->sinkables));
    } else {
      // This is an if without an else.
      if (allowStructure) {
        self->optimizeIfReturn(iff, currp);
      }
      self->sinkables.clear();
    }
  }

  static void
  doNoteIfFalse(SimplifyLocals<allowTee, allowStructure, allowNesting>* self,
                Expression** currp) {
    // we processed the ifFalse side of this if-else, we can now try to
    // mere with the ifTrue side and optimize a return value, if possible
    auto* iff = (*currp)->cast<If>();
    assert(iff->ifFalse);
    if (allowStructure) {
      self->optimizeIfElseReturn(iff, currp, self->ifStack.back());
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
      optimizeLoopReturn(curr);
    }
  }

  void optimizeLocalGet(LocalGet* curr) {
    auto found = sinkables.find(curr->index);
    if (found != sinkables.end()) {
      auto* set = (*found->second.item)
                    ->template cast<LocalSet>(); // the set we may be sinking
      bool oneUse = firstCycle || getCounter.num[curr->index] == 1;
      // the set's value may be a get (i.e., the set is a copy)
      auto* get = set->value->template dynCast<LocalGet>();
      // if nesting is not allowed, and this might cause nesting, check if the
      // sink would cause such a thing
      if (!allowNesting) {
        // a get is always ok to sink
        if (!get) {
          assert(expressionStack.size() >= 2);
          assert(expressionStack[expressionStack.size() - 1] == curr);
          auto* parent = expressionStack[expressionStack.size() - 2];
          bool parentIsSet = parent->template is<LocalSet>();
          // if the parent of this get is a set, we can sink into the set's
          // value, it would not be nested.
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

        // We are replacing a local.get with the value of the local.set. That
        // may require a refinalize in certain cases, like this:
        //
        //  (struct.get $X 0
        //    (local.get $x)
        //  )
        //
        // If we replace the local.get with a more refined type then the
        // struct.get may read a more refined type (if the subtype has a more
        // refined type for that particular field). Note that this cannot happen
        // in the other arm of this if-else, where we replace the local.get with
        // a tee, since tees have the type of the local, so no types change
        // there.
        if (set->value->type != curr->type) {
          refinalize = true;
        }
      } else {
        this->replaceCurrent(set);
        assert(!set->isTee());
        set->makeTee(this->getFunction()->getLocalType(set->index));
      }
      // reuse the local.get that is dying
      *found->second.item = curr;
      ExpressionManipulator::nop(curr);
      sinkables.erase(found);
      anotherCycle = true;
    }
  }

  void visitDrop(Drop* curr) {
    // collapse drop-tee into set, which can occur if a get was sunk into a tee
    auto* set = curr->value->dynCast<LocalSet>();
    if (set) {
      assert(set->isTee());
      set->makeSet();
      this->replaceCurrent(set);
    }
  }

  void checkInvalidations(EffectAnalyzer& effects) {
    // TODO: this is O(bad)
    std::vector<Index> invalidated;
    for (auto& [index, info] : sinkables) {
      if (effects.invalidates(info.effects)) {
        invalidated.push_back(index);
      }
    }
    for (auto index : invalidated) {
      sinkables.erase(index);
    }
  }

  // a full expression stack is used when !allowNesting, so that we can check if
  // a sink would cause nesting
  ExpressionStack expressionStack;

  static void
  visitPre(SimplifyLocals<allowTee, allowStructure, allowNesting>* self,
           Expression** currp) {
    Expression* curr = *currp;

    // Certain expressions cannot be sinked into 'try'/'try_table', and so at
    // the start of 'try'/'try_table' we forget about them.
    if (curr->is<Try>() || curr->is<TryTable>()) {
      std::vector<Index> invalidated;
      for (auto& [index, info] : self->sinkables) {
        // Expressions that may throw cannot be moved into a try (which might
        // catch them, unlike before the move).
        if (info.effects.throws()) {
          invalidated.push_back(index);
          continue;
        }
      }
      for (auto index : invalidated) {
        self->sinkables.erase(index);
      }
    }

    EffectAnalyzer effects(self->getPassOptions(), *self->getModule());
    if (effects.checkPre(curr)) {
      self->checkInvalidations(effects);
    }

    if (!allowNesting) {
      self->expressionStack.push_back(curr);
    }
  }

  static void
  visitPost(SimplifyLocals<allowTee, allowStructure, allowNesting>* self,
            Expression** currp) {
    // Handling invalidations in the case where the current node is a get
    // that we sink into is not trivial in general. In the simple case,
    // all current sinkables are compatible with each other (otherwise one
    // would have invalidated a previous one, and removed it). Given that, if
    // we sink one of the sinkables, then that new code cannot invalidate any
    // other sinkable - we've already compared them. However, a tricky case
    // is when a sinkable contains another sinkable,
    //
    //  (local.set $x
    //   (block (result i32)
    //    (A (local.get $y))
    //    (local.set $y B)
    //   )
    //  )
    //  (C (local.get $y))
    //  (D (local.get $x))
    //
    // If we sink the set of $y, we have
    //
    //  (local.set $x
    //   (block (result i32)
    //    (A (local.get $y))
    //    (nop)
    //   )
    //  )
    //  (C B)
    //  (D (local.get $x))
    //
    // There is now a risk that the set of $x should be invalidated, because
    // if we sink it then A may happen after B (imagine that B contains
    // something dangerous for that). To verify the risk, we could recursively
    // scan all of B, but that is less efficient. Instead, the key thing is
    // that if we sink out an inner part of a set, we should just leave further
    // work on it to a later iteration. This is achieved by checking for
    // invalidation on the original node, the local.get $y, which is guaranteed
    // to invalidate the parent whose inner part was removed (since the inner
    // part has a set, and the original node is a get of that same local).
    //
    // To implement this, if the current node is a get, note it and use it
    // for invalidations later down. We must note it since optimizing the get
    // may perform arbitrary changes to the graph, including reuse the get.

    Expression* original = *currp;

    LocalGet originalGet;

    if (auto* get = (*currp)->dynCast<LocalGet>()) {
      // Note: no visitor for LocalGet, so that we can handle it here.
      originalGet = *get;
      original = &originalGet;
      self->optimizeLocalGet(get);
    }

    // perform main LocalSet processing here, since we may be the result of
    // replaceCurrent, i.e., no visitor for LocalSet, like LocalGet above.
    auto* set = (*currp)->dynCast<LocalSet>();

    if (set) {
      // if we see a set that was already potentially-sinkable, then the
      // previous store is dead, leave just the value
      auto found = self->sinkables.find(set->index);
      if (found != self->sinkables.end()) {
        auto* previous = (*found->second.item)->template cast<LocalSet>();
        assert(!previous->isTee());
        auto* previousValue = previous->value;
        Drop* drop = ExpressionManipulator::convert<LocalSet, Drop>(previous);
        drop->value = previousValue;
        drop->finalize();
        self->sinkables.erase(found);
        self->anotherCycle = true;
      }
    }

    EffectAnalyzer effects(self->getPassOptions(), *self->getModule());
    if (effects.checkPost(original)) {
      self->checkInvalidations(effects);
    }

    if (set && self->canSink(set)) {
      Index index = set->index;
      assert(self->sinkables.count(index) == 0);
      self->sinkables.emplace(std::pair{
        index,
        SinkableInfo(currp, self->getPassOptions(), *self->getModule())});
    }

    if (!allowNesting) {
      self->expressionStack.pop_back();
    }
  }

  bool canSink(LocalSet* set) {
    // we can never move a tee
    if (set->isTee()) {
      return false;
    }
    // We cannot move expressions containing pops that are not enclosed in
    // 'catch', because 'pop' should follow right after 'catch'.
    FeatureSet features = this->getModule()->features;
    if (features.hasExceptionHandling() &&
        EffectAnalyzer(this->getPassOptions(), *this->getModule(), set->value)
          .danglingPop) {
      return false;
    }
    // if in the first cycle, or not allowing tees, then we cannot sink if >1
    // use as that would make a tee
    if ((firstCycle || !allowTee) && getCounter.num[set->index] > 1) {
      return false;
    }
    return true;
  }

  std::vector<Block*> blocksToEnlarge;
  std::vector<If*> ifsToEnlarge;
  std::vector<Loop*> loopsToEnlarge;

  void optimizeLoopReturn(Loop* loop) {
    // If there is a sinkable thing in an eligible loop, we can optimize
    // it in a trivial way to the outside of the loop.
    if (loop->type != Type::none) {
      return;
    }
    if (sinkables.empty()) {
      return;
    }
    Index goodIndex = sinkables.begin()->first;
    // Ensure we have a place to write the return values for, if not, we
    // need another cycle.
    auto* block = loop->body->dynCast<Block>();
    if (!block || block->name.is() || block->list.size() == 0 ||
        !block->list.back()->is<Nop>()) {
      loopsToEnlarge.push_back(loop);
      return;
    }
    Builder builder(*this->getModule());
    auto** item = sinkables.at(goodIndex).item;
    auto* set = (*item)->template cast<LocalSet>();
    block->list[block->list.size() - 1] = set->value;
    *item = builder.makeNop();
    block->finalize();
    assert(block->type != Type::none);
    loop->finalize();
    set->value = loop;
    set->finalize();
    this->replaceCurrent(set);
    // We moved things around, clear all tracking; we'll do another cycle
    // anyhow.
    sinkables.clear();
    anotherCycle = true;
  }

  void optimizeBlockReturn(Block* block) {
    if (!block->name.is() || unoptimizableBlocks.count(block->name) > 0) {
      return;
    }
    auto breaks = std::move(blockBreaks[block->name]);
    blockBreaks.erase(block->name);
    if (breaks.size() == 0) {
      // block has no branches TODO we might optimize trivial stuff here too
      return;
    }
    // block does not already have a return value (if one break has one, they
    // all do)
    assert(!(*breaks[0].brp)->template cast<Break>()->value);
    // look for a local.set that is present in them all
    bool found = false;
    Index sharedIndex = -1;
    for (auto& [index, _] : sinkables) {
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
    if (!found) {
      return;
    }
    // If one of our brs is a br_if, then we will give it a value. since
    // the value executes before the condition, it is dangerous if we are
    // moving code out of the condition,
    //  (br_if
    //   (block
    //    ..use $x..
    //    (local.set $x ..)
    //   )
    //  )
    // =>
    //  (br_if
    //   (local.tee $x ..) ;; this now affects the use!
    //   (block
    //    ..use $x..
    //   )
    //  )
    // so we must check for that.
    for (size_t j = 0; j < breaks.size(); j++) {
      // move break local.set's value to the break
      auto* breakLocalSetPointer = breaks[j].sinkables.at(sharedIndex).item;
      auto* brp = breaks[j].brp;
      auto* br = (*brp)->template cast<Break>();
      auto* set = (*breakLocalSetPointer)->template cast<LocalSet>();
      if (br->condition) {
        // TODO: optimize
        FindAll<LocalSet> findAll(br->condition);
        for (auto* otherSet : findAll.list) {
          if (otherSet == set) {
            // the set is indeed in the condition, so we can't just move it
            // but maybe there are no effects? see if, ignoring the set
            // itself, there is any risk
            Nop nop;
            *breakLocalSetPointer = &nop;
            EffectAnalyzer condition(
              this->getPassOptions(), *this->getModule(), br->condition);
            EffectAnalyzer value(
              this->getPassOptions(), *this->getModule(), set);
            *breakLocalSetPointer = set;
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
    // move block local.set's value to the end, in return position, and nop the
    // set
    auto* blockLocalSetPointer = sinkables.at(sharedIndex).item;
    auto* value = (*blockLocalSetPointer)->template cast<LocalSet>()->value;
    block->list[block->list.size() - 1] = value;
    ExpressionManipulator::nop(*blockLocalSetPointer);
    for (size_t j = 0; j < breaks.size(); j++) {
      // move break local.set's value to the break
      auto* breakLocalSetPointer = breaks[j].sinkables.at(sharedIndex).item;
      auto* brp = breaks[j].brp;
      auto* br = (*brp)->template cast<Break>();
      assert(!br->value);
      // if the break is conditional, then we must set the value here - if the
      // break is not reached, we must still have the new value in the local
      auto* set = (*breakLocalSetPointer)->template cast<LocalSet>();
      if (br->condition) {
        br->value = set;
        set->makeTee(this->getFunction()->getLocalType(set->index));
        *breakLocalSetPointer =
          this->getModule()->allocator.template alloc<Nop>();
        // in addition, as this is a conditional br that now has a value, it now
        // returns a value, so it must be dropped
        br->finalize();
        *brp = Builder(*this->getModule()).makeDrop(br);
      } else {
        br->value = set->value;
        ExpressionManipulator::nop(set);
      }
    }
    // finally, create a local.set on the block itself
    auto* newLocalSet =
      Builder(*this->getModule()).makeLocalSet(sharedIndex, block);
    this->replaceCurrent(newLocalSet);
    sinkables.clear();
    anotherCycle = true;
    block->finalize();
  }

  // optimize local.sets from both sides of an if into a return value
  void optimizeIfElseReturn(If* iff, Expression** currp, Sinkables& ifTrue) {
    assert(iff->ifFalse);
    // if this if already has a result, or is unreachable code, we have
    // nothing to do
    if (iff->type != Type::none) {
      return;
    }
    // We now have the sinkables from both sides of the if, and can look
    // for something to sink. That is either a shared index on both sides,
    // *or* if one side is unreachable, we can sink anything from the other,
    //   (if
    //     (..)
    //     (br $x)
    //     (local.set $y (..))
    //   )
    //    =>
    //   (local.set $y
    //     (if (result i32)
    //       (..)
    //       (br $x)
    //       (..)
    //     )
    //   )
    Sinkables& ifFalse = sinkables;
    Index goodIndex = -1;
    bool found = false;
    if (iff->ifTrue->type == Type::unreachable) {
      // since the if type is none
      assert(iff->ifFalse->type != Type::unreachable);
      if (!ifFalse.empty()) {
        goodIndex = ifFalse.begin()->first;
        found = true;
      }
    } else if (iff->ifFalse->type == Type::unreachable) {
      // since the if type is none
      assert(iff->ifTrue->type != Type::unreachable);
      if (!ifTrue.empty()) {
        goodIndex = ifTrue.begin()->first;
        found = true;
      }
    } else {
      // Look for a shared index.
      for (auto& [index, _] : ifTrue) {
        if (ifFalse.count(index) > 0) {
          goodIndex = index;
          found = true;
          break;
        }
      }
    }
    if (!found) {
      return;
    }
    // great, we can optimize!
    // ensure we have a place to write the return values for, if not, we
    // need another cycle
    auto* ifTrueBlock = iff->ifTrue->dynCast<Block>();
    if (iff->ifTrue->type != Type::unreachable) {
      if (!ifTrueBlock || ifTrueBlock->name.is() ||
          ifTrueBlock->list.size() == 0 ||
          !ifTrueBlock->list.back()->is<Nop>()) {
        ifsToEnlarge.push_back(iff);
        return;
      }
    }
    auto* ifFalseBlock = iff->ifFalse->dynCast<Block>();
    if (iff->ifFalse->type != Type::unreachable) {
      if (!ifFalseBlock || ifFalseBlock->name.is() ||
          ifFalseBlock->list.size() == 0 ||
          !ifFalseBlock->list.back()->is<Nop>()) {
        ifsToEnlarge.push_back(iff);
        return;
      }
    }
    // all set, go
    if (iff->ifTrue->type != Type::unreachable) {
      auto* ifTrueItem = ifTrue.at(goodIndex).item;
      ifTrueBlock->list[ifTrueBlock->list.size() - 1] =
        (*ifTrueItem)->template cast<LocalSet>()->value;
      ExpressionManipulator::nop(*ifTrueItem);
      ifTrueBlock->finalize();
      assert(ifTrueBlock->type != Type::none);
    }
    if (iff->ifFalse->type != Type::unreachable) {
      auto* ifFalseItem = ifFalse.at(goodIndex).item;
      ifFalseBlock->list[ifFalseBlock->list.size() - 1] =
        (*ifFalseItem)->template cast<LocalSet>()->value;
      ExpressionManipulator::nop(*ifFalseItem);
      ifFalseBlock->finalize();
      assert(ifFalseBlock->type != Type::none);
    }
    iff->finalize(); // update type
    assert(iff->type != Type::none);
    // finally, create a local.set on the iff itself
    auto* newLocalSet =
      Builder(*this->getModule()).makeLocalSet(goodIndex, iff);
    *currp = newLocalSet;
    anotherCycle = true;
  }

  // Optimize local.sets from a one-sided iff, adding a get on the other:
  //  (if
  //    (..condition..)
  //    (block
  //      (local.set $x (..value..))
  //    )
  //  )
  // =>
  //  (local.set $x
  //    (if (result ..)
  //      (..condition..)
  //      (block (result ..)
  //        (..value..)
  //      )
  //      (local.get $x)
  //    )
  //  )
  // This is a speculative optimization: we add a get here, as well as a branch
  // in the if, so this is harmful for code size and for speed. However, later
  // optimizations may sink the set and enable other useful things. If none of
  // that happens, other passes can "undo" this by turning an if with a copy
  // arm into a one-sided if.
  void optimizeIfReturn(If* iff, Expression** currp) {
    // If this if is unreachable code, we have nothing to do.
    if (iff->type != Type::none || iff->ifTrue->type != Type::none) {
      return;
    }
    // Anything sinkable is good for us.
    if (sinkables.empty()) {
      return;
    }

    // Check if the type makes sense. A non-nullable local might be dangerous
    // here, as creating new local.gets for such locals is risky:
    //
    //  (func $silly
    //    (local $x (ref $T))
    //    (if
    //      (condition)
    //      (local.set $x ..)
    //    )
    //  )
    //
    // That local is silly as the write is never read. If we optimize it and add
    // a local.get, however, then we'd no longer validate (as no set would
    // dominate that new get in the if's else arm). Fixups would add a
    // ref.as_non_null around the local.get, which will then trap at runtime:
    //
    //  (func $silly
    //    (local $x (ref null $T))
    //    (local.set $x
    //      (if
    //        (condition)
    //        (..)
    //        (ref.as_non_null
    //          (local.get $x)
    //        )
    //      )
    //    )
    //  )
    //
    // In other words, local.get is not necessarily free of effects if the local
    // is non-nullable - it must have been set already. We could check that
    // here, but running that linear-time check may not be worth it as this
    // optimization is fairly minor, so just skip the non-nullable case (and in
    // general, the non-defaultable case, of say a tuple with a non-nullable
    // element).
    //
    // TODO investigate more
    Index goodIndex = sinkables.begin()->first;
    auto localType = this->getFunction()->getLocalType(goodIndex);
    if (!localType.isDefaultable()) {
      return;
    }

    // Ensure we have a place to write the return values for, if not, we
    // need another cycle.
    auto* ifTrueBlock = iff->ifTrue->dynCast<Block>();
    if (!ifTrueBlock || ifTrueBlock->name.is() ||
        ifTrueBlock->list.size() == 0 || !ifTrueBlock->list.back()->is<Nop>()) {
      ifsToEnlarge.push_back(iff);
      return;
    }

    // We can optimize!

    // Update the ifTrue side.
    Builder builder(*this->getModule());
    auto** item = sinkables.at(goodIndex).item;
    auto* set = (*item)->template cast<LocalSet>();
    ifTrueBlock->list[ifTrueBlock->list.size() - 1] = set->value;
    *item = builder.makeNop();
    ifTrueBlock->finalize();
    assert(ifTrueBlock->type != Type::none);
    // Update the ifFalse side.
    iff->ifFalse = builder.makeLocalGet(set->index, localType);
    iff->finalize(); // update type
    // Update the get count.
    getCounter.num[set->index]++;
    assert(iff->type != Type::none);
    // Finally, reuse the local.set on the iff itself.
    set->value = iff;
    set->finalize();
    *currp = set;
    anotherCycle = true;
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(SimplifyLocals<allowTee, allowStructure, allowNesting>* self,
                   Expression** currp) {
    self->pushTask(visitPost, currp);

    auto* curr = *currp;

    if (auto* iff = curr->dynCast<If>()) {
      // handle if in a special manner, using the ifStack for if-elses etc.
      if (iff->ifFalse) {
        self->pushTask(
          SimplifyLocals<allowTee, allowStructure, allowNesting>::doNoteIfFalse,
          currp);
        self->pushTask(
          SimplifyLocals<allowTee, allowStructure, allowNesting>::scan,
          &iff->ifFalse);
      }
      self->pushTask(
        SimplifyLocals<allowTee, allowStructure, allowNesting>::doNoteIfTrue,
        currp);
      self->pushTask(
        SimplifyLocals<allowTee, allowStructure, allowNesting>::scan,
        &iff->ifTrue);
      self->pushTask(SimplifyLocals<allowTee, allowStructure, allowNesting>::
                       doNoteIfCondition,
                     currp);
      self->pushTask(
        SimplifyLocals<allowTee, allowStructure, allowNesting>::scan,
        &iff->condition);
    } else {
      WalkerPass<LinearExecutionWalker<
        SimplifyLocals<allowTee, allowStructure, allowNesting>>>::scan(self,
                                                                       currp);
    }

    self->pushTask(visitPre, currp);
  }

  void doWalkFunction(Function* func) {
    if (func->getNumLocals() == 0) {
      return; // nothing to do
    }
    // scan local.gets
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
        if (runLateOptimizations(func) && runMainOptimizations(func)) {
          anotherCycle = true;
        }
      }
    } while (anotherCycle);

    if (refinalize) {
      ReFinalize().walkFunctionInModule(func, this->getModule());
    }
  }

  bool runMainOptimizations(Function* func) {
    anotherCycle = false;
    WalkerPass<LinearExecutionWalker<
      SimplifyLocals<allowTee, allowStructure, allowNesting>>>::
      doWalkFunction(func);
    // enlarge blocks that were marked, for the next round
    if (blocksToEnlarge.size() > 0) {
      for (auto* block : blocksToEnlarge) {
        block->list.push_back(
          this->getModule()->allocator.template alloc<Nop>());
      }
      blocksToEnlarge.clear();
      anotherCycle = true;
    }
    // enlarge ifs that were marked, for the next round
    if (ifsToEnlarge.size() > 0) {
      for (auto* iff : ifsToEnlarge) {
        auto ifTrue =
          Builder(*this->getModule()).blockifyWithName(iff->ifTrue, Name());
        iff->ifTrue = ifTrue;
        if (ifTrue->list.size() == 0 ||
            !ifTrue->list.back()->template is<Nop>()) {
          ifTrue->list.push_back(
            this->getModule()->allocator.template alloc<Nop>());
        }
        if (iff->ifFalse) {
          auto ifFalse =
            Builder(*this->getModule()).blockifyWithName(iff->ifFalse, Name());
          iff->ifFalse = ifFalse;
          if (ifFalse->list.size() == 0 ||
              !ifFalse->list.back()->template is<Nop>()) {
            ifFalse->list.push_back(
              this->getModule()->allocator.template alloc<Nop>());
          }
        }
      }
      ifsToEnlarge.clear();
      anotherCycle = true;
    }
    // enlarge loops that were marked, for the next round
    if (loopsToEnlarge.size() > 0) {
      for (auto* loop : loopsToEnlarge) {
        auto block =
          Builder(*this->getModule()).blockifyWithName(loop->body, Name());
        loop->body = block;
        if (block->list.size() == 0 ||
            !block->list.back()->template is<Nop>()) {
          block->list.push_back(
            this->getModule()->allocator.template alloc<Nop>());
        }
      }
      loopsToEnlarge.clear();
      anotherCycle = true;
    }
    // clean up
    sinkables.clear();
    blockBreaks.clear();
    unoptimizableBlocks.clear();
    return anotherCycle;
  }

  bool runLateOptimizations(Function* func) {
    // Finally, after optimizing a function we can do some additional
    // optimization.
    getCounter.analyze(func);
    // Remove equivalent copies - assignment of
    // a local to another local that already contains that value. Note that
    // we do that at the very end, and only after structure, as removing
    // the copy here:
    //   (if
    //    (local.get $var$0)
    //    (local.set $var$0
    //     (local.get $var$0)
    //    )
    //    (local.set $var$0
    //     (i32.const 208)
    //    )
    //   )
    // will inhibit us creating an if return value.
    struct EquivalentOptimizer
      : public LinearExecutionWalker<EquivalentOptimizer> {

      // It is ok to look at adjacent blocks together, as if a later part of a
      // block is not reached that is fine - changes we make there would not be
      // reached in that case.
      bool connectAdjacentBlocks = true;

      std::vector<Index>* numLocalGets;
      bool removeEquivalentSets;
      PassOptions passOptions;

      bool anotherCycle = false;
      bool refinalize = false;

      // We track locals containing the same value.
      EquivalentSets equivalences;

      static void doNoteNonLinear(EquivalentOptimizer* self,
                                  Expression** currp) {
        // TODO do this across non-linear paths too, in coalesce-locals perhaps?
        //      (would inhibit structure opts here, though.
        self->equivalences.clear();
      }

      void visitLocalSet(LocalSet* curr) {
        auto* module = this->getModule();

        // Remove trivial copies, even through a tee
        auto* value =
          Properties::getFallthrough(curr->value, passOptions, *module);
        if (auto* get = value->template dynCast<LocalGet>()) {
          if (equivalences.check(curr->index, get->index)) {
            // This is an unnecessary copy!
            if (removeEquivalentSets) {
              if (curr->isTee()) {
                if (curr->value->type != curr->type) {
                  refinalize = true;
                }
                this->replaceCurrent(curr->value);
              } else {
                this->replaceCurrent(Builder(*module).makeDrop(curr->value));
              }
              anotherCycle = true;
            }
            // Nothing more to do, ignore the copy.
            return;
          } else {
            // There is a new equivalence now. Remove all the old ones, and add
            // the new one.
            equivalences.reset(curr->index);
            equivalences.add(curr->index, get->index);
            return;
          }
        }
        // A new value of some kind is assigned here, and it's not something we
        // could handle earlier, so remove all the old equivalent ones.
        equivalences.reset(curr->index);
      }

      void visitLocalGet(LocalGet* curr) {
        // Canonicalize gets: if some are equivalent, then we can pick more
        // then one, and other passes may benefit from having more uniformity.
        if (auto* set = equivalences.getEquivalents(curr->index)) {
          // Helper method that returns the # of gets *ignoring the current
          // get*, as we want to see what is best overall, treating this one as
          // to be decided upon.
          auto getNumGetsIgnoringCurr = [&](Index index) {
            auto ret = (*numLocalGets)[index];
            if (index == curr->index) {
              assert(ret >= 1);
              ret--;
            }
            return ret;
          };

          // Pick the index with the most uses - maximizing the chance to
          // lower one's uses to zero. If types differ though then we prefer to
          // switch to a more refined type even if there are fewer uses, as that
          // may have significant benefits to later optimizations (we may be
          // able to use it to remove casts, etc.).
          auto* func = this->getFunction();
          Index best = -1;
          for (auto index : *set) {
            if (best == Index(-1)) {
              // This is the first possible option we've seen.
              best = index;
              continue;
            }

            auto bestType = func->getLocalType(best);
            auto indexType = func->getLocalType(index);
            if (!Type::isSubType(indexType, bestType)) {
              // This is less refined than the current best; ignore.
              continue;
            }

            // This is better if it has a more refined type, or if it has more
            // uses.
            if (indexType != bestType ||
                getNumGetsIgnoringCurr(index) > getNumGetsIgnoringCurr(best)) {
              best = index;
            }
          }
          assert(best != Index(-1));
          // Due to ordering, the best index may be different from us but have
          // the same # of locals - make sure we actually improve, either adding
          // more gets, or a more refined type (and never change to a less
          // refined type).
          auto bestType = func->getLocalType(best);
          auto oldType = func->getLocalType(curr->index);
          if (best != curr->index && Type::isSubType(bestType, oldType)) {
            auto hasMoreGets = getNumGetsIgnoringCurr(best) >
                               getNumGetsIgnoringCurr(curr->index);
            if (hasMoreGets || bestType != oldType) {
              // Update the get counts.
              (*numLocalGets)[best]++;
              assert((*numLocalGets)[curr->index] >= 1);
              (*numLocalGets)[curr->index]--;
              // Make the change.
              curr->index = best;
              anotherCycle = true;
              if (bestType != oldType) {
                curr->type = func->getLocalType(best);
                // We are switching to a more refined type, which might require
                // changes in the user of the local.get.
                refinalize = true;
              }
            }
          }
        }
      }
    };

    EquivalentOptimizer eqOpter;
    eqOpter.passOptions = this->getPassOptions();
    eqOpter.numLocalGets = &getCounter.num;
    eqOpter.removeEquivalentSets = allowStructure;
    eqOpter.walkFunctionInModule(func, this->getModule());
    if (eqOpter.refinalize) {
      ReFinalize().walkFunctionInModule(func, this->getModule());
    }

    // We may have already had a local with no uses, or we may have just
    // gotten there thanks to the EquivalentOptimizer. If there are such
    // locals, remove all their sets.
    UnneededSetRemover setRemover(
      getCounter, func, this->getPassOptions(), *this->getModule());
    setRemover.setModule(this->getModule());

    return eqOpter.anotherCycle || setRemover.removed;
  }
};

Pass* createSimplifyLocalsPass() { return new SimplifyLocals<true, true>(); }

Pass* createSimplifyLocalsNoTeePass() {
  return new SimplifyLocals<false, true>();
}

Pass* createSimplifyLocalsNoStructurePass() {
  return new SimplifyLocals<true, false>();
}

Pass* createSimplifyLocalsNoTeeNoStructurePass() {
  return new SimplifyLocals<false, false>();
}

Pass* createSimplifyLocalsNoNestingPass() {
  return new SimplifyLocals<false, false, false>();
}

} // namespace wasm
