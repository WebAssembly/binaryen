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

#include <array>
#include <cassert>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>

#include "compiler-support.h"
#include "support/hash.h"
#include "wasm-features.h"
#include "wasm-type.h"

namespace wasm {

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

} // namespace wasm

namespace std {

template<> class hash<vector<wasm::Type>> {
public:
  size_t operator()(const vector<wasm::Type>& types) const {
    auto digest = wasm::hash(types.size());
    for (auto t : types) {
      wasm::rehash(digest, t.getID());
    }
    return digest;
  }
};

size_t hash<wasm::Type>::operator()(const wasm::Type& type) const {
  return wasm::hash(type.getID());
}

size_t hash<wasm::Signature>::operator()(const wasm::Signature& sig) const {
  auto digest = wasm::hash(sig.params.getID());
  wasm::rehash(digest, sig.results.getID());
  return digest;
}

size_t hash<wasm::Field>::operator()(const wasm::Field& field) const {
  auto digest = wasm::hash(field.type.getID());
  wasm::rehash(digest, uint32_t(field.packedType));
  wasm::rehash(digest, field.mutable_);
  return digest;
}

size_t hash<wasm::TypeDef>::operator()(const wasm::TypeDef& typeDef) const {
  auto kind = typeDef.kind;
  auto digest = wasm::hash(uint32_t(kind));
  switch (kind) {
    case wasm::TypeDef::TupleKind: {
      auto& types = typeDef.tuple.types;
      for (auto t : types) {
        wasm::rehash(digest, t.getID());
      }
      return digest;
    }
    case wasm::TypeDef::SignatureRefKind: {
      auto& sig = typeDef.signatureRef.signature;
      wasm::rehash(digest, sig.params.getID());
      wasm::rehash(digest, sig.results.getID());
      wasm::rehash(digest, typeDef.isNullable());
      return digest;
    }
    case wasm::TypeDef::StructRefKind: {
      auto& fields = typeDef.structRef.struct_.fields;
      wasm::rehash(digest, fields.size());
      for (auto f : fields) {
        wasm::rehash(digest, f);
      }
      wasm::rehash(digest, typeDef.isNullable());
      return digest;
    }
    case wasm::TypeDef::ArrayRefKind: {
      auto& array = typeDef.arrayRef.array;
      wasm::rehash(digest, array.element);
      wasm::rehash(digest, typeDef.isNullable());
      return digest;
    }
  }
  WASM_UNREACHABLE("unexpected kind");
}

} // namespace std

