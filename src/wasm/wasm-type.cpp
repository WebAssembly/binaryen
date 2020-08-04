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

namespace std {

template<> class hash<vector<wasm::Type>> {
public:
  size_t operator()(const vector<wasm::Type>& types) const {
    auto res = hash<size_t>{}(types.size());
    for (auto t : types) {
      wasm::hash_combine(res, t.getID());
    }
    return res;
  }
};

size_t hash<wasm::Type>::operator()(const wasm::Type& type) const {
  return hash<uint64_t>{}(type.getID());
}

size_t hash<wasm::Signature>::operator()(const wasm::Signature& sig) const {
  auto res = hash<uint64_t>{}(sig.params.getID());
  wasm::hash_combine(res, sig.results.getID());
  return res;
}

size_t hash<wasm::Field>::operator()(const wasm::Field& field) const {
  auto res = hash<uint64_t>{}(field.type.getID());
  wasm::hash_combine(res, uint32_t(field.packedType));
  wasm::hash_combine(res, field.mutable_);
  return res;
}

size_t hash<wasm::TypeDef>::operator()(const wasm::TypeDef& typeDef) const {
  auto kind = typeDef.kind;
  auto res = hash<uint32_t>{}(uint32_t(kind));
  switch (kind) {
    case wasm::TypeDef::TupleKind: {
      auto& types = typeDef.tupleDef.tuple.types;
      for (auto t : types) {
        wasm::hash_combine(res, t.getID());
      }
      return res;
    }
    case wasm::TypeDef::SignatureKind: {
      auto& sig = typeDef.signatureDef.signature;
      wasm::hash_combine(res, sig.params.getID());
      wasm::hash_combine(res, sig.results.getID());
      wasm::hash_combine(res, typeDef.isNullable());
      return res;
    }
    case wasm::TypeDef::StructKind: {
      auto& fields = typeDef.structDef.struct_.fields;
      wasm::hash_combine(res, fields.size());
      for (auto f : fields) {
        wasm::hash_combine(res, f);
      }
      wasm::hash_combine(res, typeDef.isNullable());
      return res;
    }
    case wasm::TypeDef::ArrayKind: {
      auto& array = typeDef.arrayDef.array;
      wasm::hash_combine(res, array.element);
      wasm::hash_combine(res, typeDef.isNullable());
      return res;
    }
  }
  WASM_UNREACHABLE("unexpected kind");
}

} // namespace std

