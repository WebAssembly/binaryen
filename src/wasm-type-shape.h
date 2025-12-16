/*
 * Copyright 2024 WebAssembly Community Group participants
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

#ifndef wasm_wasm_type_shape_h
#define wasm_wasm_type_shape_h

#include <functional>
#include <list>
#include <unordered_set>
#include <vector>

#include "wasm-features.h"
#include "wasm-type.h"

namespace wasm {

// Provides hashing and equality comparison for a sequence of types. The hashing
// and equality differentiate the top-level structure of each type in the
// sequence and the equality of referenced heap types that are not in the
// recursion group, but for references to types that are in the recursion group,
// it considers only the index of the referenced type within the group. That
// means that recursion groups containing different types can compare and hash
// as equal as long as their internal structure and external references are the
// same.
struct RecGroupShape {
  const std::vector<HeapType>& types;

  // Depending on the feature set, some types may be generalized when they are
  // written out. Take the features into account to ensure our comparisons
  // account for the rec groups that will ultimately be written.
  const FeatureSet features;

  RecGroupShape(const std::vector<HeapType>& types, const FeatureSet features)
    : types(types), features(features) {}

  bool operator==(const RecGroupShape& other) const;
  bool operator!=(const RecGroupShape& other) const {
    return !(*this == other);
  }
};

// Extends `RecGroupShape` with ordered comparison of rec group structures.
// Requires the user to supply a global ordering on heap types to be able to
// compare differing references to external types.
// TODO: This can all be upgraded to use C++20 three-way comparisons.
struct ComparableRecGroupShape : RecGroupShape {
  std::function<bool(HeapType, HeapType)> less;

  ComparableRecGroupShape(const std::vector<HeapType>& types,
                          FeatureSet features,
                          std::function<bool(HeapType, HeapType)> less)
    : RecGroupShape(types, features), less(less) {}

  bool operator<(const RecGroupShape& other) const;
  bool operator>(const RecGroupShape& other) const;
  bool operator<=(const RecGroupShape& other) const { return !(*this > other); }
  bool operator>=(const RecGroupShape& other) const { return !(*this < other); }
};

} // namespace wasm

namespace std {

template<> class hash<wasm::RecGroupShape> {
public:
  size_t operator()(const wasm::RecGroupShape& shape) const;
};

} // namespace std

namespace wasm {

// Provides an infinite sequence of possible brand types, prioritizing those
// with the most compact encoding.
struct BrandTypeIterator {
  static constexpr Index optionCount = 18;
  static constexpr std::array<Field, optionCount> fieldOptions = {{
    Field(Field::i8, Mutable),
    Field(Field::i16, Mutable),
    Field(Type::i32, Mutable),
    Field(Type::i64, Mutable),
    Field(Type::f32, Mutable),
    Field(Type::f64, Mutable),
    Field(Type(HeapType::any, Nullable), Mutable),
    Field(Type(HeapType::func, Nullable), Mutable),
    Field(Type(HeapType::ext, Nullable), Mutable),
    Field(Type(HeapType::none, Nullable), Mutable),
    Field(Type(HeapType::nofunc, Nullable), Mutable),
    Field(Type(HeapType::noext, Nullable), Mutable),
    Field(Type(HeapType::any, NonNullable), Mutable),
    Field(Type(HeapType::func, NonNullable), Mutable),
    Field(Type(HeapType::ext, NonNullable), Mutable),
    Field(Type(HeapType::none, NonNullable), Mutable),
    Field(Type(HeapType::nofunc, NonNullable), Mutable),
    Field(Type(HeapType::noext, NonNullable), Mutable),
  }};

  struct FieldInfo {
    uint8_t index = 0;
    bool immutable = false;

    operator Field() const {
      auto field = fieldOptions[index];
      if (immutable) {
        field.mutable_ = Immutable;
      }
      return field;
    }

    bool advance() {
      if (!immutable) {
        immutable = true;
        return true;
      }
      immutable = false;
      index = (index + 1) % optionCount;
      return index != 0;
    }
  };

  bool useArray = false;
  std::vector<FieldInfo> fields;

  HeapType operator*() const {
    if (useArray) {
      return Array(fields[0]);
    }
    return Struct(std::vector<Field>(fields.begin(), fields.end()));
  }

  BrandTypeIterator& operator++() {
    for (Index i = fields.size(); i > 0; --i) {
      if (fields[i - 1].advance()) {
        return *this;
      }
    }
    if (useArray) {
      useArray = false;
      return *this;
    }
    fields.emplace_back();
    useArray = fields.size() == 1;
    return *this;
  }
};

// A set of unique rec group shapes. Upon inserting a new group of types, if it
// has the same shape as a previously inserted group, the types will be rebuilt
// with an extra brand type at the end of the group that differentiates it from
// previous group.
struct UniqueRecGroups {
  std::list<std::vector<HeapType>> groups;
  std::unordered_set<RecGroupShape> shapes;

  FeatureSet features;

  UniqueRecGroups(FeatureSet features) : features(features) {}

  // Insert a rec group. If it is already unique, return the original types.
  // Otherwise rebuild the group  make it unique and return the rebuilt types,
  // including the brand.
  const std::vector<HeapType>& insert(std::vector<HeapType> group);
};

} // namespace wasm

#endif // wasm_wasm_type_shape_h
