#include "wasm-type.h"
#include "type-test.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST_F(TypeTest, UseAfterFreeOfCachedTypes) {
  // 1. Initialize the static types.
  HeapType i8Array1 = HeapTypes::getMutI8Array();
  HeapType i16Array1 = HeapTypes::getMutI16Array();
  Type i64Pair1 = Types::getI64Pair();

  EXPECT_TRUE(i8Array1.isArray());
  EXPECT_TRUE(i16Array1.isArray());
  EXPECT_TRUE(i64Pair1.isTuple());

  // 2. Destroy all types, simulating the end of a test case.
  wasm::destroyAllTypesForTestingPurposesOnly();

  // 3. Attempt to get the types again. Since they are cached as static local
  // variables, these calls will return the old, now-dangling references.
  HeapType i8Array2 = HeapTypes::getMutI8Array();
  HeapType i16Array2 = HeapTypes::getMutI16Array();
  Type i64Pair2 = Types::getI64Pair();

  // 4. Accessing the dangling references will cause a use-after-free.
  EXPECT_TRUE(i8Array2.isArray());
  EXPECT_TRUE(i16Array2.isArray());
  EXPECT_TRUE(i64Pair2.isTuple());
}
