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
// This uses the PossibleTypesOracle utility, and aside from the optimization
// benefits is also a good way to test that code (which is also used in other
// passes in more complex ways, or will be).
//

#include "ir/iteration.h"
#include "ir/possible-types.h"
#include "pass.h"
#include "wasm.h"

namespace wasm {

namespace {

struct PossibleTypes : public Pass {
  void run(PassRunner* runner, Module* module) override {
    PossibleTypesOracle oracle(*module);

    struct Optimizer : public WalkerPass<PostWalker<Optimizer, UnifiedExpressionVisitor<Optimizer>>> {
      bool isFunctionParallel() override { return true; }

      PossibleTypesOracle& oracle;

      Optimizer(PossibleTypesOracle& oracle) : oracle(oracle) {}

      Optimizer* create() override { return new Optimizer(oracle); }

      void visitExpression(Expression* curr) {
        auto type = curr->type;
        if (type.isNonNullable() && oracle.getTypes(ExpressionLocation{curr}).empty()) {
          // This cannot contain a null, but also we have inferred that it
          // will never contain any type at all, which means that this code is
          // unreachable or will trap at runtime. Replace it with a trap.
        }
      }
    };

    Optimizer(oracle).run(runner, module);
  }
};

} // anonymous namespace

Pass* createPossibleTypesPass() { return new PossibleTypes(); }

} // namespace wasm
