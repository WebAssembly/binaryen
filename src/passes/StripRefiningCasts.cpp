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
// Removes casts (ref.cast and ref.as_non_null) on values that flow into a slot
// whose declared type the uncast value already satisfies. For example:
//
//  (func $callee (param $s (ref $Super)) ..)
//  ..
//  (call $callee
//    (ref.cast (ref $Sub) (local.get $x)) ;; $x is (ref $Super)
//  )
//
// The cast is not needed for validation, and in traps-never-happen mode it can
// be assumed to succeed, so it can be removed:
//
//  (call $callee
//    (local.get $x)
//  )
//
// All value-flowing slots discovered by SubtypingDiscoverer (locals, globals,
// call parameters, function results, struct fields, array elements, control
// flow branches and fallthroughs, etc.) are handled. Casts on the input of a
// ref.test whose outcome is not determined by the input's type are removed as
// well, as they do not affect the result.
//
// Unlike the cast removals done in OptimizeInstructions, which never lose type
// information, the casts removed here may narrow the value beyond the slot
// type. That narrower type is information that refining passes (GUFA,
// signature-refining, type-refining, local-subtyping, etc.) could use to refine
// the slot itself, so this pass is meant to run late in the pipeline, after
// those passes had their chance. It should still be followed by a round of
// general optimizations, as removing the casts can make functions identical
// (helping duplicate-function-elimination) or smaller (helping inlining).
//
// Requires traps-never-happen mode, as removing a cast removes a possible trap.
//

#include <unordered_map>

#include "ir/effects.h"
#include "ir/gc-type-utils.h"
#include "ir/intrinsics.h"
#include "ir/subtype-exprs.h"
#include "pass.h"
#include "passes/passes.h"
#include "wasm-traversal.h"
#include "wasm.h"

namespace wasm {

namespace {

struct StripRefiningCasts
  : public WalkerPass<
      ControlFlowWalker<StripRefiningCasts,
                        SubtypingDiscoverer<StripRefiningCasts>>> {
  using Super =
    WalkerPass<ControlFlowWalker<StripRefiningCasts,
                                 SubtypingDiscoverer<StripRefiningCasts>>>;

  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<StripRefiningCasts>();
  }

  void runOnFunction(Module* module, Function* func) override {
    if (getPassOptions().trapsNeverHappen) {
      Super::runOnFunction(module, func);
    }
  }

  // Map from expression slot to the greatest lower bound of all types it must
  // be a subtype of (e.g. a switch value must be a subtype of all its targets).
  std::unordered_map<Expression**, Type> requiredTypes;

  void noteSubtype(Type, Type) {}
  void noteSubtype(HeapType, HeapType) {}
  void noteSubtype(Type, Expression*) {}
  void noteSubtype(Expression*& sub, Type super) {
    auto [it, inserted] = requiredTypes.insert({&sub, super});
    if (!inserted) {
      it->second = Type::getGreatestLowerBound(it->second, super);
    }
  }
  void noteSubtype(Expression*& sub, Expression* super) {
    noteSubtype(sub, super->type);
  }
  void noteNonFlowSubtype(Expression*, Type) {}
  void noteCast(HeapType, Type) {}
  void noteCast(Expression*, Type) {}
  void noteCast(Expression*, Expression*) {}

  // Skips casts on |input| while the uncast value is a subtype of |slotType|.
  void skipCasts(Expression*& input, Type slotType) {
    if (!slotType.isRef() || input->type == Type::unreachable) {
      return;
    }
    while (1) {
      if (auto* as = input->dynCast<RefAs>()) {
        if (as->op == RefAsNonNull &&
            Type::isSubType(as->value->type, slotType)) {
          input = as->value;
          continue;
        }
      } else if (auto* cast = input->dynCast<RefCast>()) {
        // Removing a descriptor cast also removes the descriptor operand, which
        // we can only do if it has no side effects.
        if ((!cast->desc ||
             !EffectAnalyzer(getPassOptions(), *getModule(), cast->desc)
                .hasSideEffects()) &&
            Type::isSubType(cast->ref->type, slotType)) {
          input = cast->ref;
          continue;
        }
      }
      break;
    }
  }

  void visitCall(Call* curr) {
    // call.without.effects operands must also satisfy the signature of the
    // target function operand, not just the import's declared signature.
    if (Intrinsics(*getModule()).isCallWithoutEffects(curr)) {
      return;
    }
    Super::visitCall(curr);
  }

  void visitRefTest(RefTest* curr) {
    // If the type of the input determines the outcome, leave the test to
    // OptimizeInstructions, which will use that type to resolve it.
    // (This also leaves exact tests alone when custom descriptors are disabled,
    // as those are then only valid on inputs of the same exact type, which
    // determines the outcome.)
    if (GCTypeUtils::evaluateCastCheck(curr->ref->type, curr->castType) !=
        GCTypeUtils::Unknown) {
      return;
    }
    // Any input in the hierarchy of the cast type is valid. Nullability does
    // not matter either: a removed cast is assumed to succeed, so it only ever
    // passes its input through unchanged.
    noteSubtype(curr->ref,
                Type(curr->castType.getHeapType().getTop(), Nullable));
  }

  void visitFunction(Function* func) {
    Super::visitFunction(func);
    for (auto& [slot, type] : requiredTypes) {
      skipCasts(*slot, type);
    }
    requiredTypes.clear();
  }
};

} // anonymous namespace

Pass* createStripRefiningCastsPass() { return new StripRefiningCasts(); }

} // namespace wasm
