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
#include "support/dfa_minimization.h"
#include "support/small_set.h"
#include "support/topological_sort.h"
#include "wasm-builder.h"
#include "wasm.h"

namespace wasm {

namespace {

// We need to find all types that are distinguished from their supertypes by
// some kind of cast instruction. Merging these types with their supertypes
// would be an observable change. In contrast, types that are never used in
// casts are never distinguished from their supertypes.

// Most functions do no casts, or perhaps cast |this| and perhaps a few others.
using CastTypes = SmallUnorderedSet<HeapType, 5>;

struct CastFinder : public PostWalker<CastFinder> {
  CastTypes castTypes;

  // If traps never happen, then ref.cast and call_indirect can never
  // differentiate between types since they always succeed. Take advantage of
  // that by not having those instructions inhibit merges in TNH mode.
  // mode.
  bool trapsNeverHappen;

  CastFinder(const PassOptions& options)
    : trapsNeverHappen(options.trapsNeverHappen) {}

  template<typename T> void visitCast(T* curr) {
    if (auto type = curr->getCastType(); type != Type::unreachable) {
      castTypes.insert(type.getHeapType());
    }
  }

  void visitRefCast(RefCast* curr) {
    if (!trapsNeverHappen) {
      visitCast(curr);
    }
  }

  void visitRefTest(RefTest* curr) { visitCast(curr); }

  void visitBrOn(BrOn* curr) {
    if (curr->op == BrOnCast || curr->op == BrOnCastFail) {
      visitCast(curr);
    }
  }

  void visitCallIndirect(CallIndirect* curr) {
    if (!trapsNeverHappen) {
      castTypes.insert(curr->heapType);
    }
  }
};

// TODO: This is almost directly copied from type-updating.cpp. Deduplicate
// this.
struct SupertypesFirst : TopologicalSort<HeapType, SupertypesFirst> {
  SupertypesFirst(const std::vector<HeapType>& types) {
    std::unordered_set<HeapType> supertypes;
    for (auto type : types) {
      if (auto super = type.getSuperType()) {
        supertypes.insert(*super);
      }
    }
    // Types that are not supertypes of others are the roots.
    for (auto type : types) {
      if (!supertypes.count(type)) {
        push(type);
      }
    }
  }

  void pushPredecessors(HeapType type) {
    if (auto super = type.getSuperType()) {
      push(*super);
    }
  }
};

// We are going to treat the type graph as a partitioned DFA where each type is
// a state with transitions to its children. We will partition the DFA states so
// that types that may be mergeable will be in the same partition and types that
// we know are not mergeable will be in different partitions. Then we will
// refine the partitions so that types that turn out to not be mergeable will be
// split out into separate partitions.
struct TypeMerging : public Pass {
  using TypeUpdates = std::unordered_map<HeapType, HeapType>;

  // Only modifies types.
  bool requiresNonNullableLocalFixups() override { return false; }

  Module* module;

  std::unordered_set<HeapType> privateTypes;
  CastTypes castTypes;

  void run(Module* module_) override;

  CastTypes findCastTypes();
  std::vector<HeapType> getPublicChildren(HeapType type);
  DFA::State<HeapType> makeDFAState(HeapType type);
  void applyMerges(const TypeUpdates& merges);

