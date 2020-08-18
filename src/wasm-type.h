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
  assert(!type.isTuple() && "Unexpected tuple type");                          \
  assert(!type.isCompound() && "TODO: handle compound types");

namespace wasm {

class Type;
struct Tuple;
struct Signature;
struct Struct;
struct Array;

typedef std::vector<Type> TypeList;

class Type {
  // The `id` uniquely represents each type, so type equality is just a
  // comparison of the ids. For basic types the `id` is just the `BasicID`
  // enum value below, and for constructed types the `id` is the address of the
  // canonical representation of the type, making lookups cheap for all types.
  uintptr_t id;

public:
  enum BasicID : uint32_t {
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
    _last_basic_id = exnref
  };

  Type() = default;

  // BasicID can be implicitly upgraded to Type
  constexpr Type(BasicID id) : id(id){};

  // But converting raw uint32_t is more dangerous, so make it explicit
  explicit Type(uint64_t id) : id(id){};

  // Construct tuple from a list of single types
  Type(std::initializer_list<Type>);

  // Construct from tuple description
  explicit Type(const Tuple&);

  // Construct from signature description
  explicit Type(const Signature, bool nullable);

  // Construct from struct description
  explicit Type(const Struct&, bool nullable);

  // Construct from array description
  explicit Type(const Array&, bool nullable);

  // Accessors
  size_t size() const;
  const TypeList& expand() const;

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
  // │ Signature   ║   │ x │ x │ x │ f     │ │
  // │ Struct      ║   │ x │ x │ x │       │ │
  // │ Array       ║   │ x │ x │ x │       │ ┘
  // │ Tuple       ║   │ x │   │ x │       │
  // └─────────────╨───┴───┴───┴───┴───────┘
  constexpr bool isBasic() const { return id <= _last_basic_id; }
  constexpr bool isCompound() const { return id > _last_basic_id; }
  constexpr bool isConcrete() const { return id >= i32; }
  constexpr bool isInteger() const { return id == i32 || id == i64; }
  constexpr bool isFloat() const { return id == f32 || id == f64; }
  constexpr bool isVector() const { return id == v128; };
  constexpr bool isNumber() const { return id >= i32 && id <= v128; }
  bool isTuple() const;
  bool isSingle() const {
    return id >= i32 && (id <= _last_basic_id || !isTuple());
  }
  bool isRef() const;
  bool isNullable() const;

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
  constexpr BasicID getBasic() const {
    assert(isBasic() && "Basic type expected");
    return static_cast<BasicID>(id);
  }

  // (In)equality must be defined for both Type and BasicID because it is
  // otherwise ambiguous whether to convert both this and other to int or
  // convert other to Type.
  bool operator==(const Type& other) const { return id == other.id; }
  bool operator==(const BasicID& other) const { return id == other; }
  bool operator!=(const Type& other) const { return id != other.id; }
  bool operator!=(const BasicID& other) const { return id != other; }

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

struct Tuple {
  TypeList types;
  Tuple() : types({}) {}
  Tuple(std::initializer_list<Type> types) : types(types) {}
  Tuple(TypeList types) : types(types) {}
  bool operator==(const Tuple& other) const { return types == other.types; }
  bool operator!=(const Tuple& other) const { return !(*this == other); }
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
  enum PackedType : uint32_t {
    not_packed,
    i8,
    i16,
  } packedType; // applicable iff type=i32
  bool mutable_;

  Field(Type type, bool mutable_ = false)
    : type(type), packedType(not_packed), mutable_(mutable_) {}
  Field(PackedType packedType, bool mutable_ = false)
    : type(Type::i32), packedType(packedType), mutable_(mutable_) {}

  constexpr bool isPacked() const {
    if (packedType != not_packed) {
      assert(type == Type::i32 && "unexpected type");
      return true;
    }
    return false;
  }

  bool operator==(const Field& other) const {
    return type == other.type && packedType == other.packedType &&
           mutable_ == other.mutable_;
  }
  bool operator!=(const Field& other) const { return !(*this == other); }
  std::string toString() const;
};

typedef std::vector<Field> FieldList;

struct Struct {
  FieldList fields;
  Struct(const Struct& other) : fields(other.fields) {}
  Struct(FieldList fields) : fields(fields) {}
  bool operator==(const Struct& other) const { return fields == other.fields; }
  bool operator!=(const Struct& other) const { return !(*this == other); }
  std::string toString() const;
};

struct Array {
  Field element;
  Array(const Array& other) : element(other.element) {}
  Array(Field element) : element(element) {}
  bool operator==(const Array& other) const { return element == other.element; }
  bool operator!=(const Array& other) const { return !(*this == other); }
  std::string toString() const;
};

struct TypeDef {
  enum Kind { TupleKind, SignatureRefKind, StructRefKind, ArrayRefKind } kind;
  struct SignatureRef {
    Signature signature;
    bool nullable;
  };
  struct StructRef {
    Struct struct_;
    bool nullable;
  };
  struct ArrayRef {
    Array array;
    bool nullable;
  };
  union {
    Tuple tuple;
    SignatureRef signatureRef;
    StructRef structRef;
    ArrayRef arrayRef;
  };

