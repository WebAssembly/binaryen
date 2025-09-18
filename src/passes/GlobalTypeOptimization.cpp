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
// Optimize types at the global level, altering fields etc. on the set of heap
// types defined in the module.
//
//  * Immutability: If a field has no struct.set, it can become immutable.
//  * Fields that are never read from can be removed entirely.
//

#include "ir/eh-utils.h"
#include "ir/localize.h"
#include "ir/module-utils.h"
#include "ir/names.h"
#include "ir/ordering.h"
#include "ir/struct-utils.h"
#include "ir/subtypes.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "support/insert_ordered.h"
#include "support/permutations.h"
#include "wasm-type-ordering.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

namespace {

// Information about usage of a field.
struct FieldInfo {
  // This represents a normal write for normal fields. For a descriptor, we only
  // note "dangerous" writes, specifically ones which might trap (when the
  // descriptor in a struct.new is nullable), which is a special situation we
  // must avoid.
  bool hasWrite = false;
  bool hasRead = false;

  void noteWrite() { hasWrite = true; }
  void noteRead() { hasRead = true; }

  bool combine(const FieldInfo& other) {
    bool changed = false;
    if (!hasWrite && other.hasWrite) {
      hasWrite = true;
      changed = true;
    }
    if (!hasRead && other.hasRead) {
      hasRead = true;
      changed = true;
    }
    return changed;
  }

  void dump(std::ostream& o) {
    o << "[write: " << hasWrite << " hasRead: " << hasRead << ']';
  }
};

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
    if (index == StructUtils::DescriptorIndex && expr->type.isNonNullable()) {
      // A non-dangerous write to a descriptor, which as mentioned above, we do
      // not track.
      return;
    }
    info.noteWrite();
  }

  void
  noteDefault(Type fieldType, HeapType type, Index index, FieldInfo& info) {
    info.noteWrite();
  }

  void noteCopy(HeapType type, Index index, FieldInfo& info) {
    info.noteWrite();
  }

  void noteRead(HeapType type, Index index, FieldInfo& info) {
    info.noteRead();
  }

  void noteRMW(Expression* expr, HeapType type, Index index, FieldInfo& info) {
    info.noteRead();
    info.noteWrite();
  }
};

struct GlobalTypeOptimization : public Pass {
  StructUtils::StructValuesMap<FieldInfo> combinedSetGetInfos;

  // Maps types to a vector of booleans that indicate whether a field can
  // become immutable. To avoid eager allocation of memory, the vectors are
  // only resized when we actually have a true to place in them (which is
  // rare).
  std::unordered_map<HeapType, std::vector<bool>> canBecomeImmutable;

  // Maps each field to its new index after field removals. That is, this
  // takes into account that fields before this one may have been removed,
  // which would then reduce this field's index. If a field itself is removed,
  // it has the special value |RemovedField|. This is always of the full size
  // of the number of fields, unlike canBecomeImmutable which is lazily
  // allocated, as if we remove one field that affects the indexes of all the
  // others anyhow.
  static const Index RemovedField = Index(-1);
  std::unordered_map<HeapType, std::vector<Index>> indexesAfterRemovals;

  // The types that no longer need a descriptor.
  std::unordered_set<HeapType> haveUnneededDescriptors;

  // Descriptor types that are not needed by their described types but that
  // still need to be descriptors for their own subtypes and supertypes to be
  // valid. We will keep them descriptors by having them describe trivial new
  // placeholder types.
  std::vector<HeapType> descriptorsOfPlaceholders;

