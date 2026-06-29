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
#include "ir/utils.h"
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
  BasicBlockConstraintMap startConstraints;
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
    // Start from the entry as the only reachable block. That block has incoming
    // values - defaults - for each var.
    entry->contents.startConstraints.setReachable();
    auto& entryConstraints = entry->contents.startConstraints;
    auto* func = getFunction();
    for (Index i = func->getVarIndexBase(); i < func->getNumLocals(); i++) {
      auto type = func->getLocalType(i);
      // TODO: support tuples
      if (type.size() == 1 && LiteralUtils::canMakeZero(type)) {
        // We have a default value, so we can prove something.
        auto value = Literal::makeZero(type);
        entryConstraints.set(i, Constraint{Abstract::Eq, {value}});
      }
      // Note that we need no special handling for non-nullable locals. They
      // cannot be used before being set, so it doesn't matter what we have in
      // the map for them. We leave them as proving nothing (as if they were
      // parameters in effect) as that is more efficient in the way the
      // information is encoded (see constraint.h).
    }

    // Starting from the entry, keep going while we find something new.
    UniqueDeferredQueue<BasicBlock*> work;
    work.push(entry);
    while (!work.empty()) {
      auto* block = work.pop();

      // Start at the top of the block, then go through, applying things.
      BasicBlockConstraintMap constraints = block->contents.startConstraints;
      for (auto** currp : block->contents.actions) {
        applyToConstraints(*currp, constraints);
      }

      // We now know the values at the end of the block. Flow it onward, and
      // where it causes changes, queue more work.
      for (auto* out : block->out) {
        auto& outStartConstraints = out->contents.startConstraints;

        // Find the constraints sent to this specific successor, if there is a
        // branch, and use them.
        auto sentConstraints = constraints;
        if (auto branch = getBranchConstraints(block, out)) {
          sentConstraints.approximateAnd(branch->local, branch->constraint);
        }

        // If anything changed at the start of the target block, flow onwards.
        auto old = outStartConstraints;
        outStartConstraints.approximateOr(sentConstraints);
        if (outStartConstraints != old) {
          work.push(out);
        }
      }
    }
  }

  // After inferring all we can, apply it to optimize the code.
  void optimize() {
    // If we make things unreachable, we must refinalize.
    bool refinalize = false;

    for (auto& block : basicBlocks) {
      // Follow the general shape of flow(): we need to see what the state is
      // at each intermediate point inside the block. (Flowing between blocks is
      // of course not needed at this stage.)
      auto& constraints = block->contents.startConstraints;
      for (auto** currp : block->contents.actions) {
        applyToConstraints(*currp, constraints);
        if (constraints.unreachable) {
          *currp = Builder(*getModule()).makeUnreachable();
          refinalize = true;
        }
        optimizeExpression(currp, constraints);
      }
    }

    if (refinalize) {
      ReFinalize().walkFunctionInModule(getFunction(), getModule());
    }
  }

  // Given an expression and the constraints on it, optimize it.
  void optimizeExpression(Expression** currp,
                          const BasicBlockConstraintMap& constraints) {
    auto* curr = *currp;
    auto parsed = LocalConstraint::parse(curr);
    if (!parsed) {
      return;
    }

    auto localConstraints = constraints.get(parsed->local);
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

  // Given a predecessor and one of its successors, find new constraints that
  // can be added due to the flow to that specific successor.
  std::optional<LocalConstraint> getBranchConstraints(BasicBlock* pred,
                                                      BasicBlock* succ) {
    auto* brancher = pred->contents.brancher;
    if (!brancher) {
      return {};
    }
    // We handle the case of two successors for now. When there are less, other
    // opts can handle things. TODO: Switch is the case of more than 2.
    if (pred->out.size() != 2) {
      return {};
    }
    // We pass the next function the index of the successor among the others.
    assert(succ == pred->out[0] || succ == pred->out[1]);
    auto succIndex = succ == pred->out[1] ? 1 : 0;

    if (auto* iff = brancher->dynCast<If>()) {
      return getConstraintsFromIf(iff, succIndex);
    } else if (auto* br = brancher->dynCast<Break>()) {
      return getConstraintsFromBreak(br, succIndex);
    } else if (auto* br = brancher->dynCast<BrOn>()) {
      return getConstraintsFromBrOn(br, succIndex);
    }
    // TODO: Switch
    return {};
  }

  // Gets branch constraints using a successor index and a parsed constraint.
  std::optional<LocalConstraint>
  getConstraintsFromParsed(LocalConstraint parsed, Index succIndex) {
    auto& [local, constraint] = parsed;

    // The boolean condition's constraint is added to the other contents, and
    // sent on the ifTrue. The negation is added to the ifFalse, so negate if
    // that is the path here. To detect that, use the fact that the CFG always
    // puts the ifTrue first in the successors.
    assert(succIndex < 2);
    if (succIndex == 1) {
      // This is the ifFalse.
      constraint = constraint.negate();
    }
    return LocalConstraint{local, constraint};
  }

  std::optional<LocalConstraint> getConstraintsFromIf(If* iff,
                                                      Index succIndex) {
    auto parsed = LocalConstraint::parseBoolean(iff->condition);
    if (parsed && succIndex == 1) {
      parsed = parsed->negate();
    }
    return parsed;
  }

  std::optional<LocalConstraint> getConstraintsFromBreak(Break* br,
                                                         Index succIndex) {
    // We get here when there is more than one successor, so there must be a
    // condition.
    assert(br->condition);

    auto parsed = LocalConstraint::parseBoolean(br->condition);
    if (!parsed) {
      return {};
    }

    auto [local, constraint] = *parsed;
    // Unlike If, we must flip the constraint. The adjacent block right
    // after the if is the ifTrue path, but for br_if, the adjacent block is
    // the fallthrough, i.e., ifFalse.
    return getConstraintsFromParsed(LocalConstraint{local, constraint.negate()},
                                    succIndex);

    return {};
  }

  std::optional<LocalConstraint> getConstraintsFromBrOn(BrOn* brOn,
                                                        Index succIndex) {
    // We only handle br_on of a local.
    auto* get = brOn->ref->dynCast<LocalGet>();
    if (!get) {
      return {};
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
        constraint = Constraint{op, {zero}};
        break;
      }
      default:
        // TODO: Handle BrOnCast* etc using subtyping operations.
        return {};
    }

    return getConstraintsFromParsed(LocalConstraint{get->index, constraint},
                                    succIndex);
  }

  // Given an expression, apply it to the constraints. For example, a local.set
  // sets the value for that local.
  void applyToConstraints(Expression* curr,
                          BasicBlockConstraintMap& constraints) {
    if (auto* set = curr->dynCast<LocalSet>()) {
      if (Properties::isSingleConstantExpression(set->value)) {
        // We know this one constraint.
        auto value = Properties::getLiteral(set->value);
        constraints.set(set->index, Constraint{Abstract::Eq, {value}});
      } else {
        // We know and can prove nothing.
        constraints.setProvesNothing(set->index);
      }
    }
  }
};

} // anonymous namespace

Pass* createConstraintAnalysisPass() { return new ConstraintAnalysis(); }

} // namespace wasm
