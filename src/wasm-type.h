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
  std::string toString() const;
};

struct Field {
  Type type;
  bool mutable_;
  Field(Type type, bool mutable_ = false) : type(type), mutable_(mutable_) {}
  bool operator==(const Field& other) const {
    return type == other.type && mutable_ == other.mutable_;
  }
  bool operator!=(const Field& other) const { return !(*this == other); }
  std::string toString() const;
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
  std::string toString() const;
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
  std::string toString() const;
};

union TypeDef {
  enum Kind { TupleKind, SignatureKind, StructKind, ArrayKind };

  struct TupleDef {
    Kind kind;
    Tuple tuple;
  } tupleDef;
  struct SignatureDef {
    Kind kind;
    Signature signature;
  } signatureDef;
  struct StructDef {
    Kind kind;
    Struct struct_;
  } structDef;
  struct ArrayDef {
    Kind kind;
    Array array;
  } arrayDef;

  TypeDef(Tuple tuple) : tupleDef{TupleKind, tuple} {}
  TypeDef(Signature signature) : signatureDef{SignatureKind, signature} {}
  TypeDef(Struct struct_) : structDef{StructKind, struct_} {}
  TypeDef(Array array) : arrayDef{ArrayKind, array} {}
  TypeDef(const TypeDef& other) {
    switch (other.getKind()) {
      case TupleKind:
        ::new (&tupleDef) auto(other.tupleDef);
        break;
      case SignatureKind:
        ::new (&signatureDef) auto(other.signatureDef);
        break;
      case StructKind:
        ::new (&structDef) auto(other.structDef);
        break;
      case ArrayKind:
        ::new (&arrayDef) auto(other.arrayDef);
        break;
      default:
        WASM_UNREACHABLE("unexpected kind");
    }
  }
  ~TypeDef() {
    if (tupleDef.kind == TupleKind) {
      tupleDef.~TupleDef();
    }
  }

  constexpr Kind getKind() const { return tupleDef.kind; }

  bool operator==(const TypeDef& other) const {
    auto kind = getKind();
    if (kind != other.getKind()) {
      return false;
    }
    switch (kind) {
      case TupleKind:
        return tupleDef.tuple == other.tupleDef.tuple;
      case SignatureKind:
        return signatureDef.signature == other.signatureDef.signature;
      case StructKind:
        return structDef.struct_ == other.structDef.struct_;
      case ArrayKind:
        return arrayDef.array == other.arrayDef.array;
    }
    WASM_UNREACHABLE("unexpected kind");
  }
  bool operator!=(const TypeDef& other) const { return !(*this == other); }

  std::string toString() const;
};

std::ostream& operator<<(std::ostream& os, Type t);
std::ostream& operator<<(std::ostream& os, ParamType t);
std::ostream& operator<<(std::ostream& os, ResultType t);
std::ostream& operator<<(std::ostream& os, Tuple t);
std::ostream& operator<<(std::ostream& os, Signature t);
std::ostream& operator<<(std::ostream& os, Struct t);
std::ostream& operator<<(std::ostream& os, Array t);
std::ostream& operator<<(std::ostream& os, TypeDef t);

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
