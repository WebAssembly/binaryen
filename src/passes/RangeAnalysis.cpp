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

// XXX actually a ConstraintAnalysis! Find constraints like x >= 0, x < y and
// link each local to the constraints on it, a list up to fixed depth. Then
// chak and compress it as we goo etc.

#include "cfg/cfg-traversal.h"
#include "ir/constraint.h"
#include "ir/drop.h"
#include "ir/literal-utils.h"
#include "ir/local-graph.h"
#include "ir/properties.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

using namespace wasm::constraint;

namespace {

using LocalConstraintMap = std::unordered_map<Index, AndedConstraintSet>;

// In each basic block we will store the relevant operations, which are all
// local gets and sets, branches, and uses of them.
struct Info {
  std::vector<Expression**> actions; // XXX just *?

  // For each local index, we track the constraints we know about it. We only do
  // so at the end of each block, which is enough gfor the analysis below.
  LocalConstraintMap endConstraints;
};

struct RangeAnalysis
  : public WalkerPass<CFGWalker<RangeAnalysis, Visitor<RangeAnalysis>, Info>> {
  bool isFunctionParallel() override { return true; }

  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<RangeAnalysis>();
  }

  using Super =
    WalkerPass<CFGWalker<RangeAnalysis, Visitor<RangeAnalysis>, Info>>;

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
  void visitUnary(Unary* curr) { addAction(); } // XXX needed?
  void visitBinary(Binary* curr) { addAction(); }

#if 0
  // Track the branches we reason about. CFGWalker builds a CFG, and we want to
  // add information on top of that about which branch is due to which
  // instruction. For example, if block A branches to B and C, we want to know
  // if A ends in a br_if, so we can apply its condition to the branches to B
  // (if the condition is true) and C (if false).

  // Maps each branching instruction to the basic block right before the
  // branchings. For example, for an If, this is the block that branches to the
  // ifTrue and ifFalse blocks.
  std::unordered_map<If*, BasicBlock*> brancherBlocks;

  static void doStartIfTrue(RangeAnalysis* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching.
    self->brancherBlocks[*currp] = self->currBasicBlock;

    Super::doStartIfTrue(self, currp);
  }
#endif

#if 0
  static void doEndBranch(RangeAnalysis* self, Expression** currp) {
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
      flow();
      optimize();
    }
  }

  // Flow infos around until we have inferred all we can about the constraints
  // in each location.
  void flow() {
    // Start from all the blocks, and keep going while we find something new.
    UniqueDeferredQueue<BasicBlock*> work;
    for (auto& block : basicBlocks) {
      work.push(block.get());
    }
    while (!work.empty()) {
      auto* block = work.pop();

      // Merge incoming data.
      LocalConstraintMap constraints = mergeIncoming(block);

      // Go through the block, applying things.
      for (auto** currp : block->contents.actions) {
        applyToConstraints(*currp, constraints);
      }

      // We now know the values at the end of the block. If something changed,
      // flow it onward.
      if (constraints != block->contents.endConstraints) {
        block->contents.endConstraints = std::move(constraints);
        for (auto* out : block->out) {
          work.push(out);
        }
      }
    }
  }

  // After inferring all we can, apply it to optimize the code.
  void optimize() {
    for (auto& block : basicBlocks) {
      // Follow the general shape of flow(): we need to see what the state is
      // at each intermediate point inside the block. (Flowing between blocks is
      // of course not needed at this stage.)

      LocalConstraintMap constraints = mergeIncoming(block.get());
      for (auto** currp : block->contents.actions) {
        applyToConstraints(*currp, constraints);
        optimizeExpression(currp, block.get(), constraints);
      }
    }
  }

  // Given a binary XXXand its block, try to optimize it. We provide the pointer
  // to the binary, so that it can be replaced if optimizable.
  void optimizeExpression(Expression** currp,
                          BasicBlock* block,
                          const LocalConstraintMap& constraints) {
    auto* curr = *currp;
    auto parsed = LocalConstraint::parse(curr);
    if (!parsed) {
      return;
    }

    auto iter = constraints.find(parsed->local);
    if (iter == constraints.end()) {
      return;
    }
    auto& localConstraints = iter->second;
    Result result = localConstraints.eval(parsed->constraint);
    if (result == Unknown) {
      // If we parsed something using two locals, like x != y, we can also look
      // for the flipped condition among y's constraints TODO
      return;
    }

    // We know the result!
    auto& wasm = *getModule();
    auto value =
      LiteralUtils::makeFromInt32(result == True ? 1 : 0, curr->type, wasm);
    *currp = getDroppedChildrenAndAppend(
      curr, wasm, getPassOptions(), value, DropMode::IgnoreParentEffects);
  }

  // Merge incoming data to a block, by looking at the data arriving from each
  // of the predecessor blocks.
  LocalConstraintMap mergeIncoming(BasicBlock* block) {
    LocalConstraintMap constraints;

    // For each relevant local, merge its constraints.
    for (auto local : relevantLocals) {
      AndedConstraintSet& merged = constraints[local];
      for (auto* pred : block->in) {
        merged.fuzzyOr(getConstraintsFromPredToSucc(pred, block, local));
      }
    }

    // The entry block has incoming values - defaults - for each var.
    if (block == entry) {
      auto* func = getFunction();
      auto numLocals = func->getNumLocals();
      for (Index i = 0; i < numLocals; i++) {
        if (!func->isVar(i)) {
          continue;
        }
        auto type = func->getLocalType(i);
        // TODO: support tuples
        if (type.size() == 1 && LiteralUtils::canMakeZero(type)) {
          auto value = Literal::makeZero(type);
          constraints[i].and_(Constraint{Abstract::Eq, value});
        }
      }
    }

    return constraints;
  }

  // Given a source (predecessor) and a target (successor) block, find the span
  // of a particular local as it arrives to that target from that successor.
  AndedConstraintSet getConstraintsFromPredToSucc(BasicBlock* pred,
                                                  BasicBlock* block,
                                                  Index local) {
    auto iter = pred->contents.endConstraints.find(local);
    if (iter == pred->contents.endConstraints.end()) {
      return {};
    }

    // TODO: use conditional branching to send different values along branches
    return iter->second;
  }

  // Given an expression, apply it to the constraints. For example, a local.set
  // sets the value for that local.
  void applyToConstraints(Expression* curr, LocalConstraintMap& constraints) {
    if (auto* set = curr->dynCast<LocalSet>()) {
      if (Properties::isSingleConstantExpression(set->value)) {
        auto value = Properties::getLiteral(set->value);
        auto& localConstraints = constraints[set->index];
        localConstraints.clear();
        localConstraints.and_(Constraint{Abstract::Eq, value});
      }
    }
  }
};

} // anonymous namespace

Pass* createRangeAnalysisPass() { return new RangeAnalysis(); }

} // namespace wasm
