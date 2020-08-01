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
      wasm::hash_combine<uint64_t>(res, t.getID());
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

size_t hash<wasm::TypeDef>::operator()(const wasm::TypeDef& typeDef) const {
  auto kind = typeDef.getKind();
  auto res = hash<uint32_t>{}(uint32_t(kind));
  switch (kind) {
    case wasm::TypeDef::TupleKind: {
      auto& tuple = typeDef.def.tupleDef.tuple;
      for (auto t : tuple) {
        wasm::hash_combine(res, t.getID());
      }
      break;
    }
    case wasm::TypeDef::SignatureKind: {
      auto& sig = typeDef.def.signatureDef.signature;
      wasm::hash_combine(res, sig.params.getID());
      wasm::hash_combine(res, sig.results.getID());
      break;
    }
    case wasm::TypeDef::StructKind: {
      auto& struct_ = typeDef.def.structDef.struct_;
      auto& fields = struct_.fields;
      wasm::hash_combine(res, fields.size());
      for (auto f : fields) {
        wasm::hash_combine(res, f.type.getID());
        wasm::hash_combine(res, f.mutable_);
      }
      wasm::hash_combine(res, struct_.nullable);
      break;
    }
    case wasm::TypeDef::ArrayKind: {
      auto& array = typeDef.def.arrayDef.array;
      wasm::hash_combine(res, array.element.type.getID());
      wasm::hash_combine(res, array.element.mutable_);
      wasm::hash_combine(res, array.nullable);
      break;
    }
    default:
      WASM_UNREACHABLE("unexpected type");
  }
  return res;
}

} // namespace std

