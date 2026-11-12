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
// nullable. This helps reduce code size by
// 1. Eliminating `ref.as_non_null`s - When --traps-never-happen, all
//    `ref.as_non_null`s can be eliminated, except on the boundary of things
//    that couldn't be relaxed e.g. imported function params. This is done
//    by --strip-refining-casts.
// 2. Allowing more locals to share a declaration group, since they can no
//    longer differ by nullability.
// 3. Exposing more opportunities for type merging by causing more function
//    signatures and struct/arrays to be identical.
//
// This pass does not strip redundant ref.as_non_nulls after definitions have
// been relaxed. Follow with --strip-refining-casts to do so.
//
// This pass strictly removes information so it should come near the end of
// Binaryen's pipeline.

#include <utility>
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

bool isSignatureRewritable(
  Function* func, const std::unordered_set<Function*>& referencedFuncs) {
  // The signatures of imported and exported functions aren't changed to
  // preserve the API boundary. Exported functions are implicitly 'referenced'
  // (i.e. they may be the target of a call_ref even if they never appear in a
  // ref.func), so no need to check that a second time.
  return !func->imported() && !referencedFuncs.contains(func);
}

[[nodiscard]] bool makeNullable(Type& t) {
  if (t.isNonNullableRef()) {
    t = t.with(Nullability::Nullable);
    return true;
  }

  return false;
}

void insertRefAsNonNull(Expression** curr, Builder& builder) {
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
    Builder builder(*module);
    insertRefAsNonNull(returnVal, builder);
  }
}

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
                         [&](Nullability nullability) {
                           // A polymorphic expression demanded a non-null. This
                           // can't actually happen today.
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

    Type getLabelType(Name) {
      // Labeled blocks are skipped. See `InsertRefAsNonNull::visitExpression`.
      WASM_UNREACHABLE("unexpected branch");
    }
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

// Pass implementing the bulk of function-parallel work after global rewrites
// are done.
struct LocalsToNullable : WalkerPass<PostWalker<LocalsToNullable>> {
  using Super = WalkerPass<PostWalker<LocalsToNullable>>;

  const std::unordered_set<Function*>& funcsWithRelaxedSignature;

  // true iff any expression types were changed.
  // false if only dead local definitions were changed.
  bool changed = false;

  // true iff the function's signature was relaxed before this pass ran, i.e. if
  // funcsWithRelaxedSignature contains the function.
  bool signatureWasRelaxed = false;

  LocalsToNullable(
    const std::unordered_set<Function*>& funcsWithRelaxedSignature)
    : funcsWithRelaxedSignature(funcsWithRelaxedSignature) {}

  std::unique_ptr<Pass> create() override {
    return std::make_unique<LocalsToNullable>(funcsWithRelaxedSignature);
  }

  bool isFunctionParallel() override { return true; }

  bool runsOnFunction(Function* func) const override {
    return func->vars.size() > 0 || funcsWithRelaxedSignature.contains(func);
  }

  // 1. Make all local definitions nullable and update gets and sets.
  // 2. Refinalize to fixup block types
  // 3. Insert ref.as_non_null where a parent demands it, e.g. return values,
  //    calls to unrelaxed imports, unrelaxed struct.set.
  //
  // Refinalize is not needed after step 3 because a block never demands a
  // non-null and thus step 3 makes no difference to block types.
  void doWalkFunction(Function* func) {
    signatureWasRelaxed = funcsWithRelaxedSignature.contains(func);

    bool changedLocals = false;
    for (Index i = 0; i < func->vars.size(); ++i) {
      changedLocals |= makeNullable(func->vars[i]);
    }
    if (!changedLocals && !signatureWasRelaxed) {
      return;
    }

    Super::doWalkFunction(func);

    if (!changed) {
      return;
    }
    ReFinalize().walkFunctionInModule(func, getModule());
    InsertRefAsNonNull(*getModule(), func)
      .walkFunctionInModule(func, getModule());
    fixupReturn(&func->body, getModule(), func);
  }

  void visitLocalGet(LocalGet* curr) {
    if (!signatureWasRelaxed && getFunction()->isParam(curr->index)) {
      return;
    }

    changed |= makeNullable(curr->type);
  }

  void visitLocalSet(LocalSet* curr) {
    if (!signatureWasRelaxed && getFunction()->isParam(curr->index)) {
      return;
    }

    if (curr->isTee()) {
      changed |= makeNullable(curr->type);
    }
  }
};

struct RelaxNullability : Pass {
  bool requiresNonNullableLocalFixups() override { return false; }

  void run(Module* module) override {
    auto relaxedFuncs = relaxFunctionParams(module);

    PassRunner runner(getPassRunner());
    runner.add(std::make_unique<LocalsToNullable>(relaxedFuncs));
    runner.run();
  }

private:
  // Returns the set of functions that had their signatures changed.
  std::unordered_set<Function*> relaxFunctionParams(Module* module) {
    auto referencedFuncs = ModuleUtils::getReferencedFuncs(*module);

    std::unordered_set<Function*> relaxedFuncs;
    for (auto& func : module->functions) {
      if (!isSignatureRewritable(func.get(), referencedFuncs)) {
        continue;
      }

      std::vector<Type> relaxedParams;
      bool changed = false;
      for (Type t : func->getParams()) {
        changed |= makeNullable(t);
        relaxedParams.push_back(t);
      }

      if (changed) {
        relaxedFuncs.insert(func.get());
        func->setParams(std::move(relaxedParams));
      }
    }

    return relaxedFuncs;
  }
};

} // anonymous namespace

Pass* createRelaxNullabilityPass() { return new RelaxNullability(); }

} // namespace wasm
