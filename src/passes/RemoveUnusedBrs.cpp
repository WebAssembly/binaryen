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

#include <ir/branch-utils.h>
#include <ir/cost.h>
#include <ir/effects.h>
#include <ir/gc-type-utils.h>
#include <ir/literal-utils.h>
#include <ir/utils.h>
#include <parsing.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

// Grab a slice out of a block, replacing it with nops, and returning
// either another block with the contents (if more than 1) or a single
// expression.
// This does not finalize the input block; it leaves that for the caller.
static Expression*
stealSlice(Builder& builder, Block* input, Index from, Index to) {
  Expression* ret;
  if (to == from + 1) {
    // just one
    ret = input->list[from];
  } else {
    auto* block = builder.makeBlock();
    for (Index i = from; i < to; i++) {
      block->list.push_back(input->list[i]);
    }
    block->finalize();
    ret = block;
  }
  if (to == input->list.size()) {
    input->list.resize(from);
  } else {
    for (Index i = from; i < to; i++) {
      input->list[i] = builder.makeNop();
    }
  }
  return ret;
}

// to turn an if into a br-if, we must be able to reorder the
// condition and possible value, and the possible value must
// not have side effects (as they would run unconditionally)
static bool canTurnIfIntoBrIf(Expression* ifCondition,
                              Expression* brValue,
                              PassOptions& options,
                              Module& wasm) {
  // if the if isn't even reached, this is all dead code anyhow
  if (ifCondition->type == Type::unreachable) {
    return false;
  }
  if (!brValue) {
    return true;
  }
  EffectAnalyzer value(options, wasm, brValue);
  if (value.hasSideEffects()) {
    return false;
  }
  return !EffectAnalyzer(options, wasm, ifCondition).invalidates(value);
}

// This leads to similar choices as LLVM does in some cases, by balancing the
// extra work of code that is run unconditionally with the speedup from not
// branching to decide whether to run it or not.
// See:
//  * https://github.com/WebAssembly/binaryen/pull/4228
//  * https://github.com/WebAssembly/binaryen/issues/5983
const Index TooCostlyToRunUnconditionally = 8;

// Some costs are known to be too high to move from conditional to unconditional
// execution.
static_assert(CostAnalyzer::AtomicCost >= TooCostlyToRunUnconditionally,
              "We never run atomics unconditionally");
static_assert(CostAnalyzer::ThrowCost >= TooCostlyToRunUnconditionally,
              "We never run throws unconditionally");
static_assert(CostAnalyzer::CastCost > TooCostlyToRunUnconditionally / 2,
              "We only run casts unconditionally when optimizing for size");

static bool tooCostlyToRunUnconditionally(const PassOptions& passOptions,
                                          Index cost) {
  if (passOptions.shrinkLevel == 0) {
    // We are focused on speed. Any extra cost is risky, but allow a small
    // amount.
    return cost > TooCostlyToRunUnconditionally / 2;
  } else if (passOptions.shrinkLevel == 1) {
    // We are optimizing for size in a balanced manner. Allow some extra
    // overhead here.
    return cost >= TooCostlyToRunUnconditionally;
  } else {
    // We should have already decided what to do if shrink_level=2 and not
    // gotten here, and other values are invalid.
    WASM_UNREACHABLE("bad shrink level");
  }
}

// As above, but a single expression that we are considering moving to a place
// where it executes unconditionally.
static bool tooCostlyToRunUnconditionally(const PassOptions& passOptions,
                                          Expression* curr) {
  // If we care entirely about code size, just do it for that reason (early
  // exit to avoid work).
  if (passOptions.shrinkLevel >= 2) {
    return false;
  }
  auto cost = CostAnalyzer(curr).cost;
  return tooCostlyToRunUnconditionally(passOptions, cost);
}

// Check if it is not worth it to run code unconditionally. This
// assumes we are trying to run two expressions where previously
// only one of the two might have executed. We assume here that
// executing both is good for code size.
static bool tooCostlyToRunUnconditionally(const PassOptions& passOptions,
                                          Expression* one,
                                          Expression* two) {
  // If we care entirely about code size, just do it for that reason (early
  // exit to avoid work).
  if (passOptions.shrinkLevel >= 2) {
    return false;
  }

  // Consider the cost of executing all the code unconditionally, which adds
  // either the cost of running one or two, so the maximum is the worst case.
  auto max = std::max(CostAnalyzer(one).cost, CostAnalyzer(two).cost);
  return tooCostlyToRunUnconditionally(passOptions, max);
}

