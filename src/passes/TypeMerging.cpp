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
#include "wasm-builder.h"
#include "wasm-type-ordering.h"
#include "wasm.h"

#define TYPE_MERGING_DEBUG 0

#if TYPE_MERGING_DEBUG
#include "wasm-type-printing.h"
#endif

namespace wasm {

namespace {

// Stop merging after a while to avoid spending too long on pathological
// modules.
constexpr int MAX_ITERATIONS = 20;

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
  // A list of partitions with stable iterators.
  using Partition = std::vector<DFA::State<HeapType>>;
  using Partitions = std::list<Partition>;

  // Only modifies types.
  bool requiresNonNullableLocalFixups() override { return false; }

  Module* module;

  // All private original types.
  std::unordered_set<HeapType> privateTypes;

  // Types that are distinguished by cast instructions.
  CastTypes castTypes;

  // The list of remaining types that have not been merged into other types.
  // Candidates for further merging.
  std::vector<HeapType> mergeable;

  // Map the original types to the types they will be merged into, if any.
  TypeMapper::TypeUpdates merges;
  HeapType getMerged(HeapType type) {
    for (auto it = merges.find(type); it != merges.end();
         it = merges.find(type)) {
      type = it->second;
    }
    return type;
  }

  void run(Module* module_) override;

  // We will do two different kinds of merging: First, we will merge types into
  // their identical supertypes, and after that we will will merge types into
  // their identical siblings in the type hierarchy. Doing both kinds of merges
  // in a single step would be unsound because a type might be merged into its
  // parent's sibling without being merged with its parent.
  enum MergeKind { Supertypes, Siblings };
  bool merge(MergeKind kind);

  // Split a partition into potentially multiple partitions for each
  // disconnected group of types it contains.
  std::vector<std::vector<HeapType>>
  splitSupertypePartition(const std::vector<HeapType>&);

  CastTypes findCastTypes();
  std::vector<HeapType> getPublicChildren(HeapType type);
  DFA::State<HeapType> makeDFAState(HeapType type);
  void applyMerges();
};

struct MergeableSupertypesFirst
  : HeapTypeOrdering::SupertypesFirstBase<MergeableSupertypesFirst> {
  TypeMerging& merging;

  MergeableSupertypesFirst(TypeMerging& merging) : merging(merging) {}

  std::optional<HeapType> getDeclaredSuperType(HeapType type) {
    if (auto super = type.getDeclaredSuperType()) {
      return merging.getMerged(*super);
    }
    return std::nullopt;
  }
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
  mergeable = ModuleUtils::getPrivateHeapTypes(*module);
  privateTypes =
    std::unordered_set<HeapType>(mergeable.begin(), mergeable.end());
  castTypes = findCastTypes();

  // Merging supertypes or siblings can unlock more sibling merging
  // opportunities, but merging siblings can never unlock more supertype merging
  // opportunities, so it suffices to merge supertypes once followed by repeated
  // merging of siblings.
  //
  // Merging can unlock more sibling merging opportunities because two identical
  // types cannot be merged until their respective identical parents have been
  // merged in a previous step, making them siblings.
  merge(Supertypes);
  for (int i = 0; i < MAX_ITERATIONS; ++i) {
    if (!merge(Siblings)) {
      break;
    }
  }

  applyMerges();
}

bool TypeMerging::merge(MergeKind kind) {
  // Initial partitions are formed by grouping types with their structurally
  // similar supertypes or siblings, according to the `kind`.
  Partitions partitions;

#if TYPE_MERGING_DEBUG
  auto printedPrivateTypes = ModuleUtils::getPrivateHeapTypes(*module);
  using Fallback = IndexedTypeNameGenerator<DefaultTypeNameGenerator>;
  Fallback printPrivate(printedPrivateTypes, "private.");
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

  // Map each type to its partition in the list.
  std::unordered_map<HeapType, Partitions::iterator> typePartitions;

  // Map the supertypes and top-level structures of each type to partitions so
  // that siblings that refine the supertype in the same way can be assigned to
  // the same partition and potentially merged.
  std::unordered_map<
    std::optional<HeapType>,
    std::unordered_map<HeapType, Partitions::iterator, ShapeHash, ShapeEq>>
    shapePartitions;

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
    auto super = type.getDeclaredSuperType();
    if (super) {
      super = getMerged(*super);
    }
    auto [it, inserted] =
      shapePartitions[super].insert({type, partitions.end()});
    if (inserted) {
      it->second = partitions.insert(partitions.end(), Partition{});
    }
    return it->second;
  };