namespace wasm {

namespace {

std::mutex mutex;

// Track unique_ptrs for constructed types to avoid leaks
std::vector<std::unique_ptr<TypeDef>> complexTypes;

// Maps from complex types to the canonical Type ID.
// Also maps tuples of a single basic type to the basic type.
std::unordered_map<TypeDef, uintptr_t> complexIndices = {
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

// Maps from the canonical Type ID to complex types.
// Also maps basic types to tuples of the single basic type.
std::unordered_map<uintptr_t, TypeDef> complexLookup = {
  {Type::none, TypeDef(Tuple())},
  {Type::unreachable, TypeDef({Type::unreachable})},
  {Type::i32, TypeDef({Type::i32})},
  {Type::i64, TypeDef({Type::i64})},
  {Type::f32, TypeDef({Type::f32})},
  {Type::f64, TypeDef({Type::f64})},
  {Type::v128, TypeDef({Type::v128})},
  {Type::funcref, TypeDef({Type::funcref})},
  {Type::externref, TypeDef({Type::externref})},
  {Type::nullref, TypeDef({Type::nullref})},
  {Type::exnref, TypeDef({Type::exnref})},
};

} // anonymous namespace

static uintptr_t canonicalize(const TypeDef& typeDef) {
  std::lock_guard<std::mutex> lock(mutex);
  auto indexIt = complexIndices.find(typeDef);
  if (indexIt != complexIndices.end()) {
    return indexIt->second;
  }
  auto ptr = std::make_unique<TypeDef>(typeDef);
  auto id = uintptr_t(ptr.get());
  complexTypes.push_back(std::move(ptr));
  assert(id > Type::_last_value_type);
  complexIndices[typeDef] = id;
  complexLookup.emplace(id, typeDef);
  return id;
}

Type::Type(std::initializer_list<Type> types) : Type(Tuple(types)) {}

Type::Type(const Tuple& tuple) {
#ifndef NDEBUG
  for (Type t : tuple) {
    assert(t.isSingle() && t.isConcrete());
  }
#endif
  if (tuple.size() == 0) {
    id = none;
    return;
  }
  if (tuple.size() == 1) {
    *this = tuple[0];
    return;
  }
  id = canonicalize(TypeDef(tuple));
}

Type::Type(const Signature& signature) {
  id = canonicalize(TypeDef(signature));
}

Type::Type(const Struct& struct_) {
#ifndef NDEBUG
  for (Field f : struct_.fields) {
    assert(f.type.isSingle() && f.type.isConcrete());
  }
#endif
  id = canonicalize(TypeDef(struct_));
}

Type::Type(const Array& array) {
#ifndef NDEBUG
  assert(array.element.type.isSingle() && array.element.type.isConcrete());
#endif
  id = canonicalize(TypeDef(array));
}

bool Type::isMulti() const {
  if (id > _last_value_type) {
    std::lock_guard<std::mutex> lock(mutex);
    auto it = complexLookup.find(id);
    if (it != complexLookup.end()) {
      return it->second.def.tupleDef.kind == TypeDef::TupleKind;
    }
  }
  return false;
}

bool Type::isRef() const {
  if (id > _last_value_type) {
    std::lock_guard<std::mutex> lock(mutex);
    auto it = complexLookup.find(id);
    if (it != complexLookup.end()) {
      switch (it->second.getKind()) {
        case TypeDef::SignatureKind:
        case TypeDef::StructKind:
        case TypeDef::ArrayKind:
          return true;
        default:
          return false;
      }
    }
  }
  return id >= funcref && id <= exnref;
}

size_t Type::size() const { return expand().size(); }

const Tuple& Type::expand() const {
  std::lock_guard<std::mutex> lock(mutex);
  auto it = complexLookup.find(id);
  if (it != complexLookup.end()) {
    auto& typeDef = it->second;
    if (typeDef.getKind() == TypeDef::TupleKind) {
      return typeDef.def.tupleDef.tuple;
    }
  }
  WASM_UNREACHABLE("invalid type");
}

bool Type::operator<(const Type& other) const {
  const Tuple& these = expand();
  const Tuple& others = other.expand();
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
  if (left.isMulti() && right.isMulti()) {
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
  if (a.isMulti()) {
    Tuple types;
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
    default: {
      assert(id > Type::_last_value_type);
      std::lock_guard<std::mutex> lock(mutex);
      auto it = complexLookup.find(id);
      if (it != complexLookup.end()) {
        auto& typeDef = it->second;
        switch (typeDef.getKind()) {
          case TypeDef::TupleKind: {
            auto& tuple = typeDef.def.tupleDef.tuple;
            os << '(';
            for (size_t i = 0; i < tuple.size(); ++i) {
              os << tuple[i];
              if (i < tuple.size() - 1) {
                os << ", ";
              }
            }
            os << ')';
            break;
          }
          case TypeDef::SignatureKind: {
            auto& signature = typeDef.def.signatureDef.signature;
            os << signature;
            break;
          }
          case TypeDef::StructKind: {
            auto& struct_ = typeDef.def.structDef.struct_;
            os << struct_;
            break;
          }
          case TypeDef::ArrayKind: {
            auto& array = typeDef.def.arrayDef.array;
            os << array;
            break;
          }
          default:
            WASM_UNREACHABLE("invalid type kind");
        }
      }
    }
  }
  return os;
}

std::ostream& operator<<(std::ostream& os, ParamType param) {
  return printPrefixedTypes(os, "param", param.type);
}

std::ostream& operator<<(std::ostream& os, ResultType param) {
  return printPrefixedTypes(os, "result", param.type);
}

std::ostream& operator<<(std::ostream& os, Signature sig) {
  return os << "Signature(" << sig.params << " => " << sig.results << ")";
}

std::ostream& operator<<(std::ostream& os, Struct struct_) {
  os << "struct";
  auto& fields = struct_.fields;
  for (auto f : fields) {
    if (f.mutable_) {
      os << " (mut " << f.type << ")";
    } else {
      os << " " << f.type;
    }
  }
  return os;
}

std::ostream& operator<<(std::ostream& os, Array array) {
  os << "array";
  auto& element = array.element;
  if (element.mutable_) {
    os << " (mut " << element.type << ")";
  } else {
    os << element.type;
  }
  return os;
}

} // namespace wasm
