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

#include "support/name.h"
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

// The types defined in this file. All of them are small and typically passed by
// value except for `Tuple` and `Struct`, which may own an unbounded amount of
// data.
class Type;
class HeapType;
struct Tuple;
struct Signature;
struct Field;
struct Struct;
struct Array;
struct Rtt;

enum Nullability { NonNullable, Nullable };
enum Mutability { Immutable, Mutable };

// The type used for interning IDs in the public interfaces of Type and
// HeapType.
using TypeID = uint64_t;

class Type {
  // The `id` uniquely represents each type, so type equality is just a
  // comparison of the ids. For basic types the `id` is just the `BasicType`
  // enum value below, and for constructed types the `id` is the address of the
  // canonical representation of the type, making lookups cheap for all types.
  // Since `Type` is really just a single integer, it should be passed by value.
  // This is a uintptr_t rather than a TypeID (uint64_t) to save memory on
  // 32-bit platforms.
  uintptr_t id;

public:
  enum BasicType : uint32_t {
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
    eqref,
    i31ref,
  };
  static constexpr BasicType _last_basic_type = i31ref;

  Type() : id(none) {}

  // BasicType can be implicitly upgraded to Type
  constexpr Type(BasicType id) : id(id) {}

  // But converting raw TypeID is more dangerous, so make it explicit
  explicit Type(TypeID id) : id(id) {}

  // Construct tuple from a list of single types
  Type(std::initializer_list<Type>);

  // Construct from tuple description
  Type(const Tuple&);
  Type(Tuple&&);

  // Construct from a heap type description. Also covers construction from
  // Signature, Struct or Array via implicit conversion to HeapType.
  Type(HeapType, Nullability nullable);

  // Construct from rtt description
  Type(Rtt);

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
  constexpr bool isBasic() const { return id <= _last_basic_type; }
  constexpr bool isCompound() const { return id > _last_basic_type; }
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
  bool isStruct() const;
  bool isArray() const;

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

  constexpr TypeID getID() const { return id; }
  constexpr BasicType getBasic() const {
    assert(isBasic() && "Basic type expected");
    return static_cast<BasicType>(id);
  }

  // (In)equality must be defined for both Type and BasicType because it is
  // otherwise ambiguous whether to convert both this and other to int or
  // convert other to Type.
  bool operator==(const Type& other) const { return id == other.id; }
  bool operator==(const BasicType& other) const { return id == other; }
  bool operator!=(const Type& other) const { return id != other.id; }
  bool operator!=(const BasicType& other) const { return id != other; }

  // Order types by some notion of simplicity
  bool operator<(const Type& other) const;

  // Returns the type size in bytes. Only single types are supported.
  unsigned getByteSize() const;

  // Reinterpret an integer type to a float type with the same size and vice
  // versa. Only single integer and float types are supported.
  Type reinterpret() const;

  // Returns the feature set required to use this type.
  FeatureSet getFeatures() const;

  // Gets the heap type corresponding to this type, assuming that it is a
  // reference or Rtt type.
  HeapType getHeapType() const;

  // Gets the Rtt for this type, assuming that it is an Rtt type.
  Rtt getRtt() const;

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

class HeapType {
  // Unlike `Type`, which represents the types of values on the WebAssembly
  // stack, `HeapType` is used to describe the structures that reference types
  // refer to. HeapTypes are canonicalized and interned exactly like Types and
  // should also be passed by value.
  uintptr_t id;

public:
  enum BasicHeapType : uint32_t {
    func,
    ext,
    exn,
    any,
    eq,
    i31,
  };
  static constexpr BasicHeapType _last_basic_type = i31;

  // BasicHeapType can be implicitly upgraded to HeapType
  constexpr HeapType(BasicHeapType id) : id(id) {}

  // But converting raw TypeID is more dangerous, so make it explicit
  explicit HeapType(TypeID id) : id(id) {}

  HeapType(Signature signature);
  HeapType(const Struct& struct_);
  HeapType(Struct&& struct_);
  HeapType(Array array);

  constexpr bool isBasic() const { return id <= _last_basic_type; }
  constexpr bool isCompound() const { return id > _last_basic_type; }
  bool isFunction() const;
  bool isSignature() const;
  bool isStruct() const;
  bool isArray() const;

  Signature getSignature() const;
  const Struct& getStruct() const;
  Array getArray() const;

  constexpr TypeID getID() const { return id; }
  constexpr BasicHeapType getBasic() const {
    assert(isBasic() && "Basic heap type expected");
    return static_cast<BasicHeapType>(id);
  }

  // (In)equality must be defined for both HeapType and BasicHeapType because it
  // is otherwise ambiguous whether to convert both this and other to int or
  // convert other to HeapType.
  bool operator==(const HeapType& other) const { return id == other.id; }
  bool operator==(const BasicHeapType& other) const { return id == other; }
  bool operator!=(const HeapType& other) const { return id != other.id; }
  bool operator!=(const BasicHeapType& other) const { return id != other; }

