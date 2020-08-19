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

} // namespace std

namespace wasm {

namespace {

std::mutex mutex;

std::array<std::vector<Type>, Type::_last_value_type + 1> basicTypes = {
  {{},
   {Type::unreachable},
   {Type::i32},
   {Type::i64},
   {Type::f32},
   {Type::f64},
   {Type::v128},
   {Type::funcref},
   {Type::externref},
   {Type::nullref},
   {Type::exnref}}};

// Track unique_ptrs for constructed types to avoid leaks
std::vector<std::unique_ptr<std::vector<Type>>> constructedTypes;

// Maps from type vectors to the canonical Type ID
std::unordered_map<std::vector<Type>, uintptr_t> indices = {
  {{}, Type::none},
  {{Type::unreachable}, Type::unreachable},
  {{Type::i32}, Type::i32},
  {{Type::i64}, Type::i64},
  {{Type::f32}, Type::f32},
  {{Type::f64}, Type::f64},
  {{Type::v128}, Type::v128},
  {{Type::funcref}, Type::funcref},
  {{Type::externref}, Type::externref},
  {{Type::nullref}, Type::nullref},
  {{Type::exnref}, Type::exnref},
};

} // anonymous namespace

void Type::init(const std::vector<Type>& types) {
#ifndef NDEBUG
  for (Type t : types) {
    assert(!t.isMulti() && t.isConcrete());
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

  // Add a new type if it hasn't been added concurrently
  std::lock_guard<std::mutex> lock(mutex);
  auto indexIt = indices.find(types);
  if (indexIt != indices.end()) {
    id = indexIt->second;
  } else {
    auto vec = std::make_unique<std::vector<Type>>(types);
    id = uintptr_t(vec.get());
    constructedTypes.push_back(std::move(vec));
    assert(id > _last_value_type);
    indices[types] = id;
  }
}

Type::Type(std::initializer_list<Type> types) { init(types); }

Type::Type(const std::vector<Type>& types) { init(types); }

size_t Type::size() const {
  if (isMulti()) {
    return (*(std::vector<Type>*)getID()).size();
  }
  return size_t(getID() != Type::none);
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

  if (isMulti()) {
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

  if (isMulti()) {
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
  if (left.isMulti() && right.isMulti()) {
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
  if (a.isMulti()) {
    std::vector<Type> types;
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
  if (type.isMulti()) {
    os << '(';
    auto sep = "";
    for (auto& t : type) {
      os << sep << t;
      sep = ", ";
    }
    os << ')';
  } else {
    TODO_SINGLE_COMPOUND(type);
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

} // namespace wasm
