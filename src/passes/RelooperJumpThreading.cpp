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

// Optimize relooper-generated label variable usage: add blocks and turn
// a label-set/break/label-check into a break into the new block.
// This assumes the very specific output the fastcomp relooper emits,
// including the name of the 'label' variable.

#include "wasm.h"
#include "pass.h"
#include "ir/utils.h"
#include "ir/manipulation.h"

namespace wasm {


static Name LABEL("label");

static Name getInnerName(int i) {
  return Name(std::string("__rjti$") + std::to_string(i));
}

static Name getOuterName(int i) {
  return Name(std::string("__rjto$") + std::to_string(i));
}

static If* isLabelCheckingIf(Expression* curr, Index labelIndex) {
  if (!curr) return nullptr;
  auto* iff = curr->dynCast<If>();
  if (!iff) return nullptr;
  auto* condition = iff->condition->dynCast<Binary>();
  if (!(condition && condition->op == EqInt32)) return nullptr;
  auto* left = condition->left->dynCast<GetLocal>();
  if (!(left && left->index == labelIndex)) return nullptr;
  return iff;
}

static Index getCheckedLabelValue(If* iff) {
  return iff->condition->cast<Binary>()->right->cast<Const>()->value.geti32();
}

static SetLocal* isLabelSettingSetLocal(Expression* curr, Index labelIndex) {
  if (!curr) return nullptr;
  auto* set = curr->dynCast<SetLocal>();
  if (!set) return nullptr;
  if (set->index != labelIndex) return nullptr;
  return set;
}

static Index getSetLabelValue(SetLocal* set) {
  return set->value->cast<Const>()->value.geti32();
}

struct LabelUseFinder : public PostWalker<LabelUseFinder> {
  Index labelIndex;
  std::map<Index, Index>& checks; // label value => number of checks on it
  std::map<Index, Index>& sets;   // label value => number of sets to it

  LabelUseFinder(Index labelIndex, std::map<Index, Index>& checks, std::map<Index, Index>& sets) : labelIndex(labelIndex), checks(checks), sets(sets) {}

  void visitIf(If* curr) {
    if (isLabelCheckingIf(curr, labelIndex)) {
      checks[getCheckedLabelValue(curr)]++;
    }
  }

  void visitSetLocal(SetLocal* curr) {
    if (isLabelSettingSetLocal(curr, labelIndex)) {
      sets[getSetLabelValue(curr)]++;
    }
  }
};

struct RelooperJumpThreading : public WalkerPass<ExpressionStackWalker<RelooperJumpThreading>> {
  bool isFunctionParallel() override { return true; }

  Pass* create() override { return new RelooperJumpThreading; }

  std::map<Index, Index> labelChecks;
  std::map<Index, Index> labelSets;

  Index labelIndex;
  Index newNameCounter = 0;

  void visitBlock(Block* curr) {
    // look for the  if label == X  pattern
    auto& list = curr->list;
    if (list.size() == 0) return;
    for (Index i = 0; i < list.size() - 1; i++) {
      // once we see something that might be irreducible, we must skip that if and the rest of the dependents
      bool irreducible = false;
      Index origin = i;
      for (Index j = i + 1; j < list.size(); j++) {
        if (auto* iff = isLabelCheckingIf(list[j], labelIndex)) {
          irreducible |= hasIrreducibleControlFlow(iff, list[origin]);
          if (!irreducible) {
            optimizeJumpsToLabelCheck(list[origin], iff);
            ExpressionManipulator::nop(iff);
          }
          i++;
          continue;
        }
        // if the next element is a block, it may be the holding block of label-checking ifs
        if (auto* holder = list[j]->dynCast<Block>()) {
          if (holder->list.size() > 0) {
            if (If* iff = isLabelCheckingIf(holder->list[0], labelIndex)) {
              irreducible |= hasIrreducibleControlFlow(iff, list[origin]);
              if (!irreducible) {
                // this is indeed a holder. we can process the ifs, and must also move
                // the block to enclose the origin, so it is properly reachable
                assert(holder->list.size() == 1); // must be size 1, a relooper multiple will have its own label, and is an if-else sequence and nothing more
                optimizeJumpsToLabelCheck(list[origin], iff);
                holder->list[0] = list[origin];
                list[origin] = holder;
                // reuse the if as a nop
                list[j] = iff;
                ExpressionManipulator::nop(iff);
              }
              i++;
              continue;
            }
          }
        }
        break; // we didn't see something we like, so stop here
      }
    }
  }

