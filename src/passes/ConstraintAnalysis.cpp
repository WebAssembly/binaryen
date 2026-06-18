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
  // so at the start of each block, which is enough for the analysis below.
  //
  // We use an optional here to represent the "null" state before any
  // information arrives. (From the perspective of set theory, nullopt can be
  // taken to mean the empty set is the set of values possible for each local.)
  std::optional<LocalConstraintMap> startConstraints;
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

  static void doEndBranch(ConstraintAnalysis* self, Expression** currp) {
    if (self->currBasicBlock) {
      self->currBasicBlock->contents.brancher = *currp;
    }
    Super::doEndBranch(self, currp);
  }

  void visitFunction(Function* curr) {
    if (!entry) {
      // Body is unreachable, no entry block.
      return;
    }
    // TODO: optimize for speed, find relevant locals etc.
    flow();
    optimize();
  }

  // Flow infos around until we have inferred all we can about the constraints
  // in each location.
  void flow() {
    // Start from the entry. That block has incoming values - defaults - for
    // each var.
    auto& entryConstraints = entry->contents.startConstraints;
    entryConstraints.emplace();
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
        (*entryConstraints)[i].approximateAnd(
          Constraint{Abstract::Eq, {value}});
      }
    }

    // Starting from the entry, keep going while we find something new.
    UniqueDeferredQueue<BasicBlock*> work;
    work.push(entry);
    while (!work.empty()) {
      auto* block = work.pop();

      // Start at the top of the block, then go through, applying things.
      LocalConstraintMap constraints = *block->contents.startConstraints;
      for (auto** currp : block->contents.actions) {
        applyToConstraints(*currp, constraints);
      }

      // We now know the values at the end of the block. Flow it onward, and
      // where it causes changes, queue more work.
      for (auto* out : block->out) {
        // Find the constraints sent to this specific successor.
        auto sentConstraints =
          getConstraintsFromPredToSucc(block, out, constraints);

        auto& outConstraints = out->contents.startConstraints;
        if (!outConstraints) {
          // This is the first data arriving.
          outConstraints.emplace(sentConstraints);
          work.push(out);
          continue;
        }

        // This is later data, which may or may not cause changes.
        auto old = outConstraints;
        outConstraints->approximateOr(sentConstraints);
        if (*outConstraints != old) {
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
      auto& constraints = block->contents.startConstraints;
      if (!constraints) {
        // Unreachable.
        continue;
      }

      for (auto** currp : block->contents.actions) {
        applyToConstraints(*currp, *constraints);
        optimizeExpression(currp, *constraints);
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

  // Given a predecessor and one of its successors, find the constraints that
  // flow to that specific successor, given the constraints at the end of the
  // predecessor.
  const LocalConstraintMap getConstraintsFromPredToSucc(
    BasicBlock* pred, BasicBlock* succ, const LocalConstraintMap& predEnd) {
    auto* brancher = pred->contents.brancher;
    if (!brancher) {
      // No branching instruction to reason about. Just return what is at the
      // end of the pred, no matter where we go.
      return predEnd;
    }

    if (auto* iff = brancher->dynCast<If>()) {
      return getConstraintsFromBooleanBranch(
        pred, succ, predEnd, iff->condition);
    } else if (auto* br = brancher->dynCast<Break>()) {
      return getConstraintsFromBooleanBranch(
        pred, succ, predEnd, br->condition);
    } else if (auto* br = brancher->dynCast<BrOn>()) {
      return getConstraintsFromBrOn(pred, succ, predEnd, br);
    }
    // TODO: Switch
    // TODO: BrOn
    return predEnd;
  }

  // Gets constraints from a pred to a succ, given the branch at the end of the
  // pred is a boolean condition, that is, if the condition is true we take the
  // first path, and if not, the other.
  const LocalConstraintMap
  getConstraintsFromBooleanBranch(BasicBlock* pred,
                                  BasicBlock* succ,
                                  const LocalConstraintMap& predEnd,
                                  Expression* condition) {
    return getConstraintsFromParsed(
      pred, succ, predEnd, LocalConstraint::parseBoolean(condition));
  }

  const LocalConstraintMap
  getConstraintsFromBrOn(BasicBlock* pred,
                         BasicBlock* succ,
                         const LocalConstraintMap& predEnd,
                         BrOn* brOn) {
    // We only handle br_on of a local.
    auto* get = brOn->ref->dynCast<LocalGet>();
    if (!get) {
      return predEnd;
    }

    // The constraint on that local depends on the op.
    Constraint constraint;
    switch (brOn->op) {
      case BrOnNull:
      case BrOnNonNull: {
        // The first block that pred branches to is ifFalse (the immediate
        // successor, which is adjacent to the current block, and simply falls
        // through), so BrOnNull needs "!= null" here, which is true when we
        // reach that first block.
        auto op = brOn->op == BrOnNull ? Abstract::Ne : Abstract::Eq;
        auto nullType = get->type.getHeapType().getBottom();
        auto zero = Literal::makeZero(Type(nullType, Nullable));
        constraint = Constraint{op, zero};
        break;
      }
      default:
        // TODO: Handle BrOnCast* etc using subtyping operations.
        return predEnd;
    }

    return getConstraintsFromParsed(
      pred, succ, predEnd, LocalConstraint{get->index, constraint});
  }

  // Gets constraints from pred to succ, given a parsed LocalConstraint, which
  // represents the condition of the branch: if that constraint is true, it is
  // taken in the first path from pred, and otherwise the second.
  const LocalConstraintMap
  getConstraintsFromParsed(BasicBlock* pred,
                           BasicBlock* succ,
                           const LocalConstraintMap& predEnd,
                           std::optional<LocalConstraint> parsed) {

    if (!parsed) {
      return predEnd;
    }
    auto& [local, constraint] = *parsed;

    // The boolean condition's constraint is added to the other contents, and
    // sent on the ifTrue. The negation is added to the ifFalse, so negate if
    // that is the path here. To detect that, use the fact that the CFG always
    // puts the ifTrue first in the successors.
    auto& predOut = pred->out;
    if (predOut.size() != 2) {
      // In unreachable code, there is no block right after the branch. Other
      // passes can optimize away the branch entirely.
      return predEnd;
    }
    if (succ == predOut[1]) {
      // This is the ifFalse.
      if (auto negated = constraint.negate()) {
        constraint = *negated;
      } else {
        // This could not be negated.
        return predEnd;
      }
    } else {
      // It must be the ifTrue.
      assert(succ == predOut[0]);
    }
    auto combined = predEnd;
    combined[local].approximateAnd(constraint);
    return combined;
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
