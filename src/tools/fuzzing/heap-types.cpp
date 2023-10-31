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

#include "ir/gc-type-utils.h"
#include "ir/subtypes.h"
#include "support/insert_ordered.h"
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
  struct SignatureKind {};
  struct StructKind {};
  struct ArrayKind {};
  using HeapTypeKind = std::variant<SignatureKind, StructKind, ArrayKind>;
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
    // types we haven't constructed yet.
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
        typeKinds.push_back(typeKinds[super]);
      }
    }

    // Types without nontrivial subtypes may be marked final.
    for (Index i = 0; i < builder.size(); ++i) {
      builder[i].setOpen(subtypeIndices[i].size() > 1 || rand.oneIn(2));
    }

    // Initialize the recursion groups.
    recGroupEnds.reserve(builder.size());
    // Create isorecursive recursion groups. Choose an expected group size
    // uniformly at random, then create groups with random sizes on a geometric
    // distribution based on that expected size.
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

    // Create the heap types.
    for (; index < builder.size(); ++index) {
      auto kind = typeKinds[index];
      if (!supertypeIndices[index]) {
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
        if (std::get_if<SignatureKind>(kind)) {
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
        case HeapType::func:
          return pickSubFunc();
        case HeapType::cont:
          WASM_UNREACHABLE("not implemented");
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
        case HeapType::ext:
        case HeapType::exn:
        case HeapType::string:
        case HeapType::stringview_wtf8:
        case HeapType::stringview_wtf16:
        case HeapType::stringview_iter:
        case HeapType::none:
        case HeapType::noext:
        case HeapType::nofunc:
        case HeapType::nocont:
        case HeapType::noexn:
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
        WASM_UNREACHABLE("unexpected kind");
      }
    }
    // This is not a constructed type, so it must be a basic type.
    assert(type.isBasic());
    candidates.push_back(type);
    switch (type.getBasic()) {
      case HeapType::ext:
      case HeapType::func:
      case HeapType::exn:
      case HeapType::cont:
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
        candidates.push_back(HeapType::any);
        break;
      case HeapType::stringview_wtf8:
      case HeapType::stringview_wtf16:
      case HeapType::stringview_iter:
        break;
      case HeapType::none:
        if (features.hasStrings() && rand.oneIn(10)) {
          candidates.push_back(HeapType::stringview_wtf8);
          candidates.push_back(HeapType::stringview_wtf16);
          candidates.push_back(HeapType::stringview_iter);
          break;
        }
        return pickSubAny();
      case HeapType::nofunc:
        return pickSubFunc();
      case HeapType::nocont:
        WASM_UNREACHABLE("not implemented");
      case HeapType::noext:
        candidates.push_back(HeapType::ext);
        break;
      case HeapType::noexn:
        candidates.push_back(HeapType::exn);
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
    auto params = generateSupertype(super.params);
    auto results = generateSubtype(super.results);
    return Signature(params, results);
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
    }
    WASM_UNREACHABLE("unexpected index");
  }
};

} // anonymous namespace

HeapTypeGenerator
HeapTypeGenerator::create(Random& rand, FeatureSet features, size_t n) {
  return HeapTypeGeneratorImpl(rand, features, n).result;
}

namespace {

// `makeInhabitable` implementation.
//
// There are two root causes of uninhabitability: First, a non-nullable
// reference to a bottom type is always uninhabitable. Second, a cycle in the
// type graph formed from non-nullable references makes all the types involved
// in that cycle uninhabitable because there is no way to construct the types
// one at at time. All types that reference uninhabitable types via non-nullable
// references are also themselves uninhabitable, but these transitively
// uninhabitable types will become inhabitable once we fix the root causes, so
// we don't worry about them.
//
// To modify uninhabitable types to make them habitable, it suffices to make all
// non-nullable references to bottom types nullable and to break all cycles of
// non-nullable references by making one of the references nullable. To preserve
// valid subtyping, the newly nullable fields must also be made nullable in any
// supertypes in which they appear.
struct Inhabitator {
  // Uniquely identify fields as an index into a type.
  using FieldPos = std::pair<HeapType, Index>;

