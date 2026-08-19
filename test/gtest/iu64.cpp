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

TEST(IU64Test, DefaultConstruct) {
  IU64 x;
  EXPECT_EQ(x.value, 0u);
  EXPECT_FALSE(x.negative);
  EXPECT_EQ(x, IU64(0));
}

TEST(IU64Test, ConstructFromUnsigned32) {
  uint32_t zero = 0;
  uint32_t one = 1;
  uint32_t mid = 12345678;
  uint32_t maxU32 = std::numeric_limits<uint32_t>::max();

  IU64 iZero(zero);
  EXPECT_EQ(iZero.value, 0u);
  EXPECT_FALSE(iZero.negative);

  IU64 iOne(one);
  EXPECT_EQ(iOne.value, 1u);
  EXPECT_FALSE(iOne.negative);

  IU64 iMid(mid);
  EXPECT_EQ(iMid.value, mid);
  EXPECT_FALSE(iMid.negative);

  IU64 iMax(maxU32);
  EXPECT_EQ(iMax.value, uint64_t(maxU32));
  EXPECT_FALSE(iMax.negative);
}

TEST(IU64Test, ConstructFromSigned32) {
  int32_t zero = 0;
  int32_t one = 1;
  int32_t maxI32 = std::numeric_limits<int32_t>::max();
  int32_t negOne = -1;
  int32_t negMid = -12345678;
  int32_t minI32 = std::numeric_limits<int32_t>::min();

  IU64 iZero(zero);
  EXPECT_EQ(iZero.value, 0u);
  EXPECT_FALSE(iZero.negative);

  IU64 iOne(one);
  EXPECT_EQ(iOne.value, 1u);
  EXPECT_FALSE(iOne.negative);

  IU64 iMax(maxI32);
  EXPECT_EQ(iMax.value, uint64_t(maxI32));
  EXPECT_FALSE(iMax.negative);

  IU64 iNegOne(negOne);
  EXPECT_EQ(iNegOne.value, 1u);
  EXPECT_TRUE(iNegOne.negative);

  IU64 iNegMid(negMid);
  EXPECT_EQ(iNegMid.value, 12345678u);
  EXPECT_TRUE(iNegMid.negative);

  IU64 iMin(minI32);
  EXPECT_EQ(iMin.value, 2147483648ULL);
  EXPECT_TRUE(iMin.negative);
}

TEST(IU64Test, ConstructFromUnsigned64) {
  uint64_t zero = 0;
  uint64_t one = 1;
  uint64_t maxU32 = std::numeric_limits<uint32_t>::max();
  uint64_t maxI64 = std::numeric_limits<int64_t>::max();
  uint64_t highBitOnly = uint64_t(1) << 63;
  uint64_t maxU64 = std::numeric_limits<uint64_t>::max();

  IU64 iZero(zero);
  EXPECT_EQ(iZero.value, 0u);
  EXPECT_FALSE(iZero.negative);

  IU64 iOne(one);
  EXPECT_EQ(iOne.value, 1u);
  EXPECT_FALSE(iOne.negative);

  IU64 iMaxU32(maxU32);
  EXPECT_EQ(iMaxU32.value, maxU32);
  EXPECT_FALSE(iMaxU32.negative);

  IU64 iMaxI64(maxI64);
  EXPECT_EQ(iMaxI64.value, maxI64);
  EXPECT_FALSE(iMaxI64.negative);

  IU64 iHighBit(highBitOnly);
  EXPECT_EQ(iHighBit.value, highBitOnly);
  EXPECT_FALSE(iHighBit.negative);

  IU64 iMaxU64(maxU64);
  EXPECT_EQ(iMaxU64.value, maxU64);
  EXPECT_FALSE(iMaxU64.negative);
}

