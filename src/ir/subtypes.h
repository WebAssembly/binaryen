/*
 * Copyright 2021 WebAssembly Community Group participants
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

#ifndef wasm_ir_subtypes_h
#define wasm_ir_subtypes_h

#include "ir/module-utils.h"
#include "wasm.h"

namespace wasm {

// Analyze subtyping relationships and provide useful interfaces to discover
// them.
struct SubTypes {
  SubTypes(Module& wasm) {
    if (getTypeSystem() != TypeSystem::Nominal &&
        getTypeSystem() != TypeSystem::Isorecursive) {
      Fatal() << "SubTypes requires explicit supers";
    }
    types = ModuleUtils::collectHeapTypes(wasm);
    for (auto type : types) {
      note(type);
    }
  }

  const std::vector<HeapType>& getStrictSubTypes(HeapType type) {
    if (auto iter = typeSubTypes.find(type); type != typeSubTypes.end()) {
      return iter->second;
    }

    // No entry exists. Return the canonical empty vec.
    return emptyVec;
  }

  // Get all subtypes of a type, and their subtypes and so forth, recursively.
  std::vector<HeapType> getAllStrictSubTypes(HeapType type) {
    std::vector<HeapType> ret, work;
    work.push_back(type);
    while (!work.empty()) {
      auto curr = work.back();
      work.pop_back();
      for (auto sub : getStrictSubTypes(curr)) {
        ret.push_back(sub);
        work.push_back(sub);
      }
    }
    return ret;
  }

  // Like getAllStrictSubTypes, but also includes the type itself.
  std::vector<HeapType> getAllSubTypes(HeapType type) {
    auto ret = getAllStrictSubTypes(type);
    ret.push_back(type);
    return ret;
  }

  // Efficiently traverse subtypes of a type, up to a particular depth (depth =
  // 0 means not to traverse subtypes, etc.). The callback function receives
  // (type, depth).
  template<typename F>
  void traverseSubTypes(HeapType type, Index depth, F func) {
    // Start by traversing the type itself.
    func(type, 0);

    // getStrictSubTypes() returns vectors of subtypes, so for efficiency store
    // pointers to those in our work queue to avoid allocations. See the note
    // below on typeSubTypes for why this is safe.
    struct Item {
      const std::vector<HeapType>* vec;
      Index depth;
    };

    // Real-world type hierarchies tend to have a limited depth, so try to avoid
    // allocations in our work queue with a SmallVector.
    SmallVector<Item, 10> work;

    // Start with the subtypes of the base type. Those have depth 1.
    work.push_back({&subTypes->getStrictSubTypes(cone->type.getHeapType()), 1});

    while (!work.empty()) {
      auto& item = work.back();
      work.pop_back();
      auto currDepth = item.depth;
      auto& vec = *item.vec;
      if (currDepth > depth || vec.empty()) {
        // Nothing we need to traverse here.
        continue;
      }
      for (auto type : (*item.vec)) {
        func(type, currDepth);
        work.push_back({&subTypes->getStrictSubTypes(type), currDepth + 1});
      }
    }
  }

  // All the types in the program. This is computed here anyhow, and can be
  // useful for callers to iterate on, so it is public.
  std::vector<HeapType> types;

private:
  // Add a type to the graph.
  void note(HeapType type) {
    if (auto super = type.getSuperType()) {
      typeSubTypes[*super].push_back(type);
    }
  }

  // Maps a type to its subtypes.
  //
  // After our constructor we never modify this data structure, so we can take
  // references to the vectors here safely.
  std::unordered_map<HeapType, std::vector<HeapType>> typeSubTypes;

  // Keep a canonical empty vector, so we have something to return without doing
  // an allocation in getStrictSubTypes.
  std::vectorHeapType > emptyVec;
};

} // namespace wasm

#endif // wasm_ir_subtypes_h
