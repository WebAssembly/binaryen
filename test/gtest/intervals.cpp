#include "support/intervals.h"
#include "ir/utils.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(IntervalsTest, TestEmpty) {
  std::vector<Interval> intervals;
  std::vector<int> expected;
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOne) {
  std::vector<Interval> intervals;
  intervals.emplace_back(0, 2, 5);
  std::vector<int> expected{0};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestNoOverlapFound) {
  std::vector<Interval> intervals;
  intervals.emplace_back(0, 4, 2);
  intervals.emplace_back(4, 8, 2);
  std::vector<int> expected{0, 1};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound) {
  std::vector<Interval> intervals;
  intervals.emplace_back(0, 2, 5);
  intervals.emplace_back(1, 4, 10);
  intervals.emplace_back(4, 5, 15);
  std::vector<int> expected{1, 2};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapAscendingSequence) {
  std::vector<Interval> intervals;
  intervals.emplace_back(0, 3, 6);
  intervals.emplace_back(2, 6, 2);
  intervals.emplace_back(3, 15, 5);
  intervals.emplace_back(4, 11, 1);
  intervals.emplace_back(6, 20, 15);
  intervals.emplace_back(12, 18, 3);
  intervals.emplace_back(14, 21, 5);
  intervals.emplace_back(23, 28, 5);
  std::vector<int> expected{0, 4, 7};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapDescendingSequence) {
  std::vector<Interval> intervals;
  intervals.emplace_back(9, 15, 5);
  intervals.emplace_back(8, 11, 1);
  intervals.emplace_back(3, 15, 5);
  intervals.emplace_back(3, 6, 2);
  intervals.emplace_back(2, 10, 3);
  intervals.emplace_back(0, 3, 6);
  std::vector<int> expected{5, 2};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapRandomSequence) {
  std::vector<Interval> intervals;
  intervals.emplace_back(21, 24, 1);
  intervals.emplace_back(0, 5, 1);
  intervals.emplace_back(11, 18, 1);
  intervals.emplace_back(28, 35, 1);
  intervals.emplace_back(5, 11, 1);
  intervals.emplace_back(18, 21, 1);
  intervals.emplace_back(35, 40, 1);
  intervals.emplace_back(24, 28, 1);
  std::vector<int> expected{1, 4, 2, 5, 0, 7, 3, 6};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapInnerNested) {
  std::vector<Interval> intervals;
  intervals.emplace_back(0, 12, 3);
  intervals.emplace_back(2, 4, 2);
  intervals.emplace_back(3, 6, 5);
  intervals.emplace_back(12, 15, 4);
  std::vector<int> expected{2, 3};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapOuterNested) {
  std::vector<Interval> intervals;
  intervals.emplace_back(0, 3, 6);
  intervals.emplace_back(4, 11, 1);
  intervals.emplace_back(12, 18, 3);
  intervals.emplace_back(2, 15, 6);
  std::vector<int> expected{0, 1, 2};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}