TEST(IU64Test, ConstructFromSigned64) {
  int64_t zero = 0;
  int64_t one = 1;
  int64_t maxI64 = std::numeric_limits<int64_t>::max();
  int64_t negOne = -1;
  int64_t minI64 = std::numeric_limits<int64_t>::min();
  int64_t minI64PlusOne = std::numeric_limits<int64_t>::min() + 1;

  IU64 iZero(zero);
  EXPECT_EQ(iZero.value, 0u);
  EXPECT_FALSE(iZero.negative);

  IU64 iOne(one);
  EXPECT_EQ(iOne.value, 1u);
  EXPECT_FALSE(iOne.negative);

  IU64 iMax(maxI64);
  EXPECT_EQ(iMax.value, uint64_t(maxI64));
  EXPECT_FALSE(iMax.negative);

  IU64 iNegOne(negOne);
  EXPECT_EQ(iNegOne.value, 1u);
  EXPECT_TRUE(iNegOne.negative);

  IU64 iMin(minI64);
  EXPECT_EQ(iMin.value, uint64_t(1) << 63);
  EXPECT_TRUE(iMin.negative);

  IU64 iMinPlusOne(minI64PlusOne);
  EXPECT_EQ(iMinPlusOne.value, uint64_t(std::numeric_limits<int64_t>::max()));
  EXPECT_TRUE(iMinPlusOne.negative);
}

TEST(IU64Test, EqualityAndInequality) {
  EXPECT_EQ(IU64(int32_t(0)), IU64(uint32_t(0)));
  EXPECT_EQ(IU64(int32_t(0)), IU64(int64_t(0)));
  EXPECT_EQ(IU64(int32_t(0)), IU64(uint64_t(0)));

  EXPECT_EQ(IU64(int32_t(42)), IU64(uint32_t(42)));
  EXPECT_EQ(IU64(int32_t(42)), IU64(int64_t(42)));
  EXPECT_EQ(IU64(int32_t(42)), IU64(uint64_t(42)));

  EXPECT_EQ(IU64(int32_t(-42)), IU64(int64_t(-42)));
  EXPECT_EQ(IU64(std::numeric_limits<int32_t>::min()),
            IU64(int64_t(std::numeric_limits<int32_t>::min())));

  EXPECT_NE(IU64(int32_t(1)), IU64(int32_t(-1)));
  EXPECT_NE(IU64(uint64_t(0xffffffffffffffffULL)), IU64(int64_t(-1)));
  EXPECT_NE(IU64(std::numeric_limits<int64_t>::min()), IU64(uint64_t(1) << 63));
}

TEST(IU64Test, TotalOrdering) {
  std::vector<IU64> sortedValues = {
    IU64(std::numeric_limits<int64_t>::min()),
    IU64(std::numeric_limits<int64_t>::min() + 1),
    IU64(int64_t(-0x100000000LL)),
    IU64(std::numeric_limits<int32_t>::min()),
    IU64(int32_t(-12345)),
    IU64(int64_t(-2)),
    IU64(int64_t(-1)),
    IU64(0),
    IU64(1),
    IU64(2),
    IU64(int32_t(12345)),
    IU64(std::numeric_limits<int32_t>::max()),
    IU64(uint64_t(std::numeric_limits<int32_t>::max()) + 1),
    IU64(std::numeric_limits<uint32_t>::max()),
    IU64(uint64_t(std::numeric_limits<uint32_t>::max()) + 1),
    IU64(std::numeric_limits<int64_t>::max() - 1),
    IU64(std::numeric_limits<int64_t>::max()),
    IU64(uint64_t(std::numeric_limits<int64_t>::max()) + 1),
    IU64(std::numeric_limits<uint64_t>::max() - 1),
    IU64(std::numeric_limits<uint64_t>::max()),
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

TEST(IU64Test, NumericLimits) {
  EXPECT_TRUE(std::numeric_limits<IU64>::is_specialized);
  EXPECT_TRUE(std::numeric_limits<IU64>::is_signed);
  EXPECT_TRUE(std::numeric_limits<IU64>::is_integer);

  EXPECT_EQ(std::numeric_limits<IU64>::min(),
            IU64(std::numeric_limits<int64_t>::min()));
  EXPECT_EQ(std::numeric_limits<IU64>::lowest(),
            IU64(std::numeric_limits<int64_t>::min()));
  EXPECT_EQ(std::numeric_limits<IU64>::max(),
            IU64(std::numeric_limits<uint64_t>::max()));
}

TEST(IU64Test, StreamOutput) {
  auto toString = [](const IU64& x) {
    std::ostringstream ss;
    ss << x;
    return ss.str();
  };

  EXPECT_EQ(toString(IU64(0)), "0");
  EXPECT_EQ(toString(IU64(42)), "42");
  EXPECT_EQ(toString(IU64(-42)), "-42");
  EXPECT_EQ(toString(IU64(std::numeric_limits<int64_t>::min())),
            "-9223372036854775808");
  EXPECT_EQ(toString(IU64(std::numeric_limits<uint64_t>::max())),
            "18446744073709551615");
}
