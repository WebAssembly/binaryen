// Copyright 2026 WebAssembly Community Group participants
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include "support/int128.h"
#include "gtest/gtest.h"
#include <limits>

using namespace wasm;

class Int128MulWideSTest
  : public ::testing::TestWithParam<Int128 (*)(uint64_t, uint64_t)> {};

TEST_P(Int128MulWideSTest, Basic) {
  auto mul_s = GetParam();

  // Simple cases
  EXPECT_EQ(mul_s(0, 0), (Int128{0, 0}));
  EXPECT_EQ(mul_s(1, 1), (Int128{0, 1}));

  // Mixed sign
  EXPECT_EQ(mul_s(-1, 1),
            (Int128{0xffffffffffffffffULL, 0xffffffffffffffffULL}));
  EXPECT_EQ(mul_s(1, -1),
            (Int128{0xffffffffffffffffULL, 0xffffffffffffffffULL}));

  // Double negative
  EXPECT_EQ(mul_s(-1, -1), (Int128{0, 1}));

  int64_t maxInt = std::numeric_limits<int64_t>::max();
  // Fits in the lower half because the signed bit now goes in the upper half.
  EXPECT_EQ(mul_s(maxInt, 2), (Int128{0, 0xfffffffffffffffeULL}));
  EXPECT_EQ(mul_s(maxInt, maxInt), (Int128{0x3fffffffffffffffULL, 1}));

  // Min Ints (0x8000000000000000)
  int64_t minInt = std::numeric_limits<int64_t>::min();
  EXPECT_EQ(mul_s(minInt, 2), (Int128{0xffffffffffffffffULL, 0}));
  EXPECT_EQ(mul_s(minInt, minInt), (Int128{0x4000000000000000ULL, 0}));
}

// Test that our fallback implementation is commutative
Int128 mul_wide_s_fallback_reversed(uint64_t lhs, uint64_t rhs) {
  return detail::mul_wide_s_fallback(rhs, lhs);
}

INSTANTIATE_TEST_SUITE_P(Int128,
                         Int128MulWideSTest,
                         ::testing::Values(mul_wide_s,
                                           detail::mul_wide_s_fallback,
                                           mul_wide_s_fallback_reversed));

class Int128MulWideUTest
  : public ::testing::TestWithParam<Int128 (*)(uint64_t, uint64_t)> {};

TEST_P(Int128MulWideUTest, Basic) {
  auto mul_u = GetParam();

  // Simple cases
  EXPECT_EQ(mul_u(0, 0), (Int128{0, 0}));
  EXPECT_EQ(mul_u(1, 0), (Int128{0, 0}));
  EXPECT_EQ(mul_u(1, 1), (Int128{0, 1}));

  // Max Uint (0xffffffffffffffff)
  uint64_t maxUint = std::numeric_limits<uint64_t>::max();
  EXPECT_EQ(mul_u(maxUint, 2), (Int128{1, 0xfffffffffffffffeULL}));
  EXPECT_EQ(mul_u(maxUint, maxUint), (Int128{0xfffffffffffffffeULL, 1}));

  // Max 32-bit uint (0xffffffff)
  EXPECT_EQ(mul_u(0xffffffffULL, 0xffffffffULL),
            (Int128{0, 0xfffffffe00000001ULL}));

  // Exactly 2^32 (0x100000000) - Tests a 1 in the lowest bit of the high half
  EXPECT_EQ(mul_u(0x100000000ULL, 0x100000000ULL), (Int128{1, 0}));

  // Mixed boundaries
  EXPECT_EQ(mul_u(0xffffffffULL, 0x100000000ULL),
            (Int128{0, 0xffffffff00000000ULL}));

  // Upper half filled, lower half empty
  uint64_t highOnly = 0xffffffff00000000ULL;
  EXPECT_EQ(mul_u(highOnly, 2), (Int128{1, 0xfffffffe00000000ULL}));

  // Lower half filled, upper half empty
  uint64_t lowOnly = 0x00000000ffffffffULL;
  EXPECT_EQ(mul_u(lowOnly, lowOnly), (Int128{0, 0xfffffffe00000001ULL}));
}

// Test that our fallback implementation is commutative
Int128 mul_wide_u_fallback_reversed(uint64_t lhs, uint64_t rhs) {
  return detail::mul_wide_u_fallback(rhs, lhs);
}

INSTANTIATE_TEST_SUITE_P(Int128,
                         Int128MulWideUTest,
                         ::testing::Values(mul_wide_u,
                                           detail::mul_wide_u_fallback,
                                           mul_wide_u_fallback_reversed));
