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

#ifndef wasm_tools_fuzzing_heap_types_h
#define wasm_tools_fuzzing_heap_types_h

#include "tools/fuzzing/random.h"
#include "wasm-type.h"
#include "wasm.h"
#include <optional>
#include <vector>

namespace wasm {

struct HeapTypeGenerator {
  // The builder containing the randomly generated types.
  TypeBuilder builder;

  // The intended subtypes of each built type.
  std::vector<std::vector<Index>> subtypeIndices;

  // The intended supertype of each built type, if any.
  std::vector<std::optional<Index>> supertypeIndices;

  // Create a populated `HeapTypeGenerator` with `n` random HeapTypes with
  // interesting subtyping.
  static HeapTypeGenerator create(Random& rand, FeatureSet features, size_t n);

  // Given a sequence of newly-built heap types, produce a sequence of similar
  // or identical types that are all inhabitable, i.e. that are possible to
  // create values for.
  static std::vector<HeapType>
  makeInhabitable(const std::vector<HeapType>& types);

  // Returns the types in the input that are inhabitable.
  static std::vector<HeapType>
  getInhabitable(const std::vector<HeapType>& types);
};

} // namespace wasm

#endif // wasm_tools_fuzzing_heap_types_h
