/*
 * Copyright 2026 WebAssembly Community Group participants
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

#include <cstdint>
#include <limits>
#include <sstream>

#include "support/span.h"
#include "gtest/gtest.h"

using namespace wasm;

// ============================================================================
// Generic Span<T> tests
// ============================================================================

TEST(SpanTest, EmptySpanInt) {
  Span<int32_t> empty = Span<int32_t>::empty();
  EXPECT_TRUE(empty.isEmpty());
  EXPECT_FALSE(empty.isFull());

  Span<int32_t> invalid(10, 5);
  EXPECT_TRUE(invalid.isEmpty());
  EXPECT_FALSE(invalid.isFull());

  EXPECT_EQ(empty, invalid);

  Span<int32_t> s;
  EXPECT_FALSE(s.isEmpty());
  s.setEmpty();
  EXPECT_TRUE(s.isEmpty());
  EXPECT_EQ(s, empty);
}

TEST(SpanTest, FullSpanIntTypes) {
  // Signed 32-bit
  Span<int32_t> fullI32 = Span<int32_t>::full();
  EXPECT_TRUE(fullI32.isFull());
  EXPECT_FALSE(fullI32.isEmpty());
  EXPECT_EQ(fullI32.min, std::numeric_limits<int32_t>::min());
  EXPECT_EQ(fullI32.max, std::numeric_limits<int32_t>::max());

  Span<int32_t> defI32;
  EXPECT_TRUE(defI32.isFull());
  EXPECT_EQ(defI32, fullI32);

  // Unsigned 32-bit
  Span<uint32_t> fullU32 = Span<uint32_t>::full();
  EXPECT_TRUE(fullU32.isFull());
  EXPECT_FALSE(fullU32.isEmpty());
  EXPECT_EQ(fullU32.min, 0u);
  EXPECT_EQ(fullU32.max, std::numeric_limits<uint32_t>::max());

  // Signed 64-bit
  Span<int64_t> fullI64 = Span<int64_t>::full();
  EXPECT_TRUE(fullI64.isFull());
  EXPECT_FALSE(fullI64.isEmpty());
  EXPECT_EQ(fullI64.min, std::numeric_limits<int64_t>::min());
  EXPECT_EQ(fullI64.max, std::numeric_limits<int64_t>::max());

  // Unsigned 64-bit
  Span<uint64_t> fullU64 = Span<uint64_t>::full();
  EXPECT_TRUE(fullU64.isFull());
  EXPECT_FALSE(fullU64.isEmpty());
  EXPECT_EQ(fullU64.min, 0ull);
  EXPECT_EQ(fullU64.max, std::numeric_limits<uint64_t>::max());
}

TEST(SpanTest, SetSingleValue) {
  Span<int32_t> s;
  s.set(42);
  EXPECT_EQ(s.min, 42);
  EXPECT_EQ(s.max, 42);
  EXPECT_FALSE(s.isEmpty());
  EXPECT_FALSE(s.isFull());
  EXPECT_EQ(s, Span<int32_t>(42, 42));
}

TEST(SpanTest, SetFull) {
  Span<int32_t> s(10, 20);
  EXPECT_FALSE(s.isFull());
  s.setFull();
  EXPECT_TRUE(s.isFull());
  EXPECT_EQ(s.min, std::numeric_limits<int32_t>::min());
  EXPECT_EQ(s.max, std::numeric_limits<int32_t>::max());
}

TEST(SpanTest, IntersectionInt) {
  Span<int32_t> a(1, 10);
  Span<int32_t> b(5, 15);
  Span<int32_t> ab = a.intersection(b);
  EXPECT_EQ(ab, Span<int32_t>(5, 10));

  // Commutativity
  EXPECT_EQ(b.intersection(a), Span<int32_t>(5, 10));

  // Touching at a single point
  Span<int32_t> c(10, 20);
  EXPECT_EQ(a.intersection(c), Span<int32_t>(10, 10));

  // Disjoint
  Span<int32_t> d(11, 20);
  EXPECT_TRUE(a.intersection(d).isEmpty());
  EXPECT_EQ(a.intersection(d), Span<int32_t>::empty());

  // Contained
  Span<int32_t> e(3, 7);
  EXPECT_EQ(a.intersection(e), Span<int32_t>(3, 7));

  // Identical
  EXPECT_EQ(a.intersection(a), a);

  // With empty
  EXPECT_TRUE(a.intersection(Span<int32_t>::empty()).isEmpty());
  EXPECT_TRUE(Span<int32_t>::empty().intersection(a).isEmpty());

  // With full
  EXPECT_EQ(a.intersection(Span<int32_t>::full()), a);
  EXPECT_EQ(Span<int32_t>::full().intersection(a), a);
}

TEST(SpanTest, HasOverlapInt) {
  Span<int32_t> a(1, 10);
  Span<int32_t> b(5, 15);
  Span<int32_t> c(10, 20);
  Span<int32_t> d(11, 20);

  EXPECT_TRUE(a.hasOverlap(b));
  EXPECT_TRUE(b.hasOverlap(a));
  EXPECT_TRUE(a.hasOverlap(c));
  EXPECT_FALSE(a.hasOverlap(d));
  EXPECT_FALSE(d.hasOverlap(a));

  EXPECT_FALSE(a.hasOverlap(Span<int32_t>::empty()));
  EXPECT_TRUE(a.hasOverlap(Span<int32_t>::full()));
  EXPECT_FALSE(Span<int32_t>::empty().hasOverlap(Span<int32_t>::full()));
}

TEST(SpanTest, ContainsInt) {
  Span<int32_t> a(1, 10);
  Span<int32_t> b(3, 7);
  Span<int32_t> c(5, 15);
  Span<int32_t> d(11, 20);

  EXPECT_TRUE(a.contains(b));
  EXPECT_FALSE(b.contains(a));

  EXPECT_TRUE(a.contains(a));
  EXPECT_FALSE(a.contains(c));
  EXPECT_FALSE(a.contains(d));

  EXPECT_TRUE(a.contains(Span<int32_t>::empty()));
  EXPECT_TRUE(Span<int32_t>::empty().contains(Span<int32_t>::empty()));
  EXPECT_FALSE(Span<int32_t>::empty().contains(a));

  EXPECT_TRUE(Span<int32_t>::full().contains(a));
  EXPECT_TRUE(Span<int32_t>::full().contains(Span<int32_t>::empty()));
  EXPECT_FALSE(a.contains(Span<int32_t>::full()));
}

TEST(SpanTest, StreamOutput) {
  auto toString = [](const auto& span) {
    std::ostringstream ss;
    ss << span;
    return ss.str();
  };

  EXPECT_EQ(toString(Span<int32_t>(1, 10)), "[1, 10]");
  EXPECT_EQ(toString(Span<int32_t>::empty()), "[empty]");
  EXPECT_EQ(toString(Span<int32_t>(10, 5)), "[empty]");
}

// ============================================================================
// Spans<T, N> and SpansU2 tests
// ============================================================================

TEST(SpansTest, Construction) {
  SpansU2 empty;
  EXPECT_TRUE(empty.empty());
  EXPECT_EQ(empty.size(), 0u);

  SpansU2 fromSpans{Span<uint64_t>(0, 10), Span<uint64_t>(20, 30)};
  EXPECT_FALSE(fromSpans.empty());
  EXPECT_EQ(fromSpans.size(), 2u);
  EXPECT_EQ(fromSpans[0], Span<uint64_t>(0, 10));
  EXPECT_EQ(fromSpans[1], Span<uint64_t>(20, 30));

  SpansU2 fromCoords{0, 10, 20, 30};
  EXPECT_EQ(fromCoords.size(), 2u);
  EXPECT_EQ(fromCoords[0], Span<uint64_t>(0, 10));
  EXPECT_EQ(fromCoords[1], Span<uint64_t>(20, 30));

  SpansU2 single{5, 15};
  EXPECT_EQ(single.size(), 1u);
  EXPECT_EQ(single[0], Span<uint64_t>(5, 15));
}

TEST(SpansTest, Equality) {
  EXPECT_EQ(SpansU2(), SpansU2());
  EXPECT_EQ((SpansU2{0, 10}), (SpansU2{0, 10}));
  EXPECT_EQ((SpansU2{0, 10, 20, 30}), (SpansU2{0, 10, 20, 30}));

  EXPECT_NE((SpansU2{0, 10}), SpansU2());
  EXPECT_NE((SpansU2{0, 10}), (SpansU2{0, 11}));
  EXPECT_NE((SpansU2{0, 10}), (SpansU2{0, 10, 20, 30}));
}

TEST(SpansTest, HasOverlap) {
  SpansU2 empty;
  SpansU2 s1{0, 10, 20, 30};
  SpansU2 s2{5, 15};
  SpansU2 s3{25, 35};
  SpansU2 s4{11, 19};
  SpansU2 s5{31, 40};
  SpansU2 s6{10, 20};

  EXPECT_FALSE(empty.hasOverlap(s1));
  EXPECT_FALSE(s1.hasOverlap(empty));
  EXPECT_FALSE(empty.hasOverlap(empty));

  // Overlap with first span
  EXPECT_TRUE(s1.hasOverlap(s2));
  EXPECT_TRUE(s2.hasOverlap(s1));

  // Overlap with second span
  EXPECT_TRUE(s1.hasOverlap(s3));
  EXPECT_TRUE(s3.hasOverlap(s1));

  // In the gap between spans: no overlap
  EXPECT_FALSE(s1.hasOverlap(s4));
  EXPECT_FALSE(s4.hasOverlap(s1));

  // Beyond all spans: no overlap
  EXPECT_FALSE(s1.hasOverlap(s5));
  EXPECT_FALSE(s5.hasOverlap(s1));

  // Touching at endpoints: overlaps
  EXPECT_TRUE(s1.hasOverlap(s6));
  EXPECT_TRUE(s6.hasOverlap(s1));
}

TEST(SpansTest, Contains) {
  SpansU2 empty;
  SpansU2 s1{0, 100, 200, 300};
  SpansU2 s2{10, 20};
  SpansU2 s3{210, 220};
  SpansU2 s4{10, 20, 210, 220};
  SpansU2 s5{50, 150};
  SpansU2 s6{10, 20, 250, 350};

  // Empty contains empty, non-empty contains empty, empty does not contain non-empty
  EXPECT_TRUE(empty.contains(empty));
  EXPECT_TRUE(s1.contains(empty));
  EXPECT_FALSE(empty.contains(s1));

  // Identity
  EXPECT_TRUE(s1.contains(s1));
  EXPECT_TRUE(s2.contains(s2));

  // Contained within first span
  EXPECT_TRUE(s1.contains(s2));
  EXPECT_FALSE(s2.contains(s1));

  // Contained within second span
  EXPECT_TRUE(s1.contains(s3));
  EXPECT_FALSE(s3.contains(s1));

  // Multiple spans each contained in one of s1's spans
  EXPECT_TRUE(s1.contains(s4));
  EXPECT_FALSE(s4.contains(s1));

  // Straddles gap: not contained
  EXPECT_FALSE(s1.contains(s5));

  // One span contained, but second span extends past s1: not contained
  EXPECT_FALSE(s1.contains(s6));
}

TEST(SpansTest, ExtremeBoundaries) {
  uint64_t maxU64 = std::numeric_limits<uint64_t>::max();
  uint64_t highBit = uint64_t(1) << 63;

  SpansU2 lowPart{0, 100};
  SpansU2 highPart{maxU64 - 100, maxU64};
  SpansU2 midPart{highBit - 10, highBit + 10};

  EXPECT_FALSE(lowPart.hasOverlap(highPart));
  EXPECT_FALSE(highPart.hasOverlap(lowPart));
  EXPECT_FALSE(lowPart.hasOverlap(midPart));
  EXPECT_FALSE(midPart.hasOverlap(highPart));

  SpansU2 split{0, 100, maxU64 - 100, maxU64};
  EXPECT_TRUE(split.contains(lowPart));
  EXPECT_TRUE(split.contains(highPart));
  EXPECT_FALSE(split.contains(midPart));

  SpansU2 fullRange{0, maxU64};
  EXPECT_TRUE(fullRange.contains(split));
  EXPECT_TRUE(fullRange.contains(lowPart));
  EXPECT_TRUE(fullRange.contains(highPart));
  EXPECT_TRUE(fullRange.contains(midPart));
}

TEST(SpansTest, Mutation) {
  SpansU2 s;
  EXPECT_TRUE(s.empty());

  s.push_back(Span<uint64_t>(10, 20));
  EXPECT_EQ(s.size(), 1u);
  EXPECT_EQ(s[0], Span<uint64_t>(10, 20));

  s.push_back(Span<uint64_t>(30, 40));
  EXPECT_EQ(s.size(), 2u);
  EXPECT_EQ(s[1], Span<uint64_t>(30, 40));

  s.pop_back();
  EXPECT_EQ(s.size(), 1u);
  EXPECT_EQ(s[0], Span<uint64_t>(10, 20));

  s.clear();
  EXPECT_TRUE(s.empty());
}

TEST(SpansTest, StreamOutput) {
  auto toString = [](const auto& spans) {
    std::ostringstream ss;
    ss << spans;
    return ss.str();
  };

  EXPECT_EQ(toString(SpansU2{}), "{empty}");
  EXPECT_EQ(toString(SpansU2{1, 10}), "{[1, 10]}");
  EXPECT_EQ(toString(SpansU2{1, 10, 20, 30}), "{[1, 10], [20, 30]}");
}
