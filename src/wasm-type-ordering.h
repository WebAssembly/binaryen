/*
 * Copyright 2023 WebAssembly Community Group participants
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

#ifndef wasm_wasm_type_ordering_h
#define wasm_wasm_type_ordering_h

#include <unordered_set>

#include "support/insert_ordered.h"
#include "support/topological_sort.h"
#include "wasm-type.h"

namespace wasm::HeapTypeOrdering {

// Given a collection of types, iterate through it such that each type in the
// collection is visited only after its immediate supertype in the collection is
// visited.
template<typename SupertypeProvider>
struct SupertypesFirstBase
  : TopologicalSort<HeapType, SupertypesFirstBase<SupertypeProvider>> {
  // For each type in the input collection, whether it is a supertype. Used to
  // track membership in the input collection.
  InsertOrderedMap<HeapType, bool> typeSet;

  SupertypeProvider& self() { return *static_cast<SupertypeProvider*>(this); }

  template<typename T> SupertypeProvider& sort(const T& types) {
    for (auto type : types) {
      typeSet[type] = false;
    }
    // Find the supertypes that are in the collection.
    for (auto [type, _] : typeSet) {
      if (auto super = self().getDeclaredSuperType(type)) {
        if (auto it = typeSet.find(*super); it != typeSet.end()) {
          it->second = true;
        }
      }
    }
    // Types that are not supertypes of others are the roots.
    for (auto [type, isSuper] : typeSet) {
      if (!isSuper) {
        this->push(type);
      }
    }
    return self();
  }

  void pushPredecessors(HeapType type) {
    // Do not visit types that weren't in the input collection.
    if (auto super = self().getDeclaredSuperType(type);
        super && typeSet.count(*super)) {
      this->push(*super);
    }
  }
};

struct SupertypesFirst : SupertypesFirstBase<SupertypesFirst> {
  std::optional<HeapType> getDeclaredSuperType(HeapType type) {
    return type.getDeclaredSuperType();
  }
};

} // namespace wasm::HeapTypeOrdering

#endif // wasm_wasm_type_ordering_h
