#include "support/intervals.h"
#include "ir/utils.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(IntervalsTest, TestNoOverlapFound) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 4, 2});
  intervals.emplace_back(Interval{4, 8, 2});
  std::vector<int> expected{0, 1};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 2, 5});
  intervals.emplace_back(Interval{1, 4, 10});
  intervals.emplace_back(Interval{4, 5, 15});
  std::vector<int> expected{1, 2};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestEmpty) {
  std::vector<Interval> intervals;
  std::vector<int> expected;
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOne) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 2, 5});
  std::vector<int> expected{0};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}
