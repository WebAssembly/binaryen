#include "support/delta_debugging.h"
#include "gtest/gtest.h"
#include <algorithm>
#include <string>
#include <vector>

using namespace wasm;

TEST(DeltaDebuggingTest, EmptyInput) {
  std::vector<int> items;
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    dd.resolve(false);
  }
  EXPECT_TRUE(dd.working().empty());
}

TEST(DeltaDebuggingTest, SingleInputEmptySetWorks) {
  std::vector<int> items = {42};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    dd.resolve(dd.test().empty());
  }
  EXPECT_TRUE(dd.working().empty());
}

TEST(DeltaDebuggingTest, SingleInputEmptySetFails) {
  std::vector<int> items = {42};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    dd.resolve(!dd.test().empty());
  }
  std::vector<int> expected = {42};
  EXPECT_EQ(dd.working(), expected);
}

TEST(DeltaDebuggingTest, SingleItem) {
  std::vector<int> items = {0, 1, 2, 3, 4, 5, 6, 7};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    dd.resolve(std::find(dd.test().begin(), dd.test().end(), 3) !=
               dd.test().end());
  }
  std::vector<int> expected = {3};
  EXPECT_EQ(dd.working(), expected);
}

TEST(DeltaDebuggingTest, MultipleItemsAdjacent) {
  std::vector<int> items = {0, 1, 2, 3, 4, 5, 6, 7};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    bool has2 =
      std::find(dd.test().begin(), dd.test().end(), 2) != dd.test().end();
    bool has3 =
      std::find(dd.test().begin(), dd.test().end(), 3) != dd.test().end();
    dd.resolve(has2 && has3);
  }
  std::vector<int> expected = {2, 3};
  EXPECT_EQ(dd.working(), expected);
}

TEST(DeltaDebuggingTest, MultipleItemsNonAdjacent) {
  std::vector<int> items = {0, 1, 2, 3, 4, 5, 6, 7};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    bool has2 =
      std::find(dd.test().begin(), dd.test().end(), 2) != dd.test().end();
    bool has5 =
      std::find(dd.test().begin(), dd.test().end(), 5) != dd.test().end();
    dd.resolve(has2 && has5);
  }
  std::vector<int> expected = {2, 5};
  EXPECT_EQ(dd.working(), expected);
}

TEST(DeltaDebuggingTest, OrderMaintained) {
  std::vector<int> items = {3, 1, 4, 2};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    bool has3 =
      std::find(dd.test().begin(), dd.test().end(), 3) != dd.test().end();
    bool has2 =
      std::find(dd.test().begin(), dd.test().end(), 2) != dd.test().end();
    dd.resolve(has3 && has2);
  }
  std::vector<int> expected = {3, 2};
  EXPECT_EQ(dd.working(), expected);
}

TEST(DeltaDebuggingTest, DifferentTypes) {
  std::vector<std::string> items = {"apple", "banana", "cherry", "date"};
  DeltaDebugger<std::string> dd(items);
  while (!dd.finished()) {
    bool hasBanana = std::find(dd.test().begin(), dd.test().end(), "banana") !=
                     dd.test().end();
    bool hasDate =
      std::find(dd.test().begin(), dd.test().end(), "date") != dd.test().end();
    dd.resolve(hasBanana && hasDate);
  }
  std::vector<std::string> expected = {"banana", "date"};
  EXPECT_EQ(dd.working(), expected);
}

TEST(DeltaDebuggingTest, UnconditionallyTrue) {
  std::vector<int> items = {0, 1, 2, 3};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    dd.resolve(true);
  }
  EXPECT_TRUE(dd.working().empty());
}

TEST(DeltaDebuggingTest, UnconditionallyFalse) {
  std::vector<int> items = {0, 1, 2, 3};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    dd.resolve(false);
  }
  std::vector<int> expected = {0, 1, 2, 3};
  EXPECT_EQ(dd.working(), expected);
}

TEST(DeltaDebuggingTest, StructBasic) {
  std::vector<int> items = {0, 1, 2, 3, 4, 5, 6, 7};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    bool has3 =
      std::find(dd.test().begin(), dd.test().end(), 3) != dd.test().end();
    dd.resolve(has3);
  }
  std::vector<int> expected = {3};
  EXPECT_EQ(dd.working(), expected);
}

TEST(DeltaDebuggingTest, HierarchicalExample) {
  std::vector<std::vector<int>> items = {{1, 10}, {2, 10}, {3, 10}};

  auto testProperty = [](const std::vector<std::vector<int>>& lists) {
    int sum = 0;
    for (const auto& list : lists) {
      for (int x : list) {
        sum += x;
      }
    }
    return sum >= 20;
  };

  DeltaDebugger<std::vector<int>> dd(items);
  while (!dd.finished()) {
    dd.resolve(testProperty(dd.test()));
  }

  std::vector<std::vector<int>> currentLists = dd.working();

  for (size_t i = 0; i < currentLists.size(); ++i) {
    std::vector<int> currentList = currentLists[i];
    DeltaDebugger<int> subDd(currentList);

    while (!subDd.finished()) {
      std::vector<std::vector<int>> fullTestSet;
      for (size_t j = 0; j < currentLists.size(); ++j) {
        if (j == i) {
          fullTestSet.push_back(subDd.test());
        } else {
          fullTestSet.push_back(currentLists[j]);
        }
      }
      subDd.resolve(testProperty(fullTestSet));
    }
    currentLists[i] = subDd.working();
  }

  std::vector<std::vector<int>> expected = {{10}, {10}};
  EXPECT_EQ(currentLists, expected);
}

TEST(DeltaDebuggingTest, ResolveAfterFinished) {
  std::vector<int> items = {0, 1, 2, 3};
  DeltaDebugger<int> dd(items);
  while (!dd.finished()) {
    dd.resolve(false);
  }

  std::vector<int> expected = {0, 1, 2, 3};
  EXPECT_EQ(dd.working(), expected);
  EXPECT_TRUE(dd.finished());

  // Call resolve again
  dd.resolve(true);
  EXPECT_EQ(dd.working(), expected);
  EXPECT_TRUE(dd.finished());

  dd.resolve(false);
  EXPECT_EQ(dd.working(), expected);
  EXPECT_TRUE(dd.finished());
}
