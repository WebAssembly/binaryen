/*
 * Copyright 2017 WebAssembly Community Group participants
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

#ifndef wasm_wasm_type_h
#define wasm_wasm_type_h

#include "wasm-features.h"

namespace wasm {

class Type {
  uint32_t id;

public:
  enum ValueType : uint32_t {
    none,
    i32,
    i64,
    f32,
    f64,
    v128,
    anyref,
    exnref,
    // none means no type, e.g. a block can have no return type. but unreachable
    // is different, as it can be "ignored" when doing type checking across
    // branches
    unreachable
  };

  Type() = default;

  // ValueType can be implicitly upgraded to Type
  constexpr Type(ValueType id) : id(id){};

  // But converting raw uint32_t is more dangerous, so make it explicit
  constexpr explicit Type(uint32_t id) : id(id){};

  // (In)equality must be defined for both Type and ValueType because it is
  // otherwise ambiguous whether to convert both this and other to int or
  // convert other to Type.
  bool operator==(const Type& other) { return id == other.id; }

  bool operator==(const ValueType& other) { return id == other; }

  bool operator!=(const Type& other) { return id != other.id; }

  bool operator!=(const ValueType& other) { return id != other; }

  // Allows for using Types in switch statements
  constexpr operator int() const { return id; }
};

const char* printType(Type type);
unsigned getTypeSize(Type type);
FeatureSet getFeatures(Type type);
Type getType(unsigned size, bool float_);
Type getReachableType(Type a, Type b);
bool isConcreteType(Type type);
bool isFloatType(Type type);
bool isIntegerType(Type type);
bool isVectorType(Type type);
bool isReferenceType(Type type);
Type reinterpretType(Type type);

} // namespace wasm

#endif // wasm_wasm_type_h