  // When we make a reference nullable, we typically need to make the same
  // reference in other types nullable to maintain valid subtyping. Which types
  // we need to update depends on the variance of the reference, which is
  // determined by how it is used in its enclosing heap type.
  //
  // An invariant field of a heaptype must have the same type in subtypes of
  // that heaptype. A covariant field of a heaptype must be typed with a subtype
  // of its original type in subtypes of the heaptype.
  enum Variance { Invariant, Covariant };

  // The input types.
  const std::vector<HeapType>& types;

  // The fields we will make nullable.
  std::unordered_set<FieldPos> nullables;

  SubTypes subtypes;

  Inhabitator(const std::vector<HeapType>& types)
    : types(types), subtypes(types) {}

  Variance getVariance(FieldPos fieldPos);
  void markNullable(FieldPos field);
  void markBottomRefsNullable();
  void markExternRefsNullable();
  void breakNonNullableCycles();

  std::vector<HeapType> build();
};

Inhabitator::Variance Inhabitator::getVariance(FieldPos fieldPos) {
  auto [type, idx] = fieldPos;
  assert(!type.isBasic() && !type.isSignature());
  auto field = GCTypeUtils::getField(type, idx);
  assert(field);
  if (field->mutable_ == Mutable) {
    return Invariant;
  } else {
    return Covariant;
  }
}

void Inhabitator::markNullable(FieldPos field) {
  // Mark the given field nullable in the original type and in other types
  // necessary to keep subtyping valid.
  nullables.insert(field);
  auto [curr, idx] = field;
  switch (getVariance(field)) {
    case Covariant:
      // Mark the field null in all supertypes. If the supertype field is
      // already nullable or does not exist, that's ok and this will have no
      // effect.
      while (auto super = curr.getDeclaredSuperType()) {
        nullables.insert({*super, idx});
        curr = *super;
      }
      break;
    case Invariant:
      // Find the top type for which this field exists and mark the field
      // nullable in all of its subtypes.
      if (curr.isArray()) {
        while (auto super = curr.getDeclaredSuperType()) {
          curr = *super;
        }
      } else {
        assert(curr.isStruct());
        while (auto super = curr.getDeclaredSuperType()) {
          if (super->getStruct().fields.size() <= idx) {
            break;
          }
          curr = *super;
        }
      }
      // Mark the field nullable in all subtypes. If the subtype field is
      // already nullable, that's ok and this will have no effect. TODO: Remove
      // this extra `index` variable once we have C++20. It's a workaround for
      // lambdas being unable to capture structured bindings.
      const size_t index = idx;
      subtypes.iterSubTypes(curr, [&](HeapType type, Index) {
        nullables.insert({type, index});
      });
      break;
  }
}

void Inhabitator::markBottomRefsNullable() {
  for (auto type : types) {
    if (type.isSignature()) {
      // Functions can always be instantiated, even if their types refer to
      // uninhabitable types.
      continue;
    }
    auto children = type.getTypeChildren();
    for (size_t i = 0; i < children.size(); ++i) {
      auto child = children[i];
      if (child.isRef() && child.getHeapType().isBottom() &&
          child.isNonNullable()) {
        markNullable({type, i});
      }
    }
  }
}

void Inhabitator::markExternRefsNullable() {
  // The fuzzer cannot instantiate non-nullable externrefs, so make sure they
  // are all nullable.
  // TODO: Remove this once the fuzzer imports externref globals or gets some
  // other way to instantiate externrefs.
  for (auto type : types) {
    if (type.isSignature()) {
      // Functions can always be instantiated, even if their types refer to
      // uninhabitable types.
      continue;
    }
    auto children = type.getTypeChildren();
    for (size_t i = 0; i < children.size(); ++i) {
      auto child = children[i];
      if (child.isRef() && child.getHeapType() == HeapType::ext &&
          child.isNonNullable()) {
        markNullable({type, i});
      }
    }
  }
}

// Use a depth-first search to find cycles, marking the last found reference in
// the cycle to be made non-nullable.
void Inhabitator::breakNonNullableCycles() {
  // Types we've finished visiting. We don't need to visit them again.
  std::unordered_set<HeapType> visited;

  // The path of types we are currently visiting. If one of them comes back up,
  // we've found a cycle. Map the types to the other types they reference and
  // our current index into that list so we can track where we are in each level
  // of the search.
  InsertOrderedMap<HeapType, std::pair<std::vector<Type>, Index>> visiting;

  for (auto root : types) {
    if (visited.count(root)) {
      continue;
    }
    assert(visiting.size() == 0);
    visiting.insert({root, {root.getTypeChildren(), 0}});

    while (visiting.size()) {
      auto& [curr, state] = *std::prev(visiting.end());
      auto& [children, idx] = state;

      while (idx < children.size()) {
        // Skip non-reference children because they cannot refer to other types.
        if (!children[idx].isRef()) {
          ++idx;
          continue;
        }
        // Skip nullable references because they don't cause uninhabitable
        // cycles.
        if (children[idx].isNullable()) {
          ++idx;
          continue;
        }
        // Skip references that we have already marked nullable to satisfy
        // subtyping constraints. TODO: We could take such nullable references
        // into account when detecting cycles by tracking where in the current
        // search path we have made references nullable.
        if (nullables.count({curr, idx})) {
          ++idx;
          continue;
        }
        // Skip references to types that we have finished visiting. We have
        // visited the full graph reachable from such references, so we know
        // they cannot cycle back to anything we are currently visiting.
        auto heapType = children[idx].getHeapType();
        if (visited.count(heapType)) {
          ++idx;
          continue;
        }
        // Skip references to function types. Functions types can always be
        // instantiated since functions can be created even with uninhabitable
        // params or results. Function references therefore break cycles that
        // would otherwise produce uninhabitability.
        if (heapType.isSignature()) {
          ++idx;
          continue;
        }
        // If this ref forms a cycle, break the cycle by marking it nullable and
        // continue.
        if (auto it = visiting.find(heapType); it != visiting.end()) {
          markNullable({curr, idx});
          ++idx;
          continue;
        }
        break;
      }

      // If we've finished the DFS on the current type, pop it off the search
      // path and continue searching the previous type.
      if (idx == children.size()) {
        visited.insert(curr);
        visiting.erase(std::prev(visiting.end()));
        continue;
      }

      // Otherwise we have a non-nullable reference we need to search.
      assert(children[idx].isRef() && children[idx].isNonNullable());
      auto next = children[idx++].getHeapType();
      visiting.insert({next, {next.getTypeChildren(), 0}});
    }
  }
}

std::vector<HeapType> Inhabitator::build() {
  std::unordered_map<HeapType, size_t> typeIndices;
  for (size_t i = 0; i < types.size(); ++i) {
    typeIndices.insert({types[i], i});
  }

  TypeBuilder builder(types.size());

  // Copy types. Update references to point to the corresponding new type and
  // make them nullable where necessary.
  auto updateType = [&](FieldPos pos, Type& type) {
    if (!type.isRef()) {
      return;
    }
    auto heapType = type.getHeapType();
    auto nullability = type.getNullability();
    if (auto it = typeIndices.find(heapType); it != typeIndices.end()) {
      heapType = builder[it->second];
    }
    if (nullables.count(pos)) {
      nullability = Nullable;
    }
    type = builder.getTempRefType(heapType, nullability);
  };

  for (size_t i = 0; i < types.size(); ++i) {
    auto type = types[i];
    if (type.isStruct()) {
      Struct copy = type.getStruct();
      for (size_t j = 0; j < copy.fields.size(); ++j) {
        updateType({type, j}, copy.fields[j].type);
      }
      builder[i] = copy;
      continue;
    }
    if (type.isArray()) {
      Array copy = type.getArray();
      updateType({type, 0}, copy.element.type);
      builder[i] = copy;
      continue;
    }
    if (type.isSignature()) {
      auto sig = type.getSignature();
      size_t j = 0;
      std::vector<Type> params;
      for (auto param : sig.params) {
        params.push_back(param);
        updateType({type, j++}, params.back());
      }
      std::vector<Type> results;
      for (auto result : sig.results) {
        results.push_back(result);
        updateType({type, j++}, results.back());
      }
      builder[i] = Signature(builder.getTempTupleType(params),
                             builder.getTempTupleType(results));
      continue;
    }
    WASM_UNREACHABLE("unexpected type kind");
  }

  // Establish rec groups.
  for (size_t start = 0; start < types.size();) {
    size_t size = types[start].getRecGroup().size();
    builder.createRecGroup(start, size);
    start += size;
  }

  // Establish supertypes and finality.
  for (size_t i = 0; i < types.size(); ++i) {
    if (auto super = types[i].getDeclaredSuperType()) {
      if (auto it = typeIndices.find(*super); it != typeIndices.end()) {
        builder[i].subTypeOf(builder[it->second]);
      } else {
        builder[i].subTypeOf(*super);
      }
    }
    builder[i].setOpen(types[i].isOpen());
  }

  auto built = builder.build();
  assert(!built.getError() && "unexpected build error");
  return *built;
}

} // anonymous namespace

