/*
 * Copyright 2026 WebAssembly Community Group participants
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
// Finds ranges of values for locals, and uses them. For example:
//
//  if (x > 10) {
//    assert(x > 0); // redundant and can be removed.
//  }
//
// TODO: Look not just at integers but also references
//

#include "cfg/cfg-traversal.h"
#include "ir/local-graph.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// In each basic block we will store the relevant operations, which are all
// local gets and sets, branches, and uses of them.
struct Info {
  std::vector<Expression**> actions; // XXX just *?
};

struct RangeAnalysis
  : public WalkerPass<
      CFGWalker<RangeAnalysis, Info>> {
  bool isFunctionParallel() override { return true; }

  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<RangeAnalysis>();
  }

  using Super = WalkerPass<CFGWalker<RangeAnalysis, Info>>;

  // Branches outside of the function can be ignored, as we only look at local
  // state in the function.
  bool ignoreBranchesOutsideOfFunc = true;

  // Store struct.sets and blocks, as we can find patterns among those.
  void addAction() {
    if (currBasicBlock) {
      currBasicBlock->contents.actions.push_back(getCurrentPointer());
    }
  }

  // Track the branches we reason about. CFGWalker builds a CFG, and we want to
  // add information on top of that about which branch is due to which
  // instruction. For example, if block A branches to B and C, we want to know
  // if A ends in a br_if, so we can apply its condition to the branches to B
  // (if the condition is true) and C (if false).

  // Maps each branching instruction to the basic block right before the
  // branchings. For example, for an If, this is the block that branches to the
  // ifTrue and ifFalse blocks.
  std::unordered_map<If*, BasicBlock*> brancherBlocks;

  static void doStartIfTrue(SubType* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching.
    self->brancherBlocks[*currp] = self->currBasicBlock;

    Super::doStartIfTrue(self, currp);
  }

  static void doEndBranch(SubType* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching.
    XXX maybe leave for laterself->brancherBlocks[*currp] = self->currBasicBlock;
    Super::doEndBranch(self, currp);
  }

  void visitFunction(Function* curr) {
    // Now that the walk is complete and we have a CFG, find things to optimize.
    for (auto& block : basicBlocks) {
      for (auto** currp : block->contents.actions) {
        auto* curr = *currp;
        if (auto* set = curr->dynCast<StructSet>()) {
          optimizeStructSet(set, currp);
        } else if (auto* block = curr->dynCast<Block>()) {
          optimizeBlock(block);
        } else {
          WASM_UNREACHABLE("bad action");
        }
      }
    }
  }

private:
  // A local graph that is constructed the first time we need it.
  std::optional<LazyLocalGraph> localGraph;
  /*
      if (!localGraph) {
      localGraph.emplace(getFunction(), getModule(), StructSet::SpecificId);
    }
*/
};

} // anonymous namespace

Pass* createRangeAnalysisPass() { return new RangeAnalysis(); }

} // namespace wasm
