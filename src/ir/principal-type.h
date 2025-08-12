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

// Due to various kinds of polymorphism, describing principal types requires
// extensions to the normal syntax of types. These extensions include the
// introduction of type variables, which we represent as indices.

// A sharedness that is a subtype of both `shared` and `unshared`.
struct BottomShare : std::monostate {};

// A heap type that is a subtype of all other heap types, no matter what
// hierarchy they belong to.
struct BottomHeapType : std::monostate {};

// Either a nullability or a nullability type variable.
using VarNullability = std::variant<Nullability, Index>;

// Bottom sharedness, a normal sharedness, or a sharedness type variable.
using VarSharedness = std::variant<BottomShare, Shareability, Index>;

// An abstract heap type with some given sharedness.
struct VarAbsHeapType {
  VarSharedness share;
  // Must be basic and unshared.
  HeapType ht;

  bool operator==(const VarAbsHeapType& other) const {
    return share == other.share && ht == other.ht;
  }
  bool operator!=(const VarAbsHeapType& other) const {
    return !(*this == other);
  }
};

// Either an exactness or an exactness type variable.
using VarExactness = std::variant<Exactness, Index>;

// A defined heap type with a given exactness.
struct VarDefHeapType {
  VarExactness exact;
  // Must be defined.
  HeapType ht;

  bool operator==(const VarDefHeapType& other) const {
    return exact == other.exact && ht == other.ht;
  }
  bool operator!=(const VarDefHeapType& other) const {
    return !(*this == other);
  }
};

// A bottom heap type, an abstract heap type, a defined heap type, or a heap
// type variable.
using VarHeapType =
  std::variant<BottomHeapType, VarAbsHeapType, VarDefHeapType, Index>;

// A reference comprising a given nullability and heap type.
struct VarRef {
  VarNullability null;
  VarHeapType ht;

  bool operator==(const VarRef& other) const {
    return null == other.null && ht == other.ht;
  }
  bool operator!=(const VarRef& other) const { return !(*this == other); }
};

// A normal type, a reference type using the extended syntax, or a type
// variable. If a reference type can be expressed in the normal syntax rather
// than the extended syntax, it should be represented here as a `Type`, not a
// `VarRef`.
using VarType = std::variant<Type, VarRef, Index>;

// A principal type, including extended input and output types for an
// instruction sequence and whether the sequence is stack-polymorphic, i.e.
// contains an instruction that unconditionally transfers control flow out of
// the sequence, i.e. is unreachable. The parameters are stored in reverse order
// for efficiency. Variable indices for each kind of variable must be introduced
// contiguously in order starting at zero from the end to beginning of the
// params (beginning to end of the reversed params).
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

  PrincipalType(Signature sig) {
    for (auto param : sig.params) {
      rparams.push_back(param);
    }
    std::reverse(rparams.begin(), rparams.end());
    for (auto result : sig.results) {
      results.push_back(result);
    }
  }

  // Update this type to be the composition of this and `next`.
  bool compose(const PrincipalType& next);

  // Get the signature represented by this type if it is closed, i.e. has no
  // variables.
  std::optional<Signature> getSignature() const;

  static bool matches(Type type, VarType constraint);

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
