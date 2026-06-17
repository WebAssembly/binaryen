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

// In each basic block we will store the relevant operations, which are all
// local gets and sets, branches, and uses of them.
struct Info {
  std::vector<Expression**> actions;

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
        // This is the first. Just copy.
        constraints = predConstraints;
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
          constraints[i].approximateAnd(Constraint{Abstract::Eq, value});
        }
      }
    }

    return constraints;
  }

  // Given a source (predecessor) and a target (successor) block, find the
  // constraints for locals as they arrive to that target from that successor.
  const LocalConstraintMap& getConstraintsFromPredToSucc(BasicBlock* pred,
                                                         BasicBlock* block) {
    // TODO: use conditional branching to send different values along branches
    return pred->contents.endConstraints;
  }

  // Given an expression, apply it to the constraints. For example, a local.set
  // sets the value for that local.
  void applyToConstraints(Expression* curr, LocalConstraintMap& constraints) {
    if (auto* set = curr->dynCast<LocalSet>()) {
      auto& localConstraints = constraints[set->index];
      localConstraints.clear();
      if (Properties::isSingleConstantExpression(set->value)) {
        auto value = Properties::getLiteral(set->value);
        localConstraints.approximateAnd(Constraint{Abstract::Eq, value});
      }
    }
  }
};

} // anonymous namespace

Pass* createConstraintAnalysisPass() { return new ConstraintAnalysis(); }

} // namespace wasm
