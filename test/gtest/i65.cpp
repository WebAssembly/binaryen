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
#include <vector>

#include "support/i65.h"
#include "gtest/gtest.h"

using namespace wasm;

TEST(I65Test, DefaultConstruct) {
  I65 x;
  EXPECT_EQ(x.value, 0u);
  EXPECT_FALSE(x.negative);
  EXPECT_EQ(x, I65(0));
}

TEST(I65Test, ConstructFromUnsigned32) {
  uint32_t zero = 0;
  uint32_t one = 1;
  uint32_t mid = 12345678;
  uint32_t maxU32 = std::numeric_limits<uint32_t>::max();

  I65 iZero(zero);
  EXPECT_EQ(iZero.value, 0u);
  EXPECT_FALSE(iZero.negative);

  I65 iOne(one);
  EXPECT_EQ(iOne.value, 1u);
  EXPECT_FALSE(iOne.negative);

  I65 iMid(mid);
  EXPECT_EQ(iMid.value, mid);
  EXPECT_FALSE(iMid.negative);

  I65 iMax(maxU32);
  EXPECT_EQ(iMax.value, uint64_t(maxU32));
  EXPECT_FALSE(iMax.negative);
}

TEST(I65Test, ConstructFromSigned32) {
  int32_t zero = 0;
  int32_t one = 1;
  int32_t maxI32 = std::numeric_limits<int32_t>::max();
  int32_t negOne = -1;
  int32_t negMid = -12345678;
  int32_t minI32 = std::numeric_limits<int32_t>::min();

  I65 iZero(zero);
  EXPECT_EQ(iZero.value, 0u);
  EXPECT_FALSE(iZero.negative);

  I65 iOne(one);
  EXPECT_EQ(iOne.value, 1u);
  EXPECT_FALSE(iOne.negative);

  I65 iMax(maxI32);
  EXPECT_EQ(iMax.value, uint64_t(maxI32));
  EXPECT_FALSE(iMax.negative);

  I65 iNegOne(negOne);
  EXPECT_EQ(iNegOne.value, 1u);
  EXPECT_TRUE(iNegOne.negative);

  I65 iNegMid(negMid);
  EXPECT_EQ(iNegMid.value, 12345678u);
  EXPECT_TRUE(iNegMid.negative);

  I65 iMin(minI32);
  EXPECT_EQ(iMin.value, 2147483648ULL);
  EXPECT_TRUE(iMin.negative);
}

TEST(I65Test, ConstructFromUnsigned64) {
  uint64_t zero = 0;
  uint64_t one = 1;
  uint64_t maxU32 = std::numeric_limits<uint32_t>::max();
  uint64_t maxI64 = std::numeric_limits<int64_t>::max();
  uint64_t highBitOnly = uint64_t(1) << 63;
  uint64_t maxU64 = std::numeric_limits<uint64_t>::max();

  I65 iZero(zero);
  EXPECT_EQ(iZero.value, 0u);
  EXPECT_FALSE(iZero.negative);

  I65 iOne(one);
  EXPECT_EQ(iOne.value, 1u);
  EXPECT_FALSE(iOne.negative);

  I65 iMaxU32(maxU32);
  EXPECT_EQ(iMaxU32.value, maxU32);
  EXPECT_FALSE(iMaxU32.negative);

  I65 iMaxI64(maxI64);
  EXPECT_EQ(iMaxI64.value, maxI64);
  EXPECT_FALSE(iMaxI64.negative);

  I65 iHighBit(highBitOnly);
  EXPECT_EQ(iHighBit.value, highBitOnly);
  EXPECT_FALSE(iHighBit.negative);

  I65 iMaxU64(maxU64);
  EXPECT_EQ(iMaxU64.value, maxU64);
  EXPECT_FALSE(iMaxU64.negative);
}

TEST(I65Test, ConstructFromSigned64) {
  int64_t zero = 0;
  int64_t one = 1;
  int64_t maxI64 = std::numeric_limits<int64_t>::max();
  int64_t negOne = -1;
  int64_t minI64 = std::numeric_limits<int64_t>::min();
  int64_t minI64PlusOne = std::numeric_limits<int64_t>::min() + 1;

  I65 iZero(zero);
  EXPECT_EQ(iZero.value, 0u);
  EXPECT_FALSE(iZero.negative);

  I65 iOne(one);
  EXPECT_EQ(iOne.value, 1u);
  EXPECT_FALSE(iOne.negative);

  I65 iMax(maxI64);
  EXPECT_EQ(iMax.value, uint64_t(maxI64));
  EXPECT_FALSE(iMax.negative);

  I65 iNegOne(negOne);
  EXPECT_EQ(iNegOne.value, 1u);
  EXPECT_TRUE(iNegOne.negative);

  I65 iMin(minI64);
  EXPECT_EQ(iMin.value, uint64_t(1) << 63);
  EXPECT_TRUE(iMin.negative);

  I65 iMinPlusOne(minI64PlusOne);
  EXPECT_EQ(iMinPlusOne.value, uint64_t(std::numeric_limits<int64_t>::max()));
  EXPECT_TRUE(iMinPlusOne.negative);
}

