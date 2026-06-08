#include "support/inplace_vector.h"
#include "gtest/gtest.h"

using InplaceVectorTest = ::testing::Test;

TEST_F(InplaceVectorTest, Basics) {
  std::inplace_vector<int64_t, 10> vec;
  EXPECT_EQ(sizeof(vec), sizeof(size_t) + 10 * sizeof(int64_t));
}
