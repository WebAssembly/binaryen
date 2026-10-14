/*
 * Copyright 2025 WebAssembly Community Group participants
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
// Relaxes nullability for code size, assuming traps never happen.
//
// Non-nullable reference types carry a cost in the binary: every value that
// flows into a non-nullable parameter or local that is not already known to
// be non-null needs a ref.as_non_null, and locals that only differ in
// nullability cannot share a declaration group, while function types that only
// differ in parameter nullability cannot be merged. When traps never happen a
// ref.as_non_null can never fail, so it only serves the type system, and we
// are free to remove it wherever the consumer of its value accepts a nullable
// reference.
//
// This pass therefore
//
//  1. makes every non-nullable reference parameter of every private function
//     type nullable (results are unchanged, as callers often rely on them);
//  2. makes every reference local nullable; and
//  3. walks each function and, using the type constraints the parent imposes
//     on each child (ChildTyper), removes ref.as_non_null where the parent
//     accepts a nullable value and inserts one where the parent still demands
//     a non-nullable value (struct.new operands, calls to public functions,
//     returns, global.set, etc.).
//
// Public (exported/imported) function types, tag types and types with
// signature subtyping are left alone. The pass requires --traps-never-happen
// and does nothing without it. Follow it with --optimize-instructions and
// --coalesce-locals to fold the copies `tee $a (ref.as_non_null (get $b))`
// that become plain copies, and with --type-merging to merge the function
// types that now differ only in results.
//

#include <unordered_set>

#include "ir/child-typer.h"
#include "ir/find_all.h"
#include "ir/intrinsics.h"
#include "ir/module-utils.h"
#include "ir/properties.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

Type makeNullable(Type type) {
  if (type.isRef() && type.isNonNullable()) {
    return type.with(Nullable);
  }
  return type;
}

// Per-function fix-up: relax the vars, then remove or add ref.as_non_null
// according to what each parent demands of its children.
struct FunctionRelaxer
  : public WalkerPass<
      PostWalker<FunctionRelaxer, UnifiedExpressionVisitor<FunctionRelaxer>>> {
  bool isFunctionParallel() override { return true; }

  // We only make locals more nullable, which cannot break validation.
  bool requiresNonNullableLocalFixups() override { return false; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<FunctionRelaxer>();
  }

  void doWalkFunction(Function* func) {
    for (auto& var : func->vars) {
      var = makeNullable(var);
    }
    // local.get/local.tee types are tied to the local types (params may have
    // been relaxed by the signature update as well), and ReFinalize does not
    // update them.
    for (auto* get : FindAll<LocalGet>(func->body).list) {
      get->type = func->getLocalType(get->index);
    }
    for (auto* set : FindAll<LocalSet>(func->body).list) {
      if (set->isTee() && set->type != Type::unreachable) {
        set->type = func->getLocalType(set->index);
      }
    }
    // Propagate the new nullability through blocks, ifs, etc. so that the walk
    // below sees accurate types.
    ReFinalize().walkFunctionInModule(func, getModule());

    Super::doWalkFunction(func);

    // The implicit return.
    auto results = func->getResults();
    if (results.isRef() && results.isNonNullable() &&
        func->body->type.isRef() && func->body->type.isNullable()) {
      func->body = Builder(*getModule()).makeRefAs(RefAsNonNull, func->body);
    }
  }

  struct Typer : public ChildTyper<Typer> {
    FunctionRelaxer& parent;
    bool changed = false;

    Typer(FunctionRelaxer& parent)
      : ChildTyper(*parent.getModule(), parent.getFunction()), parent(parent) {}

    void note(Expression** childp, Constraints constraints) {
      if (constraints.size() != 1) {
        // TODO: tuples
        return;
      }
      auto* child = *childp;
      if (!child->type.isRef()) {
        return;
      }
      bool demandsNonNull = false;
      bool acceptsNull = false;
      auto& constraint = constraints[0];
      if (auto* type = std::get_if<Type>(&constraint)) {
        if (type->isRef()) {
          demandsNonNull = type->isNonNullable();
          acceptsNull = type->isNullable();
        }
      } else if (auto* ref = std::get_if<VarRef>(&constraint)) {
        if (auto* null = std::get_if<Nullability>(&ref->null)) {
          demandsNonNull = *null == NonNullable;
          acceptsNull = *null == Nullable;
        }
      }
      if (demandsNonNull) {
        if (child->type.isNullable()) {
          *childp = Builder(*parent.getModule()).makeRefAs(RefAsNonNull, child);
          changed = true;
        }
        return;
      }
      if (acceptsNull) {
        // Traps never happen, so a ref.as_non_null here only narrows the type,
        // which the parent does not need.
        while (auto* as = (*childp)->dynCast<RefAs>()) {
          if (as->op != RefAsNonNull) {
            break;
          }
          *childp = as->value;
          changed = true;
        }
      }
    }

    Type getLabelType(Name label) { WASM_UNREACHABLE("unexpected branch"); }

    void noteUnknown() {}
  };

  void visitExpression(Expression* curr) {
    // Control flow structures and branches just forward values; their types
    // follow from their children and are handled by refinalization.
    if (Properties::isControlFlowStructure(curr) ||
        Properties::isBranch(curr)) {
      return;
    }
    Typer typer(*this);
    typer.visit(curr);
    if (typer.changed) {
      ReFinalizeNode().visit(curr);
    }
  }
};

struct RelaxNullability : public Pass {
  // Signatures and locals change, and all casts are revisited.
  bool invalidatesDWARF() override { return true; }

  void run(Module* module) override {
    if (!getPassOptions().trapsNeverHappen) {
      // Without this assumption removing casts changes behavior.
      return;
    }

    // 1. Relax the parameters of private function types.
    std::unordered_set<HeapType> fixed;
    for (auto type :
         ModuleUtils::getPublicHeapTypes(*module, getPassOptions().worldMode)) {
      fixed.insert(type);
    }
    for (auto& tag : module->tags) {
      fixed.insert(tag->type);
    }
    for (auto func : Intrinsics(*module).getJSCalledFunctions()) {
      fixed.insert(module->getFunction(func)->type.getHeapType());
    }

    auto types = ModuleUtils::collectHeapTypes(*module);
    SubTypes subTypes(types);
    GlobalTypeRewriter::SignatureUpdates updates;
    for (auto type : types) {
      if (!type.isSignature() || fixed.count(type)) {
        continue;
      }
      // Keep it simple: do not touch types that take part in subtyping.
      if (type.getDeclaredSuperType() ||
          !subTypes.getImmediateSubTypes(type).empty()) {
        continue;
      }
      auto sig = type.getSignature();
      std::vector<Type> params;
      bool changed = false;
      for (auto param : sig.params) {
        auto relaxed = makeNullable(param);
        changed = changed || relaxed != param;
        params.push_back(relaxed);
      }
      if (changed) {
        updates[type] = Signature(Type(params), sig.results);
      }
    }
    GlobalTypeRewriter::updateSignatures(
      updates, *module, getPassOptions().worldMode);

    // 2 + 3. Relax locals and fix up casts in every function.
    FunctionRelaxer().run(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createRelaxNullabilityPass() { return new RelaxNullability(); }

} // namespace wasm
