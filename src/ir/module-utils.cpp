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

#include "module-utils.h"
#include "support/insert_ordered.h"
#include "support/topological_sort.h"

namespace wasm::ModuleUtils {

namespace {

// Helper for collecting HeapTypes and their frequencies.
struct Counts : public InsertOrderedMap<HeapType, size_t> {
  void note(HeapType type) {
    if (!type.isBasic()) {
      (*this)[type]++;
    }
  }
  void note(Type type) {
    for (HeapType ht : type.getHeapTypeChildren()) {
      note(ht);
    }
  }
  // Ensure a type is included without increasing its count.
  void include(HeapType type) {
    if (!type.isBasic()) {
      (*this)[type];
    }
  }
  void include(Type type) {
    for (HeapType ht : type.getHeapTypeChildren()) {
      include(ht);
    }
  }
};

struct CodeScanner
  : PostWalker<CodeScanner, UnifiedExpressionVisitor<CodeScanner>> {
  Counts& counts;

  CodeScanner(Module& wasm, Counts& counts) : counts(counts) {
    setModule(&wasm);
  }

  void visitExpression(Expression* curr) {
    if (auto* call = curr->dynCast<CallIndirect>()) {
      counts.note(call->heapType);
    } else if (auto* call = curr->dynCast<CallRef>()) {
      counts.note(call->target->type);
    } else if (curr->is<RefNull>()) {
      counts.note(curr->type);
    } else if (curr->is<StructNew>()) {
      counts.note(curr->type);
    } else if (curr->is<ArrayNew>()) {
      counts.note(curr->type);
    } else if (curr->is<ArrayNewSeg>()) {
      counts.note(curr->type);
    } else if (curr->is<ArrayInit>()) {
      counts.note(curr->type);
    } else if (auto* cast = curr->dynCast<RefCast>()) {
      counts.note(cast->intendedType);
    } else if (auto* cast = curr->dynCast<RefTest>()) {
      counts.note(cast->intendedType);
    } else if (auto* cast = curr->dynCast<BrOn>()) {
      if (cast->op == BrOnCast || cast->op == BrOnCastFail) {
        counts.note(cast->intendedType);
      }
    } else if (auto* get = curr->dynCast<StructGet>()) {
      counts.note(get->ref->type);
      // If the type we read is a reference type then we must include it. It is
      // not written in the binary format, so it doesn't need to be counted, but
      // it does need to be taken into account in the IR (this may be the only
      // place this type appears in the entire binary, and we must scan all
      // types as the analyses that use us depend on that).
      counts.include(get->type);
    } else if (auto* set = curr->dynCast<StructSet>()) {
      counts.note(set->ref->type);
    } else if (auto* get = curr->dynCast<ArrayGet>()) {
      counts.note(get->ref->type);
      // See note on StructGet above.
      counts.include(get->type);
    } else if (auto* set = curr->dynCast<ArraySet>()) {
      counts.note(set->ref->type);
    } else if (Properties::isControlFlowStructure(curr)) {
      if (curr->type.isTuple()) {
        // TODO: Allow control flow to have input types as well
        counts.note(Signature(Type::none, curr->type));
      } else {
        counts.note(curr->type);
      }
    }
  }
};

Counts getHeapTypeCounts(Module& wasm) {
  // Collect module-level info.
  Counts counts;
  CodeScanner(wasm, counts).walkModuleCode(&wasm);
  for (auto& curr : wasm.globals) {
    counts.note(curr->type);
  }
  for (auto& curr : wasm.tags) {
    counts.note(curr->sig);
  }
  for (auto& curr : wasm.tables) {
    counts.note(curr->type);
  }
  for (auto& curr : wasm.elementSegments) {
    counts.note(curr->type);
  }

  // Collect info from functions in parallel.
  ModuleUtils::ParallelFunctionAnalysis<Counts, Immutable, InsertOrderedMap>
    analysis(wasm, [&](Function* func, Counts& counts) {
      counts.note(func->type);
      for (auto type : func->vars) {
        counts.note(type);
      }
      if (!func->imported()) {
        CodeScanner(wasm, counts).walk(func->body);
      }
    });

  // Combine the function info with the module info.
  for (auto& [_, functionCounts] : analysis.map) {
    for (auto& [sig, count] : functionCounts) {
      counts[sig] += count;
    }
  }

  // Recursively traverse each reference type, which may have a child type that
  // is itself a reference type. This reflects an appearance in the binary
  // format that is in the type section itself. As we do this we may find more
  // and more types, as nested children of previous ones. Each such type will
  // appear in the type section once, so we just need to visit it once. Also
  // track which recursion groups we've already processed to avoid quadratic
  // behavior when there is a single large group.
  InsertOrderedSet<HeapType> newTypes;
  for (auto& [type, _] : counts) {
    newTypes.insert(type);
  }
  std::unordered_set<RecGroup> includedGroups;
  while (!newTypes.empty()) {
    auto iter = newTypes.begin();
    auto ht = *iter;
    newTypes.erase(iter);
    for (HeapType child : ht.getHeapTypeChildren()) {
      if (!child.isBasic()) {
        if (!counts.count(child)) {
          newTypes.insert(child);
        }
        counts.note(child);
      }
    }

    if (auto super = ht.getSuperType()) {
      if (!counts.count(*super)) {
        newTypes.insert(*super);
        // We should unconditionally count supertypes, but while the type system
        // is in flux, skip counting them to keep the type orderings in nominal
        // test outputs more similar to the orderings in the equirecursive
        // outputs. FIXME
        counts.include(*super);
      }
    }

    // Make sure we've noted the complete recursion group of each type as well.
    auto recGroup = ht.getRecGroup();
    if (includedGroups.insert(recGroup).second) {
      for (auto type : recGroup) {
        if (!counts.count(type)) {
          newTypes.insert(type);
          counts.include(type);
        }
      }
    }
  }

  return counts;
}

void setIndices(IndexedHeapTypes& indexedTypes) {
  for (Index i = 0; i < indexedTypes.types.size(); i++) {
    indexedTypes.indices[indexedTypes.types[i]] = i;
  }
}

} // anonymous namespace

std::vector<HeapType> collectHeapTypes(Module& wasm) {
  Counts counts = getHeapTypeCounts(wasm);
  std::vector<HeapType> types;
  types.reserve(counts.size());
  for (auto& [type, _] : counts) {
    types.push_back(type);
  }
  return types;
}

IndexedHeapTypes getOptimizedIndexedHeapTypes(Module& wasm) {
  TypeSystem system = getTypeSystem();
  Counts counts = getHeapTypeCounts(wasm);

  if (system == TypeSystem::Equirecursive) {
    // Sort by frequency and then original insertion order.
    std::vector<std::pair<HeapType, size_t>> sorted(counts.begin(),
                                                    counts.end());
    std::stable_sort(sorted.begin(), sorted.end(), [&](auto a, auto b) {
      return a.second > b.second;
    });

    // Collect the results.
    IndexedHeapTypes indexedTypes;
    for (Index i = 0; i < sorted.size(); ++i) {
      indexedTypes.types.push_back(sorted[i].first);
    }

    setIndices(indexedTypes);
    return indexedTypes;
  }

  // Types have to be arranged into topologically ordered recursion groups.
  // Under isorecrsive typing, the topological sort has to take all referenced
  // rec groups into account but under nominal typing it only has to take
  // supertypes into account. First, sort the groups by average use count among
  // their members so that the later topological sort will place frequently used
  // types first.
  struct GroupInfo {
    size_t index;
    double useCount = 0;
    std::unordered_set<RecGroup> preds;
    std::vector<RecGroup> sortedPreds;
    GroupInfo(size_t index) : index(index) {}
    bool operator<(const GroupInfo& other) const {
      if (useCount != other.useCount) {
        return useCount < other.useCount;
      }
      return index > other.index;
    }
  };

  struct GroupInfoMap : std::unordered_map<RecGroup, GroupInfo> {
    void sort(std::vector<RecGroup>& groups) {
      std::sort(groups.begin(), groups.end(), [&](auto& a, auto& b) {
        return this->at(a) < this->at(b);
      });
    }
  };

  // Collect the information that will be used to sort the recursion groups.
  GroupInfoMap groupInfos;
  for (auto& [type, _] : counts) {
    RecGroup group = type.getRecGroup();
    // Try to initialize a new info or get the existing info.
    auto& info = groupInfos.insert({group, {groupInfos.size()}}).first->second;
    // Update the reference count.
    info.useCount += counts.at(type);
    // Collect predecessor groups.
    switch (system) {
      case TypeSystem::Isorecursive:
        for (auto child : type.getReferencedHeapTypes()) {
          if (!child.isBasic()) {
            RecGroup otherGroup = child.getRecGroup();
            if (otherGroup != group) {
              info.preds.insert(otherGroup);
            }
          }
        }
        break;
      case TypeSystem::Nominal:
        if (auto super = type.getSuperType()) {
          info.preds.insert(super->getRecGroup());
        }
        break;
      case TypeSystem::Equirecursive:
        WASM_UNREACHABLE(
          "Equirecursive types should already have been handled");
    }
  }

  // Fix up the use counts to be averages to ensure groups are used comensurate
  // with the amount of index space they occupy. Skip this for nominal types
  // since their internal group size is always 1.
  if (system != TypeSystem::Nominal) {
    for (auto& [group, info] : groupInfos) {
      info.useCount /= group.size();
    }
  }

  // Sort the predecessors so the most used will be visited first.
  for (auto& [group, info] : groupInfos) {
    info.sortedPreds.insert(
      info.sortedPreds.end(), info.preds.begin(), info.preds.end());
    groupInfos.sort(info.sortedPreds);
    info.preds.clear();
  }

  struct RecGroupSort : TopologicalSort<RecGroup, RecGroupSort> {
    GroupInfoMap& groupInfos;
    RecGroupSort(GroupInfoMap& groupInfos) : groupInfos(groupInfos) {
      // Sort all the groups so the topological sort visits the most used first.
      std::vector<RecGroup> sortedGroups;
      sortedGroups.reserve(groupInfos.size());
      for (auto& [group, _] : groupInfos) {
        sortedGroups.push_back(group);
      }
      groupInfos.sort(sortedGroups);
      for (auto group : sortedGroups) {
        push(group);
      }
    }

    void pushPredecessors(RecGroup group) {
      for (auto pred : groupInfos.at(group).sortedPreds) {
        push(pred);
      }
    }
  };

  // Perform the topological sort and collect the types.
  IndexedHeapTypes indexedTypes;
  indexedTypes.types.reserve(counts.size());
  for (auto group : RecGroupSort(groupInfos)) {
    for (auto member : group) {
      indexedTypes.types.push_back(member);
    }
  }
  setIndices(indexedTypes);
  return indexedTypes;
}

} // namespace wasm::ModuleUtils
