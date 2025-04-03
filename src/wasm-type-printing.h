/*
 * Copyright 2022 WebAssembly Community Group participants
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

#ifndef wasm_wasm_type_printing_h
#define wasm_wasm_type_printing_h

#include <cstddef>
#include <iostream>
#include <unordered_map>

#include "support/name.h"
#include "support/utilities.h"
#include "wasm-type.h"
#include "wasm.h"

namespace wasm {

// CRTP base that all other type name generators should subclass. Provides the
// ability to use the generator as a function to print Types and HeapTypes to
// streams.
template<typename Subclass> struct TypeNameGeneratorBase {
  TypeNameGeneratorBase() { assertValidUsage(); }

  TypeNames getNames(HeapTypeDef type) {
    WASM_UNREACHABLE("Derived class must implement getNames");
  }
  HeapType::Printed operator()(HeapTypeDef type) {
    return type.print([&](HeapTypeDef ht) {
      return static_cast<Subclass*>(this)->getNames(ht);
    });
  }
  Type::Printed operator()(Type type) {
    return type.print([&](HeapTypeDef ht) {
      return static_cast<Subclass*>(this)->getNames(ht);
    });
  }

private:
  constexpr void assertValidUsage() {
#if !defined(__GNUC__) || __GNUC__ >= 14
    // Check that the subclass provides `getNames` with the correct type.
    using Self = TypeNameGeneratorBase<Subclass>;
    static_assert(
      static_cast<TypeNames (Self::*)(HeapTypeDef)>(&Self::getNames) !=
        static_cast<TypeNames (Self::*)(HeapTypeDef)>(&Subclass::getNames),
      "Derived class must implement getNames");
#endif
  }
};

// Generates names like "func.0", "struct.1", "array.2", etc. Struct fields are
// not given names.
struct DefaultTypeNameGenerator
  : TypeNameGeneratorBase<DefaultTypeNameGenerator> {
  size_t funcCount = 0;
  size_t contCount = 0;
  size_t structCount = 0;
  size_t arrayCount = 0;

  // Cached names for types that have already been seen.
  std::unordered_map<HeapType, TypeNames> nameCache;

  TypeNames getNames(HeapTypeDef type);
};

// Generates names based on the indices of types in some collection, falling
// back to the given FallbackGenerator when encountering a type not in the
// collection. Struct fields are not given names.
template<typename FallbackGenerator = DefaultTypeNameGenerator>
struct IndexedTypeNameGenerator
  : TypeNameGeneratorBase<IndexedTypeNameGenerator<FallbackGenerator>> {
  DefaultTypeNameGenerator defaultGenerator;
  FallbackGenerator& fallback;
  std::unordered_map<HeapTypeDef, TypeNames> names;

  template<typename T>
  IndexedTypeNameGenerator(T& types,
                           FallbackGenerator& fallback,
                           const std::string& prefix = "")
    : fallback(fallback) {
    for (size_t i = 0; i < types.size(); ++i) {
      names.insert({types[i], {prefix + std::to_string(i), {}}});
    }
  }
  template<typename T>
  IndexedTypeNameGenerator(T& types, const std::string& prefix = "")
    : IndexedTypeNameGenerator(types, defaultGenerator, prefix) {}

  TypeNames getNames(HeapTypeDef type) {
    if (auto it = names.find(type); it != names.end()) {
      return it->second;
    } else {
      return fallback.getNames(type);
    }
  }
};

// Deduction guide.
template<typename T> IndexedTypeNameGenerator(T&) -> IndexedTypeNameGenerator<>;

// Prints heap types stored in a module, falling back to the given
// FallbackGenerator if the module does not have a name for type type.
template<typename FallbackGenerator = DefaultTypeNameGenerator>
struct ModuleTypeNameGenerator
  : TypeNameGeneratorBase<ModuleTypeNameGenerator<FallbackGenerator>> {
  const Module& wasm;
  DefaultTypeNameGenerator defaultGenerator;
  FallbackGenerator& fallback;

  ModuleTypeNameGenerator(const Module& wasm, FallbackGenerator& fallback)
    : wasm(wasm), fallback(fallback) {}

  // TODO: Use C++20 `requires` to clean this up.
  template<class T = FallbackGenerator>
  ModuleTypeNameGenerator(
    const Module& wasm,
    std::enable_if_t<std::is_same_v<T, DefaultTypeNameGenerator>>* = nullptr)
    : ModuleTypeNameGenerator(wasm, defaultGenerator) {}

  TypeNames getNames(HeapTypeDef type) {
    if (auto it = wasm.typeNames.find(type); it != wasm.typeNames.end()) {
      return it->second;
    }
    return fallback.getNames(type);
  }
};

// Deduction guide.
ModuleTypeNameGenerator(const Module&) -> ModuleTypeNameGenerator<>;

} // namespace wasm

#endif // wasm_wasm_type_printing_h
