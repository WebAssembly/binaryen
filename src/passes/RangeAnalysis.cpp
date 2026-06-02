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
// TODO: Compare locals, inferring that x <= y in some range (necessary for
//       software bounds check removal.
// TODO: Look not just at integers but also references
//

#include <variant>

#include "cfg/cfg-traversal.h"
#include "ir/local-graph.h"
#include "ir/properties.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

struct Unknown : public std::monostate {};

// In each range of values, one of the values. This can be either a literal like
// i32(0), or a local index (i.e., a reference to another local, showing that
// this one is related to them somehow: one of ==, <, >=, etc.), or something
// unknown.
using Value = std::variant<Literal, Index>;

// A range of values, [min, max] (inclusive).
// TODO: support more clever things like unions
struct Span {
  Value min;
  Value max;
};

// The span of values we inferred for locals.
using LocalSpans = std::unordered_map<Index, Span>;

// In each basic block we will store the relevant operations, which are all
// local gets and sets, branches, and uses of them.
struct Info {
  std::vector<Expression**> actions; // XXX just *?

  // We track them local spans at
  // the start and at the end of the block (for the values in the middle, we
  // need to traverse the actions and see how they are modified).
  LocalSpans localSpansStart, localSpansEnd;
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

  // Store the actions we care about.
  void addAction() {
    if (currBasicBlock) {
      currBasicBlock->contents.actions.push_back(getCurrentPointer());
    }
  }

  void visitLocalGet(LocalGet* curr) { addAction(); } // XXX needed?
  void visitLocalSet(LocalSet* curr) { addAction(); }
  void visitUnary(Unary* curr) { addAction(); }
  void visitBinary(Binary* curr) { addAction(); }

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

#if 0
  static void doEndBranch(SubType* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching.
    XXX maybe leave for laterself->brancherBlocks[*currp] = self->currBasicBlock;
    Super::doEndBranch(self, currp);
  }
#endif

  // We start with the relevant locals, i.e. which we could optimize: for
  // example, if we see (i32.eqz (local.get $x)) then we know that information
  // about $x might resolve the eqz, and we compute it and things related to
  // it.
  std::unordered_set<Index> relevantLocals;

  void visitFunction(Function* curr) {
    // Now that the walk is complete and we have a CFG, find things to optimize.

    auto maybeAdd = [&](Expression* value) {
      // Given a value flowing into something we can optimize, see if there is a
      // local there, and if so, mark it as relevant.
      // TODO: handle tee
      // TODO: handle fallthrough values
      if (auto* get = value->dynCast<LocalGet>()) {
        relevantLocals.insert(get->index);
      }
    };

    for (auto& block : basicBlocks) {
      for (auto** currp : block->contents.actions) {
        auto* curr = *currp;
        // TODO: specific unary/binary ops
        if (auto* unary = curr->dynCast<Unary>()) {
          maybeAdd(unary->value);
        } else if (auto* binary = curr->dynCast<Binary>()) {
          maybeAdd(binary->left);
          maybeAdd(binary->right);
        }
      }
    }

    // Values can flow between locals: if x is relevant, and y is written to it,
    // we must consider y relevant too. TODO?

    if (!relevantLocals.empty()) {
      optimize();
    }
  }

  void optimize() {
    // There is something to potentially optimize. For each relevant local,
    // find its sets and branches and flow ranges around, producing a graph of
    // the value of each relevant local in each block.
    for (auto& block : basicBlocks) {
      LocalSpans localSpans;
      for (auto** currp : block->contents.actions) {
        auto* curr = *currp;
        if (auto* set = curr->dynCast<LocalSet>()) {
          if (relevantLocals.contains(set->index)) {
            Value value;
            // TODO: fallthrough, tee chains, etc.
            if (auto* get = set->value->dynCast<LocalGet>()) {
              value = get->index;
            } else if (auto* c = set->value->dynCast<Const>()) {
              value = c->value;
            } else {
              value = Unknown;
            }
            // Both the min and max are equal to what we found.
            localSpans[set->index] = Span{value, value};
          }
        }
      }
    }
  }

private:
  /*
  // A local graph that is constructed the first time we need it.
  std::optional<LazyLocalGraph> localGraph;
      if (!localGraph) {
      localGraph.emplace(getFunction(), getModule(), StructSet::SpecificId);
    }
*/
};

} // anonymous namespace

Pass* createRangeAnalysisPass() { return new RangeAnalysis(); }

} // namespace wasm