  void run(Module* module) override {
    if (!module->features.hasGC()) {
      return;
    }

    if (!getPassOptions().closedWorld) {
      Fatal() << "GTO requires --closed-world";
    }

    auto trapsNeverHappen = getPassOptions().trapsNeverHappen;

    // Find and analyze struct operations inside each function.
    StructUtils::FunctionStructValuesMap<FieldInfo> functionNewInfos(*module),
      functionSetGetInfos(*module);
    FieldInfoScanner scanner(functionNewInfos, functionSetGetInfos);
    scanner.run(getPassRunner(), module);
    scanner.runOnModuleCode(getPassRunner(), module);

    // Combine the data from the functions.
    functionSetGetInfos.combineInto(combinedSetGetInfos);

    // Custom descriptor handling: We need to look at struct.news, which
    // normally we ignore (nothing in a struct.new can cause fields to remain
    // mutable, or force the field to stay around. We cannot ignore them with CD
    // because struct.news can now trap, and removing the descriptor could
    // change things, so we must be careful. (Without traps, though, this is
    // unnecessary.)
    if (module->features.hasCustomDescriptors() && !trapsNeverHappen) {
      for (auto& [func, infos] : functionNewInfos) {
        for (auto& [type, info] : infos) {
          if (info.desc.hasWrite) {
            // Copy the descriptor write to the info we will propagate below.
            combinedSetGetInfos[type].desc.noteWrite();
          }
        }
      }
    }

    // Propagate information to super and subtypes on set/get infos:
    //
    //  * For removing unread fields, we can only remove a field if it is never
    //    read in any sub or supertype, as such a read may alias any of those
    //    types (where the field is present).
    //
    //    Note that we *can* propagate reads only to supertypes, but we are
    //    limited in what we optimize. If type A has fields {a, b}, and its
    //    subtype B has the same fields, and if field a is only used in reads of
    //    type B, then we still cannot remove it. If we removed it then A would
    //    have fields {b}, that is, field b would be at index 0, while type B
    //    would still be {a, b} which has field b at index 1, which is not
    //    compatible. The only case in which we can optimize is to remove a
    //    field from the end, that is, we could remove field b from A.
    //    Otherwise, as mentioned before we can only remove a field if we also
    //    remove it from all sub- and super-types.
    //
    //  * For immutability, this is necessary because we cannot have a
    //    supertype's field be immutable while a subtype's is not - they must
    //    match for us to preserve subtyping.
    //
    //    Note that we do not need to care about types here: If the fields were
    //    mutable before, then they must have had identical types for them to be
    //    subtypes (as wasm only allows the type to differ if the fields are
    //    immutable). Note that by making more things immutable we therefore
    //    make it possible to apply more specific subtypes in subtype fields.
    SubTypes subTypes(*module);
    StructUtils::TypeHierarchyPropagator<FieldInfo> propagator(subTypes);
    auto dataFromSubsAndSupersMap = combinedSetGetInfos;
    propagator.propagateToSuperAndSubTypes(dataFromSubsAndSupersMap);
    auto dataFromSupersMap = std::move(combinedSetGetInfos);
    propagator.propagateToSubTypes(dataFromSupersMap);

    // Find the public types, which we must not modify.
    auto publicTypes = ModuleUtils::getPublicHeapTypes(*module);
    std::unordered_set<HeapType> publicTypesSet(publicTypes.begin(),
                                                publicTypes.end());

    // Process the propagated info. We look at supertypes first, as the order of
    // fields in a supertype is a constraint on what subtypes can do. That is,
    // we decide for each supertype what the optimal order is, and consider that
    // fixed, and then subtypes can decide how to sort fields that they append.
    for (auto type :
         HeapTypeOrdering::supertypesFirst(propagator.subTypes.types)) {
      if (!type.isStruct() || publicTypesSet.count(type)) {
        continue;
      }
      auto& fields = type.getStruct().fields;
      // Use the exact entry because information from the inexact entry in
      // dataFromSupersMap will have been propagated down into it but not vice
      // versa. (This doesn't matter or dataFromSubsAndSupers because the exact
      // and inexact entries will have the same data.)
      auto ht = std::make_pair(type, Exact);
      auto& dataFromSubsAndSupers = dataFromSubsAndSupersMap[ht];
      auto& dataFromSupers = dataFromSupersMap[ht];

      // Process immutability.
      for (Index i = 0; i < fields.size(); i++) {
        if (fields[i].mutable_ == Immutable) {
          // Already immutable; nothing to do.
          continue;
        }

        if (dataFromSubsAndSupers[i].hasWrite) {
          // A set exists.
          continue;
        }

        // The propagation analysis ensures we update immutability in all
        // supers and subs in concert, but it does not take into account
        // visibility, so do that here: we can only become immutable if the
        // parent can as well.
        auto super = type.getDeclaredSuperType();
        if (super) {
          // The super may not contain the field, which is fine, so only check
          // here if the field does exist in both.
          if (i < super->getStruct().fields.size()) {
            // No entry in canBecomeImmutable means nothing in the parent can
            // become immutable, so check for both that and for an entry with
            // "false".
            auto iter = canBecomeImmutable.find(*super);
            if (iter == canBecomeImmutable.end()) {
              continue;
            }
            // The vector is grown only when needed to contain a "true" value,
            // so |i| being out of bounds indicates "false".
            auto& superVec = iter->second;
            if (i >= superVec.size() || !superVec[i]) {
              continue;
            }
          }
        }

        // No set exists. Mark it as something we can make immutable.
        auto& vec = canBecomeImmutable[type];
        vec.resize(i + 1);
        vec[i] = true;
      }

      // Process removability.
      std::set<Index> removableIndexes;
      for (Index i = 0; i < fields.size(); i++) {
        // If there is no read whatsoever, in either subs or supers, then we can
        // remove the field. That is so even if there are writes (it would be a
        // pointless "write-only field").
        auto hasNoReadsAnywhere = !dataFromSubsAndSupers[i].hasRead;

        // Check for reads or writes in ourselves and our supers. If there are
        // none, then operations only happen in our strict subtypes, and those
        // subtypes can define the field there, and we don't need it here.
        auto hasNoReadsOrWritesInSupers =
          !dataFromSupers[i].hasRead && !dataFromSupers[i].hasWrite;

        if (hasNoReadsAnywhere || hasNoReadsOrWritesInSupers) {
          removableIndexes.insert(i);
        }
      }

      // We need to compute the new set of indexes if we are removing fields, or
      // if our parent removed fields. In the latter case, our parent may have
      // reordered fields even if we ourselves are not removing anything, and we
      // must update to match the parent's order.
      auto super = type.getDeclaredSuperType();
      auto superHasUpdates = super && indexesAfterRemovals.count(*super);
      if (!removableIndexes.empty() || superHasUpdates) {
        // We are removing fields. Reorder them to allow that, as in the general
        // case we can only remove fields from the end, so that if our subtypes
        // still need the fields they can append them. For example:
        //
        //  type A     = { x: i32, y: f64 };
        //  type B : A = { x: 132, y: f64, z: v128 };
        //
        // If field x is used in B but never in A then we want to remove it, but
        // we cannot end up with this:
        //
        //  type A     = { y: f64 };
        //  type B : A = { x: 132, y: f64, z: v128 };
        //
        // Here B no longer extends A's fields. Instead, we reorder A, which
        // then imposes the same order on B's fields:
        //
        //  type A     = { y: f64, x: i32 };
        //  type B : A = { y: f64, x: i32, z: v128 };
        //
        // And after that, it is safe to remove x in A: B will then append it,
        // just like it appends z, leading to this:
        //
        //  type A     = { y: f64 };
        //  type B : A = { y: f64, x: i32, z: v128 };
        //
        std::vector<Index> indexesAfterRemoval(fields.size());

        // The next new index to use.
        Index next = 0;

        // If we have a super, then we extend it, and must match its fields.
        // That is, we can only append fields: we cannot reorder or remove any
        // field that is in the super.
        Index numSuperFields = 0;
        if (super) {
          // We have visited the super before. Get the information about its
          // fields.
          std::vector<Index> superIndexes;
          auto iter = indexesAfterRemovals.find(*super);
          if (iter != indexesAfterRemovals.end()) {
            superIndexes = iter->second;
          } else {
            // We did not store any information about the parent, because we
            // found nothing to optimize there. That means it is not removing or
            // reordering anything, so its new indexes are trivial.
            superIndexes = makeIdentity(super->getStruct().fields.size());
          }

          numSuperFields = superIndexes.size();

          // Fields we keep but the super removed will be handled at the end.
          std::vector<Index> keptFieldsNotInSuper;

          // Go over the super fields and handle them.
          for (Index i = 0; i < superIndexes.size(); ++i) {
            auto superIndex = superIndexes[i];
            if (superIndex == RemovedField) {
              if (removableIndexes.count(i)) {
                // This was removed in the super, and in us as well.
                indexesAfterRemoval[i] = RemovedField;
              } else {
                // This was removed in the super, but we actually need it. It
                // must appear after all other super fields, when we get to the
                // proper index for that, later. That is, we are reordering.
                keptFieldsNotInSuper.push_back(i);
              }
            } else {
              // The super kept this field, so we must keep it as well. This can
              // happen when we need the field in both, but also in the corner
              // case where we don't need the field but the super is public.

              // We need to keep it at the same index so we remain compatible.
              indexesAfterRemoval[i] = superIndex;
              // Update |next| to refer to the next available index. Due to
              // possible reordering in the parent, we may not see indexes in
              // order here, so just take the max at each point in time.
              next = std::max(next, superIndex + 1);
            }
          }

          // Handle fields we keep but the super removed.
          for (auto i : keptFieldsNotInSuper) {
            indexesAfterRemoval[i] = next++;
          }
        }

        // Go over the fields only defined in us, and not in any super.
        for (Index i = numSuperFields; i < fields.size(); ++i) {
          if (removableIndexes.count(i)) {
            indexesAfterRemoval[i] = RemovedField;
          } else {
            indexesAfterRemoval[i] = next++;
          }
        }

        // Only store the new indexes we computed if we found something
        // interesting. We might not, if e.g. our parent removes fields and we
        // add them back in the exact order we started with. In such cases,
        // avoid wasting memory and also time later.
        if (indexesAfterRemoval != makeIdentity(indexesAfterRemoval.size())) {
          indexesAfterRemovals[type] = indexesAfterRemoval;
        }
      }

      // Process the descriptor.
      if (auto desc = type.getDescriptorType()) {
        // To remove a descriptor, it must not be read via supertypes and it
        // must not have to remain in supertypes because e.g. they are public.
        // It must also have no write (see above, we note only dangerous writes
        // which might trap), as if it could trap, we'd have no easy way to
        // remove it in a global scope.
        // TODO: We could check and handle the global scope specifically, but
        //       the trapsNeverHappen flag avoids this problem entirely anyhow.
        //
        // This does not handle descriptor subtyping, see below.
        auto super = type.getDeclaredSuperType();
        bool superNeedsDescriptor = super && super->getDescriptorType() &&
                                    !haveUnneededDescriptors.count(*super);
        bool descriptorIsUsed =
          dataFromSupers.desc.hasRead ||
          (dataFromSupers.desc.hasWrite && !trapsNeverHappen);
        if (!superNeedsDescriptor && !descriptorIsUsed) {
          haveUnneededDescriptors.insert(type);
        }
      }
    }

    // Handle descriptor subtyping:
    //
    //   A -> A.desc
    //        ^
    //   B -> B.desc
    //
    // Say we want to optimize A to no longer have a descriptor. Then A.desc
    // will no longer describe A. But A.desc still needs to be a descriptor for
    // it to remain a valid supertype of B.desc. To allow the optimization of A
    // to proceed, we will introduce a placeholder type for A.desc to describe,
    // keeping it a descriptor type.
    if (!haveUnneededDescriptors.empty()) {
      StructUtils::TypeHierarchyPropagator<StructUtils::CombinableBool>
        descPropagator(subTypes);

      // Populate the initial data: Any descriptor we did not see was unneeded,
      // is needed.
      StructUtils::TypeHierarchyPropagator<
        StructUtils::CombinableBool>::StructMap remainingDesciptors;
      for (auto type : subTypes.types) {
        if (auto desc = type.getDescriptorType()) {
          if (!haveUnneededDescriptors.count(type)) {
            // This descriptor type is needed.
            remainingDesciptors[*desc].value = true;
          }
        }
      }

      // Propagate.
      descPropagator.propagateToSuperAndSubTypes(remainingDesciptors);

      // Determine the set of descriptor types that will need placeholder
      // describees. Do not iterate directly on remainingDescriptors because it
      // is not deterministically ordered.
      for (auto type : subTypes.types) {
        if (auto it = remainingDesciptors.find(type);
            it != remainingDesciptors.end() && it->second.value) {
          auto desc = type.getDescribedType();
          assert(desc);
          if (haveUnneededDescriptors.count(*desc)) {
            descriptorsOfPlaceholders.push_back(type);
          }
        }
      }
    }

    // If we found things that can be removed, remove them from instructions.
    // (Note that we must do this first, while we still have the old heap types
    // that we can identify, and only after this should we update all the types
    // throughout the module.)
    if (!indexesAfterRemovals.empty() || !haveUnneededDescriptors.empty()) {
      updateInstructions(*module);
    }

    // Update the types in the entire module.
    if (!indexesAfterRemovals.empty() || !canBecomeImmutable.empty() ||
        !haveUnneededDescriptors.empty()) {
      updateTypes(*module);
    }
  }

