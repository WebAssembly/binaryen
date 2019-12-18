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
    for (auto vt : types) {
      res = wasm::rehash(res, uint32_t(vt));
    }
    return res;
  }
};

size_t std::hash<wasm::Signature>::
operator()(const wasm::Signature& sig) const {
  return std::hash<uint64_t>{}(uint64_t(sig.params) << 32 |
                               uint64_t(sig.results));
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
  add({Type::anyref});
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
  {{Type::anyref}, Type::anyref},
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
    [](const Type& a, const Type& b) { return uint32_t(a) < uint32_t(b); });
}

bool Signature::operator<(const Signature& other) const {
  if (results < other.results) {
    return true;
  } else if (other.results < results) {
    return false;
  } else {
    return params < other.params;
  }
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

std::ostream& operator<<(std::ostream& os, Type type) {
  switch (type) {
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
    case Type::anyref:
      os << "anyref";
      break;
    case Type::exnref:
      os << "exnref";
      break;
    default: {
      os << '(';
      const std::vector<Type>& types = type.expand();
      for (size_t i = 0; i < types.size(); ++i) {
        os << types[i];
        if (i < types.size() - 1) {
          os << ", ";
        }
      }
      os << ')';
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

std::string Type::toString() const { return genericToString(*this); }

std::string ParamType::toString() const { return genericToString(*this); }

std::string ResultType::toString() const { return genericToString(*this); }

unsigned getTypeSize(Type type) {
  switch (type) {
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
    case Type::anyref: // anyref type is opaque
    case Type::exnref: // exnref type is opaque
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

FeatureSet getFeatures(Type type) {
  FeatureSet feats = FeatureSet::MVP;
  for (Type t : type.expand()) {
    switch (t) {
      case v128:
        feats |= FeatureSet::SIMD;
        break;
      case anyref:
        feats |= FeatureSet::ReferenceTypes;
        break;
      case exnref:
        feats |= FeatureSet::ExceptionHandling;
        break;
      default:
        break;
    }
  }
  return feats;
}

Type getType(unsigned size, bool float_) {
  if (size < 4) {
    return Type::i32;
  }
  if (size == 4) {
    return float_ ? Type::f32 : Type::i32;
  }
  if (size == 8) {
    return float_ ? Type::f64 : Type::i64;
  }
  if (size == 16) {
    return Type::v128;
  }
  WASM_UNREACHABLE("invalid size");
}

Type reinterpretType(Type type) {
  switch (type) {
    case Type::i32:
      return f32;
    case Type::i64:
      return f64;
    case Type::f32:
      return i32;
    case Type::f64:
      return i64;
    case Type::v128:
    case Type::anyref:
    case Type::exnref:
    case Type::none:
    case Type::unreachable:
      WASM_UNREACHABLE("invalid type");
  }
  WASM_UNREACHABLE("invalid type");
}

} // namespace wasm
