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
#include <ostream>
#include <vector>

namespace wasm {

class Type {
  uint32_t id;
  void init(const std::vector<Type>&);

public:
  enum ValueType : uint32_t {
    none,
    unreachable,
    i32,
    i64,
    f32,
    f64,
    v128,
    funcref,
    anyref,
    nullref,
    exnref,
    _last_value_type,
  };

  Type() = default;

  // ValueType can be implicitly upgraded to Type
  constexpr Type(ValueType id) : id(id){};

  // But converting raw uint32_t is more dangerous, so make it explicit
  constexpr explicit Type(uint32_t id) : id(id){};

  // Construct from lists of elementary types
  Type(std::initializer_list<Type> types);
  explicit Type(const std::vector<Type>& types);

  // Accessors
  size_t size() const;
  const std::vector<Type>& expand() const;

  // Predicates
  bool isSingle() const { return id >= i32 && id < _last_value_type; }
  bool isMulti() const { return id >= _last_value_type; }
  bool isConcrete() const { return id >= i32; }
  bool isInteger() const { return id == i32 || id == i64; }
  bool isFloat() const { return id == f32 || id == f64; }
  bool isVector() const { return id == v128; };
  bool isNumber() const { return id >= i32 && id <= v128; }
  bool isRef() const { return id >= funcref && id <= exnref; }

  // (In)equality must be defined for both Type and ValueType because it is
  // otherwise ambiguous whether to convert both this and other to int or
  // convert other to Type.
  bool operator==(const Type& other) const { return id == other.id; }
  bool operator==(const ValueType& other) const { return id == other; }
  bool operator!=(const Type& other) const { return id != other.id; }
  bool operator!=(const ValueType& other) const { return id != other; }

  // Order types by some notion of simplicity
  bool operator<(const Type& other) const;

  // Allows for using Types in switch statements
  constexpr operator uint32_t() const { return id; }

  // Returns the type size in bytes. Only single types are supported.
  unsigned getByteSize() const;

  // Reinterpret an integer type to a float type with the same size and vice
  // versa. Only single integer and float types are supported.
  Type reinterpret() const;

  // Returns the feature set required to use this type.
  FeatureSet getFeatures() const;

  // Returns a number type based on its size in bytes and whether it is a float
  // type.
  static Type get(unsigned byteSize, bool float_);

  // Returns true if left is a subtype of right. Subtype includes itself.
  static bool isSubType(Type left, Type right);

  // Computes the least upper bound from the type lattice.
  // If one of the type is unreachable, the other type becomes the result. If
  // the common supertype does not exist, returns none, a poison value.
  static Type getLeastUpperBound(Type a, Type b);

  // Computes the least upper bound for all types in the given list.
  template<typename T> static Type mergeTypes(const T& types) {
    Type type = Type::unreachable;
    for (auto other : types) {
      type = Type::getLeastUpperBound(type, other);
    }
    return type;
  }

  std::string toString() const;
};

// Wrapper type for formatting types as "(param i32 i64 f32)"
struct ParamType {
  Type type;
  ParamType(Type type) : type(type) {}
  std::string toString() const;
};

// Wrapper type for formatting types as "(result i32 i64 f32)"
struct ResultType {
  Type type;
  ResultType(Type type) : type(type) {}
  std::string toString() const;
};

struct Signature {
  Type params;
  Type results;
  Signature() : params(Type::none), results(Type::none) {}
  Signature(Type params, Type results) : params(params), results(results) {}
  bool operator==(const Signature& other) const {
    return params == other.params && results == other.results;
  }
  bool operator!=(const Signature& other) const { return !(*this == other); }
  bool operator<(const Signature& other) const;
};

std::ostream& operator<<(std::ostream& os, Type t);
std::ostream& operator<<(std::ostream& os, ParamType t);
std::ostream& operator<<(std::ostream& os, ResultType t);
std::ostream& operator<<(std::ostream& os, Signature t);

constexpr Type none = Type::none;
constexpr Type i32 = Type::i32;
constexpr Type i64 = Type::i64;
constexpr Type f32 = Type::f32;
constexpr Type f64 = Type::f64;
constexpr Type v128 = Type::v128;
constexpr Type funcref = Type::funcref;
constexpr Type anyref = Type::anyref;
constexpr Type nullref = Type::nullref;
constexpr Type exnref = Type::exnref;
constexpr Type unreachable = Type::unreachable;

} // namespace wasm

template<> class std::hash<wasm::Signature> {
public:
  size_t operator()(const wasm::Signature& sig) const;
};

#endif // wasm_wasm_type_h