  void updateTypes(Module& wasm) {
    class TypeRewriter : public GlobalTypeRewriter {
      GlobalTypeOptimization& parent;
      InsertOrderedMap<HeapType, Index> placeholderIndices;
      InsertOrderedMap<HeapType, Index>::iterator placeholderIt;

    public:
      TypeRewriter(Module& wasm, GlobalTypeOptimization& parent)
        : GlobalTypeRewriter(wasm), parent(parent),
          placeholderIt(placeholderIndices.begin()) {}

      std::vector<HeapType> getSortedTypes(PredecessorGraph preds) override {
        auto types = GlobalTypeRewriter::getSortedTypes(std::move(preds));
        // Some of the descriptors of placeholders may not end up being used at
        // all, so we will not rebuild them. Record the used types that need
        // placeholder describees and assign them placeholder indices.
        std::unordered_set<HeapType> typeSet(types.begin(), types.end());
        for (auto desc : parent.descriptorsOfPlaceholders) {
          if (typeSet.count(desc)) {
            placeholderIndices.insert({desc, placeholderIndices.size()});
          }
        }
        placeholderIt = placeholderIndices.begin();
        // Prefix the types with placeholders to be overwritten with the
        // placeholder describees.
        HeapType placeholder = Struct{};
        types.insert(types.begin(), placeholderIndices.size(), placeholder);
        return types;
      }

      void modifyStruct(HeapType oldStructType, Struct& struct_) override {
        auto& newFields = struct_.fields;

        // Adjust immutability.
        auto immIter = parent.canBecomeImmutable.find(oldStructType);
        if (immIter != parent.canBecomeImmutable.end()) {
          auto& immutableVec = immIter->second;
          for (Index i = 0; i < immutableVec.size(); i++) {
            if (immutableVec[i]) {
              newFields[i].mutable_ = Immutable;
            }
          }
        }

        // Remove/reorder fields where we can.
        auto remIter = parent.indexesAfterRemovals.find(oldStructType);
        if (remIter != parent.indexesAfterRemovals.end()) {
          auto& indexesAfterRemoval = remIter->second;
          Index removed = 0;
          auto copy = newFields;
          for (Index i = 0; i < newFields.size(); i++) {
            auto newIndex = indexesAfterRemoval[i];
            if (newIndex != RemovedField) {
              newFields[newIndex] = copy[i];
            } else {
              removed++;
            }
          }
          newFields.resize(newFields.size() - removed);

          // Update field names as well. The Type Rewriter cannot do this for
          // us, as it does not know which old fields map to which new ones (it
          // just keeps the names in sequence).
          auto iter = wasm.typeNames.find(oldStructType);
          if (iter != wasm.typeNames.end()) {
            auto& nameInfo = iter->second;

            // Make a copy of the old ones to base ourselves off of as we do so.
            auto oldFieldNames = nameInfo.fieldNames;

            // Clear the old names and write the new ones.
            nameInfo.fieldNames.clear();
            for (Index i = 0; i < oldFieldNames.size(); i++) {
              auto newIndex = indexesAfterRemoval[i];
              if (newIndex != RemovedField && oldFieldNames.count(i)) {
                assert(oldFieldNames[i].is());
                nameInfo.fieldNames[newIndex] = oldFieldNames[i];
              }
            }
          }
        }
      }

      void modifyTypeBuilderEntry(TypeBuilder& typeBuilder,
                                  Index i,
                                  HeapType oldType) override {
        if (!oldType.isStruct()) {
          return;
        }

        // Until we've created all the placeholders, create a placeholder
        // describee type for the next descriptor that needs one.
        if (placeholderIt != placeholderIndices.end()) {
          auto descriptor = placeholderIt->first;
          typeBuilder[i].descriptor(getTempHeapType(descriptor));
          typeBuilder[i].setShared(descriptor.getShared());

          ++placeholderIt;
          return;
        }

        // Remove an unneeded describee or describe a placeholder type.
        if (auto described = oldType.getDescribedType()) {
          if (parent.haveUnneededDescriptors.count(*described)) {
            if (auto it = placeholderIndices.find(oldType);
                it != placeholderIndices.end()) {
              typeBuilder[i].describes(typeBuilder[it->second]);
            } else {
              typeBuilder[i].describes(std::nullopt);
            }
          }
        }

        // Remove an unneeded descriptor.
        if (parent.haveUnneededDescriptors.count(oldType)) {
          typeBuilder.setDescriptor(i, std::nullopt);
        }
      }
    };

    TypeRewriter(wasm, *this).update();
  }

