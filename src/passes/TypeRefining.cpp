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
// TODO: handle arrays and not just structs.
//
// The GUFA variant of this uses GUFA to infer types, which performs a (slow)
// whole-program inference, rather than just scan struct/array operations by
// themselves.
//

#include "ir/find_all.h"
#include "ir/lubs.h"
#include "ir/possible-contents.h"
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
    if (index == StructUtils::DescriptorIndex) {
      // We cannot continue on below, where we index into the vector of values.
      return;
    }

    auto noted = expr->type;
    // Do not introduce new exact fields that might requires invalid
    // casts. Keep any existing exact fields, though.
    if (type.getStruct().fields[index].type.isInexact()) {
      noted = noted.withInexactIfNoCustomDescs(getModule()->features);
    }
    info.note(noted);
  }

  void
  noteDefault(Type fieldType, HeapType type, Index index, FieldInfo& info) {
    // Default values must be noted, so that we know there is content there.
    if (fieldType.isRef()) {
      // All we need to note here is nullability (the field must remain
      // nullable), but not anything else about the type.
      fieldType = Type(fieldType.getHeapType().getBottom(), Nullable);
    }
    info.note(fieldType);
  }

  void noteCopy(HeapType type, Index index, FieldInfo& info) {
    // Copies do not add any type requirements at all: the type will always be
    // read and written to a place with the same type.
  }

  void noteRead(HeapType type, Index index, FieldInfo& info) {
    // Nothing to do for a read, we just care about written values.
  }

  void noteRMW(Expression* expr, HeapType type, Index index, FieldInfo& info) {
    // We must not refine past the RMW value type.
    info.note(expr->type);
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

  bool gufa;

  TypeRefining(bool gufa) : gufa(gufa) {}

  // The final information we inferred about struct usage, that we then use to
  // optimize.
  StructUtils::StructValuesMap<FieldInfo> finalInfos;

  using Propagator = StructUtils::TypeHierarchyPropagator<FieldInfo>;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "TypeRefining requires --closed-world";
    }

    Propagator propagator(*module);

    // Compute our main data structure, finalInfos, either normally or using
    // GUFA.
    if (!gufa) {
      computeFinalInfos(module, propagator);
    } else {
      computeFinalInfosGUFA(module, propagator);
    }

    useFinalInfos(module, propagator);
  }

  void computeFinalInfos(Module* module, Propagator& propagator) {
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
    propagator.propagateToSuperTypes(combinedNewInfos);
    propagator.propagateToSuperAndSubTypes(combinedSetGetInfos);

    // Combine everything together.
    combinedNewInfos.combineInto(finalInfos);
    combinedSetGetInfos.combineInto(finalInfos);
  }

  void computeFinalInfosGUFA(Module* module, Propagator& propagator) {
    // Compute the oracle, then simply apply it.
    // TODO: Consider doing this in GUFA.cpp, where we already computed the
    //       oracle. That would require refactoring out the rest of this pass to
    //       a shared location. Alternatively, perhaps we can reuse the computed
    //       oracle, but any pass that changes anything would need to invalidate
    //       it...
    ContentOracle oracle(*module, getPassOptions());
    auto allTypes = ModuleUtils::collectHeapTypes(*module);
    for (auto type : allTypes) {
      if (type.isStruct()) {
        auto& fields = type.getStruct().fields;
        // Update the inexact entry because that's what we will query later.
        auto& infos = finalInfos[{type, Inexact}];
        for (Index i = 0; i < fields.size(); i++) {
          auto gufaType = oracle.getContents(DataLocation{type, i}).getType();
          // Do not introduce new exact fields that might requires invalid
          // casts. Keep any existing exact fields, though.
          if (!fields[i].type.isExact()) {
            gufaType = gufaType.withInexactIfNoCustomDescs(module->features);
          }
          infos[i] = LUBFinder(gufaType);
        }
      }
    }

    // Take into account possible problems. This pass only refines struct
    // fields, and when we refine in a way that exceeds the wasm type system
    // then we fix that up with a cast (see below). However, we cannot use casts
    // in all places, specifically in globals, so we must account for that.
    for (auto& global : module->globals) {
      if (global->imported()) {
        continue;
      }

      // Find StructNews, which are the one thing that can appear in a global
      // init that is affected by our optimizations.
      for (auto* structNew : FindAll<StructNew>(global->init).list) {
        if (structNew->isWithDefault()) {
          continue;
        }

        auto type = structNew->type.getHeapType();
        auto& infos = finalInfos[{type, Inexact}];
        auto& fields = type.getStruct().fields;
        for (Index i = 0; i < fields.size(); i++) {
          // We are in a situation like this:
          //
          //  (struct.new $A
          //   (global.get or such
          //
          // To avoid ending up requiring a cast later, the type of our child
          // must fit perfectly in the field it is written to.
          auto childType = structNew->operands[i]->type;
          infos[i].note(childType);
        }
      }
    }

    // Propagate to supertypes, so no field is less refined than its super.
    propagator.propagateToSuperTypes(finalInfos);
  }

  void useFinalInfos(Module* module, Propagator& propagator) {
    // While we do the following work, see if we have anything to optimize, so
    // that we can avoid wasteful work later if not.
    bool canOptimize = false;

    // We cannot modify public types.
    auto publicTypes = ModuleUtils::getPublicHeapTypes(*module);
    std::unordered_set<HeapType> publicTypesSet(publicTypes.begin(),
                                                publicTypes.end());

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

      for (auto subType : subTypes.getImmediateSubTypes(type)) {
        work.push(subType);
      }

      if (publicTypesSet.count(type)) {
        continue;
      }

      // First, find fields that have nothing written to them at all, and set
      // their value to their old type. We must pick some type for the field,
      // and we have nothing better to go on. (If we have a super, and it does
      // have writes, then we may further update this type later, see the
      // isSubType check in the loop after this.)
      auto& fields = type.getStruct().fields;
      for (Index i = 0; i < fields.size(); i++) {
        auto oldType = fields[i].type;
        // Use inexact because exact info will have been propagated up to
        // inexact entries but not necessarily vice versa.
        auto& info = finalInfos[{type, Inexact}][i];
        if (!info.noted()) {
          info = LUBFinder(oldType);
        }
      }

      // Next ensure proper subtyping of this struct's fields versus its super.
      if (auto super = type.getDeclaredSuperType()) {
        auto& superFields = super->getStruct().fields;
        for (Index i = 0; i < superFields.size(); i++) {
          // The super's new type is either what we propagated, or, if it is
          // public, unchanged since we cannot optimize it
          Type newSuperType;
          if (!publicTypesSet.count(*super)) {
            newSuperType = finalInfos[{*super, Inexact}][i].getLUB();
          } else {
            newSuperType = superFields[i].type;
          }
          auto& info = finalInfos[{type, Inexact}][i];
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
        auto& lub = finalInfos[{type, Inexact}][i];
        auto newType = lub.getLUB();
        if (newType != oldType) {
          canOptimize = true;
        }
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

        Type newFieldType;
        if (!curr->ref->type.isNull()) {
          auto oldType = curr->ref->type.getHeapType();
          newFieldType =
            parent.finalInfos[{oldType, Inexact}][curr->index].getLUB();
        }

        if (curr->ref->type.isNull() || newFieldType == Type::unreachable ||
            !Type::isSubType(newFieldType, curr->type)) {
          // This get will trap, or cannot be reached: either the ref is null,
          // or the field is never written any contents, or the contents we see
          // are invalid (they passed through some fallthrough that will trap at
          // runtime). Emit unreachable code here.
          Builder builder(*getModule());
          replaceCurrent(builder.makeSequence(builder.makeDrop(curr->ref),
                                              builder.makeUnreachable()));
          return;
        }

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
          auto newType =
            parent.finalInfos[{oldStructType, Inexact}][i].getLUB();
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

Pass* createTypeRefiningPass() { return new TypeRefining(false); }
Pass* createTypeRefiningGUFAPass() { return new TypeRefining(true); }

} // namespace wasm
