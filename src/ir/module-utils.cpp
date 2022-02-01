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
  void include(HeapType type) {
    if (!type.isBasic()) {
      (*this)[type];
    }
  }
};

Counts getHeapTypeCounts(Module& wasm) {
  struct CodeScanner
    : PostWalker<CodeScanner, UnifiedExpressionVisitor<CodeScanner>> {
    Counts& counts;

    CodeScanner(Module& wasm, Counts& counts) : counts(counts) {
      setModule(&wasm);
    }

    void visitExpression(Expression* curr) {
      if (auto* call = curr->dynCast<CallIndirect>()) {
        counts.note(call->heapType);
      } else if (curr->is<RefNull>()) {
        counts.note(curr->type);
      } else if (curr->is<RttCanon>() || curr->is<RttSub>()) {
        counts.note(curr->type.getRtt().heapType);
      } else if (auto* make = curr->dynCast<StructNew>()) {
        // Some operations emit a HeapType in the binary format, if they are
        // static and not dynamic (if dynamic, the RTT provides the heap type).
        if (!make->rtt && make->type != Type::unreachable) {
          counts.note(make->type.getHeapType());
        }
      } else if (auto* make = curr->dynCast<ArrayNew>()) {
        if (!make->rtt && make->type != Type::unreachable) {
          counts.note(make->type.getHeapType());
        }
      } else if (auto* make = curr->dynCast<ArrayInit>()) {
        if (!make->rtt && make->type != Type::unreachable) {
          counts.note(make->type.getHeapType());
        }
      } else if (auto* cast = curr->dynCast<RefCast>()) {
        if (!cast->rtt && cast->type != Type::unreachable) {
          counts.note(cast->getIntendedType());
        }
      } else if (auto* cast = curr->dynCast<RefTest>()) {
        if (!cast->rtt && cast->type != Type::unreachable) {
          counts.note(cast->getIntendedType());
        }
      } else if (auto* cast = curr->dynCast<BrOn>()) {
        if (cast->op == BrOnCast || cast->op == BrOnCastFail) {
          if (!cast->rtt && cast->type != Type::unreachable) {
            counts.note(cast->getIntendedType());
          }
        }
      } else if (auto* get = curr->dynCast<StructGet>()) {
        counts.note(get->ref->type);
      } else if (auto* set = curr->dynCast<StructSet>()) {
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

  // Collect module-level info.
  Counts counts;
  CodeScanner(wasm, counts).walkModuleCode(&wasm);
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
  ModuleUtils::ParallelFunctionAnalysis<Counts, InsertOrderedMap> analysis(
    wasm, [&](Function* func, Counts& counts) {
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
  // format that is in the type section itself.
  // As we do this we may find more and more types, as nested children of
  // previous ones. Each such type will appear in the type section once, so
  // we just need to visit it once.
  InsertOrderedSet<HeapType> newTypes;
  for (auto& [type, _] : counts) {
    newTypes.insert(type);
  }
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

    // Make sure we've included the complete recursion group of each type.
    auto recGroup = ht.getRecGroup();
    for (auto type : recGroup) {
      if (!counts.count(type)) {
        newTypes.insert(type);
        counts.include(type);
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
  Counts counts = getHeapTypeCounts(wasm);

  if (getTypeSystem() != TypeSystem::Isorecursive) {
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

  // Isorecursive types have more ordering constraints than other types.
  // Specifically, all types in a recursion group must be adjacent, groups must
  // be ordered after other groups they reference, and supertypes must be
  // ordered before their subtypes. We want to order by decreasing reference
  // counts and have a deterministic ordering while respecting those
  // constraints. To do that, we first order recursion groups by:
  //
  //   1. Dependencies between groups
  //   2. Average reference count of group members
  //   3. Original appearance order.
  //
  // We then order the types within each group by:
  //
  //   1. Supertype dependencies
  //   2. Reference count
  //   3. Original group index.

  struct GroupInfo {
    std::unordered_set<RecGroup> predecessors;
    size_t count;
    size_t appearanceIndex;
  };

  InsertOrderedMap<RecGroup, GroupInfo> groupInfos;
  for (auto& [type, _] : counts) {
    RecGroup group = type.getRecGroup();
    // Try to initialize a new info or get the existing info.
    std::pair<const RecGroup, GroupInfo> entry{group,
                                               {{}, 0, groupInfos.size()}};
    auto& info = groupInfos.insert(entry).first->second;
    // Update the reference count.
    info.count += counts.at(type);
    // Collect predecessor groups.
    for (auto child : type.getReferencedHeapTypes()) {
      if (child.isBasic()) {
        continue;
      }
      RecGroup otherGroup = child.getRecGroup();
      if (otherGroup != group) {
        info.predecessors.insert(otherGroup);
      }
    }
  }

  // Fix up the cumulative counts to be an average instead.
  for (auto& [group, info] : groupInfos) {
    info.count /= group.size();
  }

  // Fix up the predecessors to include the transitive predecessors. Since we
  // have a DAG, we can do this efficiently in a bottom-up order using a
  // depth-first search. This is still O(n^2) because O(n) predecessors can
  // be copied into O(n) lists.
  std::unordered_set<RecGroup> finished;
  std::vector<RecGroup> workStack;
  for (auto& [group, _] : groupInfos) {
    workStack.push_back(group);
  }
  while (!workStack.empty()) {
    // Only pop `curr` off the stack when we are finished with it.
    auto curr = workStack.back();
    if (finished.count(curr)) {
      workStack.pop_back();
      continue;
    }
    bool hasUnfinishedPred = false;
    for (auto pred : groupInfos[curr].predecessors) {
      if (!finished.count(pred)) {
        workStack.push_back(pred);
        hasUnfinishedPred = true;
      }
    }
    if (!hasUnfinishedPred) {
      // All direct predecessors updated, so we can update `curr` now.
      auto& predecessors = groupInfos[curr].predecessors;
      std::vector<RecGroup> directPreds(predecessors.begin(),
                                        predecessors.end());
      for (auto pred : directPreds) {
        auto& indirectPreds = groupInfos[pred].predecessors;
        predecessors.insert(indirectPreds.begin(), indirectPreds.end());
      }
      finished.insert(curr);
      workStack.pop_back();
    }
  }

  // Sort the groups by predecessors, average reference count, and original
  // order.
  std::vector<RecGroup> sortedGroups;
  sortedGroups.reserve(groupInfos.size());
  for (auto& [group, _] : groupInfos) {
    sortedGroups.push_back(group);
  }
  std::stable_sort(sortedGroups.begin(),
                   sortedGroups.end(),
                   [&](const RecGroup& a, const RecGroup& b) {
                     if (groupInfos[b].predecessors.count(a)) {
                       return true;
                     } else if (groupInfos[a].predecessors.count(b)) {
                       return false;
                     } else {
                       return groupInfos[a].count > groupInfos[b].count;
                     }
                   });

  // Sort the types within each group by supertype predecessors, reference
  // count, and original order. This can take O(n^2 log n) time because subtype
  // query is linear. TODO: optimize this to O(n log n) time by collecting
  // supertypes.
  std::vector<HeapType> sortedTypes;
  sortedTypes.reserve(counts.size());
  for (auto group : sortedGroups) {
    size_t start = sortedTypes.size();
    sortedTypes.insert(sortedTypes.end(), group.begin(), group.end());
    std::stable_sort(sortedTypes.begin() + start,
                     sortedTypes.end(),
                     [&](const HeapType& a, const HeapType& b) {
                       if (HeapType::isSubType(b, a)) {
                         return true;
                       } else if (HeapType::isSubType(a, b)) {
                         return false;
                       } else {
                         return counts[a] > counts[b];
                       }
                     });
  }

  // Collect the results.
  IndexedHeapTypes indexedTypes;
  indexedTypes.types = std::move(sortedTypes);
  setIndices(indexedTypes);
  return indexedTypes;
}

} // namespace wasm::ModuleUtils
