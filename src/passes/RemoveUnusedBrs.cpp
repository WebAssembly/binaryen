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
// Removes branches for which we go to where they go anyhow
//

#include <wasm.h>
#include <pass.h>
#include <ast_utils.h>
#include <wasm-builder.h>

namespace wasm {

// to turn an if into a br-if, we must be able to reorder the
// condition and possible value, and the possible value must
// not have side effects (as they would run unconditionally)
static bool canTurnIfIntoBrIf(Expression* ifCondition, Expression* brValue, PassOptions& options) {
  if (!brValue) return true;
  EffectAnalyzer value(options, brValue);
  if (value.hasSideEffects()) return false;
  return !EffectAnalyzer(options, ifCondition).invalidates(value);
}

struct RemoveUnusedBrs : public WalkerPass<PostWalker<RemoveUnusedBrs>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new RemoveUnusedBrs; }

  bool anotherCycle;

  // Whether a value can flow in the current path. If so, then a br with value
  // can be turned into a value, which will flow through blocks/ifs to the right place
  bool valueCanFlow;

  typedef std::vector<Expression**> Flows;

  // list of breaks that are currently flowing. if they reach their target without
  // interference, they can be removed (or their value forwarded TODO)
  Flows flows;

  // a stack for if-else contents, we merge their outputs
  std::vector<Flows> ifStack;

  // list of all loops, so we can optimize them
  std::vector<Loop*> loops;

  static void visitAny(RemoveUnusedBrs* self, Expression** currp) {
    auto* curr = *currp;
    auto& flows = self->flows;

    if (curr->is<Break>()) {
      flows.clear();
      auto* br = curr->cast<Break>();
      if (!br->condition) { // TODO: optimize?
        // a break, let's see where it flows to
        flows.push_back(currp);
        self->valueCanFlow = true; // start optimistic
      } else {
        self->valueCanFlow = false;
      }
    } else if (curr->is<Return>()) {
      flows.clear();
      flows.push_back(currp);
      self->valueCanFlow = true; // start optimistic
    } else if (curr->is<If>()) {
      auto* iff = curr->cast<If>();
      if (iff->ifFalse) {
        assert(self->ifStack.size() > 0);
        for (auto* flow : self->ifStack.back()) {
          flows.push_back(flow);
        }
        self->ifStack.pop_back();
      } else {
        // if without else stops the flow of values
        self->valueCanFlow = false;
      }
    } else if (curr->is<Block>()) {
      // any breaks flowing to here are unnecessary, as we get here anyhow
      auto* block = curr->cast<Block>();
      auto name = block->name;
      if (name.is()) {
        size_t size = flows.size();
        size_t skip = 0;
        for (size_t i = 0; i < size; i++) {
          auto* flow = (*flows[i])->dynCast<Break>();
          if (flow && flow->name == name) {
            if (!flow->value || self->valueCanFlow) {
              if (!flow->value) {
                // br => nop
                ExpressionManipulator::nop<Break>(flow);
              } else {
                // br with value => value
                *flows[i] = flow->value;
              }
              skip++;
              self->anotherCycle = true;
            }
          } else if (skip > 0) {
            flows[i - skip] = flows[i];
          }
        }
        if (skip > 0) {
          flows.resize(size - skip);
        }
        // drop a nop at the end of a block, which prevents a value flowing
        while (block->list.size() > 0 && block->list.back()->is<Nop>()) {
          block->list.resize(block->list.size() - 1);
          self->anotherCycle = true;
        }
      }
    } else if (curr->is<Nop>()) {
      // ignore (could be result of a previous cycle)
      self->valueCanFlow = false;
    } else if (curr->is<Loop>()) {
      // do nothing - it's ok for values to flow out
    } else {
      // anything else stops the flow
      flows.clear();
      self->valueCanFlow = false;
    }
  }

  static void clear(RemoveUnusedBrs* self, Expression** currp) {
    self->flows.clear();
  }

  static void saveIfTrue(RemoveUnusedBrs* self, Expression** currp) {
    self->ifStack.push_back(std::move(self->flows));
  }

  void visitLoop(Loop* curr) {
    loops.push_back(curr);
  }

  void visitIf(If* curr) {
    if (!curr->ifFalse) {
      // if without an else. try to reduce   if (condition) br  =>  br_if (condition)
      Break* br = curr->ifTrue->dynCast<Break>();
      if (br && !br->condition) { // TODO: if there is a condition, join them
        if (canTurnIfIntoBrIf(curr->condition, br->value, getPassOptions())) {
          br->condition = curr->condition;
          br->finalize();
          replaceCurrent(Builder(*getModule()).dropIfConcretelyTyped(br));
          anotherCycle = true;
        }
      }
    }
    // TODO: if-else can be turned into a br_if as well, if one of the sides is a dead end
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(RemoveUnusedBrs* self, Expression** currp) {
    self->pushTask(visitAny, currp);

    auto* iff = (*currp)->dynCast<If>();

    if (iff) {
      self->pushTask(doVisitIf, currp);
      if (iff->ifFalse) {
      // we need to join up if-else control flow, and clear after the condition
        self->pushTask(scan, &iff->ifFalse);
        self->pushTask(saveIfTrue, currp); // safe the ifTrue flow, we'll join it later
      }
      self->pushTask(scan, &iff->ifTrue);
      self->pushTask(clear, currp); // clear all flow after the condition
      self->pushTask(scan, &iff->condition);
    } else {
      WalkerPass<PostWalker<RemoveUnusedBrs>>::scan(self, currp);
    }
  }

  // optimizes a loop. returns true if we made changes
  bool optimizeLoop(Loop* loop) {
    // if a loop ends in
    // (loop $in
    //   (block $out
    //     if (..) br $in; else br $out;
    //   )
    // )
    // then our normal opts can remove the break out since it flows directly out
    // (and later passes make the if one-armed). however, the simple analysis
    // fails on patterns like
    //     if (..) br $out;
    //     br $in;
    // which is a common way to do a while (1) loop (end it with a jump to the
    // top), so we handle that here. Specifically we want to conditionalize
    // breaks to the loop top, i.e., put them behind a condition, so that other
    // code can flow directly out and thus brs out can be removed. (even if
    // the change is to let a break somewhere else flow out, that can still be
    // helpful, as it shortens the logical loop. it is also good to generate
    // an if-else instead of an if, as it might allow an eqz to be removed
    // by flipping arms)
    if (!loop->name.is()) return false;
    auto* block = loop->body->dynCast<Block>();
    if (!block) return false;
    // does the last element break to the top of the loop?
    auto& list = block->list;
    if (list.size() <= 1) return false;
    auto* last = list.back()->dynCast<Break>();
    if (!last || !ExpressionAnalyzer::isSimple(last) || last->name != loop->name) return false;
    // last is a simple break to the top of the loop. if we can conditionalize it,
    // it won't block things from flowing out and not needing breaks to do so.
    Index i = list.size() - 2;
    Builder builder(*getModule());
    while (1) {
      auto* curr = list[i];
      if (auto* iff = curr->dynCast<If>()) {
        // let's try to move the code going to the top of the loop into the if-else
        if (!iff->ifFalse) {
          // we need the ifTrue to break, so it cannot reach the code we want to move
          if (ExpressionAnalyzer::obviouslyDoesNotFlowOut(iff->ifTrue)) {
            iff->ifFalse = builder.stealSlice(block, i + 1, list.size());
            return true;
          }
        } else {
          // this is already an if-else. if one side is a dead end, we can append to the other, if
          // there is no returned value to concern us
          assert(!isConcreteWasmType(iff->type)); // can't be, since in the middle of a block
          if (ExpressionAnalyzer::obviouslyDoesNotFlowOut(iff->ifTrue)) {
            iff->ifFalse = builder.blockifyMerge(iff->ifFalse, builder.stealSlice(block, i + 1, list.size()));
            return true;
          } else if (ExpressionAnalyzer::obviouslyDoesNotFlowOut(iff->ifFalse)) {
            iff->ifTrue = builder.blockifyMerge(iff->ifTrue, builder.stealSlice(block, i + 1, list.size()));
            return true;
          }
        }
        return false;
      } else if (auto* brIf = curr->dynCast<Break>()) {
        // br_if is similar to if.
        if (brIf->condition && !brIf->value && brIf->name != loop->name) {
          if (i == list.size() - 2) {
            // there is the br_if, and then the br to the top, so just flip them and the condition
            brIf->condition = builder.makeUnary(EqZInt32, brIf->condition);
            last->name = brIf->name;
            brIf->name = loop->name;
            return true;
          } else {
            // there are elements in the middle,
            //   br_if $somewhere (condition)
            //   (..more..)
            //   br $in
            // we can convert the br_if to an if. this has a cost, though,
            // so only do it if it looks useful, which it definitely is if
            //  (a) $somewhere is straight out (so the br out vanishes), and
            //  (b) this br_if is the only branch to that block (so the block will vanish)
            if (brIf->name == block->name && BreakSeeker::count(block, block->name) == 1) {
              // note that we could drop the last element here, it is a br we know for sure is removable,
              // but telling stealSlice to steal all to the end is more efficient, it can just truncate.
              list[i] = builder.makeIf(brIf->condition, builder.makeBreak(brIf->name), builder.stealSlice(block, i + 1, list.size()));
              return true;
            }
          }
        }
        return false;
      }
      // if there is control flow, we must stop looking
      if (EffectAnalyzer(getPassOptions(), curr).branches) {
        return false;
      }
      if (i == 0) return false;
      i--;
    }
  }

  void doWalkFunction(Function* func) {
    // multiple cycles may be needed
    bool worked = false;
    do {
      anotherCycle = false;
      WalkerPass<PostWalker<RemoveUnusedBrs>>::doWalkFunction(func);
      assert(ifStack.empty());
      // flows may contain returns, which are flowing out and so can be optimized
      for (size_t i = 0; i < flows.size(); i++) {
        auto* flow = (*flows[i])->dynCast<Return>();
        if (!flow) continue;
        if (!flow->value) {
          // return => nop
          ExpressionManipulator::nop(flow);
          anotherCycle = true;
        } else if (valueCanFlow) {
          // return with value => value
          *flows[i] = flow->value;
          anotherCycle = true;
        }
      }
      flows.clear();
      // optimize loops (we don't do it while tracking flows, as they can interfere)
      for (auto* loop : loops) {
        anotherCycle |= optimizeLoop(loop);
      }
      loops.clear();
      if (anotherCycle) worked = true;
    } while (anotherCycle);

    if (worked) {
      // Our work may alter block and if types, they may now return values that we made flow through them
      ReFinalize().walkFunctionInModule(func, getModule());
    }

    // thread trivial jumps
    struct JumpThreader : public ControlFlowWalker<JumpThreader> {
      // map of all value-less breaks going to a block (and not a loop)
      std::map<Block*, std::vector<Break*>> breaksToBlock;

      // the names to update
      std::map<Break*, Name> newNames;

      void visitBreak(Break* curr) {
        if (!curr->value) {
          if (auto* target = findBreakTarget(curr->name)->dynCast<Block>()) {
            breaksToBlock[target].push_back(curr);
          }
        }
      }
      // TODO: Switch?
      void visitBlock(Block* curr) {
        auto& list = curr->list;
        if (list.size() == 1 && curr->name.is()) {
          // if this block has just one child, a sub-block, then jumps to the former are jumps to us, really
          if (auto* child = list[0]->dynCast<Block>()) {
            if (child->name.is() && child->name != curr->name) {
              auto& breaks = breaksToBlock[child];
              for (auto* br : breaks) {
                newNames[br] = curr->name;
                breaksToBlock[curr].push_back(br); // update the list - we may push it even more later
              }
              breaksToBlock.erase(child);
            }
          }
        } else if (list.size() == 2) {
          // if this block has two children, a child-block and a simple jump, then jumps to child-block can be replaced with jumps to the new target
          auto* child = list[0]->dynCast<Block>();
          auto* jump = list[1]->dynCast<Break>();
          if (child && child->name.is() && jump && ExpressionAnalyzer::isSimple(jump)) {
            auto& breaks = breaksToBlock[child];
            for (auto* br : breaks) {
              newNames[br] = jump->name;
            }
            // if the jump is to another block then we can update the list, and maybe push it even more later
            if (auto* newTarget = findBreakTarget(jump->name)->dynCast<Block>()) {
              for (auto* br : breaks) {
                breaksToBlock[newTarget].push_back(br);
              }
            }
            breaksToBlock.erase(child);
          }
        }
      }

      void finish(Function* func) {
        for (auto& iter : newNames) {
          auto* br = iter.first;
          auto name = iter.second;
          br->name = name;
        }
        if (newNames.size() > 0) {
          // by changing where brs go, we may change block types etc.
          ReFinalize().walkFunctionInModule(func, getModule());
        }
      }
    };
    JumpThreader jumpThreader;
    jumpThreader.setModule(getModule());
    jumpThreader.walkFunction(func);
    jumpThreader.finish(func);

    // perform some final optimizations
    struct FinalOptimizer : public PostWalker<FinalOptimizer> {
      bool selectify;
      PassOptions& passOptions;

      FinalOptimizer(PassOptions& passOptions) : passOptions(passOptions) {}

      void visitBlock(Block* curr) {
        // if a block has an if br else br, we can un-conditionalize the latter, allowing
        // the if to become a br_if.
        // * note that if not in a block already, then we need to create a block for this, so not useful otherwise
        // * note that this only happens at the end of a block, as code after the if is dead
        // * note that we do this at the end, because un-conditionalizing can interfere with optimizeLoop()ing.
        auto& list = curr->list;
        for (Index i = 0; i < list.size(); i++) {
          auto* iff = list[i]->dynCast<If>();
          if (!iff || !iff->ifFalse || isConcreteWasmType(iff->type)) continue; // if it lacked an if-false, it would already be a br_if, as that's the easy case
          auto* ifTrueBreak = iff->ifTrue->dynCast<Break>();
          if (ifTrueBreak && !ifTrueBreak->condition && canTurnIfIntoBrIf(iff->condition, ifTrueBreak->value, passOptions)) {
            // we are an if-else where the ifTrue is a break without a condition, so we can do this
            ifTrueBreak->condition = iff->condition;
            ifTrueBreak->finalize();
            list[i] = Builder(*getModule()).dropIfConcretelyTyped(ifTrueBreak);
            ExpressionManipulator::spliceIntoBlock(curr, i + 1, iff->ifFalse);
            continue;
          }
          // otherwise, perhaps we can flip the if
          auto* ifFalseBreak = iff->ifFalse->dynCast<Break>();
          if (ifFalseBreak && !ifFalseBreak->condition && canTurnIfIntoBrIf(iff->condition, ifFalseBreak->value, passOptions)) {
            ifFalseBreak->condition = Builder(*getModule()).makeUnary(EqZInt32, iff->condition);
            ifFalseBreak->finalize();
            list[i] = Builder(*getModule()).dropIfConcretelyTyped(ifFalseBreak);
            ExpressionManipulator::spliceIntoBlock(curr, i + 1, iff->ifTrue);
            continue;
          }
        }
        if (list.size() >= 2) {
          if (selectify) {
            // Join adjacent br_ifs to the same target, making one br_if with
            // a "selectified" condition that executes both.
            for (Index i = 0; i < list.size() - 1; i++) {
              auto* br1 = list[i]->dynCast<Break>();
              if (!br1 || !br1->condition) continue;
              auto* br2 = list[i + 1]->dynCast<Break>();
              if (!br2 || !br2->condition) continue;
              if (br1->name == br2->name) {
                assert(!br1->value && !br2->value);
                if (!EffectAnalyzer(passOptions, br2->condition).hasSideEffects()) {
                  // it's ok to execute them both, do it
                  Builder builder(*getModule());
                  br1->condition = builder.makeBinary(OrInt32, br1->condition, br2->condition);
                  ExpressionManipulator::nop(br2);
                }
              }
            }
          }
          // Restructuring of ifs: if we have
          //   (block $x
          //     (br_if $x (cond))
          //     .., no other references to $x
          //   )
          // then we can turn that into (if (!cond) ..).
          // Code size wise, we turn the block into an if (no change), and
          // lose the br_if (-2). .. turns into the body of the if in the binary
          // format. We need to flip the condition, which at worst adds 1.
          if (curr->name.is()) {
            auto* br = list[0]->dynCast<Break>();
            if (br && br->condition && br->name == curr->name) {
              assert(!br->value); // can't, it would be dropped or last in the block
              if (BreakSeeker::count(curr, curr->name) == 1) {
                // no other breaks to that name, so we can do this
                Builder builder(*getModule());
                replaceCurrent(builder.makeIf(
                  builder.makeUnary(EqZInt32, br->condition),
                  curr
                ));
                curr->name = Name();
                ExpressionManipulator::nop(br);
                curr->finalize(curr->type);
                return;
              }
            }
          }
        }
      }

      void visitIf(If* curr) {
        // we may have simplified ifs enough to turn them into selects
        // this is helpful for code size, but can be a tradeoff with performance as we run both code paths
        if (!selectify) return;
        if (curr->ifFalse && isConcreteWasmType(curr->ifTrue->type) && isConcreteWasmType(curr->ifFalse->type)) {
          // if with else, consider turning it into a select if there is no control flow
          // TODO: estimate cost
          EffectAnalyzer condition(passOptions, curr->condition);
          if (!condition.hasSideEffects()) {
            EffectAnalyzer ifTrue(passOptions, curr->ifTrue);
            if (!ifTrue.hasSideEffects()) {
              EffectAnalyzer ifFalse(passOptions, curr->ifFalse);
              if (!ifFalse.hasSideEffects()) {
                auto* select = getModule()->allocator.alloc<Select>();
                select->condition = curr->condition;
                select->ifTrue = curr->ifTrue;
                select->ifFalse = curr->ifFalse;
                select->finalize();
                replaceCurrent(select);
              }
            }
          }
        }
      }
    };
    FinalOptimizer finalOptimizer(getPassOptions());
    finalOptimizer.setModule(getModule());
    finalOptimizer.selectify = getPassRunner()->options.shrinkLevel > 0;
    finalOptimizer.walkFunction(func);
  }
};

Pass *createRemoveUnusedBrsPass() {
  return new RemoveUnusedBrs();
}

} // namespace wasm
