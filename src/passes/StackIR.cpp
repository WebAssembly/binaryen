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

#include "ir/iteration.h"
#include "ir/local-graph.h"
#include "pass.h"
#include "wasm-stack.h"
#include "wasm.h"

namespace wasm {

// Generate Stack IR from Binaryen IR

struct GenerateStackIR : public WalkerPass<PostWalker<GenerateStackIR>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<GenerateStackIR>();
  }

  bool modifiesBinaryenIR() override { return false; }

  void doWalkFunction(Function* func) {
    StackIRGenerator stackIRGen(*getModule(), func);
    stackIRGen.write();
    func->stackIR = std::make_unique<StackIR>();
    func->stackIR->swap(stackIRGen.getStackIR());
  }
};

Pass* createGenerateStackIRPass() { return new GenerateStackIR(); }

// Optimize

class StackIROptimizer {
  Function* func;
  PassOptions& passOptions;
  StackIR& insts;
  FeatureSet features;

public:
  StackIROptimizer(Function* func,
                   PassOptions& passOptions,
                   FeatureSet features)
    : func(func), passOptions(passOptions), insts(*func->stackIR.get()),
      features(features) {
    assert(func->stackIR);
  }

  void run() {
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

private:
  // Passes.

  // Remove unreachable code.
  void dce() {
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
  }

  // Remove obviously-unneeded code.
  void vacuum() {
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
  void local2Stack() {
    // We use the localGraph to tell us if a get-set pair is indeed
    // a set that is read by that get, and only that get. Note that we run
    // this on the Binaryen IR, so we are assuming that no previous opt
    // has changed the interaction of local operations.
    // TODO: we can do this a lot faster, as we just care about linear
    //       control flow.
    LocalGraph localGraph(func);
    localGraph.computeSetInfluences();
    // We maintain a stack of relevant values. This contains:
    //  * a null for each actual value that the value stack would have
    //  * an index of each LocalSet that *could* be on the value
    //    stack at that location.
    const Index null = -1;
    std::vector<Index> values;
    // We also maintain a stack of values vectors for control flow,
    // saving the stack as we enter and restoring it when we exit.
    std::vector<std::vector<Index>> savedValues;
    // Some sets cannot be removed, if they are dependended on for validation.
    auto necessarySets = findNecessarySets();
#ifdef STACK_OPT_DEBUG
    std::cout << "func: " << func->name << '\n' << insts << '\n';
#endif
    for (Index i = 0; i < insts.size(); i++) {
      auto* inst = insts[i];
      if (!inst) {
        continue;
      }
      // First, consume values from the stack as required.
      auto consumed = getNumConsumedValues(inst);
#ifdef STACK_OPT_DEBUG
      std::cout << "  " << i << " : " << *inst << ", " << values.size()
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
        if (auto* get = inst->origin->dynCast<LocalGet>()) {
          // This is a potential optimization opportunity! See if we
          // can reach the set.
          if (values.size() > 0) {
            Index j = values.size() - 1;
            while (1) {
              // If there's an actual value in the way, we've failed.
              auto index = values[j];
              if (index == null) {
                break;
              }
              auto* set = insts[index]->origin->cast<LocalSet>();
              if (set->index == get->index) {
                // This might be a proper set-get pair, where the set is
                // used by this get and nothing else, check that.
                auto& sets = localGraph.getSetses[get];
                if (sets.size() == 1 && *sets.begin() == set) {
                  auto& setInfluences = localGraph.setInfluences[set];
                  if (setInfluences.size() == 1) {
                    assert(*setInfluences.begin() == get);
                    // Do it! The set and the get can go away, the proper
                    // value is on the stack.
#ifdef STACK_OPT_DEBUG
                    std::cout << "  stackify the get\n";
#endif
                    insts[index] = nullptr;
                    insts[i] = nullptr;
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
        values.push_back(i);
      }
    }
  }

  // There may be unnecessary blocks we can remove: blocks
  // without branches to them are always ok to remove.
  // TODO: a branch to a block in an if body can become
  //       a branch to that if body
  void removeUnneededBlocks() {
    for (auto*& inst : insts) {
      if (!inst) {
        continue;
      }
      if (auto* block = inst->origin->dynCast<Block>()) {
        if (!BranchUtils::BranchSeeker::has(block, block->name)) {
          // TODO optimize, maybe run remove-unused-names
          inst = nullptr;
        }
      }
    }
  }

  // Utilities.

  // A control flow "barrier" - a point where stack machine
  // unreachability ends.
  bool isControlFlowBarrier(StackInst* inst) {
    switch (inst->op) {
      case StackInst::BlockEnd:
      case StackInst::IfElse:
      case StackInst::IfEnd:
      case StackInst::LoopEnd:
      case StackInst::Catch:
      case StackInst::CatchAll:
      case StackInst::Delegate:
      case StackInst::TryEnd: {
        return true;
      }
      default: { return false; }
    }
  }

  // A control flow beginning.
  bool isControlFlowBegin(StackInst* inst) {
    switch (inst->op) {
      case StackInst::BlockBegin:
      case StackInst::IfBegin:
      case StackInst::LoopBegin:
      case StackInst::TryBegin: {
        return true;
      }
      default: { return false; }
    }
  }

  // A control flow ending.
  bool isControlFlowEnd(StackInst* inst) {
    switch (inst->op) {
      case StackInst::BlockEnd:
      case StackInst::IfEnd:
      case StackInst::LoopEnd:
      case StackInst::TryEnd:
      case StackInst::Delegate: {
        return true;
      }
      default: { return false; }
    }
  }

  bool isControlFlow(StackInst* inst) { return inst->op != StackInst::Basic; }

  // Remove the instruction at index i. If the instruction
  // is control flow, and so has been expanded to multiple
  // instructions, remove them as well.
  void removeAt(Index i) {
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

  Index getNumConsumedValues(StackInst* inst) {
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

  // Find LocalSet instructions that cannot be removed because they are
  // necessary in the binary format for validation. Specifically, we must keep
  // sets of non-nullable locals that dominate a get until the end of the block,
  // such as here:
  //
  //  local.set 0
  //  if
  //    local.set 0
  //  else
  //    local.set 0
  //  end
  //  local.get 0
  //
  // Logically the 2nd&3rd sets ensure a value is applied to the local before we
  // read it, but the validation rules only track each set until the end of its
  // scope, so the 1st set (before the if) is necessary.
  std::unordered_set<LocalSet*> findNecessarySets() {
    std::unordered_set<LocalSet*> necessary;

    // Exit early if no non-nullable local exists anyhow.
    if (!features.hasReferenceTypes()) {
      return necessary;
    }

    bool hasNonNullableVar = false;
    for (auto var : func->vars) {
      for (auto type : var) {
        if (type.isNonNullable()) {
          hasNonNullableVar = true;
          break;
        }
      }
    }
    if (!hasNonNullableVar) {
      return necessary;
    }

    // There may be ambiguity as we go regarding which set is necessary, like
    // this:
    //
    //  local.set 0
    //  block
    //    local.set 0
    //    local.get 0
    //  end
    //
    // Either of those two would suffice for the get to validate, so we could
    // pick either one. To keep things simple, we do a forward pass and assume
    // the first set seen is responsible. That keeps outermost sets, which makes
    // sense as a heuristic because such sets dominate a larger area and can
    // support more gets.
    //
    // Given that, in our forward pass we represent the current state as a
    // mapping of local indexes to the set that dominates there. We can then
    // ignore later sets as we go, and if we see a get then we mark that set as
    // necessary.

    // Map of local index to the set that dominates gets of that index.
    // TODO: vector?
    std::unordered_map<Index, LocalSet*> indexSetMap;

    // Stack of local indexes that have entries in indexSetMap. The first value
    // is for the indexes of depth 0, then depth 1, etc. We need this map to
    // know what to do when the depth decreases, because then we want to remove
    // all sets no longer relevant after their scope ended.
    //
    // Initialize this to set us up for the function scope itself.
    std::vector<std::vector<Index>> depthIndexMap;
    depthIndexMap.resize(1);

    // The current depth.
    Index currDepth = 0;

    auto startScope = [&]() {
      currDepth++;
      depthIndexMap.emplace_back();
    };
    auto endScope = [&]() {
      currDepth--;

      // Remove sets that no longer dominate anything since their scope ended.
      auto& depthIndexes = depthIndexMap.back();
      for (auto index : depthIndexes) {
        indexSetMap.erase(index);
      }
      depthIndexMap.pop_back();
    };

    auto relevant = [&](Index index) {
      // We only care about non-nullable local gets being dominated by sets.
      return func->isVar(index) && func->getLocalType(index).isNonNullable();
    };

    for (Index i = 0; i < insts.size(); i++) {
      auto* inst = insts[i];
      if (!inst) {
        continue;
      }
      if (isControlFlowBegin(inst)) {
        startScope();
      } else if (isControlFlowEnd(inst)) {
        endScope();
      } else if (isControlFlowBarrier(inst)) {
        // A barrier, like the else in an if-else, not only ends a scope but
        // opens a new one.
        startScope();
        endScope();
      } else if (auto* set = inst->origin->dynCast<LocalSet>()) {
        auto index = set->index;
        if (relevant(index)) {
          // If there is no set for this index, then this is the set at this
          // depth, and deeper.
          if (indexSetMap.count(index) == 0) {
            indexSetMap[index] = set;
            depthIndexMap.back().push_back(index);
          }
        }
      } else if (auto* get = inst->origin->dynCast<LocalGet>()) {
        auto index = get->index;
        if (relevant(index)) {
          // This makes some local.set necessary. One must exist, or the wasm
          // would not validate.
          assert(indexSetMap.count(index));
          necessary.insert(indexSetMap[index]);
        }
      }
    }

    return necessary;
  }
};

struct OptimizeStackIR : public WalkerPass<PostWalker<OptimizeStackIR>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<OptimizeStackIR>();
  }

  bool modifiesBinaryenIR() override { return false; }

  void doWalkFunction(Function* func) {
    if (!func->stackIR) {
      return;
    }
    StackIROptimizer(func, getPassOptions(), getModule()->features).run();
  }
};

Pass* createOptimizeStackIRPass() { return new OptimizeStackIR(); }

} // namespace wasm
