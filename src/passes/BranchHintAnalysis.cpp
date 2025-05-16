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
#include "pass.h"
#include "unique_deferring_queue.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// An abstract chance (probability, but in less letters) of code being
// reached, in the range 0 - 100.
using Chance = uint8_t;
static constexpr Chance MaxChance = 100;

struct Info {
  // In each basic block we will store instructions that either branch, or that
  // provide hints as to branching.
  std::vector<Expression**> actions;

  // The chance of the block being reached. We assume any can be reached, unless
  // we see a good hint otherwise.
  Chance chance = MaxChance;  
};

struct BranchHintAnalysis
  : public WalkerPass<
      CFGWalker<BranchHintAnalysis, UnifiedExpressionVisitor<BranchHintAnalysis>, Info>> {
  bool isFunctionParallel() override { return true; }

  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<BranchHintAnalysis>();
  }

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

  // Returns the chance that an instruction is reached, if something about
  // it suggests it is likely or not.
  std::optional<Chance> getChance(Expression* curr) {
    // Unreachable is assumed to never happen.
    if (curr->is<Unreachable>()) {
      return 0;
    }

    // Throw is assumed to almost never happen.
    if (curr->is<Throw>() || curr->is<ThrowRef>()) {
      return 1;
    }

    // Otherwise, we don't know.
    // TODO: cold calls, noreturn calls, etc.
    return {};
  }

  void visitExpression(Expression* curr) {
    // Add all (reachable, so |currBasicBlock| exists) things that either branch
    // or suggest chances of branching.
    if (currBasicBlock && (isBranching(curr) || getChance(curr))) {
      currBasicBlock->contents.actions.push_back(getCurrentPointer());
    }
  }

  void visitFunction(Function* curr) {
    // Now that the walk is complete and we have a CFG, find things to optimize.
    // First, compute the chance of each basic block from its contents.
    for (Index i = 0; i < basicBlocks.size(); ++i) {
      std::cout << "block\n";
      auto& block = basicBlocks[i];
      for (auto** currp : block->contents.actions) {
        std::cout << "  " << **currp << "\n";
        // The chance of a basic block is the lowest thing we can find: if
        // we see nop, call, unreachable, then the nop tells us nothing, the
        // call may suggests a low chance if it is cold, but the
        // unreachable suggests a very low chance, which we trust.
        if (auto chance = getChance(*currp)) {
          block->chance = std::min(block->chance, *chance);
        }
      }
      std::cout << " => " << int(block->chance) << "\n";
    }

    // We consider the chance of a block to be no higher than the things it
    // targets, that is, chance(block) := max(chance(target) for target). Flow
    // chances to sources of blocks to achieve that, starting from the indexes
    // of all blocks.
    UniqueDeferredQueue<BasicBlock*> work;
    for (auto& block : basicBlocks) {
      work.push(&block);
    }
    while (!work.empty()) {
      auto* block = work.pop();
      // Apply this block to its predecessors, potentially raising their
      // chances.
      for (auto* in : block->in) {
        if (block->chance > in->chance) {
          in->chance = block->chance;
          work.push(in);
        }
      }
    }

    for (Index i = 0; i < basicBlocks.size(); ++i) {
      std::cout << "2block\n";
      auto& block = basicBlocks[i];
      std::cout << " => " << int(block->chance) << "\n";
    }
  }
};

} // anonymous namespace

Pass* createBranchHintAnalysisPass() { return new BranchHintAnalysis(); }

} // namespace wasm
