#include "support/inplace_vector.h"
#include "gtest/gtest.h"

using InplaceVectorTest = ::testing::Test;

using namespace wasm;

TEST_F(InplaceVectorTest, Size) {
  inplace_vector<int64_t, 10> vec;
  // An inplace_vector is just a size plus the in-place storage.
  EXPECT_EQ(sizeof(vec), sizeof(size_t) + 10 * sizeof(int64_t));
}

TEST_F(InplaceVectorTest, Basics) {
  inplace_vector<int, 3> vec;

  EXPECT_EQ(vec.size(), 0);
  EXPECT_TRUE(vec.empty());
  vec.push_back(10);
  EXPECT_EQ(vec[0], 10);
  EXPECT_EQ(vec.size(), 1);

  vec.resize(3);
  EXPECT_EQ(vec.size(), 3);

  vec[1] = 20;
  vec[2] = 30;
  EXPECT_EQ(vec[1], 20);
  EXPECT_EQ(vec[2], 30);

  vec.pop_back();
  EXPECT_EQ(vec.size(), 2);
}

TEST_F(InplaceVectorTest, I) {
  inplace_vector<int, 3> vec{10, 20, 30};
  std::vector<int> normal;

  for (auto x : vec) {
    normal.push_back(x);
  }

  EXPECT_EQ(normal, std::vector<int>({10, 20, 30}));
}
