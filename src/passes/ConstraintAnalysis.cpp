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
// The normal version of this pass flows constraints around in the most precise
// way that we can. However, while doing so, it must avoid optimizing loop
// variables, because of the following problem:
//
//  x = 0
//  do {
//    print(x >= 0 & x < 100)
//    x++
//  } while (x < 100)
//
// Say that we flow information around precisely. Then initially x is 0 at the
// top of the loop, and x++ turns it into 1. 1 < 100 so we return to the top of
// the loop, and now x can be 0 or 1. We will then interpret this loop for 100
// iterations at compile time, which is obviously not a good idea.
//
// Instead, in "normal" mode we just don't increment variables when we see x++.
// This does limit us, but only on loops, in practice - if x is not in a loop,
// and we know its constant value, then x++ would be optimized away by other
// passes. And, by avoiding a precise execution of x++, we avoid the problem of
// interpreting loops at compile time.
//
// But we do want to optimize loops like the example above. The second part,
// x < 100, is trivial: at the loop top, either x == 0 from before the loop, or
// x < 100 from the loop backedge, and both prove x < 100. However x >= 0 is
// non-obvious: if x is *signed*, then we must rule out the possibility of it
// getting incremented so many times that it overflows and becomes negative.
// Proving that requires actually seeing that the loop variable x is incremented
// from 0 to 100, and no more, and that involves an interaction of the initial
// value, the increment, and the condition on the loop backedge.
//
// To optimize this, in "loops" mode we "jump ahead" to what is likely a loop
// limit: if we see a loop variable that is branched on, we expand the range of
// values the variable can take up to that bound. Concretely, we do this:
//
//   * We do implement x++, turning x from 0 to 1 in the example above, in the
//     first iteration of the loop.
//   * When we then see x == 1 that branches with x < 100, we turn that into
//     x >= 1 && x < 100. This is "imprecise", because perhaps the local will
//     not actually get incremented all the way to 100, but it is an upper
//     bound that ends up getting us to the result we want in common loop
//     shapes. (And it is safe to do because we allow more values for x, meaning
//     we can prove fewer things, so we won't prove anything false.)
//
// After doing that, we return to the top of the loop, where now we can see
// x >= 0 && x < 100. After running that through the loop a second time, no more
// changes will happen: we successfully "jumped ahead" to the end state of the
// loop variable.
//
// In theory, "normal" mode may optimize some things better than "loops" mode,
// as the "jump ahead" behavior extends ranges of variables eagerly, before we
// know they actually can fill out that range. In practice, however, it is rare
// to see a constant to which is applied a bound like x < 100, unless it is
// actually a loop variable: if it isn't a loop variable, then other passes
// would propagate the constant and remove the bounds check. Still, both modes
// of this pass are kept for comparison purposes.
//

#include "cfg/cfg-traversal.h"
#include "ir/constraint.h"
#include "ir/drop.h"
#include "ir/eh-utils.h"
#include "ir/literal-utils.h"
#include "ir/local-graph.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "support/utilities.h"
#include "wasm-builder.h"
#include "wasm.h"

#define CONSTRAINT_DEBUG 0

#ifndef CONSTRAINT_DEBUG
#define CONSTRAINT_DEBUG 0
#endif

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

  void dump(Function* func) {
    std::cout << "Info{" << actions.size();
    if (brancher) {
      std::cout << ", " << *brancher;
    }
    std::cout << ", " << startConstraints << "}\n";
  }
};

struct ConstraintAnalysis
  : public WalkerPass<
      CFGWalker<ConstraintAnalysis, Visitor<ConstraintAnalysis>, Info>> {
  bool isFunctionParallel() override { return true; }

  // Locals are not modified here.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<ConstraintAnalysis>(loops);
  }

  // Whether we are in "loops" mode, see above.
  bool loops;

  ConstraintAnalysis(bool loops) : loops(loops) {}

  using Super = WalkerPass<
    CFGWalker<ConstraintAnalysis, Visitor<ConstraintAnalysis>, Info>>;

  // Branches outside of the function can be ignored, as we only look at local
  // state in the function.
  bool ignoreBranchesOutsideOfFunc = true;

  // A relevant local is one that is used as part of an expression that we can
  // optimize (often, many locals are irrelevant).
  std::vector<bool> relevantLocals;
  // Track local copies too, as if one local is relevant, it can make another
  // relevant. We store pairs here of key=target, value=sources, which is the
  // direction we will flow in the analysis: if we check x == 10, making it
  // relevant, and x = y earlier, then we must track that source, y, so that we
  // know what it writes to x.
  std::unordered_map<Index, std::vector<Index>> localCopySources;

  void maybeMarkRelevant(Expression* curr) {
    // If this parses into a constraint on a local, that local is relevant.
    if (auto parsed = LocalConstraint::parseCondition(curr)) {
      relevantLocals[parsed->local] = true;
      if (auto* other = std::get_if<Index>(&parsed->constraint.term)) {
        relevantLocals[*other] = true;
      }
    }
  }

  void doWalkFunction(Function* func) {
    relevantLocals.assign(func->getNumLocals(), false);

    Super::doWalkFunction(func);
  }

