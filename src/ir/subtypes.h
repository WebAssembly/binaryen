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
    if (getTypeSystem() != TypeSystem::Nominal) {
      Fatal() << "SubTypes requires nominal typing to find supers";
    }
    types = ModuleUtils::collectHeapTypes(wasm);
    for (auto type : types) {
      note(type);
    }
  }

  const std::vector<HeapType>& getSubTypes(HeapType type) {
    return typeSubTypes[type];
  }

  // Like getSubTypes, but also includes the type itself.
  std::vector<HeapType> getSubTypesInclusive(HeapType type) {
    auto ret = getSubTypes(type);
    ret.push_back(type);
    return ret;
  }

  // Get all subtypes of a type, and their subtypes and so forth, recursively.
  std::vector<HeapType> getAllSubTypes(HeapType type) {
    std::vector<HeapType> ret, work;
    work.push_back(type);
    while (!work.empty()) {
      auto curr = work.back();
      work.pop_back();
      for (auto sub : getSubTypes(curr)) {
        ret.push_back(sub);
        work.push_back(sub);
      }
    }
    return ret;
  }

  // Like getAllSubTypes, but also includes the type itself.
  std::vector<HeapType> getAllSubTypesInclusive(HeapType type) {
    auto ret = getAllSubTypes(type);
    ret.push_back(type);
    return ret;
  }

  // Get all supertypes of a type. The order in the output vector is with the
  // immediate supertype first, then its supertype, and so forth.
  std::vector<HeapType> getAllSuperTypes(HeapType type) {
    std::vector<HeapType> ret;
    while (1) {
      auto super = type.getSuperType();
      if (!super) {
        return ret;
      }
      ret.push_back(*super);
      type = *super;
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
  std::unordered_map<HeapType, std::vector<HeapType>> typeSubTypes;
};

} // namespace wasm

#endif // wasm_ir_subtypes_h
