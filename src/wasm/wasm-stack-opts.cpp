/*
 * Copyright 2018 WebAssembly Community Group participants
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
// Operations on Stack IR.
//

#include "ir/branch-utils.h"
#include "ir/iteration.h"
#include "ir/local-graph.h"
#include "pass.h"
#include "wasm-stack.h"
#include "wasm.h"

namespace wasm {

StackIROptimizer::StackIROptimizer(Function* func,
                                   StackIR& insts,
                                   const PassOptions& passOptions,
                                   FeatureSet features)
  : func(func), insts(insts), passOptions(passOptions), features(features) {}

void StackIROptimizer::run() {
  dce();
  // FIXME: local2Stack is currently rather slow (due to localGraph),
  //        so for now run it only when really optimizing
  if (passOptions.optimizeLevel >= 3 || passOptions.shrinkLevel >= 1) {
    local2Stack();
  }
  removeUnneededBlocks();
  dce();
  vacuum();
}

void StackIROptimizer::dce() {
  // Remove code after an unreachable instruction: anything after it, up to the
  // next control flow barrier, can simply be removed.
  bool inUnreachableCode = false;
  for (Index i = 0; i < insts.size(); i++) {
    auto* inst = insts[i];
    if (!inst) {
      continue;
    }
    if (inUnreachableCode) {
      // Does the unreachable code end here?
      if (isControlFlowBarrier(inst)) {
        inUnreachableCode = false;
      } else {
        // We can remove this.
        removeAt(i);
      }
    } else if (inst->type == Type::unreachable) {
      inUnreachableCode = true;
    }
  }

  // Remove code before an Unreachable. Consider this:
  //
  //  (drop
  //   ..
  //  )
  //  (unreachable)
  //
  // The drop is not needed, as the unreachable puts the stack in the
  // polymorphic state anyhow. Note that we don't need to optimize anything
  // other than a drop here, as in general the Binaryen IR DCE pass will handle
  // everything else. A drop followed by an unreachable is the only thing that
  // pass cannot handle, as the structured form of Binaryen IR does not allow
  // removing such a drop, and so we can only do it here in StackIR.
  //
  // TODO: We can look even further back, say if there is another drop of
  //       something before, then we can remove that drop as well. To do that
  //       we'd need to inspect the stack going backwards.
  for (Index i = 1; i < insts.size(); i++) {
    auto* inst = insts[i];
    if (!inst || inst->op != StackInst::Basic ||
        !inst->origin->is<Unreachable>()) {
      continue;
    }

    // Look back past nulls.
    Index j = i - 1;
    while (j > 0 && !insts[j]) {
      j--;
    }

    auto*& prev = insts[j];
    if (prev && prev->op == StackInst::Basic && prev->origin->is<Drop>()) {
      prev = nullptr;
    }
  }
}

// Remove obviously-unneeded code.
void StackIROptimizer::vacuum() {
  // In the wasm binary format a nop is never needed. (In Binaryen IR, in
  // comparison, it is necessary e.g. in a function body or an if arm.)
  //
  // It is especially important to remove nops because we add nops when we
  // read wasm into Binaryen IR. That is, this avoids a potential increase in
  // code size.
  for (Index i = 0; i < insts.size(); i++) {
    auto*& inst = insts[i];
    if (inst && inst->origin->is<Nop>()) {
      inst = nullptr;
    }
  }
}

// If ordered properly, we can avoid a local.set/local.get pair,
// and use the value directly from the stack, for example
//    [..produce a value on the stack..]
//    local.set $x
//    [..much code..]
//    local.get $x
//    call $foo ;; use the value, foo(value)
// As long as the code in between does not modify $x, and has
// no control flow branching out, we can remove both the set
// and the get.
void StackIROptimizer::local2Stack() {
  // We use the localGraph to tell us if a get-set pair is indeed
  // a set that is read by that get, and only that get. Note that we run
  // this on the Binaryen IR, so we are assuming that no previous opt
  // has changed the interaction of local operations.
  // TODO: we can do this a lot faster, as we just care about linear
  //       control flow.
  LocalGraph localGraph(func);
  localGraph.computeSetInfluences();
  // The binary writing of StringWTF16Get and StringSliceWTF is optimized to use
  // fewer scratch locals when their operands are already LocalGets. To avoid
  // interfering with that optimization, we have to avoid removing such
  // LocalGets.
  auto deferredGets = findStringViewDeferredGets();

  // We maintain a stack of relevant values. This contains:
  //  * a null for each actual value that the value stack would have
  //  * an index of each LocalSet that *could* be on the value
  //    stack at that location.
  const Index null = -1;
  std::vector<Index> values;
  // We also maintain a stack of values vectors for control flow,
  // saving the stack as we enter and restoring it when we exit.
  std::vector<std::vector<Index>> savedValues;
#ifdef STACK_OPT_DEBUG
  std::cout << "func: " << func->name << '\n' << insts << '\n';
#endif
  for (Index instIndex = 0; instIndex < insts.size(); instIndex++) {
    auto* inst = insts[instIndex];
    if (!inst) {
      continue;
    }
    // First, consume values from the stack as required.
    auto consumed = getNumConsumedValues(inst);
#ifdef STACK_OPT_DEBUG
    std::cout << "  " << instIndex << " : " << *inst << ", " << values.size()
              << " on stack, will consume " << consumed << "\n    ";
    for (auto s : values)
      std::cout << s << ' ';
    std::cout << '\n';
#endif
    // TODO: currently we run dce before this, but if we didn't, we'd need
    //       to handle unreachable code here - it's ok to pop multiple values
    //       there even if the stack is at size 0.
    while (consumed > 0) {
      assert(values.size() > 0);
      // Whenever we hit a possible stack value, kill it - it would
      // be consumed here, so we can never optimize to it.
      while (values.back() != null) {
        values.pop_back();
        assert(values.size() > 0);
      }
      // Finally, consume the actual value that is consumed here.
      values.pop_back();
      consumed--;
    }
    // After consuming, we can see what to do with this. First, handle
    // control flow.
    if (isControlFlowBegin(inst)) {
      // Save the stack for when we end this control flow.
      savedValues.push_back(values); // TODO: optimize copies
      values.clear();
    } else if (isControlFlowEnd(inst)) {
      assert(!savedValues.empty());
      values = savedValues.back();
      savedValues.pop_back();
    } else if (isControlFlow(inst)) {
      // Otherwise, in the middle of control flow, just clear it
      values.clear();
    }
    // This is something we should handle, look into it.
    if (inst->type.isConcrete()) {
      bool optimized = false;
      // Do not optimize multivalue locals, since those will be better
      // optimized when they are visited in the binary writer and this
      // optimization would intefere with that one.
      if (auto* get = inst->origin->dynCast<LocalGet>();
          get && inst->type.isSingle() && !deferredGets.count(get)) {
        // Use another local to clarify what instIndex means in this scope.
        auto getIndex = instIndex;

        // This is a potential optimization opportunity! See if we
        // can reach the set.
        if (values.size() > 0) {
          Index j = values.size() - 1;
          while (1) {
            // If there's an actual value in the way, we've failed.
            auto setIndex = values[j];
            if (setIndex == null) {
              break;
            }
            auto* set = insts[setIndex]->origin->cast<LocalSet>();
            if (set->index == get->index) {
              // This might be a proper set-get pair, where the set is
              // used by this get and nothing else, check that.
              auto& sets = localGraph.getSets(get);
              if (sets.size() == 1 && *sets.begin() == set) {
                auto& setInfluences = localGraph.getSetInfluences(set);
                // If this has the proper value of 1, also do the potentially-
                // expensive check of whether we can remove this pair at all.
                if (setInfluences.size() == 1 &&
                    canRemoveSetGetPair(setIndex, getIndex)) {
                  assert(*setInfluences.begin() == get);
                  // Do it! The set and the get can go away, the proper
                  // value is on the stack.
#ifdef STACK_OPT_DEBUG
                  std::cout << "  stackify the get\n";
#endif
                  insts[setIndex] = nullptr;
                  insts[getIndex] = nullptr;
                  // Continuing on from here, replace this on the stack
                  // with a null, representing a regular value. We
                  // keep possible values above us active - they may
                  // be optimized later, as they would be pushed after
                  // us, and used before us, so there is no conflict.
                  values[j] = null;
                  optimized = true;
                  break;
                }
              }
            }
            // We failed here. Can we look some more?
            if (j == 0) {
              break;
            }
            j--;
          }
        }
      }
      if (!optimized) {
        // This is an actual regular value on the value stack.
        values.push_back(null);
      }
    } else if (inst->origin->is<LocalSet>() && inst->type == Type::none) {
      // This set is potentially optimizable later, add to stack.
      values.push_back(instIndex);
    }
  }
}

// There may be unnecessary blocks we can remove: blocks without arriving
// branches are always ok to remove.
// TODO: A branch to a block in an if body can become a branch to that if body.
void StackIROptimizer::removeUnneededBlocks() {
  // First, find all branch targets.
  std::unordered_set<Name> targets;
  for (auto*& inst : insts) {
    if (inst) {
      BranchUtils::operateOnScopeNameUses(
        inst->origin, [&](Name& name) { targets.insert(name); });
    }
  }

  // Remove untargeted blocks.
  for (auto*& inst : insts) {
    if (!inst) {
      continue;
    }
    if (auto* block = inst->origin->dynCast<Block>()) {
      if (!block->name.is() || !targets.count(block->name)) {
        // TODO optimize, maybe run remove-unused-names
        inst = nullptr;
      }
    }
  }
}

// A control flow "barrier" - a point where stack machine
// unreachability ends.
bool StackIROptimizer::isControlFlowBarrier(StackInst* inst) {
  switch (inst->op) {
    case StackInst::BlockEnd:
    case StackInst::IfElse:
    case StackInst::IfEnd:
    case StackInst::LoopEnd:
    case StackInst::Catch:
    case StackInst::CatchAll:
    case StackInst::Delegate:
    case StackInst::TryEnd:
    case StackInst::TryTableEnd: {
      return true;
    }
    default: {
      return false;
    }
  }
}

// A control flow beginning.
bool StackIROptimizer::isControlFlowBegin(StackInst* inst) {
  switch (inst->op) {
    case StackInst::BlockBegin:
    case StackInst::IfBegin:
    case StackInst::LoopBegin:
    case StackInst::TryBegin:
    case StackInst::TryTableBegin: {
      return true;
    }
    default: {
      return false;
    }
  }
}

// A control flow ending.
bool StackIROptimizer::isControlFlowEnd(StackInst* inst) {
  switch (inst->op) {
    case StackInst::BlockEnd:
    case StackInst::IfEnd:
    case StackInst::LoopEnd:
    case StackInst::TryEnd:
    case StackInst::Delegate:
    case StackInst::TryTableEnd: {
      return true;
    }
    default: {
      return false;
    }
  }
}

bool StackIROptimizer::isControlFlow(StackInst* inst) {
  return inst->op != StackInst::Basic;
}

// Remove the instruction at index i. If the instruction
// is control flow, and so has been expanded to multiple
// instructions, remove them as well.
void StackIROptimizer::removeAt(Index i) {
  auto* inst = insts[i];
  insts[i] = nullptr;
  if (inst->op == StackInst::Basic) {
    return; // that was it
  }
  auto* origin = inst->origin;
  while (1) {
    i++;
    assert(i < insts.size());
    inst = insts[i];
    insts[i] = nullptr;
    if (inst && inst->origin == origin && isControlFlowEnd(inst)) {
      return; // that's it, we removed it all
    }
  }
}

Index StackIROptimizer::getNumConsumedValues(StackInst* inst) {
  if (isControlFlow(inst)) {
    // If consumes 1; that's it.
    if (inst->op == StackInst::IfBegin) {
      return 1;
    }
    return 0;
  }
  // Otherwise, for basic instructions, just count the expression children.
  return ChildIterator(inst->origin).children.size();
}

// Given a pair of a local.set and local.get, see if we can remove them
// without breaking validation. Specifically, we must keep sets of non-
// nullable locals that dominate a get until the end of the block, such as
// here:
//
//  local.set 0    ;; Can we remove
//  local.get 0    ;; this pair?
//  if
//    local.set 0
//  else
//    local.set 0
//  end
//  local.get 0    ;; This get poses a problem.
//
// Logically the 2nd&3rd sets ensure a value is applied to the local before we
// read it, but the validation rules only track each set until the end of its
// scope, so the 1st set (before the if, in the pair) is necessary.
//
// The logic below is related to LocalStructuralDominance, but sharing code
// with it is difficult as this uses StackIR and not BinaryenIR, and it checks
// a particular set/get pair.
//
// We are given the indexes of the set and get instructions in |insts|.
bool StackIROptimizer::canRemoveSetGetPair(Index setIndex, Index getIndex) {
  // The set must be before the get.
  assert(setIndex < getIndex);

  auto* set = insts[setIndex]->origin->cast<LocalSet>();
  auto localType = func->getLocalType(set->index);
  // Note we do not need to handle tuples here, as the parent ignores them
  // anyhow (hence we can check non-nullability instead of non-
  // defaultability).
  assert(localType.isSingle());
  if (func->isParam(set->index) || !localType.isNonNullable()) {
    // This local cannot pose a problem for validation (params are always
    // initialized, and it is ok if nullable locals are uninitialized).
    return true;
  }

  // Track the depth (in block/if/loop/etc. scopes) relative to our starting
  // point. Anything less deep than that is not interesting, as we can only
  // help things at our depth or deeper to validate.
  Index currDepth = 0;

  // Look for a different get than the one in getIndex (since that one is
  // being removed) which would stop validating without the set. While doing
  // so, note other sets that ensure validation even if our set is removed. We
  // track those in this stack of booleans, one for each scope, which is true
  // if another sets covers us and ours is not needed.
  //
  // We begin in the current scope and with no other set covering us.
  std::vector<bool> coverStack = {false};

  // Track the total number of covers as well, for quick checking below.
  Index covers = 0;

  // TODO: We could look before us as well, but then we might end up scanning
  //       much of the function every time.
  for (Index i = setIndex + 1; i < insts.size(); i++) {
    auto* inst = insts[i];
    if (!inst) {
      continue;
    }
    if (isControlFlowBegin(inst)) {
      // A new scope begins.
      currDepth++;
      coverStack.push_back(false);
    } else if (isControlFlowEnd(inst)) {
      if (currDepth == 0) {
        // Less deep than the start, so we found no problem.
        return true;
      }
      currDepth--;

      if (coverStack.back()) {
        // A cover existed in the scope which ended.
        covers--;
      }
      coverStack.pop_back();
    } else if (isControlFlowBarrier(inst)) {
      // A barrier, like the else in an if-else, not only ends a scope but
      // opens a new one.
      if (currDepth == 0) {
        // Another scope with the same depth begins, but ours ended, so stop.
        return true;
      }

      if (coverStack.back()) {
        // A cover existed in the scope which ended.
        covers--;
      }
      coverStack.back() = false;
    } else if (auto* otherSet = inst->origin->dynCast<LocalSet>()) {
      // We are covered in this scope henceforth.
      if (otherSet->index == set->index) {
        if (!coverStack.back()) {
          covers++;
          if (currDepth == 0) {
            // We have a cover at depth 0, so everything from here on out
            // will be covered.
            return true;
          }
          coverStack.back() = true;
        }
      }
    } else if (auto* otherGet = inst->origin->dynCast<LocalGet>()) {
      if (otherGet->index == set->index && i != getIndex && !covers) {
        // We found a get that might be a problem: it uses the same index, but
        // is not the get we were told about, and no other set covers us.
        return false;
      }
    }
  }

  // No problem.
  return true;
}

std::unordered_set<LocalGet*> StackIROptimizer::findStringViewDeferredGets() {
  std::unordered_set<LocalGet*> deferred;
  auto note = [&](Expression* e) {
    if (auto* get = e->dynCast<LocalGet>()) {
      deferred.insert(get);
    }
  };
  for (auto* inst : insts) {
    if (!inst) {
      continue;
    }
    if (auto* curr = inst->origin->dynCast<StringWTF16Get>()) {
      note(curr->pos);
    } else if (auto* curr = inst->origin->dynCast<StringSliceWTF>()) {
      note(curr->start);
      note(curr->end);
    }
  }
  return deferred;
}

} // namespace wasm
