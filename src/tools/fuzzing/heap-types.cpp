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

struct HeapTypeGeneratorImpl {
  HeapTypeGenerator result;
  TypeBuilder& builder;
  std::vector<std::vector<Index>>& subtypeIndices;
  std::vector<std::optional<Index>> supertypeIndices;
  Random& rand;
  FeatureSet features;

  // Map the HeapTypes we are building to their indices in the builder.
  std::unordered_map<HeapType, Index> typeIndices;

  // Top-level kinds, chosen before the types are actually constructed. This
  // allows us to choose HeapTypes that we know will be subtypes of data or func
  // before we actually generate the types.
  using BasicKind = HeapType::BasicHeapType;
  struct SignatureKind {};
  struct StructKind {};
  struct ArrayKind {};
  using HeapTypeKind =
    std::variant<BasicKind, SignatureKind, StructKind, ArrayKind>;
  std::vector<HeapTypeKind> typeKinds;

  // For each type, the index one past the end of its recursion group, used to
  // determine what types could be valid children. Alternatively, the cumulative
  // size of the current and prior rec groups at each type index.
  std::vector<Index> recGroupEnds;

  // The index of the type we are currently generating.
  Index index = 0;

  HeapTypeGeneratorImpl(Random& rand, FeatureSet features, size_t n)
    : result{TypeBuilder(n),
             std::vector<std::vector<Index>>(n),
             std::vector<std::optional<Index>>(n)},
      builder(result.builder), subtypeIndices(result.subtypeIndices),
      supertypeIndices(n), rand(rand), features(features) {
    // Set up the subtype relationships. Start with some number of root types,
    // then after that start creating subtypes of existing types. Determine the
    // top-level kind of each type in advance so that we can appropriately use
    // types we haven't constructed yet. For simplicity, always choose a
    // supertype to bea previous type, which is valid in all type systems.
    typeKinds.reserve(builder.size());
    supertypeIndices.reserve(builder.size());
    Index numRoots = 1 + rand.upTo(builder.size());
    for (Index i = 0; i < builder.size(); ++i) {
      typeIndices.insert({builder[i], i});
      // Everything is a subtype of itself.
      subtypeIndices[i].push_back(i);
      if (i < numRoots || rand.oneIn(2)) {
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

    // Initialize the recursion groups.
    recGroupEnds.reserve(builder.size());
    if (getTypeSystem() != TypeSystem::Isorecursive) {
      // Recursion groups don't matter and we can choose children as though we
      // had a single large recursion group.
      for (Index i = 0; i < builder.size(); ++i) {
        recGroupEnds.push_back(builder.size());
      }
    } else {
      // We are using isorecursive types, so create groups. Choose an expected
      // group size uniformly at random, then create groups with random sizes on
      // a geometric distribution based on that expected size.
      size_t expectedSize = 1 + rand.upTo(builder.size());
      Index groupStart = 0;
      for (Index i = 0; i < builder.size(); ++i) {
        if (i == builder.size() - 1 || rand.oneIn(expectedSize)) {
          // End the old group and create a new group.
          Index newGroupStart = i + 1;
          builder.createRecGroup(groupStart, newGroupStart - groupStart);
          for (Index j = groupStart; j < newGroupStart; ++j) {
            recGroupEnds.push_back(newGroupStart);
          }
          groupStart = newGroupStart;
        }
      }
      assert(recGroupEnds.size() == builder.size());
    }

    // Create the heap types.
    for (; index < builder.size(); ++index) {
      auto kind = typeKinds[index];
      if (auto* basic = std::get_if<BasicKind>(&kind)) {
        // The type is already determined.
        builder[index] = *basic;
      } else if (!supertypeIndices[index] ||
                 builder.isBasic(*supertypeIndices[index])) {
        // No nontrivial supertype, so create a root type.
        if (std::get_if<SignatureKind>(&kind)) {
          builder[index] = generateSignature();
        } else if (std::get_if<StructKind>(&kind)) {
          builder[index] = generateStruct();
        } else if (std::get_if<ArrayKind>(&kind)) {
          builder[index] = generateArray();
        } else {
          WASM_UNREACHABLE("unexpected kind");
        }
      } else {
        // We have a supertype, so create a subtype.
        HeapType supertype = builder[*supertypeIndices[index]];
        if (supertype.isSignature()) {
          builder[index] = generateSubSignature(supertype.getSignature());
        } else if (supertype.isStruct()) {
          builder[index] = generateSubStruct(supertype.getStruct());
        } else if (supertype.isArray()) {
          builder[index] = generateSubArray(supertype.getArray());
        } else {
          WASM_UNREACHABLE("unexpected kind");
        }
      }
    }
  }

  HeapType::BasicHeapType generateBasicHeapType() {
    // Choose bottom types more rarely.
    if (rand.oneIn(16)) {
      return rand.pick(HeapType::noext, HeapType::nofunc, HeapType::none);
    }
    // TODO: string types
    return rand.pick(HeapType::func,
                     HeapType::ext,
                     HeapType::any,
                     HeapType::eq,
                     HeapType::i31,
                     HeapType::struct_,
                     HeapType::array);
  }

  Type::BasicType generateBasicType() {
    return rand.pick(
      Random::FeatureOptions<Type::BasicType>{}
        .add(FeatureSet::MVP, Type::i32, Type::i64, Type::f32, Type::f64)
        .add(FeatureSet::SIMD, Type::v128));
  }

  HeapType generateHeapType() {
    if (rand.oneIn(4)) {
      return generateBasicHeapType();
    } else {
      Index i = rand.upTo(recGroupEnds[index]);
      return builder[i];
    }
  }

  Type generateRefType() {
    auto heapType = generateHeapType();
    auto nullability = rand.oneIn(2) ? Nullable : NonNullable;
    return builder.getTempRefType(heapType, nullability);
  }

  Type generateSingleType() {
    switch (rand.upTo(2)) {
      case 0:
        return generateBasicType();
      case 1:
        return generateRefType();
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

  template<typename Kind> std::vector<HeapType> getKindCandidates() {
    std::vector<HeapType> candidates;
    // Iterate through the top level kinds, finding matches for `Kind`. Since we
    // are constructing a child, we can only look through the end of the current
    // recursion group.
    for (Index i = 0, end = recGroupEnds[index]; i < end; ++i) {
      if (std::get_if<Kind>(&typeKinds[i])) {
        candidates.push_back(builder[i]);
      }
    }
    return candidates;
  }

  template<typename Kind> std::optional<HeapType> pickKind() {
    auto candidates = getKindCandidates<Kind>();
    if (candidates.size()) {
      return rand.pick(candidates);
    } else {
      return std::nullopt;
    }
  }

  HeapType pickSubFunc() {
    auto choice = rand.upTo(8);
    switch (choice) {
      case 0:
        return HeapType::func;
      case 1:
        return HeapType::nofunc;
      default:
        if (auto type = pickKind<SignatureKind>()) {
          return *type;
        }
        return (choice % 2) ? HeapType::func : HeapType::nofunc;
    }
  }

  HeapType pickSubStruct() {
    auto choice = rand.upTo(8);
    switch (choice) {
      case 0:
        return HeapType::struct_;
      case 1:
        return HeapType::none;
      default:
        if (auto type = pickKind<StructKind>()) {
          return *type;
        }
        return (choice % 2) ? HeapType::struct_ : HeapType::none;
    }
  }

  HeapType pickSubArray() {
    auto choice = rand.upTo(8);
    switch (choice) {
      case 0:
        return HeapType::array;
      case 1:
        return HeapType::none;
      default:
        if (auto type = pickKind<ArrayKind>()) {
          return *type;
        }
        return (choice % 2) ? HeapType::array : HeapType::none;
    }
  }

  HeapType pickSubEq() {
    auto choice = rand.upTo(16);
    switch (choice) {
      case 0:
        return HeapType::eq;
      case 1:
        return HeapType::array;
      case 2:
        return HeapType::struct_;
      case 3:
        return HeapType::none;
      default: {
        auto candidates = getKindCandidates<StructKind>();
        auto arrayCandidates = getKindCandidates<ArrayKind>();
        candidates.insert(
          candidates.end(), arrayCandidates.begin(), arrayCandidates.end());
        if (candidates.size()) {
          return rand.pick(candidates);
        }
        switch (choice >> 2) {
          case 0:
            return HeapType::eq;
          case 1:
            return HeapType::array;
          case 2:
            return HeapType::struct_;
          case 3:
            return HeapType::none;
          default:
            WASM_UNREACHABLE("unexpected index");
        }
      }
    }
  }

  HeapType pickSubAny() {
    switch (rand.upTo(8)) {
      case 0:
        return HeapType::any;
      case 1:
        return HeapType::none;
      default:
        return pickSubEq();
    }
    WASM_UNREACHABLE("unexpected index");
  }

  HeapType pickSubHeapType(HeapType type) {
    auto it = typeIndices.find(type);
    if (it != typeIndices.end()) {
      // This is a constructed type, so we know where its subtypes are, but we
      // can only choose those defined before the end of the current recursion
      // group.
      std::vector<HeapType> candidates;
      for (auto i : subtypeIndices[it->second]) {
        if (i < recGroupEnds[index]) {
          candidates.push_back(builder[i]);
        }
      }
      // Very rarely choose the relevant bottom type instead. We can't just use
      // `type.getBottom()` because `type` may not have been initialized yet in
      // the builder.
      if (rand.oneIn(candidates.size() * 8)) {
        auto* kind = &typeKinds[it->second];
        if (auto* basic = std::get_if<BasicKind>(kind)) {
          return HeapType(*basic).getBottom();
        } else if (std::get_if<SignatureKind>(kind)) {
          return HeapType::nofunc;
        } else {
          return HeapType::none;
        }
      }
      return rand.pick(candidates);
    } else {
      // This is not a constructed type, so it must be a basic type.
      assert(type.isBasic());
      if (rand.oneIn(8)) {
        return type.getBottom();
      }
      switch (type.getBasic()) {
        case HeapType::ext:
          return HeapType::ext;
        case HeapType::func:
          return pickSubFunc();
        case HeapType::any:
          return pickSubAny();
        case HeapType::eq:
          return pickSubEq();
        case HeapType::i31:
          return HeapType::i31;
        case HeapType::struct_:
          return pickSubStruct();
        case HeapType::array:
          return pickSubArray();
        case HeapType::string:
        case HeapType::stringview_wtf8:
        case HeapType::stringview_wtf16:
        case HeapType::stringview_iter:
        case HeapType::none:
        case HeapType::noext:
        case HeapType::nofunc:
          return type;
      }
      WASM_UNREACHABLE("unexpected type");
    }
  }

  HeapType pickSuperHeapType(HeapType type) {
    std::vector<HeapType> candidates;
    auto it = typeIndices.find(type);
    if (it != typeIndices.end()) {
      // This is a constructed type, so we know its supertypes. Collect the
      // supertype chain as well as basic supertypes. We can't inspect `type`
      // directly because it may not have been initialized yet in the builder.
      for (std::optional<Index> curr = it->second; curr;
           curr = supertypeIndices[*curr]) {
        candidates.push_back(builder[*curr]);
      }
      auto* kind = &typeKinds[it->second];
      if (std::get_if<StructKind>(kind)) {
        candidates.push_back(HeapType::struct_);
        candidates.push_back(HeapType::eq);
        candidates.push_back(HeapType::any);
        return rand.pick(candidates);
      } else if (std::get_if<ArrayKind>(kind)) {
        candidates.push_back(HeapType::array);
        candidates.push_back(HeapType::eq);
        candidates.push_back(HeapType::any);
        return rand.pick(candidates);
      } else if (std::get_if<SignatureKind>(kind)) {
        candidates.push_back(HeapType::func);
        return rand.pick(candidates);
      } else {
        // A constructed basic type. Fall through to add all of the basic
        // supertypes as well.
        type = *std::get_if<BasicKind>(kind);
      }
    }
    // This is not a constructed type, so it must be a basic type.
    assert(type.isBasic());
    candidates.push_back(type);
    switch (type.getBasic()) {
      case HeapType::ext:
      case HeapType::func:
      case HeapType::any:
        break;
      case HeapType::eq:
        candidates.push_back(HeapType::any);
        break;
      case HeapType::i31:
      case HeapType::struct_:
      case HeapType::array:
        candidates.push_back(HeapType::eq);
        candidates.push_back(HeapType::any);
        break;
      case HeapType::string:
      case HeapType::stringview_wtf8:
      case HeapType::stringview_wtf16:
      case HeapType::stringview_iter:
        candidates.push_back(HeapType::any);
        break;
      case HeapType::none:
        return pickSubAny();
      case HeapType::nofunc:
        return pickSubFunc();
      case HeapType::noext:
        candidates.push_back(HeapType::ext);
        break;
    }
    assert(!candidates.empty());
    return rand.pick(candidates);
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

  Ref generateSuperRef(Ref sub) {
    auto nullability = sub.nullability == Nullable ? Nullable
                       : rand.oneIn(2)             ? Nullable
                                                   : NonNullable;
    return {pickSuperHeapType(sub.type), nullability};
  }

  Type generateSubtype(Type type) {
    if (type.isTuple()) {
      std::vector<Type> types;
      types.reserve(type.size());
      for (auto t : type) {
        types.push_back(generateSubtype(t));
      }
      return builder.getTempTupleType(types);
    } else if (type.isRef()) {
      auto ref = generateSubRef({type.getHeapType(), type.getNullability()});
      return builder.getTempRefType(ref.type, ref.nullability);
    } else if (type.isBasic()) {
      // Non-reference basic types do not have subtypes.
      return type;
    } else {
      WASM_UNREACHABLE("unexpected type kind");
    }
  }

  Type generateSupertype(Type type) {
    if (type.isTuple()) {
      std::vector<Type> types;
      types.reserve(type.size());
      for (auto t : type) {
        types.push_back(generateSupertype(t));
      }
      return builder.getTempTupleType(types);
    } else if (type.isRef()) {
      auto ref = generateSuperRef({type.getHeapType(), type.getNullability()});
      return builder.getTempRefType(ref.type, ref.nullability);
    } else if (type.isBasic()) {
      // Non-reference basic types do not have supertypes.
      return type;
    } else {
      WASM_UNREACHABLE("unexpected type kind");
    }
  }

  Signature generateSubSignature(Signature super) {
    return Signature(generateSupertype(super.params),
                     generateSubtype(super.results));
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
    return {generateSubField(super.element)};
  }

  HeapTypeKind generateHeapTypeKind() {
    switch (rand.upTo(3)) {
      case 0:
        return SignatureKind{};
      case 1:
        return StructKind{};
      case 2:
        return ArrayKind{};
      case 3:
        return BasicKind{generateBasicHeapType()};
    }
    WASM_UNREACHABLE("unexpected index");
  }

  HeapTypeKind getSubKind(HeapTypeKind super) {
    if (rand.oneIn(16)) {
      // Occasionally go directly to the bottom type.
      if (auto* basic = std::get_if<BasicKind>(&super)) {
        return HeapType(*basic).getBottom();
      } else if (std::get_if<SignatureKind>(&super)) {
        return HeapType::nofunc;
      } else if (std::get_if<StructKind>(&super)) {
        return HeapType::none;
      } else if (std::get_if<ArrayKind>(&super)) {
        return HeapType::none;
      }
      WASM_UNREACHABLE("unexpected kind");
    }
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
          if (rand.oneIn(5)) {
            return HeapType::eq;
          }
          [[fallthrough]];
        case HeapType::eq:
          switch (rand.upTo(3)) {
            case 0:
              return HeapType::i31;
            case 1:
              return StructKind{};
            case 2:
              return ArrayKind{};
          }
          WASM_UNREACHABLE("unexpected index");
        case HeapType::struct_:
          return StructKind{};
        case HeapType::array:
          return ArrayKind{};
        case HeapType::string:
        case HeapType::stringview_wtf8:
        case HeapType::stringview_wtf16:
        case HeapType::stringview_iter:
        case HeapType::none:
        case HeapType::noext:
        case HeapType::nofunc:
          return super;
      }
      WASM_UNREACHABLE("unexpected kind");
    } else {
      // Signature and Data types can only have Signature and Data subtypes.
      return super;
    }
  }
};

} // anonymous namespace

HeapTypeGenerator
HeapTypeGenerator::create(Random& rand, FeatureSet features, size_t n) {
  return HeapTypeGeneratorImpl(rand, features, n).result;
}

} // namespace wasm