std::vector<HeapType>
HeapTypeGenerator::makeInhabitable(const std::vector<HeapType>& types) {
  if (types.empty()) {
    return {};
  }

  // Remove duplicate and basic types. We will insert them back at the end.
  std::unordered_map<HeapType, size_t> typeIndices;
  std::vector<size_t> deduplicatedIndices;
  std::vector<HeapType> deduplicated;
  for (auto type : types) {
    if (type.isBasic()) {
      deduplicatedIndices.push_back(-1);
      continue;
    }
    auto [it, inserted] = typeIndices.insert({type, deduplicated.size()});
    if (inserted) {
      deduplicated.push_back(type);
    }
    deduplicatedIndices.push_back(it->second);
  }
  assert(deduplicatedIndices.size() == types.size());

  // Construct the new types.
  Inhabitator inhabitator(deduplicated);
  inhabitator.markBottomRefsNullable();
  inhabitator.markExternRefsNullable();
  inhabitator.breakNonNullableCycles();
  deduplicated = inhabitator.build();

  // Re-duplicate and re-insert basic types as necessary.
  std::vector<HeapType> result;
  for (size_t i = 0; i < types.size(); ++i) {
    if (deduplicatedIndices[i] == (size_t)-1) {
      assert(types[i].isBasic());
      result.push_back(types[i]);
    } else {
      result.push_back(deduplicated[deduplicatedIndices[i]]);
    }
  }
  return result;
}

