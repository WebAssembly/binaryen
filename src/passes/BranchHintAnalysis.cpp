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
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// In each basic block we will store instructions that either branch, or that
// provide hints as to branching.
struct Info {
  std::vector<Expression**> actions;
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
  bool branches(Expression* curr) {
    if (auto* br = curr->dynCast<Break>()) {
      return !!br->condition;
    }
    return curr->is<If>() || curr->is<BrOn>();
  }

  // An abstract probability of code being reached, in the range 0 - 100.
  using Probability = uint8_t;

  // Returns the probability that an instruction is reached, if something about
  // it suggests it is likely or not.
  std::optional<Probability> getProbability(Expression* curr) {
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
    // or suggest probabilities of branching.
    if (currBasicBlock && (branches(curr) || getProbability(curr))) {
      currBasicBlock->contents.actions.push_back(getCurrentPointer());
    }
  }

  void visitFunction(Function* curr) {
    // Now that the walk is complete and we have a CFG, find things to optimize.
    for (auto& block : basicBlocks) {
      std::cout << "block\n";
      for (auto** currp : block->contents.actions) {
        std::cout << "  " << **currp << "\n";
      }
    }
  }
};

} // anonymous namespace

Pass* createBranchHintAnalysisPass() { return new BranchHintAnalysis(); }

} // namespace wasm
