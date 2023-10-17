/*
 * Copyright 2021 WebAssembly Community Group participants
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
// Apply more specific subtypes to type fields where possible, where all the
// writes to that field in the entire program allow doing so.
//

#include "ir/lubs.h"
#include "ir/struct-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/unique_deferring_queue.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

// We use a LUBFinder to track field info, which includes the best LUB possible
// as well as relevant nulls (nulls force us to keep the type nullable).
using FieldInfo = LUBFinder;

struct FieldInfoScanner
  : public StructUtils::StructScanner<FieldInfo, FieldInfoScanner> {
  std::unique_ptr<Pass> create() override {
    return std::make_unique<FieldInfoScanner>(functionNewInfos,
                                              functionSetGetInfos);
  }

  FieldInfoScanner(
    StructUtils::FunctionStructValuesMap<FieldInfo>& functionNewInfos,
    StructUtils::FunctionStructValuesMap<FieldInfo>& functionSetGetInfos)
    : StructUtils::StructScanner<FieldInfo, FieldInfoScanner>(
        functionNewInfos, functionSetGetInfos) {}

  void noteExpression(Expression* expr,
                      HeapType type,
                      Index index,
                      FieldInfo& info) {
    info.note(expr->type);
  }

  void
  noteDefault(Type fieldType, HeapType type, Index index, FieldInfo& info) {
    // Default values do not affect what the heap type of a field can be turned
    // into. Note them, however, as they force us to keep the type nullable.
    if (fieldType.isRef()) {
      info.note(Type(fieldType.getHeapType().getBottom(), Nullable));
    }
  }

  void noteCopy(HeapType type, Index index, FieldInfo& info) {
    // Copies do not add any type requirements at all: the type will always be
    // read and written to a place with the same type.
  }

  void noteRead(HeapType type, Index index, FieldInfo& info) {
    // Nothing to do for a read, we just care about written values.
  }

  Properties::FallthroughBehavior getFallthroughBehavior() {
    // Looking at fallthrough values may be dangerous here, because it ignores
    // intermediate steps. Consider this:
    //
    // (struct.set $T 0
    //   (local.tee
    //     (struct.get $T 0)))
    //
    // This is a copy of a field to itself - normally something we can ignore
    // (see above). But in this case, if we refine the field then that will
    // update the struct.get, but the local.tee will still have the old type,
    // which may not be refined enough. We could in theory always fix this up
    // using casts later, but those casts may be expensive (especially ref.casts
    // as opposed to ref.as_non_null), so for now just ignore tee fallthroughs.
    // TODO: investigate more
    return Properties::FallthroughBehavior::NoTeeBrIf;
  }
};

struct TypeRefining : public Pass {
  // Only affects GC type declarations and struct.gets.
  bool requiresNonNullableLocalFixups() override { return false; }

  StructUtils::StructValuesMap<FieldInfo> finalInfos;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "TypeRefining requires --closed-world";
    }

    // Find and analyze struct operations inside each function.
    StructUtils::FunctionStructValuesMap<FieldInfo> functionNewInfos(*module),
      functionSetGetInfos(*module);
    FieldInfoScanner scanner(functionNewInfos, functionSetGetInfos);
    scanner.run(getPassRunner(), module);
    scanner.runOnModuleCode(getPassRunner(), module);

    // Combine the data from the functions.
    StructUtils::StructValuesMap<FieldInfo> combinedNewInfos;
    StructUtils::StructValuesMap<FieldInfo> combinedSetGetInfos;
    functionNewInfos.combineInto(combinedNewInfos);
    functionSetGetInfos.combineInto(combinedSetGetInfos);

    // Propagate things written during new to supertypes, as they must also be
    // able to contain that type. Propagate things written using set to subtypes
    // as well, as the reference might be to a supertype if the field is present
    // there.
    StructUtils::TypeHierarchyPropagator<FieldInfo> propagator(*module);
    propagator.propagateToSuperTypes(combinedNewInfos);
    propagator.propagateToSuperAndSubTypes(combinedSetGetInfos);

    // Combine everything together.
    combinedNewInfos.combineInto(finalInfos);
    combinedSetGetInfos.combineInto(finalInfos);

    // While we do the following work, see if we have anything to optimize, so
    // that we can avoid wasteful work later if not.
    bool canOptimize = false;

    // We have combined all the information we have about writes to the fields,
    // but we still need to make sure that the new types makes sense. In
    // particular, subtyping cares about things like mutability, and we also
    // need to handle the case where we have no writes to a type but do have
    // them to subtypes or supertypes; in all these cases, we must preserve
    // that a field is always a subtype of the parent field. To do so, we go
    // through all the types downward from supertypes to subtypes, ensuring the
    // subtypes are suitable.
    auto& subTypes = propagator.subTypes;
    UniqueDeferredQueue<HeapType> work;
    for (auto type : subTypes.types) {
      if (type.isStruct() && !type.getDeclaredSuperType()) {
        work.push(type);
      }
    }
    while (!work.empty()) {
      auto type = work.pop();

      // First, find fields that have nothing written to them at all, and set
      // their value to their old type. We must pick some type for the field,
      // and we have nothing better to go on. (If we have a super, and it does
      // have writes, then we may further update this type later, see the
      // isSubType check in the loop after this.)
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        auto oldType = fields[i].type;
        auto& info = finalInfos[type][i];
        if (!info.noted()) {
          info = LUBFinder(oldType);
        }
      }

      // Next ensure proper subtyping of this struct's fields versus its super.
      if (auto super = type.getDeclaredSuperType()) {
        auto& superFields = super->getStruct().fields;
        for (Index i = 0; i < superFields.size(); i++) {
          auto newSuperType = finalInfos[*super][i].getLUB();
          auto& info = finalInfos[type][i];
          auto newType = info.getLUB();
          if (!Type::isSubType(newType, newSuperType)) {
            // To ensure we are a subtype of the super's field, simply copy that
            // value, which is more specific than us.
            //
            // This situation cannot happen normally, but if a type is not used
            // then it can. For example, imagine that $B and $C are subtypes of
            // $A, and that $C is never created anywhere. A struct.new of $B
            // propagates info to $A (forcing $A's type to take it into account
            // and not be more specific than it), but that does not reach $C
            // (struct.new propagates only up, not down; if it propagated down
            // then we could never specialize a subtype more than its super). If
            // $C had some value written to it then that value would force the
            // LUB of $A to take it into account, but as here $C is never even
            // created, that does not happen. And then if we update $A's type
            // to something more specific than $C's old type, we end up with the
            // problem that this code path fixes: we just need to get $C's type
            // to be identical to its super so that validation works.
            info = LUBFinder(newSuperType);
          } else if (fields[i].mutable_ == Mutable) {
            // Mutable fields must have identical types, so we cannot
            // specialize.
            // TODO: Perhaps we should be using a new Field::isSubType() method
            //       here? This entire analysis might be done on fields, and not
            //       types, which would also handle more things added to fields
            //       in the future.
            info = LUBFinder(newSuperType);
          }
        }
      }

      // After all those decisions, see if we found anything to optimize.
      for (Index i = 0; i < fields.size(); i++) {
        auto oldType = fields[i].type;
        auto& lub = finalInfos[type][i];
        auto newType = lub.getLUB();
        if (newType != oldType) {
          canOptimize = true;
        }
      }

      for (auto subType : subTypes.getImmediateSubTypes(type)) {
        work.push(subType);
      }
    }

    if (canOptimize) {
      updateInstructions(*module);
      updateTypes(*module);
    }
  }

  // If we change types then some instructions may need to be modified.
  // Specifically, we assume that reads from structs impose no constraints on
  // us, so that we can optimize maximally. If a struct is never created nor
  // written to, but only read from, then we have literally no constraints on it
  // at all, and we can end up with a situation where we alter the type to
  // something that is invalid for that read. To ensure the code still
  // validates, simply remove such reads.
  void updateInstructions(Module& wasm) {
    struct ReadUpdater : public WalkerPass<PostWalker<ReadUpdater>> {
      bool isFunctionParallel() override { return true; }

      // Only affects struct.gets.
      bool requiresNonNullableLocalFixups() override { return false; }

      TypeRefining& parent;

      ReadUpdater(TypeRefining& parent) : parent(parent) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<ReadUpdater>(parent);
      }

      void visitStructGet(StructGet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        if (curr->ref->type.isNull()) {
          // This get will trap. In theory we could leave this for later
          // optimizations to do, but we must actually handle it here, because
          // of the situation where this get's type is refined, and the input
          // type is the result of a refining:
          //
          //   (struct.get $A    ;; should be refined to something
          //     (struct.get $B  ;; just refined to nullref
          //
          // If the input has become a nullref then we can't just return out of
          // this function, as we'd be leaving a struct.get of $A with the
          // wrong type. But we can't find the right type since in Binaryen IR
          // we use the ref's type to see what is being read, and that just
          // turned into nullref. To avoid that corner case, just turn this code
          // into unreachable code now, and the later refinalize will turn all
          // the parents unreachable, avoiding any type-checking problems.
          Builder builder(*getModule());
          replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                              builder.makeUnreachable()));
          return;
        }

        auto oldType = curr->ref->type.getHeapType();
        auto newFieldType = parent.finalInfos[oldType][curr->index].getLUB();
        if (Type::isSubType(newFieldType, curr->type)) {
          // This is the normal situation, where the new type is a refinement of
          // the old type. Apply that type so that the type of the struct.get
          // matches what is in the refined field. ReFinalize will later
          // propagate this to parents.
          //
          // Note that ReFinalize will also apply the type of the field itself
          // to a struct.get, so our doing it here in this pass is usually
          // redundant. But ReFinalize also updates other types while doing so,
          // which can cause a problem:
          //
          //  (struct.get $A
          //    (block (result (ref null $A))
          //      (ref.null any)
          //    )
          //  )
          //
          // Here ReFinalize will turn the block's result into a bottom type,
          // which means it won't know a type for the struct.get at that point.
          // Doing it in this pass avoids that issue, as we have all the
          // necessary information. (ReFinalize will still get into the
          // situation where it doesn't know how to update the type of the
          // struct.get, but it will just leave the existing type - it assumes
          // no update is needed - which will be correct, since we've updated it
          // ourselves here, before.)
          curr->type = newFieldType;
        } else {
          // This instruction is invalid, so it must be the result of the
          // situation described above: we ignored the read during our
          // inference, and optimized accordingly, and so now we must remove it
          // to keep the module validating. It doesn't matter what we emit here,
          // since there are no struct.new or struct.sets for this type, so this
          // code is logically unreachable.
          //
          // Note that we emit an unreachable here, which changes the type, and
          // so we should refinalize. However, we will be refinalizing later
          // anyhow in updateTypes, so there is no need.
          Builder builder(*getModule());
          replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                              builder.makeUnreachable()));
        }
      }
    };

    ReadUpdater updater(*this);
    updater.run(getPassRunner(), &wasm);
    updater.runOnModuleCode(getPassRunner(), &wasm);
  }

  void updateTypes(Module& wasm) {
    class TypeRewriter : public GlobalTypeRewriter {
      TypeRefining& parent;

    public:
      TypeRewriter(Module& wasm, TypeRefining& parent)
        : GlobalTypeRewriter(wasm), parent(parent) {}

      void modifyStruct(HeapType oldStructType, Struct& struct_) override {
        const auto& oldFields = oldStructType.getStruct().fields;
        auto& newFields = struct_.fields;

        for (Index i = 0; i < newFields.size(); i++) {
          auto oldType = oldFields[i].type;
          if (!oldType.isRef()) {
            continue;
          }
          auto newType = parent.finalInfos[oldStructType][i].getLUB();
          newFields[i].type = getTempType(newType);
        }
      }
    };

    TypeRewriter(wasm, *this).update();

    ReFinalize().run(getPassRunner(), &wasm);

    // After refinalizing, we may still have situations that do not validate.
    // In some cases we can infer something more precise than can be represented
    // in wasm, like here:
    //
    //  (try (result A)
    //    (struct.get ..) ;; returns B.
    //  (catch
    //    (const A)
    //  )
    //
    // The try body cannot throw, so the catch is never reached, and we can
    // infer the fallthrough has the subtype B. But in wasm the type of the try
    // must remain the supertype A. If that try is written into a StructSet that
    // we refined, that will error.
    //
    // To fix this, we add a cast here, and expect that other passes will remove
    // the cast after other optimizations simplify things (in this example, the
    // catch can be removed).
    struct WriteUpdater : public WalkerPass<PostWalker<WriteUpdater>> {
      bool isFunctionParallel() override { return true; }

      // Only affects struct.new/sets.
      bool requiresNonNullableLocalFixups() override { return false; }

      std::unique_ptr<Pass> create() override {
        return std::make_unique<WriteUpdater>();
      }

      void visitStructNew(StructNew* curr) {
        if (curr->type == Type::unreachable || curr->isWithDefault()) {
          return;
        }

        auto& fields = curr->type.getHeapType().getStruct().fields;

        for (Index i = 0; i < fields.size(); i++) {
          auto*& operand = curr->operands[i];
          auto fieldType = fields[i].type;
          if (!Type::isSubType(operand->type, fieldType)) {
            operand = Builder(*getModule()).makeRefCast(operand, fieldType);
          }
        }
      }

      void visitStructSet(StructSet* curr) {
        if (curr->type == Type::unreachable) {
          // Ignore unreachable code.
          return;
        }
        auto type = curr->ref->type.getHeapType();
        if (type.isBottom()) {
          // Ignore a bottom type.
          return;
        }

        auto fieldType = type.getStruct().fields[curr->index].type;

        if (!Type::isSubType(curr->value->type, fieldType)) {
          curr->value =
            Builder(*getModule()).makeRefCast(curr->value, fieldType);
        }
      }
    };

    WriteUpdater updater;
    updater.run(getPassRunner(), &wasm);
    updater.runOnModuleCode(getPassRunner(), &wasm);
  }
};

} // anonymous namespace

Pass* createTypeRefiningPass() { return new TypeRefining(); }

} // namespace wasm
