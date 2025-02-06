#include "support/intervals.h"
#include "ir/utils.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(IntervalsTest, TestNoOverlapFound) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 4, 2});
  intervals.emplace_back(Interval{4, 8, 2});
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals).size(), 2u);
}

TEST(IntervalsTest, TestOverlapFound) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 2, 5});
  intervals.emplace_back(Interval{1, 4, 10});
  intervals.emplace_back(Interval{4, 5, 15});
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals).size(), 2u);
}

TEST(IntervalsTest, TestEmpty) {
  std::vector<Interval> intervals;
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals).size(), 0u);
}

TEST(IntervalsTest, TestOne) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 2, 5});
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals).size(), 1u);
}