  // For each type, either create a new partition or add to its supertype's
  // partition.
  MergeableSupertypesFirst sortedTypes(*this);
  for (auto type : sortedTypes.sort(mergeable)) {
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

    switch (kind) {
      case Supertypes: {
        auto super = type.getDeclaredSuperType();
        if (super && shapeEq(type, *super)) {
          // The current type and its supertype have the same top-level
          // structure and are not distinguished, so add the current type to its
          // supertype's partition.
          auto it = ensurePartition(*super);
          it->push_back(makeDFAState(type));
          typePartitions[type] = it;
        } else {
          // Otherwise, create a new partition for this type.
          ensurePartition(type);
        }
        break;
      }
      case Siblings: {
        // Find or create a partition for this type's siblings of the same
        // shape.
        auto it = ensureShapePartition(type);
        it->push_back(makeDFAState(type));
        typePartitions[type] = it;
        break;
      }
    }
  }

#if TYPE_MERGING_DEBUG
  std::cerr << "Initial partitions (";
  switch (kind) {
    case Supertypes:
      std::cerr << "supertypes";
      break;
    case Siblings:
      std::cerr << "siblings";
      break;
  }
  std::cerr << "):\n";
  dumpPartitions();
#endif

  // Construct and refine the partitioned DFA.
  std::vector<Partition> dfa(std::make_move_iterator(partitions.begin()),
                             std::make_move_iterator(partitions.end()));
  auto refinedPartitions = DFA::refinePartitions(dfa);

#if TYPE_MERGING_DEBUG
  auto dumpRefinedPartitions = [&]() {
    size_t i = 0;
    for (auto& partition : refinedPartitions) {
      std::cerr << i++ << ": " << print(partition[0]) << "\n";
      for (size_t j = 1; j < partition.size(); ++j) {
        std::cerr << "   " << print(partition[j]) << "\n";
      }
      std::cerr << "\n";
    }
  };
  std::cerr << "Refined partitions:\n";
  dumpRefinedPartitions();
#endif

  if (kind == Supertypes) {
    // It's possible that a partition has been split such that a common ancestor
    // ended up in one of the new partitions, leaving unrelated types grouped
    // together in the other new partition. Since we are only supposed to be
    // merging types into their supertypes, merging such unrelated types would
    // be unsafe. Post-process the refined partitions to manually split any
    // partitions containing unrelated types.
    //
    // Normally splitting partitions like this would require re-running DFA
    // minimization afterward, but in this case it is not possible that the
    // manual splits cause types in any other partition to become
    // differentiatable. A type and its subtype cannot differ by referring to
    // different, unrelated types in the same position because then they would
    // not be in a valid subtype relationship.
    std::vector<std::vector<HeapType>> newPartitions;
    for (const auto& partitionTypes : refinedPartitions) {
      auto split = splitSupertypePartition(partitionTypes);
      newPartitions.insert(newPartitions.end(), split.begin(), split.end());
    }
    refinedPartitions = newPartitions;

#if TYPE_MERGING_DEBUG
    std::cerr << "Manually split partitions:\n";
    dumpRefinedPartitions();
#endif
  }

  // Merge each refined partition into a single type. We should only merge into
  // supertypes or siblings because if we try to merge into a subtype then we
  // will accidentally set that subtype to be its own supertype. Also keep track
  // of the remaining types.
  std::vector<HeapType> newMergeable;
  bool merged = false;
  for (const auto& partition : refinedPartitions) {
    auto target = *MergeableSupertypesFirst(*this).sort(partition).begin();
    newMergeable.push_back(target);
    for (auto type : partition) {
      if (type != target) {
        merges[type] = target;
        merged = true;
      }
    }
  }
  mergeable = std::move(newMergeable);

#if TYPE_MERGING_DEBUG
  std::cerr << "Merges:\n";
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