TEST(I65Test, EqualityAndInequality) {
  EXPECT_EQ(I65(int32_t(0)), I65(uint32_t(0)));
  EXPECT_EQ(I65(int32_t(0)), I65(int64_t(0)));
  EXPECT_EQ(I65(int32_t(0)), I65(uint64_t(0)));

  EXPECT_EQ(I65(int32_t(42)), I65(uint32_t(42)));
  EXPECT_EQ(I65(int32_t(42)), I65(int64_t(42)));
  EXPECT_EQ(I65(int32_t(42)), I65(uint64_t(42)));

  EXPECT_EQ(I65(int32_t(-42)), I65(int64_t(-42)));
  EXPECT_EQ(I65(std::numeric_limits<int32_t>::min()),
            I65(int64_t(std::numeric_limits<int32_t>::min())));

  EXPECT_NE(I65(int32_t(1)), I65(int32_t(-1)));
  EXPECT_NE(I65(uint64_t(0xffffffffffffffffULL)), I65(int64_t(-1)));
  EXPECT_NE(I65(std::numeric_limits<int64_t>::min()), I65(uint64_t(1) << 63));
}

TEST(I65Test, TotalOrdering) {
  std::vector<I65> sortedValues = {
    I65(std::numeric_limits<int64_t>::min()),
    I65(std::numeric_limits<int64_t>::min() + 1),
    I65(int64_t(-0x100000000LL)),
    I65(std::numeric_limits<int32_t>::min()),
    I65(int32_t(-12345)),
    I65(int64_t(-2)),
    I65(int64_t(-1)),
    I65(0),
    I65(1),
    I65(2),
    I65(int32_t(12345)),
    I65(std::numeric_limits<int32_t>::max()),
    I65(uint64_t(std::numeric_limits<int32_t>::max()) + 1),
    I65(std::numeric_limits<uint32_t>::max()),
    I65(uint64_t(std::numeric_limits<uint32_t>::max()) + 1),
    I65(std::numeric_limits<int64_t>::max() - 1),
    I65(std::numeric_limits<int64_t>::max()),
    I65(uint64_t(std::numeric_limits<int64_t>::max()) + 1),
    I65(std::numeric_limits<uint64_t>::max() - 1),
    I65(std::numeric_limits<uint64_t>::max()),
  };

  for (size_t i = 0; i < sortedValues.size(); ++i) {
    for (size_t j = 0; j < sortedValues.size(); ++j) {
      const auto& a = sortedValues[i];
      const auto& b = sortedValues[j];

      if (i < j) {
        EXPECT_LT(a, b);
        EXPECT_LE(a, b);
        EXPECT_GT(b, a);
        EXPECT_GE(b, a);
        EXPECT_NE(a, b);
        EXPECT_FALSE(a == b);
        EXPECT_FALSE(b < a);
      } else if (i == j) {
        EXPECT_EQ(a, b);
        EXPECT_LE(a, b);
        EXPECT_GE(a, b);
        EXPECT_FALSE(a < b);
        EXPECT_FALSE(a > b);
        EXPECT_FALSE(a != b);
      } else {
        EXPECT_GT(a, b);
        EXPECT_GE(a, b);
        EXPECT_LT(b, a);
        EXPECT_LE(b, a);
        EXPECT_NE(a, b);
        EXPECT_FALSE(a == b);
        EXPECT_FALSE(a < b);
      }
    }
  }
}

TEST(I65Test, NumericLimits) {
  EXPECT_TRUE(std::numeric_limits<I65>::is_specialized);
  EXPECT_TRUE(std::numeric_limits<I65>::is_signed);
  EXPECT_TRUE(std::numeric_limits<I65>::is_integer);

  EXPECT_EQ(std::numeric_limits<I65>::min(),
            I65(std::numeric_limits<int64_t>::min()));
  EXPECT_EQ(std::numeric_limits<I65>::lowest(),
            I65(std::numeric_limits<int64_t>::min()));
  EXPECT_EQ(std::numeric_limits<I65>::max(),
            I65(std::numeric_limits<uint64_t>::max()));
}

TEST(I65Test, StreamOutput) {
  auto toString = [](const I65& x) {
    std::ostringstream ss;
    ss << x;
    return ss.str();
  };

  EXPECT_EQ(toString(I65(0)), "0");
  EXPECT_EQ(toString(I65(42)), "42");
  EXPECT_EQ(toString(I65(-42)), "-42");
  EXPECT_EQ(toString(I65(std::numeric_limits<int64_t>::min())),
            "-9223372036854775808");
  EXPECT_EQ(toString(I65(std::numeric_limits<uint64_t>::max())),
            "18446744073709551615");
}
