/*
 * Copyright 2025 WebAssembly Community Group participants
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

#ifndef wasm_ir_principal_types_h
#define wasm_ir_principal_types_h

#include <algorithm>
#include <variant>

#include "wasm-type.h"

namespace wasm {

// The syntax of types needs to be extended with type variables for nullability,
// exactness, sharedness, heap types, and types, as well as bottom heap type and
// sharedness.
struct BottomShare : std::monostate {};

struct BottomHeapType : std::monostate {};

using VarNullability = std::variant<Nullability, Index>;

using VarSharedness = std::variant<BottomShare, Shareability, Index>;

struct VarAbsHeapType {
  VarSharedness share;
  HeapType ht;

  bool operator==(const VarAbsHeapType& other) const {
    return share == other.share && ht == other.ht;
  }
  bool operator!=(const VarAbsHeapType& other) const {
    return !(*this == other);
  }
};

using VarExactness = std::variant<Exactness, Index>;

struct VarDefHeapType {
  VarExactness exact;
  HeapType ht;

  bool operator==(const VarDefHeapType& other) const {
    return exact == other.exact && ht == other.ht;
  }
  bool operator!=(const VarDefHeapType& other) const {
    return !(*this == other);
  }
};

using VarHeapType =
  std::variant<BottomHeapType, VarAbsHeapType, VarDefHeapType, Index>;

struct VarRef {
  VarNullability null;
  VarHeapType ht;

  bool operator==(const VarRef& other) const {
    return null == other.null && ht == other.ht;
  }
  bool operator!=(const VarRef& other) const { return !(*this == other); }
};

using VarType = std::variant<Type, VarRef, Index>;

struct PrincipalType {
  std::vector<VarType> rparams;
  std::vector<VarType> results;
  bool unreachable;

  PrincipalType(std::initializer_list<VarType> params,
                std::initializer_list<VarType> results,
                bool unreachable = false)
    : rparams(params), results(results), unreachable(unreachable) {
    std::reverse(rparams.begin(), rparams.end());
  }

  // Update this type to be the composition of this and `next`.
  bool compose(const PrincipalType& next);

  // Get the signature represented by this type if it is closed, i.e. has no
  // variables.
  std::optional<Signature> getSignature() const;

  bool operator==(const PrincipalType& other) const {
    return rparams == other.rparams && results == other.results &&
           unreachable == other.unreachable;
  }
  bool operator!=(const PrincipalType& other) const {
    return !(*this == other);
  }
};

std::ostream& operator<<(std::ostream& o, const PrincipalType& type);

} // namespace wasm

#endif // wasm_ir_principal_types_h
