/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_wasm_type_shape_h
#define wasm_wasm_type_shape_h

#include <functional>
#include <vector>

#include "wasm-type.h"

namespace wasm {

// Provides hashing and equality comparison for a sequence of types. The hashing
// and equality differentiate the top-level structure of each type in the
// sequence and the equality of referenced heap types that are not in the
// recursion group, but for references to types that are in the recursion group,
// it considers only the index of the referenced type within the group. That
// means that recursion groups containing different types can compare and hash
// as equal as long as their internal structure and external references are the
// same.
struct RecGroupShape {
  const std::vector<HeapType>& types;

  RecGroupShape(const std::vector<HeapType>& types) : types(types) {}

  bool operator==(const RecGroupShape& other) const;
  bool operator!=(const RecGroupShape& other) const {
    return !(*this == other);
  }
};

// Extends `RecGroupShape` with ordered comparison of rec group structures.
// Requires the user to supply a global ordering on heap types to be able to
// compare differing references to external types.
// TODO: This can all be upgraded to use C++20 three-way comparisons.
struct ComparableRecGroupShape : RecGroupShape {
  std::function<bool(HeapType, HeapType)> less;

  ComparableRecGroupShape(const std::vector<HeapType>& types,
                          std::function<bool(HeapType, HeapType)> less)
    : RecGroupShape(types), less(less) {}

  bool operator<(const RecGroupShape& other) const;
  bool operator>(const RecGroupShape& other) const;
  bool operator<=(const RecGroupShape& other) const { return !(*this > other); }
  bool operator>=(const RecGroupShape& other) const { return !(*this < other); }
};

} // namespace wasm

namespace std {

template<> class hash<wasm::RecGroupShape> {
public:
  size_t operator()(const wasm::RecGroupShape& shape) const;
};

} // namespace std

#endif // wasm_wasm_type_shape_h
