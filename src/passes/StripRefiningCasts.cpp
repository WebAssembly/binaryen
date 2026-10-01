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
// The slots handled are locals, globals, call / call_ref / call_indirect
// parameters, function results, struct fields, array elements and select arms.
// Casts on the input of a ref.test whose outcome is not determined by the
// input's type are removed as well, as they do not affect the result.
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

#include "ir/gc-type-utils.h"
#include "ir/intrinsics.h"
#include "pass.h"
#include "passes/passes.h"
#include "wasm.h"

namespace wasm {

namespace {

struct StripRefiningCasts : public WalkerPass<PostWalker<StripRefiningCasts>> {
  bool isFunctionParallel() override { return true; }

  std::unique_ptr<Pass> create() override {
    return std::make_unique<StripRefiningCasts>();
  }

  void doWalkFunction(Function* func) {
    if (!getPassOptions().trapsNeverHappen) {
      return;
    }
    walk(func->body);
  }

  // Skips casts on |input| while the uncast value is a subtype of |slotType|.
  void skipCasts(Expression*& input, Type slotType) {
    while (1) {
      if (auto* as = input->dynCast<RefAs>()) {
        if (as->op == RefAsNonNull &&
            Type::isSubType(as->value->type, slotType)) {
          input = as->value;
          continue;
        }
      } else if (auto* cast = input->dynCast<RefCast>()) {
        // Removing a descriptor cast would also remove the descriptor operand,
        // along with its side effects.
        if (!cast->desc && Type::isSubType(cast->ref->type, slotType)) {
          input = cast->ref;
          continue;
        }
      }
      break;
    }
  }

  void skipCastsOnOperands(ExpressionList& operands, Type params) {
    if (params.size() != operands.size()) {
      return;
    }
    for (Index i = 0; i < operands.size(); ++i) {
      skipCasts(operands[i], params[i]);
    }
  }

  void visitLocalSet(LocalSet* curr) {
    // A tee's own type is the type of its value, so removing a cast from it
    // would change the tee's type.
    if (!curr->isTee()) {
      skipCasts(curr->value, getFunction()->getLocalType(curr->index));
    }
  }

  void visitGlobalSet(GlobalSet* curr) {
    skipCasts(curr->value, getModule()->getGlobal(curr->name)->type);
  }

  void visitCall(Call* curr) {
    if (Intrinsics(*getModule()).isCallWithoutEffects(curr)) {
      return;
    }
    skipCastsOnOperands(curr->operands,
                        getModule()->getFunction(curr->target)->getParams());
  }

  void visitCallRef(CallRef* curr) {
    if (curr->target->type.isSignature()) {
      skipCastsOnOperands(
        curr->operands, curr->target->type.getHeapType().getSignature().params);
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (curr->heapType.isSignature()) {
      skipCastsOnOperands(curr->operands, curr->heapType.getSignature().params);
    }
  }

  void visitReturn(Return* curr) {
    auto results = getFunction()->getResults();
    if (curr->value && results != Type::none && !results.isTuple()) {
      skipCasts(curr->value, results);
    }
  }

  void visitStructNew(StructNew* curr) {
    if (curr->type == Type::unreachable || curr->isWithDefault()) {
      return;
    }
    const auto& fields = curr->type.getHeapType().getStruct().fields;
    for (Index i = 0; i < fields.size(); i++) {
      skipCasts(curr->operands[i], fields[i].type);
    }
  }

  void visitStructSet(StructSet* curr) {
    if (auto field = GCTypeUtils::getField(curr->ref->type, curr->index)) {
      skipCasts(curr->value, field->type);
    }
  }

  void visitArrayNew(ArrayNew* curr) {
    if (curr->type == Type::unreachable || curr->isWithDefault()) {
      return;
    }
    skipCasts(curr->init, curr->type.getHeapType().getArray().element.type);
  }

  void visitArrayNewFixed(ArrayNewFixed* curr) {
    if (curr->type == Type::unreachable) {
      return;
    }
    auto elemType = curr->type.getHeapType().getArray().element.type;
    for (auto*& value : curr->values) {
      skipCasts(value, elemType);
    }
  }

  void visitArraySet(ArraySet* curr) {
    if (auto field = GCTypeUtils::getField(curr->ref->type)) {
      skipCasts(curr->value, field->type);
    }
  }

  void visitSelect(Select* curr) {
    skipCasts(curr->ifTrue, curr->type);
    skipCasts(curr->ifFalse, curr->type);
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
    skipCasts(curr->ref, Type(curr->castType.getHeapType().getTop(), Nullable));
  }
};

} // anonymous namespace

Pass* createStripRefiningCastsPass() { return new StripRefiningCasts(); }

} // namespace wasm
