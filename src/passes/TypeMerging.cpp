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
// have a negative effect later. For that reason this may be best run near the
// very end of the optimization pipeline, when nothing else is expected to do
// type-based optimizations later. However, you also do not want to merge at the
// very end, as e.g. type merging may open up function merging opportunities.
// One possible sequence:
//
//   --type-ssa -Os --type-merging -Os
//
// That is, running TypeSSA early makes sense, as it provides more type info.
// Then we hope the optimizer benefits from that, and after that we merge types
// and then optimize a final time. You can experiment with more optimization
// passes in between.
//

#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "support/small_set.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// We need to find all the types that have references to them, such as casts,
// as such types must be preserved - even if they are identical to other types,
// they are nominally distinguishable.

// Most functions do no casts, or perhaps cast |this| and perhaps a few others.
using ReferredTypes = SmallUnorderedSet<HeapType, 5>;

struct CastFinder
  : public PostWalker<CastFinder, UnifiedExpressionVisitor<CastFinder>> {
  ReferredTypes referredTypes;

  void visitExpression(Expression* curr) {
    // Find all references to a heap type.

#define DELEGATE_ID curr->_id

#define DELEGATE_START(id) [[maybe_unused]] auto* cast = curr->cast<id>();

#define DELEGATE_FIELD_HEAPTYPE(id, field) referredTypes.insert(cast->field);

#define DELEGATE_FIELD_CHILD(id, field)
#define DELEGATE_FIELD_OPTIONAL_CHILD(id, field)
#define DELEGATE_FIELD_INT(id, field)
#define DELEGATE_FIELD_INT_ARRAY(id, field)
#define DELEGATE_FIELD_LITERAL(id, field)
#define DELEGATE_FIELD_NAME(id, field)
#define DELEGATE_FIELD_NAME_VECTOR(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_DEF(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE(id, field)
#define DELEGATE_FIELD_SCOPE_NAME_USE_VECTOR(id, field)
#define DELEGATE_FIELD_TYPE(id, field)
#define DELEGATE_FIELD_ADDRESS(id, field)
#define DELEGATE_FIELD_CHILD_VECTOR(id, field)

#include "wasm-delegations-fields.def"
  }

  void visitRefCast(Expression* curr) {
    if (curr->type != Type::unreachable) {
      referredTypes.insert(curr->type.getHeapType());
    }
  }
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

    // First, find all the cast types.

    ModuleUtils::ParallelFunctionAnalysis<ReferredTypes> analysis(
      *module, [&](Function* func, ReferredTypes& referredTypes) {
        if (func->imported()) {
          return;
        }

        CastFinder finder;
        finder.walk(func->body);
        referredTypes = std::move(finder.referredTypes);
      });

    // Also find cast types in the module scope (not possible in the current
    // spec, but do it to be future-proof).
    CastFinder moduleFinder;
    moduleFinder.walkModuleCode(module);

    // Accumulate all the referredTypes.
    auto& allReferredTypes = moduleFinder.referredTypes;
    for (auto& [k, referredTypes] : analysis.map) {
      for (auto type : referredTypes) {
        allReferredTypes.insert(type);
      }
    }

    // Find all the heap types.
    std::vector<HeapType> types = ModuleUtils::collectHeapTypes(*module);

    // TODO: There may be more opportunities after this loop. Imagine that we
    //       decide to merge A and B into C, and there are types X and Y that
    //       contain a nested reference to A and B respectively, then after A
    //       and B become identical so do X and Y. The recursive case is not
    //       trivial, however, and needs more thought.
    for (auto type : types) {
      if (allReferredTypes.count(type)) {
        // This has a cast, so it is distinguishable nominally.
        continue;
      }

      auto super = type.getSuperType();
      if (!super) {
        // This has no supertype, so there is nothing to merge it into.
        continue;
      }

      if (type.isStruct()) {
        auto& fields = type.getStruct().fields;
        auto& superFields = super->getStruct().fields;
        if (fields == superFields) {
          // We can merge! This is identical structurally to the super, and also
          // not distinguishable nominally.
          merges[type] = *super;
        }
      } else if (type.isArray()) {
        auto element = type.getArray().element;
        auto superElement = super->getArray().element;
        if (element == superElement) {
          merges[type] = *super;
        }
      }
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
      while (merges.count(newType)) {
        newType = merges[newType];
      }
      // Apply the findings to all intermediate types as well, to avoid
      // duplicate work in later iterations. That is, all the types we saw in
      // the above loop will all get merged into newType.
      auto curr = type;
      while (1) {
        auto iter = merges.find(curr);
        if (iter == merges.end()) {
          break;
        }
        auto& currMerge = iter->second;
        curr = currMerge;
        currMerge = newType;
      }
    }

    // Apply the merges.

    class TypeInternalsUpdater : public GlobalTypeRewriter {
      const TypeUpdates& merges;

      std::unordered_map<HeapType, Signature> newSignatures;

    public:
      TypeInternalsUpdater(Module& wasm, const TypeUpdates& merges)
        : GlobalTypeRewriter(wasm), merges(merges) {

        // Map the types of expressions (curr->type, etc.) to their merged
        // types.
        mapTypes(merges);

        // Update the internals of types (struct fields, signatures, etc.) to
        // refer to the merged types.
        update();
      }

      Type getNewType(Type type) {
        if (!type.isRef()) {
          return type;
        }
        auto heapType = type.getHeapType();
        auto iter = merges.find(heapType);
        if (iter != merges.end()) {
          return getTempType(Type(iter->second, type.getNullability()));
        }
        return getTempType(type);
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
        auto getUpdatedTypeList = [&](Type type) {
          std::vector<Type> vec;
          for (auto t : type) {
            vec.push_back(getNewType(t));
          }
          return getTempTupleType(vec);
        };

        auto oldSig = oldSignatureType.getSignature();
        sig.params = getUpdatedTypeList(oldSig.params);
        sig.results = getUpdatedTypeList(oldSig.results);
      }
    } rewriter(*module, merges);
  }
};

} // anonymous namespace

Pass* createTypeMergingPass() { return new TypeMerging(); }

} // namespace wasm