namespace {

bool isUninhabitable(Type type,
                     std::unordered_set<HeapType>& visited,
                     std::unordered_set<HeapType>& visiting);

// Simple recursive DFS through non-nullable references to see if we find any
// cycles.
bool isUninhabitable(HeapType type,
                     std::unordered_set<HeapType>& visited,
                     std::unordered_set<HeapType>& visiting) {
  if (type.isBasic()) {
    return false;
  }
  if (type.isSignature()) {
    // Function types are always inhabitable.
    return false;
  }
  if (visited.count(type)) {
    return false;
  }

  if (!visiting.insert(type).second) {
    return true;
  }

  if (type.isStruct()) {
    for (auto& field : type.getStruct().fields) {
      if (isUninhabitable(field.type, visited, visiting)) {
        return true;
      }
    }
  } else if (type.isArray()) {
    if (isUninhabitable(type.getArray().element.type, visited, visiting)) {
      return true;
    }
  } else {
    WASM_UNREACHABLE("unexpected type kind");
  }
  visiting.erase(type);
  visited.insert(type);
  return false;
}

bool isUninhabitable(Type type,
                     std::unordered_set<HeapType>& visited,
                     std::unordered_set<HeapType>& visiting) {
  if (type.isRef() && type.isNonNullable()) {
    if (type.getHeapType().isBottom() || type.getHeapType() == HeapType::ext) {
      return true;
    }
    return isUninhabitable(type.getHeapType(), visited, visiting);
  }
  return false;
}

} // anonymous namespace

std::vector<HeapType>
HeapTypeGenerator::getInhabitable(const std::vector<HeapType>& types) {
  std::unordered_set<HeapType> visited, visiting;
  std::vector<HeapType> inhabitable;
  for (auto type : types) {
    if (!isUninhabitable(type, visited, visiting)) {
      inhabitable.push_back(type);
    }
  }
  return inhabitable;
}

} // namespace wasm
