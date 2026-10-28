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

// Unconditionally make all ref params, locals, and struct fields (todo)
// nullable when --traps-never-happen is enabled. This helps reduce code size
// by
// 1. Eliminating `ref.as_non_null`s - All `ref.as_non_null`s can be eliminated,
//    except on the boundary of things that couldn't be relaxed e.g.
//    imported function params.
// 2. Allowing more locals to share a declaration group, since they can no
//    longer differ by nullability.
//
// It may also improve type merging by causing more function signatures to be
// identical.
//
// This pass does not strip redundant ref.as_non_nulls after definitions have
// been relaxed. Follow with --strip-refinining-casts to do so.
//
// This pass strictly removes information so it should come near the end of
// Binaryen's pipeline.

#include <variant>

#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

#include "ir/child-typer.h"
#include "ir/find_all.h"
#include "ir/module-utils.h"
#include "ir/utils.h"

namespace wasm {

namespace {

bool isRelaxable(Function* func,
                 const std::unordered_set<Function*>& referencedFuncs) {
  // The signatures of imported and exported functions aren't changed to
  // preserve the API boundary. Exported functions are implicitly 'referenced'
  // (i.e. they may be the target of a call_ref even if they never appear in a
  // ref.func), so no need to check that a second time.
  //
  // TODO: Relax private referenced funcs + bodies of public referenced funcs.
  return !func->imported() && !referencedFuncs.contains(func);
}

std::pair<bool, Type> toNullable(Type t) {
  if (t.isNonNullableRef()) {
    return {true, t.with(Nullability::Nullable)};
  } else {
    return {false, t};
  }
}

void insertRefAsNonNull(Expression** curr, Builder builder) {
  // unreachable also doesn't need a change
  if (!(*curr)->type.isNullableRef()) {
    return;
  }
  *curr = builder.makeRefAs(RefAsOp::RefAsNonNull, *curr);
}

void fixupReturn(Expression** returnVal, Module* module, Function* func) {
  auto results = func->getResults();
  if (results.size() > 1) {
    Fatal() << "TODO: Tuples not supported yet";
    return;
  }
  if (results.size() == 1 && results[0].isNonNullableRef()) {
    insertRefAsNonNull(returnVal, Builder(*module));
  }
}

struct LocalsToNullable : PostWalker<LocalsToNullable> {
  // true iff any expression types were changed.
  // false if only dead local definitions were changed.
  bool changed = false;

  void doWalkFunction(Function* func) {
    for (Index i = 0; i < func->vars.size(); ++i) {
      auto [_, nullable] = toNullable(func->vars[i]);
      func->vars[i] = nullable;
    }

    // TODO: could consider doing this only if locals changed
    // but a function param could have changed and we can't tell that easily
    // from here.
    PostWalker<LocalsToNullable>::doWalkFunction(func);
  }

  void visitLocalGet(LocalGet* curr) {
    auto [changed, nullable] = toNullable(curr->type);
    curr->type = nullable;
    this->changed |= changed;
  }

  void visitLocalSet(LocalSet* curr) {
    if (curr->isTee()) {
      auto [changed, nullable] = toNullable(curr->type);
      curr->type = nullable;
      this->changed |= changed;
    }
  }
};

struct InsertRefAsNonNull
  : PostWalker<InsertRefAsNonNull,
               UnifiedExpressionVisitor<InsertRefAsNonNull>> {
  struct Typer : ChildTyper<Typer> {
    Typer(Module& module, Function* func) : ChildTyper(module, func) {}

    void note(Expression** currp, Constraints constraints) {
      if (constraints.size() > 1) {
        Fatal() << "TODO: Tuples not supported yet";
        return;
      }

      std::visit(
        overloaded{
          [&](const Type& type) {
            if (type.isNonNullableRef() && (*currp)->type.isNullableRef()) {
              *currp = Builder(wasm).makeRefAs(RefAsOp::RefAsNonNull, *currp);
            }
          },
          [](Index) { /* no nullability constraint */ },
          [&](const VarRef& var) {
            std::visit(overloaded{
                         [](Index) { /* no nullability constraint */ },
                         // A polymorphic expression demanded a non-null. This
                         // can't actually happen today.
                         [&](Nullability nullability) {
                           if (nullability == Nullability::NonNullable) {
                             *currp = Builder(wasm).makeRefAs(
                               RefAsOp::RefAsNonNull, *currp);
                           }
                         },
                       },
                       var.null);
          }},
        constraints[0]);
    }

    void noteUnknown() {
      // This is an unreachable with a type immediate e.g. struct.set.
      // In this case we don't need to insert any ref.as_non_null.
    }

    Type getLabelType(Name) { WASM_UNREACHABLE("unexpected branch"); }
  } typer;

  InsertRefAsNonNull(Module& module, Function* func) : typer(module, func) {}

  void visitExpression(Expression* curr) {
    // Types for labeled blocks will be handled by ReFinalize. Skip these
    // so we don't need to implement `getLabelType`.
    if (Properties::isBranch(curr) ||
        Properties::isControlFlowStructure(curr)) {
      return;
    }

    typer.visit(curr);
  }
};

struct Runner : Pass {
  const std::unordered_set<Function*>& referencedFuncs;

  Runner(const std::unordered_set<Function*>& referencedFuncs)
    : referencedFuncs(referencedFuncs) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<Runner>(*this);
  }

  bool isFunctionParallel() override { return true; }

  bool runsOnFunction(Function* func) override {
    return isRelaxable(func, referencedFuncs);
  }

  void runOnFunction(Module* module, Function* func) override {
    // 1. Make all local definitions nullable and update gets and sets.
    // 2. Refinalize to fixup block types
    // 3. Insert ref.as_non_null where a parent demands it, e.g. return values,
    //    calls to unrelaxed imports, unrelaxed struct.set.
    //
    // Refinalize is not needed after step 3 because a block never demands a
    // non-null and thus step 3 makes no difference to block types.
    LocalsToNullable localsToNullable;
    localsToNullable.walkFunction(func);

    if (!localsToNullable.changed) {
      return;
    }

    ReFinalize().walkFunctionInModule(func, module);
    InsertRefAsNonNull(*module, func).walkFunctionInModule(func, module);
    fixupReturn(&func->body, module, func);
  }
};

struct RelaxNullability : Pass {
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    auto referencedFuncs = ModuleUtils::getReferencedFuncs(*module);
    relaxFunctionParams(module, referencedFuncs);

    PassRunner runner(module);
    runner.add(std::make_unique<Runner>(referencedFuncs));
    runner.run();
  }

private:
  void
  relaxFunctionParams(Module* module,
                      const std::unordered_set<Function*>& referencedFuncs) {
    for (auto& func : module->functions) {
      if (!isRelaxable(func.get(), referencedFuncs)) {
        continue;
      }

      std::vector<Type> relaxedParams;
      for (Type t : func->getParams()) {
        auto [_, nullable] = toNullable(t);
        relaxedParams.push_back(nullable);
      }
      func->setParams(std::move(relaxedParams));
    }
  }
};

} // anonymous namespace

Pass* createRelaxNullabilityPass() { return new RelaxNullability(); }

} // namespace wasm
