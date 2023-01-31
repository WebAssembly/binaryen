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
#include "wasm-type-ordering.h"
#include "wasm.h"

#define TYPE_MERGING_DEBUG 0

#if TYPE_MERGING_DEBUG
#include "wasm-type-printing.h"
#endif

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

// We are going to treat the type graph as a partitioned DFA where each type is
// a state with transitions to its children. We will partition the DFA states so
// that types that may be mergeable will be in the same partition and types that
// we know are not mergeable will be in different partitions. Then we will
// refine the partitions so that types that turn out to not be mergeable will be
// split out into separate partitions.
struct TypeMerging : public Pass {
  // Only modifies types.
  bool requiresNonNullableLocalFixups() override { return false; }

  Module* module;

  std::unordered_set<HeapType> privateTypes;
  CastTypes castTypes;

  void run(Module* module_) override;

  CastTypes findCastTypes();
  std::vector<HeapType> getPublicChildren(HeapType type);
  DFA::State<HeapType> makeDFAState(HeapType type);
  void applyMerges(const TypeMapper::TypeUpdates& merges);
};

// Hash and equality-compare HeapTypes based on their top-level structure (i.e.
// "shape"), ignoring nontrivial heap type children that will not be
// differentiated between until we run the DFA partition refinement.
bool shapeEq(HeapType a, HeapType b);
bool shapeEq(const Struct& a, const Struct& b);
bool shapeEq(Array a, Array b);
bool shapeEq(Signature a, Signature b);
bool shapeEq(Field a, Field b);
bool shapeEq(Type a, Type b);
bool shapeEq(const Tuple& a, const Tuple& b);

size_t shapeHash(HeapType a);
size_t shapeHash(const Struct& a);
size_t shapeHash(Array a);
size_t shapeHash(Signature a);
size_t shapeHash(Field a);
size_t shapeHash(Type a);
size_t shapeHash(const Tuple& a);

struct ShapeEq {
  bool operator()(const HeapType& a, const HeapType& b) const {
    return shapeEq(a, b);
  }
};

struct ShapeHash {
  size_t operator()(const HeapType& type) const { return shapeHash(type); }
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

  // Map optional supertypes and the top-level structures of their refined
  // children to partitions so that different children that refine the supertype
  // in the same way can be assigned to the same partition and potentially
  // merged.
  // TODO: This is not fully general because it still prevents types from being
  // merged if they are identical subtypes of two other types that end up being
  // merged. Fixing this would require 1) merging such input partitions and
  // re-running DFA minimization until convergence or 2) treating supertypes as
  // special transitions in the DFA and augmenting Valmari-Lehtinen DFA
  // minimization so that these special transitions cannot be used to split a
  // partition if they are self-transitions.
  std::unordered_map<
    std::optional<HeapType>,
    std::unordered_map<HeapType, Partitions::iterator, ShapeHash, ShapeEq>>
    shapePartitions;

#if TYPE_MERGING_DEBUG
  using Fallback = IndexedTypeNameGenerator<DefaultTypeNameGenerator>;
  Fallback printPrivate(privates, "private.");
  ModuleTypeNameGenerator<Fallback> print(*module, printPrivate);
  auto dumpPartitions = [&]() {
    size_t i = 0;
    for (auto& partition : partitions) {
      std::cerr << i++ << ": " << print(partition[0].val) << "\n";
      for (size_t j = 1; j < partition.size(); ++j) {
        std::cerr << "   " << print(partition[j].val) << "\n";
      }
      std::cerr << "\n";
    }
  };
#endif // TYPE_MERGING_DEBUG

  // Ensure the type has a partition and return a reference to it. Since we
  // merge up the type tree and visit supertypes first, the partition usually
  // already exists. The exception is when the supertype is public, in which
  // case we might not have created a partition for it yet.
  auto ensurePartition = [&](HeapType type) -> Partitions::iterator {
    auto [it, inserted] = typePartitions.insert({type, partitions.end()});
    if (inserted) {
      it->second = partitions.insert(partitions.end(), {makeDFAState(type)});
    }
    return it->second;
  };

  // Similar to the above, but look up or create a partition associated with the
  // type's supertype and top-level shape rather than its identity.
  auto ensureShapePartition = [&](HeapType type) -> Partitions::iterator {
    auto [it, inserted] =
      shapePartitions[type.getSuperType()].insert({type, partitions.end()});
    if (inserted) {
      it->second = partitions.insert(partitions.end(), Partition{});
    }
    return it->second;
  };

  // For each type, either create a new partition or add to its supertype's
  // partition.
  for (auto type : HeapTypeOrdering::SupertypesFirst(privates)) {
    // We need partitions for any public children of this type since those
    // children will participate in the DFA we're creating.
    for (auto child : getPublicChildren(type)) {
      ensurePartition(child);
    }
    // If the type is distinguished by the module or public, we cannot merge it,
    // so create a new partition for it.
    if (castTypes.count(type) || !privateTypes.count(type)) {
      ensurePartition(type);
      continue;
    }
    // If there is no supertype to merge with or if this type refines its
    // supertype, then we can still potentially merge it with sibling types with
    // the same structure. Find and add to the partition with other such types.
    auto super = type.getSuperType();
    if (!super || !shapeEq(type, *super)) {
      auto it = ensureShapePartition(type);
      it->push_back(makeDFAState(type));
      typePartitions[type] = it;
      continue;
    }
    // The current type and its supertype have the same top-level structure and
    // are not distinguished, so add the current type to its supertype's
    // partition.
    auto it = ensurePartition(*super);
    it->push_back(makeDFAState(type));
    typePartitions[type] = it;
  }

#if TYPE_MERGING_DEBUG
  std::cerr << "Initial partitions:\n";
  dumpPartitions();
#endif

