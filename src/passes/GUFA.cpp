/*
 * Copyright 2022 WebAssembly Community Group participants
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
// Grand Unified Flow Analysis (GUFA)
//
// Optimize based on information about what content can appear in each location
// in the program. This does a whole-program analysis to find that out and
// hopefully learn more than the type system does - for example, a type might be
// $A, which means $A or any subtype can appear there, but perhaps the analysis
// can find that only $A', a particular subtype, can appear there in practice,
// and not $A or any subtypes of $A', etc. Or, we may find that no type is
// actually possible at a particular location, say if we can prove that the
// casts on the way to that location allow nothing through. We can also find
// that only a particular value is possible of that type.
//

#include "ir/drop.h"
#include "ir/eh-utils.h"
#include "ir/possible-contents.h"
#include "ir/properties.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

struct GUFAPass : public Pass {
  void run(PassRunner* runner, Module* module) override {
    ContentOracle oracle(*module);

    struct Optimizer
      : public WalkerPass<
          PostWalker<Optimizer, UnifiedExpressionVisitor<Optimizer>>> {
      bool isFunctionParallel() override { return true; }

      ContentOracle& oracle;

      Optimizer(ContentOracle& oracle) : oracle(oracle) {}

      Optimizer* create() override { return new Optimizer(oracle); }

      bool optimized = false;

      // Check if removing something (but not its children - just the node
      // itself) would be ok structurally - whether the IR would still validate.
      bool canRemoveStructurally(Expression* curr) {
        // We can remove almost anything, but not a branch target, as we still
        // need the target for the branches to it to validate.
        if (BranchUtils::getDefinedName(curr).is()) {
          return false;
        }
        // Pops are structurally necessary in catch bodies, and removing a try
        // could leave a pop without a proper parent.
        return !curr->is<Pop>() && !curr->is<Try>();
      }

      // Whether we can remove something (but not its children) without changing
      // observable behavior.
      bool canRemove(Expression* curr) {
        if (!canRemoveStructurally(curr)) {
          return false;
        }
        return !EffectAnalyzer(getPassOptions(), *getModule(), curr)
                  .hasUnremovableSideEffects();
      }

      // Whether we can replcae something (but not its children) with an
      // unreachable without changing observable behavior.
      bool canReplaceWithUnreachable(Expression* curr) {
        if (!canRemoveStructurally(curr)) {
          return false;
        }
        EffectAnalyzer effects(getPassOptions(), *getModule(), curr);
        // Ignore a trap, as the unreachable replacement would trap too.
        effects.trap = false;
        return !effects.hasUnremovableSideEffects();
      }

      // Given we know an expression is equivalent to a constant, check if we
      // should in fact replace it with that constant.
      bool shouldOptimizeToConstant(Expression* curr) {
        // We should not optimize something that is already a constant. But we
        // can just assert on that as we should have not even gotten here, as
        // there is an early exit for that.
        assert(!Properties::isConstantExpression(curr));

        // The case that we do want to avoid here is if this looks like the
        // output of our optimization, which is (block .. (constant)), a block
        // ending in a constant and with no breaks to it. If this is already so
        // then do nothing (this avoids repeated runs of the pass monotonically
        // increasing code size for no benefit).
        if (auto* block = curr->dynCast<Block>()) {
          // If we got here, the list cannot be empty - an empty block is not
          // equivalent to any constant, so a logic error occurred before.
          assert(!block->list.empty());
          if (!BranchUtils::BranchSeeker::has(block, block->name) &&
              Properties::isConstantExpression(block->list.back())) {
            return false;
          }
        }
        return true;
      }

      void visitExpression(Expression* curr) {
#if 0
        static auto LIMIT = getenv("LIMIT") ? atoi(getenv("LIMIT")) : size_t(-1);
        if (LIMIT == 0) {
          return;
        }
        LIMIT--;
#endif
        auto type = curr->type;
        if (type == Type::unreachable || type == Type::none) {
          return;
        }

        if (Properties::isConstantExpression(curr)) {
          return;
        }

        auto& options = getPassOptions();
        auto& wasm = *getModule();
        Builder builder(wasm);

        auto replaceWithUnreachable = [&]() {
          if (canReplaceWithUnreachable(curr)) {
            replaceCurrent(getDroppedChildren(
              curr, builder.makeUnreachable(), wasm, options));
          } else {
            // We can't remove this, but we can at least put an unreachable
            // right after it.
            replaceCurrent(builder.makeSequence(builder.makeDrop(curr),
                                                builder.makeUnreachable()));
          }
          optimized = true;
        };

        if (type.isTuple()) {
          // TODO: tuple types.
          return;
        }

        if (type.isRef() && getTypeSystem() != TypeSystem::Nominal) {
          // Without nominal typing we skip analysis of subtyping, so we cannot
          // infer anything about refs.
          return;
        }

        auto values = oracle.getTypes(ExpressionLocation{curr, 0});

        if (values.getType() == Type::unreachable) {
          // This cannot contain any possible value at all. It must be
          // unreachable code.
          replaceWithUnreachable();
          return;
        }

        if (!values.isConstant()) {
          return;
        }
        if (!shouldOptimizeToConstant(curr)) {
          return;
        }

        // This is a constant value that we should optimize to.
        auto* c = values.makeExpression(wasm);
        // We can only place the constant value here if it has the right
        // type. For example, a block may return (ref any), that is, not allow
        // a null, but in practice only a null may flow there.
        if (Type::isSubType(c->type, curr->type)) {
          if (canRemove(curr)) {
            replaceCurrent(getDroppedChildren(curr, c, wasm, options));
          } else {
            // We can't remove this, but we can at least put an unreachable
            // right after it.
            replaceCurrent(builder.makeSequence(builder.makeDrop(curr), c));
          }
          optimized = true;
        } else {
          // The type is not compatible: we cannot place |c| in this location,
          // even though we have proven it is the only value possible here.
          // That means no value is possible and this code is unreachable.
          // TODO add test
          replaceWithUnreachable();
        }
      }

      // TODO: if an instruction would trap on null, like struct.get, we could
      //       remove it here if it has no possible types. that information is
      //       present in OptimizeInstructions where it removes redundant
      //       ref.as_non_null, so maybe there is a way to share that

      void visitFunction(Function* func) {
        if (optimized) {
          // Optimization may introduce more unreachables, which we need to
          // propagate.
          ReFinalize().walkFunctionInModule(func, getModule());

          // We may add blocks around pops, which we must fix up.
          EHUtils::handleBlockNestedPops(func, *getModule());
        }
      }
    };

    Optimizer(oracle).run(runner, module);
  }
};

} // anonymous namespace

Pass* createGUFAPass() { return new GUFAPass(); }

} // namespace wasm
