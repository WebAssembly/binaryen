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
    exnref,
    anyref,
    _last_basic_id = anyref
  };

  Type() = default;

  // BasicID can be implicitly upgraded to Type
  constexpr Type(BasicID id) : id(id){};

  // But converting raw uint32_t is more dangerous, so make it explicit
  explicit Type(uint64_t id) : id(id){};

  // Construct tuple from a list of single types
  Type(std::initializer_list<Type>);

  // Construct from tuple description
  explicit Type(const struct Tuple&);

  // Construct from a heap type description. Also covers construction from
  // Signature, Struct or Array via implicit conversion to HeapType.
  explicit Type(const struct HeapType&, bool nullable);

  // Construct from rtt description
  explicit Type(const struct Rtt&);

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
  // ├─ Aliases ───╫───┼───┼───┼───┤───────┤
  // │ funcref     ║ x │   │ x │ x │ f  n  │ ┐ Ref
  // │ externref   ║ x │   │ x │ x │ f? n  │ │  f_unc
  // │ exnref      ║ x │   │ x │ x │    n  │ │  n_ullable
  // │ anyref      ║ x │   │ x │ x │ f? n  │ │
  // │ eqref       ║ x │   │ x │ x │    n  │ │ ┐ TODO (GC)
  // │ i31ref      ║ x │   │ x │ x │       │ │ ┘
  // ├─ Compound ──╫───┼───┼───┼───┤───────┤ │
  // │ Ref         ║   │ x │ x │ x │ f? n? │◄┘
  // │ Tuple       ║   │ x │   │ x │       │
  // │ Rtt         ║   │ x │ x │ x │       │
  // └─────────────╨───┴───┴───┴───┴───────┘
  constexpr bool isBasic() const { return id <= _last_basic_id; }
  constexpr bool isCompound() const { return id > _last_basic_id; }
  constexpr bool isConcrete() const { return id >= i32; }
  constexpr bool isInteger() const { return id == i32 || id == i64; }
  constexpr bool isFloat() const { return id == f32 || id == f64; }
  constexpr bool isVector() const { return id == v128; };
  constexpr bool isNumber() const { return id >= i32 && id <= v128; }
  bool isTuple() const;
  bool isSingle() const { return isConcrete() && !isTuple(); }
  bool isRef() const;
  bool isFunction() const;
  bool isException() const;
  bool isNullable() const;
  bool isRtt() const;

