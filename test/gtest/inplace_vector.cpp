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

TEST_F(InplaceVectorTest, Erase) {
  inplace_vector<int, 5> vec{10, 20, 30, 40, 50};

  // Erase single element in the middle (30 at index 2)
  auto it = vec.erase(vec.begin() + 2);
  EXPECT_EQ(*it, 40);
  EXPECT_EQ(vec.size(), 4u);
  EXPECT_EQ(vec[0], 10);
  EXPECT_EQ(vec[1], 20);
  EXPECT_EQ(vec[2], 40);
  EXPECT_EQ(vec[3], 50);

  // Erase range at beginning [10, 20]
  it = vec.erase(vec.begin(), vec.begin() + 2);
  EXPECT_EQ(*it, 40);
  EXPECT_EQ(vec.size(), 2u);
  EXPECT_EQ(vec[0], 40);
  EXPECT_EQ(vec[1], 50);

  // Erase at end
  it = vec.erase(vec.begin() + 1, vec.end());
  EXPECT_EQ(it, vec.end());
  EXPECT_EQ(vec.size(), 1u);
  EXPECT_EQ(vec[0], 40);
}

TEST_F(InplaceVectorTest, EraseIf) {
  // Test std::erase_if on inplace_vector
  inplace_vector<int, 5> vec{1, 2, 3, 4, 5};
  size_t erased = std::erase_if(vec, [](int x) { return x % 2 == 0; });
  EXPECT_EQ(erased, 2u);
  EXPECT_EQ(vec.size(), 3u);
  EXPECT_EQ(vec[0], 1);
  EXPECT_EQ(vec[1], 3);
  EXPECT_EQ(vec[2], 5);

  // Erase remaining elements
  erased = std::erase_if(vec, [](int x) { return x > 0; });
  EXPECT_EQ(erased, 3u);
  EXPECT_TRUE(vec.empty());
}

TEST_F(InplaceVectorTest, Insert) {
  inplace_vector<int, 6> vec{10, 30, 40};

  // Insert single element in middle (20 at index 1)
  auto it = vec.insert(vec.begin() + 1, 20);
  EXPECT_EQ(*it, 20);
  EXPECT_EQ(vec.size(), 4u);
  EXPECT_EQ(vec[0], 10);
  EXPECT_EQ(vec[1], 20);
  EXPECT_EQ(vec[2], 30);
  EXPECT_EQ(vec[3], 40);

  // Insert at beginning (5 at index 0)
  it = vec.insert(vec.begin(), 5);
  EXPECT_EQ(*it, 5);
  EXPECT_EQ(vec.size(), 5u);
  EXPECT_EQ(vec[0], 5);
  EXPECT_EQ(vec[1], 10);

  // Insert at end (50 at index 5)
  it = vec.insert(vec.end(), 50);
  EXPECT_EQ(*it, 50);
  EXPECT_EQ(vec.size(), 6u);
  EXPECT_EQ(vec[5], 50);
}

TEST_F(InplaceVectorTest, SortAndIteratorOps) {
  inplace_vector<int, 5> vec{40, 10, 50, 20, 30};

  // Test iterator subscripting and friend operator+
  EXPECT_EQ(vec.begin()[1], 10);
  EXPECT_EQ(*(2 + vec.begin()), 50);

  // Test std::sort on inplace_vector iterators
  std::sort(vec.begin(), vec.end());
  EXPECT_EQ(vec, (inplace_vector<int, 5>{10, 20, 30, 40, 50}));
}
