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
//
// This only scans user types, and not basic types like HeapType::eq.
struct SubTypes {
  SubTypes(const std::vector<HeapType>& types) : types(types) {
    if (getTypeSystem() != TypeSystem::Nominal &&
        getTypeSystem() != TypeSystem::Isorecursive) {
      Fatal() << "SubTypes requires explicit supers";
    }
    for (auto type : types) {
      note(type);
    }
  }

  SubTypes(Module& wasm) : SubTypes(ModuleUtils::collectHeapTypes(wasm)) {}

  const std::vector<HeapType>& getStrictSubTypes(HeapType type) {
    assert(!type.isBasic());
    return typeSubTypes[type];
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

  // Computes the depth of children for each type. This is 0 if the type has no
  // subtypes, 1 if it has subtypes but none of those have subtypes themselves,
  // and so forth.
  //
  // This depth ignores bottom types.
  std::unordered_map<HeapType, Index> getMaxDepths() {
    std::unordered_map<HeapType, Index> depths;

    // Begin with depth 0.
    for (auto type : types) {
      depths[type] = 0;
    }

    // Begin with a plan to work on all the types. When we visit an item, we'll
    // update our super type based on our current depth.
    std::unordered_set<HeapType> work(types.begin(), types.end());

    while (!work.empty()) {
      auto iter = work.begin();
      auto type = *iter;
      work.erase(iter);
      if (auto super = type.getSuperType()) {
        auto depth = depths[type];
        auto& superDepth = depths[*super];
        if (depth + 1 >= superDepth) {
          superDepth = depth + 1;
          work.insert(*super);
        }
      }
    }

    // Add the max depths of basic types.
    // TODO: update when we get structtype and arraytype
    for (auto type : types) {
      HeapType basic = type.isData() ? HeapType::data : HeapType::func;
      depths[basic] = std::max(depths[basic], depths[type] + 1);
    }

    depths[HeapType::eq] = std::max(Index(1), depths[HeapType::data] + 1);
    depths[HeapType::any] = depths[HeapType::eq] + 1;

    return depths;
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
  std::unordered_map<HeapType, std::vector<HeapType>> typeSubTypes;
};

} // namespace wasm

#endif // wasm_ir_subtypes_h
