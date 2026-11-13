#include <cmath>
#include <limits>

#include "support/safe_integer.h"
#include "gtest/gtest.h"

TEST(SafeInteger, Unsigned64Boundaries) {
  EXPECT_TRUE(wasm::isUInteger64(std::nextafter(0x1p64, 0.0)));
  EXPECT_FALSE(wasm::isUInteger64(0x1p64));
  EXPECT_FALSE(wasm::isUInteger64(-0.0));
}

TEST(SafeInteger, Signed64Boundaries) {
  EXPECT_FALSE(wasm::isSInteger64(
    std::nextafter(-0x1p63, -std::numeric_limits<double>::infinity())));
  EXPECT_TRUE(wasm::isSInteger64(-0x1p63));
  EXPECT_TRUE(wasm::isSInteger64(std::nextafter(0x1p63, 0.0)));
  EXPECT_FALSE(wasm::isSInteger64(0x1p63));
}
