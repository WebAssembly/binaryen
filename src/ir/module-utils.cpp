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
        counts.note(*super);
      }
    }
  }

  return counts;
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

IndexedHeapTypes getIndexedHeapTypes(Module& wasm) {
  Counts counts = getHeapTypeCounts(wasm);
  IndexedHeapTypes indexedTypes;
  Index i = 0;
  for (auto& [type, _] : counts) {
    indexedTypes.types.push_back(type);
    indexedTypes.indices[type] = i++;
  }
  return indexedTypes;
}

IndexedHeapTypes getOptimizedIndexedHeapTypes(Module& wasm) {
  Counts counts = getHeapTypeCounts(wasm);

  // Sort by frequency and then original insertion order.
  std::vector<std::pair<HeapType, size_t>> sorted(counts.begin(), counts.end());
  std::stable_sort(sorted.begin(), sorted.end(), [&](auto a, auto b) {
    return a.second > b.second;
  });

  // Collect the results.
  IndexedHeapTypes indexedTypes;
  for (Index i = 0; i < sorted.size(); ++i) {
    HeapType type = sorted[i].first;
    indexedTypes.types.push_back(type);
    indexedTypes.indices[type] = i;
  }
  return indexedTypes;
}

} // namespace wasm::ModuleUtils
