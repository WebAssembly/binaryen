#include "wasm-type.h"
#include "gtest/gtest.h"

#ifndef wasm_test_gtest_type_test_h
#define wasm_test_gtest_type_test_h

// Helper test fixture for managing the global type system state.
template<wasm::TypeSystem system>
class TypeSystemTest : public ::testing::Test {
  wasm::TypeSystem originalSystem;

protected:
  void SetUp() override {
    originalSystem = wasm::getTypeSystem();
    wasm::setTypeSystem(system);
  }
  void TearDown() override {
    wasm::destroyAllTypesForTestingPurposesOnly();
    wasm::setTypeSystem(originalSystem);
  }

  // Utilities
  wasm::Struct makeStruct(wasm::TypeBuilder& builder,
                          std::initializer_list<size_t> indices) {
    using namespace wasm;
    FieldList fields;
    for (auto index : indices) {
      Type ref = builder.getTempRefType(builder[index], Nullable);
      fields.emplace_back(ref, Mutable);
    }
    return Struct(std::move(fields));
  }
};

using TypeTest = TypeSystemTest<wasm::TypeSystem::Isorecursive>;
using NominalTest = TypeSystemTest<wasm::TypeSystem::Nominal>;
using IsorecursiveTest = TypeSystemTest<wasm::TypeSystem::Isorecursive>;

#endif // wasm_test_gtest_type_test_h
