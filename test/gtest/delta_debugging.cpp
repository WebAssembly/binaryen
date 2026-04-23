#include "support/delta_debugging.h"
#include "gtest/gtest.h"
#include <algorithm>
#include <string>
#include <vector>

using namespace wasm;

TEST(DeltaDebuggingTest, EmptyInput) {
  std::vector<int> items;
  auto result = deltaDebugging(
    items, [](size_t, size_t, const std::vector<int>&) { return false; });
  EXPECT_TRUE(result.empty());
}

TEST(DeltaDebuggingTest, SingleItem) {
  std::vector<int> items = {0, 1, 2, 3, 4, 5, 6, 7};
  auto result = deltaDebugging(
    items, [](size_t, size_t, const std::vector<int>& partition) {
      return std::find(partition.begin(), partition.end(), 3) !=
             partition.end();
    });
  std::vector<int> expected = {3};
  EXPECT_EQ(result, expected);
}

TEST(DeltaDebuggingTest, MultipleItemsAdjacent) {
  std::vector<int> items = {0, 1, 2, 3, 4, 5, 6, 7};
  auto result = deltaDebugging(
    items, [](size_t, size_t, const std::vector<int>& partition) {
      bool has2 =
        std::find(partition.begin(), partition.end(), 2) != partition.end();
      bool has3 =
        std::find(partition.begin(), partition.end(), 3) != partition.end();
      return has2 && has3;
    });
  std::vector<int> expected = {2, 3};
  EXPECT_EQ(result, expected);
}

TEST(DeltaDebuggingTest, MultipleItemsNonAdjacent) {
  std::vector<int> items = {0, 1, 2, 3, 4, 5, 6, 7};
  auto result = deltaDebugging(
    items, [](size_t, size_t, const std::vector<int>& partition) {
      bool has2 =
        std::find(partition.begin(), partition.end(), 2) != partition.end();
      bool has5 =
        std::find(partition.begin(), partition.end(), 5) != partition.end();
      return has2 && has5;
    });
  std::vector<int> expected = {2, 5};
  EXPECT_EQ(result, expected);
}

TEST(DeltaDebuggingTest, OrderMaintained) {
  std::vector<int> items = {3, 1, 4, 2};
  auto result = deltaDebugging(
    items, [](size_t, size_t, const std::vector<int>& partition) {
      bool has3 =
        std::find(partition.begin(), partition.end(), 3) != partition.end();
      bool has2 =
        std::find(partition.begin(), partition.end(), 2) != partition.end();
      return has3 && has2;
    });
  std::vector<int> expected = {3, 2};
  EXPECT_EQ(result, expected);
}

TEST(DeltaDebuggingTest, DifferentTypes) {
  std::vector<std::string> items = {"apple", "banana", "cherry", "date"};
  auto result = deltaDebugging(
    items, [](size_t, size_t, const std::vector<std::string>& partition) {
      bool hasBanana =
        std::find(partition.begin(), partition.end(), "banana") !=
        partition.end();
      bool hasDate = std::find(partition.begin(), partition.end(), "date") !=
                     partition.end();
      return hasBanana && hasDate;
    });
  std::vector<std::string> expected = {"banana", "date"};
  EXPECT_EQ(result, expected);
}

TEST(DeltaDebuggingTest, UnconditionallyTrue) {
  std::vector<int> items = {0, 1, 2, 3};
  auto result = deltaDebugging(
    items, [](size_t, size_t, const std::vector<int>&) { return true; });
  EXPECT_TRUE(result.empty());
}