private:
  template<bool (Type::*pred)() const> bool hasPredicate() {
    for (const auto& type : *this) {
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
  constexpr BasicID getBasic() const {
    assert(isBasic() && "Basic type expected");
    return static_cast<BasicID>(id);
  }

  // (In)equality must be defined for both Type and BasicID because it is
  // otherwise ambiguous whether to convert both this and other to int or
  // convert other to Type.
  bool operator==(const Type& other) const { return id == other.id; }
  bool operator==(const BasicID& otherId) const { return id == otherId; }
  bool operator!=(const Type& other) const { return id != other.id; }
  bool operator!=(const BasicID& otherId) const { return id != otherId; }

  // Order types by some notion of simplicity
  bool operator<(const Type& other) const;

  // Returns the type size in bytes. Only single types are supported.
  unsigned getByteSize() const;

  // Reinterpret an integer type to a float type with the same size and vice
  // versa. Only single integer and float types are supported.
  Type reinterpret() const;

  // Returns the feature set required to use this type.
  FeatureSet getFeatures() const;

  // Gets the heap type corresponding to this type
  HeapType getHeapType() const;

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
    Iterator& operator++() {
      ++index;
      return *this;
    }
    Iterator& operator--() {
      --index;
      return *this;
    }
    Iterator operator++(int) {
      auto it = *this;
      index++;
      return it;
    }
    Iterator operator--(int) {
      auto it = *this;
      index--;
      return it;
    }
    Iterator& operator+=(difference_type off) {
      index += off;
      return *this;
    }
    Iterator operator+(difference_type off) const {
      return Iterator(*this) += off;
    }
    Iterator& operator-=(difference_type off) {
      index -= off;
      return *this;
    }
    Iterator operator-(difference_type off) const {
      return Iterator(*this) -= off;
    }
    difference_type operator-(const Iterator& other) const {
      assert(parent == other.parent);
      return index - other.index;
    }
    const value_type& operator*() const;
  };

  Iterator begin() const { return Iterator(this, 0); }
  Iterator end() const;
  size_t size() const { return end() - begin(); }
  const Type& operator[](size_t i) const;
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

typedef std::vector<Type> TypeList;

struct Tuple {
  TypeList types;
  Tuple() : types() {}
  Tuple(std::initializer_list<Type> types) : types(types) {}
  Tuple(const TypeList& types) : types(types) {}
  Tuple(TypeList&& types) : types(std::move(types)) {}
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
  enum PackedType {
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
  Struct(const FieldList& fields) : fields(fields) {}
  Struct(FieldList&& fields) : fields(std::move(fields)) {}
  bool operator==(const Struct& other) const { return fields == other.fields; }
  bool operator!=(const Struct& other) const { return !(*this == other); }
  std::string toString() const;
};

struct Array {
  Field element;
  Array(const Array& other) : element(other.element) {}
  Array(const Field& element) : element(element) {}
  Array(Field&& element) : element(std::move(element)) {}
  bool operator==(const Array& other) const { return element == other.element; }
  bool operator!=(const Array& other) const { return !(*this == other); }
  std::string toString() const;
};

struct HeapType {
  enum Kind {
    FuncKind,
    ExternKind,
    ExnKind,
    AnyKind,
    EqKind,
    I31Kind,
    _last_basic_kind = I31Kind,
    SignatureKind,
    StructKind,
    ArrayKind,
  } kind;
  union {
    Signature signature;
    Struct struct_;
    Array array;
  };
  HeapType(Kind kind) : kind(kind) { assert(kind <= _last_basic_kind); }
  HeapType(const Signature& signature)
    : kind(SignatureKind), signature(signature) {}
  HeapType(Signature&& signature)
    : kind(SignatureKind), signature(std::move(signature)) {}
  HeapType(const Struct& struct_) : kind(StructKind), struct_(struct_) {}
  HeapType(Struct&& struct_) : kind(StructKind), struct_(std::move(struct_)) {}
  HeapType(const Array& array) : kind(ArrayKind), array(array) {}
  HeapType(Array&& array) : kind(ArrayKind), array(std::move(array)) {}
  HeapType(const HeapType& other);
  ~HeapType();

  bool isSignature() const { return kind == SignatureKind; }
  Signature getSignature() const {
    assert(isSignature() && "Not a signature");
    return signature;
  }
  bool isStruct() const { return kind == StructKind; }
  Struct getStruct() const {
    assert(isStruct() && "Not a struct");
    return struct_;
  }
  bool isArray() const { return kind == ArrayKind; }
  Array getArray() const {
    assert(isArray() && "Not an array");
    return array;
  }
  bool isException() const { return kind == ExnKind; }

  bool operator==(const HeapType& other) const;
  bool operator!=(const HeapType& other) const { return !(*this == other); }
  HeapType& operator=(const HeapType& other);
  std::string toString() const;
};

struct Rtt {
  uint32_t depth;
  HeapType heapType;
  Rtt(uint32_t depth, const HeapType& heapType)
    : depth(depth), heapType(heapType) {}
  Rtt(uint32_t depth, HeapType&& heapType)
    : depth(depth), heapType(std::move(heapType)) {}
  bool operator==(const Rtt& other) const {
    return depth == other.depth && heapType == other.heapType;
  }
  bool operator!=(const Rtt& other) const { return !(*this == other); }
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
std::ostream& operator<<(std::ostream&, HeapType);
std::ostream& operator<<(std::ostream&, Rtt);

} // namespace wasm

namespace std {

template<> class hash<wasm::Type> {
public:
  size_t operator()(const wasm::Type&) const;
};
template<> class hash<wasm::Tuple> {
public:
  size_t operator()(const wasm::Tuple&) const;
};
template<> class hash<wasm::Signature> {
public:
  size_t operator()(const wasm::Signature&) const;
};
template<> class hash<wasm::Field> {
public:
  size_t operator()(const wasm::Field&) const;
};
template<> class hash<wasm::Struct> {
public:
  size_t operator()(const wasm::Struct&) const;
};
template<> class hash<wasm::Array> {
public:
  size_t operator()(const wasm::Array&) const;
};
template<> class hash<wasm::HeapType> {
public:
  size_t operator()(const wasm::HeapType&) const;
};
template<> class hash<wasm::Rtt> {
public:
  size_t operator()(const wasm::Rtt&) const;
};

} // namespace std

#endif // wasm_wasm_type_h