  void doWalkFunction(Function* func) {
    // if there isn't a label variable, nothing for us to do
    if (func->localIndices.count(LABEL)) {
      labelIndex = func->getLocalIndex(LABEL);
      LabelUseFinder finder(labelIndex, labelChecks, labelSets);
      finder.walk(func->body);
      super::doWalkFunction(func);
    }
  }

  void visitFunction(Function* curr) {
    // we may alter types
    ReFinalize().walkFunctionInModule(curr, getModule());
  }

private:

  bool hasIrreducibleControlFlow(If* iff, Expression* origin) {
    // Gather the checks in this if chain. If all the label values checked are only set in origin,
    // then since origin is right before us, this is not irreducible - we can replace all sets
    // in origin with jumps forward to us, and since there is nothing else, this is safe and complete.
    // We must also have the property that there is just one check for the label value, as otherwise
    // node splitting has complicated things.
    std::map<Index, Index> labelChecksInOrigin;
    std::map<Index, Index> labelSetsInOrigin;
    LabelUseFinder finder(labelIndex, labelChecksInOrigin, labelSetsInOrigin);
    finder.walk(origin);
    while (iff) {
      auto num = getCheckedLabelValue(iff);
      assert(labelChecks[num] > 0);
      if (labelChecks[num] > 1) return true; // checked more than once, somewhere in function
      assert(labelChecksInOrigin[num] == 0);
      if (labelSetsInOrigin[num] != labelSets[num]) {
        assert(labelSetsInOrigin[num] < labelSets[num]);
        // the label is set outside of the origin
        // if the only other location is inside the if body, then it is ok - it must be in a loop
        // and returning to the top of the loop body, so we don't need to do anything for that
        // label setting anyhow
        std::map<Index, Index> labelChecksInIfTrue;
        std::map<Index, Index> labelSetsInIfTrue;
        LabelUseFinder finder(labelIndex, labelChecksInIfTrue, labelSetsInIfTrue);
        finder.walk(iff->ifTrue);
        if (labelSetsInOrigin[num] + labelSetsInIfTrue[num] < labelSets[num]) {
          // label set somewhere we can't see now, could be irreducible control flow
          // TODO: one case where this happens is instead of an if-chain, we have
          //       ifs and a switch on label|0, in separate elements. perhaps not
          //       emitting switches on label|0 in the relooper would avoid that.
          return true;
        }
      }
      iff = isLabelCheckingIf(iff->ifFalse, labelIndex);
    }
    return false;
  }

  // optimizes jumps to a label check
  //  * origin is where the jumps originate, and also where we should write our output
  //  * iff is the if
  void optimizeJumpsToLabelCheck(Expression*& origin, If* iff) {
    Index nameCounter = newNameCounter++;
    Index num = getCheckedLabelValue(iff);
    // create a new block for this jump target
    Builder builder(*getModule());
    // origin is where all jumps to this target must come from - the element right before this if
    // we break out of inner to reach the target. instead of flowing out of normally, we break out of the outer, so we skip the target.
    auto innerName = getInnerName(nameCounter);
    auto outerName = getOuterName(nameCounter);
    auto* ifFalse = iff->ifFalse;
    // all assignments of label to the target can be replaced with breaks to the target, via innerName
    struct JumpUpdater : public PostWalker<JumpUpdater> {
      Index labelIndex;
      Index targetNum;
      Name targetName;

      void visitSetLocal(SetLocal* curr) {
        if (curr->index == labelIndex) {
          if (Index(curr->value->cast<Const>()->value.geti32()) == targetNum) {
            replaceCurrent(Builder(*getModule()).makeBreak(targetName));
          }
        }
      }
    };
    JumpUpdater updater;
    updater.labelIndex = labelIndex;
    updater.targetNum = num;
    updater.targetName = innerName;
    updater.setModule(getModule());
    updater.walk(origin);
    // restructure code
    auto* inner = builder.blockifyWithName(origin, innerName, builder.makeBreak(outerName));
    auto* outer = builder.makeSequence(inner, iff->ifTrue);
    outer->name = outerName;
    origin = outer;
    // if another label value is checked here, handle that too
    if (ifFalse) {
      optimizeJumpsToLabelCheck(origin, ifFalse->cast<If>());
    }
  }
};

// declare pass

Pass *createRelooperJumpThreadingPass() {
  return new RelooperJumpThreading();
}

} // namespace wasm

