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

// TODO: At various code locations we were assuming that single types are basic
// types, but this is going to change with the introduction of the compound
// Signature, Struct and Array types that will be single but not basic. To
// prepare for this change, the following macro marks affected code locations.
#define TODO_SINGLE_COMPOUND(type)                                             \
  assert(!type.isMulti() && "Unexpected multi-value type");                    \
  assert(!type.isCompound() && "TODO: handle compound types");

namespace wasm {

class Type {
  // The `id` uniquely represents each type, so type equality is just a
  // comparison of the ids. For basic types the `id` is just the `ValueType`
  // enum value below, and for constructed types the `id` is the address of the
  // canonical representation of the type, making lookups cheap for all types.
  uintptr_t id;
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
    externref,
    nullref,
    exnref,
    _last_value_type = exnref
  };

  Type() = default;

  // ValueType can be implicitly upgraded to Type
  constexpr Type(ValueType id) : id(id){};

  // But converting raw uint32_t is more dangerous, so make it explicit
  explicit Type(uint64_t id) : id(id){};

  // Construct from lists of elementary types
  Type(std::initializer_list<Type> types);
  explicit Type(const std::vector<Type>& types);

  // Predicates
  //                 Compound Concrete
  //   Type        Basic │ Single│
  // ╒═════════════╦═│═╤═│═╤═│═╤═│═╤═══════╕
  // │ none        ║ x │   │   │   │       │
  // │ unreachable ║ x │   │   │   │       │
  // ├─────────────╫───┼───┼───┼───┤───────┤
  // │ i32         ║ x │   │ x │ x │ I     │ ┐ Number
  // │ i64         ║ x │   │ x │ x │ I     │ │  I_nteger
  // │ f32         ║ x │   │ x │ x │   F   │ │  F_loat
  // │ f64         ║ x │   │ x │ x │   F   │ │  V_ector
  // │ v128        ║ x │   │ x │ x │     V │ ┘
  // ├─────────────╫───┼───┼───┼───┤───────┤
  // │ funcref     ║ x │   │ x │ x │ f     │ ┐ Ref
  // │ externref   ║ x │   │ x │ x │       │ │  f_unc
  // │ nullref     ║ x │   │ x │ x │       │ │
  // │ exnref      ║ x │   │ x │ x │       │ │
  // ├─────────────╫───┼───┼───┼───┤───────┤ │
  // │ Signature   ║   │ x │ x │ x │ f     │ │ ┐
  // │ Struct      ║   │ x │ x │ x │       │ │ │ TODO (GC)
  // │ Array       ║   │ x │ x │ x │       │ ┘ ┘
  // │ Multi       ║   │ x │   │ x │       │
  // └─────────────╨───┴───┴───┴───┴───────┘
  constexpr bool isBasic() const { return id <= _last_value_type; }
  constexpr bool isCompound() const { return id > _last_value_type; }
  constexpr bool isSingle() const {
    // TODO: Compound types Signature, Struct and Array are single
    return id >= i32 && id <= _last_value_type;
  }
  constexpr bool isMulti() const {
    // TODO: Compound types Signature, Struct and Array are not multi
    return id > _last_value_type;
  }
  constexpr bool isConcrete() const { return id >= i32; }
  constexpr bool isInteger() const { return id == i32 || id == i64; }
  constexpr bool isFloat() const { return id == f32 || id == f64; }
  constexpr bool isVector() const { return id == v128; };
  constexpr bool isNumber() const { return id >= i32 && id <= v128; }
  constexpr bool isRef() const {
    // TODO: Compound types Signature, Struct and Array are ref
    return id >= funcref && id <= exnref;
  }

private:
  template<bool (Type::*pred)() const> bool hasPredicate() {
    for (auto& type : *this) {
      if ((type.*pred)()) {
        return true;
      }
    }
    return false;
  }

public:
  bool hasVector() { return hasPredicate<&Type::isVector>(); }
  bool hasRef() { return hasPredicate<&Type::isRef>(); }

  constexpr uint64_t getID() const { return id; }
  constexpr ValueType getBasic() const {
    assert(isBasic() && "Basic type expected");
    return static_cast<ValueType>(id);
  }

  // (In)equality must be defined for both Type and ValueType because it is
  // otherwise ambiguous whether to convert both this and other to int or
  // convert other to Type.
  bool operator==(const Type& other) const { return id == other.id; }
  bool operator==(const ValueType& other) const { return id == other; }
  bool operator!=(const Type& other) const { return id != other.id; }
  bool operator!=(const ValueType& other) const { return id != other; }

  // Order types by some notion of simplicity
  bool operator<(const Type& other) const;

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

  struct Iterator
    : std::iterator<std::random_access_iterator_tag, Type, long, Type*, Type&> {
    const Type* parent;
    size_t index;
    Iterator(const Type* parent, size_t index) : parent(parent), index(index) {}
    bool operator==(const Iterator& other) const {
      return index == other.index && parent == other.parent;
    }
    bool operator!=(const Iterator& other) const { return !(*this == other); }
    void operator++() { index++; }
    Iterator& operator+=(difference_type off) {
      index += off;
      return *this;
    }
    const Iterator operator+(difference_type off) const {
      return Iterator(*this) += off;
    }
    difference_type operator-(const Iterator& other) {
      assert(parent == other.parent);
      return index - other.index;
    }
    const value_type& operator*() const {
      if (parent->isMulti()) {
        return (*(std::vector<Type>*)parent->getID())[index];
      } else {
        // see TODO in Type::end()
        assert(index == 0 && parent->id != Type::none && "Index out of bounds");
        return *parent;
      }
    }
  };

  Iterator begin() const { return Iterator(this, 0); }
  Iterator end() const {
    if (isMulti()) {
      return Iterator(this, (*(std::vector<Type>*)getID()).size());
    } else {
      // TODO: unreachable expands to {unreachable} currently. change to {}?
      return Iterator(this, size_t(id != Type::none));
    }
  }
  size_t size() const { return end() - begin(); }
  const Type& operator[](size_t i) const {
    if (isMulti()) {
      return (*(std::vector<Type>*)getID())[i];
    } else {
      return *begin();
    }
  }
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

} // namespace wasm

namespace std {

template<> class hash<wasm::Type> {
public:
  size_t operator()(const wasm::Type& type) const;
};

template<> class hash<wasm::Signature> {
public:
  size_t operator()(const wasm::Signature& sig) const;
};

} // namespace std

#endif // wasm_wasm_type_h