  bool mayBeMergeable(HeapType sub, HeapType super);
  bool mayBeMergeable(const Struct& a, const Struct& b);
  bool mayBeMergeable(Array a, Array b);
  bool mayBeMergeable(Signature a, Signature b);
  bool mayBeMergeable(Field a, Field b);
  bool mayBeMergeable(Type a, Type b);
  bool mayBeMergeable(const Tuple& a, const Tuple& b);
};

void TypeMerging::run(Module* module_) {
  module = module_;

  if (!module->features.hasGC()) {
    return;
  }

  if (!getPassOptions().closedWorld) {
    Fatal() << "TypeMerging requires --closed-world";
  }

  // First, find all the cast types and private types. We will need these to
  // determine whether types are eligible to be merged.
  auto privates = ModuleUtils::getPrivateHeapTypes(*module);
  privateTypes = std::unordered_set<HeapType>(privates.begin(), privates.end());
  castTypes = findCastTypes();

  // Initial partitions are formed by grouping types with their structurally
  // similar supertypes. Starting with the topmost types and working down the
  // subtype trees, add each type to its supertype's partition if they are
  // structurally compatible.

  // A list of partitions with stable iterators.
  using Partition = std::vector<DFA::State<HeapType>>;
  using Partitions = std::list<Partition>;
  Partitions partitions;

  // Map each type to its partition in the list.
  std::unordered_map<HeapType, Partitions::iterator> typePartitions;

  // Ensure the type has a partition and return a reference to it.
  auto ensurePartition = [&](HeapType type) {
    auto [it, inserted] = typePartitions.insert({type, partitions.end()});
    if (inserted) {
      it->second = partitions.insert(partitions.end(), {makeDFAState(type)});
    }
    return it->second;
  };

  // For each type, either create a new partition or add to its supertype's
  // partition.
  for (auto type : SupertypesFirst(privates)) {
    // We need partitions for any public children of this type since those
    // children will participate in the DFA we're creating.
    for (auto child : getPublicChildren(type)) {
      ensurePartition(child);
    }
    auto super = type.getSuperType();
    if (!super || !mayBeMergeable(type, *super)) {
      // Create a new partition containing just this type.
      ensurePartition(type);
      continue;
    }
    // The current type and its supertype have the same top-level structure, so
    // merge the current type's partition into its supertype's partition. First,
    // find the supertype's partition. The supertype's partition may not exist
    // yet if the supertype is public since we don't visit public types in this
    // loop. In that case we can create a new partition for the supertype
    // because merging private types into public supertypes is fine. (In
    // contrast, merging public types into their supertypes is not fine.)
    auto it = ensurePartition(*super);
    it->push_back(makeDFAState(type));
    typePartitions[type] = it;
  }

  // Construct and refine the partitioned DFA.
  std::vector<Partition> dfa(std::make_move_iterator(partitions.begin()),
                             std::make_move_iterator(partitions.end()));
  auto refinedPartitions = DFA::refinePartitions(dfa);

  // The types we can merge mapped to the type we are merging them into.
  TypeUpdates merges;

  // Merge each refined partition into a single type.
  for (const auto& partition : refinedPartitions) {
    for (size_t i = 1; i < partition.size(); ++i) {
      merges[partition[i]] = partition[0];
    }
  }

  applyMerges(merges);
}

CastTypes TypeMerging::findCastTypes() {
  ModuleUtils::ParallelFunctionAnalysis<CastTypes> analysis(
    *module, [&](Function* func, CastTypes& castTypes) {
      if (func->imported()) {
        return;
      }

      CastFinder finder(getPassOptions());
      finder.walk(func->body);
      castTypes = std::move(finder.castTypes);
    });

  // Also find cast types in the module scope (not possible in the current
  // spec, but do it to be future-proof).
  CastFinder moduleFinder(getPassOptions());
  moduleFinder.walkModuleCode(module);

  // Accumulate all the castTypes.
  auto& allCastTypes = moduleFinder.castTypes;
  for (auto& [k, castTypes] : analysis.map) {
    for (auto type : castTypes) {
      allCastTypes.insert(type);
    }
  }
  return allCastTypes;
}

std::vector<HeapType> TypeMerging::getPublicChildren(HeapType type) {
  std::vector<HeapType> publicChildren;
  for (auto child : type.getHeapTypeChildren()) {
    if (!child.isBasic() && !privateTypes.count(child)) {
      publicChildren.push_back(child);
    }
  }
  return publicChildren;
}

DFA::State<HeapType> TypeMerging::makeDFAState(HeapType type) {
  std::vector<HeapType> succs;
  for (auto child : type.getHeapTypeChildren()) {
    // Both private and public heap type children participate in the DFA and are
    // eligible to be successors.
    if (!child.isBasic()) {
      succs.push_back(child);
    }
  }
  return {type, std::move(succs)};
}

void TypeMerging::applyMerges(const TypeUpdates& merges) {
  if (merges.empty()) {
    return;
  }

  // We found things to optimize! Rewrite types in the module to apply those
  // changes.

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

bool TypeMerging::mayBeMergeable(HeapType sub, HeapType super) {
  // If the type is distinguishable from its supertype or public, we cannot
  // merge it.
  if (castTypes.count(sub) || !privateTypes.count(sub)) {
    return false;
  }
  // Check whether `sub` and `super` have the same top-level structure,
  // including the position and identity of any children that are not included
  // as transitions in the DFA, i.e. any children that are not nontrivial
  // references.
  if (sub.isStruct() && super.isStruct()) {
    return mayBeMergeable(sub.getStruct(), super.getStruct());
  }
  if (sub.isArray() && super.isArray()) {
    return mayBeMergeable(sub.getArray(), super.getArray());
  }
  if (sub.isSignature() && super.isSignature()) {
    return mayBeMergeable(sub.getSignature(), super.getSignature());
  }
  return false;
}

bool TypeMerging::mayBeMergeable(const Struct& a, const Struct& b) {
  if (a.fields.size() != b.fields.size()) {
    return false;
  }
  for (size_t i = 0; i < a.fields.size(); ++i) {
    if (!mayBeMergeable(a.fields[i], b.fields[i])) {
      return false;
    }
  }
  return true;
}

bool TypeMerging::mayBeMergeable(Array a, Array b) {
  return mayBeMergeable(a.element, b.element);
}

bool TypeMerging::mayBeMergeable(Signature a, Signature b) {
  return mayBeMergeable(a.params, b.params) &&
         mayBeMergeable(a.results, b.results);
}

bool TypeMerging::mayBeMergeable(Field a, Field b) {
  return a.packedType == b.packedType && mayBeMergeable(a.type, b.type);
}

bool TypeMerging::mayBeMergeable(Type a, Type b) {
  if (a == b) {
    return true;
  }
  if (a.isTuple() && b.isTuple()) {
    return mayBeMergeable(a.getTuple(), b.getTuple());
  }
  // The only thing allowed to differ is the non-basic heap type child, since we
  // don't know before running the DFA partition refinement whether different
  // heap type children will end up being merged.
  if (!a.isRef() || !b.isRef()) {
    return false;
  }
  if (a.getHeapType().isBasic() || b.getHeapType().isBasic()) {
    return false;
  }
  if (a.getNullability() != b.getNullability()) {
    return false;
  }
  return true;
}

bool TypeMerging::mayBeMergeable(const Tuple& a, const Tuple& b) {
  if (a.types.size() != b.types.size()) {
    return false;
  }
  for (size_t i = 0; i < a.types.size(); ++i) {
    if (!mayBeMergeable(a.types[i], b.types[i])) {
      return false;
    }
  }
  return true;
}

} // anonymous namespace

Pass* createTypeMergingPass() { return new TypeMerging(); }

} // namespace wasm
