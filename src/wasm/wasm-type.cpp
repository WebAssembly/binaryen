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

#include <cassert>
#include <shared_mutex>
#include <sstream>
#include <unordered_map>

#include "compiler-support.h"
#include "support/hash.h"
#include "wasm-features.h"
#include "wasm-type.h"

template<> class std::hash<std::vector<wasm::Type>> {
public:
  size_t operator()(const std::vector<wasm::Type>& types) const {
    uint32_t res = wasm::rehash(0, uint32_t(types.size()));
    for (auto t : types) {
      res = wasm::rehash(res, t.getID());
    }
    return res;
  }
};

size_t std::hash<wasm::Signature>::
operator()(const wasm::Signature& sig) const {
  return std::hash<uint64_t>{}(uint64_t(sig.params.getID()) << 32 |
                               uint64_t(sig.results.getID()));
}

namespace wasm {

namespace {

// TODO: switch to std::shared_mutex in C++17
std::shared_timed_mutex mutex;

std::vector<std::unique_ptr<std::vector<Type>>> typeLists = [] {
  std::vector<std::unique_ptr<std::vector<Type>>> lists;

  auto add = [&](std::initializer_list<Type> types) {
    return lists.push_back(std::make_unique<std::vector<Type>>(types));
  };

  add({});
  add({Type::unreachable});
  add({Type::i32});
  add({Type::i64});
  add({Type::f32});
  add({Type::f64});
  add({Type::v128});
  add({Type::funcref});
  add({Type::anyref});
  add({Type::nullref});
  add({Type::exnref});
  return lists;
}();

std::unordered_map<std::vector<Type>, uint32_t> indices = {
  {{}, Type::none},
  {{Type::unreachable}, Type::unreachable},
  {{Type::i32}, Type::i32},
  {{Type::i64}, Type::i64},
  {{Type::f32}, Type::f32},
  {{Type::f64}, Type::f64},
  {{Type::v128}, Type::v128},
  {{Type::funcref}, Type::funcref},
  {{Type::anyref}, Type::anyref},
  {{Type::nullref}, Type::nullref},
  {{Type::exnref}, Type::exnref},
};

} // anonymous namespace

void Type::init(const std::vector<Type>& types) {
#ifndef NDEBUG
  for (Type t : types) {
    assert(t.isSingle() && t.isConcrete());
  }
#endif

  auto lookup = [&]() {
    auto indexIt = indices.find(types);
    if (indexIt != indices.end()) {
      id = indexIt->second;
      return true;
    } else {
      return false;
    }
  };

  {
    // Try to look up previously interned type
    std::shared_lock<std::shared_timed_mutex> lock(mutex);
    if (lookup()) {
      return;
    }
  }
  {
    // Add a new type if it hasn't been added concurrently
    std::lock_guard<std::shared_timed_mutex> lock(mutex);
    if (lookup()) {
      return;
    }
    id = typeLists.size();
    typeLists.push_back(std::make_unique<std::vector<Type>>(types));
    indices[types] = id;
  }
}

Type::Type(std::initializer_list<Type> types) { init(types); }

Type::Type(const std::vector<Type>& types) { init(types); }

size_t Type::size() const { return expand().size(); }

const std::vector<Type>& Type::expand() const {
  std::shared_lock<std::shared_timed_mutex> lock(mutex);
  assert(id < typeLists.size());
  return *typeLists[id].get();
}

bool Type::operator<(const Type& other) const {
  const std::vector<Type>& these = expand();
  const std::vector<Type>& others = other.expand();
  return std::lexicographical_compare(
    these.begin(),
    these.end(),
    others.begin(),
    others.end(),
    [](const Type& a, const Type& b) { return a.getSingle() < b.getSingle(); });
}

unsigned Type::getByteSize() const {
  assert(isSingle() && "getByteSize does not works with single types");
  Type singleType = *expand().begin();
  switch (singleType.getSingle()) {
    case Type::i32:
      return 4;
    case Type::i64:
      return 8;
    case Type::f32:
      return 4;
    case Type::f64:
      return 8;
    case Type::v128:
      return 16;
    case Type::funcref:
    case Type::anyref:
    case Type::nullref:
    case Type::exnref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
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
    case Type::anyref:
    case Type::nullref:
    case Type::exnref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

FeatureSet Type::getFeatures() const {
  FeatureSet feats = FeatureSet::MVP;
  for (Type t : expand()) {
    switch (t.getSingle()) {
      case Type::v128:
        feats |= FeatureSet::SIMD;
        break;
      case Type::anyref:
        feats |= FeatureSet::ReferenceTypes;
        break;
      case Type::exnref:
        feats |= FeatureSet::ExceptionHandling;
        break;
      default:
        break;
    }
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
      (right == Type::anyref || left == Type::nullref)) {
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
    std::vector<Type> types;
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
  return Type::anyref;
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
  if (type.isMulti()) {
    os << '(';
    const std::vector<Type>& types = type.expand();
    for (size_t i = 0; i < types.size(); ++i) {
      os << types[i];
      if (i < types.size() - 1) {
        os << ", ";
      }
    }
    os << ')';
  } else {
    switch (type.getSingle()) {
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
      case Type::anyref:
        os << "anyref";
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
