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

#include <functional>
#include <optional>
#include <ostream>
#include <string>
#include <variant>
#include <vector>

#include "support/index.h"
#include "support/name.h"
#include "support/parent_index_iterator.h"
#include "wasm-features.h"

// TODO: At various code locations we were assuming that single types are basic
// types, but this is going to change with the introduction of the compound
// Signature, Struct and Array types that will be single but not basic. To
// prepare for this change, the following macro marks affected code locations.
#define TODO_SINGLE_COMPOUND(type)                                             \
  assert(!type.isTuple() && "Unexpected tuple type");                          \
  assert(type.isBasic() && "TODO: handle compound types");

namespace wasm {

enum class TypeSystem {
  Equirecursive,
  Nominal,
  Isorecursive,
};

// This should only ever be called before any Types or HeapTypes have been
// created. The default system is equirecursive.
void setTypeSystem(TypeSystem system);

TypeSystem getTypeSystem();

// Dangerous! Frees all types and heap types that have ever been created and
// resets the type system's internal state. This is only really meant to be used
// for tests.
void destroyAllTypesForTestingPurposesOnly();

// The types defined in this file. All of them are small and typically passed by
// value except for `Tuple` and `Struct`, which may own an unbounded amount of
// data.
class Type;
class HeapType;
class RecGroup;
struct Tuple;
struct Signature;
struct Field;
struct Struct;
struct Array;
struct Rtt;

enum Nullability { NonNullable, Nullable };
enum Mutability { Immutable, Mutable };

// HeapType name information used for printing.
struct TypeNames {
  // The name of the type.
  Name name;
  // For a Struct, names of fields.
  std::unordered_map<Index, Name> fieldNames;
};

// Used to generate HeapType names.
using HeapTypeNameGenerator = std::function<TypeNames(HeapType)>;

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
    anyref,
    eqref,
    i31ref,
    dataref,
  };
  static constexpr BasicType _last_basic_type = dataref;

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
  // │ anyref      ║ x │   │ x │ x │ f? n  │ │  f_unc
  // │ eqref       ║ x │   │ x │ x │    n  │ │  n_ullable
  // │ i31ref      ║ x │   │ x │ x │       │ │
  // │ dataref     ║ x │   │ x │ x │       │ │
  // ├─ Compound ──╫───┼───┼───┼───┤───────┤ │
  // │ Ref         ║   │ x │ x │ x │ f? n? │◄┘
  // │ Tuple       ║   │ x │   │ x │       │
  // │ Rtt         ║   │ x │ x │ x │       │
  // └─────────────╨───┴───┴───┴───┴───────┘
  constexpr bool isBasic() const { return id <= _last_basic_type; }
  constexpr bool isConcrete() const { return id >= i32; }
  constexpr bool isInteger() const { return id == i32 || id == i64; }
  constexpr bool isFloat() const { return id == f32 || id == f64; }
  constexpr bool isVector() const { return id == v128; };
  constexpr bool isNumber() const { return id >= i32 && id <= v128; }
  bool isTuple() const;
  bool isSingle() const { return isConcrete() && !isTuple(); }
  bool isRef() const;
  bool isFunction() const;
  bool isData() const;
  // Checks whether a type is a reference and is nullable. This returns false
  // for a value that is not a reference, that is, for which nullability is
  // irrelevant.
  bool isNullable() const;
  // Checks whether a type is a reference and is non-nullable. This returns
  // false for a value that is not a reference, that is, for which nullability
  // is irrelevant. (For that reason, this is only the negation of isNullable()
  // on references, but both return false on non-references.)
  bool isNonNullable() const;
  bool isRtt() const;
  bool isStruct() const;
  bool isArray() const;
  bool isDefaultable() const;

  // Check if a type is either defaultable or non-nullable. This is useful in
  // the case where we allow non-nullable types, but we disallow other things
  // that are non-defaultable. For example, when GC-non-nullable references are
  // allowed we can have  a non-nullable reference, but we cannot have any other
  // nondefaultable type.
  bool isDefaultableOrNonNullable() const;

  Nullability getNullability() const;

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

  // Returns the type size in bytes. Only single types are supported.
  unsigned getByteSize() const;

  // Returns whether the type has a size in bytes. This is the same as whether
  // it can be stored in linear memory. Things like references do not have this
  // property, while numbers do. Tuples may or may not depending on their
  // contents.
  unsigned hasByteSize() const;

  // Reinterpret an integer type to a float type with the same size and vice
  // versa. Only single integer and float types are supported.
  Type reinterpret() const;

  // Returns the feature set required to use this type.
  FeatureSet getFeatures() const;

  // Returns the tuple, assuming that this is a tuple type. Note that it is
  // normally simpler to use operator[] and size() on the Type directly.
  const Tuple& getTuple() const;

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

  // Return the ordered HeapType children, looking through child Types.
  std::vector<HeapType> getHeapTypeChildren();

  // Computes the least upper bound from the type lattice.
  // If one of the type is unreachable, the other type becomes the result. If
  // the common supertype does not exist, returns none, a poison value.
  static bool hasLeastUpperBound(Type a, Type b);
  static Type getLeastUpperBound(Type a, Type b);
  template<typename T> static bool hasLeastUpperBound(const T& types) {
    auto first = types.begin(), end = types.end();
    if (first == end) {
      return false;
    }
    for (auto second = std::next(first); second != end;) {
      if (!hasLeastUpperBound(*first++, *second++)) {
        return false;
      }
    }
    return true;
  }
  template<typename T> static Type getLeastUpperBound(const T& types) {
    auto it = types.begin(), end = types.end();
    if (it == end) {
      return Type::none;
    }
    Type lub = *it++;
    for (; it != end; ++it) {
      lub = getLeastUpperBound(lub, *it);
      if (lub == Type::none) {
        return Type::none;
      }
    }
    return lub;
  }

  // Helper allowing the value of `print(...)` to be sent to an ostream. Stores
  // a `TypeID` because `Type` is incomplete at this point and using a reference
  // makes it less convenient to use.
  struct Printed {
    TypeID typeID;
    HeapTypeNameGenerator generateName;
  };

  // Given a function for generating non-basic HeapType names, print this Type
  // to `os`.`generateName` should return the same name each time it is called
  // with the same HeapType and it should return different names for different
  // types.
  Printed print(HeapTypeNameGenerator generateName) {
    return Printed{getID(), generateName};
  }

  std::string toString() const;

  size_t size() const;

  struct Iterator : ParentIndexIterator<const Type*, Iterator> {
    using value_type = Type;
    using pointer = const Type*;
    using reference = const Type&;
    reference operator*() const;
  };

  Iterator begin() const { return Iterator{{this, 0}}; }
  Iterator end() const { return Iterator{{this, size()}}; }
  std::reverse_iterator<Iterator> rbegin() const {
    return std::make_reverse_iterator(end());
  }
  std::reverse_iterator<Iterator> rend() const {
    return std::make_reverse_iterator(begin());
  }
  const Type& operator[](size_t i) const { return *Iterator{{this, i}}; }
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
    any,
    eq,
    i31,
    data,
  };
  static constexpr BasicHeapType _last_basic_type = data;

  // BasicHeapType can be implicitly upgraded to HeapType
  constexpr HeapType(BasicHeapType id) : id(id) {}

  // But converting raw TypeID is more dangerous, so make it explicit
  explicit HeapType(TypeID id) : id(id) {}

  // Choose an arbitrary heap type as the default.
  constexpr HeapType() : HeapType(func) {}

  // Construct a HeapType referring to the single canonical HeapType for the
  // given signature. In nominal mode, this is the first HeapType created with
  // this signature.
  HeapType(Signature signature);

  // Create a HeapType with the given structure. In equirecursive mode, this may
  // be the same as a previous HeapType created with the same contents. In
  // nominal mode, this will be a fresh type distinct from all previously
  // created HeapTypes.
  // TODO: make these explicit to differentiate them.
  HeapType(const Struct& struct_);
  HeapType(Struct&& struct_);
  HeapType(Array array);

  constexpr bool isBasic() const { return id <= _last_basic_type; }
  bool isFunction() const;
  bool isData() const;
  bool isSignature() const;
  bool isStruct() const;
  bool isArray() const;

  Signature getSignature() const;
  const Struct& getStruct() const;
  Array getArray() const;

  // If there is a nontrivial (i.e. non-basic) nominal supertype, return it,
  // else an empty optional.
  std::optional<HeapType> getSuperType() const;

  // Return the depth of this heap type in the nominal type hierarchy, i.e. the
  // number of supertypes in its supertype chain.
  size_t getDepth() const;

  // Get the recursion group for this non-basic type.
  RecGroup getRecGroup() const;
  size_t getRecGroupIndex() const;

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

  // Returns true if left is a subtype of right. Subtype includes itself.
  static bool isSubType(HeapType left, HeapType right);

  // Return the ordered HeapType children, looking through child Types.
  std::vector<HeapType> getHeapTypeChildren() const;

  // Similar to `getHeapTypeChildren`, but also includes the supertype if it
  // exists.
  std::vector<HeapType> getReferencedHeapTypes() const;

  // Return the LUB of two HeapTypes. The LUB always exists.
  static HeapType getLeastUpperBound(HeapType a, HeapType b);

  // Helper allowing the value of `print(...)` to be sent to an ostream. Stores
  // a `TypeID` because `Type` is incomplete at this point and using a reference
  // makes it less convenient to use.
  struct Printed {
    TypeID typeID;
    HeapTypeNameGenerator generateName;
  };

  // Given a function for generating HeapType names, print the definition of
  // this HeapType to `os`. `generateName` should return the same
  // name each time it is called with the same HeapType and it should return
  // different names for different types.
  Printed print(HeapTypeNameGenerator generateName) {
    return Printed{getID(), generateName};
  }

  std::string toString() const;
};

