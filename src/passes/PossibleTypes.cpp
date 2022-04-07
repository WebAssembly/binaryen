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
#include "ir/possible-types.h"
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

      void visitExpression(Expression* curr) {
//std::cout << "opt?\n" << *curr << "\n";
        auto type = curr->type;
        if (type.isNonNullable() &&
            oracle.getTypes(PossibleTypes::ExpressionLocation{curr}).empty()) {
//std::cout << "  opt!!!1\n";
          // This cannot contain a null, but also we have inferred that it
          // will never contain any type at all, which means that this code is
          // unreachable or will trap at runtime. Replace it with a trap.
          auto& wasm = *getModule();
          replaceCurrent(
            getDroppedChildren(curr, wasm, Builder(wasm).makeUnreachable()));
        }
      }
      // TODO: if an instruction would trap on null, like struct.get, we could
      //       remove it here if it has no possible types. that information is
      //       present in OptimizeInstructions where it removes redundant
      //       ref.as_non_null, so maybe there is a way to share that
    };

    Optimizer(oracle).run(runner, module);
  }
};

} // anonymous namespace

Pass* createPossibleTypesPass() { return new PossibleTypesPass(); }

} // namespace wasm