struct RemoveUnusedBrs : public WalkerPass<PostWalker<RemoveUnusedBrs>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<RemoveUnusedBrs>();
  }

  bool anotherCycle;

  using Flows = std::vector<Expression**>;

  // list of breaks that are currently flowing. if they reach their target
  // without interference, they can be removed (or their value forwarded TODO)
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
      if (iff->condition->type == Type::unreachable) {
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
        if (iff->ifTrue->type == Type::none ||
            iff->ifFalse->type == Type::none) {
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
      auto& list = block->list;
      if (name.is()) {
        Index size = flows.size();
        Index skip = 0;
        for (Index i = 0; i < size; i++) {
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
      }
      // Drop a nop at the end of a block, which prevents a value flowing. Note
      // that this is worth doing regardless of whether we have a name on this
      // block or not (which the if right above us checks) - such a nop is
      // always unneeded and can limit later optimizations.
      while (list.size() > 0 && list.back()->is<Nop>()) {
        list.resize(list.size() - 1);
        self->anotherCycle = true;
      }
      // A value flowing is only valid if it is a value that the block actually
      // flows out. If it is never reached, it does not flow out, and may be
      // invalid to represent as such.
      auto size = list.size();
      for (Index i = 0; i < size; i++) {
        if (i != size - 1 && list[i]->type == Type::unreachable) {
          // No value flows out of this block.
          self->stopValueFlow();
          break;
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

  void stopFlow() { flows.clear(); }

  void removeValueFlow(Flows& currFlows) {
    currFlows.erase(std::remove_if(currFlows.begin(),
                                   currFlows.end(),
                                   [&](Expression** currp) {
                                     auto* curr = *currp;
                                     if (auto* ret = curr->dynCast<Return>()) {
                                       return ret->value;
                                     }
                                     return curr->cast<Break>()->value;
                                   }),
                    currFlows.end());
  }

  void stopValueFlow() { removeValueFlow(flows); }

  static void clear(RemoveUnusedBrs* self, Expression** currp) {
    self->flows.clear();
  }

  static void saveIfTrue(RemoveUnusedBrs* self, Expression** currp) {
    self->ifStack.push_back(std::move(self->flows));
  }

  void visitLoop(Loop* curr) { loops.push_back(curr); }

  void optimizeSwitch(Switch* curr) {
    // if the final element is the default, we don't need it
    while (!curr->targets.empty() && curr->targets.back() == curr->default_) {
      curr->targets.pop_back();
    }
    // if the first element is the default, we can remove it by shifting
    // everything (which does add a subtraction of a constant, but often that is
    // worth it as the constant can be folded away and/or we remove multiple
    // elements here)
    Index removable = 0;
    while (removable < curr->targets.size() &&
           curr->targets[removable] == curr->default_) {
      removable++;
    }
    if (removable > 0) {
      for (Index i = removable; i < curr->targets.size(); i++) {
        curr->targets[i - removable] = curr->targets[i];
      }
      curr->targets.resize(curr->targets.size() - removable);
      Builder builder(*getModule());
      curr->condition = builder.makeBinary(
        SubInt32, curr->condition, builder.makeConst(int32_t(removable)));
    }
    // when there isn't a value, we can do some trivial optimizations without
    // worrying about the value being executed before the condition
    if (curr->value) {
      return;
    }
    if (curr->targets.size() == 0) {
      // a switch with just a default always goes there
      Builder builder(*getModule());
      replaceCurrent(builder.makeSequence(builder.makeDrop(curr->condition),
                                          builder.makeBreak(curr->default_)));
    } else if (curr->targets.size() == 1) {
      // a switch with two options is basically an if
      Builder builder(*getModule());
      replaceCurrent(builder.makeIf(curr->condition,
                                    builder.makeBreak(curr->default_),
                                    builder.makeBreak(curr->targets.front())));
    } else {
      // there are also some other cases where we want to convert a switch into
      // ifs, especially if the switch is large and we are focusing on size. an
      // especially egregious case is a switch like this: [a b b [..] b b c]
      // with default b (which may be arrived at after we trim away excess
      // default values on both sides). in this case, we really have 3 values in
      // a simple form, so it is the next logical case after handling 1 and 2
      // values right above here. to optimize this, we must add a local + a
      // bunch of nodes (if*2, tee, eq, get, const, break*3), so the table must
      // be big enough for it to make sense

      // How many targets we need when shrinking. This is literally the size at
      // which the transformation begins to be smaller.
      const uint32_t MIN_SHRINK = 13;
      // How many targets we need when not shrinking, in which case, 2 ifs may
      // be slower, so we do this when the table is ridiculously large for one
      // with just 3 values in it.
      const uint32_t MIN_GENERAL = 128;

      auto shrink = getPassRunner()->options.shrinkLevel > 0;
      if ((curr->targets.size() >= MIN_SHRINK && shrink) ||
          (curr->targets.size() >= MIN_GENERAL && !shrink)) {
        for (Index i = 1; i < curr->targets.size() - 1; i++) {
          if (curr->targets[i] != curr->default_) {
            return;
          }
        }
        // great, we are in that case, optimize
        Builder builder(*getModule());
        auto temp = builder.addVar(getFunction(), Type::i32);
        Expression* z;
        replaceCurrent(z = builder.makeIf(
                         builder.makeLocalTee(temp, curr->condition, Type::i32),
                         builder.makeIf(builder.makeBinary(
                                          EqInt32,
                                          builder.makeLocalGet(temp, Type::i32),
                                          builder.makeConst(
                                            int32_t(curr->targets.size() - 1))),
                                        builder.makeBreak(curr->targets.back()),
                                        builder.makeBreak(curr->default_)),
                         builder.makeBreak(curr->targets.front())));
      }
    }
  }

  void visitIf(If* curr) {
    if (!curr->ifFalse) {
      // if without an else. try to reduce
      //    if (condition) br  =>  br_if (condition)
      if (Break* br = curr->ifTrue->dynCast<Break>()) {
        if (canTurnIfIntoBrIf(
              curr->condition, br->value, getPassOptions(), *getModule())) {
          if (!br->condition) {
            br->condition = curr->condition;
          } else {
            // In this case we can replace
            //   if (condition1) br_if (condition2)
            // =>
            //   br_if select (condition1) (condition2) (i32.const 0)
            // In other words, we replace an if (3 bytes) with a select and a
            // zero (also 3 bytes). The size is unchanged, but the select may
            // be further optimizable, and if select does not branch we also
            // avoid one branch.
            // Multivalue selects are not supported
            if (br->value && br->value->type.isTuple()) {
              return;
            }
            // If running the br's condition unconditionally is too expensive,
            // give up.
            auto* zero = LiteralUtils::makeZero(Type::i32, *getModule());
            if (tooCostlyToRunUnconditionally(
                  getPassOptions(), br->condition, zero)) {
              return;
            }
            // Of course we can't do this if the br's condition has side
            // effects, as we would then execute those unconditionally.
            if (EffectAnalyzer(getPassOptions(), *getModule(), br->condition)
                  .hasSideEffects()) {
              return;
            }
            Builder builder(*getModule());
            // Note that we use the br's condition as the select condition.
            // That keeps the order of the two conditions as it was originally.
            br->condition =
              builder.makeSelect(br->condition, curr->condition, zero);
          }
          br->finalize();
          replaceCurrent(Builder(*getModule()).dropIfConcretelyTyped(br));
          anotherCycle = true;
        }
      }

      // if (condition-A) { if (condition-B) .. }
      //   =>
      // if (condition-A ? condition-B : 0) { .. }
      //
      // This replaces an if, which is 3 bytes, with a select plus a zero, which
      // is also 3 bytes. The benefit is that the select may be faster, and also
      // further optimizations may be possible on the select.
      if (auto* child = curr->ifTrue->dynCast<If>()) {
        if (child->ifFalse) {
          return;
        }
        // If running the child's condition unconditionally is too expensive,
        // give up.
        if (tooCostlyToRunUnconditionally(getPassOptions(), child->condition)) {
          return;
        }
        // Of course we can't do this if the inner if's condition has side
        // effects, as we would then execute those unconditionally.
        if (EffectAnalyzer(getPassOptions(), *getModule(), child->condition)
              .hasSideEffects()) {
          return;
        }
        Builder builder(*getModule());
        curr->condition = builder.makeSelect(
          child->condition, curr->condition, builder.makeConst(int32_t(0)));
        curr->ifTrue = child->ifTrue;
      }
    }
    // TODO: if-else can be turned into a br_if as well, if one of the sides is
    //       a dead end we handle the case of a returned value to a local.set
    //       later down, see visitLocalSet.
  }

  // override scan to add a pre and a post check task to all nodes
  static void scan(RemoveUnusedBrs* self, Expression** currp) {
    self->pushTask(visitAny, currp);

    auto* iff = (*currp)->dynCast<If>();

    if (iff) {
      if (iff->condition->type == Type::unreachable) {
        // avoid trying to optimize this, we never reach it anyhow
        return;
      }
      self->pushTask(doVisitIf, currp);
      if (iff->ifFalse) {
        // we need to join up if-else control flow, and clear after the
        // condition
        self->pushTask(scan, &iff->ifFalse);
        // safe the ifTrue flow, we'll join it later
        self->pushTask(saveIfTrue, currp);
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
    if (!loop->name.is()) {
      return false;
    }
    auto* block = loop->body->dynCast<Block>();
    if (!block) {
      return false;
    }
    // does the last element break to the top of the loop?
    auto& list = block->list;
    if (list.size() <= 1) {
      return false;
    }
    auto* last = list.back()->dynCast<Break>();
    if (!last || !ExpressionAnalyzer::isSimple(last) ||
        last->name != loop->name) {
      return false;
    }
    // last is a simple break to the top of the loop. if we can conditionalize
    // it, it won't block things from flowing out and not needing breaks to do
    // so.
    Index i = list.size() - 2;
    Builder builder(*getModule());
    while (1) {
      auto* curr = list[i];
      if (auto* iff = curr->dynCast<If>()) {
        // let's try to move the code going to the top of the loop into the
        // if-else
        if (!iff->ifFalse) {
          // we need the ifTrue to break, so it cannot reach the code we want to
          // move
          if (iff->ifTrue->type == Type::unreachable) {
            iff->ifFalse = stealSlice(builder, block, i + 1, list.size());
            iff->finalize();
            block->finalize();
            return true;
          }
        } else {
          // this is already an if-else. if one side is a dead end, we can
          // append to the other, if there is no returned value to concern us

          // can't be, since in the middle of a block
          assert(!iff->type.isConcrete());

          // ensures the first node is a block, if it isn't already, and merges
          // in the second, either as a single element or, if a block, by
          // appending to the first block. this keeps the order of operations in
          // place, that is, the appended element will be executed after the
          // first node's elements
          auto blockifyMerge = [&](Expression* any,
                                   Expression* append) -> Block* {
            Block* block = nullptr;
            if (any) {
              block = any->dynCast<Block>();
            }
            // if the first isn't a block, or it's a block with a name (so we
            // might branch to the end, and so can't append to it, we might skip
            // that code!) then make a new block
            if (!block || block->name.is()) {
              block = builder.makeBlock(any);
            } else {
              assert(!block->type.isConcrete());
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

          if (iff->ifTrue->type == Type::unreachable) {
            iff->ifFalse = blockifyMerge(
              iff->ifFalse, stealSlice(builder, block, i + 1, list.size()));
            iff->finalize();
            block->finalize();
            return true;
          } else if (iff->ifFalse->type == Type::unreachable) {
            iff->ifTrue = blockifyMerge(
              iff->ifTrue, stealSlice(builder, block, i + 1, list.size()));
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
            // there is the br_if, and then the br to the top, so just flip them
            // and the condition
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
            //  (b) this br_if is the only branch to that block (so the block
            //      will vanish)
            if (brIf->name == block->name &&
                BranchUtils::BranchSeeker::count(block, block->name) == 1) {
              // note that we could drop the last element here, it is a br we
              // know for sure is removable, but telling stealSlice to steal all
              // to the end is more efficient, it can just truncate.
              list[i] =
                builder.makeIf(brIf->condition,
                               builder.makeBreak(brIf->name),
                               stealSlice(builder, block, i + 1, list.size()));
              block->finalize();
              return true;
            }
          }
        }
        return false;
      }
      // if there is control flow, we must stop looking
      if (EffectAnalyzer(getPassOptions(), *getModule(), curr)
            .transfersControlFlow()) {
        return false;
      }
      if (i == 0) {
        return false;
      }
      i--;
    }
  }

  bool sinkBlocks(Function* func) {
    struct Sinker : public PostWalker<Sinker> {
      bool worked = false;

      void visitBlock(Block* curr) {
        // If the block has a single child which is a loop, and the block is
        // named, then it is the exit for the loop. It's better to move it into
        // the loop, where it can be better optimized by other passes. Similar
        // logic for ifs: if the block is an exit for the if, we can move the
        // block in, consider for example:
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
            if (BranchUtils::BranchSeeker::count(iff->condition, curr->name) ==
                0) {
              // We can move the block into either arm, if there are no uses in
              // the other.
              Expression** target = nullptr;
              if (!iff->ifFalse || BranchUtils::BranchSeeker::count(
                                     iff->ifFalse, curr->name) == 0) {
                target = &iff->ifTrue;
              } else if (BranchUtils::BranchSeeker::count(iff->ifTrue,
                                                          curr->name) == 0) {
                target = &iff->ifFalse;
              }
              if (target) {
                curr->list[0] = *target;
                *target = curr;
                // The block used to contain the if, and may have changed type
                // from unreachable to none, for example, if the if has an
                // unreachable condition but the arm is not unreachable.
                curr->finalize();
                iff->finalize();
                replaceCurrent(iff);
                worked = true;
                // Note that the type might change, e.g. if the if condition is
                // unreachable but the block that was on the outside had a
                // break.
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

  // GC-specific optimizations. These are split out from the main code to keep
  // things as simple as possible.
  bool optimizeGC(Function* func) {
    if (!getModule()->features.hasGC()) {
      return false;
    }

    struct Optimizer : public PostWalker<Optimizer> {
      PassOptions& passOptions;
      bool worked = false;

      Optimizer(PassOptions& passOptions) : passOptions(passOptions) {}

      void visitBrOn(BrOn* curr) {
        // Ignore unreachable BrOns which we cannot improve anyhow. Note that
        // we must check the ref field manually, as we may be changing types as
        // we go here. (Another option would be to use a TypeUpdater here
        // instead of calling ReFinalize at the very end, but that would be more
        // complex and slower.)
        if (curr->type == Type::unreachable ||
            curr->ref->type == Type::unreachable) {
          return;
        }

        Builder builder(*getModule());

        Type refType =
          Properties::getFallthroughType(curr->ref, passOptions, *getModule());
        if (refType == Type::unreachable) {
          // Leave this to DCE.
          return;
        }
        assert(refType.isRef());

        // When we optimize based on all the fallthrough type information
        // available, we may need to insert a cast to maintain validity. For
        // example, in this case we know the cast will succeed, but it would be
        // invalid to send curr->ref directly:
        //
        //   (br_on_cast $l anyref i31ref
        //     (block (result anyref)
        //       (ref.i31 ...)))
        //
        // We could just always do the cast and leave removing the casts to
        // OptimizeInstructions, but it's simple enough to avoid unnecessary
        // casting here.
        auto maybeCast = [&](Expression* expr, Type type) -> Expression* {
          assert(expr->type.isRef() && type.isRef());
          if (Type::isSubType(expr->type, type)) {
            return expr;
          }
          if (HeapType::isSubType(expr->type.getHeapType(),
                                  type.getHeapType())) {
            return builder.makeRefAs(RefAsNonNull, expr);
          }
          return builder.makeRefCast(expr, type);
        };

        if (curr->op == BrOnNull) {
          if (refType.isNull()) {
            // The branch will definitely be taken.
            replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                                builder.makeBreak(curr->name)));
            worked = true;
            return;
          }
          if (refType.isNonNullable()) {
            // The branch will definitely not be taken.
            replaceCurrent(maybeCast(curr->ref, curr->type));
            worked = true;
            return;
          }
          return;
        }

        if (curr->op == BrOnNonNull) {
          if (refType.isNull()) {
            // Definitely not taken.
            replaceCurrent(builder.makeDrop(curr->ref));
            worked = true;
            return;
          }
          if (refType.isNonNullable()) {
            // Definitely taken.
            replaceCurrent(builder.makeBreak(
              curr->name, maybeCast(curr->ref, curr->getSentType())));
            worked = true;
            return;
          }
          return;
        }

        // Improve the cast target type as much as possible given what we know
        // about the input. Unlike in BrOn::finalize(), we consider type
        // information from all the fallthrough values here. We can continue to
        // further optimizations after this, and those optimizations might even
        // benefit from this improvement.
        auto glb = Type::getGreatestLowerBound(curr->castType, refType);
        if (glb != Type::unreachable && glb != curr->castType) {
          curr->castType = glb;
          curr->finalize();
          worked = true;
        }

        // Depending on what we know about the cast results, we may be able to
        // optimize.
        auto result = GCTypeUtils::evaluateCastCheck(refType, curr->castType);
        if (curr->op == BrOnCastFail) {
          result = GCTypeUtils::flipEvaluationResult(result);
        }

        switch (result) {
          case GCTypeUtils::Unknown:
            // Anything could happen, so we cannot optimize.
            return;
          case GCTypeUtils::Success: {
            replaceCurrent(builder.makeBreak(
              curr->name, maybeCast(curr->ref, curr->getSentType())));
            worked = true;
            return;
          }
          case GCTypeUtils::Failure: {
            replaceCurrent(maybeCast(curr->ref, curr->type));
            worked = true;
            return;
          }
          case GCTypeUtils::SuccessOnlyIfNull: {
            // TODO: optimize this case using the following replacement, which
            // avoids using any scratch locals and only does a single null
            // check, but does require generating a fresh label:
            //
            //   (br_on_cast $l (ref null $X) (ref null $Y)
            //     (...)
            //   )
            //     =>
            //   (block $l' (result (ref $X))
            //     (br_on_non_null $l' ;; reuses `curr`
            //       (...)
            //     )
            //     (br $l
            //       (ref.null bot<X>)
            //     )
            //   )
            return;
          }
          case GCTypeUtils::SuccessOnlyIfNonNull: {
            // Perform this replacement:
            //
            //   (br_on_cast $l (ref null $X') (ref $X))
            //     (...)
            //   )
            //     =>
            //   (block (result (ref bot<X>))
            //     (br_on_non_null $l ;; reuses `curr`
            //       (...)
            //     (ref.null bot<X>)
            //   )
            curr->ref = maybeCast(
              curr->ref, Type(curr->getSentType().getHeapType(), Nullable));
            curr->op = BrOnNonNull;
            curr->castType = Type::none;
            curr->type = Type::none;

            assert(curr->ref->type.isRef());
            auto* refNull = builder.makeRefNull(curr->ref->type.getHeapType());
            replaceCurrent(builder.makeBlock({curr, refNull}, refNull->type));
            worked = true;
            return;
          }
          case GCTypeUtils::Unreachable: {
            // The cast is never executed, possibly because its input type is
            // uninhabitable. Replace it with unreachable.
            auto* drop = builder.makeDrop(curr->ref);
            auto* unreachable = ExpressionManipulator::unreachable(curr);
            replaceCurrent(builder.makeBlock({drop, unreachable}));
            worked = true;
            return;
          }
        }
      }
    } optimizer(getPassOptions());

    optimizer.setModule(getModule());
    optimizer.doWalkFunction(func);

    // If we removed any BrOn instructions, that might affect the reachability
    // of the things they used to break to, so update types.
    if (optimizer.worked) {
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
      // flows may contain returns, which are flowing out and so can be
      // optimized
      for (Index i = 0; i < flows.size(); i++) {
        auto* flow = (*flows[i])->dynCast<Return>();
        if (!flow) {
          continue;
        }
        if (!flow->value) {
          // return => nop
          ExpressionManipulator::nop(flow);
        } else {
          // return with value => value
          *flows[i] = flow->value;
        }
        anotherCycle = true;
      }
      flows.clear();
      // optimize loops (we don't do it while tracking flows, as they can
      // interfere)
      for (auto* loop : loops) {
        anotherCycle |= optimizeLoop(loop);
      }
      loops.clear();
      if (anotherCycle) {
        ReFinalize().walkFunctionInModule(func, getModule());
      }
      if (sinkBlocks(func)) {
        anotherCycle = true;
      }
      if (optimizeGC(func)) {
        anotherCycle = true;
      }
    } while (anotherCycle);

    // thread trivial jumps
    struct JumpThreader : public ControlFlowWalker<JumpThreader> {
      // map of all value-less breaks and switches going to a block (and not a
      // loop)
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
          // if this block has just one child, a sub-block, then jumps to the
          // former are jumps to us, really
          if (auto* child = list[0]->dynCast<Block>()) {
            // the two blocks must have the same type for us to update the
            // branch, as otherwise one block may be unreachable and the other
            // concrete, so one might lack a value
            if (child->name.is() && child->name != curr->name &&
                child->type == curr->type) {
              redirectBranches(child, curr->name);
            }
          }
        } else if (list.size() == 2) {
          // if this block has two children, a child-block and a simple jump,
          // then jumps to child-block can be replaced with jumps to the new
          // target
          auto* child = list[0]->dynCast<Block>();
          auto* jump = list[1]->dynCast<Break>();
          if (child && child->name.is() && jump &&
              ExpressionAnalyzer::isSimple(jump)) {
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
        // if the jump is to another block then we can update the list, and
        // maybe push it even more later
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
        // if a block has an if br else br, we can un-conditionalize the latter,
        // allowing the if to become a br_if.
        // * note that if not in a block already, then we need to create a block
        //   for this, so not useful otherwise
        // * note that this only happens at the end of a block, as code after
        //   the if is dead
        // * note that we do this at the end, because un-conditionalizing can
        //   interfere with optimizeLoop()ing.
        auto& list = curr->list;
        for (Index i = 0; i < list.size(); i++) {
          auto* iff = list[i]->dynCast<If>();
          if (!iff || !iff->ifFalse) {
            // if it lacked an if-false, it would already be a br_if, as that's
            // the easy case
            continue;
          }
          auto* ifTrueBreak = iff->ifTrue->dynCast<Break>();
          if (ifTrueBreak && !ifTrueBreak->condition &&
              canTurnIfIntoBrIf(iff->condition,
                                ifTrueBreak->value,
                                passOptions,
                                *getModule())) {
            // we are an if-else where the ifTrue is a break without a
            // condition, so we can do this
            ifTrueBreak->condition = iff->condition;
            ifTrueBreak->finalize();
            list[i] = Builder(*getModule()).dropIfConcretelyTyped(ifTrueBreak);
            ExpressionManipulator::spliceIntoBlock(curr, i + 1, iff->ifFalse);
            continue;
          }
          // otherwise, perhaps we can flip the if
          auto* ifFalseBreak = iff->ifFalse->dynCast<Break>();
          if (ifFalseBreak && !ifFalseBreak->condition &&
              canTurnIfIntoBrIf(iff->condition,
                                ifFalseBreak->value,
                                passOptions,
                                *getModule())) {
            ifFalseBreak->condition =
              Builder(*getModule()).makeUnary(EqZInt32, iff->condition);
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
            // avoid unreachable brs, as they are dead code anyhow, and after
            // merging them the outer scope could need type changes
            if (!br1 || !br1->condition || br1->type == Type::unreachable) {
              continue;
            }
            assert(!br1->value);
            auto* br2 = list[i + 1]->dynCast<Break>();
            if (!br2 || br1->name != br2->name) {
              continue;
            }
            assert(!br2->value); // same target as previous, which has no value
            // a br_if and then a br[_if] with the same target right after it
            if (br2->condition) {
              if (shrink && br2->type != Type::unreachable) {
                // Join adjacent br_ifs to the same target, making one br_if
                // with a "selectified" condition that executes both.
                if (!EffectAnalyzer(passOptions, *getModule(), br2->condition)
                       .hasSideEffects()) {
                  // it's ok to execute them both, do it
                  Builder builder(*getModule());
                  br1->condition =
                    builder.makeBinary(OrInt32, br1->condition, br2->condition);
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
          // This switch has just one target no matter what; replace with a br
          // if we can (to do so, we must put the condition before a possible
          // value).
          if (!curr->value ||
              EffectAnalyzer::canReorder(
                passOptions, *getModule(), curr->condition, curr->value)) {
            Builder builder(*getModule());
            replaceCurrent(builder.makeSequence(
              builder.makeDrop(curr->condition), // might have side effects
              builder.makeBreak(curr->default_, curr->value)));
          }
        }
      }

      // Restructuring of ifs: if we have
      //   (block $x
      //     (drop (br_if $x (cond)))
      //     .., no other references to $x
      //   )
      // then we can turn that into (if (!cond) ..).
      // Code size wise, we turn the block into an if (no change), and
      // lose the br_if (-2). .. turns into the body of the if in the binary
      // format. We need to flip the condition, which at worst adds 1.
      // If the block has a return value, we can do something similar, removing
      // the drop from the br_if and putting the if on the outside,
      //   (block $x
      //     (drop (br_if $x (value) (cond)))
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
          // Check if the br is conditional and goes to the block. It may or may
          // not have a value, depending on if it was dropped or not. If the
          // type is unreachable that means it is not actually reached, which we
          // can ignore.
          Builder builder(*getModule());
          if (br && br->condition && br->name == curr->name &&
              br->type != Type::unreachable) {
            if (BranchUtils::BranchSeeker::count(curr, curr->name) == 1) {
              // no other breaks to that name, so we can do this
              if (!drop) {
                assert(!br->value);
                replaceCurrent(builder.makeIf(
                  builder.makeUnary(EqZInt32, br->condition), curr));
                ExpressionManipulator::nop(br);
                curr->finalize(curr->type);
              } else {
                // To use an if, the value must have no side effects, as in the
                // if it may not execute.
                if (!EffectAnalyzer(passOptions, *getModule(), br->value)
                       .hasSideEffects()) {
                  // We also need to reorder the condition and the value.
                  if (EffectAnalyzer::canReorder(
                        passOptions, *getModule(), br->condition, br->value)) {
                    ExpressionManipulator::nop(list[0]);
                    replaceCurrent(
                      builder.makeIf(br->condition, br->value, curr));
                  }
                } else {
                  // The value has side effects, so it must always execute. We
                  // may still be able to optimize this, however, by using a
                  // select:
                  //   (block $x
                  //     (drop (br_if $x (value) (cond)))
                  //     ..., no other references to $x
                  //     ..final element..
                  //   )
                  // =>
                  //   (select
                  //     (value)
                  //     (block $x
                  //       ..., no other references to $x
                  //       ..final element..
                  //     )
                  //     (cond)
                  //   )
                  // To do this we must be able to reorder the condition with
                  // the rest of the block (but not the value), and we must be
                  // able to make the rest of the block always execute, so it
                  // must not have side effects.
                  // TODO: we can do this when there *are* other refs to $x,
                  //       with a larger refactoring here.

                  // Test for the conditions with a temporary nop instead of the
                  // br_if.
                  Expression* old = list[0];
                  Nop nop;
                  // After this assignment, curr is what is left in the block
                  // after ignoring the br_if.
                  list[0] = &nop;
                  auto canReorder = EffectAnalyzer::canReorder(
                    passOptions, *getModule(), br->condition, curr);
                  auto hasSideEffects =
                    EffectAnalyzer(passOptions, *getModule(), curr)
                      .hasSideEffects();
                  list[0] = old;
                  if (canReorder && !hasSideEffects &&
                      Properties::canEmitSelectWithArms(br->value, curr)) {
                    ExpressionManipulator::nop(list[0]);
                    replaceCurrent(
                      builder.makeSelect(br->condition, br->value, curr));
                  }
                }
              }
            }
          }
        }
      }

      void visitIf(If* curr) {
        // we may have simplified ifs enough to turn them into selects
        if (auto* select = selectify(curr)) {
          replaceCurrent(select);
        }
      }

      // Convert an if into a select, if possible and beneficial to do so.
      Select* selectify(If* iff) {
        // Only an if-else can be turned into a select.
        if (!iff->ifFalse) {
          return nullptr;
        }
        if (!Properties::canEmitSelectWithArms(iff->ifTrue, iff->ifFalse)) {
          return nullptr;
        }
        if (iff->condition->type == Type::unreachable) {
          // An if with an unreachable condition may nonetheless have a type
          // that is not unreachable,
          //
          // (if (result i32) (unreachable) ..)
          //
          // Turning such an if into a select would change the type of the
          // expression, which would require updating types further up. Avoid
          // that, leaving dead code elimination to that dedicated pass.
          return nullptr;
        }
        // This is always helpful for code size, but can be a tradeoff with
        // performance as we run both code paths. So when shrinking we always
        // try to do this, but otherwise must consider more carefully.
        if (tooCostlyToRunUnconditionally(
              passOptions, iff->ifTrue, iff->ifFalse)) {
          return nullptr;
        }
        // Check if side effects allow this: we need to execute the two arms
        // unconditionally, and also to make the condition run last.
        EffectAnalyzer ifTrue(passOptions, *getModule(), iff->ifTrue);
        if (ifTrue.hasSideEffects()) {
          return nullptr;
        }
        EffectAnalyzer ifFalse(passOptions, *getModule(), iff->ifFalse);
        if (ifFalse.hasSideEffects()) {
          return nullptr;
        }
        EffectAnalyzer condition(passOptions, *getModule(), iff->condition);
        if (condition.invalidates(ifTrue) || condition.invalidates(ifFalse)) {
          return nullptr;
        }
        return Builder(*getModule())
          .makeSelect(iff->condition, iff->ifTrue, iff->ifFalse, iff->type);
      }

      void visitLocalSet(LocalSet* curr) {
        // Sets of an if can be optimized in various ways that remove part of
        // the if branching, or all of it.
        // The optimizations we can do here can recurse and call each
        // other, so pass around a pointer to the output.
        optimizeSetIf(getCurrentPointer());
      }

      void optimizeSetIf(Expression** currp) {
        if (optimizeSetIfWithBrArm(currp)) {
          return;
        }
        if (optimizeSetIfWithCopyArm(currp)) {
          return;
        }
      }

      // If one arm is a br, we prefer a br_if and the set later:
      //  (local.set $x
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
      //  (local.set $x
      //    (..result)
      //  )
      // TODO: handle a condition in the br? need to watch for side effects
      bool optimizeSetIfWithBrArm(Expression** currp) {
        auto* set = (*currp)->cast<LocalSet>();
        auto* iff = set->value->dynCast<If>();
        if (!iff || !iff->type.isConcrete() ||
            !iff->condition->type.isConcrete()) {
          return false;
        }
        auto tryToOptimize =
          [&](Expression* one, Expression* two, bool flipCondition) {
            if (one->type == Type::unreachable &&
                two->type != Type::unreachable) {
              if (auto* br = one->dynCast<Break>()) {
                if (ExpressionAnalyzer::isSimple(br)) {
                  // Wonderful, do it!
                  Builder builder(*getModule());
                  if (flipCondition) {
                    builder.flip(iff);
                  }
                  br->condition = iff->condition;
                  br->finalize();
                  set->value = two;
                  auto* block = builder.makeSequence(br, set);
                  *currp = block;
                  // Recurse on the set, which now has a new value.
                  optimizeSetIf(&block->list[1]);
                  return true;
                }
              }
            }
            return false;
          };
        return tryToOptimize(iff->ifTrue, iff->ifFalse, false) ||
               tryToOptimize(iff->ifFalse, iff->ifTrue, true);
      }

      // If one arm is a get of the same outer set, it is a copy which
      // we can remove. If this is not a tee, then we remove the get
      // as well as the if-else opcode in the binary format, which is
      // great:
      //  (local.set $x
      //    (if (result i32)
      //      (..condition..)
      //      (..result)
      //      (local.get $x)
      //    )
      //  )
      // =>
      //  (if
      //    (..condition..)
      //    (local.set $x
      //      (..result)
      //    )
      //  )
      // If this is a tee, then we can do the same operation but
      // inside a block, and keep the get:
      //  (local.tee $x
      //    (if (result i32)
      //      (..condition..)
      //      (..result)
      //      (local.get $x)
      //    )
      //  )
      // =>
      //  (block (result i32)
      //    (if
      //      (..condition..)
      //      (local.set $x
      //        (..result)
      //      )
      //    )
      //    (local.get $x)
      //  )
      // We save the if-else opcode, and add the block's opcodes.
      // This may be detrimental, however, often the block can be
      // merged or eliminated given the outside scope, and we
      // removed one of the if branches.
      bool optimizeSetIfWithCopyArm(Expression** currp) {
        auto* set = (*currp)->cast<LocalSet>();
        auto* iff = set->value->dynCast<If>();
        if (!iff || !iff->type.isConcrete() ||
            !iff->condition->type.isConcrete()) {
          return false;
        }
        Builder builder(*getModule());
        LocalGet* get = iff->ifTrue->dynCast<LocalGet>();
        if (get && get->index == set->index) {
          builder.flip(iff);
        } else {
          get = iff->ifFalse->dynCast<LocalGet>();
          if (get && get->index != set->index) {
            get = nullptr;
          }
        }
        if (!get) {
          return false;
        }
        // We can do it!
        bool tee = set->isTee();
        assert(set->index == get->index);
        assert(iff->ifFalse == get);
        set->value = iff->ifTrue;
        set->finalize();
        iff->ifTrue = set;
        iff->ifFalse = nullptr;
        iff->finalize();
        Expression* replacement = iff;
        if (tee) {
          set->makeSet();
          // We need a block too.
          replacement = builder.makeSequence(iff,
                                             get // reuse the get
          );
        }
        *currp = replacement;
        // Recurse on the set, which now has a new value.
        optimizeSetIf(&iff->ifTrue);
        return true;
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
        auto& list = block->list;
        if (list.size() <= 1) {
          return;
        }

        // Heuristics. These are slightly inspired by the constants from the
        // asm.js backend.

        // How many br_ifs we need to see to consider doing this
        const uint32_t MIN_NUM = 3;
        // How much of a range of values is definitely too big
        const uint32_t MAX_RANGE = 1024;
        // Multiplied by the number of br_ifs, then compared to the range. When
        // this is high, we allow larger ranges.
        const uint32_t NUM_TO_RANGE_FACTOR = 3;

        // check if the input is a proper br_if on an i32.eq of a condition
        // value to a const, and the const is in the proper range,
        // [0-int32_max), to avoid overflow concerns. returns the br_if if so,
        // or nullptr otherwise
        auto getProperBrIf = [](Expression* curr) -> Break* {
          auto* br = curr->dynCast<Break>();
          if (!br) {
            return nullptr;
          }
          if (!br->condition || br->value) {
            return nullptr;
          }
          if (br->type != Type::none) {
            // no value, so can be unreachable or none. ignore unreachable ones,
            // dce will clean it up
            return nullptr;
          }
          auto* condition = br->condition;
          // Also support eqz, which is the same as == 0.
          if (auto* unary = condition->dynCast<Unary>()) {
            if (unary->op == EqZInt32) {
              return br;
            }
            return nullptr;
          }
          auto* binary = condition->dynCast<Binary>();
          if (!binary) {
            return nullptr;
          }
          if (binary->op != EqInt32) {
            return nullptr;
          }
          auto* c = binary->right->dynCast<Const>();
          if (!c) {
            return nullptr;
          }
          uint32_t value = c->value.geti32();
          if (value >= uint32_t(std::numeric_limits<int32_t>::max())) {
            return nullptr;
          }
          return br;
        };

        // check if the input is a proper br_if
        // and returns the condition if so, or nullptr otherwise
        auto getProperBrIfConditionValue =
          [&getProperBrIf](Expression* curr) -> Expression* {
          auto* br = getProperBrIf(curr);
          if (!br) {
            return nullptr;
          }
          auto* condition = br->condition;
          if (auto* binary = condition->dynCast<Binary>()) {
            return binary->left;
          } else if (auto* unary = condition->dynCast<Unary>()) {
            assert(unary->op == EqZInt32);
            return unary->value;
          } else {
            WASM_UNREACHABLE("invalid br_if condition");
          }
        };

        // returns the constant value, as a uint32_t
        auto getProperBrIfConstant =
          [&getProperBrIf](Expression* curr) -> uint32_t {
          auto* condition = getProperBrIf(curr)->condition;
          if (auto* binary = condition->dynCast<Binary>()) {
            return binary->right->cast<Const>()->value.geti32();
          } else if ([[maybe_unused]] auto* unary =
                       condition->dynCast<Unary>()) {
            assert(unary->op == EqZInt32);
            return 0;
          } else {
            WASM_UNREACHABLE("invalid br_if condition");
          }
        };
        Index start = 0;
        while (start < list.size() - 1) {
          auto* conditionValue = getProperBrIfConditionValue(list[start]);
          if (!conditionValue) {
            start++;
            continue;
          }
          // If the first condition value is a tee, that is ok, so long as the
          // others afterwards are gets of the value that is tee'd.
          LocalGet get;
          if (auto* tee = conditionValue->dynCast<LocalSet>()) {
            get.index = tee->index;
            get.type = getFunction()->getLocalType(get.index);
            conditionValue = &get;
          }
          // if the condition has side effects, we can't replace many
          // appearances of it with a single one
          if (EffectAnalyzer(passOptions, *getModule(), conditionValue)
                .hasSideEffects()) {
            start++;
            continue;
          }
          // look for a "run" of br_ifs with all the same conditionValue, and
          // having unique constants (an overlapping constant could be handled,
          // just the first branch is taken, but we can't remove the other br_if
          // (it may be the only branch keeping a block reachable), which may
          // make this bad for code size.
          Index end = start + 1;
          std::unordered_set<uint32_t> usedConstants;
          usedConstants.insert(getProperBrIfConstant(list[start]));
          while (end < list.size() &&
                 ExpressionAnalyzer::equal(
                   getProperBrIfConditionValue(list[end]), conditionValue)) {
            if (!usedConstants.insert(getProperBrIfConstant(list[end]))
                   .second) {
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
            if (range <= MAX_RANGE && range <= num * NUM_TO_RANGE_FACTOR) {
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
                if (usedNames.count(defaultName) == 0) {
                  break;
                }
              }
              std::vector<Name> table;
              for (Index i = start; i < end; i++) {
                auto name = getProperBrIf(list[i])->name;
                auto index = getProperBrIfConstant(list[i]);
                index -= min;
                while (table.size() <= index) {
                  table.push_back(defaultName);
                }
                // we should have made sure there are no overlaps
                assert(table[index] == defaultName);
                table[index] = name;
              }
              Builder builder(*getModule());
              // the table and condition are offset by the min
              auto* newCondition = getProperBrIfConditionValue(list[start]);

              if (min != 0) {
                newCondition = builder.makeBinary(
                  SubInt32, newCondition, builder.makeConst(int32_t(min)));
              }
              list[end - 1] = builder.makeBlock(
                defaultName,
                builder.makeSwitch(table, defaultName, newCondition));
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

Pass* createRemoveUnusedBrsPass() { return new RemoveUnusedBrs(); }

} // namespace wasm
