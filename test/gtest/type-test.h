#include "wasm-type.h"
#include "gtest/gtest.h"

#ifndef wasm_test_gtest_type_test_h
#define wasm_test_gtest_type_test_h

// Helper test fixture for managing the global type system state.
class TypeTest : public ::testing::Test {
protected:
  void TearDown() override { wasm::destroyAllTypesForTestingPurposesOnly(); }

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

#endif // wasm_test_gtest_type_test_h