// A recursion group consisting of one or more HeapTypes. HeapTypes with single
// members are encoded without using any additional memory, which is why
// `getHeapTypes` has to return a vector by value; it might have to create one
// on the fly.
class RecGroup {
  uintptr_t id;

public:
  explicit RecGroup(uintptr_t id) : id(id) {}
  constexpr TypeID getID() const { return id; }
  bool operator==(const RecGroup& other) const { return id == other.id; }
  bool operator!=(const RecGroup& other) const { return id != other.id; }
  size_t size() const;

  struct Iterator : ParentIndexIterator<const RecGroup*, Iterator> {
    using value_type = HeapType;
    using pointer = const HeapType*;
    using reference = const HeapType&;
    value_type operator*() const;
  };

  Iterator begin() const { return Iterator{{this, 0}}; }
  Iterator end() const { return Iterator{{this, size()}}; }
  HeapType operator[](size_t i) const { return *Iterator{{this, i}}; }
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
  std::string toString() const;

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

  // Arbitrary defaults for convenience.
  Field() : type(Type::i32), packedType(not_packed), mutable_(Mutable) {}
  Field(Type type, Mutability mutable_)
    : type(type), packedType(not_packed), mutable_(mutable_) {}
  Field(PackedType packedType, Mutability mutable_)
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