  // Construct and refine the partitioned DFA.
  std::vector<Partition> dfa(std::make_move_iterator(partitions.begin()),
                             std::make_move_iterator(partitions.end()));
  auto refinedPartitions = DFA::refinePartitions(dfa);

  // The types we can merge mapped to the type we are merging them into.
  TypeMapper::TypeUpdates merges;

  // Merge each refined partition into a single type. We should only merge into
  // supertypes or siblings because if we try to merge into a subtype then we
  // will accidentally set that subtype to be its own supertype.
  for (const auto& partition : refinedPartitions) {
    auto target = *HeapTypeOrdering::SupertypesFirst(partition).begin();
    for (auto type : partition) {
      if (type != target) {
        merges[type] = target;
      }
    }
  }

#if TYPE_MERGING_DEBUG
  std::cerr << "Merges):\n";
  std::unordered_map<HeapType, std::vector<HeapType>> mergees;
  for (auto& [mergee, target] : merges) {
    mergees[target].push_back(mergee);
  }
  for (auto& [target, types] : mergees) {
    std::cerr << "target: " << print(target) << "\n";
    for (auto type : types) {
      std::cerr << "  " << print(type) << "\n";
    }
    std::cerr << "\n";
  }
#endif // TYPE_MERGING_DEBUG

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

void TypeMerging::applyMerges(const TypeMapper::TypeUpdates& merges) {
  if (merges.empty()) {
    return;
  }

  // We found things to optimize! Rewrite types in the module to apply those
  // changes.
  TypeMapper(*module, merges).map();
}

bool shapeEq(HeapType a, HeapType b) {
  // Check whether `a` and `b` have the same top-level structure, including the
  // position and identity of any children that are not included as transitions
  // in the DFA, i.e. any children that are not nontrivial references.
  if (a.isStruct() && b.isStruct()) {
    return shapeEq(a.getStruct(), b.getStruct());
  }
  if (a.isArray() && b.isArray()) {
    return shapeEq(a.getArray(), b.getArray());
  }
  if (a.isSignature() && b.isSignature()) {
    return shapeEq(a.getSignature(), b.getSignature());
  }
  return false;
}

size_t shapeHash(HeapType a) {
  size_t digest;
  if (a.isStruct()) {
    digest = hash(0);
    hash_combine(digest, shapeHash(a.getStruct()));
  } else if (a.isArray()) {
    digest = hash(1);
    hash_combine(digest, shapeHash(a.getArray()));
  } else if (a.isSignature()) {
    digest = hash(2);
    hash_combine(digest, shapeHash(a.getSignature()));
  } else {
    WASM_UNREACHABLE("unexpected kind");
  }
  return digest;
}

bool shapeEq(const Struct& a, const Struct& b) {
  if (a.fields.size() != b.fields.size()) {
    return false;
  }
  for (size_t i = 0; i < a.fields.size(); ++i) {
    if (!shapeEq(a.fields[i], b.fields[i])) {
      return false;
    }
  }
  return true;
}

size_t shapeHash(const Struct& a) {
  size_t digest = hash(a.fields.size());
  for (size_t i = 0; i < a.fields.size(); ++i) {
    hash_combine(digest, shapeHash(a.fields[i]));
  }
  return digest;
}

bool shapeEq(Array a, Array b) { return shapeEq(a.element, b.element); }

size_t shapeHash(Array a) { return shapeHash(a.element); }

bool shapeEq(Signature a, Signature b) {
  return shapeEq(a.params, b.params) && shapeEq(a.results, b.results);
}

size_t shapeHash(Signature a) {
  auto digest = shapeHash(a.params);
  hash_combine(digest, shapeHash(a.results));
  return digest;
}

bool shapeEq(Field a, Field b) {
  return a.packedType == b.packedType && a.mutable_ == b.mutable_ &&
         shapeEq(a.type, b.type);
}

size_t shapeHash(Field a) {
  auto digest = hash((int)a.packedType);
  rehash(digest, (int)a.mutable_);
  hash_combine(digest, shapeHash(a.type));
  return digest;
}

bool shapeEq(Type a, Type b) {
  if (a == b) {
    return true;
  }
  if (a.isTuple() && b.isTuple()) {
    return shapeEq(a.getTuple(), b.getTuple());
  }
  // The only thing allowed to differ is the non-basic heap type child, since we
  // don't know before running the DFA partition refinement whether different
  // heap type children will end up being merged. Children that won't be merged
  // will end up being differentiated by the partition refinement.
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

size_t shapeHash(Type a) {
  if (a.isTuple()) {
    auto digest = hash(0);
    hash_combine(digest, shapeHash(a.getTuple()));
    return digest;
  }
  auto digest = hash(1);
  if (!a.isRef()) {
    rehash(digest, 2);
    return digest;
  }
  if (a.getHeapType().isBasic()) {
    rehash(digest, 3);
    rehash(digest, a.getHeapType().getID());
    return digest;
  }
  rehash(digest, 4);
  rehash(digest, (int)a.getNullability());
  return digest;
}

bool shapeEq(const Tuple& a, const Tuple& b) {
  if (a.types.size() != b.types.size()) {
    return false;
  }
  for (size_t i = 0; i < a.types.size(); ++i) {
    if (!shapeEq(a.types[i], b.types[i])) {
      return false;
    }
  }
  return true;
}

size_t shapeHash(const Tuple& a) {
  auto digest = hash(a.types.size());
  for (auto type : a.types) {
    hash_combine(digest, shapeHash(type));
  }
  return digest;
}

} // anonymous namespace

Pass* createTypeMergingPass() { return new TypeMerging(); }

} // namespace wasm