  // After updating the types to remove certain fields, we must also remove
  // them from struct instructions.
  void updateInstructions(Module& wasm) {
    struct FieldRemover : public WalkerPass<PostWalker<FieldRemover>> {
      bool isFunctionParallel() override { return true; }

      GlobalTypeOptimization& parent;

      FieldRemover(GlobalTypeOptimization& parent) : parent(parent) {}

      std::unique_ptr<Pass> create() override {
        return std::make_unique<FieldRemover>(parent);
      }

      bool needEHFixups = false;

      // Expressions that might trap that have been removed from module-level
      // initializers. These need to be placed in new globals to preserve any
      // instantiation-time traps.
      std::vector<Expression*> removedTrappingInits;

      void visitStructNew(StructNew* curr) {
        if (curr->type == Type::unreachable) {
          return;
        }

        auto type = curr->type.getHeapType();
        auto removeDesc = parent.haveUnneededDescriptors.count(type);

        // There may be no indexes to remove, if we are only removing the
        // descriptor.
        std::vector<Index>* indexesAfterRemoval = nullptr;
        // There are also no indexes to remove if we only write default values.
        if (!curr->isWithDefault()) {
          auto iter = parent.indexesAfterRemovals.find(type);
          if (iter != parent.indexesAfterRemovals.end()) {
            indexesAfterRemoval = &iter->second;
          }
        }

        // Ensure any children with non-trivial effects are replaced with
        // local.gets, so that we can remove/reorder to our hearts' content.
        // We can only do this inside functions. Outside of functions, we
        // preserve traps during instantiation by creating new globals to hold
        // removed and potentially-trapping operands instead.
        auto* func = getFunction();
        if (func) {
          ChildLocalizer localizer(curr, func, *getModule(), getPassOptions());
          replaceCurrent(localizer.getReplacement());
          // Adding a block here requires EH fixups.
          needEHFixups = true;
        }

        if (indexesAfterRemoval) {
          // Remove and reorder operands.
          auto& operands = curr->operands;
          assert(indexesAfterRemoval->size() == operands.size());

          Index removed = 0;
          std::vector<Expression*> old(operands.begin(), operands.end());
          for (Index i = 0; i < operands.size(); ++i) {
            auto newIndex = (*indexesAfterRemoval)[i];
            if (newIndex != RemovedField) {
              assert(newIndex < operands.size());
              operands[newIndex] = old[i];
            } else {
              ++removed;
              if (!func &&
                  EffectAnalyzer(getPassOptions(), *getModule(), old[i]).trap) {
                removedTrappingInits.push_back(old[i]);
              }
            }
          }
          if (removed) {
            operands.resize(operands.size() - removed);
          } else {
            // If we didn't remove anything then we must have reordered (or else
            // we have done pointless work).
            assert(*indexesAfterRemoval !=
                   makeIdentity(indexesAfterRemoval->size()));
          }
        }

        if (removeDesc) {
          // We already handled the case of a possible trap here, so we can
          // remove the descriptor, but must be careful of nested effects (our
          // descriptor may be ok to remove, but a nested struct.new may not).
          if (!func &&
              EffectAnalyzer(getPassOptions(), *getModule(), curr->desc).trap) {
            removedTrappingInits.push_back(curr->desc);
          }
          curr->desc = nullptr;
        }
      }

      void visitStructSet(StructSet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        auto newIndex = getNewIndex(curr->ref->type.getHeapType(), curr->index);
        if (newIndex != RemovedField) {
          // Map to the new index.
          curr->index = newIndex;
        } else {
          // This field was removed, so just emit drops of our children, plus a
          // trap if the ref is null. Note that we must preserve the order of
          // operations here: the trap on a null ref happens after the value,
          // which might have side effects.
          Builder builder(*getModule());
          auto* flipped = getResultOfFirst(curr->ref,
                                           builder.makeDrop(curr->value),
                                           getFunction(),
                                           getModule(),
                                           getPassOptions());
          needEHFixups = true;
          Expression* replacement =
            builder.makeDrop(builder.makeRefAs(RefAsNonNull, flipped));
          // We only remove fields with no reads, so if this set is atomic,
          // there are no reads it can possibly synchronize with and we do not
          // need a fence.
          replaceCurrent(replacement);
        }
      }

      void visitStructGet(StructGet* curr) {
        if (curr->ref->type == Type::unreachable) {
          return;
        }

        auto newIndex = getNewIndex(curr->ref->type.getHeapType(), curr->index);
        // We must not remove a field that is read from.
        assert(newIndex != RemovedField);
        curr->index = newIndex;
      }

      void visitFunction(Function* curr) {
        if (needEHFixups) {
          EHUtils::handleBlockNestedPops(curr, *getModule());
        }
      }

    private:
      Index getNewIndex(HeapType type, Index index) {
        auto iter = parent.indexesAfterRemovals.find(type);
        if (iter == parent.indexesAfterRemovals.end()) {
          return index;
        }
        auto& indexesAfterRemoval = iter->second;
        auto newIndex = indexesAfterRemoval[index];
        assert(newIndex < indexesAfterRemoval.size() ||
               newIndex == RemovedField);
        return newIndex;
      }
    };

    FieldRemover remover(*this);
    remover.run(getPassRunner(), &wasm);
    remover.runOnModuleCode(getPassRunner(), &wasm);

    // Insert globals necessary to preserve instantiation-time trapping of
    // removed expressions.
    for (Index i = 0; i < remover.removedTrappingInits.size(); ++i) {
      auto* curr = remover.removedTrappingInits[i];
      auto name = Names::getValidGlobalName(
        wasm, std::string("gto-removed-") + std::to_string(i));
      wasm.addGlobal(
        Builder::makeGlobal(name, curr->type, curr, Builder::Immutable));
    }
  }
};

} // anonymous namespace

Pass* createGlobalTypeOptimizationPass() {
  return new GlobalTypeOptimization();
}

} // namespace wasm
