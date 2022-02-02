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
  // Ensure a type is included without increasing its count.
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

// A utility data structure for performing topological sorts. The elements to be
// sorted should all be `push`ed to the stack, then while the stack is not
// empty, predecessors of the top element should be pushed. On each iteration,
// if the top of the stack is unchanged after pushing all the predecessors, that
// means the predecessors have all been finished so the current element is
// finished as well and should be popped.
template<typename T> struct TopologicalSortStack {
  std::list<T> workStack;
  // Map items to their locations in the work stack so that we can make sure
  // each appears and is finished only once.
  std::unordered_map<T, typename std::list<T>::iterator> locations;
  // Remember which items we have finished so we don't visit them again.
  std::unordered_set<T> finished;

  bool empty() const { return workStack.empty(); }

  void push(T item) {
    if (finished.count(item)) {
      return;
    }
    workStack.push_back(item);
    auto newLocation = std::prev(workStack.end());
    auto [it, inserted] = locations.insert({item, newLocation});
    if (!inserted) {
      // Remove the previous iteration of the pushed item and update its
      // location.
      workStack.erase(it->second);
      it->second = newLocation;
    }
  }

  T& peek() { return workStack.back(); }

  void pop() {
    finished.insert(workStack.back());
    locations.erase(workStack.back());
    workStack.pop_back();
  }
};

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

  // Isorecursive types have to be arranged into topologically ordered recursion
  // groups. Sort the groups by average use count among their members so that
  // the topological sort will place frequently used types first.
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
      return index < other.index;
    }
  };

  std::unordered_map<RecGroup, GroupInfo> groupInfos;
  for (auto& [type, _] : counts) {
    RecGroup group = type.getRecGroup();
    // Try to initialize a new info or get the existing info.
    auto& info = groupInfos.insert({group, {groupInfos.size()}}).first->second;
    // Update the reference count.
    info.useCount += counts.at(type);
    // Collect predecessor groups.
    for (auto child : type.getReferencedHeapTypes()) {
      if (!child.isBasic()) {
        RecGroup otherGroup = child.getRecGroup();
        if (otherGroup != group) {
          info.preds.insert(otherGroup);
        }
      }
    }
  }

  // Fix up the use counts to be averages to ensure groups are used comensurate
  // with the amount of index space they occupy.
  for (auto& [group, info] : groupInfos) {
    info.useCount /= group.size();
  }

  // Sort the preds of each group by increasing use count so the topological
  // sort visits the most used first. Break ties with the group's appearance
  // index to ensure determinism.
  auto sortGroups = [&](std::vector<RecGroup>& groups) {
    std::sort(groups.begin(), groups.end(), [&](auto& a, auto& b) {
      return groupInfos.at(a) < groupInfos.at(b);
    });
  };
  for (auto& [group, info] : groupInfos) {
    info.sortedPreds.insert(
      info.sortedPreds.end(), info.preds.begin(), info.preds.end());
    sortGroups(info.sortedPreds);
    info.preds.clear();
  }

  // Sort all the groups so the topological sort visits the most used first.
  std::vector<RecGroup> sortedGroups;
  sortedGroups.reserve(groupInfos.size());
  for (auto& [group, _] : groupInfos) {
    sortedGroups.push_back(group);
  }
  sortGroups(sortedGroups);

  // Perform the topological sort.
  TopologicalSortStack<RecGroup> workStack;
  for (auto group : sortedGroups) {
    workStack.push(group);
  }
  sortedGroups.clear();
  while (!workStack.empty()) {
    auto group = workStack.peek();
    for (auto pred : groupInfos.at(group).sortedPreds) {
      workStack.push(pred);
    }
    if (workStack.peek() == group) {
      // All the predecessors are finished, so `group` is too.
      workStack.pop();
      sortedGroups.push_back(group);
    }
  }

  // Collect and return the grouped types.
  IndexedHeapTypes indexedTypes;
  indexedTypes.types.reserve(counts.size());
  for (auto group : sortedGroups) {
    for (auto member : group) {
      indexedTypes.types.push_back(member);
    }
  }
  setIndices(indexedTypes);
  return indexedTypes;
}

} // namespace wasm::ModuleUtils
