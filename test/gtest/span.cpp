#include "support/span.h"
#include "gtest/gtest.h"

using namespace wasm;
using namespace wasm::span;

TEST(SpanTest, TestEmpty) {
  // An empty value or span is unknown.
  Value v;
  EXPECT_TRUE(v.isUnknown());
  EXPECT_EQ(v == Value::unknown());

  Span s;
  EXPECT_TRUE(s.isUnknown());
  EXPECT_EQ(v == Span::unknown());
}

TEST(SpanTest, TestIncludes) {
  Value unknown;

  Value lit10(Literal(int32_t(10)));
  Value lit20(Literal(int32_t(20)));
  EXPECT_NE(lit10, lit20);

  // A span of [10, 20] includes the edges.
  Span span10_20(lit10, lit20);
  EXPECT_TRUE(span10_20.includes(lit10));
  EXPECT_TRUE(span10_20.includes(lit20));

  // It includes 15 but not things below or above.
  Value lit5(Literal(int32_t(5)));
  Value lit15(Literal(int32_t(15)));
  Value lit25(Literal(int32_t(25)));
  EXPECT_FALSE(span10_20.includes(lit5));
  EXPECT_TRUE(span10_20.includes(lit15));
  EXPECT_FALSE(span10_20.includes(lit25));
}

