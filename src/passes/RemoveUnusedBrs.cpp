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
#include <parsing.h>
#include <ir/utils.h>
#include <ir/branch-utils.h>
#include <ir/effects.h>
#include <wasm-builder.h>

namespace wasm {

// to turn an if into a br-if, we must be able to reorder the
// condition and possible value, and the possible value must
// not have side effects (as they would run unconditionally)
static bool canTurnIfIntoBrIf(Expression* ifCondition, Expression* brValue, PassOptions& options) {
  // if the if isn't even reached, this is all dead code anyhow
  if (ifCondition->type == unreachable) return false;
  if (!brValue) return true;
  EffectAnalyzer value(options, brValue);
  if (value.hasSideEffects()) return false;
  return !EffectAnalyzer(options, ifCondition).invalidates(value);
}

struct RemoveUnusedBrs : public WalkerPass<PostWalker<RemoveUnusedBrs>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new RemoveUnusedBrs; }

  bool anotherCycle;

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
      } else {
        self->stopValueFlow();
      }
    } else if (curr->is<Return>()) {
      flows.clear();
      flows.push_back(currp);
    } else if (curr->is<If>()) {
      auto* iff = curr->cast<If>();
      if (iff->condition->type == unreachable) {
        // avoid trying to optimize this, we never reach it anyhow
        self->stopFlow();
        return;
      }
      if (iff->ifFalse) {
        assert(self->ifStack.size() > 0);
        auto ifTrueFlows = std::move(self->ifStack.back());
        self->ifStack.pop_back();
        // we can flow values out in most cases, except if one arm
        // has the none type - we will update the types later, but
        // there is no way to emit a proper type for one arm being
        // none and the other flowing a value; and there is no way
        // to flow a value from a none.
        if (iff->ifTrue->type == none || iff->ifFalse->type == none) {
          self->removeValueFlow(ifTrueFlows);
          self->stopValueFlow();
        }
        for (auto* flow : ifTrueFlows) {
          flows.push_back(flow);
        }
      } else {
        // if without else stops the flow of values
        self->stopValueFlow();
      }
    } else if (auto* block = curr->dynCast<Block>()) {
      // any breaks flowing to here are unnecessary, as we get here anyhow
      auto name = block->name;
      if (name.is()) {
        size_t size = flows.size();
        size_t skip = 0;
        for (size_t i = 0; i < size; i++) {
          auto* flow = (*flows[i])->dynCast<Break>();
          if (flow && flow->name == name) {
            if (!flow->value) {
              // br => nop
              ExpressionManipulator::nop<Break>(flow);
            } else {
              // br with value => value
              *flows[i] = flow->value;
            }
            skip++;
            self->anotherCycle = true;
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
      self->stopValueFlow();
    } else if (curr->is<Loop>()) {
      // do nothing - it's ok for values to flow out
    } else if (auto* sw = curr->dynCast<Switch>()) {
      self->stopFlow();
      self->optimizeSwitch(sw);
    } else {
      // anything else stops the flow
      self->stopFlow();
    }
  }

  void stopFlow() {
    flows.clear();
  }

  void removeValueFlow(Flows& currFlows) {
    currFlows.erase(std::remove_if(currFlows.begin(), currFlows.end(), [&](Expression** currp) {
      auto* curr = *currp;
      if (auto* ret = curr->dynCast<Return>()) {
        return ret->value;
      }
      return curr->cast<Break>()->value;
    }), currFlows.end());
  }

  void stopValueFlow() {
    removeValueFlow(flows);
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

  void optimizeSwitch(Switch* curr) {
    // if the final element is the default, we don't need it
    while (!curr->targets.empty() && curr->targets.back() == curr->default_) {
      curr->targets.pop_back();
    }
    // if the first element is the default, we can remove it by shifting everything (which
    // does add a subtraction of a constant, but often that is worth it as the constant can
    // be folded away and/or we remove multiple elements here)
    Index removable = 0;
    while (removable < curr->targets.size() && curr->targets[removable] == curr->default_) {
      removable++;
    }
    if (removable > 0) {
      for (Index i = removable; i < curr->targets.size(); i++) {
        curr->targets[i - removable] = curr->targets[i];
      }
      curr->targets.resize(curr->targets.size() - removable);
      Builder builder(*getModule());
      curr->condition = builder.makeBinary(SubInt32,
        curr->condition,
        builder.makeConst(Literal(int32_t(removable)))
      );
    }
    // when there isn't a value, we can do some trivial optimizations without worrying about
    // the value being executed before the condition
    if (curr->value) return;
    if (curr->targets.size() == 0) {
      // a switch with just a default always goes there
      Builder builder(*getModule());
      replaceCurrent(builder.makeSequence(
        builder.makeDrop(curr->condition),
        builder.makeBreak(curr->default_)
      ));
    } else if (curr->targets.size() == 1) {
      // a switch with two options is basically an if
      Builder builder(*getModule());
      replaceCurrent(builder.makeIf(
        curr->condition,
        builder.makeBreak(curr->default_),
        builder.makeBreak(curr->targets.front())
      ));
    } else {
      // there are also some other cases where we want to convert a switch into ifs,
      // especially if the switch is large and we are focusing on size.
      // an especially egregious case is a switch like this:
      // [a b b [..] b b c] with default b
      // (which may be arrived at after we trim away excess default values on both
      // sides). in this case, we really have 3 values in a simple form, so it is the
      // next logical case after handling 1 and 2 values right above here.
      // to optimize this, we must add a local + a bunch of nodes (if*2, tee, eq,
      // get, const, break*3), so the table must be big enough for it to make sense

      // How many targets we need when shrinking. This is literally the size at which
      // the transformation begins to be smaller.
      const uint32_t MIN_SHRINK = 13;
      // How many targets we need when not shrinking, in which case, 2 ifs may be slower,
      // so we do this when the table is ridiculously large for one with just 3 values
      // in it.
      const uint32_t MIN_GENERAL = 128;

      auto shrink = getPassRunner()->options.shrinkLevel > 0;
      if ((curr->targets.size() >= MIN_SHRINK  &&  shrink) ||
          (curr->targets.size() >= MIN_GENERAL && !shrink)) {
        for (Index i = 1; i < curr->targets.size() - 1; i++) {
          if (curr->targets[i] != curr->default_) {
            return;
          }
        }
        // great, we are in that case, optimize
        Builder builder(*getModule());
        auto temp = builder.addVar(getFunction(), i32);
        Expression* z;
        replaceCurrent(z = builder.makeIf(
          builder.makeTeeLocal(temp, curr->condition),
          builder.makeIf(
            builder.makeBinary(EqInt32,
              builder.makeGetLocal(temp, i32),
              builder.makeConst(Literal(int32_t(curr->targets.size() - 1)))
            ),
            builder.makeBreak(curr->targets.back()),
            builder.makeBreak(curr->default_)
          ),
          builder.makeBreak(curr->targets.front())
        ));
      }
    }
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
    //       we handle the case of a returned value to a set_local later down, see
    //       visitSetLocal.
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(RemoveUnusedBrs* self, Expression** currp) {
    self->pushTask(visitAny, currp);

    auto* iff = (*currp)->dynCast<If>();

    if (iff) {
      if (iff->condition->type == unreachable) {
        // avoid trying to optimize this, we never reach it anyhow
        return;
      }
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
      super::scan(self, currp);
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
          if (iff->ifTrue->type == unreachable) {
            iff->ifFalse = builder.stealSlice(block, i + 1, list.size());
            iff->finalize();
            block->finalize();
            return true;
          }
        } else {
          // this is already an if-else. if one side is a dead end, we can append to the other, if
          // there is no returned value to concern us
          assert(!isConcreteType(iff->type)); // can't be, since in the middle of a block

          // ensures the first node is a block, if it isn't already, and merges in the second,
          // either as a single element or, if a block, by appending to the first block. this
          // keeps the order of operations in place, that is, the appended element will be
          // executed after the first node's elements
          auto blockifyMerge = [&](Expression* any, Expression* append) -> Block* {
            Block* block = nullptr;
            if (any) block = any->dynCast<Block>();
            // if the first isn't a block, or it's a block with a name (so we might
            // branch to the end, and so can't append to it, we might skip that code!)
            // then make a new block
            if (!block || block->name.is()) {
              block = builder.makeBlock(any);
            } else {
              assert(!isConcreteType(block->type));
            }
            auto* other = append->dynCast<Block>();
            if (!other) {
              block->list.push_back(append);
            } else {
              for (auto* item : other->list) {
                block->list.push_back(item);
              }
            }
            block->finalize();
            return block;
          };

          if (iff->ifTrue->type == unreachable) {
            iff->ifFalse = blockifyMerge(iff->ifFalse, builder.stealSlice(block, i + 1, list.size()));
            iff->finalize();
            block->finalize();
            return true;
          } else if (iff->ifFalse->type == unreachable) {
            iff->ifTrue = blockifyMerge(iff->ifTrue, builder.stealSlice(block, i + 1, list.size()));
            iff->finalize();
            block->finalize();
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
            if (brIf->name == block->name && BranchUtils::BranchSeeker::countNamed(block, block->name) == 1) {
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

  bool sinkBlocks(Function* func) {
    struct Sinker : public PostWalker<Sinker> {
      bool worked = false;

      void visitBlock(Block* curr) {
        // If the block has a single child which is a loop, and the block is named,
        // then it is the exit for the loop. It's better to move it into the loop,
        // where it can be better optimized by other passes.
        // Similar logic for ifs: if the block is an exit for the if, we can
        // move the block in, consider for example:
        //    (block $label
        //     (if (..condition1..)
        //      (block
        //       (br_if $label (..condition2..))
        //       (..code..)
        //      )
        //     )
        //    )
        // After also merging the blocks, we have
        //    (if (..condition1..)
        //     (block $label
        //      (br_if $label (..condition2..))
        //      (..code..)
        //     )
        //    )
        // which can be further optimized later.
        if (curr->name.is() && curr->list.size() == 1) {
          if (auto* loop = curr->list[0]->dynCast<Loop>()) {
            curr->list[0] = loop->body;
            loop->body = curr;
            curr->finalize(curr->type);
            loop->finalize();
            replaceCurrent(loop);
            worked = true;
          } else if (auto* iff = curr->list[0]->dynCast<If>()) {
            // The label can't be used in the condition.
            if (BranchUtils::BranchSeeker::countNamed(iff->condition, curr->name) == 0) {
              // We can move the block into either arm, if there are no uses in the other.
              Expression** target = nullptr;
              if (!iff->ifFalse ||
                  BranchUtils::BranchSeeker::countNamed(iff->ifFalse, curr->name) == 0) {
                target = &iff->ifTrue;
              } else if (BranchUtils::BranchSeeker::countNamed(iff->ifTrue, curr->name) == 0) {
                target = &iff->ifFalse;
              }
              if (target) {
                curr->list[0] = *target;
                *target = curr;
                // The block used to contain the if, and may have changed type from unreachable
                // to none, for example, if the if has an unreachable condition but the arm
                // is not unreachable.
                curr->finalize();
                iff->finalize();
                replaceCurrent(iff);
                worked = true;
                // Note that the type might change, e.g. if the if condition is unreachable
                // but the block that was on the outside had a break.
              }
            }
          }
        }
      }
    } sinker;

    sinker.doWalkFunction(func);
    if (sinker.worked) {
      ReFinalize().walkFunctionInModule(func, getModule());
      return true;
    }
    return false;
  }

  void doWalkFunction(Function* func) {
    // multiple cycles may be needed
    do {
      anotherCycle = false;
      super::doWalkFunction(func);
      assert(ifStack.empty());
      // flows may contain returns, which are flowing out and so can be optimized
      for (size_t i = 0; i < flows.size(); i++) {
        auto* flow = (*flows[i])->dynCast<Return>();
        if (!flow) continue;
        if (!flow->value) {
          // return => nop
          ExpressionManipulator::nop(flow);
          anotherCycle = true;
        } else {
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
      if (anotherCycle) {
        ReFinalize().walkFunctionInModule(func, getModule());
      }
      // sink blocks
      if (sinkBlocks(func)) {
        anotherCycle = true;
      }
    } while (anotherCycle);

    // thread trivial jumps
    struct JumpThreader : public ControlFlowWalker<JumpThreader> {
      // map of all value-less breaks and switches going to a block (and not a loop)
      std::map<Block*, std::vector<Expression*>> branchesToBlock;

      bool worked = false;

      void visitBreak(Break* curr) {
        if (!curr->value) {
          if (auto* target = findBreakTarget(curr->name)->dynCast<Block>()) {
            branchesToBlock[target].push_back(curr);
          }
        }
      }
      void visitSwitch(Switch* curr) {
        if (!curr->value) {
          auto names = BranchUtils::getUniqueTargets(curr);
          for (auto name : names) {
            if (auto* target = findBreakTarget(name)->dynCast<Block>()) {
              branchesToBlock[target].push_back(curr);
            }
          }
        }
      }
      void visitBlock(Block* curr) {
        auto& list = curr->list;
        if (list.size() == 1 && curr->name.is()) {
          // if this block has just one child, a sub-block, then jumps to the former are jumps to us, really
          if (auto* child = list[0]->dynCast<Block>()) {
            // the two blocks must have the same type for us to update the branch, as otherwise
            // one block may be unreachable and the other concrete, so one might lack a value
            if (child->name.is() && child->name != curr->name && child->type == curr->type) {
              redirectBranches(child, curr->name);
            }
          }
        } else if (list.size() == 2) {
          // if this block has two children, a child-block and a simple jump, then jumps to child-block can be replaced with jumps to the new target
          auto* child = list[0]->dynCast<Block>();
          auto* jump = list[1]->dynCast<Break>();
          if (child && child->name.is() && jump && ExpressionAnalyzer::isSimple(jump)) {
            redirectBranches(child, jump->name);
          }
        }
      }

      void redirectBranches(Block* from, Name to) {
        auto& branches = branchesToBlock[from];
        for (auto* branch : branches) {
          if (BranchUtils::replacePossibleTarget(branch, from->name, to)) {
            worked = true;
          }
        }
        // if the jump is to another block then we can update the list, and maybe push it even more later
        if (auto* newTarget = findBreakTarget(to)->dynCast<Block>()) {
          for (auto* branch : branches) {
            branchesToBlock[newTarget].push_back(branch);
          }
        }
      }

      void finish(Function* func) {
        if (worked) {
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
      bool shrink;
      PassOptions& passOptions;

      bool needUniqify = false;

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
          if (!iff || !iff->ifFalse || isConcreteType(iff->type)) continue; // if it lacked an if-false, it would already be a br_if, as that's the easy case
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
          // combine/optimize adjacent br_ifs + a br (maybe _if) right after it
          for (Index i = 0; i < list.size() - 1; i++) {
            auto* br1 = list[i]->dynCast<Break>();
            // avoid unreachable brs, as they are dead code anyhow, and after merging
            // them the outer scope could need type changes
            if (!br1 || !br1->condition || br1->type == unreachable) continue;
            assert(!br1->value);
            auto* br2 = list[i + 1]->dynCast<Break>();
            if (!br2 || br1->name != br2->name) continue;
            assert(!br2->value); // same target as previous, which has no value
            // a br_if and then a br[_if] with the same target right after it
            if (br2->condition) {
              if (shrink && br2->type != unreachable) {
                // Join adjacent br_ifs to the same target, making one br_if with
                // a "selectified" condition that executes both.
                if (!EffectAnalyzer(passOptions, br2->condition).hasSideEffects()) {
                  // it's ok to execute them both, do it
                  Builder builder(*getModule());
                  br1->condition = builder.makeBinary(OrInt32, br1->condition, br2->condition);
                  ExpressionManipulator::nop(br2);
                }
              }
            } else {
              // merge, we go there anyhow
              Builder builder(*getModule());
              list[i] = builder.makeDrop(br1->condition);
            }
          }
          // Combine adjacent br_ifs that test the same value into a br_table,
          // when that makes sense.
          tablify(curr);
          // Pattern-patch ifs, recreating them when it makes sense.
          restructureIf(curr);
        }
      }

      void visitSwitch(Switch* curr) {
        if (BranchUtils::getUniqueTargets(curr).size() == 1) {
          // This switch has just one target no matter what; replace with a br.
          Builder builder(*getModule());
          replaceCurrent(
            builder.makeSequence(
              builder.makeDrop(curr->condition), // might have side effects
              builder.makeBreak(curr->default_, curr->value)
            )
          );
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
      // If the block has a return value, we can do something similar, removing
      // the drop from the br_if and putting the if on the outside,
      //   (block $x
      //     (br_if $x (value) (cond))
      //     .., no other references to $x
      //     ..final element..
      //   )
      // =>
      //   (if
      //     (cond)
      //     (value) ;; must not have side effects!
      //     (block
      //       .., no other references to $x
      //       ..final element..
      //     )
      //   )
      // This is beneficial as the block will likely go away in the binary
      // format (the if arm is an implicit block), and the drop is removed.
      void restructureIf(Block* curr) {
        auto& list = curr->list;
        // We should be called only on potentially-interesting lists.
        assert(list.size() >= 2);
        if (curr->name.is()) {
          Break* br = nullptr;
          Drop* drop = list[0]->dynCast<Drop>();
          if (drop) {
            br = drop->value->dynCast<Break>();
          } else {
            br = list[0]->dynCast<Break>();
          }
          // Check if the br is conditional and goes to the block. It may or may not have
          // a value, depending on if it was dropped or not.
          // If the type is unreachable that means it is not actually reached,
          // which we can ignore.
          if (br && br->condition && br->name == curr->name && br->type != unreachable) {
            if (BranchUtils::BranchSeeker::countNamed(curr, curr->name) == 1) {
              // no other breaks to that name, so we can do this
              if (!drop) {
                assert(!br->value);
                Builder builder(*getModule());
                replaceCurrent(builder.makeIf(
                  builder.makeUnary(EqZInt32, br->condition),
                  curr
                ));
                ExpressionManipulator::nop(br);
                curr->finalize(curr->type);
              } else {
                // If the items we move around have side effects, we can't do this.
                // TODO: we could use a select, in some cases..?
                if (!EffectAnalyzer(passOptions, br->value).hasSideEffects() &&
                    !EffectAnalyzer(passOptions, br->condition).hasSideEffects()) {
                  ExpressionManipulator::nop(list[0]);
                  Builder builder(*getModule());
                  replaceCurrent(
                    builder.makeIf(
                      br->condition,
                      br->value,
                      curr
                    )
                  );
                }
              }
            }
          }
        }
      }

      void visitIf(If* curr) {
        // we may have simplified ifs enough to turn them into selects
        // this is helpful for code size, but can be a tradeoff with performance as we run both code paths
        if (!shrink) return;
        if (curr->ifFalse && isConcreteType(curr->ifTrue->type) && isConcreteType(curr->ifFalse->type)) {
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

      void visitSetLocal(SetLocal* curr) {
        // Undo an if return value into a local, if one arm is a br, as we
        // prefer a br_if:
        //  (set_local $x
        //    (if (result i32)
        //      (..condition..)
        //      (br $somewhere)
        //      (..result)
        //    )
        //  )
        // =>
        //  (br_if $somewhere
        //    (..condition..)
        //  )
        //  (set_local $x
        //    (..result)
        //  )
        // TODO: handle a condition in the br? need to watch for side effects
        auto* iff = curr->value->dynCast<If>();
        if (!iff) return;
        if (!isConcreteType(iff->type) || !isConcreteType(iff->condition->type)) return;
        auto tryToOptimize = [&](Expression* one, Expression* two, bool flipCondition) {
          if (one->type == unreachable && two->type != unreachable) {
            if (auto* br = one->dynCast<Break>()) {
              if (ExpressionAnalyzer::isSimple(br)) {
                // Wonderful, do it!
                Builder builder(*getModule());
                br->condition = iff->condition;
                if (flipCondition) {
                  br->condition = builder.makeUnary(EqZInt32, br->condition);
                }
                br->finalize();
                curr->value = two;
                replaceCurrent(
                  builder.makeSequence(
                    br,
                    curr
                  )
                );
                return true;
              }
            }
          }
          return false;
        };
        if (!tryToOptimize(iff->ifTrue, iff->ifFalse, false)) {
          tryToOptimize(iff->ifFalse, iff->ifTrue, true);
        }
      }

      // (br_if)+ => br_table
      // we look for the specific pattern of
      //  (br_if ..target1..
      //    (i32.eq
      //      (..input..)
      //      (i32.const ..value1..)
      //    )
      //  )
      //  (br_if ..target2..
      //    (i32.eq
      //      (..input..)
      //      (i32.const ..value2..)
      //    )
      //  )
      // TODO: consider also looking at <= etc. and not just eq
      void tablify(Block* block) {
        auto &list = block->list;
        if (list.size() <= 1) return;

        // Heuristics. These are slightly inspired by the constants from the asm.js backend.

        // How many br_ifs we need to see to consider doing this
        const uint32_t MIN_NUM = 3;
        // How much of a range of values is definitely too big
        const uint32_t MAX_RANGE = 1024;
        // Multiplied by the number of br_ifs, then compared to the range. When
        // this is high, we allow larger ranges.
        const uint32_t NUM_TO_RANGE_FACTOR = 3;

        // check if the input is a proper br_if on an i32.eq of a condition value to a const,
        // and the const is in the proper range, [0-int32_max), to avoid overflow concerns.
        // returns the br_if if so, or nullptr otherwise
        auto getProperBrIf = [](Expression* curr) -> Break*{
          auto* br = curr->dynCast<Break>();
          if (!br) return nullptr;
          if (!br->condition || br->value) return nullptr;
          if (br->type != none) return nullptr; // no value, so can be unreachable or none. ignore unreachable ones, dce will clean it up
          auto* binary = br->condition->dynCast<Binary>();
          if (!binary) return nullptr;
          if (binary->op != EqInt32) return nullptr;
          auto* c = binary->right->dynCast<Const>();
          if (!c) return nullptr;
          uint32_t value = c->value.geti32();
          if (value >= uint32_t(std::numeric_limits<int32_t>::max())) return nullptr;
          return br;
        };

        // check if the input is a proper br_if
        // and returns the condition if so, or nullptr otherwise
        auto getProperBrIfConditionValue = [&getProperBrIf](Expression* curr) -> Expression* {
          auto* br = getProperBrIf(curr);
          if (!br) return nullptr;
          return br->condition->cast<Binary>()->left;
        };

        // returns the constant value, as a uint32_t
        auto getProperBrIfConstant = [&getProperBrIf](Expression* curr) -> uint32_t {
          return getProperBrIf(curr)->condition->cast<Binary>()->right->cast<Const>()->value.geti32();
        };
        Index start = 0;
        while (start < list.size() - 1) {
          auto* conditionValue = getProperBrIfConditionValue(list[start]);
          if (!conditionValue) {
            start++;
            continue;
          }
          // if the condition has side effects, we can't replace many appearances of it
          // with a single one
          if (EffectAnalyzer(passOptions, conditionValue).hasSideEffects()) {
            start++;
            continue;
          }
          // look for a "run" of br_ifs with all the same conditionValue, and having
          // unique constants (an overlapping constant could be handled, just the first
          // branch is taken, but we can't remove the other br_if (it may be the only
          // branch keeping a block reachable), which may make this bad for code size.
          Index end = start + 1;
          std::unordered_set<uint32_t> usedConstants;
          usedConstants.insert(getProperBrIfConstant(list[start]));
          while (end < list.size() &&
                 ExpressionAnalyzer::equal(getProperBrIfConditionValue(list[end]),
                                           conditionValue)) {
            if (!usedConstants.insert(getProperBrIfConstant(list[end])).second) {
              // this constant already appeared
              break;
            }
            end++;
          }
          auto num = end - start;
          if (num >= 2 && num >= MIN_NUM) {
            // we found a suitable range, [start, end), containing more than 1
            // element. let's see if it's worth it
            auto min = getProperBrIfConstant(list[start]);
            auto max = min;
            for (Index i = start + 1; i < end; i++) {
              auto* curr = list[i];
              min = std::min(min, getProperBrIfConstant(curr));
              max = std::max(max, getProperBrIfConstant(curr));
            }
            uint32_t range = max - min;
            // decision time
            if (range <= MAX_RANGE &&
                range <= num * NUM_TO_RANGE_FACTOR) {
              // great! let's do this
              std::unordered_set<Name> usedNames;
              for (Index i = start; i < end; i++) {
                usedNames.insert(getProperBrIf(list[i])->name);
              }
              // we need a name for the default too
              Name defaultName;
              Index i = 0;
              while (1) {
                defaultName = "tablify|" + std::to_string(i++);
                if (usedNames.count(defaultName) == 0) break;
              }
              std::vector<Name> table;
              for (Index i = start; i < end; i++) {
                auto name = getProperBrIf(list[i])->name;
                auto index = getProperBrIfConstant(list[i]);
                index -= min;
                while (table.size() <= index) {
                  table.push_back(defaultName);
                }
                assert(table[index] == defaultName); // we should have made sure there are no overlaps
                table[index] = name;
              }
              Builder builder(*getModule());
              // the table and condition are offset by the min
              if (min != 0) {
                conditionValue = builder.makeBinary(
                  SubInt32,
                  conditionValue,
                  builder.makeConst(Literal(int32_t(min)))
                );
              }
              list[end - 1] = builder.makeBlock(
                defaultName,
                builder.makeSwitch(
                  table,
                  defaultName,
                  conditionValue
                )
              );
              for (Index i = start; i < end - 1; i++) {
                ExpressionManipulator::nop(list[i]);
              }
              // the defaultName may exist elsewhere in this function,
              // uniquify it later
              needUniqify = true;
            }
          }
          start = end;
        }
      }
    };
    FinalOptimizer finalOptimizer(getPassOptions());
    finalOptimizer.setModule(getModule());
    finalOptimizer.shrink = getPassRunner()->options.shrinkLevel > 0;
    finalOptimizer.walkFunction(func);
    if (finalOptimizer.needUniqify) {
      wasm::UniqueNameMapper::uniquify(func->body);
    }
  }
};

Pass *createRemoveUnusedBrsPass() {
  return new RemoveUnusedBrs();
}

} // namespace wasm
