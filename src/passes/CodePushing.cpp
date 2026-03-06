/*
 * Copyright 2016 WebAssembly Community Group participants
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
// Pushes code "forward" as much as possible, potentially into
// a location behind a condition, where it might not always execute.
//

#include <ir/effects.h>
#include <ir/manipulation.h>
#include <pass.h>
#include <wasm-builder.h>
#include <wasm.h>

namespace wasm {

//
// Analyzers some useful local properties: # of sets and gets, and SFA.
//
// Single First Assignment (SFA) form: the local has a single local.set, is
// not a parameter, and has no local.gets before the local.set in postorder.
// This is a much weaker property than SSA, obviously, but together with
// our implicit dominance properties in the structured AST is quite useful.
//
struct LocalAnalyzer : public PostWalker<LocalAnalyzer> {
  std::vector<bool> sfa;
  std::vector<Index> numSets;
  std::vector<Index> numGets;

  void analyze(Function* func) {
    auto num = func->getNumLocals();
    numSets.clear();
    numSets.resize(num);
    numGets.clear();
    numGets.resize(num);
    sfa.clear();
    sfa.resize(num);
    std::fill(sfa.begin() + func->getNumParams(), sfa.end(), true);
    walk(func->body);
    for (Index i = 0; i < num; i++) {
      if (numSets[i] == 0) {
        sfa[i] = false;
      }
    }
  }

  bool isSFA(Index i) { return sfa[i]; }

  Index getNumGets(Index i) { return numGets[i]; }

  void visitLocalGet(LocalGet* curr) {
    if (numSets[curr->index] == 0) {
      sfa[curr->index] = false;
    }
    numGets[curr->index]++;
  }

  void visitLocalSet(LocalSet* curr) {
    numSets[curr->index]++;
    if (numSets[curr->index] > 1) {
      sfa[curr->index] = false;
    }
  }
};

// Implements core optimization logic. Used and then discarded entirely
// for each block.
class Pusher {
  ExpressionList& list;
  LocalAnalyzer& analyzer;
  std::vector<Index>& numGetsSoFar;
  PassOptions& passOptions;
  Module& module;

public:
  Pusher(Block* block,
         LocalAnalyzer& analyzer,
         std::vector<Index>& numGetsSoFar,
         PassOptions& passOptions,
         Module& module)
    : list(block->list), analyzer(analyzer), numGetsSoFar(numGetsSoFar),
      passOptions(passOptions), module(module) {
    // Find an optimization segment: from the first pushable thing, to the first
    // point past which we want to push. We then push in that range before
    // continuing forward.
    const Index nothing = -1;
    Index i = 0;
    Index firstPushable = nothing;
    while (i < list.size()) {
      if (firstPushable == nothing && isPushable(list[i])) {
        firstPushable = i;
        i++;
        continue;
      }
      if (firstPushable != nothing && isPushPoint(list[i])) {
        // Optimize this segment, and proceed from where it tells us. First
        // optimize things into the if, if possible, which does not move the
        // push point. Then move things past the push point (which has the
        // relative effect of moving the push point backwards as other things
        // move forward).
        optimizeIntoIf(firstPushable, i);
        // We never need to push past a final element, as we couldn't be used
        // after it.
        if (i < list.size() - 1) {
          i = optimizeSegment(firstPushable, i);
        }
        firstPushable = nothing;
        continue;
      }
      i++;
    }
  }

private:
  LocalSet* isPushable(Expression* curr) {
    auto* set = curr->dynCast<LocalSet>();
    if (!set) {
      return nullptr;
    }
    auto index = set->index;
    // To be pushable, this must be SFA and the right # of gets.
    //
    // It must also not have side effects, as it may no longer execute after it
    // is pushed, since it may be behind a condition that ends up false some of
    // the time. However, removable side effects are ok here. The general
    // problem with removable effects is that we can only remove them, but not
    // move them, because of stuff like this:
    //
    //   if (x != 0) foo(1 / x);
    //
    // If we move 1 / x to execute unconditionally then it may trap, but it
    // would be fine to remove it. This pass does not move code to places where
    // it might execute more, but *less*: we keep the code behind any conditions
    // it was already behind, and potentially put it behind further ones. In
    // effect, we "partially remove" the code, making it not execute some of the
    // time, which is fine.
    if (analyzer.isSFA(index) &&
        numGetsSoFar[index] == analyzer.getNumGets(index) &&
        !EffectAnalyzer(passOptions, module, set->value)
           .hasUnremovableSideEffects()) {
      return set;
    }
    return nullptr;
  }

  // Try to push past conditional control flow.
  // TODO: push into ifs as well
  bool isPushPoint(Expression* curr) {
    // look through drops
    if (auto* drop = curr->dynCast<Drop>()) {
      curr = drop->value;
    }
    if (curr->is<If>() || curr->is<BrOn>()) {
      return true;
    }
    if (auto* br = curr->dynCast<Break>()) {
      return !!br->condition;
    }
    return false;
  }

  Index optimizeSegment(Index firstPushable, Index pushPoint) {
    // The interesting part. Starting at firstPushable, try to push
    // code past pushPoint. We start at the end since we are pushing
    // forward, that way we can push later things out of the way
    // of earlier ones. Once we know all we can push, we push it all
    // in one pass, keeping the order of the pushables intact.
    assert(firstPushable != Index(-1) && pushPoint != Index(-1) &&
           firstPushable < pushPoint);
    // everything that matters if you want to be pushed past the pushPoint
    EffectAnalyzer cumulativeEffects(passOptions, module);
    cumulativeEffects.walk(list[pushPoint]);
    // It is ok to ignore branching out of the block here, that is the crucial
    // point of this optimization. That is, we are in a situation like this:
    //
    // {
    //   x = value;
    //   if (..) break;
    //   foo(x);
    // }
    //
    // If the branch is taken, then that's fine, it will jump out of this block
    // and reach some outer scope, and in that case we never need x at all
    // (since we've proven before that x is not used outside of this block, see
    // numGetsSoFar which we use for that). Similarly, control flow could
    // transfer away via a return or an exception and that would be ok as well.
    cumulativeEffects.ignoreControlFlowTransfers();
    std::vector<LocalSet*> toPush;
    Index i = pushPoint - 1;
    while (1) {
      auto* pushable = isPushable(list[i]);
      if (pushable) {
        const auto& effects = getPushableEffects(pushable);
        if (cumulativeEffects.invalidates(effects)) {
          // we can't push this, so further pushables must pass it
          cumulativeEffects.mergeIn(effects);
        } else {
          // we can push this, great!
          toPush.push_back(pushable);
        }
      } else {
        // something that can't be pushed, so it might block further pushing
        cumulativeEffects.walk(list[i]);
      }
      if (i == firstPushable) {
        // no point in looking further
        break;
      }
      assert(i > 0);
      i--;
    }
    if (toPush.size() == 0) {
      // nothing to do, can only continue after the push point
      return pushPoint + 1;
    }
    // we have work to do!
    Index total = toPush.size();
    Index last = total - 1;
    Index skip = 0;
    for (Index i = firstPushable; i <= pushPoint; i++) {
      // we see the first elements at the end of toPush
      if (skip < total && list[i] == toPush[last - skip]) {
        // this is one of our elements to push, skip it
        skip++;
      } else {
        if (skip) {
          list[i - skip] = list[i];
        }
      }
    }
    assert(skip == total);
    // write out the skipped elements
    for (Index i = 0; i < total; i++) {
      list[pushPoint - i] = toPush[i];
    }
    // proceed right after the push point, we may push the pushed elements again
    return pushPoint - total + 1;
  }

  // Similar to optimizeSegment, but for the case where the push point is an if,
  // and we try to push into the if's arms, doing things like this:
  //
  //    x = op();
  //    if (..) {
  //      ..
  //    }
  // =>
  //    if (..) {
  //      x = op(); // this moved
  //      ..
  //    }
  //
  // This does not move the push point, so it does not have a return value,
  // unlike optimizeSegment.
  void optimizeIntoIf(Index firstPushable, Index pushPoint) {
    assert(firstPushable != Index(-1) && pushPoint != Index(-1) &&
           firstPushable < pushPoint);

    auto* iff = list[pushPoint]->dynCast<If>();
    if (!iff) {
      return;
    }

    // Everything that matters if you want to be pushed past the pushPoint. This
    // begins with the if condition's effects, as we must always push past
    // those. Later, we will add to this when we need to.
    EffectAnalyzer cumulativeEffects(passOptions, module, iff->condition);

    // See optimizeSegment for why we can ignore control flow transfers here.
    cumulativeEffects.ignoreControlFlowTransfers();

    // Find the effects of the arms, which will affect what can be pushed.
    EffectAnalyzer ifTrueEffects(passOptions, module, iff->ifTrue);
    EffectAnalyzer ifFalseEffects(passOptions, module);
    if (iff->ifFalse) {
      ifFalseEffects.walk(iff->ifFalse);
    }

    // We need to know which locals are used after the if, as that can determine
    // if we can push or not.
    EffectAnalyzer postIfEffects(passOptions, module);
    for (Index i = pushPoint + 1; i < list.size(); i++) {
      postIfEffects.walk(list[i]);
    }

    // Start at the instruction right before the push point, and go back from
    // there:
    //
    //    x = op();
    //    y = op();
    //    if (..) {
    //      ..
    //    }
    //
    // Here we will try to push y first, and then x. Note that if we push y
    // then we can immediately try to push x after it, as it will remain in
    // order with x if we do. If we do *not* push y we can still try to push x
    // but we must move it past y, which means we need to check for interference
    // between them (which we do by adding y's effects to cumulativeEffects).
    //
    // Decrement at the top of the loop for simplicity, so start with i at one
    // past the first thing we can push (which is right before the push point).
    Index i = pushPoint;
    while (1) {
      if (i == firstPushable) {
        // We just finished processing the first thing that could be pushed;
        // stop.
        break;
      }
      assert(i > 0);
      i--;
      auto* pushable = isPushable(list[i]);
      if (pushable && pushable->type == Type::unreachable) {
        // Don't try to push something unreachable. If we did, then we'd need to
        // refinalize the block we are moving it from:
        //
        //  (block $unreachable
        //    (local.set $x (unreachable))
        //    (if (..)
        //      (.. (local.get $x))
        //  )
        //
        // The block should not be unreachable if the local.set is moved into
        // the if arm (the if arm may not execute, so the if itself will not
        // change type). It is simpler to avoid this complexity and leave this
        // to DCE to simplify first.
        //
        // (Note that the side effect of trapping will normally prevent us from
        // trying to push something unreachable, but in traps-never-happen mode
        // we are allowed to ignore that, and so we need this check.)
        pushable = nullptr;
      }
      if (!pushable) {
        // Something that is staying where it is, so anything we push later must
        // move past it. Note the effects and continue.
        cumulativeEffects.walk(list[i]);
        continue;
      }

      auto index = pushable->index;

      const auto& effects = getPushableEffects(pushable);

      if (cumulativeEffects.invalidates(effects)) {
        // This can't be moved forward. Add it to the things that are not
        // moving.
        cumulativeEffects.walk(list[i]);
        continue;
      }

      // We only try to push into an arm if the local is used there. If the
      // local is not used in either arm then we'll want to push it past the
      // entire if, which is what optimizeSegment handles.
      //
      // We can push into the if-true arm if the local cannot be used if we go
      // through the other arm:
      //
      //    x = op();
      //    if (..) {
      //      // we would like to move "x = op()" to here
      //      ..
      //    } else {
      //      use(x);
      //    }
      //    use(x);
      //
      // Either of those use(x)s would stop us from moving to if-true arm.
      //
      // One specific case we handle is if there is a use after the if but the
      // arm we don't push into is unreachable. In that case we only get to the
      // later code after going through the reachable arm, which is ok to push
      // into:
      //
      //    x = op();
      //    if (..) {
      //      // We'll push "x = op()" to here.
      //      use(x);
      //    } else {
      //      return;
      //    }
      //    use(x);
      auto maybePushInto = [&](Expression*& arm,
                               const Expression* otherArm,
                               EffectAnalyzer& armEffects,
                               const EffectAnalyzer& otherArmEffects) {
        if (!arm || !armEffects.localsRead.count(index) ||
            otherArmEffects.localsRead.count(index)) {
          // No arm, or this arm has no read of the index, or the other arm
          // reads the index.
          return false;
        }
        if (postIfEffects.localsRead.count(index) &&
            (!otherArm || otherArm->type != Type::unreachable)) {
          // The local is read later, which is bad, and there is no unreachable
          // in the other arm which as mentioned above is the only thing that
          // could have made it work out for us.
          return false;
        }

        // We can do it! Push into one of the if's arms, and put a nop where it
        // used to be.
        Builder builder(module);
        auto* block = builder.blockify(arm);
        arm = block;
        // TODO: this is quadratic in the number of pushed things
        ExpressionManipulator::spliceIntoBlock(block, 0, pushable);
        list[i] = builder.makeNop();

        // The code we pushed adds to the effects in that arm.
        armEffects.walk(pushable);

        // TODO: After pushing we could recurse and run both this function and
        //       optimizeSegment in that location. For now, leave that to later
        //       cycles of the optimizer, as this case seems rairly rare.
        return true;
      };

      if (!maybePushInto(
            iff->ifTrue, iff->ifFalse, ifTrueEffects, ifFalseEffects) &&
          !maybePushInto(
            iff->ifFalse, iff->ifTrue, ifFalseEffects, ifTrueEffects)) {
        // We didn't push this anywhere, so further pushables must pass it.
        cumulativeEffects.mergeIn(effects);
      }
    }
  }

  const EffectAnalyzer& getPushableEffects(LocalSet* pushable) {
    auto iter = pushableEffects.find(pushable);
    if (iter == pushableEffects.end()) {
      iter =
        pushableEffects.try_emplace(pushable, passOptions, module, pushable)
          .first;
    }
    return iter->second;
  }

  // Pushables may need to be scanned more than once, so cache their effects.
  std::unordered_map<LocalSet*, EffectAnalyzer> pushableEffects;
};

struct CodePushing : public WalkerPass<PostWalker<CodePushing>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<CodePushing>();
  }

  LocalAnalyzer analyzer;

  // gets seen so far in the main traversal
  std::vector<Index> numGetsSoFar;

  void doWalkFunction(Function* func) {
    // pre-scan to find which vars are sfa, and also count their gets&sets
    analyzer.analyze(func);
    // prepare to walk
    numGetsSoFar.clear();
    numGetsSoFar.resize(func->getNumLocals());
    // walk and optimize
    walk(func->body);
  }

  void visitLocalGet(LocalGet* curr) { numGetsSoFar[curr->index]++; }

  void visitBlock(Block* curr) {
    // Pushing code only makes sense if we are size 2 or above: we need one
    // element to push and an element to push it into, at minimum.
    if (curr->list.size() < 2) {
      return;
    }
    // At this point in the postorder traversal we have gone through all our
    // children. Therefore any variable whose gets seen so far is equal to the
    // total gets must have no further users after this block. And therefore
    // when we see an SFA variable defined here, we know it isn't used before it
    // either, and has just this one assign. So we can push it forward while we
    // don't hit a non-control-flow ordering invalidation issue, since if this
    // isn't a loop, it's fine (we're not used outside), and if it is, we hit
    // the assign before any use (as we can't push it past a use).
    Pusher pusher(curr, analyzer, numGetsSoFar, getPassOptions(), *getModule());
  }
};

Pass* createCodePushingPass() { return new CodePushing(); }

} // namespace wasm
