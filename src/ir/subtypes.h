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

// A nominal type always knows who its supertype is, if there is one; this class
// provides the list of immediate subtypes.
struct SubTypes {
  SubTypes(Module& wasm) {
    std::vector<HeapType> types;
    std::unordered_map<HeapType, Index> typeIndices;
    ModuleUtils::collectHeapTypes(wasm, types, typeIndices);
    for (auto type : types) {
      note(type);
    }
  }

  const std::unordered_set<HeapType>& getSubTypes(HeapType type) {
    return typeSubTypes[type];
  }

private:
  // Add a type to the graph.
  void note(HeapType type) {
    HeapType super;
    if (type.getSuperType(super)) {
      typeSubTypes[super].insert(type);
    }
  }

  // Maps a type to its subtypes.
  std::unordered_map<HeapType, std::unordered_set<HeapType>> typeSubTypes;
};

} // namespace wasm

#endif // wasm_ir_subtypes_h
