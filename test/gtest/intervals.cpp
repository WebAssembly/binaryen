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
  intervals.emplace_back(Interval{0, 2, 5});
  std::vector<int> expected{0};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

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

TEST(IntervalsTest, TestOverlapFound1) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 2, 1});
  intervals.emplace_back(Interval{1, 4, 1});
  intervals.emplace_back(Interval{4, 6, 1});
  intervals.emplace_back(Interval{4, 5, 1});
  std::vector<int> expected{1, 2};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound2) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 2, 3});
  intervals.emplace_back(Interval{1, 4, 2});
  intervals.emplace_back(Interval{4, 6, 1});
  intervals.emplace_back(Interval{4, 5, 4});
  std::vector<int> expected{1, 2};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound3) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 3, 1});
  intervals.emplace_back(Interval{3, 6, 2});
  intervals.emplace_back(Interval{6, 10, 3});
  intervals.emplace_back(Interval{8, 11, 4});
  std::vector<int> expected{1, 2};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound4) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 3, 4});
  intervals.emplace_back(Interval{3, 6, 2});
  intervals.emplace_back(Interval{6, 10, 3});
  intervals.emplace_back(Interval{8, 11, 1});
  intervals.emplace_back(Interval{7, 15, 5});
  std::vector<int> expected{};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound5) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 3, 6});
  intervals.emplace_back(Interval{3, 6, 2});
  intervals.emplace_back(Interval{2, 10, 3});
  intervals.emplace_back(Interval{8, 11, 1});
  intervals.emplace_back(Interval{9, 15, 5});
  intervals.emplace_back(Interval{3, 15, 5});
  std::vector<int> expected{};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound6) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{2, 6, 2});
  intervals.emplace_back(Interval{12, 18, 3});
  intervals.emplace_back(Interval{4, 11, 1});
  intervals.emplace_back(Interval{6, 20, 15});
  intervals.emplace_back(Interval{0, 3, 6});
  intervals.emplace_back(Interval{3, 15, 5});
  intervals.emplace_back(Interval{14, 21, 5});
  intervals.emplace_back(Interval{23, 28, 5});
  std::vector<int> expected{};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound7) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{21, 24, 1});
  intervals.emplace_back(Interval{0, 5, 1});
  intervals.emplace_back(Interval{11, 18, 1});
  intervals.emplace_back(Interval{28, 35, 1});
  intervals.emplace_back(Interval{5, 11, 1});
  intervals.emplace_back(Interval{18, 21, 1});
  intervals.emplace_back(Interval{35, 40, 1});
  intervals.emplace_back(Interval{24, 28, 1});
  std::vector<int> expected{};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound8) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 5, 10});
  intervals.emplace_back(Interval{5, 11, 100});
  intervals.emplace_back(Interval{11, 18, 5});
  intervals.emplace_back(Interval{18, 21, 8});
  intervals.emplace_back(Interval{21, 24, 2});
  intervals.emplace_back(Interval{24, 28, 4});
  intervals.emplace_back(Interval{28, 35, 6});
  intervals.emplace_back(Interval{35, 40, 7});
  std::vector<int> expected{};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}

TEST(IntervalsTest, TestOverlapFound9) {
  std::vector<Interval> intervals;
  intervals.emplace_back(Interval{0, 5, 1});
  intervals.emplace_back(Interval{0, 5, 1});
  intervals.emplace_back(Interval{0, 5, 1});
  intervals.emplace_back(Interval{0, 5, 1});
  intervals.emplace_back(Interval{0, 5, 1});
  std::vector<int> expected{};
  ASSERT_EQ(IntervalProcessor::filterOverlaps(intervals), expected);
}
