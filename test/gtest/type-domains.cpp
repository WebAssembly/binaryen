/*
 * Copyright 2025 WebAssembly Community Group participants
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

#include <iostream>

#include "type-domains.h"
#include "gtest/gtest.h"

namespace wasm {

namespace {

void printHeapType(std::ostream& o, HeapTypePlan& plan) {
  if (auto* type = plan.getHeapType()) {
    o << *type;
  } else if (auto* i = plan.getIndex()) {
    o << *i;
  }
}

void printRef(std::ostream& o, RefPlan& plan) {
  o << "(ref ";
  if (plan.nullable) {
    o << "null ";
  }
  printHeapType(o, plan.type);
  o << ")";
}

void printType(std::ostream& o, TypePlan& plan) {
  if (auto* type = plan.getNonRef()) {
    o << *type;
  } else if (auto* ref = plan.getRef()) {
    printRef(o, *ref);
  }
}

void printFieldType(std::ostream& o, FieldTypePlan& plan) {
  if (auto* packed = plan.getPacked()) {
    o << (*packed == Field::i8 ? "i8" : "i16");
  } else if (auto* type = plan.getNonPacked()) {
    printType(o, *type);
  }
}

void printField(std::ostream& o, FieldPlan& plan) {
  o << "(field ";
  if (plan.mutable_) {
    o << "(mut ";
  }
  printFieldType(o, plan.type);
  if (plan.mutable_) {
    o << ")";
  }
  o << ")";
}

void printFunc(std::ostream& o, FuncPlan& plan) {
  o << "(func";
  if (!plan.first.empty()) {
    o << " (param";
    for (auto& type : plan.first) {
      o << " ";
      printType(o, type);
    }
    o << ")";
  }
  if (!plan.second.empty()) {
    o << " (result";
    for (auto& type : plan.second) {
      o << " ";
      printType(o, type);
    }
    o << ")";
  }
  o << ")";
}

void printStruct(std::ostream& o, StructPlan& plan) {
  o << "(struct";
  for (auto& field : plan) {
    o << " ";
    printField(o, field);
  }
  o << ")";
}

void printArray(std::ostream& o, ArrayPlan& plan) {
  o << "(array ";
  printField(o, plan);
  o << ")";
}

void printCont(std::ostream& o, ContPlan& plan) {
  o << "(cont ";
  if (plan) {
    o << *plan;
  } else {
    o << "$fallback";
  }
  o << ")";
}

void printTypeDef(std::ostream& o, const TypeBuilderPlan& plan, size_t i) {
  auto def = plan.defs[i];
  auto super = plan.supertypes[i];
  bool shared = plan.kinds[i].shared;
  bool final = plan.kinds[i].final;
  o << "(type (; " << i << " ;) ";
  if (super || !final) {
    o << "(sub ";
    if (super) {
      o << *super << " ";
    }
  }
  if (shared) {
    o << "(shared ";
  }
  if (auto* func = def.getFunc()) {
    printFunc(o, *func);
  } else if (auto* struct_ = def.getStruct()) {
    printStruct(o, *struct_);
  } else if (auto* array = def.getArray()) {
    printArray(o, *array);
  } else if (auto* cont = def.getCont()) {
    printCont(o, *cont);
  } else {
    WASM_UNREACHABLE("unexpected kind");
  }
  if (shared) {
    o << ")";
  }
  if (super || !final) {
    o << ")";
  }
  o << ")";
}

} // anonymous namespace

std::ostream& operator<<(std::ostream& o, const TypeBuilderPlan& plan) {
  assert(!plan.recGroupSizes.empty());
  o << "size: " << plan.size << ", rec group sizes: { "
    << plan.recGroupSizes[0];
  for (size_t i = 1; i < plan.recGroupSizes.size(); ++i) {
    o << ", " << plan.recGroupSizes[i];
  }
  o << " }";

  if (plan.supertypes.empty()) {
    return o;
  }

  auto printKind = [&](size_t i) {
    if (plan.kinds[i].final) {
      o << "*";
    }
    if (plan.kinds[i].shared) {
      o << "s";
    }
    switch (plan.kinds[i].kind) {
      case FuncKind:
        o << "f";
        break;
      case StructKind:
        o << "s";
        break;
      case ArrayKind:
        o << "a";
        break;
      case ContKind:
        o << "s";
        break;
    }
    if (auto super = plan.supertypes[i]) {
      o << "(" << *super << ")";
    }
  };

  o << ", kinds: { ";
  printKind(0);
  for (size_t i = 1; i < plan.size; ++i) {
    o << ", ";
    printKind(i);
  }
  o << " }";

  if (plan.defs.empty()) {
    return o;
  }

  o << "\n";

  for (size_t i = 0; i < plan.size; ++i) {
    o << "  ";
    printTypeDef(o, plan, i);
    o << "\n";
  }

  return o;
}

namespace {

template<typename Map, typename T>
using ResultVal =
  typename std::invoke_result_t<Map, std::vector<T>, size_t>::value_type;

template<typename Map, typename T>
using ResultVec = std::vector<ResultVal<Map, T>>;

template<typename Map, typename T>
using AccTuple = std::tuple<Map, std::vector<T>, size_t, ResultVec<Map, T>>;

template<typename Map, typename T>
fuzztest::Domain<ResultVec<Map, T>> StepMapVector(AccTuple<Map, T>);

template<typename Map, typename T>
fuzztest::Domain<ResultVec<Map, T>> AppendMapVector(AccTuple<Map, T> acc,
                                                    ResultVal<Map, T> val) {
  auto& [map, vec, i, results] = acc;
  results.emplace_back(std::move(val));
  return StepMapVector(std::move(acc));
}

template<typename Map, typename T>
fuzztest::Domain<ResultVec<Map, T>> StepMapVector(AccTuple<Map, T> acc) {
  auto& [map, vec, i, results] = acc;
  if (i == vec.size()) {
    // Base case. We've generated all the elements.
    return fuzztest::Just(std::move(results));
  }
  // Apply `map` to get the domain for the next element, then generate an
  // element of that domain, append it to `results`, and recurse.
  auto elemDomain = map(vec, i++);
  return fuzztest::FlatMap(
    AppendMapVector<Map, T>, fuzztest::Just(std::move(acc)), elemDomain);
}

// Given a mapping of (const std::vector<T>&, size_t i) -> Domain<U> and a
// std::vector<T>, apply the mapping elementwise and produce a
// Domain<std::vector<U>>.
template<typename Map, typename T>
fuzztest::Domain<ResultVec<Map, T>> MapVector(Map map, std::vector<T> vec) {
  return StepMapVector(
    std::make_tuple(map, std::move(vec), size_t(0), ResultVec<Map, T>{}));
}

// Given a mapping of T -> Domain<U> and a std::vector<T>, apply the mapping
// elementwise and produce a Domain<std::vector<U>>. This is a shorthand version
// of MapVector for when the output domains depend only on single elements.
template<typename Map, typename T>
auto MapElements(Map map, std::vector<T> vec) {
  return MapVector([map](std::vector<T> vec, size_t i) { return map(vec[i]); },
                   std::move(vec));
}

fuzztest::Domain<UnsharedTypeKind> ArbitraryUnsharedTypeKind() {
  return fuzztest::ElementOf({FuncKind, StructKind, ArrayKind, ContKind});
}

fuzztest::Domain<TypeKind> ArbitraryTypeKind() {
  // Independently random unshared kind, sharedness, and mutability.
  return fuzztest::StructOf<TypeKind>(ArbitraryUnsharedTypeKind(),
                                      fuzztest::Arbitrary<bool>(),
                                      fuzztest::Arbitrary<bool>());
}

fuzztest::Domain<size_t> TypeBuilderPlanSize() {
  // Choose a size for the TypeBuilder.
  return fuzztest::InRange(size_t(1), MaxTypeBuilderSize);
}

fuzztest::Domain<TypeBuilderPlan> InitTypeBuilderPlan() {
  // Create a TypeBuilderPlan with `size` and `curr` set to the same choice
  // of size. `curr` represents how many slots still need a rec group.
  return fuzztest::FlatMap(
    [](size_t size) {
      return fuzztest::Just(TypeBuilderPlan{size, size});
    },
    TypeBuilderPlanSize());
}

fuzztest::Domain<TypeBuilderPlan> StepRecGroup(TypeBuilderPlan plan);

fuzztest::Domain<TypeBuilderPlan> AppendRecGroup(TypeBuilderPlan plan,
                                                 size_t newSize) {
  // Update `plan` to append a recgroup of size `newSize`, then recurse iff
  // there is still size unallocated to a rec group.
  plan.curr -= newSize;
  plan.recGroupSizes.push_back(newSize);
  if (plan.curr == 0) {
    return fuzztest::Just(std::move(plan));
  } else {
    return StepRecGroup(std::move(plan));
  }
}

fuzztest::Domain<TypeBuilderPlan> StepRecGroup(TypeBuilderPlan plan) {
  // Given a plan that needs more rec groups, choose the size of the next rec
  // group based on the available size remaining. Bias toward singleton rec
  // groups.
  auto remaining = plan.curr;
  assert(remaining > 0);
  return fuzztest::FlatMap(
    AppendRecGroup,
    fuzztest::Just(std::move(plan)),
    fuzztest::OneOf(fuzztest::Just(size_t(1)),
                    fuzztest::InRange(size_t(1), remaining)));
}

fuzztest::Domain<TypeBuilderPlan> ArbitraryRecGroupPlan() {
  // Initialize a plan with just a size, then add rec group sizes.
  return fuzztest::FlatMap(StepRecGroup, InitTypeBuilderPlan());
}

void TestRecGroupPlanSizes(TypeBuilderPlan plan) {
  size_t sum = 0;
  for (auto size : plan.recGroupSizes) {
    sum += size;
  }
  EXPECT_EQ(plan.size, sum);
  EXPECT_EQ(plan.curr, 0);
}
FUZZ_TEST(TypeBuilderDomainsTest, TestRecGroupPlanSizes)
  .WithDomains(ArbitraryRecGroupPlan());

fuzztest::Domain<TypeBuilderPlan> StepSupertypeAndKind(TypeBuilderPlan plan);
fuzztest::Domain<TypeBuilderPlan> AppendKind(TypeBuilderPlan plan,
                                             TypeKind kind);

fuzztest::Domain<TypeBuilderPlan> AppendSupertype(TypeBuilderPlan plan,
                                                  std::optional<size_t> super) {
  plan.supertypes.push_back(super);
  if (super) {
    // If there is a supertype, then the current type will inherit its kind.
    auto kind = plan.kinds[*super];
    return AppendKind(std::move(plan), kind);
  } else {
    // Otherwise, we give it an arbitrary kind.
    return fuzztest::FlatMap(
      AppendKind, fuzztest::Just(std::move(plan)), ArbitraryTypeKind());
  }
}

fuzztest::Domain<TypeBuilderPlan> AppendKind(TypeBuilderPlan plan,
                                             TypeKind kind) {
  // We have chosen the kind either based on the supertype or arbitrarily.
  // Either way, set it and then recurse iff there are more supertypes and kinds
  // to set.
  plan.kinds.push_back(kind);
  if (plan.curr == plan.size) {
    return fuzztest::Just(std::move(plan));
  } else {
    return StepSupertypeAndKind(std::move(plan));
  }
}

fuzztest::Domain<TypeBuilderPlan> StepSupertypeAndKind(TypeBuilderPlan plan) {
  // Collect previous non-final types as possible supertypes.
  auto index = plan.curr++;
  std::vector<size_t> possibleSupers;
  for (size_t i = 0; i < index; ++i) {
    if (!plan.kinds[i].final) {
      possibleSupers.push_back(i);
    }
  }
  if (possibleSupers.empty()) {
    // No possible supertype.
    return AppendSupertype(std::move(plan), std::nullopt);
  } else {
    // Optionally choose an available supertype.
    return fuzztest::FlatMap(
      AppendSupertype,
      fuzztest::Just(std::move(plan)),
      fuzztest::OptionalOf(fuzztest::ElementOf(std::move(possibleSupers))));
  }
}

fuzztest::Domain<TypeBuilderPlan> ArbitraryAbstractTypeBuilderPlan() {
  // Initialize with rec group sizes, then add supertype declarations and type
  // kinds.
  return fuzztest::FlatMap(StepSupertypeAndKind, ArbitraryRecGroupPlan());
}

void TestSupertypesAndKinds(TypeBuilderPlan plan) {
  ASSERT_EQ(plan.size, plan.supertypes.size());
  ASSERT_EQ(plan.size, plan.kinds.size());
  for (size_t i = 0; i < plan.size; ++i) {
    if (auto super = plan.supertypes[i]) {
      EXPECT_LT(*super, i);
      EXPECT_EQ(plan.kinds[*super].kind, plan.kinds[i].kind);
      EXPECT_EQ(plan.kinds[*super].shared, plan.kinds[i].shared);
      EXPECT_FALSE(plan.kinds[*super].final);
    }
  }
}
FUZZ_TEST(TypeBuilderDomainsTest, TestSupertypesAndKinds)
  .WithDomains(ArbitraryAbstractTypeBuilderPlan());

fuzztest::Domain<TypeBuilderPlan> InitConcreteTypeBuilderPlan() {
  // Reset `curr` to 0 (for simplicity) and initialize `numReferenceable` based
  // on the size of the first rec group.
  return fuzztest::Map(
    [](TypeBuilderPlan plan) {
      plan.curr = 0;
      plan.numReferenceable = plan.recGroupSizes[0];
      return plan;
    },
    ArbitraryAbstractTypeBuilderPlan());
}

template<typename Pred>
std::vector<size_t> AvailableMatchingIndices(TypeBuilderPlan plan, Pred pred) {
  std::vector<size_t> matches;
  for (size_t i = 0; i < plan.numReferenceable; ++i) {
    if (pred(plan.kinds[i].kind, plan.kinds[i].shared)) {
      matches.push_back(i);
    }
  }
  return matches;
}

template<typename Pred>
fuzztest::Domain<HeapTypePlan> AvailableMatchingOrAbstractHeapType(
  TypeBuilderPlan plan, Pred pred, fuzztest::Domain<HeapType> abstract) {
  // Look for referenceable indices with kinds matching the predicate and return
  // a variant of the indices or the given abstract subtypes. If there are no
  // possible indices, just return the abstract subtypes.
  auto matches = AvailableMatchingIndices(std::move(plan), pred);
  if (matches.empty()) {
    return fuzztest::Map([](HeapType type) { return HeapTypePlan{type}; },
                         abstract);
  } else {
    return fuzztest::VariantOf<HeapTypePlan>(
      abstract, fuzztest::ElementOf(std::move(matches)));
  }
}

std::vector<size_t> AvailableStrictSubIndices(TypeBuilderPlan plan,
                                              size_t index) {
  // Look for direct and indirect subtypes. To find indirect subtypes, keep
  // track of all the possible supertypes that are subtypes of `super`.
  std::vector<size_t> matches;
  std::vector<bool> acceptedSupers(plan.numReferenceable);
  acceptedSupers[index] = true;
  assert(plan.numReferenceable <= plan.size);
  for (size_t i = index + 1; i < plan.numReferenceable; ++i) {
    auto otherSuper = plan.supertypes[i];
    if (otherSuper && acceptedSupers[*otherSuper]) {
      matches.push_back(i);
      acceptedSupers[i] = true;
    }
  }
  return matches;
}

fuzztest::Domain<HeapTypePlan> AvailableStrictSubHeapType(TypeBuilderPlan plan,
                                                          HeapTypePlan super) {
  // Get an available subtype of super.
  if (auto* type = super.getHeapType()) {
    auto share = type->getShared();
    bool shared = share == Shared;

    auto matchingOrAbstract = [=](auto pred, auto abstract) {
      return AvailableMatchingOrAbstractHeapType(
        std::move(plan),
        [&](auto kind, bool otherShared) {
          return otherShared == shared && pred(kind);
        },
        abstract);
    };

    switch (type->getBasic(Unshared)) {
      case HeapType::ext:
        return matchingOrAbstract(
          [](auto kind) { return false; },
          fuzztest::ElementOf({HeapType(HeapTypes::string.getBasic(share)),
                               HeapType(HeapTypes::noext.getBasic(share))}));
      case HeapType::func:
        return matchingOrAbstract(
          [](auto kind) { return kind == FuncKind; },
          fuzztest::Just(HeapType(HeapTypes::nofunc.getBasic(share))));
      case HeapType::cont:
        return matchingOrAbstract(
          [](auto kind) { return kind == ContKind; },
          fuzztest::Just(HeapType(HeapTypes::nocont.getBasic(share))));
      case HeapType::any:
        return matchingOrAbstract(
          [](auto kind) { return kind == StructKind || kind == ArrayKind; },
          fuzztest::ElementOf({HeapType(HeapTypes::eq.getBasic(share)),
                               HeapType(HeapTypes::i31.getBasic(share)),
                               HeapType(HeapTypes::struct_.getBasic(share)),
                               HeapType(HeapTypes::array.getBasic(share)),
                               HeapType(HeapTypes::none.getBasic(share))}));
      case HeapType::eq:
        return matchingOrAbstract(
          [](auto kind) { return kind == StructKind || kind == ArrayKind; },
          fuzztest::ElementOf({HeapType(HeapTypes::i31.getBasic(share)),
                               HeapType(HeapTypes::struct_.getBasic(share)),
                               HeapType(HeapTypes::array.getBasic(share)),
                               HeapType(HeapTypes::none.getBasic(share))}));
      case HeapType::struct_:
        return matchingOrAbstract(
          [](auto kind) { return kind == StructKind; },
          fuzztest::Just(HeapType(HeapTypes::none.getBasic(share))));
      case HeapType::array:
        return matchingOrAbstract(
          [](auto kind) { return kind == ArrayKind; },
          fuzztest::Just(HeapType(HeapTypes::none.getBasic(share))));
      case HeapType::exn:
        return fuzztest::Just(
          HeapTypePlan{HeapType(HeapTypes::noexn.getBasic(share))});
      case HeapType::i31:
        return fuzztest::Just(
          HeapTypePlan{HeapType(HeapTypes::none.getBasic(share))});
      case HeapType::string:
        return fuzztest::Just(
          HeapTypePlan{HeapType(HeapTypes::noext.getBasic(share))});
      case HeapType::none:
      case HeapType::noext:
      case HeapType::nofunc:
      case HeapType::nocont:
      case HeapType::noexn:
        // No strict subtypes, so just return super.
        return fuzztest::Just(super);
    }
    WASM_UNREACHABLE("unexpected type");
  } else if (auto* index = super.getIndex()) {
    assert(*index < plan.size);
    auto kind = plan.kinds[*index].kind;
    auto share = plan.kinds[*index].shared ? Shared : Unshared;
    auto matches = AvailableStrictSubIndices(std::move(plan), *index);
    HeapType bottom = HeapType::none;
    switch (kind) {
      case FuncKind:
        bottom = HeapTypes::nofunc.getBasic(share);
        break;
      case StructKind:
      case ArrayKind:
        bottom = HeapTypes::none.getBasic(share);
        break;
      case ContKind:
        bottom = HeapTypes::nocont.getBasic(share);
        break;
    }
    if (matches.empty()) {
      return fuzztest::Just(HeapTypePlan{bottom});
    } else {
      return fuzztest::VariantOf<HeapTypePlan>(
        fuzztest::Just(bottom), fuzztest::ElementOf(std::move(matches)));
    }
  } else {
    WASM_UNREACHABLE("unexpected variant");
  }
}

fuzztest::Domain<HeapTypePlan>
AvailableStrictSuperHeapType(TypeBuilderPlan plan, HeapTypePlan sub) {
  if (auto* type = sub.getHeapType()) {
    auto share = type->getShared();
    bool shared = share == Shared;

    auto matchingOrAbstract = [&](auto pred, auto abstract) {
      return AvailableMatchingOrAbstractHeapType(
        std::move(plan),
        [&](auto kind, bool otherShared) {
          return otherShared == shared && pred(kind);
        },
        abstract);
    };

    switch (type->getBasic(Unshared)) {
      case HeapType::ext:
      case HeapType::func:
      case HeapType::cont:
      case HeapType::any:
      case HeapType::exn:
        // No strict supertypes, so just return sub.
        return fuzztest::Just(sub);
      case HeapType::eq:
        return fuzztest::Just(
          HeapTypePlan{HeapType(HeapTypes::any.getBasic(share))});
      case HeapType::i31:
      case HeapType::struct_:
      case HeapType::array:
        return fuzztest::Just(
          HeapTypePlan{HeapType(HeapTypes::any.getBasic(share))});
      case HeapType::string:
        return fuzztest::Just(
          HeapTypePlan{HeapType(HeapTypes::ext.getBasic(share))});
      case HeapType::none:
        return matchingOrAbstract(
          [](auto kind) { return kind == StructKind || kind == ArrayKind; },
          fuzztest::ElementOf({HeapType(HeapTypes::any.getBasic(share)),
                               HeapType(HeapTypes::eq.getBasic(share)),
                               HeapType(HeapTypes::i31.getBasic(share)),
                               HeapType(HeapTypes::struct_.getBasic(share)),
                               HeapType(HeapTypes::array.getBasic(share))}));
      case HeapType::noext:
        return fuzztest::Just(
          HeapTypePlan{HeapType(HeapTypes::ext.getBasic(share))});
      case HeapType::nofunc:
        return matchingOrAbstract(
          [](auto kind) { return kind == FuncKind; },
          fuzztest::Just(HeapType(HeapTypes::func.getBasic(share))));
      case HeapType::nocont:
        return matchingOrAbstract(
          [](auto kind) { return kind == ContKind; },
          fuzztest::Just(HeapType(HeapTypes::cont.getBasic(share))));
      case HeapType::noexn:
        return fuzztest::Just(
          HeapTypePlan{HeapType(HeapTypes::exn.getBasic(share))});
    }
    WASM_UNREACHABLE("unexpected type");
  } else if (auto* index = sub.getIndex()) {
    assert(*index < plan.size);
    // Collect indices from the supertype chain as well as abstract supertypes.
    auto share = plan.kinds[*index].shared ? Shared : Unshared;
    std::vector<size_t> possibleIndices;
    for (auto curr = plan.supertypes[*index]; curr;
         curr = plan.supertypes[*curr]) {
      possibleIndices.push_back(*curr);
    }
    std::vector<HeapType> abstract;
    switch (plan.kinds[*index].kind) {
      case FuncKind:
        abstract = {HeapTypes::func.getBasic(share)};
        break;
      case StructKind:
        abstract = {HeapTypes::any.getBasic(share),
                    HeapTypes::eq.getBasic(share),
                    HeapTypes::struct_.getBasic(share)};
        break;
      case ArrayKind:
        abstract = {HeapTypes::any.getBasic(share),
                    HeapTypes::eq.getBasic(share),
                    HeapTypes::array.getBasic(share)};
        break;
      case ContKind:
        abstract = {HeapTypes::cont.getBasic(share)};
        break;
    }
    assert(!abstract.empty());
    if (possibleIndices.empty()) {
      return fuzztest::Map([](auto type) { return HeapTypePlan{type}; },
                           fuzztest::ElementOf(std::move(abstract)));
    } else {
      return fuzztest::VariantOf<HeapTypePlan>(
        fuzztest::ElementOf(std::move(abstract)),
        fuzztest::ElementOf(std::move(possibleIndices)));
    }
  } else {
    WASM_UNREACHABLE("unexpected variant");
  }
}

fuzztest::Domain<HeapTypePlan> AvailableHeapType(TypeBuilderPlan plan) {
  // Any reachable or abstract heap type, constrained to be shared if the type
  // definition we are constructing is shared.
  // TODO: Allow unshared types in shared function type defs?
  bool shared = plan.kinds[plan.curr].shared;
  auto abstract =
    shared ? ArbitrarySharedAbstractHeapType() : ArbitraryAbstractHeapType();
  return AvailableMatchingOrAbstractHeapType(
    plan,
    [&](auto kind, bool otherShared) { return !shared || otherShared; },
    abstract);
}

fuzztest::Domain<HeapTypePlan> AvailableSubHeapType(TypeBuilderPlan plan,
                                                    HeapTypePlan super) {
  // Choose a subtype of `super`, biasing toward `super` itself.
  return fuzztest::OneOf(fuzztest::Just(super),
                         AvailableStrictSubHeapType(std::move(plan), super));
}

fuzztest::Domain<HeapTypePlan> AvailableSuperHeapType(TypeBuilderPlan plan,
                                                      HeapTypePlan sub) {
  // Choose a supertype of `sub`, biasing toward `sub` itself.
  return fuzztest::OneOf(fuzztest::Just(sub),
                         AvailableStrictSuperHeapType(std::move(plan), sub));
}

fuzztest::Domain<RefPlan> AvailableRefType(TypeBuilderPlan plan) {
  // Independently random heap type and nullability.
  return fuzztest::StructOf<RefPlan>(AvailableHeapType(std::move(plan)),
                                     fuzztest::Arbitrary<bool>());
}

fuzztest::Domain<RefPlan> AvailableSubRefType(TypeBuilderPlan plan,
                                              RefPlan super) {
  auto heapType = AvailableSubHeapType(std::move(plan), super.type);
  if (super.nullable) {
    return fuzztest::StructOf<RefPlan>(heapType, fuzztest::Arbitrary<bool>());
  } else {
    return fuzztest::StructOf<RefPlan>(heapType, fuzztest::Just(false));
  }
}

fuzztest::Domain<RefPlan> AvailableSuperRefType(TypeBuilderPlan plan,
                                                RefPlan sub) {
  auto heapType = AvailableSuperHeapType(std::move(plan), sub.type);
  if (sub.nullable) {
    return fuzztest::StructOf<RefPlan>(heapType, fuzztest::Just(true));
  } else {
    return fuzztest::StructOf<RefPlan>(heapType, fuzztest::Arbitrary<bool>());
  }
}

fuzztest::Domain<TypePlan> AvailableType(TypeBuilderPlan plan) {
  // A non-reference types or a reference to an available heap type.
  return fuzztest::VariantOf<TypePlan>(ArbitraryNonRefType(),
                                       AvailableRefType(std::move(plan)));
}

fuzztest::Domain<TypePlan> AvailableSubType(TypeBuilderPlan plan,
                                            TypePlan super) {
  if (super.getNonRef()) {
    // No subtyping among non-ref types.
    return fuzztest::Just(super);
  } else if (auto* ref = super.getRef()) {
    return fuzztest::Map([](auto ref) { return TypePlan{ref}; },
                         AvailableSubRefType(std::move(plan), std::move(*ref)));
  } else {
    WASM_UNREACHABLE("unexpected variant");
  }
}

fuzztest::Domain<TypePlan> AvailableSuperType(TypeBuilderPlan plan,
                                              TypePlan sub) {
  if (auto* type = sub.getNonRef()) {
    // No subtyping among non-ref types.
    return fuzztest::Just(TypePlan{*type});
  } else if (auto* ref = sub.getRef()) {
    return fuzztest::Map(
      [](auto ref) { return TypePlan{ref}; },
      AvailableSuperRefType(std::move(plan), std::move(*ref)));
  } else {
    WASM_UNREACHABLE("unexpected variant");
  }
}

fuzztest::Domain<FieldTypePlan> AvailableFieldType(TypeBuilderPlan plan) {
  // A packed type or another available type.
  return fuzztest::VariantOf<FieldTypePlan>(
    fuzztest::ElementOf({Field::i8, Field::i16}),
    AvailableType(std::move(plan)));
}

fuzztest::Domain<FieldTypePlan> AvailableSubFieldType(TypeBuilderPlan plan,
                                                      FieldTypePlan super) {
  if (auto* packed = super.getPacked()) {
    // No subtyping on packed types.
    return fuzztest::Just(FieldTypePlan{*packed});
  } else if (auto* type = super.getNonPacked()) {
    return fuzztest::Map([](auto type) { return FieldTypePlan{type}; },
                         AvailableSubType(std::move(plan), *type));
  } else {
    WASM_UNREACHABLE("unexpected variant");
  }
}

fuzztest::Domain<FieldPlan> AvailableField(TypeBuilderPlan plan) {
  // An available field type and a random mutability.
  return fuzztest::StructOf<FieldPlan>(AvailableFieldType(std::move(plan)),
                                       fuzztest::Arbitrary<bool>());
}

fuzztest::Domain<FieldPlan> AvailableSubField(TypeBuilderPlan plan,
                                              FieldPlan super) {
  if (super.mutable_) {
    // Mutable fields cannot be modified in subtypes.
    return fuzztest::Just(super);
  }
  return fuzztest::Map(
    [&](auto type) {
      return FieldPlan{type, false};
    },
    AvailableSubFieldType(std::move(plan), super.type));
}

fuzztest::Domain<FuncPlan> FuncDef(TypeBuilderPlan plan) {
  auto params =
    fuzztest::VectorOf(AvailableType(plan)).WithMaxSize(MaxParamsSize);
  auto results = fuzztest::VectorOf(AvailableType(std::move(plan)))
                   .WithMaxSize(MaxResultsSize);
  return fuzztest::PairOf(params, results);
}

fuzztest::Domain<FuncPlan> SubFuncDef(TypeBuilderPlan plan, FuncPlan super) {
  // Params are contravariant and results are covariant.
  auto params = MapElements(
    [plan](TypePlan type) { return AvailableSuperType(plan, type); },
    super.first);
  auto results = MapElements(
    [plan = std::move(plan)](TypePlan type) {
      return AvailableSubType(std::move(plan), type);
    },
    super.second);
  return fuzztest::PairOf(params, results);
}

fuzztest::Domain<StructPlan> StructDef(TypeBuilderPlan plan) {
  return fuzztest::VectorOf(AvailableField(std::move(plan)))
    .WithMaxSize(MaxStructSize);
}

fuzztest::Domain<StructPlan> SubStructDef(TypeBuilderPlan plan,
                                          StructPlan super) {
  // First do depth subtyping, where we choose a subtype of each field, then
  // maybe add extra fields if there is space.
  auto depthSubTypeDomain = MapElements(
    [plan](const FieldPlan& field) { return AvailableSubField(plan, field); },
    super);
  return fuzztest::FlatMap(
    [plan](StructPlan toExtend) -> fuzztest::Domain<StructPlan> {
      if (toExtend.size() == MaxStructSize) {
        // No room to add more fields.
        return fuzztest::Just(toExtend);
      }
      auto extensionDomain = fuzztest::VectorOf(AvailableField(std::move(plan)))
                               .WithMaxSize(MaxStructSize - toExtend.size());
      return fuzztest::FlatMap(
        [toExtend](std::vector<FieldPlan> extension) {
          auto extended = toExtend;
          extended.insert(extended.end(), extension.begin(), extension.end());
          return fuzztest::Just(std::move(extended));
        },
        extensionDomain);
    },
    depthSubTypeDomain);
}

fuzztest::Domain<ArrayPlan> ArrayDef(TypeBuilderPlan plan) {
  return AvailableField(std::move(plan));
}

fuzztest::Domain<ArrayPlan> SubArrayDef(TypeBuilderPlan plan, ArrayPlan super) {
  return AvailableSubField(std::move(plan), super);
}

fuzztest::Domain<ContPlan> ContDef(TypeBuilderPlan plan) {
  // Find referenceable function types, restricting ourselves to shared
  // functions if necessary.
  bool shared = plan.kinds[plan.curr].shared;
  auto matches =
    AvailableMatchingIndices(std::move(plan), [&](auto kind, bool otherShared) {
      return kind == FuncKind && (!shared || otherShared);
    });
  if (matches.empty()) {
    return fuzztest::NullOpt<size_t>();
  } else {
    return fuzztest::NonNull(
      fuzztest::OptionalOf(fuzztest::ElementOf(std::move(matches))));
  }
}

fuzztest::Domain<ContPlan> SubContDef(TypeBuilderPlan plan, ContPlan super) {
  if (auto index = super) {
    // Choose an available subtype of the current continuation's function type,
    // biasing toward the current continuation's function type itself.
    auto matches = AvailableStrictSubIndices(std::move(plan), *index);
    if (matches.empty()) {
      // No other function indices available to create a subtype.
      return fuzztest::Just(super);
    }
    return fuzztest::OneOf(fuzztest::Just(super),
                           fuzztest::NonNull(fuzztest::OptionalOf(
                             fuzztest::ElementOf(std::move(matches)))));
  } else {
    // We will not generate subtypes of the fallback function type, so keep it
    // unchanged.
    return fuzztest::Just(super);
  }
}

fuzztest::Domain<TypeBuilderPlan> StepTypeDefinition(TypeBuilderPlan plan);

template<typename T>
fuzztest::Domain<TypeBuilderPlan> AppendTypeDef(TypeBuilderPlan plan, T def) {
  ++plan.curr;
  plan.defs.emplace_back(TypeDefPlan{std::move(def)});
  return StepTypeDefinition(std::move(plan));
}

fuzztest::Domain<TypeBuilderPlan> StepTypeDefinition(TypeBuilderPlan plan) {
  auto index = plan.curr;
  if (index == plan.size) {
    // We have created all the type defs.
    return fuzztest::Just(plan);
  }
  // If we have moved into a new rec group, update our state accordingly.
  if (index > plan.numReferenceable) {
    ++plan.currRecGroup;
    plan.numReferenceable += plan.recGroupSizes[plan.currRecGroup];
  }
  // Look at the type kind to determine what domain to draw the type
  // definition from.
  auto super = plan.supertypes[index];
  switch (plan.kinds[index].kind) {
    case FuncKind: {
      auto def =
        super ? SubFuncDef(plan, *plan.defs[*super].getFunc()) : FuncDef(plan);
      return fuzztest::FlatMap(
        AppendTypeDef<FuncPlan>, fuzztest::Just(std::move(plan)), def);
    }
    case StructKind: {
      auto def = super ? SubStructDef(plan, *plan.defs[*super].getStruct())
                       : StructDef(plan);
      return fuzztest::FlatMap(
        AppendTypeDef<StructPlan>, fuzztest::Just(std::move(plan)), def);
    }
    case ArrayKind: {
      auto def = super ? SubArrayDef(plan, *plan.defs[*super].getArray())
                       : ArrayDef(plan);
      return fuzztest::FlatMap(
        AppendTypeDef<ArrayPlan>, fuzztest::Just(std::move(plan)), def);
    }
    case ContKind: {
      auto def =
        super ? SubContDef(plan, *plan.defs[*super].getCont()) : ContDef(plan);
      return fuzztest::FlatMap(
        AppendTypeDef<ContPlan>, fuzztest::Just(std::move(plan)), def);
    }
  }
  WASM_UNREACHABLE("unexpected kind");
}

std::vector<HeapType> BuildHeapTypes(TypeBuilderPlan plan) {
  // Continuation types without reachable function types need a fallback.
  TypeBuilder fallbackBuilder(2);
  fallbackBuilder[0] = Signature();
  fallbackBuilder[1] = Signature();
  fallbackBuilder[1].setShared();
  auto builtFallbacks = fallbackBuilder.build();
  HeapType contFallback = (*builtFallbacks)[0];
  HeapType sharedContFallback = (*builtFallbacks)[1];

  TypeBuilder builder(plan.size);

  // Rec groups.
  size_t start = 0;
  for (auto size : plan.recGroupSizes) {
    builder.createRecGroup(start, size);
    start += size;
  }

  // Map plans onto the builder.

  auto heapType = [&](HeapTypePlan& plan) -> HeapType {
    if (auto* type = plan.getHeapType()) {
      return *type;
    } else if (auto* index = plan.getIndex()) {
      return builder[*index];
    } else {
      WASM_UNREACHABLE("unexpected variant");
    }
  };

  auto ref = [&](RefPlan& plan) -> Type {
    return builder.getTempRefType(heapType(plan.type),
                                  plan.nullable ? Nullable : NonNullable);
  };

  auto type = [&](TypePlan& plan) -> Type {
    if (auto* type = plan.getNonRef()) {
      return *type;
    } else if (auto* r = plan.getRef()) {
      return ref(*r);
    } else {
      WASM_UNREACHABLE("unexpected variant");
    }
  };

  auto field = [&](FieldPlan& plan) -> Field {
    if (auto* packed = plan.type.getPacked()) {
      return Field(*packed, plan.mutable_ ? Mutable : Immutable);
    } else if (auto* t = plan.type.getNonPacked()) {
      return Field(type(*t), plan.mutable_ ? Mutable : Immutable);
    } else {
      WASM_UNREACHABLE("unexpected variant");
    }
  };

  auto func = [&](FuncPlan& plan) -> Signature {
    std::vector<Type> params, results;
    for (auto& t : plan.first) {
      params.push_back(type(t));
    }
    for (auto& t : plan.second) {
      results.push_back(type(t));
    }
    return Signature(builder.getTempTupleType(std::move(params)),
                     builder.getTempTupleType(std::move(results)));
  };

  auto struct_ = [&](StructPlan& plan) -> Struct {
    std::vector<Field> fields;
    for (auto& f : plan) {
      fields.push_back(field(f));
    }
    return Struct(std::move(fields));
  };

  auto array = [&](ArrayPlan& plan) -> Array { return Array(field(plan)); };

  auto cont = [&](ContPlan& plan, bool shared) -> Continuation {
    if (plan) {
      return Continuation(builder[*plan]);
    }
    return Continuation(shared ? sharedContFallback : contFallback);
  };

  for (size_t i = 0; i < plan.size; ++i) {
    if (auto* f = plan.defs[i].getFunc()) {
      builder[i] = func(*f);
    } else if (auto* s = plan.defs[i].getStruct()) {
      builder[i] = struct_(*s);
    } else if (auto* a = plan.defs[i].getArray()) {
      builder[i] = array(*a);
    } else if (auto* c = plan.defs[i].getCont()) {
      builder[i] = cont(*c, plan.kinds[i].shared);
    } else {
      WASM_UNREACHABLE("unexpected variant");
    }

    if (auto super = plan.supertypes[i]) {
      builder[i].subTypeOf(builder[*super]);
    }
    builder[i].setOpen(!plan.kinds[i].final);
    builder[i].setShared(plan.kinds[i].shared ? Shared : Unshared);
  }
  auto built = builder.build();
  if (auto* err = built.getError()) {
    std::cerr << err->index << ": " << err->reason << "\n";
    std::cerr << "Plan: " << plan << '\n';
  }
  assert(built);
  return *built;
}

auto ArbitraryDefinedHeapTypesAndPlan() {
  return fuzztest::Map(
    [](TypeBuilderPlan plan) {
      auto types = BuildHeapTypes(plan);
      return std::pair(std::move(types), std::move(plan));
    },
    ArbitraryTypeBuilderPlan());
}

void TestBuiltTypes(std::pair<std::vector<HeapType>, TypeBuilderPlan> pair) {
  auto types = std::move(pair.first);
  auto plan = std::move(pair.second);

  ASSERT_EQ(types.size(), plan.size);

  auto checkHeapType = [&](HeapTypePlan& plan, HeapType type) {
    if (auto* t = plan.getHeapType()) {
      EXPECT_EQ(*t, type);
    } else if (auto* i = plan.getIndex()) {
      EXPECT_EQ(types[*i], type);
    } else {
      WASM_UNREACHABLE("unexpected variant");
    }
  };

  auto checkRefType = [&](RefPlan& plan, Type type) {
    ASSERT_TRUE(type.isRef());
    checkHeapType(plan.type, type.getHeapType());
    EXPECT_EQ(plan.nullable, type.isNullable());
  };

  auto checkType = [&](TypePlan& plan, Type type) {
    if (auto* t = plan.getNonRef()) {
      EXPECT_EQ(*t, type);
    } else if (auto* r = plan.getRef()) {
      checkRefType(*r, type);
    } else {
      WASM_UNREACHABLE("unexpected variant");
    }
  };

  auto checkField = [&](FieldPlan& plan, Field field) {
    EXPECT_EQ(plan.mutable_, field.mutable_ == Mutable);
    if (auto* packed = plan.type.getPacked()) {
      EXPECT_TRUE(field.isPacked());
      EXPECT_EQ(field.packedType, *packed);
    } else if (auto* t = plan.type.getNonPacked()) {
      checkType(*t, field.type);
    }
  };

  auto checkFunc = [&](FuncPlan& plan, HeapType type) {
    ASSERT_TRUE(type.isSignature());
    auto sig = type.getSignature();
    ASSERT_EQ(plan.first.size(), sig.params.size());
    ASSERT_EQ(plan.second.size(), sig.results.size());
    for (size_t i = 0; i < plan.first.size(); ++i) {
      checkType(plan.first[i], sig.params[i]);
    }
    for (size_t i = 0; i < plan.second.size(); ++i) {
      checkType(plan.second[i], sig.results[i]);
    }
  };

  auto checkStruct = [&](StructPlan& plan, HeapType type) {
    ASSERT_TRUE(type.isStruct());
    const auto& fields = type.getStruct().fields;
    ASSERT_EQ(plan.size(), fields.size());
    for (size_t i = 0; i < plan.size(); ++i) {
      checkField(plan[i], fields[i]);
    }
  };

  auto checkArray = [&](ArrayPlan& plan, HeapType type) {
    ASSERT_TRUE(type.isArray());
    checkField(plan, type.getArray().element);
  };

  auto checkCont = [&](ContPlan& plan, HeapType type) {
    ASSERT_TRUE(type.isContinuation());
    if (plan) {
      EXPECT_EQ(types[*plan], type.getContinuation().type);
    }
  };

  auto checkDef = [&](TypeDefPlan& plan, HeapType type) {
    if (auto* f = plan.getFunc()) {
      checkFunc(*f, type);
    } else if (auto* s = plan.getStruct()) {
      checkStruct(*s, type);
    } else if (auto* a = plan.getArray()) {
      checkArray(*a, type);
    } else if (auto* c = plan.getCont()) {
      checkCont(*c, type);
    } else {
      WASM_UNREACHABLE("unexpected variant");
    }
  };

  for (size_t i = 0; i < plan.size; ++i) {
    EXPECT_EQ(plan.kinds[i].shared, types[i].isShared());
    EXPECT_EQ(plan.kinds[i].final, !types[i].isOpen());
    if (auto super = plan.supertypes[i]) {
      auto supertype = types[i].getDeclaredSuperType();
      ASSERT_TRUE(supertype);
      EXPECT_EQ(types[*super], *supertype);
    } else {
      EXPECT_FALSE(types[i].getDeclaredSuperType());
    }
    checkDef(plan.defs[i], types[i]);
  }
}
FUZZ_TEST(TypeBuilderDomainsTest, TestBuiltTypes)
  .WithDomains(ArbitraryDefinedHeapTypesAndPlan());

} // anonymous namespace

fuzztest::Domain<TypeBuilderPlan> ArbitraryTypeBuilderPlan() {
  // Initialize an abstract type builder plan, then add concrete type definition
  // plans.
  return fuzztest::FlatMap(StepTypeDefinition, InitConcreteTypeBuilderPlan());
}

fuzztest::Domain<std::vector<HeapType>> ArbitraryDefinedHeapTypes() {
  return fuzztest::Map(BuildHeapTypes, ArbitraryTypeBuilderPlan());
}

fuzztest::Domain<std::pair<HeapType, HeapType>> ArbitraryHeapTypePair() {
  return fuzztest::FlatMap(
    [](auto types) {
      auto typeDomain = fuzztest::OneOf(fuzztest::ElementOf(types),
                                        ArbitraryAbstractHeapType());
      return fuzztest::PairOf(typeDomain, typeDomain);
    },
    ArbitraryDefinedHeapTypes());
}

} // namespace wasm