  TypeDef(Tuple tuple) : kind(TupleKind), tuple(tuple) {}
  TypeDef(Signature signature, bool nullable)
    : kind(SignatureRefKind), signatureRef{signature, nullable} {}
  TypeDef(Struct struct_, bool nullable)
    : kind(StructRefKind), structRef{struct_, nullable} {}
  TypeDef(Array array, bool nullable)
    : kind(ArrayRefKind), arrayRef{array, nullable} {}
  TypeDef(const TypeDef& other) {
    kind = other.kind;
    switch (kind) {
      case TupleKind:
        new (&tuple) auto(other.tuple);
        return;
      case SignatureRefKind:
        new (&signatureRef) auto(other.signatureRef);
        return;
      case StructRefKind:
        new (&structRef) auto(other.structRef);
        return;
      case ArrayRefKind:
        new (&arrayRef) auto(other.arrayRef);
        return;
    }
    WASM_UNREACHABLE("unexpected kind");
  }
  ~TypeDef() {
    switch (kind) {
      case TupleKind: {
        tuple.~Tuple();
        return;
      }
      case SignatureRefKind: {
        signatureRef.~SignatureRef();
        return;
      }
      case StructRefKind: {
        structRef.~StructRef();
        return;
      }
      case ArrayRefKind: {
        arrayRef.~ArrayRef();
        return;
      }
    }
    WASM_UNREACHABLE("unexpected kind");
  }

  constexpr bool isTuple() const { return kind == TupleKind; }
  constexpr bool isSignatureRef() const { return kind == SignatureRefKind; }
  constexpr bool isStructRef() const { return kind == StructRefKind; }
  constexpr bool isArrayRef() const { return kind == ArrayRefKind; }

  bool isNullable() const {
    switch (kind) {
      case TupleKind:
        return false;
      case SignatureRefKind:
        return signatureRef.nullable;
      case StructRefKind:
        return structRef.nullable;
      case ArrayRefKind:
        return arrayRef.nullable;
    }
    WASM_UNREACHABLE("unexpected kind");
  }

  bool operator==(const TypeDef& other) const {
    if (kind != other.kind) {
      return false;
    }
    switch (kind) {
      case TupleKind:
        return tuple == other.tuple;
      case SignatureRefKind:
        return signatureRef.nullable == other.signatureRef.nullable &&
               signatureRef.signature == other.signatureRef.signature;
      case StructRefKind:
        return structRef.nullable == other.structRef.nullable &&
               structRef.struct_ == other.structRef.struct_;
      case ArrayRefKind:
        return arrayRef.nullable == other.arrayRef.nullable &&
               arrayRef.array == other.arrayRef.array;
    }
    WASM_UNREACHABLE("unexpected kind");
  }
  bool operator!=(const TypeDef& other) const { return !(*this == other); }
  TypeDef& operator=(const TypeDef& other) {
    if (&other != this) {
      (*this).~TypeDef();
      new (this) auto(other);
    }
    return *this;
  }

  std::string toString() const;
};

std::ostream& operator<<(std::ostream&, Type);
std::ostream& operator<<(std::ostream&, ParamType);
std::ostream& operator<<(std::ostream&, ResultType);
std::ostream& operator<<(std::ostream&, Tuple);
std::ostream& operator<<(std::ostream&, Signature);
std::ostream& operator<<(std::ostream&, Field);
std::ostream& operator<<(std::ostream&, Struct);
std::ostream& operator<<(std::ostream&, Array);
std::ostream& operator<<(std::ostream&, TypeDef);

} // namespace wasm

namespace std {

template<> class hash<wasm::Type> {
public:
  size_t operator()(const wasm::Type&) const;
};

template<> class hash<wasm::Signature> {
public:
  size_t operator()(const wasm::Signature&) const;
};

template<> class hash<wasm::Field> {
public:
  size_t operator()(const wasm::Field&) const;
};

template<> class hash<wasm::TypeDef> {
public:
  size_t operator()(const wasm::TypeDef&) const;
};

} // namespace std

#endif // wasm_wasm_type_h
