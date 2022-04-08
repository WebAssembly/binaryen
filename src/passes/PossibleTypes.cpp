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
// Optimize based on information about which types can appear in each location
// in the program. This does a whole-program analysis to find that out and
// hopefully learn more than the type system does - for example, a type might be
// $A, which means $A or any subtype can appear there, but perhaps the analysis
// can find that only $A', a particular subtype, can appear there in practice,
// and not $A or any subtypes of $A', etc. Or, we may find that no type is
// actually possible at a particular location, say if we can prove that the
// casts on the way to that location allow nothing through.
//
// This uses the PossibleTypes::Oracle utility, and aside from the optimization
// benefits is also a good way to test that code (which is also used in other
// passes in more complex ways, or will be).
//

#include "ir/drop.h"
#include "ir/eh-utils.h"
#include "ir/possible-types.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

struct PossibleTypesPass : public Pass {
  void run(PassRunner* runner, Module* module) override {
    PossibleTypes::Oracle oracle(*module);

    struct Optimizer
      : public WalkerPass<
          PostWalker<Optimizer, UnifiedExpressionVisitor<Optimizer>>> {
      bool isFunctionParallel() override { return true; }

      PossibleTypes::Oracle& oracle;

      Optimizer(PossibleTypes::Oracle& oracle) : oracle(oracle) {}

      Optimizer* create() override { return new Optimizer(oracle); }

      bool optimized = false;

      // TODO move this into drops.h, a single function that is told "this is
      // not actually needed; remove it as best you can"
      bool canRemove(Expression* curr) {
        // We can remove almost anything, but not a branch target, as we still
        // need the target for the branches to it to validate.
        if (BranchUtils::getDefinedName(curr).is()) {
          return false;
        }
        return true;
      }

      void visitExpression(Expression* curr) {
        auto type = curr->type;
        if (type.isNonNullable() &&
            oracle.getTypes(PossibleTypes::ExpressionLocation{curr}).empty()) {
          // This cannot contain a null, but also we have inferred that it
          // will never contain any type at all, which means that this code is
          // unreachable or will trap at runtime. Replace it with a trap.
          auto& wasm = *getModule();
          Builder builder(wasm);
          if (canRemove(curr)) {
            replaceCurrent(
              getDroppedChildren(curr, wasm, builder.makeUnreachable()));
          } else {
            // We can't remove this, but we can at least put an unreachable
            // right after it.
            replaceCurrent(builder.makeSequence(builder.makeDrop(curr), builder.makeUnreachable()));            
          }
          optimized = true;
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

Pass* createPossibleTypesPass() { return new PossibleTypesPass(); }

} // namespace wasm