namespace wasm {

namespace {

std::mutex mutex;

// Track unique_ptrs for constructed types to avoid leaks
std::vector<std::unique_ptr<TypeDef>> constructedTypes;

// Maps from constructed types to the canonical Type ID.
std::unordered_map<TypeDef, uintptr_t> indices = {
  // If a Type is constructed from a list of types, the list of types becomes
  // implicitly converted to a TypeDef before canonicalizing its id. This is
  // also the case if a list of just one type is provided, even though such a
  // list of types will be canonicalized to the BasicID of the single type. As
  // such, the following entries are solely placeholders to enable the lookup
  // of lists of just one type to the BasicID of the single type.
  {TypeDef(Tuple()), Type::none},
  {TypeDef({Type::unreachable}), Type::unreachable},
  {TypeDef({Type::i32}), Type::i32},
  {TypeDef({Type::i64}), Type::i64},
  {TypeDef({Type::f32}), Type::f32},
  {TypeDef({Type::f64}), Type::f64},
  {TypeDef({Type::v128}), Type::v128},
  {TypeDef({Type::funcref}), Type::funcref},
  {TypeDef({Type::externref}), Type::externref},
  {TypeDef({Type::nullref}), Type::nullref},
  {TypeDef({Type::exnref}), Type::exnref},
};

} // anonymous namespace

static uintptr_t canonicalize(const TypeDef& typeDef) {
  std::lock_guard<std::mutex> lock(mutex);
  auto indexIt = indices.find(typeDef);
  if (indexIt != indices.end()) {
    return indexIt->second;
  }
  auto ptr = std::make_unique<TypeDef>(typeDef);
  auto id = uintptr_t(ptr.get());
  constructedTypes.push_back(std::move(ptr));
  assert(id > Type::_last_basic_id);
  indices[typeDef] = id;
  return id;
}

static TypeDef* getDef(Type type) { return (TypeDef*)type.getID(); }

Type::Type(std::initializer_list<Type> types) : Type(Tuple(types)) {}

Type::Type(const Tuple& tuple) {
  auto& types = tuple.types;
#ifndef NDEBUG
  for (Type t : types) {
    assert(t.isSingle());
  }
#endif
  if (types.size() == 0) {
    id = none;
    return;
  }
  if (types.size() == 1) {
    *this = types[0];
    return;
  }
  id = canonicalize(TypeDef(tuple));
}

Type::Type(const Signature signature, bool nullable) {
  id = canonicalize(TypeDef(signature, nullable));
}

Type::Type(const Struct& struct_, bool nullable) {
#ifndef NDEBUG
  for (Field f : struct_.fields) {
    assert(f.type.isSingle());
  }
#endif
  id = canonicalize(TypeDef(struct_, nullable));
}

Type::Type(const Array& array, bool nullable) {
  assert(array.element.type.isSingle());
  id = canonicalize(TypeDef(array, nullable));
}

bool Type::isTuple() const {
  if (isBasic()) {
    return false;
  } else {
    return getDef(*this)->isTuple();
  }
}

bool Type::isRef() const {
  if (isBasic()) {
    return id >= funcref && id <= exnref;
  } else {
    switch (getDef(*this)->kind) {
      case TypeDef::TupleKind:
        return false;
      case TypeDef::SignatureRefKind:
      case TypeDef::StructRefKind:
      case TypeDef::ArrayRefKind:
        return true;
    }
    WASM_UNREACHABLE("unexpected kind");
  }
}

bool Type::isNullable() const {
  if (isBasic()) {
    return id >= funcref && id <= exnref;
  } else {
    return getDef(*this)->isNullable();
  }
}

bool Type::operator<(const Type& other) const {
  return std::lexicographical_compare((*this).begin(),
                                      (*this).end(),
                                      other.begin(),
                                      other.end(),
                                      [](const Type& a, const Type& b) {
                                        TODO_SINGLE_COMPOUND(a);
                                        TODO_SINGLE_COMPOUND(b);
                                        return a.getBasic() < b.getBasic();
                                      });
}

unsigned Type::getByteSize() const {
  // TODO: alignment?
  auto getSingleByteSize = [](Type t) {
    switch (t.getBasic()) {
      case Type::i32:
      case Type::f32:
        return 4;
      case Type::i64:
      case Type::f64:
        return 8;
      case Type::v128:
        return 16;
      case Type::funcref:
      case Type::externref:
      case Type::nullref:
      case Type::exnref:
      case Type::none:
      case Type::unreachable:
        break;
    }
    WASM_UNREACHABLE("invalid type");
  };

  if (isTuple()) {
    unsigned size = 0;
    for (auto& t : *this) {
      size += getSingleByteSize(t);
    }
    return size;
  }
  return getSingleByteSize(*this);
}

Type Type::reinterpret() const {
  auto singleType = *(*this).begin();
  switch (singleType.getBasic()) {
    case Type::i32:
      return f32;
    case Type::i64:
      return f64;
    case Type::f32:
      return i32;
    case Type::f64:
      return i64;
    case Type::v128:
    case Type::funcref:
    case Type::externref:
    case Type::nullref:
    case Type::exnref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

FeatureSet Type::getFeatures() const {
  auto getSingleFeatures = [](Type t) -> FeatureSet {
    TODO_SINGLE_COMPOUND(t);
    switch (t.getBasic()) {
      case Type::v128:
        return FeatureSet::SIMD;
      case Type::funcref:
      case Type::externref:
      case Type::nullref:
        return FeatureSet::ReferenceTypes;
      case Type::exnref:
        return FeatureSet::ReferenceTypes | FeatureSet::ExceptionHandling;
      default:
        return FeatureSet::MVP;
    }
  };

  if (isTuple()) {
    FeatureSet feats = FeatureSet::Multivalue;
    for (auto& t : *this) {
      feats |= getSingleFeatures(t);
    }
    return feats;
  }
  return getSingleFeatures(*this);
}

Type Type::get(unsigned byteSize, bool float_) {
  if (byteSize < 4) {
    return Type::i32;
  }
  if (byteSize == 4) {
    return float_ ? Type::f32 : Type::i32;
  }
  if (byteSize == 8) {
    return float_ ? Type::f64 : Type::i64;
  }
  if (byteSize == 16) {
    return Type::v128;
  }
  WASM_UNREACHABLE("invalid size");
}

bool Type::isSubType(Type left, Type right) {
  if (left == right) {
    return true;
  }
  if (left.isRef() && right.isRef() &&
      (right == Type::externref || left == Type::nullref)) {
    return true;
  }
  if (left.isTuple() && right.isTuple()) {
    if (left.size() != right.size()) {
      return false;
    }
    for (size_t i = 0; i < left.size(); ++i) {
      if (!isSubType(left[i], right[i])) {
        return false;
      }
    }
    return true;
  }
  return false;
}

Type Type::getLeastUpperBound(Type a, Type b) {
  if (a == b) {
    return a;
  }
  if (a == Type::unreachable) {
    return b;
  }
  if (b == Type::unreachable) {
    return a;
  }
  if (a.size() != b.size()) {
    return Type::none; // a poison value that must not be consumed
  }
  if (a.isTuple()) {
    TypeList types;
    types.resize(a.size());
    for (size_t i = 0; i < types.size(); ++i) {
      types[i] = getLeastUpperBound(a[i], b[i]);
      if (types[i] == Type::none) {
        return Type::none;
      }
    }
    return Type(types);
  }
  if (!a.isRef() || !b.isRef()) {
    return Type::none;
  }
  if (a == Type::nullref) {
    return b;
  }
  if (b == Type::nullref) {
    return a;
  }
  return Type::externref;
}

Type::Iterator Type::end() const {
  if (isTuple()) {
    return Iterator(this, getDef(*this)->tuple.types.size());
  } else {
    // TODO: unreachable is special and expands to {unreachable} currently.
    // see also: https://github.com/WebAssembly/binaryen/issues/3062
    return Iterator(this, size_t(id != Type::none));
  }
}

const Type& Type::Iterator::operator*() const {
  if (parent->isTuple()) {
    return getDef(*parent)->tuple.types[index];
  } else {
    // TODO: see comment in Type::end()
    assert(index == 0 && parent->id != Type::none && "Index out of bounds");
    return *parent;
  }
}

const Type& Type::operator[](size_t index) const {
  if (isTuple()) {
    return getDef(*this)->tuple.types[index];
  } else {
    assert(index == 0 && "Index out of bounds");
    return *begin();
  }
}

namespace {

std::ostream&
printPrefixedTypes(std::ostream& os, const char* prefix, Type type) {
  os << '(' << prefix;
  for (auto& t : type) {
    os << " " << t;
  }
  os << ')';
  return os;
}

template<typename T> std::string genericToString(const T& t) {
  std::ostringstream ss;
  ss << t;
  return ss.str();
}

} // anonymous namespace

std::string Type::toString() const { return genericToString(*this); }

std::string ParamType::toString() const { return genericToString(*this); }

std::string ResultType::toString() const { return genericToString(*this); }

std::string Tuple::toString() const { return genericToString(*this); }

std::string Signature::toString() const { return genericToString(*this); }

std::string Struct::toString() const { return genericToString(*this); }

std::string Array::toString() const { return genericToString(*this); }

std::string TypeDef::toString() const { return genericToString(*this); }

bool Signature::operator<(const Signature& other) const {
  if (results < other.results) {
    return true;
  } else if (other.results < results) {
    return false;
  } else {
    return params < other.params;
  }
}

std::ostream& operator<<(std::ostream& os, Type type) {
  if (type.isBasic()) {
    switch (type.getBasic()) {
      case Type::none:
        os << "none";
        break;
      case Type::unreachable:
        os << "unreachable";
        break;
      case Type::i32:
        os << "i32";
        break;
      case Type::i64:
        os << "i64";
        break;
      case Type::f32:
        os << "f32";
        break;
      case Type::f64:
        os << "f64";
        break;
      case Type::v128:
        os << "v128";
        break;
      case Type::funcref:
        os << "funcref";
        break;
      case Type::externref:
        os << "externref";
        break;
      case Type::nullref:
        os << "nullref";
        break;
      case Type::exnref:
        os << "exnref";
        break;
    }
  } else {
    os << *getDef(type);
  }
  return os;
}

std::ostream& operator<<(std::ostream& os, ParamType param) {
  return printPrefixedTypes(os, "param", param.type);
}

std::ostream& operator<<(std::ostream& os, ResultType param) {
  return printPrefixedTypes(os, "result", param.type);
}

std::ostream& operator<<(std::ostream& os, Tuple tuple) {
  auto& types = tuple.types;
  auto size = types.size();
  os << "(";
  if (size) {
    os << types[0];
    for (size_t i = 1; i < size; ++i) {
      os << " " << types[i];
    }
  }
  return os << ")";
}

std::ostream& operator<<(std::ostream& os, Signature sig) {
  os << "(func";
  if (sig.params.getID() != Type::none) {
    os << " ";
    printPrefixedTypes(os, "param", sig.params);
  }
  if (sig.results.getID() != Type::none) {
    os << " ";
    printPrefixedTypes(os, "result", sig.results);
  }
  return os << ")";
}

std::ostream& operator<<(std::ostream& os, Field field) {
  if (field.mutable_) {
    os << "(mut ";
  }
  if (field.isPacked()) {
    auto packedType = field.packedType;
    if (packedType == Field::PackedType::i8) {
      os << "i8";
    } else if (packedType == Field::PackedType::i16) {
      os << "i16";
    } else {
      WASM_UNREACHABLE("unexpected packed type");
    }
  } else {
    os << field.type;
  }
  if (field.mutable_) {
    os << ")";
  }
  return os;
};

std::ostream& operator<<(std::ostream& os, Struct struct_) {
  os << "(struct";
  if (struct_.fields.size()) {
    os << " (field";
    for (auto f : struct_.fields) {
      os << " " << f;
    }
    os << ")";
  }
  return os << ")";
}

std::ostream& operator<<(std::ostream& os, Array array) {
  return os << "(array " << array.element << ")";
}

std::ostream& operator<<(std::ostream& os, TypeDef typeDef) {
  switch (typeDef.kind) {
    case TypeDef::TupleKind: {
      return os << typeDef.tuple;
    }
    case TypeDef::SignatureRefKind: {
      os << "(ref ";
      if (typeDef.signatureRef.nullable) {
        os << "null ";
      }
      return os << typeDef.signatureRef.signature << ")";
    }
    case TypeDef::StructRefKind: {
      os << "(ref ";
      if (typeDef.structRef.nullable) {
        os << "null ";
      }
      return os << typeDef.structRef.struct_ << ")";
    }
    case TypeDef::ArrayRefKind: {
      os << "(ref ";
      if (typeDef.arrayRef.nullable) {
        os << "null ";
      }
      return os << typeDef.arrayRef.array << ")";
    }
  }
  WASM_UNREACHABLE("unexpected kind");
}

} // namespace wasm