#ifndef NDEBUG
  // We use these in asserts, see below.
  std::unordered_set<Expression*> originalActions;
#endif

  // Store the actions we care about.
  void addAction() {
    if (currBasicBlock) {
      auto* currp = getCurrentPointer();
      currBasicBlock->contents.actions.push_back(currp);
#ifndef NDEBUG
      originalActions.insert(*currp);
#endif
    }
  }

  void visitLocalSet(LocalSet* curr) {
    addAction();
    if (auto* get = curr->value->dynCast<LocalGet>()) {
      // TODO: handle tees once we handle them elsewhere
      localCopySources[curr->index].push_back(get->index);
    }
  }

  void visitUnary(Unary* curr) {
    addAction();
    maybeMarkRelevant(curr);
  }

  void visitBinary(Binary* curr) {
    addAction();
    maybeMarkRelevant(curr);
  }

  void visitRefEq(RefEq* curr) {
    addAction();
    maybeMarkRelevant(curr);
  }

  void visitRefIsNull(RefIsNull* curr) {
    addAction();
    maybeMarkRelevant(curr);
  }

  static void doStartIfTrue(ConstraintAnalysis* self, Expression** currp) {
    // We are right after the condition, so we are in the block before the If's
    // branching. Mark the If as the brancher (unless in unreachable code).
    if (self->currBasicBlock) {
      self->currBasicBlock->contents.brancher = *currp;
    }
    if (auto* iff = (*currp)->dynCast<If>()) {
      self->maybeMarkRelevant(iff->condition);
    }
    Super::doStartIfTrue(self, currp);
  }

  static void doEndBranch(ConstraintAnalysis* self, Expression** currp) {
    if (self->currBasicBlock) {
      self->currBasicBlock->contents.brancher = *currp;
    }
    if (auto* br = (*currp)->dynCast<Break>()) {
      if (br->condition) {
        self->maybeMarkRelevant(br->condition);
      }
    } else if (auto* brOn = (*currp)->dynCast<BrOn>()) {
      self->maybeMarkRelevant(brOn->ref);
    }
    Super::doEndBranch(self, currp);
  }

  void visitFunction(Function* curr) {
    if (!entry) {
      // Body is unreachable, no entry block.
      return;
    }

    computeRelevantLocals();
    flow();
    optimize();
  }

  // Every relevant local makes the things it is copied to relevant as well.
  void computeRelevantLocals() {
    // We'll start from all relevant locals, and flow from there.
    UniqueDeferredQueue<Index> work;
    for (Index i = 0; i < relevantLocals.size(); i++) {
      if (relevantLocals[i]) {
        work.push(i);
      }
    }

    // Flow.
    while (!work.empty()) {
      auto curr = work.pop();
      assert(relevantLocals[curr]);
      if (auto iter = localCopySources.find(curr);
          iter != localCopySources.end()) {
        for (auto source : iter->second) {
          if (!relevantLocals[source]) {
            relevantLocals[source] = true;
            work.push(source);
          }
        }
      }
    }
  }

  // Flow infos around until we have inferred all we can about the constraints
  // in each location.
  void flow() {
#if CONSTRAINT_DEBUG
    dumpCFG("flow");
#endif

    // Start from the entry as the only reachable block. That block has incoming
    // values - defaults - for each var.
    entry->contents.startConstraints.setReachable();
    auto& entryConstraints = entry->contents.startConstraints;
    auto* func = getFunction();
    for (Index i = func->getVarIndexBase(); i < func->getNumLocals(); i++) {
      if (!relevantLocals[i]) {
        // No point to apply a constraint to an irrelevant local.
        continue;
      }
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

#if CONSTRAINT_DEBUG
      std::cout << block << " start constraints: " << constraints << '\n';
#endif

      for (auto** currp : block->contents.actions) {
        applyToConstraints(*currp, constraints);
      }

#if CONSTRAINT_DEBUG
      std::cout << block << " end   constraints: " << constraints << '\n';
#endif

      // We now know the values at the end of the block. Flow it onward, and
      // where it causes changes, queue more work.
      for (auto* out : block->out) {
        auto& outStartConstraints = out->contents.startConstraints;

        // Find the constraints sent to this specific successor, if there is a
        // branch, and use them.
        if (auto branch = getBranchConstraints(block, out);
            branch && checkRelevancy(*branch)) {
          auto sentConstraints = constraints;
          applyBranchConstraints(*branch, sentConstraints);
#if CONSTRAINT_DEBUG
          std::cout << block << " sending branch to " << out
                    << " with sent constraints: " << sentConstraints << '\n';
#endif
          // If anything changed at the start of the target block, flow onwards.
          if (outStartConstraints.approximateOr(sentConstraints)) {
#if CONSTRAINT_DEBUG
            std::cout << "out's start after  " << outStartConstraints << '\n';
            std::cout << block << " branch-modified " << out
                      << " to start with: " << outStartConstraints << '\n';
#endif
            work.push(out);
          }
        } else {
          // There are no specific branch constraints, so send the unmodified
          // |constraints|, avoiding a copy.
          if (outStartConstraints.approximateOr(constraints)) {
#if CONSTRAINT_DEBUG
            std::cout << block << " modified " << out
                      << " to start with: " << outStartConstraints << '\n';
#endif
            work.push(out);
          }
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
#if CONSTRAINT_DEBUG
        std::cout << block << " trying to optimize " << **currp << '\n';
#endif
        if (!constraints.unreachable) {
          applyToConstraints(*currp, constraints);
          optimizeExpression(currp, constraints);
        } else {
          // This is unreachable code: just mark it so.
          *currp = getDroppedChildrenAndAppend(
            *currp,
            *getModule(),
            getPassOptions(),
            Builder(*getModule()).makeUnreachable());
          refinalize = true;
        }
      }
    }

    if (refinalize) {
      ReFinalize().walkFunctionInModule(getFunction(), getModule());
      EHUtils::handleBlockNestedPops(getFunction(), *getModule());
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
    if (!checkRelevancy(*parsed)) {
#ifndef NDEBUG
      // If this is not relevant, then it must be one of the original actions we
      // care about, i.e., not the result of optimizations. See the comment
      // below on checkRelevancy.
      assert(originalActions.contains(curr));
#endif
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

    // CFGWalker builds the IR by putting the physical successor as the first
    // successor (that is, the first is the one we reach without branching).
    // We pass that along to the specific branch type handlers, so they can
    // figure out if we are in the true or false path.
    assert(succ == pred->out[0] || succ == pred->out[1]);
    auto physicalSuccessor = (succ == pred->out[0]);

    if (auto* iff = brancher->dynCast<If>()) {
      return getConstraintsFromIf(iff, physicalSuccessor);
    } else if (auto* br = brancher->dynCast<Break>()) {
      return getConstraintsFromBreak(br, physicalSuccessor);
    } else if (auto* br = brancher->dynCast<BrOn>()) {
      return getConstraintsFromBrOn(br, physicalSuccessor);
    }
    // TODO: Switch
    return {};
  }

  std::optional<LocalConstraint> getConstraintsFromIf(If* iff,
                                                      bool physicalSuccessor) {
    auto parsed = LocalConstraint::parseCondition(iff->condition);
    if (parsed && !physicalSuccessor) {
      // We are in the ifFalse, so negate the condition.
      parsed->constraint = parsed->constraint.negate();
    }
    return parsed;
  }

  std::optional<LocalConstraint>
  getConstraintsFromBreak(Break* br, bool physicalSuccessor) {
    // We get here when there is more than one successor, so there must be a
    // condition.
    assert(br->condition);

    auto parsed = LocalConstraint::parseCondition(br->condition);
    if (parsed && physicalSuccessor) {
      // The branch was not taken, so negate the condition.
      parsed->constraint = parsed->constraint.negate();
    }
    return parsed;
  }

  std::optional<LocalConstraint>
  getConstraintsFromBrOn(BrOn* brOn, bool physicalSuccessor) {
    // The constraint on that local depends on the op.
    // TODO: Handle BrOnCast* etc using subtyping operations.
    if (brOn->op != BrOnNull && brOn->op != BrOnNonNull) {
      return {};
    }

    // parseCondition can parse more things than a local.get, which is all we
    // handle here, but there is no other valid IR that can appear there, so we
    // can reuse it.
    auto parsed = LocalConstraint::parseCondition(brOn->ref);
    // Negate depending on the op and (similar to Break) the successor.
    if (parsed && ((brOn->op == BrOnNull) ^ physicalSuccessor)) {
      parsed->constraint = parsed->constraint.negate();
    }
    return parsed;
  }

  // When applying constraints for a binary operation like x = y + 1, we may
  // end up with lots of nonlinear work, in a loop: x may go from 0 to 1, then
  // branch back to the top and merge, making it in the range [0, 1], then get
  // incremented and loop again, leading to [0, 2] and so forth, only stopping
  // when it reaches the loop bound, which may be very high. We don't want to
  // spend significant time on such constant operations, as other passes will
  // propagate them anyhow, so we verify that we don't apply such x = y + 1
  // operations too many times.
#ifndef NDEBUG
  static const Index MaxBinaryActions = 5;

  // How many times we processed each Binary action.
  std::unordered_map<Binary*, Index> binaryActionCounts;
#endif

  // Given an expression, apply it to the constraints. For example, a local.set
  // sets the value for that local.
  void applyToConstraints(Expression* curr,
                          BasicBlockConstraintMap& constraints) {
    if (auto* set = curr->dynCast<LocalSet>()) {
      if (!relevantLocals[set->index]) {
        // No point to apply a constraint to an irrelevant local.
        return;
      }

#ifndef NDEBUG
      // See above on binary action counting limits.
      if (auto* binary = set->value->dynCast<Binary>()) {
        assert(binaryActionCounts[binary]++ <= MaxBinaryActions);
      }
#endif

      constraints.set(set->index, set->value);
    }
  }

  // When we are about to use or apply a constraint to a local, it must be on a
  // relevant one - otherwise we misidentified which are relevant, which could
  // lead to missed opportunities or misoptimizations. This returns true if we
  // are operating on proper, relevant data. Normally this is all that can
  // happen, but intermediate optimizations can make things become relevant,
  // consider this:
  //
  //  x == (y < 10)
  //
  // The outer == is initially not relevant: we are comparing x to something we
  // can't parse into a constraint's term. However, if we get lucky and optimize
  // y < 10 into a constant, then it does become parseable, but because we did
  // not consider x as relevant (and so we do not have all the relevant
  // information about it), we must return false here and not operate on it
  // (later optimization cycles can get to it).
  bool checkRelevancy(const LocalConstraint& parsed) {
    if (!relevantLocals[parsed.local]) {
      return false;
    }
    if (auto* other = std::get_if<Index>(&parsed.constraint.term)) {
      if (!relevantLocals[*other]) {
        return false;
      }
    }
    return true;
  }

  // Apply branch constraints to the current set of constraints.
  void applyBranchConstraints(const LocalConstraint& branch,
                              BasicBlockConstraintMap& constraints) {
    // In "loops" mode, extend the range of values in the "jump ahead" manner.
    if (loops && applyBranchRangeExtensionToConstraints(branch, constraints)) {
      return;
    }

    constraints.approximateAnd(branch.local, branch.constraint);
  }

  bool
  applyBranchRangeExtensionToConstraints(const LocalConstraint& branch,
                                         BasicBlockConstraintMap& constraints) {
    assert(loops);

    using namespace Abstract;

    // "Jump ahead" and extend ranges. If the branch is x < M, and we were
    // x == N where N < M, then extend to x >= N && x < M, as described in the
    // top level comment.
    if (auto* M = std::get_if<Literal>(&branch.constraint.term)) {
      auto localConstraints = constraints.get(branch.local);
      if (localConstraints.size() == 1 &&
          localConstraints[0].op == Abstract::Eq) {
        if (auto* N = std::get_if<Literal>(&localConstraints[0].term)) {
          // We can handle both x < M as the branch, as described above, or
          // x <= M (if N <= M).
          if ((branch.constraint.op == Abstract::LtS &&
               N->ltS(*M).getUnsigned()) ||
              (branch.constraint.op == Abstract::LeS &&
               N->leS(*M).getUnsigned())) {
            constraints.set(branch.local, branch.constraint);
            constraints.approximateAnd(branch.local, {GeS, {*N}});
            return true;
          }
          if ((branch.constraint.op == Abstract::LtU &&
               N->ltU(*M).getUnsigned()) ||
              (branch.constraint.op == Abstract::LeU &&
               N->leU(*M).getUnsigned())) {
            constraints.set(branch.local, branch.constraint);
            constraints.approximateAnd(branch.local, {GeU, {*N}});
            return true;
          }
        }
      }
    }

    return false;
  }
};

} // anonymous namespace

Pass* createConstraintAnalysisPass() { return new ConstraintAnalysis(false); }
Pass* createConstraintAnalysisLoopsPass() {
  return new ConstraintAnalysis(true);
}

// see a.txt

} // namespace wasm