namespace wasm {

namespace {

std::mutex mutex;

// Maps basic types to tuples of the single basic type.
std::array<TypeList, Type::_last_basic_id + 1> basicTuples = {{
  {},
  {Type::unreachable},
  {Type::i32},
  {Type::i64},
  {Type::f32},
  {Type::f64},
  {Type::v128},
  {Type::funcref},
  {Type::externref},
  {Type::nullref},
  {Type::exnref},
}};

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

Type::Type(std::initializer_list<Type> types) : Type(Tuple(types)) {}

Type::Type(const Tuple& tuple) {
  auto& types = tuple.types;
#ifndef NDEBUG
  for (Type t : types) {
    assert(t.isSingle() && t.isConcrete());
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
    assert(f.type.isSingle() && f.type.isConcrete());
  }
#endif
  id = canonicalize(TypeDef(struct_, nullable));
}

Type::Type(const Array& array, bool nullable) {
#ifndef NDEBUG
  assert(array.element.type.isSingle() && array.element.type.isConcrete());
#endif
  id = canonicalize(TypeDef(array, nullable));
}

bool Type::isTuple() const {
  if (id <= _last_basic_id) {
    return false;
  } else {
    auto* typeDef = (TypeDef*)id;
    return typeDef->isTuple();
  }
}

bool Type::isRef() const {
  if (id <= _last_basic_id) {
    return id >= funcref && id <= exnref;
  } else {
    auto* typeDef = (TypeDef*)id;
    switch (typeDef->kind) {
      case TypeDef::TupleKind:
        return false;
      case TypeDef::SignatureKind:
      case TypeDef::StructKind:
      case TypeDef::ArrayKind:
        return true;
    }
    WASM_UNREACHABLE("unexpected kind");
  }
}

bool Type::isNullable() const {
  if (id <= _last_basic_id) {
    return id >= funcref && id <= exnref;
  } else {
    auto* typeDef = (TypeDef*)id;
    return typeDef->isNullable();
  }
}

size_t Type::size() const { return expand().size(); }

const TypeList& Type::expand() const {
  if (id <= Type::_last_basic_id) {
    return basicTuples[id];
  } else {
    auto* typeDef = (TypeDef*)id;
    assert(typeDef->isTuple() && "can only expand tuple types");
    return typeDef->tupleDef.tuple.types;
  }
}

bool Type::operator<(const Type& other) const {
  const TypeList& these = expand();
  const TypeList& others = other.expand();
  return std::lexicographical_compare(
    these.begin(),
    these.end(),
    others.begin(),
    others.end(),
    [](const Type& a, const Type& b) { return a.getSingle() < b.getSingle(); });
}

unsigned Type::getByteSize() const {
  // TODO: alignment?
  auto getSingleByteSize = [](Type t) {
    switch (t.getSingle()) {
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

  if (isSingle()) {
    return getSingleByteSize(*this);
  }

  unsigned size = 0;
  for (auto t : expand()) {
    size += getSingleByteSize(t);
  }
  return size;
}

Type Type::reinterpret() const {
  assert(isSingle() && "reinterpretType only works with single types");
  Type singleType = *expand().begin();
  switch (singleType.getSingle()) {
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
    switch (t.getSingle()) {
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

  if (isSingle()) {
    return getSingleFeatures(*this);
  }

  FeatureSet feats = FeatureSet::Multivalue;
  for (Type t : expand()) {
    feats |= getSingleFeatures(t);
  }
  return feats;
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
    const auto& leftElems = left.expand();
    const auto& rightElems = right.expand();
    if (leftElems.size() != rightElems.size()) {
      return false;
    }
    for (size_t i = 0; i < leftElems.size(); ++i) {
      if (!isSubType(leftElems[i], rightElems[i])) {
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
    const auto& as = a.expand();
    const auto& bs = b.expand();
    for (size_t i = 0; i < types.size(); ++i) {
      types[i] = getLeastUpperBound(as[i], bs[i]);
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

namespace {

std::ostream&
printPrefixedTypes(std::ostream& os, const char* prefix, Type type) {
  os << '(' << prefix;
  for (auto t : type.expand()) {
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
  auto id = type.getID();
  switch (id) {
    case Type::none:
      return os << "none";
    case Type::unreachable:
      return os << "unreachable";
    case Type::i32:
      return os << "i32";
    case Type::i64:
      return os << "i64";
    case Type::f32:
      return os << "f32";
    case Type::f64:
      return os << "f64";
    case Type::v128:
      return os << "v128";
    case Type::funcref:
      return os << "funcref";
    case Type::externref:
      return os << "externref";
    case Type::nullref:
      return os << "nullref";
    case Type::exnref:
      return os << "exnref";
  }
  auto* typeDef = (TypeDef*)id;
  switch (typeDef->kind) {
    case TypeDef::TupleKind:
      break;
    case TypeDef::SignatureKind:
    case TypeDef::StructKind:
    case TypeDef::ArrayKind:
      os << "ref ";
      break;
  }
  return os << *typeDef;
}

std::ostream& operator<<(std::ostream& os, ParamType param) {
  return printPrefixedTypes(os, "param", param.type);
}

std::ostream& operator<<(std::ostream& os, ResultType param) {
  return printPrefixedTypes(os, "result", param.type);
}

std::ostream& operator<<(std::ostream& os, Tuple tuple) {
  os << "(";
  auto& types = tuple.types;
  auto size = types.size();
  if (size) {
    os << types[0];
    for (size_t i = 1; i < size; ++i) {
      os << " " << types[i];
    }
  }
  os << ")";
  return os;
}

std::ostream& operator<<(std::ostream& os, Signature sig) {
  os << "func";
  if (sig.params.getID() != Type::none) {
    os << " (";
    printPrefixedTypes(os, "param", sig.params);
    os << ")";
  }
  if (sig.results.getID() != Type::none) {
    os << " (";
    printPrefixedTypes(os, "result", sig.results);
    os << ")";
  }
  return os;
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
  os << "struct";
  for (auto f : struct_.fields) {
    os << " " << f;
  }
  return os;
}

std::ostream& operator<<(std::ostream& os, Array array) {
  return os << "array " << array.element;
}

std::ostream& operator<<(std::ostream& os, TypeDef typeDef) {
  switch (typeDef.kind) {
    case TypeDef::TupleKind: {
      return os << typeDef.tupleDef.tuple;
    }
    case TypeDef::SignatureKind: {
      if (typeDef.signatureDef.nullable) {
        os << "null ";
      }
      return os << typeDef.signatureDef.signature;
    }
    case TypeDef::StructKind: {
      if (typeDef.structDef.nullable) {
        os << "null ";
      }
      return os << typeDef.structDef.struct_;
    }
    case TypeDef::ArrayKind: {
      if (typeDef.arrayDef.nullable) {
        os << "null ";
      }
      return os << typeDef.arrayDef.array;
    }
  }
  WASM_UNREACHABLE("unexpected kind");
}

} // namespace wasm
