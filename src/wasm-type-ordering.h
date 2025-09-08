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

// Given a collection of types, return a sequence of the types such that each
// type in the sequence comes only after its immediate supertype in the
// collection is visited.
template<typename T>
std::vector<HeapType> supertypesFirst(
  const T& types,
  std::function<std::optional<HeapType>(HeapType)> getSuper =
    [](HeapType type) { return type.getDeclaredSuperType(); }) {

  InsertOrderedMap<HeapType, std::vector<HeapType>> subtypes;
  for (auto type : types) {
    subtypes.insert({type, {}});
  }
  // Find the supertypes that are in the collection.
  for (auto [type, _] : subtypes) {
    if (auto super = getSuper(type)) {
      if (auto it = subtypes.find(*super); it != subtypes.end()) {
        it->second.push_back(type);
      }
    }
  }
  return TopologicalSort::sortOf(subtypes.begin(), subtypes.end());
}

} // namespace wasm::HeapTypeOrdering

#endif // wasm_wasm_type_ordering_h
