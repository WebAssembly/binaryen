/*
 * Copyright 2021 WebAssembly Community Group participants
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

#include <variant>

#include "tools/fuzzing/heap-types.h"
#include "tools/fuzzing/parameters.h"

namespace wasm {

namespace {

struct HeapTypeGenerator {
  Random& rand;
  FeatureSet features;
  TypeBuilder builder;

  // Map the HeapTypes we are building to their indices in the builder.
  std::unordered_map<HeapType, Index> typeIndices;

  // For each type we will build, the indices of its subtypes we will build.
  std::vector<std::vector<Index>> subtypeIndices;

  // Abstract over all the types that may be assigned to a builder slot.
  using Assignable =
    std::variant<HeapType::BasicHeapType, Signature, Struct, Array>;

  // Top-level kinds, chosen before the types are actually constructed. This
  // allows us to choose HeapTypes that we know will be subtypes of data or func
  // before we actually generate the types.
  using BasicKind = HeapType::BasicHeapType;
  struct SignatureKind {};
  struct DataKind {};
  using HeapTypeKind = std::variant<BasicKind, SignatureKind, DataKind>;
  std::vector<HeapTypeKind> typeKinds;

  HeapTypeGenerator(Random& rand, FeatureSet features, size_t n)
    : rand(rand), features(features), builder(n), subtypeIndices(n) {}

  HeapType::BasicHeapType generateBasicHeapType() {
    return rand.pick(HeapType::func,
                     HeapType::ext,
                     HeapType::any,
                     HeapType::eq,
                     HeapType::i31,
                     HeapType::data);
  }

  Type::BasicType generateBasicType() {
    return rand.pick(
      Random::FeatureOptions<Type::BasicType>{}
        .add(FeatureSet::MVP, Type::i32, Type::i64, Type::f32, Type::f64)
        .add(FeatureSet::SIMD, Type::v128)
        .add(FeatureSet::ReferenceTypes | FeatureSet::GC,
             Type::funcref,
             Type::externref,
             Type::anyref,
             Type::eqref,
             Type::i31ref,
             Type::dataref));
  }

  HeapType generateHeapType() {
    if (rand.oneIn(4)) {
      return generateBasicHeapType();
    } else {
      return builder[rand.upTo(builder.size())];
    }
  }

  Type generateRefType() {
    auto heapType = generateHeapType();
    auto nullability = rand.oneIn(2) ? Nullable : NonNullable;
    return builder.getTempRefType(heapType, nullability);
  }

  Type generateRttType() {
    auto heapType = generateHeapType();
    auto depth = rand.oneIn(2) ? Rtt::NoDepth : rand.upTo(MAX_RTT_DEPTH);
    return builder.getTempRttType(Rtt(depth, heapType));
  }

  Type generateSingleType() {
    switch (rand.upTo(3)) {
      case 0:
        return generateBasicType();
      case 1:
        return generateRefType();
      case 2:
        return generateRttType();
    }
    WASM_UNREACHABLE("unexpected");
  }

  Type generateTupleType() {
    std::vector<Type> types(2 + rand.upTo(MAX_TUPLE_SIZE - 1));
    for (auto& type : types) {
      type = generateSingleType();
    }
    return builder.getTempTupleType(Tuple(types));
  }

  Type generateReturnType() {
    if (rand.oneIn(6)) {
      return Type::none;
    } else if (features.hasMultivalue() && rand.oneIn(5)) {
      return generateTupleType();
    } else {
      return generateSingleType();
    }
  }

  Signature generateSignature() {
    std::vector<Type> types(rand.upToSquared(MAX_PARAMS));
    for (auto& type : types) {
      type = generateSingleType();
    }
    auto params = builder.getTempTupleType(types);
    return {params, generateReturnType()};
  }

  Field generateField() {
    auto mutability = rand.oneIn(2) ? Mutable : Immutable;
    if (rand.oneIn(6)) {
      return {rand.oneIn(2) ? Field::i8 : Field::i16, mutability};
    } else {
      return {generateSingleType(), mutability};
    }
  }

  Struct generateStruct() {
    std::vector<Field> fields(rand.upTo(MAX_STRUCT_SIZE + 1));
    for (auto& field : fields) {
      field = generateField();
    }
    return {fields};
  }

  Array generateArray() { return {generateField()}; }

  Assignable generateSubData() {
    switch (rand.upTo(2)) {
      case 0:
        return generateStruct();
      case 1:
        return generateArray();
    }
    WASM_UNREACHABLE("unexpected index");
  }

  Assignable generateSubEq() {
    switch (rand.upTo(3)) {
      case 0:
        return HeapType::i31;
      case 1:
        return HeapType::data;
      case 2:
        return generateSubData();
    }
    WASM_UNREACHABLE("unexpected index");
  }

  Assignable generateSubAny() {
    switch (rand.upTo(4)) {
      case 0:
        return HeapType::eq;
      case 1:
        return HeapType::func;
      case 2:
        return generateSubEq();
      case 3:
        return generateSignature();
    }
    WASM_UNREACHABLE("unexpected index");
  }

  Assignable generateSubBasic(HeapType::BasicHeapType type) {
    if (rand.oneIn(2)) {
      return type;
    } else {
      switch (type) {
        case HeapType::ext:
        case HeapType::i31:
          // No other subtypes.
          return type;
        case HeapType::func:
          return generateSignature();
        case HeapType::any:
          return generateSubAny();
        case HeapType::eq:
          return generateSubEq();
        case HeapType::data:
          return generateSubData();
      }
      WASM_UNREACHABLE("unexpected index");
    }
  }

  template<typename Kind> std::optional<HeapType> pickKind() {
    std::vector<HeapType> candidates;
    // Iterate through the top level kinds, finding matches for `Kind`.
    for (Index i = 0; i < typeKinds.size(); ++i) {
      if (std::get_if<Kind>(&typeKinds[i])) {
        candidates.push_back(builder[i]);
      }
    }
    if (candidates.size()) {
      return rand.pick(candidates);
    } else {
      return {};
    }
  }

  HeapType pickSubFunc() {
    if (auto type = pickKind<SignatureKind>()) {
      return *type;
    } else {
      return HeapType::func;
    }
  }

  HeapType pickSubData() {
    if (auto type = pickKind<DataKind>()) {
      return *type;
    } else {
      return HeapType::data;
    }
  }

  HeapType pickSubEq() {
    if (rand.oneIn(2)) {
      return HeapType::i31;
    } else {
      return pickSubData();
    }
  }

  HeapType pickSubAny() {
    switch (rand.upTo(4)) {
      case 0:
        return HeapType::func;
      case 1:
        return HeapType::eq;
      case 2:
        return pickSubFunc();
      case 3:
        return pickSubEq();
    }
    WASM_UNREACHABLE("unexpected index");
  }

  HeapType pickSubHeapType(HeapType type) {
    auto it = typeIndices.find(type);
    if (it != typeIndices.end()) {
      // This is a constructed type, so we know where its subtypes are.
      return builder[rand.pick(subtypeIndices[typeIndices[type]])];
    } else {
      // This is not a constructed type, so it must be a basic type.
      assert(type.isBasic());
      switch (type.getBasic()) {
        case HeapType::func:
          return pickSubFunc();
        case HeapType::ext:
          return HeapType::ext;
        case HeapType::any:
          return pickSubAny();
        case HeapType::eq:
          return pickSubEq();
        case HeapType::i31:
          return HeapType::i31;
        case HeapType::data:
          return pickSubData();
      }
      WASM_UNREACHABLE("unexpected kind");
    }
  }

  // TODO: Make this part of the wasm-type.h API
  struct Ref {
    HeapType type;
    Nullability nullability;
  };

  Ref generateSubRef(Ref super) {
    auto nullability = super.nullability == NonNullable
                         ? NonNullable
                         : rand.oneIn(2) ? Nullable : NonNullable;
    return {pickSubHeapType(super.type), nullability};
  }

  Rtt generateSubRtt(Rtt super) {
    auto depth = super.hasDepth()
                   ? super.depth
                   : rand.oneIn(2) ? Rtt::NoDepth : rand.upTo(MAX_RTT_DEPTH);
    return {depth, super.heapType};
  }

  Type generateSubtype(Type type) {
    if (type.isRef()) {
      auto ref = generateSubRef({type.getHeapType(), type.getNullability()});
      return builder.getTempRefType(ref.type, ref.nullability);
    } else if (type.isRtt()) {
      auto rtt = generateSubRtt(type.getRtt());
      return builder.getTempRttType(rtt);
    } else if (type.isBasic()) {
      // Non-reference basic types do not have subtypes.
      return type;
    } else {
      WASM_UNREACHABLE("unexpected type kind");
    }
  }

  Signature generateSubSignature(Signature super) {
    // TODO: Update this once we support nontrivial function subtyping.
    return super;
  }

  Field generateSubField(Field super) {
    if (super.mutable_ == Mutable) {
      // Only immutable fields support subtyping.
      return super;
    }
    if (super.isPacked()) {
      // No other subtypes of i8 or i16.
      return super;
    }
    return {generateSubtype(super.type), Immutable};
  }

  Struct generateSubStruct(const Struct& super) {
    if (rand.oneIn(2)) {
      return super;
    }
    std::vector<Field> fields;
    // Depth subtyping
    for (auto field : super.fields) {
      fields.push_back(generateSubField(field));
    }
    // Width subtyping
    Index extra = rand.upTo(MAX_STRUCT_SIZE + 1 - fields.size());
    for (Index i = 0; i < extra; ++i) {
      fields.push_back(generateField());
    }
    return {fields};
  }

  Array generateSubArray(Array super) {
    if (rand.oneIn(2)) {
      return super;
    }
    return {generateSubField(super.element)};
  }

  HeapTypeKind generateHeapTypeKind() {
    switch (rand.upTo(3)) {
      case 0:
        return SignatureKind{};
      case 1:
        return DataKind{};
      case 2:
        return BasicKind{generateBasicHeapType()};
    }
    WASM_UNREACHABLE("unexpected index");
  }

  HeapTypeKind getSubKind(HeapTypeKind super) {
    if (auto* basic = std::get_if<BasicKind>(&super)) {
      if (rand.oneIn(8)) {
        return super;
      }
      switch (*basic) {
        case HeapType::func:
          return SignatureKind{};
        case HeapType::ext:
        case HeapType::i31:
          return super;
        case HeapType::any:
          return generateHeapTypeKind();
        case HeapType::eq:
          if (rand.oneIn(4)) {
            return HeapType::i31;
          } else {
            return DataKind{};
          }
        case HeapType::data:
          return DataKind{};
      }
      WASM_UNREACHABLE("unexpected kind");
    } else {
      // Signature and Data types can only have Signature and Data subtypes.
      return super;
    }
  }

  std::vector<HeapType> generate() {
    // Set up the subtype relationships. Start with some number of root types,
    // then after that start creating subtypes of existing types. Determine the
    // top-level kind of each type in advance so that we can appropriately use
    // types we haven't constructed yet.
    // TODO: Determine individually whether each HeapType is nominal once
    // mixing type systems is expected to work.
    typeKinds.reserve(builder.size());
    std::vector<std::optional<Index>> supertypeIndices(builder.size());
    Index numRoots = 1 + rand.upTo(builder.size());
    for (Index i = 0; i < builder.size(); ++i) {
      typeIndices.insert({builder[i], i});
      // Everything is a subtype of itself.
      subtypeIndices[i].push_back(i);
      if (i < numRoots) {
        // This is a root type with no supertype. Choose a kind for this type.
        typeKinds.emplace_back(generateHeapTypeKind());
      } else {
        // This is a subtype. Choose one of the previous types to be the
        // supertype.
        Index super = rand.upTo(i);
        builder[i].subTypeOf(builder[super]);
        supertypeIndices[i] = super;
        subtypeIndices[super].push_back(i);
        typeKinds.push_back(getSubKind(typeKinds[super]));
      }
    }

    // Create the heap types.
    for (Index i = 0; i < builder.size(); ++i) {
      auto kind = typeKinds[i];
      if (auto* basic = std::get_if<BasicKind>(&kind)) {
        // The type is already determined.
        builder[i] = *basic;
      } else if (!supertypeIndices[i] ||
                 builder.isBasic(*supertypeIndices[i])) {
        // No nontrivial supertype, so create a root type.
        if (std::get_if<SignatureKind>(&kind)) {
          builder[i] = generateSignature();
        } else if (std::get_if<DataKind>(&kind)) {
          if (rand.oneIn(2)) {
            builder[i] = generateStruct();
          } else {
            builder[i] = generateArray();
          }
        } else {
          WASM_UNREACHABLE("unexpected kind");
        }
      } else {
        // We have a supertype, so create a subtype.
        HeapType supertype = builder[*supertypeIndices[i]];
        if (supertype.isSignature()) {
          builder[i] = generateSubSignature(supertype.getSignature());
        } else if (supertype.isStruct()) {
          builder[i] = generateSubStruct(supertype.getStruct());
        } else if (supertype.isArray()) {
          builder[i] = generateSubArray(supertype.getArray());
        } else {
          WASM_UNREACHABLE("unexpected kind");
        }
      }
    }
    return builder.build();
  }
};

} // anonymous namespace

namespace HeapTypeFuzzer {

std::vector<HeapType>
generateHeapTypes(Random& rand, FeatureSet features, size_t n) {
  return HeapTypeGenerator(rand, features, n).generate();
}

} // namespace HeapTypeFuzzer

} // namespace wasm