  unsigned getByteSize() const;
};

typedef std::vector<Field> FieldList;

// Passed by reference rather than by value because it can own an unbounded
// amount of data.
struct Struct {
  FieldList fields;
  Struct() = default;
  Struct(const Struct& other) : fields(other.fields) {}
  Struct(const FieldList& fields) : fields(fields) {}
  Struct(FieldList&& fields) : fields(std::move(fields)) {}
  bool operator==(const Struct& other) const { return fields == other.fields; }
  bool operator!=(const Struct& other) const { return !(*this == other); }
  std::string toString() const;

  // Prevent accidental copies
  Struct& operator=(const Struct&) = delete;
};

struct Array {
  Field element;
  Array() = default;
  Array(const Array& other) : element(other.element) {}
  Array(Field element) : element(element) {}
  bool operator==(const Array& other) const { return element == other.element; }
  bool operator!=(const Array& other) const { return !(*this == other); }
  std::string toString() const;
};

struct Rtt {
  // An Rtt can have no depth specified
  static constexpr uint32_t NoDepth = -1;
  uint32_t depth;
  HeapType heapType;
  explicit Rtt(HeapType heapType) : depth(NoDepth), heapType(heapType) {}
  Rtt(uint32_t depth, HeapType heapType) : depth(depth), heapType(heapType) {}
  bool operator==(const Rtt& other) const {
    return depth == other.depth && heapType == other.heapType;
  }
  bool operator!=(const Rtt& other) const { return !(*this == other); }
  bool hasDepth() const { return depth != uint32_t(NoDepth); }
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
  TypeBuilder() : TypeBuilder(0) {}
  ~TypeBuilder();

  TypeBuilder(TypeBuilder& other) = delete;
  TypeBuilder& operator=(TypeBuilder&) = delete;

  TypeBuilder(TypeBuilder&& other);
  TypeBuilder& operator=(TypeBuilder&& other);

  // Append `n` new uninitialized HeapType slots to the end of the TypeBuilder.
  void grow(size_t n);

  // The number of HeapType slots in the TypeBuilder.
  size_t size();

