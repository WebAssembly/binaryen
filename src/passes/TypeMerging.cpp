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
// Merge unneeded types: types that are not needed for validation, and have no
// detectable runtime effect. Completely unused types are removed anyhow during
// binary writing, so this handles the case of used types that can be merged
// into others. Specifically we merge a type into its super, which is possible
// when it has no extra fields, no refined fields, and no casts.
//
// Note that such "redundant" types may help the optimizer, so merging them can
// have a negative effect later. For that reason this may be best run at the
// very end of the optimization pipeline, when nothing else is expected to do
// type-based optimizations later.
//

#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "ir/utils.h"
#include "pass.h"
#include "support/small_set.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// We need to find all the types that have casts to them, as such types must be
// preserved - even if they are identical to other types, they are nominally
// distinguishable.

// Most functions do no casts, or perhaps cast |this| and perhaps a few others.
using CastTypes = SmallUnorderedSet<HeapType, 5>;

struct CastFinder : public PostWalker<CastFinder> {
  CastTypes castTypes;

  void visitRefCast(RefCast* curr) { castTypes.insert(curr->intendedType); }
};

struct TypeMerging : public Pass {
  // Only modifies types.
  bool requiresNonNullableLocalFixups() override { return false; }

  Module* module;

  // The types we can merge. We map each such type to merge with the type we
  // want to merge it with.
  using TypeUpdates = std::unordered_map<HeapType, HeapType>;
  TypeUpdates merges;

  void run(Module* module_) override {
    module = module_;

    if (!module->features.hasGC()) {
      return;
    }
    if (getTypeSystem() != TypeSystem::Nominal &&
        getTypeSystem() != TypeSystem::Isorecursive) {
      Fatal() << "TypeMerging requires nominal/isorecursive typing";
    }

    // First, find all the cast types.

    ModuleUtils::ParallelFunctionAnalysis<CastTypes> analysis(
      *module, [&](Function* func, CastTypes& castTypes) {
        if (func->imported()) {
          return;
        }

        CastFinder finder;
        finder.walk(func->body);
        castTypes = std::move(finder.castTypes);
      });

    // Also find cast types in the module scope (not possible in the current
    // spec, but do it to be future-proof).
    CastFinder moduleFinder;
    moduleFinder.walkModuleCode(module);

    // Accumulate all the castTypes.
    auto& allCastTypes = moduleFinder.castTypes;
    for (auto& [k, castTypes] : analysis.map) {
      for (auto type : castTypes) {
        allCastTypes.insert(type);
      }
    }

    // Find all the heap types.
    std::vector<HeapType> types = ModuleUtils::collectHeapTypes(*module);

    for (auto type : types) {
      if (allCastTypes.count(type)) {
        // This has a cast, so it is distinguishable nominally.
        continue;
      }

      auto super = type.getSuperType();
      if (!super) {
        // This has no supertype, so there is nothing to merge it into.
        continue;
      }

      // TODO: arrays
      if (!type.isStruct()) {
        continue;
      }

      auto& fields = type.getStruct().fields;
      auto& superFields = super->getStruct().fields;
      if (fields != superFields) {
        // This adds a field, or refines one, so it differs from the super, and
        // we cannot merge it with the super.
        continue;
      }

      // We can merge! This is identical structurally to the super, and also not
      // distinguishable nominally.
      merges[type] = *super;
    }

    if (merges.empty()) {
      return;
    }

    // We found things to optimize! Rewrite types in the module to apply those
    // changes.

    // First, close over the map, so if X can be merged into Y and Y into Z then
    // we map X into Z.
    for (auto type : types) {
      if (!merges.count(type)) {
        continue;
      }

      auto newType = merges[type];
      while (1) {
        if (merges.count(newType)) {
          newType = merges[newType];
          continue;
        }
        break;
      }
      merges[type] = newType;
    }

    // Map types, making locals refer to the new types and so forth.

    std::unordered_map<HeapType, Signature> newSignatures;

    for (auto type : types) {
      if (!type.isSignature()) {
        continue;
      }

      auto updateType = [&](Type& type) {
        if (!type.isRef()) {
          return;
        }
        auto heapType = type.getHeapType();
        auto iter = merges.find(heapType);
        if (iter != merges.end()) {
          type = Type(iter->second, type.getNullability());
        }
      };

      auto getUpdatedTypeList = [&](Type type) {
        std::vector<Type> vec;
        for (auto t : type) {
          updateType(t);
          vec.push_back(t);
        }
        return Type(vec);
      };

      auto oldSig = type.getSignature();
      Signature sig;
      sig.params = getUpdatedTypeList(oldSig.params);
      sig.results = getUpdatedTypeList(oldSig.results);
      newSignatures[type] = sig;
    }

    class TypeInternalsUpdater : public GlobalTypeRewriter {
      const TypeUpdates& updates;
      const SignatureUpdates& signatureUpdates;

    public:
      TypeInternalsUpdater(Module& wasm,
                           const TypeUpdates& updates,
                           const SignatureUpdates& signatureUpdates)
        : GlobalTypeRewriter(wasm), updates(updates),
          signatureUpdates(signatureUpdates) {

        // Map locals etc. to refer to the merged types.
        mapTypes(updates);

        // Update the internals of types to refer to the merged types.
        update();
      }

      Type getNewType(Type type) {
        if (!type.isRef()) {
          return type;
        }
        auto heapType = type.getHeapType();
        auto iter = updates.find(heapType);
        if (iter != updates.end()) {
          return Type(iter->second, type.getNullability());
        }
        return type;
      }

      void modifyStruct(HeapType oldType, Struct& struct_) override {
        auto& oldFields = oldType.getStruct().fields;
        for (Index i = 0; i < oldFields.size(); i++) {
          auto& oldField = oldFields[i];
          auto& newField = struct_.fields[i];
          newField.type = getNewType(oldField.type);
        }
      }
      void modifyArray(HeapType oldType, Array& array) override {
        array.element.type = getNewType(oldType.getArray().element.type);
      }
      void modifySignature(HeapType oldSignatureType, Signature& sig) override {
        auto iter = signatureUpdates.find(oldSignatureType);
        if (iter != signatureUpdates.end()) {
          sig.params = getTempType(iter->second.params);
          sig.results = getTempType(iter->second.results);
        }
      }
    } rewriter(*module, merges, newSignatures);

    // Propagate type changes outwards.
    ReFinalize().run(getPassRunner(), module);
  }
};

} // anonymous namespace

Pass* createTypeMergingPass() { return new TypeMerging(); }

} // namespace wasm
