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

#include <shared_mutex>
#include <unordered_map>

#include "wasm-type.h"
#include "wasm-features.h"

#include "compiler-support.h"

template<> class std::hash<std::vector<wasm::Type::ValueType>> {
public:
  size_t operator()(const std::vector<wasm::Type::ValueType>& types) const {
    size_t res = 0;
    for (auto vt : types) {
      res ^= hash<int>{}(vt);
    }
    return res;
  }
};

namespace wasm {

namespace {

// TODO: switch to std::shared_mutex in C++17
std::shared_timed_mutex mutex;

std::vector<std::vector<Type::ValueType>> typeLists = {
  {},
  {},
  {Type::i32},
  {Type::i64},
  {Type::f32},
  {Type::f64},
  {Type::v128},
  {Type::anyref},
  {Type::exnref},
};

std::unordered_map<std::vector<Type::ValueType>, uint32_t> indices = {
  {{}, Type::unreachable},
  {{}, Type::none},
  {{Type::i32}, Type::i32},
  {{Type::i64}, Type::i64},
  {{Type::f32}, Type::f32},
  {{Type::f64}, Type::f64},
  {{Type::v128}, Type::v128},
  {{Type::anyref}, Type::anyref},
  {{Type::exnref}, Type::exnref},
};

} // anonymous namespace

Type::Type(const std::vector<ValueType>& types) {
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
    typeLists.push_back(types);
    indices[types] = id;
  }
}

size_t Type::getNumValueTypes() const {
  std::shared_lock<std::shared_timed_mutex> lock(mutex);
  assert(id < typeLists.size());
  return typeLists[id].size();
}

const std::vector<Type::ValueType> Type::getValueTypes() const {
  std::shared_lock<std::shared_timed_mutex> lock(mutex);
  assert(id < typeLists.size());
  return typeLists[id];
}

const std::string printType(Type type) {
  switch (type) {
    case Type::none:
      return "none";
    case Type::i32:
      return "i32";
    case Type::i64:
      return "i64";
    case Type::f32:
      return "f32";
    case Type::f64:
      return "f64";
    case Type::v128:
      return "v128";
    case Type::anyref:
      return "anyref";
    case Type::exnref:
      return "exnref";
    case Type::unreachable:
      return "unreachable";
    default: {
      std::vector<Type::ValueType> vts = type.getValueTypes();
      std::string res("(");
      for (size_t i = 0; i < vts.size() - 1; ++i) {
        res += ", ";
        res += printType(vts[i]);
      }
      res += printType(vts.back());
      res += ")";
      return res;
    }
  }
}

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
      WASM_UNREACHABLE();
  }
  WASM_UNREACHABLE();
}

FeatureSet getFeatures(Type type) {
  switch (type) {
    case v128:
      return FeatureSet::SIMD;
    case anyref:
      return FeatureSet::ReferenceTypes;
    case exnref:
      return FeatureSet::ExceptionHandling;
    default:
      return FeatureSet();
  }
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
  WASM_UNREACHABLE();
}

Type getReachableType(Type a, Type b) { return a != unreachable ? a : b; }

bool isConcreteType(Type type) { return type != none && type != unreachable; }

bool isIntegerType(Type type) {
  switch (type) {
    case i32:
    case i64:
      return true;
    default:
      return false;
  }
}

bool isFloatType(Type type) {
  switch (type) {
    case f32:
    case f64:
      return true;
    default:
      return false;
  }
}

bool isVectorType(Type type) { return type == v128; }

bool isReferenceType(Type type) {
  switch (type) {
    case anyref:
    case exnref:
      return true;
    default:
      return false;
  }
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
      WASM_UNREACHABLE();
  }
  WASM_UNREACHABLE();
}

} // namespace wasm
