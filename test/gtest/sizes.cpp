#include "wasm.h"
#include "gtest/gtest.h"

using namespace wasm;

// Verify that Expression and its derived classes maintain their expected sizes
// on linux64 (specifically avoiding regressions in tail-padding reuse and field
// ordering).
TEST(SizesTest, ExpressionSizes) {
#if !defined(__linux__) || !defined(__x86_64__)
  GTEST_SKIP() << "This test's numbers are for linux64";
#else
  EXPECT_EQ(sizeof(Expression), 16u);
  EXPECT_EQ(sizeof(Load), 48u);
  EXPECT_EQ(sizeof(Store), 64u);
  EXPECT_EQ(sizeof(SIMDExtract), 24u);
  EXPECT_EQ(sizeof(TupleExtract), 24u);
  EXPECT_EQ(sizeof(StructGet), 24u);
  EXPECT_EQ(sizeof(StructSet), 32u);
  EXPECT_EQ(sizeof(ArrayGet), 32u);
  EXPECT_EQ(sizeof(ArraySet), 40u);
#endif
}
