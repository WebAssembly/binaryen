/*
 * Copyright 2024 WebAssembly Community Group participants
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

// Split types into minimal recursion groups by computing the strongly connected
// components of the type graph, which are the minimal sets of
// mutually-recursive types that must be in the same recursion group with each
// other for the type section to validate.
//
// We must additionally ensure that distinct types remain distinct, which would
// not be the case if we allowed two separate strongly connected components with
// the same shape to be rewritten to two copies of the same recursion group.
// Accidentally merging types would be incorrect because it would change the
// behavior of casts that would have previously been able to differentiate the
// types.
//
// When multiple strongly connected components have the same shape, first try to
// differentiate them by permuting their types, which keeps the sizes of the rec
// groups as small as possible. When there are more strongly connected
// components that are permutations of one another than there are distinct
// permutations, fall back to keeping the types distinct by adding distinct
// brand types to the recursion groups to ensure they have different shapes.

#include "ir/module-utils.h"
#include "ir/type-updating.h"
#include "pass.h"
#include "support/disjoint_sets.h"
#include "support/strongly_connected_components.h"
#include "support/topological_orders.h"
#include "wasm-type-shape.h"
#include "wasm.h"

namespace wasm {

namespace {

// Compute the strongly connected components of the private types, being sure to
// only consider edges to other private types.
struct TypeSCCs
  : SCCs<typename std::vector<HeapType>::const_iterator, TypeSCCs> {
  std::unordered_set<HeapType> includedTypes;
  TypeSCCs(const std::vector<HeapType>& types)
    : SCCs(types.begin(), types.end()),
      includedTypes(types.cbegin(), types.cend()) {}
  void pushChildren(HeapType parent) {
    for (auto child : parent.getReferencedHeapTypes()) {
      if (includedTypes.count(child)) {
        push(child);
      }
    }
  }
};

// After all their distinct permutations have been used, different groups with
// the same shapes must be differentiated by adding in a "brand" type. Even with
// a brand mixed in, we might run out of permutations, in which case we need a
// new brand type. This iterator provides an infinite sequence of possible brand
// types, prioritizing those with the most compact encoding.
struct BrandTypeIterator {
  static constexpr size_t optionCount = 18;
  static std::array<Field, optionCount> fieldOptions;
  static void initFieldOptions();

  struct FieldInfo {
    uint8_t index = 0;
    bool immutable = false;

    operator Field() const {
      auto field = fieldOptions[index];
      if (immutable) {
        field.mutable_ = Immutable;
      }
      return field;
    }

    bool advance() {
      if (!immutable) {
        immutable = true;
        return true;
      }
      immutable = false;
      index = (index + 1) % optionCount;
      return index != 0;
    }
  };

  bool useArray;
  std::vector<FieldInfo> fields;

  HeapType operator*() const {
    if (useArray) {
      return Array(fields[0]);
    }
    return Struct(std::vector<Field>(fields.begin(), fields.end()));
  }

  BrandTypeIterator& operator++() {
    for (size_t i = fields.size(); i > 0; --i) {
      if (fields[i - 1].advance()) {
        return *this;
      }
    }
    if (useArray) {
      useArray = false;
      return *this;
    }
    fields.emplace_back();
    useArray = fields.size() == 1;
    return *this;
  }
};

// Create an adjacency list with edges from supertype to subtypes.
std::vector<std::vector<size_t>>
createSubtypeGraph(const std::vector<HeapType>& types) {
  std::unordered_map<HeapType, size_t> indices;
  for (auto type : types) {
    indices.insert({type, indices.size()});
  }

  std::vector<std::vector<size_t>> subtypeGraph(types.size());
  for (size_t i = 0; i < types.size(); ++i) {
    if (auto super = types[i].getDeclaredSuperType()) {
      if (auto it = indices.find(*super); it != indices.end()) {
        subtypeGraph[it->second].push_back(i);
      }
    }
  }
  return subtypeGraph;
}

struct RecGroupInfo;

// As we iterate through the strongly connected components, we may find
// components that have the same shape. When we find such a collision, we merge
// the components into a single equivalence class where we track how we have
// disambiguated all such isomorphic components.
struct GroupClassInfo {
  // If the group has just a single type, record it so we can make sure the
  // brand is not identical to it.
  std::optional<HeapType> singletonType;
  // If we have gone through all the permutations of this group, we need to add
  // a brand type to continue differentiating different groups in the class.
  std::optional<BrandTypeIterator> brand;
  // An adjacency list giving edges from supertypes to subtypes within the
  // group, using indices into the (non-materialized) canonical shape of this
  // group, offset by 1 iff there is a brand type. Used to ensure that we only
  // find emit permutations that respect the constraint that supertypes must be
  // ordered before subtypes.
  std::vector<std::vector<size_t>> subtypeGraph;
  // A generator of valid permutations of the components in this class.
  TopologicalOrders orders;

  // Initialize `subtypeGraph` and `orders` based on the canonical ordering
  // encoded by the group and permutation in `info`.
  static std::vector<std::vector<size_t>> initSubtypeGraph(RecGroupInfo& info);
  GroupClassInfo(RecGroupInfo& info);

  void advance() {
    ++orders;
    if (orders == orders.end()) {
      advanceBrand();
    }
  }

  void advanceBrand() {
    if (brand) {
      ++*brand;
    } else {
      brand.emplace();
      // Make room in the subtype graph for the brand type, which goes at the
      // beginning of the canonical order.
      subtypeGraph.insert(subtypeGraph.begin(), {{}});
      // Adjust indices.
      for (size_t i = 1; i < subtypeGraph.size(); ++i) {
        for (auto& edge : subtypeGraph[i]) {
          ++edge;
        }
      }
    }
    // Make sure the brand is not the same as the real type.
    if (singletonType &&
        RecGroupShape({**brand}) == RecGroupShape({*singletonType})) {
      ++*brand;
    }
    // The brand type must be distinct from
    // Start back at the initial order with the new brand.
    orders.~TopologicalOrders();
    new (&orders) TopologicalOrders(subtypeGraph);
  }

  void permute(RecGroupInfo&);
};

// The information we keep for each produced rec group.
struct RecGroupInfo {
  // The sequence of input types to be rewritten into this output group.
  std::vector<HeapType> group;
  // The permutation of the canonical shape for this group's class used to
  // arrive at this group's shape. Used when we later find another strongly
  // connected component with this shape to apply the inverse permutation and
  // get that other component's types into the canonical shape before using a
  // fresh permutation to re-shuffle them into their final shape. Only set for
  // groups belonging to nontrivial equivalence classes.
  std::vector<size_t> permutation;
  // Does this group include a brand type that does not correspond to a type in
  // the original module?
  bool hasBrand = false;
  // This group may be the representative group for its nontrival equivalence
  // class, in which case it holds the necessary extra information used to add
  // new groups to the class.
  std::optional<GroupClassInfo> classInfo;
};

std::vector<std::vector<size_t>>
GroupClassInfo::initSubtypeGraph(RecGroupInfo& info) {
  assert(!info.classInfo);
  assert(info.permutation.size() == info.group.size());

  std::vector<HeapType> canonical(info.group.size());
  for (size_t i = 0; i < info.group.size(); ++i) {
    canonical[info.permutation[i]] = info.group[i];
  }

  return createSubtypeGraph(canonical);
}

GroupClassInfo::GroupClassInfo(RecGroupInfo& info)
  : singletonType(info.group.size() == 1
                    ? std::optional<HeapType>(info.group[0])
                    : std::nullopt),
    brand(std::nullopt), subtypeGraph(initSubtypeGraph(info)),
    orders(subtypeGraph) {}

void GroupClassInfo::permute(RecGroupInfo& info) {
  assert(info.group.size() == info.permutation.size());
  bool insertingBrand = info.group.size() < subtypeGraph.size();
  // First, un-permute the group to get back to the canonical order, offset by 1
  // if we are newly inserting a brand.
  std::vector<HeapType> canonical(info.group.size() + insertingBrand);
  for (size_t i = 0; i < info.group.size(); ++i) {
    canonical[info.permutation[i] + insertingBrand] = info.group[i];
  }
  // Update the brand.
  if (brand) {
    canonical[0] = **brand;
  }
  if (insertingBrand) {
    info.group.resize(info.group.size() + 1);
    info.hasBrand = true;
  }
  // Finally, re-permute with the new permutation..
  info.permutation = *orders;
  for (size_t i = 0; i < info.group.size(); ++i) {
    info.group[i] = canonical[info.permutation[i]];
  }
}

std::array<Field, BrandTypeIterator::optionCount>
  BrandTypeIterator::fieldOptions = {{}};

void BrandTypeIterator::initFieldOptions() {
  BrandTypeIterator::fieldOptions = {{
    Field(Field::i8, Mutable),
    Field(Field::i16, Mutable),
    Field(Type::i32, Mutable),
    Field(Type::i64, Mutable),
    Field(Type::f32, Mutable),
    Field(Type::f64, Mutable),
    Field(Type(HeapType::any, Nullable), Mutable),
    Field(Type(HeapType::func, Nullable), Mutable),
    Field(Type(HeapType::ext, Nullable), Mutable),
    Field(Type(HeapType::none, Nullable), Mutable),
    Field(Type(HeapType::nofunc, Nullable), Mutable),
    Field(Type(HeapType::noext, Nullable), Mutable),
    Field(Type(HeapType::any, NonNullable), Mutable),
    Field(Type(HeapType::func, NonNullable), Mutable),
    Field(Type(HeapType::ext, NonNullable), Mutable),
    Field(Type(HeapType::none, NonNullable), Mutable),
    Field(Type(HeapType::nofunc, NonNullable), Mutable),
    Field(Type(HeapType::noext, NonNullable), Mutable),
  }};
}

struct MinimizeRecGroups : Pass {
  // The types we are optimizing and their indices in this list.
  std::vector<HeapType> types;

  // A global ordering on all types, including public types. Used to define a
  // total ordering on rec group shapes.
  std::unordered_map<HeapType, size_t> typeIndices;

  // As we process strongly connected components, we will construct output
  // recursion groups here.
  std::vector<RecGroupInfo> groups;

  // For each shape of rec group we have created, its index in `groups`.
  std::unordered_map<RecGroupShape, size_t> groupShapeIndices;

  // When we find that two groups are isomorphic to (i.e. permutations of)
  // each other, we combine their equivalence classes and choose a new class
  // representative to use to disambiguate the groups.
  DisjointSets equivalenceClasses;

  void run(Module* module) override {
    // There are no recursion groups to minimize if GC is not enabled.
    if (!module->features.hasGC()) {
      return;
    }

    initBrandOptions();

    types = ModuleUtils::getPrivateHeapTypes(*module);
    for (auto type : ModuleUtils::collectHeapTypes(*module)) {
      typeIndices.insert({type, typeIndices.size()});
    }

    // The number of types to optimize is an upper bound on the number of
    // recursion groups we will emit.
    groups.reserve(types.size());

    // Compute the strongly connected components and ensure they form distinct
    // recursion groups.
    for (auto scc : TypeSCCs(types)) {
      [[maybe_unused]] size_t index = equivalenceClasses.addSet();
      assert(index == groups.size());
      groups.emplace_back();

      // The SCC is not necessarily topologically sorted to have the supertypes
      // come first. Fix that.
      std::vector<HeapType> sccTypes(scc.begin(), scc.end());
      auto deps = createSubtypeGraph(sccTypes);
      auto permutation = *TopologicalOrders(deps).begin();
      groups.back().group.resize(sccTypes.size());
      for (size_t i = 0; i < sccTypes.size(); ++i) {
        groups.back().group[i] = sccTypes[permutation[i]];
      }
      updateShape(index);
    }

    rewriteTypes(*module);
  }

  void initBrandOptions() {
    // Initialize the field options for brand types lazily here to avoid
    // depending on global constructor ordering.
    [[maybe_unused]] static bool fieldsInitialized = []() {
      BrandTypeIterator::initFieldOptions();
      return true;
    }();
  }

  void updateShape(size_t group) {
    auto [it, inserted] =
      groupShapeIndices.insert({RecGroupShape(groups[group].group), group});
    if (inserted) {
      // This shape was unique. We're done.
      return;
    }

    // We have a conflict. There are four possibilities:
    //
    //   1. We are trying to insert the next permutation of an existing
    //      equivalence class and have found that...
    //
    //     A. The next permutation is an automorphism of some previous
    //        permutation of the same equivalence class.
    //
    //     B. The next permutation is equivalent some other existing group shape
    //        not yet included in the equivalence class.
    //
    //   2. We are inserting a new group shape as of yet unaffiliated with a
    //      nontrival equivalence class and have found that...
    //
    //     A. It is the same shape as some group in an existing nontrival
    //        equivalence class.
    //
    //     B. It is the same shape as some other group also not yet affiliated
    //        with a nontrival equivalence class, so we have a new nontrivial
    //        equivalence class.
    //
    // These four possibilities are handled in order below.

    size_t other = it->second;

    auto& groupInfo = groups[group];
    auto& otherInfo = groups[other];

    // Case 1A: There is an automorphism. Skip the rest of the permutations,
    // which will also be automorphic to previous permutations.
    size_t groupRep = equivalenceClasses.getRoot(group);
    size_t otherRep = equivalenceClasses.getRoot(other);
    if (groupRep == otherRep) {
      assert(groups[groupRep].classInfo);
      auto& classInfo = *groups[groupRep].classInfo;

      // Move to the next permutation after advancing the type brand to skip
      // further automorphisms.
      classInfo.advanceBrand();
      classInfo.permute(groupInfo);

      updateShape(group);
      return;
    }

    // It is impossible by construction for both equivalence classes to be
    // nontrivial since we canonicalize groups when an equivalence is first
    // found. If the classes were equivalent, the groups in the second class
    // would have already been added to the first class when the second class
    // would otherwise have been formed.
    assert((!groups[groupRep].classInfo && groupRep == group) ||
           (!groups[otherRep].classInfo && otherRep == other));

    // Case 1B: We have permuted ourselves into equivalence with some other
    // group unaffiliated with a nontrivial equivalence class. Bring that other
    // group into our equivalence class and try the next permutation instead.
    if (groups[groupRep].classInfo) {
      auto& classInfo = *groups[groupRep].classInfo;

      [[maybe_unused]] size_t unionRep =
        equivalenceClasses.getUnion(groupRep, otherRep);
      assert(groupRep == unionRep);

      // `other` must have the same permutation as `group` because they have the
      // same shape. Advance `group` to the next permutation.
      otherInfo.classInfo = std::nullopt;
      otherInfo.permutation = groupInfo.permutation;
      classInfo.advance();
      classInfo.permute(groupInfo);

      updateShape(group);
      return;
    }

    // Case 2A: This shape is already found in an existing nontrivial
    // equivalence class. Join the class and try the next permutation.
    if (groups[otherRep].classInfo) {
      auto& classInfo = *groups[otherRep].classInfo;

      [[maybe_unused]] size_t unionRep =
        equivalenceClasses.getUnion(otherRep, groupRep);
      assert(otherRep == unionRep);

      // Since we matched shapes with `other`, unapplying its permutation gets
      // us back to the canonical shape, from which we can apply a fresh
      // permutation.
      groupInfo.classInfo = std::nullopt;
      groupInfo.permutation = otherInfo.permutation;
      classInfo.advance();
      classInfo.permute(groupInfo);

      updateShape(group);
      return;
    }

    // Case 2B: We need to join two matching unaffiliated groups into a new
    // nontrivial equivalence class.
    assert(!groups[groupRep].classInfo && !groups[otherRep].classInfo);
    assert(group == groupRep && other == otherRep);

    // We are canonicalizing and reinserting the shape for other, so remove it
    // from the map under its current shape.
    groupShapeIndices.erase(it);

    // Put the types for both groups in to the canonical order.
    auto permutation = getCanonicalPermutation(groupInfo.group);
    groupInfo.permutation = otherInfo.permutation = std::move(permutation);

    // Set up `other` to be the representative element of the equivalence class.
    otherInfo.classInfo.emplace(otherInfo);
    auto& classInfo = *otherInfo.classInfo;

    // Update both groups to have the initial valid order. Their shapes still
    // match.
    classInfo.permute(otherInfo);
    classInfo.permute(groupInfo);

    // Insert `other` with its new shape. It may end up being joined to another
    // existing equivalence class, in which case its class info will be cleared
    // and `group` will subsequently be added to that same existing class, or
    // alternatively it may be inserted as the representative element of a new
    // class to which `group` will subsequently be joined.
    updateShape(other);
    updateShape(group);
  }

  std::vector<size_t>
  getCanonicalPermutation(const std::vector<HeapType>& types) {
    // The correctness of this part depends on some interesting properties of
    // strongly connected graphs with ordered, directed edges. A permutation of
    // the vertices in a graph is an isomorphism that produces an isomorphic
    // graph. An automorphism is an isomorphism of a structure onto itself, so
    // an automorphism of a graph is a permutation of the vertices that does not
    // change the graph. Permutations can be described in terms of sets of
    // cycles of elements.
    //
    // Theorem 1: All cycles in an automorphism of an SCC are the same size.
    //
    //     Proof: By contradiction. Assume there are two cycles of different
    //     sizes. Because the SCC is fully connected, there is a path from an
    //     element in the smaller of these cycles to an element in the larger.
    //     This path must contain an edge between two edges in cycles of
    //     different sizes N and M such that N < M. Apply the automorphism N
    //     times. The source of this edge has been cycled back to its original
    //     index, but the destination is not yet back at its original index, so
    //     the edge's destination index is different from its original
    //     destination index and the permutation we applied was not an
    //     automorphism after all.
    //
    // Corollary 1.1: No nontrivial automorphism of an SCC may have a stationary
    // element, since either all the cycles have size 1 and the automorphism is
    // trivial or all the cycles have some other size and there are no
    // stationary elements.
    //
    // Corollary 1.2: All orderings with the same first element are distinct
    // since no nontrivial automorphism can keep the first element stationary.
    //
    // Theorem 2: Graphs with initial elements that are not in an automorphism
    // cycle with each other are not automorphic.
    //
    //     Proof: By contradiction. Assume two such orderings are automorphic.
    //     Then their initial elements must be in the same automorphism cycle
    //     because they occupy the same index in two automorphic orderings.
    //
    // Find a canonical ordering of the types in this group. The ordering must
    // be independent of the initial order of the types. To do so, consider the
    // orderings given by visitation order on a tree search rooted at each type
    // in the group. Since the group is strongly connected, a tree search from
    // any of types will visit all types in the group, so it will generate a
    // total and deterministic ordering of the types in the group. We can
    // compare the structures of each of these orderings to organize the root
    // types and their generated orderings into ordered equivalence classes.
    // These equivalence classes each correspond to a cycle in an automorphism
    // of the graph because their elements are vertices that can all occupy the
    // initial index of the graph without the graph structure changing. We can
    // choose an arbitrary ordering from the least equivalent class as a
    // canonical ordering because all orderings in that class describe the same
    // graph.
    //
    // Compute the orderings generated by DFS on each type.
    std::unordered_set<HeapType> typeSet(types.begin(), types.end());
    std::vector<std::vector<HeapType>> dfsOrders(types.size());
    for (size_t i = 0; i < types.size(); ++i) {
      dfsOrders[i].reserve(types.size());
      std::vector<HeapType> workList;
      workList.push_back(types[i]);
      std::unordered_set<HeapType> seen;
      while (!workList.empty()) {
        auto curr = workList.back();
        workList.pop_back();
        if (!typeSet.count(curr)) {
          continue;
        }
        if (seen.insert(curr).second) {
          dfsOrders[i].push_back(curr);
          auto children = curr.getReferencedHeapTypes();
          workList.insert(workList.end(), children.rbegin(), children.rend());
        }
      }
      assert(dfsOrders[i].size() == types.size());
    }

    // Organize the orders into equivalence classes, mapping equivalent shapes
    // to lists of automorphic types.
    std::map<ComparableRecGroupShape, std::vector<HeapType>> typeClasses;
    for (const auto& order : dfsOrders) {
      ComparableRecGroupShape shape(order, [this](HeapType a, HeapType b) {
        return this->typeIndices.at(a) < this->typeIndices.at(b);
      });
      typeClasses[shape].push_back(order[0]);
    }

    // Choose the canonical ordering.
    const auto& leastOrder = typeClasses.begin()->first.types;

    // We want our canonical ordering to have the additional property that it
    // contains with one type from each equivalence class before a second type
    // of any equivalence class. Since our utility for enumerating the
    // topological sorts of the canonical order keeps the initial element fixed
    // as long as possible before moving to the next one, by Corollary 1.2 and
    // Theorem 2 above, this will maximize the number of distinct graphs it
    // emits before starting to emit automorphisms of previously emitted graphs.
    // Since all the type equivalence classes are the same size by Theorem 1, we
    // can assemble the final order by striping across the equivalence classes.
    // We determine the order of types taken from each equivalence class by
    // sorting them by order of appearance in the least order, which ensures the
    // final order remains independent of the initial order.
    std::unordered_map<HeapType, size_t> indexInLeastOrder;
    for (auto type : leastOrder) {
      indexInLeastOrder.insert({type, indexInLeastOrder.size()});
    }
    auto classSize = typeClasses.begin()->second.size();
    for (auto& [shape, members] : typeClasses) {
      assert(members.size() == classSize);
      std::sort(members.begin(), members.end(), [&](HeapType a, HeapType b) {
        return indexInLeastOrder.at(a) < indexInLeastOrder.at(b);
      });
    }
    std::vector<HeapType> finalOrder;
    finalOrder.reserve(types.size());
    for (size_t i = 0; i < classSize; ++i) {
      for (auto& [shape, members] : typeClasses) {
        finalOrder.push_back(members[i]);
      }
    }

    // Now what we actually want is the permutation that takes us from the final
    // canonical order to the original order of the types.
    std::unordered_map<HeapType, size_t> indexInFinalOrder;
    for (auto type : finalOrder) {
      indexInFinalOrder.insert({type, indexInFinalOrder.size()});
    }
    std::vector<size_t> permutation;
    permutation.reserve(types.size());
    for (auto type : types) {
      permutation.push_back(indexInFinalOrder.at(type));
    }
    return permutation;
  }

  void rewriteTypes(Module& wasm) {
    // Map types to indices in the builder.
    std::unordered_map<HeapType, size_t> outputIndices;
    size_t i = 0;
    for (const auto& group : groups) {
      for (size_t j = 0; j < group.group.size(); ++j) {
        // Skip the brand if it exists.
        if (!group.hasBrand || group.permutation[j] != 0) {
          outputIndices.insert({group.group[j], i});
        }
        ++i;
      }
    }

    // Build the types.
    TypeBuilder builder(i);
    i = 0;
    for (const auto& group : groups) {
      builder.createRecGroup(i, group.group.size());
      for (auto type : group.group) {
        builder[i++].copy(type, [&](HeapType ht) -> HeapType {
          if (auto it = outputIndices.find(ht); it != outputIndices.end()) {
            return builder[it->second];
          }
          return ht;
        });
      }
    }
    auto built = builder.build();
    assert(built);
    auto newTypes = *built;

    // Replace the types in the module.
    std::unordered_map<HeapType, HeapType> oldToNew;
    i = 0;
    for (const auto& group : groups) {
      for (size_t j = 0; j < group.group.size(); ++j) {
        // Skip the brand again if it exists.
        if (!group.hasBrand || group.permutation[j] != 0) {
          oldToNew[group.group[j]] = newTypes[i];
        }
        ++i;
      }
    }
    GlobalTypeRewriter rewriter(wasm);
    rewriter.mapTypes(oldToNew);
    rewriter.mapTypeNames(oldToNew);
  }
};

} // anonymous namespace

Pass* createMinimizeRecGroupsPass() {
  return new MinimizeRecGroups();
}

} // namespace wasm
