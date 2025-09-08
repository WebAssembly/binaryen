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

#ifndef wasm_test_gtest_type_domains_h
#define wasm_test_gtest_type_domains_h

#include "fuzztest/fuzztest.h"
#include "wasm-type.h"

#ifndef FUZZTEST
#error "BUILD_FUZZTEST should be enabled"
#endif

namespace wasm {

inline fuzztest::Domain<HeapType> ArbitraryUnsharedAbstractHeapType() {
  return fuzztest::ElementOf<HeapType>({
    HeapTypes::ext,
    HeapTypes::func,
    HeapTypes::cont,
    HeapTypes::any,
    HeapTypes::eq,
    HeapTypes::i31,
    HeapTypes::struct_,
    HeapTypes::array,
    HeapTypes::exn,
    HeapTypes::string,
    HeapTypes::none,
    HeapTypes::noext,
    HeapTypes::nofunc,
    HeapTypes::nocont,
    HeapTypes::noexn,
  });
}

inline fuzztest::Domain<HeapType> ArbitrarySharedAbstractHeapType() {
  return fuzztest::ReversibleMap(
    [](HeapType ht) { return HeapType(ht.getBasic(Shared)); },
    [](HeapType ht) {
      return ht.isShared()
               ? std::optional{std::tuple{HeapType(ht.getBasic(Unshared))}}
               : std::nullopt;
    },
    ArbitraryUnsharedAbstractHeapType());
}

inline fuzztest::Domain<HeapType> ArbitraryAbstractHeapType() {
  return fuzztest::OneOf(ArbitraryUnsharedAbstractHeapType(),
                         ArbitrarySharedAbstractHeapType());
}

inline fuzztest::Domain<Type> ArbitraryNonRefType() {
  return fuzztest::ElementOf(
    std::vector<Type>{Type::i32, Type::i64, Type::f32, Type::f64, Type::v128});
}

enum UnsharedTypeKind { FuncKind, StructKind, ArrayKind, ContKind };

struct TypeKind {
  UnsharedTypeKind kind;
  bool shared;
  bool final;
};

struct HeapTypePlan : std::variant<HeapType, size_t> {
  HeapType* getHeapType() { return std::get_if<HeapType>(this); }
  size_t* getIndex() { return std::get_if<size_t>(this); }
};

struct RefPlan {
  HeapTypePlan type;
  bool nullable;
};

struct TypePlan : std::variant<Type, RefPlan> {
  Type* getNonRef() { return std::get_if<Type>(this); }
  RefPlan* getRef() { return std::get_if<RefPlan>(this); }
};

struct FieldTypePlan : std::variant<Field::PackedType, TypePlan> {
  Field::PackedType* getPacked() {
    return std::get_if<Field::PackedType>(this);
  }
  TypePlan* getNonPacked() { return std::get_if<TypePlan>(this); }
};

struct FieldPlan {
  FieldTypePlan type;
  bool mutable_;
};

using FuncPlan = std::pair<std::vector<TypePlan>, std::vector<TypePlan>>;
using StructPlan = std::vector<FieldPlan>;
using ArrayPlan = FieldPlan;
// If there is no available func type definition, this will be nullopt and we
// will have to use a default fallback.
using ContPlan = std::optional<size_t>;

struct TypeDefPlan : std::variant<FuncPlan, StructPlan, ArrayPlan, ContPlan> {
  FuncPlan* getFunc() { return std::get_if<FuncPlan>(this); }
  StructPlan* getStruct() { return std::get_if<StructPlan>(this); }
  ArrayPlan* getArray() { return std::get_if<ArrayPlan>(this); }
  ContPlan* getCont() { return std::get_if<ContPlan>(this); }
};

struct TypeBuilderPlan {
  // Index variable for controlling recursion during construction.
  size_t curr;

  // RecGroupPlan contents.
  size_t size;
  std::vector<size_t> recGroupSizes;

  // AbstractTypeBuilderPlan contents.
  std::vector<std::optional<size_t>> supertypes;
  std::vector<TypeKind> kinds;

  // TypeBuilderPlan contents.
  size_t currRecGroup = 0;
  size_t numReferenceable = 0;
  std::vector<TypeDefPlan> defs;

  // Built types.
  std::vector<HeapType> types;

  friend std::ostream& operator<<(std::ostream& o, const TypeBuilderPlan& plan);
};

static constexpr size_t MaxTypeBuilderSize = 8;
static constexpr size_t MaxParamsSize = 4;
static constexpr size_t MaxResultsSize = 2;
static constexpr size_t MaxStructSize = 8;

fuzztest::Domain<TypeBuilderPlan> ArbitraryTypeBuilderPlan();

fuzztest::Domain<std::vector<HeapType>> ArbitraryDefinedHeapTypes();

fuzztest::Domain<std::pair<HeapType, HeapType>> ArbitraryHeapTypePair();

// FuzzTest only supports extending the printer via AbslStringify, but we
// usually define operator<< for our custom printing. Add a generic
// implementation of AbslStringify enabled for anything in the wasm namespace
// that implements operator<< as expected.
template<typename T> constexpr bool type_exists = true;

template<typename Sink, typename T>
void AbslStringify(
  Sink& sink,
  const T& val,
  std::enable_if_t<type_exists<decltype(std::cout << val)>, bool> = false) {
  std::stringstream ss;
  ss << val;
  sink.Append(ss.str());
}

} // namespace wasm

#endif // wasm_test_gtest_type_domains_h
