#include "wasm/dwarf-ranges.h"
#include "gtest/gtest.h"

using namespace wasm::Debug;

TEST(DwarfRangesTest, Normalize) {
  DwarfRanges ranges{{8, 10}, {2, 4}, {4, 6}, {3, 5}};

  EXPECT_TRUE(ranges.normalize());
  EXPECT_EQ(ranges.get(), (std::vector<DwarfRange>{{2, 6}, {8, 10}}));
  EXPECT_FALSE(ranges.normalize());
}

TEST(DwarfRangesTest, Add) {
  DwarfRanges ranges{{2, 4}, {8, 10}};
  DwarfRanges added{{4, 8}, {12, 14}};

  EXPECT_TRUE(ranges.add(added));
  EXPECT_EQ(ranges.get(), (std::vector<DwarfRange>{{2, 10}, {12, 14}}));
  EXPECT_FALSE(ranges.add({{4, 8}}));
  EXPECT_FALSE(ranges.add({}));
}

TEST(DwarfRangesTest, Contains) {
  DwarfRanges ranges{{0, 4}, {8, 12}};

  EXPECT_TRUE(ranges.contains({{1, 3}, {9, 12}}));
  EXPECT_TRUE(ranges.contains({}));
  EXPECT_FALSE(ranges.contains({{3, 9}}));
  EXPECT_FALSE(ranges.contains({{12, 13}}));
}

TEST(DwarfRangesTest, Overlaps) {
  DwarfRanges ranges{{0, 4}, {8, 12}};

  EXPECT_TRUE(ranges.overlaps({{3, 5}}));
  EXPECT_TRUE(ranges.overlaps({{10, 14}}));
  EXPECT_FALSE(ranges.overlaps({{4, 8}}));
  EXPECT_FALSE(ranges.overlaps({{12, 14}}));
}
