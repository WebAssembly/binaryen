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

#include "support/i65.h"
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
// Span<I65> tests (corner cases, sign mixing, large range)
// ============================================================================

TEST(SpanI65Test, FullAndLimits) {
  EXPECT_EQ(Span<I65>::Min, I65(std::numeric_limits<int64_t>::min()));
  EXPECT_EQ(Span<I65>::Max, I65(std::numeric_limits<uint64_t>::max()));

  Span<I65> full = Span<I65>::full();
  EXPECT_TRUE(full.isFull());
  EXPECT_FALSE(full.isEmpty());
  EXPECT_EQ(full.min, I65(std::numeric_limits<int64_t>::min()));
  EXPECT_EQ(full.max, I65(std::numeric_limits<uint64_t>::max()));

  // Default constructed span is full
  Span<I65> def;
  EXPECT_TRUE(def.isFull());
  EXPECT_FALSE(def.isEmpty());
  EXPECT_EQ(def, full);
}

TEST(SpanI65Test, Empty) {
  Span<I65> empty = Span<I65>::empty();
  EXPECT_TRUE(empty.isEmpty());
  EXPECT_FALSE(empty.isFull());

  Span<I65> empty2{I65(100), I65(-100)};
  EXPECT_TRUE(empty2.isEmpty());
  EXPECT_FALSE(empty2.isFull());
  EXPECT_EQ(empty, empty2);

  Span<I65> empty3{I65(uint64_t(1)), I65(int64_t(-1))};
  EXPECT_TRUE(empty3.isEmpty());
  EXPECT_EQ(empty, empty3);
}

TEST(SpanI65Test, SingletonsAtExtremes) {
  // Min int64 singleton
  Span<I65> minI64{I65(std::numeric_limits<int64_t>::min()),
                   I65(std::numeric_limits<int64_t>::min())};
  EXPECT_FALSE(minI64.isEmpty());
  EXPECT_FALSE(minI64.isFull());
  EXPECT_EQ(minI64.min, I65(std::numeric_limits<int64_t>::min()));
  EXPECT_EQ(minI64.max, I65(std::numeric_limits<int64_t>::min()));

  // -1 singleton
  Span<I65> negOne{I65(-1), I65(-1)};
  EXPECT_FALSE(negOne.isEmpty());

  // 0 singleton
  Span<I65> zero{I65(0), I65(0)};
  EXPECT_FALSE(zero.isEmpty());

  // 1 singleton
  Span<I65> one{I65(1), I65(1)};
  EXPECT_FALSE(one.isEmpty());

  // Max int64 singleton
  Span<I65> maxI64{I65(std::numeric_limits<int64_t>::max()),
                   I65(std::numeric_limits<int64_t>::max())};
  EXPECT_FALSE(maxI64.isEmpty());

  // 2^63 singleton (above int64_t max, into uint64_t territory)
  Span<I65> highBit{I65(uint64_t(1) << 63), I65(uint64_t(1) << 63)};
  EXPECT_FALSE(highBit.isEmpty());

  // Max uint64 singleton
  Span<I65> maxU64{I65(std::numeric_limits<uint64_t>::max()),
                   I65(std::numeric_limits<uint64_t>::max())};
  EXPECT_FALSE(maxU64.isEmpty());
}

TEST(SpanI65Test, CrossingZero) {
  Span<I65> span{I65(-10), I65(10)};
  EXPECT_FALSE(span.isEmpty());
  EXPECT_FALSE(span.isFull());

  // Contains points inside
  EXPECT_TRUE(span.contains(Span<I65>(I65(-10), I65(-10))));
  EXPECT_TRUE(span.contains(Span<I65>(I65(-5), I65(5))));
  EXPECT_TRUE(span.contains(Span<I65>(I65(0), I65(0))));
  EXPECT_TRUE(span.contains(Span<I65>(I65(10), I65(10))));

  // Does not contain points outside
  EXPECT_FALSE(span.contains(Span<I65>(I65(-11), I65(-11))));
  EXPECT_FALSE(span.contains(Span<I65>(I65(11), I65(11))));
  EXPECT_FALSE(span.contains(Span<I65>(I65(-15), I65(5))));
  EXPECT_FALSE(span.contains(Span<I65>(I65(-5), I65(15))));
}

