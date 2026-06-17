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
// Use mathematical constraint solving to optimize. For example:
//
//  if (x == 10) {
//    assert(x != 0); // redundant and can be removed.
//  }
//

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

// Information in a basic block.
struct Info {
  // All relevant operations: local gets and sets and uses of them.
  std::vector<Expression**> actions;

  // The branching instruction at the end of the block (or nullptr if there is
  // something like a return or an unreachable, which are terminators that don't
  // interest us in this pass - we just look at ifs and brs).
  Expression* brancher = nullptr;

  // For each local index, we track the constraints we know about it. We only do
  // so at the end of each block, which is enough for the analysis below.
  LocalConstraintMap endConstraints;
};

struct ConstraintAnalysis
  : public WalkerPass<
      CFGWalker<ConstraintAnalysis, Visitor<ConstraintAnalysis>, Info>> {
  bool isFunctionParallel() override { return true; }

  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<ConstraintAnalysis>();
  }

  using Super = WalkerPass<
    CFGWalker<ConstraintAnalysis, Visitor<ConstraintAnalysis>, Info>>;

  // Branches outside of the function can be ignored, as we only look at local
  // state in the function.
  bool ignoreBranchesOutsideOfFunc = true;

  // Store the actions we care about.
  void addAction() {
    if (currBasicBlock) {
      currBasicBlock->contents.actions.push_back(getCurrentPointer());
    }
  }

  void visitLocalSet(LocalSet* curr) { addAction(); }
  void visitUnary(Unary* curr) { addAction(); }
  void visitBinary(Binary* curr) { addAction(); }
  void visitRefEq(RefEq* curr) { addAction(); }
  void visitRefIsNull(RefIsNull* curr) { addAction(); }

  static void doStartIfTrue(ConstraintAnalysis* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching. Mark the If as the brancher (unless in unreachable code).
    if (self->currBasicBlock) {
      self->currBasicBlock->contents.brancher = *currp;
    }

    Super::doStartIfTrue(self, currp);
  }

#if 0
  static void doEndBranch(ConstraintAnalysis* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching.
    XXX maybe leave for laterself->brancherBlocks[*currp] = self->currBasicBlock;
    Super::doEndBranch(self, currp);
  }
#endif

  void visitFunction(Function* curr) {
    // TODO: optimize for speed, find relevant locals etc.
    flow();
    optimize();
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

      // Merge incoming data to get the status at the start of the block.
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
        optimizeExpression(currp, constraints);
      }
    }
  }

  // Given an expression and the constraints on it, optimize it.
  void optimizeExpression(Expression** currp,
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
    Result result = localConstraints.proves(parsed->constraint);
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

    // Merge all preds.
    for (auto* pred : block->in) {
      auto& predConstraints = getConstraintsFromPredToSucc(pred, block);
      if (pred == *block->in.begin()) {
        // This is the first.
        constraints = std::move(predConstraints);
      } else {
        // Merge in subsequent ones.
        constraints.approximateOr(predConstraints);
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
          constraints[i].approximateAnd(Constraint{Abstract::Eq, {value}});
        }
      }
    }

    return constraints;
  }

  // Given a source (predecessor) and a target (successor) block, find the
  // constraints for locals as they arrive to that target from that successor.
  const LocalConstraintMap getConstraintsFromPredToSucc(BasicBlock* pred,
                                                        BasicBlock* block) {
    auto* brancher = pred->contents.brancher;
    auto& predEnd = pred->contents.endConstraints;
    if (!brancher) {
      // No branching instruction to reason about. Just return what is at the
      // end of the pred, no matter where we go.
      return predEnd;
    }

    if (auto* iff = brancher->dynCast<If>()) {
      auto parsed = LocalConstraint::parse(iff->condition);
      if (!parsed) {
        return predEnd;
      }
      auto& [local, constraint] = *parsed;

      // The if's condition's constraint is added to the other contents, and
      // sent on the ifTrue. The negation is added to the ifFalse, so negate if
      // that is the path here. To detect that, use the fact that the CFG always
      // puts the ifTrue first in the successors.
      auto& predOut = pred->out;
      assert(predOut.size() == 2);
      if (block == predOut[1]) {
        // This is the ifFalse.
        if (auto negated = constraint.negate()) {
          constraint = *negated;
        } else {
          // This could not be negated.
          return predEnd;
        }
      } else {
        // It must be the ifTrue.
        assert(block == predOut[0]);
      }
      auto combined = predEnd;
      combined[local].approximateAnd(constraint);
      return combined;
    }

    WASM_UNREACHABLE("unknown brancher");
  }

  // Given an expression, apply it to the constraints. For example, a local.set
  // sets the value for that local.
  void applyToConstraints(Expression* curr, LocalConstraintMap& constraints) {
    if (auto* set = curr->dynCast<LocalSet>()) {
      auto& localConstraints = constraints[set->index];
      localConstraints.clear();
      if (Properties::isSingleConstantExpression(set->value)) {
        auto value = Properties::getLiteral(set->value);
        localConstraints.approximateAnd(Constraint{Abstract::Eq, {value}});
      }
    }
  }
};

} // anonymous namespace

Pass* createConstraintAnalysisPass() { return new ConstraintAnalysis(); }

} // namespace wasm