  return merged;
}

std::vector<std::vector<HeapType>>
TypeMerging::splitSupertypePartition(const std::vector<HeapType>& types) {
  if (types.size() == 1) {
    // Cannot split a partition containing just one type.
    return {types};
  }
  std::unordered_set<HeapType> includedTypes(types.begin(), types.end());
  std::vector<std::vector<HeapType>> partitions;
  std::unordered_map<HeapType, Index> partitionIndices;
  MergeableSupertypesFirst sortedTypes(*this);
  for (auto type : sortedTypes.sort(types)) {
    auto super = type.getDeclaredSuperType();
    if (super && includedTypes.count(*super)) {
      // We must already have a partition for the supertype we can add to.
      auto index = partitionIndices.at(*super);
      partitions[index].push_back(type);
      partitionIndices[type] = index;
    } else {
      // This is a new root type. Create a new partition.
      auto index = partitions.size();
      partitions.push_back({type});
      partitionIndices[type] = index;
    }
  }
  return partitions;
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
      succs.push_back(getMerged(child));
    }
  }
  return {type, std::move(succs)};
}

void TypeMerging::applyMerges() {
  if (merges.empty()) {
    return;
  }

  // Flatten merges, which might be an arbitrary tree at this point.
  for (auto [type, _] : merges) {
    merges[type] = getMerged(type);
  }

  // We found things to optimize! Rewrite types in the module to apply those
  // changes.
  TypeMapper(*module, merges).map();
}

bool shapeEq(HeapType a, HeapType b) {
  // Check whether `a` and `b` have the same top-level structure, including the
  // position and identity of any children that are not included as transitions
  // in the DFA, i.e. any children that are not nontrivial references.
  if (a.isOpen() != b.isOpen()) {
    return false;
  }
  if (a.isShared() != b.isShared()) {
    return false;
  }
  auto aKind = a.getKind();
  auto bKind = b.getKind();
  if (aKind != bKind) {
    return false;
  }
  switch (aKind) {
    case HeapTypeKind::Func:
      return shapeEq(a.getSignature(), b.getSignature());
    case HeapTypeKind::Struct:
      return shapeEq(a.getStruct(), b.getStruct());
    case HeapTypeKind::Array:
      return shapeEq(a.getArray(), b.getArray());
    case HeapTypeKind::Cont:
      WASM_UNREACHABLE("TODO: cont");
    case HeapTypeKind::Basic:
      WASM_UNREACHABLE("unexpected kind");
  }
  return false;
}

size_t shapeHash(HeapType a) {
  size_t digest = hash(a.isOpen());
  rehash(digest, a.isShared());
  auto kind = a.getKind();
  rehash(digest, kind);
  switch (kind) {
    case HeapTypeKind::Func:
      hash_combine(digest, shapeHash(a.getSignature()));
      return digest;
    case HeapTypeKind::Struct:
      hash_combine(digest, shapeHash(a.getStruct()));
      return digest;
    case HeapTypeKind::Array:
      hash_combine(digest, shapeHash(a.getArray()));
      return digest;
    case HeapTypeKind::Cont:
      WASM_UNREACHABLE("TODO: cont");
    case HeapTypeKind::Basic:
      break;
  }
  WASM_UNREACHABLE("unexpected kind");
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
  if (a.size() != b.size()) {
    return false;
  }
  for (size_t i = 0; i < a.size(); ++i) {
    if (!shapeEq(a[i], b[i])) {
      return false;
    }
  }
  return true;
}

size_t shapeHash(const Tuple& a) {
  auto digest = hash(a.size());
  for (auto type : a) {
    hash_combine(digest, shapeHash(type));
  }
  return digest;
}

} // anonymous namespace

Pass* createTypeMergingPass() { return new TypeMerging(); }

} // namespace wasm