  bool operator<(const HeapType& other) const;
  std::string toString() const;
};

typedef std::vector<Type> TypeList;

// Passed by reference rather than by value because it can own an unbounded
// amount of data.
struct Tuple {
  TypeList types;
  Tuple() : types() {}
  Tuple(std::initializer_list<Type> types) : types(types) { validate(); }
  Tuple(const TypeList& types) : types(types) { validate(); }
  Tuple(TypeList&& types) : types(std::move(types)) { validate(); }
  bool operator==(const Tuple& other) const { return types == other.types; }
  bool operator!=(const Tuple& other) const { return !(*this == other); }
  bool operator<(const Tuple& other) const { return types < other.types; }
  std::string toString() const;

  // Prevent accidental copies
  Tuple& operator=(const Tuple&) = delete;

private:
  void validate() {
#ifndef NDEBUG
    for (auto type : types) {
      assert(type.isSingle());
    }
#endif
  }
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
  Mutability mutable_;
  Name name;

  Field(Type type, Mutability mutable_, Name name = Name())
    : type(type), packedType(not_packed), mutable_(mutable_), name(name) {}
  Field(PackedType packedType, Mutability mutable_, Name name = Name())
    : type(Type::i32), packedType(packedType), mutable_(mutable_), name(name) {}

  constexpr bool isPacked() const {
    if (packedType != not_packed) {
      assert(type == Type::i32 && "unexpected type");
      return true;
    }
    return false;
  }

  bool operator==(const Field& other) const {
    // Note that the name is not checked here - it is pure metadata for printing
    // purposes only.
    return type == other.type && packedType == other.packedType &&
           mutable_ == other.mutable_;
  }
  bool operator!=(const Field& other) const { return !(*this == other); }
  bool operator<(const Field& other) const;
  std::string toString() const;
};

typedef std::vector<Field> FieldList;

// Passed by reference rather than by value because it can own an unbounded
// amount of data.
struct Struct {
  FieldList fields;
  Struct(const Struct& other) : fields(other.fields) {}
  Struct(const FieldList& fields) : fields(fields) {}
  Struct(FieldList&& fields) : fields(std::move(fields)) {}
  bool operator==(const Struct& other) const { return fields == other.fields; }
  bool operator!=(const Struct& other) const { return !(*this == other); }
  bool operator<(const Struct& other) const { return fields < other.fields; }
  std::string toString() const;

  // Prevent accidental copies
  Struct& operator=(const Struct&) = delete;
};

struct Array {
  Field element;
  Array(const Array& other) : element(other.element) {}
  Array(Field element) : element(element) {}
  bool operator==(const Array& other) const { return element == other.element; }
  bool operator!=(const Array& other) const { return !(*this == other); }
  bool operator<(const Array& other) const { return element < other.element; }
  std::string toString() const;
};

struct Rtt {
  // An Rtt can have no depth specified
  static constexpr uint32_t NoDepth = -1;
  uint32_t depth;
  HeapType heapType;
  Rtt(HeapType heapType) : depth(NoDepth), heapType(heapType) {}
  Rtt(uint32_t depth, HeapType heapType) : depth(depth), heapType(heapType) {}
  bool operator==(const Rtt& other) const {
    return depth == other.depth && heapType == other.heapType;
  }
  bool operator!=(const Rtt& other) const { return !(*this == other); }
  bool operator<(const Rtt& other) const;
  bool hasDepth() { return depth != uint32_t(NoDepth); }
  std::string toString() const;
};

// TypeBuilder - allows for the construction of recursive types. Contains a
// table of `n` mutable HeapTypes and can construct temporary types that are
// backed by those HeapTypes, refering to them by reference. Those temporary
// types are owned by the TypeBuilder and should only be used in the
// construction of HeapTypes to insert into the TypeBuilder. Temporary types
// should never be used in the construction of normal Types, only other
// temporary types.
struct TypeBuilder {
  struct Impl;
  std::unique_ptr<Impl> impl;

  TypeBuilder(size_t n);
  ~TypeBuilder();

  TypeBuilder(TypeBuilder& other) = delete;
  TypeBuilder(TypeBuilder&& other) = delete;
  TypeBuilder& operator=(TypeBuilder&) = delete;

  // Sets the heap type at index `i`. May only be called before `build`.
  void setHeapType(size_t i, Signature signature);
  void setHeapType(size_t i, const Struct& struct_);
  void setHeapType(size_t i, Struct&& struct_);
  void setHeapType(size_t i, Array array);

  // Gets a temporary type or heap type for use in initializing the
  // TypeBuilder's HeapTypes. Temporary Ref and Rtt types are backed by the
  // HeapType at index `i`.
  Type getTempTupleType(const Tuple&);
  Type getTempRefType(size_t i, Nullability nullable);
  Type getTempRttType(size_t i, uint32_t depth);

  // Canonicalizes and returns all of the heap types. May only be called once
  // all of the heap types have been initialized with `setHeapType`.
  std::vector<HeapType> build();
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
