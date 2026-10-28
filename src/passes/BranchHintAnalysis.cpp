/*
 * Copyright 2025 WebAssembly Community Group participants
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
// Infer values for Branch Hints and emit the custom section with those
// annotations.
//
// Inspired by LLVM's BranchProbabilityInfo:
// https://github.com/llvm/llvm-project/blob/main/llvm/lib/Analysis/BranchProbabilityInfo.cpp
//

#include "cfg/cfg-traversal.h"
#include "ir/module-utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// An abstract chance (probability, but in less letters) of code being
// reached, in the range 0 - 100.
using Chance = uint8_t;
static constexpr Chance MinChance = 0;
static constexpr Chance TinyChance = 1;
static constexpr Chance MaxChance = 100;

// Info we store in a basic block.
struct Info {
  // In each basic block we will store instructions that either branch, or that
  // provide hints as to branching.
  std::vector<Expression*> actions;

  // The chance of the block being reached. We assume it is likely to be reached
  // until we see a signal otherwise.
  Chance chance = MaxChance;

  void dump(Function* func) {
    std::cerr << "    info\n";
    if (!actions.empty()) {
      std::cerr << "      with last: " << getExpressionName(actions.back())
                << '\n';
    }
    std::cerr << "      with chance: " << int(chance) << '\n';
  }
};

// Analyze Branch Hints in a function, using a CFG.
struct BranchHintCFGAnalysis
  : public CFGWalker<BranchHintCFGAnalysis,
                     UnifiedExpressionVisitor<BranchHintCFGAnalysis>,
                     Info> {

  using Super = CFGWalker<BranchHintCFGAnalysis,
                          UnifiedExpressionVisitor<BranchHintCFGAnalysis>,
                          Info>;

  // We only look at things that branch twice, which is all branching
  // instructions but without br (without condition, which is an unconditional
  // branch we don't need to hint about) and not switch (which Branch Hints do
  // not support).
  bool isBranching(Expression* curr) {
    if (auto* br = curr->dynCast<Break>()) {
      return !!br->condition;
    }
    return curr->is<If>() || curr->is<BrOn>();
  }

  bool isCall(Expression* curr) {
    // TODO: we could infer something for indirect calls too.
    return curr->is<Call>();
  }

  // Returns the chance that an instruction is reached, if something about
  // it suggests it is likely or not.
  std::optional<Chance> getChance(Expression* curr) {
    // Unreachable is assumed to never happen.
    if (curr->is<Unreachable>()) {
      return MinChance;
    }

    // Throw is assumed to almost never happen.
    if (curr->is<Throw>() || curr->is<ThrowRef>()) {
      return TinyChance;
    }

    // Otherwise, we don't know.
    // TODO: cold calls, noreturn calls, etc.
    return {};
  }

  void visitExpression(Expression* curr) {
    // Ignore unreachable code.
    if (!currBasicBlock) {
      return;
    }

    // Add all things that branch or call.
    if (isBranching(curr) || isCall(curr)) {
      currBasicBlock->contents.actions.push_back(curr);
    }

    // Apply all signals: if something tells us the block is unlikely, mark it
    // so.
    if (auto chance = getChance(curr)) {
      currBasicBlock->contents.chance =
        std::min(currBasicBlock->contents.chance, *chance);
    }
  }

  // Override cfg-analysis's handling of If start. Ifs are control flow
  // structures, so they do not appear in basic blocks (an If spans several),
  // but we do need to know where the If begins, specifically, where the
  // condition can branch
  static void doStartIfTrue(BranchHintCFGAnalysis* self, Expression** currp) {
    // Right before the Super creates a basic block for the ifTrue, note the
    // basic block the condition is in.
    if (self->currBasicBlock) {
      self->currBasicBlock->contents.actions.push_back(*currp);
    }
    Super::doStartIfTrue(self, currp);
  }

  void visitFunction(Function* curr) { flow(); }

  // Flow chances in a function, to find the chances of all blocks inside it.
  void flow() {
    // We consider the chance of a block to be no higher than the things it
    // targets, that is, chance(block) := max(chance(target) for target). Flow
    // chances to sources of blocks to achieve that, starting from the indexes
    // of all blocks.
    UniqueDeferredQueue<BasicBlock*> work;
    for (auto& block : basicBlocks) {
      // Blocks with no successors have nothing new to compute in the loop
      // below.
      if (!block->out.empty()) {
        work.push(block.get());
      }
    }
    while (!work.empty()) {
      auto* block = work.pop();

      // We should not get here if there is no work.
      assert(!block->out.empty());

      // Compute this block from its successors. The naive chance we already
      // computed may decrease if all successors have lower probability.
      auto maxOut = MinChance;
      for (auto* out : block->out) {
        maxOut = std::max(maxOut, out->contents.chance);
      }

      auto& chance = block->contents.chance;
      if (maxOut < chance) {
        chance = maxOut;
        for (auto* in : block->in) {
          work.push(in);
        }
      }
    }
  }

  // Checks if a branch from a branching instruction to two targets is likely or
  // not (or unknown).
  std::optional<bool>
  getLikelihood(Expression* brancher, Chance first, Chance second) {
    if (first == second) {
      // No data to suggest likelihood either way.
      return {};
    }

    // |first, second| are the chances of the basic blocks after the brancher,
    // in order. For Br*, the block right after them is reached if we do *not*
    // branch (the condition is false), and the later block if we do, while for
    // If, it is reversed: the block right after us is reached if the condition
    // is true.
    if (brancher->is<If>()) {
      std::swap(first, second);
    }
    return first < second;
  }
};

// A BranchHintCFGAnalysis with the additional info that
// CallGraphPropertyAnalysis::FunctionInfo needs, which we will store in the map
// generated by CallGraphPropertyAnalysis. This structure provides all the info
// for one function.
// TODO: we don't actually use CallGraphPropertyAnalysis?!
struct FunctionAnalysis
  : public BranchHintCFGAnalysis,
    ModuleUtils::CallGraphPropertyAnalysis<FunctionAnalysis>::FunctionInfo {};

struct BranchHintAnalysis : public Pass {
  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    // Analyze each function, computing chances inside it.
    ModuleUtils::CallGraphPropertyAnalysis<FunctionAnalysis> analyzer(
      *module, [&](Function* func, FunctionAnalysis& analysis) {
        if (func->imported()) {
          return;
        }

        analysis.walkFunctionInModule(func, module);
      });

    using BasicBlock = FunctionAnalysis::BasicBlock;

    // A block plus the context of which function it is in.
    struct BlockContext {
      BasicBlock* block;
      FunctionAnalysis* analysis;
    };

    // Whenever a function's entry block has low chance, that means callers are
    // low chance as well. Build a mapping to connect each entry function to the
    // callers, so we can update them later down.
    //
    // How much this cross-function analysis matters varies a lot by codebase,
    // anywhere from 3%, 7%, 20%, to 50%. (The 50% is on code that uses partial
    // inlining heavily, leaving many outlined throws, which can then be marked
    // unlikely.)
    std::unordered_map<BasicBlock*, std::vector<BlockContext>>
      entryToCallersMap;
    for (auto& [_, analysis] : analyzer.map) {
      for (auto& callerBlock : analysis.basicBlocks) {
        // Calls only appear at the end of blocks.
        if (callerBlock->contents.actions.empty()) {
          continue;
        }
        auto* last = callerBlock->contents.actions.back();
        if (auto* call = last->dynCast<Call>()) {
          auto* target = module->getFunction(call->target);
          auto* targetEntryBlock = analyzer.map[target].entry;
          auto context = BlockContext{callerBlock.get(), &analysis};
          entryToCallersMap[targetEntryBlock].push_back(context);
        }
      }
    }

    // Flow back from entries to callers. We start from all entries with low
    // chance and put them in a work queue.
    UniqueDeferredQueue<BasicBlock*> work;
    for (auto& [entry, _] : entryToCallersMap) {
      if (entry && entry->contents.chance < MaxChance) {
        work.push(entry);
      }
    }
    while (!work.empty()) {
      auto* entry = work.pop();
      auto entryChance = entry->contents.chance;
      // Find callers with higher chance: we can infer they have lower, now.
      for (auto& callerContext : entryToCallersMap[entry]) {
        auto& callerChance = callerContext.block->contents.chance;
        if (callerChance > entryChance) {
          // This adjustment to a basic block's chance may lead to more
          // inferences inside that function: do a flow. TODO we could flow only
          // from the caller blocks, and we could do these flows in parallel.
          auto* callerAnalysis = callerContext.analysis;
          auto* callerEntry = callerAnalysis->entry;
          auto oldCallerEntryChance = callerEntry->contents.chance;
          callerChance = entryChance;
          callerAnalysis->flow();

          // If our entry decreased in chance, we can propagate that to our
          // callers too.
          if (oldCallerEntryChance > callerEntry->contents.chance) {
            work.push(callerEntry);
          }
        }
      }
    }

    // Finally, apply all we've inferred. TODO: parallelize.

    // Apply the final chances: when a branch between two options has a higher
    // chance to go one way then the other, mark it as likely or unlikely
    // accordingly. TODO: should we not mark when the difference is small?
    for (auto& [func, analysis] : analyzer.map) {
      for (auto& block : analysis.basicBlocks) {
        if (block->contents.actions.empty() || block->out.size() != 2) {
          continue;
        }

        auto* last = block->contents.actions.back();
        if (!analysis.isBranching(last)) {
          continue;
        }

        // Compare the probabilities of the two targets and see if we can infer
        // likelihood.
        if (auto likely =
              analysis.getLikelihood(last,
                                     block->out[0]->contents.chance,
                                     block->out[1]->contents.chance)) {
          // We have a useful hint!
          func->codeAnnotations[last].branchLikely = likely;
        }
      }
    }
  }
};

} // anonymous namespace

Pass* createBranchHintAnalysisPass() { return new BranchHintAnalysis(); }

} // namespace wasm