TEST(SpanI65Test, NegativeAndPositiveIntersections) {
  Span<I65> neg{I65(-100), I65(-10)};
  Span<I65> pos{I65(10), I65(100)};

  EXPECT_FALSE(neg.hasOverlap(pos));
  EXPECT_FALSE(pos.hasOverlap(neg));
  EXPECT_TRUE(neg.intersection(pos).isEmpty());
  EXPECT_TRUE(pos.intersection(neg).isEmpty());

  Span<I65> touchNegZero{I65(-10), I65(0)};
  Span<I65> touchZeroPos{I65(0), I65(10)};
  EXPECT_TRUE(touchNegZero.hasOverlap(touchZeroPos));
  EXPECT_EQ(touchNegZero.intersection(touchZeroPos), Span<I65>(I65(0), I65(0)));

  Span<I65> overlap{I65(-50), I65(50)};
  EXPECT_EQ(neg.intersection(overlap), Span<I65>(I65(-50), I65(-10)));
  EXPECT_EQ(pos.intersection(overlap), Span<I65>(I65(10), I65(50)));
}

TEST(SpanI65Test, SignedUnsignedBoundary) {
  // Test around INT64_MAX and 2^63
  int64_t maxI64 = std::numeric_limits<int64_t>::max();
  uint64_t highBit = uint64_t(maxI64) + 1; // 0x8000000000000000ULL

  Span<I65> s1(I65(maxI64 - 100), I65(highBit + 50));
  Span<I65> s2(I65(highBit), I65(highBit + 100));

  EXPECT_TRUE(s1.hasOverlap(s2));
  EXPECT_EQ(s1.intersection(s2), Span<I65>(I65(highBit), I65(highBit + 50)));

  // Disjoint near 2^63 boundary
  Span<I65> s3{I65(maxI64 - 200), I65(maxI64)};
  Span<I65> s4{I65(highBit + 1), I65(highBit + 100)};
  EXPECT_FALSE(s3.hasOverlap(s4));
  EXPECT_TRUE(s3.intersection(s4).isEmpty());

  // Adjacent touching at 2^63
  Span<I65> s5{I65(maxI64), I65(highBit)};
  Span<I65> s6{I65(highBit), I65(highBit + 10)};
  EXPECT_TRUE(s5.hasOverlap(s6));
  EXPECT_EQ(s5.intersection(s6), Span<I65>(I65(highBit), I65(highBit)));
}

TEST(SpanI65Test, ExtremeBoundaries) {
  Span<I65> minPart(I65(std::numeric_limits<int64_t>::min()),
                    I65(std::numeric_limits<int64_t>::min() + 100));
  Span<I65> maxPart(I65(std::numeric_limits<uint64_t>::max() - 100),
                    I65(std::numeric_limits<uint64_t>::max()));

  EXPECT_FALSE(minPart.hasOverlap(maxPart));
  EXPECT_TRUE(minPart.intersection(maxPart).isEmpty());

  Span<I65> full = Span<I65>::full();
  EXPECT_TRUE(full.contains(minPart));
  EXPECT_TRUE(full.contains(maxPart));
  EXPECT_EQ(full.intersection(minPart), minPart);
  EXPECT_EQ(full.intersection(maxPart), maxPart);
  EXPECT_TRUE(full.hasOverlap(minPart));
  EXPECT_TRUE(full.hasOverlap(maxPart));

  Span<I65> allNeg(I65(std::numeric_limits<int64_t>::min()), I65(-1));
  Span<I65> allNonNeg(I65(0), I65(std::numeric_limits<uint64_t>::max()));

  EXPECT_FALSE(allNeg.hasOverlap(allNonNeg));
  EXPECT_TRUE(allNeg.intersection(allNonNeg).isEmpty());
  EXPECT_TRUE(full.contains(allNeg));
  EXPECT_TRUE(full.contains(allNonNeg));
}

TEST(SpanI65Test, SetAndMutate) {
  Span<I65> s;
  EXPECT_TRUE(s.isFull());

  s.set(I65(-12345));
  EXPECT_FALSE(s.isFull());
  EXPECT_FALSE(s.isEmpty());
  EXPECT_EQ(s.min, I65(-12345));
  EXPECT_EQ(s.max, I65(-12345));

  s.setEmpty();
  EXPECT_TRUE(s.isEmpty());

  s.setFull();
  EXPECT_TRUE(s.isFull());
}
