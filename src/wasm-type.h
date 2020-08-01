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

class Type;
typedef std::vector<Type> Tuple;
struct Signature;
struct Struct;
struct Array;

class Type {
  // The `id` uniquely represents each type, so type equality is just a
  // comparison of the ids. For basic types the `id` is just the `ValueType`
  // enum value below, and for constructed types the `id` is the address of the
  // canonical representation of the type, making lookups cheap for all types.
  uintptr_t id;

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
  Type(std::initializer_list<Type>);
  explicit Type(const Tuple&);

  // Construct from signature descriptions
  explicit Type(const Signature&);

  // Construct from struct descriptions
  explicit Type(const Struct&);

  // Construct from array descriptions
  explicit Type(const Array&);

  // Accessors
  size_t size() const;
  const Tuple& expand() const;

  // Predicates
  constexpr bool isSingle() const {
    return id >= i32 && id <= _last_value_type;
  }
  constexpr bool isConcrete() const { return id >= i32; }
  constexpr bool isInteger() const { return id == i32 || id == i64; }
  constexpr bool isFloat() const { return id == f32 || id == f64; }
  constexpr bool isVector() const { return id == v128; };
  constexpr bool isNumber() const { return id >= i32 && id <= v128; }
  bool isMulti() const;
  bool isRef() const;

private:
  template<bool (Type::*pred)() const> bool hasPredicate() {
    for (auto t : expand()) {
      if ((t.*pred)()) {
        return true;
      }
    }
    return false;
  }

public:
  bool hasVector() { return hasPredicate<&Type::isVector>(); }
  bool hasRef() { return hasPredicate<&Type::isRef>(); }

  constexpr uint64_t getID() const { return id; }
  ValueType getSingle() const {
    assert(!isMulti() && "Unexpected multivalue type");
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

struct Field {
  Type type;
  bool mutable_;
  Field(Type type, bool mutable_ = false) : type(type), mutable_(mutable_) {}
  bool operator==(const Field& other) const {
    return type == other.type && mutable_ == other.mutable_;
  }
  bool operator!=(const Field& other) const { return !(*this == other); }
};

typedef std::vector<Field> FieldList;

struct Struct {
  FieldList fields;
  bool nullable;
  Struct(const Struct& other)
    : fields(other.fields), nullable(other.nullable) {}
  Struct(FieldList fields, bool nullable = false)
    : fields(fields), nullable(nullable) {}
  bool operator==(const Struct& other) const {
    return fields == other.fields && nullable == other.nullable;
  }
  bool operator!=(const Struct& other) const { return !(*this == other); }
};

struct Array {
  Field element;
  bool nullable;
  Array(const Array& other)
    : element(other.element), nullable(other.nullable) {}
  Array(Field element, bool nullable = false)
    : element(element), nullable(nullable) {}
  bool operator==(const Array& other) const {
    return element == other.element && nullable == other.nullable;
  }
  bool operator!=(const Array& other) const { return !(*this == other); }
};

struct TypeDef { // TODO: make internal to wasm-type.cpp ?
  enum Kind { TupleKind, SignatureKind, StructKind, ArrayKind };

  Kind kind;
  union Def {
    Def(Tuple tuple) : tuple(tuple) {}
    Def(Signature signature) : signature(signature) {}
    Def(Struct struct_) : struct_(struct_) {}
    Def(Array array) : array(array) {}
    ~Def() {}
    Tuple tuple;
    Signature signature;
    Struct struct_;
    Array array;
  } def;

  TypeDef(const TypeDef& other) : kind(other.kind), def(Tuple()) { // FIXME
    switch (kind) {
      case TupleKind:
        def.tuple = other.def.tuple;
        break;
      case SignatureKind: {
        def.signature = other.def.signature;
        break;
      }
      case StructKind: {
        def.struct_ = other.def.struct_;
        break;
      }
      case ArrayKind: {
        def.array = other.def.array;
        break;
      }
      default:
        WASM_UNREACHABLE("unexpected kind");
    }
  }
  TypeDef(Tuple tuple) : kind(TupleKind), def(tuple) {}
  TypeDef(Signature signature) : kind(SignatureKind), def(signature) {}
  TypeDef(Struct struct_) : kind(StructKind), def(struct_) {}
  TypeDef(Array array) : kind(ArrayKind), def(array) {}

  bool operator==(const TypeDef& other) const {
    if (kind != other.kind)
      return false;
    switch (kind) {
      case TupleKind:
        return def.tuple == other.def.tuple;
      case SignatureKind:
        return def.signature == other.def.signature;
      case StructKind:
        return def.struct_ == other.def.struct_;
      case ArrayKind:
        return def.array == other.def.array;
    }
    WASM_UNREACHABLE("unexpected kind");
  }
  bool operator!=(const TypeDef& other) const { return !(*this == other); }
};

std::ostream& operator<<(std::ostream& os, Type t);
std::ostream& operator<<(std::ostream& os, ParamType t);
std::ostream& operator<<(std::ostream& os, ResultType t);
std::ostream& operator<<(std::ostream& os, Signature t);
std::ostream& operator<<(std::ostream& os, Struct t);
std::ostream& operator<<(std::ostream& os, Array t);

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

template<> class hash<wasm::TypeDef> {
public:
  size_t operator()(const wasm::TypeDef&) const;
};

} // namespace std

#endif // wasm_wasm_type_h
