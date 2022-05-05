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
      // observable behavior or breaking validation.
      bool canRemove(Expression* curr) {
        if (!canRemoveStructurally(curr)) {
          return false;
        }
        return !EffectAnalyzer(getPassOptions(), *getModule(), curr)
                  .hasUnremovableSideEffects();
      }

      // Whether we can replace something (but not its children, we can keep
      // then with drops) with an unreachable without changing observable
      // behavior or breaking validation.
      bool canReplaceWithUnreachable(Expression* curr) {
        if (!canRemoveStructurally(curr)) {
          return false;
        }
        EffectAnalyzer effects(getPassOptions(), *getModule(), curr);
        // Ignore a trap, as the unreachable replacement would trap too.
        effects.trap = false;
        return !effects.hasUnremovableSideEffects();
      }

      // Checks if the expression looks like it's already been optimized to a
      // particular value that we want to optimize it to. For example, if curr
      // is
      //
      //  (block
      //    ..
      //    (i32.const 20)
      //  )
      //
      // And the value we want to optimize to is (i32.const 20), the same value,
      // then there is no point to doing so - we'd be expanding code repeatedly
      // if run on the same module again and again. That can happen because in
      // general we may add such a block, so we need to look through a block
      // here to check if we already have the value.
      bool looksAlreadyOptimizedToValue(Expression* curr, Expression* value) {
        // The case that we do want to avoid here is if this looks like the
        // output of our optimization, which is (block .. (constant)), a block
        // ending in a constant and with no breaks to it. If this is already so
        // then do nothing (this avoids repeated runs of the pass monotonically
        // increasing code size for no benefit).
        if (auto* block = curr->dynCast<Block>()) {
          // If we got here, the list cannot be empty - an empty block is not
          // equivalent to any constant, so a logic error occurred before.
          assert(!block->list.empty());
          if (BranchUtils::BranchSeeker::has(block, block->name)) {
            // We never emit a branch in our blocks, so the presence of a branch
            // proves we have not already optimized here.
            return false;
          }

          // Look at the final value in the block.
          curr = block->list.back();
        }
        return ExpressionAnalyzer::equal(curr, value);
      }

      void visitExpression(Expression* curr) {
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

        if (type.isTuple()) {
          // TODO: tuple types.
          return;
        }

        if (type.isRef() && getTypeSystem() != TypeSystem::Nominal) {
          // Without nominal typing we skip analysis of subtyping, so we cannot
          // infer anything about refs.
          return;
        }

        // This is an interesting location that we might optimize. See what the
        // oracle says is possible there.
        auto contents = oracle.getContents(ExpressionLocation{curr, 0});

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

        if (contents.getType() == Type::unreachable) {
          // This cannot contain any possible value at all. It must be
          // unreachable code.
          replaceWithUnreachable();
          return;
        }

        // This is reachable. Check if we can emit something optimized for it.
        // TODO: can we handle more general things here too?
        if (!contents.canMakeExpression()) {
          return;
        }

        if (contents.isNull() && curr->type.isNullable()) {
          // Null values are all identical, so just fix up the type here, as
          // we can change the type to anything to fit the IR.
          //
          // Note that if curr's type is not nullable, then the code will trap
          // at runtime (the null must arrive through a cast that will trap).
          // We handle that below.
          //
          // TODO: would emitting a more specific null be useful when valid?
          contents = PossibleContents::literal(Literal::makeNull(curr->type));
        }

        auto* c = contents.makeExpression(wasm);
        if (looksAlreadyOptimizedToValue(curr, c)) {
          return;
        }

        // We can only place the constant value here if it has the right type.
        // For example, a block may return (ref any), that is, not allow a null,
        // but in practice only a null may flow there if it goes through casts
        // that will trap at runtime.
        if (Type::isSubType(c->type, curr->type)) {
          if (canRemove(curr)) {
            replaceCurrent(getDroppedChildren(curr, c, wasm, options));
          } else {
            // We can't remove this, but we can at least drop it and put the
            // optimized value right after it.
            replaceCurrent(builder.makeSequence(builder.makeDrop(curr), c));
          }
          optimized = true;
        } else {
          // The type is not compatible: we cannot place |c| in this location,
          // even though we have proven it is the only value possible here.
          if (Properties::isConstantExpression(c)) {
            // The type is not compatible and this is a simple constant
            // expression like a ref.func. That means this code must be
            // unreachable. (See below for the case of a non-constant.)
            replaceWithUnreachable();
          } else {
            // This is not a constant expression, but we are certain it is the
            // right value. Atm the only such case we handle is a global.get of
            // an immutable global. We don't know what the value will be, nor
            // its specific type, but we do know that a global.get will get that
            // value properly. However, in this case it does not have the right
            // type for this location. That can happen since the global.get does
            // not have exactly the proper type for the contents: the global.get
            // might be nullable, for example, even though the contents are not
            // actually a null. Consider what happens here:
            //
            //  (global $foo (ref null any) (struct.new $Foo))
            //  ..
            //    (ref.as_non_null
            //      (global.get $foo))
            //
            // We create a $Foo in the global $foo, so its value is not a null.
            // But the global's type is nullable, so the global.get's type will
            // be as well. When we get to the ref.as_non_null, we then want to
            // replace it with a global.get - in fact that's what its child
            // already is, showing it is the right content for it - but that
            // global.get would not have a non-nullable type like a
            // ref.as_non_null must have, so we cannot simply replace it.
            //
            // For now, do nothing here, but in some cases we could probably
            // optimize TODO
            assert(c->is<GlobalGet>());
          }
        }
      }

      // TODO: If an instruction would trap on null, like struct.get, we could
      //       remove it here if it has no possible contents. That information
      //       is present in OptimizeInstructions where it removes redundant
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
