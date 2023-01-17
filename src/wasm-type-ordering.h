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

#include "support/topological_sort.h"
#include "wasm-type.h"

namespace wasm::HeapTypeOrdering {

struct SupertypesFirst : TopologicalSort<HeapType, SupertypesFirst> {
  SupertypesFirst(const std::vector<HeapType>& types) {
    std::unordered_set<HeapType> supertypes;
    for (auto type : types) {
      if (auto super = type.getSuperType()) {
        supertypes.insert(*super);
      }
    }
    // Types that are not supertypes of others are the roots.
    for (auto type : types) {
      if (!supertypes.count(type)) {
        push(type);
      }
    }
  }

  void pushPredecessors(HeapType type) {
    if (auto super = type.getSuperType()) {
      push(*super);
    }
  }
};

} // namespace wasm::HeapTypeOrdering

#endif // wasm_wasm_type_ordering_h