  // Sets the heap type at index `i`. May only be called before `build`. The
  // BasicHeapType overload may not be used in nominal mode.
  void setHeapType(size_t i, HeapType::BasicHeapType basic);
  void setHeapType(size_t i, Signature signature);
  void setHeapType(size_t i, const Struct& struct_);
  void setHeapType(size_t i, Struct&& struct_);
  void setHeapType(size_t i, Array array);

  // This is an ugly hack around the fact that temp heap types initialized with
  // BasicHeapTypes are not themselves considered basic, so `HeapType::isBasic`
  // and `HeapType::getBasic` do not work as expected with them. Call these
  // methods instead.
  bool isBasic(size_t i);
  HeapType::BasicHeapType getBasic(size_t i);

  // Gets the temporary HeapType at index `i`. This HeapType should only be used
  // to construct temporary Types using the methods below.
  HeapType getTempHeapType(size_t i);

  // Gets a temporary type or heap type for use in initializing the
  // TypeBuilder's HeapTypes. For Ref and Rtt types, the HeapType may be a
  // temporary HeapType owned by this builder or a canonical HeapType.
  Type getTempTupleType(const Tuple&);
  Type getTempRefType(HeapType heapType, Nullability nullable);
  Type getTempRttType(Rtt rtt);

  // In nominal mode, or for nominal types, declare the HeapType being built at
  // index `i` to be an immediate subtype of the HeapType being built at index
  // `j`. Does nothing for equirecursive types.
  void setSubType(size_t i, size_t j);

  // Create a new recursion group covering slots [i, i + length). Groups must
  // not overlap or go out of bounds.
  void createRecGroup(size_t i, size_t length);

  enum class ErrorReason {
    // There is a cycle in the supertype relation.
    SelfSupertype,
    // The declared supertype of a type is invalid.
    InvalidSupertype,
    // The declared supertype is an invalid forward reference.
    ForwardSupertypeReference,
    // A child of the type is an invalid forward reference.
    ForwardChildReference,
  };

  struct Error {
    // The index of the type causing the failure.
    size_t index;
    ErrorReason reason;
  };

  struct BuildResult : std::variant<std::vector<HeapType>, Error> {
    operator bool() const {
      return bool(std::get_if<std::vector<HeapType>>(this));
    }
    const std::vector<HeapType>& operator*() const {
      return std::get<std::vector<HeapType>>(*this);
    }
    const Error* getError() const { return std::get_if<Error>(this); }
  };

  // Returns all of the newly constructed heap types. May only be called once
  // all of the heap types have been initialized with `setHeapType`. In nominal
  // mode, all of the constructed HeapTypes will be fresh and distinct. In
  // nominal mode, will also produce a fatal error if the declared subtype
  // relationships are not valid.
  BuildResult build();

  // Utility for ergonomically using operator[] instead of explicit setHeapType
  // and getTempHeapType methods.
  struct Entry {
    TypeBuilder& builder;
    size_t index;
    operator HeapType() const { return builder.getTempHeapType(index); }
    Entry& operator=(HeapType::BasicHeapType basic) {
      builder.setHeapType(index, basic);
      return *this;
    }
    Entry& operator=(Signature signature) {
      builder.setHeapType(index, signature);
      return *this;
    }
    Entry& operator=(const Struct& struct_) {
      builder.setHeapType(index, struct_);
      return *this;
    }
    Entry& operator=(Struct&& struct_) {
      builder.setHeapType(index, std::move(struct_));
      return *this;
    }
    Entry& operator=(Array array) {
      builder.setHeapType(index, array);
      return *this;
    }
    Entry& subTypeOf(Entry other) {
      assert(&builder == &other.builder);
      builder.setSubType(index, other.index);
      return *this;
    }
  };

  Entry operator[](size_t i) { return Entry{*this, i}; }
};

std::ostream& operator<<(std::ostream&, Type);
std::ostream& operator<<(std::ostream&, Type::Printed);
std::ostream& operator<<(std::ostream&, HeapType);
std::ostream& operator<<(std::ostream&, HeapType::Printed);
std::ostream& operator<<(std::ostream&, Tuple);
std::ostream& operator<<(std::ostream&, Signature);
std::ostream& operator<<(std::ostream&, Field);
std::ostream& operator<<(std::ostream&, Struct);
std::ostream& operator<<(std::ostream&, Array);
std::ostream& operator<<(std::ostream&, Rtt);
std::ostream& operator<<(std::ostream&, TypeBuilder::ErrorReason);

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
template<> class hash<wasm::RecGroup> {
public:
  size_t operator()(const wasm::RecGroup&) const;
};

} // namespace std

#endif // wasm_wasm_type_h
