#include "mixed_arena.h"
#include "gtest/gtest.h"

using ArenaTest = ::testing::Test;

TEST_F(ArenaTest, Swap) {
  MixedArena arena;

  ArenaVector<int> a(arena);
  a.push_back(10);
  a.push_back(20);

  ArenaVector<int> b(arena);

  EXPECT_EQ(a.size(), 2U);
  EXPECT_EQ(b.size(), 0U);

  a.swap(b);

  EXPECT_EQ(a.size(), 0U);
  EXPECT_EQ(b.size(), 2U);

  a.swap(b);

  EXPECT_EQ(a.size(), 2U);
  EXPECT_EQ(b.size(), 0U);

  // Now reverse a and b. The swap should be the same.

  b.swap(a);

  EXPECT_EQ(a.size(), 0U);
  EXPECT_EQ(b.size(), 2U);

  b.swap(a);

  EXPECT_EQ(a.size(), 2U);
  EXPECT_EQ(b.size(), 0U);
}
